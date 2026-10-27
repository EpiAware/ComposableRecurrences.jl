# # [Imported cases](@id tutorial-imports)
#
# ## Introduction
#
# Imported cases are infections that arrive from outside the population.
# They can enter a renewal process with susceptible depletion before the depletion or after it.
#
# ### What might I need to know before starting
#
# It builds on [Renewal then delay](@ref tutorial-renewal-delay), whose depletion section introduces the pool of susceptibles.

# ## Packages used

using ComposableRecurrences
using ComposableRecurrences: Depletion, Add
using CairoMakie, AlgebraOfGraphics, DataFramesMeta

CairoMakie.activate!(type = "png", px_per_unit = 2)

# ## Before or after depletion
#
# Let ``h(\cdot)`` be the hazard draw from the susceptible pool and ``\iota_t`` the imports on day ``t``.
# Imports passed as `add` and as an [`Add`](@ref ComposableRecurrences.Add) after the [`Depletion`](@ref ComposableRecurrences.Depletion) give
#
# ```math
# I^{\text{before}}_t = h\Big(R_t \sum_{l=1}^{L} g_l \, I_{t-l} + \iota_t\Big), \qquad
# I^{\text{after}}_t = h\Big(R_t \sum_{l=1}^{L} g_l \, I_{t-l}\Big) + \iota_t,
# ```
#
# where ``I_t`` is the number of infections on day ``t``, ``R_t`` the reproduction number and ``g_l`` the generation interval's weight on lag ``l``.
# The draw is ``h(v) = S_{t-1} \big(1 - e^{-v / N}\big)``, with ``S_t`` the pool and ``N`` the population.
# The `add` keyword enters before the modifiers, so imports are drawn from the pool like local cases.
# An `Add` enters where it sits in the modifier tuple.
# After the `Depletion`, the imports are added on top and do not draw down the pool.
# Here 3 cases a day arrive on days 1 to 10, ``N`` is 2000 and ``R_t`` is 1.8.

gi = [0.1, 0.3, 0.3, 0.2, 0.1]
T = 80
N = 2_000.0
R = fill(1.8, T)
ι = [t <= 10 ? 3.0 : 0.0 for t in 1:T]
before = Recurrence(gi; modifiers = (Depletion(N),))(R; history = [0.0], add = ι)
after = Recurrence(gi; modifiers = (Depletion(N), Add(TimeVarying(ι))))(R; history = [0.0])

@chain DataFrame("day" => 1:T, "add, drawn from the pool" => before, "Add after Depletion" => after) begin
    stack(Not(:day); variable_name = :imports, value_name = :count)
    data(_) * mapping(:day, :count, color = :imports => "") * visual(Lines, linewidth = 2)
    draw(_; axis = (xlabel = "Day", ylabel = "Infections"))
end

# The 30 imports added after the depletion are not drawn from the pool, so local spread has more susceptibles to infect.
# The peak is higher, 93 infections against 88, and the outbreak leaves a smaller pool.

# ## Performance
#
# Each bar times a seeded renewal with hazard depletion and imports both before and after it over 200 days with a 20-day generation interval, written with the operators or as a preallocated hand-written loop.

include(joinpath(pkgdir(ComposableRecurrences), "docs", "performance.jl")) #hide
performance_plot("imports")

# ## Learning more
#
# - [Modifier order](@ref explanation-modifier-order): how the place of a modifier in the tuple changes the model.
# - Want the full interface? See the [Public API](@ref public-api).
