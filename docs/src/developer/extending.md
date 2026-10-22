# [Writing new types](@id extending)

A new modifier, coupling or depletion form is a type with a [`forward!`](@ref ComposableRecurrences.forward!) method for its role.
Add a [`pullback!`](@ref ComposableRecurrences.pullback!) method for a hand-written gradient.
This page gives the contract for each role, then one worked example for each kind of type.

```@example extending
using ComposableRecurrences
const CR = ComposableRecurrences
```

## [Roles](@id extending-roles)

The second argument of `forward!` and the third of `pullback!` is a singleton that selects the role by dispatch.
For a step, an initial state, a coupling's mixing or a modifier's trace, both write their outputs in place and return `nothing`, and a method that returns anything else is an error.
A modifier's trace ([`Trace()`](@ref ComposableRecurrences.Trace)) is a function of the step's inputs and outputs, written after the step rather than computed in it.
An operator's whole call, [`forward(op, Run(), args...)`](@ref ComposableRecurrences.forward), returns `(y, cache)`, so [`Run()`](@ref ComposableRecurrences.Run) is not in this table.

| Type | `forward!` | `pullback!` | `grads` |
|---|---|---|---|
| modifier step | `forward!(m, Step(), v, s, t)` updates `v` and `s` | `pullback!(grads, m, Step(), v, s, t)` | `piece`; `v` and `s` hold the cotangents of `v′` and `s′`; overwrite them with those of `v` and `s` |
| blockwise modifier group step | `forward!(m, Step(), v::Tuple, s::Tuple, t, g)` updates the views in `v` and `s` | `pullback!(grads, m, Step(), v, s, t, g)` | `piece`; `v` and `s` are tuples of views holding the cotangents of `v′` and `s′`; overwrite them with those of `v` and `s` |
| initial state | `forward!(m, Init(), s, history)` writes `s` | `pullback!(grads, m, Init(), s, history)` | `piece`; `s` holds the cotangent of `s`; add into `history`, which may be `nothing` |
| coupling | `forward!(C, Pressure(), q, p, t)` writes `q` | `pullback!(grads, C, Pressure(), q, p, t)`, with `q === nothing` | `piece`; `q` holds the cotangent of `q`; add into `p` |
| depletion form | `forward!(form, Step(), v, s, N, α)` writes the drawn values into `v` and the pools after the draw into `s` | `pullback!(grads, form, Step(), v, s, N, α)` | `piece`; `v` and `s` hold the cotangents of `v′` and `s′`; overwrite them with those of `v` and `s`, and add those of `N` and `α` into `N` and `α`, which are indexed as `v` is |
| modifier trace | `forward!(m, Trace(), r, v, s, v′, s′, t)` writes `r`: for a pointwise modifier a tuple of vectors, one per trace value, indexed as `v`; for any other the step's column of [`ntrace`](@ref ComposableRecurrences.ntrace) rows | `pullback!(grads, m, Trace(), v, s, t)` | `piece`; `trace` holds the cotangent of `r`, in its shape; add into `v`, `s`, `v′` and `s′` |
| blockwise modifier group trace | `forward!(m, Trace(), r::Tuple, v::Tuple, s::Tuple, v′::Tuple, s′::Tuple, t, g)` writes the one-entry views in `r` | `pullback!(grads, m, Trace(), v, s, t, g)` | `piece`; `trace` is a tuple of views holding the cotangents of `r`; add into the views in `v`, `s`, `v′` and `s′` |

The arguments mean the same in every role:

- `t` is the absolute time, counted from 1 as `start` and `stop` are.
- `v` holds one value per [stratum](@ref glossary-stratum), indexed by stratum, and `s` is the modifier's state after the previous step, with [`nstate`](@ref ComposableRecurrences.nstate) entries.
- `history` is the call's `history` as given: a vector for one series, else strata × time.
  Without an `Init` method the state starts at zero, and no `Init` pullback is needed.
- In `pullback!`, `v`, `s`, `p` and `history` are the values `forward!` was given, so the values before the step.
  Read them, but do not write to them.
- Leave `grads` and the arguments after the role in `pullback!` untyped, so that [`uses_adjoint`](@ref ComposableRecurrences.uses_adjoint) finds the method.
- A pointwise modifier sets [`ispointwise`](@ref ComposableRecurrences.ispointwise), and writes entry `k` of `v` and `s` from entry `k` only, for each `k` in `eachindex(v)`.
  The operator may call it on a one-entry view of stratum `k`, whose axes are `k:k`, so loop over `eachindex(v)` and read parameters at `k` with [`param`](@ref ComposableRecurrences.param).
  A broadcast against a field with one entry per stratum, such as `v .*= m.w`, cannot run on that view; the pointwise check of `PieceInterface` reports it.
  Such a step runs on a [`Device`](@ref ComposableRecurrences.Device) when it reads and writes only `eachindex(v)` entries, and allocates nothing.
