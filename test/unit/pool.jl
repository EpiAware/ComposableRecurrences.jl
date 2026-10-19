# A `Pool` with removals and a second, protected pool: values and
# ForwardDiff gradients against a loop written from the maths, the limits
# that reduce to the base Depletion, conservation, and the pullbacks against
# a local ForwardDiff Jacobian of the Step.

@testmodule PoolChecks begin
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

@testitem "Pool: no removals and no protected pool is the base" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    g, R, h = [0.3, 0.5, 0.2], fill(2.2, 12), [2.0, 3.0, 4.0]
    for form in (CR.Hazard(), CR.Floor())
        base = CR.Depletion(100.0, form)
        same = CR.Depletion(100.0, form; removals = nothing)
        @test typeof(same) == typeof(base)
        @test Recurrence(g; modifiers = (same,))(R; history = h) ==
            Recurrence(g; modifiers = (base,))(R; history = h)
    end
end

@testitem "Pool: values and gradients against the maths" setup = [PoolChecks] begin
    using ComposableRecurrences, ForwardDiff
    CR = ComposableRecurrences
    g, h = [0.3, 0.5, 0.2], [2.0, 3.0, 4.0]
    R = [2.5, 2.4, 2.2, 2.0, 1.8, 1.5, 1.2, 1.0, 1.1, 1.3]
    r = [0.0, 0.0, 5.0, 10.0, 10.0, 20.0, 20.0, 20.0, 30.0, 30.0]
    W = collect(range(0.5, 1.5; length = 10))
    function run(R, N, σ, r)
        d = CR.Pool(
            N; pools = (:S, :V), draw = (:S => 1, :V => σ) => CR.Hazard(),
            flows = (CR.Flow(1 => 2, TimeVarying(r); form = CR.Truncate()),)
        )
        return Recurrence(g; modifiers = (d,))(R; history = h)
    end
    @test run(R, 100.0, 0.3, r) ≈ PoolChecks.naive(g, R, h, 100.0, 0.3, r)
    f(θ) = sum(W .* run(θ[1:10], θ[11], θ[12], θ[13:22]))
    fref(θ) = sum(W .* PoolChecks.naive(g, θ[1:10], h, θ[11], θ[12], θ[13:22]))
    θ = vcat(R, 100.0, 0.3, r)
    @test ForwardDiff.gradient(f, θ) ≈ ForwardDiff.gradient(fref, θ)
    # Removals alone leave the pool: all-or-nothing with no protected pool.
    function only(R, r)
        d = CR.Depletion(100.0; removals = TimeVarying(r))
        return Recurrence(g; modifiers = (d,))(R; history = h)
    end
    @test only(R, r) ≈ PoolChecks.naive(g, R, h, 100.0, 0.0, r)
    @test ForwardDiff.gradient(r -> sum(W .* only(R, r)), r) ≈
        ForwardDiff.gradient(r -> sum(W .* PoolChecks.naive(g, R, h, 100.0, 0.0, r)), r)
end

@testitem "Pool: full susceptibility undoes the protection" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    g, h = [0.3, 0.5, 0.2], [2.0 3.0 4.0; 1.0 1.0 2.0]
    R = fill(2.1, 2, 15)
    doses = TimeVarying(PerStratum(fill(4.0, 2, 15)))
    for form in (CR.Hazard(), CR.Floor()), α in (1.0, 1.5)
        N = PerStratum([100.0, 80.0])
        base = CR.Depletion(N, form; heterogeneity = α)
        full = CR.Pool(
            N; pools = (:S, :V), draw = (:S => 1, :V => 1.0) => form, heterogeneity = α,
            flows = (CR.Flow(1 => 2, doses; form = CR.Truncate()),)
        )
        @test Recurrence(g; modifiers = (full,))(R; history = h) ≈
            Recurrence(g; modifiers = (base,))(R; history = h)
    end
end

