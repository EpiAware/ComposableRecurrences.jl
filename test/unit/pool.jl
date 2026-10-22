# A `Depletion` with removals and a second, protected pool: values and
# ForwardDiff gradients against a loop written from the maths, the limits
# that reduce to the base Depletion, conservation, and the pullbacks against
# a local ForwardDiff Jacobian of the Step.

@testmodule DepletionChecks begin
    using ComposableRecurrences, ForwardDiff
    const CR = ComposableRecurrences

    # A hazard renewal with an unprotected pool `S`, a protected pool `V` at
    # relative susceptibility `σ` and removals `r_t` from `S` into `V`:
    #   P = S + σ V, y = P (1 - exp(-v / N)),
    #   S ← S - y S / P - m, V ← V - y σ V / P + m, m = min(r_t, S),
    # with the draw from S alone once P is 0.
    function naive(g, R, h, N, σ, r; V0 = 0.0)
        L, T = length(g), length(R)
        Tp = promote_type(eltype(R), typeof(N), typeof(σ), eltype(r))
        y = zeros(Tp, L + T)
        y[1:L] .= h
        S, V = Tp(N), Tp(V0)
        for t in 1:T
            v = R[t] * sum(g[i] * y[L + t - i] for i in 1:L)
            P = S + σ * V
            y[L + t] = P * (1 - exp(-v / N))
            if P > 0
                S, V = S - y[L + t] * S / P, V - y[L + t] * σ * V / P
            else
                S -= y[L + t]
            end
            m = min(r[t], max(S, 0))
            S, V = S - m, V + m
        end
        return y[(L + 1):end]
    end

    # The output cotangents the pool steps' pullback checks seed, passed to
    # `ModifierChecks.check_pullback`.
    function seeds(v, s)
        return (; v̄ = [0.3 + 0.4k for k in eachindex(v)], s̄ = [-0.4 + 0.3k for k in eachindex(s)])
    end
end

@testitem "Depletion: no removals and no protected pool is the base" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    g, R, h = [0.3, 0.5, 0.2], fill(2.2, 12), [2.0, 3.0, 4.0]
    for form in (CR.Hazard(), CR.Floor())
        base = CR.Depletion(100.0; form)
        same = CR.Depletion(100.0; form, removals = nothing)
        @test typeof(same) == typeof(base)
        @test Recurrence(g; modifiers = (same,))(R; history = h) ==
            Recurrence(g; modifiers = (base,))(R; history = h)
    end
end

@testitem "Depletion: values and gradients against the maths" setup = [ReferenceAD, DepletionChecks] begin
    using ComposableRecurrences, ForwardDiff
    CR = ComposableRecurrences
    g, h = [0.3, 0.5, 0.2], [2.0, 3.0, 4.0]
    R = [2.5, 2.4, 2.2, 2.0, 1.8, 1.5, 1.2, 1.0, 1.1, 1.3]
    r = [0.0, 0.0, 5.0, 10.0, 10.0, 20.0, 20.0, 20.0, 30.0, 30.0]
    W = collect(range(0.5, 1.5; length = 10))
    function run(R, N, σ, r)
        d = CR.Depletion(N; protected = σ, removals = TimeVarying(r))
        return Recurrence(g; modifiers = (d,))(R; history = h)
    end
    @test run(R, 100.0, 0.3, r) ≈ DepletionChecks.naive(g, R, h, 100.0, 0.3, r)
    f(θ) = sum(W .* run(θ[1:10], θ[11], θ[12], θ[13:22]))
    fref(θ) = sum(W .* DepletionChecks.naive(g, θ[1:10], h, θ[11], θ[12], θ[13:22]))
    θ = vcat(R, 100.0, 0.3, r)
    @test ReferenceAD.gradient(f, θ) ≈ ReferenceAD.gradient(fref, θ)
    # Removals alone leave the pool: all-or-nothing with no protected pool.
    function only(R, r)
        d = CR.Depletion(100.0; removals = TimeVarying(r))
        return Recurrence(g; modifiers = (d,))(R; history = h)
    end
    @test only(R, r) ≈ DepletionChecks.naive(g, R, h, 100.0, 0.0, r)
    @test ReferenceAD.gradient(r -> sum(W .* only(R, r)), r) ≈
        ReferenceAD.gradient(r -> sum(W .* DepletionChecks.naive(g, R, h, 100.0, 0.0, r)), r)
