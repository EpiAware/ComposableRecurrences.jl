# Shape, time and eltype helpers shared by the operators.

# == Call inputs ==

# Marks the call that sets the fields once the arguments are checked.
struct _Checked end

_nstrata(x::AbstractVector) = 1
_nstrata(x::AbstractMatrix) = size(x, 1)

# On device inputs `x`, every float array in `parts` (the parameters, other
# inputs and states) must live on the device too; the GPU extension checks it.
_check_device(x, parts) = nothing

# `x` on the device of `v`: host index arrays are copied to a device.
_like(v, x) = x

# `x` reversed along axis `d`.
_reverse_dim(x::AbstractVector, d) = reverse(x)
_reverse_dim(x, d) = reverse(x; dims = d)

# A gain or add slot at stratum `k`, absolute time `t`. A missing add is
# `false`, the additive identity for every `Real`.
_at(x::Real, k, t) = x
_at(::Nothing, k, t) = false
Base.@propagate_inbounds _at(x::AbstractVector, k, t) = x[t]
Base.@propagate_inbounds _at(x::AbstractMatrix, k, t) = x[k, t]
# The value `x` of stratum `k` at time `t` scaled by the gain and shifted by
# the add input.
Base.@propagate_inbounds function _affine(gain, add, k, t, x)
    return _at(gain, k, t) * x + _at(add, k, t)
end

# Inputs read without bounds checks index from 1.
_require_one_based(x::AbstractArray) = Base.require_one_based_indexing(x)
_require_one_based(x) = nothing

# The times a call input covers: its last axis, or `nothing` without one.
_extent(x::AbstractArray) = size(x, ndims(x))
_extent(x) = nothing

# Call inputs are plain data; time enters a call one way.
function _check_unwrapped(name, x)
    x isa Union{TimeVarying, PerStratum, Pairwise} && throw(
        ArgumentError(
            "$name is data, not a wrapped coefficient: pass the plain " *
                "array, time on the last axis; got $(_describe(x))"
        )
    )
    return nothing
end

# == Allocation ==

# A state vector of eltype `T`, copied so the caller's input is untouched.
_state_vector(::Type{T}, s) where {T} = copyto!(similar(s, T, length(s)), s)

# A zeroed array like `x` of eltype `T` and size `dims`.
_zeros(x, ::Type{T}, dims...) where {T} = fill!(similar(x, T, dims), zero(T))
# CPU arrays allocate with `zeros`, which AD backends treat as one call
# rather than tracing the fill.
const _CPUArray = Union{
    Array, SubArray{<:Any, <:Any, <:Array},
    Base.ReshapedArray{<:Any, <:Any, <:Array},
    Base.ReshapedArray{<:Any, <:Any, <:SubArray{<:Any, <:Any, <:Array}},
}
_zeros(::_CPUArray, ::Type{T}, dims...) where {T} = zeros(T, dims...)

# An array like `x` of eltype `T` and size `dims` whose entries a run
# writes before it reads them, so they start unset. An extension whose
# numbers a host array cannot hold adds a method.
_unset(x, ::Type{T}, dims...) where {T} = similar(x, T, dims...)

# A kernel given as columns: host columns of one concrete type are held as
# given; others are stacked into one vector, of their promoted type so the
# loops infer, or one device array.
function _ragged(ks::AbstractVector{K}) where {K}
    return _ragged(Val(isconcretetype(K) && K <: _CPUArray), ks)
end
_ragged(::Val{true}, ks) = _Columns(ks)
_ragged(::Val{false}, ks) = _Ragged(ks)

# == Numbers ==

# The primal value of `x` through any nesting of dual numbers (the method
# is in the dual-number extension), for deciding a branch: a dual with value
# zero is ordered by its partials.
_primal_value(x) = x

# The type `_primal_value` returns for a number of type `T`.
_primal_type(::Type{T}) where {T} = T

# `@simd` on a loop whose sum has type `T` only when `T` is an IEEE float:
# on other numbers, such as dual numbers, it slows the loop. The form
# `@_float_simd T ivdep loop` asserts the loop's writes do not alias.
macro _float_simd(T, loop)
    simd = Expr(:macrocall, Symbol("@simd"), __source__, loop)
    return esc(:($T <: _IEEEFloat ? $simd : $loop))
