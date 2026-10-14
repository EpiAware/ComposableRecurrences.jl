@doc raw"""
A modifier parameter read from the recurrence's own recent outputs.

At stratum ``k`` and absolute time ``t``,

```math
u_{t,k} = \sum_{l=1}^{W} w_l\, y_{t-l,k}
\qquad \text{or, with a coupling,} \qquad
u_{t,k} = \sum_{j=1}^{S} C_{kj} \sum_{l=1}^{W} w_l\, y_{t-l,j},
```

where ``y_{t-l,k}`` is the final output of stratum ``k`` at time ``t - l``,
after every modifier, ``w_l`` the weight on lag ``l``, ``W`` the number of
weights and ``C`` the `S × S` coupling, ``C_{kj}`` weighting stratum ``j``
in stratum ``k``.
A coupling of ones reads the total over strata, and a contact matrix the
incidence each stratum sees.
`Recent(n)` with an integer `n` sums the last `n` outputs, ``w_l = 1``.
Outputs before the history are zero.

A `Recent` goes wherever a modifier takes a parameter, alone or inside a
[`Derived`](@ref).
Arithmetic with a `Recent` on either side builds a `Derived`, so
`κ * Recent(7)` and `Derived(exp, -κ * Recent(7))` work.
The [`Recurrence`](@ref) binds it to its outputs once per call and keeps at
least ``W`` past outputs (see [`ComposableRecurrences.depth`](@ref)).
Outside a recurrence it has no outputs to read, and
[`ComposableRecurrences.param`](@ref) throws.

The reverse pass sends the cotangent ``\bar u_{t,k}`` of the value read to
the outputs it read, the weights and the coupling,

```math
\bar y_{t-l,j} \mathrel{+}= C_{kj}\, w_l\, \bar u_{t,k}, \qquad
\bar w_l \mathrel{+}= \sum_{j} C_{kj}\, y_{t-l,j}\, \bar u_{t,k}, \qquad
\bar C_{kj} \mathrel{+}= \sum_{l} w_l\, y_{t-l,j}\, \bar u_{t,k},
```

with ``C = I`` without a coupling.
These run inside the recurrence's own reverse pass, so the gradient
follows the feedback through the outputs.

Scope: modifier parameters of a [`Recurrence`](@ref); analytic adjoint.

# Arguments
- `w`: the weights, lag 1 first, or an integer `n` for the sum of the last
  `n` outputs.

# Keyword Arguments
- `coupling`: `nothing` to read each stratum's own outputs, or an `S × S`
  matrix mixing them; `Recent(w, C)` is the same as `Recent(w; coupling = C)`.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
# Transmission falls as the last week's incidence grows.
β = Derived(exp, -0.05 * Recent(7))
r = Recurrence([0.2, 0.5, 0.3]; modifiers = (CR.Transform(*, β),))
round.(r(fill(2.0, 8); history = ones(3)); digits = 3)

# output

8-element Vector{Float64}:
 1.721
 1.807
 2.196
 2.404
 2.432
 2.505
 2.414
 2.273
```

```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
# Each of two places responds to the incidence in both.
C = [0.8 0.2; 0.2 0.8]
β = Derived(exp, -0.05 * Recent(7; coupling = C))
r = Recurrence([0.2, 0.5, 0.3]; modifiers = (CR.Transform(*, β),))
round.(r([2.0 2.0 2.0; 1.0 1.0 1.0]; history = ones(2, 3)); digits = 3)

# output

2×3 Matrix{Float64}:
 1.721  1.823  2.241
 0.861  0.795  0.691
```
"""
struct Recent{W <: AbstractVector{<:Real}, C}
    "The weights, lag 1 first."
    w::W
    "The coupling, `nothing` or an `S × S` matrix."
    coupling::C
    function Recent(w::W, coupling::C) where {W <: AbstractVector{<:Real}, C}
        isempty(w) && throw(
            ArgumentError("Recent needs at least one weight; got $(_describe(w))")
        )
        coupling === nothing || coupling isa AbstractMatrix{<:Real} || throw(
            ArgumentError(
                "Recent's coupling is nothing or an S × S matrix; got " *
                    _describe(coupling)
            )
        )
        return new{W, C}(w, coupling)
    end
