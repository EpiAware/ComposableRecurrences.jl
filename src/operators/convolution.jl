@doc raw"""
How a [`Convolution`](@ref) computes its lag sum
```math
\sum_{l=0}^{L-1} k_{i,l}\, x_{t-l,i}.
```
The methods are [`ComposableRecurrences.Auto`](@ref) (the default),
[`ComposableRecurrences.Direct`](@ref) and
[`ComposableRecurrences.FFTMethod`](@ref).

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
It takes every kernel and number type.

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
transform of the zero-padded series, by overlap-add,
```math
\sum_{l=0}^{L-1} k_{i,l}\, x_{t-l,i}
= \mathcal{F}^{-1}\!\left[\mathcal{F}(k_i)\, \mathcal{F}(x_i)\right]_t .
```
The ``n = m + t_1`` buffered inputs, ``m`` from the history and the rest up
to the last time ``t_1``, are split into blocks of ``N - L + 1``, each
transformed at size ``N``, the smallest 5-smooth number at least
``\min(n + L - 1, 8L)``.
Lags from ``n`` on reach no input and are dropped first.
A block of the whole series is one transform.
For a series much longer than the kernel the cost is ``O(n \log L)``
rather than ``O(T L)``.
It is faster than the direct method from about 300 lags and 1000 outputs,
the sizes from which [`ComposableRecurrences.Auto`](@ref) takes it; time
both on the sizes of a model before choosing it.
The reverse pass uses the same transforms.

It runs once the weak dependency of the
[FFT extension](@ref extension-fftw) is loaded; without it, a call with
this method is refused.
It runs for a fixed kernel (a vector or [`PerStratum`](@ref)) on
`Float32` or `Float64` arrays; a [`TimeVarying`](@ref) kernel, any other
number type (dual numbers, say) and other arrays (device or traced) take
[`ComposableRecurrences.Direct`](@ref).
It does not use the set [`ComposableRecurrences.EXECUTOR`](@ref).

The transform's error in each sum is about the machine epsilon times the
size of the inputs and kernel in its block, not times the sum itself.
So each sum is checked against an estimate ``\epsilon_b`` of that error,
```math
\epsilon_b = \tfrac{1}{2} \log_2(N)\, \epsilon\, \lVert a_b \rVert_2\, \lVert k \rVert_2,
```
summed over the blocks ``a_b`` that reach it, with ``\epsilon`` the machine
epsilon; measured errors stay below about half of it.
The check is on each output after the gain and add input, on each input
cotangent with what it already holds, and on each kernel cotangent, summed
over the strata when they share the kernel.
A value whose estimate exceeds ``10^{-10}`` of it (``10^{-4}`` in `Float32`)
has its sum taken directly instead, and once such sums would cost more than
a quarter of the direct method, the whole pass takes the direct method.
So the outputs and gradients match the direct method to that relative
accuracy, and they cannot come out negative from a positive kernel and
inputs.
A series spanning many orders of magnitude, such as a long exponential
growth, then costs up to both methods together.
A `NaN` or `Inf` input makes every output its block's transform reaches
`NaN`, including earlier ones.

# Examples
```jldoctest; setup = :(using ComposableRecurrences, FFTW)
k = [0.1, 0.4, 0.3, 0.2]
x = collect(1.0:6.0)
Convolution(k; method = ComposableRecurrences.FFTMethod())(x) ≈ Convolution(k)(x)

# output

true
```
"""
struct FFTMethod <: ConvolutionMethod end

@doc raw"""
The default method of a [`Convolution`](@ref).
A call with a fixed kernel (a vector or [`PerStratum`](@ref)) of ``L`` lags,
``T`` outputs and `Float64` arrays on the CPU, once the weak dependency of
the [FFT extension](@ref extension-fftw) is loaded, takes
```math
\begin{cases}
\texttt{FFTMethod()} & L \ge 300 \text{ and } T \ge 1000, \\
\texttt{Direct()} & \text{otherwise}.
\end{cases}
```
Any other call takes [`ComposableRecurrences.Direct`](@ref).
From these sizes the transform is faster than the direct method on typical
series, forward and in reverse mode: by 1.02 to 1.14 times at 300 lags and
1000 outputs, and 1.5 to 2.1 times at 500 lags and 2000 outputs.
Below them the direct method is faster, up to 2 times.
So most models take the direct method, and `Float32` models never take the
transform.
The kernel, eltype, arrays and loaded packages are resolved by dispatch,
and the sizes by two integer comparisons per call.

Its accuracy, and its cost on a series spanning many orders of magnitude,
are those of [`ComposableRecurrences.FFTMethod`](@ref).

# Examples
```jldoctest
using ComposableRecurrences
k, x = [0.5, 0.5], [1.0, 2.0, 4.0]
Convolution(k)(x) == Convolution(k; method = ComposableRecurrences.Direct())(x)

# output

true
```
"""
struct Auto <: ConvolutionMethod end

# The sizes from which `Auto()` takes the transform.
const _AUTO_MIN_LAGS = 300
const _AUTO_MIN_TIMES = 1000
_auto_fft(L, T) = L >= _AUTO_MIN_LAGS && T >= _AUTO_MIN_TIMES

