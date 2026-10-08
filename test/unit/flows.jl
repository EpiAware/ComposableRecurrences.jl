# Flows: values and ForwardDiff gradients against naive loops for each flow
# kind, the group pullback against a local ForwardDiff Jacobian, and the
# checks.

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

    # Compare the vector pullback with the transposed Jacobian of the
    # vector step in `[v; s; θ]`, for a modifier `build(θ)` whose mirror
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

    # One step of flows on compartments `x`: `rates` and `shares` map
    # `(from, to)` to a value and act together, then `counts` in order.
    function flow_step(x, rates, shares, counts)
        x′ = copy(x)
        for i in eachindex(x)
            out = [(to, ρ) for ((from, to), ρ) in rates if from == i]
            H = isempty(out) ? 0.0 : sum(last, out)
            # The share that leaves per unit hazard, with its series near
            # zero so a zero rate has the right derivative.
            small = abs(ForwardDiff.value(H)) < 1.0e-4
            g = small ? 1 - H / 2 + H^2 / 6 : (1 - exp(-H)) / H
            for (to, ρ) in out
                m = x[i] * ρ * g
                x′[i] -= m
                to > 0 && (x′[to] += m)
            end
            for ((from, to), p) in shares
                from == i || continue
                x′[i] -= p * x[i]
                to > 0 && (x′[to] += p * x[i])
            end
        end
        for ((from, to), a) in counts
            # The cap follows primal values, as the package does, so a
            # compartment at exactly zero keeps its derivative.
            v = ForwardDiff.value
            c = v(x′[from]) < 0 ? zero(x′[from]) : x′[from]
            m = a < 0 ? a : (v(c) < v(a) ? c : a)
            x′[from] -= m
            to > 0 && m > 0 && (x′[to] += m)
        end
        return x′
    end

    # Wards written out: admissions into suspected (compartment 1), which
    # are confirmed (compartment 2) or ruled out; confirmed patients are
    # discharged at a rate and transferred out in fixed numbers.
    function ward(adm, confirm, ruleout, discharge, transfer)
        G, T = size(adm)
        Tp = promote_type(
            eltype(adm), typeof(confirm(1, 1)), typeof(ruleout(1, 1)),
            typeof(transfer(1, 1))
        )
        Y = zeros(Tp, 2G, T)
        x = zeros(Tp, G, 2)
        for t in 1:T, k in 1:G
            x[k, 1] += adm[k, t]
            x[k, :] = flow_step(
                x[k, :], Dict((1, 2) => confirm(k, t), (2, 0) => discharge),
                Dict((1, 0) => ruleout(k, t)), [(2, 0) => transfer(k, t)]
            )
            Y[k, t], Y[G + k, t] = x[k, 1], x[k, 2]
        end
        return Y
    end

    # Each parameter form, built from a flat vector, with its value at
    # group `k` and time `t`, for 2 groups over 6 times.
    const forms = (
        scalar = (θ -> θ[1], (θ, k, t) -> θ[1], [0.2]),
        per_group = (θ -> PerStratum(θ), (θ, k, t) -> θ[k], [0.1, 0.3]),
        over_time = (
            θ -> TimeVarying(θ), (θ, k, t) -> θ[t], [0.0, 0.1, 0.2, 0.4, 0.3, 1.0e-9],
        ),
        groups_time = (
            θ -> TimeVarying(PerStratum(reshape(θ, 2, 6))),
            (θ, k, t) -> reshape(θ, 2, 6)[k, t], collect(range(0.0, 0.5; length = 12)),
        ),
        derived = (
            θ -> θ[1] * Derived(exp, PerStratum(θ[2:3])),
            (θ, k, t) -> θ[1] * exp(θ[1 + k]), [0.1, -0.5, 0.5],
        ),
    )
end

