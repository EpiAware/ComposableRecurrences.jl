# BVD's zone share renewal: the health zones of each patch renew from their
# own past infections, and each day the patch's infections are split among
# its zones in proportion to that force. The split reads every zone of a
# patch at once, so it is a user modifier on the zones' renewal.
#
# The zones are the strata; time is the grid day `j`, absolute day
# `t0 + j - 1`.

@testitem "Use case: BVD zone share renewal" tags = [:usecase] setup = [UseCaseReferences] begin
    using ComposableRecurrences, ForwardDiff
    B = UseCaseReferences.BVDReference

    g = [0.3, 0.5, 0.2]
    f = [0.2, 0.5, 0.3]
    patch_ranges = [1:3, 4:5]
    patch_of_zone = [1, 1, 1, 2, 2]
    np, nz, n, t0 = 2, 5, 14, 5
    nd = n - t0 + 1
    I_bar = [
        2.0 3.0 4.0 5.0 7.0 9.0 12.0 15.0 18.0 20.0 22.0 21.0 19.0 17.0
        0.0 0.0 1.0 1.0 2.0 2.0 3.0 5.0 6.0 8.0 9.0 11.0 12.0 12.0
    ]
    force_pre = B.zone_fixed_terms(I_bar, g, f, t0).force_pre
    w0 = [0.5, 0.3, 0.2, 0.6, 0.4]
    δ = [0.1 * sin(j + 2z) for j in 1:nd, z in 1:nz]
    # The mixing the province model exports: a within-patch block, a
    # between-patch block, each origin's weight and each patch's imported
    # share.
    within = [
        0.0 0.3 0.2 0.0 0.0
        0.5 0.0 0.8 0.0 0.0
        0.5 0.7 0.0 0.0 0.0
        0.0 0.0 0.0 0.0 1.0
        0.0 0.0 0.0 1.0 0.0
    ]
    between = [
        0.0 0.0 0.0 0.4 0.1
        0.0 0.0 0.0 0.3 0.3
        0.0 0.0 0.0 0.3 0.6
        0.5 0.2 0.1 0.0 0.0
        0.5 0.8 0.9 0.0 0.0
    ]
    mix = (;
        within, between, origin_weight = [1.0, 0.8, 1.2, 0.9, 1.1],
        import_fraction = [fill(0.05, 1, n); fill(0.15, 1, n)],
    )
    ε = [0.1, 0.2, 0.15, 0.05, 0.1]
    Wt = reshape(range(0.5, 2.0; length = nd * nz), nd, nz)
    unpack(θ) = (
        reshape(θ[1:(nd * nz)], nd, nz), θ[(nd * nz + 1):(nd * nz + nz)],
        θ[(end - nz + 1):end],
    )
    θ0 = vcat(vec(δ), w0, ε)
    ref(δ, w0, ε; mixed) = B.zone_share_renewal(
        I_bar, g, δ, w0, patch_ranges, t0, force_pre;
        mix = mixed ? mix : nothing, ε = mixed ? ε : nothing
    ).infections
    ∇ref(mixed) = ForwardDiff.gradient(
        θ -> sum(Wt .* ref(unpack(θ)...; mixed)), θ0
    )

    # Unmixed, each zone takes the share of its patch's infections its own
    # force earns: I_z = Ī_p u_z / Σ_{z' ∈ p} u_{z'}.
    struct Allocate{I, P}
        I_bar::I
        patch_ranges::P
        t0::Int
    end
    function ComposableRecurrences.forward(
            m::Allocate, ::ComposableRecurrences.Step, v, s, t
        )
        floor_ = eps(eltype(v))
        for (p, zs) in enumerate(m.patch_ranges)
            tot = max(sum(view(v, zs)), floor_)
            v[zs] .= m.I_bar[p, m.t0 + t - 1] .* view(v, zs) ./ tot
        end
        return nothing
    end

    # Mixed, a share `ε_q` of zone q's force spills within its patch, the
    # patch's imported share lands in the pattern the other patches' zones
    # send, and the rest is split by the spilled force. The between pattern
    # reads the force before the spill, so both live in one modifier.
    struct AllocateMixed{I, P, M, E}
        I_bar::I
        patch_ranges::P
        t0::Int
        mix::M
        ε::E
    end
    function ComposableRecurrences.forward(
            m::AllocateMixed, ::ComposableRecurrences.Step, v, s, t
        )
        floor_ = eps(eltype(v))
        day = m.t0 + t - 1
        u = copy(v)
        V = (1 .- m.ε) .* u .+ m.mix.within * (m.ε .* u)
        h = m.mix.between * (m.mix.origin_weight .* u)
        for (p, zs) in enumerate(m.patch_ranges)
            Ip = m.I_bar[p, day]
            Mp = m.mix.import_fraction[p, day] * Ip
            sv = max(sum(view(V, zs)), floor_)
            sh = sum(view(h, zs))
            share = sh > floor_ ? view(h, zs) ./ sh : view(V, zs) ./ sv
            v[zs] .= (Ip - Mp) / sv .* view(V, zs) .+ Mp .* share
        end
        return nothing
    end

    # u_z = e^{δ_z} (Σ_s g_s I_z(t - s) + w0_z Λ^pre_p(t)): the deviation is
    # the gain and the pre-grid force enters through `add`, scaled by it.
    function zones(δ, w0, ε; mixed)
        gain = exp.(permutedims(δ))
        add = gain .* w0 .* force_pre[patch_of_zone, t0:n]
        split = mixed ? AllocateMixed(I_bar, patch_ranges, t0, mix, ε) :
            Allocate(I_bar, patch_ranges, t0)
        r = Recurrence(g; modifiers = (split,))
        return permutedims(r(gain; history = zeros(nz, 1), add))
    end
    for mixed in (false, true)
        @test zones(δ, w0, ε; mixed) ≈ ref(δ, w0, ε; mixed)
        @test ForwardDiff.gradient(
            θ -> sum(Wt .* zones(unpack(θ)...; mixed)), θ0
        ) ≈ ∇ref(mixed)
    end
    # The zones of each patch sum to the patch's infections.
    I = zones(δ, w0, ε; mixed = true)
    @test [sum(I[j, zs]) for j in 1:nd, zs in patch_ranges] ≈
        permutedims(I_bar[:, t0:n])
end
