# Kernels computed from coefficients (`Weights`, `Survival`): values against
# naive loops over cohorts and lags, the operators against the dense kernel
# of the same weights, gradients against ForwardDiff of the naive loops, the
# arithmetic sugar and the construction checks.

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
        η = CR.Weights((a, g) -> logistic(a + g), a0, TimeVarying(γ))
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
        K = kw(CR.Weights(*, p, x))
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

@testitem "Computed kernels: gradients against the naive loops" setup = [WeightsChecks] begin
    using ComposableRecurrences, ForwardDiff
    CR = ComposableRecurrences
    (; T, L, p, P, h, A, AS, a0, γ, primary) = WeightsChecks
    W = WeightsChecks
    w = [cos(t) for t in 1:T]
    ws = [sin(k + t) for k in 1:2, t in 1:T]
    # ForwardDiff through the computed kernel against ForwardDiff through
    # the dense kernel of the naive loop.
    f1(θ) = sum(w .* Convolution(TimeVarying(W.confirmed(θ[1:L], θ[(L + 1):end]), CR.Primary()))(A))
    g1(θ) = sum(w .* Convolution(primary(W.confirmed_loop(θ[1:L], θ[(L + 1):end], T)))(A))
    θ1 = vcat(p, h)
    @test ForwardDiff.gradient(f1, θ1) ≈ ForwardDiff.gradient(g1, θ1)
    f2(θ) = sum(ws .* Convolution(TimeVarying(W.nested(P, θ[1], θ[2:end]), CR.Primary()))(AS))
    g2(θ) = sum(ws .* Convolution(primary(W.nested_loop(P, θ[1], θ[2:end], T)))(AS))
    θ2 = vcat(0.4, h)
    @test ForwardDiff.gradient(f2, θ2) ≈ ForwardDiff.gradient(g2, θ2)
    k(θ) = CR.kernel_weights(TimeVarying(W.reported(θ[1:L], θ[(L + 1):end]), CR.Primary()), T)
    f3(θ) = sum(sin.(1:(L * T)) .* vec(k(θ)))
    g3(θ) = sum(sin.(1:(L * T)) .* vec(W.reported_loop(θ[1:L], θ[(L + 1):end], T)))
    θ3 = vcat(a0, γ)
    @test ForwardDiff.gradient(f3, θ3) ≈ ForwardDiff.gradient(g3, θ3)
end

@testitem "Computed kernels: arithmetic lowers to Weights" setup = [WeightsChecks] begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    (; p, h) = WeightsChecks
    s = CR.Survival(TimeVarying(h))
    pairs = (
        (2.0 * s, CR.Weights(*, 2.0, s)), (s * 2.0, CR.Weights(*, s, 2.0)),
        (1 - s, CR.Weights(-, 1, s)), (s + p, CR.Weights(+, s, p)),
        (p * s, CR.Weights(*, p, s)), (s / PerStratum([1.0, 2.0]), nothing),
        (s^2, CR.Weights(^, s, 2)), (-s, CR.Weights(-, s)),
        (s * s, CR.Weights(*, s, s)), (TimeVarying(h) * s, nothing),
        ((1 - s) * s, nothing),
    )
    for (sugar, explicit) in pairs
        @test sugar isa CR.Weights
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
    @test_throws ArgumentError CR.Weights(*)
    @test_throws ArgumentError CR.Weights(*, p, "a")
    @test_throws ArgumentError CR.Survival(TimeVarying(h); from = -1)
    @test_throws ArgumentError CR.Survival(ones(2, 2))
    # A computed kernel is indexed by cohort.
    @test_throws ArgumentError Convolution(TimeVarying(p * s))
    # Its lags come from an argument with a lag axis, all of one length.
    @test_throws ArgumentError Convolution(TimeVarying(s, CR.Primary()))
    @test_throws DimensionMismatch Convolution(TimeVarying(p * (s * ones(3)), CR.Primary()))
    @test_throws DimensionMismatch CR.Weights(*, PerStratum(P), PerStratum(ones(3)))
    # The strata of the kernel and the input agree.
    k = TimeVarying(PerStratum(P) * s, CR.Primary())
    @test_throws DimensionMismatch Convolution(k)(ones(3, T))
    # A time-varying coefficient covers the times the call reads.
    short = TimeVarying(p * CR.Survival(TimeVarying(h[1:10])), CR.Primary())
    @test_throws DimensionMismatch Convolution(short)(A)
    @test_throws DimensionMismatch CR.kernel_weights(short, 10)
    @test size(CR.kernel_weights(short, 5)) == (length(p), 5)
    # A Primary() kernel takes no history.
    @test_throws ArgumentError Convolution(TimeVarying(p * s, CR.Primary()))(A; history = [1.0])
    # A computed kernel is not a modifier parameter.
    @test_throws ArgumentError CR.Add(p * s)
end
