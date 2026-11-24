# Transform: a pointwise map with parameters. Values against naive loops,
# the pullback against a local ForwardDiff Jacobian of its Step, a supplied
# derivative, and a map carrying its own parameters.

@testitem "Transform: a map of each value against a naive loop" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    g = [0.6, 0.4]
    h = [1.0, 2.0]
    R = [1.2, 0.8, 1.5, 1.1, 0.9]
    function naive(f)
        y = copy(h)
        for t in eachindex(R)
            push!(y, f(R[t] * (g[1] * y[end] + g[2] * y[end - 1]), t))
        end
        return y[3:end]
    end
    run(m) = Recurrence(g; modifiers = (m,))(R; history = h)
    # Without a parameter the map is called with the value alone.
    @test run(CR.Transform(log1p)) ≈ naive((v, t) -> log1p(v))
    sat(v, θ) = θ * v / (1 + v)
    @test run(CR.Transform(sat, 2.0)) ≈ naive((v, t) -> sat(v, 2.0))
    # A NamedTuple parameter is passed entry by entry.
    lin(v, θ) = θ.a * v + θ.b
    @test run(CR.Transform(lin, (; a = 0.5, b = 0.1))) ≈
        naive((v, t) -> 0.5v + 0.1)
    # A time-varying parameter is read at the absolute time.
    θt = [0.5, 1.0, 1.5, 2.0, 2.5]
    @test run(CR.Transform(sat, TimeVarying(θt))) ≈
        naive((v, t) -> sat(v, θt[t]))
    # Any callable.
    struct Power end
    (::Power)(v) = sqrt(v)
    @test run(CR.Transform(Power())) ≈ naive((v, t) -> sqrt(v))
end

@testitem "Transform: per-stratum parameters" setup = [Reference] begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    S, T = 3, 5
    g = [0.5, 0.3]
    h = [1.0 2.0; 0.5 1.0; 2.0 0.5]
    R = [1.0 + 0.1 * (a + t) for a in 1:S, t in 1:T]
    sat(v, θ) = θ.a * v / (1 + θ.b * v)
    a, b = [1.0, 2.0, 3.0], 0.5
    A = [0.5 + 0.1 * (k + t) for k in 1:S, t in 1:T]
    w(t, k, j, i) = k == j ? g[i] : 0.0
    function ref(θk)
        post!(v, t) = (v .= [sat(v[k], θk(k, t)) for k in 1:S])
        return naive_recurrence(w, h, T; gain = (k, t) -> R[k, t], post!)
    end
    r(θ) = Recurrence(g; modifiers = (CR.Transform(sat, θ),))(R; history = h)
    @test r((; a = PerStratum(a), b)) ≈ ref((k, t) -> (; a = a[k], b))
    @test r((; a = TimeVarying(PerStratum(A)), b)) ≈
        ref((k, t) -> (; a = A[k, t], b))
    @test Recurrence(g; modifiers = (CR.Transform(*, PerStratum(a)),))(
        R; history = h
    ) ≈ naive_recurrence(
        w, h, T; gain = (k, t) -> R[k, t], post! = (v, t) -> (v .*= a)
    )
end

@testitem "Transform: argument validation" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    # Per stratum is PerStratum, and a plain matrix is strata × time.
    @test_throws ArgumentError CR.Transform(*, [1.0, 2.0])
    θ = CR.Transform(*, ones(2, 3)).θ
    @test θ isa TimeVarying{CR.Secondary, <:PerStratum{<:Matrix}}
    @test θ.x.x == ones(2, 3)
    @test_throws ArgumentError CR.Transform(*, (; a = [1.0, 2.0]))
    # Entries are flat.
    @test_throws ArgumentError CR.Transform(*, (; a = (1.0, 2.0)))
    @test_throws ArgumentError CR.Transform(*, (1.0, nothing))
    r = Recurrence([0.5]; modifiers = (CR.Transform(*, PerStratum([1.0, 2.0])),))
    @test_throws DimensionMismatch r(ones(3, 4); history = ones(3, 1))
end

