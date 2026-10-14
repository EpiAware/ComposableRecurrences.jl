# Shape, time and eltype helpers shared by the operators.

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

# The primal value of `x`, through any nesting of `ForwardDiff.Dual`s, for
# deciding a branch. A dual with value zero is ordered by its partials, so
# `P > 0` on the dual can hold where the value is zero. Other numbers,
# traced ones included, pass through.
_primal_value(x) = x
_primal_value(x::ForwardDiff.Dual) = _primal_value(ForwardDiff.value(x))

# The type `_primal_value` returns for a number of type `T`.
_primal_type(::Type{T}) where {T} = T
_primal_type(::Type{<:ForwardDiff.Dual{<:Any, V}}) where {V} = _primal_type(V)

# A gain or add slot at stratum `k`, absolute time `t`. A missing add is
# `false`, the additive identity for every `Real`.
_at(x::Real, k, t) = x
_at(::Nothing, k, t) = false
Base.@propagate_inbounds _at(x::AbstractVector, k, t) = x[t]
Base.@propagate_inbounds _at(x::AbstractMatrix, k, t) = x[k, t]
# The value `x` of stratum `k` at time `t` scaled by the gain and shifted by
# the add input.
Base.@propagate_inbounds _affine(gain, add, k, t, x) = _at(gain, k, t) * x + _at(add, k, t)

# Inputs read without bounds checks index from 1.
_require_one_based(x::AbstractArray) = Base.require_one_based_indexing(x)
_require_one_based(x) = nothing

# The times a call input covers: its last axis, or `nothing` without one.
_extent(x::AbstractArray) = size(x, ndims(x))
_extent(x) = nothing

# A bad value as an error message names it: in full when it is small, by
# type and size when it is an array.
_describe(x) = repr(x)
_describe(x::AbstractArray) = summary(x)
_describe(x::AbstractRange) = repr(x)
_describe(x::Union{PerStratum, Pairwise}) = _wrapped(nameof(typeof(x)), x.x)
_describe(x::TimeVarying{I}) where {I} = _wrapped(:TimeVarying, x.x, nameof(I))
function _describe(x::_AnyRagged)
    return string(_ncols(x), " kernel columns of up to ", _maxlen(x), " entries")
end
function _describe(x::_Piecewise)
    return string(_describe(x.x), " from the change points ", repr(x.starts))
end
_wrapped(name, x) = string(name, "(", _describe(x), ")")
_wrapped(name, x, i) = string(name, "(", _describe(x), ", ", i, "())")

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

# The last time a call covers. Without `stop` the time-indexed inputs set it
# and must agree; with it each must cover it. The inputs mix `Int` and
# `nothing` extents, so they are folded by recursion, which keeps the call
# type stable and free of allocations.
function _stop(::Nothing, inputs::Tuple)
    stop = _common_extent(nothing, inputs...)
    stop === nothing && throw(
        ArgumentError(
            "stop is required when no input is indexed by time"
        )
    )
    return stop
end
function _stop(stop, inputs::Tuple)
    foreach(p -> p.second === nothing || _check_covers(p.first, p.second, stop), inputs)
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
            "$name covers $n times but an earlier input covers $stop: pass stop"
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

# Check a kernel covers times up to `stop`.
_check_kernel_times(k, stop) = nothing
function _check_kernel_times(k::TimeVarying, stop)
    return _check_covers(:kernel, _extent(_array(k)), stop)
end
function _check_kernel_times(k::TimeVarying{<:Any, <:_AnyRagged}, stop)
    return _check_covers(:kernel, _ncols(k.x), stop)
end
# The last value between change points holds for every later time.
_check_kernel_times(k::TimeVarying{<:Any, <:_Piecewise}, stop) = nothing

# Check every time-varying coefficient in a coupling or modifier covers
# times up to `stop`, recursing through fields. Outside a kernel only
# `Secondary()` indexing has a meaning, which a `Recurrence` checks once at
# construction, with `stop = nothing`.
function _check_times(name, x::TimeVarying{Secondary}, stop)
    return _check_covers(name, _extent(_array(x)), stop)
end
_check_times(name, ::TimeVarying{Secondary}, ::Nothing) = nothing
_check_times(name, ::TimeVarying{Secondary, <:_Piecewise}, stop) = nothing
_check_times(name, ::TimeVarying{Secondary, <:_Piecewise}, ::Nothing) = nothing
_check_times(name, x::TimeVarying, stop) = _primary_error(name, x)
const _Leaf = Union{
    Real, AbstractArray, Nothing, Symbol, AbstractString, Type, Module,
    Function,
}
_check_times(name, ::_Leaf, stop) = nothing
function _check_times(name, x::Union{Tuple, NamedTuple}, stop)
    foreach(v -> _check_times(name, v, stop), values(x))
    return nothing
end
function _check_times(name, x, stop)
    return _fields_times(name, x, stop, Val(fieldcount(typeof(x))))
end
_fields_times(name, x, stop, ::Val{0}) = nothing
function _fields_times(name, x, stop, ::Val{N}) where {N}
    _fields_times(name, x, stop, Val(N - 1))
    return _check_times(name, getfield(x, N), stop)
end

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
@noinline function _kernel_as_coupling_error(x, use)
    throw(
        ArgumentError(
            "$(nameof(typeof(x))) is a kernel: use Recurrence($use) with " *
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

@doc raw"""
The element type the parameters of `x` contribute to an operator's buffer.

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

# Promote over the fields of `x` (a struct, tuple or named tuple), unrolled
# so a concrete type infers. The recursion goes only through
# `param_eltype(field)`, whose argument is part of its parent. A recursion
# that carries the field count or a tuple's length in its signature
# (`Val(N)`, `map` over a tuple) is widened by inference's recursion limit
# when an inner struct has more fields than an outer one, as
# `Depletion` inside a `Recurrence` does.
@generated function _fields_eltype(x)
    calls = (:(param_eltype(getfield(x, $i))) for i in 1:fieldcount(x))
    return :(promote_type(Bool, $(calls...)))
end

# A zeroed array like `x` of eltype `T` and size `dims`.
_zeros(x, ::Type{T}, dims...) where {T} = fill!(similar(x, T, dims), zero(T))
# CPU arrays allocate with `zeros`, which AD backends treat as one call
# rather than tracing the fill.
const _CPUArray = Union{
    Array, SubArray{<:Any, <:Any, <:Array}, Base.ReshapedArray{<:Any, <:Any, <:Array},
    Base.ReshapedArray{<:Any, <:Any, <:SubArray{<:Any, <:Any, <:Array}},
}
_zeros(::_CPUArray, ::Type{T}, dims...) where {T} = zeros(T, dims...)

# A kernel given as columns: host columns of one concrete type are held as
# given. Others are stacked into one vector: columns of mixed types into
# their promoted type, so the loops that read them infer, and device columns
# into one device array, which a device loop reads.
function _ragged(ks::AbstractVector{K}) where {K}
    return _ragged(Val(isconcretetype(K) && K <: _CPUArray), ks)
end
_ragged(::Val{true}, ks) = _Columns(ks)
_ragged(::Val{false}, ks) = _Ragged(ks)

# A state vector of eltype `T`, copied so the caller's input is untouched.
_state_vector(::Type{T}, s) where {T} = copyto!(similar(s, T, length(s)), s)
