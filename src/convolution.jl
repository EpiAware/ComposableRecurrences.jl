@doc raw"""
A causal convolution whose kernel starts at lag 0: each output weights the
current and past inputs,

```math
y_{t,i} = \sum_{l=0}^{L-1} k_{i,l}(t)\, x_{t-l,i},
\qquad t = t_0, \dots, t_1,
```

where ``y_{t,i}`` is the output of stratum ``i`` (one of ``S`` parallel
series) at absolute time ``t``, ``x_{t-l,i}`` its input ``l`` steps earlier,
``k_{i,l}(t)`` = `kernel[l + 1]` the weight on lag ``l`` and ``L`` the
kernel length.
``x_\tau`` for ``\tau < 1`` comes from `history` and is zero before it.
Strata do not mix.

A vector kernel is shared by every stratum, a [`PerStratum`](@ref) kernel is
`S × L`, and a [`TimeVarying`](@ref) kernel is `L × T` or
`TimeVarying(PerStratum(G))` with `G` `S × L × T`, all lag 0 first.
A `TimeVarying` kernel's indexing sets which time its column belongs to:
with [`ComposableRecurrences.Secondary`](@ref) (the default) column ``t``
weights the inputs reaching output ``t``, as above; with
[`ComposableRecurrences.Primary`](@ref) column ``\tau`` is the delay pmf of
the input at time ``\tau``, which spreads forward through it, so the weight
is ``k_{i,l}(t - l)`` and input mass is conserved up to the window's end.

To weight lags from 1, as a renewal's force of infection does, prepend a
zero: `Convolution(vcat(0, g))` recomputes ``\sum_{l=1}^{L} g_l\, y_{t-l}``
from the outputs ``y`` of a [`Recurrence`](@ref) with kernel ``g``.

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
```jldoctest
using ComposableRecurrences
delay = [0.0, 0.5, 0.3, 0.2]         # P(delay = 0, 1, 2, 3)
Convolution(delay)(ones(8); history = ones(3))

# output

8-element Vector{Float64}:
 1.0
 1.0
 1.0
 1.0
 1.0
 1.0
 1.0
 1.0
```
"""
struct Convolution{K} <: AbstractOperator
    "The kernel, lag 0 first."
    kernel::K
    function Convolution(kernel::K) where {K}
        kernel isa _PairwiseKernel && throw(
            ArgumentError(
                "a Pairwise kernel is for a Recurrence, not a Convolution; " *
                    "got $(_describe(kernel))"
            )
        )
        _check_kernel_shape(kernel)
        return new{K}(kernel)
    end
end

# The call builds the positional arguments `(x, history, start, stop)` and
# routes them through the native rules; `route` is `c` or `NoAdjoint(c)`.
function _invoke(c::Convolution, route, x; history = nothing, start = 1, stop = nothing)
    return adjoint_call(route, x, history, start, stop)
end

# A Convolution has no modifiers, so its cache holds no state.
function forward(
        c::Convolution, ::Run, x; history = nothing, start = 1, stop = nothing
    )
    return _run_forward(c, x, history, start, stop)
end

uses_adjoint(::Convolution, ::Run) = true

function _run_forward(c::Convolution, x, history, start, stop)
    Y, X, m, stop = _conv(c, x, history, start, stop)
    return _output(Y, x), (; x, history, start, stop, X, m)
end
function _primal(c::Convolution, x, history, start, stop)
    Y = first(_conv(c, x, history, start, stop))
    return _output(Y, x)
end

# The output buffer in the layout of `x`; a single series shares its memory.
_output(Y, x::AbstractVector) = vec(Y)
_output(Y, x::AbstractMatrix) = permutedims(Y)

# Checks the call, then convolves into a time-first buffer; returns the
# output buffer, the input buffer (history then `x`), the history length and
# the last time.
function _conv(c::Convolution, x, history, start, stop)
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
    Y, X = _conv_buffers(Tp, kernel, x, history, m, S, start, stop)
    return Y, X, m, stop
end

# Allocates and fills the input buffer and convolves it into the output
# buffer at eltype `Tp` with the set executor; an extension adds methods for
# its own number types.
function _conv_buffers(::Type{Tp}, kernel, x, history, m, S, start, stop) where {Tp}
    cur = _current()
    if cur.ex isa Serial
        return _conv_buffers(Tp, Serial(), kernel, x, history, m, S, start, stop)
    end
    return _conv_buffers(Tp, cur, kernel, x, history, m, S, start, stop)
end

