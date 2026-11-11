# The Mooncake rule for a kernel's movement under `Redistribute`, checked
# against ForwardDiff and Mooncake's own rule tester.

@testmodule MovementReference begin
    using ComposableRecurrences, ForwardDiff

    _tag(::Type{V}) where {V} = ForwardDiff.Tag(ComposableRecurrences._run_forward, V)
    _chunk(x) = ForwardDiff.Chunk{min(8, length(x))}()

    function gradient(f, x)
        cfg = ForwardDiff.GradientConfig(f, x, _chunk(x), _tag(eltype(x)))
        return ForwardDiff.gradient(f, x, cfg, Val(false))
    end
    function jacobian(f, x)
        cfg = ForwardDiff.JacobianConfig(f, x, _chunk(x), _tag(eltype(x)))
        return ForwardDiff.jacobian(f, x, cfg, Val(false))
    end
    function derivative(f, x::Real)
        T = typeof(_tag(typeof(x)))
        return ForwardDiff.extract_derivative(T, f(ForwardDiff.Dual{T}(x, one(x))))
    end
end

@testitem "Redistribute: the Mooncake rule for a kernel's movement" tags = [:ad, :mooncake, :mooncake_reverse] setup = [MovementReference] begin
    using ComposableRecurrences, Mooncake
    using Random: Xoshiro
    CR = ComposableRecurrences
    K = [0.0 0.2 0.1; 0.3 0.0 0.2; 0.1 0.4 0.0]
    M̄ = reshape(collect(1.0:9.0), 3, 3) ./ 9
    # One intensity, one per origin as `Redistribute(K, ε)` passes it, and a
    # vector of one, which the movement broadcasts over every origin.
    for E in (0.3, [0.2 0.5 0.1], fill(0.4, 1, 1))
        f = CR._movement
        JK = MovementReference.jacobian(K -> f(K, E), K)
        cache = Mooncake.prepare_pullback_cache(f, K, E)
        _, (_, K̄, Ē) = Mooncake.value_and_pullback!!(cache, M̄, f, K, E)
        @test vec(K̄) ≈ JK' * vec(M̄)
        if E isa Real
            @test Ē ≈ sum(MovementReference.derivative(e -> vec(f(K, e)), E) .* vec(M̄))
        else
            @test vec(Ē) ≈ MovementReference.jacobian(e -> f(K, e), E)' * vec(M̄)
        end
        Mooncake.TestUtils.test_rule(
            Xoshiro(1), f, K, E;
            is_primitive = true, perf_flag = :none, mode = Mooncake.ReverseMode
        )
    end
    # A kernel and intensities read from a parameter vector, as a model hands
    # them over: the row of intensities is then a reshape of a view.
    θ = [vec(K); 0.2; 0.5; 0.1]
    split(θ) = CR._movement(reshape(view(θ, 1:9), 3, 3), permutedims(view(θ, 10:12)))
    J = MovementReference.jacobian(split, θ)
    cache = Mooncake.prepare_pullback_cache(split, θ)
    _, (_, θ̄) = Mooncake.value_and_pullback!!(cache, M̄, split, θ)
    @test θ̄ ≈ J' * vec(M̄)
    # The same broadcast through a recurrence's loss.
    loss(θ) = sum(
        Recurrence([0.5, 0.3]; modifiers = (CR.Redistribute(K, θ[1:1]),))(
            [1.1 1.2 1.3; 0.9 1.0 1.1; 1.2 1.1 1.0]; history = ones(3, 2)
        )
    )
    cache = Mooncake.prepare_gradient_cache(loss, [0.3])
    _, (_, θ̄) = Mooncake.value_and_gradient!!(cache, loss, [0.3])
    @test θ̄ ≈ MovementReference.gradient(loss, [0.3])
end
