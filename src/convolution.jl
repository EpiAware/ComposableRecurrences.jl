@doc raw"""
How a [`Convolution`](@ref) computes its lag sum
```math
\sum_{l=0}^{L-1} k_{i,l}\, x_{t-l,i}.
```
[`ComposableRecurrences.Direct`](@ref) and [`ComposableRecurrences.FFTMethod`](@ref) are the methods.

# Examples
```jldoctest
using ComposableRecurrences
ComposableRecurrences.Direct() isa ComposableRecurrences.ConvolutionMethod

# output

true
```
"""
abstract type ConvolutionMethod end

@doc raw"""
The lag sum of a [`Convolution`](@ref) taken term by term,
```math
\sum_{l=0}^{L-1} k_{i,l}(t)\, x_{t-l,i},
```
at ``O(T L)`` cost for ``T`` outputs and ``L`` lags.
It takes every kernel and number type, and is the default.

# Examples
```jldoctest
using ComposableRecurrences
Convolution([0.5, 0.5]; method = ComposableRecurrences.Direct())([1.0, 2.0, 4.0])

# output

3-element Vector{Float64}:
 0.5
 1.5
 3.0
```
"""
struct Direct <: ConvolutionMethod end

@doc raw"""
The lag sum of a [`Convolution`](@ref) through the discrete Fourier
transform, by overlap-add,
```math
\sum_{l=0}^{L-1} k_{i,l}\, x_{t-l,i}
= \mathcal{F}^{-1}\!\left[\mathcal{F}(k_i)\, \mathcal{F}(x_i)\right]_t,
```
with the input split into blocks of ``N - L + 1`` times and each block
transformed at size ``N``, where ``N`` is the smallest 5-smooth number at
least ``\min(m + T + L - 1, 8L)`` for ``m`` history times and ``T`` times.
A block of the whole series is one transform.
Its cost is ``O(T \log L)`` rather than ``O(T L)``, so it pays for long
kernels; the reverse pass uses the same transforms.

It needs the FFTW package loaded.
It runs for a fixed kernel (a vector or [`PerStratum`](@ref)) on
`Float32` or `Float64` arrays; a [`TimeVarying`](@ref) kernel, any other
number type (dual numbers, say), other arrays (device or traced), and
forward-mode or plain reverse-mode AD of the call take [`ComposableRecurrences.Direct`](@ref).
The error of each output is about the machine epsilon times the largest
output in its block, not times the output itself, so tails far below the
peak lose relative accuracy and can come out negative.
In `Float32` that starts about six orders of magnitude below the peak.
It runs serially whatever [`ComposableRecurrences.Executor`](@ref) is set.

# Examples
```jldoctest
using ComposableRecurrences, FFTW
k = [0.1, 0.4, 0.3, 0.2]
x = collect(1.0:6.0)
Convolution(k; method = ComposableRecurrences.FFTMethod())(x) ≈ Convolution(k)(x)

# output

true
```
"""
struct FFTMethod <: ConvolutionMethod end