function _conv_buffers(
        ::Type{Tp}, ex::Union{Serial, _Current}, kernel, x, history, m, S, start, stop
    ) where {Tp}
    X = _zeros(x, Tp, m + stop, S)
    history === nothing || _load_history!(X, history, m)
    _load_input!(X, x, m, stop)
    Y = _zeros(x, Tp, stop - start + 1, S)
    _convolve!(ex, Y, kernel, X, m, start)
    return Y, X
end

_check_input_history(::Nothing, x) = nothing
function _check_input_history(h, x)
    ndims(h) == ndims(x) && _nstrata(h) == _nstrata(x) || throw(
        DimensionMismatch(
            "history is $(summary(h)) but x is $(summary(x)): history " *
                "must have the strata of x"
        )
    )
    return nothing
end

_check_primary_history(kernel, history) = nothing
_check_primary_history(::TimeVarying{Primary}, ::Nothing) = nothing
function _check_primary_history(::TimeVarying{Primary}, history)
    throw(
        ArgumentError(
            "a Primary() kernel has no column for an input before t = 1: " *
                "pass those inputs inside x, not as history " *
                "($(_describe(history)))"
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

# CPU buffers load by loop: a broadcast copy may alias its source, and
# reverse-mode AD cannot give that branch one activity when the input is
# constant.
function _load_input!(X::Array, x::AbstractVector, m, stop)
    for t in 1:stop
        X[m + t, 1] = x[t]
    end
    return X
end
function _load_input!(X::Array, x::AbstractMatrix, m, stop)
    for t in 1:stop, k in axes(X, 2)
        X[m + t, k] = x[k, t]
    end
    return X
end

# One `axpy!` per lag over each stratum's contiguous series: output row `j`
# is time `start + j - 1`, and lag `d` adds `c[d + 1]` times buffer row
# `m + start + j - 1 - d` for every row with a defined input. IEEE floats
# vectorise this; other numbers (dual numbers, say) gather instead, one
# dot of the kernel with the window per output, so each output is written
# once and its sum stays in registers.
function _convolve_series!(y::AbstractVector{<:_IEEEFloat}, c, X, k, m, start)
    T = size(y, 1)
    for d in 0:(length(c) - 1)
        j0 = max(1, d + 2 - m - start)
        j0 > T && break
        r0 = m + start + j0 - 1 - d
        _axpy!(c[d + 1], view(X, r0:(r0 + T - j0), k), view(y, j0:T))
    end
    return y
end
function _convolve_series!(y, c, X, k, m, start)
    L = length(c)
    for j in eachindex(y)
        r = m + start + j - 1
        acc = zero(eltype(y))
        @inbounds for d in 0:(min(L, r) - 1)
            acc += c[d + 1] * X[r - d, k]
        end
        y[j] = acc
    end
    return y
end

# `y .+= α x` as a native loop: at these lengths it is faster than a BLAS
# call. Under plain `Mooncake` AD the extension swaps in BLAS `axpy!`, which
# `Mooncake` differentiates with one rule.
function _axpy!(α, x, y)
    @inbounds @simd ivdep for i in eachindex(x, y)
        y[i] += α * x[i]
    end
    return y
end

# Each stratum is one index of the executor loop; `work` counts one
# multiply-add per output row and lag.
function _convolve!(ex, Y, c, X, m, start)
    S = size(Y, 2)
    work = length(Y) * _nlags(c)
    _each!(_convolve_body!, ex, Y, S, work, Y, c, X, m, start)
    return Y
end

function _convolve_body!(k, Y, c::AbstractVector, X, m, start)
    _convolve_series!(view(Y, :, k), c, X, k, m, start)
    return nothing
end

function _convolve_body!(k, Y, c::PerStratum, X, m, start)
    _convolve_series!(view(Y, :, k), view(c.x, k, :), X, k, m, start)
    return nothing
end

# Secondary indexing: output time `t` reads its own column, one dot with
# the window per output.
function _convolve_body!(k, Y, c::TimeVarying{Secondary}, X, m, start)
    D = _nlags(c)
    for j in axes(Y, 1)
        t = start + j - 1
        w = _wcolumn(c, k, t)
        acc = zero(eltype(Y))
        @inbounds @simd for d in 0:(min(D, m + t) - 1)
            acc += w[d + 1] * X[m + t - d, k]
        end
        @inbounds Y[j, k] = acc
    end
    return nothing
end

# Primary indexing: the input at time `σ` spreads forward through its own
# column. There is no history, so buffer row `σ` is time `σ`.
function _convolve_body!(k, Y, c::TimeVarying{Primary}, X, m, start)
    D = _nlags(c)
    stop = start + size(Y, 1) - 1
    for σ in max(1, start - D + 1):stop
        w = _wcolumn(c, k, σ)
        @inbounds x = X[σ, k]
        o = σ - start + 1
        @inbounds @simd ivdep for d in max(0, start - σ):min(D - 1, stop - σ)
            Y[o + d, k] += w[d + 1] * x
        end
    end
    return nothing
end

# The reverse pass: correlate the output cotangent with the kernel into the
# input buffer's cotangent, and with the inputs into the kernel's.
# `grads.args` are the mirrors of `(x, history, start, stop)`.
function pullback!(grads, c::Convolution, ::Run, cache)
    _count_pullback()
    (; x, history, start, X, m, stop) = cache
    x̄, h̄ = grads.args
    T = stop - start + 1
    Ȳ = _zeros(X, eltype(X), T, size(X, 2))
    _load_input!(Ȳ, grads.y, 0, T)
    X̄ = zero(X)
    _convolve_back!(X̄, cotangent(grads.piece, :kernel), c.kernel, X, Ȳ, m, start)
    _add_rows!(x̄, X̄, m, stop)
    _add_rows!(h̄, X̄, 0, m)
    return nothing
end

# Add buffer rows `o + 1` to `o + n` into the public-layout cotangent `x̄`.
_add_rows!(::Nothing, X̄, o, n) = nothing
function _add_rows!(x̄::AbstractVector, X̄, o, n)
    view(x̄, 1:n) .+= view(X̄, (o + 1):(o + n), 1)
    return nothing
end
function _add_rows!(x̄::AbstractMatrix, X̄, o, n)
    view(x̄, :, 1:n) .+= transpose(view(X̄, (o + 1):(o + n), :))
    return nothing
end

# One fused pass per lag: the kernel cotangent's dot product and the input
# cotangent's update together, the reverse of `_convolve_series!`.
function _convolve_series_back!(X̄k, c̄, c, Xk, ȳ, m, start)
    T = length(ȳ)
    for d in 0:(length(c) - 1)
        j0 = max(1, d + 2 - m - start)
        j0 > T && break
        o = m + start - 1 - d
        cd = c[d + 1]
        acc = zero(eltype(X̄k))
        @inbounds @simd ivdep for j in j0:T
            a = ȳ[j]
            acc += a * Xk[o + j]
            X̄k[o + j] += cd * a
        end
        add_cotangent!(c̄, acc, d + 1)
    end
    return nothing
end

function _convolve_back!(X̄, c̄, c::AbstractVector, X, Ȳ, m, start)
    for k in axes(Ȳ, 2)
        _convolve_series_back!(
            view(X̄, :, k), c̄, c, view(X, :, k), view(Ȳ, :, k), m, start
        )
    end
    return nothing
end

function _convolve_back!(X̄, c̄, c::PerStratum, X, Ȳ, m, start)
    C̄ = cotangent(c̄, :x)
    for k in axes(Ȳ, 2)
        _convolve_series_back!(
            view(X̄, :, k), C̄ === nothing ? nothing : view(C̄, k, :),
            view(c.x, k, :), view(X, :, k), view(Ȳ, :, k), m, start
        )
    end
    return nothing
end

# The time-varying kernel's cotangent is added through the column mirror
# `_wcolumn(c̄, c, k, τ)`, `nothing` when the kernel is constant. The
# mirror, the inputs and their cotangent are distinct arrays (`ivdep`).
function _convolve_back!(X̄, c̄, c::TimeVarying{Secondary}, X, Ȳ, m, start)
    D = _nlags(c)
    for k in axes(Ȳ, 2), j in axes(Ȳ, 1)
        t = start + j - 1
        w = _wcolumn(c, k, t)
        w̄ = _wcolumn(c̄, c, k, t)
        @inbounds a = Ȳ[j, k]
        @inbounds @simd ivdep for d in 0:(min(D, m + t) - 1)
            r = m + t - d
            _add_at!(w̄, a * X[r, k], d + 1)
            X̄[r, k] += w[d + 1] * a
        end
    end
    return nothing
end

function _convolve_back!(X̄, c̄, c::TimeVarying{Primary}, X, Ȳ, m, start)
    D = _nlags(c)
    stop = start + size(Ȳ, 1) - 1
    for k in axes(Ȳ, 2), σ in max(1, start - D + 1):stop
        w = _wcolumn(c, k, σ)
        w̄ = _wcolumn(c̄, c, k, σ)
        o = σ - start + 1
        @inbounds x = X[σ, k]
        acc = zero(eltype(X̄))
        @inbounds @simd ivdep for d in max(0, start - σ):min(D - 1, stop - σ)
            ȳ = Ȳ[o + d, k]
            _add_at!(w̄, ȳ * x, d + 1)
            acc += w[d + 1] * ȳ
        end
        @inbounds X̄[σ, k] += acc
    end
    return nothing
end
