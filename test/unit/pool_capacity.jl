# A `Pool` as a capacity: a pool of beds filled by the draw and emptied by a
# share flow first, or an allowance drawn from and granted by flows first.
# Values and ForwardDiff gradients against a naive loop for each with the
# overflow in a stratum, a queue or nowhere, the budget's period semantics,
# conservation, the smooth minimum, and the pullback against a local
# ForwardDiff Jacobian of the Step.

@testmodule CapacityChecks begin
    using ComposableRecurrences
    const CR = ComposableRecurrences

    # A renewal with per-stratum kernels whose pairs route demand under a
    # capacity, written out. `cap(p, t)` and `exit(p, t)` read the
    # parameters; `period` is `nothing` for a lifetime budget.
    function naive(
            G, R, h, pairs; mode, cap, exit = (p, t) -> 0.0, period = nothing,
            carry = true, hold = false, drop = false, initial = p -> 0.0
        )
        S, T = size(R)
        L = size(G, 2)
        Tp = promote_type(
            eltype(G), eltype(R), eltype(h), typeof(cap(1, 1)),
            typeof(exit(1, 1)), typeof(initial(1))
        )
        Y = zeros(Tp, S, L + T)
        Y[:, 1:L] .= h
        P = length(pairs)
        pool = Tp[initial(p) for p in 1:P]
        queue = zeros(Tp, P)
        for t in 1:T
            v = [R[k, t] * sum(G[k, i] * Y[k, L + t - i] for i in 1:L) for k in 1:S]
            for (p, pr) in enumerate(pairs)
                a = hold || drop ? pr : pr.first
                d = v[a] + queue[p]
                if mode === :beds
                    kept = (1 - exit(p, t)) * pool[p]
                    x = min(d, max(cap(p, t) - kept, 0))
                    pool[p] = kept + x
                else
                    refill = period === nothing ? t == 1 : (t - 1) % period == 0
                    if refill
                        pool[p] = (carry ? pool[p] : zero(Tp)) + cap(p, t)
                    end
                    x = min(d, max(pool[p], 0))
                    pool[p] -= x
                end
                v[a] = x
                if hold
                    queue[p] = d - x
                elseif !drop
                    v[pr.second] += d - x
                end
            end
            Y[:, L + t] .= v
        end
        return Y[:, (L + 1):end], pool, queue
    end

    # Groups 1 => 3 and 2 => 4, admitted strata first; they transmit less.
    const G = [
        0.2 0.3 0.1
        0.2 0.2 0.1
        0.5 0.3 0.2
        0.5 0.3 0.2
    ]
    const R = [1.6 + 0.3 * sin((1, 3, 2, 4)[k] + t) for k in 1:4, t in 1:12]
    const h = [2.0 3.0 4.0; 1.0 2.0 2.0; 1.0 1.0 2.0; 0.5 0.5 1.0]
    const W = reshape(range(0.2, 1.4; length = 48), 4, 12)
    const ROUTE = [1 => 3, 2 => 4]

    # Beds: the pool is the occupancy, a share `δ` leaves before the draw
    # and the admissions fill it up to `C`.
    function beds(C, δ; overflow = :stratum, form = CR.Truncate(), initial = nothing)
        return CR.Pool(
            C; pools = (:O,), initial, draw = form => :O, flows_first = true,
            flows = CR.Flow(:O => 0, δ; form = CR.Share()), overflow
        )
    end

    # A budget: the pool is the allowance, granted `C` at each period start
    # (every `period` steps, or once with `nothing`) of `T` steps; without
    # carry over a share flow empties it first.
    granted(c, start) = ifelse(start > 0, c, zero(c))
    function budget(
            C, period, T; carry_over = true, overflow = :stratum,
            form = CR.Truncate(), initial = nothing
        )
        starts = TimeVarying(
            [(period === nothing ? t == 1 : rem(t - 1, period) == 0) ? 1.0 : 0.0 for t in 1:T]
        )
        grant = CR.Flow(0 => :B, Derived(granted, C, starts); form = CR.Truncate())
        flows = carry_over ? (grant,) :
            (CR.Flow(:B => 0, starts; form = CR.Share()), grant)
        return CR.Pool(;
            pools = (:B,), initial, draw = :B => form, flows_first = true, flows,
            overflow
        )
    end
end

