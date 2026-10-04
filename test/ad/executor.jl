# Gradients under a threaded executor match the serial ForwardDiff gradient.
# ForwardDiff runs the threaded loops; Enzyme and Mooncake reverse mode run a
# call they differentiate serially whatever executor is set.

@testsnippet ExecutorAD begin
    using ComposableRecurrences, DifferentiationInterface, ForwardDiff
    using ADTypes: AutoForwardDiff
    using Base.ScopedValues: with
    using Random: Xoshiro
    const CR = ComposableRecurrences

    function executor_losses()
        rng = Xoshiro(7)
        S, T, L = 6, 30, 4
        g = [0.1, 0.3, 0.4, 0.2]
        seed = ones(S, L)
        w = rand(rng, S, T)
        r = Recurrence(
            PerStratum(repeat(g', S));
            modifiers = (CR.Depletion(1.0e4; pool0 = 1.0e4),)
        )
        rc = Recurrence(g; coupling = fill(1 / S, S, S))
        c = Convolution(g)
        losses = (
            θ -> sum(w .* r(reshape(θ, S, T); history = seed)),
            θ -> sum(w .* rc(reshape(θ, S, T); history = seed)),
            θ -> sum(w .* c(reshape(θ, S, T))),
        )
        return losses, vec(1.0 .+ 0.05 .* rand(rng, S, T))
    end

    function test_executor_gradients(backend)
        losses, θ = executor_losses()
        ex = CR.Threaded(; min_work = 0)
        for loss in losses
            ref = DifferentiationInterface.gradient(loss, AutoForwardDiff(), θ)
            g = with(CR.EXECUTOR => ex) do
                DifferentiationInterface.gradient(loss, backend, θ)
            end
            @test g ≈ ref
        end
        return nothing
    end
end

@testitem "Executor gradients: ForwardDiff" tags = [:ad, :forwarddiff] setup = [ExecutorAD] begin
    test_executor_gradients(AutoForwardDiff())
end

@testitem "Executor gradients: Enzyme reverse" tags = [:ad, :enzyme, :enzyme_reverse] setup = [ExecutorAD] begin
    using Enzyme: Enzyme
    using ADTypes: AutoEnzyme
    # Runtime activity for the constant history (see #64); the losses close
    # over constant operators.
    test_executor_gradients(
        AutoEnzyme(;
            mode = Enzyme.set_runtime_activity(Enzyme.Reverse),
            function_annotation = Enzyme.Const,
        )
    )
end

@testitem "Executor gradients: Mooncake reverse" tags = [:ad, :mooncake, :mooncake_reverse] setup = [ExecutorAD] begin
    using Mooncake: Mooncake
    using ADTypes: AutoMooncake
    test_executor_gradients(AutoMooncake(; config = nothing))
end
