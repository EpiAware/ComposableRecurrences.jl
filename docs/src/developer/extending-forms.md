# [Depletion forms](@id extending-form)

A new depletion form sets how a pool gives up what a step asks for, building on [Writing new types](@ref extending).
[Depletion forms](@ref explanation-depletion-forms) lists the built-in forms.

```@example extending-forms
using ComposableRecurrences
const CR = ComposableRecurrences
```

## [A form with a pullback](@id extending-form-pullback)

A depletion form draws value `v` from pool `s` with population `N`.
Its parameters, such as the exponent of [`Hazard`](@ref ComposableRecurrences.Hazard), are its fields.
It is pointwise: it draws each entry of `v` from the same entry of `s`.
Passed to `Depletion` as a draw, it takes from the first pool.

| Type | `forward!` | `pullback!` | `grads` |
|---|---|---|---|
| depletion form | `forward!(form, Step(), v, s, N)` writes the drawn values into `v` and the pools after the draw into `s` | `pullback!(grads, form, Step(), v, s, N)` | the mirror; `v` and `s` hold the cotangents of `v′` and `s′`; overwrite them with those of `v` and `s`; add that of `N` into `N`, indexed as `v` is |

This one takes what is asked, up to the pool:

```math
v' = \min(v, s), \qquad s' = s - v',
```

where ``v'`` is the value drawn and ``s'`` the pool after the step.
Its pullback overwrites `grads.v` and `grads.s` with the cotangents of `v` and `s`.
It reads no `N`, so it adds nothing into `grads.N`; `Depletion` adds what a form puts there into its own mirror.
`grads.piece` is the mirror of the form's own fields and takes their cotangents.

```@example extending-forms
struct Capped end
function CR.forward!(::Capped, ::CR.Step, v, s, N)
    for k in eachindex(v, s)
        y = min(v[k], s[k])
        v[k], s[k] = y, s[k] - y
    end
    return nothing
end
function CR.pullback!(grads, ::Capped, ::CR.Step, v, s, N)
    v̄, s̄ = grads.v, grads.s
    for k in eachindex(v, s)
        if v[k] <= s[k]
            v̄[k] -= s̄[k]
        else
            v̄[k], s̄[k] = zero(v̄[k]), v̄[k]
        end
    end
    return nothing
end

d = CR.Depletion(10.0, Capped())
Recurrence([0.5, 0.5]; modifiers = (d,))(2.0; history = [1.0, 2.0], stop = 8)
```

`PieceInterface` tells a form's step from a modifier's by a float `N` in place of the time.
