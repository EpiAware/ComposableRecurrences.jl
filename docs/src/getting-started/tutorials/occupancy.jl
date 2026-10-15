# # [Occupancy and capacity](@id tutorial-occupancy)
#
# ## Introduction
#
# Bed occupancy is the admissions weighted by the chance of still being in a bed, a convolution over the length of stay.
# When the stay is geometric it is also a recurrence: yesterday's patients who stay, plus today's admissions.
# This tutorial builds occupancy both ways, compares a stay that is not geometric, and caps occupancy at the number of beds.
# It then routes the patients turned away to a second series.
# Last, it moves patients between two linked compartments in a ward.
#
# ### What are we going to do in this exercise
#
# 1. Turn admissions into occupancy with a convolution and, for a geometric stay, a recurrence.
# 2. Compare a log-normal stay with the same mean.
# 3. Cap occupancy at the number of beds with `Clamp`.
# 4. Admit up to the free beds with `Capacity` and keep the rest.
# 5. Move suspected and confirmed patients between two compartments in one ward.
#
# ### What might I need to know before starting
#
# You need only the [Getting started](@ref getting-started) overview.
# No fitting is involved.

# ## Packages used

using ComposableRecurrences
using ComposableRecurrences: Clamp, Capacity, Beds, Flow, Flows
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
# where ``O_t`` is the occupancy and ``A_t`` the admissions on day ``t``, and ``S_k`` the survival, lag 0 first.
# This is `Convolution(S)(admissions)`.
# A geometric stay, in which each patient leaves with probability ``\delta`` each day, has ``S_k = (1 - \delta)^k``.
# Only then, because the geometric distribution is memoryless, does the sum collapse to a recurrence of order one:
#
# ```math
# O_t = (1 - \delta) \, O_{t-1} + A_t, \qquad O_0 = 0.
# ```
#
# As a recurrence, occupancy is yesterday's occupancy times `1 - δ` plus today's admissions, which enter as `add`.

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

# Occupancy peaks a few days after admissions at nearly six times their height.
# This is because each patient stays about ``1 / \delta`` days.

maximum(abs, by_convolution .- by_recurrence)

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
# The survival is `1 .- cumsum(pmf)`, lag 0 first.
# Here ``\sigma = 1.2``, and ``\mu`` is chosen so that the mean days in bed, ``\sum_k S_k``, match the geometric stay's ``1 / \delta``.

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
round.((sum(S), 1 / δ); digits = 2)

#-

@chain DataFrame(
    "day" => 1:T, "Admissions" => admissions,
    "Geometric stay" => by_convolution, "Log-normal stay" => by_lognormal
) begin
    stack(Not(:day); variable_name = :series, value_name = :count)
    data(_) * mapping(:day, :count, color = :series) * visual(Lines, linewidth = 2)
    draw(_; axis = (xlabel = "Day", ylabel = "Patients"))
end

# The log-normal stay gives a lower, later peak and a longer tail.
# For the same mean, more patients leave within two days and more stay beyond two weeks than with the geometric stay.
# The rest of this tutorial uses the geometric stay, as the `Beds` mode and the hazard flows do.

# ## A bed cap
#
# [`Clamp`](@ref ComposableRecurrences.Clamp) bounds each day's occupancy.
# With ``B`` beds,
#
# ```math
# O_t = \min\big(\max\big((1 - \delta) \, O_{t-1} + A_t,\ 0\big),\ B\big).
# ```
#
# As a modifier, the capped stock is what carries into the next day.
# So patients turned away never occupy a bed later.

beds = 120.0
capped = Recurrence([1 - δ]; modifiers = (Clamp(0.0, beds),))(; history = [0.0], add = admissions)

@chain DataFrame(day = 1:T, Uncapped = by_recurrence, Capped = capped) begin
    stack(Not(:day); variable_name = :series, value_name = :count)
    data(_) * mapping(:day, :count, color = :series) * visual(Lines, linewidth = 2) +
        mapping([beds]) * visual(HLines, color = :grey, linestyle = :dash)
    draw(_; axis = (xlabel = "Day", ylabel = "Occupied beds"))
end

# Capped occupancy holds at 120 beds for about ten days, then falls before the uncapped one.
# The bed-days lost to the cap are

round(sum(by_recurrence .- capped))

