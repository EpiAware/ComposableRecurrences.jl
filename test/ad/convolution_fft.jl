# Gradients of an FFTMethod() convolution match ForwardDiff, which runs the
# direct method. Under Enzyme and Mooncake reverse mode the native rule
# runs the transform both ways; forward mode and NoAdjoint calls they trace
# take the direct method or the transform's own Enzyme rules.
# The Enzyme items are tagged `compat_floor`, so the Threads workflow runs
# them on Julia 1.11.

@testsnippet FFTAD begin
    using ComposableRecurrences, DifferentiationInterface, FFTW, ForwardDiff
    using ADTypes: AutoForwardDiff
    using Random: Xoshiro
    const CR = ComposableRecurrences

    # Losses over the kernel, history and input together, for a shared
    # and a per-stratum kernel, single series and strata, through the rule
    # and under NoAdjoint. `T = 150` against `L = 6` takes several blocks.
    function fft_losses()
        rng = Xoshiro(9)
        S, T, L, m = 3, 150, 6, 4
        w, W = rand(rng, T), rand(rng, S, T)
        fft = CR.FFTMethod()
        n = L + m + T
        nS = S * L + S * m + S * T
        function shared(route)
            return function (θ)
                c = Convolution(θ[1:L]; method = fft)
                y = route(c)(θ[(L + m + 1):n]; history = θ[(L + 1):(L + m)], start = 2)
                return sum(w[2:end] .* y)
            end
        end
        function strata(route)
            return function (θ)
                C = reshape(θ[1:(S * L)], S, L)
                H = reshape(θ[(S * L + 1):(S * L + S * m)], S, m)
                X = reshape(θ[(S * L + S * m + 1):nS], S, T)
                c = Convolution(PerStratum(C); method = fft)
                return sum(W .* route(c)(X; history = H, gain = 0.5, add = 1.0))
            end
        end
        cases = Any[]
        for route in (identity, CR.NoAdjoint)
            push!(cases, (shared(route), 1.0 .+ rand(rng, n)))
            push!(cases, (strata(route), 1.0 .+ rand(rng, nS)))
        end
        return cases
    end

    function test_fft_gradients(backend)
        for (loss, θ) in fft_losses()
            ref = DifferentiationInterface.gradient(loss, AutoForwardDiff(), θ)
            @test DifferentiationInterface.gradient(loss, backend, θ) ≈ ref
        end
        return nothing
    end
end

@testitem "FFT convolution gradients: ReverseDiff" tags = [:ad, :reversediff] setup = [FFTAD] begin
    using ReverseDiff: ReverseDiff
    using ADTypes: AutoReverseDiff
    test_fft_gradients(AutoReverseDiff())
end

@testitem "FFT convolution gradients: Enzyme reverse" tags = [:ad, :enzyme, :enzyme_reverse, :compat_floor] setup = [FFTAD] begin
    using Enzyme: Enzyme
    import EnzymeTestUtils
    using ADTypes: AutoEnzyme
    test_fft_gradients(
        AutoEnzyme(;
            mode = Enzyme.set_runtime_activity(Enzyme.Reverse),
            function_annotation = Enzyme.Const,
        )
    )
    # The rule's own check, with the transform both ways.
    rng = Xoshiro(3)
    c = Convolution(rand(rng, 5); method = CR.FFTMethod())
    args = (rand(rng, 40), true, nothing, rand(rng, 3), 2, nothing)
    CR.test_adjoint(AutoEnzyme(), c, CR.Run(), args...; rtol = 1.0e-7, atol = 1.0e-7)
end

@testitem "FFT convolution gradients: Mooncake reverse" tags = [:ad, :mooncake, :mooncake_reverse] setup = [FFTAD] begin
    using Mooncake: Mooncake
    using ADTypes: AutoMooncake
    test_fft_gradients(AutoMooncake(; config = nothing))
    rng = Xoshiro(3)
    c = Convolution(PerStratum(rand(rng, 2, 5)); method = CR.FFTMethod())
    args = (rand(rng, 2, 40), true, nothing, rand(rng, 2, 3), 2, nothing)
    CR.test_adjoint(AutoMooncake(; config = nothing), c, CR.Run(), args...)
    # A kernel longer than the series and its history.
    c = Convolution(rand(rng, 60); method = CR.FFTMethod())
    args = (rand(rng, 20), true, nothing, rand(rng, 3), 1, nothing)
    CR.test_adjoint(AutoMooncake(; config = nothing), c, CR.Run(), args...)
