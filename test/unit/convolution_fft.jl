# The FFTMethod() lag sum against the direct one.

@testitem "Convolution FFT: matches direct" begin
    using ComposableRecurrences, FFTW, Random
    using Base.ScopedValues: with
    const CR = ComposableRecurrences
    rng = Xoshiro(41)
    # Short series take one block; long series against short kernels take
    # several, with block edges on different rows.
    for (T, L) in ((12, 5), (40, 1), (60, 7), (300, 20), (2000, 30), (5, 9))
        S = 3
        c, C = rand(rng, L), rand(rng, S, L)
        x, X = rand(rng, T), rand(rng, S, T)
        for m in (0, 4), start in (1, 3)
            h, H = m == 0 ? (nothing, nothing) : (rand(rng, m), rand(rng, S, m))
            for (k, u, hu) in ((c, x, h), (c, X, H), (PerStratum(C), X, H))
                direct = Convolution(k)
                fft = Convolution(k; method = CR.FFTMethod())
                y = fft(u; history = hu, start)
                @test y isa typeof(direct(u; history = hu, start))
                @test y ≈ direct(u; history = hu, start)
                g = rand(rng, size(u)...)
                @test fft(u; history = hu, start, gain = g, add = 1.0) ≈
                    direct(u; history = hu, start, gain = g, add = 1.0)
            end
        end
    end
    # The lag-0 weight alone, an empty kernel, and a kernel far longer than
    # the series and its history.
    fft = CR.FFTMethod()
    @test Convolution([2.0]; method = fft)([1.0, 2.0]) ≈ [2.0, 4.0]
    @test Convolution(Float64[]; method = fft)(rand(rng, 5)) == zeros(5)
    long, h, x = rand(rng, 500), rand(rng, 2), rand(rng, 5)
    @test Convolution(long; method = fft)(x; history = h) ≈
        Convolution(long)(x; history = h)
    # A view, a last time before the end, and the threaded executor.
    x = rand(rng, 3, 80)
    c = rand(rng, 9)
    @test Convolution(c; method = fft)(view(x, 2, :)) ≈ Convolution(c)(view(x, 2, :))
    @test Convolution(c; method = fft)(x; start = 4, stop = 60) ≈
        Convolution(c)(x; start = 4, stop = 60)
    y = with(CR.EXECUTOR => CR.Threaded(; min_work = 0)) do
        Convolution(c; method = fft)(x)
    end
    @test y ≈ Convolution(c)(x)
end

@testitem "Convolution FFT: the public call takes the transform" begin
    using ComposableRecurrences, FFTW
    const CR = ComposableRecurrences
    # A NaN input reaches earlier outputs of its block only through the
    # transform, so it shows which method ran.
    x = ones(50)
    x[40] = NaN
    k = fill(0.2, 5)
    @test !any(isnan, Convolution(k)(x)[1:39])
    @test any(isnan, Convolution(k; method = CR.FFTMethod())(x)[1:39])
    X = ones(2, 50)
    X[1, 40] = NaN
    @test any(isnan, Convolution(k; method = CR.FFTMethod())(X)[1, 1:39])
end

@testitem "Convolution FFT: Float32 is kept" begin
    using ComposableRecurrences, FFTW
    const CR = ComposableRecurrences
    k = Float32[0.1, 0.4, 0.3, 0.2]
    x = rand(Float32, 50)
    y = Convolution(k; method = CR.FFTMethod())(x)
    @test eltype(y) == Float32
    @test y ≈ Convolution(k)(x) rtol = 1.0f-5
    K = PerStratum(rand(Float32, 2, 4))
    X = rand(Float32, 2, 50)
    Y = Convolution(K; method = CR.FFTMethod())(X)
    @test eltype(Y) == Float32
    @test Y ≈ Convolution(K)(X) rtol = 1.0f-5
end

