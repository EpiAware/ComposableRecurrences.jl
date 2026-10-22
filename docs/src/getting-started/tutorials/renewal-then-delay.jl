# # [Renewal then delay](@id tutorial-renewal-delay)
#
# ## Introduction
#
# [Getting started](@ref overview-build) builds a renewal process with a reporting delay.
# This tutorial adds the parts it leaves out.
#
# ### What are we going to do in this exercise
#
# 1. Seed a renewal process on a growth path.
# 2. Deplete a finite susceptible pool with the hazard and floored forms.
# 3. Vaccinate with all-or-nothing, leaky and waning protection.
# 4. Add imported cases before or after depletion.
# 5. Chain delays for clinical outcomes.
# 6. Forecast by continuing from the last fitted day.
#
# ### What might I need to know before starting
#
# It builds on the [Getting started](@ref getting-started) example, with no fitting.

# ## Packages used

using ComposableRecurrences
using ComposableRecurrences: Depletion, Flow, Floor,
    Add, exponential_history
using CairoMakie, AlgebraOfGraphics, DataFramesMeta
using ForwardDiff

CairoMakie.activate!(type = "png", px_per_unit = 2)

# ## A renewal process
#
# The renewal process is the one in [Getting started](@ref overview-build), with a reproduction number that changes on days 30 and 50.

gi = [0.1, 0.3, 0.3, 0.2, 0.1]
renewal = Recurrence(gi)
T = 80
R = [t <= 30 ? 1.4 : t <= 50 ? 0.9 : 1.2 for t in 1:T]
infections = renewal(R; history = [5.0])

# ### Seeding on a growth path
#
# A single seed day makes the first generations uneven.
# [`exponential_history`](@ref ComposableRecurrences.exponential_history) gives a seed already growing at rate `r` (see [Seeding](@ref explanation-seeding)).
# Its docstring gives the equation linking `r` to `R`, and a few Newton steps solve it.

euler_lotka(r, R, gi) = R * sum(gi[l] * exp(-r * l) for l in eachindex(gi)) - 1
function growth_rate(R, gi; r = 0.0)
    for _ in 1:20
        r -= euler_lotka(r, R, gi) / ForwardDiff.derivative(x -> euler_lotka(x, R, gi), r)
    end
    return r
end
r0 = growth_rate(R[1], gi)
y0 = renewal(R; history = exponential_history(5.0, r0, length(gi)), prepend = true)
round.((exp(r0), extrema(y0[2:20] ./ y0[1:19])...); digits = 4)

# Every daily growth ratio, seed days included, equals ``e^{r}`` until `R` changes.

# ## Susceptible depletion
#
# `Depletion(N)` draws each day's infections from a pool of `N` susceptibles by the hazard form, which [Getting started](@ref overview-build) gives.
# `Depletion(N; form = Floor())` draws them by the floored form, which [`Floor`](@ref ComposableRecurrences.Floor) gives.

N = 2_000.0
R_high = fill(1.8, T)
run_with(d) = Recurrence(gi; modifiers = (d,))(R_high; history = [5.0])
plot_infections(runs) = @chain runs begin
    map(((name, d),) -> DataFrame(day = 1:T, model = name, count = run_with(d)), _)
    reduce(vcat, _)
    data(_) * mapping(:day, :count, color = :model => "") * visual(Lines, linewidth = 2)
    draw(_; axis = (xlabel = "Day", ylabel = "Infections"))
end
forms = ["Hazard" => Depletion(N), "Floor" => Depletion(N; form = Floor())]
plot_infections(forms)

#-

round.(N .- [sum(run_with(d)) for (_, d) in forms])

# Both forms end the outbreak as the pool empties.
# The hazard form draws slightly less at the peak and leaves more susceptibles, as the remaining pools show.
# This is because the hazard form draws ``1 - e^{-x}`` where the floored form draws ``x``, and ``1 - e^{-x}`` is below ``x``.

# ## Vaccination
#
# Vaccine doses move susceptibles into a protected pool.
# With the hazard form, each day draws infections from both pools and then moves the doses:
#
# ```math
# \begin{aligned}
# I_t &= \big(S_{t-1} + \sigma V_{t-1}\big) \big(1 - e^{-v_t / N}\big), \\
# m_t &= \min\big(r_t,\ S_{t-1} \, e^{-v_t / N}\big), \\
# S_t &= S_{t-1} \, e^{-v_t / N} - m_t, \\
# V_t &= V_{t-1} \big(1 - \sigma \big(1 - e^{-v_t / N}\big)\big) + m_t,
# \end{aligned}
# ```
#
# where ``v_t = R_t \sum_{l} g_l I_{t-l}`` is the renewal value, ``S_t`` the susceptible pool and ``V_t`` the protected pool.
# ``\sigma`` is the protected pool's relative susceptibility, ``r_t`` the doses on day ``t`` and ``m_t`` the doses moved.
# The doses are capped by what remains of ``S``.
# A [`Depletion`](@ref ComposableRecurrences.Depletion) with `protected = σ` holds both pools, `:S` and `:V`.
# It draws from ``S + \sigma V``, and its `removals` are the doses, moved from `:S` to `:V` up to what remains.
# The `Depletion` docstring gives the general form, with `weights = (S = 1, V = σ)` and the doses as a count [`Flow`](@ref ComposableRecurrences.Flow).
# Let ``e`` be the efficacy.
# An all-or-nothing vaccine fully protects a share ``e`` of the vaccinated.
# This gives ``\sigma = 0``, with ``e`` times the doses moved.
# A leaky vaccine reduces every vaccinated person's risk by ``e``.
# This gives ``\sigma = 1 - e``, with all the doses moved.
# Here 40 doses a day start on day 15.

