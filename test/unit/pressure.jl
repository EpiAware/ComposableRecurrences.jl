# `pressure`: the sum each step of a recurrence draws against, recomputed
# from its outputs. Without modifiers the outputs over it recover the gain,
# for every kernel and coupling form; with depletion they give the
# effective value. The first steps, start and state, zero pressures and the
# argument checks.

@testmodule PressureCases begin
    using ComposableRecurrences, LinearAlgebra, SparseArrays

    const S, T = 3, 12
    const g = [0.4, 0.3, 0.2, 0.1]
    const G = [0.4 0.3 0.2 0.1; 0.1 0.5 0.3 0.1; 0.25 0.25 0.25 0.25]
    const K = [0.8 0.1 0.1; 0.2 0.7 0.1; 0.0 0.3 0.7]
    const A = [0.05 * (a + 2b + l) / 10 for a in 1:S, b in 1:S, l in 1:4]
    const R = [1.0 + 0.2 * sin(k + t) for k in 1:S, t in 1:T]
    const h = [1.0 + 0.1 * (k + l) for k in 1:S, l in 1:5]

    # The gain recovered from a run without modifiers.
    recovered(r, R, h; kw...) = (y = r(R; history = h, kw...); y ./ pressure(r, y; history = h, kw...))
    const pressure = ComposableRecurrences.pressure
end