@testitem "Convolution FFT: which calls take the transform" begin
    using ComposableRecurrences, FFTW, ForwardDiff
    const CR = ComposableRecurrences
    fft = CR.FFTMethod()
    @test CR._fft_path(fft, rand(3), Float64, rand(5))
    @test CR._fft_path(fft, PerStratum(rand(2, 3)), Float32, rand(Float32, 2, 5))
    @test CR._fft_path(fft, rand(3), Float64, view(rand(8), 1:5))
    @test !CR._fft_path(CR.Direct(), rand(3), Float64, rand(5))
    # A time-varying kernel, other numbers and other arrays go direct.
    tv = TimeVarying(rand(3, 5))
    @test !CR._fft_path(fft, tv, Float64, rand(5))
    @test !CR._fft_path(fft, rand(3), BigFloat, rand(5))
    @test !CR._fft_path(fft, rand(3), Float16, rand(Float16, 5))
    D = ForwardDiff.Dual{Nothing, Float64, 1}
    @test !CR._fft_path(fft, rand(3), D, rand(5))
    @test !CR._fft_path(fft, rand(3), Float64, 1:5)
    # and give the direct result.
    x = rand(5)
    @test Convolution(tv; method = fft)(x) == Convolution(tv)(x)
    @test Convolution(rand(3); method = fft)(BigFloat.(x)) isa Vector{BigFloat}
    # The rule's forward pass records which method ran.
    ran(c) = last(CR._run_forward(c, x, true, nothing, nothing, 1, nothing)).fft
    @test ran(Convolution(rand(3); method = fft))
    @test !ran(Convolution(rand(3)))
    @test !ran(Convolution(tv; method = fft))
    # ForwardDiff gradients run direct.
    k = rand(4)
    f(k) = sum(abs2, Convolution(k; method = fft)(x))
    g(k) = sum(abs2, Convolution(k)(x))
    @test ForwardDiff.gradient(f, k) ≈ ForwardDiff.gradient(g, k)
end

@testitem "Convolution: method validation and rebuild" begin
    using ComposableRecurrences, ConstructionBase
    const CR = ComposableRecurrences
    @test_throws ArgumentError Convolution(rand(3); method = :fft)
    err = try
        Convolution(rand(3); method = :fft)
    catch e
        e
    end
    @test occursin(":fft", sprint(showerror, err))
    @test CR._method(Convolution(rand(3))) === CR.Auto()
    @test fieldnames(typeof(Convolution(rand(3)))) == (:kernel,)
    c = Convolution(rand(3); method = CR.FFTMethod())
    k = rand(3)
    @test CR._method(ConstructionBase.setproperties(c; kernel = k)) === CR.FFTMethod()
    @test ConstructionBase.setproperties(c; kernel = k).kernel === k
end

@testitem "Convolution FFT: refused without FFTW" begin
    using ComposableRecurrences
    const CR = ComposableRecurrences
    # The stubs refuse what the transforms do not take.
    Y, X = zeros(BigFloat, 3, 1), zeros(BigFloat, 5, 1)
    @test_throws ArgumentError CR._fft_convolve!(Y, [1.0], X, 2, 1)
    @test_throws ArgumentError CR._fft_convolve_back!(X, nothing, [1.0], X, Y, 2, 1)
    @test_throws ArgumentError CR._fft_path(CR.FFTMethod(), [1.0], Float64, nothing)
    @test_throws ArgumentError CR._fft_convolve_terms!(Y, (([1.0], X),), 2, 1)
    # A fresh process that loads the package but not FFTW.
    code = """
    using ComposableRecurrences
    try
        Convolution([1.0]; method = ComposableRecurrences.FFTMethod())([1.0])
    catch e
        print(sprint(showerror, e))
    end
    """
    julia = Base.julia_cmd()
    project = Base.active_project()
    out = read(`$julia --startup-file=no --project=$project -e $code`, String)
    @test occursin("using FFTW", out)
end

