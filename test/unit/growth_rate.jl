# `growth_rate` and `reproduction_number`: the root of the Euler-Lotka
# equation, its inverse, delays as generation intervals, the errors and the
# derivatives from the implicit function theorem.

@testitem "growth_rate: solves the Euler-Lotka equation" begin
    using ComposableRecurrences: ComposableRecurrences as CR
    lotka(r, R, g) = R * sum(g[l] * exp(-r * l) for l in eachindex(g))
    for g in ([0.1, 0.3, 0.3, 0.2, 0.1], [0.0, 0.4, 0.6, 0.0], [2.0], 0.5 .* ones(20))
        for R in (1.0e-3, 0.5, 0.9, 1.4, 3.0, 1.0e3)
            r = CR.growth_rate(R, g)
            @test lotka(r, R, g) ≈ 1
            @test CR.reproduction_number(r, g) ≈ R
            @test sign(r) == sign(log(R * sum(g)))
        end
    end
    # A single lag with mass has a closed form.
    @test CR.growth_rate(2.0, [0.0, 0.0, 1.0]) ≈ log(2) / 3
    @test abs(CR.growth_rate(1.0, [0.5, 0.5])) < 1.0e-15
    @test CR.reproduction_number(0.0, [0.2, 0.5, 0.3]) ≈ 1
    @test CR.reproduction_number(0.1, [0.2, 0.5, 0.3]) ≈
        1 / (0.2 * exp(-0.1) + 0.5 * exp(-0.2) + 0.3 * exp(-0.3))
    # A long interval at a small R needs no term to overflow.
    g = [1.0; zeros(29)]
    @test CR.growth_rate(1.0e-20, g) ≈ log(1.0e-20)
    @test CR.growth_rate(1.0e20, reverse(g)) ≈ log(1.0e20) / 30
end

@testitem "growth_rate: element types and inference" begin
    using ComposableRecurrences: ComposableRecurrences as CR
    using ForwardDiff: Dual
    g = [0.1, 0.3, 0.3, 0.2, 0.1]
    @test (@inferred CR.growth_rate(1.4, g)) isa Float64
    @test (@inferred CR.growth_rate(1.4f0, Float32.(g))) isa Float32
    @test CR.growth_rate(1.4f0, Float32.(g)) ≈ CR.growth_rate(1.4, g) rtol = 1.0e-5
    @test (@inferred CR.growth_rate(2, [1, 1])) isa Float64
    @test (@inferred CR.reproduction_number(0.1, g)) isa Float64
    @test (@inferred CR.reproduction_number(0.1f0, Float32.(g))) isa Float32
    @test CR.growth_rate(1.4, view([0.0; g], 2:6)) == CR.growth_rate(1.4, g)
    D = Dual{Nothing}
    @test (@inferred CR.growth_rate(D(1.4, 1.0), D.(g, 1.0))) isa D{Float64, 1}
    @test (@inferred CR.growth_rate(1.4, D.(g, 1.0))) isa D{Float64, 1}
    @test (@inferred CR.reproduction_number(D(0.1, 1.0), g)) isa D{Float64, 1}
end

@testitem "growth_rate: a renewal seeded at the rate grows by e^r each step" begin
    using ComposableRecurrences
    using ComposableRecurrences: ComposableRecurrences as CR
    for (R, g) in ((1.4, [0.1, 0.3, 0.3, 0.2, 0.1]), (0.8, [0.2, 0.5, 0.3]))
        r = CR.growth_rate(R, g)
        h = CR.exponential_history(5.0, r, length(g))
        y = Recurrence(g)(fill(R, 20); history = h, prepend = true)
        @test y[2:end] ./ y[1:(end - 1)] ≈ fill(exp(r), length(y) - 1)
    end
end

@testitem "growth_rate: a delay with lags as a Recurrence takes it" setup = [DelayCases] begin
    for d in (Poisson(3.0), NegativeBinomial(4, 0.5))
        g = tail(d, 10)
        @test CR.growth_rate(1.3, d; lags = 10) ≈ CR.growth_rate(1.3, g)
        @test CR.reproduction_number(0.1, d; lags = 10) ≈
            CR.reproduction_number(0.1, g)
        k = Recurrence(d; lags = 10, step = 2).kernel
        @test CR.growth_rate(1.3, d; lags = 10, step = 2) ≈ CR.growth_rate(1.3, k)
    end