# ## Admitted and turned away
#
# The cap deletes the patients it turns away.
# [`Capacity`](@ref ComposableRecurrences.Capacity) keeps them instead.
# It admits each day's demand up to the free beds and routes the rest to a second series:
#
# ```math
# f_t = \max\big(B - (1 - \delta) \, O_{t-1},\ 0\big), \qquad
# x_t = \min(A_t, f_t), \qquad
# O_t = (1 - \delta) \, O_{t-1} + x_t,
# ```
#
# where ``f_t`` is the number of free beds and ``x_t`` the admissions.
# The second series receives the ``A_t - x_t`` patients turned away.
# In the [`Beds`](@ref ComposableRecurrences.Beds) mode the state is the occupancy.
# A share `δ` of it leaves each day.
# Series 1 holds the demand, and the zero kernel passes it straight to the modifier.

routing = Capacity(beds, Beds(δ); pairs = [1 => 2])
routed = Recurrence([0.0]; modifiers = (routing,))(;
    history = zeros(2, 1), add = [admissions'; zeros(1, T)]
)
admitted_occupancy = Recurrence([1 - δ])(; history = [0.0], add = routed[1, :])

turned = DataFrame("day" => 1:T, "Admitted" => routed[1, :], "Turned away" => routed[2, :])
@chain turned begin
    stack(Not(:day); variable_name = :series, value_name = :count)
    data(_) * mapping(:day, :count, color = :series) * visual(Lines, linewidth = 2)
    draw(_; axis = (xlabel = "Day", ylabel = "Patients"))
end

# Admissions fall to the beds freed each day while the ward is full.
# The occupancy of those admitted never passes the number of beds, and no patient is lost:

maximum(admitted_occupancy), sum(routed) ≈ sum(admissions)

# A [`Budget`](@ref ComposableRecurrences.Budget) mode grants an allowance each
# period instead.
# Vaccine doses per week are one example.

# ## A ward with two linked compartments
#
# A ward holds suspected patients awaiting a test and confirmed patients.
# Each day some suspected patients are confirmed and move to the confirmed compartment.
# Others are ruled out and leave, and confirmed patients are discharged.
# Confirmation and ruling out compete for the same suspected patients.
# Let ``U_t`` be the suspected compartment, ``C_t`` the confirmed compartment
# and ``A_t`` the admissions.
# With confirmation rate ``c``, rule-out rate ``r`` and discharge rate ``\delta``,
#
# ```math
# \begin{aligned}
# U^{*}_t &= U_{t-1} + A_t, \\
# U_t &= e^{-(c + r)} U^{*}_t, \\
# C_t &= e^{-\delta} C_{t-1} + \frac{c}{c + r} \big(1 - e^{-(c + r)}\big) U^{*}_t .
# \end{aligned}
# ```
#
# The rates are hazards, so the share leaving a compartment never exceeds what it holds.
# The two compartments are the strata of a recurrence with the unit kernel, suspected first.
# The recurrence carries yesterday's compartments forward and adds the
# admissions to the suspected one.
# [`Flows`](@ref ComposableRecurrences.Flows) then applies the day's flows.
# Each is a [`Flow`](@ref ComposableRecurrences.Flow) from one compartment to
# another, or to `0` to leave, and a bare rate is a hazard
# [`Rate`](@ref ComposableRecurrences.Rate).
# Each rate is a parameter, so it can also differ by ward or change over time.

ward_flows = Flows(Flow(1 => 2, 0.3), Flow(1 => 0, 0.4), Flow(2 => 0, 0.1))
ward = Recurrence([1.0]; modifiers = (ward_flows,))
patients = ward(; history = zeros(2, 1), add = [admissions'; zero(admissions')], stop = T)

@chain DataFrame(day = 1:T, Suspected = patients[1, :], Confirmed = patients[2, :]) begin
    stack(Not(:day); variable_name = :series, value_name = :count)
    data(_) * mapping(:day, :count, color = :series) * visual(Lines, linewidth = 2)
    draw(_; axis = (xlabel = "Day", ylabel = "Patients"))
end

# Suspected patients peak first.
# Confirmed patients peak about a week later and stay longer, as they leave more slowly.
#
# A [`Linear`](@ref ComposableRecurrences.Linear) flow moves a share instead,
# like the daily discharge probability ``\delta`` at the start of this tutorial,
# except that the day's admissions can also leave that day.
# An [`Amount`](@ref ComposableRecurrences.Amount) flow moves a count, capped by
# what the compartment holds, such as a fixed number of transfers a day.
# Several wards are several groups: with ``G`` wards the strata are the ``G``
# suspected compartments, then the ``G`` confirmed ones.

# ## Learning more
#
# - See every operator, coupling and modifier on the [API overview](@ref api-overview).
# - Want a step of your own that moves values between compartments? See
#   [A blockwise step](@ref extending-blockwise).
# - Want the full interface? See the [Public API](@ref public-api).