end

@testitem "FFT convolution gradients: Enzyme forward" tags = [:ad, :enzyme, :enzyme_forward, :compat_floor] setup = [FFTAD] begin
    using Enzyme: Enzyme
    using ADTypes: AutoEnzyme
    test_fft_gradients(
        AutoEnzyme(;
            mode = Enzyme.set_runtime_activity(Enzyme.Forward),
            function_annotation = Enzyme.Const,
        )
    )
end

# The transform's Enzyme rules against finite differences, called directly,
# since traced code does not reach them on every Julia version. They cover
# each mix of active kernel and input, batched shadows, a constant output
# buffer, an immutable kernel and runtime activity off and on.
@testitem "FFT convolution: Enzyme rules of the transform" tags = [:ad, :enzyme, :enzyme_reverse, :enzyme_forward, :compat_floor] begin
    using ComposableRecurrences, Enzyme, FFTW
    using EnzymeTestUtils: test_forward, test_reverse
    using Random: Xoshiro
    const CR = ComposableRecurrences

    # An immutable kernel, which Enzyme reverse mode passes as `Active`.
    struct Lags3 <: AbstractVector{Float64}
        t::NTuple{3, Float64}
    end
    Base.size(::Lags3) = (3,)
    Base.getindex(k::Lags3, i::Int) = k.t[i]
    Base.convert(::Type{Lags3}, v::AbstractVector) = Lags3(Tuple(v))

    f = CR._fft_convolve!
    rng = Xoshiro(4)
    m, start, T, L = 3, 2, 40, 5
    kernels = ((rand(rng, L), 1), (PerStratum(rand(rng, 2, L)), 2))
    for (k, S) in kernels, ra in (false, true)
        X, Y = rand(rng, m + T, S), zeros(T - start + 1, S)
        # On Julia 1.11 the harness's own forward call needs runtime
        # activity for a struct kernel next to a constant argument.
        fwd(consts) = ra || k isa AbstractVector || !consts
        mixes = (
            (Duplicated, Duplicated), (Const, Duplicated), (Duplicated, Const),
        )
        for (Tk, TX) in mixes
            args = (
                (copy(Y), Duplicated), (k, Tk), (X, TX),
                (m, Const), (start, Const),
            )
            fwd(Const in (Tk, TX)) &&
                test_forward(f, Duplicated, args...; runtime_activity = ra)
            test_reverse(f, Duplicated, args...; runtime_activity = ra)
        end
        batch = (
            (copy(Y), BatchDuplicated), (k, BatchDuplicated),
            (X, BatchDuplicated), (m, Const), (start, Const),
        )
        test_forward(f, BatchDuplicated, batch...; runtime_activity = ra)
        test_reverse(f, BatchDuplicated, batch...; runtime_activity = ra)
        # A constant output buffer carries no tangent. The harness cannot
        # check the reverse pass of a constant mutated return.
        fwd(true) && test_forward(
            f, Const, (copy(Y), Const), (k, Duplicated), (X, Duplicated),
            (m, Const), (start, Const); runtime_activity = ra
        )
    end
    k = Lags3((0.3, 0.5, 0.2))
    X, Y = rand(rng, m + T, 1), zeros(T - start + 1, 1)
    for ra in (false, true), TX in (Const, Duplicated)
        test_reverse(
            f, Duplicated, (copy(Y), Duplicated), (k, Active), (X, TX),
            (m, Const), (start, Const); runtime_activity = ra
        )
    end
    test_reverse(
        f, BatchDuplicated, (copy(Y), BatchDuplicated), (k, Active),
        (X, BatchDuplicated), (m, Const), (start, Const)
    )

    # An immutable per-stratum kernel, also passed as `Active`.
    struct Coefs2x3 <: AbstractMatrix{Float64}
        t::NTuple{6, Float64}
    end
    Base.size(::Coefs2x3) = (2, 3)
    Base.getindex(c::Coefs2x3, i::Int, j::Int) = c.t[i + 2 * (j - 1)]
    Base.convert(::Type{Coefs2x3}, v::AbstractMatrix) = Coefs2x3(Tuple(v))
    K = PerStratum(Coefs2x3(Tuple(rand(rng, 6))))
    X, Y = rand(rng, m + T, 2), zeros(T - start + 1, 2)
    for TX in (Const, Duplicated)
        test_reverse(
            f, Duplicated, (copy(Y), Duplicated), (K, Active), (X, TX),
            (m, Const), (start, Const); runtime_activity = true
        )
    end

    # A constant output buffer asked for a shadow gets zeros, and any other
    # annotation is refused.
    ext = Base.get_extension(CR, :ComposableRecurrencesEnzymeExt)
    @test ext._out_shadow(Const(ones(2, 2)), 1) == zeros(2, 2)
    @test ext._out_shadow(Const(ones(2, 2)), 2) == (zeros(2, 2), zeros(2, 2))
    v = rand(3)
    @test_throws ArgumentError ext._lane(MixedDuplicated(v, Ref(v)), 1)
