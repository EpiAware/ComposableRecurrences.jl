# A `TimeVarying` coefficient given by change points (`_Piecewise`): each
# segment holds one value, so a call runs each segment with the fixed
# coefficient's loops and switches at the change points. The readers that
# have no such path read the values as a dense coefficient with one column
# per segment, at the column of the time's segment.

const _TVPiecewise{I} = TimeVarying{I, <:_Piecewise}

# The values as a dense coefficient with one column per segment, and the
# same view of its mirror `x̄` (the mirror of the `TimeVarying`), or
# `nothing` without one.
_values(g::TimeVarying{I, <:_Piecewise}) where {I} = TimeVarying{I}(g.x.x)
_values_mirror(x̄) = _wrap_x(_values_cotangent(x̄))
_values_cotangent(x̄) = cotangent(cotangent(x̄, :x), :x)
_wrap_x(::Nothing) = nothing
_wrap_x(x̄) = (; x = x̄)
_nsegments(p::_Piecewise) = length(p.starts)
# The times segment `j` covers within `lo:hi`.
_span(p::_Piecewise, j, lo, hi) = _span_of(p.starts, j, lo, hi)
function _span_of(starts, j, lo, hi)
    a = max(starts[j], lo)
    b = j < length(starts) ? min(starts[j + 1] - 1, hi) : hi
    return a, b
end

Base.@propagate_inbounds function _weight(g::_TVPiecewise, a, b, i, τ)
    return _weight(_values(g), a, b, i, _segment(g.x, τ))
end
Base.@propagate_inbounds function _add_weight!(ḡ, g::_TVPiecewise, v, a, b, i, τ)
    return _add_weight!(_values_mirror(ḡ), _values(g), v, a, b, i, _segment(g.x, τ))
end

# Modifier parameters: one number, or one per stratum, per segment.
param(x::_TVPiecewise, k, t) = param(_values(x), k, _segment(x.x, t))
function add_param!(x̄, x::_TVPiecewise, v, k, t)
    return add_param!(_values_mirror(x̄), _values(x), v, k, _segment(x.x, t))
end
_check_param(name, x::TimeVarying{Secondary, <:_Piecewise{<:AbstractVector}}) = x
function _check_param(
        name, x::TimeVarying{Secondary, <:_Piecewise{<:PerStratum{<:AbstractMatrix}}}
    )
    return x
end
function _float_param(x::TimeVarying{I, <:_Piecewise}) where {I}
    p = x.x
    return TimeVarying{I}(_Piecewise(_Flat(), _array_param(p.x), p.starts))
end
_array_param(x::AbstractArray) = float(x)
_array_param(x::PerStratum) = _float_param(x)
_check_values(name, x::_Piecewise, ok, what) = _check_values(name, x.x, ok, what)

# Kernels: lags × segments, or strata × lags × segments.
_check_kernel_shape(k::TimeVarying{<:Any, <:_Piecewise{<:AbstractMatrix}}) = nothing
function _check_kernel_shape(
        k::TimeVarying{<:Any, <:_Piecewise{<:PerStratum{<:AbstractArray{<:Any, 3}}}}
    )
    return nothing
end
function _check_kernel_shape(k::_TVPiecewise)
    throw(
        ArgumentError(
            "a kernel given by change points takes a vector of lag weights " *
                "or a PerStratum strata × lags matrix as each value, got " *
                _describe(k)
        )
    )
end
_check_one_based(kernel::_TVPiecewise) = _check_one_based(_values(kernel))
_nlags(k::_TVPiecewise) = _nlags(_values(k))
_check_kernel_strata(p::_Piecewise, S) = _check_kernel_strata(p.x, S)

# Couplings: strata × strata × segments.
function _check_coupling_shape(
        ::TimeVarying{Secondary, <:_Piecewise{<:AbstractArray{<:Any, 3}}}
    )
    return nothing
