# Draw forms that take what is asked for, up to what is left: the exact
# minimum and a smooth one. They are depletion forms, and the admission
# rule of `Capacity`.

@doc raw"""
The truncated draw form: the value asked for is drawn in full, up to what is
left in the pool.

For one stratum at one step,

```math
v' = \min\big(v,\ \max(s, 0)\big), \qquad s' = s - v',
```

where ``v`` is the value asked for, ``s`` the pool before the step, ``v'``
the value drawn and ``s'`` the pool after the step.
The population and the heterogeneity exponent are not used.
The minimum has a kink at ``v = s`` and the pool one at ``s = 0``; the
derivative takes the active branch, and the value on a tie.
[`ComposableRecurrences.SoftTruncate`](@ref) smooths both.

A form of [`ComposableRecurrences.Depletion`](@ref) and the admission rule
of [`ComposableRecurrences.Capacity`](@ref).

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
CR.forward(CR.Truncate(), CR.Step(), 2.0, 1.5, 100.0, 1.0)

# output

(1.5, 0.0)
```
"""
struct Truncate end

@doc raw"""
The smoothly truncated draw form: a smooth minimum of the value asked for
and what is left in the pool.

For one stratum at one step, with softness ``\kappa``,

```math
v' = \Big(v^{-1/\kappa} + \max(s, 0)^{-1/\kappa}\Big)^{-\kappa},
\qquad s' = s - v',
```

where ``v`` is the value asked for, ``s`` the pool before the step, ``v'``
the value drawn and ``s'`` the pool after the step; ``v' = \min(v, s)`` when
either is at most zero.
Then ``0 \le v' \le \min(v, s)``, with ``v' = 2^{-\kappa} v`` at ``v = s``,
and ``v'`` tends to the minimum as the two part or ``\kappa \to 0``.
The population and the heterogeneity exponent are not used.

# Arguments
- `κ`: the softness, with ``0 < \kappa < 1``.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
y, s = CR.forward(CR.SoftTruncate(0.1), CR.Step(), 2.0, 1.5, 100.0, 1.0)
round(y; digits = 3), round(s; digits = 3)

# output

(1.492, 0.008)
```
"""
struct SoftTruncate{K}
    "The softness κ."
    κ::K
    function SoftTruncate(κ::Real)
        0 < κ < 1 || throw(
            ArgumentError("SoftTruncate softness is between 0 and 1, got $κ")
        )
        k = float(κ)
        return new{typeof(k)}(k)
    end
end
function SoftTruncate(κ)
    throw(ArgumentError("SoftTruncate softness is a number, got $(_describe(κ))"))
end

# The draw of `v` from a free amount `f >= 0`: the minimum, or the smooth
# minimum `lo g(lo / hi)` with `g(r) = (1 + r^(1/κ))^(-κ)`. On a tie the
# exact minimum takes `v`.
_draw(::Truncate, v, f) = ifelse(v <= f, v, f)
function _draw(form::SoftTruncate, v, f)
    lo, hi = minmax(v, f)
    lo > 0 || return lo
    r = lo / hi
    return lo * (1 + r^inv(form.κ))^(-form.κ)
end

# Its pullback: the cotangents of `v`, `f` and `κ` from that of the draw.
function _draw_back(::Truncate, v, f, ȳ)
    z = zero(ȳ)
    return v <= f ? (ȳ, z, z) : (z, ȳ, z)
end
function _draw_back(form::SoftTruncate, v, f, ȳ)
    κ = form.κ
    z = zero(ȳ)
    lo, hi = minmax(v, f)
    lo > 0 || return v <= f ? (ȳ, z, z) : (z, ȳ, z)
    r = lo / hi
    rp = r^inv(κ)
    g = (1 + rp)^(-κ)
    q = rp / (1 + rp)
    l̄o = ȳ * g * (1 - q)
    h̄i = ȳ * g * q * r
    κ̄ = ȳ * lo * g * (q * log(r) / κ - log1p(rp))
    return v <= f ? (l̄o, h̄i, κ̄) : (h̄i, l̄o, κ̄)
end

const _TruncateForm = Union{Truncate, SoftTruncate}

function forward(form::_TruncateForm, ::Step, v, s, N, α)
    y = _draw(form, v, max(s, zero(s)))
    return y, s - y
end

function pullback!(grads, form::_TruncateForm, ::Step, v, s, N, α)
    ȳ, s̄′ = grads.v, grads.s
    v̄, f̄, κ̄ = _draw_back(form, v, max(s, zero(s)), ȳ - s̄′)
    _add_softness!(grads.piece, form, κ̄)
    z = zero(v̄)
    return v̄, s̄′ + ifelse(s > 0, f̄, z), z, z
end

_add_softness!(form̄, ::Truncate, κ̄) = nothing
_add_softness!(form̄, ::SoftTruncate, κ̄) = add_cotangent!(cotangent(form̄, :κ), κ̄)
