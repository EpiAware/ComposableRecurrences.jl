"""
    ComposableRecurrences

Fast, composable and differentiable recurrences and causal convolutions.

A recurrence steps a value forward from a window of its own past values, as in
a renewal process, a random walk or an autoregression.
A causal convolution weights past inputs by a kernel, as in a reporting delay.
The package owns the history buffer these steps read from, so reverse-mode
automatic differentiation does not copy the lag window at every step.

[`Recurrence`](@ref) and [`Convolution`](@ref) are the operators.
[`TimeVarying`](@ref), [`PerStratum`](@ref) and [`Pairwise`](@ref) set the
shape of a kernel or coupling.
Public arrays are strata × time, with time on the last axis; a single series
is a vector.

# Example

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
using Interfaces: Interfaces, Arguments, @interface, @implements
using LinearAlgebra: Diagonal, I, UniformScaling, axpy!, dot
using SparseArrays: SparseMatrixCSC, nonzeros, nzrange, rowvals

# Register the standard EpiAware docstring conventions before any
# docstrings are defined (see src/docstrings.jl).
include("docstrings.jl")

export Recurrence, Convolution, TimeVarying, PerStratum, Pairwise

public init_state, apply, apply!, apply_pullback!, apply_pullback,
    init_state_pullback!, ispointwise, param_eltype, pressure!, pressure_pullback!,
    pullback!, NoAdjoint, OperatorInterface, CouplingInterface,
    ModifierInterface, Depletion, Imports, Redistribute, Clamp, State

# Slot wrappers: time-varying, per-stratum and pairwise coefficients.
include("wrappers.jl")
# Shape and eltype helpers shared by the operators.
include("utils.jl")
# The modifier interface and the stage loop that threads modifiers.
include("modifiers.jl")
# The built-in modifiers: Depletion, Imports, Redistribute and Clamp.
include("builtin_modifiers.jl")
# The coupling interface: `pressure!` for each coupling type.
include("couplings.jl")
# The recurrence operator and its buffer loop.
include("recurrence.jl")
# The causal convolution operator.
include("convolution.jl")
# Adjoint seams: `NoAdjoint` and the `pullback!` contract.
include("adjoints.jl")
# Interfaces.jl declarations for operators, couplings and modifiers.
include("interfaces.jl")

end # module ComposableRecurrences