- A blockwise modifier sets [`blocks`](@ref ComposableRecurrences.blocks) and implements the step for one group, `g`, on tuples of one-entry views; read and write a view `x` as `x[]`.
- Any other modifier implements the step on whole vectors and may read every stratum.
- A depletion form is pointwise: it draws each entry of `v` from the same entry of `s`.

`forward!` must be generic in the element type of its arguments.
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
Under [`Threaded`](@ref ComposableRecurrences.Threaded), the reverse pass gives each chunk of strata a zeroed copy of these mirrors and sums the copies after the loop.
A mirror with an entry of another kind, such as an integer or a `Ref` that is not of a number, runs that loop on one task.
So read an entry with [`cotangent`](@ref ComposableRecurrences.cotangent).
Add to it with [`add_cotangent!`](@ref ComposableRecurrences.add_cotangent!), which skips `nothing`.
Read a modifier parameter with [`param`](@ref ComposableRecurrences.param).
Add its cotangent with [`add_param!`](@ref ComposableRecurrences.add_param!).
These accept every parameter form, including [`Derived`](@ref) and [`Recent`](@ref).
Call `add_param!` for every parameter, even with a `nothing` mirror; [`add_param!`](@ref ComposableRecurrences.add_param!) says why.

A type without a `pullback!` still takes the rule when the local step can rebuild it; [What the local step needs](@ref adjoint-local-step) gives the conditions.

## [A first modifier](@id extending-pointwise)

This modifier smooths each series exponentially:

```math
s_t = a \, s_{t-1} + (1 - a) \, v_t, \qquad v'_t = s_t,
```

where ``v_t`` is the value it receives, ``v'_t`` the value it passes on and ``s_t`` its state.
It acts on each series alone, so it is pointwise and writes each entry from its own.
Its state starts at the last value of the history.
The field has a type parameter so that a dual number can take its place.

```@example extending
struct Smooth{A}
    a::A
end
CR.ispointwise(::Smooth) = true
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

Recurrence([0.5, 0.5]; modifiers = (Smooth(0.5),))(2.0; history = [1.0, 2.0], stop = 5)
```

It goes in the modifier tuple with the package's own.
Placed before [`Depletion`](@ref ComposableRecurrences.Depletion), it smooths the infections drawn from the pool.
With ``f`` the smoothing and ``h`` the depletion draw, each step gives

```math
y_t = h\Big(f\big(g_t \sum_{l} k_l \, y_{t-l},\ s_{t-1}\big)\Big),
```

where ``k_l`` is the kernel, ``g_t`` the gain and ``y_t`` the output.
More smoothing delays the peak.

```@example extending
seed = [1.0, 2.0, 3.0]
N = 10_000.0
pool = CR.Depletion(N; pools = (S = N - sum(seed),))
model(a) = Recurrence([0.1, 0.3, 0.3, 0.2, 0.1]; modifiers = (Smooth(a), pool))
[argmax(model(a)(fill(1.8, 80); history = seed)) for a in (0.0, 0.5, 0.8)]
```

Without a `pullback!` the operator still takes its rule; [Rules and plain AD](@ref adjoint-routing) gives the route.

```@example extending
using ForwardDiff

loss(a) = sum(model(a)(fill(1.8, 80); history = seed))
ForwardDiff.derivative(loss, 0.5), CR.uses_adjoint(model(0.5), CR.Run())
```

## [Its pullback](@id extending-pullback)

A `pullback!` gives the derivative in closed form instead of the local step.
The new value and state are both ``s'``, so their cotangents add:

```math
\bar g = \bar v' + \bar s', \qquad
\bar v = (1 - a) \, \bar g, \qquad
\bar s = a \, \bar g, \qquad
\bar a \mathrel{+}= (s - v) \, \bar g,
```

where a bar marks a cotangent, ``\bar g`` is the summed cotangent and ``s`` is the state before the step.
[`cotangent`](@ref ComposableRecurrences.cotangent) reads the mirror of the field ``a``, and [`add_cotangent!`](@ref ComposableRecurrences.add_cotangent!) adds to it.
Both skip a field the backend holds constant.
The `Init` pullback adds the state's cotangent into the last column of the history.

