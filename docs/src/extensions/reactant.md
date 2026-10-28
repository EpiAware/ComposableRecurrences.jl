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

To [join the history in front](@ref explanation-returns) of a traced output, pass the history in as a traced array too.
Joining a host array to a traced one is a scalar-indexing error.

```julia
h = Reactant.to_rarray([1.0, 1.0])
joined(R, h) = vcat(h, r(R; history = h))
y = (Reactant.@compile joined(R, h))(R, h)
```

A traced call runs its own executor whatever [executor](@ref executors) is set, and Enzyme differentiates the traced program rather than using the hand-written gradients.
The time loop compiles to one loop whose body is a step, so compile time does not grow with the number of steps.
The [strata](@ref overview-step) loops within a step are written out, so the program grows with the number of strata.
The [support matrix](https://github.com/EpiAware/ComposableRecurrences.jl/blob/main/test/reactant/RESULTS.md) records, for each case at 20 and 400 steps on the CPU, whether the compiled call matches plain Julia forward and ForwardDiff in reverse to a relative error below `1e-8`.
