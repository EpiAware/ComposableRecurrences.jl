# The `FFTMethod()` lag sum of a fixed-kernel `Convolution`, by overlap-add,
# and its reverse pass through the same transforms. Plans are made once per
# size, strata count and eltype; buffers are made per call, so concurrent
# calls share no state.
module ComposableRecurrencesFFTWExt

using ComposableRecurrences: ComposableRecurrences, FFTMethod, PerStratum,
    _CPUArray, _nlags, _untraced, add_cotangent!, cotangent
using FFTW: FFTW, plan_irfft, plan_rfft
using LinearAlgebra: mul!

const _FFTFloat = Union{Float32, Float64}

# A time-varying kernel, another number type or another array takes the
# direct method; so does a call AD traces.
ComposableRecurrences._fft_path(::FFTMethod, kernel, ::Type, x::AbstractArray) = false
function ComposableRecurrences._fft_path(
        ::FFTMethod, ::Union{AbstractVector, PerStratum{<:AbstractMatrix}},
        ::Type{<:_FFTFloat}, x::_CPUArray
    )
    return _untraced()
end

# The transform size for `n` inputs and `L` lags: one block of the whole
# series, or blocks of about `7L` inputs, whichever is smaller. 5-smooth
# sizes are fast; some 7-smooth ones are not.
_fftlen(n) = nextprod((2, 3, 5), max(n, 1))
_fftsize(n, L) = min(_fftlen(n + L - 1), _fftlen(8L))

const _PLANS = Dict{Tuple{DataType, Int, Int}, Any}()
const _PLANS_LOCK = ReentrantLock()

# The forward and inverse real transforms along the first axis of `N × S`
# arrays of eltype `Tp`. They take arrays of any alignment.
function _plans(::Type{Tp}, N, S) where {Tp}
    return lock(_PLANS_LOCK) do
        get!(_PLANS, (Tp, N, S)) do
            flags = FFTW.ESTIMATE | FFTW.UNALIGNED
            f = plan_rfft(zeros(Tp, N, S), 1; flags)
            b = plan_irfft(zeros(Complex{Tp}, N ÷ 2 + 1, S), N, 1; flags)
            (f, b)
        end
    end
end

# The spectrum at size `N` of the kernel's first `L` lags, one column per
# stratum or one shared; reversed in lag for the reverse pass.
function _spectrum(c::AbstractVector, ::Type{Tp}, N, S, L, rev) where {Tp}
    cb = zeros(Tp, N, 1)
    for d in 1:L
        cb[d, 1] = c[rev ? L + 1 - d : d]
    end
    return first(_plans(Tp, N, 1)) * cb
end
function _spectrum(c::PerStratum, ::Type{Tp}, N, S, L, rev) where {Tp}
    cb = zeros(Tp, N, S)
    for k in 1:S, d in 1:L
        cb[d, k] = c.x[k, rev ? L + 1 - d : d]
    end
    return first(_plans(Tp, N, S)) * cb
end

# The lags that reach an input: lag `d` reads buffer row `o + j - d`, so lags
# from the buffer's length on add nothing.
_reach(kernel, X) = min(_nlags(kernel), size(X, 1))

# Forward: `Y[j, k] = Σ_d c[d + 1] X[o + j - d, k]`, `o = m + start - 1`.
function ComposableRecurrences._fft_convolve!(
        Y::Matrix{Tp}, kernel, X::Matrix{Tp}, m, start
    ) where {Tp <: _FFTFloat}
    L = _reach(kernel, X)
    (isempty(Y) || L == 0) && return Y
    N = _fftsize(size(X, 1), L)
    S = size(X, 2)
    f, b = _plans(Tp, N, S)
    K = _spectrum(kernel, Tp, N, S, L, false)
    _ola!(Y, f, b, K, X, m + start - 1, N, L)
    return Y
end

