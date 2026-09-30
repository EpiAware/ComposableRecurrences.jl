# # [Time-varying delays and kernels](@id tutorial-time-varying-kernels)
#
# ## Introduction
#
# Reporting delays and generation intervals often change during an outbreak, as testing capacity or behaviour changes.
# A `TimeVarying` kernel has one column per day.
# For a delay there are two ways to read that column: by the day a case is reported, or by the day it is infected.
# This tutorial shows both, checks which one conserves cases, and uses a changing generation interval in a renewal process.
#
# ### What are we going to do in this exercise
#
# 1. Build a reporting delay that lengthens and then shortens.
# 2. Report infections through it, indexed by report day and by infection day.
# 3. Check which indexing conserves the total.
# 4. Run a renewal process with a generation interval that shortens.
#
# ### What might I need to know before starting
#
# This tutorial builds on the [Getting started](@ref getting-started) overview and the [API overview](@ref api-overview), and uses AlgebraOfGraphics.jl and CairoMakie.jl for plotting.
# No fitting is involved.

# ## Packages used

using ComposableRecurrences
using ComposableRecurrences: Primary
using CairoMakie, AlgebraOfGraphics, DataFramesMeta

CairoMakie.activate!(type = "png", px_per_unit = 2)

# ## A delay that changes over time
#
# Each column is a discretised delay, lag 0 first.
# Here the delay lengthens up to day 40, then shortens as reporting recovers.

T, D = 80, 15
function delay_pmf(mean)
    w = [(d + 1)^(mean - 1) * exp(-d) for d in 0:(D - 1)]
    return w ./ sum(w)
end
means = [2 + 4 * exp(-((t - 40) / 15)^2) for t in 1:T]
P = hcat(delay_pmf.(means)...)
realised = vec(sum((0:(D - 1)) .* P; dims = 1))

draw(
    data(DataFrame(day = 1:T, value = realised, series = "Mean delay")) *
        mapping(:day, :value, color = :series) * visual(Lines, linewidth = 2);
    axis = (xlabel = "Day", ylabel = "Mean delay (days)")
)

# The mean delay is about one day at the start and end of the window and peaks at five days on day 40.

# ## Reporting by report day or infection day
#
# With the default `Secondary()`, column `t` belongs to the report day: it weights the infections reported on day `t`.
# With `Primary()`, column `s` belongs to the infection day: it is the delay of the infections on day `s`, which spread forward through it.
# A constant delay at the starting mean is a reference.

infections = [100 * exp(-((t - 35) / 12)^2) for t in 1:T]
reports = vcat(
    DataFrame(day = 1:T, count = infections, series = "Infections"),
    DataFrame(day = 1:T, count = Convolution(P[:, 1])(infections), series = "Constant delay"),
    DataFrame(day = 1:T, count = Convolution(TimeVarying(P))(infections), series = "By report day"),
    DataFrame(day = 1:T, count = Convolution(TimeVarying(P, Primary()))(infections), series = "By infection day")
)
draw(
    data(reports) * mapping(:day, :count, color = :series) * visual(Lines, linewidth = 2);
    axis = (xlabel = "Day", ylabel = "Count")
)

# Both time-varying delays report later than the constant one while the delay is long.
# Indexed by report day, the curve moves later but keeps most of its height.
# Indexed by infection day, it is also flatter, because the infections near the peak spread over the longest delays.

# ## Which indexing conserves cases
#
# Indexed by infection day, every infection's delay sums to one, so every case is reported once, up to those still in the delay at the end of the window.
# Indexed by report day, each day's weights sum to one but an infection can be counted by several columns with different delays, so the total drifts.

cumulative = @chain reports begin
    @groupby(:series)
    @transform(:cumulative = cumsum(:count))
end
draw(
    data(cumulative) * mapping(:day, :cumulative, color = :series) * visual(Lines, linewidth = 2);
    axis = (xlabel = "Day", ylabel = "Cumulative count")
)

# Indexed by infection day, the cumulative reports reach the cumulative infections.
# Indexed by report day, they overshoot by about 2%, because some infections are counted on more than one day as the delay shortens after day 40.
#
# The totals by the end of the window:

@chain cumulative begin
    @groupby(:series)
    @combine(:total = round(last(:cumulative)))
end

# ## A generation interval that shortens
#
# A recurrence kernel can change over time too, one generation interval per day, lag 1 first.
# Here isolation shortens the interval from day 30, so each infection's offspring come sooner.
# The reproduction number is held at 1.2, so only the timing changes.

long_gi = [0.05, 0.15, 0.25, 0.25, 0.2, 0.1]
short_gi = [0.3, 0.4, 0.2, 0.1, 0.0, 0.0]
G = hcat([t < 30 ? long_gi : short_gi for t in 1:T]...)
fixed = Recurrence(long_gi)(1.2; history = fill(10.0, 6), stop = T)
shortened = Recurrence(TimeVarying(G))(1.2; history = fill(10.0, 6), stop = T)
draw(
    data(
        vcat(
            DataFrame(day = 1:T, count = fixed, series = "Fixed interval"),
            DataFrame(day = 1:T, count = shortened, series = "Interval shortens on day 30")
        )
    ) * mapping(:day, :count, color = :series) * visual(Lines, linewidth = 2);
    axis = (xlabel = "Day", ylabel = "Infections")
)

# With the shorter interval the same reproduction number grows faster, because each generation takes less time.

# ## Learning more
#
# - See every operator, coupling and modifier used here on the [API overview](@ref api-overview).
# - Want the full interface? See the [Public API](@ref public-api).
