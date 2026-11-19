module ComposableRecurrencesReactantExt

using ComposableRecurrences: ComposableRecurrences, Executor, Parallel, PerStratum, Primary,
    Secondary, Serial, TimeVarying, _BoundRecent, _CPUArray, _OldestFirstPiecewise, _Piecewise,
    _ComputedKernel, _PointwiseCoupling, _Ragged, _array, _lagweight, _nlags,
    _seg_weights, _steps!, _weight
using KernelAbstractions: get_backend
using LinearAlgebra: Diagonal, UniformScaling
using Reactant: Reactant, @allowscalar, @trace, AnyTracedRArray, AnyTracedRMatrix,
    AnyTracedRVector, TracedRNumber, materialize_traced_array, unwrapped_eltype

# A traced call compiles as one program: the time loop compiles to a
# single loop whose body is the step, so the program does not grow with the
# number of steps. A loop over at least `min_strata` strata runs as the
# `Parallel` executor's kernel on Reactant's KernelAbstractions backend, so
# the program does not grow with the number of strata either; a shorter
# loop is written out, one block a stratum, whose forward pass runs faster
# on the CPU than a kernel launch each step. The threshold is
# `TRACED_MIN_STRATA`.
struct Traced <: Executor
    min_strata::Int
end
function Traced(; min_strata::Integer = ComposableRecurrences.TRACED_MIN_STRATA[])
    return Traced(Int(min_strata))
end

# Reactant compiles a KernelAbstractions kernel through CUDA.jl, on every
# target, so a traced call needs it loaded.
function _require_cuda(ext)
    isnothing(ext) && throw(
        ArgumentError(
            "a traced call runs its loops as KernelAbstractions kernels, " *
                "which Reactant compiles through CUDA.jl, on the CPU too: " *
                "load CUDA.jl with `using CUDA`"
        )
    )
    return nothing
end

# A kernel thread runs its body serially.
ComposableRecurrences._kernel_arg(::Traced) = Serial()

# The loop as the `Parallel` executor's kernel on the backend of the traced
# arrays among `args`. A loop whose arguments cannot be a kernel's, such as
# a user's part holding a traced number or a step from change points, fails
# to launch while tracing and is written out as before, one block a
# stratum; any other error is the caller's.
@inline function ComposableRecurrences.each!(
        body::F, ex::Traced, n, work, args::Vararg{Any, N}
    ) where {F, N}
    x = n >= ex.min_strata ? _first_traced(args...) : nothing
    if x !== nothing
        _require_cuda(Base.get_extension(Reactant, :ReactantCUDAExt))
        try
            ComposableRecurrences.each!(body, Parallel(get_backend(x)), n, work, args...)
            @debug "traced loop ran as a kernel" body n
            return nothing
        catch e
            _launch_failure(e) || rethrow()
            @debug "traced loop written out" body n exception = e
        end
    end
    for k in 1:n
        @inline body(k, args...)
    end
    return nothing
end

# The errors a kernel launch throws while tracing when its arguments cannot
# be a kernel's: one refused by `Adapt` or not plain data, code a kernel
# cannot hold, or a part of Reactant's kernel lowering that is missing.
function _launch_failure(e)
    return e isa Union{ArgumentError, ErrorException, MethodError, UndefVarError} ||
        nameof(typeof(e)) === :InvalidIRError
end
_first_traced() = nothing
_first_traced(x::AnyTracedRArray, args...) = x
_first_traced(x, args...) = _first_traced(args...)

@inline function ComposableRecurrences._each!(
        body::F, ex::Traced, x, n, work, args::Vararg{Any, N}
    ) where {F, N}
    ComposableRecurrences.each!(body, ex, n, work, args...)
    return nothing
end

# Independent strata run as one block, each step one kernel over the
# strata (`_series_step!` below), as a kernel over a whole series has no
# reverse pass. A block of at least `min_strata` strata is a `_KernelStrata`,
# which carries the executor to the step.
@inline function ComposableRecurrences._blocks!(
        body::F, ex::Traced, x, n, work, args::Vararg{Any, N}
    ) where {F, N}
    n == 0 && return nothing
    ks = n >= ex.min_strata ? _KernelStrata(n, ex) : 1:n
    @inline body(ks, args...)
    return nothing
end

# The strata `1:n` of a block that runs each step as one kernel.
struct _KernelStrata <: AbstractUnitRange{Int}
    n::Int
    ex::Traced
end
Base.first(::_KernelStrata) = 1
Base.last(ks::_KernelStrata) = ks.n

