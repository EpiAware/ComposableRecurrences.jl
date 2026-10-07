# Depletion with removals and a protected pool: values and ForwardDiff
# gradients against a loop written from the maths, the limits that reduce
# to the base Depletion, conservation, and the pullbacks against a local
# ForwardDiff Jacobian of the Step.

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

    # Compare a vector Step's `pullback!` with the transposed Jacobian of its
    # `forward` in `[v; s; θ]`, where the state `s` may be longer than `v`.
    function check_vector_pullback(build, θ, v, s, t)
        S, n = length(v), length(s)
        v̄ = [0.3 + 0.4k for k in 1:S]
        s̄ = [-0.4 + 0.3k for k in 1:n]
        J = ForwardDiff.jacobian(vcat(v, s, θ)) do x
            vv, ss = x[1:S], x[(S + 1):(S + n)]
            CR.forward(build(x[(S + n + 1):end]), CR.Step(), vv, ss, t)
            return vcat(vv, ss)
        end
        expected = transpose(J) * vcat(v̄, s̄)
        m = build(θ)
        m̄ = mirror(m)
        gv, gs = copy(v̄), copy(s̄)
        CR._vector_pullback!((; piece = m̄, v = gv, s = gs), m, copy(v), copy(s), t)
        return (;
            v = gv ≈ expected[1:S], s = gs ≈ expected[(S + 1):(S + n)],
            θ = flat(m̄) ≈ expected[(S + n + 1):end],
        )
    end

    mirror(x::AbstractFloat) = Ref(zero(x))
    mirror(x::AbstractArray{<:AbstractFloat}) = zero(x)
    mirror(::Union{Integer, Symbol, Nothing, AbstractArray}) = nothing
    function mirror(x)
        names = fieldnames(typeof(x))
        return NamedTuple{names}(map(n -> mirror(getfield(x, n)), names))
    end
    flat(::Nothing) = Float64[]
    flat(x::Base.RefValue) = [x[]]
    flat(x::AbstractArray) = vec(copy(x))
    flat(x::NamedTuple) = reduce(vcat, map(flat, values(x)); init = Float64[])
end

@testitem "Depletion pools: no removals and no protected pool is the base" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    g, R, h = [0.3, 0.5, 0.2], fill(2.2, 12), [2.0, 3.0, 4.0]
    for form in (CR.Hazard(), CR.Floor())
        base = CR.Depletion(100.0, form)
        same = CR.Depletion(100.0, form; removals = nothing, protected = nothing)
        @test typeof(same) == typeof(base)
        @test Recurrence(g; modifiers = (same,))(R; history = h) ==
            Recurrence(g; modifiers = (base,))(R; history = h)
    end
end

