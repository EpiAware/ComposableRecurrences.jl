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
The population is not read.
The minimum has a kink at ``v = s`` and the floor one at ``s = 0``; the
derivative takes the active branch, and the value asked for on a tie.
A NaN pool gives a NaN draw.
[`ComposableRecurrences.SoftTruncate`](@ref) is a smooth version.

# Keyword Arguments
- `weights`, `into`, `overflow`: the draw's, as
  [`ComposableRecurrences.Depletion`](@ref) sets out; with any of them
  `Truncate` returns a draw rather than the form.

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
"""
struct Truncate
    function Truncate(; weights = nothing, into = nothing, overflow = nothing)
        return _drawn(new(), weights, into, overflow)
    end
end

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

# Keyword Arguments
- `weights`, `into`, `overflow`: the draw's, as
  [`ComposableRecurrences.Depletion`](@ref) sets out.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
v, s = [2.0], [2.0]
CR.forward!(CR.SoftTruncate(0.1), CR.Step(), v, s, 100.0)
round.(v; digits = 3), round.(s; digits = 3)

# output

([1.866], [0.134])
```
"""
struct SoftTruncate{K <: Real}
    "The softness κ."
    κ::K
    function SoftTruncate(
            κ::K; weights = nothing, into = nothing, overflow = nothing
        ) where {K <: Real}
        0 < κ < 1 || throw(
            ArgumentError("the softness κ is between 0 and 1, got $κ")
        )
        return _drawn(new{K}(κ), weights, into, overflow)
    end
end

function forward!(::Truncate, ::Step, v, s, N)
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
function forward!(form::SoftTruncate, ::Step, v, s, N)
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
function pullback!(grads, ::Truncate, ::Step, v, s, N)
    for k in eachindex(v, s)
        ȳ = grads.v[k] - grads.s[k]
        v̄, s̄ = _removal_pullback(v[k], s[k], ȳ)
        grads.v[k], grads.s[k] = v̄, grads.s[k] + s̄
    end
    return nothing
end
function pullback!(grads, form::SoftTruncate, ::Step, v, s, N)
    for k in eachindex(v, s)
        ȳ = grads.v[k] - grads.s[k]
        v̄, c̄, κ̄ = _soft_min_back(form.κ, v[k], _pool_left(s[k]), ȳ)
        add_cotangent!(cotangent(grads.piece, :κ), κ̄)
        grads.v[k], grads.s[k] = v̄, grads.s[k] + ifelse(s[k] > 0, c̄, zero(ȳ))
    end
    return nothing
end
_softness(::Truncate) = nothing
_softness(form::SoftTruncate) = form.κ

# The minimum of `a` and a non-negative `b`, or with softness `κ` the
# smooth minimum `m g(m / M)` with `g(r) = (1 + r^(1/κ))^(-κ)`, `m` and `M`
# the smaller and larger of the two; a non-positive `m` is returned as it
# is, and an infinite `M` gives `m`. The exact minimum is `_removal`, which
# takes `a` on a tie and returns a NaN.
_soft_min(::Nothing, a, b) = _removal(a, b)
function _soft_min(κ, a, b)
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
