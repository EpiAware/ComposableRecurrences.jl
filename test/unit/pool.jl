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
        base = CR.Depletion(100.0, form)
        same = CR.Depletion(100.0, form; pools = nothing)
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
        d = CR.Depletion(
            N, CR.Hazard(; weights = (S = 1, V = σ)),
            CR.Flow(:S => :V, TimeVarying(r); form = CR.Truncate()); pools = (:S, :V)
        )
        return Recurrence(g; modifiers = (d,))(R; history = h)
    end
    @test run(R, 100.0, 0.3, r) ≈ DepletionChecks.naive(g, R, h, 100.0, 0.3, r)
    f(θ) = sum(W .* run(θ[1:10], θ[11], θ[12], θ[13:22]))
    fref(θ) = sum(W .* DepletionChecks.naive(g, θ[1:10], h, θ[11], θ[12], θ[13:22]))
    θ = vcat(R, 100.0, 0.3, r)
    @test ReferenceAD.gradient(f, θ) ≈ ReferenceAD.gradient(fref, θ)
    # Removals alone leave the pool: all-or-nothing with no protected pool.
    function only(R, r)
        d = CR.Depletion(
            100.0, CR.Hazard(), CR.Flow(:S => 0, TimeVarying(r); form = CR.Truncate())
        )
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
    for form in (CR.Hazard, CR.Floor), α in (1.0, 1.5)
        N = PerStratum([100.0, 80.0])
        base = CR.Depletion(N, form(α))
        full = CR.Depletion(
            N, form(α; weights = (S = 1, V = 1.0)),
            CR.Flow(:S => :V, doses; form = CR.Truncate()); pools = (:S, :V)
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
        N, CR.Hazard(; weights = (S = 1, V = 0.4)),
        CR.Flow(:S => :V, TimeVarying(doses); form = CR.Truncate());
        pools = (S = N - sum(h), V = nothing)
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
    aon = CR.Depletion(
        N, CR.Hazard(; weights = (S = 1, V = 0.0)),
        CR.Flow(:S => :V, TimeVarying(e .* doses); form = CR.Truncate());
        pools = (:S, :V)
    )
    leaky = CR.Depletion(
        N, CR.Hazard(; weights = (S = 1, V = 1 - e)),
        CR.Flow(:S => :V, TimeVarying(doses); form = CR.Truncate()); pools = (:S, :V)
    )
    none = CR.Depletion(N)
    size_of(d) = sum(Recurrence(g; modifiers = (d,))(R; history = h))
    @test size_of(aon) < size_of(leaky) < size_of(none)
end

@testitem "Depletion: pullbacks against a local Jacobian" setup = [ModifierChecks, DepletionChecks] begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    v = [2.0, 3.0, 1.5]
    # The draw's form with the exponent `α` and the draw's keywords; the
    # truncated forms read no exponent.
    drawn(form, α; kw...) = form === CR.Truncate ? form(; kw...) : form(α; kw...)
    # The mirror's leaves in the order of `θ`, with a zero for the exponent
    # of a form without one.
    flatten(m̄) = ModifierChecks.flat_pool(m̄; pad = true)
    # Removals only: a pointwise step on one pool, below and at the cap.
    for form in (CR.Hazard, CR.Floor, CR.Truncate),
            s in ([80.0, 60.0, 40.0], [3.0, 60.0, 1.0])
        build(θ) = CR.Depletion(
            PerStratum(θ[1:3]), drawn(form, θ[4]),
            CR.Flow(
                :S => 0, TimeVarying(PerStratum(reshape(θ[5:10], 3, 2)));
                form = CR.Truncate()
            )
        )
        θ = [100.0, 90.0, 70.0, 1.3, 5.0, 7.0, 2.0, 4.0, 6.0, 8.0]
        c = ModifierChecks.check_pullback(build, θ, v, s, 2; flatten)
        @test c.v && c.s && c.θ
    end
    # A protected pool: a vector step over both pools, with the draw from
    # both, from S alone (P ≤ 0) and removals at the cap.
    pools = (
        [80.0, 60.0, 40.0, 5.0, 10.0, 0.0],
        [3.0, 60.0, 1.0, 5.0, 10.0, 2.0],
        [-4.0, 60.0, 40.0, 1.0, 10.0, 0.0],
    )
    for form in (CR.Hazard, CR.Floor, CR.Truncate), s in pools
        form === CR.Hazard && s[1] < 0 && continue
        build(θ) = CR.Depletion(
            PerStratum(θ[1:3]),
            drawn(form, θ[4]; weights = (S = 1, V = PerStratum(θ[6:8]))),
            CR.Flow(:S => :V, PerStratum(θ[9:11]); form = CR.Truncate());
            pools = (S = nothing, V = θ[5])
        )
        θ = [100.0, 90.0, 70.0, 1.3, 0.0, 0.3, 0.5, 0.0, 5.0, 7.0, 2.0]
        c = ModifierChecks.check_pullback(
            build, θ, v, s, 1; flatten, DepletionChecks.seeds(v, s)...
        )
        @test c.v && c.s && c.θ
    end
    # A protected pool without removals.
    build(θ) = CR.Depletion(
        θ[1], CR.Hazard(θ[2]; weights = (S = 1, V = θ[4]));
        pools = (S = nothing, V = θ[3])
    )
    c = ModifierChecks.check_pullback(
        build, [100.0, 1.0, 0.0, 0.4], [2.0], [70.0, 20.0], 1;
        flatten = ModifierChecks.flat_pool, DepletionChecks.seeds([2.0], [70.0, 20.0])...
    )
    @test c.v && c.s && c.θ
end

@testitem "Depletion: an empty pool with a tangent under ForwardDiff" setup = [ReferenceAD, ModifierChecks, DepletionChecks] begin
    using ComposableRecurrences, ForwardDiff
    CR = ComposableRecurrences
    # A dual with value zero and non-zero partials compares above zero, so
    # the step must pick its arm on the value and not divide by zero.
    P = ForwardDiff.Dual(0.0, 1.0, 0.4)
    m = CR.Depletion(100.0, CR.Hazard(; weights = (S = 1, V = 0.3)); pools = (:S, :V))
    y, (S′, V′) = CR._draw_pools(m.pieces[1], 2.0, (P, zero(P)), 1, 1)
    @test all(isfinite, ForwardDiff.partials(S′))
    @test ForwardDiff.value(S′) == 0
    @test S′ == P - y
    @test V′ == 0
    # Both pools start empty with sizes set by parameters.
    g, h, R = [0.3, 0.5, 0.2], [5.0], fill(2.0, 6)
    W = collect(range(0.5, 1.5; length = 6))
    function f(θ)
        d = CR.Depletion(
            100.0, CR.Hazard(; weights = (S = 1, V = θ[2])); pools = (S = θ[1], V = θ[3])
        )
        return sum(W .* Recurrence(g; modifiers = (d,))(R; history = h))
    end
    ∇ = ReferenceAD.gradient(f, [0.0, 0.3, 0.0])
    @test all(isfinite, ∇)
    @test ∇[1] ≈ (f([1.0e-7, 0.3, 0.0]) - f([0.0, 0.3, 0.0])) / 1.0e-7 rtol = 1.0e-5
    # A seeded pool emptied by removals, with all-or-nothing protection.
    function fr(θ)
        d = CR.Depletion(
            100.0, CR.Hazard(; weights = (S = 1, V = θ[3])),
            CR.Flow(:S => :V, TimeVarying(fill(θ[2], 6)); form = CR.Truncate());
            pools = (S = θ[1], V = nothing)
        )
        return sum(W .* Recurrence(g; modifiers = (d,))(R; history = h))
    end
    @test all(isfinite, ReferenceAD.gradient(fr, [3.0, 4.0, 0.0]))
    # The step's pullback at an empty pool against its local Jacobian.
    build(θ) = CR.Depletion(
        θ[1], CR.Floor(θ[2]; weights = (S = 1, V = θ[4]));
        pools = (S = nothing, V = θ[3])
    )
    c = ModifierChecks.check_pullback(
        build, [100.0, 1.0, 0.0, 0.4], [2.0], [0.0, 0.0], 1;
        flatten = ModifierChecks.flat_pool, DepletionChecks.seeds([2.0], [0.0, 0.0])...
    )
    @test c.v && c.s && c.θ
end

@testitem "Depletion: the initial state and its pullback" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    d = CR.Depletion(
        PerStratum([100.0, 50.0]), CR.Hazard(; weights = (S = 1, V = 0.5)),
        CR.Flow(:S => :V, 1.0; form = CR.Truncate());
        pools = (S = PerStratum([90.0, 45.0]), V = PerStratum([3.0, 4.0]))
    )
    s = zeros(4)
    CR.forward!(d, CR.Init(), s, ones(2, 2))
    @test s == [90.0, 45.0, 3.0, 4.0]
    m̄ = (;
        pools = (S = (; x = zeros(2)), V = (; x = zeros(2))),
        pieces = (
            (;
                form = nothing, N = (; x = zeros(2)),
                weights = (S = nothing, V = Ref(0.0)), first = nothing, overflow = nothing,
            ),
            ((; from = nothing, to = nothing, demand = Ref(0.0), form = nothing),),
        ),
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
        pools = nothing,
        pieces = (
            (;
                form = nothing, N = (; x = zeros(2)), weights = nothing, first = nothing,
                overflow = nothing,
            ),
        ),
    )
    CR.pullback!((; grads..., piece = m̄), d, CR.Init(), s, ones(2, 2))
    @test m̄.pieces[1].N.x == [1.0, 2.0]
end

@testitem "Depletion: a single-precision model stays in single precision" begin
    using ComposableRecurrences, Test
    CR = ComposableRecurrences
    g, R, h = Float32[0.2, 0.5, 0.3], fill(1.5f0, 1, 20), ones(Float32, 1, 3)
    pool(σ, V0) = CR.Depletion(
        100.0f0, CR.Hazard(; weights = (S = 1, V = σ)),
        CR.Flow(:S => :V, 1.0f0; form = CR.Truncate()); pools = (S = nothing, V = V0)
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
    using ComposableRecurrences: Flow, Depletion, Hazard
    # Past 32 flows, where `map` over a tuple and a recursion over the flows
    # stop inferring.
    function pool(::Val{n}) where {n}
        ring = (:A, :B, :C, :D)
        fs = ntuple(i -> Flow(ring[mod1(i, 4)] => ring[mod1(i + 1, 4)], 0.001i), Val(n))
        return Depletion(
            1000.0, Hazard(), fs...; pools = NamedTuple{ring}((900.0, 50.0, 30.0, 20.0))
        )
    end
    for n in (32, 33, 64)
        p = @inferred pool(Val(n))
        @test length(p.pieces[2]) == n
        r = Recurrence([0.3, 0.2, 0.1]; modifiers = (p,))
        @test eltype(@inferred r(fill(2.0, 20); history = [1.0, 1.0, 1.0])) == Float64
    end
end

@testitem "Depletion: checks its arguments" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    # A count out of the first pool, as removals were spelt.
    removals(r) = CR.Flow(:S => 0, r; form = CR.Truncate())
    @test_throws ArgumentError CR.Depletion(100.0, CR.Hazard(), removals([1.0, 2.0]))
    two(w) = CR.Depletion(100.0, CR.Hazard(; weights = (S = 1, V = w)); pools = (:S, :V))
    @test_throws "it does not vary over time" two(TimeVarying([0.1, 0.2]))
    @test_throws ArgumentError two([0.1, 0.2])
    d = CR.Depletion(100.0, CR.Hazard(), removals(TimeVarying([1.0, 2.0])))
    @test_throws DimensionMismatch Recurrence([0.5]; modifiers = (d,))(
        fill(1.1, 3); history = [1.0]
    )
    d = two(PerStratum([0.1, 0.2, 0.3]))
    @test_throws DimensionMismatch Recurrence([0.5]; modifiers = (d,))(
        fill(1.1, 2, 3); history = ones(2, 1)
    )
    for dp in (
            CR.Depletion(100.0, CR.Hazard(), removals(PerStratum([1.0, 2.0, 3.0]))),
            CR.Depletion(
                100.0, CR.Hazard(; weights = (S = 1, V = 0.5)),
                CR.Flow(:S => :V, PerStratum([1.0, 2.0, 3.0]); form = CR.Truncate());
                pools = (:S, :V)
            ),
        )
        @test_throws DimensionMismatch Recurrence([0.5]; modifiers = (dp,))(
            fill(1.1, 2, 3); history = ones(2, 1)
        )
    end
    # The pools, weights and the pool a draw fills by name.
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
        100.0, CR.Hazard(; weights = (X = 1,))
    )
    @test_throws "weights is a named tuple of weights of the pools (:S, :V)" CR.Depletion(
        100.0, CR.Hazard(; weights = (X = 1,)); pools = (:S, :V)
    )
    @test_throws "weights is a named tuple" CR.Depletion(
        100.0, CR.Hazard(; weights = (;)); pools = (:S, :V)
    )
    @test_throws "weights is a named tuple" CR.Depletion(
        100.0, CR.Hazard(; weights = (1, 0.5)); pools = (:S, :V)
    )
    @test_throws "the draw names pool :X, but the pools are (:O,)" CR.Depletion(
        10.0, CR.Truncate(; into = :X); pools = (:O,)
    )
    @test_throws "the draw names pool \"O\", but the pools are (:O,)" CR.Depletion(
        10.0, CR.Truncate(; into = "O"); pools = (:O,)
    )
    @test_throws "the draw names pool 2, but the pools are (:O,)" CR.Depletion(
        10.0, CR.Truncate(; into = 2); pools = (:O,)
    )
    @test_throws "one pool is drawn with weight 1, got 0.5" CR.Depletion(
        100.0, CR.Hazard(; weights = (S = 0.5,))
    )
    @test_throws "one pool is drawn with weight 1, got 2" CR.Depletion(
        100.0, CR.Hazard(; weights = (S = 2,))
    )
    # A draw fills a pool or takes from weighted ones, and the weights name
    # only pools there are.
    @test_throws "a draw fills a pool or takes from weighted pools, not both" CR.Depletion(
        10.0, CR.Truncate(; into = :O, weights = (O = 1,)); pools = (:O, :P)
    )
    @test_throws "a draw fills a pool or takes from weighted pools, not both" CR.Depletion(
        10.0, CR.Truncate(; into = :S, weights = (S = 1, V = 0.3)); pools = (:S, :V)
    )
    @test_throws "one draw at most has overflow = :queue" CR.Depletion(
        100.0, CR.Hazard(; overflow = :queue), CR.Truncate(; overflow = :queue)
    )
    @test_throws "weights is a named tuple of weights of the pools (:S,)" CR.Depletion(
        100.0, CR.Hazard(; weights = (S = 1, V = 0.3)); pools = (S = 90.0,)
    )
    # A piece is a draw or a flow, and without a draw the history starts the
    # pools.
    for x in ((S = 1,), :S, 1.5, nothing, true, :queue)
        @test_throws "is not a draw or a Flow" CR.Depletion(
            CR.Flow(:S => 0, 0.1), x; pools = (:S,)
        )
    end
    @test_throws "the history gives their start, not pools" CR.Depletion(
        CR.Flow(:S => 0, 0.1); pools = (S = 1.0,)
    )
    @test_throws "overflow is nothing, :queue or :stratum, got :x" CR.Depletion(
        100.0, CR.Hazard(; overflow = :x)
    )
    @test_throws "overflow is nothing, :queue or :stratum" CR.Depletion(
        100.0, CR.Hazard(; overflow = 1)
    )
    @test_throws "1 is not a draw or a Flow" CR.Depletion(100.0, CR.Hazard(), 1)
    @test_throws "pools is non-negative, got -1.0" CR.Depletion(
        100.0; pools = (S = -1.0,)
    )
    @test_throws "a Hazard() draw reads the population, so give N" CR.Depletion()
    @test_throws "a draw into a pool fills it up to N, so give N" CR.Depletion(
        CR.Truncate(; into = :S)
    )
    @test_throws "a draw into a pool is Truncate() or SoftTruncate(κ)" CR.Depletion(
        10.0, CR.Hazard(; into = :S)
    )
    # A weight of an integer is fixed, a float one a parameter.
    weights(d) = d.pieces[1].weights
    @test last(weights(two(0))) === 0
    @test last(weights(two(2))) === 2
    @test last(weights(two(true))) === 1
    @test last(weights(two(0.5))) === 0.5
    @test last(weights(two(1.0f0))) === 1.0f0
    # The checks on fields given directly.
    @test_throws "the flows name pool 2, but there is 1 pool" CR._Depletion(
        (S = nothing,), (
            CR._DrawFrom(CR.Hazard(), 100.0, (S = 1,), 1, CR._Drop()),
            (CR.Flow(1, 2, 0.1, CR.Hazard()),),
        )
    )
    @test_throws "the draw names pool 2 of 1" CR._Depletion(
        (S = nothing,), (CR._DrawFrom(CR.Hazard(), 100.0, (S = 1,), 2, CR._Drop()),)
    )
    @test_throws "the draw names pool 0 of 1" CR._Depletion(
        (S = nothing,), (CR._DrawInto(CR.Truncate(), 100.0, 0, CR._Drop()),)
    )
    # One pool with no flows.
    p = CR.Depletion(100.0; pools = (S = 80.0,))
    @test p.pools == (S = 80.0,)
    @test !any(x -> x isa Tuple, p.pieces)
end

@testitem "Depletion: the draw, order and overflow as fields" begin
    using ComposableRecurrences, Test
    CR = ComposableRecurrences
    d = CR.Depletion(100.0)
    @test d.pools === (S = nothing,)
    @test d.pieces[1].weights === (S = 1,)
    @test d.pieces[1] isa CR._DrawFrom && d.pieces[1].first == 1
    @test length(d.pieces) == 1
    @test d.pieces[1].overflow === CR._Drop()
    @test CR.ispointwise(d)
    # The weights cover every pool, zero where unnamed, and the draw takes
    # first from the first pool they name.
    d = CR.Depletion(100.0, CR.Hazard(; weights = (V = 0.5, S = 1)); pools = (:S, :V, :R))
    @test d.pieces[1].weights === (S = 1, V = 0.5, R = 0)
    @test d.pieces[1].first == 2
    @test CR.blocks(d) === (1, 3)
    # A protected pool, and a pool that fills.
    d = CR.Depletion(
        100.0, CR.Hazard(; weights = (S = 1, V = 0.3)),
        CR.Flow(:S => :V, 2.0; form = CR.Truncate()); pools = (:S, :V)
    )
    @test d.pools === (S = nothing, V = nothing)
    @test d.pieces[1].weights === (S = 1, V = 0.3)
    @test only(d.pieces[2]).from == 1 && only(d.pieces[2]).to == 2
    d = CR.Depletion(
        10.0, CR.Flow(:O => 0, 0.1; form = CR.Share()),
        CR.Truncate(; into = :O, overflow = :stratum); pools = (:O,)
    )
    @test !hasproperty(d.pieces[2], :weights)
    @test d.pieces[2] isa CR._DrawInto && d.pieces[2].pool == 1
    @test d.pieces[1] isa Tuple
    @test d.pieces[2].overflow === CR._ToStratum()
    @test CR.blocks(d) === (2, 1)
    @test CR.blocks(CR.Depletion(10.0, CR.Hazard(; overflow = :queue))) === (1, 2)
    @test CR.Depletion(10.0, CR.Hazard(; overflow = :queue)).pieces[1].overflow ===
        CR._Queue()
    # Without a draw.
    d = CR.Depletion(CR.Flow(:A => :B, 0.3); pools = (:A, :B))
    @test !CR._draws(d) && d.pieces isa Tuple{Tuple} && CR._forms(d.pieces) === ()
    @test CR.blocks(d) === (2, 2)
end

@testitem "Depletion: the decided spellings infer" begin
    using ComposableRecurrences, Test
    # Imported by name: a global alias of the module would not infer.
    using ComposableRecurrences: Depletion, Flow, Hazard, Truncate, blocks, _DrawInto
    function leaky(N, σ)
        return Depletion(N, Hazard(; weights = (S = 1, V = σ)); pools = (S = N, V = 0.0))
    end
    d = @inferred leaky(1000.0, 0.3)
    @test d.pools === (S = 1000.0, V = 0.0)
    @test d.pieces[1].weights === (S = 1, V = 0.3)
    function protected(N, σ, r...)
        doses = map(x -> Flow(:S => :V, x; form = Truncate()), r)
        return Depletion(N, Hazard(; weights = (S = 1, V = σ)), doses...; pools = (:S, :V))
    end
    d = @inferred protected(1000.0, 0.3, 5.0)
    @test d.pieces[1].weights === (S = 1, V = 0.3)
    @test @inferred(blocks(d)) === (1, 2)
    beds(C) = Depletion(C, Truncate(; into = :O, overflow = :stratum); pools = (:O,))
    @test (@inferred beds(10.0)).pieces[1] isa _DrawInto
    ward() = Depletion(Flow(:U => :C, 0.3); pools = (:U, :C))
    @test (@inferred ward()).pieces[1][1].to == 2
    # The two-pool form gives the same values as the protected one.
    r(d) = Recurrence([0.3, 0.5, 0.2]; modifiers = (d,))(fill(2.0, 8); history = [5.0])
    @test r(leaky(1000.0, 0.3)) == r(protected(1000.0, 0.3))
end

@testitem "Depletion: declare their adjoint" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    doses = TimeVarying([1.0, 2.0])
    for d in (
            CR.Depletion(100.0, CR.Hazard(), CR.Flow(:S => 0, doses; form = CR.Truncate())),
            CR.Depletion(100.0, CR.Floor(; weights = (S = 1, V = 0.3)); pools = (:S, :V)),
            CR.Depletion(
                100.0, CR.Hazard(; weights = (S = 1, V = 0.3)),
                CR.Flow(:S => :V, doses; form = CR.Truncate()); pools = (:S, :V)
            ),
        )
        @test CR.uses_adjoint(d, CR.Step())
        @test CR.uses_adjoint(Recurrence([0.5, 0.5]; modifiers = (d,)), CR.Run())
    end
    # Without a draw there is no form for the rule to rebuild.
    ward = CR.Depletion(CR.Flow(1 => 2, 0.3); pools = (:A, :B))
    @test CR.uses_adjoint(ward, CR.Step())
    @test CR._local_modifier(ward) == ()
end

@testitem "Depletion: pieces are modifiers" setup = [ReferenceAD, ModifierChecks] begin
    using ComposableRecurrences, ForwardDiff
    CR = ComposableRecurrences
    (; mirror, flat) = ModifierChecks
    refs(x) = map(Ref, Tuple(x))
    vals(r) = collect(map(x -> x[], r))
    # Each model with one group's values and state, and the amounts its runs
    # of flows move from the pools they act on.
    models = (
        # One pool: a draw, then a count out.
        (
            CR.Depletion(
                100.0, CR.Hazard(1.3), CR.Flow(:S => 0, 2.0; form = CR.Truncate())
            ),
            [3.0], [80.0], x -> [min(2.0, x[1])],
        ),
        # Two pools with flows after the draw.
        (
            CR.Depletion(
                100.0, CR.Floor(; weights = (S = 1, V = 0.3)),
                CR.Flow(:S => :V, 4.0; form = CR.Truncate()), CR.Flow(:V => :S, 0.1);
                pools = (:S, :V)
            ),
            [3.0], [60.0, 20.0],
            x -> [min(4.0, x[1] + x[2] * -expm1(-0.1)), x[2] * -expm1(-0.1)],
        ),
        # Beds: a share leaves, then the draw fills them, the rest to the
        # overflow stratum.
        (
            CR.Depletion(
                10.0, CR.Flow(:O => 0, 0.1; form = CR.Share()),
                CR.SoftTruncate(0.1; into = :O, overflow = :stratum); pools = (:O,)
            ),
            [4.0, 1.0], [7.0], x -> [0.1 * x[1]],
        ),
        # Beds whose turned-away demand queues for the next step.
        (
            CR.Depletion(
                10.0, CR.Flow(:O => 0, 0.2; form = CR.Share()),
                CR.Truncate(; into = :O, overflow = :queue); pools = (:O,)
            ),
            [4.0], [7.0, 1.5], x -> [0.2 * x[1]],
        ),
        # A budget: a grant, then a draw whose remainder queues.
        (
            CR.Depletion(
                CR.Flow(0 => :B, 2.0; form = CR.Truncate()),
                CR.Truncate(; overflow = :queue); pools = (:B,)
            ),
            [3.0], [1.0, 0.5], x -> [2.0],
        ),
        # Two draws on one pool.
        (CR.Depletion(100.0, CR.Hazard(), CR.Floor(1.2)), [5.0], [70.0], nothing),
        # A flow between two draws, the second from the second pool.
        (
            CR.Depletion(
                100.0, CR.Hazard(; weights = (S = 1, V = 0.5)), CR.Flow(:S => :V, 0.2),
                CR.Truncate(; weights = (V = 1,), overflow = :stratum); pools = (:S, :V)
            ),
            [4.0, 0.5], [60.0, 10.0], x -> [x[1] * -expm1(-0.2)],
        ),
    )
    t = 1
    for (m, v, s, amounts) in models
        nv = length(v)
        # The pieces' group steps folded over one group's views give the
        # Depletion's group step.
        vm, sm = refs(v), refs(s)
        CR.forward!(m, CR.Step(), vm, sm, t, 1)
        ins = Tuple{Vector{Float64}, Vector{Float64}}[]
        vp, sp = refs(v), refs(s)
        for p in m.pieces
            push!(ins, (vals(vp), vals(sp)))
            CR.forward!(p, CR.Step(), vp, sp, t, 1)
        end
        @test vals(vp) == vals(vm)
        @test vals(sp) == vals(sm)
        # Each piece's group pullback against forward mode on its step.
        v̄0 = [0.7 - 1.1 * (i - 1) for i in 1:nv]
        s̄0 = [-0.3 + 0.7 * (i - 1) for i in eachindex(s)]
        function step(p, x)
            vr, sr = refs(x[1:nv]), refs(x[(nv + 1):end])
            CR.forward!(p, CR.Step(), vr, sr, t, 1)
            return [vals(vr); vals(sr)]
        end
        for (p, (vin, sin)) in zip(m.pieces, ins)
            J = ReferenceAD.jacobian(x -> step(p, x), [vin; sin])
            grads = (; piece = mirror(p), v = refs(v̄0), s = refs(s̄0))
            CR.pullback!(grads, p, CR.Step(), refs(vin), refs(sin), t, 1)
            @test [vals(grads.v); vals(grads.s)] ≈ transpose(J) * [v̄0; s̄0]
        end
        # The pieces' pullbacks, last first, give the Depletion's, parameters
        # included.
        m̄ = mirror(m)
        gm = (; piece = m̄, v = refs(v̄0), s = refs(s̄0))
        CR.pullback!(gm, m, CR.Step(), refs(v), refs(s), t, 1)
        p̄s = map(mirror, m.pieces)
        gv, gs = v̄0, s̄0
        for j in reverse(eachindex(ins))
            vin, sin = ins[j]
            gp = (; piece = p̄s[j], v = refs(gv), s = refs(gs))
            CR.pullback!(gp, m.pieces[j], CR.Step(), refs(vin), refs(sin), t, 1)
            gv, gs = vals(gp.v), vals(gp.s)
        end
        @test [gv; gs] ≈ [vals(gm.v); vals(gm.s)]
        @test flat(p̄s) ≈ flat(m̄.pieces)
        # A draw records the value it passes on and what it leaves of the
        # value it takes; a run of flows the amount each moves.
        outs = [ins[2:end]; [(vals(vp), vals(sp))]]
        for (p, (vin, sin), (vout, sout)) in zip(m.pieces, ins, outs)
            if p isa Tuple
                r = refs(zeros(length(p)))
                CR.forward!(
                    p, CR.Trace(), r, refs(vin), refs(sin), refs(vout), refs(sout), t, 1
                )
                @test vals(r) ≈ amounts(sin)
            else
                r = refs(zeros(2))
                CR.forward!(
                    p, CR.Trace(), r, refs(vin), refs(sin), refs(vout), refs(sout), t, 1
                )
                Q = p.overflow isa CR._Queue ? last(sin) : 0.0
                @test vals(r) ≈ [first(vout), first(vin) + Q - first(vout)]
            end
        end
    end
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
        CR.Depletion(
            PerStratum([60.0, 80.0]), CR.Hazard(),
            CR.Flow(:S => 0, doses; form = CR.Truncate())
        ),
        CR.Depletion(
            PerStratum([60.0, 80.0]),
            CR.Hazard(; weights = (S = 1, V = PerStratum([0.3, 0.5]))),
            CR.Flow(:S => :V, doses; form = CR.Truncate()); pools = (S = nothing, V = 2.0)
        ),
        CR.Depletion(
            70.0, CR.Floor(1.3; weights = (S = 1, V = 0.2)),
            CR.Flow(:S => :V, TimeVarying(rand(rng, T)); form = CR.Truncate());
            pools = (S = 65.0, V = nothing)
        ),
        CR.Depletion(
            70.0, CR.Hazard(; weights = (S = 1, V = 0.4)); pools = (S = nothing, V = 10.0)
        ),
        # Both pools start empty.
        CR.Depletion(
            70.0, CR.Floor(; weights = (S = 1, V = 0.4)); pools = (S = 0.0, V = nothing)
        ),
        # Without a population: a truncated draw reads none.
        CR.Depletion(CR.SoftTruncate(0.5); pools = (S = PerStratum([30.0, 40.0]),)),
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
    d = CR.Depletion(
        100.0, CR.Hazard(),
        CR.Flow(:S => 0, TimeVarying(fill(NaN, 6)); form = CR.Truncate());
        pools = (S = 3.0,)
    )
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
            CR.Depletion(
                100.0, CR.Hazard(), CR.Flow(:S => 0, doses; form = CR.Truncate());
                pools = (S = 3.0,)
            ),
            CR.Depletion(
                100.0, CR.Hazard(; weights = (S = 1, V = 0.0)),
                CR.Flow(:S => :V, doses; form = CR.Truncate());
                pools = (S = 3.0, V = nothing)
            ),
        )
        r = Recurrence(g; modifiers = (d,))
        @test pullback_matches(r, recargs(R, nothing, h)...)
    end
