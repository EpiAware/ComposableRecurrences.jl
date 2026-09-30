@doc "
A causal convolution whose kernel starts at lag 0: each output weights the
current and past inputs,

    y_t = Σ_d kernel_t[d + 1] x_{t-d}

A vector kernel is shared by every series, a [`PerStratum`](@ref) kernel is
`S × D`, and a [`TimeVarying`](@ref) kernel is `D × T` or
`TimeVarying(PerStratum(G))` with `G` `S × D × T`, all lag 0 first.
A `TimeVarying` kernel's indexing sets which time its column belongs to:
with [`ComposableRecurrences.Secondary`](@ref) (the default) column `t`
belongs to output day `t` and weights the inputs reaching it; with
[`ComposableRecurrences.Primary`](@ref) column `s` belongs to input day `s`
and is the delay pmf of that day's input, which spreads forward through it,
`y_t = Σ_s x_s kernel_s[t - s + 1]`, so input mass is conserved up to the
window's end.

To weight lags from 1, as a renewal's force of infection does, prepend a
zero: `Convolution(vcat(0, g))` recomputes `Σ_i g_i y_{t-i}` from the
outputs `y` of a [`Recurrence`](@ref) with kernel `g`.

Called as `c(x; history = nothing, start = 1, stop)`, the call covers the
absolute times `start:stop`:

  - `x`: the inputs, length `T` or `S × T`, read at absolute time `t`. The
    inputs before `start` come from `x` itself.
  - `history`: the inputs before `t = 1`, oldest first (any length `m`, or
    `S × m`); earlier inputs are zero. Not with a `Primary()` kernel, which
    has no column for them.
  - `start`: the first time; `1` by default.
  - `stop`: the last time; the length of `x` by default.

The output has the layout of `x` and length `stop - start + 1`.

# Arguments
- `kernel`: the kernel, lag 0 first.

# Examples
```@example
using ComposableRecurrences
delay = [0.0, 0.5, 0.3, 0.2]         # P(delay = 0, 1, 2, 3)
Convolution(delay)(ones(8); history = ones(3))
```
"
struct Convolution{K}
    "The kernel, lag 0 first."
    kernel::K
    function Convolution(kernel::K) where {K}
        kernel isa _PairwiseKernel && throw(
            ArgumentError("a Pairwise kernel is for a Recurrence")
        )
        _check_kernel_shape(kernel)
        return new{K}(kernel)
    end
end

(c::Convolution)(x; kwargs...) = first(forward(c, Run(), x; kwargs...))

# A Convolution has no modifiers, so its cache holds no state.
function forward(
        c::Convolution, ::Run, x; history = nothing, start = 1, stop = nothing
    )
    kernel = c.kernel
    _check_unwrapped(:x, x)
    S = _nstrata(x)
    m = history === nothing ? 0 : size(history, ndims(history))
    _check_input_history(history, x)
    _check_primary_history(kernel, history)
    _check_kernel_strata(kernel, S)
    stop = _stop(stop, (:x => _extent(x),))
    start >= 1 || throw(ArgumentError("start ($start) must be at least 1"))
    stop >= start - 1 || throw(
        ArgumentError("stop ($stop) is before start ($start)")
    )
    _check_kernel_times(kernel, stop)
    Tp = float(param_eltype((kernel, x, history)))
    X = _zeros(x, Tp, m + stop, S)
    history === nothing || _load_history!(X, history, m)
    _load_input!(X, x, m, stop)
    Y = _zeros(x, Tp, stop - start + 1, S)
    _convolve!(Y, kernel, X, m, start)
    return _public(Y, axes(Y, 1), x), (;)
end

_check_input_history(::Nothing, x) = nothing
function _check_input_history(h, x)
    ndims(h) == ndims(x) && _nstrata(h) == _nstrata(x) || throw(
        DimensionMismatch("history does not match the strata of x")
    )
    return nothing
end

_check_primary_history(kernel, history) = nothing
_check_primary_history(::TimeVarying{Primary}, ::Nothing) = nothing
function _check_primary_history(::TimeVarying{Primary}, history)
    throw(
        ArgumentError(
            "a Primary() kernel has no column for an input before t = 1: " *
                "pass those inputs inside x"
        )
    )
end

function _load_input!(X, x::AbstractVector, m, stop)
    X[(m + 1):(m + stop), 1] .= view(x, 1:stop)
    return X
end
function _load_input!(X, x::AbstractMatrix, m, stop)
    X[(m + 1):(m + stop), :] .= transpose(view(x, :, 1:stop))
    return X
end

# One `axpy!` per lag over each stratum's contiguous series: output row `j`
# is time `start + j - 1`, and lag `d` adds `c[d + 1]` times buffer row
# `m + start + j - 1 - d` for every row with a defined input.
function _convolve_series!(y, c, X, k, m, start)
    T = size(y, 1)
    for d in 0:(length(c) - 1)
        j0 = max(1, d + 2 - m - start)
        j0 > T && break
        r0 = m + start + j0 - 1 - d
        _axpy!(c[d + 1], view(X, r0:(r0 + T - j0), k), view(y, j0:T))
    end
    return y
end

# BLAS `axpy!` for float buffers. Other eltypes loop: the generic `axpy!`
# returns early on a zero coefficient, which drops a tracked coefficient's
# derivative.
function _axpy!(α::T, x::StridedVector{T}, y::StridedVector{T}) where {
        T <: Union{Float32, Float64},
    }
    return axpy!(α, x, y)
end
function _axpy!(α, x, y)
    for i in eachindex(x, y)
        y[i] += α * x[i]
    end
    return y
end

function _convolve!(Y, c::AbstractVector, X, m, start)
    for k in axes(Y, 2)
        _convolve_series!(view(Y, :, k), c, X, k, m, start)
    end
    return Y
end

function _convolve!(Y, c::PerStratum, X, m, start)
    for k in axes(Y, 2)
        _convolve_series!(view(Y, :, k), view(c.x, k, :), X, k, m, start)
    end
    return Y
end

# Secondary indexing: output time `t` reads its own column.
function _convolve!(Y, c::TimeVarying{Secondary}, X, m, start)
    D = _nlags(c)
    for k in axes(Y, 2), j in axes(Y, 1)
        t = start + j - 1
        acc = zero(eltype(Y))
        for d in 0:min(D - 1, m + t - 1)
            acc += _weight(c, k, k, d + 1, t) * X[m + t - d, k]
        end
        Y[j, k] = acc
    end
    return Y
end

# Primary indexing: the input at time `σ` spreads forward through its own
# column. There is no history, so buffer row `σ` is time `σ`.
function _convolve!(Y, c::TimeVarying{Primary}, X, m, start)
    D = _nlags(c)
    stop = start + size(Y, 1) - 1
    for k in axes(Y, 2), σ in max(1, start - D + 1):stop
        x = X[σ, k]
        for d in max(0, start - σ):(D - 1)
            t = σ + d
            t > stop && break
            Y[t - start + 1, k] += _weight(c, k, k, d + 1, σ) * x
        end
    end
    return Y
end
