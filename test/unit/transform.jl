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
    # Per stratum is PerStratum, strata × time is TimeVarying(PerStratum(x)).
    @test_throws ArgumentError CR.Transform(*, [1.0, 2.0])
    @test_throws ArgumentError CR.Transform(*, ones(2, 3))
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
end

@testitem "Transform: a supplied derivative replaces the local one" setup = [ModifierChecks] begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    v, s = [0.3, 0.6, 0.9], [0.1, 0.2, 0.3]
    calls = Ref(0)
    f(v, θ) = θ.a * exp(θ.b * v)
    function df(v, θ)
        calls[] += 1
        e = exp(θ.b * v)
        return θ.a * θ.b * e, (; a = e, b = θ.a * v * e)
    end
    c = ModifierChecks.check_pullback(
        θ -> CR.Transform(f, (; a = θ[1], b = θ[2]); derivative = df),
        [1.5, 0.7], v, s, 1
    )
    @test c.v && c.s && c.θ
    @test calls[] == length(v)
    # Without a parameter the derivative takes the value alone.
    calls[] = 0
    dexp(v) = (calls[] += 1; exp(v))
    c = ModifierChecks.check_pullback(
        θ -> CR.Transform(exp; derivative = dexp), Float64[], v, s, 1
    )
    @test c.v && c.s && c.θ
    @test calls[] == length(v)
end

@testitem "Transform: Float32 and no allocation in the pullback" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    nb(v, θ) = (θ.p / (1 - (1 - θ.p) * v))^θ.r
    m = CR.Transform(nb, (; r = 0.5f0, p = 0.4f0))
    y = Recurrence([1.0f0]; modifiers = (m,))(; history = [0.0f0], stop = 5)
    @test eltype(y) == Float32
    m̄ = (; f = (;), θ = (; r = Ref(0.0f0), p = Ref(0.0f0)), derivative = nothing)
    grads = (; piece = m̄, v = 1.0f0, s = 0.0f0)
    out = CR.pullback!(grads, m, CR.Step(), 0.3f0, 0.0f0, 1, 1)
    @test out isa Tuple{Float32, Float32}
    @test m̄.θ.r[] isa Float32 && m̄.θ.r[] != 0
    # `CR` is a non-constant global here, so call through the module.
    function alloc(grads, m)
        pb(grads, m) = ComposableRecurrences.pullback!(
            grads, m, ComposableRecurrences.Step(), 0.3f0, 0.0f0, 1, 1
        )
        pb(grads, m)
        return @allocated pb(grads, m)
    end
    @test alloc(grads, m) == 0
    m = CR.Transform(nb, (; r = PerStratum([0.5f0, 0.7f0]), p = 0.4f0))
    m̄ = (;
        f = (;), θ = (; r = (; x = zeros(Float32, 2)), p = Ref(0.0f0)),
        derivative = nothing,
    )
    @test alloc((; piece = m̄, v = 1.0f0, s = 0.0f0), m) == 0
end

@testitem "Transform: a map carrying parameters is differentiated whole" begin
    using ComposableRecurrences, ForwardDiff
    CR = ComposableRecurrences
    # A field-free map takes the local derivative; a closure or callable
    # struct with a float field is left to the AD backend, so its captured
    # values keep their gradient.
    struct Scale
        a::Float64
    end
    (f::Scale)(v) = f.a * v
    @test CR._local_derivative(CR.Transform(log1p))
    @test CR._local_derivative(CR.Transform((v, θ) -> θ * v, 2.0))
    @test !CR._local_derivative(CR.Transform(Scale(2.0)))
    b = 0.3
    @test !CR._local_derivative(CR.Transform(v -> b * v))
    @test CR._local_derivative(CR.Transform(Scale(2.0); derivative = v -> 2.0))
    w = range(0.5, 2.0; length = 6)
    loss(a) = sum(
        w .* Recurrence([0.5, 0.5]; modifiers = (CR.Transform(Scale(a)),))(
            fill(1.2, 6); history = ones(2)
        )
    )
    fd = (loss(1.5 + 1.0e-6) - loss(1.5 - 1.0e-6)) / 2.0e-6
    @test ForwardDiff.derivative(loss, 1.5) ≈ fd rtol = 1.0e-6
end

@testitem "Transform: ForwardDiff through a recurrence" begin
    using ComposableRecurrences, ForwardDiff
    CR = ComposableRecurrences
    nb(v, θ) = (θ.p / (1 - (1 - θ.p) * v))^θ.r
    w = range(0.5, 2.0; length = 8)
    function loss(θ)
        m = CR.Transform(nb, (; r = θ[1], p = θ[2]))
        return sum(w .* Recurrence([1.0]; modifiers = (m,))(; history = [0.0], stop = 8))
    end
    θ = [0.5, 0.4]
    ∇ = ForwardDiff.gradient(loss, θ)
    fd = map(eachindex(θ)) do i
        e = zeros(2)
        e[i] = 1.0e-6
        (loss(θ + e) - loss(θ - e)) / 2.0e-6
    end
    @test ∇ ≈ fd rtol = 1.0e-6
end

@testitem "Transform implements the piece interface" begin
    using ComposableRecurrences, Interfaces
    CR = ComposableRecurrences
    @test Interfaces.implements(CR.PieceInterface, CR.Transform)
end
