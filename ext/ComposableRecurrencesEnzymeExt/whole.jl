# The rule on the entry point `_ad_call(op, args...)`, which takes the
# operator whole: by value, or in a `Ref` when it holds a float outside its
# arrays (see `_ad`).

using ComposableRecurrences: _ad_call, _unbox

# The operator and the shadow its mirror is read from, or `nothing` when it
# has none. Under runtime activity a constant `Ref` or array comes as its
# own shadow.
_operator(x::Const) = _unbox(x.val), nothing
function _operator(x::Union{Duplicated{<:Base.RefValue}, DuplicatedNoNeed{<:Base.RefValue}})
    return x.val[], x.dval === x.val ? nothing : x.dval
end
_operator(x::Union{Duplicated, DuplicatedNoNeed}) = x.val, x.dval
function _operator(x::Annotation)
    throw(
        ArgumentError(
            "the Enzyme rule takes an operator holding scalar floats in a " *
                "Const or Duplicated Ref; got $(nameof(typeof(x)))"
        )
    )
end

# The operator's scalar cotangents go into the shadow of its `Ref`; an
# operator passed by value holds none.
function _op_writeback!(dop::Base.RefValue, m)
    _hasscalar(m) && (dop[] = _addback(dop[], m))
    return nothing
end
_op_writeback!(dop, m) = nothing

# The primal and shadow are typed by the return annotation, which is the
# inferred return type of `_ad_call` and may be abstract.
function EnzymeRules.augmented_primal(
        config::EnzymeRules.RevConfig, ::Const{typeof(_ad_call)},
        ::Type{RA}, op::Annotation, args::Vararg{Annotation, N}
    ) where {RA <: Annotation, N}
    EnzymeRules.width(config) == 1 ||
        throw(ArgumentError("batched Enzyme reverse mode is not supported"))
    y, cache = _run_forward(first(_operator(op)), map(_val, args)...)
    dy = EnzymeRules.needs_shadow(config) ? Enzyme.make_zero(y) : nothing
    ret = EnzymeRules.needs_primal(config) ? y : nothing
    R = eltype(RA)
    P = EnzymeRules.needs_primal(config) ? R : Nothing
    D = EnzymeRules.needs_shadow(config) ? R : Nothing
    tape = (cache, y, dy)
    return EnzymeRules.AugmentedReturn{P, D, typeof(tape)}(ret, dy, tape)
end

function EnzymeRules.reverse(
        config::EnzymeRules.RevConfig, ::Const{typeof(_ad_call)}, ::Type{<:Annotation},
        tape, op::Annotation, args::Vararg{Annotation, N}
    ) where {N}
    cache, y, dy = tape
    # An unused output still owes each `Active` argument a zero cotangent.
    dy === nothing && return (nothing, map(a -> _ez_ret(a, nothing), args)...)
    mode = EnzymeRules.runtime_activity(config) ? _Shared() : _Distinct()
    o, dop = _operator(op)
    m = dop === nothing ? nothing : _ezs(o, _unbox(dop), mode)
    ms = map(a -> _ez(a, mode), args)
    _run_pullback!((; piece = m, y = _ezs(y, dy, mode), args = ms), o, cache)
    dop === nothing || _op_writeback!(dop, m)
    foreach(_ez_writeback!, args, ms)
    return (nothing, map(_ez_ret, args, ms)...)
end
