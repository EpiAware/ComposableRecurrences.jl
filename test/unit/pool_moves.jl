# A `Depletion` without a draw, which moves its values between pools: values and
# ForwardDiff gradients against naive loops for each flow form, the group
# pullback against a local ForwardDiff Jacobian, and the checks.

@testmodule FlowChecks begin
    using ComposableRecurrences, ForwardDiff
    const CR = ComposableRecurrences

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

@testitem "Depletion without a draw: wards against a naive loop" setup = [ReferenceAD, FlowChecks] begin
    using ComposableRecurrences, ForwardDiff
    CR = ComposableRecurrences
    (; ward, forms) = FlowChecks
    adm = [10.0 12.0 8.0 5.0 3.0 0.0; 4.0 6.0 9.0 7.0 2.0 1.0]
    W = reshape(range(0.2, 1.4; length = 24), 4, 6)
    for (build, at, θc) in values(forms)
        n = length(θc)
        function run(θ, adm)
            flows = CR.Depletion(;
                pools = (:A, :B), form = nothing, flows = (
                    CR.Flow(1 => 2, build(θ[1:n])),
                    CR.Flow(1 => 0, TimeVarying(θ[(n + 1):(n + 6)]); form = CR.Share()),
                    CR.Flow(2 => 0, θ[n + 7]),
                    CR.Flow(2 => 0, PerStratum(θ[(n + 8):(n + 9)]); form = CR.Truncate()),
                )
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
        @test ReferenceAD.gradient(θ -> sum(W .* run(θ, adm)), θ) ≈
            ReferenceAD.gradient(θ -> sum(W .* ref(θ, adm)), θ)
        @test ReferenceAD.gradient(a -> sum(W .* run(θ, a)), adm) ≈
            ReferenceAD.gradient(a -> sum(W .* ref(θ, a)), adm)
    end
end

@testitem "Depletion without a draw: a share flow is the occupancy recurrence" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    A = [30 * exp(-((t - 15) / 6)^2) for t in 1:40]
    d = 0.15
    flows = CR.Depletion(;
        pools = (:A,), form = nothing, flows = (
            CR.Flow(1 => 0, d; form = CR.Share()),
        )
    )
    r = Recurrence([1.0]; modifiers = (flows,))
    y = r(; history = [0.0][:, :], add = A', stop = 40)
    @test vec(y) ≈ Recurrence([1 - d])(; history = [0.0], add = A) .* (1 - d)
    # The state holds the arrivals: a rate flow's confirmations.
    flows = CR.Depletion(;
        pools = (:A, :B), form = nothing, flows = (
            CR.Flow(1 => 2, 0.3),
            CR.Flow(1 => 0, 0.4),
        )
    )
    r = Recurrence([1.0]; modifiers = (flows,))
    _, st = CR.with_state(r; history = [5.0, 0.0][:, :], stop = 1)
    @test only(st.states)[1] == 0
    @test only(st.states)[2] ≈ 5 * 0.3 / 0.7 * (1 - exp(-0.7))
end

@testitem "Depletion without a draw: counts are capped and act in order" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    flows = CR.Depletion(;
        pools = (:A, :B, :C), form = nothing, flows = (
            CR.Flow(1 => 2, 4.0; form = CR.Truncate()),
            CR.Flow(1 => 3, 4.0; form = CR.Truncate()),
            CR.Flow(3 => 0, -1.0; form = CR.Truncate()),
        )
    )
    v = [6.0, 0.0, 0.0]
    CR.forward!(flows, CR.Step(), v, zeros(3), 1)
    # 4 to compartment 2, the remaining 2 to compartment 3, then 1 added
    # to compartment 3 with nothing leaving.
    @test v == [0.0, 4.0, 3.0]
end

@testitem "Depletion without a draw: a smooth count against a naive loop" setup = [ReferenceAD] begin
    using ComposableRecurrences, ForwardDiff
    CR = ComposableRecurrences
    adm = [4.0, 0.0, 3.0, 0.0, 0.0, 6.0]
    function run(θ)
        flows = CR.Depletion(;
            pools = (:A, :B), form = nothing, flows = (
                CR.Flow(1 => 2, θ[1]; form = CR.SoftTruncate(θ[2])),
                CR.Flow(2 => 0, 0.2; form = CR.Share()),
            )
        )
        r = Recurrence([1.0]; modifiers = (flows,))
        return r(; history = zeros(2, 1), add = [adm'; zero(adm')], stop = 6)
    end
    # The share acts first, then the count moves the smooth minimum of its
    # demand `a` and what pool 1 holds.
    function ref(θ)
        a, κ = θ
        x = zeros(eltype(θ), 2)
        Y = zeros(eltype(θ), 2, 6)
        for t in 1:6
            x[1] += adm[t]
            x[2] -= 0.2 * x[2]
            m = (a^(-1 / κ) + x[1]^(-1 / κ))^(-κ)
            x[1] -= m
            x[2] += m
            Y[:, t] = x
        end
        return Y
    end
    θ = [2.0, 0.3]
    @test run(θ) ≈ ref(θ)
    @test ReferenceAD.gradient(θ -> sum(run(θ)), θ) ≈
        ReferenceAD.gradient(θ -> sum(ref(θ)), θ)
end

@testitem "Depletion without a draw: the time checks infer and allocate nothing, after a gradient too" setup = [ReferenceAD] begin
    using ComposableRecurrences, ForwardDiff, Mooncake
    using DifferentiationInterface: gradient, AutoMooncake
    CR = ComposableRecurrences
    function flows(θ)
        return CR.Depletion(;
            pools = (:U, :C), form = nothing, flows = (
                CR.Flow(:U => :C, PerStratum(θ[1:2])),
                CR.Flow(:U => 0, TimeVarying(θ[3:8]); form = CR.Share()),
                CR.Flow(:C => 0, θ[9]),
                CR.Flow(
                    :C => 0, TimeVarying(PerStratum(reshape(θ[10:21], 2, 6)));
                    form = CR.Truncate()
                ),
            )
        )
    end
    θ = vcat([0.3, 0.2], fill(0.1, 6), 0.1, fill(0.5, 12))
    mods = (flows(θ), CR.Clamp(0.0, 1.0e6))
    checked(m) = ComposableRecurrences._check_times(:modifiers, m, 6)
    check_allocs(m) = (checked(m); @allocated checked(m))
    @test (@inferred checked(mods)) === nothing
    # Coverage instrumentation allocates, so counts are checked only
    # without it.
    coverage = Base.JLOptions().code_coverage != 0
    @test check_allocs(mods) == 0 skip = coverage
    adm = [fill(10.0, 2, 6); zeros(2, 6)]
    call(m) = Recurrence([1.0]; modifiers = m)(; history = zeros(4, 1), add = adm)
    call_allocs(m) = (call(m); @allocated call(m))
    before = call_allocs(mods)
    loss(θ) = sum(call((flows(θ), CR.Clamp(0.0, 1.0e6))))
    @test gradient(loss, AutoMooncake(), θ) ≈ ReferenceAD.gradient(loss, θ)
    # A gradient does not leave the checks to run inference on each call.
    @test check_allocs(mods) == 0 skip = coverage
    @test call_allocs(mods) <= before skip = coverage
end

@testitem "Depletion without a draw: pullback against a local Jacobian" setup = [FlowChecks, ModifierChecks] begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    (; check_pullback) = ModifierChecks
    # Two groups of three compartments with a cycle, exits and every form.
    build(θ) = CR.Depletion(;
        pools = (:A, :B, :C), form = nothing, flows = (
            CR.Flow(1 => 2, PerStratum(θ[1:2])),
            CR.Flow(1 => 0, θ[3]; form = CR.Share()),
            CR.Flow(2 => 3, TimeVarying(θ[4:5])),
            CR.Flow(3 => 1, θ[6]),
            CR.Flow(2 => 0, θ[7]),
            CR.Flow(3 => 2, PerStratum(θ[8:9]); form = CR.Truncate()),
            CR.Flow(1 => 0, θ[10]; form = CR.Truncate()),
        )
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
    chained(θ) = CR.Depletion(;
        pools = (:A, :B), form = nothing, flows = (
            CR.Flow(1 => 2, Derived(exp, PerStratum(θ[1:2]))),
            CR.Flow(2 => 0, TimeVarying(PerStratum(reshape(θ[3:6], 2, 2))); form = CR.Share()),
            CR.Flow(1 => 2, θ[7]; form = CR.Truncate()),
            CR.Flow(2 => 0, θ[8]; form = CR.Truncate()),
        )
    )
    v = [4.0, 2.0, 1.0, 0.5]
    # The second count's cap binds, then the first's.
    for (a1, a2) in ((1.5, 50.0), (4.0, 0.5)), t in (1, 2)
        θ = [-1.0, -2.0, 0.1, 0.2, 0.3, 0.05, a1, a2]
        c = check_pullback(chained, θ, v, zeros(4), t)
        @test c.v && c.s && c.θ
    end
    # Counts only: a negative count, a capped one and one that adds; without
    # a mirror the input cotangents are unchanged.
    counts(θ) = CR.Depletion(;
        pools = (:A, :B), form = nothing, flows = (
            CR.Flow(1 => 2, PerStratum(θ[1:2]); form = CR.Truncate()),
            CR.Flow(2 => 0, θ[3]; form = CR.Truncate()),
        )
    )
    for θ in ([1.5, -0.5, 9.0], [1.5, 0.2, 50.0], [3.0, 0.5, -1.0]), t in (1, 2)
        c = check_pullback(counts, θ, v, zeros(4), t)
        @test c.v && c.s && c.θ
    end
    # Smooth counts, with the softness as a parameter: one below what the
    # compartment holds, one above it and one out of an empty compartment.
    soft(θ) = CR.Depletion(;
        pools = (:A, :B), form = nothing, flows = (
            CR.Flow(1 => 2, PerStratum(θ[1:2]); form = CR.SoftTruncate(θ[3])),
            CR.Flow(2 => 0, θ[4]; form = CR.SoftTruncate(θ[5])),
        )
    )
    for θ in ([1.5, 0.3, 0.1, 9.0, 0.2], [3.0, 0.5, 0.4, -1.0, 0.1]), t in (1, 2)
        c = check_pullback(soft, θ, [4.0, 0.0, 1.0, 0.5], zeros(4), t)
        @test c.v && c.s && c.θ
    end
    θ = [1.5, -0.5, 9.0]
    v̄, s̄ = [0.3, 1.1, -0.4, 0.7], zeros(4)
    CR._vector_pullback!(
        (; piece = nothing, v = v̄, s = s̄), counts(θ), copy(v), zeros(4), 1
    )
    v̄m = [0.3, 1.1, -0.4, 0.7]
    CR._vector_pullback!(
        (; piece = ModifierChecks.mirror(counts(θ)), v = v̄m, s = zeros(4)),
        counts(θ), copy(v), zeros(4), 1
    )
    @test v̄ == v̄m
end

@testitem "Depletion without a draw: the share that leaves near zero hazard" begin
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

@testitem "Depletion without a draw: resume, Float32 and the adjoint route" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    flows = CR.Depletion(;
        pools = (:A, :B), form = nothing, flows = (
            CR.Flow(1 => 2, 0.3),
            CR.Flow(2 => 0, 0.1; form = CR.Share()),
        )
    )
    r = Recurrence([1.0]; modifiers = (flows,))
    A = [fill(3.0, 2, 10); zeros(2, 10)]
    y = r(; history = zeros(4, 1), add = A, stop = 10)
    y1, st = CR.with_state(r; history = zeros(4, 1), add = A, stop = 4)
    @test hcat(y1, r(; state = st, add = A, stop = 10)) ≈ y
    @test CR.blocks(flows) == Val((2, 2))
    @test CR.nstate(flows, 6) == 6
    @test CR.uses_adjoint(r, CR.Run())
    f32 = CR.Depletion(;
        pools = (:A, :B), form = nothing, flows = (
            CR.Flow(1 => 2, 0.3f0),
            CR.Flow(2 => 0, 0.5f0; form = CR.Truncate()),
        )
    )
    y = Recurrence(Float32[1.0]; modifiers = (f32,))(
        ; history = zeros(Float32, 2, 1), add = Float32[1 1 1; 0 0 0], stop = 3
    )
    @test eltype(y) == Float32
end

@testitem "Depletion without a draw: check their options" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    @test_throws "two different pools, got 1 => 1" CR.Flow(1 => 1, 0.1)
    @test_throws "two different pools, got :S => :S" CR.Flow(:S => :S, 0.1)
    @test_throws "a flow from outside the Depletion is a count" CR.Flow(0 => 1, 0.1)
    @test_throws "got to = -1" CR.Flow(1 => -1, 0.1)
    @test_throws "given as from => to, got (1, 2)" CR.Flow((1, 2), 0.1)
    @test_throws "pool names or positions, got 1.5" CR.Flow(1.5 => 2, 0.1)
    @test_throws ArgumentError CR.Flow(1 => 2, [0.1, 0.2])
    @test_throws ArgumentError CR.Flow(1 => 2, TimeVarying([0.1, 0.2], CR.Primary()))
    @test_throws ArgumentError CR.Flow(1 => 2, [0.1, 0.2]; form = CR.Share())
    @test_throws "demand is between 0 and 1, got 1.5" CR.Flow(
        1 => 2, 1.5; form = CR.Share()
    )
    @test_throws "demand is between 0 and 1, got -0.1" CR.Flow(
        1 => 0, PerStratum([0.2, -0.1]); form = CR.Share()
    )
    @test CR.Flow(1 => 2, 1.5).demand == 1.5
    @test_throws "SoftTruncate(κ), got ComposableRecurrences.Floor()" CR.Flow(
        1 => 2, 0.1; form = CR.Floor()
    )
    moving(names, flows) = CR.Depletion(; pools = names, form = nothing, flows)
    @test_throws "expected a Flow, got 0.3" moving((:A, :B), (CR.Flow(1 => 2, 0.1), 0.3))
    @test_throws "Flow(1 => 2) names pool 2, but the pools are (:A,)" moving(
        (:A,), CR.Flow(1 => 2, 0.1)
    )
    @test_throws "names pool :R, but the pools are (:S, :V)" moving(
        (:S, :V), CR.Flow(:S => :R, 0.1)
    )
    @test CR.blocks(moving((:A, :B, :C), CR.Flow(1 => 2, 0.1))) == Val((3, 3))
    @test_throws "pools is a named tuple of starting values" moving(
        2.5, CR.Flow(1 => 2, 0.1)
    )
    @test_throws "pools is a named tuple of starting values" moving((:S, :S), ())
    @test_throws "the history gives their start" CR.Depletion(;
        pools = (A = 1.0, B = nothing), form = nothing
    )
    @test_throws "shape a draw, and form = nothing has none" CR.Depletion(;
        form = nothing, heterogeneity = 2.0
    )
    # A third pool without flows is named by `pools`.
    flows = moving((:A, :B, :C), CR.Flow(1 => 2, 0.5; form = CR.Share()))
    v = [1.0, 1.0, 0.0, 0.0, 7.0, 7.0]
    CR.forward!(flows, CR.Step(), v, zeros(6), 1)
    @test v ≈ [0.5, 0.5, 0.5, 0.5, 7.0, 7.0]
    r = Recurrence([1.0]; modifiers = (moving((:A, :B), CR.Flow(1 => 2, 0.1)),))
    @test_throws "multiple of 2 strata, got 3" r(; history = zeros(3, 1), stop = 2)
    flows = moving((:A, :B), CR.Flow(1 => 2, PerStratum([0.1, 0.2, 0.3]); form = CR.Share()))
    r = Recurrence([1.0]; modifiers = (flows,))
    @test_throws "demand of Flow(1 => 2) has 3 strata, expected 2" r(
        ; history = zeros(4, 1), stop = 2
    )
end