@testitem "Transform pullback matches the local Jacobian" setup = [ModifierChecks] begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    v, s = [0.3, 0.6, 0.9], [0.1, 0.2, 0.3]
    nb(v, θ) = (θ.p / (1 - (1 - θ.p) * v))^θ.r
    c = ModifierChecks.check_pullback(θ -> CR.Transform(log1p), Float64[], v, s, 1)
    @test c.v && c.s && c.θ
    c = ModifierChecks.check_pullback(
        θ -> CR.Transform((v, a) -> a * v^2, θ[1]), [1.5], v, s, 1
    )
    @test c.v && c.s && c.θ
    @test c.θ̄[1] != 0
    c = ModifierChecks.check_pullback(
        θ -> CR.Transform(nb, (; r = θ[1], p = θ[2])), [0.5, 0.4], v, s, 1
    )
    @test c.v && c.s && c.θ
    @test all(!iszero, c.θ̄)
    c = ModifierChecks.check_pullback(
        θ -> CR.Transform(nb, (; r = PerStratum(θ[1:3]), p = θ[4])),
        [0.5, 0.8, 1.2, 0.4], v, s, 1
    )
    @test c.v && c.s && c.θ
    c = ModifierChecks.check_pullback(
        θ -> CR.Transform(
            nb, (; r = θ[1], p = TimeVarying(PerStratum(reshape(θ[2:7], 3, 2))))
        ),
        [0.5, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8], v, s, 2
    )
    @test c.v && c.s && c.θ
    c = ModifierChecks.check_pullback(
        θ -> CR.Transform(*, TimeVarying(θ)), [0.5, 2.0], v, s, 2
    )
    @test c.v && c.s && c.θ
    # Transform(+, b): scalar, per-stratum and time-varying shifts.
    for (b, θ, t) in (
            (θ -> θ[1], [0.5], 1),
            (θ -> PerStratum(θ), [0.5, 0.8, 1.2], 1),
            (θ -> TimeVarying(θ), [0.5, 2.0], 2),
        )
        c = ModifierChecks.check_pullback(θ -> CR.Transform(+, b(θ)), θ, v, s, t)
        @test c.v && c.s && c.θ
        @test any(!iszero, c.θ̄)
    end
end

@testitem "Transform: a local rule replaces the forward-mode derivative" setup = [ModifierChecks] begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    v, s = [0.3, 0.6, 0.9], [0.1, 0.2, 0.3]
    const calls = Ref(0)
    struct ScaledExp end
    (::ScaledExp)(v, θ) = θ.a * exp(θ.b * v)
    function CR.pullback!(grads, ::ScaledExp, ::CR.Local, y, v, θ)
        calls[] += 1
        e = exp(θ.b * v)
        return θ.a * θ.b * e, (; a = e, b = θ.a * v * e)
    end
    c = ModifierChecks.check_pullback(
        θ -> CR.Transform(ScaledExp(), (; a = θ[1], b = θ[2])), [1.5, 0.7], v, s, 1
    )
    @test c.v && c.s && c.θ
    @test calls[] == length(v)
    # Without a parameter the rule takes the value alone, and returns one
    # partial.
    calls[] = 0
    struct Exp1 end
    (::Exp1)(v) = exp(v)
    CR.pullback!(grads, ::Exp1, ::CR.Local, y, v) = (calls[] += 1; (y,))
    c = ModifierChecks.check_pullback(θ -> CR.Transform(Exp1()), Float64[], v, s, 1)
    @test c.v && c.s && c.θ
    @test calls[] == length(v)
end

