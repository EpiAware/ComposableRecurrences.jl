# Flows and Linked: values and ForwardDiff gradients against naive loops,
# their pullbacks against a local ForwardDiff Jacobian of the Step, and
# their checks.

@testmodule FlowChecks begin
    using ComposableRecurrences, ForwardDiff
    const CR = ComposableRecurrences

    # A zero cotangent mirror, as the adjoint wiring builds it, with a tuple
    # of mirrors for a tuple field.
    mirror(x::AbstractFloat) = Ref(zero(x))
    mirror(x::AbstractArray{<:AbstractFloat}) = zero(x)
    mirror(::AbstractArray) = nothing
    mirror(::Union{Integer, Symbol, Nothing}) = nothing
    mirror(x::Tuple) = map(mirror, x)
    function mirror(x)
        names = fieldnames(typeof(x))
        return NamedTuple{names}(map(n -> mirror(getfield(x, n)), names))
    end
    flat(::Nothing) = Float64[]
    flat(x::Base.RefValue) = [x[]]
    flat(x::AbstractArray) = vec(copy(x))
    flat(x::Union{Tuple, NamedTuple}) = reduce(vcat, map(flat, values(x)); init = Float64[])

    # Compare the Step's `pullback!` with the transposed Jacobian of its
    # `forward` in `[v; s; θ]`, for a modifier `build(θ)` whose mirror
    # flattens in the order of `θ`.
    function check_pullback(build, θ, v, s, t)
        S, n = length(v), length(s)
        v̄′ = collect(range(0.3, 1.7; length = S))
        s̄′ = collect(range(-0.4, 0.9; length = n))
        J = ForwardDiff.jacobian(vcat(v, s, θ)) do x
            vv, ss = x[1:S], x[(S + 1):(S + n)]
            CR.forward(build(x[(S + n + 1):end]), CR.Step(), vv, ss, t)
            return vcat(vv, ss)
        end
        expected = transpose(J) * vcat(v̄′, s̄′)
        m = build(θ)
        m̄ = mirror(m)
        gv, gs = copy(v̄′), copy(s̄′)
        CR._vector_pullback!((; piece = m̄, v = gv, s = gs), m, copy(v), copy(s), t)
        return (;
            v = gv ≈ expected[1:S],
            s = gs ≈ expected[(S + 1):(S + n)],
            θ = flat(m̄) ≈ expected[(S + n + 1):end],
        )
    end

    # One step of competing flows on stocks `x` with rates `r[(from, to)]`.
    function flow_step(x, r)
        x′ = copy(x)
        for i in eachindex(x)
            out = [(to, ρ) for ((from, to), ρ) in r if from == i]
            isempty(out) && continue
            H = sum(last, out)
            for (to, ρ) in out
                # `==` on a dual compares its partials too.
                m = x[i] * (ForwardDiff.value(H) == 0 ? ρ : ρ * (1 - exp(-H)) / H)
                x′[i] -= m
                to > 0 && (x′[to] += m)
            end
        end
        return x′
    end

    # A ward written out: admissions into suspected, which are confirmed or
    # ruled out; confirmed patients are discharged.
    function ward(adm, confirm, ruleout, discharge)
        H, T = size(adm)
        Tp = promote_type(eltype(adm), typeof(confirm(1, 1)), typeof(ruleout(1, 1)))
        Y = zeros(Tp, 2H, T)
        x = zeros(Tp, H, 2)
        for t in 1:T, k in 1:H
            x[k, 1] += adm[k, t]
            r = Dict((1, 2) => confirm(k, t), (1, 0) => ruleout(k, t), (2, 0) => discharge)
            x[k, :] = flow_step(x[k, :], r)
            Y[k, t], Y[H + k, t] = x[k, 1], x[k, 2]
        end
        return Y
    end

    # A renewal with leaky vaccination into a protected pool that wanes at
    # rate `ω(k, t)` before each step's draw, written out.
    function waning(g, R, h, N, σ, doses, ω)
        S, T = size(R)
        L = size(h, 2)
        Tp = promote_type(eltype(R), typeof(σ), typeof(ω(1, 1)), eltype(doses))
        Y = zeros(Tp, S, L + T)
        Y[:, 1:L] .= h
        u, w = fill(Tp(N), S), zeros(Tp, S)
        for t in 1:T, k in 1:S
            u[k], w[k] = flow_step([u[k], w[k]], Dict((2, 1) => ω(k, t)))
            v = R[k, t] * sum(g[i] * Y[k, L + t - i] for i in eachindex(g))
            P = u[k] + σ * w[k]
            y = P * (1 - exp(-v / N))
            u[k] -= y * u[k] / P
            w[k] -= y * σ * w[k] / P
            m = min(doses[k, t], max(u[k], 0))
            u[k] -= m
            w[k] += m
            Y[k, L + t] = y
        end
        return Y[:, (L + 1):end]
    end

    # Each waning rate form, built from a flat vector, with its value at
    # stratum `k` and time `t`, for 2 strata over 6 times.
    const rates = (
        scalar = (θ -> θ[1], (θ, k, t) -> θ[1], [0.2]),
        per_stratum = (θ -> PerStratum(θ), (θ, k, t) -> θ[k], [0.1, 0.3]),
        over_time = (
            θ -> TimeVarying(θ), (θ, k, t) -> θ[t], [0.0, 0.1, 0.2, 0.4, 0.3, 1.0e-9],
        ),
        strata_time = (
            θ -> TimeVarying(PerStratum(reshape(θ, 2, 6))),
            (θ, k, t) -> reshape(θ, 2, 6)[k, t], collect(range(0.0, 0.5; length = 12)),
        ),
        derived = (
            θ -> θ[1] * Derived(exp, PerStratum(θ[2:3])),
            (θ, k, t) -> θ[1] * exp(θ[1 + k]), [0.1, -0.5, 0.5],
        ),
    )