end
macro _float_simd(T, ivdep::Symbol, loop)
    ivdep === :ivdep || throw(ArgumentError("expected `ivdep`, got `$ivdep`"))
    simd = Expr(:macrocall, Symbol("@simd"), __source__, :ivdep, loop)
    return esc(:($T <: _IEEEFloat ? $simd : $loop))
end

# Objects without float parameters, which the field walks stop at.
const _Leafless = Union{
    Real, AbstractArray, Nothing, Symbol, AbstractString, Function, Type,
    Module,
}

@doc raw"""
Return the element type the parameters of `x` contribute to an operator's
buffer.

The buffer eltype is the float promotion of this over the kernel, coupling,
modifiers, inputs and history,

```math
T_{\mathrm{buf}} = \mathrm{float}\Big(\mathrm{promote}\big(E(\text{kernel}),
E(\text{coupling}), E(\text{modifiers}), E(\text{gain}), E(\text{add}),
E(\text{history})\big)\Big),
```

where ``E`` is `param_eltype`, so a dual number or a Float32 anywhere sets
it.
The default recurses by value through fields, tuples and named tuples, so
abstractly typed fields count; a `Real` gives its type and an array of reals
its eltype.
Add a method for a type whose parameters this does not reach.

# Arguments
- `x`: any object, such as a modifier, coupling or kernel.

# Examples
```jldoctest
using ComposableRecurrences
struct Scale
    a
    extra::NamedTuple
end
ComposableRecurrences.param_eltype(Scale(1.0f0, (; b = 2)))

# output

Float32
```
"""
param_eltype(x) = _fields_eltype(x)
param_eltype(x::Real) = typeof(x)
param_eltype(x::AbstractArray{<:Real}) = eltype(x)
function param_eltype(x::AbstractArray)
    return mapreduce(param_eltype, promote_type, x; init = Bool)
end
param_eltype(x::Union{Tuple, NamedTuple}) = _fields_eltype(x)
param_eltype(::Union{Nothing, Symbol, AbstractString, Type, Module}) = Bool

# Promote over the fields of `x`, unrolled so a concrete type infers. A
# recursion carrying the field count is widened by inference when an inner
# struct has more fields; `promote_type` of over about 32 types does not
# infer, so each promotion takes two.
@generated function _fields_eltype(x)
    ex = :Bool
    for i in 1:fieldcount(x)
        ex = :(promote_type($ex, param_eltype(getfield(x, $i))))
    end
    return ex
end

# == Times ==

# The last time a call covers. Without `stop` the time-indexed inputs set it
# and must agree; with it each must cover it. Folded by recursion, as the
# extents mix `Int` and `nothing`, so the call stays type stable.
function _stop(::Nothing, inputs::Tuple)
    stop = _common_extent(nothing, inputs...)
    stop === nothing && throw(
        ArgumentError("stop is required when no input is indexed by time")
    )
    return stop
end
function _stop(stop, inputs::Tuple)
    foreach(inputs) do p
        p.second === nothing || _check_covers(p.first, p.second, stop)
    end
    return stop
end

_common_extent(stop) = stop
function _common_extent(stop, p::Pair, rest::Vararg{Pair, N}) where {N}
    return _common_extent(_agree(stop, p.first, p.second), rest...)
end
_agree(stop, name, ::Nothing) = stop
_agree(::Nothing, name, n) = n
_agree(::Nothing, name, ::Nothing) = nothing
function _agree(stop, name, n)
    n == stop || throw(
        DimensionMismatch(
            "$name covers $n times but an earlier input covers $stop: " *
                "pass stop"
        )
    )
    return stop
end

function _check_covers(name, n, stop)
    n >= stop || throw(
        DimensionMismatch("$name covers $n times, fewer than stop = $stop")
    )
    return nothing
end

# A kernel covers times up to `stop`.
_check_kernel_times(k, stop) = nothing
function _check_kernel_times(k::TimeVarying, stop)
    return _check_covers(:kernel, _extent(_array(k)), stop)
end
function _check_kernel_times(k::TimeVarying{<:Any, <:_AnyRagged}, stop)
    return _check_covers(:kernel, _ncols(k.x), stop)
