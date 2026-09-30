# [Getting started](@id getting-started)

ComposableRecurrences has two operators.
`Recurrence` steps a series forward from a kernel-weighted window of its own past.
`Convolution` weights past inputs by a kernel.
Many series can be linked so that each one feeds the others, and extra behaviour such as finite pools or bounds can be added to each step.
Every operator is differentiable, so a model built from them can be fitted with gradient-based methods.

## A first example

Three towns share an outbreak.
Infections follow a renewal process, a gravity coupling mixes the towns, and each town's susceptible pool is depleted.
An intervention from day 50 lowers the reproduction number over a week, and a reporting delay turns infections into reports.

```@example overview
using ComposableRecurrences
using ComposableRecurrences: Depletion
using CairoMakie, AlgebraOfGraphics, DataFramesMeta
using ForwardDiff, Markdown

CairoMakie.activate!(type = "png", px_per_unit = 2)

towns = ["A", "B", "C"]
pop = [60_000.0, 25_000.0, 10_000.0]
dist = [0.0 20.0 45.0; 20.0 0.0 30.0; 45.0 30.0 0.0]
gravity = [a == b ? 0.0 : pop[b] / dist[a, b]^2 for a in 1:3, b in 1:3]
K = 0.998 * [a == b for a in 1:3, b in 1:3] + 0.002 * gravity ./ sum(gravity; dims = 2)

gi = [0.05, 0.2, 0.3, 0.25, 0.12, 0.08]
renewal = Recurrence(gi; coupling = K, modifiers = (Depletion(PerStratum(pop)),))
delay = Convolution([0.0, 0.1, 0.25, 0.3, 0.2, 0.1, 0.05])

T = 75
R = [1.8 - clamp((t - 50) / 6, 0, 1) for _ in towns, t in 1:T]
seed = [fill(10.0, 1, 6); zeros(2, 6)]
infections = renewal(R; history = seed)
reports = 0.4 .* delay(infections)
round.(vec(sum(reports; dims = 2)))
```

The operators are built once and called like functions.
The coupling mixes the towns after the generation interval is applied, and the depletion runs after each step.
Each town is one series, and `PerStratum` gives each its own population.
Chaining the renewal and the delay is function composition.

```@example overview
long(x) = @chain DataFrame(permutedims(x), towns) begin
    @transform(:day = 1:T)
    stack(Not(:day); variable_name = :town, value_name = :count)
end
@chain ["Infections" => infections, "Reports" => reports] begin
    map(((series, x),) -> @transform(long(x), :series = series), _)
    reduce(vcat, _)
    data(_) * mapping(:day, :count, color = :series, layout = :town) *
        visual(Lines, linewidth = 2)
    draw(_; axis = (xlabel = "Day", ylabel = "Count"))
end
```

Town A turns before the intervention because its susceptible pool runs down.

## Gradients

One line gives the gradient of all reports with respect to every town's reproduction number on every day.

```@example overview
∂R = ForwardDiff.gradient(R -> sum(delay(renewal(R; history = seed))), R)
size(∂R)
```

```@example overview
@chain long(∂R) begin
    data(_) * mapping(:day, :town, :count => "∂ reports / ∂R") * visual(Heatmap)
    draw(_; axis = (xlabel = "Day", ylabel = "Town"))
end
```

Total reports are most sensitive to town A's reproduction number around its peak.
The reproduction numbers of B and C matter most just before the intervention, when their own outbreaks are largest.
Sensitivity fades after the intervention and is zero on the last day, whose infections are not yet reported.

## Speed

The same model can be written by hand as a preallocated loop, or with `accumulate` and a `NamedTuple` state.
All three give the same ForwardDiff gradient, up to rounding error.

