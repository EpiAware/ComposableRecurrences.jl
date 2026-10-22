# The role interface. An operator implements `forward` for `Run()`; every
# coupling, modifier or variant implements `forward!`, and optionally
# `pullback!`, for its role.

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
It is the role an operator is asked about, as in
`uses_adjoint(op, Run())`, `PieceInterface` with `role = Run()` and
`test_adjoint(backend, op, Run(), args...)`.

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
depletion form inside a [`ComposableRecurrences.Depletion`](@ref)).

A modifier ``M`` maps the step's values and its own state at absolute time
``t`` to new ones,

```math
(v', s') = M(v, s, t), \qquad v, v', s, s' \in \mathbb{R}^S,
```

where ``v`` holds one value per stratum (see [`PerStratum`](@ref)), ``s``
is the modifier's state after the previous step and ``s'`` its state after
this one.
A pointwise modifier acts on each stratum ``i`` separately,
``(v'_i, s'_i) = M_i(v_i, s_i, t)``.

  - `forward!(m, Step(), v, s, t)` updates the step's values `v` and the
    modifier's state `s` in place (one entry per stratum, or one per pool
    for a [`ComposableRecurrences.Depletion`](@ref) with several) and
    returns `nothing`.
    A pointwise modifier, with [`ComposableRecurrences.blocks`](@ref)
    `(1, 1)`, writes entry `k` from entry `k` only, and may be called on
    a one-entry view of stratum `k`.
  - `forward!(m, Step(), v, s, t, g)` is the group step of a blockwise
    modifier ([`ComposableRecurrences.blocks`](@ref)), with `v` and `s`
    tuples of one-entry views of group `g`'s values and state.
  - `forward!(form, Step(), v, s, N)` draws `v` from pool `s` in place
    for a depletion form, with `v` and `s` views and `N` a number.

A step writes its outputs and returns `nothing`; one that returns anything
else is an error.
[Roles](@ref extending-roles) gives the matching
[`ComposableRecurrences.pullback!`](@ref) for each.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
v, s = [2.0], [80.0]
CR.forward!(CR.Hazard(), CR.Step(), v, s, 100.0)
round.(v; digits = 3), round.(s; digits = 3)

# output

([1.584], [78.416])
```
"""
struct Step end

@doc raw"""
The role of a modifier's initial state: `forward!(m, Init(), s, history)`
writes the state `s` (one entry per stratum, or one per pool for a
[`ComposableRecurrences.Depletion`](@ref) with several, allocated
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
CR.forward!(CR.Depletion(PerStratum([100.0, 50.0])), CR.Init(), s, ones(2, 3))
s

# output

2-element Vector{Float64}:
 100.0
  50.0
```
"""
struct Init end

@doc raw"""
The role of a coupling: `forward!(C, Pressure(), q, p, t)` writes into `q`
the mixing of the per-stratum kernel convolutions `p` at absolute time `t`,
and returns `nothing`.

For the built-in couplings

```math
q_{t,i} = \sum_{j=1}^{S} C_{t,ij}\, p_{t,j},
```

where ``p_{t,j}`` is stratum ``j``'s kernel convolution of its past values,
``q_{t,i}`` the pressure on stratum ``i`` and ``C_{t,ij}`` the weight of
stratum ``j`` in stratum ``i``, with ``S`` strata (see [`PerStratum`](@ref)).
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
CR.forward!([0.9 0.1; 0.2 0.8], CR.Pressure(), q, [1.0, 2.0], 1)
q

# output

2-element Vector{Float64}:
 1.1
 1.8
```
"""
struct Pressure end

@doc raw"""
Run operator `op` over a whole call, returning `(y, cache)`.

This is the [`ComposableRecurrences.Run`](@ref) role: calling the operator
lowers to `forward(op, Run(), args...; kwargs...)`.
For inputs ``u`` it computes

```math
y = f_{\mathrm{op}}(u),
```

with ``f_{\mathrm{op}}`` the operator's own maths, and `cache` holds what
the reverse pass needs.
Couplings, modifiers and depletion forms write their outputs in place
through [`ComposableRecurrences.forward!`](@ref) instead.

# Arguments
- `op`: the operator.
- `role`: `Run()`.
- `args`: the call's arguments.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
y, cache = CR.forward(Convolution([0.5, 0.5]), CR.Run(), [1.0, 2.0, 3.0])
y

# output

3-element Vector{Float64}:
 0.5
 1.5
 2.5
```
"""
function forward end

@doc raw"""
Run `x` in `role` on primal arguments `args`, writing the outputs in place.

