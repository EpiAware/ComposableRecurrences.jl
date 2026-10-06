# Mass vaccination in expectation. EpiBranch.jl's `VaccineEffect` gives a
# dose an `efficacy` e under `LeakyMode` (each exposure of a vaccinated
# person is blocked with probability e) or `AllOrNothingMode` (a fraction e
# of recipients respond and are fully protected);
# src/interventions/vaccination.jl at cdfbb338. Over a population these are
# transfers of susceptibles into a protected pool:
#
#   all-or-nothing: e ⋅ doses leave the susceptible pool, σ = 0;
#   leaky:          doses move to a pool with relative susceptibility 1 - e.
#
# With unprotected S, protected V and a hazard draw from P = S + σ V,
#   y = P (1 - exp(-v / N)),  S ← S - y S / P - m,  V ← V - y σ V / P + m,
# and m = min(r_t, S) the doses taken up.

@testitem "Use case: all-or-nothing and leaky vaccination" tags = [:usecase] begin
    using ComposableRecurrences, ForwardDiff
    CR = ComposableRecurrences

    g = [0.1, 0.3, 0.3, 0.2, 0.1]
    N, T, e = 10_000.0, 60, 0.8
    seed = [5.0, 8.0, 12.0]
    R = [2.2 - 0.4 * (t > 30) for t in 1:T]
    doses = [t < 10 ? 0.0 : 150.0 for t in 1:T]
    pool0 = N - sum(seed)

    # The two pools written out.
    function naive(R, doses, σ, r)
        L = length(g)
        y = zeros(promote_type(eltype(R), eltype(r), typeof(σ)), T)
        y[1:3] .= seed
        S, V = pool0, zero(eltype(y))
        for t in 4:T
            v = R[t] * sum(g[i] * y[t - i] for i in 1:L if t - i >= 1)
            P = S + σ * V
            y[t] = P * (1 - exp(-v / N))
            if P > 0
                S, V = S - y[t] * S / P, V - y[t] * σ * V / P
            else
                S -= y[t]
            end
            m = min(r[t], max(S, 0))
            S, V = S - m, V + m
        end
        return y
    end
    vaccinated(σ, r) = CR.Depletion(
        N; pool0, removals = TimeVarying(r), protected = CR.Protected(σ)
    )
    model(R, d) = CR.seeded(Recurrence(g; modifiers = (d,)), R; history = seed)

    aon(e, doses) = vaccinated(0.0, e .* doses)
    leaky(e, doses) = vaccinated(1 - e, doses)
    @test model(R, aon(e, doses)) ≈ naive(R, doses, 0.0, e .* doses)
    @test model(R, leaky(e, doses)) ≈ naive(R, doses, 1 - e, doses)
    for arm in (aon, leaky)
        f(θ) = sum(model(R, arm(θ[1], θ[2:end])))
        σ(θ) = arm === aon ? 0.0 : 1 - θ[1]
        r(θ) = arm === aon ? θ[1] .* θ[2:end] : θ[2:end]
        fref(θ) = sum(naive(R, θ[2:end], σ(θ), r(θ)))
        θ = vcat(e, doses)
        @test ForwardDiff.gradient(f, θ) ≈ ForwardDiff.gradient(fref, θ)
    end

    # All-or-nothing never draws from the protected pool, so it equals the
    # removals alone leaving the pool.
    @test model(R, aon(e, doses)) ≈
        model(R, CR.Depletion(N; pool0, removals = TimeVarying(e .* doses)))
    # At the same efficacy all-or-nothing protects more than leaky, and both
    # more than no vaccination.
    final(d) = sum(model(R, d))
    @test final(aon(e, doses)) < final(leaky(e, doses)) <
        final(CR.Depletion(N; pool0))
end

# The same two vaccines against seeded stochastic simulations of
# EpiBranch.jl's `HomogeneousProcess`, a continuous-time SIR model, in
# `references/epibranch_homogeneous.jl`. A share of the population is
# vaccinated before the outbreak, so the protected pool starts full and
# there are no removals. With an infectious period of mean D the SIR
# generation interval is Exponential with mean D, binned by day here. The
# hazard form leaves an unprotected share exp(-Λ) uninfected, with Λ the
# cumulative force of infection, which is the SIR final-size relation, so
# the final sizes should match whatever the binning.
@testitem "Use case: vaccination against a seeded HomogeneousProcess" tags = [:usecase] setup = [UseCaseReferences] begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    E = UseCaseReferences.EpiBranchHomogeneousReference

    N, n0 = float(E.N), E.N_INITIAL
    c, e, D = E.COVERAGE, E.EFFICACY, E.INFECTIOUS_PERIOD
    g = [exp(-(i - 1) / D) - exp(-i / D) for i in 1:120]
    g ./= sum(g)
    R = fill(E.R0, 400)
    # The simulation picks its index cases at random, so in expectation they
    # come from each pool in proportion to its size.
    rest = N - n0
    attack(x∞, x0) = 1 - (1 - n0 / N) * x∞ / x0
    function final_size(σ, protected0)
        d = CR.Depletion(
            N; pool0 = rest - protected0,
            protected = CR.Protected(σ; pool0 = protected0)
        )
        y, state = CR.with_state(
            Recurrence(g; modifiers = (d,)), R; history = [float(n0)]
        )
        u∞, w∞ = state.states[1]
        @test y[end] < 1.0e-6
        return (;
            total = (n0 + sum(y)) / N,
            unvaccinated = attack(u∞, rest - protected0),
            protected = attack(w∞, protected0),
        )
    end

    none = final_size(1.0, 0.0)
    # All-or-nothing: responders are never infected and non-responders
    # share the unprotected pool, so the vaccinated attack rate mixes the
    # two (plus responders picked as index cases).
    aon = final_size(0.0, c * e * rest)
    aon_vaccinated = (1 - e) * aon.unvaccinated + e * n0 / N
    leaky = final_size(1 - e, c * rest)

    # The reference is fixed by its seeds, so this test is deterministic.
    # Four standard errors of the simulation means covers their Monte Carlo
    # error; the gaps from the daily step, the finite population and the
    # proportional draw from the two pools are all below one standard
    # error at these settings.
    close(x, ref) = abs(x - ref.mean) <= 4 * ref.se
    @test close(none.total, E.NONE.total)
    @test close(none.unvaccinated, E.NONE.unvaccinated)
    @test close(none.unvaccinated, E.NONE.vaccinated)
    @test close(aon.total, E.ALL_OR_NOTHING.total)
    @test close(aon.unvaccinated, E.ALL_OR_NOTHING.unvaccinated)
    @test close(aon_vaccinated, E.ALL_OR_NOTHING.vaccinated)
    @test close(leaky.total, E.LEAKY.total)
    @test close(leaky.unvaccinated, E.LEAKY.unvaccinated)
    @test close(leaky.protected, E.LEAKY.vaccinated)
    # The tolerance is tight enough to tell the two vaccines apart.
    @test !close(aon.total, E.LEAKY.total)
    @test !close(leaky.total, E.ALL_OR_NOTHING.total)
end
