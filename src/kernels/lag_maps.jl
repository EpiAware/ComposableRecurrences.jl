# Maps of a computed kernel along each cohort's lags: its increments, and
# its weights over their total. They fill and pull back with the other
# computed kernels (see `weights.jl` and `walk.jl`).

@doc raw"""
The increments of a computed kernel along its lags.

Inside a kernel `TimeVarying(Increments(x), Primary())`, the weight on lag
``l`` of cohort ``\tau`` in stratum ``k`` is

```math
w_{k,l}(\tau) = x_{k,l}(\tau) - x_{k,l-1}(\tau),
```

where ``x_{k,l}(\tau)`` is the weight of the kernel `TimeVarying(x,
Primary())`, and ``x`` before the kernel's first lag is zero.
On a cumulative distribution, such as `1 - Survival(hazard)`, it gives the
probability mass at each lag.

# Arguments
- `x`: the kernel to take the increments of, a [`Derived`](@ref), a
  [`ComposableRecurrences.Survival`](@ref) or another computed kernel, or a
  kernel's weights, `TimeVarying(K, Primary())`, as
  [`kernel_weights`](@ref ComposableRecurrences.kernel_weights) returns them.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
# The probability a delay with hazard `h` ends at each lag.
h = [0.2, 0.3, 0.4]
pmf = CR.Increments(1 - CR.Survival(h))
round.(CR.kernel_weights(TimeVarying(pmf, CR.Primary()), 1); digits = 3)

# output

3×1 Matrix{Float64}:
 0.2
 0.24
 0.224
```
"""
struct Increments{X}
    "The kernel to take the increments of."
    x::X
    function Increments(x::X) where {X}
        _check_lag_map(x)
        return new{X}(x)
    end
end

@doc raw"""
The weights of a computed kernel over their total across its lags.

Inside a kernel `TimeVarying(Normalised(x), Primary())`, the weight on lag
``l`` of cohort ``\tau`` in stratum ``k`` is

```math
w_{k,l}(\tau) = \frac{x_{k,l}(\tau)}{\max_\epsilon \sum_{j} x_{k,j}(\tau)},
```

where ``x_{k,l}(\tau)`` is the weight of the kernel `TimeVarying(x,
Primary())`, the sum runs over all of the kernel's lags, and a total that
is not finite or is at most `eps` is replaced by `eps`, so a cohort whose
weights are all zero keeps weights of zero.
Every lag of each cohort enters its total, so for ``n`` cohorts and ``L``
lags a `TimeVarying(h)` argument needs the times up to ``n + L - 1`` in a
[`Convolution`](@ref) and ``n + L`` in a [`Recurrence`](@ref).

# Arguments
- `x`: the kernel to normalise, a [`Derived`](@ref), a
  [`ComposableRecurrences.Survival`](@ref) or another computed kernel, or a
  kernel's weights, `TimeVarying(K, Primary())`, as
  [`kernel_weights`](@ref ComposableRecurrences.kernel_weights) returns them.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
# The probability mass of a delay with hazard `h`, given that it ends by
# the last lag.
h = [0.2, 0.3, 0.4]
pmf = CR.Normalised(CR.Increments(1 - CR.Survival(h)))
round.(CR.kernel_weights(TimeVarying(pmf, CR.Primary()), 1); digits = 3)

# output

3×1 Matrix{Float64}:
 0.301
 0.361
 0.337
```
"""
struct Normalised{X}
    "The kernel to normalise."
    x::X
    function Normalised(x::X) where {X}
        _check_lag_map(x)
        return new{X}(x)
    end
end

const _LagMap = Union{Increments, Normalised}

# == A kernel's weights inside a lag map ==

# The weights of a kernel `TimeVarying(K, Primary())` held as an array: lag
# index by cohort (`L × n`), or stratum by lag index by cohort
# (`S × L × n`), as `kernel_weights` returns them. A lag map reads them as
# it reads a computed kernel's.
const _KernelTable = TimeVarying{
    Primary, <:Union{AbstractMatrix{<:Real}, AbstractArray{<:Real, 3}},
}

@noinline function _check_lag_map(x)
    x isa Union{Derived, Survival, _LagMap, _KernelTable} || throw(
        ArgumentError(
            "a lag map takes a computed kernel (a Derived, a Survival, " *
                "Increments or Normalised) or a kernel's weights, " *
                "TimeVarying(K, Primary()); got $(_describe(x))"
        )
    )
    return nothing
end

_coef_lags(x::_KernelTable) = size(x.x, ndims(x.x) - 1)
_coef_strata(x::_KernelTable) = ndims(x.x) == 3 ? size(x.x, 1) : 0
_stratified_type(::Type{<:TimeVarying{Primary, <:AbstractArray{<:Real, 3}}}) = true
function _check_kernel_args(x::_KernelTable)
    _require_one_based(x.x)
    return nothing
end
Base.@propagate_inbounds function _value(
        x::TimeVarying{Primary, <:AbstractMatrix{<:Real}}, sc, k, i, τ, l, b
    )
    return x.x[i, τ]
end
Base.@propagate_inbounds function _value(
        x::TimeVarying{Primary, <:AbstractArray{<:Real, 3}}, sc, k, i, τ, l, b
    )
    return x.x[k, i, τ]
end
Base.@propagate_inbounds function _add_value!(
        x̄, x::TimeVarying{Primary, <:AbstractMatrix{<:Real}}, sc, v, k, i,
        τ, l, b
    )
    return add_cotangent!(cotangent(x̄, :x), v, i, τ)
end
Base.@propagate_inbounds function _add_value!(
        x̄, x::TimeVarying{Primary, <:AbstractArray{<:Real, 3}}, sc, v, k, i,
        τ, l, b
    )
    return add_cotangent!(cotangent(x̄, :x), v, k, i, τ)
end

# == The maps along one cohort's lags ==

# A total that is not finite or is at most `eps` is replaced by `eps`, and
# then has no slope.
_safe_on(t) = isfinite(t) && t > eps(typeof(t))
_safe_total(t) = _safe_on(t) ? t : eps(typeof(t))
_safe_slope(t) = _safe_on(t) ? one(t) : zero(t)

# The weights `w` of lags `1:n` from the values `u` of the kernel inside.
function _lag_map!(w, ::Increments, u, n)
    prev = zero(eltype(u))
    @inbounds for i in 1:n
        w[i] = u[i] - prev
        prev = u[i]
    end
    return w
end
function _lag_map!(w, ::Normalised, u, n)
    T = eltype(u)
    total = zero(T)
    @inbounds for i in 1:n
        total += u[i]
    end
    s = _safe_total(total)
    @inbounds for i in 1:n
        w[i] = u[i] / s
    end
    return w
end

# The cotangents `ū` of the values inside from those `w̄` of the weights;
# `ū` may be `w̄`.
function _lag_map_back!(ū, ::Increments, w̄, u, n)
    next = zero(eltype(w̄))
    @inbounds for i in n:-1:1
        wi = w̄[i]
        ū[i] = wi - next
        next = wi
    end
    return ū
end
function _lag_map_back!(ū, ::Normalised, w̄, u, n)
    T = eltype(u)
    total = zero(T)
    dot = zero(T)
    @inbounds for i in 1:n
        total += u[i]
        dot += w̄[i] * u[i]
    end
    s = _safe_total(total)
    c = _safe_slope(total) * dot / s^2
    @inbounds for i in 1:n
        ū[i] = w̄[i] / s - c
    end
    return ū
end
