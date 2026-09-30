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
            PerStratum(N); form = :floor
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

    # A strata × strata × lags coupling carries the intervals itself, lag 1
    # at `[:, :, 1]`, so the kernel is `nothing`.
    window = C.renewal_window(C.ConstantRenewalStep(reverse(g)), g, I₀, r)
    function per_pair(K)
        r = Recurrence(nothing; coupling = Pairwise(pairwise(K)))
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
        depletion = ComposableRecurrences.Depletion(
            PerStratum(N); form = :hazard, seeded = true
        )
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
