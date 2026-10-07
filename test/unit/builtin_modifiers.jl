# The built-in modifiers: Depletion, Add, Redistribute and Clamp.
# Forward values against naive loops, ForwardDiff gradients through a
# recurrence, and each hand-written pullback against a local ForwardDiff
# Jacobian of the Step in the step's values, state and the modifier's own
# parameters.

@testmodule ModifierChecks begin
    using ComposableRecurrences, ForwardDiff, LinearAlgebra
    const CR = ComposableRecurrences

    # A zero cotangent mirror, as the adjoint wiring builds it: an array per
    # float array, a `Ref` per float scalar, a NamedTuple per struct and
    # `nothing` for anything without a cotangent.
    mirror(x::AbstractFloat) = Ref(zero(x))
    mirror(x::AbstractArray{<:AbstractFloat}) = zero(x)
    mirror(::AbstractArray) = nothing
    mirror(::Union{Integer, Symbol, Nothing}) = nothing
    function mirror(x)
        names = fieldnames(typeof(x))
        return NamedTuple{names}(map(n -> mirror(getfield(x, n)), names))
    end

    # The mirror's float leaves in field order, flattened.
    flat(::Nothing) = Float64[]
    flat(x::Base.RefValue) = [x[]]
    flat(x::AbstractArray) = vec(copy(x))
    flat(x::NamedTuple) = reduce(vcat, map(flat, values(x)); init = Float64[])

    # Compare the Step's `pullback!` with the transposed Jacobian of its
    # `forward` in
    # `[v; s; θ]`, for a modifier `build(θ)` whose mirror flattens in the
    # order of `θ`. Returns the parameter cotangent for further checks.
    function check_pullback(build, θ, v, s, t; v̄ = nothing, s̄ = nothing)
        S = length(v)
        v̄′ = v̄ === nothing ? collect(range(0.3, 1.7; length = S)) : v̄
        s̄′ = s̄ === nothing ? collect(range(-0.4, 0.9; length = S)) : s̄
        J = ForwardDiff.jacobian(vcat(v, s, θ)) do x
            vv, ss = x[1:S], x[(S + 1):(2S)]
            CR.forward(build(x[(2S + 1):end]), CR.Step(), vv, ss, t)
            return vcat(vv, ss)
        end
        expected = transpose(J) * vcat(v̄′, s̄′)
        m = build(θ)
        m̄ = mirror(m)
        gv, gs = copy(v̄′), copy(s̄′)
        CR._vector_pullback!((; piece = m̄, v = gv, s = gs), m, copy(v), copy(s), t)
        return (;
            v = gv ≈ expected[1:S],
            s = gs ≈ expected[(S + 1):(2S)],
            θ = flat(m̄) ≈ expected[(2S + 1):end],
            θ̄ = flat(m̄),
        )
    end
end

@testitem "Depletion: hazard form against a naive loop" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    g = [0.3, 0.5, 0.2]
    R = [2.5, 2.4, 2.2, 2.0, 1.8, 1.5, 1.2, 1.0]
    h = [2.0, 3.0, 4.0]
    N = 200.0
    function naive(α; seeded)
        pool = seeded ? max(N - sum(h), 0.0) : N
        y = copy(h)
        for t in eachindex(R)
            v = R[t] * sum(g[i] * y[end - i + 1] for i in 1:3)
            x = v / N * (pool / N)^(α - 1)
            push!(y, pool * (1 - exp(-x)))
            pool *= exp(-x)
        end
        return y[4:end]
    end
    for α in (1.0, 0.7, 1.6), seeded in (false, true)
        pool0 = seeded ? max(N - sum(h), 0.0) : N
        m = CR.Depletion(N, CR.Hazard(); pool0, heterogeneity = α)
        @test Recurrence(g; modifiers = (m,))(R; history = h) ≈ naive(α; seeded)
    end
    # The default form is the hazard form, starting from N.
    @test Recurrence(g; modifiers = (CR.Depletion(N),))(R; history = h) ≈
        naive(1.0; seeded = false)
    # An empty starting pool draws nothing.
    m = CR.Depletion(5.0; pool0 = max(5.0 - sum(h), 0.0))
    @test all(iszero, Recurrence(g; modifiers = (m,))(R; history = h))
end

