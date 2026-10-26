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
            _, st = st === nothing ? r(R; history, stop = t, state = true) :
                r(R; state = st, stop = t)
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
    (y3, tr3), st = r(R; history = [5.0], trace = true, state = true)
    @test y3 == y
    @test tr3.modifiers == tr.modifiers
    @test st.states == r(R; history = [5.0], state = true)[2].states
    (y4, tr4), _ = CR.forward(r, CR.Run(), R; history = [5.0], trace = true)
    @test y4 == y
    @test tr4.modifiers == tr.modifiers
    # A literal `trace` inside a function is folded, so each call infers.
    # `forward` and `Run` are imported, as a global alias does not infer.
    using ComposableRecurrences: forward, Run
    traced(r, R, h) = r(R; history = h, trace = true)
    untraced(r, R, h) = r(R; history = h, trace = false)
    run(r, R, h) = first(forward(r, Run(), R; history = h, trace = true))
    @test @inferred(traced(r, R, [5.0])) == (y2, tr)
    @test @inferred(untraced(r, R, [5.0])) == y
    @test @inferred(run(r, R, [5.0])) == (y2, tr)
end

@testsnippet InStepTraces begin
    using ComposableRecurrences, ForwardDiff
    using LinearAlgebra: I
    CR = ComposableRecurrences
    S, T, L = 3, 9, 3
    g = [0.3, 0.5, 0.2]
    R = [1.5 + 0.2 * sin(k + t) for k in 1:S, t in 1:(L + T)]
    h = [4.0 + k + l for k in 1:S, l in 1:L]
    N = PerStratum([60.0, 80.0, 100.0])
    K = [0.0 0.2 0.1; 0.1 0.0 0.2; 0.2 0.1 0.0]
    ε = [0.3 + 0.1 * cos(k * t) for k in 1:S, t in 1:(L + T)]
    leaky = CR.Depletion(
        N; pools = (:S, :V), weights = (S = 1, V = 0.3),
        flows = (CR.Flow(:S => :V, 2.0; form = CR.Truncate()),)
    )
    # A draw that fills one pool: one value and one state entry per stratum,
    # but stepped by its group kernel, so not on the per-stratum loop.
    beds = CR.Depletion(N; pools = (O = 0.0,), form = CR.Truncate(), fill = :O)
    # Independent strata, coupled strata with pointwise modifiers, a
    # vector step before a pointwise one, a blockwise step, a modifier
    # whose state never changes, and the one-pool fill.
    cases = (
        Recurrence(g; modifiers = (CR.Depletion(N),)),
        Recurrence(g; coupling = K + I, modifiers = (CR.Depletion(N),)),
        Recurrence(
            g; modifiers = (CR.Redistribute(CR.movement(K, ε)), CR.Depletion(N))
        ),
        Recurrence(g; modifiers = (leaky,)),
        Recurrence(g; modifiers = (CR.Clamp(0.0, 9.0), CR.Depletion(N))),
        Recurrence(g; modifiers = (beds,)),
    )
    dual(x) = ForwardDiff.Dual{Nothing}.(x, 0.5 .* x)
    # Floats match the rule's trace exactly. Dual numbers match it to a few
    # rounding errors, as the plain and recorded runs of dual numbers
    # already do: the compiler sums their lags in a different order.
    same(a, b) = a == b
    function same(a::AbstractArray{<:ForwardDiff.Dual}, b)
        return isapprox(ForwardDiff.value.(a), ForwardDiff.value.(b); rtol = 1.0e-13) &&
            isapprox(ForwardDiff.partials.(a, 1), ForwardDiff.partials.(b, 1); rtol = 1.0e-13)
    end
    same(a::Tuple, b::Tuple) = all(map(same, a, b))
end

@testitem "Trace: a call without records writes the rule's trace in each step" setup = [InStepTraces] begin
    @test CR.blocks(beds) == (1, 1)
    @test !CR._strata_loop(beds)
    # The rule builds the trace from its records after the run; the call
    # without records writes it in each step.
    for r in cases, (Rx, hx) in ((R, h), (dual(R), dual(h)))
        args = CR._run_args(r, Rx, hx, nothing, nothing, L + 1)
        w = CR._WithTrace(r)
        yr, trr = first(CR._run_forward(w, args..., nothing))
        yw, trw = CR._primal(w, args..., nothing)
        @test same(yw, yr)
        @test same(trw.modifiers, trr.modifiers)
        y, tr = r(Rx; history = hx, start = L + 1, trace = true)
        @test y == yw
        @test tr.modifiers == trw.modifiers
        @test y == r(Rx; history = hx, start = L + 1)
    end
    # One series, with its seed in front.
    r = Recurrence(g; modifiers = (CR.Depletion(70.0),))
    args = CR._run_args(r, R[1, :], h[1, :], nothing, nothing, L + 1)
    yr, trr = first(CR._run_forward(CR._WithTrace(r), args..., nothing))
    y, tr = r(R[1, :]; history = h[1, :], start = L + 1, prepend = true, trace = true)
    @test y == vcat(h[1, :], yr)
    @test tr.modifiers == trr.modifiers
