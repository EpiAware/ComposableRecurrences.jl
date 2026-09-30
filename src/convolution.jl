@doc "
A causal convolution: each output weights the current and past inputs by a
kernel indexed from lag 0,

    y_t = Σ_d kernel_t[d + 1] x_{t-d}

A vector kernel is shared by every stratum, a [`PerStratum`](@ref) kernel is
`S × D`, and a [`TimeVarying`](@ref) kernel is `D × T` or `S × D × T`, all
lag 0 first.

`indexed_by` sets which time a time-varying kernel's column belongs to:

  - `:primary` (the default): column `s` is the delay pmf of the input at
    time `s`, which spreads forward through it,
    `y_t = Σ_s x_s kernel_s[t - s + 1]`, so input mass is conserved up to
    the window's end.
  - `:secondary`: column `t` weights the inputs reaching output `t`,
    `y_t = Σ_d kernel_t[d + 1] x_{t-d}`.

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
struct Convolution{K} <: AbstractOperator
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

function _invoke(c::Convolution, route, x; history = nothing, start = 1)
    return adjoint_call(route, x, history, start)
end

# `forward(c, x, history, start)`.
function forward(c::Convolution, x, history, start)
    Y, X, m = _conv(c, x, history, start)
    return _public(Y, axes(Y, 1), x), (; c, x, history, start, X, m)
end
function _primal(c::Convolution, x, history, start)
    Y = first(_conv(c, x, history, start))
    return _public(Y, axes(Y, 1), x)
end

# Checks the call, then convolves into a time-first buffer; returns the
# output buffer, the input buffer (history then `x`) and the history length.
function _conv(c::Convolution, x, history, start)
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
    return Y, X, m
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

# The reverse pass: correlate the output cotangent with the kernel into the
# input buffer's cotangent, and with the inputs into the kernel's.
function pullback!(c::Convolution, cache, ȳ, c̄, x̄, h̄, start̄)
    _PULLBACK_CALLS[] += 1
    (; x, history, start, X, m) = cache
    T = size(X, 1) - m
    Ȳ = _load_input!(zeros(eltype(X), T, size(X, 2)), ȳ, 0)
    X̄ = zero(X)
    _convolve_back!(X̄, cotangent(c̄, :kernel), c.kernel, X, Ȳ, m, start, c.indexed_by)
    _add_rows!(x̄, X̄, m, x)
    _add_rows!(h̄, X̄, 0, history)
    return nothing
end

# Add buffer rows `o + 1` onwards into the public-layout cotangent `x̄`.
_add_rows!(::Nothing, X̄, o, x) = nothing
function _add_rows!(x̄::AbstractVector, X̄, o, x)
    x̄ .+= view(X̄, (o + 1):(o + length(x̄)), 1)
    return nothing
end
function _add_rows!(x̄::AbstractMatrix, X̄, o, x)
    x̄ .+= transpose(view(X̄, (o + 1):(o + size(x̄, 2)), :))
    return nothing
end

function _convolve_series_back!(X̄k, c̄, c, Xk, ȳ, m)
    T = length(ȳ)
    for d in 0:(length(c) - 1)
        t0 = max(1, d + 1 - m)
        t0 > T && break
        rows = (m + t0 - d):(m + T - d)
        ȳd = view(ȳ, t0:T)
        add_cotangent!(c̄, dot(ȳd, view(Xk, rows)), d + 1)
        _axpy!(c[d + 1], ȳd, view(X̄k, rows))
    end
    return nothing
end

function _convolve_back!(X̄, c̄, c::AbstractVector, X, Ȳ, m, start, indexed_by)
    for k in axes(Ȳ, 2)
        _convolve_series_back!(
            view(X̄, :, k), c̄, c, view(X, :, k), view(Ȳ, :, k), m
        )
    end
    return nothing
end

function _convolve_back!(X̄, c̄, c::PerStratum, X, Ȳ, m, start, indexed_by)
    C̄ = cotangent(c̄, :x)
    for k in axes(Ȳ, 2)
        _convolve_series_back!(
            view(X̄, :, k), C̄ === nothing ? nothing : view(C̄, k, :),
            view(c.x, k, :), view(X, :, k), view(Ȳ, :, k), m
        )
    end
    return nothing
end

function _convolve_back!(X̄, c̄, c::TimeVarying, X, Ȳ, m, start, indexed_by)
    C̄ = cotangent(c̄, :x)
    D = _ndelays(c)
    if indexed_by === :primary
        T = size(Ȳ, 1)
        for k in axes(Ȳ, 2), j in axes(X, 1)
            σ = start - m + j - 1
            for d in max(0, m + 1 - j):(D - 1)
                t = j - m + d
                t > T && break
                _add_tv!(C̄, Ȳ[t, k] * X[j, k], k, d + 1, σ)
                X̄[j, k] += _tv_weight(c.x, k, d + 1, σ) * Ȳ[t, k]
            end
        end
    else
        for k in axes(Ȳ, 2), t in axes(Ȳ, 1)
            τ = start + t - 1
            for d in 0:min(D - 1, m + t - 1)
                _add_tv!(C̄, Ȳ[t, k] * X[m + t - d, k], k, d + 1, τ)
                X̄[m + t - d, k] += _tv_weight(c.x, k, d + 1, τ) * Ȳ[t, k]
            end
        end
    end
    return nothing
end
