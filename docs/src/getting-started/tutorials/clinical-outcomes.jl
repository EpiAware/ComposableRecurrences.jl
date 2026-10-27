# # [Clinical outcomes](@id tutorial-clinical-outcomes)
#
# ## Introduction
#
# Each clinical transition is a delay that happens with some probability.
# Here symptom onsets follow infections, hospital admissions follow onsets and deaths follow admissions.
#
# ### What might I need to know before starting
#
# It builds on the reporting delay of [Getting started](@ref overview-build).

# ## Packages used

using ComposableRecurrences
using CairoMakie, AlgebraOfGraphics, DataFramesMeta

CairoMakie.activate!(type = "png", px_per_unit = 2)

# ## Infections
#
# The infections come from the renewal process of [Renewal then delay](@ref tutorial-renewal-delay):
#
# ```math
# I_t = R_t \sum_{l=1}^{L} g_l \, I_{t-l},
# ```
#
# where ``I_t`` is the number of infections on day ``t``, ``R_t`` the reproduction number and ``g_l`` the generation interval's weight on lag ``l``.
# Here ``R_t`` is 1.4 to day 30, 0.9 to day 50 and 1.2 after.

gi = [0.1, 0.3, 0.3, 0.2, 0.1]
T = 80
R = [t <= 30 ? 1.4 : t <= 50 ? 0.9 : 1.2 for t in 1:T]
infections = Recurrence(gi)(R; history = [5.0])
nothing #hide

# ## A chain of delays
#
# Onsets ``O_t`` follow infections.
# Admissions ``A_t`` follow onsets with probability ``h``.
# Deaths ``D_t`` follow admissions with probability ``f``:
#
# ```math
# O_t = \sum_{l=0}^{3} d^O_l \, I_{t-l}, \qquad
# A_t = h \sum_{l=0}^{3} d^A_l \, O_{t-l}, \qquad
# D_t = f \sum_{l=0}^{4} d^D_l \, A_{t-l},
# ```
#
# where ``d^O_l``, ``d^A_l`` and ``d^D_l`` are the weights of the three delays on lag ``l``.
# Each transition is a [`Convolution`](@ref) with its probability as the gain.
# Here ``h`` is 0.1 and ``f`` is 0.25.

onsets = Convolution([0.0, 0.2, 0.5, 0.3])(infections)
admissions = Convolution([0.3, 0.4, 0.2, 0.1])(onsets; gain = 0.1)
deaths = Convolution([0.1, 0.2, 0.4, 0.2, 0.1])(admissions; gain = 0.25)

@chain DataFrame(
    "day" => 1:T, "Infections" => infections, "Onsets" => onsets,
    "Admissions" => admissions, "Deaths" => deaths
) begin
    stack(Not(:day); variable_name = :outcome, value_name = :count)
    data(_) * mapping(:day, :count, row = :outcome => sorter("Infections", "Onsets", "Admissions", "Deaths")) *
        visual(Lines, linewidth = 2)
    draw(_; axis = (xlabel = "Day", ylabel = "Count"), facet = (; linkyaxes = :none))
end

# Each outcome follows the shape of the one before, later and smaller.
# Over the run, admissions are 8.5% of infections and deaths 1.9%.
# These shares are below ``h = 0.1`` and ``h f = 0.025``, because infections still grow at the end and the last ones have outcomes after the run.

# ## One delay from onset to death
#
# Two delays one after the other are one delay whose weights are the convolution of theirs:
#
# ```math
# D_t = h f \sum_{l=0}^{7} \big(d^A \circledast d^D\big)_l \, O_{t-l}, \qquad
# \big(d^A \circledast d^D\big)_l = \sum_{j=0}^{l} d^A_j \, d^D_{l-j}.
# ```
#
# A [chain of delays](@ref time-units-chained), the tuple `(dA, dD)`, is this delay.
# It needs `lags`, here the 8 lags of the full convolution.

dA, dD = [0.3, 0.4, 0.2, 0.1], [0.1, 0.2, 0.4, 0.2, 0.1]
onset_to_death = Convolution((dA, dD); lags = 8)
deaths_direct = onset_to_death(onsets; gain = 0.1 * 0.25)
@assert deaths_direct ≈ deaths #hide

@chain DataFrame("day" => 1:T, "Two delays" => deaths, "One chained delay" => deaths_direct) begin
    stack(Not(:day); variable_name = :model, value_name = :count)
    data(_) * mapping(:day, :count, color = :model => "", linestyle = :model => "") *
        visual(Lines, linewidth = 2)
    draw(_; axis = (xlabel = "Day", ylabel = "Deaths"))
end

# The two lines overlap: the chained delay gives the same deaths, to rounding error.

# ## Performance
#
# Each bar times onsets, admissions and deaths as a chain of three delays over 200 days with 20-day delays, written with the operators or as a preallocated hand-written loop.

include(joinpath(pkgdir(ComposableRecurrences), "docs", "performance.jl")) #hide
performance_plot("clinical outcomes")

# ## Learning more
#
# - [Time-varying delays and kernels](@ref tutorial-time-varying-kernels): delays that change over time.
# - Want the full interface? See the [Public API](@ref public-api).
