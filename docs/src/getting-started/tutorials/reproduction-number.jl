# # [The reproduction number from a run](@id tutorial-reproduction-number)
#
# ## Introduction
#
# A renewal multiplies the sum each day draws against by its reproduction number.
# The function [`pressure`](@ref ComposableRecurrences.pressure) recomputes that sum from a run's output:
#
# ```math
# q_{t,i} = \sum_{j} K_{t,ij} \sum_{l=1}^{L} g_l \, I_{t-l,j},
# ```
#
# where ``I_{t,i}`` is the infections of stratum ``i`` on day ``t``, ``g_l`` the generation interval on lag ``l`` and ``K_t`` the coupling.
# The ratio ``\hat R_{t,i} = I_{t,i} / q_{t,i}`` recovers the reproduction number.
# Without modifiers it is the gain ``\gamma_t``, the instantaneous reproduction number.
# With depletion it is the effective reproduction number.
# It builds on the [Getting started](@ref getting-started) example.

# ## Packages used

using ComposableRecurrences
using ComposableRecurrences: Depletion, pressure
using CairoMakie, AlgebraOfGraphics, DataFramesMeta

CairoMakie.activate!(type = "png", px_per_unit = 2)

# ## The instantaneous reproduction number
#
# The one-town renewal of [Getting started](@ref overview-build), with its intervention from day 50:
#
# ```math
# I_t = \gamma_t \sum_{l=1}^{L} g_l \, I_{t-l}, \qquad
# \gamma_t = R_t = 1.8 - \min\Big(\max\Big(\frac{t - 50}{6},\ 0\Big),\ 1\Big).
# ```
#
# ``I_t`` is the number of infections on day ``t`` and ``g_l`` the generation interval on lag ``l``, with ``L = 6`` lags.
# ``R_t`` is the reproduction number, the gain ``\gamma_t``.
# It is 1.8 up to day 50 and falls in equal steps to 0.8 on day 56.
# The run starts from ten infections on each of the six days before day 1.
# Passing the run's `history` to `pressure` gives the first ``L`` days the seed terms they need.

gi = [0.05, 0.2, 0.3, 0.25, 0.12, 0.08]
T = 75
R = [1.8 - clamp((t - 50) / 6, 0, 1) for t in 1:T]
seed = fill(10.0, 6)
renewal = Recurrence(gi)
infections = renewal(R; history = seed)
R_hat = infections ./ pressure(renewal, infections; history = seed)

@chain DataFrame(day = 1:T, value = R, series = "Gain") begin
    data(_) * mapping(:day, :value => "Reproduction number", color = :series => "") *
        visual(Lines, linewidth = 2)
    _ + data(DataFrame(day = 1:T, value = R_hat, series = "Infections / pressure")) *
        mapping(:day, :value => "Reproduction number", color = :series => "") *
        visual(Scatter, markersize = 6)
    draw(_; axis = (xlabel = "Day",))
end

# The ratio recovers the gain to round-off on every day.
# Where the pressure is zero, as in a stratum no infection has reached, the ratio is `NaN` with no infections and `Inf` otherwise.
# With strata the pressure includes the coupling, for any kernel and coupling a [`Recurrence`](@ref) takes.

# ## The effective reproduction number
#
# A pool of ``N`` susceptibles, ``s_t`` after day ``t``, depleted by the [hazard form](@ref ComposableRecurrences.Hazard), draws
#
# ```math
# I_t = s_{t-1} \big(1 - e^{-\lambda_t}\big), \qquad \lambda_t = \frac{\gamma_t q_t}{N},
# \qquad \text{so} \qquad
# \hat R_t = \frac{I_t}{q_t} = \gamma_t \, \frac{s_{t-1}}{N} \, \frac{1 - e^{-\lambda_t}}{\lambda_t}.
# ```
#
# ``q_t = \sum_l g_l I_{t-l}`` is the pressure and ``\lambda_t`` the hazard on day ``t``.
# ``N = 60000`` is the town's population, and the pool starts there, ``s_0 = N``.
# The gain ``\gamma_t = R_t`` is the one above, and the [`Depletion`](@ref ComposableRecurrences.Depletion) is the only modifier.
# A call with `trace = true` also returns each modifier's [`Trace`](@ref ComposableRecurrences.Trace).
# For a `Depletion` its first row is the pool after each day, which gives ``s_{t-1}``.

N = 60_000.0
depleted = Recurrence(gi; modifiers = (Depletion(N),))
y, tr = depleted(R; history = seed, trace = true)
q = pressure(depleted, y; history = seed)
R_eff = y ./ q
pool = [N; only(tr.modifiers)[1, 1:(end - 1)]]
λ = R .* q ./ N
@assert R_eff ≈ R .* pool ./ N .* -expm1.(-λ) ./ λ

@chain DataFrame(day = 1:T, Gain = R, Effective = R_eff) begin
    stack(Not(:day); variable_name = :series, value_name = :R)
    data(_) * mapping(:day, :R => "Reproduction number", color = :series => "") *
        visual(Lines, linewidth = 2)
    draw(_; axis = (xlabel = "Day",))
end

# The effective reproduction number matches the hazard formula above to round-off.
# It falls below the gain as the pool runs down.
# It falls below 1 on day 38, two days after infections peak and before the intervention on day 50.
# After day 75 the pool holds 28% of the town.
#
# Imports ``\iota_t`` added after the depletion by `Add` are not multiplied by the gain.
# With them, ``(I_t - \iota_t) / q_t`` is the effective reproduction number.
# An `add` input enters before the depletion and is drawn with the rest, so the ratio then includes its share.

# ## Performance
#
# Each bar times the effective reproduction number of the three towns of [Getting started](@ref overview-build), with depletion, over 200 days with a 20-day generation interval, written with the operators or as a preallocated hand-written loop.

include(joinpath(pkgdir(ComposableRecurrences), "docs", "performance.jl")) #hide
performance_plot("reproduction number")

# ## Learning more
#
# - [Vaccination](@ref tutorial-vaccination), [imported cases](@ref tutorial-imports) and [clinical outcomes](@ref tutorial-clinical-outcomes) extend the renewal.
# - [Spatial models](@ref tutorial-spatial-strata) builds the couplings the pressure mixes.