@testitem "Convolution FFT: reverse pass matches direct" begin
    using ComposableRecurrences, FFTW, Random
    const CR = ComposableRecurrences
    rng = Xoshiro(43)
    # The transforms' reverse pass against the direct one on the same
    # buffers, with and without a kernel cotangent.
    for (n, L, S, m, start) in ((30, 4, 1, 0, 1), (200, 7, 2, 3, 2), (12, 40, 3, 2, 1))
        X = rand(rng, n, S)
        T = n - m - start + 1
        Ȳ = rand(rng, T, S)
        for kernel in (rand(rng, L), PerStratum(rand(rng, S, L)))
            mirror(k::AbstractVector) = zeros(length(k))
            mirror(k::PerStratum) = (; x = zero(k.x))
            flat(k̄) = k̄ isa NamedTuple ? k̄.x : k̄
            for k̄ in (mirror(kernel), nothing)
                X̄d, X̄f = zero(X), zero(X)
                k̄d = k̄ === nothing ? nothing : mirror(kernel)
                CR._convolve_back!(CR.Serial(), X̄d, k̄d, kernel, X, Ȳ, m, start)
                CR._fft_convolve_back!(X̄f, k̄, kernel, X, Ȳ, m, start)
                @test X̄f ≈ X̄d
                k̄ === nothing || @test flat(k̄) ≈ flat(k̄d)
            end
        end
    end
    # An empty output takes no transform.
    X̄ = zeros(5, 1)
    CR._fft_convolve_back!(X̄, nothing, rand(3), rand(5, 1), zeros(0, 1), 5, 1)
    @test iszero(X̄)
end

@testitem "Convolution FFT: the rule's reverse pass matches direct" begin
    using ComposableRecurrences, FFTW, Random
    const CR = ComposableRecurrences
    # The rule's forward and reverse passes, driven without an AD backend:
    # the transform's cotangents match the direct method's.
    rng = Xoshiro(44)
    k, x, h, ȳ = rand(rng, 6), rand(rng, 30), rand(rng, 4), rand(rng, 28)
    function grads(method)
        c = Convolution(k; method)
        y, cache = CR._run_forward(c, x, 0.5, 1.0, h, 3, nothing)
        g = (;
            piece = (; kernel = zero(k)), y = ȳ,
            args = (zero(x), Ref(0.0), Ref(0.0), zero(h)),
        )
        CR.pullback!(g, c, CR.Run(), cache)
        return y, cache.fft, g
    end
    yd, fd, gd = grads(CR.Direct())
    yf, ff, gf = grads(CR.FFTMethod())
    @test !fd && ff
    @test yf ≈ yd
    @test gf.piece.kernel ≈ gd.piece.kernel
    @test gf.args[1] ≈ gd.args[1]
    @test gf.args[2][] ≈ gd.args[2][]
    @test gf.args[3][] ≈ gd.args[3][]
    @test gf.args[4] ≈ gd.args[4]
end

@testitem "Convolution FFT: device arrays take the direct method" begin
    using ComposableRecurrences, FFTW, JLArrays
    const CR = ComposableRecurrences
    JLArrays.allowscalar(false)
    # The transform runs on CPU arrays only, so a device call runs the direct
    # body on the device and returns a device array.
    fft = CR.FFTMethod()
    k, x, h = rand(6), rand(30), rand(3)
    K, X, H = rand(2, 6), rand(2, 30), rand(2, 3)
    @test !CR._fft_path(fft, JLArray(k), Float64, JLArray(x))
    y = Convolution(JLArray(k); method = fft)(JLArray(x); history = JLArray(h))
    @test y isa JLArray
    @test Array(y) ≈ Convolution(k)(x; history = h)
    Y = Convolution(PerStratum(JLArray(K)); method = fft)(JLArray(X); history = JLArray(H))
    @test Y isa JLArray
    @test Array(Y) ≈ Convolution(PerStratum(K))(X; history = H)
end

@testitem "Convolution Auto: which method it picks with FFTW" begin
    using ComposableRecurrences, FFTW, ForwardDiff, JLArrays
    const CR = ComposableRecurrences
    auto = CR.Auto()
    picks(kernel, Tp, x, T) = CR._fft_path(auto, kernel, Tp, x, T)
    # The transform from 300 lags and 1000 outputs, for a fixed kernel on
    # `Float64` CPU arrays.
    @test picks(rand(300), Float64, rand(1000), 1000)
    @test picks(PerStratum(rand(2, 500)), Float64, rand(2, 2000), 2000)
    @test picks(rand(300), Float64, view(rand(1200), 1:1000), 1000)
    @test !picks(rand(299), Float64, rand(2000), 2000)
    @test !picks(rand(500), Float64, rand(2000), 999)
    # Other kernels, numbers and arrays take the direct method at any size.
    @test !picks(TimeVarying(rand(300, 1000)), Float64, rand(1000), 1000)
    @test !picks(rand(Float32, 500), Float32, rand(Float32, 2000), 2000)
    @test !picks(rand(500), BigFloat, rand(2000), 2000)
    D = ForwardDiff.Dual{Nothing, Float64, 1}
    @test !picks(rand(500), D, rand(2000), 2000)
    @test !picks(JLArray(rand(500)), Float64, JLArray(rand(2000)), 2000)
    # The number of outputs is the call's, not the input's length.
    ran(c, x; start = 1, stop = nothing) = last(
        CR._run_forward(c, x, true, nothing, nothing, start, stop)
    ).fft
    x = rand(1200)
    @test ran(Convolution(rand(300)), x)
    @test ran(Convolution(rand(300)), x; start = 201)
    @test !ran(Convolution(rand(300)), x; start = 202)
    @test !ran(Convolution(rand(300)), x; stop = 999)
    @test !ran(Convolution(rand(299)), x)
    @test !ran(Convolution(rand(Float32, 300)), rand(Float32, 1200))
