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
# and m = min(r_t, S) the doses taken up (EpiAware/ComposableRecurrences#9).

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
