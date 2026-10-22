# [API overview](@id api-overview)

A recurrence steps a series forward from its own past values.
A convolution weights past inputs.
Both take a kernel, and a recurrence also takes a coupling and modifiers.

![One recurrence step and one convolution output](../assets/recurrence-step.svg)

For each time ``t`` from `start` to `stop`, a recurrence computes

```math
\begin{aligned}
p_t &= \sum_{l=1}^{L} k_l \, y_{t-l} \\
v_t &= g_t \odot C_t \, p_t + a_t \\
y_t &= M_R \circ \dots \circ M_1 (v_t)
\end{aligned}
```

and a convolution computes

```math
y_t = g_t \odot \sum_{l=0}^{L-1} k_l \, x_{t-l} + a_t .
```

- ``y_t`` is the output and ``x_t`` the convolution input; each has one entry per [series](@ref glossary-series), and the values before `start` are the `history`.
- ``k_l`` is the [kernel](@ref overview-shapes) weight on lag ``l``.
- ``C_t`` is the [coupling](@ref overview-couplings), which mixes the series.
- ``g_t`` is the gain and ``a_t`` the additive input, the arguments `gain` and `add` of the [call](@ref overview-calls).
- ``M_1, \dots, M_R`` are the [modifiers](@ref overview-modifiers), each with its own state carried from step to step.
- ``\odot`` multiplies element by element.

Names that are public but not exported are written unqualified below.
Load them with `using ComposableRecurrences: Depletion, Floor, with_state`, and so on.
For models from infectious disease epidemiology, see [Infectious disease models](@ref infectious-disease-models).

## [Words used on these pages](@id glossary)

### [Series](@id glossary-series)

One sequence of values over time, such as the infections in one region or age group.

### [Stratum](@id glossary-stratum)

One of several series run side by side (plural strata); see [`PerStratum`](@ref).

### [Pointwise](@id glossary-pointwise)

Acting on each series separately; [`ispointwise`](@ref ComposableRecurrences.ispointwise) says whether a modifier does.

### [Pool](@id glossary-pool)

A quantity carried from one step to the next that a step draws from or adds to; a [`Depletion`](@ref ComposableRecurrences.Depletion) holds one or more.

## Tables

Each table below lists one part of the package:
[operators](@ref overview-operators),
[calls](@ref overview-calls),
[shapes](@ref overview-shapes),
[delay distributions](@ref overview-delays),
[couplings](@ref overview-couplings),
[modifiers](@ref overview-modifiers),
[depletion forms and indexing](@ref overview-variants),
[time-series processes](@ref overview-time-series),
[executors](@ref overview-executors) and
the [extension API](@ref overview-extending), which includes
[checking gradients](@ref overview-gradients).

## [Operators](@id overview-operators)

| Name | What it does | Returns |
|---|---|---|
| [`Recurrence(kernel; coupling, modifiers)`](@ref Recurrence) | steps a series forward from its own last ``L`` values; `kernel[1]` weights lag 1 | a callable `Recurrence` |
| [`Convolution(kernel; method)`](@ref Convolution) | weights the current and past inputs; `kernel[1]` weights lag 0; `method` is [`Auto()`](@ref ComposableRecurrences.Auto) (the default), [`Direct()`](@ref ComposableRecurrences.Direct) or [`FFTMethod()`](@ref ComposableRecurrences.FFTMethod) | a callable `Convolution` |

A recurrence has no lag 0; [A recurrence is a convolution of its own outputs](@ref explanation-lag-origin) says why.

## [Calls](@id overview-calls)