end

@testitem "Depletion: full susceptibility undoes the protection" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    g, h = [0.3, 0.5, 0.2], [2.0 3.0 4.0; 1.0 1.0 2.0]
    R = fill(2.1, 2, 15)
    doses = TimeVarying(PerStratum(fill(4.0, 2, 15)))
    for form in (CR.Hazard(), CR.Floor()), α in (1.0, 1.5)
        N = PerStratum([100.0, 80.0])
        base = CR.Depletion(N; form, heterogeneity = α)
        full = CR.Depletion(
            N; form, protected = 1.0, heterogeneity = α, removals = doses
        )
        @test Recurrence(g; modifiers = (full,))(R; history = h) ≈
            Recurrence(g; modifiers = (base,))(R; history = h)
    end
end

@testitem "Depletion: conservation and final-size ordering" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    g, h, N = [0.3, 0.5, 0.2], [2.0, 3.0, 4.0], 500.0
    R = fill(2.4, 40)
    doses = vcat(zeros(5), fill(8.0, 35))
    d = CR.Depletion(
        N; pools = (S = N - sum(h), V = nothing), protected = 0.4,
        removals = TimeVarying(doses)
    )
    r = Recurrence(g; modifiers = (d,))
    for stop in (1, 7, 20, 40)
        y, st = r(R; history = h, stop, state = true)
        pools = only(st.states)
        @test sum(pools) + sum(y) ≈ N - sum(h)
    end
    # All-or-nothing (σ = 0, removals e ⋅ doses) protects more than leaky
    # (σ = 1 - e, removals doses) at the same efficacy.
    e = 0.7
    aon = CR.Depletion(N; protected = 0.0, removals = TimeVarying(e .* doses))
    leaky = CR.Depletion(N; protected = 1 - e, removals = TimeVarying(doses))
    none = CR.Depletion(N)
    size_of(d) = sum(Recurrence(g; modifiers = (d,))(R; history = h))
    @test size_of(aon) < size_of(leaky) < size_of(none)
end

@testitem "Depletion: pullbacks against a local Jacobian" setup = [ModifierChecks, DepletionChecks] begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    v = [2.0, 3.0, 1.5]
    # Removals only: a pointwise step on one pool, below and at the cap.
    for form in (CR.Hazard(), CR.Floor(), CR.Truncate()),
            s in ([80.0, 60.0, 40.0], [3.0, 60.0, 1.0])
        build(θ) = CR.Depletion(
            PerStratum(θ[1:3]); form, heterogeneity = θ[4],
            removals = TimeVarying(PerStratum(reshape(θ[5:10], 3, 2)))
        )
        θ = [100.0, 90.0, 70.0, 1.3, 5.0, 7.0, 2.0, 4.0, 6.0, 8.0]
        c = ModifierChecks.check_pullback(build, θ, v, s, 2)
        @test c.v && c.s && c.θ
    end
    # A protected pool: a vector step over both pools, with the draw from
    # both, from S alone (P ≤ 0) and removals at the cap.
    pools = (
        [80.0, 60.0, 40.0, 5.0, 10.0, 0.0],
        [3.0, 60.0, 1.0, 5.0, 10.0, 2.0],
        [-4.0, 60.0, 40.0, 1.0, 10.0, 0.0],
    )
    for form in (CR.Hazard(), CR.Floor(), CR.Truncate()), s in pools
        form isa CR.Hazard && s[1] < 0 && continue
        build(θ) = CR.Depletion(
            PerStratum(θ[1:3]); pools = (S = nothing, V = θ[5]), form,
            protected = PerStratum(θ[6:8]), heterogeneity = θ[4],
            removals = PerStratum(θ[9:11])
        )
        θ = [100.0, 90.0, 70.0, 1.3, 0.0, 0.3, 0.5, 0.0, 5.0, 7.0, 2.0]
        c = ModifierChecks.check_pullback(build, θ, v, s, 1; DepletionChecks.seeds(v, s)...)
        @test c.v && c.s && c.θ
    end
    # A protected pool without removals.
    build(θ) = CR.Depletion(
        θ[1]; pools = (S = nothing, V = θ[3]), protected = θ[4], heterogeneity = θ[2]
    )
    c = ModifierChecks.check_pullback(
        build, [100.0, 1.0, 0.0, 0.4], [2.0], [70.0, 20.0], 1;
        DepletionChecks.seeds([2.0], [70.0, 20.0])...
    )
    @test c.v && c.s && c.θ
