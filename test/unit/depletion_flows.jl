# Depletion with flows between its pools: waning protection and rate
# removals against naive loops, removals as the first count flow, the
# pullbacks against a local Jacobian, and the checks.

@testitem "Depletion flows: waning protection against a naive loop" setup = [FlowChecks] begin
    using ComposableRecurrences, ForwardDiff
    CR = ComposableRecurrences
    (; flow_step, forms) = FlowChecks
    g = [0.5, 0.3, 0.2]
    R = [2.0 + 0.2 * sin(k + t) for k in 1:2, t in 1:6]
    h = [2.0 3.0 4.0; 1.0 1.0 2.0]
    N, σ = 200.0, 0.3
    doses = [3.0 4.0 5.0 5.0 6.0 6.0; 1.0 2.0 2.0 3.0 3.0 300.0]
    # The draw from both pools, then waning, then the doses capped by what
    # is left.
    function naive(R, ω)
        S, T = size(R)
        L = size(h, 2)
        Tp = promote_type(eltype(R), typeof(ω(1, 1)))
        Y = zeros(Tp, S, L + T)
        Y[:, 1:L] .= h
        u, w = fill(Tp(N), S), zeros(Tp, S)
        for t in 1:T, k in 1:S
            v = R[k, t] * sum(g[i] * Y[k, L + t - i] for i in eachindex(g))
            P = u[k] + σ * w[k]
            y = P * (1 - exp(-v / N))
            u[k] -= y * u[k] / P
            w[k] -= y * σ * w[k] / P
            u[k], w[k] = flow_step(
                [u[k], w[k]], Dict((2, 1) => ω(k, t)), Dict(),
                [(1, 2) => doses[k, t]]
            )
            Y[k, L + t] = y
        end
        return Y[:, (L + 1):end]
    end
    W = reshape(range(0.2, 1.4; length = 12), 2, 6)
    for (build, at, θ) in values(forms)
        function run(θ, R)
            d = CR.Depletion(
                N; removals = TimeVarying(PerStratum(doses)),
                protected = CR.Protected(σ), flows = (CR.Flow(2 => 1, build(θ)),)
            )
            return Recurrence(g; modifiers = (d,))(R; history = h)
        end
        ref(θ, R) = naive(R, (k, t) -> at(θ, k, t))
        @test run(θ, R) ≈ ref(θ, R)
        @test ForwardDiff.gradient(θ -> sum(W .* run(θ, R)), θ) ≈
            ForwardDiff.gradient(θ -> sum(W .* ref(θ, R)), θ)
        @test ForwardDiff.gradient(R -> sum(W .* run(θ, R)), R) ≈
            ForwardDiff.gradient(R -> sum(W .* ref(θ, R)), R)
    end
    # Removals are the first count flow, and no waning is the depletion
    # without flows.
    removals = TimeVarying(PerStratum(doses))
    d = CR.Depletion(N; removals, protected = CR.Protected(σ))
    explicit = CR.Depletion(
        N; protected = CR.Protected(σ), flows = [CR.Flow(1 => 2, CR.Amount(removals))]
    )
    still = CR.Depletion(
        N; removals, protected = CR.Protected(σ), flows = CR.Flow(2 => 1, 0.0)
    )
    y = Recurrence(g; modifiers = (d,))(R; history = h)
    @test Recurrence(g; modifiers = (explicit,))(R; history = h) == y
    @test Recurrence(g; modifiers = (still,))(R; history = h) ≈ y
end

@testitem "Depletion flows: susceptibles leaving at a rate" setup = [FlowChecks] begin
    using ComposableRecurrences, ForwardDiff
    CR = ComposableRecurrences
    g, h, N = [0.3, 0.5, 0.2], [2.0, 3.0, 4.0], 500.0
    R = fill(2.2, 12)
    function naive(R, μ)
        T, L = length(R), length(h)
        Tp = promote_type(eltype(R), typeof(μ))
        y, s = vcat(Tp.(h), zeros(Tp, T)), Tp(N)
        for t in 1:T
            v = R[t] * sum(g[i] * y[L + t - i] for i in eachindex(g))
            y[L + t] = s * (1 - exp(-v / N))
            s = (s - y[L + t]) * exp(-μ)
        end
        return y[(L + 1):end]
    end
    run(R, μ) = Recurrence(g; modifiers = (CR.Depletion(N; flows = CR.Flow(1 => 0, μ)),))(
        R; history = h
    )
    @test run(R, 0.05) ≈ naive(R, 0.05)
    @test ForwardDiff.derivative(μ -> sum(run(R, μ)), 0.05) ≈
        ForwardDiff.derivative(μ -> sum(naive(R, μ)), 0.05)
    @test ForwardDiff.gradient(R -> sum(run(R, 0.05)), R) ≈
        ForwardDiff.gradient(R -> sum(naive(R, 0.05)), R)
    @test CR.ispointwise(CR.Depletion(N; flows = CR.Flow(1 => 0, 0.05)))
