# [Writing new types](@id extending)

A new modifier, coupling or depletion form is a type with a [`forward`](@ref ComposableRecurrences.forward) method for its role.
Add a [`pullback!`](@ref ComposableRecurrences.pullback!) method for a hand-written gradient.
This page gives the contract for each role, then one worked example for each kind of type.

```@example extending
using ComposableRecurrences
const CR = ComposableRecurrences
```

## [Roles](@id extending-roles)

The second argument of `forward` and the third of `pullback!` is a singleton that selects the role by dispatch.

| Type | `forward` | `pullback!` | `grads` | `pullback!` returns |
|---|---|---|---|---|
| pointwise modifier step | `forward(m, Step(), v, s, t, k)` returns `(v′, s′)` | `pullback!(grads, m, Step(), v, s, t, k)` | `piece`; `v` and `s` hold the scalar cotangents of `v′` and `s′` | `(v̄, s̄)` |
| blockwise modifier group step | `forward(m, Step(), v::Tuple, s::Tuple, t, g)` returns tuples `(v′, s′)` | `pullback!(grads, m, Step(), v, s, t, g)` | `piece`; `v` and `s` are tuples holding the cotangents of `v′` and `s′` | tuples `(v̄, s̄)` |
| vector modifier step | `forward(m, Step(), v, s, t)` updates `v` and `s` in place | `pullback!(grads, m, Step(), v, s, t)` | `piece`; `v` and `s` are vectors holding the cotangents of `v′` and `s′`; overwrite them with those of `v` and `s` | `nothing` |
| initial state | `forward(m, Init(), s, history)` writes `s` | `pullback!(grads, m, Init(), s, history)` | `piece`; `s` holds the cotangent of `s`; add into `history`, which may be `nothing` | `nothing` |
| coupling | `forward(C, Pressure(), q, p, t)` writes `q` | `pullback!(grads, C, Pressure(), q, p, t)`, with `q === nothing` | `piece`; `q` holds the cotangent of `q`; add into `p` | `nothing` |
| depletion form | `forward(form, Step(), v, s, N, α)` returns `(y, s′)` | `pullback!(grads, form, Step(), v, s, N, α)` | `piece`; `v` and `s` hold the cotangents of `y` and `s′` | `(v̄, s̄, N̄, ᾱ)` |

The arguments mean the same in every role:

- `t` is the absolute time, counted from 1 as `start` and `stop` are, and `k` is the stratum.
- `s` is the modifier's state after the previous step, with [`nstate`](@ref ComposableRecurrences.nstate) entries.
- `history` is the call's `history` as given: a vector for one series, else strata × time.
  Without an `Init` method the state starts at zero, and no `Init` pullback is needed.
- In `pullback!`, `v`, `s`, `p` and `history` are the values `forward` was given, so the values before the step.
  Read them, but do not write to them.
- A pointwise modifier sets [`ispointwise`](@ref ComposableRecurrences.ispointwise) and implements the scalar step.
  A blockwise modifier sets [`blocks`](@ref ComposableRecurrences.blocks) and implements the step for one group, `g`.
  Any other modifier implements the vector step and may read every stratum.

`forward` must be generic in the element type of its arguments.
A dual number, a `Float32` or a tracked value can arrive in `v`, `s` or a field.
So do not annotate `Float64` or build `0.0`; use `zero(v)` and `oftype`.
Under [`Threaded`](@ref ComposableRecurrences.Threaded) the steps of different strata can run at once.
So a step writes only its own stratum's slots, and never to the type's fields.

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
So read an entry with [`cotangent`](@ref ComposableRecurrences.cotangent).
Add to it with [`add_cotangent!`](@ref ComposableRecurrences.add_cotangent!), which skips `nothing`.
Read a modifier parameter with [`param`](@ref ComposableRecurrences.param).
Add its cotangent with [`add_param!`](@ref ComposableRecurrences.add_param!).
These accept every parameter form, so the type works with one value, `PerStratum`, `TimeVarying` or [`Derived`](@ref).

## [Gradient routes](@id extending-routes)

[Rules and plain AD](@ref adjoint-routing) says which route a type gives its operator.

Give each float field a type parameter, as `struct Smooth{A}; a::A; end`, since an abstractly typed field takes plain AD.

The local step rebuilds the type with dual numbers through `ConstructionBase.constructorof`, from its fields in order.
Its type parameters must let a float field hold a dual number, and the constructor must keep its arguments as given.
So these send the operator to plain AD: a closure that captures a float, a keyword-only constructor, a float field typed `Float64`, or a constructor that changes its arguments.
Integer fields, index ranges and integer arrays are structure, not parameters.
Add a `ConstructionBase.constructorof` method for a type whose positional constructor differs.

## [A pointwise modifier with state](@id extending-pointwise)

This modifier smooths each series exponentially, with state ``s_t = a s_{t-1} + (1 - a) v_t`` passed on as the value.
Its state starts at the last value of the history.