For the role's inputs ``u`` it computes its outputs

```math
o = f_{\mathrm{role}}(u),
```

with ``f_{\mathrm{role}}`` the map each role's docstring gives:
[`ComposableRecurrences.Step`](@ref) a modifier step ``(v, s) \mapsto (v', s')``,
[`ComposableRecurrences.Init`](@ref) an initial state from the history,
[`ComposableRecurrences.Pressure`](@ref) a coupling ``q_t = C_t p_t`` and
[`ComposableRecurrences.Trace`](@ref) a modifier's record
``r_t = R_M(v_t, s_{t-1}, v'_t, s_t)``.
The outputs are written into the leading array arguments, and the method
returns `nothing`; returning anything else is an error.
To extend the package, define a type and add this method for its role:
[`ComposableRecurrences.Step`](@ref) and [`ComposableRecurrences.Init`](@ref)
for a modifier or variant, [`ComposableRecurrences.Pressure`](@ref) for a
coupling and [`ComposableRecurrences.Trace`](@ref) for a modifier's record.
[Roles](@ref extending-roles) gives each role's arguments.

A pointwise step runs on a [`ComposableRecurrences.Device`](@ref) when it
reads and writes only `eachindex(v)` entries, and allocates nothing.

# Arguments
- `x`: the coupling, modifier or variant.
- `role`: `Step()`, `Init()`, `Pressure()` or `Trace()`.
- `args`: the role's arguments.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
struct Offset{T}
    b::T
end
CR.blocks(::Offset) = (1, 1)
function CR.forward!(m::Offset, ::CR.Step, v, s, t)
    for k in eachindex(v)
        v[k] += m.b
    end
    return nothing
end
Recurrence([0.5, 0.5]; modifiers = (Offset(1.0),))(1.0; history = ones(2), stop = 4)

# output

4-element Vector{Float64}:
 2.0
 2.5
 3.25
 3.875
```
"""
function forward! end

@doc raw"""
Accumulate the reverse pass of [`ComposableRecurrences.forward!`](@ref) for
`x` in `role`.

For `forward!` computing outputs ``o = f(u, \theta)`` from inputs ``u`` and
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
buffer `forward!` updated in place is overwritten with the cotangent of its
incoming value.
It returns `nothing`.
A pointwise or blockwise `Step` gets the same views as its `forward!`, with
`grads.v` and `grads.s` views of the same entries.
[Roles](@ref extending-roles) gives the signature and the `grads` fields for
each role, and [The gradient mirror](@ref extending-mirror)
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
- `args`: the primal arguments `forward!` was given.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
m = CR.Clamp(0.0, 1.0)
grads = (; piece = (; lo = Ref(0.0), hi = Ref(0.0)), v = [1.0], s = [0.0])
CR.pullback!(grads, m, CR.Step(), [2.0], [0.0], 1)
grads.v, grads.piece.hi[]

# output

([0.0], 1.0)
```
"""
function pullback! end

@doc raw"""
Whether modifier `m` acts on each stratum separately: whether its
[`ComposableRecurrences.blocks`](@ref) is `(1, 1)`.

A pointwise modifier's step factorises over the ``S`` strata
(see [`PerStratum`](@ref)): at absolute time ``t``, stratum ``i``'s new
value and state depend only on its own,

```math
(v'_i, s'_i) = M_i(v_i, s_i, t), \qquad i = 1, \dots, S .
```

It follows from `blocks`, which is the trait to define.

# Arguments
- `m`: the modifier.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
CR.ispointwise(CR.Clamp(0.0, 1.0)), CR.ispointwise(nothing)

# output

(true, false)
```
"""
ispointwise(m) = blocks(m) === (1, 1)

@doc raw"""
The group shape of modifier `m`: `(nv, ns)`, its values and state entries
per group, or `nothing` when its step reads the whole vectors.

A modifier with `(nv, ns)` holds ``n_v`` compartments of ``G`` groups each
in its values and ``n_s`` in its state, compartment by compartment: with
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

`(1, 1)` is a pointwise modifier ([`ComposableRecurrences.ispointwise`](@ref)),
whose groups are the strata: it implements `forward!(m, Step(), v, s, t)`
writing entry `k` of `v` and `s` from entry `k` only, for each `k` in
`eachindex(v)`.
The operator may call it on a one-entry view of stratum `k`, whose axes are
`k:k`, so a parameter read at `k` through
[`ComposableRecurrences.param`](@ref) reads the right entry; a broadcast
against a field with one entry per stratum, such as `v .*= m.w`, cannot run
on such a view.
Any other shape is blockwise: the modifier implements
`forward!(m, Step(), v, s, t, g)` with `v` and `s` tuples of one-entry views
of group `g`'s ``n_v`` values and ``n_s`` state entries, writing them in
place, and optionally `pullback!(grads, m, Step(), v, s, t, g)` with
`grads.v` and `grads.s` tuples of views, overwritten with the input
cotangents.
Both return `nothing`, and the default vector
[`ComposableRecurrences.Step`](@ref) loops the groups.
The group step reads parameters at group `g`, so a [`PerStratum`](@ref)
parameter has ``G`` entries.
`blocks` should follow from the type of `m`, not from the value of a field,
so the loops are compiled for its shape; a shape read from a field is known
only at run time.
[`ComposableRecurrences.ispointwise`](@ref) and
[`ComposableRecurrences.nstate`](@ref) follow from it.
The default is `nothing`.

# Arguments
- `m`: the modifier.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
weights = (S = 1, V = 0.3)
leaky = CR.Depletion(100.0, CR.Hazard(; weights); pools = (:S, :V))
CR.blocks(leaky), CR.blocks(CR.Clamp(0.0, 1.0)), CR.blocks(nothing)

# output

((1, 2), (1, 1), nothing)
```
"""
blocks(m) = nothing

@doc raw"""
The number of state entries modifier `m` keeps for `S` strata
(see [`PerStratum`](@ref)), from its [`ComposableRecurrences.blocks`](@ref).

The recurrence allocates each modifier's state ``s`` with

```math
|s| = n(m, S), \qquad
n(m, S) = \begin{cases} n_s S / n_v & \text{for blocks } (n_v, n_s), \\
S & \text{otherwise}, \end{cases}
```

passes it to the modifier's [`ComposableRecurrences.Init`](@ref) and
[`ComposableRecurrences.Step`](@ref), and checks a resumed state against it.
A pointwise modifier keeps one entry per stratum, and a `Depletion` with two
pools keeps the first pool then the second, ``n(m, S) = 2S``.
Of the built-ins with `blocks` `nothing`, an
[`ComposableRecurrences.Allocate`](@ref) with imports keeps its import
pattern as well, as its docstring sets out.

# Arguments
- `m`: the modifier.
- `S`: the number of strata.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
weights = (S = 1, V = 0.3)
leaky = CR.Depletion(100.0, CR.Hazard(; weights); pools = (:S, :V))
CR.nstate(CR.Clamp(0.0, 1.0), 3), CR.nstate(leaky, 3)

# output

(3, 6)
```
"""
nstate(m, S) = _blocks_nstate(_blocks(m), S)
_blocks_nstate(::Nothing, S) = S
_blocks_nstate(::Val{B}, S) where {B} = B[2] * _ngroups(Val(B), S)

# How the operator runs a modifier's step, as a static value the loops are
# compiled for: `Val((nv, ns))` runs the group kernel per group, `nothing`
# runs the step per stratum (pointwise) or on the whole vectors. It follows
# from `blocks`, which follows from the type, so this folds. A built-in may
# run a pointwise shape on its group kernel instead: `Depletion` does, for a
# one-pool kind without a step of its own (see `pool.jl`).
_blocks(m) = _static_blocks(blocks(m))
_static_blocks(::Nothing) = nothing
_static_blocks(b::Tuple) = _group_shape(Val(b))
@noinline function _static_blocks(b)
    throw(
        ArgumentError(
            "blocks(m) is nothing or a tuple (nv, ns), got $(repr(b))"
        )
    )
end
_group_shape(::Val{(1, 1)}) = nothing
_group_shape(b::Val) = b

# Whether the operator runs a modifier's step per stratum, on one-entry
# views: an execution choice, not a property of the maths, which is
# `ispointwise`. A pointwise modifier that runs a group kernel, such as a
# `Depletion` filling one pool, is pointwise but not looped per stratum.
_strata_loop(m) = blocks(m) === (1, 1) && _blocks(m) === nothing

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
            "blocks(m) is (nv, ns) with integers nv >= 1 and ns >= 0, " *
                "got $(repr(B))"
        )
    )
    return B[1]
end

# Whether a modifier's Step returns its state unchanged, so the reverse pass
# reads the state it started from instead of a record per step.
_stateless(m) = false

@doc raw"""
The number of past outputs `x` reads from a recurrence's buffer, before
the current step.

A [`Recurrence`](@ref) keeps

```math
D = \max\big(L,\ d(\text{kernel}),\ d(\text{coupling}),\ d(M_1), \dots, d(M_R)\big)
```

past outputs per stratum, where ``L`` is the kernel length, ``d`` is
`depth` and ``M_1, \dots, M_R`` are the modifiers.
The kernel reads the last ``L`` of them; the deeper rows are kept for
objects that read further back than the kernel.
A [`ComposableRecurrences.State`](@ref) holds the last ``D`` outputs, so a
resumed call reads the same past.
The default recurses by value through the fields of immutable structs,
tuples and named tuples and takes the largest.
Numbers, arrays, functions, mutable objects and operators (which keep
their own buffers) read nothing, ``d = 0``, so an object held inside an
array or a mutable struct is not counted.
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
# Mutable objects are not walked, so a cycle or an undefined field cannot
# stop a call.
@generated function _fields_depth(x)
    ismutabletype(x) && return 0
    calls = (
        :(isdefined(x, $i) ? _checked_depth(getfield(x, $i)) : 0)
            for i in 1:fieldcount(x)
    )
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
    return Int(d)::Int
end

# A modifier's shape checks against `S` strata, run once per call by its
# `Init` and on a resumed state.
_check_modifier_strata(m, S) = nothing

# Defaults: a zero initial state, and a vector step that loops the
# per-stratum or per-group step.
function forward!(m, ::Init, s, history)
    fill!(s, zero(eltype(s)))
    return nothing
end

forward!(m, ::Step, v, s, t) = _vector_step!(_blocks(m), m, v, s, t)

# The step of a pointwise modifier on stratum `k`'s value and state, as new
# scalars: its `forward!` on one-entry views of local slots, which a fully
# inlined step keeps in registers.
@inline function _step(m, v, s, t, k)
    vr, sr = _slot(m, v), _slot(m, s)
    _written(m, @inline forward!(m, Step(), _At(vr, k), _At(sr, k), t))
    return vr[], sr[]
end
# The same for its `pullback!`: the cotangents of the step's inputs from
# those of its outputs, `grads.v` and `grads.s`.
@inline function _step_back(grads, m, v, s, t, k)
    T = promote_type(typeof(grads.v), typeof(grads.s), typeof(v), typeof(s), param_eltype(m))
    v̄r, s̄r = Base.RefValue{T}(grads.v), Base.RefValue{T}(grads.s)
    g = (; piece = grads.piece, v = _At(v̄r, k), s = _At(s̄r, k))
    _written(m, @inline pullback!(g, m, Step(), _At(Ref(v), k), _At(Ref(s), k), t))
    return v̄r[], s̄r[]
end
# A slot for a scalar the step may write a value of the modifier's float type
# into, such as a dual number from a parameter.
@inline _slot(m, x) = Base.RefValue{promote_type(typeof(x), param_eltype(m))}(x)

# A step writes its outputs in place and returns `nothing`; a returned
# value is an error, not a silent no-op.
@inline _written(m, ::Nothing) = nothing
@noinline function _written(m, x)
    throw(
        ArgumentError(
            "the step of $(nameof(typeof(m))) returned a $(typeof(x)); " *
                "forward! and pullback! write their outputs in place and " *
                "return nothing"
        )
    )
end

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

# The step of a blockwise modifier on group `g`'s values and state, as new
# tuples: a built-in's kernel, or the modifier's `forward!` on tuples of
# one-entry views of local slots. Its pullback likewise.
@inline function _block_step(m, v::Tuple, s::Tuple, t, g)
    vr, sr = map(x -> _slot(m, x), v), map(x -> _slot(m, x), s)
    at = r -> _At(r, g)
    _written(m, @inline forward!(m, Step(), map(at, vr), map(at, sr), t, g))
    return map(getindex, vr), map(getindex, sr)
end
@inline function _block_back(grads, m, v::Tuple, s::Tuple, t, g)
    T = promote_type(map(typeof, (grads.v..., grads.s..., v..., s...))..., param_eltype(m))
    v̄r, s̄r = map(Base.RefValue{T}, grads.v), map(Base.RefValue{T}, grads.s)
    at = r -> _At(r, g)
    gg = (; piece = grads.piece, v = map(at, v̄r), s = map(at, s̄r))
    vv, sv = map(at ∘ Ref, v), map(at ∘ Ref, s)
    _written(m, @inline pullback!(gg, m, Step(), vv, sv, t, g))
    return map(getindex, v̄r), map(getindex, s̄r)
end

# The group step and its pullback are inlined at their calls: across a call
# boundary, plain reverse AD of the returned tuples took about 70% longer
# and the rule's reverse pass about 8% longer.
function _vector_step!(::Val{B}, m, v, s, t) where {B}
    G = _ngroups(Val(B), length(v))
    _each!(_group_body!, Serial(), v, G, G, v, s, m, t, Val(B), G)
    return nothing
end

# Group `g`'s step, gathered from and scattered back into `v` and `s`.
function _group_body!(g, v, s, m, t, ::Val{B}, G) where {B}
    nv, ns = B
    v′, s′ = @inline _block_step(
        m, _gather(v, Val(nv), G, g), _gather(s, Val(ns), G, g), t, g
    )
    _scatter!(v, v′, G, g)
    _scatter!(s, s′, G, g)
    return nothing
end

function _vector_step!(::Nothing, m, v, s, t)
    blocks(m) === (1, 1) && throw(
        ArgumentError(
            "$(typeof(m)) has blocks (1, 1), so it is pointwise and " *
                "needs forward!(m, Step(), v, s, t); a group step " *
                "forward!(m, Step(), v, s, t, g) is called only for " *
                "another shape"
        )
    )
    throw(
        ArgumentError(
            "$(typeof(m)) has no forward!(m, Step(), v, s, t), and is not " *
                "blockwise (see blocks)"
        )
    )
end

function _pointwise_body!(k, v, s, m, t)
    v[k], s[k] = _step(m, v[k], s[k], t, k)
    return nothing
end

# The vector step's pullback: the modifier's own, or per stratum or group
# for a pointwise or a blockwise modifier without one. Not a `pullback!`
# method, which would count as every modifier's own.
function _vector_pullback!(grads, m, v, s, t)
    _has_vector_pullback(m) || return _split_pullback!(_blocks(m), grads, m, v, s, t)
    return pullback!(grads, m, Step(), v, s, t)
end
function _split_pullback!(::Nothing, grads, m, v, s, t)
    _strata_loop(m) && return _strata_pullback!(grads, m, v, s, t)
    uses_adjoint(m, Step()) && return pullback!(grads, m, Step(), v, s, t)
    return _local_step_back!(grads, m, v, s, t)
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
        v̄g, s̄g = @inline _block_back(gg, m, vg, sg, t, g)
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
    _stage!(first(ms), v, first(states), t)
    return _stages!(Base.tail(ms), Base.tail(states), v, t)
end

# One modifier's step on the step's values. A pointwise modifier runs per
# stratum, as in the loops that thread one stratum's value, so the strata
# loop runs where the executor puts it, on a device too; any other on the
# whole vectors.
_stage!(m, v, s, t) = _stage!(Val(_strata_loop(m)), m, v, s, t)
_stage!(::Val{false}, m, v, s, t) = forward!(m, Step(), v, s, t)
function _stage!(::Val{true}, m, v, s, t)
    n = length(eachindex(v, s))
    _each!(_pointwise_body!, Serial(), v, n, n, v, s, m, t)
    return nothing
end