@testitem "Transform: a local rule reads the step's output rather than recomputing it" setup = [AdjointCheck] begin
    using ComposableRecurrences, LinearAlgebra
    const calls, wrong = Ref(0), Ref(0)
    nb(v, θ) = (θ.p / (1 - (1 - θ.p) * v))^θ.r
    struct CountedNB end
    (::CountedNB)(v, θ) = (calls[] += 1; nb(v, θ))
    # The output `y` replaces the power in both partial derivatives.
    function CR.pullback!(grads, ::CountedNB, ::CR.Local, y, v, θ)
        y == nb(v, θ) || (wrong[] += 1)
        D = 1 - (1 - θ.p) * v
        return y * θ.r * (1 - θ.p) / D,
            (; r = y * log(θ.p / D), p = y * θ.r * (1 - v) / (θ.p * D))
    end
    S = 3
    θ = (; r = PerStratum([0.5, 0.7, 0.9]), p = PerStratum([0.3, 0.4, 0.5]))
    m = CR.Transform(CountedNB(), θ)
    g = [0.5, 0.3, 0.2]
    R = [0.8 + 0.1 * sin(k + t) for k in 1:S, t in 1:12]
    h = fill(0.1, S, 3)
    K = fill(0.1, S, S) + 0.7I
    # Strata on their own, alone and with a map after it, and strata mixed by
    # a coupling, alone and with a map after it.
    for r in (
            Recurrence(g; modifiers = (m,)),
            Recurrence(g; modifiers = (m, CR.Transform(+, 0.01))),
            Recurrence(g; coupling = K, modifiers = (m,)),
            Recurrence(g; coupling = K, modifiers = (m, CR.Transform(+, 0.01))),
        )
        args = recargs(R, nothing, h)
        @test pullback_matches(r, args...)
        y, cache = CR._run_forward(r, args...)
        calls[], wrong[] = 0, 0
        ms = zero_mirror((r, args...))
        grads = (; piece = first(ms), y = one.(y), args = Base.tail(ms))
        CR._run_pullback!(grads, r, cache)
        @test calls[] == 0
        @test wrong[] == 0
    end
    # Without a step output, as in a single step's pullback, it is
    # recomputed, giving the local derivative's cotangents.
    mirror() = (; f = (;), θ = (; r = (; x = zeros(S)), p = (; x = zeros(S))))
    m̄, m̄0 = mirror(), mirror()
    calls[] = 0
    out = CR._step_back((; piece = m̄, v = 1.0, s = 0.0), m, 0.3, 0.0, 1, 2)
    @test calls[] == 1
    @test wrong[] == 0
    m0 = CR.Transform(nb, θ)
    @test all(out .≈ CR._step_back((; piece = m̄0, v = 1.0, s = 0.0), m0, 0.3, 0.0, 1, 2))
    @test m̄.θ.r.x ≈ m̄0.θ.r.x && m̄.θ.p.x ≈ m̄0.θ.p.x
end

@testitem "Transform: Float32 and no allocation in the pullback" begin
    using ComposableRecurrences, ForwardDiff
    CR = ComposableRecurrences
    nb(v, θ) = (θ.p / (1 - (1 - θ.p) * v))^θ.r
    m = CR.Transform(nb, (; r = 0.5f0, p = 0.4f0))
    y = Recurrence([1.0f0]; modifiers = (m,))(; history = [0.0f0], stop = 5)
    @test eltype(y) == Float32
    m̄ = (; f = (;), θ = (; r = Ref(0.0f0), p = Ref(0.0f0)))
    grads = (; piece = m̄, v = 1.0f0, s = 0.0f0)
    out = CR._step_back(grads, m, 0.3f0, 0.0f0, 1, 1)
    @test out isa Tuple{Float32, Float32}
    @test m̄.θ.r[] isa Float32 && m̄.θ.r[] != 0
    # `CR` is a non-constant global here, so call through the module.
    function alloc(grads, m)
        pb(grads, m) = ComposableRecurrences._step_back(grads, m, 0.3f0, 0.0f0, 1, 1)
        pb(grads, m)
        return @allocated pb(grads, m)
    end
    # Coverage instrumentation allocates, so the count is checked only
    # without it.
    coverage = Base.JLOptions().code_coverage != 0
    @test alloc(grads, m) == 0 skip = coverage
    m = CR.Transform(nb, (; r = PerStratum([0.5f0, 0.7f0]), p = 0.4f0))
    m̄ = (; f = (;), θ = (; r = (; x = zeros(Float32, 2)), p = Ref(0.0f0)))
    @test alloc((; piece = m̄, v = 1.0f0, s = 0.0f0), m) == 0 skip = coverage
