# [Reactant extension](@id extension-reactant)

`ComposableRecurrencesReactantExt` is loaded automatically when Reactant is available alongside ComposableRecurrences.

Operator calls on traced arrays compile with `Reactant.@compile`, and so do Enzyme gradients of them:

```julia
using ComposableRecurrences, Reactant
r = Recurrence([0.5, 0.3])
R = Reactant.to_rarray(fill(1.1, 50))
f(R) = r(R; history = [1.0, 1.0])
y = (Reactant.@compile f(R))(R)
```

A traced call runs serially whatever [executor](@ref executors) is set, and Enzyme differentiates the traced program rather than using the hand-written gradients.
The step loops are unrolled when traced, so compile time grows with the number of steps and [strata](@ref glossary-stratum).
[`test/reactant/RESULTS.md`](https://github.com/EpiAware/ComposableRecurrences.jl/blob/main/test/reactant/RESULTS.md) lists the cases checked.