@doc raw"""
A causal convolution whose kernel starts at lag 0: each output weights the
current and past inputs, then is scaled by the gain and shifted by the add
input,

```math
y_{t,i} = g_{t,i} \sum_{l=0}^{L-1} k_{i,l}(t)\, x_{t-l,i} + a_{t,i},
\qquad t = t_0, \dots, t_1,
```

where ``y_{t,i}`` is the output of stratum ``i`` (one of ``S`` parallel
series) at absolute time ``t``, ``x_{t-l,i}`` its input ``l`` steps earlier,
``k_{i,l}(t)`` = `kernel[l + 1]` the weight on lag ``l``, ``L`` the
kernel length, ``g_{t,i}`` the gain and ``a_{t,i}`` the add input.
``x_\tau`` for ``\tau < 1`` comes from `history` and is zero before it.
Strata do not mix.
[`ComposableRecurrences.contributions`](@ref) returns the terms of the sum
over ``l`` before it is taken.

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

Called as `c(x; gain = 1, add, history = nothing, start = 1, stop)`, the
call covers the absolute times `start:stop`:

  - `x`: the inputs, length `T` or `S × T`, read at absolute time `t`. The
    inputs before `start` come from `x` itself.
  - `gain`: a scalar, a length-`T` vector shared by every stratum, or
    `S × T`, read at time `t`; one when left out.
  - `add`: `nothing`, a scalar, length `T` or `S × T`, read at time `t`.
  - `history`: the inputs before `t = 1`, oldest first (any length `m`, or
    `S × m`); earlier inputs are zero. Not with a `Primary()` kernel, which
    has no column for them.
  - `start`: the first time; `1` by default.
  - `stop`: the last time; by default the common length of the
    time-indexed inputs (`x`, `gain`, `add`).

The output has the layout of `x` and length `stop - start + 1`.

# Arguments
- `kernel`: the kernel, lag 0 first.

# Keyword Arguments
- `method`: how the lag sum is computed, a
  [`ComposableRecurrences.ConvolutionMethod`](@ref);
  [`ComposableRecurrences.Direct`](@ref) by default.

# Examples
```jldoctest
using ComposableRecurrences
delay = [0.0, 0.5, 0.3, 0.2]         # P(delay = 0, 1, 2, 3)
# Report 40% of the delayed inputs, on a baseline of 1.
Convolution(delay)(ones(8); history = ones(3), gain = 0.4, add = 1.0)

# output

8-element Vector{Float64}:
 1.4
 1.4
 1.4
 1.4
 1.4
 1.4
 1.4
 1.4
```
"""
struct Convolution{K, M <: ConvolutionMethod} <: AbstractOperator
    "The kernel, lag 0 first."
    kernel::K
    "How the lag sum is computed: [`ComposableRecurrences.Direct`](@ref) or [`ComposableRecurrences.FFTMethod`](@ref)."
    method::M
    function Convolution(kernel::K; method = Direct()) where {K}
        kernel isa _PairwiseKernel && throw(
            ArgumentError(
                "a Pairwise kernel is for a Recurrence, not a Convolution; " *
                    "got $(_describe(kernel))"
            )
        )
        method isa ConvolutionMethod || throw(
            ArgumentError(
                "method must be a ComposableRecurrences.ConvolutionMethod, " *
                    "Direct() or FFTMethod(); got $(repr(method))"
            )
        )
        _check_kernel_shape(kernel)
        return new{K, typeof(method)}(kernel, method)
    end
end

# A rebuild of a `Convolution` from its fields keeps its method.
_convolution_flat(kernel, method) = Convolution(kernel; method)
ConstructionBase.constructorof(::Type{<:Convolution}) = _convolution_flat

# The call builds the positional arguments
# `(x, gain, add, history, start, stop)` and routes them through the native
# rules; `route` is `c` or `NoAdjoint(c)`.
function _invoke(
        c::Convolution, route, x; gain = true, add = nothing, history = nothing,
        start = 1, stop = nothing
    )
    return adjoint_call(route, x, gain, add, history, start, stop)
end

# A Convolution has no modifiers, so its cache holds no state.
function forward(
        c::Convolution, ::Run, x; gain = true, add = nothing, history = nothing,
        start = 1, stop = nothing
    )
    return _run_forward(c, x, gain, add, history, start, stop)
end

# The cache keeps the lag sums `Y` before the gain, which the gain's
# cotangent reads.
function _run_forward(c::Convolution, x, gain, add, history, start, stop)
    Y, X, m, stop, fft = _conv(c, x, gain, add, history, start, stop)
    out = _finish(Y, x, gain, add, start)
    return out, (; gain = _tape(gain), add, start, stop, X, Y, m, fft)
end
function _primal(c::Convolution, x, gain, add, history, start, stop)
    Y = first(_conv(c, x, gain, add, history, start, stop))
    return _finish(Y, x, gain, add, start)
end

# Checks the call, then convolves into a time-first buffer; returns the
# output buffer of lag sums, the input buffer (history then `x`), the
# history length, the last time and whether the transform ran.
function _conv(c::Convolution, x, gain, add, history, start, stop)
    Tp, S, m, stop = _check_conv(c.kernel, x, gain, add, history, start, stop)
    fft = _fft_path(c.method, c.kernel, Tp, x)
    if fft
        X = _input_buffer(Tp, x, history, m, S, stop)
        Y = _zeros(x, Tp, stop - start + 1, S)
        _fft_convolve!(Y, c.kernel, X, m, start)
    else
        Y, X = _conv_buffers(Tp, c.kernel, x, history, m, S, start, stop)
    end
    return Y, X, m, stop, fft
