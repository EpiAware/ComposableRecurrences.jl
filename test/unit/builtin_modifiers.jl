# The built-in modifiers: Depletion, Imports, Redistribute and Clamp.
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
    m = CR.Depletion(N; seeded = true)
    @test CR.init_state(m, h) ≈ [97.0, 46.0]
    @test CR.init_state(CR.Depletion(80.0), h) == [80.0, 80.0]
    @test_throws DimensionMismatch CR.init_state(CR.Depletion([1.0, 2.0, 3.0]), h)
    @test_throws ArgumentError CR.Depletion(1.0; form = :other)
    r = Recurrence([0.4, 0.6]; coupling = [0.9 0.1; 0.2 0.8], modifiers = (m,))
    y = r(fill(1.5, 2, 6); history = h)
    @test size(y) == (2, 6)
    @test all(y .>= 0)
end

@testitem "Imports: scalar, per-time and per-stratum-time" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    g = [0.5, 0.5]
    h = [1.0 1.0; 2.0 2.0]
    base(add) = Recurrence(g)(1.1; history = h, add)
    b = [0.1 0.2 0.3 0.4; 0.5 0.6 0.7 0.8]
    r(b) = Recurrence(g; modifiers = (CR.Imports(b),))
    # Alone, imports are the same as `add`.
    @test r(0.5)(1.1; history = h, add = zeros(2, 4)) ≈ base(fill(0.5, 2, 4))
    @test r(b[1, :])(1.1; history = h, add = zeros(2, 4)) ≈
        base(repeat(b[1:1, :], 2))
    @test r(b)(1.1; history = h, add = zeros(2, 4)) ≈ base(b)
    # Read at the absolute time index.
    y = r(b)(1.1; history = h, add = zeros(2, 2), start = 3)
    @test y ≈ Recurrence(g)(1.1; history = h, add = b[:, 3:4])
end

@testitem "Imports after depletion are not depleted" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    g = [1.0]
    b = [0.5, 1.0, 2.0]
    d = CR.Depletion(10.0; form = :floor)
    y = Recurrence(g; modifiers = (d, CR.Imports(b)))(1.0; history = [2.0], add = zeros(3))
    S, prev, out = 10.0, 2.0, Float64[]
    for t in 1:3
        v = S / 10 * prev
        S -= v
        prev = v + b[t]
        push!(out, prev)
    end
    @test y ≈ out
end

@testitem "Redistribute: conserving, against a naive loop" begin
    using ComposableRecurrences
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
            (0.1, fill(0.1, 3)), ([0.1, 0.2, 0.05], [0.1, 0.2, 0.05]),
            (TimeVarying([0.1 0.3; 0.2 0.1; 0.05 0.2]), [0.3, 0.1, 0.2]),
        )
        x, s = copy(v), zeros(3)
        CR.apply!(CR.Redistribute(K, ε), x, s, 2)
        @test x ≈ naive(εv)
        # What moves is conserved; the state is the arrivals in each stratum.
        @test sum(x) ≈ sum(v)
        @test s ≈ [sum(εv[q] * Ktrue[p, q] * v[q] for q in 1:3 if q != p) for p in 1:3]
    end
    @test_throws DimensionMismatch CR.Redistribute(ones(2, 3), 0.1)
end

@testitem "Clamp: bounds, scalar and per stratum" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    v, s = [-1.0, 0.5, 3.0], zeros(3)
    CR.apply!(CR.Clamp(0.0, 1.0), v, s, 1)
    @test v == [0.0, 0.5, 1.0]
    v = [-1.0, 0.5, 3.0]
    CR.apply!(CR.Clamp([-2.0, 0.6, 0.0], [0.0, 1.0, 2.0]), v, s, 1)
    @test v == [-1.0, 0.6, 2.0]
    y = Recurrence([2.0]; modifiers = (CR.Clamp(0.0, 5.0),))(1.0; history = [1.0], add = zeros(4))
    @test y == [2.0, 4.0, 5.0, 5.0]
end

@testitem "Built-in modifiers implement the modifier interface" begin
    using ComposableRecurrences, Interfaces
    CR = ComposableRecurrences
    @test Interfaces.implements(CR.ModifierInterface, CR.Depletion)
    @test Interfaces.implements(CR.ModifierInterface, CR.Imports)
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
            θ -> CR.Depletion(θ[1:3]; form, heterogeneity = θ[4]),
            [200.0, 60.0, 100.0, α], v, s, 3
        )
        @test c.v && c.s && c.θ
    end
    # The floor binds on the second stratum (negative pool).
    c = ModifierChecks.check_pullback(
        θ -> CR.Depletion(θ[1:3]; form = :floor, heterogeneity = θ[4]),
        [200.0, 60.0, 100.0, 1.0], v, [150.0, -5.0, 90.0], 1
    )
    @test c.v && c.s && c.θ
end

@testitem "Depletion init pullback matches ForwardDiff" setup = [ModifierChecks] begin
    using ComposableRecurrences, ForwardDiff
    CR = ComposableRecurrences
    h = [1.0 2.0 3.0; 4.0 5.0 6.0; 50.0 60.0 70.0]
    s̄ = [0.7, -1.2, 0.4]
    for seeded in (false, true), N0 in ([100.0, 40.0, 60.0], [80.0])
        n = length(N0)
        pool(θ) = CR.init_state(
            CR.Depletion(n == 1 ? θ[1] : θ[1:n]; seeded),
            reshape(θ[(n + 1):end], 3, 3)
        )
        θ = vcat(N0, vec(h))
        expected = transpose(ForwardDiff.jacobian(pool, θ)) * s̄
        m = CR.Depletion(n == 1 ? N0[1] : N0; seeded)
        m̄ = ModifierChecks.mirror(m)
        h̄ = zero(h)
        CR.init_pullback!(m̄, m, h, h̄, s̄)
        @test ModifierChecks.flat(m̄) ≈ expected[1:n]
        @test vec(h̄) ≈ expected[(n + 1):end]
        # No history cotangent is asked for.
        CR.init_pullback!(ModifierChecks.mirror(m), m, h, nothing, s̄)
    end
end

@testitem "Imports pullback matches the local Jacobian" setup = [ModifierChecks] begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    v, s = [1.0, 2.0], [0.3, 0.4]
    c = ModifierChecks.check_pullback(θ -> CR.Imports(θ[1]), [0.7], v, s, 2)
    @test c.v && c.s && c.θ
    @test c.θ̄[1] != 0
    c = ModifierChecks.check_pullback(θ -> CR.Imports(θ), [0.1, 0.2, 0.3], v, s, 2)
    @test c.v && c.s && c.θ
    c = ModifierChecks.check_pullback(
        θ -> CR.Imports(reshape(θ, 2, 3)), collect(0.1:0.1:0.6), v, s, 3
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
        θ -> CR.Redistribute(Kof(θ), θ[10:12]), vcat(K, [0.1, 0.2, 0.05]),
        v, s, 1
    )
    @test c.v && c.s && c.θ
    c = ModifierChecks.check_pullback(
        θ -> CR.Redistribute(Kof(θ), TimeVarying(reshape(θ[10:15], 3, 2))),
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
        θ -> CR.Clamp(θ[1:3], θ[4:6]), [-2.0, 0.6, 0.0, 0.0, 1.0, 2.0], v, s, 1
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
            CR.Depletion(θ[2:4]; seeded = true, heterogeneity = θ[5]),
            CR.Imports(θ[6]),
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
