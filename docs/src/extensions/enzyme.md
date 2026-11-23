# [Enzyme extension](@id extension-enzyme)

Loading Enzyme registers the [rule](@ref adjoint-routing) of every operator as an Enzyme reverse-mode rule.
Use reverse mode with runtime activity:

```jldoctest
using ComposableRecurrences, Enzyme
using DifferentiationInterface: AutoEnzyme, gradient
backend = AutoEnzyme(; mode = Enzyme.set_runtime_activity(Enzyme.Reverse))
r = Recurrence([0.5, 0.3])
loss(R) = sum(r(R; history = [1.0, 1.0]))
round.(gradient(loss, backend, fill(1.1, 4)); digits = 3)

# output

4-element Vector{Float64}:
 2.17
 1.615
 1.04
 0.613
```

## Known issues

| Symptom | Workaround | Issue |
|---|---|---|
| Julia 1.11: zero gradient for a scalar field, such as `b` in `Transform(+, b)`, of an operator built in code Julia cannot infer; warns once | Use Julia 1.12 or later, or build operators in type-stable code | |
| `TypeError: in new, expected Tuple{...}` when a modifier's type depends on a run-time branch | Choose the loss before differentiating: `flag ? (θ -> f(Depletion(N), θ)) : (θ -> f(Depletion(N, Floor()), θ))` | [#314](https://github.com/EpiAware/ComposableRecurrences.jl/issues/314) |
| `EnzymeRuntimeActivityError` when an operator holds a constant array defined outside the loss | Use runtime activity, as above, or build the array inside the loss | |
| `IllegalTypeAnalysisException` from `hcat`, `vcat` or `[a b]` on a view | Use `cat(a, b; dims = 2)`, or `collect` the view | [#672](https://github.com/EpiAware/ComposableRecurrences.jl/issues/672), [#299](https://github.com/EpiAware/ComposableRecurrences.jl/issues/299) |
| Julia 1.12 and later: forward mode crashes in the garbage collector after repeated gradients | Use reverse mode, or `Enzyme.gradient(Enzyme.Forward, f, θ; chunk = Val(1))` | [#321](https://github.com/EpiAware/ComposableRecurrences.jl/issues/321) |

Enzyme's place among the other backends is in [Backends](@ref adjoint-backends).