end
_check_coupling(C::_TVPiecewise, S) = _check_coupling(_values(C), S)
const _PiecewiseCoupling = TimeVarying{
    Secondary, <:_Piecewise{<:AbstractArray{<:Any, 3}},
}
function forward(C::_PiecewiseCoupling, ::Pressure, q, p, t)
    return forward(_values(C), Pressure(), q, p, _segment(C.x, t))
end
function pullback!(grads, C::_PiecewiseCoupling, ::Pressure, q, p, t)
    g = (; piece = _values_mirror(grads.piece), q = grads.q, p = grads.p)
    return pullback!(g, _values(C), Pressure(), q, p, _segment(C.x, t))
end

# A recurrence kernel as a run reads it: each segment's weights as a fixed
# kernel reversed once per call, `ks[j]`, so a step is one dot of its
# segment's weights with the oldest-first window, read as a fixed kernel's.
# `cols[t]` is the segment of time `t` up to the last start.
struct _OldestFirstPiecewise{I, K <: AbstractVector, P <: AbstractVector{Int}}
    ks::K
    starts::P
    cols::P
end
function _OldestFirstPiecewise{I}(ks::K, starts::P) where {I, K, P}
    cols = similar(starts, last(starts))
    for j in eachindex(starts)
        a, b = _span_of(starts, j, 1, last(starts))
        cols[a:b] .= j
    end
    return _OldestFirstPiecewise{I, K, P}(ks, starts, cols)
end
@inline function _segment(g::_OldestFirstPiecewise, t)
    return @inbounds g.cols[clamp(t, 1, length(g.cols))]
end
function _oldest_first(g::TimeVarying{I, <:_Piecewise{<:AbstractMatrix}}) where {I}
    G = g.x.x
    ks = [_oldest_first(view(G, :, j)) for j in axes(G, 2)]
    return _OldestFirstPiecewise{I}(ks, g.x.starts)
end
function _oldest_first(g::TimeVarying{I, <:_Piecewise{<:PerStratum}}) where {I}
    G = g.x.x.x
    ks = [_oldest_first(PerStratum(view(G, :, :, j))) for j in axes(G, 3)]
    return _OldestFirstPiecewise{I}(ks, g.x.starts)
end
const _VectorSegments = _OldestFirstPiecewise{<:Any, <:AbstractVector{<:AbstractVector}}
const _StrataSegments = _OldestFirstPiecewise{<:Any, <:AbstractVector{<:PerStratum}}

# Secondary: the steps of each segment run with its weights as a fixed
# kernel, and the reverse pass adds their cotangent into the segment's
# buffer, as a fixed kernel's. The segments from that of `τ0` to that of the
# last step each cover some steps.
function _kernel_runs(g::_OldestFirstPiecewise{Secondary}, τ0, T)
    js = _segment_of(g.starts, τ0):_segment_of(g.starts, τ0 + T - 1)
    return ((_run_span(g.starts, j, τ0, T), g.ks[j], j) for j in js)
end
# The steps of a call from time `τ0` that segment `j` covers.
function _run_span(starts, j, τ0, T)
    a, b = _span_of(starts, j, τ0, τ0 + T - 1)
    return (a - τ0 + 1):(b - τ0 + 1)
end

# One fixed kernel's buffer per segment, added into the values' cotangent
# after the loop.
struct _PiecewiseBuffer{B}
    x::B
end
function _kernel_buffer(ḡ, g::_VectorSegments, H, S, L)
    _values_cotangent(ḡ) === nothing && return nothing
    return _PiecewiseBuffer([_zeros(H, eltype(H), L, S) for _ in g.ks])
end
function _kernel_buffer(ḡ, g::_StrataSegments, H, S, L)
    _values_cotangent(ḡ) === nothing && return nothing
    return _PiecewiseBuffer([_zeros(H, eltype(H), S, L) for _ in g.ks])
