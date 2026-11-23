@testitem "Recurrence: include_history joins the history to the output" begin
    using ComposableRecurrences, LinearAlgebra
    CR = ComposableRecurrences
    T = 8
    R = [1.0 + 0.1 * sin(t) for t in 1:T]
    RS = [1.0 + 0.1 * sin(k + t) for k in 1:2, t in 1:T]
    pool = CR.Depletion(50.0)
    # The buffer run and the scan, a series and strata, a view history.
    θ = [0.4, 0.2, 0.3, 0.1]
    cases = (
        (Recurrence([0.6, 0.3]), R, [0.2, 0.4]),
        (Recurrence([0.6, 0.3]; modifiers = (pool,)), R, view(θ, 1:2)),
        (Recurrence([0.9]), R, [0.5]),
        (Recurrence([0.9]), R, view(θ, 2:4)),
        (Recurrence([0.6, 0.3]), RS, [0.2 0.4; 0.1 0.3]),
        (Recurrence([0.9]), RS, reshape(view(θ, 1:4), 2, 2)),
        (Recurrence([0.9]), R, Float64[]),
    )
    for (r, gain, h) in cases
        y = r(gain; history = h)
        yh = r(gain; history = h, include_history = true)
        @test yh == cat(h, y; dims = ndims(y))
        @test typeof(yh) == typeof(y)
        @test CR.NoAdjoint(r)(gain; history = h, include_history = true) ≈ yh
        # It infers, as the flag does not change the return type.
        @test (@inferred r(gain; history = h, include_history = true)) isa
            typeof(y)
    end
    # A traced and stated call: the trace takes zero columns over the
    # history, and the state is unchanged.
    r = Recurrence([0.6, 0.3]; modifiers = (pool,))
    h = [0.2, 0.4]
    out = r(R; history = h, record = (:state, :trace))
    j = r(R; history = h, record = (:state, :trace), include_history = true)
    @test j.y == vcat(h, out.y)
    @test j.state.history == out.state.history
    @test j.state.t == out.state.t
    for (a, b) in zip(j.trace.modifiers, out.trace.modifiers)
        @test a == hcat(zeros(size(b, 1), 2), b)
    end
    @test j.trace.pressure == vcat(zeros(2), out.trace.pressure)
    # A later start joins the history as given.
    @test r(R; history = h, start = 3, include_history = true) ==
        vcat(h, r(R; history = h, start = 3))
    # A resumed call has no seed to join.
    @test_throws ArgumentError r(R; state = out.state, include_history = true)
end

@testitem "Recurrence: include_history gradients against the joined output" begin
    using ComposableRecurrences, ForwardDiff, Mooncake, Enzyme
    using DifferentiationInterface, ADTypes
    CR = ComposableRecurrences
    T = 9
    w = cos.(1:(T + 2))
    backends = (
        AutoMooncake(; config = nothing),
        AutoEnzyme(; mode = set_runtime_activity(Reverse)),
        AutoEnzyme(; mode = Reverse),
    )
    # The scan and the buffer run, each with a history that is a view of
    # the parameters, as a sampled vector hands it over.
    for kernel in ([0.9], [0.6, 0.3])
        n = length(kernel)
        r = Recurrence(kernel)
        function joined(θ)
            h = view(θ, 1:n)
            y = r(1.0; history = h, add = view(θ, (n + 1):length(θ)),
                include_history = true)
            return sum(w[1:length(y)] .* y)
        end
        function by_hand(θ)
            h = θ[1:n]
            y = vcat(h, r(1.0; history = h, add = θ[(n + 1):end]))
            return sum(w[1:length(y)] .* y)
        end
        θ = vcat(0.3 .* (1:n), 0.2 .* sin.(1:T))
        ref = ForwardDiff.gradient(by_hand, θ)
        @test ForwardDiff.gradient(joined, θ) ≈ ref
        for b in backends
            @test DifferentiationInterface.gradient(joined, b, θ) ≈ ref
        end
    end
end