end

@testitem "Depletion: an empty pool with a tangent under ForwardDiff" setup = [ReferenceAD, ModifierChecks, DepletionChecks] begin
    using ComposableRecurrences, ForwardDiff
    CR = ComposableRecurrences
    # A dual with value zero and non-zero partials compares above zero, so
    # the step must pick its arm on the value and not divide by zero.
    P = ForwardDiff.Dual(0.0, 1.0, 0.4)
    m = CR.Depletion(100.0; protected = 0.3)
    y, (S′, V′) = CR._draw_pools(m, 2.0, (P, zero(P)), 1, 1)
    @test all(isfinite, ForwardDiff.partials(S′))
    @test ForwardDiff.value(S′) == 0
    @test S′ == P - y
    @test V′ == 0
    # Both pools start empty with sizes set by parameters.
    g, h, R = [0.3, 0.5, 0.2], [5.0], fill(2.0, 6)
    W = collect(range(0.5, 1.5; length = 6))
    function f(θ)
        d = CR.Depletion(100.0; pools = (S = θ[1], V = θ[3]), protected = θ[2])
        return sum(W .* Recurrence(g; modifiers = (d,))(R; history = h))
    end
    ∇ = ReferenceAD.gradient(f, [0.0, 0.3, 0.0])
    @test all(isfinite, ∇)
    @test ∇[1] ≈ (f([1.0e-7, 0.3, 0.0]) - f([0.0, 0.3, 0.0])) / 1.0e-7 rtol = 1.0e-5
    # A seeded pool emptied by removals, with all-or-nothing protection.
    function fr(θ)
        d = CR.Depletion(
            100.0; pools = (S = θ[1], V = nothing), protected = θ[3],
            removals = TimeVarying(fill(θ[2], 6))
        )
        return sum(W .* Recurrence(g; modifiers = (d,))(R; history = h))
    end
    @test all(isfinite, ReferenceAD.gradient(fr, [3.0, 4.0, 0.0]))
    # The step's pullback at an empty pool against its local Jacobian.
    build(θ) = CR.Depletion(
        θ[1]; pools = (S = nothing, V = θ[3]), form = CR.Floor(), protected = θ[4],
        heterogeneity = θ[2]
    )
    c = ModifierChecks.check_pullback(
        build, [100.0, 1.0, 0.0, 0.4], [2.0], [0.0, 0.0], 1;
        DepletionChecks.seeds([2.0], [0.0, 0.0])...
    )
    @test c.v && c.s && c.θ
end

@testitem "Depletion: the initial state and its pullback" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    d = CR.Depletion(
        PerStratum([100.0, 50.0]);
        pools = (S = PerStratum([90.0, 45.0]), V = PerStratum([3.0, 4.0])),
        protected = 0.5, removals = 1.0
    )
    s = zeros(4)
    CR.forward!(d, CR.Init(), s, ones(2, 2))
    @test s == [90.0, 45.0, 3.0, 4.0]
    m̄ = (;
        N = (; x = zeros(2)), form = nothing, heterogeneity = nothing,
        pools = (S = (; x = zeros(2)), V = (; x = zeros(2))),
        weights = (S = nothing, V = Ref(0.0)),
        flows = ((; from = nothing, to = nothing, demand = Ref(0.0), form = nothing),),
    )
    grads = (; piece = m̄, s = [1.0, 2.0, 3.0, 4.0], history = zeros(2, 2))
    CR.pullback!(grads, d, CR.Init(), s, ones(2, 2))
    @test m̄.pools.S.x == [1.0, 2.0]
    @test m̄.pools.V.x == [3.0, 4.0]
    # The first pool's default start is the population at time 1.
    d = CR.Depletion(PerStratum([100.0, 50.0]); pools = (:S, :V))
    CR.forward!(d, CR.Init(), s, ones(2, 2))
    @test s == [100.0, 50.0, 0.0, 0.0]
    m̄ = (;
        N = (; x = zeros(2)), form = nothing, heterogeneity = nothing,
        pools = nothing, weights = nothing, flows = (),
    )
    CR.pullback!((; grads..., piece = m̄), d, CR.Init(), s, ones(2, 2))
    @test m̄.N.x == [1.0, 2.0]
end