end

# Whether a call takes the transform: never for `Direct()`. For
# `FFTMethod()` the FFTW extension adds the methods that answer; without it
# the call is refused.
_fft_path(::Direct, kernel, ::Type, x) = false
function _fft_path(::FFTMethod, kernel, ::Type, x)
    throw(
        ArgumentError(
            "FFTMethod() needs the FFTW package: load it with `using FFTW`"
        )
    )
end

# The transform's forward and reverse passes, added by the FFTW extension.
function _fft_convolve! end
function _fft_convolve_back! end

# Whether AD is tracing the code that calls this: `false` under forward-mode
# AD and plain reverse-mode AD, whose extensions say so, and `true`
# otherwise, including the forward pass of a native rule, which runs as
# primal code.
_untraced() = true

# The checks a convolution call shares with `contributions`; returns the
# buffer eltype, the strata, the history length and the last time.
function _check_conv(kernel, x, gain, add, history, start, stop)
    _check_unwrapped(:x, x)
    _check_unwrapped(:gain, gain)
    _check_unwrapped(:add, add)
    S = _nstrata(x)
    m = history === nothing ? 0 : size(history, ndims(history))
    _check_input_history(history, x)
    _check_primary_history(kernel, history)
    _check_kernel_strata(kernel, S)
    _check_strata(:gain, gain, S)
    _check_strata(:add, add, S)
    stop = _stop(
        stop, (:x => _extent(x), :gain => _extent(gain), :add => _extent(add))
    )
    start >= 1 || throw(ArgumentError("start ($start) must be at least 1"))
    stop >= start - 1 || throw(
        ArgumentError("stop ($stop) is before start ($start)")
    )
    _check_kernel_times(kernel, stop)
    Tp = float(param_eltype((kernel, x, history, gain, add)))
    return Tp, S, m, stop
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
    X = _input_buffer(Tp, x, history, m, S, stop)
    Y = _zeros(x, Tp, stop - start + 1, S)
    _convolve!(ex, Y, kernel, X, m, start)
    return Y, X
end

# The inputs at times `1 - m` to `stop`, time first: history then `x`.
function _input_buffer(::Type{Tp}, x, history, m, S, stop) where {Tp}
    X = _zeros(x, Tp, m + stop, S)
    history === nothing || _load_history!(X, history, m)
    _load_input!(X, x, m, stop)
    return X
end

# The output in the layout of `x`: the lag sums `Y` scaled by the gain and
# shifted by the add input in the one pass that copies them out. With
# neither it is the copy alone.
_unscaled(gain::Bool, ::Nothing) = gain
_unscaled(gain, add) = false
function _finish(Y, x, gain, add, start)
    _unscaled(gain, add) && return _public(Y, axes(Y, 1), x)
    return _scaled_public(Y, x, gain, add, start)
end
function _scaled_public(Y::Array, x::AbstractVector, gain, add, start)
    out = similar(Y, size(Y, 1))
    @inbounds for j in eachindex(out)
        t = start + j - 1
        out[j] = _at(gain, 1, t) * Y[j, 1] + _at(add, 1, t)
    end
    return out
end
function _scaled_public(Y::Array, x::AbstractMatrix, gain, add, start)
    out = similar(Y, size(Y, 2), size(Y, 1))
    @inbounds for j in axes(Y, 1), k in axes(Y, 2)
        t = start + j - 1
        out[k, j] = _at(gain, k, t) * Y[j, k] + _at(add, k, t)
    end
    return out
end
# Other arrays (device or traced) broadcast over the public copy.
function _scaled_public(Y, x, gain, add, start)
    out = _public(Y, axes(Y, 1), x)
    times = start:(start + size(Y, 1) - 1)
    out .= _tslice(gain, x, times) .* out .+ _tslice(add, x, times)
    return out
end
_tslice(g::Real, x, times) = g
_tslice(::Nothing, x, times) = false
_tslice(g::AbstractVector, ::AbstractVector, times) = view(g, times)
_tslice(g::AbstractVector, ::AbstractMatrix, times) = transpose(view(g, times))
_tslice(g::AbstractMatrix, ::AbstractVector, times) = view(g, 1, times)
_tslice(g::AbstractMatrix, ::AbstractMatrix, times) = view(g, :, times)

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

