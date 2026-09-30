# Single-series renewal processes: CTIDM's renewal step with susceptible
# depletion and imported cases, and BVD's `renewal_infections` with hazard
# depletion from a seed.
#
# The generation interval, reversed so the oldest lag comes first as in
# CTIDM's `rev_gen_int`, is the kernel and R_t is the gain.

@testitem "Use case: renewal" tags = [:usecase] setup = [UseCaseReferences] begin
    using ComposableRecurrences, ForwardDiff
    C = UseCaseReferences.CTIDMReference

    g = [0.2, 0.5, 0.3]
    I₀, r = 5.0, 0.1
    Rt = [1.4, 1.3, 1.5, 1.2, 1.1, 1.0, 0.9, 1.2, 1.3, 1.1]
    step = C.ConstantRenewalStep(reverse(g))
    ref = C.renewal(step, g, I₀, r, Rt)
    w = range(0.5, 2.0; length = length(ref))
    θ0 = vcat(g, I₀, Rt)
    unpack(θ) = (θ[1:3], θ[4], θ[5:end])
    function ref_loss(θ)
        g, I₀, Rt = unpack(θ)
        return sum(w .* C.renewal(C.ConstantRenewalStep(reverse(g)), g, I₀, r, Rt))
    end
    ∇ref = ForwardDiff.gradient(ref_loss, θ0)

    # I_t = R_t Σ_i g_i I_{t-i}, from CTIDM's exponentially seeded window.
    function renewal(g, I₀, Rt)
        window = C.renewal_window(C.ConstantRenewalStep(reverse(g)), g, I₀, r)
        return Recurrence(reverse(g))(Rt; history = window)
    end
    @test renewal(g, I₀, Rt) ≈ ref
    @test ForwardDiff.gradient(θ -> sum(w .* renewal(unpack(θ)...)), θ0) ≈ ∇ref
end

@testitem "Use case: renewal with susceptible depletion" tags = [:usecase] setup = [UseCaseReferences] begin
    using ComposableRecurrences, ForwardDiff
    C = UseCaseReferences.CTIDMReference

    g = [0.2, 0.5, 0.3]
    I₀, r, N = 5.0, 0.1, 400.0
    Rt = [2.4, 2.3, 2.5, 2.2, 2.1, 2.0, 1.9, 2.2, 2.3, 2.1]
    window = C.renewal_window(C.ConstantRenewalStep(reverse(g)), g, I₀, r)
    ref_step(N) = C.RenewalStep(
        C.ConstantRenewalStep(reverse(g)), (C.SusceptibleDepletion(N),)
    )
    ref = C.renewal(ref_step(N), g, I₀, r, Rt)
    w = range(0.5, 2.0; length = length(ref))
    θ0 = vcat(N, Rt)
    ∇ref = ForwardDiff.gradient(
        θ -> sum(w .* C.renewal(ref_step(θ[1]), g, I₀, r, θ[2:end])), θ0
    )

    # CTIDM's floored depletion, `max(S / N, 1e-6)`, as a modifier on each
    # step's new infections.
    function renewal(N, Rt)
        depletion = ComposableRecurrences.Depletion(N; form = :floor)
        r = Recurrence(reverse(g); modifiers = (depletion,))
        return r(Rt; history = window)
    end
    @test renewal(N, Rt) ≈ ref
    # The floor binds once the pool is exhausted.
    @test renewal(50.0, Rt) ≈ C.renewal(ref_step(50.0), g, I₀, r, Rt)
    ∇ = ForwardDiff.gradient(θ -> sum(w .* renewal(θ[1], θ[2:end])), θ0)
    @test ∇ ≈ ∇ref
end

@testitem "Use case: renewal with imported cases" tags = [:usecase] setup = [UseCaseReferences] begin
    using ComposableRecurrences, ForwardDiff
    C = UseCaseReferences.CTIDMReference

    g = [0.2, 0.5, 0.3]
    I₀, r, N = 1.0, 0.0, 300.0
    Rt = [0.8, 0.9, 1.2, 1.5, 1.8, 2.0, 1.6, 1.2, 1.0, 0.9]
    ι = [0.5, 0.5, 1.0, 2.0, 1.5, 0.5, 0.2, 0.1, 0.0, 0.0]
    window = C.renewal_window(C.ConstantRenewalStep(reverse(g)), g, I₀, r)
    core = C.ConstantRenewalStep(reverse(g))
    ref_alone(ι, N) = C.renewal(
        C.RenewalStep(core, (C.ImportedRate(ι),)), g, I₀, r, Rt
    )
    ref_before(ι, N) = C.renewal(
        C.RenewalStep(core, (C.ImportedRate(ι), C.SusceptibleDepletion(N))),
        g, I₀, r, Rt
    )
    w = range(0.5, 2.0; length = length(Rt))
    θ0 = vcat(ι, N)
    loss(f) = θ -> sum(w .* f(θ[1:10], θ[11]))
    ∇ref_alone = ForwardDiff.gradient(loss(ref_alone), θ0)
    ∇ref_before = ForwardDiff.gradient(loss(ref_before), θ0)

    # Imports join the new infections before any modifier, so they are
    # `add`. With depletion after them they are depleted with the rest,
    # CTIDM's `(ImportedCases, SusceptibleDepletion)` order.
    alone(ι, N) = Recurrence(reverse(g))(Rt; history = window, add = ι)
    function before(ι, N)
        depletion = ComposableRecurrences.Depletion(N; form = :floor)
        r = Recurrence(reverse(g); modifiers = (depletion,))
        return r(Rt; history = window, add = ι)
    end
    @test alone(ι, N) ≈ ref_alone(ι, N)
    @test before(ι, N) ≈ ref_before(ι, N)
    @test ForwardDiff.gradient(loss(alone), θ0) ≈ ∇ref_alone
    @test ForwardDiff.gradient(loss(before), θ0) ≈ ∇ref_before