| Call | What it does | Returns |
|---|---|---|
| [`(r::Recurrence)(gain; history, add, start, stop)`](@ref Recurrence) | runs `r` over times `start:stop`, multiplying each step by `gain` and adding `add` before the modifiers | a `Vector` of length `T`, or an `S × T` `Matrix` for `S` series |
| [`(c::Convolution)(x; gain, add, history, start, stop)`](@ref Convolution) | weights the inputs `x` by the kernel over `start:stop`, then multiplies by `gain` and adds `add` | an array shaped like `x` |
| [`contributions(c, x; gain, history, start, stop)`](@ref ComposableRecurrences.contributions) | the terms of `c(x; gain)` before the sum over lags, such as a reporting triangle | `L × T`, or `S × L × T` for `S` series |
| [`with_state(r, gain; kwargs...)`](@ref ComposableRecurrences.with_state) | runs `r` like `r(gain; kwargs...)` and also returns a `State`, so that `r(gain; state)` continues the series from where it ended | a `(y, state)` tuple |
| [`(r::Recurrence)(gain; state)`](@ref Recurrence) | continues from a `State`, starting at time `state.t` | the values from `state.t` on |
| [`(r::Recurrence)(gain; history, trace = true)`](@ref Recurrence) | runs `r` and records what each modifier did at each step | a `(y, trace)` tuple, with one matrix per modifier in `trace.modifiers` |
| [`(r::Recurrence)(gain; history, prepend = true)`](@ref Recurrence) | runs `r` after the seed days in `history` and returns the seed followed by the run | the seed and run joined along time |
| [`exponential_history(I0, r, L)`](@ref ComposableRecurrences.exponential_history) | an `L`-step seed growing at rate `r` up to `I0` | a `Vector`, or `S × L` for a vector `I0` |
| [`State`](@ref ComposableRecurrences.State) | holds the last ``L`` values ``y_{t-L}, \dots, y_{t-1}``, each modifier's state ``s^{(n)}_{t-1}`` (such as the remaining pool) and the next time ``t`` | a struct |

A call reads every time-indexed input (`gain`, `add`, `x` and any `TimeVarying` coefficient) at absolute time ``t``; see [Time base](@ref explanation-time-base).
`stop` defaults to the common length of those inputs, and inputs of different lengths without a `stop` are an error.
[History and state](@ref explanation-history-state), [Seeding](@ref explanation-seeding) and [What a call returns](@ref explanation-returns) cover short histories, resuming, where a seed sits and `prepend`.
The [Renewal then delay](@ref tutorial-renewal-delay) tutorial forecasts by continuing from a `State`.

## [Shapes](@id overview-shapes)

A bare array has the slot's own axes only: a kernel's lags, a coupling's `S × S` or a parameter's single value.
Wrappers add axes, and data (inputs, history and outputs) are series × time and never wrapped.

| Name | What it does | Returns |
|---|---|---|
| vector | one kernel shared by every series | ``L`` lags |
| [`PerStratum(x)`](@ref PerStratum) | one kernel or parameter per series | adds a leading `S` axis |
| [`Pairwise(A)`](@ref Pairwise) | one kernel per pair of series, which mixes the series itself, so the coupling stays `I` | `S × S × L` |
| [`Routes((C₁, g₁), (C₂, g₂))`](@ref Routes) | a kernel that sums routes, each a kernel with its own coupling, such as community and funeral contacts; the coupling stays `I` | one kernel and one `S × S` coupling per route |
| [`TimeVarying(x)`](@ref TimeVarying) | a kernel, coupling or parameter that changes by day | adds a trailing `T` axis, or takes a vector of `T` kernel columns of any lengths, or of `start => value` change points |
| [`Derived(f, args...)`](@ref Derived) | a value computed from others: a modifier parameter, as in `κ * Derived(exp, TimeVarying(x))`, or a cohort kernel computed inside the operator, `TimeVarying(Derived(f, args...), Primary())` | the value `f` returns |
| [`Survival(h)`](@ref ComposableRecurrences.Survival) | each cohort's survival through a kernel's lags against a hazard, as in `TimeVarying(S * (1 - Survival(TimeVarying(h))), Primary())`; [`kernel_weights`](@ref ComposableRecurrences.kernel_weights) returns a computed kernel's weights | the survival on each lag |
| [`Recent(w)`](@ref Recent) | a modifier parameter read from the recurrence's own last outputs, as in `κ * Recent(7)`, or mixed across series with `Recent(7; coupling = C)` | a weighted sum of past outputs |

Wrappers combine: `TimeVarying(PerStratum(G))` is an `S × L × T` kernel.
They tag one stored array and make no copies, apart from the exceptions listed under [`TimeVarying`](@ref).
A bare vector where a single value is expected is an error that names the wrapper to use.
The [Spatial models](@ref tutorial-spatial-strata) tutorial uses each wrapper.

## [Delay distributions](@id overview-delays)

A kernel can hold delays, and the operator turns them into masses when it is built with the number of lags `lags`.
A delay is a value whose type has a [`delay_masses`](@ref ComposableRecurrences.delay_masses) method.
`delay_masses(d, lags)` gives the masses on lags `0` to `lags - 1`:

