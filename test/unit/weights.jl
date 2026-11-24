# Kernels computed from coefficients (`Derived`, `Survival`): values against
# naive loops over cohorts and lags, the operators against the dense kernel
# of the same weights, each rule's pullback against a ForwardDiff Jacobian,
# the arithmetic sugar and the construction checks.

@testmodule WeightsChecks begin
    using ComposableRecurrences
    using ComposableRecurrences: Derived
    const CR = ComposableRecurrences

    const T = 40
    const L = 6
    const h = [0.1 + 0.3 * abs(sin(t)) for t in 1:(T + L)]
    const p = [1.0, 0.9, 0.7, 0.5, 0.3, 0.1]
    const P = [p'; reverse(p)']
    const A = [2.0 + cos(t) for t in 1:T]
    const AS = [2.0 + cos(k * t) for k in 1:2, t in 1:T]
    const a0 = [-2.0 + 0.2 * i for i in 1:L]
    const γ = [0.3 * sin(t / 3) for t in 1:(T + L)]
    logistic(x) = inv(1 + exp(-x))

    # Cohort `u`'s weight on lag `d` (lag 0 first): still present with
    # probability `p[d + 1]`, and confirmed against `h` from the day after
    # entry.
    # With `o = 1`, as a recurrence reads it, entry `i` is lag `i`.
    function confirmed_loop(p, h, n, o = 0)
        K = zeros(promote_type(eltype(p), eltype(h)), length(p), n)
        for u in 1:n
            unconf = one(eltype(K))
            for i in eachindex(p)
                d = i - 1 + o
                d > 0 && (unconf *= 1 - h[u + d])
                K[i, u] = p[i] * (1 - unconf)
            end
        end
        return K
    end
    confirmed(p, h) = p * (1 - CR.Survival(TimeVarying(h); from = 1))

    # A per-stratum pmf times the survival against `κ` times an unconfirmed
    # survival, which reads the hazard of the day before each lag lands.
    function nested_loop(P, κ, h, n)
        S, D = size(P)
        G = zeros(promote_type(eltype(P), typeof(κ), eltype(h)), S, D, n)
        for u in 1:n
            surv = unconf = one(eltype(G))
            for d in 0:(D - 1)
                if d > 0
                    unconf *= 1 - h[u + d - 1]
                    surv *= 1 - κ * unconf
                end
                G[:, d + 1, u] .= P[:, d + 1] .* surv
            end
        end
        return G
    end
    function nested(P, κ, h)
        shifted = vcat(zero(eltype(h)), h)
        unconf = CR.Survival(TimeVarying(shifted); from = 1)
        return PerStratum(P) * CR.Survival(κ * unconf; from = 1)
    end

    # The probability each cohort is reported by each delay, against a
    # hazard of the delay and the calendar time, every delay acting.
    function reported_loop(a0, γ, n)
        K = zeros(promote_type(eltype(a0), eltype(γ)), length(a0), n)
        for u in 1:n
            s = one(eltype(K))
            for d in 0:(length(a0) - 1)
                s *= 1 - logistic(a0[d + 1] + γ[u + d])
                K[d + 1, u] = 1 - s
            end
        end
        return K
    end
    function reported(a0, γ)
        η = Derived((a, g) -> logistic(a + g), a0, TimeVarying(γ))
        return 1 - CR.Survival(η)
    end

    # The weights a call up to `stop` reads: cohort `u`'s lag-index `i`
    # weight, lags from `o`, lands at `u + i - 1 + o`.
    function triangle(K, o, stop)
        K = copy(K)
        L, n = size(K, ndims(K) - 1), size(K, ndims(K))
        for u in 1:n, i in 1:L
            u + i - 1 + o > stop || continue
            selectdim(selectdim(K, ndims(K), u), ndims(K) - 1, i) .= 0
        end
        return K
    end
    primary(K::AbstractMatrix) = TimeVarying(K, CR.Primary())
    primary(K::AbstractArray{<:Any, 3}) = TimeVarying(PerStratum(K), CR.Primary())
end

@testitem "Computed kernels: weights against naive loops" setup = [WeightsChecks] begin
    using ComposableRecurrences
    using ComposableRecurrences: Derived
    CR = ComposableRecurrences
    (; T, L, p, P, h, a0, γ) = WeightsChecks
    W = WeightsChecks
    n = T
    kw(x) = CR.kernel_weights(TimeVarying(x, CR.Primary()), n)
    @test kw(W.confirmed(p, h)) ≈ W.confirmed_loop(p, h, n)
    @test kw(W.nested(P, 0.4, h)) ≈ W.nested_loop(P, 0.4, h, n)
    @test kw(W.reported(a0, γ)) ≈ W.reported_loop(a0, γ, n)
    # A Survival is a Recurrence([1]) with gain 1 - η run over each cohort.
    η = [0.1 * i for i in 1:L]
    s = kw(CR.Survival(η))
    y = Recurrence([1.0])(1 .- η; history = [1.0])
    @test all(s[:, u] ≈ y for u in 1:n)
    # Lags before `from` keep survival one.
    @test all(isone, kw(CR.Survival(η; from = 3))[1:3, :])
    # Every coefficient form reads its own axis.
    v = [1.0 + 0.1 * t for t in 1:(n + L)]
    c = [2.0 + 0.1 * t for t in 1:n]
    B = [k + 0.1 * t for k in 1:2, t in 1:(n + L)]
    forms = (
        (2.5, (k, i, u) -> 2.5),
        (p, (k, i, u) -> p[i]),
        (PerStratum([3.0, 4.0]), (k, i, u) -> k + 2.0),
        (PerStratum(P), (k, i, u) -> P[k, i]),
        (TimeVarying(v), (k, i, u) -> v[u + i - 1]),
        (TimeVarying(c, CR.Primary()), (k, i, u) -> c[u]),
        (TimeVarying(PerStratum(B)), (k, i, u) -> B[k, u + i - 1]),
    )
    for (x, ref) in forms
        K = kw(Derived(*, p, x))
        if ndims(K) == 2
            @test K ≈ [p[i] * ref(1, i, u) for i in 1:L, u in 1:n]
        else
            @test K ≈ [p[i] * ref(k, i, u) for k in 1:2, i in 1:L, u in 1:n]
        end
    end
