# Gradients under a threaded executor match the serial gradients exactly.
# ForwardDiff runs the threaded loops. Under Enzyme and Mooncake reverse
# mode the native rule runs its forward pass threaded and its reverse pass
# serially, and a NoAdjoint call they trace runs serially. Enzyme and
# Mooncake forward mode run serially under any executor.

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
        # Vector steps that read every stratum: a protected pool and
        # grouped totals.
        doses = TimeVarying(PerStratum(fill(5.0, S, T)))
        rv = Recurrence(
            g; modifiers = (
                CR.Depletion(
                    1.0e3; removals = doses, protected = CR.Protected(0.3)
                ),
            )
        )
        totals = TimeVarying(PerStratum(fill(8.0, 2, T)))
        ra = Recurrence(g; modifiers = (CR.Allocate([1:3, 4:6], totals),))
        rva = Recurrence(
            g; modifiers = (
                CR.Depletion(
                    1.0e3; removals = doses, protected = CR.Protected(0.3)
                ),
                CR.Allocate([1:3, 4:6], totals),
            )
        )
        losses = Any[]
        for op in (r, rc, c, rv, ra, rva), route in (op, CR.NoAdjoint(op))
            push!(
                losses, op isa Convolution ?
                    θ -> sum(w .* route(reshape(θ, S, T))) :
                    θ -> sum(w .* route(reshape(θ, S, T); history = seed))
            )
        end
        return Tuple(losses), vec(1.0 .+ 0.05 .* rand(rng, S, T))
    end

    # The gradient under a threaded executor is the serial gradient on the
    # same backend, and matches the serial ForwardDiff gradient.
    function test_executor_gradients(backend)
        losses, θ = executor_losses()
        for ex in (CR.Threaded(; min_work = 0), CR.Threaded(; min_work = 0, ntasks = 3))
            for loss in losses
                ref = DifferentiationInterface.gradient(loss, AutoForwardDiff(), θ)
                gs = DifferentiationInterface.gradient(loss, backend, θ)
                g = with(CR.EXECUTOR => ex) do
                    DifferentiationInterface.gradient(loss, backend, θ)
                end
                @test g == gs
                @test g ≈ ref
            end
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
    # Runtime activity for the constant history; the losses close
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

@testitem "Executor gradients: Enzyme forward" tags = [:ad, :enzyme, :enzyme_forward] setup = [ExecutorAD] begin
    using Enzyme: Enzyme
    using ADTypes: AutoEnzyme
    test_executor_gradients(
        AutoEnzyme(;
            mode = Enzyme.set_runtime_activity(Enzyme.Forward),
            function_annotation = Enzyme.Const,
        )
    )
end

@testitem "Executor gradients: Mooncake forward" tags = [:ad, :mooncake, :mooncake_forward] setup = [ExecutorAD] begin
    using Mooncake: Mooncake
    using ADTypes: AutoMooncakeForward
    test_executor_gradients(AutoMooncakeForward())
end
