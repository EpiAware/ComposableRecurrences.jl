# # [Occupancy and capacity](@id tutorial-occupancy)
#
# ## Introduction
#
# Bed occupancy is the admissions weighted by the chance of still being in a bed, a convolution over the length of stay.

# ## Packages used

using ComposableRecurrences
using ComposableRecurrences: Transform, Recent, Depletion, Flow
using CairoMakie, AlgebraOfGraphics, DataFramesMeta
using SpecialFunctions: erfc

CairoMakie.activate!(type = "png", px_per_unit = 2)

# ## Occupancy two ways
#
# For any length-of-stay distribution, occupancy is the admissions weighted by the probability of still being in a bed:
#
# ```math
# O_t = \sum_{k \ge 0} S_k \, A_{t-k}, \qquad S_k = \Pr(\text{stay} > k),
# ```
#
# where ``O_t`` is the occupancy and ``A_t`` the admissions on day ``t``.
# The survival ``S_k`` is the convolution kernel, lag 0 first.
# The code is `Convolution(S)(admissions)`.
# A geometric stay, in which each patient leaves with probability ``\delta`` each day, has ``S_k = (1 - \delta)^k``.
# Because the geometric distribution is memoryless, only this stay collapses the sum to a recurrence of order one:
#
# ```math
# O_t = (1 - \delta) \, O_{t-1} + A_t, \qquad O_0 = 0.
# ```
#
# In the recurrence the kernel weight on lag 1 is ``k_1 = 1 - \delta``.
# The admissions are the add input ``a_t = A_t``, passed as `add`.

T = 90
admissions = [30 * exp(-((t - 35) / 12)^2) for t in 1:T]
δ = 0.15
by_convolution = Convolution((1 - δ) .^ (0:(T - 1)))(admissions)
by_recurrence = Recurrence([1 - δ])(; history = [0.0], add = admissions)

@chain DataFrame(
    "day" => 1:T, "Admissions" => admissions,
    "Occupancy (convolution)" => by_convolution,
    "Occupancy (recurrence)" => by_recurrence
) begin
    stack(Not(:day); variable_name = :series, value_name = :count)
    data(_) * mapping(:day, :count, color = :series) * visual(Lines, linewidth = 2)
    draw(_; axis = (xlabel = "Day", ylabel = "Patients"))
end

# The convolution and the recurrence agree to rounding error, so their lines overlap.
# Occupancy peaks on day 39, four days after admissions, at 5.7 times their height.
# Each patient stays ``1 / \delta \approx 6.7`` days on average.

# ## A stay that is not geometric
#
# Real stays are rarely geometric: the chance of leaving changes with the time already spent in bed, and a few patients stay much longer.
# A log-normal stay with log-mean ``\mu`` and log-standard deviation ``\sigma``, discretised by day, has
#
# ```math
# p_k = F(k + 1) - F(k), \qquad S_k = 1 - \sum_{j=0}^{k} p_j, \qquad
# F(x) = \tfrac{1}{2} \operatorname{erfc}\Big(-\frac{\log x - \mu}{\sigma \sqrt{2}}\Big),
# ```
#
# where ``p_k`` is the probability of a stay of ``k`` whole days and ``F`` the log-normal distribution function.
# The survival ``S_k`` is `1 .- cumsum(pmf)`, lag 0 first, and occupancy is again ``O_t = \sum_k S_k A_{t-k}``.
# Here ``\sigma = 1.2``.
# The log-mean ``\mu`` is chosen so that the mean days in bed, ``\sum_k S_k``, match the geometric stay's ``1 / \delta``.

σ = 1.2
function survival(μ)
    F(x) = x <= 0 ? 0.0 : erfc(-(log(x) - μ) / (σ * sqrt(2))) / 2
    pmf = [F(k + 1) - F(k) for k in 0:(T - 1)]
    return 1 .- cumsum(pmf)
end
function matched_mu(target; lo = 0.0, hi = 3.0)
    for _ in 1:50  # bisect on μ until the mean days in bed match
        mid = (lo + hi) / 2
        sum(survival(mid)) < target ? (lo = mid) : (hi = mid)
    end
    return lo
end
S = survival(matched_mu(1 / δ))
by_lognormal = Convolution(S)(admissions)