end
# The last value between change points holds for every later time.
_check_kernel_times(k::TimeVarying{<:Any, <:_Piecewise}, stop) = nothing

# Every time-varying coefficient in a coupling or modifier covers times up
# to `stop`. Outside a kernel only `Secondary()` indexing has a meaning,
# which a `Recurrence` checks once at construction, with `stop = nothing`.
function _check_leaf(name, x::TimeVarying{Secondary}, stop)
    return _check_covers(name, _extent(_array(x)), stop)
end
_check_leaf(name, ::TimeVarying{Secondary}, ::Nothing) = nothing
_check_leaf(name, x::TimeVarying, stop) = _primary_error(name, x)
# The last value between change points holds for every later time.
_check_leaf(name, ::TimeVarying{Secondary, <:_Piecewise}, stop) = nothing
_check_leaf(name, ::TimeVarying{Secondary, <:_Piecewise}, ::Nothing) = nothing
# Unrolled from the type of `x`, so the walk runs no recursion at run time;
# a field of abstract type is walked by dispatch on its value. A generator
# sees only the methods defined before it, so its helper comes first.
function _times_walk!(out, T, ex, depth)
    if T <: TimeVarying
        push!(out, :(_check_leaf(name, $ex, stop)))
    elseif T <: _Leafless
        return out
    elseif !isconcretetype(T) || depth > 32
        push!(out, :(_check_times(name, $ex, stop)))
    else
        for i in 1:fieldcount(T)
            _times_walk!(out, fieldtype(T, i), :(getfield($ex, $i)), depth + 1)
        end
    end
    return out
end
@generated function _check_times(name, x, stop)
    body = Expr(:block)
    _times_walk!(body.args, x, :x, 0)
    push!(body.args, :(return nothing))
    return body
end

# == Checks and errors ==

# A bad value as an error message names it: in full when it is small, by
# type and size when it is an array.
_describe(x) = repr(x)
_describe(x::AbstractArray) = summary(x)
_describe(x::AbstractRange) = repr(x)
_describe(x::Union{PerStratum, Pairwise}) = _wrapped(nameof(typeof(x)), x.x)
_describe(x::TimeVarying{I}) where {I} = _wrapped(:TimeVarying, x.x, nameof(I))
function _describe(x::_AnyRagged)
    return string(
        _ncols(x), " kernel columns of up to ", _maxlen(x), " entries"
    )
end
function _describe(x::_Piecewise)
    return string(_describe(x.x), " from the change points ", repr(x.starts))
end
_wrapped(name, x) = string(name, "(", _describe(x), ")")
_wrapped(name, x, i) = string(name, "(", _describe(x), ", ", i, "())")

# Shared argument errors, each raised by more than one check.
@noinline function _primary_error(name, x)
    throw(
        ArgumentError(
            "$name: Primary() indexing is only meaningful for a kernel; " *
                "got $(_describe(x))"
        )
    )
end
@noinline function _not_constant_error(name, x)
    throw(
        ArgumentError(
            "$name is one value or PerStratum($name); it does not vary over " *
                "time, got $(_describe(x))"
        )
    )
end
@noinline function _kernel_as_coupling_error(
        x, use, name = nameof(typeof(x))
    )
    throw(
        ArgumentError(
            "$name is a kernel: use Recurrence($use) with " *
                "coupling I, not coupling = $(_describe(x))"
        )
    )
end

# A kernel that already mixes strata needs the unit coupling `I`; `what`
# names the coupling and why.
function _check_unit_coupling(coupling, what)
    coupling isa UniformScaling && isone(coupling.λ) || throw(
        ArgumentError("$what must be I, got $(_describe(coupling))")
    )
    return nothing
end

# Check that `A` has `n` rows, each one of `what` (strata, pairs, groups).
function _check_nrows(name, A, n, what)
    size(A, 1) == n || throw(
        DimensionMismatch("$name has $(size(A, 1)) $what, expected $n")
    )
    return nothing
end

# Check a parameter's leading axis against `n` entries of `what`.
_check_rows(name, x, n, what) = nothing
_check_rows(name, x::TimeVarying, n, what) = _check_rows(name, x.x, n, what)
_check_rows(name, x::_Piecewise, n, what) = _check_rows(name, x.x, n, what)
_check_rows(name, x::PerStratum, n, what) = _check_nrows(name, x.x, n, what)

