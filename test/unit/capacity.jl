# Capacity: values and ForwardDiff gradients against a naive loop for each
# mode and overflow handling, the budget's period semantics, conservation,
# the smooth minimum, and the pullback against a local ForwardDiff Jacobian
# of the Step.

@testmodule CapacityChecks begin
    using ComposableRecurrences
    const CR = ComposableRecurrences

    # A renewal with per-stratum kernels whose pairs route demand under a
    # capacity, written out. `cap(p, t)` and `exit(p, t)` read the
    # parameters; `period` is `nothing` for a lifetime budget.
    function naive(
            G, R, h, pairs; mode, cap, exit = (p, t) -> 0.0, period = nothing,
            carry = true, hold = false, initial = p -> 0.0
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
        stock = Tp[initial(p) for p in 1:P]
        queue = zeros(Tp, P)
        for t in 1:T
            v = [R[k, t] * sum(G[k, i] * Y[k, L + t - i] for i in 1:L) for k in 1:S]
            for (p, pr) in enumerate(pairs)
                a = hold ? pr : pr.first
                d = v[a] + queue[p]
                if mode === :stock
                    kept = (1 - exit(p, t)) * stock[p]
                    x = min(d, max(cap(p, t) - kept, 0))
                    stock[p] = kept + x
                else
                    refill = period === nothing ? t == 1 : (t - 1) % period == 0
                    if refill
                        stock[p] = (carry ? stock[p] : zero(Tp)) + cap(p, t)
                    end
                    x = min(d, max(stock[p], 0))
                    stock[p] -= x
                end
                v[a] = x
                if hold
                    queue[p] = d - x
                else
                    v[pr.second] += d - x
                end
            end
            Y[:, L + t] .= v
        end
        return Y[:, (L + 1):end], stock, queue
    end

    # Pairs 1 => 2 and 3 => 4; admitted strata transmit less.
    const G = [
        0.2 0.3 0.1
        0.5 0.3 0.2
        0.2 0.2 0.1
        0.5 0.3 0.2
    ]
    const R = [1.6 + 0.3 * sin(k + t) for k in 1:4, t in 1:12]
    const h = [2.0 3.0 4.0; 1.0 1.0 2.0; 1.0 2.0 2.0; 0.5 0.5 1.0]
    const W = reshape(range(0.2, 1.4; length = 48), 4, 12)
end

@testitem "Capacity: values and gradients against a naive loop" setup = [CapacityChecks] begin
    using ComposableRecurrences, ForwardDiff
    CR = ComposableRecurrences
    (; G, R, h, W, naive) = CapacityChecks
    route, hold = [1 => 2, 3 => 4], [1, 3]
    TT = [4.0 + 0.5 * sin(p * t) for p in 1:2, t in 1:12]
    # Each case: the modifier from θ, the naive loop's keywords from θ, θ.
    cases = (
        stock_scalar = (
            θ -> CR.Capacity(θ[1], CR.Stock(θ[2]); pairs = route),
            θ -> (; mode = :stock, cap = (p, t) -> θ[1], exit = (p, t) -> θ[2]),
            [6.0, 0.2],
        ),
        stock_hold = (
            θ -> CR.Capacity(
                PerStratum(θ[1:2]), CR.Stock(PerStratum(θ[3:4]));
                pairs = hold, overflow = CR.Hold(), initial = PerStratum(θ[5:6])
            ),
            θ -> (;
                mode = :stock, cap = (p, t) -> θ[p], exit = (p, t) -> θ[2 + p],
                hold = true, initial = p -> θ[4 + p],
            ),
            [6.0, 4.0, 0.2, 0.3, 1.0, 0.5],
        ),
        stock_time = (
            θ -> CR.Capacity(
                TimeVarying(PerStratum(reshape(θ[1:24], 2, 12))),
                CR.Stock(TimeVarying(θ[25:36])); pairs = route
            ),
            θ -> (;
                mode = :stock, cap = (p, t) -> reshape(θ[1:24], 2, 12)[p, t],
                exit = (p, t) -> θ[24 + t],
            ),
            vcat(vec(TT), fill(0.25, 12)),
        ),
        weekly = (
            θ -> CR.Capacity(θ[1], CR.Budget(4); pairs = route),
            θ -> (; mode = :budget, cap = (p, t) -> θ[1], period = 4),
            [9.0],
        ),
        weekly_reset = (
            θ -> CR.Capacity(
                TimeVarying(θ), CR.Budget(4; carry_over = false); pairs = route
            ),
            θ -> (; mode = :budget, cap = (p, t) -> θ[t], period = 4, carry = false),
            collect(range(6.0, 12.0; length = 12)),
        ),
        lifetime_hold = (
            θ -> CR.Capacity(
                PerStratum(θ), CR.Budget(Inf); pairs = hold, overflow = CR.Hold()
            ),
            θ -> (; mode = :budget, cap = (p, t) -> θ[p], hold = true),
            [30.0, 20.0],
        ),
    )
    for (build, kw, θ) in values(cases)
        r(θ, R) = Recurrence(PerStratum(G); modifiers = (build(θ),))(R; history = h)
        pairs = build(θ).overflow isa CR.Hold ? hold : route
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

@testitem "Capacity: infinite capacity is the identity" setup = [CapacityChecks] begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    (; G, R, h) = CapacityChecks
    free = Recurrence(PerStratum(G))(R; history = h)
    for m in (
            CR.Capacity(Inf, CR.Stock(0.1); pairs = [1 => 2, 3 => 4]),
            CR.Capacity(Inf, CR.Budget(3); pairs = [1 => 2]),
            CR.Capacity(Inf, CR.Stock(); pairs = [1, 3], overflow = CR.Hold()),
        )
        @test Recurrence(PerStratum(G); modifiers = (m,))(R; history = h) ≈ free
    end
end

@testitem "Capacity: route conserves each step, hold across steps" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    d = [3.0, 5.0, 1.0, 6.0, 2.0, 0.0, 4.0, 7.0]
    demand = [d'; zeros(1, 8)]
    for mode in (CR.Stock(0.3), CR.Budget(3), CR.Budget(3; carry_over = false))
        m = CR.Capacity(4.0, mode; pairs = [1 => 2])
        y = Recurrence([0.0]; modifiers = (m,))(; history = zeros(2, 1), add = demand)
        @test vec(sum(y; dims = 1)) ≈ d
        @test all(>=(0), y)
        h = CR.Capacity(4.0, mode; pairs = [1], overflow = CR.Hold())
        r = Recurrence([0.0]; modifiers = (h,))
        y, st = CR.with_state(r; history = zeros(1, 1), add = reshape(d, 1, :))
        queue = st.states[1][2]
        @test sum(y) + queue ≈ sum(d)
        @test queue > 0
    end
end

@testitem "Capacity: budget periods, carry over and lifetime" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    run(mode, d; kw...) = Recurrence([0.0]; modifiers = (CR.Capacity(4.0, mode; pairs = [1 => 2], kw...),))(;
        history = zeros(2, 1), add = [d'; zeros(1, length(d))]
    )[1, :]
    d = [1.0, 1.0, 1.0, 5.0, 5.0, 5.0, 0.0, 0.0, 0.0, 9.0]
    # Carry over: 1 unused in the first period, so 5 in the second; then 4
    # granted in each, all unused in the third.
    @test run(CR.Budget(3), d) == [1.0, 1.0, 1.0, 5.0, 0.0, 0.0, 0.0, 0.0, 0.0, 8.0]
    # Without carry over each period starts at 4.
    @test run(CR.Budget(3; carry_over = false), d) ==
        [1.0, 1.0, 1.0, 4.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.0]
    # A lifetime budget is granted once.
    @test run(CR.Budget(Inf), d) == [1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    @test run(CR.Budget(Inf; carry_over = false), d) == run(CR.Budget(Inf), d)
    # The starting allowance adds to the first grant.
    @test run(CR.Budget(Inf), d; initial = 2.0)[4] == 3.0
    # Unserved demand is routed, not queued: it never returns to stratum 1.
    y = Recurrence([0.0]; modifiers = (CR.Capacity(4.0, CR.Budget(3); pairs = [1 => 2]),))(;
        history = zeros(2, 1), add = [d'; zeros(1, 10)]
    )
    @test y[2, :] == d .- y[1, :]
end

@testitem "Capacity: resuming from the state matches one call" setup = [CapacityChecks] begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    (; G, R, h) = CapacityChecks
    for (mode, overflow, pairs) in (
            (CR.Stock(0.2), CR.Route(), [1 => 2, 3 => 4]),
            (CR.Budget(5), CR.Hold(), [1, 3]),
        )
        r = Recurrence(PerStratum(G); modifiers = (CR.Capacity(5.0, mode; pairs, overflow),))
        whole = r(R; history = h)
        first7, st = CR.with_state(r, R; history = h, stop = 7)
        @test hcat(first7, r(R; state = st, stop = 12)) ≈ whole
    end
end

@testitem "Capacity: the smooth minimum" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    for κ in (0.05, 0.2)
        @test CR._admit(κ, 3.0, 3.0) ≈ 3.0 * 2.0^(-κ)
        @test CR._admit(κ, 0.0, 3.0) == 0.0
        @test CR._admit(κ, 3.0, 0.0) == 0.0
        for (d, f) in ((1.0, 4.0), (4.0, 1.0), (2.0, 2.5))
            x = CR._admit(κ, d, f)
            @test 0 <= x <= min(d, f)
            @test CR._admit(κ, f, d) ≈ x
        end
    end
    @test CR._admit(0.01, 1.0, 2.0) ≈ 1.0
    # Smooth through the tie: the derivative in `d` is continuous at d = f.
    lo = CR._admit_back(0.2, 3.0 - 1.0e-9, 3.0, 1.0)
    hi = CR._admit_back(0.2, 3.0 + 1.0e-9, 3.0, 1.0)
    @test lo[1] ≈ hi[1] atol = 1.0e-6
    @test lo[3] ≈ hi[3] atol = 1.0e-6
end

@testitem "Capacity: pullback against a local Jacobian" setup = [ModifierChecks] begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    v = [2.0, 0.5, 3.0, 1.0]
    # The state is each pair's stock, then each queue with Hold().
    builds = (
        (
            x -> CR.Capacity(
                x[2], CR.Stock(x[1]); pairs = [1 => 2, 3 => 4], initial = x[3]
            ),
            [0.2, 4.0, 0.0], [2.0, 3.5], (3, 4),
        ),
        (
            x -> CR.Capacity(
                PerStratum(x[3:4]), CR.Stock(PerStratum(x[1:2]));
                pairs = [3 => 1, 2 => 4], softness = x[5], initial = x[6]
            ),
            [0.2, 0.4, 4.0, 2.0, 0.2, 0.0], [2.0, 1.0], (1,),
        ),
        (
            x -> CR.Capacity(
                TimeVarying(x[1:6]), CR.Budget(3); pairs = [1, 3],
                overflow = CR.Hold(), initial = x[7]
            ),
            [collect(range(2.0, 4.0; length = 6)); 0.0], [1.2, 0.5, 1.0, 2.0],
            (1, 3, 4),
        ),
        (
            x -> CR.Capacity(
                x[1], CR.Budget(2; carry_over = false); pairs = [1 => 2],
                softness = x[2], initial = x[3]
            ),
            [2.5, 0.1, 0.0], [1.0], (1, 2),
        ),
        (
            x -> CR.Capacity(
                x[1], CR.Budget(Inf); pairs = [3 => 2], initial = x[2]
            ),
            [2.5, 0.0], [4.0], (1, 2),
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

@testitem "Capacity: checks its arguments" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    @test_throws "Route() moves the overflow" CR.Capacity(1.0, CR.Stock(); pairs = [1])
    @test_throws "Hold() keeps the overflow" CR.Capacity(
        1.0, CR.Stock(); pairs = [1 => 2], overflow = CR.Hold()
    )
    @test_throws "at most once" CR.Capacity(1.0, CR.Stock(); pairs = [1 => 2, 2 => 3])
    @test_throws "non-empty vector" CR.Capacity(1.0, CR.Stock(); pairs = Pair{Int, Int}[])
    @test_throws "start at 1, got 0" CR.Capacity(1.0, CR.Stock(); pairs = [0 => 1])
    @test_throws "Stock(exit) or Budget(period), got :stock" CR.Capacity(
        1.0, :stock; pairs = [1 => 2]
    )
    @test_throws "Route() or Hold(), got :hold" CR.Capacity(
        1.0, CR.Stock(); pairs = [1 => 2], overflow = :hold
    )
    @test_throws "between 0 and 1, got 1.5" CR.Capacity(
        1.0, CR.Stock(); pairs = [1 => 2], softness = 1.5
    )
    @test CR.Budget(7, false) === CR.Budget(7; carry_over = false)
    @test CR.Budget(Inf).period === nothing
    @test_throws "positive integer or Inf, got 0" CR.Budget(0)
    @test_throws "positive integer or Inf, got 2.5" CR.Budget(2.5)
    @test_throws DimensionMismatch CR.Capacity(
        PerStratum([1.0, 2.0]), CR.Stock(); pairs = [1 => 2]
    )
    @test_throws DimensionMismatch CR.Capacity(
        1.0, CR.Stock(PerStratum([0.1, 0.2])); pairs = [1 => 2]
    )
    @test_throws ArgumentError CR.Capacity(
        1.0, CR.Stock(); pairs = [1 => 2], initial = TimeVarying([1.0])
    )
    @test_throws ArgumentError CR.Stock([0.1, 0.2])
    m = CR.Capacity(1.0, CR.Stock(); pairs = [1 => 3])
    @test_throws "name stratum 3, but there are 2" Recurrence([0.5]; modifiers = (m,))(
        ones(2, 3); history = ones(2, 1)
    )
    @test CR.nstate(m, 5) == 1
    @test CR.nstate(CR.Capacity(1.0, CR.Budget(2); pairs = [1, 2], overflow = CR.Hold()), 5) == 4
    @test CR.param_eltype(CR.Capacity(1.0f0, CR.Stock(0.1f0); pairs = [1 => 2])) == Float32
end

@testitem "Capacity: the recurrence uses its adjoint" setup = [CapacityChecks] begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    (; G) = CapacityChecks
    m = CR.Capacity(5.0, CR.Stock(0.2); pairs = [1 => 2, 3 => 4], softness = 0.1)
    r = Recurrence(PerStratum(G); modifiers = (m,))
    @test CR.uses_adjoint(r, CR.Run())
    @test CR.uses_adjoint(m, CR.Step())
end