end

@testitem "Computed kernels: operators equal the dense kernel" setup = [WeightsChecks] begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    (; T, L, p, P, h, A, AS, a0, γ, triangle, primary) = WeightsChecks
    W = WeightsChecks
    for (x, K, input) in (
            (W.confirmed(p, h), W.confirmed_loop(p, h, T), A),
            (W.nested(P, 0.4, h), W.nested_loop(P, 0.4, h, T), AS),
            (W.reported(a0, γ), W.reported_loop(a0, γ, T), AS),
        )
        computed = Convolution(TimeVarying(x, CR.Primary()))
        dense = Convolution(primary(K))
        @test computed(input) ≈ dense(input)
        # A late start reads the earlier cohorts too.
        @test computed(input; start = 7) ≈ dense(input; start = 7)
        @test computed(input; stop = 20, gain = 0.5) ≈ dense(input; stop = 20, gain = 0.5)
        @test_throws "lag by lag" CR.contributions(computed, input)
        @test computed'(input) ≈ dense'(input)
    end
    # In a recurrence the kernel's lags start at 1, so entry `i` is lag `i`.
    g = 0.3 * W.confirmed(p, h)
    Kr = 0.3 .* W.confirmed_loop(p, h, T, 1)
    r(k) = vcat([1.0], Recurrence(k)(fill(1.1, T); history = [1.0], start = 2))
    @test r(TimeVarying(g, CR.Primary())) ≈ r(primary(triangle(Kr, 1, T)))
    rs(k) = Recurrence(k)(fill(1.1, 2, T); history = ones(2, 1), start = 2)
    gs = PerStratum(P[:, 1:L]) * CR.Survival(TimeVarying(h); from = 1)
    U = 1 .- W.confirmed_loop(ones(L), h, T, 1)
    Ks = [P[k, i] * U[i, u] for k in 1:2, i in 1:L, u in 1:T]
    @test rs(TimeVarying(gs, CR.Primary())) ≈ rs(primary(triangle(Ks, 1, T)))
    # A plain call equals a call that keeps no cache, with one stratum or two.
    for (k, gain, hist) in (
            (g, fill(1.1, T), [1.0]), (gs, fill(1.1, 2, T), ones(2, 1)),
        )
        rk = Recurrence(TimeVarying(k, CR.Primary()))
        args = (CR._run_args(rk, gain, hist, nothing, nothing, 2)..., nothing)
        @test CR._primal(rk, args...) == first(CR._recur(rk, args..., Val(false)))
    end
    # Under NoAdjoint the operator is differentiated by plain AD, with the
    # same values.
    c = Convolution(TimeVarying(W.confirmed(p, h), CR.Primary()))
    @test CR.NoAdjoint(c)(A) ≈ c(A)
end