# Lags in blocks of four over each stratum's contiguous series, one pass
# over the output per block: output row `j` is time `start + j - 1`, and lag
# `d` adds `c[d + 1]` times buffer row `o + j - d`, `o = m + start - 1`, for
# every row with a defined input. Rows that only some lags of a block reach,
# and the lags after the last block, take one `axpy` per lag. IEEE floats
# vectorise this; other numbers (dual numbers, say) gather instead, one dot
# of the kernel with the window per output, so each output is written once
# and its sum stays in registers.
function _convolve_series!(y::AbstractVector{<:_IEEEFloat}, c, X, k, m, start)
    T = length(y)
    o = m + start - 1
    nb = length(c) ÷ 4
    for b in 0:(nb - 1)
        d = 4b
        j1 = max(1, d + 4 - o)
        for q in 0:3
            _lag_axpy!(y, c, X, k, o, d + q, min(j1 - 1, T))
        end
        j1 > T && return y
        r = o - d
        _axpy4!(
            c[d + 1], c[d + 2], c[d + 3], c[d + 4],
            view(X, (r + j1):(r + T), k), view(X, (r + j1 - 1):(r + T - 1), k),
            view(X, (r + j1 - 2):(r + T - 2), k), view(X, (r + j1 - 3):(r + T - 3), k),
            view(y, j1:T)
        )
    end
    for d in (4nb):(length(c) - 1)
        _lag_axpy!(y, c, X, k, o, d, T)
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

# Lag `d`'s part of output rows up to `last`, from its first defined row.
@inline function _lag_axpy!(y, c, X, k, o, d, last)
    j0 = max(1, d + 1 - o)
    j0 > last && return y
    _axpy!(c[d + 1], view(X, (o + j0 - d):(o + last - d), k), view(y, j0:last))
    return y
end

# `y .+= α x` and `y .+= α₀ x₀ .+ α₁ x₁ .+ α₂ x₂ .+ α₃ x₃` as native loops:
# at these lengths they are faster than BLAS calls. Under plain `Mooncake`
# AD the extension swaps in BLAS `axpy!`, which `Mooncake` differentiates
# with one rule.
@inline function _axpy!(α, x, y)
    @inbounds @simd ivdep for i in eachindex(x, y)
        y[i] += α * x[i]
    end
    return y
end
@inline function _axpy4!(α₀, α₁, α₂, α₃, x₀, x₁, x₂, x₃, y)
    @inbounds @simd ivdep for i in eachindex(x₀, x₁, x₂, x₃, y)
        y[i] += α₀ * x₀[i] + α₁ * x₁[i] + α₂ * x₂[i] + α₃ * x₃[i]
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
# the window per output. A column kernel's column is contiguous and
# vectorises; a per-stratum column is strided, so it is read entry by entry.
function _convolve_body!(k, Y, c::_TVColumns{Secondary}, X, m, start)
    for j in axes(Y, 1)
        t = start + j - 1
        w = _wcolumn(c, k, t)
        acc = zero(eltype(Y))
        @inbounds @simd for d in 0:(min(length(w), m + t) - 1)
            acc += w[d + 1] * X[m + t - d, k]
        end
        @inbounds Y[j, k] = acc
    end
    return nothing
end
function _convolve_body!(k, Y, c::_TVPerStratum{Secondary}, X, m, start)
    D = _nlags(c)
    for j in axes(Y, 1)
        t = start + j - 1
        acc = zero(eltype(Y))
        @inbounds for d in 0:(min(D, m + t) - 1)
            acc += _weight(c, k, k, d + 1, t) * X[m + t - d, k]
        end
        @inbounds Y[j, k] = acc
    end
    return nothing
end

# Primary indexing: the input at time `σ` spreads forward through its own
# column. There is no history, so buffer row `σ` is time `σ`.
function _convolve_body!(k, Y, c::_TVColumns{Primary}, X, m, start)
    D = _nlags(c)
    stop = start + size(Y, 1) - 1
    for σ in max(1, start - D + 1):stop
        w = _wcolumn(c, k, σ)
        @inbounds x = X[σ, k]
        o = σ - start + 1
        @inbounds @simd ivdep for d in max(0, start - σ):min(length(w) - 1, stop - σ)
            Y[o + d, k] += w[d + 1] * x
        end
    end
    return nothing
