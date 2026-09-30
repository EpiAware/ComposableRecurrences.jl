# [Getting started](@id getting-started)

ComposableRecurrences steps a series forward from its own past, as in a renewal process, an autoregression or a random walk.
It also weights past inputs by a kernel, as in a reporting delay.
`Recurrence` and `Convolution` build these two steps, and couplings and modifiers extend them to groups, depletion and bounds.
Every operator is differentiable, so a model built from them can be fitted with gradient-based methods.
Computational efficiency is a main focus of the package; see [Performance](@ref overview-performance).

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

The outbreak starts in town A and reaches B and C through the coupling, so their waves are smaller.
All three towns turn at the intervention.
Reports are 40% of infections, delayed and smoothed by the reporting delay.

## [Performance](@id overview-performance)

```@example overview
using ComposableRecurrences: Floor, Add # hide
using Printf # hide
results = joinpath(pkgdir(ComposableRecurrences), "benchmark", "results", "docs.csv") # hide
bench = if isfile(results) # hide
    lines = readlines(results) # hide
    header = Symbol.(split(first(lines), ',')) # hide
    rows = split.(lines[2:end], ',') # hide
    DataFrame([h => getindex.(rows, i) for (i, h) in enumerate(header)]) # hide
else # hide
    nothing # hide
end # hide
methods_order = ["ComposableRecurrences", "hand loop", "hand loop (window copies)", "accumulate"] # hide
targets = ["primal" => "Forward run", "ForwardDiff" => "ForwardDiff", "Mooncake reverse" => "Mooncake", "Enzyme reverse" => "Enzyme"] # hide
if bench === nothing # hide
    Markdown.parse("The benchmark results are not available in this build.") # hide
else # hide
    @chain bench begin # hide
        @subset(:block .== "naive vs package", :size .== "T200_L20_S3", :status .== "ok") # hide
        @transform(:median_us = parse.(Float64, :median_us)) # hide
        data(_) * mapping( # hide
            :target => renamer(targets...) => "", # hide
            :median_us => "Median time (μs)", # hide
            color = :method => sorter(methods_order...) => "", # hide
            dodge = :method => sorter(methods_order...) => "", # hide
        ) * visual(BarPlot, fillto = 1) # hide
        draw(_; axis = (yscale = log10,), figure = (size = (800, 420),), legend = (position = :bottom,)) # hide
    end # hide
end # hide
```

```@example overview
if bench !== nothing # hide
    failed = @subset(bench, :block .== "naive vs package", :size .== "T200_L20_S3", :status .== "error") # hide
    missing_note = isempty(failed.method) ? "" : # hide
        " No bar: " * join(unique(failed.target), ", ") * " could not differentiate " * # hide
        join(unique(failed.method), " or ") * "." # hide
    Markdown.parse( # hide
        "The three-town model above over 200 days with a 20-day generation interval: " * # hide
            "the operators, a preallocated hand-written loop, a loop that copies its window every step, " * # hide
            "and `accumulate` over a `NamedTuple` state, for the forward run and each gradient backend; " * # hide
            "median times at revision `" * first(bench.revision) * "`." * missing_note # hide
    ) # hide
end # hide
```

### Changing the model

Switching to the floored depletion form and adding imported infections after depletion changes one line of the operator version.

```diff
-renewal = Recurrence(gi; coupling = K, modifiers = (Depletion(PerStratum(pop)),))
+renewal = Recurrence(gi; coupling = K, modifiers = (Depletion(PerStratum(pop), Floor()), Add(TimeVarying(PerStratum(ι)))))
```

::: details The same change in the hand-written loop

```@example overview
function loop_renewal(R, seed, gi, K, pop, ι)  # changed: imports passed in
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
            v = R[a, t] * sum(K[a, b] * p[b] for b in 1:S)  # changed
            drawn = max(max(pool[a] / pop[a], 0), 1e-6) * v  # changed: floored form
            pool[a] -= drawn  # changed
            y[a, m + t] = drawn + ι[a, t]  # changed: imports after depletion
        end
    end
    return y[:, (m + 1):end]
end

ι = zeros(3, T)
ι[3, 1:10] .= 5.0
extended = Recurrence(
    gi; coupling = K,
    modifiers = (Depletion(PerStratum(pop), Floor()), Add(TimeVarying(PerStratum(ι))))
)
maximum(abs, extended(R; history = seed) .- loop_renewal(R, seed, gi, K, pop, ι))
```

:::

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

Total reports are most sensitive to town A's reproduction number early on, when each extra infection seeds the most later ones.
The reproduction numbers of B and C matter most just before the intervention, when their own outbreaks are largest.
Sensitivity fades after the intervention and is zero on the last day, whose infections are not yet reported.

## Learning more

- See every operator, coupling and modifier on the [API overview](@ref api-overview).
- See how renewal processes, delays and occupancy map to the package in [Infectious disease models](@ref infectious-disease-models).
- Want to write your own modifier or coupling? See the [Developer documentation](@ref developer).
- Want the full interface? See the [Public API](@ref public-api).
- Want the packages ComposableRecurrences works alongside? See Related packages on the [home page](../index.md).

## Getting help

For usage questions, ask on the [Julia Discourse](https://discourse.julialang.org) or the [epinowcast community forum](https://community.epinowcast.org), our home for epidemiological modelling questions.
Please use [GitHub issues](https://github.com/EpiAware/ComposableRecurrences.jl/issues) for bug reports and feature requests only.
