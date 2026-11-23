# [Writing new types](@id extending)

A new modifier, coupling or depletion form is a type with a [`forward!`](@ref ComposableRecurrences.forward!) method for each of its roles.
A [`pullback!`](@ref ComposableRecurrences.pullback!) method is optional and gives it a hand-written gradient.
One modifier built end to end shows each step: the type, its use in a model, its gradient and its checks.
The [pages after this one](@ref extending-next) cover the other cases.

```@example extending
using ComposableRecurrences
const CR = ComposableRecurrences
```

## [A first modifier](@id extending-pointwise)

This modifier smooths each stratum exponentially:

```math
s_t = a \, s_{t-1} + (1 - a) \, v_t, \qquad v'_t = s_t,
```

where ``v_t`` is the value it receives, ``v'_t`` the value it passes on and ``s_t`` its state.

```@example extending
struct Smooth{A}
    a::A
end
CR.blocks(::Smooth) = (1, 1)
function CR.forward!(m::Smooth, ::CR.Init, s, history)
    H = reshape(history, length(s), :)
    s .= view(H, :, size(H, 2))
    return nothing
end
function CR.forward!(m::Smooth, ::CR.Step, v, s, t)
    for k in eachindex(v, s)
        s[k] = m.a * s[k] + (1 - m.a) * v[k]
        v[k] = s[k]
    end
    return nothing
end
nothing # hide
```

The second argument of `forward!` is the role, a type with no fields that selects the method by dispatch.
The role [`Step()`](@ref ComposableRecurrences.Step) computes one step from the values `v`, one per stratum, the state `s` and the time `t`.
The role [`Init()`](@ref ComposableRecurrences.Init) sets the starting state from the call's history, here its last value.
Both write in place and return `nothing`.

The modifier acts on each stratum alone, so it is pointwise.
It says so with `blocks(::Smooth) = (1, 1)`: one value and one state entry per stratum.
The field `a` has a type parameter so that a dual number can take its place.
[Rules for every type](@ref extending-rules) lists what else a `forward!` must respect.

## [In a model](@id extending-model)

The modifier goes in the modifier tuple beside the built-in ones.
Placed before [`Depletion`](@ref ComposableRecurrences.Depletion), it smooths the infections drawn from the pool.
With ``f`` the smoothing and ``h`` the depletion draw, each step gives

```math
y_t = h\Big(f\big(\gamma_t \sum_{l} k_l \, y_{t-l},\ s_{t-1}\big)\Big),
```

where ``k_l`` is the kernel, ``\gamma_t`` the gain and ``y_t`` the output.
More smoothing delays the peak.

```@example extending
seed = [1.0, 2.0, 3.0]
N = 10_000.0
pool = CR.Depletion(N; pools = (S = N - sum(seed),))
model(a) = Recurrence(
    [0.1, 0.3, 0.3, 0.2, 0.1]; modifiers = (Smooth(a), pool)
)
[argmax(model(a)(fill(1.8, 80); history = seed)) for a in (0.0, 0.5, 0.8)]
```

The model is differentiable already.
Without a `pullback!`, the operator's [rule](@ref adjoint-routing) differentiates the modifier's step locally with dual numbers.

```@example extending
using ForwardDiff

loss(a) = sum(model(a)(fill(1.8, 80); history = seed))
ForwardDiff.derivative(loss, 0.5)
```

## [Its pullback](@id extending-pullback)

A `pullback!` gives the derivative in closed form instead.
The new value and state are both ``s'``, so their cotangents add:

```math
\bar g = \bar v' + \bar s', \qquad
\bar v = (1 - a) \, \bar g, \qquad
\bar s = a \, \bar g, \qquad
\bar a \mathrel{+}= (s - v) \, \bar g,
```

where a bar marks a cotangent, ``\bar g`` is the summed cotangent and ``s`` is the state before the step.

