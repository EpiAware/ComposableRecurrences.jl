# [Adding a modifier](@id extending)

To add a modifier, define a type and add a `forward` method for it.
The second argument is a singleton that selects the job by dispatch: `Step()` for one step, `Init()` for the starting state, `Pressure()` for a coupling's mixing and `Run()` for a whole call.
Depletion forms are types too, so pass `Hazard()` or `Floor()`, or define your own.
Add a `pullback!` method for a hand-written gradient, and declare `uses_adjoint` for the same job so the operator's rule calls it.

| Kind | Dispatch on | Method |
|---|---|---|
| operator call | `Run()` | `forward(op, Run(), args...; kwargs...)` returns `(y, cache)` |
| modifier, vector step | `Step()` | `forward(m, Step(), v, s, t)` updates `v` and `s` in place |
| modifier, pointwise step | `Step()` | `forward(m, Step(), v, s, t, k)` returns `(v′, s′)` |
| modifier, initial state | `Init()` | `forward(m, Init(), s, history)` writes `s` |
| depletion form | `Step()` | `forward(form, Step(), v, s, N, α)` returns `(y, s′)` |

```@example extending
using ComposableRecurrences
const CR = ComposableRecurrences
```

## A custom modifier

A modifier that acts on each series separately sets `ispointwise` and implements the step for one value.
This one scales each value by a factor.

```@example extending
struct Scale
    a::Float64
end
CR.ispointwise(::Scale) = true
CR.forward(m::Scale, ::CR.Step, v, s, t, k) = (m.a * v, s)

Recurrence([0.5, 0.5]; modifiers = (Scale(0.9),))(2.0; history = ones(2), stop = 5)
```

## A modifier with more state

A modifier that keeps more than one entry per series adds an [`nstate`](@ref ComposableRecurrences.nstate) method and a vector step.
This one keeps a running total and a step count per series, and adds their mean to the value.

```@example extending
struct AddMean end
CR.nstate(::AddMean, S) = 2S
function CR.forward(::AddMean, ::CR.Step, v, s, t)
    S = length(v)
    for k in 1:S
        s[k] += v[k]
        s[S + k] += 1
        v[k] += s[k] / s[S + k]
    end
    return nothing
end

Recurrence([0.5, 0.5]; modifiers = (AddMean(),))(fill(1.0, 2, 4); history = [1.0 2.0; 3.0 1.0])
```

## A hand-written gradient

A pointwise step's `pullback!` returns the cotangents of the value and the state.
`grads.v` and `grads.s` hold the output cotangents, and `grads.piece` mirrors the fields, here a `Ref` for `a` (or `nothing`).
`uses_adjoint` tells the Mooncake and Enzyme rules of a `Recurrence` to call it.

```@example extending
function CR.pullback!(grads, m::Scale, ::CR.Step, v, s, t, k)
    CR.add_cotangent!(CR.cotangent(grads.piece, :a), grads.v * v)
    return m.a * grads.v, grads.s
end
CR.uses_adjoint(::Scale, ::CR.Step) = true

grads = (; piece = (; a = Ref(0.0)), v = 1.0, s = 0.0)
CR.pullback!(grads, Scale(0.9), CR.Step(), 2.0, 0.0, 1, 1), grads.piece.a[]
```

Without a `pullback!`, a pointwise modifier with only scalar float parameters is differentiated locally with ForwardDiff inside the rule.
The rule rebuilds the modifier with dual numbers through `ConstructionBase.constructorof`, from its fields in order.
Its type parameters must let a float field hold a dual number, and the constructor must keep its arguments as given.
Integer fields, index ranges and integer arrays are structure, not parameters.
Any other modifier without a `pullback!` makes the backend differentiate the whole operator.
This includes one holding a closure that captures a float, a keyword-only constructor, a float field typed `Float64`, or a constructor that changes its arguments.
Add a `ConstructionBase.constructorof` method for a type whose positional constructor differs.

## A custom depletion form

A depletion form draws value `v` from pool `s`.
This one takes what is asked, up to the pool.

```@example extending
struct Linear end
CR.forward(::Linear, ::CR.Step, v, s, N, α) = (y = min(v, s); (y, s - y))

d = CR.Depletion(10.0, Linear())
Recurrence([0.5, 0.5]; modifiers = (d,))(2.0; history = [1.0, 2.0], stop = 8)
```

A form without a `pullback!` is differentiated locally with ForwardDiff inside the rule, in the value, the pool, the population, the exponent and its own float scalars.
The same conditions on its constructor apply as for a pointwise modifier.

## Checking an extension

`PieceInterface` declares the roles with Interfaces.jl.
Test a new modifier or depletion form against it with one `Arguments(; piece, role, args)` object per role it supports.
The test runs its `forward` and checks it keeps to the role's conventions.
`CR.PieceInterface{(:nstate,)}` also checks the state length against [`nstate`](@ref ComposableRecurrences.nstate).

```@example extending
using Interfaces: Interfaces, Arguments

Interfaces.test(
    CR.PieceInterface, Scale,
    [Arguments(; piece = Scale(0.9), role = CR.Step(), args = ([1.0, 2.0], [0.0, 0.0], 1))]
)
```
