# # [Latent processes driving R_t](@id tutorial-latent-rt)
#
# ## Introduction
#
# A smoothly changing reproduction number is often a latent process on the log scale.
# Random walks, AR and MA processes are recurrences or convolutions of innovations, and they can drive a renewal process.
# It builds on the [Getting started](@ref getting-started) example and AR processes.

# ## Packages used

using ComposableRecurrences
using ComposableRecurrences: Transform, Depletion, Flow, Hazard, Truncate, Derived,
    Recent
using CairoMakie, AlgebraOfGraphics, DataFramesMeta
using ForwardDiff
using Random

CairoMakie.activate!(type = "png", px_per_unit = 2)

# ## Three processes from one set of innovations
#
# ```math
# z^{\text{RW}}_t = z^{\text{RW}}_{t-1} + \epsilon_t, \qquad
# z^{\text{AR}}_t = \phi_1 z^{\text{AR}}_{t-1} + \phi_2 z^{\text{AR}}_{t-2}
#     + \epsilon_t, \qquad
# z^{\text{MA}}_t = \epsilon_t + \theta_1 \epsilon_{t-1} + \theta_2 \epsilon_{t-2}.
# ```
#
# ``z_t`` is each process's value on day ``t``.
# ``\epsilon_t`` is the innovation on day ``t``, drawn with standard deviation 0.1.
# ``\phi_1 = 0.6`` and ``\phi_2 = 0.3`` are the AR coefficients.
# ``\theta_1 = 0.8`` and ``\theta_2 = 0.4`` are the MA coefficients.
# Each recurrence has the AR coefficients as its kernel and takes the innovations as `add`.
# The MA(2) process is a [`Convolution`](@ref) of the innovations with the kernel ``(1, \theta_1, \theta_2)``.
# With no gain the call runs over the length of `add`.
# Other [time-series processes](@ref overview-time-series) are built the same way.

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
# ```math
# z_t = \phi_t \, z_{t-1} + \epsilon_t.
# ```
#
# ``\phi_t`` is the AR coefficient on day ``t``, falling in equal steps from 0.95 on day 1 to 0.5 on day 100.
# ``\epsilon_t`` are the innovations above.
# ``\phi_t`` can be a [`TimeVarying`](@ref) kernel, one column per day.
# With a single lag it can also be the gain ``\gamma_t`` on the unit kernel.
# The gain scales the lag sum before the `add` input is added, so both forms give the same process.
# The comparison holds ``\phi`` at 0.95 throughout.

φ = range(0.95, 0.5; length = T)
tvar_kernel = Recurrence(TimeVarying(reshape(collect(φ), 1, :)))(; history = [0.0], add = ϵ)
tvar_gain = Recurrence([1.0])(φ; history = [0.0], add = ϵ)
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
# The kernel and gain forms agree to round-off.

# ## An AR(1) process as the log reproduction number
#
# ```math
# z_t = \phi \, z_{t-1} + \epsilon_t, \qquad
# \gamma_t = R_t = \exp(z_t), \qquad
# I_t = \gamma_t \sum_{l=1}^{L} g_l \, I_{t-l}.
# ```
#
# ``z_t`` is the log reproduction number, an AR(1) process with coefficient ``\phi = 0.95``.
# ``\epsilon_t`` are new innovations with standard deviation 0.05.
# ``R_t`` is the reproduction number on day ``t``, the gain ``\gamma_t`` of the renewal.
# ``I_t`` is the number of infections on day ``t``.
# ``g_l`` is the generation interval on lag ``l``, with ``L = 5`` lags.
# Each run starts from ten infections on each of the five days before day 1.
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

# ``R_t`` stays between 0.57 and 1.84 across the twenty draws.
# Small differences in ``R_t`` compound, so some outbreaks die out and others grow large.

# ## Transmission that saturates with incidence
#
# People may reduce their contacts when incidence is high.
# A saturating form (Capasso and Serio 1978) caps daily infections below ``\kappa``:
#
# ```math
# v_t = \gamma \sum_{l=1}^{L} g_l \, I_{t-l}, \qquad
# I_t = M_1(v_t) = \frac{v_t}{1 + v_t / \kappa}.
# ```
#
# ``v_t`` is the renewal value on day ``t``, with a constant gain ``\gamma = R = 1.5``.
# ``g_l`` and ``I_t`` are the generation interval and infections of the previous model.
# ``M_1`` is a [`Transform`](@ref ComposableRecurrences.Transform) modifier, the only one.
# ``\kappa`` is the level daily infections stay below.
# Each run starts from five infections on the day before day 1.
# With ``R > 1`` infections settle at ``\kappa (R - 1) / R``, which is 33.3 for ``\kappa = 100`` and 100 for ``\kappa = 300``.

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

# Without the response infections keep growing.
# With it they level off at the values above.
#
# The total infections over the 100 days depend smoothly on ``\kappa`` and ``R``:
#
# ```math
# C(\kappa, R) = \sum_{t=1}^{T} I_t.
# ```
#
# ``T = 100`` is the number of days.
# [ForwardDiff](https://github.com/JuliaDiff/ForwardDiff.jl) gives the gradient of ``C`` at ``\kappa = 100`` and ``R = 1.5``.
# Each panel varies one parameter and holds the other at that point.
# The dashed line in each panel is the tangent the gradient gives.