# Step `t` of the independent strata `ks` as one kernel over the strata.
function ComposableRecurrences._series_step!(
        t, ks::_KernelStrata, H::AnyTracedRArray, pr, gain, add, coupling,
        kernel, p, q, ms, states, rec, τ0, L, D
    )
    τ = τ0 + t - 1
    ComposableRecurrences.each!(
        ComposableRecurrences._step_body!, ks.ex, length(ks), 0,
        H, pr, gain, add, coupling, kernel, p, q, ms, states, rec, t, τ, L, D
    )
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
# The core `_buffer` fills a view of `similar`, which is not a traced array.
function ComposableRecurrences._buffer(
        h, ::Type{Tp}, D, T, S
    ) where {Tp <: TracedRNumber}
    return ComposableRecurrences._zeros(h, Tp, D + T, S)
end
function ComposableRecurrences._buffer(
        h::_CPUArray, ::Type{Tp}, D, T, S
    ) where {Tp <: TracedRNumber}
    return ComposableRecurrences._zeros(h, Tp, D + T, S)
end

# A vector history loads into the traced buffer through a block of rows by
# one column: a copy into the column `H[rows, 1]` is not traced. A matrix
# history already loads as a block, `H[rows, :]`, so it keeps the core's
# method.
function ComposableRecurrences._load_history!(
        H::AnyTracedRArray, h::AbstractVector, D
    )
    m = length(h)
    n = min(m, D)
    H[(D - n + 1):D, 1:1] .= reshape(view(h, (m - n + 1):m), n, 1)
    return H
end

# A traced array's eltype is a traced number, which is not a `Real`, so the
# generic array method would reduce over its entries' types; the eltype
# is the answer, also for reshapes and views of traced arrays.
# A traced movement matrix's values are not known while tracing, so its
# columns are not checked.
ComposableRecurrences._check_columns(::AnyTracedRArray, leak) = nothing

function ComposableRecurrences.param_eltype(x::AbstractArray{<:TracedRNumber})
    return eltype(x)
end
# A traced number is not a `Real` either, so the generic method would walk
# its fields; its type is the answer, as for a `Real`.
ComposableRecurrences.param_eltype(x::TracedRNumber) = typeof(x)

# A traced scalar parameter, heterogeneity exponent or softness is one
# value, as a `Real` is. Its value is not known while tracing, so the
# softness's range is not checked.
ComposableRecurrences._check_param(name, x::TracedRNumber) = x
ComposableRecurrences._check_exponent(α::TracedRNumber) = α
ComposableRecurrences._check_softness(::TracedRNumber) = nothing
# Read and made float as a `Real` parameter is.
ComposableRecurrences.param(x::TracedRNumber, k, t) = x
ComposableRecurrences._float_param(x::TracedRNumber) = float(x)
# A traced number first is a pool's population, as a `Real` is.
@inline function ComposableRecurrences.Depletion(N::TracedRNumber, pieces...)
    return ComposableRecurrences._depletion(
        ComposableRecurrences._population(N), pieces, nothing
    )
end
@inline function Core.kwcall(
        kw::NamedTuple, ::Type{ComposableRecurrences.Depletion},
        N::TracedRNumber, pieces...
    )
    return ComposableRecurrences._depletion(
        ComposableRecurrences._population(N), pieces,
        ComposableRecurrences._pools_keyword(kw)
    )
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
function ComposableRecurrences._stack(::Type, get, ps, sz, ::AnyTracedRArray)
    cols = map(ps) do p
        w = vec(get(p))
        n = prod(sz) - length(w)
        n == 0 ? w : vcat(w, Reactant.Ops.fill(zero(unwrapped_eltype(eltype(w))), (n,)))
    end
    return reshape(reduce(hcat, cols), sz..., length(ps))
end

# Traced numbers between change points stack into one traced vector.
function ComposableRecurrences._stack_values(::Type{<:TracedRNumber}, get, ps)
    return Reactant.aos_to_soa([float(get(p)) for p in ps])
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

# A per-stratum parameter at a traced time, read at its linear index for the
# same reason: inside the traced loop `x[k, t]` reads stratum 1 for every
# `k`. Values given by change points reach here with their segment as `t`.
function ComposableRecurrences.param(
        x::TimeVarying{<:Any, <:PerStratum}, k, t::TracedRNumber
    )
    A = x.x.x
    return vec(_traced(A))[k + (t - 1) * size(A, 1)]
end

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
# The fill itself runs at every traced step: a traced row is never known to
# be the one filled before, so it cannot be skipped as cached.
function ComposableRecurrences._refresh_one!(b::_BoundRecent, i::TracedRNumber)
    return ComposableRecurrences._fill_windows!(b, i)
end

