# The role interface. Every operator, coupling, modifier or variant
# implements `forward`, and optionally `pullback!`, for a role.

@doc raw"""
The role of an operator's whole call, `forward(op, Run(), args...; kwargs...)`,
which returns `(y, cache)`; calling the operator lowers to it.

For inputs ``u`` (the call's arguments and the operator's fields) it
computes the output over the call's times ``t = t_0, \dots, t_1``,

```math
y = f_{\mathrm{op}}(u), \qquad y = (y_{t_0}, \dots, y_{t_1}),
```

with ``f_{\mathrm{op}}`` the operator's own maths (see [`Recurrence`](@ref)
and [`Convolution`](@ref)); `cache` holds what the reverse pass needs, such
as the [`ComposableRecurrences.State`](@ref).

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
y, cache = CR.forward(Recurrence([0.5, 0.5]), CR.Run(), fill(1.1, 4); history = ones(2))
round.(y; digits = 3)

# output

4-element Vector{Float64}:
 1.1
 1.155
 1.24
 1.317
```
"""
struct Run end

@doc raw"""
The role of one step of a modifier, or of a variant inside its owner (a
depletion form inside [`ComposableRecurrences.Depletion`](@ref)).

A modifier ``M`` maps the step's values and its own state at absolute time
``t`` to new ones,

```math
(v', s') = M(v, s, t), \qquad v, v', s, s' \in \mathbb{R}^S,
```

where ``v`` holds one value per stratum (one of ``S`` parallel series), ``s``
is the modifier's state after the previous step and ``s'`` its state after
this one.
A pointwise modifier acts on each stratum ``i`` separately,
``(v'_i, s'_i) = M_i(v_i, s_i, t)``.

  - `forward(m, Step(), v, s, t)` updates the step's values `v` and the
    modifier's state `s` in place (one entry per stratum, or two for a
    [`ComposableRecurrences.Depletion`](@ref) with a protected pool) and
    returns `nothing`.
  - `forward(m, Step(), v, s, t, k)` is the scalar form for stratum `k`,
    returning `(v′, s′)`; a modifier with
    [`ComposableRecurrences.ispointwise`](@ref) implements this one.
  - `forward(form, Step(), v, s, N, α)` draws `v` from pool `s` for a
    depletion form, returning `(y, s′)`.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
y, s = CR.forward(CR.Hazard(), CR.Step(), 2.0, 80.0, 100.0, 1.0)
round(y; digits = 3), round(s; digits = 3)

# output

(1.584, 78.416)
```
"""
struct Step end

@doc raw"""
The role of a modifier's initial state: `forward(m, Init(), s, history)`
writes the state `s` (one entry per stratum, or two for a
[`ComposableRecurrences.Depletion`](@ref) with a protected pool, allocated
by the operator at its buffer eltype) from the full history, and returns
`nothing`.

It sets the state before the first step of the call at ``t_0``,

```math
s_{t_0 - 1} = I_M(h), \qquad h = (y_{t_0 - m}, \dots, y_{t_0 - 1}),
```

where ``h`` is the whole history of length ``m``, not only the last ``L``
values the recursion reads, and ``I_M`` is the modifier's own map.
The default is ``s_{t_0 - 1} = 0``.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
s = zeros(2)
CR.forward(CR.Depletion(PerStratum([100.0, 50.0])), CR.Init(), s, ones(2, 3))
s

# output

2-element Vector{Float64}:
 100.0
  50.0
```
"""
struct Init end

@doc raw"""
The role of a coupling: `forward(C, Pressure(), q, p, t)` writes into `q`
the mixing of the per-stratum kernel convolutions `p` at absolute time `t`,
and returns `nothing`.

For the built-in couplings

```math
q_{t,i} = \sum_{j=1}^{S} C_{t,ij}\, p_{t,j},
```

where ``p_{t,j}`` is stratum ``j``'s kernel convolution of its past values,
``q_{t,i}`` the pressure on stratum ``i`` and ``C_{t,ij}`` the weight of
stratum ``j`` in stratum ``i``, with ``S`` strata (parallel series).
`λ * I` gives ``C_{t,ij} = \lambda \delta_{ij}``, a matrix `C` gives
``C_{t,ij}`` = `C[i, j]` at every ``t``, and a [`TimeVarying`](@ref)
coupling gives ``C_{t,ij}`` = `C.x[i, j, t]`.
To add a coupling, define a type and add this method; it may compute any
``q_t`` from ``p_t`` and ``t``.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
q = zeros(2)
CR.forward([0.9 0.1; 0.2 0.8], CR.Pressure(), q, [1.0, 2.0], 1)
q

# output

2-element Vector{Float64}:
 1.1
 1.8
```
"""
struct Pressure end

