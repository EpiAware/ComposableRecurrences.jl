@testitem "growth_rate: roots of the Euler–Lotka equation" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    g = [0.2, 0.5, 0.3]
    @test CR.growth_rate(1.0, g) ≈ 0 atol = 1.0e-14
    @test CR.growth_rate(2.0, [1.0]) ≈ log(2.0)
    kernels = ([0.2, 0.5, 0.3], [0.05, 0.2, 0.3, 0.25, 0.12, 0.08], [0.0, 0.1, 0.6, 0.3])
    for R in 0.3:0.3:3, k in kernels
        r = CR.growth_rate(R, k)
        @test abs(R * sum(k[l] * exp(-r * l) for l in eachindex(k)) - 1) < 1.0e-10
    end
    # Every float type converges to its own precision.
    for T in (Float32, Float16, BigFloat), R in 0.3:0.1:3, k in kernels
        r = CR.growth_rate(T(R), T.(k))
        @test r isa T
        res = T(R) * sum(T(k[l]) * exp(-r * l) for l in eachindex(k)) - 1
        @test abs(res) <= 4 * eps(T)
    end
    # Faster spread, faster growth; R below one shrinks.
    @test CR.growth_rate(1.5, g) > CR.growth_rate(1.2, g) > 0
    @test CR.growth_rate(0.8, g) < 0
    @test_throws ArgumentError CR.growth_rate(0.0, g)
    @test_throws ArgumentError CR.growth_rate(1.5, [0.5, -0.1])
    @test_throws ArgumentError CR.growth_rate(1.5, zeros(3))
    gr(R, g) = ComposableRecurrences.growth_rate(R, g)
    alloc(R, g) = (gr(R, g); @allocated gr(R, g))
    @test alloc(1.5, g) == 0 skip = Base.JLOptions().code_coverage != 0
end

@testitem "growth_rate: its derivative is the implicit one" begin
    using ComposableRecurrences
    using ForwardDiff
    CR = ComposableRecurrences
    R, g = 1.6, [0.05, 0.2, 0.3, 0.25, 0.12, 0.08]
    r = CR.growth_rate(R, g)
    E = [exp(-r * l) for l in eachindex(g)]
    A, B = sum(g .* E), sum(eachindex(g) .* g .* E)
    θ = vcat(R, g)
    ∇ = ForwardDiff.gradient(θ -> CR.growth_rate(θ[1], view(θ, 2:length(θ))), θ)
    @test ∇[1] ≈ A / (R * B)
    @test ∇[2:end] ≈ E ./ B
    # A dual R with a plain kernel takes the same step.
    @test ForwardDiff.derivative(R -> CR.growth_rate(R, g), R) ≈ A / (R * B)
end