e = 0.7
doses = [t < 15 ? 0.0 : 40.0 for t in 1:T]
leaky = Depletion(N; protected = 1 - e, removals = TimeVarying(doses))
vaccines = [
    "None" => Depletion(N),
    "All-or-nothing" => Depletion(N; protected = 0.0, removals = TimeVarying(e .* doses)),
    "Leaky" => leaky,
]
plot_infections(vaccines)

# Both vaccines lower the peak.
# The peak comes slightly earlier, because the pool shrinks faster.
# At the same efficacy the all-or-nothing vaccine prevents slightly more infections.
# The leaky vaccine leaves every vaccinated person some risk, which adds up over time.
# A delay from dose to protection is a `Convolution` of the doses, passed as the flow's demand.
#
# ### Waning protection
#
# Protection that wanes moves people from the protected pool back to the susceptible pool.
# The pool's flows act after each day's infections.
# So waning at rate ``\omega`` is a hazard flow, `Flow(:V => :S, ω)`.
# Hazard flows act before count flows, so it acts before the day's doses:
#
# ```math
# V'_t = e^{-\omega} V_t, \qquad
# S'_t = S_t + \big(1 - e^{-\omega}\big) V_t,
# ```
#
# with ``S_t`` and ``V_t`` the pools after the day's infections.
# Here protection lasts about 20 days on average.

waning = Depletion(
    N; protected = 1 - e, removals = TimeVarying(doses), flows = Flow(:V => :S, 1 / 20)
)
plot_infections(["Leaky" => leaky, "Leaky, waning" => waning])

# Waning raises the peak a little and adds about 8% more infections over the outbreak, because people protected early return to the susceptible pool while the epidemic runs.
#
# The final sizes of these vaccines match seeded stochastic SIR simulations from [EpiBranch.jl](https://github.com/epiforecasts/EpiBranch.jl); the [vaccination use case](https://github.com/EpiAware/ComposableRecurrences.jl/blob/main/test/usecases/vaccination.jl) checks them.

# ## [Imported cases](@id tutorial-imports)
#
# Let ``h(\cdot)`` be the depletion draw above and ``\iota_t`` the imports on day ``t``.
# Imports passed as `add` and as an `Add` after `Depletion` give
#
# ```math
# I^{\text{before}}_t = h\Big(R_t \sum_{l} g_l I_{t-l} + \iota_t\Big), \qquad
# I^{\text{after}}_t = h\Big(R_t \sum_{l} g_l I_{t-l}\Big) + \iota_t.
# ```
#
# `add` enters before the modifiers, so imports are drawn from the pool like local cases.
# `Add` enters where it sits in the modifier tuple.
# After `Depletion`, the imports are added on top.

ι = [t <= 10 ? 3.0 : 0.0 for t in 1:T]
before = Recurrence(gi; modifiers = (Depletion(N),))(R_high; history = [0.0], add = ι)
after = Recurrence(gi; modifiers = (Depletion(N), Add(TimeVarying(ι))))(R_high; history = [0.0])
round.((sum(before), sum(after)))

#-

@chain DataFrame("day" => 1:T, "add, drawn from the pool" => before, "Add after Depletion" => after) begin
    stack(Not(:day); variable_name = :series, value_name = :count)
    data(_) * mapping(:day, :count, color = :series) * visual(Lines, linewidth = 2)
    draw(_; axis = (xlabel = "Day", ylabel = "Infections"))
end

# Imports added after depletion are not drawn from the pool.
# More susceptibles remain and the total is larger.

# ## Clinical outcomes
#
# A reporting delay is a `Convolution` with the ascertainment as its gain, as in [Getting started](@ref overview-build).
# Each clinical transition is the same: a delay that happens with some probability.
# Onsets ``O_t`` follow infections.
# Admissions follow onsets with probability ``h``.
# Deaths follow admissions with probability ``f``:
#
# ```math
# A_t = h \sum_{l} d^A_l O_{t-l}, \qquad D_t = f \sum_{l} d^D_l A_{t-l}.
# ```
#
# The chain is one convolution with gain ``h f``, whose kernel convolves the three delays.

onsets = Convolution([0.0, 0.2, 0.5, 0.3])(infections)
admissions = Convolution([0.3, 0.4, 0.2, 0.1])(onsets; gain = 0.1)
deaths = Convolution([0.1, 0.2, 0.4, 0.2, 0.1])(admissions; gain = 0.25)
round.((sum(admissions), sum(deaths)) ./ sum(infections); digits = 3)

# The shares are below ``h = 0.1`` and ``h f = 0.025``.
# Infections still grow at the end, and the last ones have outcomes after the run.

# ## Forecasting by continuing a run
#
# `renewal(R; history, stop = 50, state = true)` runs to day 50 and also returns a `State`.
# Here the state holds the infections ``I_{46}, \dots, I_{50}`` and the next day, 51.
# Passing it back as `state` continues the run, and returns the next `State`; [History and state](@ref explanation-history-state) explains what a `State` holds.

split = 50
fitted, state = renewal(R; history = [5.0], stop = split, state = true)
forecast, _ = renewal(R; state)
@chain DataFrame(day = 1:T, count = vcat(fitted, forecast)) begin
    @transform(:series = ifelse.(:day .<= split, "Fitted", "Forecast"))
    data(_) * mapping(:day, :count, color = :series) * visual(Lines, linewidth = 2) +
        mapping([split + 0.5]) * visual(VLines, color = :grey, linestyle = :dash)
    draw(_; axis = (xlabel = "Day", ylabel = "Infections"))
end

# The two calls together match one call over all 80 days exactly.

maximum(abs, vcat(fitted, forecast) .- infections)

# ## Learning more
#
# - The [API overview](@ref api-overview) lists every operator, coupling and modifier.
# - Want the full interface? See the [Public API](@ref public-api).