end
Recent(w::AbstractVector{<:Real}; coupling = nothing) = Recent(w, coupling)
Recent(n::Integer; coupling = nothing) = Recent(n, coupling)
function Recent(n::Integer, coupling)
    n >= 1 || throw(ArgumentError("Recent(n) needs n >= 1 outputs; got n = $n"))
    return Recent(fill(true, n), coupling)
end

# A short description for errors: the weights and the coupling's size.
function _describe(x::Recent)
    C = x.coupling === nothing ? "" : "; coupling $(join(size(x.coupling), " × "))"
    return "Recent($(length(x.w)) weights$C)"
end

depth(x::Recent) = length(x.w)

# A `Recent` has a value only once a recurrence binds it to its outputs.
param(x::Recent, k, t) = _unbound(x)
add_param!(x̄, x::Recent, v, k, t) = _unbound(x)
@noinline function _unbound(x::Recent)
    throw(
        ArgumentError(
            "$(_describe(x)) reads a recurrence's outputs, so it " *
                "has a value only inside a Recurrence's modifiers, held in " *
                "immutable fields of concrete type"
        )
    )
end

_check_param(name, x::Recent) = x
_check_constant(name, x::Recent) = _not_constant_error(name, x)
_float_param(x::Recent) = x

# A `Recent` bound to a call's buffer `H`, whose row `t + o` holds the
# output at absolute time `t`. In the reverse pass `H̄` is the buffer's
# cotangent, else `nothing`. Binding checks the coupling against the
# buffer's strata.
#
# With a coupling, every stratum's read at a step mixes the same `S`
# windows, so the recurrence fills them once per step into `u`
# (`_refresh!`, run serially before the strata read them) and `row` names
# the buffer row they belong to. In the reverse pass each read adds the
# cotangent of the windows into `z`, and `_flush!` sends it to the buffer
# and the weights once per step, into the weights' mirror kept in `w̄`
# (with no `H̄`, only into the weights). Without a coupling these are
# `nothing`.
struct _BoundRecent{R <: Recent, B, G, U, I, Z, M}
    x::R
    H::B
    H̄::G
    o::Int
    u::U
    row::I
    z::Z
    w̄::M
    function _BoundRecent(
            x::R, H::B, H̄::G, o, u::U, row::I, z::Z, w̄::M
        ) where {R <: Recent, B, G, U, I, Z, M}
        return new{R, B, G, U, I, Z, M}(x, H, H̄, o, u, row, z, w̄)
    end
end
function _BoundRecent(x::Recent, H, H̄, o)
    C = x.coupling
    _check_recent_strata(C, size(H, 2))
    return _BoundRecent(
        x, H, H̄, o, _window_cache(C, H), _row_slot(C), _window_cache(C, H),
        _mirror_slot(C)
    )
end
_window_cache(::Nothing, H) = nothing
_window_cache(C, H) = _zeros(H, eltype(H), size(H, 2))
_row_slot(::Nothing) = nothing
_row_slot(C) = Ref(0)
# The weights' mirror is first seen when a read's cotangent arrives.
_mirror_slot(::Nothing) = nothing
_mirror_slot(C) = Ref{Any}(nothing)
_check_recent_strata(::Nothing, S) = nothing
function _check_recent_strata(C, S)
    size(C) == (S, S) || throw(
        DimensionMismatch(
            "Recent's coupling is $(join(size(C), " × ")); expected $S × $S"
        )
    )
    return nothing
end

param(b::_BoundRecent, k, t) = _read(b.x.coupling, b, k, _recent_row(b, k, t))

# Stratum `j`'s weighted window ending before row `i`.
function _recent_window(w, H, i, j)
    acc = zero(promote_type(eltype(w), eltype(H)))
    @inbounds for l in eachindex(w)
        acc += w[l] * H[i - l, j]
    end
    return acc
end
_read(::Nothing, b, k, i) = _recent_window(b.x.w, b.H, i, k)
function _read(C, b, k, i)
    acc = zero(promote_type(eltype(C), eltype(b.x.w), eltype(b.H)))
    if _cached(b, i)
        u = b.u
        for j in axes(b.H, 2)
            acc += C[k, j] * u[j]
        end
    else
        # A read outside the step being run, such as from an `Init`.
        for j in axes(b.H, 2)
            acc += C[k, j] * _recent_window(b.x.w, b.H, i, j)
        end
    end
    return acc
