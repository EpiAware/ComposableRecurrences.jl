# # [Occupancy and capacity](@id tutorial-occupancy)
#
# ## Introduction
#
# Bed occupancy is a stock: yesterday's patients who stay, plus today's admissions.
# A stock is a recurrence.
# When stays are independent it is also a convolution over the length of stay.
# This tutorial builds occupancy both ways and caps it at the number of beds.
# It then routes the patients turned away to a second series.
# Last, it moves patients between two linked compartments in a ward.
#
# ### What are we going to do in this exercise
#
# 1. Turn admissions into occupancy with a convolution and with a recurrence.
# 2. Cap occupancy at the number of beds with `Clamp`.
# 3. Admit up to the free beds with `Capacity` and keep the rest.
# 4. Move suspected and confirmed patients between two compartments in one ward.
#
# ### What might I need to know before starting
#
# You need only the [Getting started](@ref getting-started) overview.
# No fitting is involved.

# ## Packages used

using ComposableRecurrences
using ComposableRecurrences: Clamp, Capacity, Beds, Flow, Pool
using CairoMakie, AlgebraOfGraphics, DataFramesMeta

CairoMakie.activate!(type = "png", px_per_unit = 2)

# ## Occupancy two ways
#
# Each patient leaves with probability `δ` each day.
# So the chance of still being in a bed `k` days after admission is ``(1 - \delta)^k``.
# Occupancy is then
#
# ```math
# O_t = \sum_{k=0}^{t-1} (1 - \delta)^k A_{t-k} = (1 - \delta) \, O_{t-1} + A_t,
# ```
#
# where ``O_t`` is the occupancy and ``A_t`` the admissions on day ``t``, with ``O_0 = 0``.
# As a convolution, occupancy is the admissions weighted by that survival, lag 0 first.
# As a recurrence, it is yesterday's occupancy times `1 - δ` plus today's admissions.
# The admissions enter as `add`.

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
# A [`Pool`](@ref ComposableRecurrences.Pool) without a draw then applies the day's flows.
# Its stocks are the compartments, held in the strata.
# Each flow is a [`Flow`](@ref ComposableRecurrences.Flow) from one stock to
# another, or to `0` to leave, with a hazard rate as its demand.
# Each rate is a parameter, so it can also differ by ward or change over time.

ward_flows = Pool(;
    stocks = (:suspected, :confirmed), draw = nothing,
    flows = (
        Flow(:suspected => :confirmed, 0.3), Flow(:suspected => 0, 0.4),
        Flow(:confirmed => 0, 0.1),
    )
)
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
# A flow with `form = Share()` moves a share instead, like the daily
# discharge probability `δ` at the start of this tutorial, except that the
# day's admissions can also leave that day.
# A flow with `form = Truncate()` moves a count, capped by what the
# compartment holds, such as a fixed number of transfers a day.
# Several wards are several groups: with ``G`` wards the strata are the ``G``
# suspected compartments, then the ``G`` confirmed ones.

# ## Learning more
#
# - See every operator, coupling and modifier on the [API overview](@ref api-overview).
# - Want a step of your own that moves values between compartments? See
#   [A blockwise step](@ref extending-blockwise).
# - Want the full interface? See the [Public API](@ref public-api).
