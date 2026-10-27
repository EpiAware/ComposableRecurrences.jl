# # [Time-varying delays and kernels](@id tutorial-time-varying-kernels)
#
# ## Introduction
#
# Reporting delays and generation intervals often change as testing or behaviour changes.
# A [`TimeVarying`](@ref) kernel models this with one column per day.
#
# ### What might I need to know before starting
#
# The [Renewal then delay](@ref tutorial-renewal-delay) tutorial.

# ## Packages used

using ComposableRecurrences
using ComposableRecurrences: Primary
using CairoMakie, AlgebraOfGraphics, DataFramesMeta

CairoMakie.activate!(type = "png", px_per_unit = 2)

# ## A delay that changes over time
#
# Each column of `P` is a discretised delay, lag 0 first.
# Column ``t`` puts weight
#
# ```math
# P_l(t) = \frac{(l + 1)^{\mu_t - 1} e^{-l}}{\sum_{j=0}^{L_d - 1} (j + 1)^{\mu_t - 1} e^{-j}}, \qquad
# \mu_t = 2 + 4 e^{-((t - 40) / 15)^2},
# ```
#
# on lag ``l = 0, \dots, L_d - 1``.
# Here ``L_d = 15`` is the delay's length, `D` in the code.
# The shape parameter ``\mu_t`` is `means` in the code.
# It rises up to day 40, then falls as reporting recovers.
# The plot is the mean delay of each column, ``\sum_l l \, P_l(t)``.

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

# The mean delay is 1.2 days at the start and end, and peaks at 5.0 days on day 40.

# ## Reporting by report day or infection day
#
# Let ``P_l(\tau)`` be the weight on lag ``l`` in column ``\tau`` of `P`.
# The two indexings give
#
# ```math
# C^{\text{report}}_t = \sum_{l=0}^{L_d-1} P_l(t) \, I_{t-l}, \qquad
# C^{\text{infection}}_t = \sum_{l=0}^{L_d-1} P_l(t-l) \, I_{t-l},
# ```
#
# where ``I_t`` is the number of infections and ``C_t`` the reports on day ``t``.
# With the default [`Secondary()`](@ref ComposableRecurrences.Secondary), column `t` is a report day.
# With [`Primary()`](@ref ComposableRecurrences.Primary), column `s` is the infection day.
# A constant delay, the first column ``P_l(1)``, is a reference.

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
# Indexed by report day, the curve moves later but keeps most of its height, with a peak of 96 on day 40.
# By infection day, it is also flatter, with a peak of 85 on day 41.
# The infections at the peak have the longest delays.

# ## Which indexing conserves cases
#
# Summing the reports over all days, while the window is long enough to hold every delay, gives
#
# ```math
# \sum_t C^{\text{infection}}_t = \sum_s I_s \sum_{l} P_l(s), \qquad
# \sum_t C^{\text{report}}_t = \sum_s I_s \sum_{l} P_l(s + l),
# ```
#
# where ``s`` is the infection day.
# By infection day, each infection's delay ``P(s)`` sums to one, so each case is reported once.
# Indexed by report day, each day's weights sum to one.
# One infection is then weighted by several columns with different delays, so its weights need not sum to one and the total drifts.

cumulative = @chain reports begin
    @groupby(:series)
    @transform(:cumulative = cumsum(:count))
end
@chain cumulative begin
    data(_) * mapping(:day, :cumulative, color = :series) * visual(Lines, linewidth = 2)
    draw(_; axis = (xlabel = "Day", ylabel = "Cumulative count"))
end

# Indexed by infection day, the cumulative reports reach the cumulative infections.
# By day 80 both reach 2127.
# Indexed by report day, they reach 2165, an overshoot of 1.8%.
# The delay shortens after day 40, so some infections are counted on more than one day.

