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

@testitem "Convolution: per-stratum kernel" setup = [Reference] begin
    using ComposableRecurrences, Random
    rng = Xoshiro(23)
    S, D, T = 3, 4, 8
    X = rand(rng, S, T)
    H = rand(rng, S, 2)
    C = rand(rng, S, D)
    @test Convolution(PerStratum(C))(X; history = H) ≈
        naive_convolution((t, k, d) -> C[k, d + 1], X, D; hist = H)
end

@testitem "Convolution: time-varying kernel indexed by output" setup = [Reference] begin
    using ComposableRecurrences, Random
    rng = Xoshiro(24)
    S, D, T = 3, 4, 8
    X = rand(rng, S, T)
    H = rand(rng, S, 2)
    # Column `t` weights the inputs reaching output `t`.
    Ct = rand(rng, D, T)
    c = Convolution(TimeVarying(Ct))
    @test c(X; history = H) ≈
        naive_convolution((t, k, d) -> Ct[d + 1, t], X, D; hist = H)
    @test Convolution(TimeVarying(Ct, ComposableRecurrences.Secondary()))(X) ≈ c(X)
    C3 = rand(rng, S, D, T)
    @test Convolution(TimeVarying(PerStratum(C3)))(X) ≈
        naive_convolution((t, k, d) -> C3[k, d + 1, t], X, D)
    # The inputs before `start` come from `x`.
    full = c(X; history = H)
    @test c(X; history = H, start = 4) ≈ full[:, 4:end]
    @test c(X; history = H, start = 4, stop = 6) ≈ full[:, 4:6]
    @test c(X[1, :]) ≈
        vec(naive_convolution((t, k, d) -> Ct[d + 1, t], X[1:1, :], D))
end

@testitem "Convolution: time-varying kernel indexed by input" setup = [Reference] begin
    using ComposableRecurrences, Random
    rng = Xoshiro(25)
    S, D, T = 3, 4, 8
    X = rand(rng, S, T)
    # Column `s` is the delay pmf of the input at time `s`: output `t`
    # reads the input at `t - d` through that input's column.
    Ct = rand(rng, D, T)
    c = Convolution(TimeVarying(Ct, ComposableRecurrences.Primary()))
    ref = naive_convolution((t, k, d) -> t - d >= 1 ? Ct[d + 1, t - d] : 0.0, X, D)
    @test c(X) ≈ ref
    C3 = rand(rng, S, D, T)
    @test Convolution(TimeVarying(PerStratum(C3), ComposableRecurrences.Primary()))(X) ≈
        naive_convolution(
        (t, k, d) -> t - d >= 1 ? C3[k, d + 1, t - d] : 0.0, X, D
    )

    # Inputs before `start` spread through their own columns; there is no
    # column for an input before t = 1.
    @test c(X; start = 4) ≈ ref[:, 4:end]
    @test c(X; start = 4, stop = 6) ≈ ref[:, 4:6]
    @test_throws ArgumentError c(X; history = X[:, 1:2])

    # Every input's mass lands somewhere when the window is long enough.
    P = rand(rng, D, T)
    P ./= sum(P; dims = 1)
    x = [rand(rng, T - D); zeros(D)]
    @test sum(Convolution(TimeVarying(P, ComposableRecurrences.Primary()))(x)) ≈ sum(x)

    # A constant kernel is the same under either indexing.
    g = rand(rng, D)
    G = repeat(g, 1, T)
    @test Convolution(TimeVarying(G, ComposableRecurrences.Primary()))(X) ≈
        Convolution(g)(X)
    @test Convolution(TimeVarying(G))(X) ≈ Convolution(g)(X)
end

@testitem "Convolution: output indexing matches CTIDM's time-varying delay" setup = [UseCaseReferences] begin
    using ComposableRecurrences
    C = UseCaseReferences.CTIDMReference
    Y = [5.0, 8.0, 12.0, 15.0, 14.0, 11.0, 9.0, 7.0, 6.0, 4.0]
    n, d = length(Y), 3
    early, late = [0.6, 0.3, 0.1], [0.1, 0.3, 0.6]
    P = reduce(hcat, [early .* (1 - s) .+ late .* s for s in range(0, 1; length = n)])
    ref = C.time_varying_latent_delay(collect(eachcol(P)), Y)
    c = Convolution(TimeVarying(P))
    @test c(Y)[d:end] ≈ ref
end

@testitem "Convolution: argument validation" begin
    using ComposableRecurrences
    err = try
        TimeVarying(ones(2, 2), :primary)
        nothing
    catch e
        e
    end
    @test err isa ArgumentError
    @test occursin("Secondary()", err.msg) && occursin("Primary()", err.msg)
    # Indexing lives on TimeVarying only.
    @test_throws MethodError Convolution([1.0]; indexed_by = :secondary)
    @test_throws ArgumentError Convolution(Pairwise(ones(2, 2, 3)))
    @test_throws ArgumentError Convolution(ones(2, 3))
    @test_throws ArgumentError Convolution(TimeVarying(ones(2, 3, 4)))
    @test_throws ArgumentError Convolution(nothing)
    @test_throws ArgumentError Convolution(ones(3))(TimeVarying(ones(5)))
    @test_throws DimensionMismatch Convolution(ones(3))(ones(5); stop = 6)
    @test_throws DimensionMismatch Convolution(ones(3))(ones(2, 5); history = ones(3, 2))
    @test_throws DimensionMismatch Convolution(PerStratum(ones(2, 3)))(ones(3, 5))
    @test_throws DimensionMismatch Convolution(TimeVarying(ones(3, 4)))(ones(5))
end
