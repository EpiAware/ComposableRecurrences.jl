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
| seed and resume       | `history =`, `prepend = true`, `with_state`, `state =`   |
| modifiers             | `Depletion`, `Redistribute`, `Add`, `Clamp`, `Transform` |
| admitted and overflow | `Capacity(C, Stock(δ); pairs = [a => o])`                |
| variants              | structs: `Hazard()`, `Floor()`, `Primary()`              |
| extension             | a type with a `forward` method for a role                |

To extend the package, define a type and add a
[`ComposableRecurrences.forward`](@ref) method, and optionally a
[`ComposableRecurrences.pullback!`](@ref) method, for its role
([`ComposableRecurrences.Step`](@ref), [`ComposableRecurrences.Init`](@ref)
or [`ComposableRecurrences.Pressure`](@ref)).

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
using ForwardDiff: ForwardDiff
using Interfaces: Interfaces, Arguments, @interface, @implements
using LinearAlgebra: Diagonal, I, UniformScaling
using SparseArrays: SparseMatrixCSC, nonzeros, nzrange, rowvals
using Base.ScopedValues: ScopedValue

# Register the standard docstring conventions before any
# docstrings are defined (see src/docstrings.jl).
include("docstrings.jl")

export Recurrence, Convolution, TimeVarying, PerStratum, Pairwise, Derived

public Depletion, Protected, Redistribute, Add, Clamp, Allocate, Capacity,
    Stock, Budget, Route, Hold, Transform,
    Hazard, Floor, Primary, Secondary, seeded, exponential_history,
    with_state, State, contributions, forward,
    pullback!, Step, Init, Pressure, Run, ispointwise, nstate, param_eltype,
    NoAdjoint, PieceInterface, uses_adjoint, test_adjoint, cotangent,
    add_cotangent!, Executor, Serial, Threaded, Device, EXECUTOR, each!,
    param, add_param!

# Slot wrappers: time-varying, per-stratum and pairwise coefficients.
include("wrappers.jl")
# Shape and eltype helpers shared by the operators.
include("utils.jl")
# Executors: how loops over independent strata, series or times run.
include("executor.jl")
# The role interface: roles, `forward`, `pullback!` and the stage loop.
include("modifiers.jl")
# The operator supertype, `NoAdjoint` and the routing to the native rules.
include("adjoints.jl")
# The built-in modifiers and depletion forms.
include("builtin_modifiers.jl")
# Depletion with removals and a protected pool.
include("depletion_pools.jl")
# Rescaling groups of strata to exogenous totals.
include("allocate.jl")
# Routing demand between admitted and overflow strata under a capacity.
include("capacity.jl")
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
# The Transform modifier, a pointwise map with parameters.
include("transform.jl")
# Parameters computed from other parameters.
include("derived.jl")

end # module ComposableRecurrences