end

@testitem "Depletion flows: pullbacks against a local Jacobian" setup = [FlowChecks] begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    (; check_pullback) = FlowChecks
    # Waning, a share leaving the protected pool and removals, per stratum.
    function protected(θ)
        return CR.Depletion(
            PerStratum(θ[1:2]); heterogeneity = θ[3],
            protected = CR.Protected(PerStratum(θ[4:5])),
            flows = (
                CR.Flow(1 => 2, CR.Amount(θ[6])), CR.Flow(2 => 1, PerStratum(θ[7:8])),
                CR.Flow(2 => 0, CR.Linear(TimeVarying(θ[9:10]))),
            )
        )
    end
    for θ in (
            [100.0, 80.0, 1.0, 0.3, 0.5, 2.0, 0.1, 0.2, 0.01, 0.02],
            [100.0, 80.0, 1.4, 0.3, 0.5, 70.0, 0.0, 1.0e-9, 0.0, 0.05],
        ), t in (1, 2)
        # The protected pool's mirror order: N, heterogeneity, the flows'
        # parameters, then σ and its pool0.
        c = check_pullback(
            x -> protected(vcat(x[1:3], x[end - 2:end - 1], x[4:(end - 3)])),
            vcat(θ[1:3], θ[6:10], θ[4:5], 0.0), [3.0, 1.5],
            [60.0, 50.0, 20.0, 10.0], t
        )
        @test c.v && c.s && c.θ
    end
    # A rate and a count out of the one pool, pointwise.
    pointwise(θ) = CR.Depletion(
        θ[1]; heterogeneity = θ[2],
        flows = (CR.Flow(1 => 0, θ[3]), CR.Flow(1 => 0, CR.Amount(θ[4])))
    )
    for θ in ([100.0, 1.0, 0.05, 2.0], [100.0, 1.2, 0.0, 70.0])
        c = check_pullback(pointwise, θ, [3.0, 1.5], [60.0, 50.0], 1)
        @test c.v && c.s && c.θ
    end
end

@testitem "Depletion flows: the rule matches ForwardDiff" begin
    using ComposableRecurrences, ForwardDiff, Mooncake
    using DifferentiationInterface: gradient, AutoMooncake
    CR = ComposableRecurrences
    g, h = [0.3, 0.5, 0.2], [5.0 4.0; 3.0 2.0]
    function loss(θ)
        d = CR.Depletion(
            PerStratum([1000.0, 800.0]);
            removals = TimeVarying(PerStratum(reshape(θ[1:12], 2, 6))),
            protected = CR.Protected(θ[13]),
            flows = CR.Flow(2 => 1, TimeVarying(θ[14:19]))
        )
        r = Recurrence(g; coupling = [0.9 0.1; 0.2 0.8], modifiers = (d,))
        return sum(abs2, r(reshape(θ[20:31], 2, 6); history = h))
    end
    θ = [fill(4.0, 12); 0.3; fill(0.05, 6); fill(2.0, 12)]
    @test CR.uses_adjoint(
        Recurrence(g; modifiers = (CR.Depletion(1.0; flows = CR.Flow(1 => 0, 0.1)),)),
        CR.Run()
    )
    @test gradient(loss, AutoMooncake(), θ) ≈ ForwardDiff.gradient(loss, θ)
end

@testitem "Depletion flows: check their options" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    @test_throws "name compartment 2, but the depletion has 1 pool" CR.Depletion(
        100.0; flows = CR.Flow(2 => 1, 0.1)
    )
    @test_throws "flows holds Flows, got 0.1" CR.Depletion(100.0; flows = (0.1,))
    @test_throws "a Flow, or a tuple or vector of Flows, got 0.1" CR.Depletion(
        100.0; flows = 0.1
    )
    @test_throws ArgumentError CR.Depletion(100.0; removals = [1.0, 2.0])
    d = CR.Depletion(100.0; flows = CR.Flow(1 => 0, PerStratum([0.1, 0.2, 0.3])))
    r = Recurrence([0.5]; modifiers = (d,))
    @test_throws "r has 3 strata, expected 2" r(ones(2, 3); history = ones(2, 1))
end