@testitem "Pool: conservation and final-size ordering" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    g, h, N = [0.3, 0.5, 0.2], [2.0, 3.0, 4.0], 500.0
    R = fill(2.4, 40)
    doses = vcat(zeros(5), fill(8.0, 35))
    d = CR.Pool(
        N; pools = (:S, :V), initial = (N - sum(h), nothing),
        draw = (:S => 1, :V => 0.4) => CR.Hazard(),
        flows = (CR.Flow(1 => 2, TimeVarying(doses); form = CR.Truncate()),)
    )
    r = Recurrence(g; modifiers = (d,))
    for stop in (1, 7, 20, 40)
        y, st = CR.with_state(r, R; history = h, stop)
        pools = only(st.states)
        @test sum(pools) + sum(y) ≈ N - sum(h)
    end
    # All-or-nothing (σ = 0, removals e ⋅ doses) protects more than leaky
    # (σ = 1 - e, removals doses) at the same efficacy.
    e = 0.7
    aon = CR.Pool(
        N; pools = (:S, :V), draw = (:S => 1, :V => 0.0) => CR.Hazard(),
        flows = (CR.Flow(1 => 2, TimeVarying(e .* doses); form = CR.Truncate()),)
    )
    leaky = CR.Pool(
        N; pools = (:S, :V), draw = (:S => 1, :V => 1 - e) => CR.Hazard(),
        flows = (CR.Flow(1 => 2, TimeVarying(doses); form = CR.Truncate()),)
    )
    none = CR.Depletion(N)
    size_of(d) = sum(Recurrence(g; modifiers = (d,))(R; history = h))
    @test size_of(aon) < size_of(leaky) < size_of(none)
end