end

@testitem "Use case: imports added after depletion (user modifier)" tags = [:usecase] setup = [UseCaseReferences] begin
    using ComposableRecurrences, ForwardDiff
    C = UseCaseReferences.CTIDMReference

    g = [0.2, 0.5, 0.3]
    I₀, r, N = 1.0, 0.0, 300.0
    Rt = [0.8, 0.9, 1.2, 1.5, 1.8, 2.0, 1.6, 1.2, 1.0, 0.9]
    ι = [0.5, 0.5, 1.0, 2.0, 1.5, 0.5, 0.2, 0.1, 0.0, 0.0]
    window = C.renewal_window(C.ConstantRenewalStep(reverse(g)), g, I₀, r)
    core = C.ConstantRenewalStep(reverse(g))
    ref_after(ι, N) = C.renewal(
        C.RenewalStep(core, (C.SusceptibleDepletion(N), C.ImportedRate(ι))),
        g, I₀, r, Rt
    )
    w = range(0.5, 2.0; length = length(Rt))
    θ0 = vcat(ι, N)
    ∇ref = ForwardDiff.gradient(θ -> sum(w .* ref_after(θ[1:10], θ[11])), θ0)

    # CTIDM's `(SusceptibleDepletion, ImportedCases)` order adds imports to
    # the depleted infections, which `add` cannot express. A user modifier
    # through the public interface does: it adds `rate[t]` and keeps no state,
    # so it takes the default `init_state`.
    struct AddImports{R}
        rate::R
    end
    function ComposableRecurrences.apply!(m::AddImports, v, s, t)
        v .+= m.rate[t]
        return nothing
    end

    function after(ι, N)
        depletion = ComposableRecurrences.Depletion(N; form = :floor)
        r = Recurrence(reverse(g); modifiers = (depletion, AddImports(ι)))
        return r(Rt; history = window)
    end
    @test after(ι, N) ≈ ref_after(ι, N)
    @test ForwardDiff.gradient(θ -> sum(w .* after(θ[1:10], θ[11])), θ0) ≈ ∇ref
end

@testitem "Use case: BVD renewal_infections" tags = [:usecase] setup = [UseCaseReferences] begin
    using ComposableRecurrences, ForwardDiff
    B = UseCaseReferences.BVDReference

    N = 500.0
    Rt = [0.0, 0.0, 0.0, 2.5, 2.4, 2.2, 2.0, 1.8, 1.5, 1.2, 1.0, 0.9]
    n = length(Rt)
    w = range(0.5, 2.0; length = n)

    # I_t = S_{t-1} (1 − exp(−R_t Σ_i g_i I_{t-i} / N)) after the seed days,
    # with the pool starting at N − Σ seed. The seed is the history and is
    # returned first; the recurrence starts on the day after it.
    function bvd_renewal(Rt, g, seed, N)
        L = length(seed)
        depletion = ComposableRecurrences.Depletion(
            N; form = :hazard, seeded = true
        )
        # A seed shorter than the generation interval is zero-padded: BVD
        # truncates the early windows, which is the same sum.
        history = vcat(zeros(eltype(seed), length(g) - L), seed)
        r = Recurrence(reverse(g); modifiers = (depletion,))
        return vcat(seed, r(Rt[(L + 1):end]; history))
    end

    # Seed as long as the generation interval, then shorter.
    cases = (
        ([0.3, 0.5, 0.2], [2.0, 3.0, 4.0]),
        ([0.1, 0.4, 0.3, 0.2], [2.0, 3.0, 4.0]),
    )
    for (g, seed) in cases
        G, L = length(g), length(seed)
        unpack(θ) = (
            θ[1:n], θ[(n + 1):(n + G)], θ[(n + G + 1):(n + G + L)], θ[end],
        )
        θ0 = vcat(Rt, g, seed, N)
        ref = B.renewal_infections(Rt, g, seed, N)
        ∇ref = ForwardDiff.gradient(
            θ -> sum(w .* B.renewal_infections(unpack(θ)...)), θ0
        )
        @test bvd_renewal(Rt, g, seed, N) ≈ ref
        ∇ = ForwardDiff.gradient(θ -> sum(w .* bvd_renewal(unpack(θ)...)), θ0)
        @test ∇ ≈ ∇ref
    end
end