```math
k_l = P(D = l), \qquad l = 0, \dots, L - 1,
```

where ``D`` is the delay in whole steps and ``L`` = `lags`.
`lags` counts from lag 0 for both operators, and each operator keeps the masses from its own [lag origin](@ref explanation-lag-origin): a convolution from ``k_0`` and a recurrence from ``k_1``.
So `Convolution(d; lags = 4)` has 4 kernel entries and `Recurrence(d; lags = 4)` has 3.
The masses are not renormalised after this cut, so a recurrence kernel sums to ``\sum_{l=1}^{L-1} k_l``, which scales the gain.
Loading Distributions adds `delay_masses` for any discrete distribution.
A package that owns a delay type adds a method for it, as the `delay_masses` docstring shows, and its delays then work as kernels too.

| Kernel | Holds |
|---|---|
| `d` | one delay |
| `PerStratum(ds)` | a vector of delays, one per series |
| `Pairwise(D)` | a matrix of delays, `D[i, j]` series `j`'s delay in series `i`; `Recurrence` only |
| `TimeVarying(ds, indexing)` | a vector of delays, one per time, or `PerStratum` or `Pairwise` of them with time last |
| `Routes((C₁, d₁), (C₂, g₂))` | delays or arrays as route kernels; `Recurrence` only |

