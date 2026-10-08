# # [Occupancy and capacity](@id tutorial-occupancy)
#
# ## Introduction
#
# Bed occupancy is a stock: yesterday's patients who stay, plus today's admissions.
# A stock is a recurrence.
# When stays are independent it is also a convolution over the length of stay.
# This tutorial builds occupancy both ways and caps it at the number of beds.
# It then moves patients between two linked stocks in a ward.
#
# ### What are we going to do in this exercise
#
# 1. Turn admissions into occupancy with a convolution and with a recurrence.
# 2. Cap occupancy at the number of beds with `Clamp`.
# 3. Move suspected and confirmed patients between two stocks in one ward.
#
# ### What might I need to know before starting
#
# You need only the [Getting started](@ref getting-started) overview.
# No fitting is involved.

# ## Packages used

using ComposableRecurrences
using ComposableRecurrences: Clamp, Flow, Flows
using CairoMakie, AlgebraOfGraphics, DataFramesMeta

CairoMakie.activate!(type = "png", px_per_unit = 2)

# ## Occupancy two ways
#
# Each patient leaves with probability `d` each day.
# So the chance of still being in a bed `k` days after admission is ``(1 - d)^k``.
# As a convolution, occupancy is the admissions weighted by that survival, lag 0 first.
# As a recurrence, it is yesterday's occupancy times `1 - d` plus today's admissions.
# The admissions enter as `add`.

T = 90
admissions = [30 * exp(-((t - 35) / 12)^2) for t in 1:T]
d = 0.15
by_convolution = Convolution((1 - d) .^ (0:(T - 1)))(admissions)
by_recurrence = Recurrence([1 - d])(; history = [0.0], add = admissions)

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
# This is because each patient stays about ``1 / d`` days.

maximum(abs, by_convolution .- by_recurrence)

# ## A bed cap
#
# [`Clamp`](@ref ComposableRecurrences.Clamp) bounds each day's occupancy.
# As a modifier, the capped stock is what carries into the next day.
# So patients turned away never occupy a bed later.

beds = 120.0
capped = Recurrence([1 - d]; modifiers = (Clamp(0.0, beds),))(; history = [0.0], add = admissions)

@chain DataFrame(day = 1:T, Uncapped = by_recurrence, Capped = capped) begin
    stack(Not(:day); variable_name = :series, value_name = :count)
    data(_) * mapping(:day, :count, color = :series) * visual(Lines, linewidth = 2) +
        mapping([beds]) * visual(HLines, color = :grey, linestyle = :dash)
    draw(_; axis = (xlabel = "Day", ylabel = "Occupied beds"))
end

# Capped occupancy holds at 120 beds for about ten days, then falls before the uncapped one.
# The bed-days lost to the cap are

round(sum(by_recurrence .- capped))

# ## A ward with two linked stocks
#
# A ward holds suspected patients awaiting a test and confirmed patients.
# Each day some suspected patients are confirmed and move to the confirmed stock.
# Others are ruled out and leave, and confirmed patients are discharged.
# Confirmation and ruling out compete for the same suspected patients.
# Let ``U_t`` be the suspected stock, ``C_t`` the confirmed stock and ``A_t`` the admissions.
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
# The rates are hazards rather than daily probabilities like ``d`` above, so the share leaving a stock never exceeds the stock.
# The two stocks are the strata of a recurrence with the unit kernel, suspected first.
# The recurrence carries yesterday's stocks forward and adds the admissions to the suspected stock.
# [`Flows`](@ref ComposableRecurrences.Flows) then applies the day's flows.
# Each is a [`Flow`](@ref ComposableRecurrences.Flow) from one stock to another, or to `0` to leave.
# Each rate is a parameter, so it can also be per stratum or change over time.

ward_flows = Flows(Flow(1 => 2, 0.3), Flow(1 => 0, 0.4), Flow(2 => 0, 0.1))
ward = Recurrence([1.0]; modifiers = (ward_flows,))
stocks = ward(; history = zeros(2, 1), add = [admissions'; zero(admissions')], stop = T)

@chain DataFrame(day = 1:T, Suspected = stocks[1, :], Confirmed = stocks[2, :]) begin
    stack(Not(:day); variable_name = :series, value_name = :count)
    data(_) * mapping(:day, :count, color = :series) * visual(Lines, linewidth = 2)
    draw(_; axis = (xlabel = "Day", ylabel = "Patients"))
end

# Suspected patients peak first.
# Confirmed patients peak about a week later and stay longer, as they leave more slowly.
#
# [`Linked`](@ref ComposableRecurrences.Linked) moves the stocks a modifier keeps in its state in the same way, as for waning protection.
# [Extending](@ref extending) shows how to write a modifier of your own.

# ## Learning more
#
# - See every operator, coupling and modifier on the [API overview](@ref api-overview).
# - Want the full interface? See the [Public API](@ref public-api).