end

@testitem "Convolution Auto: matches direct" begin
    using ComposableRecurrences, FFTW, Random
    const CR = ComposableRecurrences
    rng = Xoshiro(45)
    # Sizes either side of the switch, for a shared and a per-stratum
    # kernel, with history, gain and add.
    for (T, L) in ((999, 300), (1000, 300), (1500, 400), (400, 20), (2000, 500))
        S = 2
        g = exp.(-0.05 .* (0:(L - 1)))
        G = rand(rng, S, L)
        x, X = rand(rng, T), rand(rng, S, T)
        h, H = rand(rng, 4), rand(rng, S, 4)
        for (k, u, hu) in ((g, x, h), (g, X, H), (PerStratum(G), X, H))
            auto = Convolution(k)
            direct = Convolution(k; method = CR.Direct())
            y = auto(u; history = hu, gain = 0.5, add = 1.0)
            @test y isa typeof(direct(u; history = hu))
            @test y ≈ direct(u; history = hu, gain = 0.5, add = 1.0)
        end
    end
    # `Float32` matches the direct method exactly, as it never takes the
    # transform.
    k, x = rand(rng, Float32, 500), rand(rng, Float32, 2000)
    @test Convolution(k)(x) == Convolution(k; method = CR.Direct())(x)
end

@testitem "Convolution Auto: direct without FFTW" begin
    using ComposableRecurrences
    const CR = ComposableRecurrences
    # A fresh process that loads the package but not FFTW.
    code = """
    using ComposableRecurrences
    const CR = ComposableRecurrences
    k, x = rand(500), rand(2000)
    c = Convolution(k)
    print(
        CR._fft_path(CR.Auto(), k, Float64, x, 2000), " ",
        last(CR._run_forward(c, x, true, nothing, nothing, 1, nothing)).fft, " ",
        c(x) == Convolution(k; method = CR.Direct())(x)
    )
    """
    julia = Base.julia_cmd()
    project = Base.active_project()
    out = read(`$julia --startup-file=no --project=$project -e $code`, String)
    @test out == "false false true"
end