@testitem "Pool: pullbacks against a local Jacobian" setup = [ModifierChecks, PoolChecks] begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    v = [2.0, 3.0, 1.5]
    # Removals only: a pointwise step on one pool, below and at the cap.
    for form in (CR.Hazard(), CR.Floor(), CR.Truncate()),
            s in ([80.0, 60.0, 40.0], [3.0, 60.0, 1.0])
        build(θ) = CR.Depletion(
            PerStratum(θ[1:3]), form; heterogeneity = θ[4],
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
        build(θ) = CR.Pool(
            PerStratum(θ[1:3]); pools = (:S, :V), initial = (nothing, θ[5]),
            draw = (:S => 1, :V => PerStratum(θ[6:8])) => form, heterogeneity = θ[4],
            flows = (CR.Flow(1 => 2, PerStratum(θ[9:11]); form = CR.Truncate()),)
        )
        θ = [100.0, 90.0, 70.0, 1.3, 0.0, 0.3, 0.5, 0.0, 5.0, 7.0, 2.0]
        c = ModifierChecks.check_pullback(build, θ, v, s, 1; PoolChecks.seeds(v, s)...)
        @test c.v && c.s && c.θ
    end
    # A protected pool without removals.
    build(θ) = CR.Pool(
        θ[1]; pools = (:S, :V), initial = (nothing, θ[3]),
        draw = (:S => 1, :V => θ[4]) => CR.Hazard(), heterogeneity = θ[2]
    )
    c = ModifierChecks.check_pullback(
        build, [100.0, 1.0, 0.0, 0.4], [2.0], [70.0, 20.0], 1;
        PoolChecks.seeds([2.0], [70.0, 20.0])...
    )
    @test c.v && c.s && c.θ
end

@testitem "Pool: an empty pool with a tangent under ForwardDiff" setup = [ModifierChecks, PoolChecks] begin
    using ComposableRecurrences, ForwardDiff
    CR = ComposableRecurrences
    # A dual with value zero and non-zero partials compares above zero, so
    # the step must pick its arm on the value and not divide by zero.
    P = ForwardDiff.Dual(0.0, 1.0, 0.4)
    m = CR.Pool(100.0; pools = (:S, :V), draw = (:S => 1, :V => 0.3) => CR.Hazard())
    y, (S′, V′) = CR._draw_pools(m, 2.0, (P, zero(P)), 1, 1)
    @test all(isfinite, ForwardDiff.partials(S′))
    @test ForwardDiff.value(S′) == 0
    @test S′ == P - y
    @test V′ == 0
    # Both pools start empty with sizes set by parameters.
    g, h, R = [0.3, 0.5, 0.2], [5.0], fill(2.0, 6)
    W = collect(range(0.5, 1.5; length = 6))
    function f(θ)
        d = CR.Pool(
            100.0; pools = (:S, :V), initial = (θ[1], θ[3]),
            draw = (:S => 1, :V => θ[2]) => CR.Hazard()
        )
        return sum(W .* Recurrence(g; modifiers = (d,))(R; history = h))
    end
    ∇ = ForwardDiff.gradient(f, [0.0, 0.3, 0.0])
    @test all(isfinite, ∇)
    @test ∇[1] ≈ (f([1.0e-7, 0.3, 0.0]) - f([0.0, 0.3, 0.0])) / 1.0e-7 rtol = 1.0e-5
    # A seeded pool emptied by removals, with all-or-nothing protection.
    function fr(θ)
        d = CR.Pool(
            100.0; pools = (:S, :V), initial = (θ[1], nothing),
            draw = (:S => 1, :V => θ[3]) => CR.Hazard(),
            flows = (CR.Flow(1 => 2, TimeVarying(fill(θ[2], 6)); form = CR.Truncate()),)
        )
        return sum(W .* Recurrence(g; modifiers = (d,))(R; history = h))
    end
    @test all(isfinite, ForwardDiff.gradient(fr, [3.0, 4.0, 0.0]))
    # The step's pullback at an empty pool against its local Jacobian.
    build(θ) = CR.Pool(
        θ[1]; pools = (:S, :V), initial = (nothing, θ[3]),
        draw = (:S => 1, :V => θ[4]) => CR.Floor(), heterogeneity = θ[2]
    )
    c = ModifierChecks.check_pullback(
        build, [100.0, 1.0, 0.0, 0.4], [2.0], [0.0, 0.0], 1;
        PoolChecks.seeds([2.0], [0.0, 0.0])...
    )
    @test c.v && c.s && c.θ
end

@testitem "Pool: the initial state and its pullback" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    d = CR.Pool(
        PerStratum([100.0, 50.0]); pools = (:S, :V),
        initial = (PerStratum([90.0, 45.0]), PerStratum([3.0, 4.0])),
        draw = (:S => 1, :V => 0.5) => CR.Hazard(),
        flows = (CR.Flow(1 => 2, 1.0; form = CR.Truncate()),)
    )
    s = zeros(4)
    CR.forward!(d, CR.Init(), s, ones(2, 2))
    @test s == [90.0, 45.0, 3.0, 4.0]
    m̄ = (;
        N = (; x = zeros(2)), form = nothing, heterogeneity = nothing,
        initial = ((; x = zeros(2)), (; x = zeros(2))), weights = (nothing, Ref(0.0)),
        flows = ((; from = nothing, to = nothing, demand = Ref(0.0), form = nothing),),
    )
    grads = (; piece = m̄, s = [1.0, 2.0, 3.0, 4.0], history = zeros(2, 2))
    CR.pullback!(grads, d, CR.Init(), s, ones(2, 2))
    @test m̄.initial[1].x == [1.0, 2.0]
    @test m̄.initial[2].x == [3.0, 4.0]
    # The first pool's default start is the population at time 1.
    d = CR.Pool(PerStratum([100.0, 50.0]); pools = (:S, :V), draw = :S => CR.Hazard())
    CR.forward!(d, CR.Init(), s, ones(2, 2))
    @test s == [100.0, 50.0, 0.0, 0.0]
    m̄ = (;
        N = (; x = zeros(2)), form = nothing, heterogeneity = nothing,
        initial = nothing, weights = nothing, flows = (),
    )
    CR.pullback!((; grads..., piece = m̄), d, CR.Init(), s, ones(2, 2))
    @test m̄.N.x == [1.0, 2.0]
end

@testitem "Pool: a single-precision model stays in single precision" begin
    using ComposableRecurrences, Test
    CR = ComposableRecurrences
    g, R, h = Float32[0.2, 0.5, 0.3], fill(1.5f0, 1, 20), ones(Float32, 1, 3)
    pool(σ, V0) = CR.Pool(
        100.0f0; pools = (:S, :V), initial = (nothing, V0),
        draw = (:S => 1, :V => σ) => CR.Hazard(),
        flows = CR.Flow(:S => :V, 1.0f0; form = CR.Truncate())
    )
    run(p) = Recurrence(g; modifiers = (p,))
    # The default starting pool is empty and takes the state's type.
    @test pool(0.5f0, nothing).initial === (nothing, nothing)
    for p in (
            pool(0.5f0, nothing), pool(0.5f0, 2.0f0),
            pool(PerStratum([0.5f0]), PerStratum([2.0f0])),
        )
        r = run(p)
        @test eltype(@inferred r(R; history = h)) == Float32
        y, st = CR.with_state(r, R; history = h, stop = 10)
        @test eltype(y) == Float32
        @test eltype(r(R; state = st)) == Float32
    end
    # The empty default gives the same values as an explicit empty pool.
    @test run(pool(0.5f0, nothing))(R; history = h) ==
        run(pool(0.5f0, 0.0f0))(R; history = h)
    # A given starting pool is converted to a float.
    @test pool(0.5, 1).initial[2] === 1.0
end

@testitem "Pool: many flows infer" begin
    using ComposableRecurrences, Test
    using ComposableRecurrences: Flow, Pool
    # Past 32 flows, where `map` over a tuple and a recursion over the flows
    # stop inferring.
    function pool(::Val{n}) where {n}
        ring = (:A, :B, :C, :D)
        fs = ntuple(i -> Flow(ring[mod1(i, 4)] => ring[mod1(i + 1, 4)], 0.001i), Val(n))
        return Pool(
            1000.0; pools = ring, initial = (900.0, 50.0, 30.0, 20.0), flows = fs
        )
    end
    for n in (32, 33, 64)
        p = @inferred pool(Val(n))
        @test length(p.flows) == n
        r = Recurrence([0.3, 0.2, 0.1]; modifiers = (p,))
        @test eltype(@inferred r(fill(2.0, 20); history = [1.0, 1.0, 1.0])) == Float64
    end
end

@testitem "Pool: checks its arguments" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    @test_throws ArgumentError CR.Depletion(100.0; removals = [1.0, 2.0])
    two(w) = CR.Pool(100.0; pools = (:S, :V), draw = (:S => 1, :V => w) => CR.Hazard())
    @test_throws "it does not vary over time" two(TimeVarying([0.1, 0.2]))
    @test_throws ArgumentError two([0.1, 0.2])
    d = CR.Depletion(100.0; removals = TimeVarying([1.0, 2.0]))
    @test_throws DimensionMismatch Recurrence([0.5]; modifiers = (d,))(
        fill(1.1, 3); history = [1.0]
    )
    d = CR.Pool(
        100.0; pools = (:S, :V),
        draw = (:S => 1, :V => PerStratum([0.1, 0.2, 0.3])) => CR.Hazard()
    )
    @test_throws DimensionMismatch Recurrence([0.5]; modifiers = (d,))(
        fill(1.1, 2, 3); history = ones(2, 1)
    )
    for dp in (
            CR.Depletion(100.0; removals = PerStratum([1.0, 2.0, 3.0])),
            CR.Pool(
                100.0; pools = (:S, :V), draw = (:S => 1, :V => 0.5) => CR.Hazard(),
                flows = CR.Flow(:S => :V, PerStratum([1.0, 2.0, 3.0]); form = CR.Truncate())
            ),
        )
        @test_throws DimensionMismatch Recurrence([0.5]; modifiers = (dp,))(
            fill(1.1, 2, 3); history = ones(2, 1)
        )
    end
    @test_throws "draw is pool => form" CR.Pool(100.0; draw = CR.Hazard())
    @test_throws "the draw names pool :X, but the pools are (:S,)" CR.Pool(
        100.0; draw = :X => CR.Hazard()
    )
    @test_throws "not a Pool layout" CR.Pool{(n = 1, draw = false, first = 1)}(
        nothing, nothing, nothing, (nothing,), nothing, ()
    )
    # A weight of zero is fixed, as one is; another integer is a float.
    weight(w) = last(two(w).weights)
    @test weight(0) isa CR._Fixed{false}
    @test weight(2) === 2.0
    @test_throws "number of pools, got 0" CR.Pool(100.0; pools = 0)
    @test_throws "number of pools, got ()" CR.Pool(100.0; pools = ())
    @test_throws "a Hazard() draw reads the population, so give N" CR.Pool(;
        draw = :S => CR.Hazard()
    )
    @test_throws "initial has one entry per pool, 2, got 3" CR.Pool(
        100.0; pools = (:S, :V), initial = (1.0, 2.0, 3.0)
    )
    # The layout's check on flows placed directly.
    @test_throws "the flows name pool 2, but there is 1 pool" CR.Depletion(
        100.0, CR.Hazard(), CR._FixedExponent{true}(), (nothing,),
        (CR._Fixed{true}(),), (CR.Flow(1, 2, 0.1, CR.Hazard()),)
    )
    @test_throws "the flows name pool 3, but there are 2 pools" CR._check_pools(
        (CR.Flow(1, 3, 0.1, CR.Hazard()),), 2
    )
    # One starting value for one pool, and no flows.
    p = CR.Pool(100.0; initial = 80.0, flows = nothing)
    @test p.initial == (80.0,)
    @test p.flows == ()
end

@testitem "Pool: declare their adjoint" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    doses = TimeVarying([1.0, 2.0])
    for d in (
            CR.Depletion(100.0; removals = doses),
            CR.Pool(100.0; pools = (:S, :V), draw = (:S => 1, :V => 0.3) => CR.Floor()),
            CR.Pool(
                100.0; pools = (:S, :V), draw = (:S => 1, :V => 0.3) => CR.Hazard(),
                flows = (CR.Flow(1 => 2, doses; form = CR.Truncate()),)
            ),
        )
        @test CR.uses_adjoint(d, CR.Step())
        @test CR.uses_adjoint(Recurrence([0.5, 0.5]; modifiers = (d,)), CR.Run())
    end
    # Without a draw there is no form for the rule to rebuild.
    ward = CR.Pool(; pools = 2, draw = nothing, flows = CR.Flow(1 => 2, 0.3))
    @test CR.uses_adjoint(ward, CR.Step())
    @test CR._local_modifier(ward) == ()
end

@testitem "Pool: the Recurrence reverse pass" setup = [AdjointCheck] begin
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
        CR.Pool(
            PerStratum([60.0, 80.0]); pools = (:S, :V), initial = (nothing, 2.0),
            draw = (:S => 1, :V => PerStratum([0.3, 0.5])) => CR.Hazard(),
            flows = (CR.Flow(1 => 2, doses; form = CR.Truncate()),)
        ),
        CR.Pool(
            70.0; pools = (:S, :V), initial = (65.0, nothing),
            draw = (:S => 1, :V => 0.2) => CR.Floor(), heterogeneity = 1.3,
            flows = (CR.Flow(1 => 2, TimeVarying(rand(rng, T)); form = CR.Truncate()),)
        ),
        CR.Pool(
            70.0; pools = (:S, :V), initial = (nothing, 10.0),
            draw = (:S => 1, :V => 0.4) => CR.Hazard()
        ),
        # Both pools start empty.
        CR.Pool(
            70.0; pools = (:S, :V), initial = (0.0, nothing),
            draw = (:S => 1, :V => 0.4) => CR.Floor()
        ),
        # Without a population: a truncated draw reads none.
        CR.Pool(; draw = :S => CR.SoftTruncate(0.5), initial = PerStratum([30.0, 40.0])),
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

@testitem "Pool: the removal picks its arm as its pullback does" begin
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
    d = CR.Depletion(100.0; pool0 = 3.0, removals = TimeVarying(fill(NaN, 6)))
    y = Recurrence([0.3, 0.5, 0.2]; modifiers = (d,))(fill(2.0, 6); history = [5.0])
    @test any(isnan, y)
end

@testitem "Pool: removals at an empty pool, reverse against ForwardDiff" setup = [AdjointCheck] begin
    using ComposableRecurrences
    g, h, R = [0.3, 0.5, 0.2], [5.0], fill(2.0, 6)
    # A seeded pool emptied by removals; with all-or-nothing protection the
    # pool stays at zero with a tangent from `σ`, a tie in the removal.
    doses = TimeVarying(fill(4.0, 6))
    for d in (
            CR.Depletion(100.0; pool0 = 3.0, removals = doses),
            CR.Pool(
                100.0; pools = (:S, :V), initial = (3.0, nothing),
                draw = (:S => 1, :V => 0.0) => CR.Hazard(),
                flows = CR.Flow(:S => :V, doses; form = CR.Truncate())
            ),
        )
        r = Recurrence(g; modifiers = (d,))
        @test pullback_matches(r, recargs(R, nothing, h)...)
    end
end
