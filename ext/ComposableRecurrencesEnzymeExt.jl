# Enzyme reverse-mode rule for every operator with a `pullback!`: one
# varargs `augmented_primal`/`reverse` pair on the internal entry point
# `_ad(op, args...)`. Shadows are read into the mirrors `pullback!`
# accumulates into; scalar cotangents are returned for `Active` arguments and
# written back for `MixedDuplicated` ones.
module ComposableRecurrencesEnzymeExt

using ComposableRecurrences: Recurrence, _WithState, _ad, _plain, forward,
    pullback!
using Enzyme: Enzyme, EnzymeRules, Annotation, Const, Active, Duplicated,
    DuplicatedNoNeed, MixedDuplicated
using LinearAlgebra: Diagonal
using SparseArrays: SparseMatrixCSC, nonzeros

const _IEEEFloat = Union{Float16, Float32, Float64}
const _Inert = Union{Nothing, Integer, Symbol, AbstractArray{<:Integer}}

# The mirror of an annotated argument.
_ez(::Const) = nothing
_ez(a::Active) = _ezs(a.val, Enzyme.make_zero(a.val))
_ez(a::Union{Duplicated, DuplicatedNoNeed}) = _ezs(a.val, a.dval)
_ez(a::MixedDuplicated) = _ezs(a.val, a.dval[])

# The mirror of primal `x` from its shadow `dx`.
_ezs(x::_IEEEFloat, dx) = Ref(zero(x))
_ezs(::_Inert, dx) = nothing
# Under runtime activity a constant array's shadow is the primal itself.
_ezs(x::AbstractArray{<:_IEEEFloat}, dx::AbstractArray) = dx === x ? nothing : dx
function _ezs(x::SparseMatrixCSC, dx::SparseMatrixCSC)
    return (; nzval = _ezs(nonzeros(x), nonzeros(dx)))
end
_ezs(x::Diagonal, dx::Diagonal) = (; diag = _ezs(x.diag, dx.diag))
_ezs(x::Union{Tuple, NamedTuple}, dx) = map(_ezs, x, dx)
function _ezs(x, dx)
    names = fieldnames(typeof(x))
    return NamedTuple{names}(map(n -> _ezs(getfield(x, n), getfield(dx, n)), names))
end

# Whether a mirror holds a nonzero scalar cotangent.
_hasscalar(m::Base.RefValue) = !iszero(m[])
_hasscalar(m::Union{Tuple, NamedTuple}) = any(_hasscalar, values(m))
_hasscalar(m) = false

# The returned cotangent of an `Active` argument: its scalar leaves rebuilt.
_ez_ret(a::Active, m) = _addback(Enzyme.make_zero(a.val), m)
_ez_ret(a, m) = nothing

# Scalar cotangents of a `MixedDuplicated` argument are written back into its
# shadow. A `Duplicated` immutable shadow cannot take them, so refuse rather
# than drop them.
_ez_writeback!(a, m) = nothing
function _ez_writeback!(a::MixedDuplicated, m)
    a.dval[] = _addback(a.dval[], m)
    return nothing
end
function _ez_writeback!(a::Union{Duplicated, DuplicatedNoNeed}, m)
    _hasscalar(m) && throw(
        ArgumentError(
            "a Duplicated $(typeof(a.val)) has scalar float fields whose " *
                "cotangents Enzyme cannot receive; annotate it Active or " *
                "MixedDuplicated, or Const"
        )
    )
    return nothing
end

_addback(dx, m) = m === nothing ? dx : _addback1(dx, m)
_addback1(dx::Real, m::Base.RefValue) = dx + m[]
_addback1(dx::AbstractArray, m) = dx
_addback1(dx::Union{Tuple, NamedTuple}, m) = map(_addback, dx, m)
function _addback1(dx::T, m) where {T}
    fs = map(n -> _addback(getfield(dx, n), getfield(m, n)), fieldnames(T))
    return Base.typename(T).wrapper(fs...)
end

function EnzymeRules.augmented_primal(
        config::EnzymeRules.RevConfig, ::Const{typeof(_ad)},
        ::Type{<:Annotation}, args::Vararg{Annotation, N}
    ) where {N}
    EnzymeRules.width(config) == 1 ||
        throw(ArgumentError("batched Enzyme reverse mode is not supported"))
    y, cache = forward(map(a -> a.val, args)...)
    dy = EnzymeRules.needs_shadow(config) ? Enzyme.make_zero(y) : nothing
    ret = EnzymeRules.needs_primal(config) ? y : nothing
    return EnzymeRules.AugmentedReturn(ret, dy, (cache, y, dy))
end

function EnzymeRules.reverse(
        ::EnzymeRules.RevConfig, ::Const{typeof(_ad)}, ::Type{<:Annotation},
        tape, args::Vararg{Annotation, N}
    ) where {N}
    cache, y, dy = tape
    dy === nothing && return map(_ -> nothing, args)
    ms = map(_ez, args)
    pullback!(first(args).val, cache, _ezs(y, dy), ms...)
    foreach(_ez_writeback!, args, ms)
    return map(_ez_ret, args, ms)
end

# Plain Enzyme reverse AD of a sparse coupling's products in a loop gives
# wrong gradients, so `NoAdjoint` on an active sparse coupling is refused.
const _SparseRec = Recurrence{<:Any, <:SparseMatrixCSC}
const _SparseOp = Union{_SparseRec, _WithState{<:_SparseRec}}
const _ActiveSparse = Union{
    Duplicated{<:_SparseOp}, DuplicatedNoNeed{<:_SparseOp},
    MixedDuplicated{<:_SparseOp},
}
const _SPARSE_MSG = "plain Enzyme reverse AD of a sparse coupling gives " *
    "wrong gradients; drop NoAdjoint so the analytic rule runs"

function EnzymeRules.augmented_primal(
        ::EnzymeRules.RevConfig, ::Const{typeof(_plain)}, ::Type{<:Annotation},
        op::_ActiveSparse, args::Vararg{Annotation, N}
    ) where {N}
    throw(ArgumentError(_SPARSE_MSG))
end
function EnzymeRules.reverse(
        ::EnzymeRules.RevConfig, ::Const{typeof(_plain)}, ::Type{<:Annotation},
        tape, op::_ActiveSparse, args::Vararg{Annotation, N}
    ) where {N}
    throw(ArgumentError(_SPARSE_MSG))
end

end
