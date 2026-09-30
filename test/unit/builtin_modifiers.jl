# The built-in modifiers: Depletion, Add, Redistribute and Clamp.
# Forward values against naive loops, ForwardDiff gradients through a
# recurrence, and each hand-written pullback against a local ForwardDiff
# Jacobian of `apply!` in the step's values, state and the modifier's own
# parameters.

@testmodule ModifierChecks begin
    using ComposableRecurrences, ForwardDiff, LinearAlgebra
    const CR = ComposableRecurrences

    # A zero cotangent mirror, as the adjoint wiring builds it: an array per
    # float array, a `Ref` per float scalar, a NamedTuple per struct and
    # `nothing` for anything without a cotangent.
    mirror(x::AbstractFloat) = Ref(zero(x))
    mirror(x::AbstractArray{<:AbstractFloat}) = zero(x)
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

    # Compare `apply_pullback!` with the transposed Jacobian of `apply!` in
    # `[v; s; θ]`, for a modifier `build(θ)` whose mirror flattens in the
    # order of `θ`. Returns the parameter cotangent for further checks.
    function check_pullback(build, θ, v, s, t; v̄ = nothing, s̄ = nothing)
        S = length(v)
        v̄′ = v̄ === nothing ? collect(range(0.3, 1.7; length = S)) : v̄
        s̄′ = s̄ === nothing ? collect(range(-0.4, 0.9; length = S)) : s̄
        J = ForwardDiff.jacobian(vcat(v, s, θ)) do x
            vv, ss = x[1:S], x[(S + 1):(2S)]
            CR.apply!(build(x[(2S + 1):end]), vv, ss, t)
            return vcat(vv, ss)
        end
        expected = transpose(J) * vcat(v̄′, s̄′)
        m = build(θ)
        m̄ = mirror(m)
        gv, gs = copy(v̄′), copy(s̄′)
        CR.apply_pullback!(m̄, m, copy(v), copy(s), t, gv, gs)
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
        m = CR.Depletion(N; form = :hazard, seeded, heterogeneity = α)
        @test Recurrence(g; modifiers = (m,))(R; history = h) ≈ naive(α; seeded)
    end
    # The default form is the hazard form without a seed.
    @test Recurrence(g; modifiers = (CR.Depletion(N),))(R; history = h) ≈
        naive(1.0; seeded = false)
    # The seed can exhaust the pool, which is then floored at zero.
    m = CR.Depletion(5.0; seeded = true)
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
        m = CR.Depletion(N; form = :floor, heterogeneity = α)
        @test Recurrence(g; modifiers = (m,))(R; history = h) ≈ naive(N, α)
    end
end

@testitem "Depletion: one population per stratum" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    h = [1.0 2.0; 3.0 1.0]
    N = [100.0, 50.0]
    m = CR.Depletion(PerStratum(N); seeded = true)
    @test CR.init_state(m, h) ≈ [97.0, 46.0]
    @test CR.init_state(CR.Depletion(80.0), h) == [80.0, 80.0]
    @test_throws DimensionMismatch CR.init_state(
        CR.Depletion(PerStratum([1.0, 2.0, 3.0])), h
    )
    @test_throws ArgumentError CR.Depletion(1.0; form = :other)
    # A plain array is not a parameter; N is the starting pool, so it does
    # not vary over time.
    @test_throws ArgumentError CR.Depletion(N)
    @test_throws ArgumentError CR.Depletion(TimeVarying(N))
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
    @test_throws ArgumentError CR.Add(TimeVarying(b[1, :]; indexed_by = :primary))
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
    d = CR.Depletion(10.0; form = :floor)
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
        CR.apply!(CR.Redistribute(K, ε), x, s, 2)
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
    CR.apply!(CR.Clamp(0.0, 1.0), v, s, 1)
    @test v == [0.0, 0.5, 1.0]
    v = [-1.0, 0.5, 3.0]
    CR.apply!(CR.Clamp(PerStratum([-2.0, 0.6, 0.0]), PerStratum([0.0, 1.0, 2.0])), v, s, 1)
    @test v == [-1.0, 0.6, 2.0]
    y = Recurrence([2.0]; modifiers = (CR.Clamp(0.0, 5.0),))(1.0; history = [1.0], stop = 4)
    @test y == [2.0, 4.0, 5.0, 5.0]
    # A time-varying bound is read at the absolute time.
    hi = TimeVarying([10.0, 3.0, 10.0, 6.0])
    y = Recurrence([2.0]; modifiers = (CR.Clamp(0.0, hi),))(1.0; history = [1.0], stop = 4)
    @test y == [2.0, 3.0, 6.0, 6.0]
    @test_throws ArgumentError CR.Clamp([0.0, 1.0], 2.0)