end
_run_buffer(kbuf::_PiecewiseBuffer, ::_OldestFirstPiecewise{Secondary}, j) = kbuf.x[j]
_kernel_finish!(ḡ, kb::_PiecewiseBuffer) = _piecewise_finish!(_values_cotangent(ḡ), kb.x)
function _piecewise_finish!(V̄::AbstractMatrix, bufs)
    for j in eachindex(bufs)
        _kernel_finish!(view(V̄, :, j), bufs[j])
    end
    return nothing
end
function _piecewise_finish!(V̄::NamedTuple, bufs)
    Ḡ = cotangent(V̄, :x)
    for j in eachindex(bufs)
        _kernel_finish!((; x = view(Ḡ, :, :, j)), bufs[j])
    end
    return nothing
end

# Stratum `a`'s oldest-first weights in segment `j`, and the same view of
# the reverse pass's buffer, or `nothing` without one.
@inline _seg_weights(g::_VectorSegments, a, j) = g.ks[j]
@inline _seg_weights(g::_StrataSegments, a, j) = view(g.ks[j].x, a, :)
_seg_buffer(::Nothing, g, a, j) = nothing
_seg_buffer(kbuf::_PiecewiseBuffer, ::_VectorSegments, a, j) = view(kbuf.x[j], :, a)
_seg_buffer(kbuf::_PiecewiseBuffer, ::_StrataSegments, a, j) = view(kbuf.x[j], a, :)

# A step that reads a segment's weights without the runs, as a route's
# kernel does.
@inline function _kdot(g::_OldestFirstPiecewise{Secondary}, H, t, τ, L, a)
    return _kdot(g.ks[_segment(g, τ)], H, t, τ, L, a)
end
function _kernel_back_at!(
        kbuf, ḡ, g::_OldestFirstPiecewise{Secondary}, a, H, H̄, t, τ, L, k
    )
    j = _segment(g, τ)
    return _kernel_back_at!(_run_buffer(kbuf, g, j), ḡ, g.ks[j], a, H, H̄, t, τ, L, k)
end

# Primary: the window's value at oldest-first position `u` is from time
# `τ - L - 1 + u`, read with the weights of that time's segment, so the
# window splits into one span per segment it covers. Times before 1 have no
# segment.
function _kdot(g::_OldestFirstPiecewise{Primary}, H, t, τ, L, a)
    acc = zero(eltype(H))
    o = τ - L - 1
    u = max(1, 1 - o)
    j = _segment(g, o + u)
    n = length(g.starts)
    while u <= L
        hi = j < n ? min(L, g.starts[j + 1] - 1 - o) : L
        acc += _span_dot(_seg_weights(g, a, j), H, t, u, hi, a)
        u = hi + 1
        j += 1
    end
    return acc
end
function _span_dot(
        w::AbstractVector{<:_IEEEFloat}, H::AbstractMatrix{<:_IEEEFloat}, t, lo, hi, a
    )
    acc = zero(promote_type(eltype(w), eltype(H)))
    @inbounds @simd for i in lo:hi
        acc += w[i] * H[t + i - 1, a]
    end
    return acc
end
# Other numbers, such as dual numbers, sum in order: `@simd` slows them.
function _span_dot(w, H, t, lo, hi, a)
    acc = zero(promote_type(eltype(w), eltype(H)))
    @inbounds for i in lo:hi
        acc += w[i] * H[t + i - 1, a]
    end
    return acc
end
function _kernel_back_at!(
        kbuf, ḡ, g::_OldestFirstPiecewise{Primary}, a, H, H̄, t, τ, L, k
    )
    o = τ - L - 1
    u = max(1, 1 - o)
    j = _segment(g, o + u)
    n = length(g.starts)
    while u <= L
        hi = j < n ? min(L, g.starts[j + 1] - 1 - o) : L
        kb = _seg_buffer(kbuf, g, k, j)
        _span_back!(kb, _seg_weights(g, k, j), a, H, H̄, t, u, hi, k)
        u = hi + 1
        j += 1
    end
    return nothing