@testitem "Depletion: floor form against a naive loop" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    g = [0.3, 0.5, 0.2]
    R = fill(3.0, 12)
    h = [5.0, 6.0, 7.0]
    function naive(N, α)
        S = N
        y = copy(h)
        for t in eachindex(R)
            v = R[t] * sum(g[i] * y[end - i + 1] for i in 1:3)
            f = max(max(S / N, 0.0)^α, 1.0e-6)
            push!(y, f * v)
            S -= f * v
        end
        return y[4:end]
    end
    # A small pool drives S negative, so the floor binds.
    for N in (500.0, 60.0), α in (1.0, 1.4)
        m = CR.Depletion(N, CR.Floor(); heterogeneity = α)
        @test Recurrence(g; modifiers = (m,))(R; history = h) ≈ naive(N, α)
    end
end

@testitem "Depletion: one population per stratum" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    h = [1.0 2.0; 3.0 1.0]
    N = [100.0, 50.0]
    init(m, h) = (s = zeros(size(h, 1)); CR.forward(m, CR.Init(), s, h); s)
    m = CR.Depletion(PerStratum(N); pool0 = PerStratum(N .- vec(sum(h; dims = 2))))
    @test init(m, h) ≈ [97.0, 46.0]
    @test init(CR.Depletion(80.0), h) == [80.0, 80.0]
    @test init(CR.Depletion(PerStratum(N)), h) == N
    @test_throws DimensionMismatch init(CR.Depletion(PerStratum([1.0, 2.0, 3.0])), h)
    @test_throws DimensionMismatch init(
        CR.Depletion(80.0; pool0 = PerStratum([1.0, 2.0, 3.0])), h
    )
    # A plain array is not a parameter; the population and starting pool do
    # not vary over time.
    @test_throws ArgumentError CR.Depletion(N)
    @test_throws ArgumentError CR.Depletion(TimeVarying(N))
    @test_throws "does not vary over time, got TimeVarying(" CR.Depletion(TimeVarying(N))
    @test_throws ArgumentError CR.Depletion(1.0; pool0 = TimeVarying(N))
    r = Recurrence([0.4, 0.6]; coupling = [0.9 0.1; 0.2 0.8], modifiers = (m,))
    y = r(fill(1.5, 2, 6); history = h)
    @test size(y) == (2, 6)
    @test all(y .>= 0)
end

@testitem "Add: scalar, per stratum and time-varying" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    g = [0.5, 0.5]
    h = [1.0 1.0; 2.0 2.0]
    base(add) = Recurrence(g)(1.1; history = h, add)
    b = [0.1 0.2 0.3 0.4; 0.5 0.6 0.7 0.8]
    r(b) = Recurrence(g; modifiers = (CR.Add(b),))
    # Alone, Add is the same as `add`.
    @test r(0.5)(1.1; history = h, stop = 4) ≈ base(fill(0.5, 2, 4))
    @test r(PerStratum(b[:, 1]))(1.1; history = h, stop = 4) ≈
        base(repeat(b[:, 1], 1, 4))
    @test r(TimeVarying(b[1, :]))(1.1; history = h, stop = 4) ≈
        base(repeat(b[1:1, :], 2))
    @test r(TimeVarying(PerStratum(b)))(1.1; history = h, stop = 4) ≈ base(b)
    # Read at the absolute time.
    y = r(TimeVarying(PerStratum(b)))(1.1; history = h, start = 3, stop = 4)
    @test y ≈ Recurrence(g)(1.1; history = h, add = b, start = 3)
    # A plain array is not a parameter, and the values must cover stop.
    @test_throws ArgumentError CR.Add(b[1, :])
    @test_throws ArgumentError CR.Add(b)
    @test_throws ArgumentError CR.Add(TimeVarying(b[1, :], CR.Primary()))
    @test_throws "only meaningful for a kernel; got TimeVarying(" CR.Add(
        TimeVarying(b[1, :], CR.Primary())
    )
    @test_throws DimensionMismatch r(TimeVarying(b[1, :]))(1.1; history = h, stop = 5)
    @test_throws DimensionMismatch r(PerStratum([1.0, 2.0, 3.0]))(
        1.1; history = h, stop = 4
    )
end