end

@testitem "Transform: a map carrying parameters is differentiated whole" setup = [ReferenceAD] begin
    using ComposableRecurrences, ForwardDiff
    CR = ComposableRecurrences
    # A field-free map takes the local derivative; a closure or callable
    # struct with a float field is left to the AD backend, so its captured
    # values keep their gradient.
    struct Scale{T}
        a::T
    end
    (f::Scale)(v) = f.a * v
    @test CR._local_derivative(CR.Transform(log1p))
    @test CR._local_derivative(CR.Transform((v, θ) -> θ * v, 2.0))
    @test !CR._local_derivative(CR.Transform(Scale(2.0)))
    scaled(b) = v -> b * v
    @test !CR._local_derivative(CR.Transform(scaled(0.3)))
    w = range(0.5, 2.0; length = 6)
    loss(a) = sum(
        w .* Recurrence([0.5, 0.5]; modifiers = (CR.Transform(Scale(a)),))(
            fill(1.2, 6); history = ones(2)
        )
    )
    fd = (loss(1.5 + 1.0e-6) - loss(1.5 - 1.0e-6)) / 2.0e-6
    @test ReferenceAD.derivative(loss, 1.5) ≈ fd rtol = 1.0e-6
end

@testitem "Transform: ForwardDiff through a recurrence" setup = [ReferenceAD] begin
    using ComposableRecurrences, ForwardDiff
    CR = ComposableRecurrences
    nb(v, θ) = (θ.p / (1 - (1 - θ.p) * v))^θ.r
    w = range(0.5, 2.0; length = 8)
    function loss(θ)
        m = CR.Transform(nb, (; r = θ[1], p = θ[2]))
        return sum(w .* Recurrence([1.0]; modifiers = (m,))(; history = [0.0], stop = 8))
    end
    θ = [0.5, 0.4]
    ∇ = ReferenceAD.gradient(loss, θ)
    fd = map(eachindex(θ)) do i
        e = zeros(2)
        e[i] = 1.0e-6
        (loss(θ + e) - loss(θ - e)) / 2.0e-6
    end
    @test ∇ ≈ fd rtol = 1.0e-6
end

@testitem "Transform: the local derivative runs on an outer dual" begin
    using ComposableRecurrences, ForwardDiff
    CR = ComposableRecurrences
    # The derivative also runs on an outer dual, as in forward-over-reverse.
    # Each entry's cotangent depends on every entry (∂²f/∂p∂r ≠ 0), so the
    # mirror takes the modifier's promoted eltype, not each entry's own.
    nb(v, θ) = (θ.p / (1 - (1 - θ.p) * v))^θ.r
    m(r) = CR.Transform(nb, (; r, p = 0.4))
    function pb(r)
        T = CR.param_eltype(m(r))
        θ̄ = (; r = Ref(zero(T)), p = Ref(zero(T)))
        grads = (; piece = (; θ = θ̄), v = 1.0, s = 0.0)
        v̄, _ = CR._step_back(grads, m(r), 0.3, 0.0, 1, 1)
        return v̄, θ̄.p[]
    end
    ∂v(r) = ForwardDiff.derivative(v -> nb(v, (; r, p = 0.4)), 0.3)
    ∂p(r) = ForwardDiff.derivative(p -> nb(0.3, (; r, p)), 0.4)
    @test ForwardDiff.derivative(r -> pb(r)[1], 0.5) ≈
        ForwardDiff.derivative(∂v, 0.5)
    @test ForwardDiff.derivative(r -> pb(r)[2], 0.5) ≈
        ForwardDiff.derivative(∂p, 0.5)
end