function total_infections(x)
    modifiers = (Transform(saturate, x[1]),)
    return sum(Recurrence(gi; modifiers)(fill(x[2], T); history = [5.0]))
end
line_names = ["Total infections", "Tangent from the gradient"]
function tangents(f, x0, names, grids)
    grad = ForwardDiff.gradient(f, x0)
    frames = map(eachindex(x0)) do i
        xs = collect(grids[i])
        curve = [f(setindex!(copy(x0), x, i)) for x in xs]
        tangent = f(x0) .+ grad[i] .* (xs .- x0[i])
        DataFrame(
            parameter = names[i], value = vcat(xs, xs), total = vcat(curve, tangent),
            line = repeat(line_names; inner = length(xs))
        )
    end
    return reduce(vcat, frames)
end
@chain tangents(total_infections, [100.0, 1.5], ["κ", "R"], [60:5:140, 1.3:0.02:1.7]) begin
    data(_) * visual(Lines, linewidth = 2) * mapping(
        :value, :total; linestyle = :line => sorter(line_names) => "", layout = :parameter
    )
    draw(
        _; axis = (xlabel = "Parameter value", ylabel = "Total infections"),
        facet = (; linkxaxes = :none)
    )
end

# Each tangent touches its curve at the point, so the gradient matches the slope.

# ## Feedback from recent incidence
#
# The saturating response reacts to the current day only.
# A response to the last week's incidence is built from existing modifiers.
# The parameter [`Recent`](@ref ComposableRecurrences.Recent) reads the recurrence's own past outputs, [`Derived`](@ref ComposableRecurrences.Derived) maps them, and any modifier parameter takes the result.
# The response scales the renewal value, and a [`Depletion`](@ref ComposableRecurrences.Depletion) of a pool of ``N`` then draws from it.
# The same source can drive ring vaccination, removing doses from the susceptible pool in proportion to recent cases:
#
# ```math
# \begin{aligned}
# v_t &= \gamma \sum_{l=1}^{L} g_l \, I_{t-l}, \qquad
# v'_t = M_1(v_t) = \exp\Big(-\frac{\kappa}{N} \sum_{l=1}^{7} I_{t-l}\Big)\, v_t, \\
# I_t &= S_{t-1} \big(1 - e^{-v'_t / N}\big), \qquad
# S_t = S_{t-1} - I_t - D_t, \\
# D_t &= \min\Big(0.5 \sum_{l=1}^{7} I_{t-l},\ \max\big(S_{t-1} - I_t,\ 0\big)\Big).
# \end{aligned}
# ```
#
# ``v_t`` is the renewal value with gain ``\gamma = 1.5``, and ``v'_t`` the value after the response.
# ``M_1`` is the response, a [`Transform`](@ref ComposableRecurrences.Transform) with strength ``\kappa = 10``.
# ``S_t`` is the susceptible pool after day ``t``, starting at ``N = 5000``.
# The depletion is the second modifier ``M_2``, which draws ``I_t`` from the pool by the [hazard form](@ref ComposableRecurrences.Hazard).
# ``D_t`` is the ring vaccination doses on day ``t``, half the last week's infections.
# The models without a response take ``v'_t = v_t``, and those without ring vaccination take ``D_t = 0``.

N = 5_000.0
κr = 10.0
response = Transform(*, Derived(exp, -κr / N * Recent(7)))
ring = Depletion(N, Hazard(), Flow(:S => 0, 0.5 * Recent(7); form = Truncate()))
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

# Depletion alone peaks at 111 infections on day 37.
# The response lowers the peak to 23 and ring vaccination to 36.
# Together they lower it to 16.
#
# The [reverse-mode rule](@ref adjoint-routing) sends gradients back through the outputs `Recent` reads, so Mooncake and Enzyme follow the feedback.
# ForwardDiff gives the gradient of the total infections ``C(\kappa, R)`` of the response-and-depletion model at ``\kappa = 10`` and ``R = 1.5``.

function total_with_response(x)
    modifiers = (Transform(*, Derived(exp, -x[1] / N * Recent(7))), Depletion(N))
    return sum(Recurrence(gi; modifiers)(fill(x[2], T); history = [5.0]))
end
@chain tangents(total_with_response, [κr, 1.5], ["κ", "R"], [0:1:20, 1.3:0.02:1.7]) begin
    data(_) * visual(Lines, linewidth = 2) * mapping(
        :value, :total; linestyle = :line => sorter(line_names) => "", layout = :parameter
    )
    draw(
        _; axis = (xlabel = "Parameter value", ylabel = "Total infections"),
        facet = (; linkxaxes = :none)
    )
end

# A stronger response lowers the total, and a higher ``R`` raises it.
# Each tangent touches its curve at the point.

# ## Performance
#
# Each bar times an AR(2) process over 200 days, written with the operators or as a preallocated hand-written loop.

include(joinpath(pkgdir(ComposableRecurrences), "docs", "performance.jl")) #hide
performance_plot("latent processes")

# ## References
#
# - Capasso and Serio (1978), "A generalization of the Kermack-McKendrick
#   deterministic epidemic model", Mathematical Biosciences 42, 43-61,
#   [10.1016/0025-5564(78)90006-8](https://doi.org/10.1016/0025-5564%2878%2990006-8)

# ## Learning more
#
# - See every operator, coupling and modifier on the [API overview](@ref api-overview).
# - Want the full interface? See the [Public API](@ref public-api).
