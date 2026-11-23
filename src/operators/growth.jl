# The growth rate of a renewal from its reproduction number.
#
# Newton's method finds the root on primal values, from a start left of the
# root (Jensen's inequality), so the iterates rise to it. One Newton step from
# the root in the callers' number types then carries the implicit-function
# derivative, as Newton's map has zero slope at its root.

@doc raw"""
Return the growth rate per step ``r`` of a renewal with reproduction number
`R` and generation interval `g`, from the Euler–Lotka equation

```math
R \sum_{l=1}^{L} g_l\, e^{-r l} = 1,
```

where ``g_l`` is `g[l]`, the weight on lag ``l``, as in a
[`Recurrence`](@ref) kernel.
It gives the rate that [`ComposableRecurrences.exponential_history`](@ref)
needs for a seed that grows as the renewal does.

The derivative in `R` and `g` is exact under every automatic
differentiation backend, without a rule.

# Arguments
- `R`: the reproduction number, positive.
- `g`: the generation interval, with `g[1]` the weight on lag 1; its
  weights are non-negative with a positive sum.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
g = [0.2, 0.5, 0.3]
r = CR.growth_rate(1.5, g)
residual = 1.5 * sum(g[l] * exp(-r * l) for l in 1:3)
round(r; digits = 4), round(residual; digits = 8)

# output

(0.1977, 1.0)
```
"""
function growth_rate(R::Real, g::AbstractVector{<:Real})
    r = _growth_root(_primal_value(R), g)
    A, B = _growth_sums(R, g, r)
    return r + (R * A - 1) / (R * B)
end

# The two sums of the Euler–Lotka equation at `r`, of `f` of each weight.
function _growth_sums(R, g, r, f = identity)
    A = B = zero(promote_type(typeof(R), typeof(f(first(g))), typeof(r)))
    for (l, w) in pairs(g)
        e = f(w) * exp(-r * l)
        A += e
        B += l * e
    end
    return A, B
end

# The root on primal values; automatic differentiation does not trace it.
function _growth_root(R, g)
    R > 0 || throw(ArgumentError("R must be positive, got $R"))
    G = M = zero(float(_primal_value(first(g))))
    for (l, w) in pairs(g)
        x = _primal_value(w)
        x >= 0 || throw(ArgumentError("g must be non-negative, got $x at lag $l"))
        G += x
        M += l * x
    end
    G > 0 || throw(ArgumentError("g must have a positive sum"))
    r = log(R * G) / (M / G)
    for _ in 1:50
        A, B = _growth_sums(R, g, r, _primal_value)
        step = (R * A - 1) / (R * B)
        r += step
        abs(step) <= 1.0e-12 * max(1, abs(r)) && return r
    end
    throw(ArgumentError("growth_rate did not converge in 50 steps for R = $R"))
end
