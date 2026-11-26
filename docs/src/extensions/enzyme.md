# [Enzyme gradients](@id extension-enzyme)

Loading Enzyme registers the [rule](@ref adjoint-routing) of every operator as an Enzyme reverse-mode rule, so Enzyme is one of the [backends](@ref adjoint-backends).
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
| `IllegalTypeAnalysisException` from `hcat`, `vcat` or `[a b]` on a view, as when a run's history is put in front of its output | Pass `include_history = true` to join the history in front, or use `cat(a, b; dims = 2)`, or `collect` the view | [#672](https://github.com/EpiAware/ComposableRecurrences.jl/issues/672), [#299](https://github.com/EpiAware/ComposableRecurrences.jl/issues/299) |
| Julia 1.11 with several threads: reverse mode without runtime activity crashes in the garbage collector when it differentiates a `NoAdjoint` operator | Use `set_runtime_activity(Enzyme.Reverse)`, or drop `NoAdjoint` so the operator takes its rule | [#872](https://github.com/EpiAware/ComposableRecurrences.jl/issues/872) |
| Julia 1.12 and later: forward mode crashes in the garbage collector after repeated gradients | Use reverse mode, or `Enzyme.gradient(Enzyme.Forward, f, θ; chunk = Val(1))` | [#321](https://github.com/EpiAware/ComposableRecurrences.jl/issues/321) |

Calling `Enzyme.API.strictAliasing!(false)` at the start of the session, before the first Enzyme gradient, also avoids the `IllegalTypeAnalysisException`.
It changes Enzyme's analysis for every later gradient, and turning it off after the error, in the same session, can crash on Julia 1.12 and 1.13.

Enzyme's place among the other backends is in [Backends](@ref adjoint-backends).

All extensions are listed in the [overview](@ref extensions-overview).
