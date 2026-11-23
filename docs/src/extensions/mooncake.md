# [ADTypes + Mooncake + Random extension](@id extension-mooncake)

Loading Mooncake registers the [rule](@ref adjoint-routing) of every operator as a Mooncake reverse-mode rule.
It also adds [`test_adjoint`](@ref ComposableRecurrences.test_adjoint) for `AutoMooncake`, which runs `Mooncake.TestUtils.test_rule` on an operator's rule.

```jldoctest
using ComposableRecurrences, DifferentiationInterface, Mooncake
backend = AutoMooncake(; config = nothing)
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

None known.
Mooncake's place among the other backends is in [Backends](@ref adjoint-backends).

All extensions are listed in the [overview](@ref extensions-overview).
