# # [Vaccination](@id tutorial-vaccination)
#
# ## Introduction
#
# Vaccine doses move susceptibles into a protected pool.
# Here a renewal process with susceptible depletion gets all-or-nothing, leaky and waning protection.
#
# ### What might I need to know before starting
#
# It builds on [Renewal then delay](@ref tutorial-renewal-delay), whose depletion section introduces the pool of susceptibles.

# ## Packages used

using ComposableRecurrences
using ComposableRecurrences: Depletion, Flow, Hazard, Truncate
using CairoMakie, AlgebraOfGraphics, DataFramesMeta

CairoMakie.activate!(type = "png", px_per_unit = 2)

# ## Two pools
#
# With the hazard form, each day draws infections from both pools and then moves the doses:
#
# ```math
# \begin{aligned}
# v_t &= R_t \sum_{l=1}^{L} g_l \, I_{t-l}, \\
# I_t &= \big(S_{t-1} + \sigma V_{t-1}\big) \big(1 - e^{-v_t / N}\big), \\
# q_t &= \min\big(d_t,\ S_{t-1} \, e^{-v_t / N}\big), \\
# S_t &= S_{t-1} \, e^{-v_t / N} - q_t, \\
# V_t &= V_{t-1} \big(1 - \sigma \big(1 - e^{-v_t / N}\big)\big) + q_t,
# \end{aligned}
# ```
#
# where ``v_t`` is the number of new infections before depletion, ``S_t`` the susceptible pool and ``V_t`` the protected pool.
# ``\sigma`` is the protected pool's relative susceptibility, ``d_t`` the doses on day ``t`` and ``q_t`` the doses moved.
# The doses moved are capped by what remains of ``S``.
# A [`Depletion`](@ref ComposableRecurrences.Depletion) holds both pools, `:S` and `:V`.
# Its `Hazard(; weights = (S = 1, V = σ))` draws from ``S + \sigma V``, and a count [`Flow`](@ref ComposableRecurrences.Flow) after it moves the doses from `:S` to `:V`.
#
# Let ``e`` be the efficacy.
# An all-or-nothing vaccine fully protects a share ``e`` of the vaccinated.
# This gives ``\sigma = 0``, with ``e \, d_t`` doses moved.
# A leaky vaccine reduces every vaccinated person's risk by ``e``.
# This gives ``\sigma = 1 - e``, with all ``d_t`` doses moved.
# Here ``e`` is 0.7, ``N`` is 2000, ``R_t`` is 1.8 and 40 doses a day start on day 15.

gi = [0.1, 0.3, 0.3, 0.2, 0.1]
T = 80
N = 2_000.0
R = fill(1.8, T)
e = 0.7
doses = [t < 15 ? 0.0 : 40.0 for t in 1:T]
vaccinated(σ, d, flows...) = Depletion(
    N, Hazard(; weights = (S = 1, V = σ)),
    Flow(:S => :V, TimeVarying(d); form = Truncate()), flows...; pools = (:S, :V)
)
run_with(d) = Recurrence(gi; modifiers = (d,))(R; history = [5.0])
plot_infections(runs) = @chain runs begin
    map(((name, d),) -> DataFrame(day = 1:T, vaccine = name, count = run_with(d)), _)
    reduce(vcat, _)
    data(_) * mapping(:day, :count, color = :vaccine => "") * visual(Lines, linewidth = 2)
    draw(_; axis = (xlabel = "Day", ylabel = "Infections"))
end

leaky = vaccinated(1 - e, doses)
vaccines = [
    "None" => Depletion(N),
    "All-or-nothing" => vaccinated(0.0, e .* doses),
    "Leaky" => leaky,
]
plot_infections(vaccines)

# Both vaccines lower the peak and bring it slightly earlier, because the susceptible pool shrinks faster.
# At the same efficacy the all-or-nothing vaccine prevents slightly more infections.
# The leaky vaccine leaves every vaccinated person some risk, which adds up over time.
# A delay from dose to protection is a [`Convolution`](@ref) of the doses, passed as the flow's demand.

# ## Waning protection
#
# Protection that wanes moves people from the protected pool back to the susceptible pool.
# Waning at rate ``\omega`` is a hazard flow, `Flow(:V => :S, ω)`.
# The pool's flows act after each day's infections, and hazard flows act before count flows, so waning acts before the day's doses:
#
# ```math
# V'_t = e^{-\omega} V_t, \qquad
# S'_t = S_t + \big(1 - e^{-\omega}\big) V_t,
# ```
#
# where ``S_t`` and ``V_t`` are the pools after the day's infections and ``S'_t`` and ``V'_t`` the pools after waning.
# Here ``\omega`` is 1/20, so protection lasts 20 days on average.

waning = vaccinated(1 - e, doses, Flow(:V => :S, 1 / 20))
plot_infections(["Leaky" => leaky, "Leaky, waning" => waning])

# Waning raises the peak a little and adds about 8% more infections over the outbreak.
# This is because people protected early return to the susceptible pool while the epidemic runs.
#
# The final sizes of these vaccines match seeded stochastic SIR simulations from [EpiBranch.jl](https://github.com/epiforecasts/EpiBranch.jl), as the [vaccination use case](https://github.com/EpiAware/ComposableRecurrences.jl/blob/main/test/usecases/vaccination.jl) checks.

# ## Performance
#
# Each bar times leaky vaccination with waning protection over 200 days with a 20-day generation interval, written with the operators or as a preallocated hand-written loop.

include(joinpath(pkgdir(ComposableRecurrences), "docs", "performance.jl")) #hide
performance_plot("vaccination")

# ## Learning more
#
# - [Infectious disease models](@ref infectious-disease-models): the operator for each model part, vaccines included.
# - Want the full interface? See the [Public API](@ref public-api).