@testitem "Depletion: a single-precision model stays in single precision" begin
    using ComposableRecurrences, Test
    CR = ComposableRecurrences
    g, R, h = Float32[0.2, 0.5, 0.3], fill(1.5f0, 1, 20), ones(Float32, 1, 3)
    pool(σ, V0) = CR.Depletion(
        100.0f0; pools = (S = nothing, V = V0), protected = σ, removals = 1.0f0
    )
    run(p) = Recurrence(g; modifiers = (p,))
    # The default starting pool is empty and takes the state's type.
    @test pool(0.5f0, nothing).pools === (S = nothing, V = nothing)
    for p in (
            pool(0.5f0, nothing), pool(0.5f0, 2.0f0),
            pool(PerStratum([0.5f0]), PerStratum([2.0f0])),
        )
        r = run(p)
        @test eltype(@inferred r(R; history = h)) == Float32
        y, st = r(R; history = h, stop = 10, state = true)
        @test eltype(y) == Float32
        @test eltype(first(r(R; state = st))) == Float32
    end
    # The empty default gives the same values as an explicit empty pool.
    @test run(pool(0.5f0, nothing))(R; history = h) ==
        run(pool(0.5f0, 0.0f0))(R; history = h)
    # A given starting pool is converted to a float.
    @test pool(0.5, 1).pools.V === 1.0
end

@testitem "Depletion: many flows infer" begin
    using ComposableRecurrences, Test
    using ComposableRecurrences: Flow, Depletion
    # Past 32 flows, where `map` over a tuple and a recursion over the flows
    # stop inferring.
    function pool(::Val{n}) where {n}
        ring = (:A, :B, :C, :D)
        fs = ntuple(i -> Flow(ring[mod1(i, 4)] => ring[mod1(i + 1, 4)], 0.001i), Val(n))
        return Depletion(
            1000.0; pools = NamedTuple{ring}((900.0, 50.0, 30.0, 20.0)), flows = fs
        )
    end
    for n in (32, 33, 64)
        p = @inferred pool(Val(n))
        @test length(p.flows) == n
        r = Recurrence([0.3, 0.2, 0.1]; modifiers = (p,))
        @test eltype(@inferred r(fill(2.0, 20); history = [1.0, 1.0, 1.0])) == Float64
    end
end

