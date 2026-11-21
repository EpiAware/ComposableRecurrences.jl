module ComposableRecurrencesGPUArraysCoreExt

using ComposableRecurrences: ComposableRecurrences, Allocate, Pairwise,
    Parallel, PerStratum, Pressure, Secondary, Serial, Step, Threaded, TimeVarying,
    _AllocateImports, _FixedKernel, _OldestFirstPairwise, _Ragged, _Piecewise,
    _PIECEWISE_DEVICE, cotangent
using GPUArraysCore: AbstractGPUArray, AnyGPUArray, @allowscalar
using KernelAbstractions: get_backend
using LinearAlgebra: Diagonal, mul!
using SparseArrays: SparseMatrixCSC

# Device arrays, and views and reshapes of them, run on their own backend
# under the CPU executors: host threads cannot index them.
function ComposableRecurrences._resolve(
        ::Union{Serial, Threaded}, x::AnyGPUArray
    )
    return Parallel(get_backend(x))
end
ComposableRecurrences._on_gpu(::AnyGPUArray) = true

# The construction and call checks rebuild a part from its parameters at
# stratum 1 and time 1, once: on a device that is one read from the host.
const _DeviceParam = Union{
    PerStratum{<:AnyGPUArray}, TimeVarying{<:Any, <:AnyGPUArray{<:Any, 1}},
    TimeVarying{<:Any, <:PerStratum{<:AnyGPUArray}},
}
function ComposableRecurrences._entry(x::_DeviceParam, at::Tuple)
    return @allowscalar ComposableRecurrences.param(x, at...)
end

# A user modifier's `Init` reverses once per call, on host copies: its
# dual-number pullback runs stratum by stratum there, its scalar parameters'
# cotangents are host `Ref`s, and the history's cotangent is copied back.
function ComposableRecurrences._init_strata_back!(
        m̄, h̄, m, s̄::AnyGPUArray, s, history
    )
    h̄h = h̄ === nothing ? nothing : zeros(eltype(h̄), size(h̄))
    hh = history === nothing ? nothing : Array(history)
    ComposableRecurrences._init_strata_back!(m̄, h̄h, m, Array(s̄), Array(s), hh)
    h̄ === nothing || (h̄ .+= copyto!(similar(h̄), h̄h))
    return nothing
end
# An `Init` written only for device states would not run on those host
# copies, so a call with one keeps plain AD; the host method decides the
# rest. The probe state is built as the run builds its states.
function ComposableRecurrences._parts_fit(r, h::AnyGPUArray, tlast = 2)
    fit = @invoke ComposableRecurrences._parts_fit(r, h::Any, tlast)
    return any(m -> _device_only_init(m, h), r.modifiers) ? :none : fit
end
function _device_only_init(m, h)
    ComposableRecurrences._default_init(m, similar(h, 0), h) && return false
    host = Matrix{eltype(h)}(undef, 0, 0)
    return ComposableRecurrences._default_init(m, Vector{eltype(h)}(), host)
end

# A fixed kernel's pullback over every stratum on device arrays, as a
# route's kernel runs it; the host loop cannot index them.
function ComposableRecurrences._kernel_back!(
        kbuf, ḡ, g::_FixedKernel, p̄::AnyGPUArray, H, H̄, t, τ, L
    )
    return ComposableRecurrences._device_kernel_back!(
        kbuf, ḡ, g, p̄, H, H̄, t, τ, L
    )
end

# A pairwise kernel's pullback on device arrays, one sender per kernel
# index.
function ComposableRecurrences._kernel_back!(
        kbuf, ḡ, g::_OldestFirstPairwise, p̄::AnyGPUArray, H, H̄, t, τ, L
    )
    return ComposableRecurrences._device_pairwise_back!(
        kbuf, ḡ, g, p̄, H, H̄, t, τ, L
    )
end
function ComposableRecurrences._kernel_back!(
        kbuf, ḡ, g::TimeVarying{<:Any, <:Pairwise}, p̄::AnyGPUArray, H, H̄, t,
        τ, L
    )
    return ComposableRecurrences._device_pairwise_back!(
        kbuf, ḡ, g, p̄, H, H̄, t, τ, L
    )
