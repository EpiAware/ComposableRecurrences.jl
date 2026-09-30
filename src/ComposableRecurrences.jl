"""
    ComposableRecurrences

Fast, composable and differentiable recurrences and causal convolutions.

A recurrence steps a value forward from a window of its own past values, as in
a renewal process, a random walk or an autoregression.
A causal convolution weights past inputs by a kernel, as in a reporting delay.
The package owns the history buffer these steps read from, so reverse-mode
automatic differentiation does not copy the lag window at every step.

The package is under development and has no public API yet.

# Example

```@example
using ComposableRecurrences
```
"""
module ComposableRecurrences

# All genuine module-scope `using`/`import` statements live here, in
# the main module file, rather than scattered across included files.
using DocStringExtensions: @template, DOCSTRING, EXPORTS, IMPORTS,
    TYPEDEF, TYPEDFIELDS, TYPEDSIGNATURES

# Register the standard EpiAware docstring conventions before any
# docstrings are defined (see src/docstrings.jl).
include("docstrings.jl")

end # module ComposableRecurrences
