# [Traces](@id extending-trace)

A modifier can record a series of its own at each step, building on the smoothing modifier of [Writing new types](@ref extending).

```@setup extending-traces
using ComposableRecurrences
const CR = ComposableRecurrences
struct Smooth{A}
    a::A
end
CR.blocks(::Smooth) = (1, 1)
function CR.forward!(m::Smooth, ::CR.Step, v, s, t)
    for k in eachindex(v, s)
        s[k] = m.a * s[k] + (1 - m.a) * v[k]
        v[k] = s[k]
    end
    return nothing
end
```

A call with `record = (:trace,)` returns `(; y, trace)`, with `trace.modifiers` holding one matrix per modifier, [`ntrace`](@ref ComposableRecurrences.ntrace) rows by the steps.
By default a modifier's trace is its state after each step.
A modifier whose state never changes records nothing, and declares so with `isstateless(::MyModifier) = true` ([`isstateless`](@ref ComposableRecurrences.isstateless)).

## [A trace of its own](@id extending-trace-own)

A modifier can instead record a function of the step's values and state before and after it, `v`, `s`, `v′` and `s′`.
Its `forward!` for the role [`Trace()`](@ref ComposableRecurrences.Trace) writes it into `r`.

| Type | `forward!` | `pullback!` | `grads` |
|---|---|---|---|
| modifier trace | `forward!(m, Trace(), r, v, s, v′, s′, t)` writes `r` | `pullback!(grads, m, Trace(), v, s, t)` | the mirror; `trace` holds the cotangent of `r`, in its shape; add into `v`, `s`, `v′` and `s′` |

For a pointwise modifier `r` is a tuple of vectors, one per trace value, indexed as `v`.
For a modifier on whole vectors it is the step's column of `ntrace` rows.

The smoothing modifier records its smoothed value and what it leaves of the value it receives,

```math
r_t = \big(s_t,\ v_t - s_t\big),
```

and the pullback sends their cotangents to the inputs and outputs of the step:

```math
\bar v = \bar r_2, \qquad \bar s' = \bar r_1 - \bar r_2,
```

with ``\bar s`` and ``\bar v'`` zero.
Two values per stratum give ``2S`` rows.

```@example extending-traces
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
y, trace = r(2.0; history = [1.0, 2.0], stop = 4, record = (:trace,))
only(trace.modifiers)
```

A blockwise modifier records its trace per group, with `g` after `t` and tuples of one-entry views, as its step does.
Its `pullback!(grads, m, Trace(), v, s, t, g)` adds `grads.trace`, a tuple of views, into the views in `v`, `s`, `v′` and `s′`, and is given the values before the step.
One whose trace is not linear in the step's outputs computes them with the step's `forward!`.
`PieceInterface` checks that a trace leaves `v`, `s`, `v′` and `s′` unchanged.