```@example extending
CR.uses_adjoint(Smooth(0.5), CR.Step())
```

```@example extending
function CR.pullback!(grads, m::Smooth, ::CR.Step, v, s, t)
    v̄, s̄ = grads.v, grads.s
    for k in eachindex(v, s)
        ḡ = v̄[k] + s̄[k]
        CR.add_cotangent!(CR.cotangent(grads.piece, :a), (s[k] - v[k]) * ḡ)
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
(grads.v, grads.s, grads.piece.a[]), CR.uses_adjoint(Smooth(0.5), CR.Step())
```

[Checking a new type](@ref extending-checks) tests a `pullback!` against ForwardDiff, and [Performance](@ref extending-performance) gives what a `pullback!` saves.

## [A per-stratum parameter](@id extending-param)

This modifier adds ``b_k`` to the value of stratum ``k``:

```math
v'_{t,k} = v_{t,k} + b_k.
```

It reads `b` with `param` and adds its cotangent with `add_param!`, so `b` may be one value or `PerStratum`.
For a `PerStratum` `b` the mirror entry is `(; x)`, and the cotangent of entry `k` lands in `x[k]`.

```@example extending
struct Shift{B}
    b::B
end
CR.ispointwise(::Shift) = true
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

## [A coupling](@id extending-coupling)

A coupling writes the pressure `q` on each stratum from each stratum's kernel-weighted past values `p`.
This one sends a share ``a`` of every stratum's pressure to the first:

```math
q_i = (1 - a) \, p_i + a \, \delta_{i1} \sum_{j=1}^{S} p_j,
```

where ``\delta_{i1}`` is 1 for the first stratum and 0 otherwise, and ``S`` is the number of strata.
Its pullback reads `grads.q`, adds into `grads.p` and adds the cotangent of `share`.

```@example extending
struct ToFirst{A}
    share::A
end
function CR.forward!(C::ToFirst, ::CR.Pressure, q, p, t)
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

A modifier that reads other strata is not pointwise, and its step reads the whole vectors.
This one pulls each value towards the mean over strata by a share ``a``:

```math
v'_k = (1 - a) \, v_k + a \, \mu, \qquad \mu = \frac{1}{S} \sum_{j=1}^{S} v_j,
```

where ``S`` is the number of strata.

Its pullback overwrites `grads.v` with the cotangent of the incoming values.
The state passes through unchanged, so `grads.s` already holds its cotangent.

```@example extending
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

Recurrence([0.5, 0.5]; modifiers = (ToMean(0.5),))(1.0; history = [1.0 2.0; 3.0 1.0], stop = 3)
```

## [A blockwise step](@id extending-blockwise)

A modifier whose step acts on fixed groups of series, each with a fixed number of values and state entries, is blockwise.
[`blocks`](@ref ComposableRecurrences.blocks) gives the values and state entries of each group.
The step takes them as tuples of one-entry views, read and written as `x[]`.
This one keeps a running total and a step count per series, and adds their mean to the value:

```math
a_t = a_{t-1} + v_t, \qquad n_t = n_{t-1} + 1, \qquad v'_t = v_t + \frac{a_t}{n_t},
```

where ``v_t`` is the value at step ``t`` and ``v'_t`` the value passed on.
``a_t`` is the running total and ``n_t`` the step count, the series' two state entries.

```@example extending
struct AddMean end
CR.blocks(::AddMean) = Val((1, 2))
function CR.forward!(::AddMean, ::CR.Step, v::Tuple, s::Tuple, t, g)
    total, n = s[1][] + v[1][], s[2][] + 1
    v[1][] += total / n
    s[1][], s[2][] = total, n
    return nothing
end

Recurrence([0.5, 0.5]; modifiers = (AddMean(),))(fill(1.0, 2, 4); history = [1.0 2.0; 3.0 1.0])
```

## [A trace](@id extending-trace)

A call with `trace = true` returns `(y, trace)`, with `trace.modifiers` holding one matrix per modifier, [`ntrace`](@ref ComposableRecurrences.ntrace) rows by the steps; [`Trace`](@ref ComposableRecurrences.Trace) gives the default, the built-in traces and the layout of the rows.
A modifier can record another series instead: a function of the step's values and state before it, `v` and `s`, and after it, `v′` and `s′`, written into `r` by `forward!`.
The smoothing modifier above records its smoothed value and what it leaves of the value it receives,

```math
r_t = \big(s_t,\ v_t - s_t\big),
```

