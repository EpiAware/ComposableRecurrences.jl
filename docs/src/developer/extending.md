# [Adding a modifier](@id extending)

To add a modifier, define a type and add a `forward` method for it.
The second argument is a singleton that selects the job by dispatch: `Step()` for one step, `Init()` for the starting state, `Pressure()` for a coupling's mixing and `Run()` for a whole call.
Depletion forms are types too, so pass `Hazard()` or `Floor()`, or define your own.
Add a `pullback!` method for a hand-written gradient, and the operator's rule calls it.

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
The factor's type is a parameter, so automatic differentiation can pass a dual number in its place.

```@example extending
struct Scale{A}
    a::A
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
The rule of a `Recurrence` calls it; [Rules and plain AD](@ref adjoint-routing) says when.

```@example extending
function CR.pullback!(grads, m::Scale, ::CR.Step, v, s, t, k)
    CR.add_cotangent!(CR.cotangent(grads.piece, :a), grads.v * v)
    return m.a * grads.v, grads.s
end

grads = (; piece = (; a = Ref(0.0)), v = 1.0, s = 0.0)
CR.pullback!(grads, Scale(0.9), CR.Step(), 2.0, 0.0, 1, 1), grads.piece.a[]
```

To accept every parameter form, such as `PerStratum`, `TimeVarying` or `Derived`, read each parameter with [`param`](@ref ComposableRecurrences.param) and add its cotangent with [`add_param!`](@ref ComposableRecurrences.add_param!).

Without a `pullback!`, some modifiers and couplings are differentiated inside the rule by a local ForwardDiff step, and the rest send the operator to plain AD; [Rules and plain AD](@ref adjoint-routing) lists which.
The local step rebuilds the type with dual numbers through `ConstructionBase.constructorof`, from its fields in order.
Its type parameters must let a float field hold a dual number, and the constructor must keep its arguments as given.
So a closure that captures a float, a keyword-only constructor, a float field typed `Float64` or a constructor that changes its arguments sends the operator to plain AD.
Integer fields, index ranges and integer arrays are structure, not parameters.
Add a `ConstructionBase.constructorof` method for a type whose positional constructor differs.
A `pullback!` is kept only where it beats plain AD; see [Which rules are kept](@ref rule-policy).

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

## [Specialising for speed](@id specialising)

Every call of an operator has one form, and the work behind it is chosen by dispatch on the types of its kernel, coupling, modifiers and numbers.
A method for a narrower type replaces the general one for that type alone, so a faster path for one combination needs no new interface and no change to any call.

| To speed up | Add a method |
|---|---|
| a coupling with structure, such as low rank or banded | `forward(C::MyCoupling, Pressure(), q, p, t)`, and its `pullback!` |
| a modifier at one parameter form | `forward(m::MyModifier{<:PerStratum}, Step(), v, s, t, k)` |
| a depletion form at one number type | `forward(form::MyForm, Step(), v::Float32, s::Float32, N::Float32, α::Float32)` |
| how a loop over strata runs | an [`Executor`](@ref ComposableRecurrences.Executor) and its [`each!`](@ref ComposableRecurrences.each!) |

A rank-one coupling ``C = u w^\top`` mixes the strata in ``2S`` operations, where a dense matrix takes ``S^2``.

```@example extending
struct RankOne{V}
    u::V
    w::V
end
function CR.forward(C::RankOne, ::CR.Pressure, q, p, t)
    c = zero(eltype(q))
    for b in eachindex(p)
        c += C.w[b] * p[b]
    end
    for a in eachindex(q)
        q[a] = C.u[a] * c
    end
    return nothing
end

u, w = [0.9, 0.1, 0.4], [0.5, 0.3, 0.2]
R = fill(1.2, 3, 6)
h = ones(3, 2)
low = Recurrence([0.5, 0.5]; coupling = RankOne(u, w))(R; history = h)
dense = Recurrence([0.5, 0.5]; coupling = u * w')(R; history = h)
low ≈ dense
```

The package specialises its own code the same way.
These methods are internal and may change without notice; the list says where a contributor would add one:

- one stratum's kernel convolution, `_kdot`, by the kernel's form (shared, per stratum, time varying with either indexing, pairwise) and by the buffer's array type;
- independent strata, where the coupling is `I` or `Diagonal`, the kernel is not pairwise and every modifier is pointwise, run each block of strata over the whole series (`_independent` decides, `_series_body!` runs);
- a fixed convolution's body, `_convolve_series!`, by the buffer's number type: one vectorised `axpy` per lag for IEEE floats, one dot per output for other numbers;
- the output's copy into the public layout, `_public`, by the buffer's array type;
- the route of a call, the rule or plain AD, by [`uses_adjoint`](@ref ComposableRecurrences.uses_adjoint) and the number types.

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
