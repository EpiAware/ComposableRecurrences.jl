# # [The reproduction number from a run](@id tutorial-reproduction-number)
#
# ## Introduction
#
# A renewal multiplies the sum each day draws against by its reproduction number.
# [`pressure`](@ref ComposableRecurrences.pressure) recomputes that sum from a run's output:
#
# ```math
# q_{t,i} = \sum_{j} K_{ij} \sum_{l=1}^{L} g_l \, I_{t-l,j},
# ```
#
# where ``I_{t,i}`` is the infections of stratum ``i`` on day ``t``, ``g_l`` the generation interval on lag ``l`` and ``K`` the coupling.
# The ratio ``\hat R_{t,i} = I_{t,i} / q_{t,i}`` recovers the reproduction number.
# Without modifiers it is the gain, the instantaneous reproduction number.
# With depletion it is the effective reproduction number.
#
# ### What are we going to do in this exercise
#
# 1. Recover the gain from a run of the one-town model in [Getting started](@ref overview-build).
# 2. Recover the effective reproduction number from the same model with a susceptible pool.
#
# ### What might I need to know before starting
#
# It builds on the [Getting started](@ref getting-started) example, with no fitting.

# ## Packages used

using ComposableRecurrences
using ComposableRecurrences: Depletion, pressure
using CairoMakie, AlgebraOfGraphics, DataFramesMeta

CairoMakie.activate!(type = "png", px_per_unit = 2)

# ## The instantaneous reproduction number
#
# The one-town renewal of [Getting started](@ref overview-build), with its intervention from day 50.
# Passing the run's `history` gives the first ``L`` days the seed terms they need.

gi = [0.05, 0.2, 0.3, 0.25, 0.12, 0.08]
T = 75
R = [1.8 - clamp((t - 50) / 6, 0, 1) for t in 1:T]
seed = fill(10.0, 6)
renewal = Recurrence(gi)
infections = renewal(R; history = seed)
maximum(abs, infections ./ pressure(renewal, infections; history = seed) .- R)

# The ratio recovers the gain to round-off.
# Where the pressure is zero, as in a stratum no infection has reached, the ratio is `NaN` with no infections and `Inf` otherwise.
# With strata the pressure includes the coupling, for any kernel and coupling a [`Recurrence`](@ref) takes.

# ## The effective reproduction number
#
# A pool of ``N`` susceptibles, ``s_t`` after day ``t``, depleted by the hazard form of [Getting started](@ref overview-build), draws
#
# ```math
# I_t = s_{t-1} \big(1 - e^{-\lambda_t}\big), \qquad \lambda_t = \frac{R_t q_t}{N},
# \qquad \text{so} \qquad
# \hat R_t = R_t \, \frac{s_{t-1}}{N} \, \frac{1 - e^{-\lambda_t}}{\lambda_t}.
# ```
#
# A call with `trace = true` also returns each modifier's [`Trace`](@ref ComposableRecurrences.Trace); for `Depletion` its first row is the pool after each day.

N = 60_000.0
depleted = Recurrence(gi; modifiers = (Depletion(N),))
y, tr = depleted(R; history = seed, trace = true)
q = pressure(depleted, y; history = seed)
R_eff = y ./ q
pool = [N; only(tr.modifiers)[1, 1:(end - 1)]]
λ = R .* q ./ N
maximum(abs, R_eff .- R .* pool ./ N .* -expm1.(-λ) ./ λ)

#-

@chain DataFrame(day = 1:T, Gain = R, Effective = R_eff) begin
    stack(Not(:day); variable_name = :series, value_name = :R)
    data(_) * mapping(:day, :R => "Reproduction number", color = :series => "") *
        visual(Lines, linewidth = 2)
    draw(_; axis = (xlabel = "Day",))
end

# The effective reproduction number falls below the gain as the pool runs down.
# It falls below 1 on this day, before the intervention on day 50:

findfirst(<(1), R_eff)

# Imports ``\iota_t`` added after the depletion by `Add` are not multiplied by the gain.
# With them, ``(I_t - \iota_t) / q_t`` is the effective reproduction number.
# An `add` input enters before the depletion and is drawn with the rest, so the ratio then includes its share.

# ## Learning more
#
# - [Renewal then delay](@ref tutorial-renewal-delay) adds vaccination, imports and clinical outcomes to the renewal.
# - [Spatial models](@ref tutorial-spatial-strata) builds the couplings the pressure mixes.
