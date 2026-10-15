# The `FFTMethod()` lag sum of a fixed-kernel `Convolution`, by overlap-add,
# and its reverse pass through the same transforms. Plans are made once per
# size, strata count and eltype; buffers are made per call, so concurrent
# calls share no state.
module ComposableRecurrencesFFTWExt

using ComposableRecurrences: ComposableRecurrences, Auto, FFTMethod, PerStratum,
    Serial, _CPUArray, _affine, _auto_fft, _convolve!, _convolve_back!, _nlags,
    _untraced, add_cotangent!, cotangent
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

# `Auto()` takes the transform for a fixed kernel on `Float64` CPU arrays
# once the kernel and the outputs are long enough. The sizes are integers,
# so the check carries no derivative; traced calls take the method that
# `_untraced` gives them, as for `FFTMethod()`.
function ComposableRecurrences._fft_path(
        ::Auto, kernel::Union{AbstractVector, PerStratum{<:AbstractMatrix}},
        ::Type{Float64}, x::_CPUArray, T
    )
    return _auto_fft(_nlags(kernel), T) && _untraced()
end

# The transform size for `n` inputs and `L` lags: one block of the whole
# series, or blocks of about `7L` inputs, whichever is smaller. 5-smooth
# sizes are fast; some 7-smooth ones are not.
_fftlen(n) = nextprod((2, 3, 5), max(n, 1))
_fftsize(n, L) = min(_fftlen(n + L - 1), _fftlen(8L))

# The forward and inverse real transforms along the first axis of `N × S`
# arrays of eltype `Tp`. They take arrays of any alignment.
function _make_plans(::Type{Tp}, N, S) where {Tp}
    flags = FFTW.ESTIMATE | FFTW.UNALIGNED
    f = plan_rfft(zeros(Tp, N, S), 1; flags)
    b = plan_irfft(zeros(Complex{Tp}, N ÷ 2 + 1, S), N, 1; flags)
    return f, b
end

# One cache per eltype, keyed by `(N, S)` and typed by the plans it holds.
# It keeps every pair it makes: one per transform size and strata count a
# session meets.
_plan_pair(::Type{Tp}) where {Tp} = Base.promote_op(_make_plans, Type{Tp}, Int, Int)
const _PLANS32 = Dict{Tuple{Int, Int}, _plan_pair(Float32)}()
const _PLANS64 = Dict{Tuple{Int, Int}, _plan_pair(Float64)}()
const _PLANS_LOCK = ReentrantLock()
_plan_cache(::Type{Float32}) = _PLANS32
_plan_cache(::Type{Float64}) = _PLANS64

function _plans(::Type{Tp}, N, S) where {Tp}
    cache = _plan_cache(Tp)
    return lock(_PLANS_LOCK) do
        get!(() -> _make_plans(Tp, N, S), cache, (N, S))
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

# Each sum is checked against an estimate of the transform's rounding
# error, and the sums the estimate cannot give to `_rtol` relative accuracy
# are taken directly: one by one when they are few, or by the direct
# method's body once they would cost more than a quarter of it. Each output
# of a block's transform has an error of about `eps‖a‖₂‖c‖₂` for the block
# `a` and kernel `c`; `_gamma` scales that into the estimate, which measured
# errors stayed below 0.56 of, even on inputs searched to raise them.
_rtol(::Type{Float64}) = 1.0e-10
_rtol(::Type{Float32}) = 1.0f-4
_gamma(::Type{Tp}, N) where {Tp} = Tp(log2(N) / 2) * eps(Tp)

# The weight of lag `d` (from 0) for stratum `k`, and the 2-norm of the
# first `L` lags.
_weight(c::AbstractVector, k, d) = @inbounds c[d + 1]
_weight(c::PerStratum, k, d) = @inbounds c.x[k, d + 1]
function _knorm(c, k, L)
    acc = zero(float(eltype(c isa PerStratum ? c.x : c)))
    for d in 0:(L - 1)
        acc += abs2(_weight(c, k, d))
    end
    return sqrt(acc)
end

# The 2-norm of a block, by plain loops rather than a library call, scaled
# by its largest value so that it neither overflows nor underflows.
function _norm(a)
    s = zero(eltype(a))
    @inbounds for i in eachindex(a)
        s = max(s, abs(a[i]))
    end
    (iszero(s) || !isfinite(s)) && return s
    acc = zero(eltype(a))
    @inbounds @simd for i in eachindex(a)
        acc += abs2(a[i] / s)
    end
    return s * sqrt(acc)
end

# Whether a value `v` with error estimate `e` misses the relative accuracy;
# `false` for a `NaN`, which then stays.
_inexact(v, e, rtol) = e > rtol * abs(v)

