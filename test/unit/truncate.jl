# The truncated draw forms: values against the minimum, Depletion with each
# form against a naive loop, and the pullbacks against local Jacobians.

@testitem "Truncate forms: the draw and the pool" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    for (v, s) in ((2.0, 5.0), (5.0, 2.0), (2.0, 2.0), (2.0, -1.0), (0.0, 3.0))
        y, s′ = CR.forward(CR.Truncate(), CR.Step(), v, s, 100.0, 1.0)
        @test y == min(v, max(s, 0.0))
        @test s′ == s - y
        y, s′ = CR.forward(CR.SoftTruncate(0.2), CR.Step(), v, s, 100.0, 1.0)
        @test 0 <= y <= min(v, max(s, 0.0))
        @test s′ ≈ s - y
    end
    # The smooth draw tends to the minimum away from the tie.
    @test CR.forward(CR.SoftTruncate(0.01), CR.Step(), 2.0, 5.0, 1.0, 1.0)[1] ≈ 2.0
    @test CR.SoftTruncate(1 // 4).κ === 0.25
end

@testitem "Truncate forms: Depletion against a naive loop" begin
    using ComposableRecurrences, ForwardDiff
    CR = ComposableRecurrences
    g = [0.3, 0.5, 0.2]
    R = [2.5, 2.4, 2.2, 2.0, 1.8, 1.5, 1.2, 1.0]
    h = [2.0, 3.0, 4.0]
    W = collect(range(0.5, 1.5; length = 8))
    draw(::Nothing, v, f) = min(v, f)
    function draw(κ, v, f)
        lo, hi = minmax(v, f)
        lo > 0 || return lo
        # `(v^(-1/κ) + f^(-1/κ))^(-κ)`, scaled so the powers do not overflow.
        return lo * (1 + (lo / hi)^(1 / κ))^(-κ)
    end
    function naive(N, κ)
        pool = N
        y = collect(promote(h..., N, something(κ, 0.0))[1:3])
        for t in eachindex(R)
            v = R[t] * sum(g[i] * y[end - i + 1] for i in 1:3)
            x = draw(κ, v, max(pool, 0))
            push!(y, x)
            pool -= x
        end
        return y[4:end]
    end
    form(::Nothing) = CR.Truncate()
    form(κ) = CR.SoftTruncate(κ)
    run(N, κ) = Recurrence(g; modifiers = (CR.Depletion(N, form(κ)),))(R; history = h)
    for κ in (nothing, 0.1, 0.3)
        # The pool runs out part way, so the draw binds.
        @test run(40.0, κ) ≈ naive(40.0, κ)
        @test run(40.0, κ) != Recurrence(g)(R; history = h)[1:8]
        @test ForwardDiff.derivative(N -> sum(W .* run(N, κ)), 40.0) ≈
            ForwardDiff.derivative(N -> sum(W .* naive(N, κ)), 40.0)
    end
    @test ForwardDiff.derivative(κ -> sum(W .* run(40.0, κ)), 0.2) ≈
        ForwardDiff.derivative(κ -> sum(W .* naive(40.0, κ)), 0.2)
end

@testitem "Truncate forms: pullbacks against a local Jacobian" setup = [ModifierChecks] begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    v = [3.0, 0.5, 8.0]
    for s in ([150.0, 0.2, 5.0], [2.0, -1.0, 90.0])
        c = ModifierChecks.check_pullback(
            θ -> CR.Depletion(PerStratum(θ[1:3]), CR.Truncate(); heterogeneity = θ[4]),
            [200.0, 60.0, 100.0, 1.0], v, s, 2
        )
        @test c.v && c.s && c.θ
        # The softness is a parameter, after `N` in field order.
        c = ModifierChecks.check_pullback(
            θ -> CR.Depletion(θ[1], CR.SoftTruncate(θ[2]); heterogeneity = θ[3]),
            [200.0, 0.2, 1.0], v, s, 2
        )
        @test c.v && c.s && c.θ
        @test c.θ̄[2] != 0
    end
    @test CR.uses_adjoint(CR.Truncate(), CR.Step())
    @test CR.uses_adjoint(CR.Depletion(1.0, CR.SoftTruncate(0.1)), CR.Step())
end
