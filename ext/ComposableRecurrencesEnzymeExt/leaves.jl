# The rule on Julia 1.11: one varargs `augmented_primal`/`reverse` pair on
# `_ADLeaves{X}()(leaves...)`, which takes each leaf of the operator and its
# arguments as its own annotated argument (see `src/adjoint_leaves.jl`). The
# leaves' shadows are read into the mirrors `pullback!` accumulates into,
# assembled along the leaves' field paths; scalar cotangents are returned
# for `Active` leaves. Included only on Julia 1.11; it goes when 1.11 does.

using ComposableRecurrences: _ADLeaves, _is_leaf, _leaf_paths, _rebuild_leaves

# The mirror of an annotated argument.
_ez(::Const) = nothing
_ez(a::Active) = _ezs(a.val, Enzyme.make_zero(a.val))
_ez(a::Union{Duplicated, DuplicatedNoNeed}) = _ezs(a.val, a.dval)
_ez(a::MixedDuplicated) = _ezs(a.val, a.dval[])

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

# `map` and `foreach` over the rule's leaves, unrolled so that the result is
# concretely typed at any number of leaves: `map` over tuples of 32 or more
# entries returns a `Tuple` of unknown type, which Enzyme rejects as a
# rule's return, and `ntuple` infers each entry only while constant
# propagation reaches it. Each generator reads only the number of leaves,
# as inference does not expand one that reads an argument whose type is not
# concrete, and a leaf's mirror can be a `Union`.
@generated function _map_leaves(f, xs::Tuple{Vararg{Any, N}}) where {N}
    return :(($((:(f(xs[$i])) for i in 1:N)...),))
end
@generated function _map_leaves(f, xs::Tuple{Vararg{Any, N}}, ys::Tuple) where {N}
    return :(($((:(f(xs[$i], ys[$i])) for i in 1:N)...),))
end
@generated function _foreach_leaves(f, xs::Tuple{Vararg{Any, N}}, ys::Tuple) where {N}
    return Expr(:block, (:(f(xs[$i], ys[$i])) for i in 1:N)..., :(return nothing))
end
_val(a) = a.val

# A scalar leaf of the rule's entry point.
_active_float(::Active{<:_IEEEFloat}) = true
_active_float(a::MixedDuplicated) = _holds_float(typeof(a.val))
_active_float(a) = false
_any_active_float(leaves) = any(_active_float, leaves)
# The mirrors of the operator and its arguments, assembled from the leaves'
# mirrors `ms` along the leaf paths of `X`, as `_ezs` builds them. An
# operator or argument whose leaves are all `Const` mirrors as `nothing`.
@generated function _assemble(::Type{X}, ::Type{A}, ms::Tuple) where {X, A}
    k = Ref(0)
    function build(T)
        _is_leaf(T) && return :(ms[$(k[] += 1)])
        T === Nothing && return :nothing
        parts = [build(fieldtype(T, i)) for i in 1:fieldcount(T)]
        T <: Tuple && return :(($(parts...),))
        return :(NamedTuple{$(fieldnames(T))}(($(parts...),)))
    end
    tops = map(fieldtypes(X)) do T
        n = length(_leaf_paths(T))
        consts = all(i -> fieldtype(A, k[] + i) <: Const, 1:n)
        consts ? (k[] += n; :nothing) : build(T)
    end
    return :(($(tops...),))
end

# The primal and shadow are typed by the return annotation, which is the
# inferred return type of `_ADLeaves` and may be abstract.
function EnzymeRules.augmented_primal(
        config::EnzymeRules.RevConfig, ::Const{_ADLeaves{X}},
        ::Type{RA}, leaves::Vararg{Annotation, N}
    ) where {X, RA <: Annotation, N}
    EnzymeRules.width(config) == 1 ||
        throw(ArgumentError("batched Enzyme reverse mode is not supported"))
    VERSION < v"1.12" &&
        _warn_scalar_loss(fieldtype(X, 1), leaves, _any_active_float)
    y, cache = _run_forward(_rebuild_leaves(X, _map_leaves(_val, leaves))...)
    dy = EnzymeRules.needs_shadow(config) ? Enzyme.make_zero(y) : nothing
    ret = EnzymeRules.needs_primal(config) ? y : nothing
    R = eltype(RA)
    P = EnzymeRules.needs_primal(config) ? R : Nothing
    D = EnzymeRules.needs_shadow(config) ? R : Nothing
    tape = (cache, y, dy)
    return EnzymeRules.AugmentedReturn{P, D, typeof(tape)}(ret, dy, tape)
end

function EnzymeRules.reverse(
        ::EnzymeRules.RevConfig, ::Const{_ADLeaves{X}}, ::Type{<:Annotation},
        tape, leaves::Vararg{Annotation, N}
    ) where {X, N}
    cache, y, dy = tape
    dy === nothing && return _map_leaves(_ -> nothing, leaves)
    lms = _map_leaves(_ez, leaves)
    ms = _assemble(X, typeof(leaves), lms)
    grads = (; piece = first(ms), y = _ezs(y, dy), args = Base.tail(ms))
    _run_pullback!(grads, _rebuild_leaves(X, _map_leaves(_val, leaves))[1], cache)
    _foreach_leaves(_ez_writeback!, leaves, lms)
    return _map_leaves(_ez_ret, leaves, lms)
end