end

@testitem "Flows: a ward against a naive loop" setup = [FlowChecks] begin
    using ComposableRecurrences, ForwardDiff
    CR = ComposableRecurrences
    (; ward) = FlowChecks
    adm = [10.0 12.0 8.0 5.0 3.0 0.0; 4.0 6.0 9.0 7.0 2.0 1.0]
    run(θ, adm) = Recurrence(
        [1.0]; modifiers = (
            CR.Flows(
                CR.Flow(1 => 2, PerStratum(θ[1:2])),
                CR.Flow(1 => 0, TimeVarying(θ[3:8])), CR.Flow(2 => 0, θ[9]),
            ),
        )
    )(; history = zeros(4, 1), add = [adm; zero(adm)], stop = 6)
    ref(θ, adm) = ward(adm, (k, t) -> θ[k], (k, t) -> θ[2 + t], θ[9])
    θ = [0.3, 0.5, 0.4, 0.0, 0.2, 0.6, 0.4, 0.3, 0.1]
    @test run(θ, adm) ≈ ref(θ, adm)
    W = reshape(range(0.2, 1.4; length = 24), 4, 6)
    @test ForwardDiff.gradient(θ -> sum(W .* run(θ, adm)), θ) ≈
        ForwardDiff.gradient(θ -> sum(W .* ref(θ, adm)), θ)
    @test ForwardDiff.gradient(a -> sum(W .* run(θ, a)), adm) ≈
        ForwardDiff.gradient(a -> sum(W .* ref(θ, a)), adm)
    # The state holds the last step's arrivals: confirmations, none into
    # the suspected stock.
    r = Recurrence(
        [1.0]; modifiers = (CR.Flows(CR.Flow(1 => 2, 0.3), CR.Flow(1 => 0, 0.4)),)
    )
    _, st = CR.with_state(r; history = [5.0, 0.0][:, :], stop = 1)
    @test only(st.states)[1] == 0
    @test only(st.states)[2] ≈ 5 * 0.3 / 0.7 * (1 - exp(-0.7))
end