end

function add_param!(x̄, b::_BoundRecent, v, k, t)
    i = _recent_row(b, k, t)
    _read_back!(x̄, b.x.coupling, b, v, k, i)
    return nothing
end
function _read_back!(x̄, ::Nothing, b, v, k, i)
    return _recent_back!(cotangent(x̄, :w), b.x.w, b.H, b.H̄, v, i, k)
end
function _read_back!(x̄, C, b, v, k, i)
    # A read at a row other than the cached one, which the recurrence does
    # not make, first sends on the cached row's cotangents and caches row `i`.
    b.row[] == i || (_flush_one!(b); _refresh_one!(b, i))
    C̄ = cotangent(x̄, :coupling)
    u, z = b.u, b.z
    b.w̄[] = cotangent(x̄, :w)
    for j in axes(b.H, 2)
        _add_entry!(C̄, C, v * u[j], k, j)
        z[j] += v * C[k, j]
    end
    return nothing
end

# Fill the windows of every coupled `Recent` in `x` at buffer row `i`, once
# per step and before the strata read them.
_refresh!(x, i) = _each_coupled(b -> _refresh_one!(b, i), x)
function _refresh_one!(b::_BoundRecent, i)
    u, w, H = b.u, b.x.w, b.H
    for j in axes(H, 2)
        u[j] = _recent_window(w, H, i, j)
    end
    _cache_row!(b, i)
    return nothing
end

# Whether the windows in `u` are those of buffer row `i`, and marking them
# as row `i`'s once filled.
_cached(b::_BoundRecent, i) = b.row[] == i
_cache_row!(b::_BoundRecent, i) = (b.row[] = i; nothing)

# Send the cotangents the reads of a step added into `z` to the buffer and
# the weights, then clear them.
_flush!(x) = _each_coupled(_flush_one!, x)
function _flush_one!(b::_BoundRecent)
    z, i = b.z, b.row[]
    i > 0 || return nothing
    _flush_weights!(b.w̄[], z, b.x.w, b.H, i)
    for j in eachindex(z)
        _recent_back!(nothing, b.x.w, b.H, b.H̄, z[j], i, j)
        z[j] = zero(eltype(z))
    end
    return nothing
end
# The weights' cotangent, `w̄_l += Σ_j z_j y_{i-l,j}`; behind a function
# barrier, as the mirror's type is known only once a read stores it.
_flush_weights!(::Nothing, z, w, H, i) = nothing
function _flush_weights!(w̄, z, w, H, i)
    for j in eachindex(z), l in eachindex(w)
        add_cotangent!(w̄, z[j] * H[i - l, j], l)
    end
    return nothing
end

# Apply `f` to every bound `Recent` with a coupling inside `x`, walking only
# values whose type holds one.
_each_coupled(f, x) = _each_coupled(Val(_reads_across(x)), f, x)
_each_coupled(::Val{false}, f, x) = nothing
_each_coupled(::Val{true}, f, x::_BoundRecent) = (f(x); nothing)
function _each_coupled(::Val{true}, f, x::Union{Tuple, NamedTuple})
    foreach(y -> _each_coupled(f, y), values(x))
    return nothing
end
function _each_coupled(::Val{true}, f, x)
    foreach(y -> _each_coupled(f, y), Tuple(ConstructionBase.getfields(x)))
    return nothing
end
function _recent_back!(w̄, w, H, H̄, v, i, j)
    @inbounds for l in eachindex(w)
        add_cotangent!(w̄, v * H[i - l, j], l)
        _add_buffer!(H̄, v * w[l], i - l, j)
    end
    return nothing
end
# The buffer row of time `t`, checked once so the loops over the window
# read without bounds checks: a read at a time before the run's window,
# such as from a modifier's `Init`, is an error.
function _recent_row(b::_BoundRecent, k, t)
    i = t + b.o
    W = length(b.x.w)
    i - W >= 1 && i - 1 <= size(b.H, 1) || _before_window(b, t)
    checkbounds(b.H, i - 1, k)
    return i