end
# A strided per-stratum column is faster read with bounds checks left in,
# which keep the compiler from a gather.
function _convolve_body!(k, Y, c::_TVPerStratum{Primary}, X, m, start)
    D = _nlags(c)
    stop = start + size(Y, 1) - 1
    for σ in max(1, start - D + 1):stop
        x = X[σ, k]
        for d in max(0, start - σ):min(D - 1, stop - σ)
            Y[σ + d - start + 1, k] += _weight(c, k, k, d + 1, σ) * x
        end
    end
    return nothing
end

# The reverse pass: take the output cotangent back through the gain and
# add input, then correlate it with the kernel into the input buffer's
# cotangent and with the inputs into the kernel's. `grads.args` are the
# mirrors of `(x, gain, add, history, start, stop)`.
function pullback!(grads, c::Convolution, ::Run, cache)
    _count_pullback()
    (; gain, add, start, X, Y, m, stop) = cache
    x̄, ḡ, ā, h̄ = grads.args
    T = stop - start + 1
    Ȳ = _zeros(X, eltype(X), T, size(X, 2))
    if _unscaled(gain, add)
        _load_input!(Ȳ, grads.y, 0, T)
    else
        _scale_back!(Ȳ, ḡ, ā, grads.y, Y, gain, start)
    end
    X̄ = zero(X)
    k̄ = cotangent(grads.piece, :kernel)
    if cache.fft
        _fft_convolve_back!(X̄, k̄, c.kernel, X, Ȳ, m, start)
    else
        _convolve_back!(X̄, k̄, c.kernel, X, Ȳ, m, start)
    end
    _add_rows!(x̄, X̄, m, stop)
    _add_rows!(h̄, X̄, 0, m)
    return nothing
end

# The cotangent of the lag sums `Ȳ` from the output's `ȳ`, adding the gain's
# and the add input's on the way.
function _scale_back!(Ȳ, ḡ, ā, ȳ, Y, gain, start)
    for j in axes(Ȳ, 1), k in axes(Ȳ, 2)
        t = start + j - 1
        @inbounds a = _ycot(ȳ, k, j)
        _add_slot!(ā, a, k, t)
        @inbounds _add_slot!(ḡ, a * Y[j, k], k, t)
        @inbounds Ȳ[j, k] = _at(gain, k, t) * a
    end
    return nothing
end
Base.@propagate_inbounds _ycot(ȳ::AbstractVector, k, j) = ȳ[j]
Base.@propagate_inbounds _ycot(ȳ::AbstractMatrix, k, j) = ȳ[k, j]

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

# A column kernel's cotangent is added through the column mirror
# `_wcolumn(c̄, c, k, τ)`, `nothing` when the kernel is constant. The
# mirror, the inputs and their cotangent are distinct arrays (`ivdep`).
function _convolve_back!(X̄, c̄, c::_TVColumns{Secondary}, X, Ȳ, m, start)
    for k in axes(Ȳ, 2), j in axes(Ȳ, 1)
        t = start + j - 1
        w = _wcolumn(c, k, t)
        w̄ = _wcolumn(c̄, c, k, t)
        @inbounds a = Ȳ[j, k]
        @inbounds @simd ivdep for d in 0:(min(length(w), m + t) - 1)
            r = m + t - d
            _add_at!(w̄, a * X[r, k], d + 1)
            X̄[r, k] += w[d + 1] * a
        end
    end
    return nothing
end

function _convolve_back!(X̄, c̄, c::_TVColumns{Primary}, X, Ȳ, m, start)
    D = _nlags(c)
    stop = start + size(Ȳ, 1) - 1
    for k in axes(Ȳ, 2), σ in max(1, start - D + 1):stop
        w = _wcolumn(c, k, σ)
        w̄ = _wcolumn(c̄, c, k, σ)
        o = σ - start + 1
        @inbounds x = X[σ, k]
        acc = zero(eltype(X̄))
        @inbounds @simd ivdep for d in max(0, start - σ):min(length(w) - 1, stop - σ)
            ȳ = Ȳ[o + d, k]
            _add_at!(w̄, ȳ * x, d + 1)
            acc += w[d + 1] * ȳ
        end
        @inbounds X̄[σ, k] += acc
    end
    return nothing