# ## A generation interval that shortens
#
# A recurrence kernel can change over time too, one generation interval per day:
#
# ```math
# I_t = \gamma_t \sum_{l=1}^{L} g_l(t) \, I_{t-l}, \qquad
# g(t) = \begin{cases} g^{\text{long}} & t < 30, \\ g^{\text{short}} & t \ge 30. \end{cases}
# ```
#
# Here ``I_t`` is the number of infections on day ``t`` and ``\gamma_t`` the gain, the reproduction number.
# The weight on lag ``l`` on day ``t`` is ``g_l(t)``, and ``L`` is the interval's length.
# The intervals ``g^{\text{long}}`` and ``g^{\text{short}}`` are `long_gi` and `short_gi` below, with means of 3.7 and 2.1 days.
# Isolation shortens the interval from day 30, so offspring come sooner.
# The reproduction number is held at ``\gamma_t = 1.2``, so only the timing changes.
# The kernel changes once, so it is given by its change points, each start day paired with the interval from that day.

long_gi = [0.05, 0.15, 0.25, 0.25, 0.2, 0.1]
short_gi = [0.3, 0.4, 0.2, 0.1]
fixed = Recurrence(long_gi)(1.2; history = fill(10.0, 6), stop = T)
G = TimeVarying([1 => long_gi, 30 => short_gi])
shortened = Recurrence(G)(1.2; history = fill(10.0, 6), stop = T)
@chain DataFrame(
    "day" => 1:T, "Fixed interval" => fixed, "Interval shortens on day 30" => shortened
) begin
    stack(Not(:day); variable_name = :series, value_name = :count)
    data(_) * mapping(:day, :count, color = :series) * visual(Lines, linewidth = 2)
    draw(_; axis = (xlabel = "Day", ylabel = "Infections"))
end

# With the shorter interval the same reproduction number grows faster.
# By day 80 there are 4310 infections a day, against 586 with the fixed interval.

# ## An isolation policy that starts on a set day
#
# A recurrence kernel read by infection day gives each case the generation interval of the day it was infected, a cohort effect.
# A `Secondary()` kernel is a period effect, the same for every case on a given day.
#
# Isolation thins the generation interval, as [Isolation as a thinned kernel](@ref tutorial-isolation-thinning) derives.
# Here a case infected on day ``c`` is isolated with probability ``p`` after a delay ``D``.
# Isolation blocks a share ``b`` of its later transmission.
# The policy starts on day ``t_0``, and an isolation that would fall before it does not happen.
# The expected generation interval of cohort ``c`` at lag ``l`` is then
#
# ```math
# g_l(c) = g_l \big(1 - p\, b\, P(D \le l,\ c + D \ge t_0)\big),
# ```
#
# where ``g_l`` is `long_gi`, and ``p = 0.7``, ``b = 0.9`` and ``t_0 = 30``.
# The delay ``D`` is 0, 1, 2 or 3 days, with probabilities `delay_iso`.
# The calendar-day kernel instead starts the same thinning on day ``t_0`` for every case:
#
# ```math
# g_l(t) = g_l \big(1 - p\, b\, P(D \le l)\, [t \ge t_0]\big),
# ```
#
# where ``[t \ge t_0]`` is one from day ``t_0`` and zero before.
# Both runs use ``I_t = \gamma_t \sum_{l} g_l(\cdot) \, I_{t-l}``, with ``\gamma_t = 1.8``.
# With `Primary()` column ``c`` is cohort ``c``'s interval, read at lag ``l`` on day ``c + l``.
# With the default `Secondary()` column ``t`` is the interval used on day ``t``.
# The run starts at `start = 7` after six seed values.
# With `prepend = true`, a [`Recurrence`](@ref) returns the seed with the run.

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

# Without isolation the outbreak keeps growing.
# Both isolation curves turn down near day 30.
# Read by calendar day, every case infectious on day 30 is thinned at once, as if isolated from infection.
# Infections fall from 589 on day 29 to 291 on day 30.
# Read by infection day, cases infected shortly before day 30 keep most of their transmission, because their isolation would fall before the policy starts.
# Infections then peak on day 31, at 642.
# The extra cases seed later generations, so infections stay 1.86 times as high.

# ## Performance
#
# Each bar times a 15-day delay indexed by infection day over 200 days, written with the operators or as a preallocated hand-written loop.

include(joinpath(pkgdir(ComposableRecurrences), "docs", "performance.jl")) #hide
performance_plot("time-varying delays")

# ## Learning more
#
# - See every operator, coupling and modifier on the [API overview](@ref api-overview).
# - Want the full interface? See the [Public API](@ref public-api).