A `pullback!` takes the named tuple `grads` first, then the same arguments as `forward!`.
Its entries `grads.v` and `grads.s` hold the cotangents of the new value and state, and the method overwrites them with those of the old.
The entry `grads.piece` holds the cotangents of the type's own fields.
The function [`cotangent`](@ref ComposableRecurrences.cotangent) reads the entry of the field `a`, and [`add_cotangent!`](@ref ComposableRecurrences.add_cotangent!) adds to it; both skip a field the backend holds constant.
The `Init` pullback adds the state's cotangent into the last column of the history.

```@example extending
function CR.pullback!(grads, m::Smooth, ::CR.Step, v, s, t)
    v̄, s̄ = grads.v, grads.s
    for k in eachindex(v, s)
        ḡ = v̄[k] + s̄[k]
        ā = (s[k] - v[k]) * ḡ
        CR.add_cotangent!(CR.cotangent(grads.piece, :a), ā)
        v̄[k], s̄[k] = (1 - m.a) * ḡ, m.a * ḡ
    end
    return nothing
end
function CR.pullback!(grads, m::Smooth, ::CR.Init, s, history)
    grads.history === nothing && return nothing
    H̄ = reshape(grads.history, length(s), :)
    view(H̄, :, size(H̄, 2)) .+= grads.s
    return nothing
end

grads = (; piece = (; a = Ref(0.0)), v = [1.0], s = [0.5])
CR.pullback!(grads, Smooth(0.5), CR.Step(), [2.0], [1.0], 1)
(grads.v, grads.s, grads.piece.a[])
```

[Parameters and gradients](@ref extending-parameters) gives the layout of `grads.piece` for every kind of field.

## [Checking a new type](@id extending-checks)

The test [`PieceInterface`](@ref ComposableRecurrences.PieceInterface) checks `forward!` with one `Arguments` per role, each holding the type, the role and the arguments after the role.
The optional checks `:pointwise` and `:nstate` test a pointwise step and the state length.
The `:pullback` check compares each `pullback!` with the ForwardDiff Jacobian of `forward!` on the same inputs.
[Checking your type](@ref overview-gradients) lists the arguments for every role.

```@example extending
using Interfaces: Interfaces, Arguments

m = Smooth(0.3)
Interfaces.test(
    CR.PieceInterface{(:pointwise, :nstate, :pullback)}, Smooth,
    [
        Arguments(; piece = m, role = CR.Init(), args = (zeros(2), ones(2, 3))),
        Arguments(;
            piece = m, role = CR.Step(), args = ([1.0, 2.0], [0.5, 0.5], 1)
        ),
    ]
)
```

Last, compare a reverse-mode gradient through the operator with its [`NoAdjoint`](@ref ComposableRecurrences.NoAdjoint) twin, which takes plain automatic differentiation (AD) of the operator's code.
Use Mooncake or Enzyme, and a loss that changes with every parameter, as forward-mode [backends](@ref adjoint-backends) never take the rule.

```@example extending
using DifferentiationInterface, Mooncake

smooth(a) = Recurrence([0.5, 0.5]; modifiers = (Smooth(a[1]),))
abs2_loss(op) = a -> sum(abs2, op(a)(fill(1.2, 30); history = [1.0, 2.0]))
backend = AutoMooncake(; config = nothing)
gradient(abs2_loss(smooth), backend, [0.3]) ≈
    gradient(abs2_loss(CR.NoAdjoint ∘ smooth), backend, [0.3])
```

## [Where next](@id extending-next)

- [Parameters and gradients](@ref extending-parameters): a parameter per stratum or over time, and the layout of `grads.piece`.
- [Couplings](@ref extending-coupling): a new way to mix strata, including a linear one.
- [Steps across strata](@ref extending-steps): a modifier that reads other strata or acts on groups of them.
- [Traces](@ref extending-trace): what a modifier records for a call with `record = (:trace,)`.
- [Depletion forms](@ref extending-form): a new way for a pool to give up what a step asks for.
- [Extension API](@ref overview-extending): every role, its arguments and the names for a new type.
- [Rules for every type](@ref extending-rules): number types, threads and other cases a `forward!` must handle.
- [Performance and trimming](@ref extending-performance): fast methods, specialising and trimmed executables.