```@example extending
struct Smooth{A}
    a::A
end
CR.ispointwise(::Smooth) = true
function CR.forward(m::Smooth, ::CR.Init, s, history)
    H = reshape(history, length(s), :)
    s .= view(H, :, size(H, 2))
    return nothing
end
function CR.forward(m::Smooth, ::CR.Step, v, s, t, k)
    s′ = m.a * s + (1 - m.a) * v
    return s′, s′
end

Recurrence([0.5, 0.5]; modifiers = (Smooth(0.5),))(2.0; history = [1.0, 2.0], stop = 5)
```

## [Its pullback](@id extending-pullback)

The new value and state are both ``s'``, so their cotangents add to ``\bar g = \bar v' + \bar s'``.
Then ``\bar v = (1 - a) \bar g``, ``\bar s = a \bar g`` and ``\bar a \mathrel{+}= (s - v) \bar g``.
The `Init` pullback adds the state's cotangent into the last column of the history.

```@example extending
function CR.pullback!(grads, m::Smooth, ::CR.Step, v, s, t, k)
    ḡ = grads.v + grads.s
    CR.add_cotangent!(CR.cotangent(grads.piece, :a), (s - v) * ḡ)
    return (1 - m.a) * ḡ, m.a * ḡ
end
function CR.pullback!(grads, m::Smooth, ::CR.Init, s, history)
    grads.history === nothing && return nothing
    H̄ = reshape(grads.history, length(s), :)
    view(H̄, :, size(H̄, 2)) .+= grads.s
    return nothing
end

grads = (; piece = (; a = Ref(0.0)), v = 1.0, s = 0.5)
CR.pullback!(grads, Smooth(0.5), CR.Step(), 2.0, 1.0, 1, 1), grads.piece.a[]
```

## [A per-stratum parameter](@id extending-param)

This modifier adds `b` to each value.
It reads `b` with `param` and adds its cotangent with `add_param!`, so `b` may be one value or `PerStratum`.
For a `PerStratum` `b` the mirror entry is `(; x)`, and the cotangent lands in `x[k]`.

```@example extending
struct Shift{B}
    b::B
end
CR.ispointwise(::Shift) = true
CR.forward(m::Shift, ::CR.Step, v, s, t, k) = (v + CR.param(m.b, k, t), s)
function CR.pullback!(grads, m::Shift, ::CR.Step, v, s, t, k)
    CR.add_param!(CR.cotangent(grads.piece, :b), m.b, grads.v, k, t)
    return grads.v, grads.s
end

m = Shift(PerStratum([0.1, 0.2]))
grads = (; piece = (; b = (; x = zeros(2))), v = 1.5, s = 0.0)
CR.pullback!(grads, m, CR.Step(), 2.0, 0.0, 1, 2), grads.piece.b.x
```

## [A coupling](@id extending-coupling)

A coupling writes the pressure `q` on each stratum from each stratum's kernel-weighted past values `p`.
This one sends a share of every stratum's pressure to the first.
Its pullback reads `grads.q`, adds into `grads.p` and adds the cotangent of `share`.

```@example extending
struct ToFirst{A}
    share::A
end
function CR.forward(C::ToFirst, ::CR.Pressure, q, p, t)
    q .= (1 - C.share) .* p
    q[1] += C.share * sum(p)
    return nothing
end
function CR.pullback!(grads, C::ToFirst, ::CR.Pressure, q, p, t)
    q̄, p̄ = grads.q, grads.p
    for i in eachindex(p, p̄)
        p̄[i] += (1 - C.share) * q̄[i] + C.share * q̄[1]
    end
    ā = q̄[1] * sum(p) - sum(i -> q̄[i] * p[i], eachindex(p))
    CR.add_cotangent!(CR.cotangent(grads.piece, :share), ā)
    return nothing
end

Recurrence([0.5, 0.5]; coupling = ToFirst(0.2))(1.0; history = ones(2, 2), stop = 4)
```

## [A vector step](@id extending-vector)

A modifier that reads other strata implements the vector step.
This one pulls each value towards the mean over strata by a share `a`.
Its pullback overwrites `grads.v` with the cotangent of the incoming values.
The state passes through unchanged, so `grads.s` already holds its cotangent.

```@example extending
struct Pool{A}
    a::A
end
function CR.forward(m::Pool, ::CR.Step, v, s, t)
    μ = sum(v) / length(v)
    for k in eachindex(v)
        v[k] = (1 - m.a) * v[k] + m.a * μ
    end
    return nothing
end
function CR.pullback!(grads, m::Pool, ::CR.Step, v, s, t)
    v̄ = grads.v
    μ, μ̄ = sum(v) / length(v), sum(v̄) / length(v̄)
    ā = sum(k -> v̄[k] * (μ - v[k]), eachindex(v))
    for k in eachindex(v̄)
        v̄[k] = (1 - m.a) * v̄[k] + m.a * μ̄
    end
    CR.add_cotangent!(CR.cotangent(grads.piece, :a), ā)
    return nothing
end

Recurrence([0.5, 0.5]; modifiers = (Pool(0.5),))(1.0; history = [1.0 2.0; 3.0 1.0], stop = 3)
```

