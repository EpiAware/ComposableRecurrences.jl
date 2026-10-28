# # [Renewal then delay](@id tutorial-renewal-delay)
#
# ## Introduction
#
# [Getting started](@ref overview-build) builds a renewal process with a reporting delay.
# Here the reproduction number changes over time, the seed grows from the first day and the population is finite.
# It builds on the [Getting started](@ref getting-started) example.

# ## Packages used

using ComposableRecurrences
using ComposableRecurrences: Depletion, Floor, exponential_history, growth_rate
using CairoMakie, AlgebraOfGraphics, DataFramesMeta

CairoMakie.activate!(type = "png", px_per_unit = 2)

# ## A renewal process
#
# New infections are a weighted sum of earlier infections:
#
# ```math
# I_t = R_t \sum_{l=1}^{L} g_l \, I_{t-l}, \qquad
# R_t = \begin{cases} 1.4, & t \le 30, \\ 0.9, & 30 < t \le 50, \\ 1.2, & t > 50, \end{cases}
# ```
#
# where ``I_t`` is the number of infections on day ``t`` and ``R_t`` the reproduction number, the gain of the [`Recurrence`](@ref).
# ``g_l`` is the generation interval's weight on lag ``l``, and ``L = 5`` is its length.
# The history is one day of 5 infections before day 1.

gi = [0.1, 0.3, 0.3, 0.2, 0.1]
renewal = Recurrence(gi)
T = 80
R = [t <= 30 ? 1.4 : t <= 50 ? 0.9 : 1.2 for t in 1:T]
infections = renewal(R; history = [5.0])

@chain DataFrame(day = 1:T, count = infections) begin
    data(_) * mapping(:day, :count) * visual(Lines, linewidth = 2)
    draw(_; axis = (xlabel = "Day", ylabel = "Infections"))
end

# Infections grow while ``R_t`` is above one and fall while it is below one.

# ### Seeding on a growth path
#
# A single seed day makes the first generations uneven.
# A [seed](@ref explanation-seeding) already growing at rate ``r`` avoids this:
#
# ```math
# h_l = I_0 \, e^{r (l - L)}, \quad l = 1, \dots, L, \qquad
# 1 = R_1 \sum_{l=1}^{L} g_l \, e^{-r l},
# ```
#
# where ``h_l`` is the seed on the ``l``-th of the ``L`` days before day 1 and ``I_0`` the seed on the last of them.
# The second equation links the growth rate ``r`` to the reproduction number ``R_1`` for the generation interval.
# [`growth_rate`](@ref ComposableRecurrences.growth_rate) solves it for ``r``, and [`exponential_history`](@ref ComposableRecurrences.exponential_history) builds the seed.

r0 = growth_rate(R[1], gi)
h0 = exponential_history(5.0, r0, length(gi))
seeded = vcat(h0, renewal(R; history = h0))
single = vcat(5.0, renewal(R; history = [5.0]))
## The ratio of each day's infections to the day before's, on days 1 to 25.
ratio(y) = (y[2:end] ./ y[1:(end - 1)])[(end - T + 1):(end - T + 25)]

@chain DataFrame("day" => 1:25, "Growing seed" => ratio(seeded), "Single seed day" => ratio(single)) begin
    stack(Not(:day); variable_name = :seed, value_name = :ratio)
    data(_) * mapping(:day, :ratio, color = :seed => "") * visual(Lines, linewidth = 2) +
        mapping([exp(r0)]) * visual(HLines, color = :grey, linestyle = :dash)
    draw(_; axis = (xlabel = "Day", ylabel = "Daily growth ratio", limits = (nothing, (0, 2))))
end

# The dashed line is ``e^{r}``.
# With the growing seed the daily growth ratio is ``e^{r}`` from day 1 until ``R_t`` changes.
# With a single seed day the ratio swings for the first generations.

# ## Susceptible depletion
#
# A finite population of ``N`` susceptibles limits the outbreak.
# A [`Depletion`](@ref ComposableRecurrences.Depletion) draws each day's infections from the pool ``S_t`` left:
#
# ```math
# v_t = R_t \sum_{l=1}^{L} g_l \, I_{t-l}, \qquad
# I_t = \begin{cases}
#   S_{t-1} \big(1 - e^{-v_t / N}\big) & \text{hazard form,} \\
#   v_t \max\big(S_{t-1} / N,\ 10^{-6}\big) & \text{floored form,}
# \end{cases} \qquad
# S_t = S_{t-1} - I_t,
# ```
#
# where ``v_t`` is the number of new infections before depletion and ``S_0 = N``.
# `Depletion(N)` takes the [hazard form](@ref ComposableRecurrences.Hazard), and `Depletion(N, Floor())` the [floored form](@ref ComposableRecurrences.Floor).
# Here ``N`` is 2000 and ``R_t`` is 1.8 on every day.

N = 2_000.0
R_high = fill(1.8, T)
run_with(d) = Recurrence(gi; modifiers = (d,))(R_high; history = [5.0])
forms = ["Hazard" => Depletion(N), "Floor" => Depletion(N, Floor())]

@chain forms begin
    map(((name, d),) -> DataFrame(day = 1:T, form = name, count = run_with(d)), _)
    reduce(vcat, _)
    @groupby(:form)
    @transform(:susceptible = N .- cumsum(:count))
    stack([:count, :susceptible]; variable_name = :quantity, value_name = :value)
    @transform(:quantity = ifelse.(:quantity .== "count", "Infections", "Susceptibles"))
    data(_) * mapping(:day, :value, color = :form => "", row = :quantity) *
        visual(Lines, linewidth = 2)
    draw(_; axis = (xlabel = "Day", ylabel = ""), facet = (; linkyaxes = :none))
end

# Both forms end the outbreak as the pool empties.
# The hazard form draws slightly less at the peak and leaves more susceptibles.
# This is because ``1 - e^{-x}`` is below ``x``, so the hazard form draws less than the floored form from the same pool.

# ## Reported cases
#
# Reports are a share ``\rho`` of the depleted infections, recorded after a delay:
#
# ```math
# C_t = \rho \sum_{l=0}^{L_w - 1} w_l \, I_{t-l},
# ```
#
# where ``C_t`` is the number of reports on day ``t`` and ``w_l`` the delay's weight on lag ``l``.
# ``\rho`` is the gain of the [`Convolution`](@ref).
# Here ``\rho`` is 0.4.

infections_depleted = run_with(Depletion(N))
delay = Convolution([0.0, 0.1, 0.25, 0.3, 0.2, 0.1, 0.05])
reports = delay(infections_depleted; gain = 0.4)

@chain DataFrame("day" => 1:T, "Infections" => infections_depleted, "Reports" => reports) begin
    stack(Not(:day); variable_name = :series, value_name = :count)
    data(_) * mapping(:day, :count, color = :series => "") * visual(Lines, linewidth = 2)
    draw(_; axis = (xlabel = "Day", ylabel = "Count"))
end

# Reports peak three days after infections, at about 40% of their height.

# ## Performance
#
# Each bar times a seeded renewal with hazard depletion over 200 days with a 20-day generation interval, written with the operators or as a preallocated hand-written loop.

include(joinpath(pkgdir(ComposableRecurrences), "docs", "performance.jl")) #hide
performance_plot("renewal")

# ## Learning more
#
# - [Vaccination](@ref tutorial-vaccination), [imported cases](@ref tutorial-imports) and [clinical outcomes](@ref tutorial-clinical-outcomes) extend this model.
# - The [API overview](@ref api-overview) lists every operator, coupling and modifier.
# - Want the full interface? See the [Public API](@ref public-api).
