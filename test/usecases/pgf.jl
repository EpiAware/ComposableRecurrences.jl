# Probability generating function (PGF) iterations as a Recurrence with a
# Transform: chain-length likelihoods, containment and extinction
# probabilities, checked against EpiBranch.jl values in
# `references/epibranch.jl`.

@testitem "Use case: chain-length likelihood from PGF iteration" tags = [:usecase] setup = [UseCaseReferences] begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    E = UseCaseReferences.EpiBranchReference
    # q_n = G(q_{n-1}) from q_0 = 0, so q[n + 1] = P(length ≤ n).
    function iterate_pgf(G, θ, n)
        r = Recurrence([1.0]; modifiers = (CR.Transform(G, θ),))
        return r(; history = [0.0], add = zeros(n))
    end
    prob(q, len) = len == 0 ? q[1] : q[len + 1] - q[len]
    loglik(q, data) = sum(len -> log(prob(q, len)), data)
    single(q) = [loglik(q, [len]) for len in 0:E.MAXLEN]

    nb(s, θ) = (θ.p / (1 - (1 - θ.p) * s))^θ.r
    q = iterate_pgf(nb, (; r = E.NB_K, p = E.NB_P), E.MAXLEN + 1)
    @test single(q) == E.NB_SINGLE_LL
    @test loglik(q, E.DATA) ≈ E.NB_DATA_LL rtol = 1.0e-14

    poisson(s, λ) = exp(λ * (s - 1))
    q = iterate_pgf(poisson, E.POIS_LAMBDA, E.MAXLEN + 1)
    @test single(q) == E.POIS_SINGLE_LL
    @test loglik(q, E.DATA) ≈ E.POIS_DATA_LL rtol = 1.0e-14
end

@testitem "Use case: containment and extinction at convergence" tags = [:usecase] setup = [UseCaseReferences] begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    E = UseCaseReferences.EpiBranchReference
    nb(s, θ) = (θ.p / (1 - (1 - θ.p) * s))^θ.r
    fixed_point(m, n) = last(
        Recurrence([1.0]; modifiers = (m,))(; history = [0.0], add = zeros(n))
    )

    # Containment: q = c + (1 - c) G(q), raised to the number of introductions.
    r, p = E.CONTAIN_RP
    contain(s, θ) = θ.c + (1 - θ.c) * nb(s, θ)
    c = E.CONTAIN.ind_control
    q = fixed_point(CR.Transform(contain, (; c, r, p)), 500)
    @test q^E.CONTAIN.n_initial ≈ E.CONTAIN_VALUE atol = 1.0e-8

    # Extinction: q = G(q).
    r, p = E.EXT_RP
    @test fixed_point(CR.Transform(nb, (; r, p)), 500) ≈ E.EXT_VALUE atol =
        1.0e-8
    poisson(s, λ) = exp(λ * (s - 1))
    @test fixed_point(CR.Transform(poisson, E.EXT_POIS_LAMBDA), 500) ≈
        E.EXT_POIS_VALUE atol = 1.0e-8

    # Time-resolved extinction with a generation interval: q_t is the
    # probability of extinction by time t, and tends to the extinction
    # probability.
    g = [0.2, 0.5, 0.3]
    q = Recurrence(g; modifiers = (CR.Transform(nb, (; r, p)),))(
        ; history = zeros(3), add = zeros(1000)
    )
    @test all(diff(q) .>= 0)
    @test last(q) ≈ E.EXT_VALUE atol = 1.0e-8
end

@testitem "Use case: multi-type extinction" tags = [:usecase] setup = [UseCaseReferences] begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    E = UseCaseReferences.EpiBranchReference
    # q_j = G_j(Σ_i a_ij q_i): the coupling sums over the allocation column,
    # and each type has its own offspring law.
    nb(s, θ) = (θ.p / (1 - (1 - θ.p) * s))^θ.r
    m = CR.Transform(nb, (; r = E.MT_NB_R, p = E.MT_NB_P))
    r = Recurrence([1.0]; coupling = permutedims(E.MT_ALLOC), modifiers = (m,))
    q = r(; history = zeros(2, 1), add = zeros(2, 500))
    @test q[:, end] ≈ E.MT_VALUE atol = 1.0e-8
end