end

@testitem "Built-in modifiers implement the modifier interface" begin
    using ComposableRecurrences, Interfaces
    CR = ComposableRecurrences
    @test Interfaces.implements(CR.ModifierInterface, CR.Depletion)
    @test Interfaces.implements(CR.ModifierInterface, CR.Add)
    @test Interfaces.implements(CR.ModifierInterface, CR.Redistribute)
    @test Interfaces.implements(CR.ModifierInterface, CR.Clamp)
end

@testitem "Depletion pullback matches the local Jacobian" setup = [ModifierChecks] begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    v, s = [3.0, 0.5, 8.0], [150.0, 40.0, 90.0]
    for form in (:hazard, :floor), α in (1.0, 0.8, 1.3)
        # Scalar N and per-stratum N, each with the exponent as a parameter.
        c = ModifierChecks.check_pullback(
            θ -> CR.Depletion(θ[1]; form, heterogeneity = θ[2]),
            [200.0, α], v, s, 3
        )
        @test c.v && c.s && c.θ
        @test all(!iszero, c.θ̄)
        c = ModifierChecks.check_pullback(
            θ -> CR.Depletion(PerStratum(θ[1:3]); form, heterogeneity = θ[4]),
            [200.0, 60.0, 100.0, α], v, s, 3
        )
        @test c.v && c.s && c.θ
    end
    # The floor binds on the second stratum (negative pool).
    c = ModifierChecks.check_pullback(
        θ -> CR.Depletion(PerStratum(θ[1:3]); form = :floor, heterogeneity = θ[4]),
        [200.0, 60.0, 100.0, 1.0], v, [150.0, -5.0, 90.0], 1
    )
    @test c.v && c.s && c.θ
    # An exhausted pool (a seed larger than N) has a finite hazard pullback.
    m = CR.Depletion(200.0; heterogeneity = 1.3)
    v̄, s̄ = [0.5, 1.0, 0.2], [0.3, -0.2, 0.1]
    CR.apply_pullback!(
        ModifierChecks.mirror(m), m, v, [150.0, 0.0, 90.0], 1, v̄, s̄
    )
    @test all(isfinite, v̄) && all(isfinite, s̄)
end

@testitem "Depletion init pullback matches ForwardDiff" setup = [ModifierChecks] begin
    using ComposableRecurrences, ForwardDiff
    CR = ComposableRecurrences
    h = [1.0 2.0 3.0; 4.0 5.0 6.0; 50.0 60.0 70.0]
    s̄ = [0.7, -1.2, 0.4]
    for seeded in (false, true), N0 in ([100.0, 40.0, 60.0], [80.0])
        n = length(N0)
        pool(θ) = CR.init_state(
            CR.Depletion(n == 1 ? θ[1] : PerStratum(θ[1:n]); seeded),
            reshape(θ[(n + 1):end], 3, 3)
        )
        θ = vcat(N0, vec(h))
        expected = transpose(ForwardDiff.jacobian(pool, θ)) * s̄
        m = CR.Depletion(n == 1 ? N0[1] : PerStratum(N0); seeded)
        m̄ = ModifierChecks.mirror(m)
        h̄ = zero(h)
        CR.init_state_pullback!(m̄, h̄, m, h, s̄)
        @test ModifierChecks.flat(m̄.N) ≈ expected[1:n]
        @test vec(h̄) ≈ expected[(n + 1):end]
        # No history cotangent is asked for.
        CR.init_state_pullback!(ModifierChecks.mirror(m), nothing, m, h, s̄)
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
            CR.Depletion(PerStratum(θ[2:4]); seeded = true, heterogeneity = θ[5]),
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
    for I in (:secondary, :primary)
        a = TimeVarying(PerStratum(G); indexed_by = I)
        b = PerStratum(TimeVarying(G; indexed_by = I))
        @test typeof(a) === typeof(b) && a.x.x === b.x.x
    end
    ra = Recurrence(TimeVarying(PerStratum(G)))
    rb = Recurrence(PerStratum(TimeVarying(G)))
    @test typeof(ra) === typeof(rb) && ra.kernel.x.x === rb.kernel.x.x
    @test ra(R; history = h) == rb(R; history = h)
    ca = Convolution(TimeVarying(PerStratum(G); indexed_by = :primary))
    cb = Convolution(PerStratum(TimeVarying(G; indexed_by = :primary)))
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

