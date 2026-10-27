# # [Forecasting](@id tutorial-forecasting)
#
# ## Introduction
#
# A forecast continues a run past the last day with data.
# The run returns its [state](@ref explanation-history-state), and a second call starts from it.
#
# ### What might I need to know before starting
#
# It builds on [Renewal then delay](@ref tutorial-renewal-delay).

# ## Packages used

using ComposableRecurrences
using CairoMakie, AlgebraOfGraphics, DataFramesMeta

CairoMakie.activate!(type = "png", px_per_unit = 2)

# ## Continuing a run
#
# The renewal process is
#
# ```math
# I_t = R_t \sum_{l=1}^{L} g_l \, I_{t-l},
# ```
#
# where ``I_t`` is the number of infections on day ``t``, ``R_t`` the reproduction number and ``g_l`` the generation interval's weight on lag ``l``.
# Day ``t`` reads only ``I_{t-L}, \dots, I_{t-1}``.
# So the infections on days 46 to 50 and the next day, 51, are all a run to day 50 needs to continue.
# The call `renewal(R; history, stop = 50, state = true)` runs to day 50 and returns them as a [`State`](@ref ComposableRecurrences.State).
# Passing the state back as `state` continues the run from day 51.
# Here ``R_t`` is 1.4 to day 30, 0.9 to day 50 and 1.2 after.

gi = [0.1, 0.3, 0.3, 0.2, 0.1]
renewal = Recurrence(gi)
T = 80
R = [t <= 30 ? 1.4 : t <= 50 ? 0.9 : 1.2 for t in 1:T]
last_day = 50
fitted, state = renewal(R; history = [5.0], stop = last_day, state = true)
forecast, _ = renewal(R; state)

@chain DataFrame("day" => 1:T, "count" => vcat(fitted, forecast)) begin
    @transform(:part = ifelse.(:day .<= last_day, "Fitted", "Forecast"))
    data(_) * mapping(:day, :count, color = :part => "") * visual(Lines, linewidth = 2) +
        mapping([last_day + 0.5]) * visual(VLines, color = :grey, linestyle = :dash)
    draw(_; axis = (xlabel = "Day", ylabel = "Infections"))
end

# The forecast reads ``R_t`` on days 51 to 80, as the time base counts days from 1 whatever the start.
# The two calls together match one call over all 80 days to rounding error.

# ## Performance
#
# Each bar times a renewal run to day 100 and continued from its state to day 200, with a 20-day generation interval, written with the operators or as a preallocated hand-written loop over all 200 days in one pass.

include(joinpath(pkgdir(ComposableRecurrences), "docs", "performance.jl")) #hide
performance_plot("forecasting")

# ## Learning more
#
# - [History and state](@ref explanation-history-state): what a `State` holds, modifiers included.
# - Want the full interface? See the [Public API](@ref public-api).