@testitem "Depletion: checks its arguments" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    @test_throws ArgumentError CR.Depletion(100.0; removals = [1.0, 2.0])
    two(w) = CR.Depletion(100.0; pools = (:S, :V), weights = (S = 1, V = w))
    @test_throws "it does not vary over time" two(TimeVarying([0.1, 0.2]))
    @test_throws ArgumentError two([0.1, 0.2])
    d = CR.Depletion(100.0; removals = TimeVarying([1.0, 2.0]))
    @test_throws DimensionMismatch Recurrence([0.5]; modifiers = (d,))(
        fill(1.1, 3); history = [1.0]
    )
    d = CR.Depletion(100.0; protected = PerStratum([0.1, 0.2, 0.3]))
    @test_throws DimensionMismatch Recurrence([0.5]; modifiers = (d,))(
        fill(1.1, 2, 3); history = ones(2, 1)
    )
    for dp in (
            CR.Depletion(100.0; removals = PerStratum([1.0, 2.0, 3.0])),
            CR.Depletion(100.0; protected = 0.5, removals = PerStratum([1.0, 2.0, 3.0])),
        )
        @test_throws DimensionMismatch Recurrence([0.5]; modifiers = (dp,))(
            fill(1.1, 2, 3); history = ones(2, 1)
        )
    end
    # The pools, weights and fill by name.
    @test_throws "pools is a named tuple of starting values" CR.Depletion(
        100.0; pools = ()
    )
    @test_throws "pools is a named tuple of starting values" CR.Depletion(
        100.0; pools = (:S, :S)
    )
    @test_throws "pools is a named tuple of starting values" CR.Depletion(
        100.0; pools = 2
    )
    @test_throws "pools is a named tuple of starting values" CR.Depletion(
        100.0; pools = (;)
    )
    @test_throws "weights is a named tuple of weights of the pools (:S,)" CR.Depletion(
        100.0; weights = (X = 1,)
    )
    @test_throws "weights is a named tuple of weights of the pools (:S, :V)" CR.Depletion(
        100.0; pools = (:S, :V), weights = (X = 1,)
    )
    @test_throws "weights is a named tuple" CR.Depletion(
        100.0; pools = (:S, :V), weights = (;)
    )
    @test_throws "weights is a named tuple" CR.Depletion(
        100.0; pools = (:S, :V), weights = (1, 0.5)
    )
    @test_throws "the draw names pool :X, but the pools are (:O,)" CR.Depletion(
        10.0; pools = (:O,), form = CR.Truncate(), fill = :X
    )
    @test_throws "the draw names pool \"O\", but the pools are (:O,)" CR.Depletion(
        10.0; pools = (:O,), form = CR.Truncate(), fill = "O"
    )
    @test_throws "the draw names pool 2, but the pools are (:O,)" CR.Depletion(
        10.0; pools = (:O,), form = CR.Truncate(), fill = 2
    )
    @test_throws "one pool is drawn with weight 1, got 0.5" CR.Depletion(
        100.0; weights = (S = 0.5,)
    )
    @test_throws "one pool is drawn with weight 1, got 2" CR.Depletion(
        100.0; weights = (S = 2,)
    )
    # A draw fills a pool or takes from weighted ones, and protection sets
    # the weights of two pools.
    @test_throws "a draw fills a pool or takes from weighted pools, not both" CR.Depletion(
        10.0; pools = (:O, :P), form = CR.Truncate(), fill = :O, weights = (O = 1,)
    )
    @test_throws "a draw fills a pool or takes from weighted pools, not both" CR.Depletion(
        10.0; form = CR.Truncate(), fill = :S, protected = 0.3
    )
    @test_throws "protected sets the weights, so give one of them" CR.Depletion(
        100.0; protected = 0.3, weights = (S = 1, V = 0.3)
    )
    @test_throws "a protected Depletion holds two pools, got (:S,)" CR.Depletion(
        100.0; pools = (S = 90.0,), protected = 0.3
    )
    # Without a draw nothing shapes one, and the history starts the pools.
    for kw in (
            (; weights = (S = 1,)), (; fill = :S), (; heterogeneity = 1.5),
            (; protected = 0.3), (; flows_first = true), (; overflow = :queue),
        )
        @test_throws "shape a draw, and form = nothing has none" CR.Depletion(;
            pools = (:S,), form = nothing, kw...
        )
    end
    @test_throws "the history gives their start, not pools" CR.Depletion(;
        pools = (S = 1.0,), form = nothing
    )
    @test_throws "overflow is nothing, :queue or :stratum, got :x" CR.Depletion(
        100.0; overflow = :x
    )
    @test_throws "overflow is nothing, :queue or :stratum" CR.Depletion(
        100.0; overflow = 1
    )
    @test_throws "flows is a Flow, or a tuple or vector of Flows" CR.Depletion(
        100.0; flows = 1
    )
    @test_throws "pools is non-negative, got -1.0" CR.Depletion(
        100.0; pools = (S = -1.0,)
    )
    @test_throws "a Hazard() draw reads the population, so give N" CR.Depletion()
    @test_throws "a draw into a pool fills it up to N, so give N" CR.Depletion(;
        form = CR.Truncate(), fill = :S
    )
    @test_throws "a draw into a pool is Truncate() or SoftTruncate(κ)" CR.Depletion(
        10.0; form = CR.Hazard(), fill = :S
    )
    # A weight of an integer is fixed, a float one a parameter.
    @test last(two(0).weights) === 0
    @test last(two(2).weights) === 2
    @test last(two(true).weights) === 1
    @test last(two(0.5).weights) === 0.5
    @test last(two(1.0f0).weights) === 1.0f0
    # The checks on fields given directly.
    @test_throws "the flows name pool 2, but there is 1 pool" CR.Depletion(
        100.0, CR.Hazard(), CR._FixedExponent{true}(), (S = nothing,), (S = 1,),
        (CR.Flow(1, 2, 0.1, CR.Hazard()),), CR._DrawFrom(1), CR._FlowsAfter(),
        CR._Drop()
    )
    @test_throws "the draw names pool 2 of 1" CR.Depletion(
        100.0, CR.Hazard(), CR._FixedExponent{true}(), (S = nothing,), (S = 1,),
        (), CR._DrawFrom(2), CR._FlowsAfter(), CR._Drop()
    )
    @test_throws "the draw names pool 0 of 1" CR.Depletion(
        100.0, CR.Truncate(), CR._FixedExponent{true}(), (S = nothing,), nothing,
        (), CR._DrawInto(0), CR._FlowsAfter(), CR._Drop()
    )
    # One pool with no flows.
    p = CR.Depletion(100.0; pools = (S = 80.0,), flows = nothing)
    @test p.pools == (S = 80.0,)
    @test p.flows == ()