@testitem "Computed kernels: several strata equal each stratum alone" setup = [WeightsChecks] begin
    using ComposableRecurrences, ForwardDiff
    CR = ComposableRecurrences
    (; T, L, h) = WeightsChecks
    W = WeightsChecks
    # Three strata read one walk per cohort, each stratum's lags from a
    # contiguous copy; one stratum adds each weight as it is walked. Both do
    # the same products and sums in the same order, so they agree exactly.
    P3 = [1.0 / (k + i) for k in 1:3, i in 1:L]
    X3 = [2.0 + cos(k * t) for k in 1:3, t in 1:T]
    conv(P, κ, h) = Convolution(TimeVarying(W.nested(P, κ, h), CR.Primary()))
    alone(P, κ, h, X) = reduce(
        vcat, [conv(P[k:k, :], κ, h)(X[k:k, :]) for k in axes(P, 1)]
    )
    for F in (Float64, Float32)
        P, X, hF, κ = F.(P3), F.(X3), F.(h), F(0.4)
        Y = conv(P, κ, hF)(X)
        @test eltype(Y) == F
        @test Y == alone(P, κ, hF, X)
        @test conv(P, κ, hF)(X; start = 7) == alone(P, κ, hF, X)[:, 7:end]
    end
    # Dual numbers in the input and the coefficients.
    D = ForwardDiff.Dual{Nothing}
    PD = [D(P3[k, i], 1.0, float(k + i)) for k in 1:3, i in 1:L]
    XD = [D(X3[k, t], 0.5, float(t)) for k in 1:3, t in 1:T]
    @test conv(PD, 0.4, h)(XD) == alone(PD, 0.4, h, XD)
    # Strata with no strata × lags matrix: a per-stratum scale.
    v = [0.5, 0.8, 1.1]
    scaled(v) = Convolution(
        TimeVarying(PerStratum(v) * W.confirmed(W.p, h), CR.Primary())
    )
    @test scaled(v)(X3) ==
        reduce(vcat, [scaled(v[k:k])(X3[k:k, :]) for k in 1:3])
    # A coefficient with no strata × lags matrix is used as it is.
    x = W.confirmed(W.p, h)
    @test CR._lags_contiguous(x) === x
    lc = ComposableRecurrences._lags_contiguous
    contiguous(f, x) = (f(x); @allocated f(x))
    @test contiguous(lc, x) == 0 skip = Base.JLOptions().code_coverage != 0
    @test CR._lags_contiguous(W.nested(P3, 0.4, h)).args[1].x == P3
    # The type test the generated check reads, called as a function.
    @test !CR._strata_lags_type(typeof(x))
    @test CR._strata_lags_type(typeof(W.nested(P3, 0.4, h)))
    @test CR._strata_lags_type(typeof(PerStratum(P3)))
    @test !CR._strata_lags_type(typeof(PerStratum(v)))
end

@testitem "Computed kernels: arithmetic lowers to Derived" setup = [WeightsChecks] begin
    using ComposableRecurrences
    using ComposableRecurrences: Derived
    CR = ComposableRecurrences
    (; p, h) = WeightsChecks
    s = CR.Survival(TimeVarying(h))
    pairs = (
        (2.0 * s, Derived(*, 2.0, s)), (s * 2.0, Derived(*, s, 2.0)),
        (1 - s, Derived(-, 1, s)), (s + p, Derived(+, s, p)),
        (p * s, Derived(*, p, s)), (s / PerStratum([1.0, 2.0]), nothing),
        (s * s, Derived(*, s, s)), (TimeVarying(h) * s, nothing),
        ((1 - s) * s, nothing),
    )
    for (sugar, explicit) in pairs
        @test sugar isa Derived
        explicit === nothing || @test typeof(sugar) == typeof(explicit)
    end
    # A power or a negation of a survival is spelled as a Derived.
    @test !hasmethod(^, Tuple{typeof(s), Int})
    @test !hasmethod(-, Tuple{typeof(s)})
    @test Derived(^, s, 2) isa Derived
    # Plain numbers and wrappers keep their own arithmetic.
    @test !hasmethod(*, Tuple{Vector{Float64}, TimeVarying{CR.Secondary, Vector{Float64}}})
end

@testitem "Computed kernels: construction and call checks" setup = [WeightsChecks] begin
    using ComposableRecurrences
    using ComposableRecurrences: Derived, Recent
    CR = ComposableRecurrences
    (; p, P, h, A, T) = WeightsChecks
    s = CR.Survival(TimeVarying(h))
    @test_throws ArgumentError Derived(*)
    # A value that is neither a coefficient nor a parameter is named
    # against both uses; a kernel refuses a parameter it cannot read.
    @test_throws "kernel coefficient" Derived(*, p, "a")
    @test_throws "kernel coefficient" Derived(*, p, TimeVarying(ones(2, 5)))
    @test_throws "computed kernel reads" CR.Survival(Recent(7))
    k7 = TimeVarying(Derived(*, [0.5, 0.5], Recent(7)), CR.Primary())
    @test_throws "computed kernel reads" Convolution(k7)
    # A coefficient with a lag axis of its own is not one a kernel reads.
    @test_throws ArgumentError Derived(*, p, TimeVarying(ones(length(p), 4), CR.Primary()))
    @test_throws ArgumentError CR.Survival(TimeVarying(h); from = -1)
    # `from` is a keyword only; a rebuild from fields keeps it and its check.
    @test_throws MethodError CR.Survival(TimeVarying(h), 1)
    s1 = CR.Survival(TimeVarying(h); from = 1)
    @test s1.from == 1
    @test CR.ConstructionBase.constructorof(typeof(s1))(s1.hazard, s1.from).from == 1
    s2 = CR.ConstructionBase.setproperties(s1; from = 2)
    @test s2.from == 2 && s2.hazard === s1.hazard
    @test_throws ArgumentError CR.ConstructionBase.setproperties(s1; from = -1)
    @test_throws ArgumentError CR.Survival(ones(2, 2))
    # A computed kernel is indexed by cohort.
    @test_throws ArgumentError Convolution(TimeVarying(p * s))
    # Its lags come from an argument with a lag axis, all of one length.
    @test_throws ArgumentError Convolution(TimeVarying(s, CR.Primary()))
    @test_throws DimensionMismatch Convolution(TimeVarying(p * (s * ones(3)), CR.Primary()))
    @test_throws DimensionMismatch Derived(*, PerStratum(P), PerStratum(ones(3)))
    # The strata of the kernel and the input agree.
    k = TimeVarying(PerStratum(P) * s, CR.Primary())
    @test_throws DimensionMismatch Convolution(k)(ones(3, T))
    # A time-varying coefficient covers the times the call reads.
    short = TimeVarying(p * CR.Survival(TimeVarying(h[1:10])), CR.Primary())
    @test_throws DimensionMismatch Convolution(short)(A)
    @test_throws DimensionMismatch CR.kernel_weights(short, 10)
    @test size(CR.kernel_weights(short, 5)) == (length(p), 5)
    # A Primary() kernel takes no history.
    c = Convolution(TimeVarying(p * s, CR.Primary()))
    @test_throws ArgumentError c(A; history = [1.0])
    # A computed kernel is not a modifier parameter.
    @test_throws ArgumentError CR.Transform(+, p * s)
    # A map that holds floats is named as the reason for plain AD.
    scaled = let c = 2.0
        x -> c * x
    end
    empty!(CR._PLAIN_NOTED)
    @test_logs (:info, r"the kernel has a Derived map that holds floats") Recurrence(
        TimeVarying(Derived(scaled, p), CR.Primary())
    )
    @test_logs Recurrence(TimeVarying(Derived(exp, p), CR.Primary()))
