# [Steps across strata](@id extending-steps)

A modifier whose step reads other strata runs on whole vectors or on groups, building on [Writing new types](@ref extending).

```@example extending-steps
using ComposableRecurrences
const CR = ComposableRecurrences
```

The trait [`blocks`](@ref ComposableRecurrences.blocks) sets the scope of a step: `(1, 1)` for a [pointwise](@ref extending-pointwise-rules) step, `(nv, ns)` for groups of `nv` values and `ns` state entries, and `nothing`, the default, for whole vectors.
[`nstate`](@ref ComposableRecurrences.nstate) is read from `blocks`.
A whole-step modifier, one with `blocks(m) === nothing`, declares how many rows its `PerStratum` parameters have with [`param_rows(m, S)`](@ref ComposableRecurrences.param_rows), so each call checks them.

## [A vector step](@id extending-vector)

This modifier pulls each value towards the mean over strata by a share ``a``:

```math
v'_k = (1 - a) \, v_k + a \, \mu, \qquad \mu = \frac{1}{S} \sum_{j=1}^{S} v_j,
```

where ``S`` is the number of strata.
Its pullback overwrites `grads.v` with the cotangent of the incoming values.
The state passes through unchanged, so `grads.s` already holds its cotangent.

```@example extending-steps
struct ToMean{A}
    a::A
end
function CR.forward!(m::ToMean, ::CR.Step, v, s, t)
    μ = sum(v) / length(v)
    for k in eachindex(v)
        v[k] = (1 - m.a) * v[k] + m.a * μ
    end
    return nothing
end
function CR.pullback!(grads, m::ToMean, ::CR.Step, v, s, t)
    v̄ = grads.v
    μ, μ̄ = sum(v) / length(v), sum(v̄) / length(v̄)
    ā = sum(k -> v̄[k] * (μ - v[k]), eachindex(v))
    for k in eachindex(v̄)
        v̄[k] = (1 - m.a) * v̄[k] + m.a * μ̄
    end
    CR.add_cotangent!(CR.cotangent(grads.piece, :a), ā)
    return nothing
end

r = Recurrence([0.5, 0.5]; modifiers = (ToMean(0.5),))
r(1.0; history = [1.0 2.0; 3.0 1.0], stop = 3)
```

A vector step makes the strata wait for each other at every step, so [`Threaded`](@ref ComposableRecurrences.Threaded) gains less from it.

## [A blockwise step](@id extending-blockwise)

A blockwise step, `forward!(m, Step(), v::Tuple, s::Tuple, t, g)`, acts on one group `g` at a time, with its values and state entries as tuples of one-entry views, read and written as `x[]`.
Its `pullback!(grads, m, Step(), v, s, t, g)` takes `grads.v` and `grads.s` as tuples of views and overwrites them with the cotangents of `v` and `s`.

This one keeps a running total and a step count per stratum, and adds their mean to the value:

```math
a_t = a_{t-1} + v_t, \qquad n_t = n_{t-1} + 1, \qquad v'_t = v_t + \frac{a_t}{n_t},
```

where ``v_t`` is the value at step ``t`` and ``v'_t`` the value passed on.
``a_t`` is the running total and ``n_t`` the step count, the stratum's two state entries.

```@example extending-steps
struct AddMean end
CR.blocks(::AddMean) = (1, 2)
function CR.forward!(::AddMean, ::CR.Step, v::Tuple, s::Tuple, t, g)
    total, n = s[1][] + v[1][], s[2][] + 1
    v[1][] += total / n
    s[1][], s[2][] = total, n
    return nothing
end

r = Recurrence([0.5, 0.5]; modifiers = (AddMean(),))
r(fill(1.0, 2, 4); history = [1.0 2.0; 3.0 1.0])
```

Without a `pullback!`, the rule differentiates the group step locally with ForwardDiff, one group at a time.
A parameter it reads as `param(m.a, g, t)`, with `a` a `PerStratum` or `TimeVarying`, is seeded at that entry only.
A step that indexes the array instead takes plain AD ([Rules and plain AD](@ref adjoint-routing)).
The `:blocks` check of [`PieceInterface`](@ref ComposableRecurrences.PieceInterface) tests a blockwise step.