@testsnippet WideRange begin
    using ComposableRecurrences, FFTW
    const CR = ComposableRecurrences
    const EXT = Base.get_extension(CR, :ComposableRecurrencesFFTWExt)
    # Each value within a relative 1e-10 of the direct one.
    within(a, b) = all(i -> abs(a[i] - b[i]) <= 1.0e-10 * abs(b[i]), eachindex(a, b))
    const TW, LW = 1000, 300
    const GW = let g = exp.(-0.05 .* (0:(LW - 1)))
        g ./ sum(g)
    end
    # A geometric series spanning `span` orders of magnitude.
    wide(span, dir) = dir(10.0 .^ range(-span, 0; length = TW))
    # An epidemic curve: a few early outputs are below the bound.
    epidemic(k) = [10 * exp(0.01t) * (1 + 0.2 * sin(t / 7 + k)) for t in 1:TW]
    # The forward transform of `x` without the check, and how many of its
    # sums miss the accuracy.
    function forward_raw(g, x)
        n, L = length(x), length(g)
        N = EXT._fftsize(n, L)
        f, b = EXT._plans(Float64, N, 1)
        K = EXT._spectrum(g, Float64, N, 1, L, false)
        Z, E = zeros(n, 1), zeros(n, 1)
        EXT._ola!(Z, E, f, b, K, [EXT._knorm(g, 1, L)], reshape(x, n, 1), 0, N, L)
        return vec(Z), count(i -> EXT._inexact(Z[i], E[i], 1.0e-10), eachindex(Z))
    end
    ninexact(g, x) = last(forward_raw(g, x))
    # The reverse transforms without the check, from time 1 with no history:
    # the input and kernel cotangents, how many sums of each miss, and
    # whether the pass takes the direct body.
    function reverse_raw(c, X, Ȳ)
        n, S = size(X)
        T = size(Ȳ, 1)
        L = EXT._reach(c, X)
        N = EXT._fftsize(n, L)
        f, b = EXT._plans(Float64, N, S)
        Kr = EXT._spectrum(c, Float64, N, S, L, true)
        W, EW = zeros(n, S), zeros(n, S)
        C, EC = zeros(L, S), zeros(L, S)
        cn = [EXT._knorm(c, k, L) for k in 1:S]
        EXT._ola_back!(W, EW, C, EC, cn, f, b, Kr, X, Ȳ, 0, N, L, true)
        nW = count(i -> EXT._inexact(W[i], EW[i], 1.0e-10), eachindex(W))
        k̄ = c isa PerStratum ? copy(C) : vec(sum(C; dims = 2))
        nC = EXT._kernel_inexact!(C, EC, c, 1.0e-10)
        return (; X̄ = W, k̄, nW, nC, direct = 4 * (nW * L + nC * T) > 2 * T * L * S)
    end
    # The direct reverse pass from time 1 with no history.
    function reverse_direct(c, X, Ȳ)
        X̄ = zero(X)
        k̄ = c isa PerStratum ? (; x = zero(c.x)) : zeros(length(c))
        CR._convolve_back!(CR.Serial(), X̄, k̄, c, X, Ȳ, 0, 1)
        return X̄, c isa PerStratum ? permutedims(k̄.x) : k̄
    end
    function reverse_fft(c, X, Ȳ)
        X̄ = zero(X)
        k̄ = c isa PerStratum ? (; x = zero(c.x)) : zeros(length(c))
        CR._fft_convolve_back!(X̄, k̄, c, X, Ȳ, 0, 1)
        return X̄, c isa PerStratum ? permutedims(k̄.x) : k̄
    end
end

@testitem "Convolution FFT: wide-range series match direct" setup = [WideRange] begin
    # Series spanning 12 to 22 orders of magnitude take the direct body.
    for span in (12, 16, 22), dir in (identity, reverse)
        x = wide(span, dir)
        @test 4 * ninexact(GW, x) > TW
        yd = Convolution(GW; method = CR.Direct())(x)
        for method in (CR.Auto(), CR.FFTMethod())
            y = Convolution(GW; method)(x)
            @test within(y, yd)
            @test all(>(0), y)
        end
    end
    # An epidemic curve recomputes its few inexact outputs one by one, per
    # stratum and with history.
    @test 0 < ninexact(GW, epidemic(1)) < TW ÷ 4
    X = permutedims(hcat(epidemic(1), epidemic(2)))
    H = ones(2, 5)
    G = PerStratum(permutedims(hcat(GW, reverse(GW))))
    for k in (GW, G)
        yd = Convolution(k; method = CR.Direct())(X; history = H)
        @test within(Convolution(k)(X; history = H), yd)
    end
end

@testitem "Convolution FFT: wide-range reverse pass matches direct" setup = [WideRange] begin
    # The cotangent of `log(y)` spans the same orders as the series, so both
    # cotangents take the direct body or recompute their inexact sums.
    for x in (wide(22, identity), wide(22, reverse), epidemic(1))
        X = reshape(x, TW, 1)
        y = Convolution(GW; method = CR.Direct())(x)
        Ȳ = reshape((1.5 .+ sin.(1:TW)) ./ y, TW, 1)
        X̄d, X̄f = zeros(TW, 1), zeros(TW, 1)
        k̄d, k̄f = zeros(LW), zeros(LW)
        CR._convolve_back!(CR.Serial(), X̄d, k̄d, GW, X, Ȳ, 0, 1)
        CR._fft_convolve_back!(X̄f, k̄f, GW, X, Ȳ, 0, 1)
        @test within(X̄f, X̄d)
        @test within(k̄f, k̄d)
    end
end

