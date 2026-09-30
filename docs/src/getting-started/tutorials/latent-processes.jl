# # [Latent processes driving R_t](@id tutorial-latent-rt)
#
# ## Introduction
#
# A reproduction number that changes smoothly over time is often modelled as a latent process on the log scale.
# Random walks, autoregressions and moving averages are all recurrences or convolutions driven by innovations.
# This tutorial builds each from the same innovations, then uses one as the log reproduction number of a renewal process.
#
# ### What are we going to do in this exercise
#
# 1. Build a random walk, an AR(2) and an MA(2) process from the same innovations.
# 2. Show that a time-varying AR coefficient can be a kernel or a multiplier.
# 3. Drive a renewal process with the exponential of an AR(1) process.
#
# ### What might I need to know before starting
#
# This tutorial builds on the [Getting started](@ref getting-started) overview and the [API overview](@ref api-overview), and uses AlgebraOfGraphics.jl and CairoMakie.jl for plotting.
# No fitting is involved.

# ## Packages used

using ComposableRecurrences
using CairoMakie, AlgebraOfGraphics, DataFramesMeta
using Random

CairoMakie.activate!(type = "png", px_per_unit = 2)

# ## Three processes from one set of innovations
#
# Each process is driven by the innovations through `add`.
# A call with no multiplier (gain) runs over the length of `add`.
# A random walk is a recurrence with the unit kernel `[1.0]`.
# An AR(p) process is a recurrence whose kernel is its coefficients, lag 1 first.
# An MA(q) process is a convolution with kernel `[1; θ]`, lag 0 first.
# The operators do not prepend histories or trim outputs, so each process starts from zero and the MA process reads its first `q` innovations from the input itself.

T = 100
ϵ = 0.1 .* randn(Xoshiro(1), T)

rw = Recurrence([1.0])(; history = [0.0], add = ϵ)
ar = Recurrence([0.6, 0.3])(; history = zeros(2), add = ϵ)
ma = Convolution([1.0, 0.8, 0.4])(ϵ)

processes = vcat(
    DataFrame(day = 1:T, value = rw, series = "Random walk"),
    DataFrame(day = 1:T, value = ar, series = "AR(2)"),
    DataFrame(day = 1:T, value = ma, series = "MA(2)")
)
draw(
    data(processes) * mapping(:day, :value, color = :series, layout = :series) *
        visual(Lines, linewidth = 2);
    axis = (xlabel = "Day", ylabel = "Value")
)

# The random walk wanders furthest, because every innovation persists.
# The AR(2) process follows it more loosely, because its coefficients sum to 0.9 and old innovations decay.
# The MA(2) process stays near zero, because it forgets each innovation after two days.

# ## A time-varying AR coefficient
#
# An AR(1) coefficient that changes over time can be a `TimeVarying` kernel, one column per day.
# With a single lag it can also be the multiplier (gain) on the unit kernel, and the two give the same output.

ρ = range(0.95, 0.5; length = T)
tvar_kernel = Recurrence(TimeVarying(reshape(collect(ρ), 1, :)))(; history = [0.0], add = ϵ)
tvar_gain = Recurrence([1.0])(ρ; history = [0.0], add = ϵ)
maximum(abs, tvar_kernel .- tvar_gain)

# ## An AR(1) process as the log reproduction number
#
# The exponential of a latent process is a positive reproduction number.
# An AR(1) process with a coefficient below one reverts to zero, so ``R_t`` stays near 1.
# Twenty draws of the innovations give twenty paths of ``R_t`` and the infections each produces.

renewal = Recurrence([0.1, 0.3, 0.3, 0.2, 0.1])
rng = Xoshiro(2)
draws = map(1:20) do i
    log_R = Recurrence([0.95])(; history = [0.0], add = 0.05 .* randn(rng, T))
    infections = renewal(exp.(log_R); history = fill(10.0, 5))
    vcat(
        DataFrame(day = 1:T, value = exp.(log_R), draw = i, quantity = "Reproduction number"),
        DataFrame(day = 1:T, value = infections, draw = i, quantity = "Infections")
    )
end
draw(
    data(vcat(draws...)) *
        mapping(:day, :value, group = :draw => nonnumeric, layout = :quantity) *
        visual(Lines, linewidth = 1, alpha = 0.5);
    axis = (xlabel = "Day", ylabel = "Value"),
    facet = (; linkyaxes = :none)
)

# ``R_t`` stays between about 0.6 and 1.8 in every draw.
# Small differences in ``R_t`` compound, so infections range from dying out to one large outbreak.

# ## Learning more
#
# - See every operator, coupling and modifier used here on the [API overview](@ref api-overview).
# - Want the full interface? See the [Public API](@ref public-api).
