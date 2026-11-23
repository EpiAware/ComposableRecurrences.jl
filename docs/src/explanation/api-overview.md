# [API overview](@id api-overview)

This page is a map of the package.
It says what each part is, shows how the parts fit together in one small model, and points to the page that covers each part in full.

Some public names are not exported, so `using ComposableRecurrences` does not bring them in.
They are written here without the package prefix, and `using ComposableRecurrences: Depletion, Floor, Recent` loads them.
Internal names, such as `ComposableRecurrences.State`, keep the prefix.
The neural network package Lux also exports a `Recurrence`, so with both loaded write [`ComposableRecurrences.Recurrence`](@ref Recurrence).

## [How the parts fit together](@id overview-map)

[`Recurrence`](@ref) and [`Convolution`](@ref) are the two operators.
A recurrence computes each value from its own past values, such as infections from earlier infections.
A convolution weights the past values of another series, such as reports from earlier infections.
A model can run several series side by side, such as one per town; each series is a stratum.

An operator is built once from a kernel, the weights on each lag.
A recurrence also takes a coupling, which mixes the strata, and modifiers, which change each step's value, such as a draw from a finite pool.
A shape sets how each of these coefficients varies across strata and time.
The operator is then called with data, such as the reproduction number as its gain, and an executor sets where the call's loops run.

![How kernels, couplings, modifiers, shapes, operators, calls and executors fit together](../assets/api-map.svg)

## [A worked example](@id overview-example)

The example uses `gi`, `pop`, `K`, `seed` and `R` from the model of [Three towns, step by step](@ref tutorial-three-towns).
They are a generation interval, each town's population, a gravity coupling, the seed infections and the reproduction number.

```@setup api-overview
using ComposableRecurrences
include(
    joinpath(pkgdir(ComposableRecurrences), "docs", "getting_started_model.jl")
)
```

```@example api-overview
using ComposableRecurrences
using ComposableRecurrences: Depletion
renewal = Recurrence(
    gi; coupling = K, modifiers = (Depletion(PerStratum(pop)),)
)
infections = renewal(R; history = seed)
delay = Convolution([0.0, 0.1, 0.25, 0.3, 0.2, 0.1, 0.05])
reports = delay(infections; gain = 0.4, history = seed)
size(reports)
```

Each part of this model has its own section below.

- `gi` is the kernel of the recurrence, and the vector of delays the kernel of the convolution.
- `K` is the coupling, a matrix of weights between the three towns.
- `Depletion(PerStratum(pop))` is a modifier, and `PerStratum` is a shape: one population per town.
- `renewal(R; history = seed)` and `delay(infections; ...)` are calls, each returning a towns × days matrix.

## [A step](@id overview-step)

Both operators compute their outputs one step at a time, with time the integer step ``t`` counted from 1.
A recurrence takes a weighted sum of each stratum's recent outputs, mixes the sums with the coupling, scales them by the gain, adds `add` and passes the result through its modifiers.
A convolution takes a weighted sum of an input series and scales it by the gain.
[A step](@ref explanation-step) gives both equations, and [Operators](@ref explanation-operators) explains why a recurrence's kernel starts at lag 1.

## [Operators](@id overview-operators)

`Recurrence(kernel; coupling, modifiers)` and `Convolution(kernel; method)` build the two operators.
[Building an operator](@ref explanation-build) lists their keywords, including the fast Fourier transform for long convolutions.

## [Calls](@id overview-calls)

A recurrence is called with its gain first, and a convolution with its input first and its gain as a keyword.
Both take `history`, `add`, `start` and `stop`.
A call can also return the `State` to resume from, a trace of each step, or each lag's contribution.
[Calls](@ref explanation-calls) lists every call form, and [Time base](@ref explanation-time-base) and [What a call returns](@ref explanation-returns) say how inputs are indexed and outputs joined.

## [Shapes](@id overview-shapes)

A kernel, a coupling or a modifier parameter is a coefficient, and a shape is how it varies across strata and time.
A plain array is one set of numbers for every stratum and time, and a wrapper such as [`PerStratum`](@ref), [`Pairwise`](@ref) or [`TimeVarying`](@ref) adds an axis.
[Slots and shapes](@ref explanation-slots) lists which wrapper each coefficient takes and what each means, and [Data shapes](@ref explanation-data-shapes) gives the shapes of the gain and `add`.

## [Delay distributions](@id overview-delays)

A delay distribution, such as a gamma generation interval, can stand in for a kernel, given the number of lags.
[Delay distributions as kernels](@ref explanation-delays) says how its masses are computed and how to add a delay type of your own.

## [Couplings](@id overview-couplings)

A coupling sets how much each stratum's past outputs drive each stratum, such as travel between towns.
Row ``i`` is the stratum that receives, and column ``j`` the stratum that gives.
[Where the coupling acts](@ref explanation-coupling) lists the coupling types and says where a per-stratum coefficient belongs.

## [Modifiers](@id overview-modifiers)

A modifier changes each step's value after the gain and `add`, and keeps its own state, such as the people left to infect.
The built-ins are [`Depletion`](@ref ComposableRecurrences.Depletion), [`Redistribute`](@ref ComposableRecurrences.Redistribute), [`Allocate`](@ref ComposableRecurrences.Allocate) and [`Transform`](@ref ComposableRecurrences.Transform).
[Built-in modifiers](@ref explanation-builtin-modifiers) lists what each does, and [Order](@ref explanation-modifier-order) says why their order in the tuple matters.

## [Depletion forms](@id overview-variants)

A depletion form, such as [`Hazard`](@ref ComposableRecurrences.Hazard) or [`Floor`](@ref ComposableRecurrences.Floor), sets how a pool gives up what a step asks for.
[Depletion forms](@ref explanation-depletion-forms) lists each form and its formula.

## [Time-series processes](@id overview-time-series)

A random walk, an autoregression and a moving average are each a recurrence or a convolution of innovations.
[Time-series processes](@ref explanation-time-series) gives each in maths and code, and [Latent processes](@ref tutorial-latent-rt) uses one to drive the reproduction number.

## [Executors](@id overview-executors)

An executor sets where an operator's loops run: in order, on threads or on a device such as a GPU.
[Executors](@ref executors) says how to choose one and what each supports, and [Adjoints and backends](@ref adjoints-backends) how gradients are computed.

## [Writing your own](@id overview-own)

To write a new coupling, modifier or depletion form, or to check a gradient, see [Writing new types](@ref extending).
Its [extension API](@ref overview-extending) lists the names for this.
