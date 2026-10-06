# Derived: a parameter computed from parameters. Values against naive loops,
# the arithmetic sugar, construction checks and the local derivative.

@testitem "Derived: values against a naive loop" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    g = [0.6, 0.3]
    h = [0.5 1.0; 2.0 1.5]
    S, T = 2, 6
    R = [1.0 + 0.1 * (k + t) for k in 1:S, t in 1:T]
    ι = [0.1 * t for t in 1:T]
    A = [0.5 + 0.1 * k * t for k in 1:S, t in 1:T]
    κ = 0.7
    # The reference: the renewal step, then `post!(v, t)`.
    function naive(post!)
        y = copy(h)
        for t in 1:T
            v = R[:, t] .* (g[1] .* y[:, end] .+ g[2] .* y[:, end - 1])
            post!(v, t)
            y = hcat(y, v)
        end
        return y[:, 3:end]
    end
    run(ms...) = Recurrence(g; modifiers = ms)(R; history = h)
    # Derived of a time-varying and a scalar parameter in `Add`.
    b = Derived((x, c) -> c * exp(x), TimeVarying(ι), κ)
    @test run(CR.Add(b)) ≈ naive((v, t) -> (v .+= κ * exp(ι[t])))
    # Derived of a per-stratum, time-varying parameter in `Transform`.
    β = Derived(sqrt, TimeVarying(PerStratum(A)))
    @test run(CR.Transform(*, β)) ≈ naive((v, t) -> (v .*= sqrt.(A[:, t])))
    # Nested Derived, and a Derived bound in `Clamp`.
    hi = Derived(+, Derived(abs2, PerStratum([1.0, 2.0])), 0.5)
    @test run(CR.Clamp(0.0, hi)) ≈
        naive((v, t) -> (v .= min.(v, [1.0, 4.0] .+ 0.5)))
    # A constant Derived population in `Depletion`.
    N = Derived(*, 10.0, PerStratum([3.0, 5.0]))
    @test run(CR.Depletion(N)) ≈ run(CR.Depletion(PerStratum([30.0, 50.0])))
end

@testitem "Derived: arithmetic lowers to Derived" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    x = Derived(exp, TimeVarying(PerStratum([0.1 0.2 0.3; 0.4 0.5 0.6])))
    c, N = 0.3, PerStratum([2.0, 4.0])
    pairs = (
        (2.0 * x, Derived(*, 2.0, x)), (x * 2.0, Derived(*, x, 2.0)),
        (x + c, Derived(+, x, c)), (c - x, Derived(-, c, x)),
        (x / N, Derived(/, x, N)), (x^2, Derived(^, x, 2)), (-x, Derived(-, x)),
        (x * x, Derived(*, x, x)), (TimeVarying([1.0, 2.0, 3.0]) + x, nothing),
    )
    for (sugar, explicit) in pairs
        @test sugar isa Derived
        explicit === nothing && continue
        @test typeof(sugar) == typeof(explicit)
        for k in 1:2, t in 1:3
            @test CR.param(sugar, k, t) == CR.param(explicit, k, t)
        end
    end
    @test CR.param(2.0 * x / N + 1, 2, 3) ≈ 2 * exp(0.6) / 4 + 1
    # A run with the sugar equals a run with the explicit form.
    g, R, h = [0.5, 0.4], fill(1.1, 2, 3), ones(2, 2)
    run(b) = Recurrence(g; modifiers = (CR.Add(b),))(R; history = h)
    @test run(0.5 * x + 1) == run(Derived(+, Derived(*, 0.5, x), 1))
    # Plain numbers and wrappers keep their own arithmetic.
    @test !hasmethod(*, Tuple{Float64, PerStratum{Vector{Float64}}})
    @test (@inferred CR.param(0.5 * x + 1, 1, 2)) isa Float64
end

@testitem "Derived: construction and checks" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    @test_throws ArgumentError Derived(exp)
    @test_throws ArgumentError Derived(exp, [1.0, 2.0])
    @test_throws ArgumentError Derived(exp, TimeVarying([1.0], CR.Primary()))
    # A population or starting pool is constant over time.
    @test_throws ArgumentError CR.Depletion(Derived(exp, TimeVarying([1.0, 2.0])))
    @test_throws ArgumentError CR.Depletion(10.0; pool0 = 2.0 * Derived(exp, TimeVarying([1.0])))
    # Strata and times are checked through the arguments.
    g, R, h = [0.5], fill(1.1, 2, 3), ones(2, 1)
    run(b) = Recurrence(g; modifiers = (CR.Add(b),))(R; history = h)
    @test_throws DimensionMismatch run(Derived(exp, TimeVarying([1.0, 2.0])))
    @test_throws DimensionMismatch Recurrence(
        g; modifiers = (CR.Depletion(Derived(exp, PerStratum([1.0, 2.0, 3.0]))),)
    )(R; history = h)
    # The element type promotes through the arguments.
    @test CR.param_eltype(Derived(*, 1.0f0, TimeVarying(Float32[1, 2]))) == Float32
    @test CR.param_eltype(Derived(*, 1.0f0, 2.0)) == Float64
    # The rule gate accepts IEEE arguments, and a map with float fields of
    # its own leaves the rule.
    b = Derived(*, 2.0, TimeVarying([1.0, 2.0, 3.0]))
    @test CR._gate(Recurrence(g; modifiers = (CR.Add(b),)))
    scaled(c) = x -> c * x
    closure = Derived(scaled(2.0), TimeVarying([1.0, 2.0, 3.0]))
    route(b) = CR.uses_adjoint(Recurrence(g; modifiers = (CR.Add(b),)), CR.Run())
    @test route(b)
    @test !route(closure)
    @test !route(1.0 + closure)
    @test !CR.uses_adjoint(
        Recurrence(g; modifiers = (CR.Transform(*, closure),)), CR.Run()
    )
end

@testitem "Derived: add_param! against ForwardDiff" begin
    using ComposableRecurrences
    using ForwardDiff
    CR = ComposableRecurrences
    a, z = [0.3, 0.7], [0.1, 0.2, 0.4]
    function build(θ)
        return Derived(
            (u, w, κ) -> κ * u * exp(w), PerStratum(θ[1:2]),
            TimeVarying(θ[3:5]), θ[6]
        ) / 2.0
    end
    θ = [a; z; 1.5]
    for k in 1:2, t in 1:3
        ref = ForwardDiff.gradient(θ -> CR.param(build(θ), k, t), θ)
        x = build(θ)
        mirror = (;
            f = nothing,
            args = (
                (; f = nothing, args = ((; x = zeros(2)), (; x = zeros(3)), Ref(0.0))),
                Ref(0.0),
            ),
        )
        CR.add_param!(mirror, x, 1.0, k, t)
        inner = mirror.args[1].args
        @test [inner[1].x; inner[2].x; inner[3][]] ≈ ref
        # No mirror takes nothing.
        @test CR.add_param!(nothing, x, 1.0, k, t) === nothing
    end
    # The N-argument local derivative.
    @test CR._forward_derivative((x, y, w) -> x * y + w^2, (2.0, 3.0, 1)) ==
        (3.0, 2.0, 2.0)
end