# Check a strata × time slot against `S` strata.
_check_strata(name, x, S) = nothing
_check_strata(name, x::AbstractMatrix, S) = _check_nrows(name, x, S, "strata")

# Value checks on parameters given as numbers or arrays, on their primal
# values, as a dual number at a bound is not ordered by its value alone; a
# `Derived` parameter is not checked here.
function _check_unit(name, x)
    ok = v -> 0 <= _primal_value(v) <= 1
    return _check_values(name, x, ok, "between 0 and 1")
end
function _check_nonnegative(name, x)
    return _check_values(name, x, v -> _primal_value(v) >= 0, "non-negative")
end
_check_values(name, x, ok, what) = nothing
function _check_values(name, x::Real, ok, what)
    ok(x) || throw(ArgumentError("$name is $what, got $x"))
    return nothing
end
function _check_values(name, x::Union{PerStratum, TimeVarying}, ok, what)
    return _check_values(name, x.x, ok, what)
end
function _check_values(name, x::AbstractArray{<:Real}, ok, what)
    i = findfirst(!ok, x)
    i === nothing || throw(ArgumentError("$name is $what, got $(x[i])"))
    return nothing
end

# == Unrolled tuple helpers ==

# `map` over a tuple, unrolled so the result infers at any length: `map`
# over 32 or more entries does not. Each helper takes a loop for a tuple
# whose length is not in its type, as static analysis may pass.
@generated function _tuple_map(f, xs::Tuple{Vararg{Any, N}}) where {N}
    N isa Int || return :(map(f, xs))
    return :(($((:(f(xs[$i])) for i in 1:N)...),))
end

# `foreach` over a tuple, unrolled so each call is static at any length.
@generated function _tuple_foreach(f, xs::Tuple{Vararg{Any, N}}) where {N}
    N isa Int || return :(foreach(f, xs))
    return Expr(:block, (:(f(xs[$i])) for i in 1:N)..., :(return nothing))
end

# `op(acc, x, k)` folded over the entries of `xs` in order, unrolled.
@generated function _tuple_fold(op, acc, xs::Tuple{Vararg{Any, N}}) where {N}
    N isa Int || return :(_fold_loop(op, acc, xs))
    ex = :acc
    for k in 1:N
        ex = :(op($ex, xs[$k], $k))
    end
    return Expr(:block, Expr(:meta, :inline), ex)
end

# `map` with each entry's position, `op(x, k)`, unrolled.
@generated function _tuple_map_index(
        op, xs::Tuple{Vararg{Any, N}}
    ) where {N}
    N isa Int || return :(map(op, xs, ntuple(identity, length(xs))))
    ex = Expr(:tuple, (:(op(xs[$k], $k)) for k in 1:N)...)
    return Expr(:block, Expr(:meta, :inline), ex)
end

# The pairs `(xs[k], ys[k])` of two tuples of one length, unrolled.
@generated function _tuple_zip(
        xs::Tuple{Vararg{Any, N}}, ys::Tuple{Vararg{Any, N}}
    ) where {N}
    N isa Int || return :(map(tuple, xs, ys))
    return Expr(:tuple, (:((xs[$k], ys[$k])) for k in 1:N)...)
end

# The tuple of each `out` from `(out, s) = op(s, x, k)` over the entries of
# `xs` in order, unrolled.
@generated function _tuple_scan(op, s, xs::Tuple{Vararg{Any, N}}) where {N}
    N isa Int || return :(_scan_loop(op, s, xs))
    outs = [Symbol(:out, k) for k in 1:N]
    ex = Any[Expr(:meta, :inline)]
    for k in 1:N
        push!(ex, :(($(outs[k]), s) = op(s, xs[$k], $k)))
    end
    push!(ex, Expr(:tuple, outs...))
    return Expr(:block, ex...)
end

