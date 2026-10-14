# A pool with flows between its stocks: waning protection and rate
# removals against naive loops, removals as the first count flow, the
# pullbacks against a local Jacobian, and the checks. Gradients through the
# rules on every backend, with derived removals and a derived waning rate,
# are in the AD registry's waning scenario.

@testitem "Pool flows: waning against a naive loop" setup = [FlowChecks] begin
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
    # The most general rate form and a derived one; the flows tests cover
    # every form.
    for (build, at, θ) in (forms.groups_time, forms.derived)
        function run(θ, R)
            d = CR.Pool(
                N; stocks = (:S, :V), draw = (:S => 1, :V => σ) => CR.Hazard(),
                flows = (
                    CR.Flow(1 => 2, TimeVarying(PerStratum(doses)); form = CR.Truncate()),
                    CR.Flow(2 => 1, build(θ)),
                )
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
    d = CR.Pool(
        N; stocks = (:S, :V), draw = (:S => 1, :V => σ) => CR.Hazard(),
        flows = (CR.Flow(1 => 2, removals; form = CR.Truncate()),)
    )
    explicit = CR.Pool(
        N; stocks = (:S, :V), draw = (:S => 1, :V => σ) => CR.Hazard(),
        flows = (CR.Flow(1 => 2, removals; form = CR.Truncate()),)
    )
    still = CR.Pool(
        N; stocks = (:S, :V), draw = (:S => 1, :V => σ) => CR.Hazard(),
        flows = (CR.Flow(1 => 2, removals; form = CR.Truncate()), CR.Flow(2 => 1, 0.0))
    )
    y = Recurrence(g; modifiers = (d,))(R; history = h)
    @test Recurrence(g; modifiers = (explicit,))(R; history = h) == y
    @test Recurrence(g; modifiers = (still,))(R; history = h) ≈ y
end

@testitem "Pool flows: susceptibles leaving at a rate or in counts" begin
    using ComposableRecurrences, ForwardDiff
    CR = ComposableRecurrences
    g, h, N = [0.3, 0.5, 0.2], [2.0, 3.0, 4.0], 500.0
    R = fill(2.2, 12)
    # The draw, then a rate `μ` out of the pool, then the removals `r`
    # capped by what is left.
    function naive(R, μ, r)
        T, L = length(R), length(h)
        Tp = promote_type(eltype(R), typeof(μ), typeof(r))
        y, s = vcat(Tp.(h), zeros(Tp, T)), Tp(N)
        for t in 1:T
            v = R[t] * sum(g[i] * y[L + t - i] for i in eachindex(g))
            y[L + t] = s * (1 - exp(-v / N))
            s = (s - y[L + t]) * exp(-μ)
            s -= min(r, max(s, zero(s)))
        end
        return y[(L + 1):end]
    end
    run(R, μ) = Recurrence(g; modifiers = (CR.Pool(N; flows = (CR.Flow(1 => 0, μ),)),))(
        R; history = h
    )
    @test run(R, 0.05) ≈ naive(R, 0.05, 0.0)
    @test ForwardDiff.derivative(μ -> sum(run(R, μ)), 0.05) ≈
        ForwardDiff.derivative(μ -> sum(naive(R, μ, 0.0)), 0.05)
    @test ForwardDiff.gradient(R -> sum(run(R, 0.05)), R) ≈
        ForwardDiff.gradient(R -> sum(naive(R, 0.05, 0.0)), R)
    d = CR.Pool(N; flows = (CR.Flow(1 => 0, 0.05),))
    @test CR.ispointwise(d)
    @test CR.uses_adjoint(Recurrence(g; modifiers = (d,)), CR.Run())
    # Removals of any parameter form, a Derived one included, are the first
    # count flow's count.
    removed(r) = Recurrence(g; modifiers = (CR.Depletion(N; removals = r),))(
        R; history = h
    )
    @test removed(3.0) ≈ naive(R, 0.0, 3.0)
    @test removed(2 * Derived(identity, 1.5)) ≈ naive(R, 0.0, 3.0)
    @test ForwardDiff.derivative(r -> sum(removed(r)), 3.0) ≈
        ForwardDiff.derivative(r -> sum(naive(R, 0.0, r)), 3.0)
end

@testitem "Pool flows: pullbacks against a local Jacobian" setup = [ModifierChecks] begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    (; check_pullback) = ModifierChecks
    # Each builder reads its parameters in the pool's mirror order: N,
    # heterogeneity, the protected stock's start, its weight, then the flows'
    # parameters in order. `a` is the count each flow set carries and `α`
    # the heterogeneity.
    flow_sets = (
        # Waning, a share leaving the protected pool and a count into it.
        (
            x -> CR.Pool(
                PerStratum(x[1:2]); stocks = (:S, :V), initial = (nothing, x[4]),
                draw = (:S => 1, :V => PerStratum(x[5:6])) => CR.Hazard(),
                heterogeneity = x[3],
                flows = (
                    CR.Flow(1 => 2, x[7]; form = CR.Truncate()),
                    CR.Flow(2 => 1, PerStratum(x[8:9])),
                    CR.Flow(2 => 0, TimeVarying(x[10:11]); form = CR.Share()),
                )
            ),
            (a, α) -> [100.0, 80.0, α, 0.0, 0.3, 0.5, a, 0.1, 1.0e-9, 0.0, 0.05],
        ),
        # A rate out of the pool, waning and a count into the protected pool.
        (
            x -> CR.Pool(
                PerStratum(x[1:2]); stocks = (:S, :V), initial = (nothing, x[4]),
                draw = (:S => 1, :V => x[5]) => CR.Hazard(), heterogeneity = x[3],
                flows = (
                    CR.Flow(1 => 0, x[6]),
                    CR.Flow(2 => 1, x[7]),
                    CR.Flow(1 => 2, x[8]; form = CR.Truncate()),
                )
            ),
            (a, α) -> [100.0, 80.0, α, 0.0, 0.3, 0.02, 0.1, a],
        ),
        # Removals alone, and a single count out of the system.
        (
            x -> CR.Pool(
                x[1]; stocks = (:S, :V), initial = (nothing, x[3]),
                draw = (:S => 1, :V => x[4]) => CR.Hazard(), heterogeneity = x[2],
                flows = (CR.Flow(1 => 2, x[5]; form = CR.Truncate()),)
            ),
            (a, α) -> [100.0, α, 0.0, 0.3, a],
        ),
        (
            x -> CR.Pool(
                x[1]; stocks = (:S, :V), initial = (nothing, x[3]),
                draw = (:S => 1, :V => x[4]) => CR.Hazard(), heterogeneity = x[2],
                flows = (CR.Flow(1 => 0, x[5]; form = CR.Truncate()),)
            ),
            (a, α) -> [100.0, α, 0.0, 0.3, a],
        ),
    )
    # Pools full, and one stratum's pools empty so the draw comes from the
    # pool alone; counts that are taken whole, capped and negative. At an
    # empty pool the exponent's derivative holds `log(0)`, so it is one
    # there.
    pools = (
        ([60.0, 50.0, 20.0, 10.0], (1.0, 1.4)), ([0.0, 50.0, 0.0, 10.0], (1.0,)),
    )
    for (build, θ) in flow_sets, (s, αs) in pools, α in αs, a in (2.0, 70.0, -3.0)
        c = check_pullback(build, θ(a, α), [3.0, 1.5], s, 2)
        @test c.v && c.s && c.θ
    end
    # A rate and a count out of the one pool, pointwise.
    pointwise(x) = CR.Pool(
        x[1]; heterogeneity = x[2],
        flows = (CR.Flow(1 => 0, x[3]), CR.Flow(1 => 0, x[4]; form = CR.Truncate()))
    )
    for (s, αs) in (([60.0, 50.0], (1.0, 1.2)), ([0.0, 50.0], (1.0,))), α in αs,
            a in (2.0, 70.0, -3.0)
        c = check_pullback(pointwise, [100.0, α, 0.05, a], [3.0, 1.5], s, 1)
        @test c.v && c.s && c.θ
    end
end

@testitem "Pool flows: check their options" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    @test_throws "Flow(2 => 1) names stock 2, but the stocks are (:S,)" CR.Pool(
        100.0; flows = CR.Flow(2 => 1, 0.1)
    )
    @test_throws "expected a Flow, got 0.1" CR.Pool(100.0; flows = (0.1,))
    @test_throws "a Flow, or a tuple or vector of Flows, got 0.1" CR.Pool(
        100.0; flows = 0.1
    )
    # A vector of flows is a tuple of them.
    @test CR.Pool(100.0; flows = [CR.Flow(:S => 0, 0.1)]).flows ==
        CR.Pool(100.0; flows = CR.Flow(:S => 0, 0.1)).flows
    @test_throws ArgumentError CR.Depletion(100.0; removals = [1.0, 2.0])
    d = CR.Pool(100.0; flows = (CR.Flow(1 => 0, PerStratum([0.1, 0.2, 0.3])),))
    r = Recurrence([0.5]; modifiers = (d,))
    @test_throws "demand of Flow(1 => 0) has 3 strata, expected 2" r(
        ones(2, 3); history = ones(2, 1)
    )
end

@testitem "Pool flows: resume, Float32 and inference" begin
    using ComposableRecurrences, Test
    CR = ComposableRecurrences
    g, h = [0.3, 0.5, 0.2], [5.0]
    R = fill(2.0, 12)
    ω = TimeVarying(collect(range(0.0, 0.2; length = 12)))
    d = CR.Pool(
        500.0; stocks = (:S, :V), draw = (:S => 1, :V => 0.3) => CR.Hazard(),
        flows = (CR.Flow(1 => 2, 3.0; form = CR.Truncate()), CR.Flow(2 => 1, ω))
    )
    r = Recurrence(g; modifiers = (d,))
    y = r(R; history = h)
    y1, st = CR.with_state(r, R[1:5]; history = h)
    @test vcat(y1, r(R; state = st)) ≈ y
    # Inside a function the stock names are constants, so the pool infers.
    build() = ComposableRecurrences.Pool(
        500.0; stocks = (:S, :V),
        draw = (:S => 1, :V => 0.3) => ComposableRecurrences.Hazard(),
        flows = ComposableRecurrences.Flow(:V => :S, 0.1)
    )
    @inferred build()
    @inferred CR.forward(d, CR.Step(), (2.0,), (400.0, 50.0), 3, 1)
    # Float32 throughout gives the Float64 values in Float32.
    d32 = CR.Pool(
        500.0f0; stocks = (:S, :V), draw = (:S => 1, :V => 0.3f0) => CR.Hazard(),
        heterogeneity = 1.0f0,
        flows = (
            CR.Flow(1 => 2, 3.0f0; form = CR.Truncate()),
            CR.Flow(2 => 1, TimeVarying(Float32.(ω.x))),
        )
    )
    y32 = Recurrence(Float32.(g); modifiers = (d32,))(Float32.(R); history = Float32.(h))
    @test y32 isa Vector{Float32}
    @test y32 ≈ y rtol = 1.0e-5
end
