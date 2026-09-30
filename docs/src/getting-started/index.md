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
using ForwardDiff

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

The same model written in plain Julia copies its lag window and grows its output at every step.
The operators read one history buffer in place instead.
This compares the two on the model above, measured when this page was built.

```@example overview
using Chairmarks

function plain_renewal(R, seed, gi, K, pop)
    y = copy(seed)
    pool = pop .+ zero(eltype(R))
    for t in axes(R, 2)
        window = y[:, (end - length(gi) + 1):end]
        x = R[:, t] .* (K * (window * reverse(gi))) ./ pop
        y = hcat(y, pool .* (1 .- exp.(-x)))
        pool = pool .* exp.(-x)
    end
    return y[:, (size(seed, 2) + 1):end]
end
plain_renewal(R, seed, gi, K, pop) ≈ infections
```

```@example overview
f_ops(R) = sum(renewal(R; history = seed))
f_plain(R) = sum(plain_renewal(R, seed, gi, K, pop))
times = [
    ("Forward", "Plain Julia", @b(f_plain($R)).time),
    ("Forward", "ComposableRecurrences", @b(f_ops($R)).time),
    ("Gradient", "Plain Julia", @b(ForwardDiff.gradient(f_plain, $R)).time),
    ("Gradient", "ComposableRecurrences", @b(ForwardDiff.gradient(f_ops, $R)).time),
]
bench = DataFrame(task = first.(times), method = getindex.(times, 2), time = last.(times))
@transform!(groupby(bench, :task), :relative = :time ./ last(:time))
draw(
    data(bench) * mapping(:method => "", :relative, color = :method, layout = :task) *
        visual(BarPlot);
    axis = (ylabel = "Time relative to ComposableRecurrences", xticklabelsvisible = false)
)
```

The gradient gains more than the forward run, because every copy in the plain version is repeated for each derivative.

## Learning more

- Want the full interface? See the [Public API](@ref public-api).
- Want the packages ComposableRecurrences works alongside? See Related packages on the [home page](../index.md).

## Getting help

For usage questions, ask on the [Julia Discourse](https://discourse.julialang.org) or the [epinowcast community forum](https://community.epinowcast.org), our home for epidemiological modelling questions.
Please use [GitHub issues](https://github.com/EpiAware/ComposableRecurrences.jl/issues) for bug reports and feature requests only.