@testitem "Add after depletion is not depleted" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    g = [1.0]
    b = [0.5, 1.0, 2.0]
    d = CR.Depletion(10.0, CR.Floor())
    y = Recurrence(g; modifiers = (d, CR.Add(TimeVarying(b))))(1.0; history = [2.0], stop = 3)
    function naive()
        S, prev, out = 10.0, 2.0, Float64[]
        for t in 1:3
            v = S / 10 * prev
            S -= v
            prev = v + b[t]
            push!(out, prev)
        end
        return out
    end
    @test y ≈ naive()
end

@testitem "Redistribute: conserving, against a naive loop" begin
    using ComposableRecurrences, LinearAlgebra
    CR = ComposableRecurrences
    K = [9.0 0.2 0.1; 0.3 9.0 0.2; 0.1 0.4 9.0]
    Ktrue = K - Diagonal(diag(K))
    v = [4.0, 2.0, 1.0]
    function naive(ε)
        out = vec(sum(Ktrue; dims = 1))
        return [
            (1 - ε[p] * out[p]) * v[p] +
                sum(ε[q] * Ktrue[p, q] * v[q] for q in 1:3 if q != p)
                for p in 1:3
        ]
    end
    for (ε, εv) in (
            (0.1, fill(0.1, 3)),
            (PerStratum([0.1, 0.2, 0.05]), [0.1, 0.2, 0.05]),
            (TimeVarying([0.1, 0.4]), fill(0.4, 3)),
            (
                TimeVarying(PerStratum([0.1 0.3; 0.2 0.1; 0.05 0.2])),
                [0.3, 0.1, 0.2],
            ),
        )
        x, s = copy(v), zeros(3)
        CR.forward(CR.Redistribute(K, ε), CR.Step(), x, s, 2)
        @test x ≈ naive(εv)
        # What moves is conserved; the state is the arrivals in each stratum.
        @test sum(x) ≈ sum(v)
        @test s ≈ [sum(εv[q] * Ktrue[p, q] * v[q] for q in 1:3 if q != p) for p in 1:3]
    end
    @test_throws DimensionMismatch CR.Redistribute(ones(2, 3), 0.1)
    @test_throws ArgumentError CR.Redistribute(K, [0.1, 0.2, 0.05])
    @test_throws ArgumentError CR.Redistribute(K, ones(3, 2))
end

@testitem "Clamp: bounds, scalar and per stratum" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    v, s = [-1.0, 0.5, 3.0], zeros(3)
    CR.forward(CR.Clamp(0.0, 1.0), CR.Step(), v, s, 1)
    @test v == [0.0, 0.5, 1.0]
    v = [-1.0, 0.5, 3.0]
    CR.forward(
        CR.Clamp(PerStratum([-2.0, 0.6, 0.0]), PerStratum([0.0, 1.0, 2.0])),
        CR.Step(), v, s, 1
    )
    @test v == [-1.0, 0.6, 2.0]
    y = Recurrence([2.0]; modifiers = (CR.Clamp(0.0, 5.0),))(1.0; history = [1.0], stop = 4)
    @test y == [2.0, 4.0, 5.0, 5.0]
    # A time-varying bound is read at the absolute time.
    hi = TimeVarying([10.0, 3.0, 10.0, 6.0])
    y = Recurrence([2.0]; modifiers = (CR.Clamp(0.0, hi),))(1.0; history = [1.0], stop = 4)
    @test y == [2.0, 3.0, 6.0, 6.0]
    @test_throws ArgumentError CR.Clamp([0.0, 1.0], 2.0)
end

@testitem "Built-in modifiers implement the piece interface" begin
    using ComposableRecurrences, Interfaces
    CR = ComposableRecurrences
    for T in (CR.Depletion, CR.Hazard, CR.Floor, CR.Add, CR.Redistribute, CR.Clamp)
        @test Interfaces.implements(CR.PieceInterface, T)
    end
end

