# Stratified renewal processes: CTIDM's mixing matrix, gravity coupling,
# per-stratum and per-pair generation intervals, and BVD's patch model with
# importation and hazard depletion.
#
# Arrays are strata × time; the history is strata × time, oldest first.

@testitem "Use case: strata with a mixing matrix" tags = [:usecase] setup = [UseCaseReferences] begin
    using ComposableRecurrences, ForwardDiff
    C = UseCaseReferences.CTIDMReference

    g = [0.2, 0.5, 0.3]
    I₀, r = [5.0, 2.0, 1.0], 0.1
    K = [0.8 0.15 0.05; 0.1 0.7 0.2; 0.05 0.25 0.7]
    Rt = [
        1.2 1.3 1.1 1.0 0.9 1.1 1.2 1.0
        1.5 1.4 1.3 1.2 1.1 1.0 0.9 0.8
        0.9 1.0 1.1 1.2 1.3 1.4 1.3 1.2
    ]
    S, T = size(Rt)
    ref_renewal(K, Rt) = C.renewal(C.ConstantRenewalStep(reverse(g), K), g, I₀, r, Rt)
    ref = ref_renewal(K, Rt)
    w = reshape(range(0.5, 2.0; length = S * T), S, T)
    unpack(θ) = (reshape(θ[1:9], 3, 3), reshape(θ[10:end], S, T))
    θ0 = vcat(vec(K), vec(Rt))
    ∇ref = ForwardDiff.gradient(θ -> sum(w .* ref_renewal(unpack(θ)...)), θ0)

    # I_{g,t} = R_{g,t} Σ_h K_{gh} Σ_i g_i I_{h,t-i}: K couples the strata
    # after the generation-interval convolution.
    window = C.renewal_window(C.ConstantRenewalStep(reverse(g), K), g, I₀, r)
    function mixed(K, Rt)
        return Recurrence(g; coupling = K)(Rt; history = window)
    end
    @test mixed(K, Rt) ≈ ref
    @test ForwardDiff.gradient(θ -> sum(w .* mixed(unpack(θ)...)), θ0) ≈ ∇ref
end

@testitem "Use case: gravity coupling with depletion" tags = [:usecase] setup = [UseCaseReferences] begin
    using ComposableRecurrences, ForwardDiff
    C = UseCaseReferences.CTIDMReference

    g = [0.2, 0.5, 0.3]
    I₀, r = [5.0, 2.0, 1.0], 0.1
    pop = [1.0e5, 3.0e4, 6.0e4]
    N = [400.0, 150.0, 250.0]
    dist = [0.0 40.0 70.0; 40.0 0.0 50.0; 70.0 50.0 0.0]
    Rt = fill(2.0, 3, 8)
    w = reshape(range(0.5, 2.0; length = length(Rt)), size(Rt))
    gravity(θ) = C.gravity(pop, dist; α = θ[1], β = θ[2], γ = θ[3])
    function ref_renewal(θ)
        step = C.RenewalStep(
            C.ConstantRenewalStep(reverse(g), gravity(θ)),
            (C.SusceptibleDepletion(N),)
        )
        return C.renewal(step, g, I₀, r, Rt)
    end
    θ0 = [0.5, 1.0, 2.0]
    ref = ref_renewal(θ0)
    ∇ref = ForwardDiff.gradient(θ -> sum(w .* ref_renewal(θ)), θ0)

    # The gravity K is built by the caller and is differentiable through the
    # coupling slot; depletion takes one population per stratum.
    window = C.renewal_window(C.ConstantRenewalStep(reverse(g)), g, I₀, r)
    function coupled(θ)
        depletion = ComposableRecurrences.Depletion(
            PerStratum(N), ComposableRecurrences.Floor()
        )
        r = Recurrence(g; coupling = gravity(θ), modifiers = (depletion,))
        return r(Rt; history = window)
    end
    @test coupled(θ0) ≈ ref
    @test ForwardDiff.gradient(θ -> sum(w .* coupled(θ)), θ0) ≈ ∇ref
end

