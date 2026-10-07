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

@testitem "Convolution: other number types take the gather body" begin
    using ComposableRecurrences, Random
    rng = Xoshiro(26)
    S, D, T = 3, 4, 9
    c, C = rand(rng, D), rand(rng, S, D)
    x, X = rand(rng, T), rand(rng, S, T)
    h, H = rand(rng, 2), rand(rng, S, 2)
    big = v -> BigFloat.(v)
    for (k, u, hu) in ((c, x, h), (c, X, H), (PerStratum(C), X, H))
        conv = Convolution(k)
        @test conv(big(u)) isa AbstractArray{BigFloat}
        @test conv(big(u)) ≈ conv(u)
        @test conv(big(u); history = big(hu)) ≈ conv(u; history = hu)
        @test conv(big(u); history = big(hu), start = 3, stop = 7) ≈
            conv(u; history = hu, start = 3, stop = 7)
    end
    # A kernel longer than the series and its history.
    long = rand(rng, T + 3)
    @test Convolution(long)(big(x); history = big(h)) ≈ Convolution(long)(x; history = h)
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
    # A kernel with more lags than the history and series hold.
    Cl = rand(rng, T + 3, T)
    @test Convolution(TimeVarying(Cl))(X; history = H) ≈
        naive_convolution((t, k, d) -> Cl[d + 1, t], X, T + 3; hist = H)
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
    cp = Convolution(TimeVarying(PerStratum(C3), ComposableRecurrences.Primary()))
    @test cp(X; start = 4, stop = 6) ≈ cp(X)[:, 4:6]
    @test_throws ArgumentError c(X; history = X[:, 1:2])
    @test_throws "not as history (" c(X; history = X[:, 1:2])

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
    @test_throws "not a Convolution; got Pairwise(" Convolution(Pairwise(ones(2, 2, 3)))
    @test_throws ArgumentError Convolution(ones(2, 3))
    @test_throws ArgumentError Convolution(TimeVarying(ones(2, 3, 4)))
    @test_throws ArgumentError Convolution(nothing)
    @test_throws ArgumentError Convolution(ones(3))(TimeVarying(ones(5)))
    @test_throws DimensionMismatch Convolution(ones(3))(ones(5); stop = 6)
    @test_throws DimensionMismatch Convolution(ones(3))(ones(2, 5); history = ones(3, 2))
    @test_throws "history is 3×2 Matrix{Float64} but x is 2×5" Convolution(ones(3))(
        ones(2, 5); history = ones(3, 2)
    )
    @test_throws DimensionMismatch Convolution(PerStratum(ones(2, 3)))(ones(3, 5))
    @test_throws DimensionMismatch Convolution(TimeVarying(ones(3, 4)))(ones(5))
end

@testitem "Convolution: input loads the same into any buffer" begin
    import ComposableRecurrences as CR
    using Random
    rng = Xoshiro(23)
    m, stop, S = 2, 6, 3
    x = rand(rng, stop + 1)
    X = rand(rng, S, stop + 1)
    # `Array` buffers load by loop; a view takes the broadcast fallback.
    for (buf, src) in ((zeros(m + stop, 1), x), (zeros(m + stop, S), X))
        alt = view(zeros(size(buf)), :, :)
        @test !(alt isa Array)
        @test CR._load_input!(alt, src, m, stop) == CR._load_input!(buf, src, m, stop)
    end
end

@testitem "Convolution: gain and add" setup = [Reference] begin
    using ComposableRecurrences, Random
    import ComposableRecurrences as CR
    rng = Xoshiro(27)
    S, D, T = 3, 4, 9
    c = rand(rng, D)
    X, H = rand(rng, S, T), rand(rng, S, 2)
    ref = naive_convolution((t, k, d) -> c[d + 1], X, D; hist = H)
    conv = Convolution(c)
    slot(v::Real, k, t) = v
    slot(::Nothing, k, t) = 0.0
    slot(v::AbstractVector, k, t) = v[t]
    slot(v::AbstractMatrix, k, t) = v[k, t]
    hand(g, a) = [slot(g, k, t) * ref[k, t] + slot(a, k, t) for k in 1:S, t in 1:T]
    for g in (true, 0.4, rand(rng, T), rand(rng, S, T)),
            a in (nothing, 1.5, rand(rng, T), rand(rng, S, T))
        @test conv(X; history = H, gain = g, add = a) ≈ hand(g, a)
        @test conv(X; history = H, gain = g, add = a, start = 3, stop = 7) ≈
            hand(g, a)[:, 3:7]
        @test conv(big.(X); history = H, gain = g, add = a) ≈ hand(g, a)
    end
    g, a = rand(rng, T), rand(rng, T)
    @test conv(X[1, :]; history = H[1, :], gain = g, add = a) ≈ hand(g, a)[1, :]
    # A gain or add matrix covers the strata of a single series too.
    @test conv(X[1, :]; history = H[1, :], gain = g', add = a') ≈ hand(g, a)[1, :]
    # Other arrays take the broadcast fallback.
    Y = rand(rng, T, S)
    for (u, gg, aa) in (
            (X, g, rand(rng, S, T)), (X[1, :], 0.5, a),
            (X[1, :], rand(rng, 1, T), nothing),
        )
        Yu = u isa AbstractVector ? Y[:, 1:1] : Y
        @test CR._scaled_public(view(Yu, :, :), u, gg, aa, 1) ≈
            CR._scaled_public(Yu, u, gg, aa, 1)
    end
    @test (@inferred conv(X; gain = rand(rng, S, T), add = 0.1)) isa Matrix{Float64}
    # The default stop, read from a mix of arrays and absent inputs, does
    # not allocate.
    stop_of(u, g, a) = CR._stop(
        nothing, (:x => CR._extent(u), :gain => CR._extent(g), :add => CR._extent(a))
    )
    stop_allocs(u) = (stop_of(u, true, nothing); @allocated stop_of(u, true, nothing))
    @test stop_allocs(X) == 0
    @test Convolution(Float32.(c))(Float32.(X); gain = 0.5f0) isa Matrix{Float32}
    @test_throws DimensionMismatch conv(X; gain = rand(rng, 2, T))
    @test_throws "gain has 2 strata, expected 3" conv(X; gain = rand(rng, 2, T))
    @test_throws DimensionMismatch conv(X; add = rand(rng, T + 1))
    @test_throws DimensionMismatch conv(X; gain = rand(rng, T - 1), stop = T)
    @test_throws ArgumentError conv(X; gain = TimeVarying(rand(rng, T)))
