# Isolation that starts on a calendar day, as a cohort-indexed renewal
# kernel. A case infected at time c is isolated with probability p at c + D,
# with D the infection-to-isolation delay, and isolation blocks a share b of
# its later transmission. An isolation dated before the policy start t0 does
# not happen (EpiBranch.jl `Scheduled(Isolation(...); start_time)`, which
# resets an individual whose isolation time falls before `start_time`;
# src/interventions/scheduled.jl and src/interventions/isolation.jl at
# cdfbb338). In expectation the kernel of cohort c at lag τ is
#
#     K[τ, c] = g(τ) (1 - p b P(D ≤ τ, c + D ≥ t0)),
#
# a property of the infector's cohort, so it is a Primary() kernel.

@testitem "Use case: scheduled isolation as a cohort kernel" tags = [:usecase] begin
    using ComposableRecurrences, ForwardDiff
    CR = ComposableRecurrences

    g = [0.1, 0.3, 0.3, 0.2, 0.1]
    d = [0.2, 0.4, 0.3, 0.1]          # P(D = 0, 1, 2, 3)
    p, b, t0, T = 0.6, 0.9, 15, 30
    L = length(g)
    # P(D ≤ τ, D ≥ t0 - c) for the discrete delay.
    blocked(τ, c) = sum(d[j + 1] for j in max(t0 - c, 0):min(τ, 3); init = 0.0)
    kernel(p, b) = [g[τ] * (1 - p * b * blocked(τ, c)) for τ in 1:L, c in 1:T]
    R = [2.0 + 0.3 * sin(t / 4) for t in 1:T]
    seed = [1.0, 2.0, 3.0]

    # The renewal with each infector's own kernel, written out.
    function naive(K, R)
        y = zeros(promote_type(eltype(K), eltype(R)), T)
        y[1:3] .= seed
        for t in 4:T
            y[t] = R[t] * sum(K[τ, t - τ] * y[t - τ] for τ in 1:L if t - τ >= 1)
        end
        return y
    end
    model(K, R) = CR.seeded(
        Recurrence(TimeVarying(K, CR.Primary())), R; history = seed
    )
    K = kernel(p, b)
    @test model(K, R) ≈ naive(K, R)
    θ = [p, b]
    @test ForwardDiff.gradient(θ -> sum(model(kernel(θ...), R)), θ) ≈
        ForwardDiff.gradient(θ -> sum(naive(kernel(θ...), R)), θ)

    # Cohorts isolated only after the start see the plain kernel; cohorts
    # infected from t0 on see the thinned kernel g(τ)(1 - p b P(D ≤ τ)).
    F(τ) = sum(d[1:(min(τ, 3) + 1)])
    @test K[:, 1:(t0 - 5)] ≈ repeat(g, 1, t0 - 5)
    @test K[:, t0:end] ≈ repeat([g[τ] * (1 - p * b * F(τ)) for τ in 1:L], 1, T - t0 + 1)
end
