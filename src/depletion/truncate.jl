# Draw forms that take the value asked for up to what the pool holds: the
# exact minimum and a smooth one.

@doc raw"""
The truncated depletion form: the value is drawn in full while the pool
holds it, and the pool is drawn down to zero otherwise.

For one stratum at one step, with ``c = \max(s, 0)``,

```math
v' = \min(v, c), \qquad s' = s - v',
```

where ``v`` is the value asked for, ``s`` the pool before the step, ``v'``
the value drawn and ``s'`` the pool after the step.
The population is not read.
The minimum has a kink at ``v = c`` and the floor one at ``s = 0``; the
derivative takes the active branch, and the value asked for on a tie.
A NaN pool gives a NaN draw.

`Truncate(κ)` replaces the minimum by a smooth one of softness ``\kappa``:

```math
v' = \Big(v^{-1/\kappa} + c^{-1/\kappa}\Big)^{-\kappa},
```

with ``v \ge 0`` and ``v' = 0`` when ``v`` or ``c`` is zero.
Then ``0 \le v' \le \min(v, c)``, with ``v' = 2^{-\kappa} v`` at
``v = c``, and ``v'`` tends to the minimum as ``\kappa \to 0`` or as ``v``
and ``c`` part.
A non-positive value is drawn as it is, and the floor at ``s = 0`` keeps
its kink.
``\kappa = 0`` is the exact minimum; `Truncate()` is that form with no
softness to differentiate.

# Arguments
- `κ`: the softness, with ``0 \le \kappa < 1``; omitted for the exact
  minimum.

# Keyword Arguments
- `weights`, `into`, `overflow`: the form's arguments as a draw in a
  [`ComposableRecurrences.Depletion`](@ref): each pool's weight, the pool
  it fills and where what it leaves goes.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
v, s = [2.0, 2.0], [80.0, 1.5]
CR.forward!(CR.Truncate(), CR.Step(), v, s, 100.0)
v, s

# output

([2.0, 1.5], [78.0, 0.0])
```

```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
v, s = [2.0], [2.0]
CR.forward!(CR.Truncate(0.1), CR.Step(), v, s, 100.0)
round.(v; digits = 3), round.(s; digits = 3)

# output

([1.866], [0.134])
```
"""
struct Truncate{K, W, I, O}
    "The softness κ, or `nothing` for the exact minimum."
    κ::K
    "As a draw, each pool's weight by name, or `nothing`."
    weights::W
    "As a draw, the pool it fills, or `nothing`."
    into::I
    "As a draw, where what it leaves goes."
    overflow::O
    function Truncate(κ::K, weights::W, into::I, overflow::O) where {K, W, I, O}
        _check_softness(κ)
        return new{K, W, I, O}(κ, weights, into, overflow)
    end
end
function Truncate(κ = nothing; weights = nothing, into = nothing, overflow = nothing)
    return Truncate(κ, weights, into, _overflow(overflow))
end

_check_softness(::Nothing) = nothing
function _check_softness(κ::Real)
    0 <= κ < 1 || throw(ArgumentError("the softness κ is in [0, 1), got $κ"))
    return nothing
end
@noinline function _check_softness(κ)
    throw(ArgumentError("the softness κ is a number or nothing, got $(_describe(κ))"))
end

# The exact and the smooth form, told apart by the type of the softness.
const _HardTruncate = Truncate{Nothing}
const _SoftTruncate = Truncate{<:Real}

const _TruncateForm = Truncate
# The built-in forms, without a method lookup at run time.
_is_form(::Type{<:Union{_ExponentForm, _TruncateForm}}) = true
_draw_args(form::_TruncateForm) = (form.weights, form.into, form.overflow)
_bare(form::Truncate) = Truncate(form.κ)

# Printed as written.
function Base.show(io::IO, form::Truncate)
    show(io, Truncate)
    print(io, "(")
    form.κ === nothing || print(io, form.κ)
    _show_draw_args(io, form)
    print(io, ")")
    return nothing
end

function forward!(::_HardTruncate, ::Step, v, s, N)
    for k in eachindex(v, s)
        vk, sk = promote(v[k], s[k])
        y = _removal(vk, sk)
        v[k], s[k] = y, sk - y
    end
    return nothing
end

# The softness goes to the smooth minimum in its own type: promoted with the
# value and pool to a dual number first, the step took about 20% longer in
# forward mode.
function forward!(form::_SoftTruncate, ::Step, v, s, N)
    for k in eachindex(v, s)
        vk, sk = promote(v[k], s[k])
        y = _soft_min(form.κ, vk, _pool_left(sk))
        v[k], s[k] = y, sk - y
    end
    return nothing