end
# The oldest-first buffer of a fixed pairwise kernel adds into its
# cotangent as one array operation.
function ComposableRecurrences._kernel_finish!(
        ḡ::NamedTuple, kbuf::AnyGPUArray{<:Any, 3}
    )
    L = size(kbuf, 1)
    cotangent(ḡ, :x) .+= permutedims(kbuf[L:-1:1, :, :], (3, 2, 1))
    return nothing
end

# An `Allocate` with imports on a device reverses each group as one kernel
# index, as the host loop cannot index device arrays; the host method holds
# no device code.
function ComposableRecurrences.pullback!(
        grads, m::Allocate{<:Any, <:_AllocateImports}, ::Step,
        v::AnyGPUArray, s, t
    )
    return ComposableRecurrences._device_imports_pullback!(grads, m, v, s, t)
end

# A coupling over time on the device: see `_device_tv_coupling_back!`.
function ComposableRecurrences.pullback!(
        grads, C::TimeVarying{Secondary, <:AnyGPUArray{<:Any, 3}}, ::Pressure,
        q, p, t
    )
    return ComposableRecurrences._device_tv_coupling_back!(grads, C, p, t)
end

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

# A dense coupling's step and the kernels' reverse run in one kernel per
# step, one index per stratum, where the two products and the kernels' pass
# took a launch each. Stratum `k` sums its entry of `p̄` from a transposed
# copy of the coupling, so neighbouring indices read neighbouring entries,
# records its `q̄` and steps its kernel back. The coupling's cotangent is one
# product after the loop, `Q̄ Pᵀ`. Both buffers are made once per call.
struct _FusedSteps{A, Q}
    Cᵀ::A
    Q̄::Q
end
function ComposableRecurrences._coupling_steps(
        C̄, C::AnyGPUArray{<:Number, 2}, kernel, H::AnyGPUArray, pr
    )
    C̄m = ComposableRecurrences._array_mirror(C̄)
    Q̄ = C̄m isa AbstractMatrix ? fill!(similar(pr.P), false) : nothing
    return _FusedSteps(permutedims(C), Q̄)
end
function ComposableRecurrences._coupling_steps_done!(C̄, pr, f::_FusedSteps)
    f.Q̄ === nothing && return nothing
    mul!(ComposableRecurrences._array_mirror(C̄), f.Q̄, transpose(pr.P), true, true)
    return nothing
end
function ComposableRecurrences._coupling_kernels_back!(
        accs, kb, g, p̄, C, q̄, pr, H, H̄, t, τ, D, L, pbufs, f::_FusedSteps
    )
    ComposableRecurrences._reduce_blocks!(
        _fused_back!, accs, length(p̄), kb, g, p̄, f.Cᵀ, f.Q̄, q̄, H, H̄, t,
        t + D - L, τ, L
    )
    return nothing
end
function _fused_back!(ks, acc, kb, g, p̄, Cᵀ, Q̄, q̄, H, H̄, t, j, τ, L)
    for k in ks
        s = zero(eltype(p̄))
        for i in axes(Cᵀ, 2)
            s += @inbounds Cᵀ[k, i] * q̄[i]
        end
        @inbounds p̄[k] = s
        Q̄ === nothing || @inbounds(Q̄[k, t] = q̄[k])
        ComposableRecurrences._kernel_back_at!(kb, acc.ḡ, g, s, H, H̄, j, τ, L, k)
    end
    return nothing
end

# Couplings on a device mix the strata with one `mul!` (or broadcast) per
# step. The coupling must live on the device of the pressures.
function ComposableRecurrences.forward!(
        C::AbstractMatrix, ::Pressure, q::AnyGPUArray, p, t
    )
    mul!(q, C, p)
    return nothing
end
function ComposableRecurrences.forward!(
        C::Diagonal, ::Pressure, q::AnyGPUArray, p, t
    )
    q .= C.diag .* p
    return nothing
end
function ComposableRecurrences.forward!(
        C::TimeVarying{Secondary, <:AbstractArray{<:Any, 3}}, ::Pressure,
        q::AnyGPUArray, p, t
    )
    mul!(q, view(C.x, :, :, t), p)
    return nothing
end
function ComposableRecurrences.forward!(
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