end

@testitem "Depletion: parts on vectors, their traces' pullbacks and their checks" setup = [
    ReferenceAD, ModifierChecks,
] begin
    using ComposableRecurrences, ForwardDiff
    CR = ComposableRecurrences
    (; mirror) = ModifierChecks
    refs(x) = map(Ref, Tuple(x))
    vals(r) = collect(map(x -> x[], r))
    t = 2
    # A part's vector step on one value and one pool per stratum is its
    # group step on each stratum, and its pullback matches forward mode.
    d = CR.Depletion(100.0, CR.Hazard(1.2), CR.Floor(), CR.Truncate(; into = :S))
    # Each part as the `Depletion` holds it, its pools named by position.
    parts = (
        CR.Flow(1 => 0, 0.2),
        (CR.Flow(1 => 0, 0.2), CR.Flow(1 => 0, 1.0; form = CR.Truncate())),
        d.pieces[2], d.pieces[3],
    )
    v, s = [2.0, 3.0], [40.0, 7.0]
    for p in parts
        v′, s′ = copy(v), copy(s)
        CR.forward!(p, CR.Step(), v′, s′, t)
        for k in eachindex(v)
            vk, sk = refs([v[k]]), refs([s[k]])
            CR.forward!(p, CR.Step(), vk, sk, t, k)
            @test (only(vals(vk)), only(vals(sk))) == (v′[k], s′[k])
        end
        function step(x)
            a, b = x[1:2], x[3:4]
            CR.forward!(p, CR.Step(), a, b, t)
            return [a; b]
        end
        J = ReferenceAD.jacobian(step, [v; s])
        v̄, s̄ = [0.4, -1.1], [0.3, 0.8]
        grads = (; piece = mirror(p), v = copy(v̄), s = copy(s̄))
        CR.pullback!(grads, p, CR.Step(), copy(v), copy(s), t)
        @test [grads.v; grads.s] ≈ transpose(J) * [v̄; s̄]
    end
    # The pullback of each part's trace against forward mode on the trace.
    q = CR.Depletion(
        CR.Flow(0 => :B, 2.0; form = CR.Truncate()), CR.Flow(:B => 0, 0.1),
        CR.Truncate(; overflow = :queue); pools = (:B,)
    )
    for p in q.pieces
        local v, s, n = [3.0], [1.0, 0.5], 2
        function trace(x)
            vin, sin = refs(x[1:1]), refs(x[2:3])
            vout, sout = refs(x[1:1]), refs(x[2:3])
            CR.forward!(p, CR.Step(), vout, sout, t, 1)
            r = refs(zeros(eltype(x), n))
            CR.forward!(p, CR.Trace(), r, vin, sin, vout, sout, t, 1)
            return vals(r)
        end
        x = [v; s]
        J = ReferenceAD.jacobian(trace, x)
        r̄ = [0.6, -0.9][1:n]
        grads = (;
            piece = mirror(p), trace = refs(r̄), v = refs(zeros(1)), s = refs(zeros(2)),
            v′ = refs(zeros(1)), s′ = refs(zeros(2)),
        )
        CR.pullback!(grads, p, CR.Trace(), refs(v), refs(s), t, 1)
        # The trace reads the step's inputs and its outputs; the pullback
        # gives each, so their sum through the step is the trace's.
        function step(x)
            vr, sr = refs(x[1:1]), refs(x[2:3])
            CR.forward!(p, CR.Step(), vr, sr, t, 1)
            return [vals(vr); vals(sr)]
        end
        Js = ReferenceAD.jacobian(step, x)
        ins = [vals(grads.v); vals(grads.s)]
        total = ins + transpose(Js) * [vals(grads.v′); vals(grads.s′)]
        @test total ≈ transpose(J) * r̄
    end
    # The recursion that groups runs of flows for static analysis gives the
    # generated grouping.
    f1, f2 = CR.Flow(1 => 0, 0.1), CR.Flow(1 => 0, 0.2)
    ps = (f1, f2, d.pieces[1], f1, d.pieces[2], f2)
    @test CR._runs_any(ps) === CR._runs(ps)
    @test CR._runs_any(ps[3:end]) === CR._runs(ps[3:end])
    @test CR._runs_any(()) === CR._runs(()) === ()
    # The checks of the pools, the exponent and the overflow.
    @test_throws "pools is a named tuple" CR.Depletion(100.0; pools = (;))
    @test_throws "pools is a named tuple" CR.Depletion(100.0; pools = (:S, :S))
    @test_throws "pools is a named tuple" CR.Depletion(100.0; pools = [:S])
    @test_throws "the heterogeneity exponent is a number" CR.Hazard("2")
    @test_throws "overflow is nothing, :queue or :stratum" CR.Truncate(; overflow = :spill)
    @test_throws "overflow is nothing, :queue or :stratum" CR.Truncate(; overflow = 1)
    @test_throws "a draw fills a pool or takes from weighted pools" CR.Depletion(
        10.0, CR.Truncate(; into = :S, weights = (S = 1,))
    )
    @test_throws "the draw names pool :X" CR.Depletion(10.0, CR.Truncate(; into = :X))
    @test_throws "splat a collection" CR.Depletion(10.0, (f1, f2))
    @test_throws "splat a collection" CR.Depletion(10.0, [f1, f2])
    # `pools` is its one keyword, with a population or without.
    @test_throws "takes the keyword pools alone, got pool" CR.Depletion(
        10.0; pool = (:S,)
    )
    @test_throws "takes the keyword pools alone, got pools, N" CR.Depletion(
        f1; pools = (:A, :B), N = 1.0
    )
    @test CR.Depletion(10.0; pools = (:S,)) == CR.Depletion(10.0)
    @test CR.Depletion(f1; pools = (:A, :B)) isa CR.Depletion
    # A form among the parts the local step rebuilds runs as a draw and
    # explains itself as the form.
    part = CR._FormPart(CR.Hazard(1.5))
    @test CR._any_step(part, 2.0) === CR._draw(CR.Hazard(1.5), 2.0, 2.0, 1)
    @test CR._rebuild_why(part) == CR._rebuild_why(CR.Hazard(1.5))
    # A form prints as written.
    @test repr(CR.Hazard()) == "ComposableRecurrences.Hazard()"
    @test repr(CR.Floor(1.5)) == "ComposableRecurrences.Floor(1.5)"
    @test repr(CR.Truncate()) == "ComposableRecurrences.Truncate()"
    @test repr(CR.SoftTruncate(0.1)) == "ComposableRecurrences.SoftTruncate(0.1)"
    @test repr(CR.Truncate(; into = :B, overflow = :queue)) ==
        "ComposableRecurrences.Truncate(; into = :B, overflow = :queue)"
    @test repr(CR.Hazard(2.0; weights = (S = 1, V = 0.3))) ==
        "ComposableRecurrences.Hazard(2.0; weights = (S = 1, V = 0.3))"
    @test repr(CR.SoftTruncate(0.1; overflow = :stratum)) ==
        "ComposableRecurrences.SoftTruncate(0.1; overflow = :stratum)"
end