## [A blockwise step](@id extending-blockwise)

A modifier whose step acts on fixed groups of series, each with a fixed number of values and state entries, is blockwise.
[`blocks`](@ref ComposableRecurrences.blocks) gives the values and state entries of each group, and the step takes and returns them as tuples.
This one keeps a running total and a step count per series, and adds their mean to the value.

```@example extending
struct AddMean end
CR.blocks(::AddMean) = Val((1, 2))
function CR.forward(::AddMean, ::CR.Step, v::Tuple, s::Tuple, t, k)
    total, n = s[1] + v[1], s[2] + 1
    return (v[1] + total / n,), (total, n)
end

Recurrence([0.5, 0.5]; modifiers = (AddMean(),))(fill(1.0, 2, 4); history = [1.0 2.0; 3.0 1.0])
```

## [A depletion form](@id extending-form)

A depletion form draws value `v` from pool `s` with population `N` and exponent `α`.
It is passed to [`Depletion`](@ref ComposableRecurrences.Depletion).
This one takes what is asked, up to the pool.
Its pullback returns the cotangents of `v`, `s`, `N` and `α`.
`Depletion` adds those of `N` and `α` into its own mirror.
Its `grads.piece` is the mirror of the form's own fields.

```@example extending
struct Capped end
CR.forward(::Capped, ::CR.Step, v, s, N, α) = (y = min(v, s); (y, s - y))
function CR.pullback!(grads, ::Capped, ::CR.Step, v, s, N, α)
    ȳ, s̄′ = grads.v, grads.s
    z = zero(ȳ)
    v <= s && return ȳ - s̄′, s̄′, z, z
    return z, ȳ, z, z
end

d = CR.Depletion(10.0, Capped())
Recurrence([0.5, 0.5]; modifiers = (d,))(2.0; history = [1.0, 2.0], stop = 8)
```

## [Checking a new type](@id extending-checks)

First test `forward` against [`PieceInterface`](@ref ComposableRecurrences.PieceInterface), with one `Arguments(; piece, role, args)` per role the type has.
Here `args` are the arguments after the role:

- `(s, history)` for `Init()`;
- `(v, s, t)`, with vectors, for a modifier's `Step()`;
- `(q, p, t)` for `Pressure()`;
- scalars `(v, s, N, α)` for a depletion form.
The optional checks of `PieceInterface{(:pointwise, :nstate)}` test a pointwise step and the state length.

```@example extending
using Interfaces: Interfaces, Arguments

Interfaces.test(
    CR.PieceInterface{(:pointwise, :nstate)}, Smooth,
    [
        Arguments(; piece = Smooth(0.3), role = CR.Init(), args = (zeros(2), ones(2, 3))),
        Arguments(; piece = Smooth(0.3), role = CR.Step(), args = ([1.0, 2.0], [0.5, 0.5], 1)),
    ]
)
```

Then check each `pullback!` against ForwardDiff of `forward` on the same inputs.

```@example extending
using ForwardDiff

smooth_step(x) = collect(CR.forward(Smooth(x[1]), CR.Step(), x[2], x[3], 1, 1))
J = ForwardDiff.jacobian(smooth_step, [0.5, 2.0, 1.0])
grads = (; piece = (; a = Ref(0.0)), v = 1.0, s = 0.5)
v̄, s̄ = CR.pullback!(grads, Smooth(0.5), CR.Step(), 2.0, 1.0, 1, 1)
J' * [grads.v, grads.s] ≈ [grads.piece.a[], v̄, s̄]
```

Last, compare a reverse-mode gradient through the operator with its [`NoAdjoint`](@ref ComposableRecurrences.NoAdjoint) twin.
Use Mooncake or Enzyme, since [forward mode runs the same code on both](@ref adjoint-backends), and a loss that changes with every parameter.

```julia
using DifferentiationInterface, Mooncake

r(a) = Recurrence([0.5, 0.5]; modifiers = (Smooth(a[1]),))
loss(op) = a -> sum(abs2, op(a)(fill(1.2, 30); history = [1.0, 2.0]))
backend = AutoMooncake(; config = nothing)
gradient(loss(r), backend, [0.3]) ≈
    gradient(loss(CR.NoAdjoint ∘ r), backend, [0.3])
```

[`test_adjoint`](@ref ComposableRecurrences.test_adjoint) runs a backend's own rule tester on an operator.
[Testing and benchmarking](@ref testing) covers timing.

## [Performance](@id extending-performance)

- Keep `forward` and `pullback!` free of allocations: return scalars from a pointwise step and loop over a vector step in place.
- Use concrete field types through type parameters, so every call is type stable.
- Loop with `eachindex` over the arrays you index, and add `@inbounds` only to such loops.
- [Which rules are kept](@ref rule-policy) gives the cost of a missing `pullback!`.
- A vector step makes the strata wait for each other at every step, so [`Threaded`](@ref ComposableRecurrences.Threaded) gains less from it.
