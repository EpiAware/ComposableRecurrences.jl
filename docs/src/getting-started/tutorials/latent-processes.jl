# # [Latent processes driving R_t](@id tutorial-latent-rt)
#
# ## Introduction
#
# A smoothly changing reproduction number is often a latent process on the log scale.
# Random walks, AR and MA processes are recurrences or convolutions of innovations.
# This tutorial builds each from the same innovations.
# It then uses one as the log reproduction number of a renewal process.
#
# ### What are we going to do in this exercise
#
# 1. Build a random walk, an AR(2) and an MA(2) process from the same innovations.
# 2. Show that a time-varying AR coefficient can be a kernel or a multiplier.
# 3. Drive a renewal process with the exponential of an AR(1) process.
#
# ### What might I need to know before starting
#
# You should know the [Getting started](@ref getting-started) example and AR processes.
# No fitting is involved.

# ## Packages used

using ComposableRecurrences
using CairoMakie, AlgebraOfGraphics, DataFramesMeta
using Random

CairoMakie.activate!(type = "png", px_per_unit = 2)

# ## Three processes from one set of innovations
#
# Each process takes the innovations as `add`.
# With no gain the call runs over the length of `add`.
# The processes are those in the [time-series table](@ref overview-time-series).

T = 100
ϵ = 0.1 .* randn(Xoshiro(1), T)

rw = Recurrence([1.0])(; history = [0.0], add = ϵ)
ar = Recurrence([0.6, 0.3])(; history = zeros(2), add = ϵ)
ma = Convolution([1.0, 0.8, 0.4])(ϵ)

@chain DataFrame("day" => 1:T, "Random walk" => rw, "AR(2)" => ar, "MA(2)" => ma) begin
    stack(Not(:day); variable_name = :series, value_name = :value)
    data(_) * mapping(:day, :value, color = :series, layout = :series) *
        visual(Lines, linewidth = 2)
    draw(_; axis = (xlabel = "Day", ylabel = "Value"))
end

# The random walk wanders furthest, because every innovation persists.
# The AR(2) process follows it loosely: its coefficients sum to 0.9, so innovations decay.
# The MA(2) process stays near zero, because it forgets each innovation after two days.

# ## A time-varying AR coefficient
#
# A changing AR(1) coefficient can be a [`TimeVarying`](@ref) kernel, one column per day.
# With a single lag it can also be the gain on the unit kernel.

ρ = range(0.95, 0.5; length = T)
tvar_kernel = Recurrence(TimeVarying(reshape(collect(ρ), 1, :)))(; history = [0.0], add = ϵ)
tvar_gain = Recurrence([1.0])(ρ; history = [0.0], add = ϵ)
maximum(abs, tvar_kernel .- tvar_gain)

#-

fixed = Recurrence([0.95])(; history = [0.0], add = ϵ)
@chain DataFrame(
    "day" => 1:T, "Fixed at 0.95" => fixed, "Falling from 0.95 to 0.5" => tvar_kernel
) begin
    stack(Not(:day); variable_name = :series, value_name = :value)
    data(_) * mapping(:day, :value, color = :series) * visual(Lines, linewidth = 2)
    draw(_; axis = (xlabel = "Day", ylabel = "Value"))
end

# The two agree at first.
# As the coefficient falls, innovations fade sooner and the process stays nearer zero.

# ## An AR(1) process as the log reproduction number
#
# The exponential of a latent process is a positive reproduction number.
# An AR(1) process with a coefficient below one reverts to zero, so ``R_t`` stays near 1.
# Twenty draws of the innovations give twenty paths of ``R_t`` and their infections.

renewal = Recurrence([0.1, 0.3, 0.3, 0.2, 0.1])
rng = Xoshiro(2)
@chain 1:20 begin
    map(_) do i
        log_R = Recurrence([0.95])(; history = [0.0], add = 0.05 .* randn(rng, T))
        R = exp.(log_R)
        DataFrame(
            "day" => 1:T, "draw" => i, "Reproduction number" => R,
            "Infections" => renewal(R; history = fill(10.0, 5))
        )
    end
    reduce(vcat, _)
    stack(Not([:day, :draw]); variable_name = :quantity, value_name = :value)
    data(_) * mapping(:day, :value, group = :draw => nonnumeric, layout = :quantity) *
        visual(Lines, linewidth = 1, alpha = 0.5)
    draw(_; axis = (xlabel = "Day", ylabel = "Value"), facet = (; linkyaxes = :none))
end

# ``R_t`` stays between about 0.6 and 1.8 in every draw.
# Small differences in ``R_t`` compound, so some outbreaks die out and others grow large.

# ## Learning more
#
# - See every operator, coupling and modifier on the [API overview](@ref api-overview).
# - Want the full interface? See the [Public API](@ref public-api).