end

# Each rule's pullback against the Jacobian of the plain call. The float
# leaves (arrays and scalars) of an operator and its arguments are found in
# field order; the reference rebuilds the call with dual leaves, and the
# rule's mirrors are built and read back in the same order.
@testmodule PullbackChecks begin
    using ComposableRecurrences, ConstructionBase
    const CR = ComposableRecurrences

    _leaf(x) = x isa Float64 || x isa AbstractArray{Float64}
    function _rebuildable(x)
        x isa Union{Number, AbstractArray, Function, Symbol, Nothing} && return false
        return x isa Tuple || fieldcount(typeof(x)) > 0
    end

    leaves(x) = _leaf(x) ? Any[x] : _rebuildable(x) ? _leaves_of(x) : Any[]
    _leaves_of(x::Tuple) = reduce(vcat, map(leaves, x); init = Any[])
    _leaves_of(x) = reduce(vcat, map(leaves, ConstructionBase.getfields(x)); init = Any[])
    flat(x) = reduce(vcat, map(l -> l isa Number ? [l] : vec(l), leaves(x)); init = Float64[])

    # `x` with its float leaves taken in order from `θ`.
    rebuild(x, θ) = first(_rebuild(x, θ, 0))
    function _rebuild(x, θ, i)
        x isa Float64 && return θ[i + 1], i + 1
        x isa AbstractArray{Float64} && return reshape(θ[(i + 1):(i + length(x))], size(x)), i + length(x)
        _rebuildable(x) || return x, i
        vals = Any[]
        for f in (x isa Tuple ? x : ConstructionBase.getfields(x))
            v, i = _rebuild(f, θ, i)
            push!(vals, v)
        end
        x isa Tuple && return Tuple(vals), i
        return ConstructionBase.constructorof(typeof(x))(vals...), i
    end

    # Zero mirrors, and their values in leaf order.
    mirror(x) = x isa Float64 ? Ref(0.0) : x isa AbstractArray{Float64} ? zero(x) :
        _rebuildable(x) ? _mirror_of(x) : nothing
    _mirror_of(x::Tuple) = map(mirror, x)
    function _mirror_of(x)
        names = fieldnames(typeof(x))
        return NamedTuple{names}(map(n -> mirror(getfield(x, n)), names))
    end
    values_of(m::Base.RefValue) = [m[]]
    values_of(m::AbstractArray) = vec(m)
    values_of(::Nothing) = Float64[]
    values_of(m::Union{Tuple, NamedTuple}) = reduce(vcat, map(values_of, values(m)); init = Float64[])

    # The rule's vector-Jacobian product for the output cotangent `ȳ`, and
    # the reference from the Jacobian of the plain call.
    function rule_vjp(op, args, ȳ)
        y, cache = CR._run_forward(op, args...)
        m = mirror(op)
        ms = map(mirror, args)
        CR.pullback!((; piece = m, y = ȳ, args = ms), op, CR.Run(), cache)
        return vcat(values_of(m), values_of(ms))
    end
    function reference_vjp(jacobian, op, args, ȳ)
        θ = vcat(flat(op), flat(args))
        n = length(flat(op))
        f(θ) = vec(CR._primal(rebuild(op, θ[1:n]), rebuild(args, θ[(n + 1):end])...))
        return jacobian(f, θ)' * vec(ȳ)
    end
end

@testitem "Computed kernels: a dual walk allocates nothing per cohort" setup = [WeightsChecks] begin
    using ComposableRecurrences, ForwardDiff
    CR = ComposableRecurrences
    W = WeightsChecks
    # Over several strata under dual numbers, the call's allocations do not
    # grow with the number of cohorts.
    D = ForwardDiff.Dual{Nothing}
    function allocs(n)
        h = [D(0.1 + 0.3 * abs(sin(t)), 1.0, float(t)) for t in 1:(n + W.L)]
        X = [D(2.0 + cos(k * t), 0.5, 0.0) for k in 1:2, t in 1:n]
        c = Convolution(
            TimeVarying(W.nested(W.P, D(0.4, 0.0, 1.0), h), CR.Primary())
        )
        c(X)
        return @allocations c(X)
    end
    coverage = Base.JLOptions().code_coverage != 0
    @test allocs(4 * W.T) - allocs(2 * W.T) <= 2 skip = coverage
