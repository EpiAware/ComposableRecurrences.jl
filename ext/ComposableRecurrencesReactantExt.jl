module ComposableRecurrencesReactantExt

using ComposableRecurrences: ComposableRecurrences, Executor, PerStratum, Primary,
    Secondary, TimeVarying, _BoundRecent, _CPUArray, _OldestFirstPiecewise, _Piecewise,
    _Ragged, _array, _lagweight, _nlags, _seg_weights, _steps!, _weight
using Reactant: Reactant, @allowscalar, @trace, AnyTracedRArray, AnyTracedRMatrix,
    AnyTracedRVector, TracedRNumber, materialize_traced_array, unwrapped_eltype

# A traced call compiles as one program: the strata loops are written out
# in order, which costs a fixed `S` blocks, while the time loop compiles to
# a single loop whose body is the step, so the program does not grow with
# the number of steps.
struct Traced <: Executor end

@inline function ComposableRecurrences.each!(
        body::F, ::Traced, n, work, args::Vararg{Any, N}
    ) where {F, N}
    for k in 1:n
        @inline body(k, args...)
    end
    return nothing
end

@inline function ComposableRecurrences._each!(
        body::F, ex::Traced, x, n, work, args::Vararg{Any, N}
    ) where {F, N}
    ComposableRecurrences.each!(body, ex, n, work, args...)
    return nothing
end

@inline function ComposableRecurrences._blocks!(
        body::F, ::Traced, x, n, work, args::Vararg{Any, N}
    ) where {F, N}
    n == 0 || @inline body(1:n, args...)
    return nothing
end

# Integers the step closes over, such as the number of lags, stay
# constants of the loop rather than becoming values it carries.
function ComposableRecurrences._steps!(
        body::F, ::Traced, n, args::Vararg{Any, N}
    ) where {F, N}
    @trace track_numbers = false for t in 1:n
        body(t, args...)
    end
    return nothing
end

# Buffers at a traced eltype are traced arrays, which the loop carries and
# updates in place, rather than arrays of traced numbers.
function ComposableRecurrences._zeros(x, ::Type{T}, dims...) where {T <: TracedRNumber}
    return Reactant.Ops.fill(zero(unwrapped_eltype(T)), dims)
end
function ComposableRecurrences._zeros(
        x::_CPUArray, ::Type{T}, dims...
    ) where {T <: TracedRNumber}
    return Reactant.Ops.fill(zero(unwrapped_eltype(T)), dims)
end

# A traced array's eltype is a traced number, which is not a `Real`, so the
# generic array method would reduce over its entries' types; the eltype
# is the answer, also for reshapes and views of traced arrays.
function ComposableRecurrences.param_eltype(x::AbstractArray{<:TracedRNumber})
    return eltype(x)
end

# Traced `reverse` also reverses its argument in place, so a second call
# with the same kernel (as when resuming from a returned state) would read
# it backwards; reversing a copy leaves the caller's kernel intact.
function ComposableRecurrences._oldest_first(g::AnyTracedRVector)
    return reverse(copy(g))
end
function ComposableRecurrences._oldest_first(g::PerStratum{<:AnyTracedRMatrix})
    return PerStratum(reverse(copy(g.x); dims = 2))
end

# The kernel window `H[t:(t + L - 1), a]` as one slice, whose start may be
# the traced step, and its product with the kernel as one broadcast and
# sum rather than `L` scalar reads.
function _window(H, t, L, a)
    return vec(Reactant.Ops.dynamic_slice(H, [t, a], [L, 1]))
end
function ComposableRecurrences._kdot(g::AbstractVector, H::AnyTracedRArray, t, τ, L, a)
    return sum(g .* _window(H, t, L, a))
end

# A `Recent` window `Σ_l w_l H[i - l, j]` as one slice of the rows before
# `i`, oldest first, against the weights reversed.
function ComposableRecurrences._recent_window(w, H::AnyTracedRArray, i, j)
    W = length(w)
    return sum(reverse(w) .* _window(H, i - W, W, j))
end

# Column `τ` of a lags × time kernel at the traced step, read as one
# slice; a kernel that is not traced is a constant of the program.
function ComposableRecurrences._wcolumn(
        g::TimeVarying{<:Any, <:AbstractMatrix}, a, τ::TracedRNumber
    )
    x = _traced(g.x)
    return vec(Reactant.Ops.dynamic_slice(x, [1, τ], [size(x, 1), 1]))
