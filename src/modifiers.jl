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
    A blockwise modifier ([`ComposableRecurrences.blocks`](@ref))
    implements it for group `k`, with `v`, `s`, `v′` and `s′` tuples.
  - `forward(form, Step(), v, s, N, α)` draws `v` from pool `s` for a
    depletion form, returning `(y, s′)`.

[Roles](@ref extending-roles) gives the matching
[`ComposableRecurrences.pullback!`](@ref) for each.

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
`nothing`; [Roles](@ref extending-roles) gives the arguments.

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
[A coupling](@ref extending-coupling) writes one with its
[`ComposableRecurrences.pullback!`](@ref).

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
[Roles](@ref extending-roles) gives each role's arguments.

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
[Roles](@ref extending-roles) gives the signature, the `grads` fields and the
return value for each role, and [The gradient mirror](@ref extending-mirror)
the shape of `grads.piece`.
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
The group shape of modifier `m`: `Val((nv, ns))`, its values and state
entries per group, or `nothing` when it is not blockwise.

A blockwise modifier holds ``n_v`` compartments of ``G`` groups each in its
values and ``n_s`` in its state, compartment by compartment: with
``S = n_v G`` strata, value ``(i - 1) G + g`` is compartment ``i`` of group
``g`` and state entry ``(j - 1) G + g`` is state compartment ``j`` of group
``g``.
Its step factorises over groups: at absolute time ``t``, group ``g``'s new
values and state depend only on its own,

```math
\big(v'_{1:n_v,\,g},\ s'_{1:n_s,\,g}\big) =
M_g\big(v_{1:n_v,\,g},\ s_{1:n_s,\,g},\ t\big),
\qquad g = 1, \dots, G .
```

A blockwise modifier implements `forward(m, Step(), v, s, t, g)` with `v`
and `s` tuples of the group's ``n_v`` values and ``n_s`` state entries,
returning the new tuples `(v′, s′)`, and optionally
`pullback!(grads, m, Step(), v, s, t, g)` with `grads.v` and `grads.s`
tuples, returning the input cotangents as tuples.
The default vector [`ComposableRecurrences.Step`](@ref) loops the groups,
and [`ComposableRecurrences.nstate`](@ref) is ``n_s G``.
The group step reads parameters at group `g`, so a [`PerStratum`](@ref)
parameter has ``G`` entries.
`blocks` should follow from the type of `m`, so the group loop is
compiled for its shape.
A pointwise modifier ([`ComposableRecurrences.ispointwise`](@ref)) is the
case ``n_v = n_s = 1`` with a scalar step, and is not blockwise.
The default is `nothing`.

# Arguments
- `m`: the modifier.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
leaky = CR.Depletion(100.0; removals = 1.0, protected = CR.Protected(0.3))
CR.blocks(leaky), CR.blocks(CR.Clamp(0.0, 1.0))

# output