@doc raw"""
A convolution whose kernel starts at lag 0: each output weights the current
and past inputs, then is scaled by the gain and shifted by the add input,

```math
y_{t,i} = \gamma_{t,i} \sum_{l=0}^{L-1} k_{i,l}(t)\, x_{t-l,i} + a_{t,i},
\qquad t = t_0, \dots, t_1,
```

where ``y_{t,i}`` is the output of [stratum](@ref PerStratum) ``i``
at absolute time ``t``, ``x_{t-l,i}`` its input ``l`` steps earlier,
``k_{i,l}(t)`` = `kernel[l + 1]` the weight on lag ``l``, ``L`` the
kernel length, ``\gamma_{t,i}`` the gain and ``a_{t,i}`` the add input.
``x_\tau`` for ``\tau < 1`` comes from `history` and is zero before it.
Strata do not mix.
In the direct sum a zero weight multiplies its input rather than skipping
it, so ``0 \cdot \infty`` gives `NaN`, as `sum(k .* x)` does, and a
non-finite input reaches every output its lags feed; the transform of
[`ComposableRecurrences.FFTMethod`](@ref) spreads it further.
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
A sum that reads the inputs forward from each time is the transpose
`c'`, which [`transpose`](@ref Base.transpose(::Convolution)) sets out.

Called as `c(x; gain = 1, add, history = nothing, start = 1, stop)`, the
call covers the absolute times `start:stop`:

  - `x`: the inputs, length `T` or `S × T`, read at absolute time `t`. The
    inputs before `start` come from `x` itself, and the inputs after its
    end are zero.
  - `gain`: a scalar, a length-`T` vector shared by every stratum, or
    `S × T`, read at time `t`; one when left out.
  - `add`: `nothing`, a scalar, length `T` or `S × T`, read at time `t`.
  - `history`: the inputs before `t = 1`, oldest first (any length `m`, or
    `S × m`); earlier inputs are zero.
    Not with a `Primary()` kernel, which has no column for them.
  - `start`: the first time; `1` by default.
  - `stop`: the last time; by default the common length of the
    time-indexed inputs (`x`, `gain`, `add`).
    It may pass the end of `x`, but `gain` and `add` must cover it.
    Only the outputs that a lag of `x` reaches are summed, so an input
    that is zero from some time on can be passed up to that time, as in
    `c(x[:, 1:(t0 - 1)]; stop = T)`.

The output has the layout of `x` and length `stop - start + 1`.

# Arguments
- `kernel`: the kernel, lag 0 first, or a kernel of
  [delays](@ref ComposableRecurrences.delay_masses).

# Keyword Arguments
- `method`: how the lag sum is computed,
  [`ComposableRecurrences.Auto`](@ref) (the default),
  [`ComposableRecurrences.Direct`](@ref) or
  [`ComposableRecurrences.FFTMethod`](@ref).
- `lags`: for a kernel of delays only, the number of lags from lag 0.
- `step`: for a kernel of delays only, the width of a lag in the delays'
  own unit; `1` by default.

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
    function Convolution(
            kernel::K; method = Auto(), lags = nothing, step = 1
        ) where {K}
        lags === nothing ||
            return Convolution(_delay_kernel(kernel, lags, 0, step); method)
        _check_no_step(step)
        _check_no_delays(kernel)
        kernel isa Union{_PairwiseKernel, _Routes} && throw(
            ArgumentError(
                "a Pairwise kernel is for a Recurrence, not a " *
                    "Convolution; " *
                    "got $(_describe(kernel))"
            )
        )
        _is_method(method) || throw(
            ArgumentError(
                "method must be Auto(), Direct() or FFTMethod(); " *
                    "got $(repr(method))"
            )
        )
        _check_kernel_shape(kernel)
        _check_one_based(kernel)
        return new{K, typeof(method)}(kernel)
    end
end

# A method is a singleton `ConvolutionMethod`, so the type carries it.
_is_method(m) = m isa ConvolutionMethod && Base.issingletontype(typeof(m))

# The method is a type parameter rather than a field, so a convolution's
# only field is its kernel and AD mirrors of it stay as small as before.
_method(::Convolution{K, M}) where {K, M} = M()

# A rebuild of a `Convolution` from its kernel keeps its method.
struct _ConvolutionFlat{M} end
(::_ConvolutionFlat{M})(kernel) where {M} = Convolution(kernel; method = M())
function ConstructionBase.constructorof(::Type{<:Convolution{K, M}}) where {K, M}
    return _ConvolutionFlat{M}()
end

# The convolution loops read the kernel by lag from index 1, so a kernel
# array with offset axes is refused. Ragged columns check their own.
_check_one_based(kernel) = nothing
function _check_one_based(
        kernel::Union{
            AbstractArray, PerStratum,
            TimeVarying{<:Any, <:Union{AbstractArray, PerStratum}},
        }
    )
    A = _array(kernel)
    Base.has_offset_axes(A) && throw(
        ArgumentError(
            "a kernel indexes from 1, got $(_describe(kernel)) with axes " *
                "$(axes(A))"
        )
    )
    return nothing
end

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

# Checks the call, then convolves in the layout of `x` or into a time-first
# buffer. The cache keeps the lag sums `Y` before the gain, which the gain's
# cotangent reads, and the inputs they read: the buffer (history then `x`)
# with its row offset `o`, or `x` itself.
function _run_forward(c::Convolution, x, gain, add, history, start, stop)
    kernel = c.kernel
    Tp, S, m, stop = _check_conv(kernel, x, gain, add, history, start, stop)
    fft = _fft_path(_method(c), kernel, Tp, x, stop - start + 1)
    if !fft && _in_layout(Tp, kernel, x, history, start)
        Y, xr, r = _layout_sums(Tp, kernel, x, stop)
        # Unscaled, the output is `Y` itself: the reverse pass reads `Y`
        # only for a gain's cotangent, so a caller may change the output.
        out = _unscaled(gain, add) ? Y :
            _affine_layout!(similar(Y), Y, gain, add)
        return out, _LayoutCache(_tape(gain), add, xr, Y, false, r, _extent(x))
    end
    Y, X, o = if fft
        _fft_buffers(Tp, kernel, x, history, m, S, start, stop, gain, add)
    else
        _conv_buffers(Tp, kernel, x, history, m, S, start, stop)
    end
    out = _finish(Y, x, gain, add, start)
    return out, (; gain = _tape(gain), add, start, stop, X, Y, o, m, fft)
end
function _primal(c::Convolution, x, gain, add, history, start, stop)
    kernel = c.kernel
    Tp, S, m, stop = _check_conv(kernel, x, gain, add, history, start, stop)
    if _fft_path(_method(c), kernel, Tp, x, stop - start + 1)
        Y = first(_fft_buffers(Tp, kernel, x, history, m, S, start, stop, gain, add))
        return _finish(Y, x, gain, add, start)
    end
    if _in_layout(Tp, kernel, x, history, start)
        Y = first(_layout_sums(Tp, kernel, x, stop))
        return _unscaled(gain, add) ? Y : _affine_layout!(Y, Y, gain, add)
    end
    path = _conv_path(Tp, kernel, x)
    return _convolve_public(path, Tp, kernel, x, gain, add, history, m, S, start, stop)
end

# How a call without a rule convolves, chosen by dispatch on the buffer
# eltype, the kernel and the input. `_Buffered()` copies the input into a
# time-first buffer, convolves there and copies the lag sums out: the
# per-lag `axpy` body vectorises for IEEE floats and suits device arrays.
# `_Gathered()` reads the input and history where they are and writes each
# output once, in the public layout: for numbers that do not vectorise
# (dual numbers, `BigFloat`, tracked reals inside plain arrays) on CPU
# arrays, where each copy of a wide number costs more than the arithmetic
# it saves. A dense time-varying kernel gathers too, reading each weight in
# place. A tracked array input is not a CPU array here and keeps the
# buffer.
struct _Buffered end
struct _Gathered end
const _FixedKernel = Union{AbstractVector, PerStratum}
const _DenseTimeVarying = TimeVarying{
    <:Any, <:Union{AbstractMatrix, PerStratum{<:AbstractArray{<:Any, 3}}},
}
_conv_path(::Type{Tp}, kernel, x) where {Tp} = _Buffered()
function _conv_path(
        ::Type{Tp}, kernel::Union{_FixedKernel, _DenseTimeVarying}, x::_CPUArray
    ) where {Tp}
    return Tp <: Real && !(Tp <: _IEEEFloat) ? _Gathered() : _Buffered()
end

function _convolve_public(
        ::_Buffered, ::Type{Tp}, kernel, x, gain, add, history, m, S, start, stop
    ) where {Tp}
    Y, _, _ = _conv_buffers(Tp, kernel, x, history, m, S, start, stop)
    return _finish(Y, x, gain, add, start)
end
function _convolve_public(
        ::_Gathered, ::Type{Tp}, kernel, x, gain, add, history, m, S, start, stop
    ) where {Tp}
    Base.require_one_based_indexing(x)
    history === nothing || Base.require_one_based_indexing(history)
    T = stop - start + 1
    out = x isa AbstractVector ? similar(x, Tp, T) : similar(x, Tp, S, T)
    work = _work(_RunLoop(), out, length(out) * _nlags(kernel))
    _with_executor() do ex
        _each!(
            _gather_body!, ex, out, S, work, out, kernel, x, history, gain, add,
            m, start
        )
    end
    return out
end

# Stratum `k`'s outputs, each one dot of the kernel with its window: lags
# up to `t - 1` read `x`, older ones the history, and lags before the
# history, or after the end of `x`, read zeros.
# The call's checks fix every shape and the caller requires one-based
# indices, so the loops read without bounds checks.
function _gather_body!(k, out, kernel, x, history, gain, add, m, start)
    L = _nlags(kernel)
    e = _extent(x)
    for j in 1:size(out, ndims(out))
        t = start + j - 1
        acc = zero(eltype(out))
        @inbounds for d in max(0, t - e):(min(L, t) - 1)
            acc += _lagweight(kernel, k, d, t) * _at(x, k, t - d)
        end
        acc = _add_history(acc, kernel, history, k, t, L, m)
        @inbounds _set_at!(out, _affine(gain, add, k, t, acc), k, j)
    end
    return nothing
end
_add_history(acc, kernel, ::Nothing, k, t, L, m) = acc
function _add_history(acc, kernel, history, k, t, L, m)
    @inbounds for d in t:(min(L, m + t) - 1)
        acc += _lagweight(kernel, k, d, t) * _at(history, k, m + t - d)
    end
    return acc
end
Base.@propagate_inbounds _set_at!(y::AbstractVector, v, k, j) = (y[j] = v; nothing)
Base.@propagate_inbounds _set_at!(y::AbstractMatrix, v, k, j) = (y[k, j] = v; nothing)

# A fixed kernel over a plain array of IEEE floats, with no history and
# from the first time, convolves in the layout of `x`: lag `d` reads every
# stratum `S d` entries back. Threaded loops keep the time-first buffer,
# which splits the work by stratum.
_in_layout(::Type, kernel, x, history, start) = false
function _in_layout(
        ::Type{Tp}, ::AbstractVector, ::Union{Vector, Matrix}, ::Nothing, start
    ) where {Tp <: _IEEEFloat}
    return start == 1 && _current().ex isa Serial
end

# The lag sums `Y` of times 1 to `n`, with the inputs they read and the
# number `r` of times summed. Inputs after the end of `x` are zero, so only
# the first `min(n, extent + L - 1)` times can be nonzero: `r` covers them
# (all `n` for a series short enough to gather), they are summed from `x`
# and zeros by the passes the full series would take, and the later times
# stay zero.
function _layout_sums(::Type{Tp}, c, x::Vector, n) where {Tp}
    Y = zeros(Tp, n)
    xr, r = _summed_inputs(c, x, n)
    if r == n
        _convolve_series!(Y, c, reshape(xr, :, 1), 1, 0, 1)
    else
        Yr = zeros(Tp, r)
        _convolve_series!(Yr, c, reshape(xr, :, 1), 1, 0, 1, n)
        copyto!(Y, Yr)
    end
    return Y, xr, r
end
function _layout_sums(::Type{Tp}, c, x::Matrix, n) where {Tp}
    Y = zeros(Tp, size(x, 1), n)
    xr, r = _summed_inputs(c, x, n)
    if r == n
        _convolve_shifted!(Y, c, xr, size(x, 1))
    else
        Yr = zeros(Tp, size(x, 1), r)
        _convolve_shifted!(Yr, c, xr, size(x, 1))
        copyto!(Y, Yr)
    end
    return Y, xr, r
end
# `x` itself when it covers time `n`; otherwise `x` then zeros up to the
# last time its inputs reach. A series short enough to gather groups its
# outputs by its own length, so it is summed in full to keep each sum's
# order.
function _summed_inputs(c, x, n)
    e = _extent(x)
    e >= n && return x, n
    r = _short_slice(n, length(c)) ? n : min(n, e + length(c) - 1)
    xr = _zeros_to(x, r)
    copyto!(xr, x)
    return xr, r
end
_zeros_to(x::Vector, r) = zeros(eltype(x), r)
_zeros_to(x::Matrix, r) = zeros(eltype(x), size(x, 1), r)

# `Y[i] += c[d + 1] x[i - s d]` for every lag `d` and entry `i > s d`, in
# blocks of four lags as `_convolve_series!` takes them: the entries every
# lag of a block reaches take one pass, and the first entries of the
# block, which only its earlier lags reach, one pass per lag.
function _convolve_shifted!(Y, c, x, s)
    N = length(Y)
    s == 0 && return Y
    checkbounds(x, 1:N)
    L = min(length(c), N ÷ s)
    nb = L ÷ 4
    for b in 0:(nb - 1)
        d = 4b
        full = s * (d + 3)
        for q in 0:2
            _shifted_axpy!(Y, c[d + q + 1], x, s * (d + q), min(full, N))
        end
        full >= N && return Y
        r = s * d
        _axpy4!(
            c[d + 1], c[d + 2], c[d + 3], c[d + 4],
            view(x, (full + 1 - r):(N - r)),
            view(x, (full + 1 - r - s):(N - r - s)),
            view(x, (full + 1 - r - 2s):(N - r - 2s)),
            view(x, (full + 1 - r - 3s):(N - r - 3s)), view(Y, (full + 1):N)
        )
    end
    for d in (4nb):(L - 1)
        _shifted_axpy!(Y, c[d + 1], x, s * d, N)
    end
    return Y
end
# Entries `r + 1` to `last` of `Y` take `α` times `x` shifted by `r`.
@inline function _shifted_axpy!(Y, α, x, r, last)
    r >= last && return Y
    _axpy!(α, view(x, 1:(last - r)), view(Y, (r + 1):last))
    return Y
end

# The gain and add input applied to the lag sums `Y` into `out`, which may
# be `Y`.
function _affine_layout!(out, Y, gain, add)
    for j in axes(Y, ndims(Y)), k in 1:_nstrata(Y)
        @inbounds _set_at!(out, _affine(gain, add, k, j, _at(Y, k, j)), k, j)
    end
    return out
end

# The cache of a convolution in the layout of `x`: the gain and add input,
# `x` and the lag sums `Y` before the gain. `fft` is `false`, as in a
# buffered cache whose call did not take the transform.
struct _LayoutCache{G, A, X, Y}
    gain::G
    add::A
    x::X
    Y::Y
    fft::Bool
    # The times summed, and the times the caller's `x` covers; `x` above
    # holds the inputs to time `r`, zeros after the caller's last.
    r::Int
    e::Int
end
# A cache that holds `x` keeps a copy of it when the AD backend may
# overwrite `x` before the reverse pass; any other cache holds no input.
_keep_inputs(cache, overwritten::Bool) = cache
function _keep_inputs(c::_LayoutCache, overwritten::Bool)
    overwritten || return c
    return _LayoutCache(c.gain, c.add, copy(c.x), c.Y, c.fft, c.r, c.e)
end

# The reverse pass in the layout of `x`, the transpose of the forward pass:
# `x̄[j] += Σ_d c[d + 1] Ȳ[j + s d]` and `c̄[d + 1] += Σ_j Ȳ[j + s d] x[j]`.
# Without the gain or add input, `Ȳ` is the output's cotangent itself.
function pullback!(grads, c::Convolution, ::Run, cache::_LayoutCache)
    _count_pullback()
    (; gain, add, x, Y) = cache
    x̄, ḡ, ā, _ = grads.args
    Ȳ = _unscaled(gain, add) ? grads.y :
        _scale_back_layout(ḡ, ā, grads.y, Y, gain)
    k̄ = cotangent(grads.piece, :kernel)
    s = _nstrata(x)
    s == 0 && return nothing
    (; r, e) = cache
    L = min(length(c.kernel), r)
    if e >= r
        N = length(Ȳ)
        checkbounds(x, 1:N)
        x̄ === nothing || checkbounds(x̄, 1:N)
        _shifted_back!(x̄, k̄, c.kernel, x, Ȳ, s, L)
    else
        # Only the first `r` times were summed, from `x` and zeros: the
        # later outputs read no input, and the zeros take no cotangent.
        # The back pass writes a cotangent for every summed input, zeros
        # included, so it takes one over all `r` times, and plain copies
        # keep the native loops on plain arrays.
        N = s * r
        x̄r = x̄ === nothing ? nothing : zeros(eltype(x̄), size(x))
        _shifted_back!(x̄r, k̄, c.kernel, x, Ȳ[1:N], s, L)
        x̄ === nothing || (view(x̄, 1:(s * e)) .+= view(x̄r, 1:(s * e)))
    end
    return nothing
end

# The cotangent of the lag sums from the output's `ȳ`, adding the gain's
# and the add input's on the way.
function _scale_back_layout(ḡ, ā, ȳ, Y, gain)
    Ȳ = similar(Y)
    for j in axes(Y, ndims(Y)), k in 1:_nstrata(Y)
        @inbounds a = _at(ȳ, k, j)
        _add_slot!(ā, a, k, j)
        @inbounds _add_slot!(ḡ, a * _at(Y, k, j), k, j)
        @inbounds _set_at!(Ȳ, _at(gain, k, j) * a, k, j)
    end
    return Ȳ
end

# `x̄[j] += c[d + 1] Ȳ[j + s d]` and `c̄[d + 1] += Σ_j Ȳ[j + s d] x[j]` for
# the first `L` lags: four lags a pass over the entries they all reach,
# each read of `Ȳ` serving both, then one pass per lag for the rest.
function _shifted_back!(x̄, c̄, c, x, Ȳ, s, L)
    N = length(Ȳ)
    nb = L ÷ 4
    for b in 0:(nb - 1)
        d = 4b
        r = s * d
        J = N - s * (d + 3)
        y = ntuple(q -> view(Ȳ, (r + (q - 1) * s + 1):(r + (q - 1) * s + J)), 4)
        a = _back4!(
            _part(x̄, 1:J), view(x, 1:J),
            c[d + 1], c[d + 2], c[d + 3], c[d + 4], y...
        )
        for q in 0:3
            # Entries past `J`, which only the block's earlier lags reach.
            e = s * (d + q)
            t = q == 3 ? zero(eltype(a)) :
                _back1!(
                    _part(x̄, (J + 1):(N - e)), view(x, (J + 1):(N - e)),
                    c[d + q + 1], view(Ȳ, (J + 1 + e):N)
                )
            add_cotangent!(c̄, a[q + 1] + t, d + q + 1)
        end
    end
    for d in (4nb):(L - 1)
        r = s * d
        t = _back1!(
            _part(x̄, 1:(N - r)), view(x, 1:(N - r)), c[d + 1],
            view(Ȳ, (r + 1):N)
        )
        add_cotangent!(c̄, t, d + 1)
    end
    return nothing
end
_shifted_back!(::Nothing, ::Nothing, c, x, Ȳ, s, L) = nothing

# One lag's pass, `x̄ .+= α y` and `Σ_j x[j] y[j]`, and four lags' passes
# `x̄ .+= Σ_q α_q y_q` and the four sums `Σ_j x[j] y_q[j]`, as native loops.
# A constant input (`x̄` is `nothing`) takes only the sums.
@inline function _back1!(x̄, x, α, y)
    _same_length(y, x)
    acc = zero(promote_type(eltype(x), eltype(y)))
    @inbounds @simd ivdep for i in eachindex(y)
        yi = y[i]
        acc += x[i] * yi
        _add_to!(x̄, α * yi, i)
    end
    return acc
end
@inline function _back4!(x̄, x, α₀, α₁, α₂, α₃, y₀, y₁, y₂, y₃)
    _same_length(x, y₀, y₁, y₂, y₃)
    a₀ = a₁ = a₂ = a₃ = zero(promote_type(eltype(x), eltype(y₀)))
    @inbounds @simd ivdep for i in eachindex(x)
        xi = x[i]
        u₀, u₁, u₂, u₃ = y₀[i], y₁[i], y₂[i], y₃[i]
        a₀ += xi * u₀
        a₁ += xi * u₁
        a₂ += xi * u₂
        a₃ += xi * u₃
        _add_to!(x̄, α₀ * u₀ + α₁ * u₁ + α₂ * u₂ + α₃ * u₃, i)
    end
    return (a₀, a₁, a₂, a₃)
end
Base.@propagate_inbounds _add_to!(x̄, v, i) = (x̄[i] += v; nothing)
_add_to!(::Nothing, v, i) = nothing
_part(::Nothing, r) = nothing
_part(x̄, r) = view(x̄, r)

# The input buffer and the lag sums by the transform, checked on the output
# they give with the gain and add input.
function _fft_buffers(
        ::Type{Tp}, kernel, x, history, m, S, start, stop, gain, add
    ) where {Tp}
    X, o = _input_buffer(Tp, kernel, x, history, m, S, start, stop)
    Y = _zeros(x, Tp, stop - start + 1, S)
    _fft_convolve!(Y, kernel, X, o, start, gain, add)
    return Y, X, o
end

# Whether a call of `T` outputs takes the transform: never for `Direct()`.
# For `FFTMethod()` the FFT extension adds the methods that answer; without
# it the call is refused. `Auto()` takes the direct method unless that
# extension adds a method for the kernel, eltype and arrays, which then
# checks the sizes.
function _fft_path(method, kernel, ::Type{Tp}, x, T) where {Tp}
    return !(method isa Auto) && _fft_path(method, kernel, Tp, x)
end
_fft_path(::Direct, kernel, ::Type, x) = false
_fft_path(::FFTMethod, kernel, ::Type, x) = _no_fftw()
function _no_fftw()
    throw(
        ArgumentError(
            "FFTMethod() needs the FFTW package: load it with `using FFTW`"
        )
    )
end

# The transform's forward and reverse passes over `Float32` or `Float64`
# buffers, added by the FFTW extension. `_fft_convolve_terms!` adds the sum
# of several lag sums `((kernel, X), ...)`, checked as one.
_fft_convolve!(Y, kernel, X, m, start, gain = true, add = nothing) = _no_fftw()
_fft_convolve_terms!(Y, terms, m, start) = _no_fftw()
_fft_convolve_back!(X̄, k̄, kernel, X, Ȳ, m, start) = _no_fftw()

# Whether AD is tracing the code that calls this: `false` under forward-mode
# AD and plain reverse-mode AD, whose extensions say so, and `true`
# otherwise, including the forward pass of a native rule, which runs as
# primal code. Inference must not see the constant, or it folds the branch
# away before the AD rules replace it.
# Dispatch on the method, kernel and eltype cannot make this choice: code
# that a reverse-mode AD tool traces reaches `_fft_path` with the same
# `Float64` arrays as a primal call, so only a call these rules replace can
# tell them apart. Forward-mode dual eltypes already take the direct method
# by dispatch.
_untraced() = Base.inferencebarrier(true)::Bool

# The checks a convolution call shares with `contributions`; returns the
# buffer eltype, the strata, the history length and the last time.
function _check_conv(kernel, x, gain, add, history, start, stop)
    _check_unwrapped(:x, x)
    _check_unwrapped(:gain, gain)
    _check_unwrapped(:add, add)
    _require_one_based(gain)
    _require_one_based(add)
    S = _nstrata(x)
    m = history === nothing ? 0 : size(history, ndims(history))
    _check_input_history(history, x)
    _check_primary_history(kernel, history)
    _check_kernel_strata(kernel, S)
    _check_strata(:gain, gain, S)
    _check_strata(:add, add, S)
    # An explicit `stop` may pass the end of `x`, whose later inputs are
    # zero; the gain and add input must still cover it.
    stop = stop === nothing ?
        _stop(
            stop,
            (:x => _extent(x), :gain => _extent(gain), :add => _extent(add))
        ) : _stop(stop, (:gain => _extent(gain), :add => _extent(add)))
    start >= 1 || throw(ArgumentError("start ($start) must be at least 1"))
    stop >= start - 1 || throw(
        ArgumentError("stop ($stop) is before start ($start)")
    )
    _check_kernel_times(kernel, stop)
    _check_device(x, (kernel, history, gain, add))
    Tp = float(param_eltype((kernel, x, history, gain, add)))
    return Tp, S, m, stop
end

# Allocates and fills the input buffer and convolves it into the output
# buffer at eltype `Tp` with the set executor; an extension adds methods for
# its own number types.
function _conv_buffers(::Type{Tp}, kernel, x, history, m, S, start, stop) where {Tp}
    return _with_executor() do ex
        _conv_buffers(Tp, ex, kernel, x, history, m, S, start, stop)
    end
end

function _conv_buffers(
        ::Type{Tp}, ex, kernel, x, history, m, S, start, stop
    ) where {Tp}
    X, o = _input_buffer(Tp, kernel, x, history, m, S, start, stop)
    Y = _zeros(x, Tp, stop - start + 1, S)
    _convolve!(ex, Y, kernel, X, o, start)
    return Y, X, o
end

# The inputs the outputs from `start` read, time first: history then `x`,
# and the buffer's row offset `o`, so row `o + t` holds time `t`. The
# buffer starts at the oldest lag of the first output, or at the start of
# the history if that is later: a late `start` leaves the earlier inputs
# out rather than copying them. From `start = 1` the offset is the history
# length `m`, or `L - 1` if the history is longer.
function _input_buffer(::Type{Tp}, kernel, x, history, m, S, start, stop) where {Tp}
    lo = clamp(start - _nlags(kernel) + 1, 1 - m, stop + 1)
    o = 1 - lo
    X = _zeros(x, Tp, o + stop, S)
    n = max(o, 0)
    history === nothing || _load_history!(X, history, n)
    _load_input!(X, x, o, stop, lo)
    return X, o
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
        out[j] = _affine(gain, add, 1, t, Y[j, 1])
    end
    return out
end
function _scaled_public(Y::Array, x::AbstractMatrix, gain, add, start)
    out = similar(Y, size(Y, 2), size(Y, 1))
    @inbounds for j in axes(Y, 1), k in axes(Y, 2)
        t = start + j - 1
        out[k, j] = _affine(gain, add, k, t, Y[j, k])
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

# Load the inputs at times `lo` to `stop` into buffer rows `m + lo` on; the
# rows past the end of `x` keep the buffer's zeros.
function _load_input!(X, x::AbstractVector, m, stop, lo = 1)
    f = max(lo, 1)
    stop = min(stop, _extent(x))
    X[(m + f):(m + stop), 1] .= view(x, f:stop)
    return X
end
function _load_input!(X, x::AbstractMatrix, m, stop, lo = 1)
    f = max(lo, 1)
    stop = min(stop, _extent(x))
    X[(m + f):(m + stop), :] .= transpose(view(x, :, f:stop))
    return X
end

# CPU buffers load by loop: a broadcast copy may alias its source, and
# reverse-mode AD cannot give that branch one activity when the input is
# constant.
# The bounds are checked once, so the loops read without bounds checks.
function _load_input!(X::Array, x::AbstractVector, m, stop, lo = 1)
    f = max(lo, 1)
    stop = min(stop, _extent(x))
    f > stop && return X
    checkbounds(X, (m + f):(m + stop), 1)
    checkbounds(x, f:stop)
    @inbounds for t in f:stop
        X[m + t, 1] = x[t]
    end
    return X
end
function _load_input!(X::Array, x::AbstractMatrix, m, stop, lo = 1)
    f = max(lo, 1)
    stop = min(stop, _extent(x))
    f > stop && return X
    checkbounds(X, (m + f):(m + stop), :)
    checkbounds(x, axes(X, 2), f:stop)
    @inbounds for t in f:stop, k in axes(X, 2)
        X[m + t, k] = x[k, t]
    end
    return X
end

# Lags in blocks of four over each stratum's contiguous series, one pass
# over the output per block: output row `j` is time `start + j - 1`, and lag
# `d` adds `c[d + 1]` times buffer row `o + j - d`, `o = m + start - 1`, for
# every row with a defined input. Rows that only some lags of a block reach,
# and the lags after the last block, take one `axpy` per lag. IEEE floats
# vectorise this; other numbers that reach the buffer (on device arrays, a
# tracked array input or a time-varying kernel's caller) gather instead, one
# dot of the kernel with the window per output, so each output is written
# once and its sum stays in registers. Up to three kernel lengths of
# outputs pay more in per-lag loop overhead than the passes save, so they
# gather four outputs at a time.
function _convolve_series!(
        y::AbstractVector{<:_IEEEFloat}, c, X, k, m, start, n = length(y)
    )
    T = length(y)
    # The choice of passes follows the length `n` of the whole series, of
    # which `y` may be the first part, so each output takes the same sums.
    _short_slice(n, length(c)) && return _gather4!(y, c, X, k, m, start)
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
function _convolve_series!(y, c, X, k, m, start, n = length(y))
    for j in eachindex(y)
        y[j] = _lag_dot(c, X, k, m + start + j - 1)
    end
    return y
end

# The kernel `c` against stratum `k`'s window ending at buffer row `r`: lag
# `d` reads row `r - d`, and lags past the first row read zeros.
@inline _lag_dot(c, X, k, r) = _tail_dot(c, X, k, r, 0, min(length(c), r) - 1)

# Whether `n` outputs of a kernel with `L` lags gather rather than take
# one pass per lag.
_short_slice(n, L) = n <= 3L

# Four outputs per pass over the lags, each sum in its own register; an
# output whose window starts before the buffer, and the last outputs that
# do not fill a group of four, take one dot each.
function _gather4!(y, c, X, k, m, start)
    L = length(c)
    T = length(y)
    j = 1
    @inbounds while j <= T
        r = m + start + j - 1
        if j + 3 <= T && r >= L
            a₀ = a₁ = a₂ = a₃ = zero(eltype(y))
            @simd for d in 0:(L - 1)
                cd = c[d + 1]
                a₀ += cd * X[r - d, k]
                a₁ += cd * X[r + 1 - d, k]
                a₂ += cd * X[r + 2 - d, k]
                a₃ += cd * X[r + 3 - d, k]
            end
            y[j], y[j + 1], y[j + 2], y[j + 3] = a₀, a₁, a₂, a₃
            j += 4
        else
            y[j] = _lag_dot(c, X, k, r)
            j += 1
        end
    end
    return y
end

# Lag `d`'s part of output rows up to `jlast`, from its first defined row.
@inline function _lag_axpy!(y, c, X, k, o, d, jlast)
    j0 = max(1, d + 1 - o)
    j0 > jlast && return y
    _axpy!(c[d + 1], view(X, (o + j0 - d):(o + jlast - d), k), view(y, j0:jlast))
    return y
end

# `y .+= α x` and `y .+= α₀ x₀ .+ α₁ x₁ .+ α₂ x₂ .+ α₃ x₃` as native loops:
# at these lengths they are faster than BLAS calls. Under plain `Mooncake`
# AD the extension swaps in BLAS `axpy!`, which `Mooncake` differentiates
# with one rule.
@inline function _axpy!(α, x, y)
    _same_length(y, x)
    @inbounds @simd ivdep for i in eachindex(y)
        y[i] += α * x[i]
    end
    return y
end
@inline function _axpy4!(α₀, α₁, α₂, α₃, x₀, x₁, x₂, x₃, y)
    _same_length(y, x₀, x₁, x₂, x₃)
    @inbounds @simd ivdep for i in eachindex(y)
        y[i] += α₀ * x₀[i] + α₁ * x₁[i] + α₂ * x₂[i] + α₃ * x₃[i]
    end
    return y
end

# The vectors an axpy reads have the axes of the one it writes. The message
# is a constant: a device kernel cannot format the axes into a string, as
# `eachindex` over several arrays does when they differ. Every comparison
# runs, and the throw sits behind a call, so the check stays branch-light.
@inline _same_length(y, x) = axes(x) == axes(y) || _axpy_mismatch()
@inline function _same_length(y, x₀, x₁, x₂, x₃)
    a = axes(y)
    return (axes(x₀) == a) & (axes(x₁) == a) & (axes(x₂) == a) &
        (axes(x₃) == a) || _axpy_mismatch()
end
@noinline _axpy_mismatch() =
    throw(DimensionMismatch("axpy vectors have different axes"))

# Each stratum is one index of the executor loop; `work` counts one
# multiply-add per output row and lag. On a device, a kernel that gathers
# each output from its window runs one output per index instead: outputs
# are independent, and neighbouring indices read neighbouring rows.
function _convolve!(ex, Y, c, X, m, start)
    S = size(Y, 2)
    work = _work(_ConvLoop(), Y, length(Y) * _nlags(c))
    if _gathers(c) && _on_device(ex, Y)
        _each!(_convolve_output!, ex, Y, length(Y), work, Y, c, X, m, start)
    else
        _each!(_convolve_body!, ex, Y, S, work, Y, c, X, m, start)
    end
    return Y
end

# Whether each output of kernel `c` is one dot of its weights with the
# window it reads, so an output can run on its own.
_gathers(c) = false
_gathers(::Union{AbstractVector, PerStratum, _TVColumns{Secondary}}) = true

# Output `i` of `Y`, in column-major order: row `j` of stratum `k`.
function _convolve_output!(i, Y, c, X, m, start)
    j, k = mod1(i, size(Y, 1)), cld(i, size(Y, 1))
    t = start + j - 1
    @inbounds Y[j, k] = _lag_dot(_output_weights(c, k, t), X, k, m + t)
    return nothing
end
_output_weights(c::AbstractVector, k, t) = c
_output_weights(c::PerStratum, k, t) = view(c.x, k, :)
_output_weights(c::_TVColumns{Secondary}, k, t) = _wcolumn(c, k, t)
# A per-stratum time-varying kernel stores its weights strata fastest, so
# strata run inside time, in blocks from `_nblocks`: one, or one per task
# when the loop splits. Device arrays keep one stratum per index, and a
# traced call its own loop.
function _convolve!(
        ex::Union{Serial, _Current}, Y::Array, c::_TVPerStratum, X, m, start
    )
    S = size(Y, 2)
    work = _work(_ConvLoop(), Y, length(Y) * _nlags(c))
    n = _nblocks(ex, S, work)
    _each!(_convolve_block!, ex, Y, n, work, n, Y, c, X, m, start)
    return Y
end
function _convolve_block!(b, n, Y, c, X, m, start)
    _strata_forward!(_chunk(b, size(Y, 2), n), Y, c, X, m, start)
    return nothing
end

function _convolve_body!(k, Y, c::AbstractVector, X, m, start)
    _convolve_series!(view(Y, :, k), c, X, k, m, start)
    return nothing
end

function _convolve_body!(k, Y, c::PerStratum, X, m, start)
    _convolve_series!(view(Y, :, k), view(c.x, k, :), X, k, m, start)
    return nothing
end

# A column kernel in Secondary indexing: output time `t` reads its own
# column as a vector, which vectorises when it is contiguous.
function _convolve_body!(k, Y, c::_TVColumns{Secondary}, X, m, start)
    for j in axes(Y, 1)
        t = start + j - 1
        @inbounds Y[j, k] = _lag_dot(_wcolumn(c, k, t), X, k, m + t)
    end
    return nothing
end
# A column kernel in Primary indexing: the input at time `σ`, buffer row
# `m + σ`, spreads forward through its own column. There is no history, so
# `σ` starts at 1, and an input after the last column spreads nowhere.
function _convolve_body!(k, Y, c::_TVColumns{Primary}, X, m, start)
    D = _nlags(c)
    stop = start + size(Y, 1) - 1
    for σ in max(1, start - D + 1):min(stop, _last_column(c))
        w = _wcolumn(c, k, σ)
        @inbounds x = X[m + σ, k]
        o = σ - start + 1
        @inbounds @simd ivdep for d in max(0, start - σ):min(length(w) - 1, stop - σ)
            Y[o + d, k] += w[d + 1] * x
        end
    end
    return nothing
end
# The last input time a `Primary()` kernel has a column for, and the first
# lag at output time `t` whose input has one: guards for the transpose,
# which runs these bodies past the kernel's last column.
_last_column(c::TimeVarying) = _extent(_array(c))
_last_column(c::TimeVarying{<:Any, <:_AnyRagged}) = _ncols(c.x)
_first_lag(c, t) = 0
_first_lag(c::TimeVarying{Primary}, t) = max(0, t - _last_column(c))

# A per-stratum kernel, in either indexing: one dot per output time `t` of
# the window with the weights `_lagweight` reads, from the column
# `_lagcolumn` picks for the indexing. The column bodies above measured
# faster for column kernels, this for per-stratum ones. Time runs
# outermost, so the strata `ks` read neighbouring weights in turn.
function _convolve_body!(k, Y, c::_TVPerStratum, X, m, start)
    _strata_forward!(k:k, Y, c, X, m, start)
    return nothing
end
function _strata_forward!(ks, Y, c, X, m, start)
    L = _nlags(c)
    for j in axes(Y, 1), k in ks
        t = start + j - 1
        acc = zero(eltype(Y))
        @inbounds for d in _first_lag(c, t):(min(L, m + t) - 1)
            acc += _lagweight(c, k, d, t) * X[m + t - d, k]
        end
        @inbounds Y[j, k] = acc
    end
    return nothing
end

# The reverse pass: take the output cotangent back through the gain and
# add input, then correlate it with the kernel into the input buffer's
# cotangent and with the inputs into the kernel's. `grads.args` are the
# mirrors of `(x, gain, add, history, start, stop)`.
function pullback!(grads, c::Convolution, ::Run, cache)
    _count_pullback()
    (; gain, add, start, X, Y, o, m, stop) = cache
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
        _fft_convolve_back!(X̄, k̄, c.kernel, X, Ȳ, o, start)
    else
        _with_executor(_convolve_back!, X̄, k̄, c.kernel, X, Ȳ, o, start)
    end
    _add_window!(x̄, h̄, X̄, o, m, stop)
    return nothing
end

# The cotangent of the lag sums `Ȳ` from the output's `ȳ`, adding the gain's
# and the add input's on the way.
function _scale_back!(Ȳ, ḡ, ā, ȳ, Y, gain, start)
    for j in axes(Ȳ, 1), k in axes(Ȳ, 2)
        t = start + j - 1
        @inbounds a = _at(ȳ, k, j)
        _add_slot!(ā, a, k, t)
        @inbounds _add_slot!(ḡ, a * Y[j, k], k, t)
        @inbounds Ȳ[j, k] = _at(gain, k, t) * a
    end
    return nothing
end

# The cotangent of an input buffer with row offset `o` into those of `x`
# and of a history of length `m`: the buffer holds the last `max(o, 0)`
# times of the history and `x` from time `max(1 - o, 1)` on.
function _add_window!(x̄, h̄, X̄, o, m, stop)
    n = max(o, 0)
    _add_rows!(x̄, X̄, o, max(1 - o, 1), _within(x̄, stop))
    _add_rows!(h̄, X̄, n - m, m - n + 1, m)
    return nothing
end

# The last time of `stop` that the input of cotangent `x̄` has.
_within(::Nothing, stop) = stop
_within(x̄, stop) = min(stop, _extent(x̄))

# Add buffer rows `o + f` to `o + n` into entries `f` to `n` of the
# public-layout cotangent `x̄`.
_add_rows!(::Nothing, X̄, o, f, n) = nothing
function _add_rows!(x̄::AbstractVector, X̄, o, f, n)
    view(x̄, f:n) .+= view(X̄, (o + f):(o + n), 1)
    return nothing
end
function _add_rows!(x̄::AbstractMatrix, X̄, o, f, n)
    view(x̄, :, f:n) .+= transpose(view(X̄, (o + f):(o + n), :))
    return nothing
end

# The strata run in blocks of the executor `ex`; each block adds the kernel
# cotangent into its own accumulator.
function _convolve_back!(ex, X̄, c̄, c, X, Ȳ, m, start)
    S = size(Ȳ, 2)
    accs = _accumulators(
        ex, X̄, S, _work(_ConvLoop(), X̄, length(Ȳ) * _nlags(c)), (; c̄)
    )
    _reduce_blocks!(_convolve_back_body!, accs, S, X̄, c, X, Ȳ, m, start)
    _reduce!(accs)
    return nothing
end
function _convolve_back_body!(ks, acc, X̄, c, X, Ȳ, m, start)
    _strata_back!(ks, X̄, acc.c̄, c, X, Ȳ, m, start)
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

function _strata_back!(ks, X̄, c̄, c::AbstractVector, X, Ȳ, m, start)
    for k in ks
        _convolve_series_back!(
            view(X̄, :, k), c̄, c, view(X, :, k), view(Ȳ, :, k), m, start
        )
    end
    return nothing
end

function _strata_back!(ks, X̄, c̄, c::PerStratum, X, Ȳ, m, start)
    C̄ = cotangent(c̄, :x)
    for k in ks
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
function _strata_back!(ks, X̄, c̄, c::_TVColumns{Secondary}, X, Ȳ, m, start)
    for k in ks, j in axes(Ȳ, 1)
        t = start + j - 1
        w = _wcolumn(c, k, t)
        w̄ = _wcolumn(c̄, c, k, t)
        @inbounds a = Ȳ[j, k]
        _tail_back!(w̄, X̄, w, X, a, k, m + t, 0, min(length(w), m + t) - 1)
    end
    return nothing
end

function _strata_back!(ks, X̄, c̄, c::_TVColumns{Primary}, X, Ȳ, m, start)
    D = _nlags(c)
    stop = start + size(Ȳ, 1) - 1
    for k in ks, σ in max(1, start - D + 1):min(stop, _last_column(c))
        w = _wcolumn(c, k, σ)
        w̄ = _wcolumn(c̄, c, k, σ)
        o = σ - start + 1
        @inbounds x = X[m + σ, k]
        acc = zero(eltype(X̄))
        @inbounds @simd ivdep for d in max(0, start - σ):min(length(w) - 1, stop - σ)
            ȳ = Ȳ[o + d, k]
            _add_at!(w̄, ȳ * x, d + 1)
            acc += w[d + 1] * ȳ
        end
        @inbounds X̄[m + σ, k] += acc
    end
    return nothing
end

# A per-stratum kernel's reverse pass, in either indexing, the transpose
# of its forward body: each output cotangent adds to the weights it read,
# through `_add_lagweight!`, and to the inputs. Time runs outermost, as in
# the forward pass; a single stratum keeps its loop free of the strata loop.
function _strata_back!(ks, X̄, c̄, c::_TVPerStratum, X, Ȳ, m, start)
    L = _nlags(c)
    if length(ks) == 1
        k = first(ks)
        for j in axes(Ȳ, 1)
            _lag_back!(X̄, c̄, c, X, Ȳ, m, start, L, j, k)
        end
    else
        for j in axes(Ȳ, 1), k in ks
            _lag_back!(X̄, c̄, c, X, Ȳ, m, start, L, j, k)
        end
    end
    return nothing
end
@inline function _lag_back!(X̄, c̄, c, X, Ȳ, m, start, L, j, k)
    t = start + j - 1
    @inbounds a = Ȳ[j, k]
    @inbounds for d in _first_lag(c, t):(min(L, m + t) - 1)
        r = m + t - d
        _add_lagweight!(c̄, c, a * X[r, k], k, d, t)
        X̄[r, k] += _lagweight(c, k, d, t) * a
    end
    return nothing
end

@doc raw"""
The lag contributions of a [`Convolution`](@ref): the terms of its sum over
lags, before the sum,

