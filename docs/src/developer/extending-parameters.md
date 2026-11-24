# [Parameters and gradients](@id extending-parameters)

A modifier parameter can take any form and still get its gradient, building on [Writing new types](@ref extending).

```@example extending-parameters
using ComposableRecurrences
const CR = ComposableRecurrences
```

## [The gradient mirror](@id extending-mirror)

`grads.piece` mirrors the type's fields, one entry per field, by field type:

| Field | Mirror entry |
|---|---|
| float scalar | `Ref`, add with `x̄[] += g` |
| float array | an array of the same shape |
| [`PerStratum`](@ref), [`TimeVarying`](@ref) or another struct | a NamedTuple of its own fields' mirrors, such as `(; x = zeros(S))` |
| integer, range, `nothing`, function | `nothing` |
| struct with no fields | `(;)` |

The whole mirror, or any entry, is `nothing` when the backend holds it constant.
Read an entry with [`cotangent`](@ref ComposableRecurrences.cotangent), which returns `nothing` for such a field, and add to it with [`add_cotangent!`](@ref ComposableRecurrences.add_cotangent!), which skips `nothing`.
For a modifier parameter, use `param` and `add_param!` instead, which accept every parameter form, including [`Derived`](@ref ComposableRecurrences.Derived) and [`Recent`](@ref ComposableRecurrences.Recent).
Call `add_param!` for every parameter, even with a `nothing` mirror, as a `Recent` parameter still sends its cotangent to the outputs it read.

## [A per-stratum parameter](@id extending-param)

This modifier adds ``b_k`` to the value of stratum ``k``:

```math
v'_{t,k} = v_{t,k} + b_k.
```

It reads `b` with `param` and adds its cotangent with `add_param!`, so `b` may be one value or `PerStratum`.
For a `PerStratum` `b` the mirror entry is `(; x)`, and the cotangent of entry `k` lands in `x[k]`.

```@example extending-parameters
struct Shift{B}
    b::B
end
CR.blocks(::Shift) = (1, 1)
function CR.forward!(m::Shift, ::CR.Step, v, s, t)
    for k in eachindex(v)
        v[k] += CR.param(m.b, k, t)
    end
    return nothing
end
function CR.pullback!(grads, m::Shift, ::CR.Step, v, s, t)
    b̄ = CR.cotangent(grads.piece, :b)
    for k in eachindex(v)
        CR.add_param!(b̄, m.b, grads.v[k], k, t)
    end
    return nothing
end

m = Shift(PerStratum([0.1, 0.2]))
grads = (; piece = (; b = (; x = zeros(2))), v = [1.5, 0.5], s = [0.0, 0.0])
CR.pullback!(grads, m, CR.Step(), [2.0, 1.0], [0.0, 0.0], 1)
grads.piece.b.x
```

A pointwise modifier reads each parameter at its own stratum, `param(m.b, k, t)`, and its `Init` at time 1, `param(m.b, k, 1)`.
A call checks the `PerStratum` parameters of a pointwise or blockwise modifier against the number of strata.

## [Local rules for maps](@id extending-local-rules)

The map of a [`Derived`](@ref ComposableRecurrences.Derived) parameter or a [`Transform`](@ref ComposableRecurrences.Transform) is differentiated one entry at a time.
Without a rule of its own, each entry takes a local forward-mode derivative, which evaluates the map on dual numbers.
A map whose derivative has a closed form can say so with a [`pullback!`](@ref ComposableRecurrences.pullback!) method in the [`Local`](@ref ComposableRecurrences.Local) role.
It receives the map's value at the entry, as the forward pass computed it, before the map's arguments, and returns the partial derivatives, one per argument.

Write the map as a callable struct, or a named function, so the method is for a type you own.
A reporting-delay hazard on the logit scale, ``h = \operatorname{logistic}(a + \gamma)``, has ``\partial h / \partial a = \partial h / \partial \gamma = h (1 - h)``:

```@example extending-parameters
struct LogisticSum end
(::LogisticSum)(a, γ) = inv(1 + exp(-(a + γ)))
function CR.pullback!(grads, ::LogisticSum, ::CR.Local, y, a, γ)
    d = y * (1 - y)
    return d, d
end

hazard = CR.Derived(LogisticSum(), [-2.0, -1.5, -1.0], TimeVarying(zeros(6)))
delay = TimeVarying(CR.Increments(1 - CR.Survival(hazard)), CR.Primary())
round.(CR.kernel_weights(delay, 2); digits = 3)
```

The operators find the method from the types, so a map without one costs nothing to check.
A `Transform` map `f(v, θ)` returns `(∂f/∂v, ∂f/∂θ)`, the second shaped as `θ`.
A map with float fields of its own keeps taking plain AD, as the rule gives no gradient for those fields; pass them in `θ`.
