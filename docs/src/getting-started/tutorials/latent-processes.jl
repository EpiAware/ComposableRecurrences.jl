# # [Latent processes driving R_t](@id tutorial-latent-rt)
#
# ## Introduction
#
# A smoothly changing reproduction number is often a latent process on the log scale.
# Random walks, AR and MA processes are recurrences or convolutions of innovations.
# This tutorial builds each from the same innovations.
# It then uses one as the log reproduction number of a renewal process.
# Last, it lets transmission respond to incidence through [`Transform`](@ref ComposableRecurrences.Transform) and [`Recent`](@ref).
#
# ### What are we going to do in this exercise
#
# 1. Build a random walk, an AR(2) and an MA(2) process from the same innovations.
# 2. Show that a time-varying AR coefficient can be a kernel or a multiplier.
# 3. Drive a renewal process with the exponential of an AR(1) process.
# 4. Saturate transmission as incidence rises, and take its gradient.
# 5. Drive a response and vaccination from recent incidence.
#
# ### What might I need to know before starting
#
# You should know the [Getting started](@ref getting-started) example and AR processes.
# No fitting is involved.

# ## Packages used

using ComposableRecurrences
using ComposableRecurrences: Transform, Depletion
using CairoMakie, AlgebraOfGraphics, DataFramesMeta
using ForwardDiff
using Random

CairoMakie.activate!(type = "png", px_per_unit = 2)

# ## Three processes from one set of innovations
#
# With innovations ``\epsilon_t``, the three processes are
#
# ```math
# z^{\text{RW}}_t = z^{\text{RW}}_{t-1} + \epsilon_t, \qquad
# z^{\text{AR}}_t = 0.6 \, z^{\text{AR}}_{t-1} + 0.3 \, z^{\text{AR}}_{t-2}
#     + \epsilon_t, \qquad
# z^{\text{MA}}_t = \epsilon_t + 0.8 \, \epsilon_{t-1} + 0.4 \, \epsilon_{t-2}.
# ```
#
# Each recurrence takes the innovations as `add`.
# The MA(2) process is a convolution of them.
# ``z_t`` is each process's value on day ``t``.
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
# An AR(1) process with a coefficient ``\rho_t`` that changes by day is
#
# ```math
# z_t = \rho_t \, z_{t-1} + \epsilon_t.
# ```
#
# ``\rho_t`` can be a [`TimeVarying`](@ref) kernel, one column per day.
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
# The exponential of a latent process is a positive reproduction number:
#
# ```math
# \log R_t = 0.95 \log R_{t-1} + \epsilon_t, \qquad I_t = R_t \sum_{l=1}^{L} g_l \, I_{t-l}.
# ```
#
# Here ``\epsilon_t`` are new draws with standard deviation 0.05.
# ``I_t`` is the number of infections and ``g_l`` the generation interval of length ``L``.
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

# ## Transmission that saturates with incidence
#
# People may reduce their contacts when incidence is high.
# A saturating form (Capasso and Serio 1978) caps daily infections below ``\kappa``:
#
# ```math
# f(v, \kappa) = \frac{v}{1 + v / \kappa},
# ```
#
# where ``v`` is the renewal value ``R \sum_{l} g_l I_{t-l}``.
# With a constant ``R > 1`` infections settle at ``\kappa (R - 1) / R``.

gi = [0.1, 0.3, 0.3, 0.2, 0.1]
R = fill(1.5, T)
saturate(v, κ) = v / (1 + v / κ)

@chain [100.0, 300.0] begin
    map(_) do κ
        y = Recurrence(gi; modifiers = (Transform(saturate, κ),))(R; history = [5.0])
        DataFrame(day = 1:T, series = "κ = $(Int(κ))", count = y)
    end
    reduce(vcat, _)
    vcat(_, DataFrame(day = 1:T, series = "No response", count = Recurrence(gi)(R; history = [5.0])))
    data(_) * mapping(:day, :count, color = :series) * visual(Lines, linewidth = 2)
    draw(_; axis = (xlabel = "Day", ylabel = "Infections (log scale)", yscale = log10))
end

# The gradient of the total infections with respect to ``\kappa`` and a constant ``R``:

function total_infections(x)
    modifiers = (Transform(saturate, x[1]),)
    return sum(Recurrence(gi; modifiers)(fill(x[2], T); history = [5.0]))
end
ForwardDiff.gradient(total_infections, [100.0, 1.5])

# ## Feedback from recent incidence
#
# The saturating response reacts to the current day only.
# A response to the last week's incidence is built from parts instead of a bespoke modifier.
# [`Recent`](@ref) reads the recurrence's own past outputs, [`Derived`](@ref) maps them, and any modifier parameter takes the result.
# The response scales the renewal value, and a [`Depletion`](@ref ComposableRecurrences.Depletion) of a pool of ``N`` then draws from it:
#
# ```math
# v'_t = \exp\Big(-\frac{\kappa}{N} \sum_{l=1}^{7} y_{t-l}\Big)\, R_t \sum_{l} g_l\, y_{t-l},
# ```
#
# where ``y_t`` is the infections drawn on day ``t`` and ``v'_t`` the value the depletion draws them from.
# The same source can drive ring vaccination, removing doses from the susceptible pool in proportion to recent cases (@placeholder).

N = 5_000.0
κr = 10.0
response = Transform(*, Derived(exp, -κr / N * Recent(7)))
ring = Depletion(N; removals = 0.5 * Recent(7))
feedback = [
    "Depletion only" => (Depletion(N),),
    "Response to the last week" => (response, Depletion(N)),
    "Ring vaccination" => (ring,),
    "Both" => (response, ring),
]
@chain feedback begin
    map(_) do (name, modifiers)
        y = Recurrence(gi; modifiers)(R; history = [5.0])
        DataFrame(day = 1:T, model = name, count = y)
    end
    reduce(vcat, _)
    data(_) * mapping(:day, :count, color = :model) * visual(Lines, linewidth = 2)
    draw(_; axis = (xlabel = "Day", ylabel = "Infections"))
end

# Both measures cut the peak, and together they cut it further than either alone.
# The reverse-mode rule sends each gradient back through the outputs that `Recent` reads, so Mooncake and Enzyme follow the feedback too.
# ForwardDiff gives the gradient of the total infections with respect to the response strength and ``R``:

function total_with_response(x)
    modifiers = (Transform(*, Derived(exp, -x[1] / N * Recent(7))), Depletion(N))
    return sum(Recurrence(gi; modifiers)(fill(x[2], T); history = [5.0]))
end
ForwardDiff.gradient(total_with_response, [κr, 1.5])

# ## References
#
# - Capasso and Serio (1978), "A generalization of the Kermack-McKendrick
#   deterministic epidemic model", Mathematical Biosciences 42, 43-61,
#   [10.1016/0025-5564(78)90006-8](https://doi.org/10.1016/0025-5564%2878%2990006-8)

# ## Learning more
#
# - See every operator, coupling and modifier on the [API overview](@ref api-overview).
# - Want the full interface? See the [Public API](@ref public-api).