@testitem "Pool capacity: values and gradients against a naive loop" setup = [CapacityChecks] begin
    using ComposableRecurrences, ForwardDiff
    CR = ComposableRecurrences
    (; G, R, h, W, ROUTE, naive, beds, budget) = CapacityChecks
    TT = [4.0 + 0.5 * sin(p * t) for p in 1:2, t in 1:12]
    # Each case: the modifier from θ, the naive loop's keywords from θ, θ.
    cases = (
        beds_scalar = (
            θ -> beds(θ[1], θ[2]),
            θ -> (; mode = :beds, cap = (p, t) -> θ[1], exit = (p, t) -> θ[2]),
            [6.0, 0.2],
        ),
        beds_hold = (
            θ -> beds(
                PerStratum(θ[1:4]), PerStratum(θ[5:8]); overflow = :queue,
                initial = PerStratum(θ[9:12])
            ),
            θ -> (;
                mode = :beds, cap = (p, t) -> θ[p], exit = (p, t) -> θ[4 + p],
                hold = true, initial = p -> θ[8 + p],
            ),
            [6.0, 4.0, 5.0, 3.0, 0.2, 0.3, 0.25, 0.1, 1.0, 0.5, 0.0, 0.2],
        ),
        beds_time = (
            θ -> beds(
                TimeVarying(PerStratum(reshape(θ[1:24], 2, 12))),
                TimeVarying(θ[25:36])
            ),
            θ -> (;
                mode = :beds, cap = (p, t) -> reshape(θ[1:24], 2, 12)[p, t],
                exit = (p, t) -> θ[24 + t],
            ),
            vcat(vec(TT), fill(0.25, 12)),
        ),
        weekly = (
            θ -> budget(θ[1], 4, 12),
            θ -> (; mode = :budget, cap = (p, t) -> θ[1], period = 4),
            [9.0],
        ),
        weekly_reset = (
            θ -> budget(TimeVarying(θ), 4, 12; carry_over = false),
            θ -> (; mode = :budget, cap = (p, t) -> θ[t], period = 4, carry = false),
            collect(range(6.0, 12.0; length = 12)),
        ),
        lifetime_hold = (
            θ -> budget(PerStratum(θ), nothing, 12; overflow = :queue),
            θ -> (; mode = :budget, cap = (p, t) -> θ[p], hold = true),
            [30.0, 20.0, 25.0, 15.0],
        ),
        weekly_drop = (
            θ -> budget(θ[1], 4, 12; overflow = nothing),
            θ -> (; mode = :budget, cap = (p, t) -> θ[1], period = 4, drop = true),
            [9.0],
        ),
        beds_drop = (
            θ -> beds(PerStratum(θ[1:4]), θ[5]; overflow = nothing),
            θ -> (;
                mode = :beds, cap = (p, t) -> θ[p], exit = (p, t) -> θ[5],
                drop = true,
            ),
            [6.0, 4.0, 5.0, 3.0, 0.2],
        ),
    )
    for (build, kw, θ) in values(cases)
        r(θ, R) = Recurrence(PerStratum(G); modifiers = (build(θ),))(R; history = h)
        pairs = CR._layout(build(θ)).overflow === :stratum ? ROUTE : collect(1:4)
        ref(θ, R) = first(naive(G, R, h, pairs; kw(θ)...))
        @test r(θ, R) ≈ ref(θ, R)
        @test ForwardDiff.gradient(θ -> sum(W .* r(θ, R)), θ) ≈
            ForwardDiff.gradient(θ -> sum(W .* ref(θ, R)), θ)
        @test ForwardDiff.gradient(R -> sum(W .* r(θ, R)), R) ≈
            ForwardDiff.gradient(R -> sum(W .* ref(θ, R)), R)
        # The capacity binds somewhere, so the cases test the routing.
        @test r(θ, R) != Recurrence(PerStratum(G))(R; history = h)
    end
end

@testitem "Pool capacity: infinite capacity is the identity" setup = [CapacityChecks] begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    (; G, R, h, beds, budget) = CapacityChecks
    free = Recurrence(PerStratum(G))(R; history = h)
    for m in (
            beds(Inf, 0.1), budget(Inf, 3, 12), beds(Inf, false; overflow = :queue),
            budget(Inf, nothing, 12; overflow = nothing),
            beds(Inf, 0.1; form = CR.SoftTruncate(0.1)),
        )
        @test Recurrence(PerStratum(G); modifiers = (m,))(R; history = h) ≈ free
    end
end

