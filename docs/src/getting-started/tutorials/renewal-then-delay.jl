# # [Renewal then delay](@id tutorial-renewal-delay)
#
# ## Introduction
#
# A renewal process makes each day's infections from the recent past, weighted by the generation interval and scaled by the reproduction number.
# A reporting delay then spreads those infections over the days they are reported.
# This tutorial builds both from `Recurrence` and `Convolution`, adds susceptible depletion and imported cases, takes a gradient and makes a forecast.
#
# ### What are we going to do in this exercise
#
# 1. Run a renewal process with a changing reproduction number.
# 2. Deplete a finite susceptible pool with the hazard and floored forms.
# 3. Add imported cases before or after depletion.
# 4. Report infections through a delay.
# 5. Differentiate the reports with respect to the reproduction number.
# 6. Resume a run to forecast from where it stopped.
#
# ### What might I need to know before starting
#
# This tutorial builds on the [Getting started](@ref getting-started) overview and the [Concepts](@ref concepts) page, and uses AlgebraOfGraphics.jl and CairoMakie.jl for plotting.
# No fitting is involved.

# ## Packages used

using ComposableRecurrences
using ComposableRecurrences: Depletion, Floor, Add, seeded, with_state
using CairoMakie, AlgebraOfGraphics, DataFramesMeta
using ForwardDiff

CairoMakie.activate!(type = "png", px_per_unit = 2)

# ## A renewal process
#
# The generation interval is the kernel, lag 1 first.
# The reproduction number is the gain, one value per day.
# The history holds the infections on the days before the first step, and a shorter history is padded with zeros.

gi = [0.1, 0.3, 0.3, 0.2, 0.1]
renewal = Recurrence(gi)
T = 80
R = [t <= 30 ? 1.4 : t <= 50 ? 0.9 : 1.2 for t in 1:T]
infections = renewal(R; history = [5.0])

draw(
    data(DataFrame(day = 1:T, count = infections, series = "Infections")) *
        mapping(:day, :count, color = :series) * visual(Lines, linewidth = 2);
    axis = (xlabel = "Day", ylabel = "Count")
)

# Infections grow while `R` is 1.4, fall after day 30 when it drops to 0.9, and grow again after day 50.
# Each change in `R` shows as a jump, because `R` scales each day's infections directly.

# ## Susceptible depletion
#
# `Depletion(N)` draws each day's infections from a pool of `N` susceptibles.
# The default `Hazard()` form draws `s (1 - exp(-v / N))` from pool `s`, so the pool never goes negative.
# The `Floor()` form draws `max(s / N, 1e-6) v` instead.

N = 2_000.0
R_high = fill(1.8, T)
forms = ["Hazard" => Depletion(N), "Floor" => Depletion(N, Floor())]
depleted = map(forms) do (name, d)
    y = Recurrence(gi; modifiers = (d,))(R_high; history = [5.0])
    vcat(
        DataFrame(day = 1:T, count = y, series = name, quantity = "Infections"),
        DataFrame(day = 1:T, count = N .- cumsum(y), series = name, quantity = "Susceptible pool")
    )
end
draw(
    data(vcat(depleted...)) *
        mapping(:day, :count, color = :series, layout = :quantity) *
        visual(Lines, linewidth = 2);
    axis = (xlabel = "Day", ylabel = "Count"),
    facet = (; linkyaxes = :none)
)

# Both forms end the outbreak as the pool empties.
# The hazard form draws slightly less at the peak and leaves more susceptibles, because `1 - exp(-x)` is below `x`.

# ## Imported cases
#
# `add` enters before the modifiers, so imported cases are drawn from the pool like local ones.
# `Add` enters where it sits in the modifier tuple, so after `Depletion` the imports are added on top.

ι = [t <= 10 ? 3.0 : 0.0 for t in 1:T]
before = Recurrence(gi; modifiers = (Depletion(N),))(R_high; history = [0.0], add = ι)
after = Recurrence(gi; modifiers = (Depletion(N), Add(TimeVarying(ι))))(R_high; history = [0.0])
round.((sum(before), sum(after)))

# Imports added after depletion are not drawn from the pool, so more susceptibles remain and the total is larger.

# ## Reporting delay
#
# The delay is a convolution kernel, lag 0 first.
# Ascertainment is a plain multiplication.
# `seeded` returns the seed days followed by the run, so the delay sees the seed too.

delay = Convolution([0.1, 0.3, 0.3, 0.2, 0.1])
seed = fill(5.0, 5)
R_full = vcat(fill(1.0, 5), R)
infections_seeded = seeded(renewal, R_full; history = seed)
reports = 0.3 .* delay(infections_seeded)
days = 1:length(reports)
draw(
    data(
        vcat(
            DataFrame(day = days, count = infections_seeded, series = "Infections"),
            DataFrame(day = days, count = reports, series = "Reports")
        )
    ) * mapping(:day, :count, color = :series) * visual(Lines, linewidth = 2);
    axis = (xlabel = "Day", ylabel = "Count")
)

# Reports are 30% of infections, delayed and smoothed by the reporting delay.
# The seed days appear at the start of both series.

# ## Gradients
#
# Both operators run on dual numbers, so ForwardDiff gives the gradient of the total reports with respect to every day's reproduction number.

total_reports(R) = sum(0.3 .* delay(seeded(renewal, R; history = seed)))
∂R = ForwardDiff.gradient(total_reports, R_full)
draw(
    data(DataFrame(day = days, value = ∂R, series = "∂ total reports / ∂R")) *
        mapping(:day, :value, color = :series) * visual(Lines, linewidth = 2);
    axis = (xlabel = "Day", ylabel = "Sensitivity")
)

# The seed days have zero sensitivity, because the renewal does not run on them.
# Later days matter less, because the infections they add have less time to grow and be reported.

# ## Forecasting from where a run stopped
#
# `with_state` returns the output and a `State` holding the recent history and each modifier's state.
# Passing it back as `state` continues the run, so a forecast needs no rerun of the fitted period.

split = 50
fitted, state = with_state(renewal, R; history = [5.0], stop = split)
forecast = renewal(R; state)
draw(
    data(
        vcat(
            DataFrame(day = 1:split, count = fitted, series = "Fitted"),
            DataFrame(day = (split + 1):T, count = forecast, series = "Forecast")
        )
    ) * mapping(:day, :count, color = :series) * visual(Lines, linewidth = 2) +
        mapping([split + 0.5]) * visual(VLines, color = :grey, linestyle = :dash);
    axis = (xlabel = "Day", ylabel = "Infections")
)

# The forecast continues from the state on day 50, with no rerun of the first 50 days.
# The resumed run matches the single run exactly.

maximum(abs, vcat(fitted, forecast) .- infections)

# ## Learning more
#
# - See every type used here on the [Concepts](@ref concepts) page.
# - Want the full interface? See the [Public API](@ref public-api).