end

@testitem "Depletion: the draw, order and overflow as fields" begin
    using ComposableRecurrences, Test
    CR = ComposableRecurrences
    d = CR.Depletion(100.0)
    @test d.pools === (S = nothing,)
    @test d.weights === (S = 1,)
    @test d.draw === CR._DrawFrom(1)
    @test d.order === CR._FlowsAfter()
    @test d.overflow === CR._Drop()
    @test CR.ispointwise(d)
    # The weights cover every pool, zero where unnamed, and the draw takes
    # first from the first pool they name.
    d = CR.Depletion(100.0; pools = (:S, :V, :R), weights = (V = 0.5, S = 1))
    @test d.weights === (S = 1, V = 0.5, R = 0)
    @test d.draw === CR._DrawFrom(2)
    @test CR.blocks(d) === (1, 3)
    # A protected pool, and a pool that fills.
    d = CR.Depletion(100.0; protected = 0.3, removals = 2.0)
    @test d.pools === (S = nothing, V = nothing)
    @test d.weights === (S = 1, V = 0.3)
    @test only(d.flows).from == 1 && only(d.flows).to == 2
    d = CR.Depletion(
        10.0; pools = (:O,), form = CR.Truncate(), fill = :O, flows_first = true,
        overflow = :stratum
    )
    @test d.weights === nothing
    @test d.draw === CR._DrawInto(1)
    @test d.order === CR._FlowsFirst()
    @test d.overflow === CR._ToStratum()
    @test CR.blocks(d) === (2, 1)
    @test CR.blocks(CR.Depletion(10.0; overflow = :queue)) === (1, 2)
    @test CR.Depletion(10.0; overflow = :queue).overflow === CR._Queue()
    # Without a draw.
    d = CR.Depletion(; pools = (:A, :B), form = nothing, flows = CR.Flow(:A => :B, 0.3))
    @test d.draw === nothing && d.weights === nothing && d.heterogeneity === nothing
    @test CR.blocks(d) === (2, 2)
end

@testitem "Depletion: the decided spellings infer" begin
    using ComposableRecurrences, Test
    # Imported by name: a global alias of the module would not infer.
    using ComposableRecurrences: Depletion, Flow, Truncate, blocks, _DrawInto
    leaky(N, σ) = Depletion(N; pools = (S = N, V = 0.0), weights = (S = 1, V = σ))
    d = @inferred leaky(1000.0, 0.3)
    @test d.pools === (S = 1000.0, V = 0.0)
    @test d.weights === (S = 1, V = 0.3)
    protected(N, σ, r) = Depletion(N; protected = σ, removals = r)
    d = @inferred protected(1000.0, 0.3, 5.0)
    @test d.weights === (S = 1, V = 0.3)
    @test @inferred(blocks(d)) === (1, 2)
    beds(C) = Depletion(
        C; pools = (:O,), form = Truncate(), fill = :O, overflow = :stratum
    )
    @test (@inferred beds(10.0)).draw === _DrawInto(1)
    ward() = Depletion(; pools = (:U, :C), form = nothing, flows = Flow(:U => :C, 0.3))
    @test (@inferred ward()).flows[1].to == 2
    # The two-pool form gives the same values as the protected one.
    r(d) = Recurrence([0.3, 0.5, 0.2]; modifiers = (d,))(fill(2.0, 8); history = [5.0])
    @test r(leaky(1000.0, 0.3)) == r(protected(1000.0, 0.3, nothing))
end

@testitem "Depletion: declare their adjoint" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    doses = TimeVarying([1.0, 2.0])
    for d in (
            CR.Depletion(100.0; removals = doses),
            CR.Depletion(100.0; form = CR.Floor(), protected = 0.3),
            CR.Depletion(100.0; protected = 0.3, removals = doses),
        )
        @test CR.uses_adjoint(d, CR.Step())
        @test CR.uses_adjoint(Recurrence([0.5, 0.5]; modifiers = (d,)), CR.Run())
    end
    # Without a draw there is no form for the rule to rebuild.
    ward = CR.Depletion(; pools = (:A, :B), form = nothing, flows = CR.Flow(1 => 2, 0.3))
    @test CR.uses_adjoint(ward, CR.Step())
    @test CR._local_modifier(ward) == ()