end

@testitem "FFT convolution gradients: Mooncake forward" tags = [:ad, :mooncake, :mooncake_forward] setup = [FFTAD] begin
    using Mooncake: Mooncake
    using ADTypes: AutoMooncakeForward
    test_fft_gradients(AutoMooncakeForward())
end

# A log-likelihood over a series spanning 22 orders of magnitude: the
# default method and the transform match the direct method's gradient to a
# relative 1e-10 under the native rules.
@testsnippet WideAD begin
    using ComposableRecurrences, DifferentiationInterface, FFTW, ForwardDiff
    using ADTypes: AutoForwardDiff
    const CR = ComposableRecurrences
    function test_wide_gradients(backend)
        T, L = 1000, 300
        g = exp.(-0.05 .* (0:(L - 1)))
        w = 1.5 .+ sin.(1:T)
        within(a, b) = all(i -> abs(a[i] - b[i]) <= 1.0e-10 * abs(b[i]), eachindex(a, b))
        for x in (10.0 .^ range(-22, 0; length = T), 10.0 .^ range(0, -22; length = T))
            θ = vcat(g ./ sum(g), x)
            loss(method) = θ -> sum(
                w .* log.(Convolution(θ[1:L]; method)(view(θ, (L + 1):(L + T))))
            )
            ref = DifferentiationInterface.gradient(loss(CR.Direct()), backend, θ)
            fd = DifferentiationInterface.gradient(loss(CR.Direct()), AutoForwardDiff(), θ)
            @test isapprox(ref, fd; rtol = 1.0e-10)
            for method in (CR.Auto(), CR.FFTMethod())
                @test within(DifferentiationInterface.gradient(loss(method), backend, θ), ref)
            end
        end
        return nothing
    end
end

@testitem "Wide-range convolution gradients: ForwardDiff" tags = [:ad, :forwarddiff] setup = [WideAD] begin
    test_wide_gradients(AutoForwardDiff())
end

@testitem "Wide-range convolution gradients: Mooncake reverse" tags = [:ad, :mooncake, :mooncake_reverse] setup = [WideAD] begin
    using Mooncake: Mooncake
    using ADTypes: AutoMooncake
    test_wide_gradients(AutoMooncake(; config = nothing))
end

@testitem "Wide-range convolution gradients: Enzyme reverse" tags = [:ad, :enzyme, :enzyme_reverse, :compat_floor] setup = [WideAD] begin
    using Enzyme: Enzyme
    using ADTypes: AutoEnzyme
    test_wide_gradients(
        AutoEnzyme(;
            mode = Enzyme.set_runtime_activity(Enzyme.Reverse),
            function_annotation = Enzyme.Const,
        )
    )
end