@doc raw"""
Run `x` in `role` on primal arguments `args`.

For the role's inputs ``u`` it computes its outputs

```math
o = f_{\mathrm{role}}(u),
```

with ``f_{\mathrm{role}}`` the map each role's docstring gives:
[`ComposableRecurrences.Run`](@ref) an operator's whole call,
[`ComposableRecurrences.Step`](@ref) a modifier step ``(v, s) \mapsto (v', s')``,
[`ComposableRecurrences.Init`](@ref) an initial state from the history and
[`ComposableRecurrences.Pressure`](@ref) a coupling ``q_t = C_t p_t``.
Array outputs are written into the leading array arguments and the method
returns `nothing`; a scalar [`ComposableRecurrences.Step`](@ref) returns its
new scalars and [`ComposableRecurrences.Run`](@ref) returns `(y, cache)`.
To extend the package, define a type and add this method for its role:
[`ComposableRecurrences.Step`](@ref) and [`ComposableRecurrences.Init`](@ref)
for a modifier or variant, [`ComposableRecurrences.Pressure`](@ref) for a
coupling.

# Arguments
- `x`: the operator, coupling, modifier or variant.
- `role`: `Run()`, `Step()`, `Init()` or `Pressure()`.
- `args`: the role's arguments.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
struct Offset{T}
    b::T
end
CR.ispointwise(::Offset) = true
CR.forward(m::Offset, ::CR.Step, v, s, t, k) = (v + m.b, s)
Recurrence([0.5, 0.5]; modifiers = (Offset(1.0),))(1.0; history = ones(2), stop = 4)

# output

4-element Vector{Float64}:
 2.0
 2.5
 3.25
 3.875
```
"""
function forward end

@doc raw"""
Accumulate the reverse pass of [`ComposableRecurrences.forward`](@ref) for
`x` in `role`.

For `forward` computing outputs ``o = f(u, \theta)`` from inputs ``u`` and
the object's parameters ``\theta``, given the output cotangent ``\bar o``
(the gradient of a scalar loss with respect to ``o``) it adds

```math
\bar u \mathrel{+}= \Big(\frac{\partial o}{\partial u}\Big)^{\top} \bar o,
\qquad
\bar\theta \mathrel{+}= \Big(\frac{\partial o}{\partial \theta}\Big)^{\top} \bar o .
```

`grads` is a NamedTuple: `grads.piece` holds ``\bar\theta``, mirroring the
object's parameters (or is `nothing`), and the other fields are named after
the role's arguments.
Output cotangents are read on entry and input cotangents accumulated; a
buffer `forward` updated in place is overwritten with the cotangent of its
incoming value, and a scalar `Step` returns its input cotangents instead.
An operator's native rule calls a method whose `grads` and arguments after
the role are untyped (see [`ComposableRecurrences.uses_adjoint`](@ref)).
Without one, [Rules and plain AD](@ref adjoint-routing) says how the object
is differentiated.

# Arguments
- `grads`: the cotangents, `(; piece, ...)`, with `piece` the mirror of
  `x`'s parameters.
- `x`: the operator, coupling, modifier or variant.
- `role`: the role.
- `args`: the primal arguments `forward` was given.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
m = CR.Clamp(0.0, 1.0)
grads = (; piece = (; lo = Ref(0.0), hi = Ref(0.0)), v = 1.0, s = 0.0)
CR.pullback!(grads, m, CR.Step(), 2.0, 0.0, 1, 1), grads.piece.hi[]

# output

((0.0, 0.0), 1.0)
```
"""
function pullback! end

@doc raw"""
Whether modifier `m` acts on each stratum separately.

A pointwise modifier's step factorises over strata (the ``S`` parallel
series): at absolute time ``t``, stratum ``i``'s new value and state depend
only on its own,

```math
(v'_i, s'_i) = M_i(v_i, s_i, t), \qquad i = 1, \dots, S .
```

This sets which [`ComposableRecurrences.Step`](@ref) a modifier implements:
a per-stratum map sets `ispointwise(m) = true` and implements the scalar
`forward(m, Step(), v, s, t, k)`, which the default vector step loops over
strata; a modifier that couples strata implements
`forward(m, Step(), v, s, t)` instead.
The default is `false`.

# Arguments
- `m`: the modifier.

# Examples
```jldoctest
using ComposableRecurrences
ComposableRecurrences.ispointwise(nothing)

# output

false
```
"""
ispointwise(m) = false

