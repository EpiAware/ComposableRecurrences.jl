# The rule's entry point on Julia 1.11, where `Enzyme` mishandles a
# struct that holds both an array and an active float: `_ad` passes the
# primitive `_ADLeaves{X}` each leaf of the operator and its arguments as its
# own argument, so `Enzyme` annotates every float and array on its own, and
# `_ADLeaves` rebuilds the operator and arguments from them. Included only
# on Julia 1.11; it goes when 1.11 does.
struct _ADLeaves{X} end
function (::_ADLeaves{X})(leaves::Vararg{Any, N}) where {X, N}
    return _primal(_rebuild_leaves(X, leaves)...)
end

# The field paths to the leaves of a value of type `T`. A leaf is a float,
# an array, other data without float fields, a mutable struct or a field
# whose type is not concrete; a struct without fields has none.
function _leaf_paths(::Type{T}) where {T}
    _is_leaf(T) && return ((),)
    fieldcount(T) == 0 && return ()
    paths = Tuple[]
    for i in 1:fieldcount(T), p in _leaf_paths(fieldtype(T, i))
        push!(paths, (i, p...))
    end
    return Tuple(paths)
end
function _is_leaf(T)
    T <: Union{
        Base.IEEEFloat, AbstractArray, Integer, Symbol, AbstractString, Char,
        Type, Module, Ptr,
    } && return true
    return !isconcretetype(T) || ismutabletype(T) ||
        (fieldcount(T) == 0 && !Base.issingletontype(T))
end
function _path_expr(x, p)
    isempty(p) && return x
    return _path_expr(:(getfield($x, $(first(p)))), Base.tail(p))
end
# After its helpers: a generator sees only the methods defined before it.
@generated function _ad(op, args::Vararg{Any, N}) where {N}
    X = Tuple{op, args...}
    roots = (:op, (:(args[$i]) for i in 1:N)...)
    leaves = map(p -> _path_expr(roots[first(p)], Base.tail(p)), _leaf_paths(X))
    return :(_ADLeaves{$X}()($(leaves...)))
end

# The value of type `X` with the given leaves, built field by field without
# calling constructors.
@generated function _rebuild_leaves(::Type{X}, leaves::Tuple) where {X}
    k = Ref(0)
    function build(T)
        _is_leaf(T) && return :(leaves[$(k[] += 1)])
        fieldcount(T) == 0 && return T.instance
        parts = (build(fieldtype(T, i)) for i in 1:fieldcount(T))
        T <: Tuple && return :(($(parts...),))
        return Expr(:new, T, parts...)
    end
    return build(X)
end