@testitem "Linked: waning protection against a naive loop" setup = [FlowChecks] begin
    using ComposableRecurrences, ForwardDiff
    CR = ComposableRecurrences
    (; waning, rates) = FlowChecks
    g = [0.5, 0.3, 0.2]
    R = [2.0 + 0.2 * sin(k + t) for k in 1:2, t in 1:6]
    h = [2.0 3.0 4.0; 1.0 1.0 2.0]
    N, σ = 200.0, 0.3
    doses = [3.0 4.0 5.0 5.0 6.0 6.0; 1.0 2.0 2.0 3.0 3.0 300.0]
    W = reshape(range(0.2, 1.4; length = 12), 2, 6)
    for (build, at, θ) in values(rates)
        function run(θ, R)
            d = CR.Depletion(
                N; removals = TimeVarying(PerStratum(doses)),
                protected = CR.Protected(σ)
            )
            m = CR.Linked(d, CR.Flow(2 => 1, build(θ)))
            return Recurrence(g; modifiers = (m,))(R; history = h)
        end
        ref(θ, R) = waning(g, R, h, N, σ, doses, (k, t) -> at(θ, k, t))
        @test run(θ, R) ≈ ref(θ, R)
        @test ForwardDiff.gradient(θ -> sum(W .* run(θ, R)), θ) ≈
            ForwardDiff.gradient(θ -> sum(W .* ref(θ, R)), θ)
        @test ForwardDiff.gradient(R -> sum(W .* run(θ, R)), R) ≈
            ForwardDiff.gradient(R -> sum(W .* ref(θ, R)), R)
    end
    # No waning is the depletion alone.
    d = CR.Depletion(N; removals = 2.0, protected = CR.Protected(σ))
    still = CR.Linked(d, CR.Flow(2 => 1, 0.0))
    @test Recurrence(g; modifiers = (still,))(R; history = h) ≈
        Recurrence(g; modifiers = (d,))(R; history = h)
end

@testitem "Flows and Linked: pullbacks against a local Jacobian" setup = [FlowChecks] begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    (; check_pullback, rates) = FlowChecks
    # Two wards of three stocks, with a cycle, an exit and a zero rate.
    build_flows(θ) = CR.Flows(
        CR.Flow(1 => 2, PerStratum(θ[1:2])), CR.Flow(1 => 0, θ[3]),
        CR.Flow(2 => 3, TimeVarying(θ[4:5])), CR.Flow(3 => 1, θ[6]),
        CR.Flow(2 => 0, θ[7]),
    )
    v = [4.0, 2.0, 3.0, 0.5, 1.0, 6.0]
    θs = ([0.3, 0.5, 0.4, 0.2, 0.6, 0.1, 0.05], [0.0, 2.0, 0.0, 1.0e-9, 3.0, 0.0, 0.0])
    for θ in θs, t in (1, 2)
        c = check_pullback(build_flows, θ, v, zeros(6), t)
        @test c.v && c.s && c.θ
    end
    # Waning on a protected pool with removals, for each rate form.
    for (build, at, θ) in values(rates), t in (1, 4)
        c = check_pullback(
            x -> CR.Linked(
                CR.Depletion(
                    PerStratum(x[1:2]); heterogeneity = x[3], removals = x[4],
                    protected = CR.Protected(x[5]; pool0 = x[6])
                ),
                CR.Flow(2 => 1, build(x[7:end]))
            ),
            [100.0, 80.0, 1.2, 2.0, 0.3, 0.0, θ...], [3.0, 1.5],
            [60.0, 50.0, 20.0, 10.0, 0.5, 0.2, 0.1, 0.3], t
        )
        @test c.v && c.s && c.θ
    end
    # A removal at rate μ on a depletion without a protected pool.
    c = check_pullback(
        x -> CR.Linked(
            CR.Depletion(x[1]; heterogeneity = x[2]), CR.Flow(1 => 0, x[3])
        ),
        [100.0, 1.0, 0.02], [3.0, 1.5], [60.0, 50.0, 0.1, 0.2], 1
    )
    @test c.v && c.s && c.θ
end

@testitem "Flows: the share that leaves near zero hazard" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    g(H) = H == 0 ? big(1.0) : -expm1(-H) / H
    g′(H) = H == 0 ? big(-0.5) : (exp(-H) - g(H)) / H
    Hs = (0.0, 1.0e-12, 1.0e-6, 1.0e-3, 5.0e-3, 0.02, 0.03, 0.1, 0.5, 1.0, 20.0, -1.0e-4)
    for T in (Float32, Float64), H in Hs
        x = T(H)
        E, gx = CR._leave(x)
        @test gx isa T
        @test gx ≈ T(g(big(x))) rtol = 8 * eps(T)
        @test CR._leave_slope(x, E, gx) ≈ T(g′(big(x))) rtol = sqrt(eps(T))
    end
end