```@example overview
using Chairmarks, Printf

function loop_renewal(R, seed, gi, K, pop)
    S, T = size(R)
    L, m = length(gi), size(seed, 2)
    V = promote_type(eltype(R), Float64)
    y = zeros(V, S, m + T)
    y[:, 1:m] .= seed
    pool = V.(pop)
    p = zeros(V, S)
    for t in 1:T
        for s in 1:S
            p[s] = sum(gi[i] * y[s, m + t - i] for i in 1:L)
        end
        for a in 1:S
            h = R[a, t] * sum(K[a, b] * p[b] for b in 1:S) / pop[a]
            y[a, m + t] = pool[a] * (1 - exp(-h))
            pool[a] *= exp(-h)
        end
    end
    return y[:, (m + 1):end]
end

function accumulate_renewal(R, seed, gi, K, pop)
    init = (window = seed, pool = pop .+ zero(eltype(R)), y = zeros(eltype(R), size(R, 1)))
    steps = accumulate(eachcol(R); init) do state, Rt
        h = Rt .* (K * (state.window * reverse(gi))) ./ pop
        new = state.pool .* (1 .- exp.(-h))
        (window = hcat(state.window[:, 2:end], new), pool = state.pool .* exp.(-h), y = new)
    end
    return reduce(hcat, getfield.(steps, :y))
end

methods = [
    "ComposableRecurrences" => R -> sum(renewal(R; history = seed)),
    "Hand-written loop" => R -> sum(loop_renewal(R, seed, gi, K, pop)),
    "accumulate" => R -> sum(accumulate_renewal(R, seed, gi, K, pop)),
]
∇ = [ForwardDiff.gradient(f, R) for (_, f) in methods]
maximum(maximum(abs, g .- ∇[1]) for g in ∇)
```

This compares their forward and gradient times, measured when this page was built.

```@example overview
times = @chain methods begin
    map(_) do (method, f)
        DataFrame(
            method = method,
            Forward = @b(f($R), seconds = 0.5).time,
            Gradient = @b(ForwardDiff.gradient($f, $R), seconds = 0.5).time
        )
    end
    reduce(vcat, _)
    stack(Not(:method); variable_name = :task, value_name = :time)
    @groupby(:task)
    @transform(:relative = :time ./ first(:time))
end
@chain times begin
    data(_) * mapping(:method => "", :relative, color = :method, layout = :task) *
        visual(BarPlot)
    draw(_; axis = (ylabel = "Time relative to ComposableRecurrences", xticklabelsvisible = false))
end
```

```@example overview
function compare(task, method, name)
    r = only(@subset(times, :task .== task, :method .== method).relative)
    return r >= 1 ? @sprintf("%s takes %.1f times as long", name, r) :
        @sprintf("%s is %.1f times as fast", name, 1 / r)
end
Markdown.parse(
    "For the forward run, $(compare("Forward", "Hand-written loop", "the hand-written loop")) " *
        "and $(compare("Forward", "accumulate", "`accumulate`")).\n" *
        "For the gradient, $(compare("Gradient", "Hand-written loop", "the hand-written loop")) " *
        "and $(compare("Gradient", "accumulate", "`accumulate`"))."
)
```

A loop written for one model has to be rewritten when the model changes.
The operators compose, so a new coupling or modifier needs no new loop.

## Learning more

- See every operator, coupling and modifier on the [API overview](@ref api-overview).
- See how renewal processes, delays and occupancy map to the package in [Infectious disease models](@ref infectious-disease-models).
- Want to write your own modifier or coupling? See the [Developer documentation](@ref developer).
- Want the full interface? See the [Public API](@ref public-api).
- Want the packages ComposableRecurrences works alongside? See Related packages on the [home page](../index.md).

## Getting help

For usage questions, ask on the [Julia Discourse](https://discourse.julialang.org) or the [epinowcast community forum](https://community.epinowcast.org), our home for epidemiological modelling questions.
Please use [GitHub issues](https://github.com/EpiAware/ComposableRecurrences.jl/issues) for bug reports and feature requests only.
