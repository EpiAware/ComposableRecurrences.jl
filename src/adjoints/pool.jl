# A per-task pool of the working arrays of a recurrence's rule: its
# forward pass takes them from the pool, and its pullback gives back those
# no output holds, for the next call of the same shape. Prototype.
const _POOL_KEY = :_ComposableRecurrences_rule_pool
const _POOL_DEPTH = 4
function _pool()
    tls = task_local_storage()
    p = get(tls, _POOL_KEY, nothing)
    if p === nothing
        p = Dict{Any, Vector{Any}}()
        tls[_POOL_KEY] = p
    end
    return p::Dict{Any, Vector{Any}}
end
function _take(::Type{T}, dims::Vararg{Int, N}) where {T, N}
    v = get(_pool(), (T, dims), nothing)
    (v === nothing || isempty(v)) && return Array{T, N}(undef, dims...)
    return pop!(v)::Array{T, N}
end
_give!(x) = nothing
_give!(x::Union{Tuple, NamedTuple}) = (foreach(_give!, values(x)); nothing)
# Only matrices: a stateless modifier's record is the vector of its
# starting state, which the returned state may share.
function _give!(A::Matrix{<:AbstractFloat})
    v = get!(Vector{Any}, _pool(), (eltype(A), size(A)))
    length(v) < _POOL_DEPTH && !any(x -> x === A, v) && push!(v, A)
    return nothing
end
# Working arrays of a kept run: from the pool for host arrays.
_kept_similar(h, ::Type{Tp}, dims::Vararg{Int, N}) where {Tp, N} = similar(h, Tp, dims...)
_kept_similar(::Array, ::Type{Tp}, dims::Vararg{Int, N}) where {Tp, N} = _take(Tp, dims...)