@doc raw"""
The number of state entries modifier `m` keeps for `S` strata.

A stratum is one of the ``S`` parallel series computed together, such as a
place or an age group.
The recurrence allocates each modifier's state ``s`` with

```math
|s| = n(m, S), \qquad n(m, S) = S \text{ by default},
```

passes it to the modifier's [`ComposableRecurrences.Init`](@ref) and
[`ComposableRecurrences.Step`](@ref), and checks a resumed state against it.
This is the extension point for a modifier that holds more than one stock
per stratum: a depletion with a protected pool keeps the unprotected pool
then the protected pool, ``n(m, S) = 2S``.
A pointwise modifier ([`ComposableRecurrences.ispointwise`](@ref)) keeps
one entry per stratum, so it must have ``n(m, S) = S``.

# Arguments
- `m`: the modifier.
- `S`: the number of strata.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
leaky = CR.Depletion(100.0; removals = 1.0, protected = CR.Protected(0.3))
CR.nstate(CR.Clamp(0.0, 1.0), 3), CR.nstate(leaky, 3)

# output

(3, 6)
```
"""
nstate(m, S) = S

@doc raw"""
The number of past outputs `x` reads from a recurrence's buffer, before
the current step.

A [`Recurrence`](@ref) keeps

```math
D = \max\big(L,\ d(\text{kernel}),\ d(\text{coupling}),\ d(M_1), \dots, d(M_R)\big)
```

past outputs per stratum, where ``L`` is the kernel length, ``d`` is
`depth` and ``M_1, \dots, M_R`` are the modifiers.
The kernel reads the last ``L`` of them, and a piece with ``d(x) > L``
can read further back.
A [`ComposableRecurrences.State`](@ref) holds the last ``D`` outputs, so a
resumed call reads the same past.
The default recurses by value through fields, tuples and named tuples and
takes the largest; numbers, arrays and functions read nothing, ``d = 0``.
Add a method for a type that reads the buffer.

# Arguments
- `x`: any object, such as a modifier, coupling or kernel.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
struct Window
    w::Int
end
CR.depth(x::Window) = x.w
CR.depth((Window(5), (; a = Window(9), b = 1.0))), CR.depth(CR.Clamp(0.0, 1.0))

# output

(9, 0)
```
"""
depth(x) = _fields_depth(x)
depth(::Union{Number, AbstractArray, Nothing, Symbol, AbstractString}) = 0
depth(::Union{Type, Module, Function}) = 0

# The largest depth over the fields of `x`, unrolled so a concrete type
# infers, as `_fields_eltype` does. Each field's depth is checked here, so
# a bad one is not hidden by the maximum.
@generated function _fields_depth(x)
    calls = (:(_checked_depth(getfield(x, $i))) for i in 1:fieldcount(x))
    return :(max(0, $(calls...)))
end

function _checked_depth(x)
    d = depth(x)
    d isa Integer && d >= 0 || throw(
        ArgumentError(
            "depth($(nameof(typeof(x)))) must be a non-negative integer; " *
                "got $(repr(d))"
        )
    )
    return Int(d)
end

# A modifier's shape checks against `S` strata, run once per call by its
# `Init` and on a resumed state.
_check_modifier_strata(m, S) = nothing

# Defaults: a zero initial state, and a vector step that loops the scalar
# one for a pointwise modifier.
function forward(m, ::Init, s, history)
    fill!(s, zero(eltype(s)))
    return nothing
end

function forward(m, ::Step, v, s, t)
    ispointwise(m) || throw(
        ArgumentError(
            "$(typeof(m)) implements neither forward(m, Step(), v, s, t) " *
                "nor a pointwise forward(m, Step(), v, s, t, k)"
        )
    )
    for k in eachindex(v, s)
        v[k], s[k] = forward(m, Step(), v[k], s[k], t, k)
    end
    return nothing
end

# The vector step's pullback: the modifier's own, or for a pointwise
# modifier without one the scalar pullback per stratum. Not a `pullback!`
# method, which would count as every modifier's own.
function _vector_pullback!(grads, m, v, s, t)
    ispointwise(m) && !_has_vector_pullback(m) &&
        return _strata_pullback!(grads, m, v, s, t)
    return _call_pullback!(grads, m, Step(), v, s, t)
end
function _strata_pullback!(grads, m, v, s, t)
    v̄, s̄ = grads.v, grads.s
    for k in eachindex(v, s, v̄, s̄)
        v̄[k], s̄[k] = _step_pullback(
            (; piece = grads.piece, v = v̄[k], s = s̄[k]), m, v[k], s[k], t, k
        )
    end
    return nothing
end

# Run the modifiers in tuple order on the step's values, in place.
_stages!(::Tuple{}, ::Tuple{}, v, t) = nothing
function _stages!(ms::Tuple, states::Tuple, v, t)
    forward(first(ms), Step(), v, first(states), t)
    return _stages!(Base.tail(ms), Base.tail(states), v, t)
end