end
# As in the forward sums, `@simd` runs only when the weights and the
# values are IEEE floats.
function _span_back!(
        kb, w::AbstractVector{<:_IEEEFloat}, a, H::AbstractMatrix{<:_IEEEFloat},
        H̄, t, lo, hi, k
    )
    @inbounds @simd ivdep for i in lo:hi
        _add_at!(kb, a * H[t + i - 1, k], i)
        H̄[t + i - 1, k] += a * w[i]
    end
    return nothing
end
function _span_back!(kb, w, a, H, H̄, t, lo, hi, k)
    @inbounds for i in lo:hi
        _add_at!(kb, a * H[t + i - 1, k], i)
        H̄[t + i - 1, k] += a * w[i]
    end
    return nothing
end

# A convolution kernel's weights in segment `j` for stratum `k`, and the
# same view of the values' cotangent `V̄`, or `nothing` without one.
function _conv_weights(c::TimeVarying{<:Any, <:_Piecewise{<:AbstractMatrix}}, k, j)
    return view(c.x.x, :, j)
end
function _conv_weights(c::TimeVarying{<:Any, <:_Piecewise{<:PerStratum}}, k, j)
    return view(c.x.x.x, k, :, j)
end
_conv_mirror(::Nothing, c, k, j) = nothing
_conv_mirror(V̄::AbstractMatrix, c, k, j) = view(V̄, :, j)
_conv_mirror(V̄::NamedTuple, c, k, j) = _mirror_view(cotangent(V̄, :x), k, :, j)

# Secondary: the outputs of each segment are one fixed convolution of the
# whole input with that segment's weights. Keeping the fixed loop's four-lag
# blocks across the change points instead measured slower: a segment of up
# to three kernel lengths of outputs takes the fixed loop's four-output
# gather, which beats the blocks.
function _convolve_body!(k, Y, c::_TVPiecewise{Secondary}, X, m, start)
    p = c.x
    T = size(Y, 1)
    for j in _out_segments(p, start, T)
        lo, hi = _out_rows(p, j, start, T)
        y = view(Y, lo:hi, k)
        _convolve_series!(y, _conv_weights(c, k, j), X, k, m, start + lo - 1)
    end
    return nothing
end
# The segments a call from `start` with `T` outputs reads, and the output
# rows of segment `j`.
function _out_segments(p::_Piecewise, start, T)
    return _segment(p, start):_segment(p, start + T - 1)
end
function _out_rows(p::_Piecewise, j, start, T)
    a, b = _span(p, j, start, start + T - 1)
    return a - start + 1, b - start + 1
end
# The weights `w[d + 1]` against stratum `k`'s inputs at buffer rows `r - d`,
# for the lags `lo:hi`; other numbers than IEEE floats sum in order, as
# `@simd` slows them.
function _tail_dot(
        w::AbstractVector{<:_IEEEFloat}, X::AbstractMatrix{<:_IEEEFloat}, k, r, lo, hi
    )
    acc = zero(promote_type(eltype(w), eltype(X)))
    @inbounds @simd for d in lo:hi
        acc += w[d + 1] * X[r - d, k]
    end
    return acc
end
function _tail_dot(w, X, k, r, lo, hi)
    acc = zero(promote_type(eltype(w), eltype(X)))
    @inbounds for d in lo:hi
        acc += w[d + 1] * X[r - d, k]
    end
    return acc
end
# The pullback of `_tail_dot` for the cotangent `ȳ`, with `@simd` under the
# same condition.
function _tail_back!(
        w̄, X̄, w::AbstractVector{<:_IEEEFloat}, X::AbstractMatrix{<:_IEEEFloat},
        ȳ, k, r, lo, hi
    )
    @inbounds @simd ivdep for d in lo:hi
        _add_at!(w̄, ȳ * X[r - d, k], d + 1)
        X̄[r - d, k] += w[d + 1] * ȳ
    end
    return nothing
