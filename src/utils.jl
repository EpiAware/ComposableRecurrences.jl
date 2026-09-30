# Shape and eltype helpers shared by the operators.

_nstrata(x::AbstractVector) = 1
_nstrata(x::AbstractMatrix) = size(x, 1)

# A gain or add slot at stratum `k`, step `t`. A missing add is `false`,
# the additive identity for every `Real`.
_at(x::Real, k, t) = x
_at(::Nothing, k, t) = false
_at(x::AbstractVector, k, t) = x[t]
_at(x::AbstractMatrix, k, t) = x[k, t]

# The number of steps a gain or add slot fixes, or `nothing`.
_steps(x::AbstractArray) = size(x, ndims(x))
_steps(x) = nothing

# The steps a kernel or coupling covers: only time-varying ones do.
_tv_steps(x::TimeVarying) = size(x.x, ndims(x.x))
_tv_steps(x) = nothing

# The number of steps of a call. The gain and add inputs set it and must
# agree; without them the time-varying slots set it from `start` on. Every
# time-varying slot must cover steps `start` to `start + T - 1`.
function _nsteps(start, inputs::Tuple, varying::Tuple)
    T = nothing
    for (name, n) in inputs
        n === nothing && continue
        if T === nothing
            T = n
        elseif n != T
            throw(
                DimensionMismatch(
                    "$name has $n steps but an earlier input has $T"
                )
            )
        end
    end
    for (name, n) in varying
        n === nothing && continue
        T === nothing && (T = n - start + 1)
        n >= start + T - 1 || throw(
            DimensionMismatch(
                "$name covers $n steps, fewer than start + T - 1 = " *
                    "$(start + T - 1)"
            )
        )
    end
    T === nothing && throw(
        ArgumentError(
            "the number of steps is not set: pass a length-T or S × T " *
                "gain or add, or a TimeVarying kernel or coupling"
        )
    )
    return T
end

# Check a strata × time slot against `S` strata.
_check_strata(name, x, S) = nothing
function _check_strata(name, x::AbstractMatrix, S)
    size(x, 1) == S || throw(
        DimensionMismatch("$name has $(size(x, 1)) strata, expected $S")
    )
    return nothing
end

@doc "
The element type the parameters of `x` contribute to an operator's buffer.

The buffer eltype is the float promotion of this over the kernel, coupling,
modifiers, inputs and history, so a ForwardDiff Dual or a Float32 anywhere
sets it.
The default recurses by value through fields, tuples and named tuples, so
abstractly typed fields count; a `Real` gives its type and an array of reals
its eltype.
Add a method for a type whose parameters this does not reach.

# Arguments
- `x`: any object, such as a modifier, coupling or kernel.

# Examples
```@example
using ComposableRecurrences
struct Scale
    a
    extra::NamedTuple
end
ComposableRecurrences.param_eltype(Scale(1.0f0, (; b = 2)))
```
"
param_eltype(x) = _fields_eltype(x, Val(fieldcount(typeof(x))))
param_eltype(x::Real) = typeof(x)
param_eltype(x::AbstractArray{<:Real}) = eltype(x)
function param_eltype(x::AbstractArray)
    return mapreduce(param_eltype, promote_type, x; init = Bool)
end
param_eltype(x::Union{Tuple, NamedTuple}) = promote_type(Bool, map(param_eltype, values(x))...)
param_eltype(::Union{Nothing, Symbol, AbstractString, Type, Module}) = Bool

# Promote over the first `N` fields, unrolled so a concrete struct infers.
_fields_eltype(x, ::Val{0}) = Bool
function _fields_eltype(x, ::Val{N}) where {N}
    return promote_type(
        _fields_eltype(x, Val(N - 1)), param_eltype(getfield(x, N))
    )
end

# A state vector of eltype `T`, copied so the caller's input is untouched.
_state_vector(::Type{T}, s) where {T} = copyto!(zeros(T, length(s)), s)