```math
c_{t,i,l} = \gamma_{t,i}\, k_{i,l}(t)\, x_{t-l,i},
\qquad l = 0, \dots, L - 1, \quad t = t_0, \dots, t_1,
```

in the notation of [`Convolution`](@ref), so that
``\sum_l c_{t,i,l} + a_{t,i} = y_{t,i}``.
A [`ComposableRecurrences.Primary`](@ref) kernel reads ``k_{i,l}(t - l)``,
so ``c_{t,i,l}`` is the part of the input at time ``t - l`` that arrives
at ``t``: a reporting triangle by arrival time.
Terms whose input is before the history, or past a ragged column's end,
are zero.
A kernel computed from coefficients (`TimeVarying(d, Primary())` with `d` a
[`ComposableRecurrences.Derived`](@ref) or a
[`ComposableRecurrences.Survival`](@ref)) is an `ArgumentError`: pass the
dense kernel of its weights, `TimeVarying(K, Primary())`.

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
    X, o = _input_buffer(Tp, kernel, x, history, m, S, start, stop)
    T = stop - start + 1
    L = _nlags(kernel)
    C = x isa AbstractVector ? _zeros(x, Tp, L, T) : _zeros(x, Tp, S, L, T)
    _with_executor(_contribute!, C, kernel, X, gain, o, start)
    return C, (; gain = _tape(gain), start, stop, X, o, m)