end
@noinline function _before_window(b::_BoundRecent, t)
    W = length(b.x.w)
    t0 = W + 1 - b.o
    throw(
        ArgumentError(
            "Recent with $W weights was read at time $t, but this call keeps " *
                "outputs only for reads from time $t0 on; a modifier's " *
                "Init reads its parameters at time 1, so start the run at 1"
        )
    )
end

Base.@propagate_inbounds _add_buffer!(H̄, v, i, k) = (H̄[i, k] += v; nothing)
_add_buffer!(::Nothing, v, i, k) = nothing

_check_param(name, x::_BoundRecent) = x

# Whether a value of type `T` holds a value that `leaf` decides, from the
# type alone: `leaf(T)` is `true` or `false` for a type it decides and
# `nothing` otherwise, in which case the fields are walked.
function _holds_type(leaf, ::Type{T}) where {T}
    r = leaf(T)
    r === nothing || return r
    T <: Union{Number, AbstractArray, Nothing, Symbol, AbstractString} &&
        return false
    # Types, modules and functions are leaves, as for `depth`.
    T <: Union{Type, Module, Function} && return false
    # Mutable objects are not walked, as `depth` does not walk them.
    ismutabletype(T) && return false
    isconcretetype(T) && isstructtype(T) || return false
    return any(F -> _holds_type(leaf, F), fieldtypes(T))
end

# Whether a value of type `T` holds a `Recent`, so a value without one is
# left as it is.
@generated _reads_outputs(x) = _holds_type(_outputs_leaf, x)
_outputs_leaf(::Type{T}) where {T} = T <: Union{Recent, _BoundRecent} || nothing

# Whether a value of type `T` holds a `Recent` with a coupling, which reads
# other strata's outputs, so the strata cannot run on their own.
@generated _reads_across(x) = _holds_type(_across_leaf, x)
function _across_leaf(::Type{T}) where {T}
    T <: Recent || return nothing
    return !(fieldtype(T, :coupling) <: Nothing)
end

# Bind every `Recent` inside `x` to the buffer `H` (and its cotangent `H̄`),
# rebuilding only the values that hold one.
_bind(x, H, H̄, o) = _bind(Val(_reads_outputs(x)), x, H, H̄, o)
_bind(::Val{false}, x, H, H̄, o) = x
_bind(::Val{true}, x::Recent, H, H̄, o) = _BoundRecent(x, H, H̄, o)
_bind(::Val{true}, x::_BoundRecent, H, H̄, o) = _BoundRecent(x.x, H, H̄, o)
_bind(::Val{true}, x::Tuple, H, H̄, o) = map(y -> _bind(y, H, H̄, o), x)
function _bind(::Val{true}, x::NamedTuple{K}, H, H̄, o) where {K}
    return NamedTuple{K}(_bind(Tuple(x), H, H̄, o))
end
function _bind(::Val{true}, x::Derived, H, H̄, o)
    return Derived(x.f, _bind(x.args, H, H̄, o))
end
function _bind(::Val{true}, x, H, H̄, o)
    fs = map(f -> _bind(f, H, H̄, o), Tuple(ConstructionBase.getfields(x)))
    return constructorof(typeof(x))(fs...)
end

# Arithmetic with a `Recent` on either side lowers to `Derived`.
for op in (:+, :-, :*, :/, :^)
    @eval begin
        Base.$op(a::Recent, b::Union{_Param, Recent}) = Derived($op, a, b)
        Base.$op(a::Union{_Param, Recent}, b::Recent) = Derived($op, a, b)
        Base.$op(a::Recent, b::Recent) = Derived($op, a, b)
    end
end
Base.:-(a::Recent) = Derived(-, a)

# The mirrors of a parameter's arguments. Without a mirror the cotangent of
# an argument that reads the outputs must still reach the buffer, so each
# argument gets a `nothing` mirror; otherwise there is nothing to add.
_arg_mirrors(ā, args) = ā
_arg_mirrors(::Nothing, args) = _no_mirrors(Val(_reads_outputs(args)), args)
_no_mirrors(::Val{false}, args) = nothing
_no_mirrors(::Val{true}, args) = map(_ -> nothing, Tuple(args))