@testitem "Options: an unknown name errors and names the hook" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    err = try
        CR.Depletion(1.0; form = :foo)
        nothing
    catch e
        e
    end
    @test err isa ArgumentError
    @test occursin(":foo", err.msg) && occursin(":hazard", err.msg) &&
        occursin(":floor", err.msg)
    @test occursin("ComposableRecurrences.option(::Val{:form}, ::Val{:foo})", err.msg)
    @test occursin("deplete", err.msg)
    @test_throws ArgumentError CR.option(Val(:colour), Val(:red))
end

@testitem "Options: resolved once, at construction" begin
    using ComposableRecurrences, JET
    CR = ComposableRecurrences
    for form in (:hazard, :floor)
        m = CR.Depletion(100.0; form)
        F = typeof(CR.option(Val(:form), Val(form)))
        @test m isa CR.Depletion{F}
        @test m.form === F()
        # The built-in maths is the form's deplete method.
        @test CR.apply(m, 2.0, 80.0, 1, 1) ==
            CR.deplete(m.form, 2.0, 80.0, 100.0, 1.0)
        # A step compiles to one path: no dispatch on the form at run time.
        @test (@inferred CR.apply(m, 2.0, 80.0, 1, 1)) isa Tuple{Float64, Float64}
        JET.@test_opt CR.apply(m, 2.0, 80.0, 1, 1)
    end
    # A literal form infers through the keyword constructor.
    floor_depletion() = ComposableRecurrences.Depletion(1.0; form = :floor)
    @test (@inferred floor_depletion()) isa CR.Depletion
    default_depletion() = ComposableRecurrences.Depletion(1.0)
    @test (@inferred default_depletion()) isa CR.Depletion
end

@testitem "Options: a user depletion form, with and without a pullback" setup = [ModifierChecks] begin
    using ComposableRecurrences, ForwardDiff
    CR = ComposableRecurrences
    # Take what is asked, up to the pool.
    struct Linear end
    CR.option(::Val{:form}, ::Val{:linear}) = Linear()
    CR.deplete(::Linear, v, s, N, α) = (y = min(v, s); (y, s - y))
    struct LinearWithPullback end
    CR.option(::Val{:form}, ::Val{:linear_pullback}) = LinearWithPullback()
    CR.deplete(::LinearWithPullback, v, s, N, α) = (y = min(v, s); (y, s - y))
    function CR.deplete_pullback(::LinearWithPullback, v, s, N, α, ȳ, s̄′)
        z = zero(ȳ)
        return v < s ? (ȳ - s̄′, s̄′, z, z) : (z, ȳ, z, z)
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
    for form in (:linear, :linear_pullback)
        d = CR.Depletion(100.0; form)
        y = Recurrence([0.5, 0.5]; modifiers = (d,))(R; history = h)
        @test y ≈ naive(R, 100.0)
        # The pool runs out, so both branches of the form are used.
        @test y[end] < R[end] * (0.5 * y[end - 1] + 0.5 * y[end - 2])
        run(θ) = Recurrence([0.5, 0.5]; modifiers = (CR.Depletion(θ[1]; form),))(
            θ[2:end]; history = h
        )
        @test ForwardDiff.gradient(θ -> sum(run(θ)), vcat(100.0, R)) ≈ ∇ref
    end
    # The pullback matches the local Jacobian on both branches.
    c = ModifierChecks.check_pullback(
        θ -> CR.Depletion(θ[1]; form = :linear_pullback, heterogeneity = θ[2]),
        [100.0, 1.0], [2.0, 5.0], [4.0, 3.0], 1
    )
    @test c.v && c.s && c.θ
end