end

@testitem "Convolution: contributions" setup = [Reference] begin
    using ComposableRecurrences, Random
    import ComposableRecurrences as CR
    rng = Xoshiro(28)
    S, D, T = 2, 4, 8
    X, H = rand(rng, S, T), rand(rng, S, 3)
    G = rand(rng, S, T)
    ks = [rand(rng, n) for n in (2, 0, 4, 1, 3, 4, 2, 1)]
    Ct, C3 = rand(rng, D, T), rand(rng, S, D, T)
    P = CR.Primary()
    # Each kernel with its weight on lag `d` at output time `t` for stratum
    # `k`, zero where it has none.
    rag(τ, d) = τ >= 1 && d < length(ks[τ]) ? ks[τ][d + 1] : 0.0
    c = rand(rng, D)
    C = rand(rng, S, D)
    cases = [
        (c, (t, k, d) -> c[d + 1], true),
        (PerStratum(C), (t, k, d) -> C[k, d + 1], true),
        (TimeVarying(Ct), (t, k, d) -> Ct[d + 1, t], true),
        (TimeVarying(PerStratum(C3)), (t, k, d) -> C3[k, d + 1, t], true),
        (TimeVarying(ks), (t, k, d) -> rag(t, d), true),
        (TimeVarying(Ct, P), (t, k, d) -> t - d >= 1 ? Ct[d + 1, t - d] : 0.0, false),
        (TimeVarying(PerStratum(C3), P), (t, k, d) -> t - d >= 1 ? C3[k, d + 1, t - d] : 0.0, false),
        (TimeVarying(ks, P), (t, k, d) -> rag(t - d, d), false),
    ]
    for (kernel, w, history) in cases
        conv = Convolution(kernel)
        L = CR._nlags(kernel)
        h = history ? H : nothing
        m = history ? size(H, 2) : 0
        at(k, τ) = τ >= 1 ? X[k, τ] : (τ >= 1 - m ? H[k, τ + m] : 0.0)
        hand = [G[k, t] * w(t, k, d) * at(k, t - d) for k in 1:S, d in 0:(L - 1), t in 1:T]
        Y = CR.contributions(conv, X; gain = G, history = h)
        @test size(Y) == (S, L, T)
        @test Y ≈ hand
        @test dropdims(sum(Y; dims = 2); dims = 2) ≈ conv(X; gain = G, history = h)
        @test CR.contributions(conv, X; gain = G, history = h, start = 3, stop = 6) ≈
            hand[:, :, 3:6]
        @test CR.contributions(CR.NoAdjoint(conv), X; history = h) ≈
            CR.contributions(conv, X; history = h)
        if !(kernel isa PerStratum || kernel isa TimeVarying && kernel.x isa PerStratum)
            hist1 = history ? H[1, :] : nothing
            Y1 = CR.contributions(conv, X[1, :]; gain = 0.5, history = hist1)
            @test size(Y1) == (L, T)
            @test Y1 ≈ 0.5 .* hand[1, :, :] ./ G[1:1, :]
        end
    end
    conv = Convolution(c)
    @test (@inferred CR.contributions(conv, X; gain = G)) isa Array{Float64, 3}
    @test (@inferred CR.contributions(conv, X[1, :])) isa Matrix{Float64}
    @test_throws MethodError CR.contributions(conv, X; add = 1.0)
    @test_throws ArgumentError CR.contributions(Convolution(TimeVarying(Ct, P)), X; history = H)
    @test_throws DimensionMismatch CR.contributions(conv, X; gain = rand(rng, 3, T))
end