@testitem "Use case: per-stratum generation intervals" tags = [:usecase] setup = [UseCaseReferences] begin
    using ComposableRecurrences, ForwardDiff
    C = UseCaseReferences.CTIDMReference

    G = [0.2 0.5 0.3; 0.5 0.3 0.2; 0.1 0.3 0.6]
    I₀, r = [5.0, 2.0, 1.0], 0.1
    K = [0.8 0.15 0.05; 0.1 0.7 0.2; 0.05 0.25 0.7]
    Rt = fill(1.2, 3, 8)
    w = reshape(range(0.5, 2.0; length = length(Rt)), size(Rt))
    step(G) = C.ConstantRenewalStep(reverse(G; dims = 2), K)
    ref_renewal(G) = C.renewal(step(G), G, I₀, r, Rt)
    ref = ref_renewal(G)
    ∇ref = ForwardDiff.gradient(
        θ -> sum(w .* ref_renewal(reshape(θ, 3, 3))), vec(G)
    )

    # `PerStratum` takes a strata × lags kernel, one row per stratum.
    window = C.renewal_window(step(G), G, I₀, r)
    function per_stratum(G)
        r = Recurrence(PerStratum(G); coupling = K)
        return r(Rt; history = window)
    end
    @test per_stratum(G) ≈ ref
    @test ForwardDiff.gradient(
        θ -> sum(w .* per_stratum(reshape(θ, 3, 3))), vec(G)
    ) ≈ ∇ref
end

@testitem "Use case: per-pair generation intervals" tags = [:usecase] setup = [UseCaseReferences] begin
    using ComposableRecurrences, ForwardDiff
    C = UseCaseReferences.CTIDMReference

    g = [0.2, 0.5, 0.3]
    I₀, r = [5.0, 2.0, 1.0], 0.1
    K = [0.8 0.15 0.05; 0.1 0.7 0.2; 0.05 0.25 0.7]
    # Between-stratum transmission takes longer than within.
    within, between = [0.5, 0.3, 0.2], [0.1, 0.3, 0.6]
    Gpair = [
        i == j ? within[l] : between[l] for i in 1:3, j in 1:3, l in 1:3
    ]
    Rt = fill(1.2, 3, 8)
    w = reshape(range(0.5, 2.0; length = length(Rt)), size(Rt))
    pairwise(K) = C.pairwise_gen_int(K, Gpair)
    function ref_renewal(K)
        step = C.ConstantRenewalStep(reverse(g), pairwise(K))
        return C.renewal(step, g, I₀, r, Rt)
    end
    ref = ref_renewal(K)
    ∇ref = ForwardDiff.gradient(
        θ -> sum(w .* ref_renewal(reshape(θ, 3, 3))), vec(K)
    )

    # A strata × strata × lags kernel carries the intervals and the mixing,
    # lag 1 at `[:, :, 1]`, so the coupling stays `I`.
    window = C.renewal_window(C.ConstantRenewalStep(reverse(g)), g, I₀, r)
    function per_pair(K)
        r = Recurrence(Pairwise(pairwise(K)))
        return r(Rt; history = window)
    end
    @test per_pair(K) ≈ ref
    @test ForwardDiff.gradient(θ -> sum(w .* per_pair(reshape(θ, 3, 3))), vec(K)) ≈
        ∇ref
end