end

@testitem "Trace: prepend and state with a trace written in each step" setup = [InStepTraces] begin
    for r in cases, (Rx, hx) in ((R, h), (dual(R), dual(h)))
        y, tr = r(Rx; history = hx, start = L + 1, trace = true)
        # With the seed in front, as the rule's forward pass joins it.
        yp, trp = r(Rx; history = hx, start = L + 1, prepend = true, trace = true)
        @test yp == CR._join(hx, y)
        @test trp.modifiers == tr.modifiers
        @test r(Rx; history = hx, start = L + 1, prepend = true) == yp
        (ys, trs), st = r(Rx; history = hx, start = L + 1, trace = true, state = true)
        @test ys == y
        @test trs.modifiers == tr.modifiers
        @test st.states == r(Rx; history = hx, start = L + 1, state = true)[2].states
    end
end

@testitem "Trace: a trace written in each step under other executors" setup = [InStepTraces] begin
    using Base.ScopedValues: with
    using KernelAbstractions
    for r in cases, (Rx, hx) in ((R, h), (dual(R), dual(h)))
        yp, tr = r(Rx; history = hx, start = L + 1, prepend = true, trace = true)
        for ex in (
                CR.Threaded(; min_work = 0, ntasks = 3),
                CR.Device(KernelAbstractions.CPU()),
            )
            yt, trt = with(CR.EXECUTOR => ex) do
                r(Rx; history = hx, start = L + 1, prepend = true, trace = true)
            end
            @test same(yt, yp)
            @test same(trt.modifiers, tr.modifiers)
        end
    end
end

@testitem "Trace: a trace written in each step with a short or long history" setup = [InStepTraces] begin
    # A history shorter or longer than the kernel, which the joined output
    # holds whole, over strata and for one series.
    for r in cases[[1, 3]], hx in (h[:, 2:3], hcat(h, h)), x in (identity, dual)
        Rx, hx = x(R[:, 1:T]), x(hx)
        y = r(Rx; history = hx)
        @test r(Rx; history = hx, prepend = true) == CR._join(hx, y)
        yp, tr = r(Rx; history = hx, prepend = true, trace = true)
        @test yp == CR._join(hx, y)
        @test tr.modifiers == last(r(Rx; history = hx, trace = true)).modifiers
        r1 = Recurrence(g; modifiers = (CR.Depletion(70.0),))
        y1 = r1(Rx[1, :]; history = hx[1, :])
        @test r1(Rx[1, :]; history = hx[1, :], prepend = true) == vcat(hx[1, :], y1)
    end
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