@testitem "Transform: pullback edge cases and refusals" begin
    using ComposableRecurrences, ForwardDiff
    CR = ComposableRecurrences
    # A map whose output does not depend on its inputs has zero partials.
    @test CR._forward_derivative((v, θ) -> 1.0, 0.3, (; a = 2.0)) ==
        (0.0, (; a = 0.0))
    # A map with float fields and no derivative is left to the AD backend.
    struct Shift{T}
        b::T
    end
    (f::Shift)(v) = v + f.b
    grads = (; piece = nothing, v = 1.0, s = 0.0)
    @test_throws "differentiated by the AD backend" CR._step_back(
        grads, CR.Transform(Shift(0.5)), 0.3, 0.0, 1, 1
    )
    # Without a θ mirror only the value cotangent is returned.
    m = CR.Transform((v, θ) -> θ.a * v^2, (; a = 2.0))
    @test CR._step_back(grads, m, 0.3, 0.0, 1, 1) == (1.2, 0.0)
    # Init has no parameters to pull back.
    @test CR.pullback!(grads, m, CR.Init(), zeros(2), ones(2, 1)) === nothing
end

@testitem "Transform: local derivative helpers called directly" begin
    using ComposableRecurrences, ForwardDiff
    CR = ComposableRecurrences
    # Each method runs on its own here, not only inlined into a caller.
    m = CR.Transform((v, θ) -> θ[1] * v^2 + θ[2], (2.0, 0.5))
    @test CR.ispointwise(m)
    @test !CR._scalar_params(m)
    @test CR._forward_derivative(v -> v^2, 0.3, nothing) == (0.6, nothing)
    @test CR._forward_derivative((v, a) -> a * v^2, 0.3, 2.0) == (1.2, 0.09)
    # A Tuple of parameters keeps its form.
    ∂v, ∂θ = CR._forward_derivative(m.f, 0.3, m.θ)
    @test ∂v ≈ 1.2 && ∂θ isa Tuple && collect(∂θ) ≈ [0.09, 1.0]
    @test CR._restructure((1.0, 2.0), (3.0, 4.0)) == (3.0, 4.0)
    xs = CR._transform_seeds((0.3, 2.0))
    @test ForwardDiff.value.(xs) == (0.3, 2.0)
    @test CR._transform_partials(xs[1] * xs[2], Val(2)) == (2.0, 0.3)
    θ̄ = (Ref(0.0), Ref(0.0))
    @test CR._add_theta!(θ̄, m.θ, ∂θ, 2.0, 1, 1) === nothing
    @test θ̄[1][] ≈ 0.18 && θ̄[2][] ≈ 2.0
    # The pullback with a Tuple of parameters.
    grads = (; piece = (; θ = (Ref(0.0), Ref(0.0))), v = 1.0, s = 0.0)
    @test CR._step_back(grads, m, 0.3, 0.0, 1, 1)[1] ≈ 1.2
    @test grads.piece.θ[2][] ≈ 1.0
end

@testitem "Transform: the rule covers it unless the map has float fields" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    nb(v, θ) = (θ.p / (1 - (1 - θ.p) * v))^θ.r
    struct Shift{T}
        b::T
    end
    (f::Shift)(v, θ) = θ * v + f.b
    rule(m) = CR.uses_adjoint(Recurrence([0.5]; modifiers = (m,)), CR.Run())
    # Scalars, per-stratum vectors, time-varying and named tuples of them.
    for (f, θ) in (
            (*, 0.5), (*, PerStratum([0.5, 0.7])), (*, TimeVarying([0.5, 0.6])),
            (nb, (; r = PerStratum([0.5, 0.7]), p = TimeVarying(PerStratum(ones(2, 3))))),
        )
        m = CR.Transform(f, θ)
        @test CR.uses_adjoint(m, CR.Step())
        @test rule(m)
    end
    @test rule(CR.Transform(log1p))
    # A map with float fields is left to plain AD, with or without θ arrays.
    @test !CR.uses_adjoint(CR.Transform(Shift(0.1), 2.0), CR.Step())
    @test !rule(CR.Transform(Shift(0.1), 2.0))
    @test !rule(CR.Transform(Shift(0.1), PerStratum([1.0, 2.0])))
end