@testitem "Use case: time-varying mixing" tags = [:usecase] setup = [UseCaseReferences] begin
    using ComposableRecurrences, ForwardDiff
    C = UseCaseReferences.CTIDMReference

    g = [0.2, 0.5, 0.3]
    I₀, r = [5.0, 2.0, 1.0], 0.1
    T = 8
    K0 = [0.8 0.15 0.05; 0.1 0.7 0.2; 0.05 0.25 0.7]
    # Mixing relaxes towards within-stratum contact over time.
    Id = [1.0 0 0; 0 1 0; 0 0 1]
    Ks = cat(
        [(1 - s) .* K0 .+ s .* Id for s in range(0, 0.8; length = T)]...;
        dims = 3
    )
    Rt = fill(1.2, 3, T)
    w = reshape(range(0.5, 2.0; length = length(Rt)), size(Rt))
    window = C.renewal_window(C.ConstantRenewalStep(reverse(g)), g, I₀, r)
    ref_renewal(Ks) = C.time_varying_mixing_renewal(reverse(g), Ks, window, Rt)
    ref = ref_renewal(Ks)
    ∇ref = ForwardDiff.gradient(
        θ -> sum(w .* ref_renewal(reshape(θ, 3, 3, T))), vec(Ks)
    )

    # `TimeVarying` coupling is strata × strata × time.
    function tv(Ks)
        r = Recurrence(g; coupling = TimeVarying(Ks))
        return r(Rt; history = window)
    end
    @test tv(Ks) ≈ ref
    @test ForwardDiff.gradient(θ -> sum(w .* tv(reshape(θ, 3, 3, T))), vec(Ks)) ≈
        ∇ref
end

