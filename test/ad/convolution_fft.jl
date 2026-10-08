# Gradients of an FFTMethod() convolution match ForwardDiff, which runs the
# direct method. Under Enzyme and Mooncake reverse mode the native rule
# runs the transform both ways; forward mode and NoAdjoint calls they trace
# take the direct method.

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

@testitem "FFT convolution gradients: Enzyme reverse" tags = [:ad, :enzyme, :enzyme_reverse] setup = [FFTAD] begin
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

@testitem "FFT convolution gradients: Enzyme forward" tags = [:ad, :enzyme, :enzyme_forward] setup = [FFTAD] begin
    using Enzyme: Enzyme
    using ADTypes: AutoEnzyme
    test_fft_gradients(
        AutoEnzyme(;
            mode = Enzyme.set_runtime_activity(Enzyme.Forward),
            function_annotation = Enzyme.Const,
        )
    )
end

@testitem "FFT convolution gradients: Mooncake forward" tags = [:ad, :mooncake, :mooncake_forward] setup = [FFTAD] begin
    using Mooncake: Mooncake
    using ADTypes: AutoMooncakeForward
    test_fft_gradients(AutoMooncakeForward())
end
