# [Adding a modifier](@id extending)

To add a modifier, define a type and add a `forward` method for it.
The second argument is a singleton that selects the job by dispatch: `Step()` for one step, `Init()` for the starting state, `Pressure()` for a coupling's mixing and `Run()` for a whole call.
Depletion forms are types too, so pass `Hazard()` or `Floor()`, or define your own.
Add a `pullback!` method for a hand-written gradient.

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

## A custom depletion form

A depletion form draws value `v` from pool `s`.
This one takes what is asked, up to the pool.

```@example extending
struct Linear end
CR.forward(::Linear, ::CR.Step, v, s, N, α) = (y = min(v, s); (y, s - y))

d = CR.Depletion(10.0, Linear())
Recurrence([0.5, 0.5]; modifiers = (d,))(2.0; history = [1.0, 2.0], stop = 8)
```

## Checking an extension

`PieceInterface` declares the roles with Interfaces.jl.
Test a new modifier or depletion form against it with one `Arguments(; piece, role, args)` object per role it supports.
The test runs its `forward` and checks it keeps to the role's conventions.

```@example extending
using Interfaces: Interfaces, Arguments

Interfaces.test(
    CR.PieceInterface, Scale,
    [Arguments(; piece = Scale(0.9), role = CR.Step(), args = ([1.0, 2.0], [0.0, 0.0], 1))]
)
```