@testitem "Use case: BVD patch model" tags = [:usecase] setup = [UseCaseReferences] begin
    using ComposableRecurrences, ForwardDiff, LinearAlgebra
    B = UseCaseReferences.BVDReference

    g = [0.3, 0.5, 0.2]
    np, n, L = 3, 10, 3
    Rt = [fill(0.0, np, L) [
        2.0 1.9 1.8 1.7 1.6 1.5 1.4
        1.2 1.3 1.4 1.5 1.6 1.5 1.4
        0.8 0.9 1.0 1.1 1.2 1.3 1.2
    ]]
    seeds = [1.0 2.0 3.0; 0.5 1.0 1.0; 0.0 0.0 1.0]
    K = [0.0 0.2 0.1; 0.3 0.0 0.2; 0.1 0.4 0.0]
    ε = [0.05 .+ 0.01 .* (1:n)'; fill(0.1, 1, n); fill(0.02, 1, n)]
    N = [300.0, 200.0, 150.0]
    w = reshape(range(0.5, 2.0; length = np * n), np, n)
    unpack(θ) = (
        reshape(θ[1:9], 3, 3), reshape(θ[10:(9 + np * n)], np, n),
        θ[(end - 2):end],
    )
    θ0 = vcat(vec(K), vec(ε), N)
    ref = B.patch_infections(Rt, g, seeds, K, ε, N).infections
    function ref_loss(θ)
        K, ε, N = unpack(θ)
        return sum(w .* B.patch_infections(Rt, g, seeds, K, ε, N).infections)
    end
    ∇ref = ForwardDiff.gradient(ref_loss, θ0)

    # Each patch generates R_{p,t} Σ_i g_i I_{p,t-i}; a share ε_{q,t} K_{pq}
    # of what origin q generates is realised in p instead (Redistribute),
    # then each patch depletes its own pool from N_p − Σ seed (hazard form).
    # The seeds are the history and are returned first; the first output is
    # day `L + 1`, which reads R_t and ε at that day.
    function patch(K, ε, N)
        importation = ComposableRecurrences.Redistribute(K, ε)
        pool0 = PerStratum(max.(N .- vec(sum(seeds; dims = 2)), 0))
        depletion = ComposableRecurrences.Depletion(PerStratum(N); pool0)
        r = Recurrence(g; modifiers = (importation, depletion))
        return ComposableRecurrences.seeded(r, Rt; history = seeds)
    end
    @test patch(K, TimeVarying(PerStratum(ε)), N) ≈ ref
    function loss(θ)
        K, ε, N = unpack(θ)
        return sum(w .* patch(K, TimeVarying(PerStratum(ε)), N))
    end
    @test ForwardDiff.gradient(loss, θ0) ≈ ∇ref

    # One importation intensity shared by every origin and day.
    @test patch(K, 0.05, N) ≈
        B.patch_infections(Rt, g, seeds, K, 0.05, N).infections
    # One intensity per origin, the same every day.
    εq = [0.05, 0.1, 0.02]
    @test patch(K, PerStratum(εq), N) ≈
        B.patch_infections(Rt, g, seeds, K, repeat(εq, 1, n), N).infections

    # BVD also returns the importation series, the arrivals in each patch.
    # It is recomputed from the infections: each patch's force is its lag
    # 1..L convolution with g (a lag-0 weight of zero shifts the kernel by a
    # day), what it generates is R_t times that, and the arrivals are the
    # off-diagonal K applied to each origin's ε-weighted generation. The
    # seed days have no arrivals.
    function patch_importation(K, ε, N)
        I = patch(K, TimeVarying(PerStratum(ε)), N)
        gen = Rt .* Convolution(vcat(0.0, g))(I)
        arrivals = (K - Diagonal(diag(K))) * (ε .* gen)
        arrivals[:, 1:L] .= 0
        return arrivals
    end
    @test patch_importation(K, ε, N) ≈
        B.patch_infections(Rt, g, seeds, K, ε, N).importation
end

@testitem "Use case: stratified renewal with imports, depletion and mixing" tags = [:usecase] setup = [UseCaseReferences] begin
    using ComposableRecurrences, ForwardDiff
    C = UseCaseReferences.CTIDMReference

    g = [0.2, 0.5, 0.3]
    I₀, r = [2.0, 1.0, 0.5], 0.0
    K = [0.8 0.15 0.05; 0.1 0.7 0.2; 0.05 0.25 0.7]
    N = [200.0, 120.0, 90.0]
    Rt = fill(2.2, 3, 8)
    # One exogenous importation stream per stratum, `strata × time`.
    ι = [
        0.5 0.5 1.0 2.0 1.5 0.5 0.2 0.1
        0.0 0.2 0.4 0.4 0.2 0.1 0.0 0.0
        1.0 0.8 0.6 0.4 0.2 0.1 0.1 0.0
    ]
    S, T = size(Rt)
    w = reshape(range(0.5, 2.0; length = S * T), S, T)
    core(K) = C.ConstantRenewalStep(reverse(g), K)
    ref_after(K, N, ι) = C.renewal(
        C.RenewalStep(core(K), (C.SusceptibleDepletion(N), C.ImportedRate(ι))),
        g, I₀, r, Rt
    )
    ref_before(K, N, ι) = C.renewal(
        C.RenewalStep(core(K), (C.ImportedRate(ι), C.SusceptibleDepletion(N))),
        g, I₀, r, Rt
    )
    unpack(θ) = (reshape(θ[1:9], 3, 3), θ[10:12], reshape(θ[13:end], S, T))
    θ0 = vcat(vec(K), N, vec(ι))
    loss(f) = θ -> sum(w .* f(unpack(θ)...))
    ∇ref_after = ForwardDiff.gradient(loss(ref_after), θ0)
    ∇ref_before = ForwardDiff.gradient(loss(ref_before), θ0)

    # The mixing is the coupling, the pool is per stratum, and the imports
    # are per stratum and day: `Add` after the depletion, or `add` before it.
    window = C.renewal_window(core(K), g, I₀, r)
    function after(K, N, ι)
        depletion = ComposableRecurrences.Depletion(
            PerStratum(N), ComposableRecurrences.Floor()
        )
        imports = ComposableRecurrences.Add(TimeVarying(PerStratum(ι)))
        renewal = Recurrence(g; coupling = K, modifiers = (depletion, imports))
        return renewal(Rt; history = window)
    end
    function before(K, N, ι)
        depletion = ComposableRecurrences.Depletion(
            PerStratum(N), ComposableRecurrences.Floor()
        )
        renewal = Recurrence(g; coupling = K, modifiers = (depletion,))
        return renewal(Rt; history = window, add = ι)
    end
    @test after(K, N, ι) ≈ ref_after(K, N, ι)
    @test before(K, N, ι) ≈ ref_before(K, N, ι)
    @test ForwardDiff.gradient(loss(after), θ0) ≈ ∇ref_after
    @test ForwardDiff.gradient(loss(before), θ0) ≈ ∇ref_before
end

@testitem "Use case: BVD deviation knots (stratified AR(1))" tags = [:usecase] setup = [UseCaseReferences] begin
    using ComposableRecurrences, ForwardDiff
    B = UseCaseReferences.BVDReference

    # Two groups of units; unit 3 holds a level only and does not walk.
    groups = [1:3, 4:5]
    walking = [true, true, false, true, true]
    walk_index = [1, 2, 0, 3, 4]
    n_walking, n_knots = 4, 6
    factors = [[1.0 0.0 0.0; 0.4 0.9 0.0; 0.2 0.3 0.9], nothing]
    drift_factors = [[1.0 0.0; 0.5 0.8], nothing]
    z_level = [0.3, -0.5, 0.8, 1.1, -0.2]
    z_drift = [0.1 * sin(i) for i in 1:(n_walking * (n_knots - 1))]
    σ_level, φ = 0.4, 0.7
    σ_δ = [0.2, 0.3, 0.25, 0.1, 0.15]
    nz, nd = length(z_level), length(z_drift)
    unpack(θ) = (
        θ[1:nz], θ[(nz + 1):(nz + nd)], θ[nz + nd + 1],
        θ[(nz + nd + 2):(2nz + nd + 1)], θ[end],
    )
    θ0 = vcat(z_level, z_drift, σ_level, σ_δ, φ)
    ref(z_level, z_drift, σ_level, σ_δ, φ) = B.deviation_knots(
        z_level, z_drift, σ_level, σ_δ, φ, groups, factors, drift_factors,
        walking, walk_index, n_walking, n_knots
    )
    W = reshape(range(0.5, 2.0; length = nz * n_knots), nz, n_knots)
    ∇ref = ForwardDiff.gradient(θ -> sum(W .* ref(unpack(θ)...)), θ0)

    # The level and each knot's innovation are group-centred linear maps of
    # the draws; they do not read δ, so they are built before the call.
    correlate(F, z) = F === nothing ? z : F * z
    centre(x) = x .- sum(x) / length(x)
    function level(z_level, σ_level)
        return reduce(
            vcat,
            [centre(σ_level .* correlate(F, z_level[us])) for (us, F) in zip(groups, factors)]
        )
    end
    function innovations(z_drift, σ_δ)
        Tp = promote_type(eltype(z_drift), eltype(σ_δ))
        c = zeros(Tp, nz, n_knots - 1)
        for k in 2:n_knots, (us, F) in zip(groups, drift_factors)
            ws = filter(u -> walking[u], us)
            z = z_drift[(k - 2) * n_walking .+ walk_index[ws]]
            c[ws, k - 1] = centre(σ_δ[ws] .* correlate(F, z))
        end
        return c
    end
    # δ(k) = φ δ(k - 1) + c_k per unit: one AR(1) kernel shared by the
    # strata, the level as history and the innovations as `add`.
    function knots(z_level, z_drift, σ_level, σ_δ, φ)
        δ1 = level(z_level, σ_level)
        ar = Recurrence([φ])
        return hcat(δ1, ar(1.0; history = reshape(δ1, :, 1), add = innovations(z_drift, σ_δ)))
    end
    @test knots(unpack(θ0)...) ≈ ref(unpack(θ0)...)
    @test ForwardDiff.gradient(θ -> sum(W .* knots(unpack(θ)...)), θ0) ≈ ∇ref

    # `patch_rt_model` carries the same AR(1) past the cut-off on fresh
    # innovations. Resuming from the fitted knots' state is the one run.
    function forecast(z_level, z_drift, σ_level, σ_δ, φ)
        δ1 = level(z_level, σ_level)
        c = innovations(z_drift, σ_δ)
        ar = Recurrence([φ])
        fitted, state = ComposableRecurrences.with_state(
            ar, 1.0; history = reshape(δ1, :, 1), add = c, stop = 3
        )
        return hcat(δ1, fitted, ar(1.0; state, add = c))
    end
    @test forecast(unpack(θ0)...) ≈ ref(unpack(θ0)...)
    @test ForwardDiff.gradient(θ -> sum(W .* forecast(unpack(θ)...)), θ0) ≈ ∇ref
end