@testitem "pressure: every kernel and coupling recovers the gain" setup = [PressureCases] begin
    using ComposableRecurrences, LinearAlgebra, SparseArrays, Distributions
    using ComposableRecurrences: Primary
    using .PressureCases: S, T, g, G, K, A, R, h, recovered
    tv(x) = repeat(x, ntuple(_ -> 1, ndims(x))..., T)
    ops = [
        Recurrence(g),
        Recurrence(g; coupling = K),
        Recurrence(PerStratum(G); coupling = K),
        Recurrence(g; coupling = Diagonal([0.9, 1.0, 1.1])),
        Recurrence(g; coupling = 0.7I),
        Recurrence(g; coupling = sparse(K)),
        Recurrence(g; coupling = TimeVarying(tv(K))),
        Recurrence(TimeVarying(g .* (1 .+ 0.01 .* (1:T)')); coupling = K),
        Recurrence(TimeVarying(PerStratum(tv(G)))),
        Recurrence(TimeVarying([1 => g, 7 => reverse(g)]); coupling = K),
        Recurrence(Pairwise(A)),
        Recurrence(TimeVarying(Pairwise(tv(A)))),
        Recurrence(Routes((K, g), (Diagonal(ones(S)), [0.0, 0.0, 0.0, 0.5, 0.5]))),
        Recurrence(NegativeBinomial(4, 0.6); lags = 5, coupling = K),
        Recurrence(NegativeBinomial(4, 0.6); lags = 5, step = 2),
    ]
    for r in ops
        @test recovered(r, R, h) ≈ R atol = 1.0e-12 rtol = 1.0e-12
    end
    # A Primary() kernel, with the seed at times 1 to 5.
    r = Recurrence(TimeVarying(repeat(g, 1, T + 5), Primary()); coupling = K)
    @test recovered(r, hcat(ones(S, 5), R), h; start = 6) ≈ R atol = 1.0e-12 rtol = 1.0e-12
    # One series.
    @test recovered(Recurrence(g), R[1, :], h[1, :]) ≈ R[1, :] atol = 1.0e-12 rtol = 1.0e-12
end

@testitem "pressure: the history, start and a resumed state" setup = [PressureCases] begin
    using ComposableRecurrences
    using .PressureCases: g, K, R, h, pressure
    L = length(g)
    r = Recurrence(g; coupling = K)
    y = r(R; history = h)
    # Without the history the pressure misses the seed until lag `L` has
    # passed it, then agrees.
    R̂ = y ./ pressure(r, y)
    @test all(R̂[:, 1:L] .!= R[:, 1:L])
    @test R̂[:, (L + 1):end] ≈ R[:, (L + 1):end] atol = 1.0e-12 rtol = 1.0e-12
    # A call that returns its seed: the columns after the history.
    yp = r(R; history = h, prepend = true)
    @test pressure(r, yp[:, (size(h, 2) + 1):end]; history = h) ≈ pressure(r, y; history = h)
    # A resumed call: its state's history and time.
    y1, st = r(R; history = h, stop = 6, state = true)
    y2, _ = r(R; state = st)
    @test y2 ./ pressure(r, y2; history = st.history, start = st.t) ≈ R[:, 7:end]
end

@testitem "pressure: a zero pressure gives no value" setup = [PressureCases] begin
    using ComposableRecurrences
    using .PressureCases: K, R, pressure
    Rt = R[1, :]
    # No seed: every output and pressure is zero.
    r = Recurrence([0.5, 0.5])
    y = r(Rt; history = zeros(1))
    @test all(isnan, y ./ pressure(r, y; history = zeros(1)))
    # A kernel on lag 3 alone: only every third step has a pressure.
    r3 = Recurrence([0.0, 0.0, 1.0])
    y = r3(Rt; history = [1.0])
    R̂ = y ./ pressure(r3, y; history = [1.0])
    seeded = (1:length(Rt)) .% 3 .== 0
    @test all(isnan, R̂[.!seeded])
    @test R̂[seeded] ≈ Rt[seeded] atol = 1.0e-12 rtol = 1.0e-12
    # Only the first stratum seeded: the coupling gives the others a
    # pressure from the first step, which their own kernel alone does not.
    seed = [ones(1, 2); zeros(2, 2)]
    rK = Recurrence([0.5, 0.5]; coupling = K)
    y = rK(R; history = seed)
    @test pressure(rK, y; history = seed)[2, 1] > 0
    @test isinf((y ./ pressure(Recurrence([0.5, 0.5]), y; history = seed))[2, 1])
end

@testitem "pressure: the effective value under depletion" setup = [PressureCases] begin
    using ComposableRecurrences
    using ComposableRecurrences: Depletion, Add
    using .PressureCases: S, T, g, K, R, pressure
    pop = [600.0, 250.0, 100.0]
    seed = fill(2.0, S, 4)
    # The hazard form draws `s_{t-1} (1 - e^{-λ})` with `λ = R_t q_t / N`,
    # so the effective value is `R_t s_{t-1} / N` scaled by `(1 - e^{-λ}) / λ`,
    # from the pools after each step in the trace.
    function depleted(q, pools)
        s = hcat(pop, pools[:, 1:(end - 1)])
        λ = R .* q ./ pop
        return R .* s ./ pop .* -expm1.(-λ) ./ λ
    end
    r = Recurrence(g; coupling = K, modifiers = (Depletion(PerStratum(pop)),))
    y, tr = r(R; history = seed, trace = true)
    q = pressure(r, y; history = seed)
    R̂ = y ./ q
    @test R̂ ≈ depleted(q, only(tr.modifiers)[1:S, :]) atol = 1.0e-12 rtol = 1.0e-12
    @test all(R̂ .< R)
    # Imports after the depletion change the output but not what is drawn:
    # the output less the imports gives the depleted value, as do the drawn
    # values after the pools in the trace.
    ι = [t <= 5 ? 1.0 : 0.0 for _ in 1:S, t in 1:T]
    imports = Add(TimeVarying(PerStratum(ι)))
    ra = Recurrence(g; coupling = K, modifiers = (Depletion(PerStratum(pop)), imports))
    ya, tra = ra(R; history = seed, trace = true)
    M = first(tra.modifiers)
    drawn = M[(S + 1):(2S), :]
    @test ya ≈ drawn .+ ι
    qa = pressure(ra, ya; history = seed)
    @test drawn ./ qa ≈ depleted(qa, M[1:S, :]) atol = 1.0e-12 rtol = 1.0e-12
    @test (ya .- ι) ./ qa ≈ drawn ./ qa atol = 1.0e-12 rtol = 1.0e-12
end

@testitem "pressure: argument checks and inference" setup = [PressureCases] begin
    using ComposableRecurrences
    using ComposableRecurrences: Primary
    using .PressureCases: S, T, g, K, R, h, pressure
    r = Recurrence(g; coupling = K)
    y = r(R; history = h)
    @test @inferred(pressure(r, y; history = h)) isa Matrix{Float64}
    @test @inferred(pressure(Recurrence(g), y[1, :]; history = h[1, :])) isa Vector{Float64}
    @test @inferred(pressure(r, Float32.(y); history = Float32.(h))) isa Matrix{Float64}
    @test_throws DimensionMismatch pressure(r, y; history = h[1:2, :])
    @test_throws DimensionMismatch pressure(r, y; history = h[1, :])
    @test_throws ArgumentError pressure(r, y; history = h, start = 0)
    @test_throws DimensionMismatch pressure(Recurrence(g; coupling = ones(2, 2)), y; history = h)
    # A Primary() kernel needs its seed at times from 1, and a time-varying
    # kernel must cover the last time.
    rp = Recurrence(TimeVarying(repeat(g, 1, T + 5), Primary()))
    @test_throws ArgumentError pressure(rp, y; history = h)
    @test_throws DimensionMismatch pressure(
        Recurrence(TimeVarying(repeat(g, 1, 3))), y; history = h
    )
end
