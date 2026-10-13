# # [Writing your own modifier](@id tutorial-custom-modifier)
#
# ## Introduction
#
# A modifier changes each step's value inside a [`Recurrence`](@ref).
# The package's modifiers cover common needs, and a model can add its own.
# This tutorial writes one, shows that its gradient takes the operator's fast route with no hand-written rule, and then adds one.
#
# ### What are we going to do in this exercise
#
# 1. Write a modifier that saturates each value, with `forward` only.
# 2. Use it in a renewal process with depletion.
# 3. See which route its gradient takes.
# 4. Add a `pullback!` and check it.
# 5. Compare gradient times with and without the `pullback!`.
#
# ### What might I need to know before starting
#
# This tutorial builds on [Renewal then delay](@ref tutorial-renewal-delay).
# [Writing new types](@ref extending) gives the contract a modifier meets, and [Adjoints and backends](@ref adjoints-backends) explains the routes a gradient can take.

# ## Packages used

using ComposableRecurrences
using ComposableRecurrences: Depletion
const CR = ComposableRecurrences
using CairoMakie, AlgebraOfGraphics, DataFramesMeta
using ForwardDiff
using Markdown

CairoMakie.activate!(type = "png", px_per_unit = 2)

# ## A modifier with `forward` only
#
# The modifier caps each value smoothly at ``\kappa``:
#
# ```math
# v' = \frac{v \, \kappa}{\kappa + v},
# ```
#
# where ``v`` is the value it receives and ``v'`` the value it passes on.
# It acts on each series alone, so it is pointwise and implements the scalar step.
# It keeps no state, so it passes its state on unchanged.
# The field has a type parameter so that a dual number can take its place.

struct Saturation{K}
    κ::K
end
CR.ispointwise(::Saturation) = true
CR.forward(m::Saturation, ::CR.Step, v, s, t, k) = (v * m.κ / (m.κ + v), s)

# ## Using it
#
# The modifier goes in the tuple with the package's own.
# Placed before [`Depletion`](@ref ComposableRecurrences.Depletion), it caps the infections drawn from the pool.
# With ``g_l`` the generation interval, ``R_t`` the reproduction number, ``f`` the saturation above and ``h`` the depletion draw,
#
# ```math
# y_t = h\Big(f\big(R_t \sum_{l} g_l \, y_{t-l}, \kappa\big)\Big).
# ```

gi = [0.1, 0.3, 0.3, 0.2, 0.1]
T = 80
R = fill(1.8, T)
seed = [1.0, 2.0, 3.0]
N = 10_000.0
model(κ) = Recurrence(gi; modifiers = (Saturation(κ), Depletion(N; pool0 = N - sum(seed))))

@chain [50.0, 150.0, 1.0e6] begin
    map(_) do κ
        DataFrame(day = 1:T, κ = string(Int(κ)), infections = model(κ)(R; history = seed))
    end
    reduce(vcat, _)
    data(_) * mapping(:day => "Day", :infections => "Infections", color = :κ => "κ") *
        visual(Lines, linewidth = 2)
    draw(_)
end

# A low cap slows the epidemic and spreads it out.
# A cap far above the infections leaves the epidemic as depletion alone sets it.

# ## Which route the gradient takes
#
# ForwardDiff differentiates the operator's forward code, so the new modifier works with it as written.

loss(κ) = sum(model(κ)(R; history = seed))
ForwardDiff.derivative(loss, 100.0)

# Under Mooncake or Enzyme in reverse mode, the operator runs its own reverse pass, its rule.
# The rule calls a part's `pullback!` where it has one, and [`uses_adjoint`](@ref ComposableRecurrences.uses_adjoint) reports whether it does.

CR.uses_adjoint(Saturation(100.0), CR.Step())

# Without one, the rule still runs.
# The modifier is pointwise with a single float parameter, so the rule takes its derivative at each step with a local ForwardDiff step.
# [Rules and plain AD](@ref adjoint-routing) gives the parts that send the whole operator to plain AD instead.
# So the operator keeps its rule even though the modifier has none.

CR.uses_adjoint(model(100.0), CR.Run())

# ## Adding a `pullback!`
#
# The local step evaluates `forward` with dual numbers at every step.
# A `pullback!` gives the derivative in closed form instead.
# With ``\bar v'`` the cotangent of ``v'``, the cotangents are
#
# ```math
# \bar v = \bar v' \, \frac{\kappa^2}{(\kappa + v)^2}, \qquad
# \bar\kappa \mathrel{+}= \bar v' \, \frac{v^2}{(\kappa + v)^2}.
# ```
#
# [`cotangent`](@ref ComposableRecurrences.cotangent) reads the mirror of the field ``\kappa``, and [`add_cotangent!`](@ref ComposableRecurrences.add_cotangent!) adds to it.
# Both skip a field the backend holds constant.