# Traced weights or a traced coupling stand for real numbers, and a traced
# number scales a `Recent` or a `Derived` as a real one does.
ComposableRecurrences._real_entries(::AbstractArray{<:TracedRNumber}) = true
for op in (:+, :-, :*, :/, :^),
        P in (:(ComposableRecurrences.Recent), :(ComposableRecurrences.Derived))
    @eval begin
        function Base.$op(a::$P, b::TracedRNumber)
            return ComposableRecurrences.Derived($op, a, b)
        end
        function Base.$op(a::TracedRNumber, b::$P)
            return ComposableRecurrences.Derived($op, a, b)
        end
    end
end

# The soft minimum of `Truncate(κ)` with a traced value picks its arms
# with `ifelse`, as a traced `Bool` has no branch. The arm not taken sees
# the ratio 1, so it makes no NaN that a derivative would carry: both ends
# of the ratio are replaced, as a zero numerator still gives a NaN
# softness gradient once compiled.
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
    r = ifelse(smooth, lo, one(lo)) / ifelse(smooth, hi, one(hi))
    return ifelse(smooth, lo * (1 + r^inv(κ))^(-κ), lo)
end

# The step and convolution loops read and write one entry at a time, so a
# traced run allows scalar indexing. The traced executor runs it: the
# threads and devices of the other executors are the compiled program's
# own concern.
function ComposableRecurrences._run(
        ::Type{Tp}, r, gain, add, h, s0, τ0, L, D, S, T, cache::Val
    ) where {Tp <: TracedRNumber}
    return @allowscalar ComposableRecurrences._run(
        Tp, Traced(), r, gain, add, h, s0, τ0, L, D, S, T, cache
    )
end

function ComposableRecurrences._conv_buffers(
        ::Type{Tp}, kernel, x, history, m, S, start, stop
    ) where {Tp <: TracedRNumber}
    return @allowscalar ComposableRecurrences._conv_buffers(
        Tp, Traced(), kernel, x, history, m, S, start, stop
    )
end

# A traced convolution is a loop over output times, each step one kernel
# over the strata whose outputs are one sum over the `D` lags. The input
# buffer gains `D - 1` zero rows on top, so every lag of every output reads
# inside it, as reverse mode needs a fixed trip count: a lag before the
# first input reads a zero, as it would outside the buffer.
function ComposableRecurrences._convolve!(ex::Traced, Y, c, X, m, start)
    D = _nlags(c)
    z = zero(unwrapped_eltype(eltype(X)))
    Xp = vcat(Reactant.Ops.fill(z, (D - 1, size(X, 2))), X)
    _steps!(_conv_step!, ex, size(Y, 1), ex, Y, c, Xp, m + D - 1, start, D)
    return Y
end

# A computed kernel is filled as a dense `Primary()` kernel, as on any
# executor without its own loops; this method settles which of this
# executor's method and the computed kernel's a traced call takes.
function ComposableRecurrences._convolve!(
        ex::Traced, Y, c::_ComputedKernel, X, m, start
    )
    return ComposableRecurrences._convolve_dense!(ex, Y, c, X, m, start)
end

# The coefficients a computed kernel reads may be traced: a traced array's
# eltype is a traced number, which is not a `Real`, so the package's check
# on the coefficient's shape does not match it.
const _TracedCoefficient = Union{
    TracedRNumber, AnyTracedRVector,
    PerStratum{<:Union{AnyTracedRVector, AnyTracedRMatrix}},
    TimeVarying{<:Any, <:Union{AnyTracedRVector, PerStratum{<:AnyTracedRMatrix}}},
}
ComposableRecurrences._check_coefficient(::_TracedCoefficient) = nothing
ComposableRecurrences._check_argument(::_TracedCoefficient) = nothing

# Arithmetic between a traced number or vector and a `Derived` or a
# `Survival` lowers to `Derived`, as the package's operands do; a
# `PerStratum` or `TimeVarying` is an operand whatever it holds.
const _TracedOperand = Union{TracedRNumber, AnyTracedRVector}
for op in (:+, :-, :*, :/, :^)
    @eval begin
        function Base.$op(
                a::_TracedOperand,
                b::Union{ComposableRecurrences.Derived, ComposableRecurrences.Survival}
            )
            return ComposableRecurrences.Derived($op, a, b)
        end
        function Base.$op(
                a::Union{ComposableRecurrences.Derived, ComposableRecurrences.Survival},
                b::_TracedOperand
            )
            return ComposableRecurrences.Derived($op, a, b)
        end
    end
end

# A survival's scratch buffers at a traced eltype are traced arrays, as
# `zeros` gives, not Julia arrays of traced numbers.
function ComposableRecurrences._alloc(
        ::Type{Tp}, dims::Vararg{Int, N}
    ) where {Tp <: TracedRNumber, N}
    return zeros(Tp, dims...)