end

@testitem "Computed kernels: a survival scratch's row is fixed by the hazard's type" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    S, L, T = 3, 4, 6
    plain = [0.1, 0.2, 0.3, 0.4]
    hazards = (
        plain, PerStratum(rand(S, L)), TimeVarying(rand(T)),
        TimeVarying(PerStratum(rand(S, T))), CR.Derived(exp, plain),
        CR.Derived(*, 0.5, PerStratum(rand(S, L))),
        CR.Derived(+, CR.Derived(exp, plain), TimeVarying(PerStratum(rand(S, T)))),
    )
    for h in (hazards..., CR.Survival(plain), CR.Survival(PerStratum(rand(S, L))))
        # The type's answer agrees with the strata count the values give.
        @test CR._stratified_type(typeof(h)) == (CR._coef_strata(h) > 0)
        @test CR._stratified(h) === CR._stratified_type(typeof(h))
    end
    for h in hazards
        sc = @inferred CR._scratch(CR.Survival(h), Float64, L)
        @test sc isa CR._SurvivalScratch{CR._stratified_type(typeof(h))}
    end
end

@testitem "Computed kernels: each rule's pullback against a Jacobian" tags = [:threads] setup = [WeightsChecks, PullbackChecks, ReferenceAD] begin
    using ComposableRecurrences
    using ComposableRecurrences: Derived
    CR = ComposableRecurrences
    (; p, P, h, a0, γ) = WeightsChecks
    (; rule_vjp, reference_vjp) = PullbackChecks
    W = WeightsChecks
    # Small inputs: five lags, eight times.
    T, L = 8, 5
    q, hs, Ps = p[1:L], h[1:(T + L)], P[:, 1:L]
    computed(x) = TimeVarying(x, CR.Primary())
    x, xs = [1.0 + 0.1 * t for t in 1:T], [1.0 + 0.1 * k * t for k in 1:2, t in 1:T]
    check(op, args, ȳ) = @test rule_vjp(op, args, ȳ) ≈ reference_vjp(ReferenceAD.jacobian, op, args, ȳ)
    conv(k) = Convolution(computed(k))
    # Convolution, shared and per-stratum kernels, a late start and a gain.
    check(conv(W.confirmed(q, hs)), (x, true, nothing, nothing, 1, T), sin.(1:T))
    check(conv(W.confirmed(q, hs)), (x, 0.7, nothing, nothing, 3, T), sin.(1:(T - 2)))
    # The closed-form partials of the other arithmetic.
    mixed = (q + -W.confirmed(q, hs)) / 2.0
    check(conv(mixed), (x, true, nothing, nothing, 1, T), sin.(1:T))
    check(conv(W.nested(Ps, 0.4, hs)), (xs, true, nothing, nothing, 1, T), sin.(xs))
    # Per-stratum coefficients, one value per stratum and one per stratum
    # and calendar time.
    B = [1.0 + 0.05 * k * t for k in 1:2, t in 1:(T + L)]
    args = (xs, true, nothing, nothing, 1, T)
    check(conv(PerStratum([0.5, 0.8]) * W.confirmed(q, hs)), args, sin.(xs))
    check(conv(Derived(*, q, TimeVarying(PerStratum(B)))), args, sin.(xs))
    # A survival against a per-stratum hazard carries a cotangent per
    # stratum, alone and inside another survival with a later start.
    η = Derived(*, 0.1, TimeVarying(PerStratum(B)))
    check(conv(q * CR.Survival(η; from = 1)), args, sin.(xs))
    outer = CR.Survival(0.4 * CR.Survival(η; from = 1); from = 2)
    check(conv(PerStratum(Ps) * outer), args, sin.(xs))
    # The same with a late start, and a survival from lag 2.
    late = (xs, true, nothing, nothing, 3, T)
    check(conv(q * CR.Survival(η; from = 1)), late, sin.(xs[:, 3:end]))
    check(conv(PerStratum(Ps) * outer), late, sin.(xs[:, 3:end]))
    from2 = conv(q * CR.Survival(TimeVarying(hs); from = 2))
    check(from2, (x, true, nothing, nothing, 1, T), sin.(1:T))
    # A constant kernel: the input's cotangent alone, as with the kernel's.
    cs = conv(q * CR.Survival(η; from = 1))
    ys, cache = CR._run_forward(cs, args...)
    ms = map(PullbackChecks.mirror, args)
    CR.pullback!((; piece = nothing, y = sin.(xs), args = ms), cs, CR.Run(), cache)
    full = rule_vjp(cs, args, sin.(xs))
    @test PullbackChecks.values_of(ms) ≈ full[(end - length(xs) + 1):end]
    # Another executor takes the dense kernel of the same weights.
    threaded = CR.Threaded(; min_work = 0, ntasks = 2)
    Base.ScopedValues.with(CR.EXECUTOR => threaded) do
        c = conv(W.nested(Ps, 0.4, hs))
        @test c(xs) ≈ Base.ScopedValues.with(() -> c(xs), CR.EXECUTOR => CR.Serial())
        check(c, (xs, true, nothing, nothing, 1, T), sin.(xs))
        # A per-stratum survival from a late start, against the serial walk.
        cη = conv(q * CR.Survival(η; from = 1))
        serial(f) = Base.ScopedValues.with(f, CR.EXECUTOR => CR.Serial())
        @test cη(xs; start = 3) ≈ serial(() -> cη(xs; start = 3))
    end
    # The transpose runs the computed kernel's reverse body as its forward
    # pass, so its own pullback is checked too.
    tr(k) = CR._TransposedConvolution(conv(k))
    check(tr(W.confirmed(q, hs)), (x, nothing, 1, T), sin.(1:T))
    check(tr(W.confirmed(q, hs)), (x, nothing, 3, T - 2), sin.(1:(T - 4)))
    check(tr(W.confirmed(q, hs)), (x[1:(T - 2)], x[1:2], 1, T - 2), sin.(1:(T - 2)))
    check(tr(W.nested(Ps, 0.4, hs)), (xs, nothing, 1, T), sin.(xs))
    # The weights as an array, with a map the rule differentiates locally.
    kw = CR._KernelWeights(computed(W.reported(a0[1:L], γ[1:(T + L)])))
    check(kw, (T,), reshape(sin.(1:(L * T)), L, T))
    # The same with strata, each walking its own survival.
    ηs = Derived(b -> 0.2 / (1 + b), TimeVarying(PerStratum(B)))
    kws = CR._KernelWeights(computed(PerStratum(Ps) * CR.Survival(ηs)))
    check(kws, (T,), reshape(sin.(1:(2 * L * T)), 2, L, T))
    # One cohort: the kept walk of each stratum's group is read back.
    check(kws, (1,), reshape(sin.(1:(2 * L)), 2, L, 1))
    # A recurrence with a computed kernel.
    r = Recurrence(computed(0.3 * W.confirmed(q, hs)))
    check(r, (fill(1.1, T), nothing, [1.0], nothing, 2, T), sin.(1:(T - 1)))