end

# A per-stratum kernel reads and adds each weight through `_weight` and
# `_add_weight!`.
function _convolve_back!(X̄, c̄, c::_TVPerStratum{Secondary}, X, Ȳ, m, start)
    D = _nlags(c)
    for k in axes(Ȳ, 2), j in axes(Ȳ, 1)
        t = start + j - 1
        a = Ȳ[j, k]
        for d in 0:(min(D, m + t) - 1)
            r = m + t - d
            _add_weight!(c̄, c, a * X[r, k], k, k, d + 1, t)
            X̄[r, k] += _weight(c, k, k, d + 1, t) * a
        end
    end
    return nothing
end

function _convolve_back!(X̄, c̄, c::_TVPerStratum{Primary}, X, Ȳ, m, start)
    D = _nlags(c)
    stop = start + size(Ȳ, 1) - 1
    for k in axes(Ȳ, 2), σ in max(1, start - D + 1):stop
        x = X[σ, k]
        acc = zero(eltype(X̄))
        for d in max(0, start - σ):min(D - 1, stop - σ)
            ȳ = Ȳ[σ + d - start + 1, k]
            _add_weight!(c̄, c, ȳ * x, k, k, d + 1, σ)
            acc += _weight(c, k, k, d + 1, σ) * ȳ
        end
        X̄[σ, k] += acc
    end
    return nothing
end

@doc raw"""
The lag contributions of a [`Convolution`](@ref): the terms of its sum over
lags, before the sum,

```math
c_{t,i,l} = g_{t,i}\, k_{i,l}(t)\, x_{t-l,i},
\qquad l = 0, \dots, L - 1, \quad t = t_0, \dots, t_1,
```

in the notation of [`Convolution`](@ref), so that
``\sum_l c_{t,i,l} + a_{t,i} = y_{t,i}``.
A [`ComposableRecurrences.Primary`](@ref) kernel reads ``k_{i,l}(t - l)``,
so ``c_{t,i,l}`` is the part of the input at time ``t - l`` that arrives
at ``t``: a reporting triangle by arrival time.
Terms whose input is before the history, or past a ragged column's end,
are zero.

Takes the arguments of a call of `c` except `add`, which no lag carries.
The output is `L × T` for a single series and `S × L × T` for `S` strata,
with `T = stop - start + 1` and lag 0 first, so summing over the lag axis
gives `c(x; gain, history, start, stop)`.
A [`ComposableRecurrences.NoAdjoint`](@ref) convolution is differentiated
by plain AD.

# Arguments
- `c`: the convolution, or its `NoAdjoint`.
- `x`: the inputs, as in a call of `c`.

# Keyword Arguments
- `gain`, `history`, `start`, `stop`: as in a call of `c`.

# Examples
```jldoctest
using ComposableRecurrences
c = Convolution([0.5, 0.3, 0.2])
Y = ComposableRecurrences.contributions(c, [1.0, 2.0, 4.0, 8.0])
vec(sum(Y; dims = 1)) ≈ c([1.0, 2.0, 4.0, 8.0]), Y

# output

(true, [0.5 1.0 2.0 4.0; 0.0 0.3 0.6 1.2; 0.0 0.0 0.2 0.4])
```
"""
contributions(c::Convolution, x; kwargs...) = _contributions(c, c, x; kwargs...)
function contributions(n::NoAdjoint{<:Convolution}, x; kwargs...)
    return _contributions(n.op, n, x; kwargs...)
end
function _contributions(
        c::Convolution, route, x; gain = true, history = nothing, start = 1,
        stop = nothing
    )
    op = _reroute(route, _Contributions(c))
    return adjoint_call(op, x, gain, history, start, stop)
end

# `contributions` routes through the rules as an operator of its own, with
# positional arguments `(x, gain, history, start, stop)`.
struct _Contributions{C <: Convolution} <: AbstractOperator
    c::C
end

