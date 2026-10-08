@doc raw"""
A modifier parameter read from the recurrence's own recent outputs.

At stratum ``k`` and absolute time ``t``,

```math
u_{t,k} = \sum_{l=1}^{W} w_l\, y_{t-l,k},
```

where ``y_{t-l,k}`` is the final output of stratum ``k`` at time ``t - l``,
after every modifier, ``w_l`` the weight on lag ``l`` and ``W`` the number
of weights.
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
the outputs it read and to the weights,

```math
\bar y_{t-l,k} \mathrel{+}= w_l\, \bar u_{t,k}, \qquad
\bar w_l \mathrel{+}= y_{t-l,k}\, \bar u_{t,k},
```

inside the recurrence's own reverse pass, so the gradient follows the
feedback through the outputs.

Scope: modifier parameters of a [`Recurrence`](@ref); analytic adjoint.

# Arguments
- `w`: the weights, lag 1 first, or an integer `n` for the sum of the last
  `n` outputs.

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
"""
struct Recent{W <: AbstractVector{<:Real}}
    "The weights, lag 1 first."
    w::W
    function Recent(w::W) where {W <: AbstractVector{<:Real}}
        isempty(w) && throw(
            ArgumentError("Recent needs at least one weight; got $(_describe(w))")
        )
        return new{W}(w)
    end
end
function Recent(n::Integer)
    n >= 1 || throw(ArgumentError("Recent(n) needs n >= 1 outputs; got n = $n"))
    return Recent(fill(true, n))
end

depth(x::Recent) = length(x.w)

@noinline function param(x::Recent, k, t)
    throw(
        ArgumentError(
            "Recent($(_describe(x.w))) reads a recurrence's outputs, so it " *
                "has a value only inside a Recurrence's modifiers"
        )
    )
end

_check_param(name, x::Recent) = x
function _check_constant(name, x::Recent)
    throw(
        ArgumentError(
            "$name is one value or PerStratum($name); it does not vary over " *
                "time, got $(_describe(x))"
        )
    )
end
_float_param(x::Recent) = x

# A `Recent` bound to a call's buffer `H`, whose row `t + o` holds the
# output at absolute time `t`. In the reverse pass `H̄` is the buffer's
# cotangent, else `nothing`.
struct _BoundRecent{R <: Recent, B, G}
    x::R
    H::B
    H̄::G
    o::Int
end

function param(b::_BoundRecent, k, t)
    w, H = b.x.w, b.H
    i = t + b.o
    acc = zero(promote_type(eltype(w), eltype(H)))
    @inbounds for l in eachindex(w)
        acc += w[l] * H[i - l, k]
    end
    return acc
end

function add_param!(x̄, b::_BoundRecent, v, k, t)
    w, H = b.x.w, b.H
    w̄ = cotangent(x̄, :w)
    i = t + b.o
    @inbounds for l in eachindex(w)
        add_cotangent!(w̄, v * H[i - l, k], l)
        _add_buffer!(b.H̄, v * w[l], i - l, k)
    end
    return nothing
end
Base.@propagate_inbounds _add_buffer!(H̄, v, i, k) = (H̄[i, k] += v; nothing)
_add_buffer!(::Nothing, v, i, k) = nothing

_check_param(name, x::_BoundRecent) = x

# Whether a value of type `T` holds a `Recent`, from the type alone, so a
# piece without one is left as it is.
@generated _reads_outputs(x) = _reads_outputs_type(x)
function _reads_outputs_type(::Type{T}) where {T}
    T <: Union{Recent, _BoundRecent} && return true
    T <: Union{Number, AbstractArray, Nothing, Symbol, AbstractString} &&
        return false
    T <: Union{Type, Module} && return false
    isconcretetype(T) && isstructtype(T) || return false
    return any(_reads_outputs_type, fieldtypes(T))
end

# Bind every `Recent` inside `x` to the buffer `H` (and its cotangent `H̄`),
# rebuilding only the pieces that hold one.
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
    fs = ntuple(i -> _bind(getfield(x, i), H, H̄, o), Val(fieldcount(typeof(x))))
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
