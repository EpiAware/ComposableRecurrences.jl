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
    c = Convolution(TimeVarying(Ct); indexed_by = :secondary)
    @test c(X; history = H) ≈
        naive_convolution((t, k, d) -> Ct[d + 1, t], X, D; hist = H)
    C3 = rand(rng, S, D, T)
    @test Convolution(TimeVarying(C3); indexed_by = :secondary)(X) ≈
        naive_convolution((t, k, d) -> C3[k, d + 1, t], X, D)
    full = c(X)
    @test c(X[:, 4:end]; history = X[:, 1:3], start = 4) ≈ full[:, 4:end]
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
    c = Convolution(TimeVarying(Ct))
    ref = naive_convolution((t, k, d) -> t - d >= 1 ? Ct[d + 1, t - d] : 0.0, X, D)
    @test c(X) ≈ ref
    @test Convolution(TimeVarying(Ct); indexed_by = :primary)(X) ≈ ref
    C3 = rand(rng, S, D, T)
    @test Convolution(TimeVarying(C3))(X) ≈ naive_convolution(
        (t, k, d) -> t - d >= 1 ? C3[k, d + 1, t - d] : 0.0, X, D
    )

    # History inputs sit at their own times before `start`.
    @test c(X[:, 4:end]; history = X[:, 1:3], start = 4) ≈ ref[:, 4:end]
    @test_throws ArgumentError c(X; history = X[:, 1:2])

    # Every input's mass lands somewhere when the window is long enough.
    P = rand(rng, D, T)
    P ./= sum(P; dims = 1)
    x = [rand(rng, T - D); zeros(D)]
    @test sum(Convolution(TimeVarying(P))(x)) ≈ sum(x)

    # A fixed kernel is the same under either indexing.
    g = rand(rng, D)
    @test Convolution(g; indexed_by = :secondary)(X) ≈ Convolution(g)(X)
end

@testitem "Convolution: output indexing matches CTIDM's time-varying delay" setup = [UseCaseReferences] begin
    using ComposableRecurrences
    C = UseCaseReferences.CTIDMReference
    Y = [5.0, 8.0, 12.0, 15.0, 14.0, 11.0, 9.0, 7.0, 6.0, 4.0]
    n, d = length(Y), 3
    early, late = [0.6, 0.3, 0.1], [0.1, 0.3, 0.6]
    P = reduce(hcat, [early .* (1 - s) .+ late .* s for s in range(0, 1; length = n)])
    ref = C.time_varying_latent_delay(collect(eachcol(P)), Y)
    c = Convolution(TimeVarying(P); indexed_by = :secondary)
    @test c(Y)[d:end] ≈ ref
end

@testitem "Convolution: argument validation" begin
    using ComposableRecurrences
    err = try
        Convolution([1.0]; indexed_by = :tertiary)
        nothing
    catch e
        e
    end
    @test err isa ArgumentError
    @test occursin(":tertiary", err.msg) && occursin(":primary", err.msg) &&
        occursin(":secondary", err.msg)
    @test_throws DimensionMismatch Convolution(ones(3))(ones(2, 5); history = ones(3, 2))
    @test_throws DimensionMismatch Convolution(PerStratum(ones(2, 3)))(ones(3, 5))
    @test_throws DimensionMismatch Convolution(TimeVarying(ones(3, 4)))(ones(5))
end

@testitem "Convolution: modifiers act on each output step" setup = [Reference] begin
    using ComposableRecurrences, Random
    CR = ComposableRecurrences
    rng = Xoshiro(31)
    S, D, T = 3, 4, 8
    c = rand(rng, D)
    X = rand(rng, S, T)
    H = rand(rng, S, 2)
    base = naive_convolution((t, k, d) -> c[d + 1], X, D; hist = H)
    B = rand(rng, S, T + 2)
    lo, hi = [0.2, 0.3, 0.4], 0.9
    sat(v, θ) = θ * v / (1 + v)
    conv(mods; kw...) = Convolution(c; modifiers = mods)(X; history = H, kw...)
    # Imports read at the absolute time, then per-stratum Clamp, then a
    # Transform, in tuple order.
    mods = (CR.Imports(TimeVarying(B)), CR.Clamp(lo, hi), CR.Transform(sat, 2.0))
    ref = [
        sat(clamp(base[k, t] + B[k, t + 2], lo[k], hi), 2.0) for k in 1:S,
            t in 1:T
    ]
    @test conv(mods; start = 3) ≈ ref
    # The order matters: clamping last bounds the output.
    y = conv((CR.Transform(sat, 2.0), CR.Clamp(lo, hi)))
    @test y ≈ [clamp(sat(base[k, t], 2.0), lo[k], hi) for k in 1:S, t in 1:T]
    # No modifiers is the plain convolution.
    @test Convolution(c; modifiers = ())(X; history = H) ≈ base
    # A single series.
    x = X[1, :]
    y = Convolution(c; modifiers = (CR.Transform(sqrt),))(x; history = H[1, :])
    @test y ≈ sqrt.(base[1, :])