@testitem "Flows: wards against a naive loop" setup = [FlowChecks] begin
    using ComposableRecurrences, ForwardDiff
    CR = ComposableRecurrences
    (; ward, forms) = FlowChecks
    adm = [10.0 12.0 8.0 5.0 3.0 0.0; 4.0 6.0 9.0 7.0 2.0 1.0]
    W = reshape(range(0.2, 1.4; length = 24), 4, 6)
    for (build, at, θc) in values(forms)
        n = length(θc)
        function run(θ, adm)
            flows = CR.Flows(
                CR.Flow(1 => 2, build(θ[1:n])),
                CR.Flow(1 => 0, CR.Linear(TimeVarying(θ[(n + 1):(n + 6)]))),
                CR.Flow(2 => 0, θ[n + 7]),
                CR.Flow(2 => 0, CR.Amount(PerStratum(θ[(n + 8):(n + 9)]))),
            )
            r = Recurrence([1.0]; modifiers = (flows,))
            return r(; history = zeros(4, 1), add = [adm; zero(adm)], stop = 6)
        end
        function ref(θ, adm)
            return ward(
                adm, (k, t) -> at(θ[1:n], k, t), (k, t) -> θ[n + t], θ[n + 7],
                (k, t) -> θ[n + 7 + k]
            )
        end
        θ = vcat(θc, [0.4, 0.0, 0.2, 0.3, 0.1, 0.25], 0.1, [0.5, 30.0])
        @test run(θ, adm) ≈ ref(θ, adm)
        @test ForwardDiff.gradient(θ -> sum(W .* run(θ, adm)), θ) ≈
            ForwardDiff.gradient(θ -> sum(W .* ref(θ, adm)), θ)
        @test ForwardDiff.gradient(a -> sum(W .* run(θ, a)), adm) ≈
            ForwardDiff.gradient(a -> sum(W .* ref(θ, a)), adm)
    end
end

