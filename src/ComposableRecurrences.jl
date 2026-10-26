@doc raw"""
    ComposableRecurrences

Fast, composable and differentiable recurrences and causal convolutions.

A recurrence steps a value forward from a window of its own past values, as in
an autoregression.
A causal convolution weights past inputs by a kernel, as in a delay.
For a single series the two are

```math
y_t = g_t \sum_{l=1}^{L} k_l\, y_{t-l}
\qquad \text{and} \qquad
y_t = \sum_{l=0}^{L-1} k_l\, x_{t-l},
```

where ``y_t`` is the output at time ``t``, ``g_t`` a multiplicative input,
``x_t`` the convolved input and ``k_l`` the kernel weight on lag ``l``.
Every operator is differentiable, and [Backends](@ref adjoint-backends)
lists the automatic differentiation backends it is tested with.
The [performance figure](@ref overview-performance) compares run and
gradient times with a hand-written loop.

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
| causal convolution   | `Convolution(kernel)`, lag 0 first                                   |
| strata               | `PerStratum(x)`, `Pairwise(x)`                                       |
| time variation       | `TimeVarying(x, Secondary())`                                        |
| strata and time      | `TimeVarying(PerStratum(x))`, `TimeVarying(Pairwise(x))`             |
| multiplicative input | `r(gain; ...)`                                                       |
| additive input       | `add =`, before the modifiers                                        |
| seed and resume      | `history =`, `prepend = true`, `state =`                             |
| modifiers            | `Depletion`, `Redistribute`, `Add`, `Clamp`, `Allocate`, `Transform` |
| pools and flows      | `Depletion(N; pools, weights, flows)`, `Flow(from => to, d)`         |
| filling a pool       | `Depletion(C; form = Truncate(), fill = :O)`                         |
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

export Recurrence, Convolution, TimeVarying, PerStratum, Pairwise, Routes, Derived,
    Recent

public Depletion, Flow, Share, Redistribute, movement,
    Add, Clamp, Allocate,
    Transform, Hazard, Floor, Truncate, SoftTruncate, Primary, Secondary,
    exponential_history, State, contributions, forward!, pullback!, Step,
    Init, Pressure, Run, Trace, ispointwise, blocks, nstate, ntrace, depth,
    param_eltype, NoAdjoint, PieceInterface, uses_adjoint, cotangent,
    add_cotangent!, Serial, Threaded, Device, EXECUTOR, param, add_param!,
    Auto, Direct, FFTMethod, delay_masses

# interface: roles, `forward!`, `pullback!` and the trace role.
include("interface/modifiers.jl")
include("interface/trace.jl")

# shapes: slot wrappers, shape and eltype helpers, and couplings.
include("shapes/wrappers.jl")
include("shapes/utils.jl")
include("shapes/couplings.jl")

# adjoints: executors and the routing to the native rules.
include("adjoints/executor.jl")
include("adjoints/adjoints.jl")

# modifiers: the built-in modifiers.
include("modifiers/builtin_modifiers.jl")
include("modifiers/allocate.jl")

# parameters: computed from parameters, recent outputs or change points.
include("parameters/derived.jl")
include("parameters/recent.jl")
include("parameters/piecewise.jl")

# depletion: `Depletion` forms, flows and pools.
include("depletion/truncate.jl")
include("depletion/flows.jl")
include("depletion/pool.jl")

# operators: `Recurrence` and `Convolution`, their loops and reverse passes.
include("operators/recurrence.jl")
include("operators/trace_run.jl")
include("operators/recurrence_adjoint.jl")
include("operators/convolution.jl")

# kernels: routes kernels and delay masses.
include("kernels/routes.jl")
include("kernels/delays.jl")

# Files below need the operators' types, so load after them.
# adjoints: default pullbacks of modifiers and couplings without one.
include("adjoints/fallbacks.jl")
# interface: the Interfaces.jl declaration of the role interface.
include("interface/interfaces.jl")
# modifiers: `Transform`, which declares its own `PieceInterface`.
include("modifiers/transform.jl")

end # module ComposableRecurrences
