# Capacity as routing, not deletion. Every new case is demand for a place:
# an isolation bed or a vaccinated ring. Admitted cases sit in stratum 1 and
# transmit less; the overflow sits in stratum 2 with the full kernel, or
# waits in a queue. Both strata seed stratum 1, so the coupling is
# `[1 1; 0 0]`. EpiBranch.jl's `CapacityConstrained(intervention;
# budget_per_period, period, carry_over)` drops unserved demand, which here
# means it stays in the community stratum.

@testmodule CapacityUseCase begin
    using ComposableRecurrences
    const CR = ComposableRecurrences

    const g = [0.1, 0.3, 0.3, 0.2, 0.1]
    const T = 40
    const seed = [1.0 2.0 3.0 4.0 5.0; 0.0 0.0 0.0 0.0 0.0]
    const R = [2.0 + 0.3 * cos(t / 6) for t in 1:T]
    const C = [1.0 1.0; 0.0 0.0]

    # The two strata written out: `admit(d, stock, t)` returns the
    # admissions and the new stock, and the queue holds the overflow when
    # `hold`.
    function naive(R, e, admit; hold = false)
        L = length(g)
        # A trial admission finds the eltype of the capacity's parameters.
        Tp = promote_type(eltype(R), typeof(e), typeof(admit(1.0, 0.0, 1)[1]))
        Y = zeros(Tp, 2, L + T)
        Y[:, 1:L] .= seed
        stock, queue = zero(Tp), zero(Tp)
        for t in 1:T
            p1 = (1 - e) * sum(g[i] * Y[1, L + t - i] for i in 1:L)
            p2 = sum(g[i] * Y[2, L + t - i] for i in 1:L)
            d = R[t] * (p1 + p2) + queue
            x, stock = admit(d, stock, t)
            Y[1, L + t] = x
            if hold
                queue = d - x
            else
                Y[2, L + t] = d - x
            end
        end
        return Y[:, (L + 1):end]
    end

    # The admitted stratum's kernel is thinned by the effect `e`.
    function model(R, e, cap)
        G = PerStratum([(1 - e) .* g'; g'])
        r = Recurrence(G; coupling = C, modifiers = (cap,))
        return r(repeat(R', 2); history = seed)
    end
end

@testitem "Use case: isolation beds with overflow to the community" tags = [:usecase] setup = [CapacityUseCase] begin
    using ComposableRecurrences, ForwardDiff
    CR = ComposableRecurrences
    (; T, R, naive, model) = CapacityUseCase
    w = range(0.5, 1.5; length = T)
    beds(θ) = CR.Capacity(θ[2], CR.Stock(θ[3]); pairs = [1 => 2])
    function admit(θ)
        return (d, O, t) -> begin
            kept = (1 - θ[3]) * O
            x = min(d, max(θ[2] - kept, 0))
            (x, kept + x)
        end
    end
    θ = [0.4, 40.0, 0.15]
    run(R, θ) = model(R, θ[1], beds(θ))
    ref(R, θ) = naive(R, θ[1], admit(θ))
    Y = run(R, θ)
    @test Y ≈ ref(R, θ)
    # The beds fill, the cap binds and the overflow transmits.
    @test any(>(0), Y[2, :])
    @test maximum(Y[1, :]) < maximum(Y[2, :])
    # Nothing is deleted: with no bed cap every case is admitted.
    free = run(R, [θ[1], Inf, θ[3]])
    @test all(iszero, free[2, :])
    @test sum(free) < sum(Y)
    loss(Y) = sum(w' .* Y)
    @test ForwardDiff.gradient(θ -> loss(run(R, θ)), θ) ≈
        ForwardDiff.gradient(θ -> loss(ref(R, θ)), θ)
    @test ForwardDiff.gradient(R -> loss(run(R, θ)), R) ≈
        ForwardDiff.gradient(R -> loss(ref(R, θ)), R)
    # More beds, fewer cases.
    @test ForwardDiff.gradient(θ -> sum(run(R, θ)), θ)[2] < 0

    # A queue for the next free bed instead: cases wait in the state.
    queued(θ) = CR.Capacity(θ[2], CR.Stock(θ[3]); pairs = [1], overflow = CR.Hold())
    Yq = model(R, θ[1], queued(θ))
    @test Yq ≈ naive(R, θ[1], admit(θ); hold = true)
    @test all(iszero, Yq[2, :])
    @test ForwardDiff.gradient(θ -> loss(model(R, θ[1], queued(θ))), θ) ≈
        ForwardDiff.gradient(θ -> loss(naive(R, θ[1], admit(θ); hold = true)), θ)
end

@testitem "Use case: ring vaccination under a weekly budget" tags = [:usecase] setup = [CapacityUseCase] begin
    using ComposableRecurrences, ForwardDiff
    CR = ComposableRecurrences
    (; T, R, naive, model) = CapacityUseCase
    w = range(0.5, 1.5; length = T)
    loss(Y) = sum(w' .* Y)
    # `b` rings a week; each case needs one ring.
    function admit(b, period, carry)
        return (d, B, t) -> begin
            refill = period === nothing ? t == 1 : (t - 1) % period == 0
            B = refill ? (carry ? B : zero(B)) + b : B
            x = min(d, max(B, 0))
            (x, B - x)
        end
    end
    e = 0.4
    for (mode, period, carry, b) in (
            (CR.Budget(7), 7, true, 60.0),
            (CR.Budget(7; carry_over = false), 7, false, 60.0),
            (CR.Budget(Inf), nothing, true, 400.0),
        )
        rings(b) = CR.Capacity(b, mode; pairs = [1 => 2])
        Y = model(R, e, rings(b))
        @test Y ≈ naive(R, e, admit(b, period, carry))
        @test any(>(0), Y[2, :])
        @test ForwardDiff.derivative(b -> loss(model(R, e, rings(b))), b) ≈
            ForwardDiff.derivative(b -> loss(naive(R, e, admit(b, period, carry))), b)
        @test ForwardDiff.gradient(R -> loss(model(R, e, rings(b))), R) ≈
            ForwardDiff.gradient(R -> loss(naive(R, e, admit(b, period, carry))), R)
        # More rings, fewer cases.
        @test ForwardDiff.derivative(b -> sum(model(R, e, rings(b))), b) < 0
    end
    # Carrying unused rings over never gives more cases than resetting them.
    @test sum(model(R, e, CR.Capacity(60.0, CR.Budget(7); pairs = [1 => 2]))) <=
        sum(
        model(
            R, e, CR.Capacity(60.0, CR.Budget(7; carry_over = false); pairs = [1 => 2])
        )
    )
end