end

@testitem "Depletion: the Recurrence reverse pass" setup = [AdjointCheck] begin
    using ComposableRecurrences
    rng = Xoshiro(12)
    S, L, T = 2, 3, 6
    g = rand(rng, L) ./ 2
    K = [0.4 0.1; 0.2 0.3]
    h = 1 .+ rand(rng, S, L)
    R = 1.5 .+ rand(rng, S, T)
    doses = TimeVarying(PerStratum(1 .+ rand(rng, S, T)))
    mods = (
        CR.Depletion(PerStratum([60.0, 80.0]); removals = doses),
        CR.Depletion(
            PerStratum([60.0, 80.0]); pools = (S = nothing, V = 2.0),
            protected = PerStratum([0.3, 0.5]), removals = doses
        ),
        CR.Depletion(
            70.0; pools = (S = 65.0, V = nothing), form = CR.Floor(), protected = 0.2,
            heterogeneity = 1.3, removals = TimeVarying(rand(rng, T))
        ),
        CR.Depletion(70.0; pools = (S = nothing, V = 10.0), protected = 0.4),
        # Both pools start empty.
        CR.Depletion(
            70.0; pools = (S = 0.0, V = nothing), form = CR.Floor(), protected = 0.4
        ),
        # Without a population: a truncated draw reads none.
        CR.Depletion(; pools = (S = PerStratum([30.0, 40.0]),), form = CR.SoftTruncate(0.5)),
    )
    for m in mods
        r = Recurrence(g; coupling = K, modifiers = (m, CR.Add(0.1)))
        @test pullback_matches(r, recargs(R, nothing, h)...)
        @test pullback_matches(CR._WithState(r), recargs(R, nothing, h)...)
    end
    # Resumed from given states: two pools per stratum.
    r = Recurrence(g; coupling = K, modifiers = (mods[2],))
    states = ([40.0, 70.0, 5.0, 3.0],)
    @test pullback_matches(r, recargs(R, nothing, h; states)...)
end

@testitem "Depletion: the removal picks its arm as its pullback does" begin
    using ComposableRecurrences, ForwardDiff
    CR = ComposableRecurrences
    using ForwardDiff: Dual, partials
    xs = (-1.0, -0.0, 0.0, 3.0, 4.0, NaN)
    for r in xs, s in xs
        # Float64 values match `min(r, max(s, 0))` bit for bit; a NaN
        # in either input is returned.
        @test isequal(CR._removal(r, s), min(r, max(s, zero(s))))
        r̄, s̄ = CR._removal_pullback(r, s, 1.0)
        for ṙ in (1.0, -1.0), ṡ in (1.0, -1.0)
            m = CR._removal(Dual(r, ṙ), Dual(s, ṡ))
            @test partials(m)[1] == r̄ * ṙ + s̄ * ṡ
        end
    end
    @test CR._removal(false, 2.0) === 0.0
    @test (@inferred CR._removal(false, 2.0f0)) === 0.0f0
    @test (@inferred CR._removal(1.0, Dual(0.0, 1.0))) isa Dual
    # A NaN removal reaches the trajectory.
    d = CR.Depletion(100.0; pools = (S = 3.0,), removals = TimeVarying(fill(NaN, 6)))
    y = Recurrence([0.3, 0.5, 0.2]; modifiers = (d,))(fill(2.0, 6); history = [5.0])
    @test any(isnan, y)
end

@testitem "Depletion: removals at an empty pool, reverse against ForwardDiff" setup = [AdjointCheck] begin
    using ComposableRecurrences
    g, h, R = [0.3, 0.5, 0.2], [5.0], fill(2.0, 6)
    # A seeded pool emptied by removals; with all-or-nothing protection the
    # pool stays at zero with a tangent from `σ`, a tie in the removal.
    doses = TimeVarying(fill(4.0, 6))
    for d in (
            CR.Depletion(100.0; pools = (S = 3.0,), removals = doses),
            CR.Depletion(
                100.0; pools = (S = 3.0, V = nothing), protected = 0.0, removals = doses
            ),
        )
        r = Recurrence(g; modifiers = (d,))
        @test pullback_matches(r, recargs(R, nothing, h)...)
    end
end
