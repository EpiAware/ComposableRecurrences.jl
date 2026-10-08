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
    @test Convolution(rand(3)).method === CR.Direct()
    c = Convolution(rand(3); method = CR.FFTMethod())
    k = rand(3)
    @test ConstructionBase.setproperties(c; kernel = k).method === CR.FFTMethod()
    @test ConstructionBase.setproperties(c; kernel = k).kernel === k
end

@testitem "Convolution FFT: refused without FFTW" begin
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
                CR._convolve_back!(X̄d, k̄d, kernel, X, Ȳ, m, start)
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