@testitem "Pool capacity: the stratum conserves each step, the queue across steps" setup = [CapacityChecks] begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    (; beds, budget) = CapacityChecks
    d = [3.0, 5.0, 1.0, 6.0, 2.0, 0.0, 4.0, 7.0]
    demand = [d'; zeros(1, 8)]
    modes = (
        o -> beds(4.0, 0.3; overflow = o), o -> budget(4.0, 3, 8; overflow = o),
        o -> budget(4.0, 3, 8; carry_over = false, overflow = o),
    )
    for mode in modes
        m = mode(:stratum)
        y = Recurrence([0.0]; modifiers = (m,))(; history = zeros(2, 1), add = demand)
        @test vec(sum(y; dims = 1)) ≈ d
        @test all(>=(0), y)
        r = Recurrence([0.0]; modifiers = (mode(:queue),))
        y, st = CR.with_state(r; history = zeros(1, 1), add = reshape(d, 1, :))
        queue = st.states[1][2]
        @test sum(y) + queue ≈ sum(d)
        @test queue > 0
        # Without an overflow the demand left leaves: what remains is the
        # admissions of the routed pool.
        r = Recurrence([0.0]; modifiers = (mode(nothing),))
        y = r(; history = zeros(1, 1), add = reshape(d, 1, :))
        z = Recurrence([0.0]; modifiers = (m,))(; history = zeros(2, 1), add = demand)
        @test vec(y) ≈ z[1, :]
        @test sum(y) < sum(d)
    end
end

@testitem "Pool capacity: budget periods, carry over and lifetime" setup = [CapacityChecks] begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    (; budget) = CapacityChecks
    function run(period, d; kw...)
        m = budget(4.0, period, length(d); kw...)
        add = [d'; zeros(1, length(d))]
        return Recurrence([0.0]; modifiers = (m,))(; history = zeros(2, 1), add)[1, :]
    end
    d = [1.0, 1.0, 1.0, 5.0, 5.0, 5.0, 0.0, 0.0, 0.0, 9.0]
    # Carry over: 1 unused in the first period, so 5 in the second; then 4
    # granted in each, all unused in the third.
    @test run(3, d) == [1.0, 1.0, 1.0, 5.0, 0.0, 0.0, 0.0, 0.0, 0.0, 8.0]
    # Without carry over each period starts at 4.
    @test run(3, d; carry_over = false) ==
        [1.0, 1.0, 1.0, 4.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.0]
    # A lifetime budget is granted once.
    @test run(nothing, d) == [1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    @test run(nothing, d; carry_over = false) == run(nothing, d)
    # The starting allowance adds to the first grant, unless it is reset.
    @test run(nothing, d; initial = 2.0)[4] == 3.0
    @test run(nothing, d; initial = 2.0, carry_over = false) == run(nothing, d)
    # A lifetime budget is also a starting allowance alone.
    lifetime = CR.Pool(; pools = (:B,), initial = 4.0, draw = :B => CR.Truncate())
    @test Recurrence([0.0]; modifiers = (lifetime,))(; history = [0.0], add = d) ==
        run(nothing, d)
    # The demand left goes to the second stratum: it never returns to the
    # first.
    y = Recurrence([0.0]; modifiers = (budget(4.0, 3, 10),))(;
        history = zeros(2, 1), add = [d'; zeros(1, 10)]
    )
    @test y[2, :] == d .- y[1, :]
end

@testitem "Pool capacity: resuming from the state matches one call" setup = [CapacityChecks] begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    (; G, R, h, beds, budget) = CapacityChecks
    for cap in (beds(5.0, 0.2), budget(5.0, 5, 12; overflow = :queue))
        r = Recurrence(PerStratum(G); modifiers = (cap,))
        whole = r(R; history = h)
        first7, st = CR.with_state(r, R; history = h, stop = 7)
        @test hcat(first7, r(R; state = st, stop = 12)) ≈ whole
    end
end

@testitem "Pool capacity: the smooth minimum" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    draw(κ, d, f) = first(CR._draw(CR.SoftTruncate(κ), d, f, 1.0, 1.0))
    for κ in (0.05, 0.2)
        @test draw(κ, 3.0, 3.0) ≈ 3.0 * 2.0^(-κ)
        @test draw(κ, 0.0, 3.0) == 0.0
        @test draw(κ, 3.0, 0.0) == 0.0
        for (d, f) in ((1.0, 4.0), (4.0, 1.0), (2.0, 2.5))
            x = draw(κ, d, f)
            @test 0 <= x <= min(d, f)
            @test draw(κ, f, d) ≈ x
        end
    end
    @test draw(0.01, 1.0, 2.0) ≈ 1.0
    # Smooth through the tie: the derivative in `d` is continuous at d = f.
    lo = CR._soft_min_back(0.2, 3.0 - 1.0e-9, 3.0, 1.0)
    hi = CR._soft_min_back(0.2, 3.0 + 1.0e-9, 3.0, 1.0)
    @test lo[1] ≈ hi[1] atol = 1.0e-6
    @test lo[3] ≈ hi[3] atol = 1.0e-6
end

@testitem "Pool capacity: pullback against a local Jacobian" setup = [ModifierChecks, CapacityChecks] begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    (; beds, budget) = CapacityChecks
    v = [2.0, 0.5, 3.0, 1.0]
    # The state is each group's pool, then each queue. The mirror holds the
    # parameters of `θ` in order: `N`, the softness, `initial`, the flows'.
    builds = (
        (x -> beds(x[1], x[3]; initial = x[2]), [4.0, 0.0, 0.2], [2.0, 3.5], (3, 4)),
        (
            x -> beds(
                PerStratum(x[1:2]), PerStratum(x[5:6]);
                form = CR.SoftTruncate(x[3]), initial = x[4]
            ),
            [4.0, 2.0, 0.2, 0.0, 0.2, 0.4], [2.0, 1.0], (1,),
        ),
        (
            x -> CR.Pool(;
                pools = (:B,), initial = x[1], draw = :B => CR.Truncate(),
                flows_first = true, overflow = :queue,
                flows = CR.Flow(0 => :B, TimeVarying(x[2:7]); form = CR.Truncate())
            ),
            [0.0; collect(range(2.0, 4.0; length = 6))],
            [1.2, 0.5, 1.0, 2.0, 0.3, 0.0, 1.0, 0.4], (1, 3, 4),
        ),
        (
            x -> CR.Pool(;
                pools = (:B,), initial = x[2], draw = :B => CR.SoftTruncate(x[1]),
                flows_first = true, overflow = :stratum, flows = (
                    CR.Flow(:B => 0, TimeVarying(x[3:5]); form = CR.Share()),
                    CR.Flow(0 => :B, x[6]; form = CR.Truncate()),
                )
            ),
            [0.1, 0.0, 1.0, 0.0, 1.0, 2.5], [1.0, 0.4], (1, 2),
        ),
        (
            x -> CR.Pool(; pools = (:B,), initial = x[1], draw = :B => CR.Truncate()),
            [2.5], [4.0, 0.5, 1.0, 0.0], (1, 2),
        ),
        (
            x -> beds(
                PerStratum(x[1:4]), x[6]; overflow = nothing,
                form = CR.SoftTruncate(x[5])
            ),
            [2.0, 4.0, 1.0, 3.0, 0.15, 0.3], [1.5, 2.5, 0.0, 1.0], (1,),
        ),
        (
            x -> CR.Pool(;
                pools = (:B,), draw = :B => CR.Truncate(), flows_first = true,
                flows = CR.Flow(0 => :B, x[1]; form = CR.Truncate()), overflow = :queue
            ),
            [0.3], [0.6, 0.1, 0.0, 0.2, 1.0, 0.0, 0.5, 0.0], (1, 2),
        ),
        # A tie, demand 2 against 2 free beds: the demand takes it, as with
        # dual numbers.
        (x -> beds(x[1], x[3]; initial = x[2]), [3.0, 0.0, 0.5], [2.0, 2.0], (1,)),
        # Infinite capacity with the smooth form: the softness takes nothing.
        (
            x -> beds(x[1], x[4]; form = CR.SoftTruncate(x[2]), initial = x[3]),
            [Inf, 0.1, 0.0, 0.2], [2.0, 1.0], (1,),
        ),
        # The occupancy as one of two pools, with the draw weighted on the
        # second and a hazard flow between them after it.
        (
            x -> CR.Pool(
                x[1]; pools = (:A, :O), initial = (x[2], x[3]),
                draw = CR.Truncate() => :O, overflow = :stratum,
                flows = CR.Flow(:O => :A, x[4])
            ),
            [5.0, 1.0, 2.0, 0.3], [1.0, 0.5, 2.0, 3.0], (1,),
        ),
    )
    for (build, θ, s, ts) in builds, t in ts
        c = ModifierChecks.check_pullback(
            build, θ, v, s, t; s̄ = 0.7 .* s .- 0.9
        )
        @test c.v
        @test c.s
        @test c.θ
    end
end

@testitem "Pool capacity: two wards share one overflow stratum" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    # Wards 1 and 2 overflow into strata 3 and 4, and the Redistribute moves
    # all of stratum 4 into stratum 3, as two pairs `1 => 3, 2 => 3` did.
    beds = CR.Pool(1.0; pools = (:O,), draw = CR.Truncate() => :O, overflow = :stratum)
    K = zeros(4, 4)
    K[3, 4] = 1.0
    shared = CR.Redistribute(CR.movement(K, PerStratum([0.0, 0.0, 0.0, 1.0])))
    y = Recurrence([0.0]; modifiers = (beds, shared))(;
        history = zeros(4, 1), add = [3.0 0.0; 2.0 0.0; 1.0 1.0; 0.0 0.0]
    )
    @test y[1:3, 1] ≈ [1.0, 1.0, 4.0]
    @test all(iszero, y[4, :])
end

@testitem "Pool capacity: checks its arguments" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    fill_into(o; kw...) = CR.Pool(1.0; pools = (:O,), draw = CR.Truncate() => o, kw...)
    @test_throws "overflow is nothing, :queue or :stratum, got :hold" fill_into(
        :O; overflow = :hold
    )
    @test_throws "overflow is nothing, :queue or :stratum, got 2" fill_into(
        :O; overflow = 2
    )
    @test_throws "the draw names pool :X, but the pools are (:O,)" fill_into(:X)
    # A draw into a pool is truncated, from a capacity that is not negative.
    @test_throws "a draw into a pool is Truncate() or SoftTruncate(κ)" CR.Pool(
        1.0; pools = (:O,), draw = CR.Hazard() => :O
    )
    @test_throws "N is non-negative, got -1.0" CR.Pool(
        PerStratum([1.0, -1.0]); pools = (:O,), draw = CR.Truncate() => :O
    )
    @test_throws "initial is non-negative, got -2.0" fill_into(:O; initial = -2.0)
    # Every pool starts from a stock that is not negative, filled or not.
    @test_throws "initial is non-negative, got -1.0" CR.Pool(;
        pools = (:B,), initial = -1.0, draw = :B => CR.Truncate()
    )
    @test_throws "initial is non-negative, got -1.0" CR.Pool(
        1.0; pools = (:S, :R), initial = (1.0, -1.0)
    )
    @test fill_into(:O; initial = 0.5).initial == (0.5,)
    # A truncated draw reads no exponent; `true` and `false` stay fixed.
    @test fill_into(:O; heterogeneity = false).heterogeneity isa CR._FixedExponent{false}
    @test_throws "a draw into a pool fills it up to N, so give N" CR.Pool(;
        pools = (:O,), draw = CR.Truncate() => :O
    )
    @test_throws "flows_first and overflow order and route a draw" CR.Pool(;
        draw = nothing, overflow = :queue
    )
    @test_throws "form => pool, or nothing; got :S => :O" CR.Pool(
        1.0; pools = (:S, :O), draw = :S => :O
    )
    @test_throws "from is a pool from 1, or 0 for outside the Pool, got from = -1" CR.Flow(
        -1 => 1, 0.1
    )
    @test_throws "two different pools, got 0 => 0" CR.Flow(0 => 0, 0.1)
    @test_throws "between 0 and 1, got 1.5" CR.SoftTruncate(1.5)
    @test_throws MethodError CR.SoftTruncate(:soft)
    m = fill_into(:O; overflow = :stratum)
    @test_throws "multiple of 2 strata, got 3" Recurrence([0.5]; modifiers = (m,))(
        ones(3, 3); history = ones(3, 1)
    )
    @test_throws DimensionMismatch Recurrence([0.5]; modifiers = (fill_into(:O; initial = PerStratum([1.0, 2.0, 3.0])),))(
        ones(2, 3); history = ones(2, 1)
    )
    @test CR.blocks(m) == Val((2, 1))
    @test CR.nstate(m, 6) == 3
    queued = fill_into(:O; overflow = :queue)
    @test CR.blocks(queued) == Val((1, 2))
    @test CR.nstate(queued, 5) == 10
    dropped = fill_into(:O)
    @test CR.blocks(dropped) == Val((1, 1))
    @test !CR.ispointwise(dropped)
    @test CR.nstate(dropped, 5) == 5
    @test CR.param_eltype(fill_into(:O; flows = CR.Flow(:O => 0, 0.1f0))) == Float64
    @test CR.param_eltype(
        CR.Pool(
            1.0f0; pools = (:O,), draw = CR.Truncate() => :O,
            flows = CR.Flow(:O => 0, 0.1f0; form = CR.Share())
        )
    ) == Float32
end

@testitem "Pool capacity: the recurrence uses its adjoint" setup = [CapacityChecks] begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    (; G, beds) = CapacityChecks
    m = beds(5.0, 0.2; form = CR.SoftTruncate(0.1))
    r = Recurrence(PerStratum(G); modifiers = (m,))
    @test CR.uses_adjoint(r, CR.Run())
    @test CR.uses_adjoint(m, CR.Step())
end