@testitem "Transform: maps with their own pullbacks need no dual numbers" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    whys(m) = CR._dual_whys([0.5], CR.I, (m,))
    # `clamp`, `+` without `b` and `*` take their own pullbacks, so a call
    # without `ForwardDiff` still takes the rule.
    @test isempty(whys(CR.Transform(clamp, 0.0, 2.0)))
    @test isempty(whys(CR.Transform(clamp, 0.0, TimeVarying([1.0, 2.0]))))
    @test isempty(whys(CR.Transform(+)))
    # A map without a local rule takes the forward-mode derivative, which
    # needs `ForwardDiff`.
    @test length(whys(CR.Transform(^, 0.5))) == 1
    @test length(whys(CR.Transform((v, θ) -> θ * v, 0.5))) == 1
    # A map with a local rule needs none: the package's own for `*` and `+`,
    # and a user's for a type they own.
    @test isempty(whys(CR.Transform(*, 0.5)))
    @test isempty(whys(CR.Transform(+, 0.5)))
    struct Times end
    (::Times)(v, θ) = θ * v
    CR.pullback!(grads, ::Times, ::CR.Local, y, v, θ) = (θ, v)
    @test isempty(whys(CR.Transform(Times(), 0.5)))
    @test CR._wants_output(CR.Transform(Times(), 0.5))
    @test !CR._wants_output(CR.Transform((v, θ) -> θ * v, 0.5))
end

@testitem "Transform implements the role interface" begin
    using ComposableRecurrences, Interfaces
    CR = ComposableRecurrences
    @test Interfaces.implements(CR.PieceInterface, CR.Transform)
end

@testitem "Transform(*, γ): its own pullback, and a gain on the added values" setup = [ModifierChecks] begin
    using ComposableRecurrences, ForwardDiff, Mooncake, Test
    CR = ComposableRecurrences
    v, s = [0.3, 0.6, 0.9], [0.1, 0.2, 0.3]
    for (γ, θ, t) in (
            (θ -> θ[1], [1.5], 1),
            (θ -> PerStratum(θ), [0.5, 0.8, 1.2], 1),
            (θ -> TimeVarying(PerStratum(reshape(θ, 3, 2))), 0.5:0.1:1.0, 2),
        )
        m = CR.Transform(*, γ(θ))
        @test CR._own_pullback(m)
        @test !CR._needs_duals(m)
        c = ModifierChecks.check_pullback(θ -> CR.Transform(*, γ(θ)), θ, v, s, t)
        @test c.v && c.s && c.θ
        @test any(!iszero, c.θ̄)
    end
    # Before the other modifiers, it scales the added values with the
    # kernel's: the same as passing γ as the gain and γ .* a as `add`.
    T = 8
    γ = [1.0 + 0.1 * k + 0.02 * t for k in 1:2, t in 1:T]
    a = [0.3 + 0.05 * k * t for k in 1:2, t in 1:T]
    h = ones(2, 2)
    m = CR.Transform(*, TimeVarying(PerStratum(γ)))
    scaled = Recurrence([0.5, 0.3]; modifiers = (m,))
    @test scaled(1.0; history = h, add = a, stop = T) ≈
        Recurrence([0.5, 0.3])(γ; history = h, add = γ .* a)
    # The rule's gradients in γ and in the added values, against ForwardDiff
    # of plain AD.
    W = [sin(k + t) for k in 1:2, t in 1:T]
    function loss(op, x)
        γx, ax = reshape(x[1:(2T)], 2, T), reshape(x[(2T + 1):end], 2, T)
        r = Recurrence(
            [0.5, 0.3]; modifiers = (CR.Transform(*, TimeVarying(PerStratum(γx))),)
        )
        return sum(W .* op(r)(1.0; history = h, add = ax, stop = T))
    end
    x = vcat(vec(γ), vec(a))
    expected = ForwardDiff.gradient(x -> loss(CR.NoAdjoint, x), x)
    f = x -> loss(identity, x)
    n0 = CR._PULLBACK_CALLS[]
    rule = Mooncake.build_rrule(f, x)
    @test Mooncake.value_and_gradient!!(rule, f, x)[2][2] ≈ expected
    @test CR._PULLBACK_CALLS[] > n0
end
