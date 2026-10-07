# Time-varying kernels given as a vector of columns of different lengths,
# checked against hand loops and against the same columns padded with zeros
# into a dense lags × time kernel.

@testmodule RaggedChecks begin
    using ComposableRecurrences
    const CR = ComposableRecurrences

    # The columns padded with zeros to the longest, as a dense kernel.
    function pad(ks, L = maximum(length, ks))
        return [i <= length(k) ? k[i] : zero(eltype(k)) for i in 1:L, k in ks]
    end
    # Weight `i` of column `c`, zero past its end.
    at(ks, i, c) = 1 <= c <= length(ks) && i <= length(ks[c]) ? ks[c][i] : 0.0

    const T = 10
    # An empty column, columns shorter and longer than the window reaches,
    # and the longest (5) in the middle.
    const NS = [3, 0, 1, 5, 2, 4, 1, 3, 2, 6]
    const KS = [[0.3 / i + 0.01 * c for i in 1:n] for (c, n) in enumerate(NS)]
    const X = [1.0 + 0.3 * sin(k + t) for k in 1:2, t in 1:T]
    const R = [1.1 + 0.2 * cos(k * t) for k in 1:2, t in 1:T]
    const H = [1.0 2.0 1.5 0.5 0.8 1.2; 0.4 0.9 1.1 0.7 0.3 0.6]
end

@testitem "Ragged kernel: Convolution equals a hand loop and the padded kernel" setup = [Reference, RaggedChecks] begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    (; pad, at, KS, X, T) = RaggedChecks
    D = maximum(length, KS)
    h = X[:, 1:3]
    # Secondary: column `t` weights the inputs reaching output `t`.
    c = Convolution(TimeVarying(KS))
    @test c(X; history = h) ≈
        naive_convolution((t, k, d) -> at(KS, d + 1, t), X, D; hist = h)
    # Primary: column `s` spreads the input at time `s`.
    p = Convolution(TimeVarying(KS, CR.Primary()))
    @test p(X) ≈ naive_convolution((t, k, d) -> at(KS, d + 1, t - d), X, D)
    for I in (CR.Secondary(), CR.Primary()), start in (1, 4), stop in (7, T)
        hist = I isa CR.Primary ? nothing : h
        ragged = Convolution(TimeVarying(KS, I))
        dense = Convolution(TimeVarying(pad(KS), I))
        @test ragged(X; history = hist, start, stop) ≈ dense(X; history = hist, start, stop)
        @test ragged(X[1, :]; start, stop) ≈ dense(X[1, :]; start, stop)
    end
    # More columns than the call reads, and every column empty.
    @test Convolution(TimeVarying([KS; KS]))(X) ≈ Convolution(TimeVarying(pad(KS)))(X)
    @test Convolution(TimeVarying([Float64[] for _ in 1:T]))(X) == zeros(2, T)
end

@testitem "Ragged kernel: Recurrence equals a hand loop and the padded kernel" setup = [Reference, RaggedChecks] begin
    using ComposableRecurrences
    using LinearAlgebra: I, UniformScaling
    CR = ComposableRecurrences
    (; pad, at, KS, R, H, T) = RaggedChecks
    L = maximum(length, KS)
    h = H[:, 1:L]
    own(w) = (t, a, b, i) -> a == b ? w(t, i) : 0.0
    # Secondary, seeded before time 1: step `t` is absolute time `t`.
    sec = Recurrence(TimeVarying(KS))
    @test sec(R; history = h) ≈
        naive_recurrence(own((t, i) -> at(KS, i, t)), h, T; gain = (a, t) -> R[a, t])
    # Primary, seeded at times 1 to L: step `t` is absolute time `L + t`, and
    # lag `i` reads the column of the value's own time.
    prim = Recurrence(TimeVarying(KS, CR.Primary()))
    @test prim(R; history = h, start = L + 1) ≈ naive_recurrence(
        own((t, i) -> at(KS, i, L + t - i)), h, T - L; gain = (a, t) -> R[a, L + t]
    )
    for ix in (CR.Secondary(), CR.Primary()), C in ([0.9 0.1; 0.2 0.8], 0.8I)
        seed = (; history = h, start = ix isa CR.Primary ? L + 1 : 1)
        ragged = Recurrence(TimeVarying(KS, ix); coupling = C)
        dense = Recurrence(TimeVarying(pad(KS), ix); coupling = C)
        @test ragged(R; seed...) ≈ dense(R; seed...)
        C isa UniformScaling && @test ragged(R[1, :]; history = h[1, :], seed.start) ≈
            dense(R[1, :]; history = h[1, :], seed.start)
        # A resumed call carries on through the same columns.
        y1, st = CR.with_state(ragged, R; seed..., stop = 7)
        @test hcat(y1, ragged(R; state = st)) ≈ ragged(R; seed...)
    end