# Stratum `k`'s lag sum at output row `j` taken directly:
# `Σ_d c[d + 1] X[o + j - d, k]` over the lags that reach an input.
function _direct_sum(c, X, k, j, o, L)
    acc = zero(eltype(X))
    @inbounds @simd for d in max(0, o + j - size(X, 1)):min(L - 1, o + j - 1)
        acc += _weight(c, k, d) * X[o + j - d, k]
    end
    return acc
end

# Forward: `Y[j, k] += Σ_d c[d + 1] X[o + j - d, k]`, `o = m + start - 1`,
# checked on the output `gain * Y + add` at time `start + j - 1`.
function ComposableRecurrences._fft_convolve!(
        Y::Matrix{Tp}, kernel, X::Matrix{Tp}, m, start, gain = true, add = nothing
    ) where {Tp <: _FFTFloat}
    return _fft_terms!(Y, ((kernel, X),), m, start, gain, add)
end

# The sum of several lag sums `Σᵢ cᵢ ⋆ Xᵢ` over inputs of one size, checked
# as one: the tangent of a lag sum in both the kernel and the input.
function ComposableRecurrences._fft_convolve_terms!(
        Y::Matrix{Tp}, terms::Tuple, m, start
    ) where {Tp <: _FFTFloat}
    return _fft_terms!(Y, terms, m, start, true, nothing)
end

function _fft_terms!(Y::Matrix{Tp}, terms, m, start, gain, add) where {Tp}
    isempty(Y) && return Y
    Z, E = zeros(Tp, size(Y)), zeros(Tp, size(Y))
    foreach(t -> _fft_term!(Z, E, t[1], t[2], m, start), terms)
    rtol = _rtol(Tp)
    o = m + start - 1
    Ls = map(t -> _reach(t[1], t[2]), terms)
    flagged = 0
    @inbounds for k in axes(Z, 2), j in axes(Z, 1)
        t = start + j - 1
        v = _affine(gain, add, k, t, Y[j, k] + Z[j, k])
        flagged += _inexact(v, abs(_affine(gain, nothing, k, t, E[j, k])), rtol)
    end
    if 4 * flagged > length(Z)
        fill!(Z, zero(Tp))
        foreach(t -> _convolve!(Serial(), Z, t[1], t[2], m, start), terms)
    elseif flagged > 0
        @inbounds for k in axes(Z, 2), j in axes(Z, 1)
            t = start + j - 1
            v = _affine(gain, add, k, t, Y[j, k] + Z[j, k])
            _inexact(v, abs(_affine(gain, nothing, k, t, E[j, k])), rtol) || continue
            Z[j, k] = sum(
                i -> _direct_sum(terms[i][1], terms[i][2], k, j, o, Ls[i]),
                eachindex(terms)
            )
        end
    end
    Y .+= Z
    return Y
end

# One lag sum's transform added to `Z`, and its error estimate to `E`.
function _fft_term!(Z::Matrix{Tp}, E, kernel, X, m, start) where {Tp}
    L = _reach(kernel, X)
    L == 0 && return nothing
    N = _fftsize(size(X, 1), L)
    S = size(X, 2)
    f, b = _plans(Tp, N, S)
    K = _spectrum(kernel, Tp, N, S, L, false)
    cn = Tp[_knorm(kernel, k, L) for k in 1:S]
    _ola!(Z, E, f, b, K, cn, X, m + start - 1, N, L)
    return nothing
end