@testitem "Depletion pullback matches the local Jacobian" setup = [ModifierChecks] begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    v, s = [3.0, 0.5, 8.0], [150.0, 40.0, 90.0]
    for form in (CR.Hazard(), CR.Floor()), α in (1.0, 0.8, 1.3)
        # Scalar N and per-stratum N, each with the exponent as a parameter.
        c = ModifierChecks.check_pullback(
            θ -> CR.Depletion(θ[1], form; heterogeneity = θ[2]),
            [200.0, α], v, s, 3
        )
        @test c.v && c.s && c.θ
        @test all(!iszero, c.θ̄)
        c = ModifierChecks.check_pullback(
            θ -> CR.Depletion(PerStratum(θ[1:3]), form; heterogeneity = θ[4]),
            [200.0, 60.0, 100.0, α], v, s, 3
        )
        @test c.v && c.s && c.θ
    end
    # The floor binds on the second stratum (negative pool).
    c = ModifierChecks.check_pullback(
        θ -> CR.Depletion(PerStratum(θ[1:3]), CR.Floor(); heterogeneity = θ[4]),
        [200.0, 60.0, 100.0, 1.0], v, [150.0, -5.0, 90.0], 1
    )
    @test c.v && c.s && c.θ
    # An exhausted pool (a seed larger than N) has a finite hazard pullback.
    m = CR.Depletion(200.0; heterogeneity = 1.3)
    v̄, s̄ = [0.5, 1.0, 0.2], [0.3, -0.2, 0.1]
    CR._vector_pullback!(
        (; piece = ModifierChecks.mirror(m), v = v̄, s = s̄), m, v,
        [150.0, 0.0, 90.0], 1
    )
    @test all(isfinite, v̄) && all(isfinite, s̄)
end

@testitem "Depletion init pullback matches ForwardDiff" setup = [ModifierChecks] begin
    using ComposableRecurrences, ForwardDiff
    CR = ComposableRecurrences
    h = [1.0 2.0 3.0; 4.0 5.0 6.0; 50.0 60.0 70.0]
    s̄ = [0.7, -1.2, 0.4]
    for N0 in ([100.0, 40.0, 60.0], [80.0]), with_pool0 in (false, true)
        n = length(N0)
        wrap(x) = n == 1 ? x[1] : PerStratum(x)
        build(θ) = with_pool0 ?
            CR.Depletion(wrap(θ[1:n]); pool0 = wrap(θ[(n + 1):(2n)])) :
            CR.Depletion(wrap(θ[1:n]))
        function pool(θ)
            s = zeros(eltype(θ), 3)
            CR.forward(build(θ), CR.Init(), s, h)
            return s
        end
        θ = with_pool0 ? vcat(N0, 0.9 .* N0) : N0
        expected = transpose(ForwardDiff.jacobian(pool, θ)) * s̄
        m = build(θ)
        m̄ = ModifierChecks.mirror(m)
        CR.pullback!((; piece = m̄, s = s̄, history = nothing), m, CR.Init(), zeros(3), h)
        @test vcat(ModifierChecks.flat(m̄.N), ModifierChecks.flat(m̄.pool0)) ≈ expected
    end
end

@testitem "Add pullback matches the local Jacobian" setup = [ModifierChecks] begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    v, s = [1.0, 2.0], [0.3, 0.4]
    c = ModifierChecks.check_pullback(θ -> CR.Add(θ[1]), [0.7], v, s, 2)
    @test c.v && c.s && c.θ
    @test c.θ̄[1] != 0
    c = ModifierChecks.check_pullback(θ -> CR.Add(PerStratum(θ)), [0.1, 0.2], v, s, 2)
    @test c.v && c.s && c.θ
    c = ModifierChecks.check_pullback(
        θ -> CR.Add(TimeVarying(PerStratum(reshape(θ, 2, 3)))),
        collect(0.1:0.1:0.6), v, s, 3
    )
    @test c.v && c.s && c.θ
    c = ModifierChecks.check_pullback(
        θ -> CR.Add(TimeVarying(θ)), [0.1, 0.2, 0.3], v, s, 2
    )
    @test c.v && c.s && c.θ
end

@testitem "Redistribute pullback matches the local Jacobian" setup = [ModifierChecks] begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    v, s = [4.0, 2.0, 1.0], [0.3, 0.1, 0.2]
    K = [0.5, 0.3, 0.1, 0.2, 0.7, 0.4, 0.1, 0.2, 0.9]
    Kof(θ) = reshape(θ[1:9], 3, 3)
    c = ModifierChecks.check_pullback(
        θ -> CR.Redistribute(Kof(θ), θ[10]), vcat(K, 0.1), v, s, 1
    )
    @test c.v && c.s && c.θ
    @test c.θ̄[10] != 0
    # The diagonal of K is not read.
    @test all(iszero, c.θ̄[[1, 5, 9]])
    c = ModifierChecks.check_pullback(
        θ -> CR.Redistribute(Kof(θ), PerStratum(θ[10:12])),
        vcat(K, [0.1, 0.2, 0.05]), v, s, 1
    )
    @test c.v && c.s && c.θ
    c = ModifierChecks.check_pullback(
        θ -> CR.Redistribute(Kof(θ), TimeVarying(θ[10:11])),
        vcat(K, [0.1, 0.2]), v, s, 2
    )
    @test c.v && c.s && c.θ
    c = ModifierChecks.check_pullback(
        θ -> CR.Redistribute(
            Kof(θ), TimeVarying(PerStratum(reshape(θ[10:15], 3, 2)))
        ),
        vcat(K, [0.1, 0.2, 0.05, 0.3, 0.1, 0.2]), v, s, 2
    )
    @test c.v && c.s && c.θ
