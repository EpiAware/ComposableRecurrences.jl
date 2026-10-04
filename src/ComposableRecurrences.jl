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
Every operator is differentiable, and the README lists the automatic
differentiation backends it is tested with.

[`Recurrence`](@ref) and [`Convolution`](@ref) are the operators.
A plain array holds one set of coefficients: a kernel's lag weights, a
coupling's `S × S` matrix or a modifier parameter's single value.
[`PerStratum`](@ref) gives one set per stratum, [`Pairwise`](@ref) one per
pair of strata and [`TimeVarying`](@ref) one per time.
A stratum is one of `S` parallel series computed together, such as a place
or an age group.
Inputs, histories and outputs are strata × time arrays, or a vector for a
single series.
Time is absolute, counted from 1, and a call covers the times `start:stop`.

| concept               | one way                                                  |
|:--------------------- |:-------------------------------------------------------- |
| feedback recursion    | `Recurrence(kernel; coupling, modifiers)`, lag 1 first   |
| causal convolution    | `Convolution(kernel)`, lag 0 first                       |
| strata                | `PerStratum(x)`, `Pairwise(x)`                           |
| time variation        | `TimeVarying(x, Secondary())`                            |
| multiplicative input  | `r(gain; ...)`                                           |
| additive input        | `add =`, before the modifiers                            |
| seed and resume       | `history =`, `with_state`, `state =`, `seeded`           |
| modifiers             | `Depletion`, `Redistribute`, `Add`, `Clamp`              |
| variants              | structs: `Hazard()`, `Floor()`, `Primary()`              |
| extension             | a type with a `forward` method for a role                |

To extend the package, define a type and add a
[`ComposableRecurrences.forward`](@ref) method, and optionally a
[`ComposableRecurrences.pullback!`](@ref) method, for its role
([`ComposableRecurrences.Step`](@ref), [`ComposableRecurrences.Init`](@ref)
or [`ComposableRecurrences.Pressure`](@ref)).

# Examples

```@example
using ComposableRecurrences
g = [0.1, 0.3, 0.6]
Recurrence(g)(fill(1.2, 10); history = ones(3))
```
"""
module ComposableRecurrences

# All genuine module-scope `using`/`import` statements live here, in
# the main module file, rather than scattered across included files.
using DocStringExtensions: @template, DOCSTRING, EXPORTS, IMPORTS,
    TYPEDEF, TYPEDFIELDS, TYPEDSIGNATURES
using ForwardDiff: ForwardDiff
using Interfaces: Interfaces, Arguments, @interface, @implements
using LinearAlgebra: Diagonal, I, UniformScaling
using SparseArrays: SparseMatrixCSC, nonzeros, nzrange, rowvals

# Register the standard docstring conventions before any
# docstrings are defined (see src/docstrings.jl).
include("docstrings.jl")

export Recurrence, Convolution, TimeVarying, PerStratum, Pairwise

public Depletion, Redistribute, Add, Clamp, Hazard, Floor, Primary,
    Secondary, seeded, with_state, State, forward, pullback!, Step, Init,
    Pressure, Run, ispointwise, param_eltype, NoAdjoint, PieceInterface,
    uses_adjoint, test_adjoint, cotangent, add_cotangent!

# Slot wrappers: time-varying, per-stratum and pairwise coefficients.
include("wrappers.jl")
# Shape and eltype helpers shared by the operators.
include("utils.jl")
# The role interface: roles, `forward`, `pullback!` and the stage loop.
include("modifiers.jl")
# The operator supertype, `NoAdjoint` and the routing to the native rules.
include("adjoints.jl")
# The built-in modifiers and depletion forms.
include("builtin_modifiers.jl")
# The built-in couplings, `forward` and `pullback!` on `Pressure()`.
include("couplings.jl")
# The recurrence operator and its buffer loop.
include("recurrence.jl")
# The analytic reverse pass of the recurrence.
include("recurrence_adjoint.jl")
# The causal convolution operator and its reverse pass.
include("convolution.jl")
# Local `ForwardDiff` pullbacks for pointwise modifiers and initial states.
include("fallbacks.jl")
# Interfaces.jl declaration of the role interface.
include("interfaces.jl")

end # module ComposableRecurrences
