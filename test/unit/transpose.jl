# The transpose of a convolution: a sum that reads the series forward,
# checked against the transpose of the convolution's dense matrix, its
# pullback against ForwardDiff, and two forward sums against hand loops.

@testsnippet TransposeCases begin
    using ComposableRecurrences: ComposableRecurrences as CR
    using Random

    # The kernels to transpose for `S` strata over `n` times, each with the
    # kernel that convolves inputs at times up to `N`: a `Primary()` kernel
    # spreads nothing from the inputs after its last column.
    function transpose_cases(rng, S, L, n, N)
        P = CR.Primary()
        g, Gs = rand(rng, L), rand(rng, S, L)
        K, KN = rand(rng, L, n), rand(rng, L, N)
        G3 = rand(rng, S, L, n)
        cols = [rand(rng, rand(rng, 1:L)) for _ in 1:n]
        pad = [zeros(1) for _ in 1:(N - n)]
        steps = [1 => rand(rng, L), 4 => rand(rng, L)]
        return (
            vector = (g, g),
            per_stratum = (PerStratum(Gs), PerStratum(Gs)),
            secondary = (TimeVarying(KN), TimeVarying(KN)),
            per_stratum_secondary = (
                TimeVarying(PerStratum(rand(rng, S, L, N))),
            ),
            primary = (
                TimeVarying(K, P), TimeVarying(hcat(K, zeros(L, N - n)), P),
            ),
            per_stratum_primary = (
                TimeVarying(PerStratum(G3), P),
                TimeVarying(PerStratum(cat(G3, zeros(S, L, N - n); dims = 3)), P),
            ),
            ragged_primary = (
                TimeVarying(cols, P), TimeVarying(vcat(cols, pad), P),
            ),
            piecewise_primary = (TimeVarying(steps, P), TimeVarying(steps, P)),
            piecewise = (TimeVarying(steps), TimeVarying(steps)),
        )
    end

    # The dense matrix of the convolution of stratum `k`'s `N` inputs.
    function dense(c, S, N, k)
        A = zeros(N, N)
        for j in 1:N
            E = zeros(S, N)
            E[k, j] = 1
            A[:, j] = c(E)[k, :]
        end
        return A
    end
    # `Aᵀ x` per stratum for the dense matrices `As` and strata × time `X`.
    function transposed(As, X)
        return permutedims(reduce(hcat, [As[i]' * X[i, :] for i in axes(X, 1)]))
    end
end

@testitem "Transpose: the dense matrix's transpose" setup = [
    TransposeCases,
] begin
    rng = Xoshiro(1)
    S, L, n, m = 2, 4, 9, 3
    N = n + m
    for (name, ks) in pairs(transpose_cases(rng, S, L, n, N))
        k, kN = first(ks), last(ks)
        X = rand(rng, S, N)
        x, tail = X[:, 1:n], X[:, (n + 1):N]
        As = [dense(Convolution(kN), S, N, i) for i in 1:S]
        ref = transposed(As, X)
        t = transpose(Convolution(k))
        @test t(x; tail) ≈ ref[:, 1:n]
        @test t(x; tail, start = 3, stop = 8) ≈ ref[:, 3:8]
        @test t(x; tail, start = n - 1, stop = n) ≈ ref[:, (n - 1):n]
        @test t(x) ≈ transposed(As, hcat(x, zero(tail)))[:, 1:n]
        # One series is the first stratum, as a vector.
        if !(k isa Union{PerStratum, TimeVarying{<:Any, <:PerStratum}})
            @test t(x[1, :]; tail = tail[1, :]) ≈ ref[1, 1:n]
        end
    end
end

@testitem "Transpose: spellings and checks" begin
    using ComposableRecurrences: ComposableRecurrences as CR
    c = Convolution(TimeVarying([0.5 0.2 0.1; 0.5 0.8 0.9], CR.Primary()))
    x = [1.0, 2.0, 4.0]
    @test c' === transpose(c)
    @test transpose(transpose(c)) === c
    @test (c')' === c
    @test CR.NoAdjoint(c')(x; tail = [8.0]) ≈ c'(x; tail = [8.0])
    @test c'(x; tail = [8.0]) ≈ [0.5 + 1.0, 0.4 + 3.2, 0.4 + 7.2]
    # An empty call, and one past the series that reads the tail alone.
    @test c'(x; start = 2, stop = 1) == Float64[]
    @test transpose(Convolution([1.0, 1.0]))(x; tail = [8.0], stop = 4) ==
        [3.0, 6.0, 12.0, 8.0]
    # The method of the convolution does not change the transpose.
    g = [0.5, 0.3, 0.2]
    d = Convolution(g; method = CR.Direct())
    @test transpose(d)(x) == transpose(Convolution(g))(x)
    @test_throws DimensionMismatch c'(x; stop = 4)
    @test_throws DimensionMismatch c'([x; 1.0]; stop = 4)
    @test_throws ArgumentError c'(x; start = 0)
    @test_throws ArgumentError c'(x; start = 3, stop = 1)
    @test_throws DimensionMismatch c'(x; tail = ones(2, 1))
    @test_throws ArgumentError c'(TimeVarying(ones(1, 3)))
    # A Secondary() kernel covers the last time it reads.
    s = Convolution(TimeVarying(ones(2, 3)))
    @test_throws DimensionMismatch s'(x; tail = [1.0])
    @test_throws DimensionMismatch Convolution(PerStratum(ones(2, 2)))'(ones(3, 4))
end

@testitem "Transpose: pullback against ForwardDiff" setup = [
    AdjointCheck, TransposeCases,
] begin
    using Base.ScopedValues: with
    rng = Xoshiro(2)
    S, L, n, m = 2, 4, 9, 3
    for (name, ks) in pairs(transpose_cases(rng, S, L, n, n + m))
        t = transpose(Convolution(first(ks)))
        X, tail = rand(rng, S, n), rand(rng, S, m)
        @test pullback_matches(t, X, tail, 1, nothing)
        @test pullback_matches(t, X, tail, 3, 8)
        @test pullback_matches(t, X, nothing, 2, 6)
        @test constant_kernel_matches(
            t, X, tail, 1, nothing; constant = p -> (; c = (; kernel = nothing))
        )
    end
    t = transpose(Convolution(rand(rng, L)))
    @test pullback_matches(t, rand(rng, n), rand(rng, m), 1, nothing)
    with(CR.EXECUTOR => CR.Threaded(; min_work = 0, ntasks = 2)) do
        for k in (rand(rng, L), TimeVarying(rand(rng, L, n), CR.Primary()))
            splits = CR._SPLIT_BLOCKS[]
            X, tail = rand(rng, S, n), rand(rng, S, m)
            @test pullback_matches(transpose(Convolution(k)), X, tail, 1, nothing)
            @test CR._SPLIT_BLOCKS[] > splits
        end
    end
end

# A forward sum of BVD's: what one infection on day `k` adds to each
# reporting window `[a, b]` through the delay `f`, `Σ_{j=a}^{b} f[j - k]`.
# It is a difference of the cumulative sum of `f`, so the transpose is not
# the cheaper way to write it; it is the transpose of the convolution of
# the windows' indicators.
@testitem "Transpose: window weights against a hand loop" begin
    using ForwardDiff
    nd, L = 30, 8
    f = [exp(-0.3 * l) for l in 0:(L - 1)]
    f ./= sum(f)
    windows = [(3, 9), (10, 10), (12, 20), (25, 34)]
    function hand(f)
        W = zeros(eltype(f), nd, length(windows))
        for (v, (a, b)) in enumerate(windows), k in 1:nd, j in a:b
            0 <= j - k < length(f) && (W[k, v] += f[j - k + 1])
        end
        return W
    end
    function weights(f)
        I = [a <= j <= b for (a, b) in windows, j in 1:(nd + L - 1)]
        Z = transpose(Convolution(f))(I[:, 1:nd]; tail = I[:, (nd + 1):end])
        return permutedims(Z)
    end
    @test weights(f) ≈ hand(f)
    w = [sin(k + v) for k in 1:nd, v in eachindex(windows)]
    @test ForwardDiff.gradient(f -> sum(w .* weights(f)), f) ≈
        ForwardDiff.gradient(f -> sum(w .* hand(f)), f)
end

@testitem "Transpose: numbers that do not vectorise take the gather body" begin
    using ComposableRecurrences: ComposableRecurrences as CR
    using Random
    rng = Xoshiro(4)
    S, L, n, m = 2, 4, 9, 3
    X, tail = rand(rng, S, n), rand(rng, S, m)
    for k in (rand(rng, L), PerStratum(rand(rng, S, L)))
        t = transpose(Convolution(k))
        kb = k isa PerStratum ? PerStratum(big.(k.x)) : big.(k)
        tb = transpose(Convolution(kb))
        @test CR._conv_path(BigFloat, kb, X) isa CR._Gathered
        for (start, stop) in ((1, n), (3, 8), (n - 1, n + m), (2, 1))
            @test tb(X; tail, start, stop) ≈ t(X; tail, start, stop)
            s = min(stop, n)
            @test tb(X; start, stop = s) ≈ t(X; start, stop = s)
        end
        k isa PerStratum && continue
        x, tl = X[1, :], tail[1, :]
        @test tb(x; tail = tl) ≈ t(x; tail = tl)
    end
end
