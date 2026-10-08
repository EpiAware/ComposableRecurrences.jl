# Transmission routes in expectation, as EpiBranch.jl's `RouteWindow` splits
# them: each route opens at a state, closes at its `until` states and
# reaches its own contacts. Its kernel is the opening delay convolved with
# the contact kernel, thinned by the survival of its `until` events, and its
# coupling is the contacts it reaches.
#
# Three places. Community transmission runs from infection until isolation
# and reaches every place through a gravity matrix. Household transmission
# runs from onset, is not cut by isolation and stays within the place.
# Funeral transmission opens at death and reaches the place and its
# neighbours, a sparse matrix. Susceptibles deplete in each place.

@testitem "Use case: community, household and funeral routes" tags = [:usecase] begin
    using ComposableRecurrences, ForwardDiff, LinearAlgebra, SparseArrays
    CR = ComposableRecurrences

    S, T = 3, 40
    contact = [0.1, 0.25, 0.25, 0.2, 0.1, 0.05, 0.05]
    isolated = [0.0, 0.1, 0.3, 0.5, 0.7, 0.8, 0.9]  # P(isolated by lag τ)
    onset = [0.0, 0.3, 0.5, 0.2]                    # infection to onset, lag 0 first
    death = [0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.2, 0.3, 0.2, 0.1, 0.1]
    days = [0.6, 0.4]                               # funeral contact days
    cfr = 0.4
    pad(x, n) = vcat(x, zeros(n - length(x)))
    # Lag 1 first, from lag 0 first convolutions.
    lag1(x) = x[2:end]
    community = contact .* (1 .- isolated)
    household = 0.5 .* lag1(Convolution(onset)(pad([0.0; contact], 11)))
    funeral = cfr .* lag1(Convolution(days)(pad(death, 12)))
    pop = [8_000.0, 5_000.0, 3_000.0]
    dist = [0.0 10.0 30.0; 10.0 0.0 15.0; 30.0 15.0 0.0]
    gravity = [a == b ? 0.0 : pop[b] / dist[a, b]^2 for a in 1:S, b in 1:S]
    K_community = 0.9 * I(S) + 0.1 * gravity ./ sum(gravity; dims = 2)
    K_funeral = sparse([0.8 0.2 0.0; 0.1 0.8 0.1; 0.0 0.2 0.8])
    seed = [fill(2.0, 1, 12); zeros(2, 12)]
    R = [1.1 + 0.2 * sin(t / 6) for t in 1:T]

    function model(β)
        routes = Routes(
            (β[1] .* K_community, community), (β[2] * I, household),
            (β[3] .* K_funeral, funeral)
        )
        depletion = CR.Depletion(PerStratum(pop), CR.Floor())
        return Recurrence(routes; modifiers = (depletion,))
    end
    run(β) = model(β)(R; history = seed)

    # The routes written out, with floored depletion.
    function naive(β)
        Tp = eltype(β)
        y = zeros(Tp, S, size(seed, 2) + T)
        y[:, 1:size(seed, 2)] .= seed
        s = Tp.(pop)
        m = size(seed, 2)
        Ks = (β[1] .* K_community, β[2] * Matrix(I(S)), β[3] .* Matrix(K_funeral))
        gs = (community, household, funeral)
        for t in 1:T
            v = zeros(Tp, S)
            for (K, g) in zip(Ks, gs), l in eachindex(g)
                v .+= g[l] .* (K * y[:, m + t - l])
            end
            v .*= R[t]
            v′ = max.(s ./ pop, 1.0e-6) .* v
            s .-= v′
            y[:, m + t] .= v′
        end
        return y[:, (m + 1):end]
    end

    β = [1.0, 0.8, 1.5]
    @test run(β) ≈ naive(β)
    # Each route alone is below one, and together they grow.
    @test all(r -> sum(r) < 1, (community, 0.8 .* household, 1.5 .* funeral))
    @test sum(run(β)[:, end]) > sum(run(β)[:, 10])

    # The same model as one Pairwise kernel, which loses the sparsity.
    L = maximum(length, (community, household, funeral))
    function pairwise(β)
        Ks = (β[1] .* K_community, β[2] * Matrix(I(S)), β[3] .* Matrix(K_funeral))
        A = zeros(eltype(β), S, S, L)
        for (K, g) in zip(Ks, (community, household, funeral)), l in eachindex(g)
            A[:, :, l] .+= K .* g[l]
        end
        depletion = CR.Depletion(PerStratum(pop), CR.Floor())
        return Recurrence(Pairwise(A); modifiers = (depletion,))(R; history = seed)
    end
    @test run(β) ≈ pairwise(β)

    # Gradients in the route scales, for the attack rates per place.
    attack(f) = β -> sum(f(β); dims = 2) ./ pop
    @test ForwardDiff.jacobian(attack(run), β) ≈ ForwardDiff.jacobian(attack(naive), β)

    # Per-route incidence is recomputed after the run as each route's
    # coupling applied to a Convolution of the infections with its kernel.
    y = run(β)
    routes = model(β).kernel
    m = size(seed, 2)
    force = sum(zip(routes.couplings, routes.kernels)) do (K, g)
        K * Convolution(vcat(0.0, g))(hcat(seed, y))[:, (m + 1):end]
    end
    @test force .* R' ≈ model(β)(R; history = seed, stop = T) ./
        max.(1 .- cumsum(hcat(zeros(S), y[:, 1:(end - 1)]); dims = 2) ./ pop, 1.0e-6)
end