end
function _tail_back!(w̄, X̄, w, X, ȳ, k, r, lo, hi)
    @inbounds for d in lo:hi
        _add_at!(w̄, ȳ * X[r - d, k], d + 1)
        X̄[r - d, k] += w[d + 1] * ȳ
    end
    return nothing
end
function _strata_back!(ks, X̄, c̄, c::_TVPiecewise{Secondary}, X, Ȳ, m, start)
    p = c.x
    V̄ = _values_cotangent(c̄)
    stop = start + size(Ȳ, 1) - 1
    for k in ks, j in 1:_nsegments(p)
        a, b = _span(p, j, start, stop)
        a > b && continue
        _convolve_series_back!(
            view(X̄, :, k), _conv_mirror(V̄, c, k, j), _conv_weights(c, k, j),
            view(X, :, k), view(Ȳ, (a - start + 1):(b - start + 1), k), m, a
        )
    end
    return nothing
end

# Primary: the output is the sum over segments of a fixed convolution of the
# input masked to the segment. Segment `j`'s inputs, at times `a:b`, give a
# fixed convolution of those inputs alone at the outputs `a:b`, which no
# other segment's inputs before `a` reach; their tail at the outputs after
# `b` adds to the next segments' outputs. The outputs `a:b` of the segments
# do not overlap, so each is written by the fixed loop first and the tails
# are added after. The buffer has no history, so its rows from `m + lo`
# hold the times from `lo`.
function _convolve_body!(k, Y, c::_TVPiecewise{Primary}, X, m, start)
    p = c.x
    D = _nlags(c)
    stop = start + size(Y, 1) - 1
    lo = max(1, start - D + 1)
    for j in 1:_nsegments(p)
        a, b = _span(p, j, lo, stop)
        b < max(a, start) && continue
        Xj = view(X, (m + a):(m + b), k:k)
        y = view(Y, (max(a, start) - start + 1):(b - start + 1), k)
        _convolve_series!(y, _conv_weights(c, k, j), Xj, 1, 0, max(a, start) - a + 1)
    end
    for j in 1:(_nsegments(p) - 1)
        a, b = _span(p, j, lo, stop)
        a > b && continue
        w = _conv_weights(c, k, j)
        for t in max(b + 1, start):min(b + D - 1, stop)
            @inbounds Y[t - start + 1, k] += _tail_dot(w, X, k, m + t, t - b, min(D - 1, t - a))
        end
    end
    return nothing
end
function _strata_back!(ks, X̄, c̄, c::_TVPiecewise{Primary}, X, Ȳ, m, start)
    p = c.x
    V̄ = _values_cotangent(c̄)
    D = _nlags(c)
    stop = start + size(Ȳ, 1) - 1
    lo = max(1, start - D + 1)
    for k in ks, j in 1:_nsegments(p)
        a, b = _span(p, j, lo, stop)
        a > b && continue
        w = _conv_weights(c, k, j)
        w̄ = _conv_mirror(V̄, c, k, j)
        if b >= max(a, start)
            _convolve_series_back!(
                view(X̄, (m + a):(m + b), k), w̄, w, view(X, (m + a):(m + b), k),
                view(Ȳ, (max(a, start) - start + 1):(b - start + 1), k), 0,
                max(a, start) - a + 1
            )
        end
        j < _nsegments(p) || continue
        for t in max(b + 1, start):min(b + D - 1, stop)
            @inbounds ȳ = Ȳ[t - start + 1, k]
            _tail_back!(w̄, X̄, w, X, ȳ, k, m + t, t - b, min(D - 1, t - a))
        end
    end
    return nothing
end

# A coefficient given by change points reads its segments on the host, so a
# device call refuses it, as adapting it for a kernel does.
const _PIECEWISE_DEVICE = "a TimeVarying given by change points runs on the " *
    "host; on a device, pass the dense TimeVarying array that repeats each " *
    "value over its segment"
