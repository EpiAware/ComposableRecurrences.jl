module ComposableRecurrencesGPUArraysCoreExt

using ComposableRecurrences: ComposableRecurrences, Add, Clamp, Depletion,
    Derived, Device, Pairwise, PerStratum, Pressure, Protected, Redistribute,
    Secondary, Serial, TimeVarying, Transform, _OldestFirstPairwise
using Adapt: Adapt, adapt
using ConstructionBase: constructorof, getfields
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

# Host index arrays a loop reads, copied to the device of `v`.
function ComposableRecurrences._like(v::AnyGPUArray, x::Array)
    return copyto!(similar(v, eltype(x), size(x)), x)
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

# Coefficient wrappers and built-in modifiers carry their arrays into a
# kernel: each is rebuilt from its adapted fields, as `constructorof`
# rebuilds it elsewhere.
const _Adapted = Union{
    PerStratum, Pairwise, TimeVarying, _OldestFirstPairwise, Depletion,
    Protected, Add, Clamp, Redistribute, Transform, Derived,
}
function Adapt.adapt_structure(to, x::_Adapted)
    return constructorof(typeof(x))(map(f -> adapt(to, f), Tuple(getfields(x)))...)
end

end