end

@testitem "Convolution: modifiers do not feed back into the input" setup = [Reference] begin
    using ComposableRecurrences, Random
    CR = ComposableRecurrences
    rng = Xoshiro(32)
    D, T = 3, 10
    c = rand(rng, D)
    x = 5 .* rand(rng, T)
    base = vec(naive_convolution((t, k, d) -> c[d + 1], reshape(x, 1, T), D))
    # Depletion draws each output from a pool that starts at N and shrinks
    # by the outputs; the convolution still reads the undepleted input.
    N = 20.0
    pool = N
    ref = map(base) do v
        y = pool * (1 - exp(-v / N))
        pool *= exp(-v / N)
        return y
    end
    y = Convolution(c; modifiers = (CR.Depletion(N),))(x)
    @test y ≈ ref
    @test sum(y) < N
    # The input history is not drawn from the pool, even when seeded.
    h = [1.0, 2.0]
    base_h = vec(
        naive_convolution(
            (t, k, d) -> c[d + 1], reshape(x, 1, T), D; hist = reshape(h, 1, 2)
        )
    )
    pool = N
    ref_h = map(base_h) do v
        y = pool * (1 - exp(-v / N))
        pool *= exp(-v / N)
        return y
    end
    m = CR.Depletion(N; seeded = true)
    @test Convolution(c; modifiers = (m,))(x; history = h) ≈ ref_h
end

@testitem "Convolution: resume from the returned state" begin
    using ComposableRecurrences, Random
    CR = ComposableRecurrences
    rng = Xoshiro(33)
    S, D, T = 2, 4, 12
    X = rand(rng, S, T)
    H = rand(rng, S, 3)
    B = rand(rng, S, T)
    P = rand(rng, D, T + 1)
    mods = (
        CR.Imports(TimeVarying(B)), CR.Depletion([30.0, 40.0]),
        CR.Transform(*, TimeVarying(1 .+ B)),
    )
    for kernel in (rand(rng, D), TimeVarying(P))
        c = Convolution(kernel; modifiers = mods)
        full = c(X; history = H, start = 2)
        y1, state = c(X[:, 1:5]; history = H, start = 2, return_state = true)
        @test state.t == 7
        y2 = c(X[:, 6:end]; history = state)
        @test hcat(y1, y2) ≈ full
    end
    # A single series, and without modifiers.
    x = X[1, :]
    c = Convolution(rand(rng, D))
    y1, state = c(x[1:4]; return_state = true)
    @test vcat(y1, c(x[5:end]; history = state)) ≈ c(x)
end

@testitem "Convolution: modifier eltypes and derivatives" begin
    using ComposableRecurrences, ForwardDiff
    CR = ComposableRecurrences
    c = Float32[0.2, 0.5, 0.3]
    x = Float32[1.0, 2.0, 3.0, 4.0, 5.0]
    y = Convolution(c; modifiers = (CR.Transform(*, 2.0f0),))(x)
    @test eltype(y) == Float32
    # A Dual parameter in a modifier promotes the buffer.
    w = [0.5, 1.0, 1.5, 2.0, 2.5]
    loss(θ) = sum(
        w .* Convolution(c; modifiers = (CR.Depletion(θ[1]), CR.Clamp(0.0, θ[2])))(x)
    )
    θ = [20.0, 2.0]
    ∇ = ForwardDiff.gradient(loss, θ)
    fd = map(1:2) do i
        e = zeros(2)
        e[i] = 1.0e-6
        (loss(θ + e) - loss(θ - e)) / 2.0e-6
    end
    @test ∇ ≈ fd rtol = 1.0e-6
    @test all(!iszero, ∇)
end
