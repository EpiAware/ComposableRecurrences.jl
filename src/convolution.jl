@doc "
A causal convolution: each output weights the current and past inputs by a
kernel indexed from lag 0,

    y_t = Σ_d kernel_t[d + 1] x_{t-d}

A vector kernel is shared by every stratum, a [`PerStratum`](@ref) kernel is
`S × D`, and a [`TimeVarying`](@ref) kernel is `D × T` or `S × D × T`, all
lag 0 first.

`indexed_by` sets which time a time-varying kernel's column belongs to, as
in ConvolvedDistributions' `convolve_series`:

  - `:primary` (the default): column `s` is the delay pmf of the input at
    time `s`, which spreads forward through it,
    `y_t = Σ_s x_s kernel_s[t - s + 1]`, so input mass is conserved up to
    the window's end.
  - `:secondary`: column `t` weights the inputs reaching output `t`,
    `y_t = Σ_d kernel_t[d + 1] x_{t-d}` (CTIDM's `TimeVaryingLDStep`).

The two agree for a fixed kernel.

Called as `c(x; history = nothing, start = 1)`, where `x` is length `T` or
`S × T` and `history` holds earlier inputs, oldest first (any length `m`, or
`S × m`).
Inputs before the history are zero.
`start` is the time index of the first output; the history inputs sit at
the times before it, so with `:primary` indexing `start` must exceed the
history length.
The output has the shape of `x`.

# Arguments
- `kernel`: the kernel, lag 0 first.

# Keyword Arguments
- `indexed_by`: `:primary` (default) or `:secondary`.

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
    "Which time a time-varying kernel's column belongs to."
    indexed_by::Symbol
    function Convolution(kernel::K, indexed_by::Symbol) where {K}
        indexed_by in (:primary, :secondary) || throw(
            ArgumentError(
                "unknown indexed_by $(repr(indexed_by)); choose one of " *
                    ":primary, :secondary"
            )
        )
        return new{K}(kernel, indexed_by)
    end
end

function Convolution(kernel; indexed_by::Symbol = :primary)
    return Convolution(kernel, indexed_by)
end

_ndelays(k::AbstractVector) = length(k)
_ndelays(k::PerStratum) = size(k.x, 2)
_ndelays(k::TimeVarying) = size(k.x, ndims(k.x) - 1)

function (c::Convolution)(x; history = nothing, start = 1)
    kernel = c.kernel
    S = _nstrata(x)
    T = size(x, ndims(x))
    m = history === nothing ? 0 : size(history, ndims(history))
    _check_input_history(history, x)
    _check_kernel_strata(kernel, S)
    _nsteps(start, (:x => T,), (:kernel => _tv_steps(kernel),))
    kernel isa TimeVarying && c.indexed_by === :primary && start <= m &&
        throw(
        ArgumentError(
            "a :primary time-varying kernel needs a column for every " *
                "history input: start ($start) must exceed the history " *
                "length ($m)"
        )
    )
    Tp = float(param_eltype((kernel, x, history)))
    X = zeros(Tp, m + T, S)
    history === nothing || _load_history!(X, history, m)
    _load_input!(X, x, m)
    Y = zeros(Tp, T, S)
    _convolve!(Y, kernel, X, m, start, c.indexed_by)
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
        _axpy!(c[d + 1], view(X, (m + t0 - d):(m + T - d), k), view(y, t0:T))
    end
    return y
end

# BLAS `axpy!` for float buffers. Other eltypes loop: the generic `axpy!`
# returns early on a zero coefficient, which drops a tracked coefficient's
# derivative (ReverseDiff).
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

function _convolve!(Y, c::AbstractVector, X, m, start, indexed_by)
    for k in axes(Y, 2)
        _convolve_series!(view(Y, :, k), c, X, k, m)
    end
    return Y
end

function _convolve!(Y, c::PerStratum, X, m, start, indexed_by)
    for k in axes(Y, 2)
        _convolve_series!(view(Y, :, k), view(c.x, k, :), X, k, m)
    end
    return Y
end

function _convolve!(Y, c::TimeVarying, X, m, start, indexed_by)
    indexed_by === :primary && return _scatter!(Y, c, X, m, start)
    D = _ndelays(c)
    for k in axes(Y, 2), t in axes(Y, 1)
        acc = zero(eltype(Y))
        for d in 0:min(D - 1, m + t - 1)
            acc += _tv_weight(c.x, k, d + 1, start + t - 1) * X[m + t - d, k]
        end
        Y[t, k] = acc
    end
    return Y
end

# Primary indexing: the input in buffer row `j`, at time
# `start - m + j - 1`, spreads forward through its own column.
function _scatter!(Y, c::TimeVarying, X, m, start)
    D = _ndelays(c)
    T = size(Y, 1)
    for k in axes(Y, 2), j in axes(X, 1)
        x = X[j, k]
        σ = start - m + j - 1
        for d in max(0, m + 1 - j):(D - 1)
            t = j - m + d
            t > T && break
            Y[t, k] += _tv_weight(c.x, k, d + 1, σ) * x
        end
    end
    return Y
end
