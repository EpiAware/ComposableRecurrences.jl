# The trace a call records with `trace = true`: each modifier's trace
# against the series it stands for (the state after each step, read by
# resuming one step at a time, or the maths), its shape and its
# gradients, by the rule against ForwardDiff.

@testmodule TraceChecks begin
    using ComposableRecurrences
    const CR = ComposableRecurrences

    # Each modifier's state after each step, read by resuming one step at
    # a time: a matrix of state entries × steps per modifier.
    function states_by_step(r, R; history)
        T = size(R, ndims(R))
        cols = map(_ -> Vector{Vector{Float64}}(), r.modifiers)
        st = nothing
        for t in 1:T
            _, st = st === nothing ? CR.with_state(r, R; history, stop = t) :
                CR.with_state(r, R; state = st, stop = t)
            foreach((c, s) -> push!(c, copy(s)), cols, st.states)
        end
        return map(c -> reduce(hcat, c), cols)
    end

    # The value entering the modifiers at each step, `R_t Σ g_l y_{t-l}`,
    # for one series from its outputs and history.
    # A history shorter than the kernel is zero-padded, as the recurrence
    # pads it.
    function pressures(g, R, y, h)
        L = length(g)
        z = vcat(zeros(max(L - length(h), 0)), h, y)
        H = length(z) - length(y)
        return [R[t] * sum(g[l] * z[H + t - l] for l in 1:L) for t in eachindex(R)]
    end
end

@testitem "Trace: a call without a trace is unchanged" setup = [TraceChecks] begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    r = Recurrence([0.3, 0.5, 0.2]; modifiers = (CR.Depletion(100.0),))
    R = fill(2.0, 8)
    y = r(R; history = [5.0])
    y2, tr = r(R; history = [5.0], trace = true)
    @test y2 == y
    @test keys(tr) == (:modifiers,)
    @test length(tr.modifiers) == 1
    @test size(only(tr.modifiers)) == (3, 8)
    (y3, tr3), st = CR.with_state(r, R; history = [5.0], trace = true)
    @test y3 == y
    @test tr3.modifiers == tr.modifiers
    @test st.states == CR.with_state(r, R; history = [5.0])[2].states
    (y4, tr4), _ = CR.forward(r, CR.Run(), R; history = [5.0], trace = true)
    @test y4 == y
    @test tr4.modifiers == tr.modifiers
end

@testitem "Trace: a depletion's pool, draw and overflow" setup = [TraceChecks] begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    (; states_by_step, pressures) = TraceChecks
    g, R, h = [0.3, 0.5, 0.2], collect(range(1.5, 3.0; length = 10)), [5.0]
    r = Recurrence(g; modifiers = (CR.Depletion(60.0; removals = 1.0),))
    y, tr = r(R; history = h, trace = true)
    M = only(tr.modifiers)
    @test M[1, :] ≈ vec(only(states_by_step(r, R; history = h)))
    @test M[2, :] == y
    @test M[3, :] ≈ pressures(g, R, y, h) .- y
end

@testitem "Trace: a protected pool's pools, draw and overflow" setup = [TraceChecks] begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    (; states_by_step, pressures) = TraceChecks
    g, R, h = [0.3, 0.5, 0.2], fill(2.0, 2, 8), [5.0 4.0; 3.0 2.0]
    leaky = CR.Pool(
        PerStratum([80.0, 120.0]); pools = (:S, :V), draw = (:S => 1, :V => 0.3) => CR.Hazard(),
        flows = (CR.Flow(:S => :V, 2.0; form = CR.Truncate()), CR.Flow(:V => :S, 0.1))
    )
    r = Recurrence(g; modifiers = (leaky,))
    y, tr = r(R; history = h, trace = true)
    M = only(tr.modifiers)
    # Rows: pool S of each stratum, then pool V, then the value drawn,
    # then the overflow.
    @test size(M) == (8, 8)
    @test M[1:4, :] ≈ only(states_by_step(r, R; history = h))
    @test M[5:6, :] == y
    for k in 1:2
        @test M[6 + k, :] ≈ pressures(g, R[k, :], y[k, :], h[k, :]) .- y[k, :]
    end
end