end

# Each stratum is one index of the executor loop.
function _contribute!(ex, C, kernel, X, gain, m, start)
    work = _work(_ConvLoop(), C, length(C))
    _each!(_contributions_body!, ex, C, size(X, 2), work, C, kernel, X, gain, m, start)
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
    (; gain, start, stop, X, o, m) = cache
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
        for d in 0:(min(L, o + t) - 1)
            r = o + t - d
            @inbounds a = _cell(C̄, k, d + 1, j)
            @inbounds w = _lagweight(kernel, k, d, t)
            @inbounds x = X[r, k]
            acc += a * w * x
            @inbounds _add_lagweight!(k̄, kernel, g * a * x, k, d, t)
            @inbounds X̄[r, k] += g * w * a
        end
        _add_slot!(ḡ, acc, k, t)
    end
    _add_window!(x̄, h̄, X̄, o, m, stop)
    return nothing
end

@implements PieceInterface Convolution [
    Arguments(;
        piece = Convolution([0.1, 0.6, 0.3]), role = Run(),
        args = ([1.0, 2.0, 3.0, 4.0],)
    ),
    Arguments(;
        piece = Convolution([0.1, 0.6, 0.3]), role = Run(),
        args = ([1.0 2.0 3.0; 4.0 5.0 6.0],),
        kwargs = (; history = [1.0 1.0; 2.0 2.0])
    ),
]