# A pass forward over the entries of `xs` with `(s, kept) = fwd(s, x, k)`,
# then one back, last first, with `b = back(b, x, kept, k)`; unrolled.
@generated function _tuple_forward_back(
        fwd, back, s, b, xs::Tuple{Vararg{Any, N}}
    ) where {N}
    N isa Int || return :(_forward_back_loop(fwd, back, s, b, xs))
    kept = [Symbol(:kept, k) for k in 1:N]
    ex = Any[Expr(:meta, :inline)]
    for k in 1:N
        push!(ex, :((s, $(kept[k])) = fwd(s, xs[$k], $k)))
    end
    for k in N:-1:1
        push!(ex, :(b = back(b, xs[$k], $(kept[k]), $k)))
    end
    push!(ex, :b)
    return Expr(:block, ex...)
end

# The loops the unrolled helpers take for a tuple of unknown length.
function _fold_loop(op, acc, xs)
    for (k, x) in enumerate(xs)
        acc = op(acc, x, k)
    end
    return acc
end
function _scan_loop(op, s, xs)
    outs = ()
    for (k, x) in enumerate(xs)
        out, s = op(s, x, k)
        outs = (outs..., out)
    end
    return outs
end
function _forward_back_loop(fwd, back, s, b, xs)
    kept = Any[]
    for (k, x) in enumerate(xs)
        s, c = fwd(s, x, k)
        push!(kept, c)
    end
    for k in reverse(eachindex(xs))
        b = back(b, xs[k], kept[k], k)
    end
    return b
end

# == One-entry views ==

# The one entry of stratum `k` of a vector, or of a `Ref`, as a vector with
# axes `k:k`, so a step written over `eachindex(v)` reads and writes that
# entry and reads a per-stratum parameter at `k`. The axis is an identity
# range, so Base's linear indices of the view are `k` too.
struct _At{T, A} <: AbstractVector{T}
    parent::A
    k::Int
end
@inline function _At(a::Union{AbstractVector, Base.RefValue}, k::Integer)
    return _At{eltype(a), typeof(a)}(a, Int(k))
end
@inline Base.size(::_At) = (1,)
@inline Base.axes(a::_At) = (Base.IdentityUnitRange(a.k:a.k),)
Base.IndexStyle(::Type{<:_At}) = IndexLinear()
@inline _ix(a::_At{T, <:AbstractVector}) where {T} = (a.k,)
@inline _ix(a::_At{T, <:Base.RefValue}) where {T} = ()
@inline function Base.getindex(a::_At, i::Int)
    @boundscheck i == a.k || _out_of_view()
    return @inbounds a.parent[_ix(a)...]
end
@inline function Base.setindex!(a::_At, x, i::Int)
    @boundscheck i == a.k || _out_of_view()
    @inbounds a.parent[_ix(a)...] = x
    return a
end
# An index other than the view's own, such as from a step looping over
# `1:length(v)`. The message is fixed, as a step can run in a GPU kernel,
# which cannot build a string.
@noinline function _out_of_view()
    throw(
        ArgumentError(
            "an index is outside a pointwise step's view of one stratum: " *
                "loop over eachindex(v), not 1:length(v)"
        )
    )
end
# `eachindex(v, s)` over two views of one stratum: Base's generic axis match
# costs plain reverse-mode AD more to compile.
@inline function Base.eachindex(a::_At, b::_At)
    a.k == b.k || _view_mismatch()
    return a.k:a.k
end
@noinline function _view_mismatch()
    throw(DimensionMismatch("one-entry views of different strata"))
end
# The one entry without its index, as `v[]`, for a step that holds it alone.
@inline Base.getindex(a::_At) = @inbounds a[a.k]
@inline Base.setindex!(a::_At, x) = (@inbounds a[a.k] = x; a)
# A broadcast over a one-entry view, such as `2 .* v` in a step, allocates
# another one-entry view over a `Ref`, as does a copy or a map.
struct _AtStyle <: Broadcast.AbstractArrayStyle{1} end
_AtStyle(::Val) = _AtStyle()
Base.BroadcastStyle(::Type{<:_At}) = _AtStyle()
function Base.similar(bc::Broadcast.Broadcasted{_AtStyle}, ::Type{T}) where {T}
    return _At(Ref{T}(), first(only(axes(bc))))
end
function Base.similar(
        ::_At, ::Type{T}, ax::Tuple{Base.IdentityUnitRange}
    ) where {T}
    r = only(ax)
    length(r) == 1 || throw(
        DimensionMismatch("a one-entry view has one entry, not $(length(r))")
    )
    return _At(Ref{T}(), first(r))
end
