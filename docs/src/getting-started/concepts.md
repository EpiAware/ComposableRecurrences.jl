# [Concepts: operators, wrappers, modifiers and tooling](@id concepts)

This page groups the package's operations by what they do, so you can find the right one before reading the tutorials.
The status column marks each row as available, in progress or planned.

## Operators

An operator is built once from a kernel and called like a function.

| Operation | What it does | Returns | Status |
|---|---|---|---|
| `Recurrence(kernel; coupling, modifiers)` | steps a value forward from its own last `L` outputs | a `Recurrence` | available |
| `Convolution(kernel; modifiers)` | weights past inputs by a kernel | a `Convolution` | available; `modifiers` in progress |
| `r(gain; history, add, return_state)` | runs a recurrence over the steps of `gain` or `add` | the output, and optionally the state `(; history, states, t)` | available |
| `c(x; history)` | runs a convolution over `x` | the output | available |

See [Operators](@ref operators) for the maths.

## Kernel and coupling wrappers

A wrapper marks how a kernel or coupling array is indexed.
Every kernel is lag-first.

| Operation | What it does | Returns | Status |
|---|---|---|---|
| `TimeVarying(x)` | a kernel or coupling that changes over time, time last | a `TimeVarying` | available |
| `PerStratum(x)` | one kernel per stratum, `S × L` | a `PerStratum` | available |
| `Pairwise(x)` | a coupling that depends on the lag, `S × S × L` | a `Pairwise` | available |
| `I`, a dense or sparse matrix, `Diagonal` | a fixed coupling between strata | used as given | available |

See [Shapes and coefficients](@ref shapes) and [Couplings](@ref couplings).

## Modifiers

A modifier acts on each output step in order and keeps its own state.
The scope columns show where each one applies.

| Modifier | What it does | Status | Recurrence | Convolution | Pointwise | Analytic adjoint | Specialised |
|---|---|---|---|---|---|---|---|
| `Depletion(N; form, seeded)` | scales by the remaining pool, with an optional `(S/N)^α` heterogeneity | in progress | yes | – | yes | yes | needs feedback |
| `Imports(b)` | adds a time-indexed input | in progress | yes | yes | yes | yes | – |
| `Redistribute(K, ε)` | moves a share `ε` of each stratum's value to others through `K` | in progress | yes | yes | no | yes | strata only |
| `Clamp(lo, hi)` | bounds each value | in progress | yes | yes | yes | yes | – |
| `Transform(f, θ)` | applies a user function to each value | in progress | yes | yes | yes | optional | – |
| `Capacity(C)` | caps a stratum and carries the overflow in its state | planned | yes | – | – | – | – |
| `Feedback(κ)` | changes the step in response to past outputs, such as a threshold trigger | planned | yes | – | – | – | – |

A modifier without an analytic adjoint is differentiated locally for its step.
See [Modifiers](@ref modifiers).

## Tooling

These operations check and time the adjoints.

| Operation | What it does | Returns | Status |
|---|---|---|---|
| `NoAdjoint(op)` | turns the adjoint off so a backend differentiates the plain code | a wrapped operator | available |
| `test_adjoint(backend, op, args...)` | tests an operator's adjoint on one backend | a test result | planned |
| `benchmark_adjoint(op)` | times an operator's gradient with and without its adjoint | a benchmark table | planned |
| `scenarios(op)` | the test and benchmark cases for an operator | a vector of scenarios | planned |

See [Adjoints](@ref adjoints).