end

@testitem "Clamp pullback matches the local Jacobian" setup = [ModifierChecks] begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    v, s = [-1.0, 0.5, 3.0], [0.1, 0.2, 0.3]
    c = ModifierChecks.check_pullback(θ -> CR.Clamp(θ[1], θ[2]), [0.0, 1.0], v, s, 1)
    @test c.v && c.s && c.θ
    @test all(!iszero, c.θ̄)
    c = ModifierChecks.check_pullback(
        θ -> CR.Clamp(PerStratum(θ[1:3]), PerStratum(θ[4:6])),
        [-2.0, 0.6, 0.0, 0.0, 1.0, 2.0], v, s, 1
    )
    @test c.v && c.s && c.θ
    c = ModifierChecks.check_pullback(
        θ -> CR.Clamp(TimeVarying(θ[1:2]), θ[3]), [0.0, 0.7, 2.0], v, s, 2
    )
    @test c.v && c.s && c.θ
end

@testitem "Built-in modifiers: ForwardDiff through a recurrence" begin
    using ComposableRecurrences, ForwardDiff
    CR = ComposableRecurrences
    g = [0.3, 0.5, 0.2]
    h = [1.0 2.0 3.0; 0.5 1.0 1.0; 0.0 0.0 1.0]
    K = [0.0 0.2 0.1; 0.3 0.0 0.2; 0.1 0.4 0.0]
    R = [2.0 1.9 1.8 1.7 1.6; 1.2 1.3 1.4 1.5 1.6; 0.8 0.9 1.0 1.1 1.2]
    w = reshape(range(0.5, 2.0; length = 15), 3, 5)
    function loss(θ)
        mods = (
            CR.Redistribute(K, θ[1]),
            CR.Depletion(
                PerStratum(θ[2:4]);
                pool0 = PerStratum(max.(θ[2:4] .- vec(sum(h; dims = 2)), 0)),
                heterogeneity = θ[5]
            ),
            CR.Add(θ[6]),
            CR.Clamp(0.0, θ[7]),
        )
        return sum(w .* Recurrence(g; modifiers = mods)(R; history = h))
    end
    θ = [0.05, 300.0, 200.0, 150.0, 1.2, 0.3, 50.0]
    ∇ = ForwardDiff.gradient(loss, θ)
    fd = map(eachindex(θ)) do i
        e = zeros(length(θ))
        e[i] = 1.0e-6 * max(1.0, abs(θ[i]))
        (loss(θ + e) - loss(θ - e)) / (2e[i])
    end
    @test ∇ ≈ fd rtol = 1.0e-5
    @test all(!iszero, ∇[1:6])
end

@testitem "Wrapper nesting is normalised" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    S, L, T = 2, 3, 6
    G = rand(S, L, T)
    B = rand(S, T)
    h = rand(S, L)
    R = 1 .+ rand(S, T)
    # Either order builds one object, TimeVarying outermost.
    for I in (CR.Secondary(), CR.Primary())
        a = TimeVarying(PerStratum(G), I)
        b = PerStratum(TimeVarying(G, I))
        @test typeof(a) === typeof(b) && a.x.x === b.x.x
    end
    P4 = rand(S, S, L, T)
    pa = Recurrence(TimeVarying(Pairwise(P4)))
    pb = Recurrence(Pairwise(TimeVarying(P4)))
    @test typeof(pa) === typeof(pb) && pa.kernel.x.x === pb.kernel.x.x
    @test pa(R; history = h) == pb(R; history = h)
    ra = Recurrence(TimeVarying(PerStratum(G)))
    rb = Recurrence(PerStratum(TimeVarying(G)))
    @test typeof(ra) === typeof(rb) && ra.kernel.x.x === rb.kernel.x.x
    @test ra(R; history = h) == rb(R; history = h)
    ca = Convolution(TimeVarying(PerStratum(G), CR.Primary()))
    cb = Convolution(PerStratum(TimeVarying(G, CR.Primary())))
    @test typeof(ca) === typeof(cb)
    @test ca(R) == cb(R)
    # And for modifier parameters.
    for build in (
            b -> CR.Add(b), b -> CR.Redistribute([0.0 0.2; 0.3 0.0], b),
            b -> CR.Clamp(0.0, b),
        )
        ma, mb = build(TimeVarying(PerStratum(B))), build(PerStratum(TimeVarying(B)))
        @test typeof(ma) === typeof(mb)
        g = [0.3, 0.2, 0.1]
        @test Recurrence(g; modifiers = (ma,))(R; history = h) ==
            Recurrence(g; modifiers = (mb,))(R; history = h)
    end
