# Gradients in the inputs under a threaded executor match the serial
# gradients exactly; cotangents of parameters every stratum shares are
# summed per chunk, so they match up to rounding. ForwardDiff runs the
# threaded loops. Under Enzyme and Mooncake reverse mode the native rule
# runs its forward and reverse passes threaded, and a NoAdjoint call they
# trace runs serially. Enzyme and Mooncake forward mode run serially under
# any executor.

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

    # Losses in every parameter, so the reverse pass adds into shared kernel,
    # coupling and modifier cotangents: independent strata, strata mixed by
    # a dense coupling, and a convolution.
    function shared_losses()
        rng = Xoshiro(11)
        S, T, L = 8, 30, 4
        seed = ones(S, L)
        w = rand(rng, S, T)
        split(θ, n) = (θ[1:n], reshape(θ[(n + 1):end], S, T))
        independent = function (θ)
            g, R = split(θ, L + 1)
            r = Recurrence(
                g[1:L]; modifiers = (
                    CR.Depletion(PerStratum(fill(1.0e3, S)), CR.Floor()),
                    CR.Add(g[L + 1]),
                )
            )
            return sum(w .* r(R; history = seed))
        end
        mixed = function (θ)
            g, R = split(θ, L + 1)
            K = fill(0.05, S, S) .+ g[L + 1] .* [i == j for i in 1:S, j in 1:S]
            r = Recurrence(g[1:L]; coupling = K)
            return sum(w .* r(R; history = seed))
        end
        convolution = function (θ)
            g, X = split(θ, L)
            return sum(w .* Convolution(g)(X))
        end
        θ = vcat([0.1, 0.3, 0.4, 0.2, 0.5], vec(1.0 .+ 0.05 .* rand(rng, S, T)))
        return (
            (independent, θ), (mixed, θ), (convolution, θ[[1:4; 6:end]]),
        )
    end

    # The reverse pass of each loss runs on more than one task under a
    # threaded executor, and its gradient matches the serial one.
    function test_reverse_split(backend)
        ex = CR.Threaded(; min_work = 0, ntasks = 3)
        for (loss, θ) in shared_losses()
            ref = DifferentiationInterface.gradient(loss, AutoForwardDiff(), θ)
            gs = DifferentiationInterface.gradient(loss, backend, θ)
            calls, splits = CR._PULLBACK_CALLS[], CR._SPLIT_BLOCKS[]
            g = with(CR.EXECUTOR => ex) do
                DifferentiationInterface.gradient(loss, backend, θ)
            end
            @test CR._PULLBACK_CALLS[] > calls
            @test CR._SPLIT_BLOCKS[] > splits
            @test g ≈ gs
            @test g ≈ ref
        end
        return nothing
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

@testitem "Executor gradients: ForwardDiff" tags = [:ad, :executor, :forwarddiff] setup = [ExecutorAD] begin
    test_executor_gradients(AutoForwardDiff())
end

@testitem "Executor gradients: ReverseDiff" tags = [:ad, :executor, :reversediff] setup = [ExecutorAD] begin
    using ReverseDiff: ReverseDiff
    using ADTypes: AutoReverseDiff
    test_executor_gradients(AutoReverseDiff())
end

@testitem "Executor gradients: Enzyme reverse" tags = [:ad, :executor, :enzyme, :enzyme_reverse] setup = [ExecutorAD] begin
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

@testitem "Executor gradients: Mooncake reverse" tags = [:ad, :executor, :mooncake, :mooncake_reverse] setup = [ExecutorAD] begin
    using Mooncake: Mooncake
    using ADTypes: AutoMooncake
    test_executor_gradients(AutoMooncake(; config = nothing))
end

@testitem "Executor gradients: Enzyme forward" tags = [:ad, :executor, :enzyme, :enzyme_forward] setup = [ExecutorAD] begin
    using Enzyme: Enzyme
    using ADTypes: AutoEnzyme
    test_executor_gradients(
        AutoEnzyme(;
            mode = Enzyme.set_runtime_activity(Enzyme.Forward),
            function_annotation = Enzyme.Const,
        )
    )
end

@testitem "Executor gradients: Mooncake forward" tags = [:ad, :executor, :mooncake, :mooncake_forward] setup = [ExecutorAD] begin
    using Mooncake: Mooncake
    using ADTypes: AutoMooncakeForward
    test_executor_gradients(AutoMooncakeForward())
end

@testitem "Executor gradients: Enzyme reverse splits the reverse pass" tags = [:ad, :executor, :enzyme, :enzyme_reverse] setup = [ExecutorAD] begin
    using Enzyme: Enzyme
    using ADTypes: AutoEnzyme
    test_reverse_split(
        AutoEnzyme(;
            mode = Enzyme.set_runtime_activity(Enzyme.Reverse),
            function_annotation = Enzyme.Const,
        )
    )
end

@testitem "Executor gradients: Mooncake reverse splits the reverse pass" tags = [:ad, :executor, :mooncake, :mooncake_reverse] setup = [ExecutorAD] begin
    using Mooncake: Mooncake
    using ADTypes: AutoMooncake
    test_reverse_split(AutoMooncake(; config = nothing))
end
