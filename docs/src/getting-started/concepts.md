# [Concepts: operators and the pieces they compose](@id concepts)

An operator is a recurrence or a convolution built from a kernel and the pieces that shape its steps.
Find the piece you need by intent here, then see it at work in the tutorials.

Names that are public but not exported are written unqualified below.
Load them with `using ComposableRecurrences: Depletion, Floor, with_state`, and so on.

The package has these layers.

- **Operators** step a series forward or weight past inputs.
- **Calls and state** run an operator over a window of time and resume it.
- **Shapes** mark how a kernel, coupling or parameter is indexed by strata and time.
- **Couplings** mix strata within a step.
- **Modifiers** act on each step's values in order.
- **Variants** choose between forms of one piece.
- **Extending** adds your own piece.
- **Tooling** checks an operator's gradients.

## Operators

| Name | What it does | Returns |
|---|---|---|
| `Recurrence(kernel; coupling, modifiers)` | steps a series forward from its own last `L` values; kernel lag 1 first | a callable operator |
| `Convolution(kernel)` | weights current and past inputs by a kernel; kernel lag 0 first | a callable operator |

## Calls and state

| Name | What it does | Returns |
|---|---|---|
| `r(gain; history, add, start, stop)` | runs a recurrence over `start:stop`; `gain` scales and `add` adds before the modifiers | length `T` or `S × T` output |
| `c(x; history, start, stop)` | runs a convolution over `start:stop` | output in the layout of `x` |
| `with_state(op, args...; kwargs...)` | the same call, also returning where it stopped | `(y, state)` |
| `r(...; state)` | resumes from a `State`, for example a forecast after a fit | output from `state.t` on |
| `seeded(r, gain; history)` | runs after the seed days and returns them joined | seed and output |
| `State` | the last outputs, each modifier's state and the next time | a struct |

## Shapes

A bare array has the slot's own axes only.
Data (inputs, history and outputs) are strata × time and are never wrapped.

| Name | What it does | Returns |
|---|---|---|
| vector | one kernel shared by every stratum | `L` lags |
| `PerStratum(x)` | one kernel or parameter per stratum | adds a leading `S` axis |
| `Pairwise(A)` | one kernel per pair of strata, which mixes strata itself so the coupling stays `I` | `S × S × L` |
| `TimeVarying(x)` | a kernel, coupling or parameter that changes by day | adds a trailing `T` axis |
| `Secondary()` | column `t` is read at output time `t`; the default | an indexing variant |
| `Primary()` | column `c` is the kernel of the input at time `c`; convolution kernels only | an indexing variant |

## Couplings

A coupling mixes the strata after the kernel, `x_t = C_t (kernel ⋆ y)_t`.

| Name | What it does | Returns |
|---|---|---|
| `I`, `λI` | no mixing, or a uniform scaling | – |
| `S × S` matrix (dense, `Diagonal`, sparse) | contact, mobility or type-to-type mixing | – |
| `TimeVarying(C)` with `C` `S × S × T` | mixing that changes by day | – |
| your struct | `forward` on `Pressure()` | – |

## Modifiers

A modifier acts on `v_t = gain_t ⊙ x_t + add_t` after each recurrence step, in tuple order, with its own state.

| Name | What it does | Recurrence | Convolution | Pointwise | Adjoint | Parameters |
|---|---|---|---|---|---|---|
| `Depletion(N, form)` | draws each step's values from a finite pool, with removals and a protected pool | yes | no | yes; no with `protected` | hand-written | `N`, `heterogeneity`, `pool0`, `removals`, `protected` |
| `Redistribute(K, ε)` | moves a share `ε` of each stratum's value to others through `K` | yes, with strata | no | no | hand-written | `ε` |
| `Add(b)` | adds `b` at this point in the modifier order | yes | no | yes | hand-written | `b` |
| `Clamp(lo, hi)` | bounds each value | yes | no | yes | hand-written | `lo`, `hi` |

Every parameter is a scalar, `PerStratum(x)`, `TimeVarying(x)` or `TimeVarying(PerStratum(x))`.
A bare array is an error that names the wrapper to use.

## Variants

| Name | What it does | Example |
|---|---|---|
| `Hazard()`, `Floor()` | depletion forms | `Depletion(N)`, `Depletion(N, Floor())` |
| `Primary()`, `Secondary()` | `TimeVarying` indexing | `TimeVarying(P, Primary())` |
| your struct | a new depletion form, with `forward` on `Step()` | `Depletion(N, MyForm())` |
| `Protected(σ; pool0)` | a pool that depletion removals move into, drawn from at relative susceptibility `σ` | `Depletion(N; removals, protected = Protected(σ))` |

## Extending

| Name | What it does | Returns |
|---|---|---|
| `forward(piece, role, args...)` | the piece's maths for a role | writes in place, or returns scalars |
| `pullback!(grads, piece, role, args...)` | its hand-written adjoint, optional | accumulates cotangents |
| `Run()`, `Step()`, `Init()`, `Pressure()` | roles: an operator call, a modifier step, a modifier's initial state, a coupling's mixing | singletons |
| `ispointwise(m)` | opts a modifier into the scalar `Step()` form | `Bool` |
| `param_eltype(x)` | the element type a piece's parameters promote the buffer to | a type |
| `PieceInterface` | the Interfaces.jl conformance test for a new piece | a test result |

## Tooling

| Name | What it does | Returns |
|---|---|---|
| `NoAdjoint(op)` | the same operator differentiated by plain AD, to compare against its adjoint | an operator |

## Concept to primitive

| Concept | Primitive |
|---|---|
| Renewal process | `Recurrence(gi)` with `R_t` as the gain |
| Susceptible depletion | `Depletion(N)` or `Depletion(N, Floor())` |
| All-or-nothing vaccination | `Depletion(N; removals = TimeVarying(e .* doses), protected = Protected(0))` |
| Leaky vaccination | `Depletion(N; removals = TimeVarying(doses), protected = Protected(1 - e))` |
| Imported cases | `add = ι` before the modifiers, or `Add(TimeVarying(ι))` at a place in their order |
| Random walk | `Recurrence([1.0])(; history = [z0], add = ϵ)` |
| AR(p) | `Recurrence(ρ)` with the innovations as `add` |
| Time-varying AR | `Recurrence(TimeVarying(ρ_t))` |
| MA(q) | `Convolution(vcat(1, θ))` |
| Reporting delay | `Convolution(pmf)` |
| Delay that changes over time | `Convolution(TimeVarying(P))` or `TimeVarying(P, Primary())` |
| Spatial or group mixing | `coupling = K` or `TimeVarying(K)` |
| Per-group generation interval | `PerStratum(G)`, or `Pairwise(A)` per pair |
| Importation between patches | `Redistribute(K, ε)` |
| Bed occupancy | `Convolution(survival)` or `Recurrence([1 - d])` with admissions as `add` |
| Bed cap | `Clamp(0, beds)` |
| Forecast from a fit | `with_state`, then `state =` |
| Seed days returned first | `seeded` |
| Intermediate quantities | recompute with `Convolution(vcat(0, g))` and array operations |
