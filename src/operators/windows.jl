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

function _window_sums(op::_WindowSums, (; lo, hi), x::AbstractVector)
    _on_gpu(x) && return _device_window_sums(op, lo, hi, x)
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
    _on_gpu(x) && return _device_window_sums(op, lo, hi, x)
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
function _window_sums_back!(x̄::AbstractVector, op::_WindowSums, (; lo, hi), ȳ)
    _on_gpu(x̄) && return _device_window_sums_back!(x̄, op, lo, hi, ȳ)
    @inbounds for v in eachindex(hi), t in (lo[v] + 1):hi[v]
        x̄[t] += ȳ[v]
    end
    return x̄
end
function _window_sums_back!(
        x̄::AbstractMatrix, op::_WindowSums, (; lo, hi), ȳ
    )
    _on_gpu(x̄) && return _device_window_sums_back!(x̄, op, lo, hi, ȳ)
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

# == On a device ==

# On a device each sum is one index of a kernel, and in the reverse pass each
# time is one index that adds the cotangents of the windows it falls in, so
# no index writes where another does. A vector is a matrix of one column.
_device_ready(::_WindowSums) = true
_device_ints(like, v) = copyto!(similar(like, Int, length(v)), v)
function _device_window_sums(op::_WindowSums, lo, hi, x)
    V = length(hi)
    dims = op.dims == 1 ? (V, size(x, 2)) : (size(x, 1), V)
    out = similar(x, eltype(x), x isa AbstractVector ? (V,) : dims)
    lo, hi = _device_ints(x, lo), _device_ints(x, hi)
    each!(
        _window_sum_at!, _resolve(Serial(), x), length(out), typemax(Int),
        out, x, lo, hi, op.dims == 1, first(dims)
    )
    return out
end
function _window_sum_at!(i, out, x, lo, hi, along, m)
    a, b = _split_index(i, m)
    acc = zero(eltype(out))
    @inbounds if along
        for t in (lo[a] + 1):hi[a]
            acc += x[t, b]
        end
    else
        for t in (lo[b] + 1):hi[b]
            acc += x[a, t]
        end
    end
    @inbounds out[i] = acc
    return nothing
end
function _device_window_sums_back!(x̄, op::_WindowSums, lo, hi, ȳ)
    lo, hi = _device_ints(x̄, lo), _device_ints(x̄, hi)
    each!(
        _window_sums_back_at!, _resolve(Serial(), x̄), length(x̄),
        typemax(Int), x̄, ȳ, lo, hi, op.dims == 1, size(x̄, 1)
    )
    return x̄
end
function _window_sums_back_at!(j, x̄, ȳ, lo, hi, along, m)
    a, b = _split_index(j, m)
    t = along ? a : b
    acc = zero(eltype(x̄))
    @inbounds for v in eachindex(hi)
        if lo[v] < t <= hi[v]
            acc += along ? ȳ[v, b] : ȳ[a, v]
        end
    end
    @inbounds x̄[j] += acc
    return nothing
end
# Row and column of linear index `i` in a matrix of `m` rows.
_split_index(i, m) = (rem(i - 1, m) + 1, div(i - 1, m) + 1)
