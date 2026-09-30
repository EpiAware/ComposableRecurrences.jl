@doc "
A causal convolution: each output weights the current and past inputs by a
kernel indexed from lag 0,

    y_t = Σ_d kernel_t[d + 1] x_{t-d}

A vector kernel is shared by every stratum, a [`PerStratum`](@ref) kernel is
`S × D`, and a [`TimeVarying`](@ref) kernel is `D × T` or `S × D × T`, all
lag 0 first.

Called as `c(x; history = nothing)`, where `x` is length `T` or `S × T` and
`history` holds earlier inputs, oldest first (any length `m`, or `S × m`).
Inputs before the history are zero.
The output has the shape of `x`.

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
end

_ndelays(k::AbstractVector) = length(k)
_ndelays(k::PerStratum) = size(k.x, 2)
_ndelays(k::TimeVarying) = size(k.x, ndims(k.x) - 1)

function (c::Convolution)(x; history = nothing)
    kernel = c.kernel
    S = _nstrata(x)
    T = size(x, ndims(x))
    m = history === nothing ? 0 : size(history, ndims(history))
    _check_input_history(history, x)
    _check_kernel_strata(kernel, S)
    n = _tv_steps(kernel)
    n === nothing || n == T || throw(
        DimensionMismatch("kernel has $n steps, x has $T")
    )
    Tp = float(
        promote_type(_eltype(kernel), _eltype(x), _eltype(history))
    )
    X = zeros(Tp, m + T, S)
    history === nothing || _load_history!(X, history, m)
    _load_input!(X, x, m)
    Y = zeros(Tp, T, S)
    _convolve!(Y, kernel, X, m)
    return _public(Y, axes(Y, 1), x)
end

_check_input_history(::Nothing, x) = nothing
function _check_input_history(h, x)
    ndims(h) == ndims(x) && _nstrata(h) == _nstrata(x) || throw(
        DimensionMismatch("history does not match the strata of x")
    )
    return nothing
end

_load_input!(X, x::AbstractVector, m) = (X[(m + 1):end, 1] .= x; X)
_load_input!(X, x::AbstractMatrix, m) = (X[(m + 1):end, :] .= transpose(x); X)

# One `axpy!` per lag over each stratum's contiguous series: lag `d` adds
# `c[d + 1] X[m + t - d]` to `Y[t]` for every `t` with a defined input.
function _convolve_series!(y, c, X, k, m)
    T = size(y, 1)
    for d in 0:(length(c) - 1)
        t0 = max(1, d + 1 - m)
        t0 > T && break
        axpy!(c[d + 1], view(X, (m + t0 - d):(m + T - d), k), view(y, t0:T))
    end
    return y
end

function _convolve!(Y, c::AbstractVector, X, m)
    for k in axes(Y, 2)
        _convolve_series!(view(Y, :, k), c, X, k, m)
    end
    return Y
end

function _convolve!(Y, c::PerStratum, X, m)
    for k in axes(Y, 2)
        _convolve_series!(view(Y, :, k), view(c.x, k, :), X, k, m)
    end
    return Y
end

function _convolve!(Y, c::TimeVarying, X, m)
    D = _ndelays(c)
    for k in axes(Y, 2), t in axes(Y, 1)
        acc = zero(eltype(Y))
        for d in 0:min(D - 1, m + t - 1)
            acc += _tv_weight(c.x, k, d + 1, t) * X[m + t - d, k]
        end
        Y[t, k] = acc
    end
    return Y
end

_tv_weight(x::AbstractMatrix, k, j, t) = x[j, t]
_tv_weight(x::AbstractArray{<:Any, 3}, k, j, t) = x[k, j, t]
