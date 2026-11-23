# [ForwardDiff extension](@id extension-forwarddiff)

Loading ForwardDiff gives each coupling, modifier and initial state without its own [`pullback!`](@ref ComposableRecurrences.pullback!) a dual-number [local step](@ref adjoint-routing) in the reverse-mode rules.
Without it, a gradient through such a component falls back to plain AD, which is [slower](@ref adjoint-local-step).
ForwardDiff gradients themselves use plain AD:

```jldoctest
using ComposableRecurrences, ForwardDiff
r = Recurrence([0.5, 0.3])
loss(R) = sum(r(R; history = [1.0, 1.0]))
round.(ForwardDiff.gradient(loss, fill(1.1, 4)); digits = 3)

# output

4-element Vector{Float64}:
 2.17
 1.615
 1.04
 0.613
```

## Known issues

None known.
