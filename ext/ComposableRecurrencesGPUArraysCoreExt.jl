module ComposableRecurrencesGPUArraysCoreExt

using ComposableRecurrences: ComposableRecurrences, Device, Pressure,
    Secondary, Serial, TimeVarying, _Ragged, _Piecewise, _PIECEWISE_DEVICE
using GPUArraysCore: AbstractGPUArray, AnyGPUArray
using KernelAbstractions: get_backend
using LinearAlgebra: Diagonal, mul!
using SparseArrays: SparseMatrixCSC

ComposableRecurrences._resolve(::Serial, x::AbstractGPUArray) = Device(get_backend(x))

# Device arrays reverse by indexing with a reversed range, one gather,
# where `reverse` would index each entry from the host.
function ComposableRecurrences._reverse_dim(x::AnyGPUArray, d)
    return x[ntuple(i -> i == d ? (size(x, i):-1:1) : Colon(), Val(ndims(x)))...]
end

# A call on device inputs reads its kernel, coupling, modifiers, other
# inputs and states inside kernels, so a float array among them must live on
# the device too. Integer arrays, such as `Allocate`'s groups, are copied
# where a loop needs them.
function ComposableRecurrences._check_device(::AnyGPUArray, parts)
    _piecewise_leaf(parts) && throw(ArgumentError(_PIECEWISE_DEVICE))
    _host_leaf(parts) && throw(
        ArgumentError(
            "the inputs live on a device but a kernel, coupling, modifier " *
                "parameter, gain, add input or state is a host array; move " *
                "every array a call reads to the device of the inputs"
        )
    )
    return nothing
end

_host_leaf(::Array) = true
_host_leaf(::Array{<:Integer}) = false
_host_leaf(::AbstractGPUArray) = false
_host_leaf(::Union{Number, Symbol, Nothing, Function, Type, Module}) = false
_host_leaf(x::Tuple) = any(_host_leaf, x)
function _host_leaf(x::T) where {T}
    isstructtype(T) || return false
    return any(i -> _host_leaf(getfield(x, i)), 1:fieldcount(T))
end

_piecewise_leaf(::_Piecewise) = true
const _NoPiecewise = Union{AbstractArray, Number, Symbol, Nothing, Function, Type, Module}
_piecewise_leaf(::_NoPiecewise) = false
_piecewise_leaf(x::Tuple) = any(_piecewise_leaf, x)
function _piecewise_leaf(x::T) where {T}
    isstructtype(T) || return false
    return any(i -> _piecewise_leaf(getfield(x, i)), 1:fieldcount(T))
end

# The longest column of a ragged kernel whose offsets live on a device, as
# one reduction there.
function ComposableRecurrences._maxlen(g::_Ragged{<:AbstractVector, <:AnyGPUArray})
    n = length(g.offsets)
    n <= 1 && return 0
    o = g.offsets
    return mapreduce(-, max, view(o, 2:n), view(o, 1:(n - 1)); init = 0)
end

# Host index arrays a loop reads, copied to the device of `v`.
function ComposableRecurrences._like(v::AnyGPUArray, x::Array)
    return copyto!(similar(v, eltype(x), size(x)), x)
end
# Columns on a device stack there.
function ComposableRecurrences._like(ks::AbstractVector{<:AnyGPUArray}, x::Array)
    return isempty(ks) ? x : ComposableRecurrences._like(first(ks), x)
end

# Couplings on a device mix the strata with one `mul!` (or broadcast) per
# step. The coupling must live on the device of the pressures.
function ComposableRecurrences.forward(
        C::AbstractMatrix, ::Pressure, q::AnyGPUArray, p, t
    )
    mul!(q, C, p)
    return nothing
end
function ComposableRecurrences.forward(
        C::Diagonal, ::Pressure, q::AnyGPUArray, p, t
    )
    q .= C.diag .* p
    return nothing
end
function ComposableRecurrences.forward(
        C::TimeVarying{Secondary, <:AbstractArray{<:Any, 3}}, ::Pressure,
        q::AnyGPUArray, p, t
    )
    mul!(q, view(C.x, :, :, t), p)
    return nothing
end
function ComposableRecurrences.forward(
        C::SparseMatrixCSC, ::Pressure, q::AnyGPUArray, p, t
    )
    throw(
        ArgumentError(
            "a SparseMatrixCSC coupling lives on the host; move it to the " *
                "device of the inputs, as a device sparse matrix"
        )
    )
end

end