@chain DataFrame(
    "day" => 1:T, "Admissions" => admissions,
    "Geometric stay" => by_convolution, "Log-normal stay" => by_lognormal
) begin
    stack(Not(:day); variable_name = :series, value_name = :count)
    data(_) * mapping(:day, :count, color = :series) * visual(Lines, linewidth = 2)
    draw(_; axis = (xlabel = "Day", ylabel = "Patients"))
end

# Both stays have a mean of 6.67 days, with ``\mu = 1.27``.
# The log-normal stay gives a lower, later peak, 140 patients on day 40 against 171 on day 39, and a longer tail.
# With the log-normal stay 31% of patients stay at most one day, against 15% with the geometric stay.
# Also 12% stay more than 14 days, against 10%.

# ## A bed cap on occupancy
#
# With a geometric stay occupancy is a recurrence, so a modifier can bound it.
# [`Transform(clamp, lo, hi)`](@ref ComposableRecurrences.Transform) bounds each day's occupancy.
# With ``B`` beds,
#
# ```math
# O_t = \min\big(\max\big((1 - \delta) \, O_{t-1} + A_t,\ 0\big),\ B\big).
# ```
#
# The one modifier ``M_1`` is `Transform(clamp, 0, B)`.
# The cap applies before occupancy carries over to the next day, so patients turned away never occupy a bed later.

beds = 120.0
capped = Recurrence([1 - δ]; modifiers = (Transform(clamp, 0.0, beds),))(; history = [0.0], add = admissions)

@chain DataFrame(day = 1:T, Uncapped = by_recurrence, Capped = capped) begin
    stack(Not(:day); variable_name = :series, value_name = :count)
    data(_) * mapping(:day, :count, color = :series) * visual(Lines, linewidth = 2) +
        mapping([beds]) * visual(HLines, color = :grey, linestyle = :dash)
    draw(_; axis = (xlabel = "Day", ylabel = "Occupied beds"))
end

# Capped occupancy holds at 120 beds for 12 days, days 32 to 43, then falls before the uncapped one.
# The cap removes 670 bed-days.
# This cap needs the geometric stay, as only that stay makes occupancy a recurrence.
# It also deletes the patients it turns away.

# ## A bed cap with any stay
#
# Capping the admissions rather than the occupancy works with any stay and keeps the patients turned away.
# Each day admits the demand up to the free beds:
#
# ```math
# x_t = \min\Big(A_t,\ \frac{B - h_t}{S_0}\Big), \qquad
# h_t = \sum_{k \ge 1} S_k \, x_{t-k}, \qquad
# O_t = h_t + S_0 \, x_t,
# ```
#
# where ``A_t`` is the demand for beds, ``x_t`` the admissions and ``h_t`` the beds still held by earlier admissions.
# The held beds ``h_t`` are a weighted sum of the recurrence's own past outputs, which [`Recent`](@ref ComposableRecurrences.Recent) reads, so the cap is `Transform(min, (B - Recent(S[2:end])) / S[1])` on a recurrence with a zero kernel and the demand as `add`.
# Of the day's admissions a share ``S_0`` is still in a bed at the end of the day, so the cap divides the free beds by ``S_0``, and ``O_t = B`` on the days it binds.
# The survival is non-increasing, so ``h_t \le O_{t-1} \le B`` and the bound is never negative.

function admit(survival, beds, demand)
    cap = Transform(min, (beds - Recent(survival[2:end])) / survival[1])
    return Recurrence([0.0]; modifiers = (cap,))(; history = [0.0], add = demand)
end
geometric = (1 - δ) .^ (0:(T - 1))
admitted = admit(S, beds, admissions)
@assert round(Int, sum(admissions .- admitted)) == 43 #hide
@assert extrema(findall(>=(beds - 1.0e-9), Convolution(S)(admitted))) == (35, 42) #hide
admitted_occupancy = Convolution(S)(admitted)

@chain DataFrame(
    "day" => 1:T, "Admitted" => admitted, "Turned away" => admissions .- admitted
) begin
    stack(Not(:day); variable_name = :series, value_name = :count)
    data(_) * mapping(:day, :count, color = :series) * visual(Lines, linewidth = 2)
    draw(_; axis = (xlabel = "Day", ylabel = "Patients"))
end

# With the log-normal stay admissions fall to the beds freed each day while the ward is full.
# Over the 90 days 43 patients are turned away.
# Admitted and turned-away patients add up to the demand, so no patient is lost.
# Occupancy of those admitted reaches the 120 beds and never passes them:

@chain DataFrame(
    "day" => 1:T,
    "Geometric stay" => Convolution(geometric)(admit(geometric, beds, admissions)),
    "Log-normal stay" => admitted_occupancy
) begin
    stack(Not(:day); variable_name = :series, value_name = :count)
    data(_) * mapping(:day, :count, color = :series) * visual(Lines, linewidth = 2) +
        mapping([beds]) * visual(HLines, color = :grey, linestyle = :dash)
    draw(_; axis = (xlabel = "Day", ylabel = "Occupied beds"))
end

# The log-normal ward is full on days 35 to 42.
# With the geometric stay ``S_0 = 1``, and the ward is full on days 32 to 43, as with the cap on occupancy.
# There 101 patients are turned away rather than deleted.
# Swapping the stay changes only the survival ``S``: the cap and the convolution stay the same.

# ## A ward with two linked compartments
#
# A ward holds suspected patients awaiting a test and confirmed patients.
# Each day some suspected patients are confirmed and move to the confirmed compartment.
# Others are ruled out and leave, and confirmed patients are discharged.
# Confirmation and ruling out compete for the same suspected patients.
# Let ``U_t`` be the suspected compartment, ``Q_t`` the confirmed compartment and ``A_t`` the admissions.
# With confirmation rate ``c``, rule-out rate ``r`` and discharge rate ``d``,
#
# ```math
# \begin{aligned}
# U^{*}_t &= U_{t-1} + A_t, \\
# U_t &= e^{-(c + r)} U^{*}_t, \\
# Q_t &= e^{-d} Q_{t-1} + \frac{c}{c + r} \big(1 - e^{-(c + r)}\big) U^{*}_t .
# \end{aligned}
# ```
#
# The rates are hazards, so the share leaving a compartment never exceeds what it holds.
# The two compartments are the strata of a recurrence with the unit kernel, suspected first.
# The recurrence carries yesterday's compartments forward and adds the admissions to the suspected one.
# A [`Depletion`](@ref ComposableRecurrences.Depletion) without a draw then applies the day's flows.
# Its pools are the compartments, held in the strata.
# Each flow is a [`Flow`](@ref ComposableRecurrences.Flow) from one pool to another, or to `0` to leave, with a hazard rate as its demand.
# Each rate is a parameter, so it can differ by ward or change over time.
# Here ``c = 0.3``, ``r = 0.4`` and ``d = 0.1``.

ward_flows = Depletion(
    Flow(:suspected => :confirmed, 0.3), Flow(:suspected => 0, 0.4),
    Flow(:confirmed => 0, 0.1); pools = (:suspected, :confirmed)
)
ward = Recurrence([1.0]; modifiers = (ward_flows,))
patients = ward(; history = zeros(2, 1), add = [admissions'; zero(admissions')], stop = T)

@chain DataFrame(day = 1:T, Suspected = patients[1, :], Confirmed = patients[2, :]) begin
    stack(Not(:day); variable_name = :series, value_name = :count)
    data(_) * mapping(:day, :count, color = :series) * visual(Lines, linewidth = 2)
    draw(_; axis = (xlabel = "Day", ylabel = "Patients"))
end

# Suspected patients peak first, on day 36.
# Confirmed patients peak six days later, on day 42, and stay longer, as they leave more slowly.
#
# A flow with `form = Share()` moves a share, like the daily discharge probability ``\delta`` above, except that the day's admissions can also leave that day.
# A flow with `form = Truncate()` moves a count capped by what the compartment holds, such as a fixed number of transfers a day.
# With ``G`` wards the strata are the ``G`` suspected compartments, then the ``G`` confirmed ones.

# ## Performance
#
# Each bar times the two-compartment ward with rate, share and count flows over 200 days, written with the operators or as a preallocated hand-written loop.

include(joinpath(pkgdir(ComposableRecurrences), "docs", "performance.jl")) #hide
performance_plot("occupancy")
#-
slower_targets("occupancy") #hide

# ## Learning more
#
# - See every operator, coupling and modifier on the [API overview](@ref api-overview).
# - Want a step of your own that moves values between compartments? See [A blockwise step](@ref extending-blockwise).
# - Want the full interface? See the [Public API](@ref public-api).