end

# What the pool holds, `max(s, 0)`, on the arm of the primal value, as in
# `_removal`.
_pool_left(s) = ifelse(_primal_value(s) > 0, s, zero(s))

# The cotangents of `v` and `s`; neither form reads `N`, and the softness
# takes its own.
function pullback!(grads, ::_HardTruncate, ::Step, v, s, N)
    for k in eachindex(v, s)
        ȳ = grads.v[k] - grads.s[k]
        v̄, s̄ = _removal_pullback(v[k], s[k], ȳ)
        grads.v[k], grads.s[k] = v̄, grads.s[k] + s̄
    end
    return nothing
end
function pullback!(grads, form::_SoftTruncate, ::Step, v, s, N)
    for k in eachindex(v, s)
        ȳ = grads.v[k] - grads.s[k]
        v̄, c̄, κ̄ = _soft_min_back(form.κ, v[k], _pool_left(s[k]), ȳ)
        add_cotangent!(cotangent(grads.piece, :κ), κ̄)
        grads.v[k], grads.s[k] = v̄, grads.s[k] + ifelse(s[k] > 0, c̄, zero(ȳ))
    end
    return nothing
end
_softness(form::Truncate) = form.κ

# The minimum of `a` and a non-negative `b`, or with softness `κ` the
# smooth minimum `m g(m / M)` with `g(r) = (1 + r^(1/κ))^(-κ)`, `m` and `M`
# the smaller and larger of the two; a non-positive `m` is returned as it
# is, and an infinite `M` gives `m`. The exact minimum, for no softness or
# a zero one, is `_removal`, which takes `a` on a tie and returns a NaN.
_soft_min(::Nothing, a, b) = _removal(a, b)
function _soft_min(κ, a, b)
    iszero(_primal_value(κ)) && return _soft_min(nothing, a, b)
    a, b, κ = promote(a, b, κ)
    lo, hi = _takes_first(a, b) ? (a, b) : (b, a)
    _primal_value(lo) > 0 || return lo
    isinf(_primal_value(hi)) && return lo
    r = lo / hi
    return lo * (1 + r^inv(κ))^(-κ)
end
_takes_first(a, b) = _primal_value(a) <= _primal_value(b)

# Its pullback: the cotangents of `a`, `b` and `κ` from that of the result.
function _soft_min_back(::Nothing, a, b, ȳ)
    ā, b̄ = _removal_pullback(a, b, ȳ)
    return ā, b̄, zero(ȳ)
end
function _soft_min_back(κ, a, b, ȳ)
    iszero(_primal_value(κ)) && return _soft_min_back(nothing, a, b, ȳ)
    z = zero(ȳ)
    first = _takes_first(a, b)
    lo, hi = first ? (a, b) : (b, a)
    lo > 0 && !isinf(hi) || return first ? (ȳ, z, z) : (z, ȳ, z)
    r = lo / hi
    rp = r^inv(κ)
    g = (1 + rp)^(-κ)
    q = rp / (1 + rp)
    l̄o = ȳ * g * (1 - q)
    h̄i = ȳ * g * q * r
    κ̄ = ȳ * lo * g * (q * log(r) / κ - log1p(rp))
    return first ? (l̄o, h̄i, κ̄) : (h̄i, l̄o, κ̄)
end

@implements PieceInterface{(:pullback,)} Truncate [
    Arguments(; piece = Truncate(), role = Step(), args = ([2.0], [1.5], 100.0)),
    # An integer `N`, as a count of a population gives it.
    Arguments(; piece = Truncate(), role = Step(), args = ([2.0], [1.5], 100)),
    Arguments(; piece = Truncate(0.1), role = Step(), args = ([2.0], [1.5], 100.0)),
    Arguments(; piece = Truncate(0.0), role = Step(), args = ([2.0], [1.5], 100.0)),
]

# The interface check of a built-in depletion form's draw takes any real `N`.
const _BuiltinForm = Union{_ExponentForm, _TruncateForm}
function _pullback_matches(f::_BuiltinForm, ::Step, args::Tuple{Any, Any, Any})
    return _form_pullback_matches(f, args)
end
function _pullback_matches(f::_BuiltinForm, ::Step, args::Tuple{Any, Any, AbstractFloat})
    return _form_pullback_matches(f, args)
end