and the pullback sends their cotangents to the inputs and outputs of the step:

```math
\bar v = \bar r_2, \qquad \bar s' = \bar r_1 - \bar r_2,
```

with ``\bar s`` and ``\bar v'`` zero.
Two values per stratum give ``2S`` rows.

```@example extending
CR.ntrace(::Smooth, S) = 2S
function CR.forward!(m::Smooth, ::CR.Trace, r, v, s, v′, s′, t)
    smoothed, left = r
    for k in eachindex(v)
        smoothed[k], left[k] = s′[k], v[k] - s′[k]
    end
    return nothing
end
function CR.pullback!(grads, m::Smooth, ::CR.Trace, v, s, t)
    r̄₁, r̄₂ = grads.trace
    for k in eachindex(v)
        grads.v[k] += r̄₂[k]
        grads.s′[k] += r̄₁[k] - r̄₂[k]
    end
    return nothing
end

r = Recurrence([0.5, 0.5]; modifiers = (Smooth(0.5),))
y, trace = r(2.0; history = [1.0, 2.0], stop = 4, trace = true)
only(trace.modifiers)
```

A blockwise modifier records its trace per group, on tuples of one-entry views, as its step.
The pullback is given the values before the step, `v` and `s`.
One whose trace is not linear in the step's outputs computes them with the step's `forward!`.

## [A depletion form](@id extending-form)

A depletion form draws value `v` from pool `s` with population `N` and exponent `α`.
It is passed to [`Depletion`](@ref ComposableRecurrences.Depletion) as its `form`.
This one takes what is asked, up to the pool:

```math
v' = \min(v, s), \qquad s' = s - v',
```

where ``v'`` is the value drawn and ``s'`` the pool after the step.
Its pullback overwrites `grads.v` and `grads.s` with the cotangents of `v` and `s`.
This form reads neither `N` nor `α`, so it adds nothing into `grads.N` and `grads.α`; `Depletion` adds what a form puts there into its own mirror.
Its `grads.piece` is the mirror of the form's own fields.

```@example extending
struct Capped end
function CR.forward!(::Capped, ::CR.Step, v, s, N, α)
    for k in eachindex(v, s)
        y = min(v[k], s[k])
        v[k], s[k] = y, s[k] - y
    end
    return nothing
end
function CR.pullback!(grads, ::Capped, ::CR.Step, v, s, N, α)
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

d = CR.Depletion(10.0; form = Capped())
Recurrence([0.5, 0.5]; modifiers = (d,))(2.0; history = [1.0, 2.0], stop = 8)
```

## [Checking a new type](@id extending-checks)

First test `forward!` against [`PieceInterface`](@ref ComposableRecurrences.PieceInterface), with one `Arguments(; piece, role, args)` per role the type has.
Here `args` are the arguments after the role:

- `(s, history)` for `Init()`;
- `(v, s, t)`, with vectors, for a modifier's `Step()`;
- `(q, p, t)` for `Pressure()`;
- `(v, s, N, α)`, with vectors `v` and `s`, for a depletion form;
- `(r, v, s, v′, s′, t)` for `Trace()`, with `r` in the shape the [Roles](@ref extending-roles) table gives, and `g` after `t` for a blockwise group, whose arguments are then tuples of `Ref`s.

For `Trace()` it checks that the trace leaves `v`, `s`, `v′` and `s′` unchanged.
It also checks that `uses_adjoint` finds any `pullback!` the type has.
The optional checks of `PieceInterface{(:pointwise, :nstate)}` test a pointwise step and the state length, and `(:blocks,)` a [blockwise](@ref extending-blockwise) step.

```@example extending
using Interfaces: Interfaces, Arguments

Interfaces.test(
    CR.PieceInterface{(:pointwise, :nstate)}, Smooth,
    [
        Arguments(; piece = Smooth(0.3), role = CR.Init(), args = (zeros(2), ones(2, 3))),
        Arguments(; piece = Smooth(0.3), role = CR.Step(), args = ([1.0, 2.0], [0.5, 0.5], 1)),
        Arguments(;
            piece = Smooth(0.3), role = CR.Trace(),
            args = ((zeros(2), zeros(2)), [1.0, 2.0], [0.5, 0.5], [0.85, 1.55], [0.85, 1.55], 1),
        ),
    ]
)
```

Then check each `pullback!` against ForwardDiff of `forward!` on the same inputs.

