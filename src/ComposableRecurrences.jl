@doc raw"""
    ComposableRecurrences

Fast, composable and differentiable recurrences and convolutions.

A recurrence computes each value from its own past values, such as infections
from earlier infections.
A convolution weights the past values of another series, such as reported cases
from earlier infections.
For a single series the two are

```math
y_t = \gamma_t \sum_{l=1}^{L} k_l\, y_{t-l}
\qquad \text{and} \qquad
y_t = \sum_{l=0}^{L-1} k_l\, x_{t-l},
```

where ``y_t`` is the output at time ``t``, ``\gamma_t`` a multiplicative input,
``x_t`` the convolved input and ``k_l`` the kernel weight on lag ``l``.
Every operator is differentiable with forward- and reverse-mode
[automatic differentiation backends](@ref adjoint-backends).

[`Recurrence`](@ref) and [`Convolution`](@ref) are the operators.
A plain array holds one set of coefficients: a kernel's lag weights, a
coupling's `S × S` matrix or a modifier parameter's single value.
[`PerStratum`](@ref) gives one set per stratum, [`Pairwise`](@ref) one per
pair of strata and [`TimeVarying`](@ref) one per time.
Inputs, histories and outputs are strata × time arrays, or a vector for a
single series.
Time is absolute, counted from 1, and a call covers the times `start:stop`.

| concept              | one way                                                              |
|:---------------------|:---------------------------------------------------------------------|
| feedback recursion   | `Recurrence(kernel; coupling, modifiers)`, lag 1 first               |
| convolution          | `Convolution(kernel)`, lag 0 first                                   |
| strata               | `PerStratum(x)`, `Pairwise(x)`                                       |
| time variation       | `TimeVarying(x)`, `TimeVarying(x, Primary())`                        |
| strata and time      | `TimeVarying(PerStratum(x))`, `TimeVarying(Pairwise(x))`             |
| multiplicative input | `r(gain; ...)`                                                       |
| additive input       | `add =`, before the modifiers                                        |
| seed and resume      | `history =`, `state =`                                               |
| modifiers            | `Depletion`, `Redistribute`, `Add`, `Clamp`, `Allocate`, `Transform` |
| pools and flows      | `Depletion(N, Hazard(), Flow(from => to, d); pools)`                 |
| filling a pool       | `Depletion(C, Truncate(; into = :O); pools)`                         |
| variants             | structs: `Hazard()`, `Floor()`, `Primary()`                          |
| extension            | a type with a `forward!` method for a role                           |

To extend the package, define a type and add a
[`ComposableRecurrences.forward!`](@ref) method, and optionally a
[`ComposableRecurrences.pullback!`](@ref) method, for its role
([`ComposableRecurrences.Step`](@ref), [`ComposableRecurrences.Init`](@ref),
[`ComposableRecurrences.Pressure`](@ref) or
[`ComposableRecurrences.Trace`](@ref)).

# Examples

```jldoctest
using ComposableRecurrences
g = [0.1, 0.3, 0.6]
y = Recurrence(g)(fill(1.2, 10); history = ones(3))
round.(y; digits = 3)

# output

10-element Vector{Float64}:
 1.2
 1.224
 1.299
 1.461
 1.524
 1.644
 1.798
 1.905
 2.059
 2.227
```
"""
module ComposableRecurrences

# All genuine module-scope `using`/`import` statements live here, in
# the main module file, rather than scattered across included files.
using ConstructionBase: ConstructionBase, constructorof
using DocStringExtensions: @template, DOCSTRING, EXPORTS, IMPORTS,
    TYPEDEF, TYPEDFIELDS, TYPEDSIGNATURES
using Interfaces: Interfaces, Arguments, @interface, @implements
using LinearAlgebra: Diagonal, I, UniformScaling, mul!
using SparseArrays: SparseMatrixCSC, nonzeros, nzrange, rowvals
using Base.ScopedValues: ScopedValue

# Register the standard docstring conventions before any
# docstrings are defined (see src/docstrings.jl).
include("docstrings.jl")

export Recurrence, Convolution, TimeVarying, PerStratum, Pairwise

public Derived, Recent, Depletion, Flow, Share, Redistribute, movement,
    Add, Clamp, Allocate, Transform, Hazard, Floor, Truncate, SoftTruncate,
    Primary, exponential_history, forward!, pullback!, Step, Init, Pressure,
    blocks, nstate, NoAdjoint, PieceInterface, cotangent, Serial, Threaded,
    Device, EXECUTOR, param, add_param!, Direct, FFTMethod, delay_masses,
    pressure, Survival, kernel_weights

# shapes: slot wrappers and shape and eltype helpers.
# Time-varying, per-stratum and pairwise coefficients.
include("shapes/wrappers.jl")
# Shape and eltype helpers shared by the operators.
include("shapes/utils.jl")

# interface: roles, the trace role and `PieceInterface`.
# Roles, `forward!`, `pullback!` and the stage loop.
include("interface/roles.jl")
# The trace role: what a call with `trace = true` records per modifier.
include("interface/trace.jl")
# `PieceInterface` and its checks; each type declares it beside its methods.
include("interface/declarations.jl")

# couplings: how strata mix.
# The built-in couplings, `forward!` and `pullback!` on `Pressure()`.
include("couplings/builtin.jl")

# adjoints: executors and the routing to the native rules.
# How loops over independent strata, series or times run.
include("adjoints/executor.jl")
# The operator supertype, `NoAdjoint` and the routing to the native rules.
include("adjoints/adjoints.jl")

# modifiers: the built-in modifiers.
# The built-in modifiers and the exponent depletion forms.
include("modifiers/builtin.jl")
# Rescaling groups of strata to exogenous totals.
include("modifiers/allocate.jl")
# A pointwise map with parameters.
include("modifiers/transform.jl")

# parameters: computed, recent-output and change-point parameters.
# Parameters computed from other parameters.
include("parameters/derived.jl")
# Parameters read from the recurrence's own recent outputs.
include("parameters/recent.jl")
# `TimeVarying` coefficients given by change points.
include("parameters/piecewise.jl")

# depletion: `Depletion` forms, flows and pools.
# Depletion forms that draw up to what the pool holds.
include("depletion/truncate.jl")
# Flows between the pools of a `Depletion`.
include("depletion/flows.jl")
# `Depletion`: pools drawn from by a depletion form and moved by flows.
include("depletion/pool.jl")

# operators: `Recurrence` and `Convolution`, their loops and reverse passes.
# The recurrence operator and its buffer loop.
include("operators/recurrence.jl")
# A call with its trace, built from the records after the run.
include("operators/trace_run.jl")
# The analytic reverse pass of the recurrence.
include("operators/recurrence_adjoint.jl")
# The convolution operator and its reverse pass.
include("operators/convolution.jl")
# The transpose of a convolution, a sum that reads the series forward.
include("operators/transpose.jl")
# The pressure a recurrence's steps draw against, from given outputs.
include("operators/pressure.jl")

# kernels: routes kernels, delay masses and computed kernels.
# The routes kernel: a sum of (coupling, kernel) routes.
include("kernels/routes.jl")
# The masses of a delay on whole lags, the hook delay types extend.
include("kernels/delays.jl")
# Kernels computed from coefficients: `Survival` and the fill of the weights.
include("kernels/weights.jl")
# Operators whose kernel is computed from coefficients, and `kernel_weights`.
include("kernels/computed.jl")

# adjoints, loaded last: it reads `_EntryParam` from `operators/recurrence.jl`.
# Default pullbacks of modifiers and couplings without one.
include("adjoints/fallbacks.jl")

end # module ComposableRecurrences