# Reverse: the input cotangent `X̄[r, k] += Σ_d c[d + 1] Ȳ[r - o + d, k]` is
# the output cotangent convolved with the reversed kernel, and the kernel
# cotangent `k̄[d + 1] += Σ_j Ȳ[j, k] X[o + j - d, k]` its correlation with
# the inputs. Each is checked as the forward sums are: the input cotangent
# with what `X̄` already holds, and a kernel shared by the strata on its sum
# over them.
function ComposableRecurrences._fft_convolve_back!(
        X̄::Matrix{Tp}, k̄, kernel, X::Matrix{Tp}, Ȳ::Matrix{Tp}, m, start
    ) where {Tp <: _FFTFloat}
    L = _reach(kernel, X)
    (isempty(Ȳ) || L == 0) && return nothing
    N = _fftsize(size(X, 1), L)
    n, S = size(X)
    T = size(Ȳ, 1)
    f, b = _plans(Tp, N, S)
    Kr = _spectrum(kernel, Tp, N, S, L, true)
    corr = _has_cotangent(k̄, kernel)
    o = m + start - 1
    W, EW = zeros(Tp, n, S), zeros(Tp, n, S)
    C, EC = zeros(Tp, L, S), zeros(Tp, L, S)
    cn = Tp[_knorm(kernel, k, L) for k in 1:S]
    _ola_back!(W, EW, C, EC, cn, f, b, Kr, X, Ȳ, o, N, L, corr)
    rtol = _rtol(Tp)
    nW = count(i -> @inbounds(_inexact(X̄[i] + W[i], EW[i], rtol)), eachindex(W))
    nC = corr ? _kernel_inexact!(C, EC, kernel, rtol) : 0
    if 4 * (nW * L + nC * T) > (corr ? 2 : 1) * T * L * S
        _convolve_back!(Serial(), X̄, k̄, kernel, X, Ȳ, m, start)
        return nothing
    end
    @inbounds for k in 1:S, r in 1:n
        _inexact(X̄[r, k] + W[r, k], EW[r, k], rtol) || continue
        acc = zero(Tp)
        @simd for d in max(0, o + 1 - r):min(L - 1, o + T - r)
            acc += _weight(kernel, k, d) * Ȳ[r - o + d, k]
        end
        W[r, k] = acc
    end
    X̄ .+= W
    corr || return nothing
    @inbounds for k in 1:S, d in 0:(L - 1)
        iszero(EC[d + 1, k]) && continue
        acc = zero(Tp)
        @simd for j in max(1, 1 + d - o):min(T, n + d - o)
            acc += Ȳ[j, k] * X[o + j - d, k]
        end
        C[d + 1, k] = acc
    end
    _add_kernel_cotangent!(k̄, kernel, C, L)
    return nothing
end

# Marks the kernel cotangent sums to take directly by leaving their error
# estimate in `EC` and zeroing the rest; returns how many there are. A
# per-stratum kernel checks each sum. A shared kernel's cotangent is the
# sum over the strata, so a lag whose sum misses the accuracy takes every
# stratum directly.
function _kernel_inexact!(C, EC, ::PerStratum, rtol)
    n = 0
    @inbounds for i in eachindex(C, EC)
        if _inexact(C[i], EC[i], rtol)
            n += 1
        else
            EC[i] = 0
        end
    end
    return n
end
function _kernel_inexact!(C, EC, ::AbstractVector, rtol)
    n = 0
    @inbounds for d in axes(C, 1)
        tot = sum(view(C, d, :))
        if _inexact(tot, sum(view(EC, d, :)), rtol)
            n += size(C, 2)
        else
            view(EC, d, :) .= 0
        end
    end
    return n
end

# Both cotangents take each block of `Ȳ` from one transform of it, into `W`
# and `C` (lag `d` at row `d + 1`), with their error bounds in `EW` and `EC`.
function _ola_back!(W, EW, C, EC, cn, f, b, Kr, X, Ȳ, o, N, L, corr)
    Tp = eltype(W)
    n = size(X, 1)
    T, S = size(Ȳ)
    B = N - L + 1
    off = L - 1 - o
    γ = _gamma(Tp, N)
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
            @views W[lo:hi, :] .+= buf[(lo + off - s + 1):(hi + off - s + 1), :]
            for k in 1:S
                @views EW[lo:hi, k] .+= γ * _norm(Ȳ[s:e, k]) * cn[k]
            end
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
            for k in 1:S
                @views EC[:, k] .+= γ * _norm(Ȳ[s:e, k]) *
                    _norm(X[(r0 + q0):(r0 + max(q0 - 1, q1)), k])
                for d in 0:(L - 1)
                    @inbounds C[d + 1, k] += buf[L - d, k]
                end
            end
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
# convolution that land in `Z` are added, with their error bound in `E`
# from the kernel norms `cn`.
function _ola!(Z, E, f, b, K, cn, A, off, N, L)
    Tp = eltype(Z)
    n = size(A, 1)
    B = N - L + 1
    γ = _gamma(Tp, N)
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
            for k in axes(A, 2)
                @views E[lo:hi, k] .+= γ * _norm(A[s:e, k]) * cn[k]
            end
        end
        s = e + 1
    end
    return Z
end

# Lag `d`'s sum is row `d + 1` of `C`.
function _add_kernel_cotangent!(k̄, ::AbstractVector, C, L)
    for d in 0:(L - 1)
        add_cotangent!(k̄, sum(view(C, d + 1, :)), d + 1)
    end
    return nothing
end
function _add_kernel_cotangent!(k̄, ::PerStratum, C, L)
    C̄ = cotangent(k̄, :x)
    for k in axes(C, 2), d in 0:(L - 1)
        add_cotangent!(C̄, C[d + 1, k], k, d + 1)
    end
    return nothing
end

end