end

@testitem "Computed kernels: increments and weights over their total" tags = [:threads] setup = [WeightsChecks, PullbackChecks, ReferenceAD] begin
    using ComposableRecurrences, JLArrays
    using ComposableRecurrences: Derived
    CR = ComposableRecurrences
    (; p, P, h, A, AS, primary) = WeightsChecks
    (; rule_vjp, reference_vjp) = PullbackChecks
    W = WeightsChecks
    computed(x) = TimeVarying(x, CR.Primary())
    # Naive maps of each cohort's column of a weights array.
    increments(K) = cat(selectdim(K, ndims(K) - 1, 1:1), diff(K; dims = ndims(K) - 1); dims = ndims(K) - 1)
    normalised(K) = K ./ sum(K; dims = ndims(K) - 1)
    n = 30
    kw(x, m = n) = CR.kernel_weights(computed(x), m)
    cdf = 1 - CR.Survival(Derived(*, 0.5 * p, TimeVarying(h)))
    stratified = PerStratum(P) * CR.Survival(TimeVarying(h); from = 1)
    for x in (cdf, W.confirmed(p, h), stratified)
        K = kw(x)
        @test kw(CR.Increments(x)) ≈ increments(K)
        @test kw(CR.Normalised(x)) ≈ normalised(K)
        @test kw(CR.Normalised(CR.Increments(x))) ≈ normalised(increments(K))
        @test kw(CR.Increments(CR.Normalised(x))) ≈ increments(normalised(K))
    end
    # A total of zero keeps zero weights.
    @test iszero(kw(CR.Normalised(Derived(*, 0.0, p))))
    # Arithmetic lowers to Derived, and the maps show as their formula.
    pmf = CR.Normalised(CR.Increments(cdf))
    @test 2.0 * pmf isa Derived && pmf * CR.Survival(p) isa Derived
    @test CR.Survival(p) - CR.Increments(cdf) isa Derived
    @test kw(2.0 * pmf) ≈ 2 .* kw(pmf)
    @test startswith(CR._formula(pmf), "Normalised(Increments(1 - Survival(")
    @test_throws "lag map takes a computed kernel" CR.Increments(p)
    # The operators against the dense kernel of the same weights, with the
    # input held at its last value past its end in the transpose.
    for (x, input) in ((pmf, A), (CR.Normalised(CR.Increments(stratified)), AS))
        computed_conv = Convolution(computed(x))
        dense = Convolution(primary(kw(x, size(input, ndims(input)))))
        @test computed_conv(input) ≈ dense(input)
        @test computed_conv(input; start = 7) ≈ dense(input; start = 7)
        tail = collect(selectdim(input, ndims(input), fill(lastindex(input, ndims(input)), 5)))
        @test computed_conv'(input; tail) ≈ dense'(input; tail)
        @test computed_conv'(input; stop = 20) ≈ dense'(input; stop = 20)
    end
    # Each rule's pullback against a Jacobian, on small inputs.
    T, L = 8, 5
    q, hs, Ps = p[1:L], h[1:(T + L + 1)], P[:, 1:L]
    x, xs = [1.0 + 0.1 * t for t in 1:T], [1.0 + 0.1 * k * t for k in 1:2, t in 1:T]
    check(op, args, ȳ) = @test rule_vjp(op, args, ȳ) ≈ reference_vjp(ReferenceAD.jacobian, op, args, ȳ)
    conv(k) = Convolution(computed(k))
    tr(k) = CR._TransposedConvolution(conv(k))
    small = CR.Normalised(CR.Increments(1 - CR.Survival(Derived(*, 0.5 * q, TimeVarying(hs)))))
    perstratum = CR.Normalised(CR.Increments(PerStratum(Ps) * CR.Survival(TimeVarying(hs); from = 1)))
    inc = CR.Increments(q * CR.Survival(TimeVarying(hs); from = 1))
    for k in (small, inc)
        check(conv(k), (x, true, nothing, nothing, 1, T), sin.(1:T))
        check(conv(k), (x, 0.7, nothing, nothing, 3, T), sin.(1:(T - 2)))
        check(tr(k), (x, nothing, 1, T), sin.(1:T))
        check(tr(k), (x, fill(x[end], L - 1), 1, T), sin.(1:T))
        check(CR._KernelWeights(computed(k)), (T,), reshape(sin.(1:(L * T)), L, T))
    end
    # With a tail the transpose reads past its last output, but not a
    # cohort's coefficient there: one covering the outputs alone serves.
    cohort = CR.Normalised(CR.Increments(1 - CR.Survival(Derived(*, 0.5 * q, TimeVarying(fill(0.4, T), CR.Primary())))))
    check(tr(cohort), (x, fill(x[end], L - 1), 1, T), sin.(1:T))
    dense = Convolution(primary(CR.kernel_weights(computed(cohort), T)))
    @test conv(cohort)'(x; tail = fill(x[end], L - 1)) ≈ dense'(x; tail = fill(x[end], L - 1))
    args = (xs, true, nothing, nothing, 1, T)
    check(conv(perstratum), args, sin.(xs))
    check(tr(perstratum), (xs, nothing, 1, T), sin.(xs))
    # Another executor fills the dense kernel in blocks, forward, transposed
    # and in reverse.
    dsmall = Convolution(primary(CR.kernel_weights(computed(small), T)))
    held = fill(x[end], L - 1)
    threaded = CR.Threaded(; min_work = 0, ntasks = 2)
    Base.ScopedValues.with(CR.EXECUTOR => threaded) do
        @test conv(small)(x) ≈ dsmall(x)
        @test conv(small)'(x; tail = held) ≈ dsmall'(x; tail = held)
        check(conv(small), (x, true, nothing, nothing, 1, T), sin.(1:T))
        check(tr(small), (x, held, 1, T), sin.(1:T))
        check(conv(perstratum), args, sin.(xs))
    end
    # At a total of zero the floor has no slope.
    check(conv(CR.Normalised(Derived(*, 0.0, q))), (x, true, nothing, nothing, 1, T), sin.(1:T))
    # A total reads every lag of each cohort: a hazard read at the time a
    # weight lands needs the times up to `T + L - 1` in a convolution and
    # `T + L` in a recurrence.
    landed(h) = CR.Normalised(1 - CR.Survival(Derived(*, 0.5 * q, TimeVarying(h))))
    @test length(conv(landed(hs[1:(T + L - 1)]))(x)) == T
    @test_throws DimensionMismatch conv(landed(hs[1:(T + L - 2)]))(x)
    rec(h) = Recurrence(computed(0.3 * landed(h)))(fill(1.1, T); history = [1.0], start = 2)
    @test length(rec(hs[1:(T + L)])) == T - 1
    @test_throws DimensionMismatch rec(hs[1:(T + L - 1)])
    # A lag map fills on the host only.
    device = computed(CR.Increments(Derived(*, JLArray(q), 2.0)))
    @test_throws "fills on the host" CR.kernel_weights(device, T)
    # A recurrence with a lag-mapped kernel, its lags from 1.
    r = Recurrence(computed(0.3 * small))
    check(r, (fill(1.1, T), nothing, [1.0], nothing, 2, T), sin.(1:(T - 1)))