@testitem "Flows: a share flow is the occupancy recurrence" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    A = [30 * exp(-((t - 15) / 6)^2) for t in 1:40]
    d = 0.15
    flows = CR.Flows(CR.Flow(1 => 0, CR.Linear(d)))
    r = Recurrence([1.0]; modifiers = (flows,))
    y = r(; history = [0.0][:, :], add = A', stop = 40)
    @test vec(y) ≈ Recurrence([1 - d])(; history = [0.0], add = A) .* (1 - d)
    # The state holds the arrivals: a rate flow's confirmations.
    flows = CR.Flows(CR.Flow(1 => 2, 0.3), CR.Flow(1 => 0, 0.4))
    r = Recurrence([1.0]; modifiers = (flows,))
    _, st = CR.with_state(r; history = [5.0, 0.0][:, :], stop = 1)
    @test only(st.states)[1] == 0
    @test only(st.states)[2] ≈ 5 * 0.3 / 0.7 * (1 - exp(-0.7))
end

@testitem "Flows: counts are capped and act in order" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    flows = CR.Flows(
        CR.Flow(1 => 2, CR.Amount(4.0)), CR.Flow(1 => 3, CR.Amount(4.0)),
        CR.Flow(3 => 0, CR.Amount(-1.0))
    )
    v = [6.0, 0.0, 0.0]
    CR.forward(flows, CR.Step(), v, zeros(3), 1)
    # 4 to compartment 2, the remaining 2 to compartment 3, then 1 added
    # to compartment 3 with nothing leaving.
    @test v == [0.0, 4.0, 3.0]
end

@testitem "Flows: pullback against a local Jacobian" setup = [FlowChecks] begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    (; check_pullback) = FlowChecks
    # Two groups of three compartments with a cycle, exits and every kind.
    build(θ) = CR.Flows(
        CR.Flow(1 => 2, PerStratum(θ[1:2])), CR.Flow(1 => 0, CR.Linear(θ[3])),
        CR.Flow(2 => 3, TimeVarying(θ[4:5])), CR.Flow(3 => 1, θ[6]),
        CR.Flow(2 => 0, θ[7]), CR.Flow(3 => 2, CR.Amount(PerStratum(θ[8:9]))),
        CR.Flow(1 => 0, CR.Amount(θ[10]))
    )
    v = [4.0, 2.0, 3.0, 0.5, 1.0, 6.0]
    θs = (
        [0.3, 0.5, 0.2, 0.2, 0.6, 0.1, 0.05, 0.5, 9.0, 1.0],
        [0.0, 2.0, 0.0, 1.0e-9, 3.0, 0.0, 0.0, -1.0, 0.2, 10.0],
    )
    for θ in θs, t in (1, 2)
        c = check_pullback(build, θ, v, zeros(6), t)
        @test c.v && c.s && c.θ
    end
    # Derived and group-by-time parameters, and a count into a compartment
    # followed by a count out of it whose cap binds.
    chained(θ) = CR.Flows(
        CR.Flow(1 => 2, Derived(exp, PerStratum(θ[1:2]))),
        CR.Flow(2 => 0, CR.Linear(TimeVarying(PerStratum(reshape(θ[3:6], 2, 2))))),
        CR.Flow(1 => 2, CR.Amount(θ[7])), CR.Flow(2 => 0, CR.Amount(θ[8]))
    )
    v = [4.0, 2.0, 1.0, 0.5]
    # The second count's cap binds, then the first's.
    for (a1, a2) in ((1.5, 50.0), (4.0, 0.5)), t in (1, 2)
        θ = [-1.0, -2.0, 0.1, 0.2, 0.3, 0.05, a1, a2]
        c = check_pullback(chained, θ, v, zeros(4), t)
        @test c.v && c.s && c.θ
    end
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

@testitem "Flows: resume, Float32 and the adjoint route" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    flows = CR.Flows(CR.Flow(1 => 2, 0.3), CR.Flow(2 => 0, CR.Linear(0.1)))
    r = Recurrence([1.0]; modifiers = (flows,))
    A = [fill(3.0, 2, 10); zeros(2, 10)]
    y = r(; history = zeros(4, 1), add = A, stop = 10)
    y1, st = CR.with_state(r; history = zeros(4, 1), add = A, stop = 4)
    @test hcat(y1, r(; state = st, add = A, stop = 10)) ≈ y
    @test CR.blocks(flows) == Val((2, 2))
    @test CR.nstate(flows, 6) == 6
    @test CR.uses_adjoint(r, CR.Run())
    f32 = CR.Flows(CR.Flow(1 => 2, 0.3f0), CR.Flow(2 => 0, CR.Amount(0.5f0)))
    y = Recurrence(Float32[1.0]; modifiers = (f32,))(
        ; history = zeros(Float32, 2, 1), add = Float32[1 1 1; 0 0 0], stop = 3
    )
    @test eltype(y) == Float32
end

@testitem "Flows: check their options" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    @test_throws "two different compartments, got 1 => 1" CR.Flow(1 => 1, 0.1)
    @test_throws "got from = 0" CR.Flow(0 => 1, 0.1)
    @test_throws "got to = -1" CR.Flow(1 => -1, 0.1)
    @test_throws "given as from => to, got (1, 2)" CR.Flow((1, 2), 0.1)
    @test_throws ArgumentError CR.Flow(1 => 2, [0.1, 0.2])
    @test_throws ArgumentError CR.Rate(TimeVarying([0.1, 0.2], CR.Primary()))
    @test_throws ArgumentError CR.Linear([0.1, 0.2])
    @test_throws ArgumentError CR.Amount([0.1, 0.2])
    @test_throws "at least one Flow, got none" CR.Flows()
    @test_throws "expected a Flow, got 0.3" CR.Flows(CR.Flow(1 => 2, 0.1), 0.3)
    @test_throws "up to 2, got compartments = 1" CR.Flows(
        CR.Flow(1 => 2, 0.1); compartments = 1
    )
    @test CR.blocks(CR.Flows(CR.Flow(1 => 2, 0.1); compartments = Int32(3))) == Val((3, 3))
    @test_throws "a positive integer, got 2.5" CR.Flows(
        CR.Flow(1 => 2, 0.1); compartments = 2.5
    )
    # A third compartment without flows is named by `compartments`.
    flows = CR.Flows(CR.Flow(1 => 2, CR.Linear(0.5)); compartments = 3)
    v = [1.0, 1.0, 0.0, 0.0, 7.0, 7.0]
    CR.forward(flows, CR.Step(), v, zeros(6), 1)
    @test v ≈ [0.5, 0.5, 0.5, 0.5, 7.0, 7.0]
    r = Recurrence([1.0]; modifiers = (CR.Flows(CR.Flow(1 => 2, 0.1)),))
    @test_throws "multiple of 2 strata, got 3" r(; history = zeros(3, 1), stop = 2)
    flows = CR.Flows(CR.Flow(1 => 2, CR.Linear(PerStratum([0.1, 0.2, 0.3]))))
    r = Recurrence([1.0]; modifiers = (flows,))
    @test_throws "p has 3 strata, expected 2" r(; history = zeros(4, 1), stop = 2)
end
