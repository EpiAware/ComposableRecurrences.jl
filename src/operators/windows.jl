@doc raw"""
Sum `x` over consecutive windows along dimension `dims`, the first from
time 1 and each later one from the time after the end before it,

```math
s_v = \sum_{t = e_{v - 1} + 1}^{e_v} x_t, \qquad e_0 = 0,
```

with ``e_v`` = `ends[v]` clamped to `0:n`, ``n`` the length of `x` along
`dims`.
A matrix gives its sums in place of dimension `dims`.
It is differentiable in `x`, with a reverse pass that adds each window's
cotangent to its times.

# Arguments
- `x`: a vector, or a matrix with time along `dims`.
- `ends`: the last time of each window; one not after the end before it
  gives an empty window, whose sum is zero, and the next window starts
  after it, so a time can fall in more than one window.
- `dims`: the dimension of `x` that is time; the last by default.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
daily = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0]
CR.window_sums(daily, [2, 5, 5, 8])

# output

4-element Vector{Float64}:
  3.0
 12.0
  0.0
  6.0
```
"""
function window_sums(
        x::AbstractVecOrMat, ends::AbstractVector{<:Integer};
        dims::Integer = ndims(x)
    )
    1 <= dims <= ndims(x) || throw(
        ArgumentError(
            "dims ($dims) must be a dimension of x, which has $(ndims(x))"
        )
    )
    return _WindowSums(ends, size(x, dims), Int(dims))(x)
end

# == _WindowSums ==

# `window_sums` as an operator of its own. It holds the ends as given, so a
# backend that traces the call has no loop to trace before the rule.
struct _WindowSums{E <: AbstractVector{<:Integer}} <: AbstractOperator
    ends::E
    n::Int
    dims::Int
end
uses_adjoint(::_WindowSums, ::Run) = true
function _run_forward(op::_WindowSums, x)
    w = _windows(op)
    return _window_sums(op, w, x), w
end

# Window `v` covers times `lo[v] + 1` to `hi[v]`, empty when
# `hi[v] <= lo[v]`.
function _windows(op::_WindowSums)
    hi = Vector{Int}(undef, length(op.ends))
    lo = similar(hi)
    prev = 0
    for (v, e) in enumerate(op.ends)
        hi[v] = clamp(Int(e), 0, op.n)
        lo[v] = clamp(prev, 0, op.n)
        prev = hi[v]
    end
    return (; lo, hi)
end

function _window_sums(::_WindowSums, (; lo, hi), x::AbstractVector)
    out = _zeros(x, eltype(x), length(hi))
    @inbounds for v in eachindex(hi)
        acc = zero(eltype(x))
        for t in (lo[v] + 1):hi[v]
            acc += x[t]
        end
        out[v] = acc
    end
    return out
end
function _window_sums(op::_WindowSums, (; lo, hi), x::AbstractMatrix)
    if op.dims == 1
        out = _zeros(x, eltype(x), length(hi), size(x, 2))
        @inbounds for k in axes(x, 2), v in eachindex(hi)
            acc = zero(eltype(x))
            for t in (lo[v] + 1):hi[v]
                acc += x[t, k]
            end
            out[v, k] = acc
        end
        return out
    end
    out = _zeros(x, eltype(x), size(x, 1), length(hi))
    @inbounds for v in eachindex(hi), t in (lo[v] + 1):hi[v]
        for p in axes(x, 1)
            out[p, v] += x[p, t]
        end
    end
    return out
end

# Each time in a window takes that window's cotangent.
function pullback!(grads, op::_WindowSums, ::Run, w)
    _count_pullback()
    x̄ = grads.args[1]
    x̄ === nothing && return nothing
    _window_sums_back!(x̄, op, w, grads.y)
    return nothing
end
function _window_sums_back!(x̄::AbstractVector, ::_WindowSums, (; lo, hi), ȳ)
    @inbounds for v in eachindex(hi), t in (lo[v] + 1):hi[v]
        x̄[t] += ȳ[v]
    end
    return x̄
end
function _window_sums_back!(
        x̄::AbstractMatrix, op::_WindowSums, (; lo, hi), ȳ
    )
    if op.dims == 1
        @inbounds for k in axes(x̄, 2), v in eachindex(hi)
            ȳv = ȳ[v, k]
            for t in (lo[v] + 1):hi[v]
                x̄[t, k] += ȳv
            end
        end
    else
        @inbounds for v in eachindex(hi), t in (lo[v] + 1):hi[v]
            for p in axes(x̄, 1)
                x̄[p, t] += ȳ[p, v]
            end
        end
    end
    return x̄
end
