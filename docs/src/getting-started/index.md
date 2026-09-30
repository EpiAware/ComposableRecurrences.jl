# [Getting started](@id getting-started)

ComposableRecurrences steps a series forward from its own past, as in a renewal process, an autoregression or a random walk.
It also weights past inputs by a kernel, as in a reporting delay.
`Recurrence` and `Convolution` build these two steps, and couplings and modifiers extend them to groups, depletion and bounds.
Every operator is differentiable, so a model built from them can be fitted with gradient-based methods.

## A first example

Three towns share an outbreak.
Infections follow a renewal process, a gravity coupling mixes the towns, and each town's susceptible pool is depleted.
An intervention on day 50 lowers the reproduction number, and a reporting delay turns infections into reports.

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
K = 0.98 * [a == b for a in 1:3, b in 1:3] + 0.02 * gravity ./ sum(gravity; dims = 2)

gi = [0.05, 0.2, 0.3, 0.25, 0.12, 0.08]
renewal = Recurrence(gi; coupling = K, modifiers = (Depletion(PerStratum(pop)),))
delay = Convolution([0.0, 0.1, 0.25, 0.3, 0.2, 0.1, 0.05])

T = 100
R = [t < 50 ? 1.5 : 0.8 for _ in towns, t in 1:T]
seed = [fill(10.0, 1, 6); zeros(2, 6)]
infections = renewal(R; history = seed)
reports = 0.4 .* delay(infections)
round.(vec(sum(reports; dims = 2)))
```

The operators are built once and called like functions.
The coupling mixes the towns after the generation interval is applied, and the depletion runs after each step.
Chaining the renewal and the delay is function composition.

```@example overview
long(x, series) = DataFrame(
    day = repeat(1:T; inner = 3), town = repeat(towns, T), count = vec(x), series = series
)
df = vcat(long(infections, "Infections"), long(reports, "Reports"))
draw(
    data(df) * mapping(:day, :count, color = :series, layout = :town) *
        visual(Lines, linewidth = 2);
    axis = (xlabel = "Day", ylabel = "Count")
)
```

The outbreak starts in town A and reaches B and C through the coupling, so their waves are smaller.
All three towns turn at the intervention.
Reports are 40% of infections, delayed and smoothed by the reporting delay.

## Gradients

One line gives the gradient of all reports with respect to every town's reproduction number on every day.

```@example overview
∂R = ForwardDiff.gradient(R -> sum(delay(renewal(R; history = seed))), R)
size(∂R)
```

```@example overview
sens = DataFrame(day = repeat(1:T; inner = 3), town = repeat(towns, T), value = vec(∂R))
draw(
    data(sens) * mapping(:day, :town, :value => "∂ reports / ∂R") * visual(Heatmap);
    axis = (xlabel = "Day", ylabel = "Town")
)
```

Total reports are most sensitive to town A's reproduction number early on, when each extra infection seeds the most later ones.
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
times = DataFrame(
    task = repeat(["Forward", "Gradient"]; inner = length(methods)),
    method = repeat(first.(methods), 2),
    time = vcat(
        [@b(f($R), seconds = 0.5).time for (_, f) in methods],
        [@b(ForwardDiff.gradient($f, $R), seconds = 0.5).time for (_, f) in methods]
    )
)
@transform!(groupby(times, :task), :relative = :time ./ first(:time))
draw(
    data(times) * mapping(:method => "", :relative, color = :method, layout = :task) *
        visual(BarPlot);
    axis = (ylabel = "Time relative to ComposableRecurrences", xticklabelsvisible = false)
)
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

- Want the full interface? See the [Public API](@ref public-api).
- Want the packages ComposableRecurrences works alongside? See Related packages on the [home page](../index.md).

## Getting help

For usage questions, ask on the [Julia Discourse](https://discourse.julialang.org) or the [epinowcast community forum](https://community.epinowcast.org), our home for epidemiological modelling questions.
Please use [GitHub issues](https://github.com/EpiAware/ComposableRecurrences.jl/issues) for bug reports and feature requests only.
