# [Getting started](@id getting-started)

[`Recurrence`](@ref) steps a series forward from a kernel-weighted window of its own past.
[`Convolution`](@ref) weights past inputs by a kernel.
Couplings link series, and modifiers add behaviour such as finite pools to each step.
Every operator is differentiable.
Computational efficiency is a main focus; see [Performance](@ref overview-performance).

## [Building the model](@id overview-build)

Three towns share an outbreak.
This section builds a model of it in five steps.
Each step gives the equation, then the code, then a plot of what the step adds.
The model and numbers are those of the README.
The equations follow the [`Recurrence`](@ref), [`Convolution`](@ref) and [`Depletion`](@ref ComposableRecurrences.Depletion) docstrings.

```@example overview
using ComposableRecurrences
using ComposableRecurrences: Depletion
using CairoMakie, AlgebraOfGraphics, DataFramesMeta
using ForwardDiff, Markdown

CairoMakie.activate!(type = "png", px_per_unit = 2)

# The rows of `x` as named series in a long table, one row per day.
long(x, names; name = :town) = @chain DataFrame(permutedims(x), names) begin
    @transform(:day = 1:size(x, 2))
    stack(Not(:day); variable_name = name, value_name = :count)
end
small = (size = (600, 280),)
nothing # hide
```

### One town

Infections follow a renewal process:

```math
I_t = R_t \sum_{l=1}^{L} g_l \, I_{t-l},
```

where ``I_t`` is the number of infections on day ``t``.
``R_t`` is the reproduction number, the gain of the [`Recurrence`](@ref).
``g_l`` is the generation interval's weight on lag ``l``, and ``L`` is its length.
Infections before the first day are the history.

```@example overview
gi = [0.05, 0.2, 0.3, 0.25, 0.12, 0.08]
T = 75
one_town = Recurrence(gi)(fill(1.8, T); history = fill(10.0, 6))

@chain DataFrame(day = 1:T, count = one_town) begin
    data(_) * mapping(:day, :count) * visual(Lines, linewidth = 2)
    draw(_; axis = (xlabel = "Day", ylabel = "Infections"), figure = small)
end
```

Nothing limits growth yet, so infections grow exponentially.

### A reporting delay

A share ``\rho`` of infections is reported, after a delay:

```math
C_t = \rho \sum_{l=0}^{L_w - 1} w_l \, I_{t-l},
```

where ``C_t`` is the number of reports on day ``t``.
``w_l`` is the delay's weight on lag ``l``, and ``L_w`` is its length.
Infections before day 1 count as zero here.
``\rho`` is the gain of the [`Convolution`](@ref), and a delay of zero days is lag 0.

```@example overview
delay = Convolution([0.0, 0.1, 0.25, 0.3, 0.2, 0.1, 0.05])
one_report = delay(one_town; gain = 0.4)

@chain long([one_town one_report]', ["Infections", "Reports"]; name = :series) begin
    data(_) * mapping(:day, :count, color = :series => "") *
        visual(Lines, linewidth = 2)
    draw(_; axis = (xlabel = "Day", ylabel = "Daily count"), figure = small)
end
```

Reports are 40% of infections, spread over the days that follow.
These two steps are the usual model of infections and their reports.
Each later step adds one part to it.

### Three towns and a gravity coupling

Each town now has its own infections ``I_{t,i}``, and a coupling ``K`` mixes the towns:

```math
I_{t,i} = R_{t,i} \sum_{j=1}^{3} K_{ij} \sum_{l=1}^{L} g_l \, I_{t-l,j},
\qquad
K_{ij} = 0.998 \, \delta_{ij} + 0.002 \, \frac{G_{ij}}{\sum_{m} G_{im}},
\qquad
G_{ij} = \frac{N_j}{d_{ij}^2} \text{ for } i \neq j,
```

where ``K_{ij}`` weights town ``j`` in town ``i``.
``\delta_{ij}`` is 1 when ``i = j`` and 0 otherwise.
``N_j`` is the population of town ``j`` and ``d_{ij}`` the distance between towns ``i`` and ``j``.
The gravity weight ``G_{ii}`` of a town on itself is 0.
The towns are [strata](@ref glossary-stratum), and only town A is seeded.

```@example overview
towns = ["A", "B", "C"]
pop = [60_000.0, 25_000.0, 10_000.0]
dist = [0.0 20.0 45.0; 20.0 0.0 30.0; 45.0 30.0 0.0]
gravity = [a == b ? 0.0 : pop[b] / dist[a, b]^2 for a in 1:3, b in 1:3]
K = 0.998 * [a == b for a in 1:3, b in 1:3] + 0.002 * gravity ./ sum(gravity; dims = 2)

seed = [fill(10.0, 1, 6); zeros(2, 6)]
coupled = Recurrence(gi; coupling = K)(fill(1.8, 3, T); history = seed)

@chain long(coupled, towns) begin
    data(_) * mapping(:day, :count, color = :town => "Town") *
        visual(Lines, linewidth = 2)
    draw(
        _; axis = (xlabel = "Day", ylabel = "Infections", yscale = log10),
        figure = small
    )
end
```