end

@testitem "growth_rate: errors say what is wrong" setup = [DelayCases] begin
    g = [0.2, 0.5, 0.3]
    @test_throws "R > 0; got R = 0.0" CR.growth_rate(0.0, g)
    @test_throws "R > 0; got R = -1.0" CR.growth_rate(-1.0, g)
    @test_throws "got R = Inf" CR.growth_rate(Inf, g)
    @test_throws "got R = NaN" CR.growth_rate(NaN, g)
    @test_throws "all 3 lags are zero" CR.growth_rate(1.5, zeros(3))
    @test_throws "all 3 lags are zero" CR.reproduction_number(0.1, zeros(3))
    @test_throws "it has no lags" CR.growth_rate(1.5, Float64[])
    @test_throws "non-negative masses; got -0.1 on lag 2" CR.growth_rate(
        1.5, [0.2, -0.1, 0.3]
    )
    @test_throws "got NaN on lag 1" CR.growth_rate(1.5, [NaN, 0.5])
    @test_throws "got Inf on lag 3" CR.reproduction_number(0.1, [0.2, 0.5, Inf])
    @test_throws "finite growth rate r; got r = Inf" CR.reproduction_number(Inf, g)
    @test_throws "got 1×2 Matrix" CR.growth_rate(1.5, [0.2 0.3])
    @test_throws "got PerStratum" CR.reproduction_number(0.1, PerStratum([0.2 0.3]))
    @test_throws "needs `lags`" CR.growth_rate(1.5, Poisson(3.0))
    @test_throws "holds no delays" CR.growth_rate(1.5, g; lags = 3)
    @test_throws "step sets the width" CR.growth_rate(1.5, g; step = 2)
end

@testitem "growth_rate: derivatives from the implicit function theorem" setup = [ReferenceAD] begin
    using ComposableRecurrences: ComposableRecurrences as CR
    for g in ([0.1, 0.3, 0.3, 0.2, 0.1], [0.0, 0.4, 0.6, 0.0])
        R = 1.5
        r = CR.growth_rate(R, g)
        e = exp.(-r .* eachindex(g))
        τ = R * sum(eachindex(g) .* g .* e)
        @test ReferenceAD.derivative(x -> CR.growth_rate(x, g), R) ≈ 1 / (R * τ)
        # Lags without mass have a derivative too.
        @test ReferenceAD.gradient(x -> CR.growth_rate(R, x), g) ≈ R .* e ./ τ
        # The inverse: dR/dr = R τ and dR/dg_l = -R² e^{-r l}.
        @test ReferenceAD.derivative(x -> CR.reproduction_number(x, g), r) ≈
            R * τ
        @test ReferenceAD.gradient(x -> CR.reproduction_number(r, x), g) ≈
            -R^2 .* e
    end
end

@testitem "growth_rate: second derivatives match differences of the first" setup = [ReferenceAD] begin
    using ComposableRecurrences: ComposableRecurrences as CR
    using ForwardDiff
    # The first derivative from the implicit function theorem.
    function ift(θ)
        R, g = θ[1], θ[2:end]
        r = CR.growth_rate(R, g)
        e = exp.(-r .* eachindex(g))
        τ = R * sum(eachindex(g) .* g .* e)
        return [1 / (R * τ); R .* e ./ τ]
    end
    f(θ) = CR.growth_rate(θ[1], θ[2:end])
    h = 1.0e-5
    for θ in ([1.5, 0.1, 0.3, 0.3, 0.2, 0.1], [0.5, 0.01, 0.4, 0.6, 0.01])
        n = length(θ)
        δ(j) = h .* (1:n .== j)
        H = reduce(hcat, [(ift(θ .+ δ(j)) .- ift(θ .- δ(j))) ./ 2h for j in 1:n])
        @test ForwardDiff.hessian(f, θ) ≈ H rtol = 1.0e-6
    end
end