end

@testitem "Variants: the form slot takes a form struct" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    struct NotAForm end
    err = try
        CR.Depletion(1.0, NotAForm())
        nothing
    catch e
        e
    end
    @test err isa ArgumentError
    @test occursin("NotAForm", err.msg) &&
        occursin("forward(form, Step(), v, s, N, α)", err.msg)
    @test_throws ArgumentError CR.Depletion(1.0, :floor)
    @test_throws ":floor is not a depletion form" CR.Depletion(1.0, :floor)
end

@testitem "Variants: one path per step" begin
    using ComposableRecurrences, JET
    CR = ComposableRecurrences
    for form in (CR.Hazard(), CR.Floor())
        m = CR.Depletion(100.0, form)
        @test m isa CR.Depletion{typeof(form)}
        # The built-in maths is the form's Step.
        @test CR.forward(m, CR.Step(), 2.0, 80.0, 1, 1) ==
            CR.forward(form, CR.Step(), 2.0, 80.0, 100.0, 1.0)
        # A step compiles to one path: no dispatch on the form at run time.
        @test (@inferred CR.forward(m, CR.Step(), 2.0, 80.0, 1, 1)) isa
            Tuple{Float64, Float64}
        JET.@test_opt CR.forward(m, CR.Step(), 2.0, 80.0, 1, 1)
    end
    default_depletion() = ComposableRecurrences.Depletion(1.0)
    @test (@inferred default_depletion()) isa CR.Depletion{CR.Hazard}
end

@testitem "Built-in modifiers: a Recurrence infers its return type" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    K = [0.0 0.3; 0.2 0.0]
    # Depletion nests a form struct in a modifier tuple in the Recurrence,
    # a depth that inference's recursion limit can widen to `Any`.
    for m in (
            CR.Depletion(100.0),
            CR.Depletion(100.0, CR.Floor()),
            CR.Depletion(
                PerStratum([100.0, 50.0]); pool0 = PerStratum([97.0, 46.0]),
                heterogeneity = 1.5
            ),
            CR.Add(0.5), CR.Clamp(0.0, 5.0), CR.Redistribute(K, 0.1),
        )
        r = Recurrence([0.5, 0.5]; modifiers = (m,))
        @test (@inferred r(fill(1.1, 2, 6); history = ones(2, 2))) isa
            Matrix{Float64}
    end
    r = Recurrence(
        Float32[0.5, 0.5];
        modifiers = (CR.Depletion(100.0f0), CR.Clamp(0.0f0, 5.0f0))
    )
    @test (@inferred r(fill(1.1f0, 6); history = ones(Float32, 2))) isa
        Vector{Float32}
end