struct SaturationPullback{K}
    κ::K
end
CR.ispointwise(::SaturationPullback) = true
CR.forward(m::SaturationPullback, ::CR.Step, v, s, t, k) = (v * m.κ / (m.κ + v), s)
function CR.pullback!(grads, m::SaturationPullback, ::CR.Step, v, s, t, k)
    d = inv(m.κ + v)^2
    CR.add_cotangent!(CR.cotangent(grads.piece, :κ), grads.v * v^2 * d)
    return grads.v * m.κ^2 * d, grads.s
end

CR.uses_adjoint(SaturationPullback(100.0), CR.Step())

# The `pullback!` should match ForwardDiff of `forward` on the same inputs.
# Here `x` holds ``\kappa``, ``v`` and the state.

step(x) = collect(CR.forward(SaturationPullback(x[1]), CR.Step(), x[2], x[3], 1, 1))
J = ForwardDiff.jacobian(step, [100.0, 30.0, 0.0])
grads = (; piece = (; κ = Ref(0.0)), v = 1.0, s = 0.5)
v̄, s̄ = CR.pullback!(grads, SaturationPullback(100.0), CR.Step(), 30.0, 0.0, 1, 1)
J' * [grads.v, grads.s] ≈ [grads.piece.κ[], v̄, s̄]

# [Checking a new type](@ref extending-checks) adds the interface test and a reverse-mode check through the operator.

# ## Timing the routes
#
# The [benchmark matrix](@ref testing) times the gradient of a renewal with this modifier, under Mooncake and Enzyme in reverse mode.
# It times three versions: plain AD of the whole operator, the rule with `forward` only, and the rule with the `pullback!`.
# The figure reads the times from the benchmark results, so this page compiles no backend.

results = joinpath(pkgdir(ComposableRecurrences), "benchmark", "results", "docs.csv")
bench = if isfile(results)
    lines = readlines(results)
    header = Symbol.(split(first(lines), ','))
    rows = split.(lines[2:end], ',')
    @chain DataFrame([h => String.(getindex.(rows, i)) for (i, h) in enumerate(header)]) begin
        @subset(:block .== "custom modifier", :status .== "ok")
        @transform(:median_us = parse.(Float64, :median_us))
    end
else
    nothing
end
arms = ["plain AD", "forward only", "with pullback!"]
backends = ["Mooncake reverse" => "Mooncake", "Enzyme reverse" => "Enzyme"]
sizes = ["T100_L6_S1" => "100 days, 6 lags", "T200_L20_S1" => "200 days, 20 lags"]
if bench === nothing || isempty(bench.method)
    md"The benchmark results are not available in this build."
else
    @chain bench begin
        data(_) * mapping(
            :target => renamer(backends...) => "",
            :median_us => "Median gradient time (μs)",
            color = :method => sorter(arms...) => "",
            dodge = :method => sorter(arms...) => "",
            layout = :size => renamer(sizes...),
        ) * visual(BarPlot)
        draw(_; figure = (size = (800, 420),), legend = (position = :bottom,))
    end
end

# The takeaway, computed from the same results:

function share(bench, a, b)
    t = @chain bench begin
        @subset(in.(:method, Ref([a, b])))
        unstack([:size, :target], :method, :median_us)
    end
    r = t[!, b] ./ t[!, a]
    return round(Int, 100 * minimum(r)), round(Int, 100 * maximum(r))
end
if bench !== nothing && !isempty(bench.method)
    lo, hi = share(bench, "plain AD", "forward only")
    plo, phi = share(bench, "forward only", "with pullback!")
    Markdown.parse(
        "With `forward` only, the gradient takes $lo% to $hi% of the time of plain AD. " *
            "The `pullback!` then takes it to $plo% to $phi% of the time with `forward` only. " *
            "These are median times at revision `$(first(bench.revision))`."
    )
end

# The local step evaluates `forward` once per step with dual numbers, so its cost follows the cost of `forward`.
# For a map as cheap as this one there is little for a `pullback!` to save.
# Write `forward` first, and add a `pullback!` when timing shows the modifier's local step matters.
# [Which rules are kept](@ref rule-policy) gives the gain of each built-in's rule.

# ## Learning more
#
# - [Writing new types](@ref extending) gives the contract for modifiers, couplings and depletion forms.
# - [Adjoints and backends](@ref adjoints-backends) says which code each backend runs.
