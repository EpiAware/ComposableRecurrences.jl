# Branching-process features in expectation, built from existing pieces:
# multi-type offspring, isolation, per-type isolation delays, contact
# tracing, population measures and clinical transitions. Each item checks an
# expected-value identity; isolation is also checked against seeded
# EpiBranch.jl simulations in `references/epibranch_isolation.jl`.

@testitem "Use case: multi-type growth is the spectral radius" tags = [:usecase] begin
    using ComposableRecurrences, LinearAlgebra
    # With a unit kernel each step is one generation, y_n = M y_{n-1}, so for
    # a primitive M the growth per generation tends to ρ(M), the
    # reproduction number of the multi-type process.
    M = [1.2 0.4 0.1; 0.3 0.6 0.2; 0.1 0.2 0.5]
    y = Recurrence([1.0]; coupling = M)(1.0; history = [1.0; 0.0; 0.0;;], stop = 60)
    ρ = maximum(abs, eigvals(M))
    @test norm(y[:, end]) / norm(y[:, end - 1]) ≈ ρ rtol = 1.0e-10
    @test y[:, end] / sum(y[:, end]) ≈
        y[:, end - 1] / sum(y[:, end - 1]) rtol = 1.0e-10
end

@testitem "Use case: isolation as a thinned kernel" tags = [:usecase] setup = [UseCaseReferences] begin
    using ComposableRecurrences
    E = UseCaseReferences.EpiBranchIsolationReference
    # A case is isolated with probability p, at a delay D after infection,
    # and isolation blocks a share b of its later contacts. With the
    # generation interval independent of D, the mean offspring at lag τ is
    # R g(τ) (1 - p b F_D(τ)).
    erlang_cdf(x, k, θ) = x <= 0 ? 0.0 :
        1 - sum(exp(-x / θ) * (x / θ)^j / factorial(j) for j in 0:(k - 1))
    lags = 1:80
    g = erlang_cdf.(lags, E.GEN_SHAPE, E.GEN_SCALE) .-
        erlang_cdf.(lags .- 1, E.GEN_SHAPE, E.GEN_SCALE)
    @assert E.DELAY_SCALE == E.INC_SCALE
    F_D = erlang_cdf.(lags .- 0.5, E.INC_SHAPE + 1, E.INC_SCALE)
    p = (1 - E.PROB_ASYMPTOMATIC) * E.TEST_SENSITIVITY
    b = 1 - E.POST_ISOLATION_TRANSMISSION
    g_iso = g .* (1 .- p * b .* F_D)

    # The offspring of one case on day 0 by day of infection, R k_t, are the
    # case convolved with the kernel; their total is the mean offspring.
    case = [1.0; zeros(length(lags))]
    offspring(k) = sum(Convolution([0.0; k])(case; gain = E.R))
    @test offspring(g) ≈ E.R * sum(g)
    @test offspring(g_iso) ≈ E.R * sum(g_iso)
    @test abs(offspring(g) - E.NONE.mean) < 3 * E.NONE.se
    @test abs(offspring(g_iso) - E.ISOLATION.mean) < 3 * E.ISOLATION.se
end

@testitem "Use case: per-type isolation and tracing in expectation" tags = [:usecase] begin
    using ComposableRecurrences, LinearAlgebra
    # Total cases from a seed x0 sum every generation: Σ_n K^n x0 =
    # (I - K)^{-1} K x0, with K the next-generation matrix of mean offspring
    # by infectee (row) and infector (column) type.
    g = [0.1, 0.3, 0.3, 0.2, 0.1]
    F_slow = [0.0, 0.1, 0.4, 0.7, 0.9]
    F_fast = [0.2, 0.6, 0.9, 1.0, 1.0]
    p, b, R = 0.8, 0.9, 1.5
    thin(F) = g .* (1 .- p * b .* F)
    total(r, x0) = sum(r(R; history = [zeros(2, 4) x0], stop = 2_000); dims = 2)

    # Isolation delay set by type: a household's first case is found slowly
    # and later cases quickly. Each infector type keeps its own kernel.
    M = [0.5 0.3; 0.4 0.5]
    W = permutedims([thin(F_slow) thin(F_fast)])
    K = R * M * Diagonal(vec(sum(W; dims = 2)))
    x0 = [1.0, 0.0]
    @test vec(total(Recurrence(PerStratum(W); coupling = M), x0)) ≈
        (I - K) \ (K * x0) rtol = 1.0e-8

    # Contact tracing: a share q of each case's infectees is traced (type 2)
    # and isolated on the faster delay.
    q = 0.6
    A = zeros(2, 2, length(g))
    for (j, k) in enumerate([thin(F_slow), thin(F_fast)])
        A[1, j, :] = (1 - q) .* k
        A[2, j, :] = q .* k
    end
    K = R * dropdims(sum(A; dims = 3); dims = 3)
    @test vec(total(Recurrence(Pairwise(A)), x0)) ≈ (I - K) \ (K * x0) rtol = 1.0e-8
end

@testitem "Use case: population measures as a gain" tags = [:usecase] begin
    using ComposableRecurrences
    # Population control scales R by 1 - c. A scheduled measure applies it
    # only from t0 to t1, so the gain is the series R_t. With a unit kernel
    # each step is one generation and y_n = y_0 Π_{t ≤ n} R_t.
    R, c, t0, t1, T = 1.8, 0.5, 5, 12, 20
    R_t = [t0 <= t <= t1 ? (1 - c) * R : R for t in 1:T]
    y = Recurrence([1.0])(R_t; history = [3.0])
    @test y ≈ 3.0 .* cumprod(R_t)
    @test y[t1] / y[t1 - 1] ≈ (1 - c) * R

    # With a generation interval the long-run growth per generation tends to
    # the gain, so a constant control 1 - c moves R to (1 - c) R.
    g = [0.1, 0.3, 0.3, 0.2, 0.1]
    renewal(R) = Recurrence(g)(fill(R, 400); history = [1.0])
    growth(y) = y[end] / y[end - 1]
    r = log(growth(renewal((1 - c) * R)))
    @test sum(g[l] * exp(-r * l) for l in eachindex(g)) * (1 - c) * R ≈ 1 rtol =
        1.0e-8
end

@testitem "Use case: clinical transitions as chained convolutions" tags = [:usecase] begin
    using ComposableRecurrences
    # Infection to onset, onset to admission with probability h, admission
    # to death with probability f. Each step is a Convolution, the
    # probability its gain. The chain equals one Convolution of the
    # convolved delays, with gain h f.
    conv(a, b) = [
        sum(a[i + 1] * b[n - i + 1] for i in max(0, n - length(b) + 1):min(n, length(a) - 1))
            for n in 0:(length(a) + length(b) - 2)
    ]
    d_onset = [0.0, 0.2, 0.5, 0.3]
    d_admit = [0.3, 0.4, 0.2, 0.1]
    d_death = [0.1, 0.2, 0.4, 0.2, 0.1]
    h, f = 0.1, 0.25
    infections = [t <= 30 ? exp(0.1 * t) : 0.0 for t in 1:60]
    onsets = Convolution(d_onset)(infections)
    admissions = Convolution(d_admit)(onsets; gain = h)
    deaths = Convolution(d_death)(admissions; gain = f)
    @test deaths ≈
        Convolution(conv(conv(d_onset, d_admit), d_death))(infections; gain = h * f)
    # Every infection's delays fall inside the window, so totals scale by
    # the probabilities.
    @test sum(onsets) ≈ sum(infections)
    @test sum(deaths) ≈ h * f * sum(infections)
end
