@doc raw"""
    window_sums(x, ends; dims = ndims(x))

Sums of `x` over consecutive windows along dimension `dims`, window `v`
ending at time `ends[v]` and starting the time after the window before it,
the first at time 1,

```math
s_v = \sum_{t = e_{v - 1} + 1}^{e_v} x_t, \qquad e_0 = 0,
```

where ``e_v`` is `ends[v]` clamped to `0:n`, with ``n`` the length of `x`
along `dims`.
An end time not after the one before it gives an empty window, whose sum is
zero, and the next window starts after it.
So the sums are those of a running total read at the ends and differenced,
taken without the running total.

A vector gives a vector of `length(ends)` sums.
A matrix gives its sums along `dims` in place of that dimension: with
`dims = 2`, the default, a row per series and a column per window, and with
`dims = 1` a row per window.

It is differentiable in `x`, with a reverse pass that adds each window's
cotangent to the times in it.

# Arguments
- `x`: a vector, or a matrix with time along `dims`.
- `ends`: the last time of each window, ascending.
- `dims`: the dimension of `x` that is time.

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

# `window_sums` routes through the rules as an operator of its own. Window
# `v` covers times `lo[v] + 1` to `hi[v]`, empty when `hi[v] <= lo[v]`.
struct _WindowSums <: AbstractOperator
    lo::Vector{Int}
    hi::Vector{Int}
    dims::Int
end
function _WindowSums(ends::AbstractVector{<:Integer}, n::Integer, dims::Int)
    hi = Vector{Int}(undef, length(ends))
    lo = similar(hi)
    prev = 0
    for (v, e) in enumerate(ends)
        hi[v] = clamp(Int(e), 0, n)
        lo[v] = clamp(prev, 0, n)
        prev = hi[v]
    end
    return _WindowSums(lo, hi, dims)
end
uses_adjoint(::_WindowSums, ::Run) = true
_run_forward(op::_WindowSums, x) = (_window_sums(op, x), nothing)

function _window_sums(op::_WindowSums, x::AbstractVector)
    out = _zeros(x, eltype(x), length(op.hi))
    @inbounds for v in eachindex(op.hi)
        acc = zero(eltype(x))
        for t in (op.lo[v] + 1):op.hi[v]
            acc += x[t]
        end
        out[v] = acc
    end
    return out
end
function _window_sums(op::_WindowSums, x::AbstractMatrix)
    op.dims == 1 && return _window_sums_down(op, x)
    out = _zeros(x, eltype(x), size(x, 1), length(op.hi))
    @inbounds for v in eachindex(op.hi), t in (op.lo[v] + 1):op.hi[v]
        for p in axes(x, 1)
            out[p, v] += x[p, t]
        end
    end
    return out
end
function _window_sums_down(op::_WindowSums, x::AbstractMatrix)
    out = _zeros(x, eltype(x), length(op.hi), size(x, 2))
    @inbounds for k in axes(x, 2), v in eachindex(op.hi)
        acc = zero(eltype(x))
        for t in (op.lo[v] + 1):op.hi[v]
            acc += x[t, k]
        end
        out[v, k] = acc
    end
    return out
end

# Each time in a window takes that window's cotangent.
function pullback!(grads, op::_WindowSums, ::Run, cache)
    _count_pullback()
    x̄ = grads.args[1]
    x̄ === nothing && return nothing
    _window_sums_back!(x̄, op, grads.y)
    return nothing
end
function _window_sums_back!(x̄::AbstractVector, op::_WindowSums, ȳ)
    @inbounds for v in eachindex(op.hi), t in (op.lo[v] + 1):op.hi[v]
        x̄[t] += ȳ[v]
    end
    return x̄
end
function _window_sums_back!(x̄::AbstractMatrix, op::_WindowSums, ȳ)
    if op.dims == 1
        @inbounds for k in axes(x̄, 2), v in eachindex(op.hi)
            ȳv = ȳ[v, k]
            for t in (op.lo[v] + 1):op.hi[v]
                x̄[t, k] += ȳv
            end
        end
    else
        @inbounds for v in eachindex(op.hi), t in (op.lo[v] + 1):op.hi[v]
            for p in axes(x̄, 1)
                x̄[p, t] += ȳ[p, v]
            end
        end
    end
    return x̄
end
