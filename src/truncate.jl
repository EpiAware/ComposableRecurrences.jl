# Draw forms that take the value asked for up to what the pool holds: the
# exact minimum and a smooth one.

@doc raw"""
The truncated depletion form: the value is drawn in full while the pool
holds it, and the pool is drawn down to zero otherwise.

For one stratum at one step,

```math
v' = \min\big(v,\ \max(s, 0)\big), \qquad s' = s - v',
```

where ``v`` is the value asked for, ``s`` the pool before the step, ``v'``
the value drawn and ``s'`` the pool after the step.
The population and the heterogeneity exponent are not read.
The minimum has a kink at ``v = s`` and the floor one at ``s = 0``; the
derivative takes the active branch, and the pool on a tie.
[`ComposableRecurrences.SoftTruncate`](@ref) is a smooth version.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
CR.forward(CR.Truncate(), CR.Step(), 2.0, 80.0, 100.0, 1.0),
CR.forward(CR.Truncate(), CR.Step(), 2.0, 1.5, 100.0, 1.0)

# output

((2.0, 78.0), (1.5, 0.0))
```
"""
struct Truncate end

@doc raw"""
The smoothly truncated depletion form: as
[`ComposableRecurrences.Truncate`](@ref), with the minimum replaced by a
smooth one of softness ``\kappa``.

For one stratum at one step, with ``c = \max(s, 0)``,

```math
v' = \Big(v^{-1/\kappa} + c^{-1/\kappa}\Big)^{-\kappa}, \qquad s' = s - v',
```

where ``v \ge 0`` is the value asked for, ``s`` the pool before the step,
``v'`` the value drawn and ``s'`` the pool after the step; ``v' = 0`` when
``v`` or ``c`` is zero.
Then ``0 \le v' \le \min(v, c)``, with ``v' = 2^{-\kappa} v`` at ``v = c``,
and ``v'`` tends to the minimum as ``\kappa \to 0`` or as ``v`` and ``c``
part.
A non-positive value is drawn as it is.
The floor at ``s = 0`` keeps its kink.

# Arguments
- `κ`: the softness, with ``0 < \kappa < 1``.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
y, s = CR.forward(CR.SoftTruncate(0.1), CR.Step(), 2.0, 2.0, 100.0, 1.0)
round(y; digits = 3), round(s; digits = 3)

# output

(1.866, 0.134)
```
"""
struct SoftTruncate{K <: Real}
    "The softness κ."
    κ::K
    function SoftTruncate(κ::K) where {K <: Real}
        0 < κ < 1 || throw(
            ArgumentError("the softness κ is between 0 and 1, got $κ")
        )
        return new{K}(κ)
    end
end

function forward(form::Union{Truncate, SoftTruncate}, ::Step, v, s, N, α)
    y = _soft_min(_softness(form), v, _pool_left(s))
    return y, s - y
end

# What the pool holds, `max(s, 0)`. The arms follow primal values here and
# in the minimum, so dual numbers take the arm the pullback takes.
_pool_left(s) = ifelse(_primal_value(s) > 0, s, zero(s))

# The cotangents of `(v, s, N, α)`; the form's softness takes its own.
function pullback!(grads, form::Union{Truncate, SoftTruncate}, ::Step, v, s, N, α)
    ȳ = grads.v - grads.s
    v̄, c̄, κ̄ = _soft_min_back(_softness(form), v, _pool_left(s), ȳ)
    add_cotangent!(cotangent(grads.piece, :κ), κ̄)
    z = zero(ȳ)
    return v̄, grads.s + ifelse(s > 0, c̄, z), z, z
end
_softness(::Truncate) = nothing
_softness(form::SoftTruncate) = form.κ

# The minimum of `a` and `b`, or with softness `κ` the smooth minimum
# `m g(m / M)` with `g(r) = (1 + r^(1/κ))^(-κ)`, `m` and `M` the smaller and
# larger of the two; a non-positive `m` is returned as it is, and an
# infinite `M` gives `m`. On a tie the exact minimum takes `b`.
_takes_first(a, b) = _primal_value(a) < _primal_value(b)
_soft_min(::Nothing, a, b) = ifelse(_takes_first(a, b), a, b)
function _soft_min(κ, a, b)
    lo, hi = _takes_first(a, b) ? (a, b) : (b, a)
    _primal_value(lo) > 0 || return lo
    isinf(_primal_value(hi)) && return lo
    r = lo / hi
    return lo * (1 + r^inv(κ))^(-κ)
end

# Its pullback: the cotangents of `a`, `b` and `κ` from that of the result.
function _soft_min_back(::Nothing, a, b, ȳ)
    z = zero(ȳ)
    return _takes_first(a, b) ? (ȳ, z, z) : (z, ȳ, z)
end
function _soft_min_back(κ, a, b, ȳ)
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
