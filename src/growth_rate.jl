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
  delay (see [`ComposableRecurrences.delay_masses`](@ref)); not
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
y = Recurrence(g)(fill(1.5, 6); history = h, prepend = true)
round(r; digits = 4), all(y[2:end] ./ y[1:(end - 1)] .≈ exp(r))

# output

(0.1977, true)
```
"""
function growth_rate(R::Real, g; lags = nothing, step = 1)
    lags === nothing || return growth_rate(R, _delay_kernel(g, lags, 1, step))
    _check_no_step(step)
    _check_no_delays(g)
    return _growth_rate(R, g)
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
- `g`: the generation interval, lag 1 first, as a vector of masses or a
  delay (see [`ComposableRecurrences.delay_masses`](@ref)).

# Keyword Arguments
- `lags`: for a delay only, the number of lags from lag 0.
- `step`: for a delay only, the width of a lag in the delay's own unit;
  `1` by default.

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
    lags === nothing ||
        return reproduction_number(r, _delay_kernel(g, lags, 1, step))
    _check_no_step(step)
    _check_no_delays(g)
    return _reproduction_number(r, g)
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
        0 <= gl < Inf || _bad_mass(l, gl)
        gl > 0 || continue
        lo == 0 && (lo = l)
        hi = l
    end
    lo > 0 || _no_mass(length(g))
    return lo:hi
end
@noinline function _no_mass(n)
    throw(
        ArgumentError(
            "the generation interval g needs positive mass on some lag; " *
                (n == 0 ? "it has no lags" : "all $n lags are zero")
        )
    )
end
@noinline function _bad_mass(l, gl)
    throw(
        ArgumentError(
            "the generation interval g must have finite, non-negative masses; " *
                "got $gl on lag $l"
        )
    )
end

# The log of `∑ g_l e^{-r l}` and the mean lag under the weights
# `g_l e^{-r l}`, which is minus its derivative in `r`, summed over the lags
# `over`. Each term is scaled by `e^{r a}`, with `a` the first lag with mass
# where `r >= 0` and the last where `r < 0`, so no term with mass
# overflows. A lag without mass adds nothing to either but carries the
# derivative in its mass, so its exponent is capped to keep that finite.
# `v` maps each mass before use.
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
# which is convex and falling in `r`. By Jensen's inequality the log of
# `∑ g_l e^{-r l}` is at least `log ∑ g_l - r μ`, with `μ` the mean lag, so
# `log(R ∑ g_l) / μ` is below the root. The log is at most
# `log ∑ g_l - r l` for the first lag with mass where `r > 0`, and the last
# where `r < 0`, which bounds the root above. Newton steps on a convex,
# falling function rise from below the root towards it, so the iteration
# stops once a step no longer rises or would leave the bounds. Steps
# converge quadratically, so the cap on their number is only a guard.
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
