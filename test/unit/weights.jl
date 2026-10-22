# Kernels computed from coefficients (`Derived`, `Survival`): values against
# naive loops over cohorts and lags, the operators against the dense kernel
# of the same weights, each rule's pullback against a ForwardDiff Jacobian,
# the arithmetic sugar and the construction checks.

@testmodule WeightsChecks begin
    using ComposableRecurrences
    const CR = ComposableRecurrences

    const T = 30
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
    M = [0.1 * i + 0.01 * t for i in 1:L, t in 1:n]
    B = [k + 0.1 * t for k in 1:2, t in 1:(n + L)]
    G = [k + 0.1 * i + 0.01 * t for k in 1:2, i in 1:L, t in 1:n]
    forms = (
        (2.5, (k, i, u) -> 2.5),
        (p, (k, i, u) -> p[i]),
        (PerStratum([3.0, 4.0]), (k, i, u) -> k + 2.0),
        (PerStratum(P), (k, i, u) -> P[k, i]),
        (TimeVarying(v), (k, i, u) -> v[u + i - 1]),
        (TimeVarying(c, CR.Primary()), (k, i, u) -> c[u]),
        (TimeVarying(M, CR.Primary()), (k, i, u) -> M[i, u]),
        (TimeVarying(PerStratum(B)), (k, i, u) -> B[k, u + i - 1]),
        (TimeVarying(PerStratum(G), CR.Primary()), (k, i, u) -> G[k, i, u]),
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
        @test CR.contributions(computed, input) ≈ CR.contributions(dense, input)
    end
    # In a recurrence the kernel's lags start at 1, so entry `i` is lag `i`.
    g = 0.3 * W.confirmed(p, h)
    Kr = 0.3 .* W.confirmed_loop(p, h, T, 1)
    r(k) = Recurrence(k)(fill(1.1, T); history = [1.0], start = 2, prepend = true)
    @test r(TimeVarying(g, CR.Primary())) ≈ r(primary(triangle(Kr, 1, T)))
    rs(k) = Recurrence(k)(fill(1.1, 2, T); history = ones(2, 1), start = 2)
    gs = PerStratum(P[:, 1:L]) * CR.Survival(TimeVarying(h); from = 1)
    U = 1 .- W.confirmed_loop(ones(L), h, T, 1)
    Ks = [P[k, i] * U[i, u] for k in 1:2, i in 1:L, u in 1:T]
    @test rs(TimeVarying(gs, CR.Primary())) ≈ rs(primary(triangle(Ks, 1, T)))
    # Under NoAdjoint the operator is differentiated by plain AD, with the
    # same values.
    c = Convolution(TimeVarying(W.confirmed(p, h), CR.Primary()))
    @test CR.NoAdjoint(c)(A) ≈ c(A)
end

@testitem "Computed kernels: arithmetic lowers to Derived" setup = [WeightsChecks] begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    (; p, h) = WeightsChecks
    s = CR.Survival(TimeVarying(h))
    pairs = (
        (2.0 * s, Derived(*, 2.0, s)), (s * 2.0, Derived(*, s, 2.0)),
        (1 - s, Derived(-, 1, s)), (s + p, Derived(+, s, p)),
        (p * s, Derived(*, p, s)), (s / PerStratum([1.0, 2.0]), nothing),
        (s^2, Derived(^, s, 2)), (-s, Derived(-, s)),
        (s * s, Derived(*, s, s)), (TimeVarying(h) * s, nothing),
        ((1 - s) * s, nothing),
    )
    for (sugar, explicit) in pairs
        @test sugar isa Derived
        explicit === nothing || @test typeof(sugar) == typeof(explicit)
    end
    # Plain numbers and wrappers keep their own arithmetic.
    @test !hasmethod(*, Tuple{Vector{Float64}, TimeVarying{CR.Secondary, Vector{Float64}}})
end

@testitem "Computed kernels: construction and call checks" setup = [WeightsChecks] begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    (; p, P, h, A, T) = WeightsChecks
    s = CR.Survival(TimeVarying(h))
    @test_throws ArgumentError Derived(*)
    @test_throws ArgumentError Derived(*, p, "a")
    @test_throws ArgumentError CR.Survival(TimeVarying(h); from = -1)
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
    @test_throws ArgumentError CR.Add(p * s)
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

@testitem "Computed kernels: each rule's pullback against a Jacobian" setup = [WeightsChecks, PullbackChecks, ReferenceAD] begin
    using ComposableRecurrences
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
    check(conv(W.nested(Ps, 0.4, hs)), (xs, true, nothing, nothing, 1, T), sin.(xs))
    # The terms of a convolution.
    terms = CR._Contributions(conv(W.confirmed(q, hs)))
    check(terms, (x, true, nothing, 1, T), reshape(sin.(1:(L * T)), L, T))
    # The weights as an array, with a map the rule differentiates locally.
    kw = CR._KernelWeights(computed(W.reported(a0[1:L], γ[1:(T + L)])))
    check(kw, (T,), reshape(sin.(1:(L * T)), L, T))
    # A recurrence with a computed kernel.
    r = Recurrence(computed(0.3 * W.confirmed(q, hs)))
    check(r, (fill(1.1, T), nothing, [1.0], nothing, 2, T), sin.(1:(T - 1)))
end