@testitem "Trace: a protected Depletion's pools, draw and overflow" setup = [TraceChecks] begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    (; states_by_step, pressures) = TraceChecks
    g, R, h = [0.3, 0.5, 0.2], fill(2.0, 2, 8), [5.0 4.0; 3.0 2.0]
    leaky = CR.Depletion(
        PerStratum([80.0, 120.0]); pools = (:S, :V), weights = (S = 1, V = 0.3),
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
    ward = CR.Depletion(;
        pools = (:A, :B), form = nothing, flows = (
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

@testitem "Trace: the flow amounts' pullback against forward mode" setup = [ReferenceAD] begin
    using ComposableRecurrences, ForwardDiff
    CR = ComposableRecurrences
    # Every kind of flow: two hazards out of one pool, a share, a count
    # into a pool, a smooth count out of the system and a count from
    # outside, where the count into a pool binds and where it does not.
    build(θ) = (
        CR.Flow(1 => 2, θ[1]), CR.Flow(1 => 0, θ[2]),
        CR.Flow(2 => 0, θ[3]; form = CR.Share()),
        CR.Flow(2 => 1, θ[4]; form = CR.Truncate()),
        CR.Flow(1 => 0, θ[5]; form = CR.SoftTruncate(θ[6])),
        CR.Flow(0 => 2, θ[7]; form = CR.Truncate()),
    )
    θ = [0.3, 0.2, 0.25, 0.8, 0.5, 0.2, 1.5]
    r̄ = (0.7, -0.4, 1.1, 0.6, -0.9, 0.5)
    for x in ((4.0, 3.0), (4.0, 0.3))
        f(z) = sum(map(*, r̄, CR._amounts(build(z[3:end]), (z[1], z[2]), 1, 1)))
        ref = ReferenceAD.gradient(f, [x..., θ...])
        fs = build(θ)
        f̄s = map(_ -> (; demand = Ref(0.0), form = (; κ = Ref(0.0))), fs)
        x̄ = CR._amounts_pullback(fs, f̄s, r̄, x, 1, 1)
        d̄ = map(f̄ -> f̄.demand[], f̄s)
        @test [x̄..., d̄[1:5]..., f̄s[5].form.κ[], d̄[6]] ≈ ref
    end
end

@testitem "Trace: a Depletion group's trace and pullback on one-entry views" setup = [ReferenceAD] begin
    using ComposableRecurrences, ForwardDiff
    CR = ComposableRecurrences
    # The group methods a caller reaches directly, which the run passes by
    # for the gathered values: a ward of two pools, one group, against the
    # run's own group trace and forward mode.
    build(θ) = CR.Depletion(;
        pools = (:A, :B), form = nothing, flows = (
            CR.Flow(1 => 2, θ[1]), CR.Flow(1 => 0, θ[2]; form = CR.Share()),
            CR.Flow(2 => 0, θ[3]),
        )
    )
    θ = [0.3, 0.2, 0.1]
    m = build(θ)
    n = CR.ntrace(m, 2)
    refs(x) = map(Ref, Tuple(x))
    function trace(z)
        r = ntuple(_ -> Ref(zero(eltype(z))), n)
        CR.forward!(
            build(z[9:end]), CR.Trace(), r, refs(z[1:2]), refs(z[3:4]),
            refs(z[5:6]), refs(z[7:8]), 1, 1
        )
        return collect(map(x -> x[], r))
    end
    z = [4.0, 3.0, 0.0, 0.0, 2.6, 4.1, 0.0, 0.0, θ...]
    col = zeros(n)
    CR._group_trace!(m, CR._blocks(m), col, z[1:2], z[3:4], z[5:6], z[7:8], 1, 1, 1)
    @test trace(z) ≈ col
    r̄ = [0.7, -0.4, 1.1][1:n]
    ref = ReferenceAD.gradient(x -> sum(r̄ .* trace(x)), z)
    piece = (; flows = map(_ -> (; demand = Ref(0.0), form = nothing), m.flows))
    grads = (;
        piece, trace = refs(r̄), v = refs(zeros(2)), s = refs(zeros(2)),
        v′ = refs(zeros(2)), s′ = refs(zeros(2)),
    )
    @test CR.pullback!(grads, m, CR.Trace(), refs(z[1:2]), refs(z[3:4]), 1, 1) === nothing
    x̄ = [map(x -> x[], (grads.v..., grads.s..., grads.v′..., grads.s′...))...]
    d̄ = [f̄.demand[] for f̄ in piece.flows]
    @test [x̄; d̄] ≈ ref
end

@testitem "Trace: the default is the state after the step" setup = [TraceChecks] begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    (; states_by_step) = TraceChecks
    # Redistribute keeps its arrivals as its state, so its trace is what
    # each stratum receives at each step.
    K = [0.0 0.3 0.1; 0.2 0.0 0.4; 0.1 0.2 0.0]
    r = Recurrence(
        [0.4, 0.6]; modifiers = (
            CR.Redistribute(CR.movement(K, 0.2)),
            CR.Depletion(PerStratum([50.0, 60.0, 70.0])),
        )
    )
    R, h = fill(1.8, 3, 6), [1.0 2.0; 2.0 1.0; 0.5 0.5]
    y, tr = r(R; history = h, trace = true)
    M1, M2 = tr.modifiers
    S1, S2 = states_by_step(r, R; history = h)
    @test M1 ≈ S1
    @test M2[1:3, :] ≈ S2
    @test CR.ntrace(CR.Redistribute(CR.movement(K, 0.2)), 3) == 3
    # A modifier whose state never changes records nothing.
    for m in (CR.Add(0.1), CR.Clamp(0.0, 5.0), CR.Allocate([1:3], 5.0))
        @test CR.ntrace(m, 3) == 0
        s = Recurrence([0.4, 0.6]; modifiers = (m, CR.Depletion(60.0)))
        _, tm = s(R; history = h, trace = true)
        @test size(first(tm.modifiers)) == (0, 6)
        @test size(last(tm.modifiers)) == (9, 6)
    end
end

# One item for the Mooncake gradients through traces, so the rules compiled
# for one loss are reused by the others.
@testitem "Trace: gradients through a trace and the default trace of user modifiers, the rule against ForwardDiff" setup = [ReferenceAD] begin
    using ComposableRecurrences, ForwardDiff, Mooncake
    using DifferentiationInterface: gradient, AutoMooncake
    CR = ComposableRecurrences
    # A pointwise modifier whose state decays and gathers what passes it.
    struct Decay{A}
        a::A
    end
    CR.blocks(::Decay) = (1, 1)
    CR.uses_adjoint(::Decay, ::CR.Step) = true
    CR.forward!(::Decay, ::CR.Init, s, history) = (fill!(s, 0); nothing)
    function CR.forward!(m::Decay, ::CR.Step, v, s, t)
        for k in eachindex(v, s)
            s[k] = m.a * s[k] + v[k]
        end
        return nothing
    end
    function CR.pullback!(grads, m::Decay, ::CR.Step, v, s, t)
        v̄, s̄ = grads.v, grads.s
        for k in eachindex(v, s)
            CR.add_cotangent!(CR.cotangent(grads.piece, :a), s̄[k] * s[k])
            v̄[k], s̄[k] = v̄[k] + s̄[k], m.a * s̄[k]
        end
        return nothing
    end
    # Two values and two state entries per group.
    struct Keep{A}
        a::A
    end
    CR.blocks(::Keep) = (2, 2)
    function CR.forward!(m::Keep, ::CR.Step, v::Tuple, s::Tuple, t, g)
        v1, v2, s1, s2 = v[1][], v[2][], s[1][], s[2][]
        v[1][], v[2][] = v1 * m.a, v2 + s1
        s[1][], s[2][] = s1 + v1, s2 + v2
        return nothing
    end
    function CR.pullback!(grads, m::Keep, ::CR.Step, v::Tuple, s::Tuple, t, g)
        v̄1, v̄2 = grads.v[1][], grads.v[2][]
        s̄1, s̄2 = grads.s[1][], grads.s[2][]
        CR.add_cotangent!(CR.cotangent(grads.piece, :a), v̄1 * v[1][])
        grads.v[1][], grads.v[2][] = v̄1 * m.a + s̄1, v̄2 + s̄2
        grads.s[1][], grads.s[2][] = v̄2 + s̄1, s̄2
        return nothing
    end
    @testset "built-in modifiers and flows" begin
        W = reshape(range(0.2, 1.8; length = 48), 6, 8)
        g, R, h = [0.3, 0.5, 0.2], fill(2.0, 2, 8), [5.0 4.0; 3.0 2.0]
        K = [0.0 0.3; 0.2 0.0]
        function loss(θ)
            leaky = CR.Depletion(
                PerStratum(θ[1:2]); pools = (:S, :V),
                form = CR.Hazard(), weights = (S = 1, V = θ[3]),
                flows = (
                    CR.Flow(:S => :V, θ[4]; form = CR.Truncate()), CR.Flow(:V => :S, θ[5]),
                )
            )
            # `Add` keeps no state, so its trace is empty and takes no cotangent.
            mods = (CR.Redistribute(CR.movement(K, θ[6])), CR.Add(θ[7]), leaky)
            _, tr = Recurrence(g; modifiers = mods)(R; history = h, trace = true)
            T1, T0, T2 = tr.modifiers
            return sum(W[1:2, :] .* T1) + sum(T0) + sum(W .* T2[3:8, :])
        end
        θ = [80.0, 120.0, 0.3, 2.0, 0.1, 0.2, 0.4]
        n = CR._PULLBACK_CALLS[]
        @test gradient(loss, AutoMooncake(), θ) ≈ ReferenceAD.gradient(loss, θ)
        @test CR._PULLBACK_CALLS[] > n
        # The flows' amounts, with a smooth count whose softness is a
        # parameter.
        function ward(θ)
            flows = CR.Depletion(;
                pools = (:A, :B), form = nothing, flows = (
                    CR.Flow(1 => 2, θ[1]), CR.Flow(1 => 0, θ[2]; form = CR.Share()),
                    CR.Flow(2 => 0, θ[3]; form = CR.SoftTruncate(θ[4])),
                    CR.Flow(2 => 1, θ[5]; form = CR.Truncate()),
                    CR.Flow(0 => 2, θ[6]; form = CR.Truncate()),
                )
            )
            r = Recurrence([1.0]; modifiers = (flows,))
            adm = [4.0 6.0 2.0 0.0 3.0 1.0; 0.0 0.0 0.0 0.0 0.0 0.0]
            y, tr = r(; history = zeros(2, 1), add = adm, trace = true)
            return sum(W[1:5, 1:6] .* only(tr.modifiers)) + sum(y)
        end
        θw = [0.3, 0.2, 1.5, 0.2, 0.4, 0.6]
        @test gradient(ward, AutoMooncake(), θw) ≈ ReferenceAD.gradient(ward, θw)
    end
    @testset "the default trace of user modifiers" begin
        g, R, h = [0.5, 0.5], [1.0 + 0.1 * sin(k + t) for k in 1:4, t in 1:6], ones(4, 2)
        W = reshape(range(0.2, 1.8; length = 72), 12, 6)
        # Pointwise modifiers only, so each stratum's pullback runs on its own;
        # `Add` keeps no state, so its trace takes no cotangent.
        function pointwise(θ)
            mods = (Decay(θ[1]), CR.Add(0.1), CR.Depletion(θ[2]))
            y, tr = Recurrence(g; modifiers = mods)(R; history = h, trace = true)
            T1, _, T2 = tr.modifiers
            return sum(W[1:4, :] .* T1) + sum(W .* T2) + sum(y)
        end
        function blockwise(θ)
            y, tr = Recurrence(g; modifiers = (Keep(θ[1]),))(R; history = h, trace = true)
            return sum(W[1:4, :] .* only(tr.modifiers)) + sum(y)
        end
        for (f, θ) in ((pointwise, [0.6, 80.0]), (blockwise, [0.8]))
            n = CR._PULLBACK_CALLS[]
            @test gradient(f, AutoMooncake(), θ) ≈ ReferenceAD.gradient(f, θ)
            @test CR._PULLBACK_CALLS[] > n
        end
    end
end

@testitem "Trace: user traces written in place, for each kind of step" setup = [ReferenceAD] begin
    using ComposableRecurrences, ForwardDiff, Mooncake
    using DifferentiationInterface: gradient, AutoMooncake
    CR = ComposableRecurrences
    # Pointwise: the smoothed value and what it leaves of the value, as
    # a tuple of series over the strata.
    struct Smoothing{A}
        a::A
    end
    CR.blocks(::Smoothing) = (1, 1)
    function CR.forward!(m::Smoothing, ::CR.Step, v, s, t)
        for k in eachindex(v, s)
            s[k] = m.a * s[k] + (1 - m.a) * v[k]
            v[k] = s[k]
        end
        return nothing
    end
    CR.ntrace(::Smoothing, S) = 2S
    function CR.forward!(m::Smoothing, ::CR.Trace, r, v, s, v′, s′, t)
        smoothed, left = r
        for k in eachindex(v)
            smoothed[k], left[k] = s′[k], v[k] - s′[k]
        end
        return nothing
    end
    function CR.pullback!(grads, m::Smoothing, ::CR.Trace, v, s, t)
        s̄′, r̄ = grads.trace
        for k in eachindex(v)
            grads.v[k] += r̄[k]
            grads.s′[k] += s̄′[k] - r̄[k]
        end
        return nothing
    end
    # Blockwise: two values and two state entries per group; its trace is
    # the group's total after the step.
    struct Pairs{A}
        a::A
    end
    CR.blocks(::Pairs) = (2, 2)
    function CR.forward!(m::Pairs, ::CR.Step, v::Tuple, s::Tuple, t, g)
        v1, v2, s1, s2 = v[1][], v[2][], s[1][], s[2][]
        v[1][], v[2][] = v1 * m.a, v2 + s1
        s[1][], s[2][] = s1 + v1, s2 + v2
        return nothing
    end
    function CR.pullback!(grads, m::Pairs, ::CR.Step, v::Tuple, s::Tuple, t, g)
        v̄1, v̄2 = grads.v[1][], grads.v[2][]
        s̄1, s̄2 = grads.s[1][], grads.s[2][]
        CR.add_cotangent!(CR.cotangent(grads.piece, :a), v̄1 * v[1][])
        grads.v[1][], grads.v[2][] = v̄1 * m.a + s̄1, v̄2 + s̄2
        grads.s[1][], grads.s[2][] = v̄2 + s̄1, s̄2
        return nothing
    end
    CR.ntrace(::Pairs, S) = S ÷ 2
    function CR.forward!(m::Pairs, ::CR.Trace, r::Tuple, v::Tuple, s::Tuple, v′::Tuple, s′::Tuple, t, g)
        only(r)[] = v′[1][] + v′[2][]
        return nothing
    end
    function CR.pullback!(grads, m::Pairs, ::CR.Trace, v::Tuple, s::Tuple, t, g)
        r̄ = only(grads.trace)[]
        grads.v′[1][] += r̄
        grads.v′[2][] += r̄
        return nothing
    end
    # Whole step: each value mixed with the mean, its trace the mean.
    struct Mean{B}
        b::B
    end
    function CR.forward!(m::Mean, ::CR.Step, v, s, t)
        μ = sum(v) / length(v)
        v .= (1 - m.b) .* v .+ m.b * μ
        return nothing
    end
    function CR.pullback!(grads, m::Mean, ::CR.Step, v, s, t)
        v̄ = grads.v
        μ, μ̄ = sum(v) / length(v), sum(v̄) / length(v)
        CR.add_cotangent!(CR.cotangent(grads.piece, :b), sum(v̄ .* (μ .- v)))
        v̄ .= (1 - m.b) .* v̄ .+ m.b * μ̄
        fill!(grads.s, zero(eltype(grads.s)))
        return nothing
    end
    CR.ntrace(::Mean, S) = 1
    function CR.forward!(m::Mean, ::CR.Trace, r, v, s, v′, s′, t)
        r[1] = sum(v) / length(v)
        return nothing
    end
    function CR.pullback!(grads, m::Mean, ::CR.Trace, v, s, t)
        grads.v .+= grads.trace[1] / length(v)
        return nothing
    end
    g, h = [0.5, 0.3], [1.0 2.0; 2.0 1.0; 1.5 0.5; 0.5 1.5]
    R = [1.0 + 0.1 * sin(k + t) for k in 1:4, t in 1:6]
    # The trace rows against the step run by hand.
    # The trace rows: the smoothed value is the output, and the two rows
    # sum to the value the step received.
    y, tr = Recurrence(g; modifiers = (Smoothing(0.6),))(R; history = h, trace = true)
    M = only(tr.modifiers)
    @test size(M) == (8, 6)
    @test M[1:4, :] ≈ y
    _, trm = Recurrence(g; modifiers = (Mean(0.3),))(R; history = h, trace = true)
    @test size(only(trm.modifiers)) == (1, 6)
    _, trp = Recurrence(g; modifiers = (Pairs(0.8),))(R; history = h, trace = true)
    @test size(only(trp.modifiers)) == (2, 6)
    for (mods, W) in (
            ((Smoothing(0.6), CR.Depletion(PerStratum(fill(80.0, 4)))), nothing),
            ((Pairs(0.8),), nothing),
            ((Mean(0.3), CR.Clamp(0.0, 9.0)), nothing),
        )
        f(θ) = begin
            ms = mods[1] isa Smoothing ? (Smoothing(θ[1]), Base.tail(mods)...) :
                mods[1] isa Pairs ? (Pairs(θ[1]),) : (Mean(θ[1]), Base.tail(mods)...)
            y, tr = Recurrence(g; modifiers = ms)(R; history = h, trace = true)
            sum(y) + sum(x -> sum(abs2, x), tr.modifiers)
        end
        θ = [0.6]
        n = CR._PULLBACK_CALLS[]
        @test gradient(f, AutoMooncake(), θ) ≈ ReferenceAD.gradient(f, θ)
        @test CR._PULLBACK_CALLS[] > n
    end
    # A trace that returns its values rather than writing them is an error.
    struct Returns end
    CR.blocks(::Returns) = (1, 1)
    CR.forward!(::Returns, ::CR.Step, v, s, t) = nothing
    CR.nstate(::Returns, S) = S
    CR.forward!(::Returns, ::CR.Trace, r, v, s, v′, s′, t) = (s′,)
    r = Recurrence(g; modifiers = (Returns(),))
    @test_throws r"returned a Tuple" r(R; history = h, trace = true)
end