@testitem "Flows and Linked: resume, Float32 and the adjoint route" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    d = CR.Depletion(500.0; removals = 4.0, protected = CR.Protected(0.4))
    r = Recurrence([0.5, 0.5]; modifiers = (CR.Linked(d, CR.Flow(2 => 1, 0.2)),))
    R = fill(1.6, 10)
    y = r(R; history = [2.0, 3.0])
    y1, st = CR.with_state(r, R[1:4]; history = [2.0, 3.0])
    @test length(only(st.states)) == 4
    @test vcat(y1, r(R; state = st)) ≈ y
    @test CR.nstate(r.modifiers[1], 3) == 12
    @test CR.uses_adjoint(r, CR.Run())
    # A modifier without its own pullback leaves the call to plain AD.
    struct Halve end
    CR.ispointwise(::Halve) = true
    CR.forward(::Halve, ::CR.Step, v, s, t, k) = (v / 2, s)
    @test !CR.uses_adjoint(CR.Linked(Halve(), CR.Flow(1 => 0, 0.1)), CR.Step())
    flows = CR.Flows(CR.Flow(1 => 2, 0.3f0), CR.Flow(2 => 0, 0.1f0))
    y = Recurrence(Float32[1.0]; modifiers = (flows,))(
        ; history = zeros(Float32, 2, 1), add = Float32[1 1 1; 0 0 0], stop = 3
    )
    @test eltype(y) == Float32
    @test CR.uses_adjoint(flows, CR.Step())
end

@testitem "Flows and Linked: check their options" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    @test_throws "two different stocks, got 1 => 1" CR.Flow(1 => 1, 0.1)
    @test_throws "got from = 0" CR.Flow(0 => 1, 0.1)
    @test_throws "got to = -1" CR.Flow(1 => -1, 0.1)
    @test_throws "given as from => to, got (1, 2)" CR.Flow((1, 2), 0.1)
    @test_throws ArgumentError CR.Flow(1 => 2, [0.1, 0.2])
    @test_throws ArgumentError CR.Flow(1 => 2, TimeVarying([0.1, 0.2], CR.Primary()))
    @test_throws "at least one Flow, got none" CR.Flows()
    @test_throws "up to 2, got stocks = 1" CR.Flows(CR.Flow(1 => 2, 0.1); stocks = 1)
    @test_throws "up to 2, got stocks = 1" CR.Flows((CR.Flow(1 => 2, 0.1),), 1)
    @test_throws "at least one Flow, got none" CR.Linked(CR.Depletion(10.0), ())
    @test_throws "expected a Flow, got 0.3" CR.Flows(CR.Flow(1 => 2, 0.1), 0.3)
    @test_throws "at least one Flow, got none" CR.Linked(CR.Depletion(10.0))
    @test_throws "modifier whose stocks the flows move first" CR.Linked(
        CR.Flow(1 => 0, 0.1), CR.Flow(1 => 0, 0.1)
    )
    # A third stock without flows is named by `stocks`.
    flows = CR.Flows(CR.Flow(1 => 2, 0.5); stocks = 3)
    v = [1.0, 1.0, 0.0, 0.0, 7.0, 7.0]
    CR.forward(flows, CR.Step(), v, zeros(6), 1)
    @test v ≈ [exp(-0.5), exp(-0.5), 1 - exp(-0.5), 1 - exp(-0.5), 7.0, 7.0]
    flows = CR.Flows(CR.Flow(1 => 2, 0.1))
    @test_throws "a multiple of 2, got 3 strata" Recurrence([1.0]; modifiers = (flows,))(
        ; history = zeros(3, 1), stop = 2
    )
    flows = CR.Flows(CR.Flow(1 => 2, PerStratum([0.1, 0.2, 0.3])))
    @test_throws DimensionMismatch Recurrence([1.0]; modifiers = (flows,))(
        ; history = zeros(4, 1), stop = 2
    )
    m = CR.Linked(CR.Depletion(10.0), CR.Flow(2 => 1, 0.1))
    @test_throws "the flows name stock 2, but Depletion keeps 1 per stratum" Recurrence(
        [0.5]; modifiers = (m,)
    )(ones(3); history = [1.0])
    m = CR.Linked(CR.Depletion(10.0), CR.Flow(1 => 0, PerStratum([0.1, 0.2])))
    @test_throws DimensionMismatch Recurrence([0.5]; modifiers = (m,))(
        ones(3, 3); history = ones(3, 1)
    )
end
