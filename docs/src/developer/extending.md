# [Writing a piece](@id writing-a-piece)

A piece is a modifier, a coupling or a depletion form.
You add one by writing a struct and giving it `forward` for its role.
Variants such as a depletion form are struct values too, so there is no registry and no symbol to add.

| Piece | Role | `forward` |
|---|---|---|
| operator call | `Run()` | `forward(op, Run(), args...; kwargs...)` returns `(y, cache)` |
| modifier, vector step | `Step()` | `forward(m, Step(), v, s, t)` updates `v` and `s` in place |
| modifier, pointwise step | `Step()` | `forward(m, Step(), v, s, t, k)` returns `(v′, s′)` |
| modifier, initial state | `Init()` | `forward(m, Init(), s, history)` writes `s` |
| depletion form | `Step()` | `forward(form, Step(), v, s, N, α)` returns `(y, s′)` |
| coupling | `Pressure()` | `forward(C, Pressure(), q, p, t)` writes `q` |

```@example extending
using ComposableRecurrences
const CR = ComposableRecurrences
```

## A custom modifier

A pointwise modifier sets `ispointwise` and implements the scalar step.
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

## A custom coupling

A coupling writes the mixed convolutions `q` from the per-stratum convolutions `p`.
This one sends a fixed share of every stratum's convolution to the first stratum.

```@example extending
struct ToFirst
    share::Float64
end
function CR.forward(C::ToFirst, ::CR.Pressure, q, p, t)
    q .= (1 - C.share) .* p
    q[1] += C.share * sum(p)
    return nothing
end

r = Recurrence([0.5, 0.5]; coupling = ToFirst(0.2))
r(1.0; history = [1.0 1.0; 1.0 1.0], stop = 4)
```

## Checking an extension

`PieceInterface` declares the roles with Interfaces.jl.
Test a new piece against it with one `Arguments(; piece, role, args)` object per role it supports.
The test runs the piece's `forward` and checks it keeps to the role's conventions.

```@example extending
using Interfaces: Interfaces, Arguments

Interfaces.test(
    CR.PieceInterface, Scale,
    [Arguments(; piece = Scale(0.9), role = CR.Step(), args = ([1.0, 2.0], [0.0, 0.0], 1))]
)
```