@testitem "Variants: a user depletion form, with and without a pullback" setup = [ModifierChecks] begin
    using ComposableRecurrences, ForwardDiff
    CR = ComposableRecurrences
    # Take what is asked, up to the pool.
    struct Linear end
    CR.forward(::Linear, ::CR.Step, v, s, N, α) = (y = min(v, s); (y, s - y))
    struct LinearWithPullback end
    function CR.forward(::LinearWithPullback, ::CR.Step, v, s, N, α)
        y = min(v, s)
        return y, s - y
    end
    function CR.pullback!(ḡ, ::LinearWithPullback, ::CR.Step, v, s, N, α)
        take = v < s
        v̄ = take ? ḡ.v - ḡ.s : zero(v)
        s̄ = take ? ḡ.s : ḡ.v
        return v̄, s̄, zero(N), zero(α)
    end
    h = [1.0, 2.0]
    function naive(R, N)
        y, pool = promote_type(eltype(R), typeof(N)).(h), N
        for t in eachindex(R)
            v = R[t] * (0.5 * y[end] + 0.5 * y[end - 1])
            push!(y, min(v, pool))
            pool -= y[end]
        end
        return y[3:end]
    end
    R = fill(2.0, 8)
    ∇ref = ForwardDiff.gradient(θ -> sum(naive(θ[2:end], θ[1])), vcat(100.0, R))
    for form in (Linear(), LinearWithPullback())
        d = CR.Depletion(100.0, form)
        y = Recurrence([0.5, 0.5]; modifiers = (d,))(R; history = h)
        @test y ≈ naive(R, 100.0)
        # The pool runs out, so both branches of the form are used.
        @test y[end] < R[end] * (0.5 * y[end - 1] + 0.5 * y[end - 2])
        run(θ) = Recurrence([0.5, 0.5]; modifiers = (CR.Depletion(θ[1], form),))(
            θ[2:end]; history = h
        )
        @test ForwardDiff.gradient(θ -> sum(run(θ)), vcat(100.0, R)) ≈ ∇ref
    end
    # The pullback matches the local Jacobian on both branches.
    c = ModifierChecks.check_pullback(
        θ -> CR.Depletion(θ[1], LinearWithPullback(); heterogeneity = θ[2]),
        [100.0, 1.0], [2.0, 5.0], [4.0, 3.0], 1
    )
    @test c.v && c.s && c.θ
end

@testitem "Depletion: a dual population keeps an integer heterogeneity plain" begin
    using ComposableRecurrences, ForwardDiff
    CR = ComposableRecurrences
    using ForwardDiff: Dual
    @test CR.Depletion(Dual(100.0, 1.0)).heterogeneity === 1.0
    @test CR.Depletion(Dual(100.0f0, 1.0f0); heterogeneity = 2).heterogeneity ===
        2.0f0
    @test CR.Depletion(Dual(Dual(100.0, 1.0), 1.0)).heterogeneity === 1.0
    @test CR.Depletion(100.0f0).heterogeneity === 1.0f0
    # A dual exponent at an empty pool takes the primal exponent, as the
    # pullback gives the exponent no cotangent there.
    @test (@inferred CR._pool_power(0.0, Dual(0.0, 1.0))) === Dual(1.0, 0.0)
    @test CR._pool_power(0.5, Dual(2.0, 1.0)) == Dual(0.25, 0.25 * log(0.5))
    # A NaN share or exponent stays NaN in the value and the tangent.
    @test all(isnan, ForwardDiff.partials(CR._pool_power(NaN, Dual(1.0, 1.0))))
    @test isnan(ForwardDiff.value(CR._pool_power(0.0, Dual(NaN, 1.0))))
    grads = (; v = 1.0, s = 0.0)
    @test isnan(CR.pullback!(grads, CR.Hazard(), CR.Step(), 1.0, NaN, 1.0, 2.0)[4])
    @test CR.pullback!(grads, CR.Hazard(), CR.Step(), 1.0, 0.0, 1.0, 2.0)[4] == 0
    # At an empty pool a dual exponent would give `log(0) * 0 = NaN`.
    g, h, R = [0.3, 0.5, 0.2], [5.0], fill(2.0, 6)
    W = collect(range(0.5, 1.5; length = 6))
    pools = (nothing, CR.Protected(0.3))
    for form in (CR.Hazard(), CR.Floor()), α in (1, 2), protected in pools
        function f(θ)
            d = CR.Depletion(
                θ[1], form; heterogeneity = α, pool0 = θ[2], protected
            )
            return sum(W .* Recurrence(g; modifiers = (d,))(R; history = h))
        end
        θ = [100.0, 0.0]
        ∇ = ForwardDiff.gradient(f, θ)
        @test all(isfinite, ∇)
        e = 1.0e-7
        @test ∇[1] ≈ (f(θ + [e, 0]) - f(θ - [e, 0])) / 2e atol = 1.0e-6
        @test ∇[2] ≈ (f(θ + [0, e]) - f(θ)) / e rtol = 1.0e-4 atol = 1.0e-6
    end
end
