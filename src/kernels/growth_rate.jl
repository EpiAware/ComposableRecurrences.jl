@doc raw"""
    growth_rate(R, g; lags, step = 1)

The growth rate per step ``r`` of a renewal with constant reproduction
number ``R`` and generation interval ``g``, lag 1 first.
It is the root of the Euler-Lotka equation

```math
1 = R \sum_{l \ge 1} g_l\, e^{-r l}.
```

The right side falls as ``r`` rises, so the root is unique when ``R > 0``
and the masses ``g_l`` are non-negative with a positive sum.
The root is positive when ``R \sum_l g_l > 1`` and negative when it is
below 1.
[`ComposableRecurrences.reproduction_number`](@ref) is the inverse.

A seed on the renewal's own growth path at ``R`` is
`exponential_history(I0, growth_rate(R, g), L)`, with `L = length(g)` for
masses and `L = lags - 1` for a delay (see
[`ComposableRecurrences.exponential_history`](@ref)).

The derivatives are those of the implicit function theorem,

```math
\frac{\partial r}{\partial R} = \frac{1}{R \bar{\tau}},
\qquad
\frac{\partial r}{\partial g_l} = \frac{R e^{-r l}}{\bar{\tau}},
\qquad
\bar{\tau} = R \sum_l l\, g_l e^{-r l},
```

where ``\bar{\tau}`` is the mean generation interval weighted by the
growth.

# Arguments
- `R`: the reproduction number, above 0.
- `g`: the generation interval, lag 1 first, as a vector of masses or a
  [delay](@ref ComposableRecurrences.delay_masses); not
  normalised.

# Keyword Arguments
- `lags`: for a delay only, the number of lags from lag 0, as for a
  [`Recurrence`](@ref) kernel.
- `step`: for a delay only, the width of a lag in the delay's own unit;
  `1` by default.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
g = [0.2, 0.5, 0.3]
r = CR.growth_rate(1.5, g)
h = CR.exponential_history(5.0, r, length(g))
y = vcat(h, Recurrence(g)(fill(1.5, 6); history = h))
round(r; digits = 4), all(y[2:end] ./ y[1:(end - 1)] .≈ exp(r))

# output

(0.1977, true)
```
"""
function growth_rate(R::Real, g; lags = nothing, step = 1)
    return _growth_rate(R, _interval(g, lags, step))
end

@doc raw"""
    reproduction_number(r, g; lags, step = 1)

The reproduction number ``R`` of a renewal growing at rate ``r`` per step
with generation interval ``g``, lag 1 first:

```math
R = \Big(\sum_{l \ge 1} g_l\, e^{-r l}\Big)^{-1}.
```

It is the inverse of [`ComposableRecurrences.growth_rate`](@ref), and
takes the same `g`, `lags` and `step`.

# Arguments
- `r`: the growth rate per step, a finite number.
- `g`: the generation interval, as for `growth_rate`.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
g = [0.2, 0.5, 0.3]
R = CR.reproduction_number(0.1, g)
round(R; digits = 4), CR.growth_rate(R, g) ≈ 0.1

# output

(1.2307, true)
```
"""
function reproduction_number(r::Real, g; lags = nothing, step = 1)
    return _reproduction_number(r, _interval(g, lags, step))
end

# The generation interval as masses from lag 1: a delay's masses with
# `lags`, or `g` as it is without.
function _interval(g, lags, step)
    lags === nothing || return _delay_kernel(g, lags, 1, step)
    _check_no_step(step)
    _check_no_delays(g)
    return g
end

# The root is found on the primal values and carries no derivative. Newton
# steps from it on the inputs as given carry the derivative of the implicit
# function theorem: one step gets the first derivative exact and each step
# doubles the order, so two get the Hessian exact too.
function _growth_rate(R::Real, g::AbstractVector{<:Real})
    _check_reproduction(R)
    lags = _mass_span(g)
    r = _growth_root(R, g, lags)
    return _newton_step(_newton_step(r, R, g, lags), R, g, lags)