end

@testitem "Computed kernels: lag maps over a kernel's weights" tags = [:threads] setup = [WeightsChecks, PullbackChecks, ReferenceAD] begin
    using ComposableRecurrences
    using ComposableRecurrences: Derived
    CR = ComposableRecurrences
    (; p, P, h, A, AS, primary) = WeightsChecks
    (; rule_vjp, reference_vjp) = PullbackChecks
    computed(x) = TimeVarying(x, CR.Primary())
    kw(x, m) = CR.kernel_weights(computed(x), m)
    # The maps over a kernel's weights equal the maps over the kernel that
    # computed them, alone, nested and with strata.
    n = 30
    cdf = 1 - CR.Survival(Derived(*, 0.5 * p, TimeVarying(h)))
    stratified = PerStratum(P) * CR.Survival(TimeVarying(h); from = 1)
    for x in (cdf, stratified)
        K = computed(kw(x, n))
        for map in (CR.Increments, CR.Normalised, x -> CR.Normalised(CR.Increments(x)))
            @test kw(map(K), n) ≈ kw(map(x), n)
        end
    end
    # The operators against the dense kernel of the same weights, the
    # transpose with its input held at its last value past its end.
    for (x, input) in ((cdf, A), (stratified, AS))
        m = size(input, ndims(input))
        pmf = CR.Normalised(CR.Increments(computed(kw(x, m))))
        conv, dense = Convolution(computed(pmf)), Convolution(primary(kw(pmf, m)))
        @test conv(input) ≈ dense(input)
        tail = collect(selectdim(input, ndims(input), fill(m, 5)))
        @test conv'(input; tail) ≈ dense'(input; tail)
        @test conv'(input; stop = 20) ≈ dense'(input; stop = 20)
    end
    # Each rule's pullback against a Jacobian, the weights' cotangent
    # included, on small inputs.
    T, L = 8, 5
    q, hs, Ps = p[1:L], h[1:(T + L + 1)], P[:, 1:L]
    K = computed(kw(1 - CR.Survival(Derived(*, 0.5 * q, TimeVarying(hs))), T))
    KS = computed(kw(PerStratum(Ps) * CR.Survival(TimeVarying(hs); from = 1), T))
    x, xs = [1.0 + 0.1 * t for t in 1:T], [1.0 + 0.1 * k * t for k in 1:2, t in 1:T]
    check(op, args, ȳ) = @test rule_vjp(op, args, ȳ) ≈ reference_vjp(ReferenceAD.jacobian, op, args, ȳ)
    conv(k) = Convolution(computed(k))
    tr(k) = CR._TransposedConvolution(conv(k))
    held = fill(x[end], L - 1)
    for k in (CR.Normalised(CR.Increments(K)), CR.Increments(K))
        check(conv(k), (x, true, nothing, nothing, 1, T), sin.(1:T))
        check(tr(k), (x, nothing, 1, T), sin.(1:T))
        check(tr(k), (x, held, 1, T), sin.(1:T))
        check(CR._KernelWeights(computed(k)), (T,), reshape(sin.(1:(L * T)), L, T))
    end
    pmfs = CR.Normalised(CR.Increments(KS))
    check(conv(pmfs), (xs, true, nothing, nothing, 1, T), sin.(xs))
    check(tr(pmfs), (xs, nothing, 1, T), sin.(xs))
    # Another executor fills the dense kernel in blocks.
    threaded = CR.Threaded(; min_work = 0, ntasks = 2)
    Base.ScopedValues.with(CR.EXECUTOR => threaded) do
        check(tr(CR.Normalised(CR.Increments(K))), (x, held, 1, T), sin.(1:T))
        check(conv(pmfs), (xs, true, nothing, nothing, 1, T), sin.(xs))
    end
    # A recurrence with a lag-mapped table, its lags from 1.
    r = Recurrence(computed(0.3 * CR.Normalised(K)))
    check(r, (fill(1.1, T), nothing, [1.0], nothing, 2, T), sin.(1:(T - 1)))
    # The weights cover the cohorts the call reads; a series over time is
    # not a kernel's weights.
    @test_throws DimensionMismatch conv(CR.Normalised(computed(kw(cdf, T - 1))))(x)
    @test_throws "or a kernel's weights" CR.Increments(computed(hs))
    @test startswith(CR._formula(CR.Normalised(CR.Increments(K))), "Normalised(Increments(")