end
_traced(x::AnyTracedRArray) = materialize_traced_array(x)
_traced(x::AbstractArray) = Reactant.Ops.constant(collect(x))

# At a traced step every lag of a `Primary()` or ragged kernel runs, as the
# lags cannot depend on the step. A `Primary()` lag before time 1 reads the
# first column, where it meets a zero in the buffer: a seed sits at times
# from 1 and the buffer is zero before it.
ComposableRecurrences._lags(g::TimeVarying{Primary}, τ::TracedRNumber, L) = 1:L
function ComposableRecurrences._lags(
        g::TimeVarying{Secondary, <:_Ragged}, τ::TracedRNumber, L
    )
    return 1:L
end
function ComposableRecurrences._column(
        ::TimeVarying{Primary}, τ::TracedRNumber, i
    )
    return max(τ - i, 1)
end

# A ragged column's weight at a traced step: zero past the column's end,
# read from a valid index either way.
function ComposableRecurrences._weight(
        g::TimeVarying{<:Any, <:_Ragged}, a, b, i, τ::TracedRNumber
    )
    o, v = g.x.offsets, g.x.values
    lo = o[τ]
    w = v[min(lo + i, length(v))]
    return ifelse(i <= o[τ + 1] - lo, w, zero(w))
end
function ComposableRecurrences._kdot(
        g::TimeVarying{Secondary, <:_Ragged}, H::AnyTracedRArray, t,
        τ::TracedRNumber, L, a
    )
    acc = zero(eltype(H))
    for i in 1:L
        acc += _weight(g, a, a, i, τ) * H[t + L - i, a]
    end
    return acc
end

# Traced values between change points stack by concatenation, which the
# compiled program holds as one array.
function ComposableRecurrences._stack(get, ps, sz, ::AnyTracedRArray)
    cols = map(ps) do p
        w = vec(get(p))
        n = prod(sz) - length(w)
        n == 0 ? w : vcat(w, Reactant.Ops.fill(zero(unwrapped_eltype(eltype(w))), (n,)))
    end
    return reshape(reduce(hcat, cols), sz..., length(ps))
end

# A coefficient given by change points at a traced time: its segment is the
# count of the starts at or before that time, a traced number, by which the
# dense values are read.
function ComposableRecurrences._segment_of(s::AbstractVector{Int}, t::TracedRNumber)
    j = zero(t) + 1
    for i in 2:length(s)
        j += ifelse(s[i] <= t, 1, 0)
    end
    return j
end
function ComposableRecurrences._segment(g::_OldestFirstPiecewise, t::TracedRNumber)
    return ComposableRecurrences._segment_of(g.starts, t)
end

# A kernel weight from change points at a traced time, read at its linear
# index in the values: an index pair whose last entry is traced does not
# read the entry asked for.
function ComposableRecurrences._weight(
        g::TimeVarying{<:Any, <:_Piecewise}, a, b, i, τ::TracedRNumber
    )
    A = _array(g)
    n = prod(size(A)[1:(end - 1)])
    j = ComposableRecurrences._segment_of(g.x.starts, τ)
    return vec(_traced(A))[_lead_index(g.x.x, a, i) + (j - 1) * n]
end
_lead_index(::AbstractMatrix, a, i) = i
_lead_index(x::PerStratum, a, i) = a + (i - 1) * size(x.x, 1)

# A recurrence kernel from change points at a traced step: each lag's weight
# is chosen from the segment of the time it reads, `τ` or with `Primary()`
# the value's own time, with `ifelse` over the segments, so every lag runs.
# A `Primary()` lag before time 1 reads the first segment, where it meets a
# zero in the buffer.
function ComposableRecurrences._kdot(
        g::_OldestFirstPiecewise{Secondary}, H::AnyTracedRArray, t, τ::TracedRNumber, L, a
    )
    return _traced_kdot(g, H, t, L, a, u -> τ)
end
function ComposableRecurrences._kdot(
        g::_OldestFirstPiecewise{Primary}, H::AnyTracedRArray, t, τ::TracedRNumber, L, a
    )
    return _traced_kdot(g, H, t, L, a, u -> τ - L - 1 + u)
