# The ComposableTuringIDModels.jl step code used as the reference for the
# use-case tests, with drivers that call it.
#
# The step code is `test/ADFixtures/src/ctidm_steps.jl`, a frozen copy of
# ComposableTuringIDModels at commit f7d6cc9f that the benchmark matrix
# shares; it is not kept in step with that package's `main`, which has
# since changed `renewal_init_state` and the ARIMA body the `arima` driver
# follows. The drivers below are not copied: each wraps the
# `accumulate_scan` call or expression of the cited model body so it can be
# called without `DynamicPPL`.
module CTIDMReference

using LinearAlgebra

include(joinpath(@__DIR__, "..", "..", "ADFixtures", "src", "ctidm_steps.jl"))

# --- drivers (not copied) ----------------------------------------------------
#
# Each driver is the `accumulate_scan` call of the cited model body, with the
# sampled quantities passed in as arguments.

# src/latent_models/models/RandomWalk.jl L46
random_walk(init, ϵ_t) = accumulate_scan(RWStep(), init, ϵ_t)

# src/latent_models/models/AR.jl L138-140 (order p > 1)
function ar(damp_AR, ar_init, ϵ_t)
    return accumulate_scan(
        ARStep(reverse(damp_AR)), (; val = last(ar_init), window = ar_init), ϵ_t
    )
end

# src/latent_models/models/AR.jl L125-128 (order 1, time-varying coefficient)
function tvar(ρ, ar_init, ϵ_t)
    n = length(ϵ_t) + 1
    return accumulate_scan(TVARStep(ρ), ar_init, collect(zip(1:(n - 1), ϵ_t)))
end

# src/latent_models/models/MA.jl L77-79 (order q > 1)
function ma(θ, ϵ_t)
    q = length(θ)
    return accumulate_scan(
        MAStep(θ), (; val = 0.0, state = reverse(ϵ_t[1:q])), ϵ_t[(q + 1):end]
    )
end

# src/observation_models/modifiers/LatentDelay.jl L357-372 (fixed pmf)
function latent_delay(pmf, Y_t)
    rev_pmf = reverse(pmf)
    d = length(rev_pmf)
    return accumulate_scan(
        LDStep(rev_pmf), (; val = 0, current = Y_t[1:d]),
        vcat(Y_t[(d + 1):end], 0.0)
    )
end

# src/observation_models/modifiers/LatentDelay.jl L336-356 (one pmf per time)
function time_varying_latent_delay(pmfs, Y_t)
    rev_pmfs = reverse.(pmfs)
    d = length(first(rev_pmfs))
    return accumulate_scan(
        TimeVaryingLDStep(), (; val = 0, current = Y_t[1:d]),
        collect(zip(vcat(Y_t[(d + 1):end], 0.0), rev_pmfs[d:end]))
    )
end

# src/infection_models/Renewal.jl L248-251 and L287-289, with the growth rate
# `r` of the initial window given rather than solved from R_0.
function renewal(step, gen_int, I₀, r, Rt)
    init = renewal_init_state(step, I₀, r, _n_lags(gen_int))
    return accumulate_scan(step, init, _steps(Rt))
end

# A renewal whose mixing matrix changes each step: the copied
# `ConstantRenewalStep` rebuilt with `Ks[:, :, t]` at step `t`.
function time_varying_mixing_renewal(rev_gen_int, Ks, window, Rt)
    state = (; val = _newest(window), window = window)
    out = map(axes(Rt, 2)) do t
        state = ConstantRenewalStep(rev_gen_int, Ks[:, :, t])(state, Rt[:, t])
        state.val
    end
    return _series(out)
end

# src/latent_models/models/MA.jl L70 (order 1, a coefficient path)
ma1(θ, ϵ_t) = vcat(ϵ_t[1], ϵ_t[2:end] .+ θ .* ϵ_t[1:(end - 1)])

# src/latent_models/combinations/arma.jl and arima.jl: an AR whose
# innovations are an MA, differenced `d` times (DiffLatentModel.jl L61-L66).
function arima(damp, ar_init, θ, ϵ_t, diff_init)
    return _combine_diff(diff_init, ar(damp, ar_init, ma(θ, ϵ_t)), length(diff_init))
end

# src/infection_models/ExpGrowthRate.jl L85, with the identity transformation
# so the log incidence is returned.
exp_growth(I₀, Z_t) = I₀ .+ _cumsum(Z_t)

# src/observation_models/modifiers/Aggregate.jl L113-L137, the window sums
# alone for a `y_t` as long as `Y_t` (no offset).
function aggregate(aggregation, Y_t)
    idx = findall(aggregation .!= 0)
    return map(i -> sum(Y_t[max(1, i - aggregation[i] + 1):i]), idx)
end

end
