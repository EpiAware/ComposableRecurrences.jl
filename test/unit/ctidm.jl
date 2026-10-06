# The operators reproduce the ComposableTuringIDModels `accumulate_scan`
# steps, run from a verbatim copy of their code (ctidm_steps.jl).

@testitem "CTIDM: random walk and AR" begin
    using ComposableRecurrences, Random
    include(joinpath(@__DIR__, "ctidm_steps.jl"))
    rng = Xoshiro(31)
    T = 15
    ϵ = randn(rng, T)
    ref = CTIDM.accumulate_scan(CTIDM.RWStep(), 0.3, ϵ)
    @test Recurrence([1.0])(1.0; history = [0.3], add = ϵ, prepend = true) ≈ ref

    damp = [0.1, -0.2, 0.6]
    w0 = randn(rng, 3)
    ref = CTIDM.accumulate_scan(
        CTIDM.ARStep(damp), (; val = 0.0, window = w0), ϵ
    )
    # CTIDM's AR coefficients are oldest first.
    @test Recurrence(reverse(damp))(1.0; history = w0, add = ϵ, prepend = true) ≈ ref
end

@testitem "CTIDM: delay as a convolution" begin
    using ComposableRecurrences, Random
    include(joinpath(@__DIR__, "ctidm_steps.jl"))
    rng = Xoshiro(32)
    L, T = 6, 20
    rev_pmf = rand(rng, L)
    w0 = rand(rng, L)
    ϵ = rand(rng, T)
    ref = CTIDM.accumulate_scan(
        CTIDM.LDStep(rev_pmf), (; val = 0.0, current = w0), ϵ
    )
    # `rev_pmf` is oldest first over lags 1:L; the lag-first kernel with no
    # weight on lag 0 is its reverse.
    y = Convolution([0.0; reverse(rev_pmf)])(ϵ; history = w0)
    @test y ≈ ref
end

@testitem "CTIDM: renewal" begin
    using ComposableRecurrences, Random
    include(joinpath(@__DIR__, "ctidm_steps.jl"))
    rng = Xoshiro(33)
    L, T = 7, 30
    g = reverse(exp.(-0.3 .* (1:L)) ./ sum(exp.(-0.3 .* (1:L))))  # CTIDM: oldest first
    w0 = fill(10.0, L)
    R = exp.(0.1 .* randn(rng, T))
    ref = CTIDM.accumulate_scan(
        CTIDM.ConstantRenewalStep(g), (; val = last(w0), window = w0), R
    )
    @test Recurrence(reverse(g))(R; history = w0) ≈ ref
end

@testitem "CTIDM: renewal with mixing and depletion" setup = [TestModifiers] begin
    using ComposableRecurrences, LinearAlgebra, Random
    include(joinpath(@__DIR__, "ctidm_steps.jl"))
    rng = Xoshiro(34)
    S, L, T = 4, 6, 40
    g = reverse(exp.(-0.3 .* (1:L)) ./ sum(exp.(-0.3 .* (1:L))))  # CTIDM: oldest first
    K = 0.8I(S) .+ 0.2 / S .* ones(S, S)
    pop = [1.0e3, 5.0e3, 2.0e3, 800.0]
    w0 = 5 .* rand(rng, S, L)
    R = 1.2 .+ 0.3 .* rand(rng, S, T)
    step = CTIDM.RenewalStep(
        CTIDM.ConstantRenewalStep(g, K), (CTIDM.SusceptibleDepletion(pop),)
    )
    init = (; val = w0[:, end], window = w0, substates = (copy(pop),))
    ref = CTIDM.accumulate_scan(step, init, CTIDM._steps(R))
    r = Recurrence(reverse(g); coupling = K, modifiers = (FlooredDepletion(pop),))
    @test r(R; history = w0) ≈ ref

    # Without depletion: the constant step with mixing.
    ref = CTIDM.accumulate_scan(
        CTIDM.ConstantRenewalStep(g, K), (; val = w0[:, end], window = w0),
        CTIDM._steps(R)
    )
    @test Recurrence(reverse(g); coupling = K)(R; history = w0) ≈ ref
end
