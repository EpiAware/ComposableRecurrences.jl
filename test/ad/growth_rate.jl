# `growth_rate` and `reproduction_number` on each backend against a
# ForwardDiff Jacobian: the Newton iteration carries no derivative there, and
# the step from its root carries all of it, lags without mass included.

@testitem "growth_rate and reproduction_number: each backend matches ForwardDiff" tags = [:ad, :forwarddiff, :reversediff, :mooncake, :mooncake_reverse, :mooncake_forward, :enzyme, :enzyme_reverse, :enzyme_forward] setup = [JobBackends] begin
    using ComposableRecurrences: ComposableRecurrences as CR
    using ADTypes: AutoForwardDiff, AutoReverseDiff, AutoMooncake,
        AutoMooncakeForward, AutoEnzyme
    using DifferentiationInterface: jacobian
    import Enzyme, ForwardDiff, Mooncake, ReverseDiff
    function f(θ)
        g = view(θ, 3:length(θ))
        return [CR.growth_rate(exp(θ[1]), g), CR.reproduction_number(θ[2], g)]
    end
    backends = job_backends(
        :reversediff => AutoReverseDiff(),
        :mooncake_reverse => AutoMooncake(; config = nothing),
        :mooncake_forward => AutoMooncakeForward(; config = nothing),
        :enzyme_reverse => AutoEnzyme(;
            mode = Enzyme.set_runtime_activity(Enzyme.Reverse),
            function_annotation = Enzyme.Const
        ),
        :enzyme_forward => AutoEnzyme(;
            mode = Enzyme.set_runtime_activity(Enzyme.Forward),
            function_annotation = Enzyme.Const
        ),
    )
    for θ in ([log(1.5); 0.1; 0.2; 0.5; 0.3], [log(0.7); -0.2; 0.0; 0.6; 0.4; 0.0])
        ref = jacobian(f, AutoForwardDiff(), θ)
        @test all(isfinite, ref)
        @test all(!iszero, ref[1, 3:end])
        for backend in backends
            @test jacobian(f, backend, θ) ≈ ref
        end
    end
end