@testitem "Trace: each flow's amount against a naive loop" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    # One ward: admissions into pool 1, confirmed into 2 at a hazard rate,
    # ruled out as a share, discharged at a hazard rate, transferred out in
    # counts that bind on the third step.
    c, p, d, a = 0.3, 0.2, 0.1, [1.0, 1.0, 5.0, 1.0, 0.5, 0.0]
    adm = [4.0, 6.0, 2.0, 0.0, 3.0, 1.0]
    ward = CR.Pool(;
        pools = 2, draw = nothing, flows = (
            CR.Flow(1 => 2, c), CR.Flow(1 => 0, p; form = CR.Share()),
            CR.Flow(2 => 0, d), CR.Flow(2 => 0, TimeVarying(a); form = CR.Truncate()),
        )
    )
    r = Recurrence([1.0]; modifiers = (ward,))
    y, tr = r(; history = zeros(2, 1), add = [adm'; zero(adm')], trace = true)
    M = only(tr.modifiers)
    @test size(M) == (4, 6)
    x = zeros(2)
    for t in 1:6
        x[1] += adm[t]
        g1 = (1 - exp(-c)) / c
        g2 = (1 - exp(-d)) / d
        m = [x[1] * c * g1, x[1] * p, x[2] * d * g2]
        x1 = x[1] * (exp(-c) - p)
        x2 = x[2] * exp(-d) + m[1]
        count = min(a[t], max(x2, 0.0))
        @test M[:, t] ≈ [m; count]
        x .= [x1, x2 - count]
        @test y[:, t] ≈ x
    end
end

@testitem "Trace: the default is the state after the step" setup = [TraceChecks] begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    (; states_by_step) = TraceChecks
    # Redistribute keeps its arrivals as its state, so its trace is what
    # each stratum receives at each step.
    K = [0.0 0.3 0.1; 0.2 0.0 0.4; 0.1 0.2 0.0]
    r = Recurrence(
        [0.4, 0.6]; modifiers = (CR.Redistribute(K, 0.2), CR.Depletion(PerStratum([50.0, 60.0, 70.0])))
    )
    R, h = fill(1.8, 3, 6), [1.0 2.0; 2.0 1.0; 0.5 0.5]
    y, tr = r(R; history = h, trace = true)
    M1, M2 = tr.modifiers
    S1, S2 = states_by_step(r, R; history = h)
    @test M1 ≈ S1
    @test M2[1:3, :] ≈ S2
    @test CR.ntrace(CR.Redistribute(K, 0.2), 3) == 3
end

@testitem "Trace: gradients through a trace, the rule against ForwardDiff" begin
    using ComposableRecurrences, ForwardDiff, Mooncake
    using DifferentiationInterface: gradient, AutoMooncake
    CR = ComposableRecurrences
    W = reshape(range(0.2, 1.8; length = 48), 6, 8)
    g, R, h = [0.3, 0.5, 0.2], fill(2.0, 2, 8), [5.0 4.0; 3.0 2.0]
    K = [0.0 0.3; 0.2 0.0]
    function loss(θ)
        leaky = CR.Pool(
            PerStratum(θ[1:2]); pools = (:S, :V),
            draw = (:S => 1, :V => θ[3]) => CR.Hazard(),
            flows = (
                CR.Flow(:S => :V, θ[4]; form = CR.Truncate()), CR.Flow(:V => :S, θ[5]),
            )
        )
        mods = (CR.Redistribute(K, θ[6]), leaky)
        _, tr = Recurrence(g; modifiers = mods)(R; history = h, trace = true)
        T1, T2 = tr.modifiers
        return sum(W[1:2, :] .* T1) + sum(W .* T2[3:8, :])
    end
    θ = [80.0, 120.0, 0.3, 2.0, 0.1, 0.2]
    n = CR._PULLBACK_CALLS[]
    @test gradient(loss, AutoMooncake(), θ) ≈ ForwardDiff.gradient(loss, θ)
    @test CR._PULLBACK_CALLS[] > n
    # The flows' amounts, with a smooth count whose softness is a
    # parameter.
    function ward(θ)
        flows = CR.Pool(;
            pools = 2, draw = nothing, flows = (
                CR.Flow(1 => 2, θ[1]), CR.Flow(1 => 0, θ[2]; form = CR.Share()),
                CR.Flow(2 => 0, θ[3]; form = CR.SoftTruncate(θ[4])),
            )
        )
        r = Recurrence([1.0]; modifiers = (flows,))
        adm = [4.0 6.0 2.0 0.0 3.0 1.0; 0.0 0.0 0.0 0.0 0.0 0.0]
        y, tr = r(; history = zeros(2, 1), add = adm, trace = true)
        return sum(W[1:3, 1:6] .* only(tr.modifiers)) + sum(y)
    end
    θw = [0.3, 0.2, 1.5, 0.2]
    @test gradient(ward, AutoMooncake(), θw) ≈ ForwardDiff.gradient(ward, θw)
end