@testitem "Convolution FFT: inexact sums are recomputed one by one" setup = [WideRange] begin
    using Random: Xoshiro
    # A short kernel over ones with a stretch of tiny values: the outputs in
    # the stretch miss the accuracy, too few to take the direct body.
    g = [0.1, 0.4, 0.3, 0.15, 0.05]
    x = ones(TW)
    x[400:450] .= 1.0e-12
    yd = Convolution(g; method = CR.Direct())(x)
    raw, n = forward_raw(g, x)
    @test 0 < n < TW ÷ 4
    @test !within(raw, yd)
    @test within(Convolution(g; method = CR.FFTMethod())(x), yd)
    # The input cotangent from an output cotangent with the same stretch.
    X = reshape(1.0 .+ sin.(1:TW) .^ 2, TW, 1)
    Ȳ = ones(TW, 1)
    Ȳ[400:450] .= 1.0e-12
    r = reverse_raw(g, X, Ȳ)
    X̄d, k̄d = reverse_direct(g, X, Ȳ)
    @test r.nW > 0 && r.nC == 0 && !r.direct
    @test !within(r.X̄, X̄d)
    X̄f, k̄f = reverse_fft(g, X, Ȳ)
    @test within(X̄f, X̄d)
    @test within(k̄f, k̄d)
    # Small integers and a kernel of powers of two, so the direct sums are
    # exact: where they cancel to zero, in the kernel cotangent of lag 0 and
    # in some input cotangents, the transform leaves rounding.
    h = [0.5, 0.25, 0.125, 0.0625, 0.0625]
    rng = Xoshiro(1)
    X = reshape(Float64.(rand(rng, 1:3, TW)), TW, 1)
    X[1] = 1
    Ȳ = reshape(Float64.(rand(rng, -5:5, TW)), TW, 1)
    Ȳ[1] -= sum(Ȳ .* X)
    r = reverse_raw(h, X, Ȳ)
    X̄d, k̄d = reverse_direct(h, X, Ȳ)
    @test k̄d[1] == 0
    @test r.nW > 0 && r.nC == 1 && !r.direct
    @test !within(r.X̄, X̄d)
    @test !within(r.k̄, k̄d)
    X̄f, k̄f = reverse_fft(h, X, Ȳ)
    @test within(X̄f, X̄d)
    @test within(k̄f, k̄d)
end

@testitem "Convolution FFT: the output with gain and add is checked" setup = [WideRange] begin
    # An add input cancelling the lag sums of a 6-order series to 1e-4.
    x = [10.0^(6t / TW) for t in 1:TW]
    yd = Convolution(GW; method = CR.Direct())(x)
    a = -(1 - 1.0e-4) .* yd
    for gain in (true, 2.0)
        od = Convolution(GW; method = CR.Direct())(x; gain, add = gain .* a)
        @test within(Convolution(GW)(x; gain, add = gain .* a), od)
    end
end

@testitem "Convolution FFT: a shared kernel's cotangent is checked over the strata" setup = [WideRange] begin
    # Two strata whose kernel cotangents nearly cancel, as near the optimum
    # of a stratified likelihood with a shared delay.
    X = hcat([10.0^(4t / TW) for t in 1:TW], [10.0^(4t / TW) * (1 + 0.3 * sin(t)) for t in 1:TW])
    Y = similar(X)
    for k in 1:2
        Y[:, k] = Convolution(GW; method = CR.Direct())(X[:, k])
    end
    w = 1.5 .+ sin.(1:TW)
    Ȳ = hcat(w, -0.999 .* w) ./ Y
    r = reverse_raw(GW, X, Ȳ)
    X̄d, k̄d = reverse_direct(GW, X, Ȳ)
    @test r.nC > 0
    @test !within(r.k̄, k̄d)
    X̄f, k̄f = reverse_fft(GW, X, Ȳ)
    @test within(X̄f, X̄d)
    @test within(k̄f, k̄d)
    # Per stratum, each cotangent is checked on its own.
    G = PerStratum(permutedims(hcat(GW, GW)))
    X̄d, k̄d = reverse_direct(G, X, Ȳ)
    X̄f, k̄f = reverse_fft(G, X, Ȳ)
    @test within(X̄f, X̄d)
    @test within(k̄f, k̄d)
end