@testitem "Depletion pools: values and gradients against the maths" setup = [PoolChecks] begin
    using ComposableRecurrences, ForwardDiff
    CR = ComposableRecurrences
    g, h = [0.3, 0.5, 0.2], [2.0, 3.0, 4.0]
    R = [2.5, 2.4, 2.2, 2.0, 1.8, 1.5, 1.2, 1.0, 1.1, 1.3]
    r = [0.0, 0.0, 5.0, 10.0, 10.0, 20.0, 20.0, 20.0, 30.0, 30.0]
    W = collect(range(0.5, 1.5; length = 10))
    function run(R, N, σ, r)
        d = CR.Depletion(
            N; removals = TimeVarying(r), protected = CR.Protected(σ)
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

@testitem "Depletion pools: full susceptibility undoes the protection" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    g, h = [0.3, 0.5, 0.2], [2.0 3.0 4.0; 1.0 1.0 2.0]
    R = fill(2.1, 2, 15)
    doses = TimeVarying(PerStratum(fill(4.0, 2, 15)))
    for form in (CR.Hazard(), CR.Floor()), α in (1.0, 1.5)
        N = PerStratum([100.0, 80.0])
        base = CR.Depletion(N, form; heterogeneity = α)
        full = CR.Depletion(
            N, form; heterogeneity = α, removals = doses,
            protected = CR.Protected(1.0)
        )
        @test Recurrence(g; modifiers = (full,))(R; history = h) ≈
            Recurrence(g; modifiers = (base,))(R; history = h)
    end
end

@testitem "Depletion pools: conservation and final-size ordering" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    g, h, N = [0.3, 0.5, 0.2], [2.0, 3.0, 4.0], 500.0
    R = fill(2.4, 40)
    doses = vcat(zeros(5), fill(8.0, 35))
    d = CR.Depletion(
        N; pool0 = N - sum(h), removals = TimeVarying(doses),
        protected = CR.Protected(0.4)
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
    aon = CR.Depletion(N; removals = TimeVarying(e .* doses), protected = CR.Protected(0.0))
    leaky = CR.Depletion(N; removals = TimeVarying(doses), protected = CR.Protected(1 - e))
    none = CR.Depletion(N)
    size_of(d) = sum(Recurrence(g; modifiers = (d,))(R; history = h))
    @test size_of(aon) < size_of(leaky) < size_of(none)
end

@testitem "Depletion pools: pullbacks against a local Jacobian" setup = [ModifierChecks, PoolChecks] begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    v = [2.0, 3.0, 1.5]
    # Removals only: a pointwise step on one pool, below and at the cap.
    for form in (CR.Hazard(), CR.Floor()), s in ([80.0, 60.0, 40.0], [3.0, 60.0, 1.0])
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
    for form in (CR.Hazard(), CR.Floor()), s in pools
        form isa CR.Hazard && s[1] < 0 && continue
        build(θ) = CR.Depletion(
            PerStratum(θ[1:3]), form; heterogeneity = θ[4],
            removals = PerStratum(θ[5:7]),
            protected = CR.Protected(PerStratum(θ[8:10]); pool0 = θ[11])
        )
        θ = [100.0, 90.0, 70.0, 1.3, 5.0, 7.0, 2.0, 0.3, 0.5, 0.0, 0.0]
        c = PoolChecks.check_vector_pullback(build, θ, v, s, 1)
        @test c.v && c.s && c.θ
    end
    # A protected pool without removals.
    build(θ) = CR.Depletion(
        θ[1]; heterogeneity = θ[2], protected = CR.Protected(θ[3]; pool0 = θ[4])
    )
    c = PoolChecks.check_vector_pullback(
        build, [100.0, 1.0, 0.4, 0.0], [2.0], [70.0, 20.0], 1
    )
    @test c.v && c.s && c.θ
end

@testitem "Depletion pools: an empty pool with a tangent under ForwardDiff" setup = [PoolChecks] begin
    using ComposableRecurrences, ForwardDiff
    CR = ComposableRecurrences
    # A dual with value zero and non-zero partials compares above zero, so
    # the step must pick its arm on the value and not divide by zero.
    P = ForwardDiff.Dual(0.0, 1.0, 0.4)
    y, S′, V′ = CR._protected_step(CR.Hazard(), 2.0, P, 0.0, 0.3, 100.0, 1.0, 0.0)
    @test all(isfinite, ForwardDiff.partials(S′))
    @test ForwardDiff.value(S′) == 0
    @test S′ == P - y
    @test V′ == 0
    # Both pools start empty with sizes set by parameters.
    g, h, R = [0.3, 0.5, 0.2], [5.0], fill(2.0, 6)
    W = collect(range(0.5, 1.5; length = 6))
    function f(θ)
        d = CR.Depletion(
            100.0; pool0 = θ[1], protected = CR.Protected(θ[2]; pool0 = θ[3])
        )
        return sum(W .* Recurrence(g; modifiers = (d,))(R; history = h))
    end
    ∇ = ForwardDiff.gradient(f, [0.0, 0.3, 0.0])
    @test all(isfinite, ∇)
    @test ∇[1] ≈ (f([1.0e-7, 0.3, 0.0]) - f([0.0, 0.3, 0.0])) / 1.0e-7 rtol = 1.0e-5
    # A seeded pool emptied by removals, with all-or-nothing protection.
    function fr(θ)
        d = CR.Depletion(
            100.0; pool0 = θ[1], removals = TimeVarying(fill(θ[2], 6)),
            protected = CR.Protected(θ[3])
        )
        return sum(W .* Recurrence(g; modifiers = (d,))(R; history = h))
    end
    @test all(isfinite, ForwardDiff.gradient(fr, [3.0, 4.0, 0.0]))
    # The step's pullback at an empty pool against its local Jacobian.
    build(θ) = CR.Depletion(
        θ[1], CR.Floor(); heterogeneity = θ[2],
        protected = CR.Protected(θ[3]; pool0 = θ[4])
    )
    c = PoolChecks.check_vector_pullback(
        build, [100.0, 1.0, 0.4, 0.0], [2.0], [0.0, 0.0], 1
    )
    @test c.v && c.s && c.θ
end

@testitem "Depletion pools: the initial state and its pullback" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    d = CR.Depletion(
        PerStratum([100.0, 50.0]); pool0 = PerStratum([90.0, 45.0]),
        removals = 1.0, protected = CR.Protected(0.5; pool0 = PerStratum([3.0, 4.0]))
    )
    s = zeros(4)
    CR.forward(d, CR.Init(), s, ones(2, 2))
    @test s == [90.0, 45.0, 3.0, 4.0]
    m̄ = (;
        N = (; x = zeros(2)), form = nothing, heterogeneity = Ref(0.0),
        pool0 = (; x = zeros(2)), removals = Ref(0.0),
        protected = (; σ = Ref(0.0), pool0 = (; x = zeros(2))),
    )
    grads = (; piece = m̄, s = [1.0, 2.0, 3.0, 4.0], history = zeros(2, 2))
    CR.pullback!(grads, d, CR.Init(), s, ones(2, 2))
    @test m̄.pool0.x == [1.0, 2.0]
    @test m̄.protected.pool0.x == [3.0, 4.0]
end

@testitem "Depletion pools: checks its arguments" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    @test_throws ArgumentError CR.Depletion(100.0; removals = [1.0, 2.0])
    @test_throws ArgumentError CR.Depletion(100.0; protected = 0.3)
    @test_throws "Protected pool or nothing, got 0.3" CR.Depletion(
        100.0; protected = 0.3
    )
    @test_throws ArgumentError CR.Protected(TimeVarying([0.1, 0.2]))
    @test_throws ArgumentError CR.Protected([0.1, 0.2])
    d = CR.Depletion(100.0; removals = TimeVarying([1.0, 2.0]))
    @test_throws DimensionMismatch Recurrence([0.5]; modifiers = (d,))(
        fill(1.1, 3); history = [1.0]
    )
    d = CR.Depletion(100.0; protected = CR.Protected(PerStratum([0.1, 0.2, 0.3])))
    @test_throws DimensionMismatch Recurrence([0.5]; modifiers = (d,))(
        fill(1.1, 2, 3); history = ones(2, 1)
    )
    for protected in (nothing, CR.Protected(0.5))
        dp = CR.Depletion(100.0; removals = PerStratum([1.0, 2.0, 3.0]), protected)
        @test_throws DimensionMismatch Recurrence([0.5]; modifiers = (dp,))(
            fill(1.1, 2, 3); history = ones(2, 1)
        )
    end
end

@testitem "Depletion pools: declare their adjoint" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    doses = TimeVarying([1.0, 2.0])
    for d in (
            CR.Depletion(100.0; removals = doses),
            CR.Depletion(100.0, CR.Floor(); protected = CR.Protected(0.3)),
            CR.Depletion(100.0; removals = doses, protected = CR.Protected(0.3)),
        )
        @test CR.uses_adjoint(d, CR.Step())
        @test CR.uses_adjoint(Recurrence([0.5, 0.5]; modifiers = (d,)), CR.Run())
    end
end

@testitem "Depletion pools: the Recurrence reverse pass" setup = [AdjointCheck] begin
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
            PerStratum([60.0, 80.0]); removals = doses,
            protected = CR.Protected(PerStratum([0.3, 0.5]); pool0 = 2.0)
        ),
        CR.Depletion(
            70.0, CR.Floor(); heterogeneity = 1.3, pool0 = 65.0,
            removals = TimeVarying(rand(rng, T)), protected = CR.Protected(0.2)
        ),
        CR.Depletion(70.0; protected = CR.Protected(0.4; pool0 = 10.0)),
        # Both pools start empty.
        CR.Depletion(
            70.0, CR.Floor(); pool0 = 0.0, protected = CR.Protected(0.4)
        ),
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

@testitem "Depletion pools: the removal picks its arm as its pullback does" begin
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

@testitem "Depletion pools: removals at an empty pool, reverse against ForwardDiff" setup = [AdjointCheck] begin
    using ComposableRecurrences
    g, h, R = [0.3, 0.5, 0.2], [5.0], fill(2.0, 6)
    # A seeded pool emptied by removals; with all-or-nothing protection the
    # pool stays at zero with a tangent from `σ`, a tie in the removal.
    for protected in (nothing, CR.Protected(0.0))
        d = CR.Depletion(
            100.0; pool0 = 3.0, removals = TimeVarying(fill(4.0, 6)), protected
        )
        r = Recurrence(g; modifiers = (d,))
        @test pullback_matches(r, recargs(R, nothing, h)...)
    end
end
