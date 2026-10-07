# # [Time-varying delays and kernels](@id tutorial-time-varying-kernels)
#
# ## Introduction
#
# Reporting delays and generation intervals often change as testing or behaviour changes.
# A [`TimeVarying`](@ref) kernel has one column per day.
# A delay's column can be read by the day a case is reported or the day it is infected.
# This tutorial shows both and checks which one conserves cases.
# It then uses a changing generation interval in a renewal process.
#
# ### What are we going to do in this exercise
#
# 1. Build a reporting delay that lengthens and then shortens.
# 2. Report infections through it, indexed by report day and by infection day.
# 3. Check which indexing conserves the total.
# 4. Run a renewal process with a generation interval that shortens.
# 5. Model an isolation policy that starts on a set day, by the day each case was infected.
#
# ### What might I need to know before starting
#
# It builds on [Renewal then delay](@ref tutorial-renewal-delay), which uses fixed kernels.
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

@chain DataFrame(day = 1:T, mean_delay = realised) begin
    data(_) * mapping(:day, :mean_delay) * visual(Lines, linewidth = 2)
    draw(_; axis = (xlabel = "Day", ylabel = "Mean delay (days)"))
end

# The mean delay is about one day at the start and end, and peaks at five days on day 40.

# ## Reporting by report day or infection day
#
# [`Secondary()`](@ref ComposableRecurrences.Secondary) is the default.
# With it, column `t` is a report day.
# With [`Primary()`](@ref ComposableRecurrences.Primary) column `s` is the infection day.
# A constant delay at the starting mean is a reference.

infections = [100 * exp(-((t - 35) / 12)^2) for t in 1:T]
reports = @chain DataFrame(
    "day" => 1:T,
    "Infections" => infections,
    "Constant delay" => Convolution(P[:, 1])(infections),
    "By report day" => Convolution(TimeVarying(P))(infections),
    "By infection day" => Convolution(TimeVarying(P, Primary()))(infections)
) begin
    stack(Not(:day); variable_name = :series, value_name = :count)
end
@chain reports begin
    data(_) * mapping(:day, :count, color = :series) * visual(Lines, linewidth = 2)
    draw(_; axis = (xlabel = "Day", ylabel = "Count"))
end

# Both time-varying delays report later than the constant one while the delay is long.
# Indexed by report day, the curve moves later but keeps most of its height.
# By infection day, it is also flatter: the peak's infections have the longest delays.

# ## Which indexing conserves cases
#
# By infection day, each infection's delay sums to one, so each case is reported once.
# Indexed by report day, each day's weights sum to one.
# But several columns with different delays can count one infection, so the total drifts.

cumulative = @chain reports begin
    @groupby(:series)
    @transform(:cumulative = cumsum(:count))
end
@chain cumulative begin
    data(_) * mapping(:day, :cumulative, color = :series) * visual(Lines, linewidth = 2)
    draw(_; axis = (xlabel = "Day", ylabel = "Cumulative count"))
end

# Indexed by infection day, the cumulative reports reach the cumulative infections.
# Indexed by report day, they overshoot by about 2%.
# Some infections are counted on more than one day as the delay shortens after day 40.
#
# The totals by the end of the window:

@chain cumulative begin
    @groupby(:series)
    @combine(:total = round(last(:cumulative)))
end

# ## A generation interval that shortens
#
# A recurrence kernel can change over time too, one generation interval per day.
# Here isolation shortens the interval from day 30, so offspring come sooner.
# The reproduction number is held at 1.2, so only the timing changes.

long_gi = [0.05, 0.15, 0.25, 0.25, 0.2, 0.1]
short_gi = [0.3, 0.4, 0.2, 0.1, 0.0, 0.0]
G = hcat([t < 30 ? long_gi : short_gi for t in 1:T]...)
fixed = Recurrence(long_gi)(1.2; history = fill(10.0, 6), stop = T)
shortened = Recurrence(TimeVarying(G))(1.2; history = fill(10.0, 6), stop = T)
@chain DataFrame(
    "day" => 1:T, "Fixed interval" => fixed, "Interval shortens on day 30" => shortened
) begin
    stack(Not(:day); variable_name = :series, value_name = :count)
    data(_) * mapping(:day, :count, color = :series) * visual(Lines, linewidth = 2)
    draw(_; axis = (xlabel = "Day", ylabel = "Infections"))
end

# With the shorter interval the same reproduction number grows faster.

# ## An isolation policy that starts on a set day
#
# A recurrence kernel can also be read by the day each case was infected.
# Then each case keeps the generation interval of the day it was infected.
# That is a cohort effect.
# A `Secondary()` kernel is a period effect, the same for every case on a given day.
#
# A case infected on day ``c`` is isolated with probability ``p`` after a delay ``D``.
# Isolation blocks a share ``b`` of its later transmission.
# The policy starts on day ``t_0``; an isolation that would fall before it does not happen.
# The expected generation interval of cohort ``c`` at lag ``l`` is then
#
# ```math
# w_l(c) = w_l \big(1 - p\, b\, P(D \le l,\ c + D \ge t_0)\big).
# ```
#
# With `Primary()` column ``c`` is cohort ``c``'s interval.
# The run starts at `start = 7` after six seed values, and `prepend = true` returns the seed with the run (see [`Recurrence`](@ref)).
# The `Secondary()` kernel instead starts the same thinning on day ``t_0`` for every case.

p_iso, b_iso, t0 = 0.7, 0.9, 30
delay_iso = [0.2, 0.3, 0.3, 0.2]          # P(D = 0, 1, 2, 3)
P_iso(l, from) = sum(delay_iso[d + 1] for d in max(from, 0):min(l, 3); init = 0.0)
cohort = [long_gi[l] * (1 - p_iso * b_iso * P_iso(l, t0 - c)) for l in 1:6, c in 1:T]
period = [long_gi[l] * (1 - (t >= t0 ? p_iso * b_iso * P_iso(l, 0) : 0.0)) for l in 1:6, t in 1:T]
R_iso = fill(1.8, T)
seed_iso = fill(10.0, 6)
seeded_iso(kernel) = Recurrence(kernel)(R_iso; history = seed_iso, start = 7, prepend = true)
@chain DataFrame(
    "day" => 1:T,
    "No isolation" => seeded_iso(long_gi),
    "By infection day" => seeded_iso(TimeVarying(cohort, Primary())),
    "By calendar day" => seeded_iso(TimeVarying(period)),
) begin
    stack(Not(:day); variable_name = :series, value_name = :count)
    data(_) * mapping(:day, :count, color = :series) * visual(Lines, linewidth = 2)
    draw(_; axis = (xlabel = "Day", ylabel = "Infections (log scale)", yscale = log10))
end

# Without isolation the outbreak keeps growing; both isolation curves turn down near day 30.
# Read by calendar day, every case infectious on day 30 is thinned at once.
# It is as if its isolation had applied from infection, so infections halve that day.
# Read by infection day, cases infected just before day 30 keep most of their transmission.
# Their isolation would be dated before the policy starts, so it does not happen.
# Infections then peak on day 31.
# The extra cases seed later generations, so infections stay just under twice as high.

# ## Learning more
#
# - See every operator, coupling and modifier on the [API overview](@ref api-overview).
# - Want the full interface? See the [Public API](@ref public-api).
