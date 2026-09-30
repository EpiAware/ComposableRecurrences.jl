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

# The number of steps a kernel or coupling fixes: only time-varying ones do.
_tv_steps(x::TimeVarying) = size(x.x, ndims(x.x))
_tv_steps(x) = nothing

# The number of steps the time-indexed slots agree on, from `name => steps`
# pairs where `steps` is `nothing` for a slot that sets none.
function _nsteps(slots::Pair...)
    T = nothing
    for (name, n) in slots
        n === nothing && continue
        if T === nothing
            T = n
        elseif n != T
            throw(
                DimensionMismatch(
                    "$name has $n steps but an earlier slot has $T"
                )
            )
        end
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

_eltype(x::Real) = typeof(x)
_eltype(x::AbstractArray) = eltype(x)
_eltype(x::UniformScaling) = eltype(x)
_eltype(x::Union{TimeVarying, PerStratum, Pairwise}) = eltype(x.x)
_eltype(::Nothing) = Bool

# A modifier's `Real` and `AbstractArray{<:Real}` fields set its parameter
# eltype, so a Dual parameter promotes the buffer.
_leaf_eltype(::Type{T}) where {T <: Real} = T
_leaf_eltype(::Type{<:AbstractArray{T}}) where {T <: Real} = T
_leaf_eltype(::Type) = Bool
function _param_eltype(m)
    return promote_type(Bool, map(_leaf_eltype, fieldtypes(typeof(m)))...)
end

# The buffer eltype: every input and parameter, promoted and made float.
_buffer_eltype(xs...) = float(promote_type(map(_eltype, xs)...))

# A state vector of eltype `T`, copied so the caller's input is untouched.
_state_vector(::Type{T}, s) where {T} = copyto!(zeros(T, length(s)), s)
