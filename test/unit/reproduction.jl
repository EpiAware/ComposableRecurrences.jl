# The reproduction number recovered from a run by composition: the output
# over its renewal sum, a `Convolution` with a zero on lag 0 over the
# output and the run's history, mixed by the coupling. Instantaneous R_t
# against the gain, effective R_t against the depletion's value, the first
# steps, zero denominators and the coupling.

@testmodule Reproduction begin
    using ComposableRecurrences

    # The renewal sum each step's output is drawn against, and the output
    # over it.
    force(y, g, h; coupling = 1) = coupling * Convolution(vcat(0, g))(y; history = h)
    reproduction(y, g, h; coupling = 1) = y ./ force(y, g, h; coupling)
    # The hazard form's effective value over the renewal sums `p`, from the
    # pools after each step: `R_t s_{t-1} / N` scaled by `(1 - e^{-λ}) / λ`.
    function depleted(R, p, pools, pop)
        s = hcat(pop, pools[:, 1:(end - 1)])
        λ = R .* p ./ pop
        return R .* s ./ pop .* -expm1.(-λ) ./ λ
    end

    const g = [0.05, 0.2, 0.3, 0.25, 0.12, 0.08]
    const T = 40
    const pop = [600.0, 250.0, 100.0]
    const dist = [0.0 20.0 45.0; 20.0 0.0 30.0; 45.0 30.0 0.0]
    const gravity = [a == b ? 0.0 : pop[b] / dist[a, b]^2 for a in 1:3, b in 1:3]
    const K = 0.9 * [a == b for a in 1:3, b in 1:3] +
        0.1 * gravity ./ sum(gravity; dims = 2)
    const R = [1.8 - clamp((t - 20) / 6, 0, 1) + 0.1 * k for k in 1:3, t in 1:T]
    const seed = [fill(2.0, 1, 6); zeros(2, 6)]
end

@testitem "Reproduction: instantaneous R_t recovers the gain" setup = [Reproduction] begin
    using ComposableRecurrences
    using .Reproduction: reproduction, g, R
    Rt = R[1, :]
    for h in ([3.0, 5.0, 4.0, 6.0, 2.0, 1.0, 7.0, 3.0], [1.0, 2.0], [5.0])
        y = Recurrence(g)(Rt; history = h)
        @test reproduction(y, g, h) ≈ Rt atol = 1.0e-12 rtol = 1.0e-12
    end
    # A per-stratum gain and kernel, without a coupling.
    G = [g'; reverse(g)'; fill(1 / 6, 1, 6)]
    h = 1.0 .+ [0.1 * (k + l) for k in 1:3, l in 1:4]
    y = Recurrence(PerStratum(G))(R; history = h)
    R̂ = Convolution(PerStratum(hcat(zeros(3), G)))(y; history = h)
    @test y ./ R̂ ≈ R atol = 1.0e-12 rtol = 1.0e-12
end

@testitem "Reproduction: the first steps need the history" setup = [Reproduction] begin
    using ComposableRecurrences
    using .Reproduction: g, R
    Rt = R[1, :]
    L = length(g)
    h = [3.0, 5.0, 4.0, 6.0, 2.0, 1.0, 7.0, 3.0]
    y = Recurrence(g)(Rt; history = h)
    # Without the history the renewal sum misses the seed until lag `L`
    # has passed it, then agrees.
    R̂ = y ./ Convolution(vcat(0, g))(y)
    @test all(R̂[1:L] .!= Rt[1:L])
    @test R̂[(L + 1):end] ≈ Rt[(L + 1):end] atol = 1.0e-12 rtol = 1.0e-12
    # The seed returned with the run gives the same renewal sum.
    yp = Recurrence(g)(Rt; history = h, prepend = true)
    m = length(h)
    R̂p = (yp ./ Convolution(vcat(0, g))(yp))[(m + 1):end]
    @test R̂p ≈ Rt atol = 1.0e-12 rtol = 1.0e-12
end

@testitem "Reproduction: a zero renewal sum gives no value" setup = [Reproduction] begin
    using ComposableRecurrences
    using .Reproduction: reproduction, g, R
    Rt = R[1, :]
    # No seed: every output and renewal sum is zero.
    y = Recurrence(g)(Rt; history = zeros(1))
    @test all(isnan, reproduction(y, g, zeros(1)))
    # A kernel on lag 3 alone: only every third step has a renewal sum.
    g3 = [0.0, 0.0, 1.0]
    y = Recurrence(g3)(Rt; history = [1.0])
    R̂ = reproduction(y, g3, [1.0])
    seeded = (1:length(Rt)) .% 3 .== 0
    @test all(isnan, R̂[.!seeded])
    @test R̂[seeded] ≈ Rt[seeded] atol = 1.0e-12 rtol = 1.0e-12
end

@testitem "Reproduction: per stratum with a coupling" setup = [Reproduction] begin
    using ComposableRecurrences
    using .Reproduction: reproduction, g, R, K, seed
    y = Recurrence(g; coupling = K)(R; history = seed)
    # The renewal sum includes the coupling: towns with no seed draw on
    # the seeded town from the first step.
    @test reproduction(y, g, seed; coupling = K) ≈ R atol = 1.0e-12 rtol = 1.0e-12
    # Without it the unseeded towns have no renewal sum on the first step.
    @test all(isinf, reproduction(y, g, seed)[2:3, 1])
end

@testitem "Reproduction: effective R_t under depletion" setup = [Reproduction] begin
    using ComposableRecurrences
    using ComposableRecurrences: Depletion, Add
    using .Reproduction: reproduction, force, depleted, g, T, R, K, pop, seed
    S = length(pop)
    r = Recurrence(g; coupling = K, modifiers = (Depletion(PerStratum(pop)),))
    y, tr = r(R; history = seed, trace = true)
    M = only(tr.modifiers)
    # The trace holds the pools after each step, then the drawn values.
    @test M[(S + 1):(2S), :] ≈ y
    p = force(y, g, seed; coupling = K)
    R̂ = reproduction(y, g, seed; coupling = K)
    @test R̂ ≈ depleted(R, p, M[1:S, :], pop) atol = 1.0e-12 rtol = 1.0e-12
    @test all(R̂ .< R)
    # Imports added after the depletion change the output the next steps
    # read, but not what is drawn: the drawn values over the renewal sum
    # still give the depleted value.
    ι = [t <= 5 ? 1.0 : 0.0 for _ in 1:S, t in 1:T]
    imports = Add(TimeVarying(PerStratum(ι)))
    ra = Recurrence(g; coupling = K, modifiers = (Depletion(PerStratum(pop)), imports))
    ya, tra = ra(R; history = seed, trace = true)
    Ma = first(tra.modifiers)
    drawn = Ma[(S + 1):(2S), :]
    @test ya ≈ drawn .+ ι
    pa = force(ya, g, seed; coupling = K)
    R̂a = drawn ./ pa
    @test R̂a ≈ depleted(R, pa, Ma[1:S, :], pop) atol = 1.0e-12 rtol = 1.0e-12
end