`Recurrence(kernel; lags, coupling, modifiers)` and `Convolution(kernel; lags, method)` take any of these.
An array of delays is read by its element type, so that type needs a `delay_masses` method.
`lags` has no default, since where a delay is cut is a modelling choice.
A kernel of delays without `lags` is an error, and so is `lags` on a kernel with no delays.
A continuous distribution has masses once a censoring choice discretises it.
Loading [CensoredDistributions](https://censoreddistributions.epiaware.org) as well makes that choice with its defaults: `delay_masses(d, lags; interval = 1)` takes the masses of `double_interval_censored(d; interval)`.
Without it, a continuous distribution is an error that names it.
The [CensoredDistributions extension](@ref extension-censored-distributions) page has an example.
Gradients reach the delays' parameters through their masses.

```jldoctest
using ComposableRecurrences, Distributions
delay = Convolution(Poisson(1.5); lags = 4)
generation = Recurrence(Poisson(1.5); lags = 4)
length(delay.kernel), length(generation.kernel)

# output

(4, 3)
```

```jldoctest
using ComposableRecurrences, Distributions
delay = Convolution(Poisson(1.5); lags = 4)
round.(delay([10.0, 20.0, 40.0, 80.0]); digits = 3)

# output

4-element Vector{Float64}:
  2.231
  7.81
 18.129
 37.514
```

## [Couplings](@id overview-couplings)

[Where the coupling acts](@ref explanation-coupling) gives where a coupling mixes the series, and what a row and a column of ``C`` mean.

| Name | What it does | Returns |
|---|---|---|
| `I`, `λI` | no mixing, or a uniform scaling | – |
| `S × S` matrix (dense, `Diagonal`, sparse) | contact, mobility or type-to-type mixing | – |
| [`TimeVarying(C)`](@ref TimeVarying) with `C` `S × S × T` | mixing that changes by day | – |
| your type | see [A coupling](@ref extending-coupling) | – |

## [Modifiers](@id overview-modifiers)

[Order](@ref explanation-modifier-order) gives the order modifiers act in, with each modifier's state.
The `add` input enters before every modifier, and `Add` enters where it sits in the tuple; [Imported cases](@ref tutorial-imports) compares the two for imports.
`Redistribute` moves whatever it receives, including values from `add`.

| Name | What it does | Recurrence | Per series | Parameters |
|---|---|---|---|---|
| [`Depletion(N; pools, form, weights, flows)`](@ref ComposableRecurrences.Depletion) | holds pools per group: draws each step's value from them by a depletion form, or fills one up to a capacity, and moves between them by [`Flow(from => to, demand; form)`](@ref ComposableRecurrences.Flow)s; sends what the draw leaves to a second series, a queue or nowhere; without a draw, moves the values themselves | yes | yes with one pool, else blockwise | `N`, `heterogeneity`, each starting pool, each draw weight and each flow's demand |
| [`Redistribute(M; leak)`](@ref ComposableRecurrences.Redistribute) | moves each series' value to others through a movement matrix whose columns sum to one; [`movement(K, ε)`](@ref ComposableRecurrences.movement) builds one from a kernel and an intensity | yes, with several series | no | `M` |
| [`Add(b)`](@ref ComposableRecurrences.Add) | adds ``b`` at this point in the order | yes | yes | `b` |
| [`Clamp(lo, hi)`](@ref ComposableRecurrences.Clamp) | bounds each value | yes | yes | `lo`, `hi` |
| [`Allocate(groups, total; imports, spill)`](@ref ComposableRecurrences.Allocate) | rescales each group of series to an exogenous total, keeping each series' share, with a fraction placed by an import pattern | yes, with several series | no | `total` and `fraction`, one per group; `pattern` |
| [`Transform(f, θ)`](@ref ComposableRecurrences.Transform) | maps each value through ``f(v, \theta)`` | yes | yes | `θ` |

Every parameter is a scalar, `PerStratum(x)`, `TimeVarying(x)`, `TimeVarying(PerStratum(x))`, a [`Recent`](@ref) read from the outputs, or a [`Derived`](@ref) of these, read through [`param`](@ref ComposableRecurrences.param).
Each modifier here has a hand-written gradient, except a `Transform` whose `f` holds floats and has no `derivative`; [Rules and plain AD](@ref adjoint-routing) gives the route a call takes.
The [Occupancy and capacity](@ref tutorial-occupancy) tutorial uses `Clamp` and a `Depletion` as a capacity and without a draw.

## [Depletion forms and indexing](@id overview-variants)

Depletion forms, flow forms and time indexing are types, and you pass an instance.

| Name | What it does | Example |
|---|---|---|
| [`Hazard()`](@ref ComposableRecurrences.Hazard), [`Floor()`](@ref ComposableRecurrences.Floor) | depletion forms | `Depletion(N)`, `Depletion(N; form = Floor())` |
| [`Truncate()`](@ref ComposableRecurrences.Truncate), [`SoftTruncate(κ)`](@ref ComposableRecurrences.SoftTruncate) | draw forms: what is asked for, up to what is left, exactly or smoothly | `Depletion(b; form = Truncate())`, `Depletion(C; form = SoftTruncate(0.1), fill = :S)` |
| [`Secondary()`](@ref ComposableRecurrences.Secondary) | a time-varying kernel's column ``\tau`` belongs to output day ``\tau``; the default | `TimeVarying(P)` |
| [`Primary()`](@ref ComposableRecurrences.Primary) | column ``\tau`` belongs to input day ``\tau``: a convolution's input, or a recurrence's output, so each keeps its own kernel | `TimeVarying(P, Primary())` |
| your type | a new depletion form, with a `forward!` method for `Step()` | `Depletion(N; form = MyForm())` |
| [`Share()`](@ref ComposableRecurrences.Share) | a flow form: the flow moves a share of its pool; a flow's form is otherwise `Hazard()` (a competing rate, the default), `Truncate()` or `SoftTruncate(κ)` (a count capped by what remains) | `Flow(:S => :V, p; form = Share())` |

The [Time-varying delays and kernels](@ref tutorial-time-varying-kernels) tutorial compares the two indexings.

## [Time-series processes](@id overview-time-series)

| Process | Maths | Code |
|---|---|---|
| Random walk | ``z_t = z_{t-1} + \epsilon_t`` | `Recurrence([1.0])(; history = [z0], add = ϵ)` |
| AR(p) | ``z_t = \sum_{l=1}^{p} \rho_l z_{t-l} + \epsilon_t`` | `Recurrence(ρ)(; history, add = ϵ)` |
| Time-varying AR(1) | ``z_t = \rho_t z_{t-1} + \epsilon_t`` | `Recurrence(TimeVarying(reshape(ρ, 1, :)))(; history, add = ϵ)` |
| MA(q) | ``z_t = \epsilon_t + \sum_{l=1}^{q} \theta_l \epsilon_{t-l}`` | `Convolution(vcat(1, θ))(ϵ)` |
| Values before the gain | ``p_t = \sum_{l=1}^{L} k_l y_{t-l}`` | `Convolution(vcat(0, k))(y; history)` |

The [Latent processes driving R_t](@ref tutorial-latent-rt) tutorial builds each process.

## [Executors](@id overview-executors)

| Name | What it does | Returns |
|---|---|---|
| [`EXECUTOR`](@ref ComposableRecurrences.EXECUTOR) | the executor operator calls use, set for a block with `with` | a scoped value |
| [`Serial()`](@ref ComposableRecurrences.Serial), [`Threaded()`](@ref ComposableRecurrences.Threaded), [`Device(backend)`](@ref ComposableRecurrences.Device) | the built-in executors | an executor |

[Executors](@ref executors) says what each does and supports under each AD backend.

## [Extension API](@id overview-extending)

These names are for writing a new coupling, modifier, depletion form or executor, and for checking its gradient.
A model built from the package's own parts needs none of them.
[Writing new types](@ref extending) gives the contract and an example for each role.

| Name | What it does | Returns |
|---|---|---|
| [`forward!(m, role, args...)`](@ref ComposableRecurrences.forward!) | the maths of a modifier, coupling or depletion form for one job | writes in place, returns `nothing` |
| [`forward(op, Run(), args...)`](@ref ComposableRecurrences.forward) | an operator's whole call, which the rules and `test_adjoint` use | `(y, cache)` |
| [`pullback!(grads, m, role, args...)`](@ref ComposableRecurrences.pullback!) | its hand-written gradient, optional | accumulates cotangents |
| [`Step()`](@ref ComposableRecurrences.Step), [`Init()`](@ref ComposableRecurrences.Init), [`Pressure()`](@ref ComposableRecurrences.Pressure), [`Trace()`](@ref ComposableRecurrences.Trace) | the job a `forward!` method does: one step, the starting state, a coupling's mixing, a modifier's record for a call with `trace = true` | singletons for dispatch |
| [`Run()`](@ref ComposableRecurrences.Run) | the job of `forward`: an operator's whole call | a singleton for dispatch |
| [`ntrace(m, S)`](@ref ComposableRecurrences.ntrace) | how many rows a modifier's trace has | `Int` |
| [`uses_adjoint(m, role)`](@ref ComposableRecurrences.uses_adjoint) | whether the rule calls `m`'s `pullback!` for `role`; see [Rules and plain AD](@ref adjoint-routing) | `Bool` |
| [`ispointwise(m)`](@ref ComposableRecurrences.ispointwise) | marks a modifier that acts on each series separately | `Bool` |
| [`blocks(m)`](@ref ComposableRecurrences.blocks) | marks a modifier that acts on groups of series, `Val((nv, ns))` values and state entries per group | `Val` or `nothing` |
| [`nstate(m, S)`](@ref ComposableRecurrences.nstate) | the number of state entries a modifier keeps for `S` series | `Int` |
| [`param(x, k, t)`](@ref ComposableRecurrences.param), [`add_param!(x̄, x, v, k, t)`](@ref ComposableRecurrences.add_param!) | read a parameter for series `k` at time `t`, and add to its cotangent | a value, or `nothing` |
| [`cotangent(x̄, name)`](@ref ComposableRecurrences.cotangent), [`add_cotangent!(x̄, v, idx...)`](@ref ComposableRecurrences.add_cotangent!) | the cotangent of a field, and an addition to it | a cotangent, or `nothing` |
| [`depth(x)`](@ref ComposableRecurrences.depth) | how many past outputs a modifier, coupling or kernel reads, to deepen the buffer past the kernel | `Int` |
| [`param_eltype(x)`](@ref ComposableRecurrences.param_eltype) | the element type a type's parameters promote the buffer to | a type |
| [`PieceInterface`](@ref ComposableRecurrences.PieceInterface) | the Interfaces.jl conformance test for a new type | a test result |
| [`Executor`](@ref ComposableRecurrences.Executor), [`each!(body, ex, n, work, args...)`](@ref ComposableRecurrences.each!) | the executor supertype, and the loop a new executor adds a method of | `nothing` |

### [Checking gradients](@id overview-gradients)

| Name | What it does | Returns |
|---|---|---|
| [`NoAdjoint(op)`](@ref ComposableRecurrences.NoAdjoint) | the same operator, differentiated by automatic differentiation instead of its hand-written gradient, to check or time one against the other | an operator |
| [`test_adjoint(backend, op, Run(), args...)`](@ref ComposableRecurrences.test_adjoint) | runs a backend's own rule tester on an operator's hand-written gradient | a test result |

[Adjoints and backends](@ref adjoints-backends) says when each backend uses the hand-written gradient.