```@example extending
using ForwardDiff

function smooth_step(x)
    v, s = [x[2]], [x[3]]
    CR.forward!(Smooth(x[1]), CR.Step(), v, s, 1)
    return [v[1], s[1]]
end
J = ForwardDiff.jacobian(smooth_step, [0.5, 2.0, 1.0])
grads = (; piece = (; a = Ref(0.0)), v = [1.0], s = [0.5])
CR.pullback!(grads, Smooth(0.5), CR.Step(), [2.0], [1.0], 1)
J' * [1.0, 0.5] ≈ [grads.piece.a[], grads.v[1], grads.s[1]]
```

Last, compare a reverse-mode gradient through the operator with its [`NoAdjoint`](@ref ComposableRecurrences.NoAdjoint) twin.
Use Mooncake or Enzyme, and a loss that changes with every parameter.
[Backends](@ref adjoint-backends) says why it must be reverse mode.

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

- Keep `forward!` and `pullback!` free of allocations: loop over `eachindex(v)` and write in place.
- Use concrete field types through type parameters, so every call is type stable.
- Loop with `eachindex` over the arrays you index, and add `@inbounds` only to such loops.
- [Rule timings](@ref rule-timings) gives the cost of a missing `pullback!`.
- A vector step makes the strata wait for each other at every step, so [`Threaded`](@ref ComposableRecurrences.Threaded) gains less from it.

The [benchmark matrix](@ref testing) times the gradient of a renewal with a stateless pointwise modifier, the saturation ``v \kappa / (\kappa + v)`` in `benchmark/docs_modifier.jl`, under Mooncake and Enzyme in reverse mode.
It times plain AD of the whole operator, the rule with `forward!` only, and the rule with the `pullback!`.

```@example extending
using Markdown # hide
results = joinpath(pkgdir(ComposableRecurrences), "benchmark", "results", "docs.csv") # hide
rows = isfile(results) ? split.(readlines(results)[2:end], ',') : [] # hide
custom = filter(r -> r[1] == "custom modifier" && r[5] == "ok", rows) # hide
time_of(m, sz, tg) = parse(Float64, only(r[6] for r in custom if (r[3], r[2], r[4]) == (m, sz, tg))) # hide
cases = unique((r[2], r[4]) for r in custom) # hide
pct(a, b) = extrema(round(Int, 100 * time_of(b, c...) / time_of(a, c...)) for c in cases) # hide
if isempty(cases) # hide
    md"The benchmark results are not available in this build." # hide
else # hide
    (lo, hi), (plo, phi) = pct("plain AD", "forward only"), pct("forward only", "with pullback!") # hide
    Markdown.parse( # hide
        "With `forward!` only, the gradient takes $lo% to $hi% of the time of plain AD. " * # hide
            "The `pullback!` then takes it to $plo% to $phi% of the time with `forward!` only. " * # hide
            "These are median times at revision `$(first(custom)[12])`." # hide
    ) # hide
end # hide
```

The local step evaluates `forward!` once per step with dual numbers, so its cost follows the cost of `forward!`.
For a map as cheap as the saturation there is little for a `pullback!` to save.
Write `forward!` first, and add a `pullback!` when timing shows the modifier's local step matters.

## [Specialising for speed](@id specialising)

Every call of an operator has one form, and the work behind it is chosen by dispatch on the types of its kernel, coupling, modifiers and numbers.
A method for a narrower type replaces the general one for that type alone, so a faster path for one combination needs no new interface and no change to any call.

| To speed up | Add a method |
|---|---|
| a coupling with structure, such as low rank or banded | `forward!(C::MyCoupling, Pressure(), q, p, t)`, and its `pullback!` |
| a modifier at one parameter form | `forward!(m::MyModifier{<:PerStratum}, Step(), v, s, t)` |
| a depletion form at one number type | `forward!(form::MyForm, Step(), v::AbstractVector{Float32}, s::AbstractVector{Float32}, N::Float32, α::Float32)` |
| how a loop over strata runs | an [`Executor`](@ref ComposableRecurrences.Executor) and its [`each!`](@ref ComposableRecurrences.each!) |

A rank-one coupling ``C = u w^\top`` mixes the strata in ``2S`` operations, where a dense matrix takes ``S^2``:

```math
q_a = u_a \sum_{b=1}^{S} w_b \, p_b,
```

where ``p_b`` is stratum ``b``'s kernel-weighted past and ``q_a`` the mixed value of stratum ``a``.

```@example extending
struct RankOne{V}
    u::V
    w::V
end
function CR.forward!(C::RankOne, ::CR.Pressure, q, p, t)
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