# Reverse: the input cotangent `X̄[r, k] += Σ_d c[d + 1] Ȳ[r - o + d, k]` is
# the output cotangent convolved with the reversed kernel, and the kernel
# cotangent `k̄[d + 1] += Σ_j Ȳ[j, k] X[o + j - d, k]` its correlation with
# the inputs.
function ComposableRecurrences._fft_convolve_back!(
        X̄::Matrix{Tp}, k̄, kernel, X::Matrix{Tp}, Ȳ::Matrix{Tp}, m, start
    ) where {Tp <: _FFTFloat}
    L = _reach(kernel, X)
    (isempty(Ȳ) || L == 0) && return nothing
    N = _fftsize(size(X, 1), L)
    S = size(X, 2)
    f, b = _plans(Tp, N, S)
    Kr = _spectrum(kernel, Tp, N, S, L, true)
    corr = _has_cotangent(k̄, kernel)
    _ola_back!(X̄, k̄, kernel, f, b, Kr, X, Ȳ, m + start - 1, N, L, corr)
    return nothing
end

# Both cotangents take each block of `Ȳ` from one transform of it.
function _ola_back!(X̄, k̄, kernel, f, b, Kr, X, Ȳ, o, N, L, corr)
    Tp = eltype(X̄)
    n = size(X, 1)
    T, S = size(Ȳ)
    B = N - L + 1
    off = L - 1 - o
    buf = zeros(Tp, N, S)
    spec = zeros(Complex{Tp}, N ÷ 2 + 1, S)
    work = similar(spec)
    s = 1
    while s <= T
        e = min(s + B - 1, T)
        fill!(buf, zero(Tp))
        @views buf[1:(e - s + 1), :] .= Ȳ[s:e, :]
        mul!(spec, f, buf)
        # Block rows `s:e` of `Ȳ` reach input rows `s - off` to `e + L - 1 - off`.
        lo = max(1, s - off)
        hi = min(n, e + L - 1 - off)
        if lo <= hi
            work .= spec .* Kr
            mul!(buf, b, work)
            @views X̄[lo:hi, :] .+= buf[(lo + off - s + 1):(hi + off - s + 1), :]
        end
        # The same rows against input rows `o + s - L + 1` to `o + e`, whose
        # circular correlation at shift `L - 1 - d` is lag `d`'s sum.
        if corr
            fill!(buf, zero(Tp))
            r0 = o + s - L
            q0 = max(1, 1 - r0)
            q1 = min(e - s + L, n - r0)
            q0 <= q1 && (@views buf[q0:q1, :] .= X[(r0 + q0):(r0 + q1), :])
            mul!(work, f, buf)
            work .*= conj.(spec)
            mul!(buf, b, work)
            _add_kernel_cotangent!(k̄, kernel, buf, L)
        end
        s = e + 1
    end
    return nothing
end

_has_cotangent(k̄, kernel) = k̄ !== nothing
_has_cotangent(k̄, ::PerStratum) = cotangent(k̄, :x) !== nothing

# Overlap-add: `Z[i, k] += Σ_d c[d + 1] A[i + off - d, k]` for the kernel
# with spectrum `K`. Each block of `N - L + 1` rows of `A` is transformed,
# multiplied by `K` and transformed back, and the rows of its linear
# convolution that land in `Z` are added.
function _ola!(Z, f, b, K, A, off, N, L)
    Tp = eltype(Z)
    n = size(A, 1)
    B = N - L + 1
    buf = zeros(Tp, N, size(A, 2))
    spec = zeros(Complex{Tp}, N ÷ 2 + 1, size(A, 2))
    s = 1
    while s <= n
        e = min(s + B - 1, n)
        lo = max(1, s - off)
        hi = min(size(Z, 1), e + L - 1 - off)
        if lo <= hi
            fill!(buf, zero(Tp))
            @views buf[1:(e - s + 1), :] .= A[s:e, :]
            mul!(spec, f, buf)
            spec .*= K
            mul!(buf, b, spec)
            @views Z[lo:hi, :] .+= buf[(lo + off - s + 1):(hi + off - s + 1), :]
        end
        s = e + 1
    end
    return Z
end

# Lag `d`'s sum sits at row `L - d` of the correlation.
function _add_kernel_cotangent!(k̄, ::AbstractVector, buf, L)
    for d in 0:(L - 1)
        add_cotangent!(k̄, sum(view(buf, L - d, :)), d + 1)
    end
    return nothing
end
function _add_kernel_cotangent!(k̄, ::PerStratum, buf, L)
    C̄ = cotangent(k̄, :x)
    for k in axes(buf, 2), d in 0:(L - 1)
        add_cotangent!(C̄, buf[L - d, k], k, d + 1)
    end
    return nothing
end

end