end
function _newton_step(r, R, g, lags)
    f, τ = _lotka(r, g, lags)
    return r + (log(R) + f) / τ
end
_growth_rate(R, g) = _not_masses(:growth_rate, g)

function _reproduction_number(r::Real, g::AbstractVector{<:Real})
    isfinite(_primal_value(r)) || throw(
        ArgumentError(
            "reproduction_number needs a finite growth rate r; got r = $r"
        )
    )
    logm, _ = _lotka(r, g, _mass_span(g))
    return exp(-logm)
end
_reproduction_number(r, g) = _not_masses(:reproduction_number, g)

@noinline function _not_masses(f, g)
    throw(
        ArgumentError(
            "$f takes one generation interval, lag 1 first, as a vector of " *
                "masses or a delay with `lags`; got $(_describe(g))"
        )
    )
end

function _check_reproduction(R)
    R0 = _primal_value(R)
    0 < R0 < Inf || throw(
        ArgumentError(
            "growth_rate needs a finite reproduction number R > 0; got R = $R0"
        )
    )
    return nothing
end

# The lags from the first to the last with positive mass, after checking
# that every mass is finite and non-negative and that some mass is positive.
function _mass_span(g::AbstractVector)
    lo, hi = 0, 0
    for (l, i) in enumerate(eachindex(g))
        gl = _primal_value(g[i])
        0 <= gl < Inf ||
            _mass_error("must have finite, non-negative masses; got $gl on lag $l")
        gl > 0 || continue
        lo == 0 && (lo = l)
        hi = l
    end
    lo > 0 || _mass_error(
        "needs positive mass on some lag; " *
            (isempty(g) ? "it has no lags" : "all $(length(g)) lags are zero")
    )
    return lo:hi
end
@noinline function _mass_error(problem)
    throw(ArgumentError("the generation interval g " * problem))
end

# The log of `∑ g_l e^{-r l}` over the lags `over`, and the mean lag, minus
# its derivative in `r`. `over` is the lags with mass for the root and every
# lag for the derivative, which lags without mass carry too; `v` maps each
# mass, to its primal value for the root. Scaling by `e^{r a}` keeps the
# terms with mass from overflowing, and the cap keeps the derivative on a
# lag without mass finite, though below its true value once `r` times the
# distance to the nearest lag with mass passes the cap, about 354 in Float64.
function _lotka(r, g, lags, over = Base.OneTo(length(g)), v = identity)
    o = firstindex(g) - 1
    a = _primal_value(r) < 0 ? last(lags) : first(lags)
    cap = _exp_cap(_primal_type(typeof(r)))
    w = v(g[o + first(over)]) * exp(min(-r * (first(over) - a), cap))
    m, τ = w, first(over) * w
    for l in (first(over) + 1):last(over)
        w = v(g[o + l]) * exp(min(-r * (l - a), cap))
        m += w
        τ += l * w
    end
    return log(m) - r * a, τ / m
end
_exp_cap(::Type{T}) where {T <: AbstractFloat} = log(floatmax(T)) / 2
_exp_cap(::Type) = _exp_cap(Float64)

# The root on the primal values, by Newton steps on `log(R ∑ g_l e^{-r l})`,
# which is convex and falling in `r`.
const _NEWTON_STEPS = 100
function _growth_root(R, g, lags)
    logR = log(_primal_value(R))
    o = firstindex(g) - 1
    s = μ = zero(float(_primal_value(first(g))))
    for l in lags
        gl = _primal_value(g[o + l])
        s += gl
        μ += l * gl
    end
    μ /= s
    c = logR + log(s)
    # Jensen's inequality puts `c / μ` below the root, and the first or last
    # lag with mass bounds it above. From below, each step rises towards the
    # root, so the loop stops once a step does not rise or passes the bound.
    r = c / μ
    upper = c / (c > 0 ? first(lags) : last(lags))
    for _ in 1:_NEWTON_STEPS
        f, τ = _lotka(r, g, lags, lags, _primal_value)
        next = r + (logR + f) / τ
        r < next <= upper || break
        r = next
    end
    return r
end