function _run_forward(op::_Contributions, x, gain, history, start, stop)
    kernel = op.c.kernel
    Tp, S, m, stop = _check_conv(kernel, x, gain, nothing, history, start, stop)
    X = _input_buffer(Tp, x, history, m, S, stop)
    T = stop - start + 1
    L = _nlags(kernel)
    C = x isa AbstractVector ? _zeros(x, Tp, L, T) : _zeros(x, Tp, S, L, T)
    cur = _current()
    if cur.ex isa Serial
        _contribute!(Serial(), C, kernel, X, gain, m, start)
    else
        _contribute!(cur, C, kernel, X, gain, m, start)
    end
    return C, (; gain = _tape(gain), start, stop, X, m)
end

# Each stratum is one index of the executor loop.
function _contribute!(ex, C, kernel, X, gain, m, start)
    _each!(_contributions_body!, ex, C, size(X, 2), length(C), C, kernel, X, gain, m, start)
    return C
end

# Stratum `k`'s terms: lag `d` at output row `j` reads buffer row
# `m + t - d`, and rows before the buffer are zero inputs.
function _contributions_body!(k, C, kernel, X, gain, m, start)
    L = size(C, ndims(C) - 1)
    for j in axes(C, ndims(C))
        t = start + j - 1
        g = _at(gain, k, t)
        @inbounds for d in 0:(min(L, m + t) - 1)
            _setcell!(C, g * _lagweight(kernel, k, d, t) * X[m + t - d, k], k, d + 1, j)
        end
    end
    return nothing
end

Base.@propagate_inbounds _setcell!(C::AbstractMatrix, v, k, i, j) = (C[i, j] = v; nothing)
Base.@propagate_inbounds _setcell!(C::AbstractArray{<:Any, 3}, v, k, i, j) = (C[k, i, j] = v; nothing)
Base.@propagate_inbounds _cell(C::AbstractMatrix, k, i, j) = C[i, j]
Base.@propagate_inbounds _cell(C::AbstractArray{<:Any, 3}, k, i, j) = C[k, i, j]

# Stratum `k`'s weight on lag `d` at output time `t`, and its cotangent: a
# `Primary()` kernel reads the column of the input's time `t - d`.
Base.@propagate_inbounds _lagweight(c::AbstractVector, k, d, t) = c[d + 1]
Base.@propagate_inbounds _lagweight(c::PerStratum, k, d, t) = c.x[k, d + 1]
Base.@propagate_inbounds function _lagweight(c::TimeVarying, k, d, t)
    return _weight(c, k, k, d + 1, _lagcolumn(c, t, d))
end
_lagcolumn(c, t, d) = t
_lagcolumn(::TimeVarying{Primary}, t, d) = t - d
_add_lagweight!(c̄, c::AbstractVector, v, k, d, t) = add_cotangent!(c̄, v, d + 1)
function _add_lagweight!(c̄, c::PerStratum, v, k, d, t)
    return add_cotangent!(cotangent(c̄, :x), v, k, d + 1)
end
Base.@propagate_inbounds function _add_lagweight!(c̄, c::TimeVarying, v, k, d, t)
    return _add_weight!(c̄, c, v, k, k, d + 1, _lagcolumn(c, t, d))
end

# Each term's cotangent goes to its weight, its input and the gain.
function pullback!(grads, op::_Contributions, ::Run, cache)
    _count_pullback()
    (; gain, start, stop, X, m) = cache
    x̄, ḡ, h̄ = grads.args
    kernel = op.c.kernel
    k̄ = cotangent(cotangent(grads.piece, :c), :kernel)
    C̄ = grads.y
    X̄ = zero(X)
    L = _nlags(kernel)
    for k in axes(X, 2), j in 1:(stop - start + 1)
        t = start + j - 1
        g = _at(gain, k, t)
        acc = zero(eltype(X̄))
        for d in 0:(min(L, m + t) - 1)
            r = m + t - d
            @inbounds a = _cell(C̄, k, d + 1, j)
            @inbounds w = _lagweight(kernel, k, d, t)
            @inbounds x = X[r, k]
            acc += a * w * x
            @inbounds _add_lagweight!(k̄, kernel, g * a * x, k, d, t)
            @inbounds X̄[r, k] += g * w * a
        end
        _add_slot!(ḡ, acc, k, t)
    end
    _add_rows!(x̄, X̄, m, stop)
    _add_rows!(h̄, X̄, 0, m)
    return nothing
end