Towns B and C start from infections that town A passes on.
They then grow at about the same rate as town A.

### Depletion

Each town's susceptible pool ``s_{t,i}`` starts at ``N_i`` and shrinks by the infections drawn from it.
The default hazard form, with its exponent at the default of 1, draws

```math
\lambda_{t,i} = \frac{v_{t,i}}{N_i}, \qquad
I_{t,i} = s_{t-1,i} \big(1 - e^{-\lambda_{t,i}}\big), \qquad
s_{t,i} = s_{t-1,i} \, e^{-\lambda_{t,i}},
```

where ``v_{t,i}`` is the right-hand side of the coupled equation above.
``\lambda_{t,i}`` is the hazard.
[`PerStratum`](@ref) gives each town its own population.

```@example overview
renewal = Recurrence(gi; coupling = K, modifiers = (Depletion(PerStratum(pop)),))
depleted = renewal(fill(1.8, 3, T); history = seed)

@chain long(depleted, towns) begin
    data(_) * mapping(:day, :count, color = :town => "Town") *
        visual(Lines, linewidth = 2)
    draw(_; axis = (xlabel = "Day", ylabel = "Infections"), figure = small)
end
```

Each outbreak now peaks and declines as its pool runs down.
Town A peaks first, and towns B and C about two weeks later.
About 73% of each town is infected by the end.

### An intervention

An intervention from day 50 lowers the reproduction number over six days:

```math
R_{t,i} = 1.8 - \min\Big(\max\Big(\frac{t - 50}{6}, 0\Big), 1\Big).
```

The reports are those of the delay above, applied to each town.
The susceptible share of town ``i`` on day ``t`` is ``s_{t,i} / N_i``.

```@example overview
R = [1.8 - clamp((t - 50) / 6, 0, 1) for _ in towns, t in 1:T]
infections = renewal(R; history = seed)
reports = delay(infections; gain = 0.4)

susceptible = 1 .- cumsum(infections; dims = 2) ./ pop
@chain [
        ("Infections", "Daily count") => infections,
        ("Reports", "Daily count") => reports,
        ("Susceptible", "Susceptible share") => susceptible,
    ] begin
    map((((series, panel), x),) -> @transform(long(x, towns), :series = series, :panel = panel), _)
    reduce(vcat, _)
    data(_) * mapping(:day, :count => "", color = :series => "", row = :panel, col = :town) *
        visual(Lines, linewidth = 2)
    draw(_; axis = (xlabel = "Day",), facet = (; linkyaxes = :rowwise))
end
```

Town A turns before the intervention because its susceptible pool runs down.

## [Performance](@id overview-performance)

```@example overview
using ComposableRecurrences: Floor, Add # hide
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
        @transform(:min_us = parse.(Float64, :min_us)) # hide
        data(_) * mapping( # hide
            :target => renamer(targets...) => "", # hide
            :min_us => "Minimum time (μs)", # hide
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
    reverse_rules = unique( # hide
        @subset( # hide
            bench, :block .== "naive vs package", :size .== "T200_L20_S3", # hide
            in.(:target, Ref(["Mooncake reverse", "Enzyme reverse"])) # hide
        ).rules # hide
    ) # hide
    Markdown.parse( # hide
        "The three-town model above over 200 days with a 20-day generation interval: " * # hide
            "the operators, a preallocated hand-written loop, a loop that copies its window every step, " * # hide
            "and `accumulate` over a `NamedTuple` state, for the forward run and each gradient backend; " * # hide
            "minimum times at revision `" * first(bench.revision) * "`, " * # hide
            (reverse_rules == ["true"] ? "with" : "without") * # hide
            " the package's Mooncake and Enzyme rules loaded; " * # hide
            "the forward run and ForwardDiff do not use them." * missing_note # hide
    ) # hide
end # hide
```

### Changing the model

Switching to the floored depletion form and adding imported infections after depletion changes one line of the operator version.
The step becomes

```math
D_{t,i} = \max\Big(\max\Big(\frac{s_{t-1,i}}{N_i}, 0\Big), 10^{-6}\Big) \, v_{t,i}, \qquad
s_{t,i} = s_{t-1,i} - D_{t,i}, \qquad
I_{t,i} = D_{t,i} + \iota_{t,i},
```

where ``D_{t,i}`` is the number drawn from the pool and ``\iota_{t,i}`` the imported infections.
[Imported cases](@ref tutorial-imports) compares imports before and after depletion.

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
@chain long(∂R, towns) begin
    data(_) * mapping(:day, :town, :count => "∂ reports / ∂R") * visual(Heatmap)
    draw(_; axis = (xlabel = "Day", ylabel = "Town"))
end
```

Total reports are most sensitive to town A's reproduction number around its peak.
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