end

@testitem "Ragged kernel: gradients equal the padded kernel's" setup = [RaggedChecks] begin
    using ComposableRecurrences, ForwardDiff
    CR = ComposableRecurrences
    (; pad, KS, X, R, H, T) = RaggedChecks
    ns = length.(KS)
    o = cumsum([0; ns])
    cols(v) = [v[(o[c] + 1):o[c + 1]] for c in eachindex(ns)]
    v = reduce(vcat, KS)
    W = [0.5 + 0.1 * k * t for k in 1:2, t in 1:T]
    L = maximum(ns)
    for I in (CR.Secondary(), CR.Primary())
        conv(K) = sum(W .* Convolution(TimeVarying(K, I))(X))
        @test ForwardDiff.gradient(v -> conv(cols(v)), v) ≈
            ForwardDiff.gradient(v -> conv(pad(cols(v))), v)
        start = I isa CR.Primary ? L + 1 : 1
        rec(K) = sum(Recurrence(TimeVarying(K, I))(R; history = H[:, 1:L], start))
        @test ForwardDiff.gradient(v -> rec(cols(v)), v) ≈
            ForwardDiff.gradient(v -> rec(pad(cols(v))), v)
    end
end

@testitem "Ragged kernel: storage and validation" setup = [RaggedChecks] begin
    using ComposableRecurrences, ConstructionBase
    CR = ComposableRecurrences
    (; KS, X, T) = RaggedChecks
    tv = TimeVarying(KS, CR.Primary())
    @test tv isa TimeVarying{CR.Primary, <:CR._Ragged}
    @test tv.x.values == reduce(vcat, KS)
    @test tv.x.offsets == cumsum([0; length.(KS)])
    @test CR._nlags(tv) == 6
    # A rebuild from the fields keeps the indexing and the columns.
    re = ConstructionBase.constructorof(typeof(tv))(tv.x)
    @test re isa TimeVarying{CR.Primary} && re.x.offsets == tv.x.offsets
    @test ConstructionBase.constructorof(typeof(tv.x))(2 .* tv.x.values, tv.x.offsets).values ==
        2 .* tv.x.values
    # Integer and mixed columns promote.
    @test TimeVarying([[1, 2], [3]]).x.values == [1, 2, 3]
    @test eltype(TimeVarying(Vector{<:Real}[[1, 2], [0.5]]).x.values) == Float64
    @test Convolution(TimeVarying([[1, 1], [2]]))([1.0, 1.0]) ≈ [1.0, 2.0]
    @test @inferred(Convolution(TimeVarying(KS))(X)) isa Matrix{Float64}
    @test @inferred(Recurrence(TimeVarying(KS))(X; history = X[:, 1:6])) isa Matrix{Float64}

    # Offsets must rise from 0 to the number of values.
    for offsets in ([1, 3], [0, 2], [0, 3, 2, 3], Int[])
        @test_throws ArgumentError CR._Ragged([1.0, 2.0, 3.0], offsets)
    end
    @test_throws "values (3), got" CR._Ragged([1.0, 2.0, 3.0], [0, 2])
    # The columns must cover the call.
    @test_throws DimensionMismatch Convolution(TimeVarying(KS))(hcat(X, X))
    @test_throws "kernel covers 10 times" Recurrence(TimeVarying(KS))(1.0; history = [1.0], stop = 11)
    # A Primary() kernel has no column before time 1.
    @test_throws ArgumentError Convolution(tv)(X; history = X)
    @test_throws ArgumentError Recurrence(tv)(1.0; history = [1.0], stop = 3)
    # Kernel slots only, and shared by every stratum.
    @test_throws "10 kernel columns of up to 6 entries" PerStratum(TimeVarying(KS))
    @test_throws ArgumentError Pairwise(TimeVarying(KS))
    @test_throws ArgumentError CR.Add(TimeVarying(KS))
    @test_throws ArgumentError Recurrence([0.5]; coupling = TimeVarying(KS))
end