end

@testitem "Computed kernels: a transposed call with a tail reads only what its outputs need" setup = [WeightsChecks, PullbackChecks, ReferenceAD] begin
    using ComposableRecurrences
    using ComposableRecurrences: Derived
    CR = ComposableRecurrences
    (; primary) = WeightsChecks
    (; rule_vjp, reference_vjp) = PullbackChecks
    T, L = 8, 4
    x = [1.0 + 0.1 * t for t in 1:T]
    tail = fill(x[end], L - 1)
    base = [0.5, 0.6, 0.7, 0.8]
    computed(w) = TimeVarying(w, CR.Primary())
    # The transpose reads the series and tail past its last output, but a
    # coefficient per cohort covering the outputs alone serves.
    cohort = 1 - CR.Survival(Derived(*, base, TimeVarying(fill(0.3, T), CR.Primary())))
    dense = Convolution(primary(CR.kernel_weights(computed(cohort), T)))
    @test Convolution(computed(cohort))'(x; tail) ≈ dense'(x; tail)
    tr = CR._TransposedConvolution(Convolution(computed(cohort)))
    args = (x, tail, 1, T)
    @test rule_vjp(tr, args, sin.(1:T)) ≈ reference_vjp(ReferenceAD.jacobian, tr, args, sin.(1:T))
    # A hazard read at the time a weight lands covers the times the outputs
    # read, up to `T + L - 1`.
    h = [0.1 + 0.02 * t for t in 1:(T + L - 1)]
    landed(h) = base * CR.Survival(TimeVarying(h); from = 1)
    dense = Convolution(primary(CR.kernel_weights(computed(landed(h)), T)))
    @test Convolution(computed(landed(h)))'(x; tail) ≈ dense'(x; tail)
    @test_throws DimensionMismatch Convolution(computed(landed(h[1:T])))'(x; tail)
end
