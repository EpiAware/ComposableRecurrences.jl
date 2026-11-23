@testitem "Recurrence: a one-lag scan against the buffer run" begin
    using ComposableRecurrences, LinearAlgebra
    CR = ComposableRecurrences
    # A second lag of zero keeps the buffer run with the same values.
    buffer(k, C) = Recurrence([k, 0.0]; coupling = C)
    T = 9
    γ = collect(range(0.8, 1.2; length = T))
    G = reshape(collect(1.0:27.0), 3, T) ./ 20
    inputs = (
        (1.0, collect(0.1:0.1:0.9), [0.3]),
        (γ, sin.(1:T), [0.1, 0.3]),
        (0.9, nothing, [0.5]),
        (true, cos.(1:T), [0.2]),
        (1.1, sin.(1:T), Float64[]),
        (G, cos.((1:3) .+ (1:T)'), [0.1 0.2; 0.3 0.4; 0.5 0.6]),
        (γ, 0.2, reshape([0.4, -0.2], 2, 1)),
        (1.0, sin.((1:2) .* (1:T)'), zeros(2, 0)),
    )
    for (k, C) in ((1.0, I), (0.7, I), (0.7, 2.0I)), (g, a, h) in inputs
        r = Recurrence([k]; coupling = C)
        y = r(g; history = h, add = a, stop = T)
        ref = buffer(k, C)(g; history = h, add = a, stop = T)
        @test y ≈ ref
        @test typeof(y) == typeof(ref)
        @test CR.NoAdjoint(r)(g; history = h, add = a, stop = T) ≈ ref
    end
    # A later start reads the inputs at absolute time, and a resumed call
    # continues the scan.
    r = Recurrence([0.8])
    a = sin.(1:T)
    @test r(γ; history = [0.4], add = a, start = 4) ≈
        buffer(0.8, I)(γ; history = [0.4], add = a, start = 4)
    fit = r(γ; history = [0.4], add = a, stop = 5, record = (:state,))
    @test vcat(fit.y, r(γ; state = fit.state, add = a)) ≈
        r(γ; history = [0.4], add = a)
    # A view history, as a sampled vector reaches it.
    θ = [0.1, 0.2, 0.3]
    @test r(1.0; history = view(θ, 2:2), add = a) ≈
        r(1.0; history = [0.2], add = a)
    # The return type infers.
    @test (@inferred r(1.0; history = [0.1], add = a)) isa Vector{Float64}
    y = @inferred r(1.0; history = ones(2, 1), add = ones(2, T))
    @test y isa Matrix{Float64}
end

@testitem "Recurrence: the one-lag scan's errors match the buffer run's" begin
    using ComposableRecurrences
    error_type(f) = try
        f()
        nothing
    catch e
        typeof(e)
    end
    calls = (
        r -> r(1.0; history = [0.1]),
        r -> r(ones(3, 5); history = ones(2, 1)),
        r -> r(1.0; history = [0.1], add = ones(4), stop = 6),
        r -> r(1.0; history = [0.1], add = ones(4), start = 0),
    )
    for call in calls
        E = error_type(() -> call(Recurrence([1.0, 0.0])))
        @test E !== nothing
        @test error_type(() -> call(Recurrence([1.0]))) === E
    end
end

@testitem "Recurrence: the one-lag scan's pullback against a Jacobian" begin
    using ComposableRecurrences, ForwardDiff, LinearAlgebra
    CR = ComposableRecurrences
    T = 7
    w = cos.(1:(2 * T))
    # Kernel, coupling scale, gain, seed and add input, through the rule's
    # pullback against ForwardDiff of the buffer run.
    function args(θ, S)
        k, λ, n = θ[1], θ[2], S * T
        g, h, a = θ[3:(2 + n)], θ[(3 + n):(2 + n + S)], θ[(3 + n + S):end]
        S == 1 && return k, λ, g, h, a
        return k, λ, reshape(g, S, T), reshape(h, S, 1), reshape(a, S, T)
    end
    for S in (1, 2)
        n = S * T
        θ = vcat(0.8, 1.2, 1 .+ 0.1 .* sin.(1:n), 0.3 .* (1:S), cos.(1:n))
        loss(y) = sum(w[1:length(y)] .* vec(y))
        function ref(θ)
            k, λ, g, h, a = args(θ, S)
            r = CR.NoAdjoint(Recurrence([k, 0.0]; coupling = λ * I))
            return loss(r(g; history = h, add = a))
        end
        k, λ, g, h, a = args(θ, S)
        op = CR._Scan([k], λ * I)
        y, cache = CR._run_forward(op, g, a, h, 1, T)
        ȳ = reshape(w[1:length(y)], size(y))
        grads = (;
            y = ȳ, piece = (; kernel = [0.0], coupling = (; λ = Ref(0.0))),
            args = (zero(g), zero(a), zero(h), nothing, nothing),
        )
        CR.pullback!(grads, op, CR.Run(), cache)
        J = ForwardDiff.gradient(ref, θ)
        @test grads.piece.kernel[1] ≈ J[1]
        @test grads.piece.coupling.λ[] ≈ J[2]
        @test vec(grads.args[1]) ≈ J[3:(2 + n)]
        @test vec(grads.args[3]) ≈ J[(3 + n):(2 + n + S)]
        @test vec(grads.args[2]) ≈ J[(3 + n + S):end]
    end
    # A scalar gain and add input take the sums of their slots.
    op = CR._Scan([0.9], 1.0I)
    h = [0.4]
    y, cache = CR._run_forward(op, 1.1, 0.3, h, 1, T)
    grads = (;
        y = ones(T), piece = (; kernel = nothing, coupling = nothing),
        args = (Ref(0.0), Ref(0.0), zero(h), nothing, nothing),
    )
    CR.pullback!(grads, op, CR.Run(), cache)
    r = CR.NoAdjoint(Recurrence([0.9, 0.0]))
    f(x) = sum(r(x[1]; history = x[2:2], add = x[3], stop = T))
    J = ForwardDiff.gradient(f, [1.1, 0.4, 0.3])
    @test grads.args[1][] ≈ J[1]
    @test grads.args[3][1] ≈ J[2]
    @test grads.args[2][] ≈ J[3]
end

@testitem "Recurrence: the one-lag scan's Enzyme rule" begin
    using ComposableRecurrences, Enzyme, ForwardDiff, LinearAlgebra
    CR = ComposableRecurrences
    # Kernel, gain, seed and add input, odd and even lengths, one and two
    # strata, with and without runtime activity, against the buffer run.
    function loss(θ, T, S, wrap, lags)
        k, n = θ[1], S * T
        g, h, a = θ[2:(1 + n)], θ[(2 + n):(1 + n + S)], θ[(2 + n + S):end]
        if S > 1
            g, h, a = reshape(g, S, T), reshape(h, S, 1), reshape(a, S, T)
        end
        r = wrap(Recurrence(vcat(k, zeros(lags - 1)); coupling = 1.5I))
        y = r(g; history = h, add = a)
        return sum(abs2, y) + sum(sin, y)
    end
    modes = (Reverse, set_runtime_activity(Reverse))
    for T in (6, 7), S in (1, 2)
        n = S * T
        θ = vcat(0.8, 1 .+ 0.1 .* sin.(1:n), 0.3 .* (1:S), cos.(1:n))
        ref = ForwardDiff.gradient(θ -> loss(θ, T, S, CR.NoAdjoint, 2), θ)
        for mode in modes, wrap in (identity, CR.NoAdjoint)
            n0 = CR._PULLBACK_CALLS[]
            g = Enzyme.gradient(mode, θ -> loss(θ, T, S, wrap, 1), θ)[1]
            @test g ≈ ref
            # The rule runs, and `NoAdjoint` differentiates the loop.
            @test (CR._PULLBACK_CALLS[] > n0) == (wrap === identity)
        end
    end
end