end

# A step of independent strata with no modifiers, and no records or trace,
# runs on every stratum at once: one slice of the `L × S` window, one
# product with the kernel summed over the lags, and one write of the
# buffer row. The program then holds one step whatever the number of
# strata, as it holds one whatever the number of steps.
function ComposableRecurrences._series_step!(
        t, ks::AbstractUnitRange, H::AnyTracedRArray, pr::Nothing, gain, add,
        coupling::_PointwiseCoupling, kernel::Union{AbstractVector, PerStratum},
        p, q, ms::Tuple{}, states::Tuple{}, rec::Nothing, τ0, L, D
    )
    τ = τ0 + t - 1
    pk = _strata_kdot(kernel, H, t + D - L, L, ks)
    H[D + t, ks] = _strata_at(gain, τ, ks) .* _coefs(coupling, ks) .* pk .+
        _strata_at(add, τ, ks)
    return nothing
end

# The same step from a block that would otherwise run as one kernel: the
# array operations above run faster.
function ComposableRecurrences._series_step!(
        t, ks::_KernelStrata, H::AnyTracedRArray, pr::Nothing, gain, add,
        coupling::_PointwiseCoupling, kernel::Union{AbstractVector, PerStratum},
        p, q, ms::Tuple{}, states::Tuple{}, rec::Nothing, τ0, L, D
    )
    return ComposableRecurrences._series_step!(
        t, 1:length(ks), H, pr, gain, add, coupling, kernel, p, q, ms, states,
        rec, τ0, L, D
    )
end

# The kernel convolutions of strata `ks` over the window from row `t`.
function _strata_kdot(g, H, t, L, ks)
    L == 0 && return Reactant.Ops.fill(zero(unwrapped_eltype(eltype(H))), (length(ks),))
    W = Reactant.Ops.dynamic_slice(H, [t, first(ks)], [L, length(ks)])
    return vec(sum(_lag_weights(g, ks) .* W; dims = 1))
end
_lag_weights(g::AbstractVector, ks) = _traced(g)
_lag_weights(g::PerStratum, ks) = permutedims(_traced(g.x)[ks, :])

# A parameter of the step at time `τ` for strata `ks`, as `_at` reads it
# for one stratum.
_strata_at(x::Real, τ, ks) = x
_strata_at(::Nothing, τ, ks) = false
_strata_at(x::AbstractVector, τ, ks) = _traced(x)[τ]
function _strata_at(x::AbstractMatrix, τ, ks)
    return vec(Reactant.Ops.dynamic_slice(_traced(x), [first(ks), τ], [length(ks), 1]))
end
_coefs(C::UniformScaling, ks) = C.λ
_coefs(C::Diagonal, ks) = _traced(C.diag)[ks]


# Output `j` of every stratum, as one kernel over the strata when the
# weights are fixed. A time-varying kernel's weights are looked up in loops
# with no fixed trip count once raised, which have no reverse pass, so its
# strata are written out.
function _conv_step!(j, ex, Y, c, X, m, start, D)
    ComposableRecurrences.each!(
        _conv_output!, ex, size(Y, 2), 0, j, Y, c, X, m, start, D
    )
    return nothing
end
function _conv_step!(j, ex, Y, c::TimeVarying, X, m, start, D)
    for k in axes(Y, 2)
        _conv_output!(k, j, Y, c, X, m, start, D)
    end
    return nothing
end
function _conv_output!(k, j, Y, c, X, m, start, D)
    t = start + j - 1
    acc = zero(eltype(Y))
    for d in 0:(D - 1)
        acc += _conv_weight(c, k, d, t) * X[m + t - d, k]
    end
    Y[j, k] = acc
    return nothing
end

# The weight on lag `d` of output time `t`. A `Primary()` kernel reads the
# column of the input's own time `t - d`; one before time 1 has no column,
# so it reads the first, which meets a zero input.
_conv_weight(c, k, d, t) = _lagweight(c, k, d, t)
function _conv_weight(c::TimeVarying{Primary}, k, d, t)
    return _weight(c, k, k, d + 1, max(t - d, 1))
end

# A dense coupling over at least `TRACED_MIN_STRATA` strata mixes a traced
# step's pressures as one broadcast and sum, rather than one multiply-add
# per pair of strata written out. A matrix product here compiled to wrong
# values once a weighted sum followed it.
function ComposableRecurrences._mix!(q::AnyTracedRVector, C, p)
    length(q) < Traced().min_strata && return invoke(
        ComposableRecurrences._mix!, Tuple{Any, Any, Any}, q, C, p
    )
    q .= vec(sum(_traced(C) .* reshape(p, 1, :); dims = 2))
    return nothing
end

end
