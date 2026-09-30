# Convolution values against the naive reference. Kernels are indexed from
# lag 0: `c[d + 1]` weights `x_{t-d}`.

@testitem "Convolution: fixed kernel" setup = [Reference] begin
    using ComposableRecurrences, Random
    rng = Xoshiro(21)
    D, T = 5, 12
    c = rand(rng, D)
    x = rand(rng, T)
    y = Convolution(c)(x)
    @test y isa Vector{Float64}
    @test y ≈ vec(naive_convolution((t, k, d) -> c[d + 1], reshape(x, 1, T), D))

    S = 3
    X = rand(rng, S, T)
    Y = Convolution(c)(X)
    @test size(Y) == (S, T)
    @test Y ≈ naive_convolution((t, k, d) -> c[d + 1], X, D)

    # A kernel longer than the series.
    c = rand(rng, T + 3)
    @test Convolution(c)(x) ≈
        vec(naive_convolution((t, k, d) -> c[d + 1], reshape(x, 1, T), T + 3))
end

@testitem "Convolution: history" setup = [Reference] begin
    using ComposableRecurrences, Random
    rng = Xoshiro(22)
    D, T, S = 4, 9, 2
    c = rand(rng, D)
    x = rand(rng, T)
    for m in (1, 3, 6)
        h = rand(rng, m)
        ref = naive_convolution(
            (t, k, d) -> c[d + 1], reshape(x, 1, T), D; hist = reshape(h, 1, m)
        )
        @test Convolution(c)(x; history = h) ≈ vec(ref)
    end
    X = rand(rng, S, T)
    H = rand(rng, S, 3)
    @test Convolution(c)(X; history = H) ≈
        naive_convolution((t, k, d) -> c[d + 1], X, D; hist = H)
end

@testitem "Convolution: per-stratum and time-varying kernels" setup = [Reference] begin
    using ComposableRecurrences, Random
    rng = Xoshiro(23)
    S, D, T = 3, 4, 8
    X = rand(rng, S, T)
    H = rand(rng, S, 2)

    C = rand(rng, S, D)
    @test Convolution(PerStratum(C))(X; history = H) ≈
        naive_convolution((t, k, d) -> C[k, d + 1], X, D; hist = H)

    Ct = rand(rng, D, T)
    @test Convolution(TimeVarying(Ct))(X; history = H) ≈
        naive_convolution((t, k, d) -> Ct[d + 1, t], X, D; hist = H)

    C3 = rand(rng, S, D, T)
    @test Convolution(TimeVarying(C3))(X) ≈
        naive_convolution((t, k, d) -> C3[k, d + 1, t], X, D)

    x = X[1, :]
    @test Convolution(TimeVarying(Ct))(x) ≈
        vec(naive_convolution((t, k, d) -> Ct[d + 1, t], X[1:1, :], D))
end

@testitem "Convolution: argument validation" begin
    using ComposableRecurrences
    @test_throws DimensionMismatch Convolution(ones(3))(ones(2, 5); history = ones(3, 2))
    @test_throws DimensionMismatch Convolution(PerStratum(ones(2, 3)))(ones(3, 5))
    @test_throws DimensionMismatch Convolution(TimeVarying(ones(3, 4)))(ones(5))
end