end
function _traced_kdot(g, H, t, L, a, time)
    acc = zero(eltype(H))
    for u in 1:L
        acc += _traced_weight(g, a, u, time(u)) * H[t + u - 1, a]
    end
    return acc
end
function _traced_weight(g, a, u, σ)
    w = _seg_weights(g, a, 1)[u]
    for j in 2:length(g.starts)
        w = ifelse(g.starts[j] <= σ, _seg_weights(g, a, j)[u], w)
    end
    return w
end

# A traced time is a step of the traced loop, which reads `Recent` only at
# its own buffer row: the buffer depth covers the window, so the read needs
# no check, and with a coupling the loop has filled that row's windows just
# before the strata read them.
function ComposableRecurrences._recent_row(b::_BoundRecent, k, t::TracedRNumber)
    return t + b.o
end
ComposableRecurrences._cached(b::_BoundRecent, i::TracedRNumber) = true
ComposableRecurrences._cache_row!(b::_BoundRecent, i::TracedRNumber) = nothing

# The soft minimum of `SoftTruncate` with a traced value picks its arms
# with `ifelse`, as a traced `Bool` has no branch. The arm not taken sees
# the ratio 1, so it makes no NaN that a derivative would carry.
const _MaybeTraced = Union{Real, TracedRNumber}
function ComposableRecurrences._soft_min(
        κ::_MaybeTraced, a::TracedRNumber, b::_MaybeTraced
    )
    return _traced_soft_min(κ, a, b)
end
function ComposableRecurrences._soft_min(κ::_MaybeTraced, a::Real, b::TracedRNumber)
    return _traced_soft_min(κ, a, b)
end
function _traced_soft_min(κ, a, b)
    a, b, κ = promote(a, b, κ)
    takes_a = a <= b
    lo, hi = ifelse(takes_a, a, b), ifelse(takes_a, b, a)
    smooth = (lo > 0) & !isinf(hi)
    r = ifelse(smooth, lo / ifelse(smooth, hi, one(hi)), one(lo))
    return ifelse(smooth, lo * (1 + r^inv(κ))^(-κ), lo)
end

# The step and convolution loops read and write one entry at a time, so a
# traced run allows scalar indexing. The traced executor runs it: the
# threads and devices of the other executors are the compiled program's
# own concern.
function ComposableRecurrences._run(
        ::Type{Tp}, r, gain, add, h, s0, τ0, L, D, S, T, record::Val
    ) where {Tp <: TracedRNumber}
    return @allowscalar ComposableRecurrences._run(
        Tp, Traced(), r, gain, add, h, s0, τ0, L, D, S, T, record
    )
end

function ComposableRecurrences._conv_buffers(
        ::Type{Tp}, kernel, x, history, m, S, start, stop
    ) where {Tp <: TracedRNumber}
    return @allowscalar ComposableRecurrences._conv_buffers(
        Tp, Traced(), kernel, x, history, m, S, start, stop
    )
end

# A traced convolution is a loop over output times, each output one sum
# over the `D` lags. The input buffer gains `D - 1` zero rows on top, so
# every lag of every output reads inside it: a lag before the first input
# reads a zero, as it would outside the buffer.
function ComposableRecurrences._convolve!(ex::Traced, Y, c, X, m, start)
    D = _nlags(c)
    z = zero(unwrapped_eltype(eltype(X)))
    Xp = vcat(Reactant.Ops.fill(z, (D - 1, size(X, 2))), X)
    _steps!(_conv_step!, ex, size(Y, 1), Y, c, Xp, m + D - 1, start, D)
    return Y
end

# Output `j` of every stratum.
function _conv_step!(j, Y, c, X, m, start, D)
    t = start + j - 1
    for k in axes(Y, 2)
        acc = zero(eltype(Y))
        for d in 0:(D - 1)
            acc += _conv_weight(c, k, d, t) * X[m + t - d, k]
        end
        Y[j, k] = acc
    end
    return nothing
end

# The weight on lag `d` of output time `t`. A `Primary()` kernel reads the
# column of the input's own time `t - d`; one before time 1 has no column,
# so it reads the first, which meets a zero input.
_conv_weight(c, k, d, t) = _lagweight(c, k, d, t)
function _conv_weight(c::TimeVarying{Primary}, k, d, t)
    return _weight(c, k, k, d + 1, max(t - d, 1))
end

end