(Val{(1, 2)}(), nothing)
```
"""
blocks(m) = nothing

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
per stratum.
A blockwise modifier ([`ComposableRecurrences.blocks`](@ref)) keeps
``n_s`` entries per group, ``n(m, S) = n_s S / n_v``: a depletion with a
protected pool keeps the unprotected pool then the protected pool,
``n(m, S) = 2S``.
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
nstate(m, S) = _blocks_nstate(blocks(m), S)
_blocks_nstate(::Nothing, S) = S
_blocks_nstate(::Val{B}, S) where {B} = B[2] * _ngroups(Val(B), S)

# The number of groups of a blockwise modifier over `S` strata.
function _ngroups(::Val{B}, S) where {B}
    nv = _check_blocks(Val(B))
    rem(S, nv) == 0 || _strata_mismatch(nv, S)
    return S ÷ nv
end
@noinline function _strata_mismatch(nv, S)
    throw(
        DimensionMismatch(
            "a blockwise modifier with $nv value compartments needs a " *
                "multiple of $nv strata, got $S"
        )
    )
end

# The value compartments of a group shape, after checking the shape.
function _check_blocks(::Val{B}) where {B}
    B isa Tuple{Int, Int} && B[1] >= 1 && B[2] >= 0 || throw(
        ArgumentError(
            "blocks(m) is Val((nv, ns)) with integers nv >= 1 and ns >= 0, " *
                "got Val($(repr(B)))"
        )
    )
    return B[1]
end

# A modifier's shape checks against `S` strata, run once per call by its
# `Init` and on a resumed state.
_check_modifier_strata(m, S) = nothing

# Defaults: a zero initial state, and a vector step that loops the scalar
# one for a pointwise modifier or the group one for a blockwise modifier.
function forward(m, ::Init, s, history)
    fill!(s, zero(eltype(s)))
    return nothing
end

forward(m, ::Step, v, s, t) = _vector_step!(blocks(m), m, v, s, t)

# The group `g` entries of `x`, compartment by compartment, as a tuple, and
# their write-back. Generated as straight-line indexing, which AD backends
# differentiate more cheaply than a closure or a recursion over the tuple.
@generated function _gather(x, ::Val{n}, G, g) where {n}
    return Expr(:tuple, (:(x[$(i - 1) * G + g]) for i in 1:n)...)
end
@generated function _scatter!(x, xs::Tuple, G, g)
    body = (:(x[$(i - 1) * G + g] = xs[$i]) for i in 1:fieldcount(xs))
    return Expr(:block, body..., :(return x))
end

# The group step and its pullback are inlined at their calls: across a call
# boundary, plain reverse AD of the returned tuples took about 70% longer
# and the rule's reverse pass about 8% longer.
function _vector_step!(::Val{B}, m, v, s, t) where {B}
    nv, ns = B
    G = _ngroups(Val(B), length(v))
    for g in 1:G
        v′, s′ = @inline forward(
            m, Step(), _gather(v, Val(nv), G, g), _gather(s, Val(ns), G, g), t, g
        )
        _scatter!(v, v′, G, g)
        _scatter!(s, s′, G, g)
    end
    return nothing
end

function _vector_step!(::Nothing, m, v, s, t)
    ispointwise(m) || throw(
        ArgumentError(
            "$(typeof(m)) implements neither forward(m, Step(), v, s, t) " *
                "nor a pointwise forward(m, Step(), v, s, t, k), and is " *
                "not blockwise (see blocks)"
        )
    )
    for k in eachindex(v, s)
        v[k], s[k] = forward(m, Step(), v[k], s[k], t, k)
    end
    return nothing
end

# The vector step's pullback: the modifier's own, or for a pointwise or
# blockwise modifier without one the scalar or group pullback per stratum
# or group. Not a `pullback!` method, which would count as every
# modifier's own.
function _vector_pullback!(grads, m, v, s, t)
    _has_vector_pullback(m) || return _split_pullback!(blocks(m), grads, m, v, s, t)
    return _call_pullback!(grads, m, Step(), v, s, t)
end
function _split_pullback!(::Nothing, grads, m, v, s, t)
    ispointwise(m) && return _strata_pullback!(grads, m, v, s, t)
    return _call_pullback!(grads, m, Step(), v, s, t)
end
function _split_pullback!(::Val{B}, grads, m, v, s, t) where {B}
    nv, ns = B
    v̄, s̄ = grads.v, grads.s
    G = _ngroups(Val(B), length(v))
    for g in 1:G
        gg = (;
            piece = grads.piece, v = _gather(v̄, Val(nv), G, g),
            s = _gather(s̄, Val(ns), G, g),
        )
        vg, sg = _gather(v, Val(nv), G, g), _gather(s, Val(ns), G, g)
        # The check folds; the group pullback itself is inlined here, as
        # inlining `_call_pullback!` leaves its inner call a real one.
        sig = Tuple{
            typeof(pullback!), typeof(gg), typeof(m), Step, typeof(vg),
            typeof(sg), typeof(t), typeof(g),
        }
        Core._hasmethod(sig) || _no_pullback(m, Step())
        v̄g, s̄g = @inline pullback!(gg, m, Step(), vg, sg, t, g)
        _scatter!(v̄, v̄g, G, g)
        _scatter!(s̄, s̄g, G, g)
    end
    return nothing
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
