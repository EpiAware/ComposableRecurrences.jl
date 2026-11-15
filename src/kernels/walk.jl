# A computed kernel's weights walked one cohort at a time, lag by lag, as a
# hand-written loop does: each `Survival` keeps its cohort's survival and
# hazard at each lag in a buffer of `L` entries, so a call that reads each
# weight once (a convolution, `kernel_weights`) holds no block of weights.
# The reverse pass walks the cohort forward again, then back along its lags
# once: each `Survival` carries the cotangent of its survival from the
# current lag on, takes it to its hazard, and its hazard's cotangent goes
# on down the tree at the same lag. A `Survival` is read once per lag, by
# its parent, so its cotangent at a lag is whole once its parent's is
# added.

# A `Survival`'s survival `S` and hazard `H` at each lag index of the cohort
# walked, and `acc`: the cotangent of its survival from the current lag on
# (`acc[1]`) and the cotangent of its value at the current lag added by its
# parent (`acc[2]`).
struct _WalkScratch{C, V <: AbstractVector}
    hazard::C
    S::V
    H::V
    acc::V
end
_walk_scratch(x, ::Type, L) = nothing
function _walk_scratch(x::Derived, ::Type{Tp}, L) where {Tp}
    return map(a -> _walk_scratch(a, Tp, L), x.args)
end
function _walk_scratch(x::Survival, ::Type{Tp}, L) where {Tp}
    return _WalkScratch(
        _walk_scratch(x.hazard, Tp, L), _alloc(Tp, L), _alloc(Tp, L),
        zeros(Tp, 2)
    )
end

# Whether a `Survival` in a coefficient of type `T` has a strata axis, from
# the type. Without one, every stratum shares each cohort's walk.
_walks_strata_type(::Type) = false
_walks_strata_type(::Type{<:Survival{H}}) where {H} = _stratified_type(H)
function _walks_strata_type(::Type{<:Derived{F, A}}) where {F, A}
    return any(_walks_strata_type, fieldtypes(A))
end
@generated _walks_strata(x) = _walks_strata_type(x)

# The strata each walk serves: one walk for all of `ks` when no `Survival`
# has strata, else one walk per stratum.
_walk_groups(x, ks) = _walks_strata(x) ? ks : (first(ks):first(ks))
_walk_strata(x, ks, k0) = _walks_strata(x) ? (k0:k0) : ks

# Step every `Survival` in `x` to lag index `i` (lag `l`) of cohort `τ`,
# for stratum `k`, inner ones first.
_walk!(x, sc, k, i, τ, l) = nothing
function _walk!(x::Derived, sc, k, i, τ, l)
    _walk_args!(x.args, sc, k, i, τ, l)
    return nothing
end
_walk_args!(::Tuple{}, ::Tuple{}, k, i, τ, l) = nothing
@inline function _walk_args!(args::Tuple, sc::Tuple, k, i, τ, l)
    _walk!(first(args), first(sc), k, i, τ, l)
    return _walk_args!(Base.tail(args), Base.tail(sc), k, i, τ, l)
end
@inline function _walk!(x::Survival, sc::_WalkScratch, k, i, τ, l)
    _walk!(x.hazard, sc.hazard, k, i, τ, l)
    (; S, H) = sc
    T = eltype(S)
    @inbounds begin
        prev = i == 1 ? one(T) : S[i - 1]
        if l < x.from
            H[i] = zero(T)
            S[i] = prev
        else
            η = _value(x.hazard, sc.hazard, k, i, τ, l, 1)
            H[i] = η
            S[i] = prev * (one(T) - η)
        end
    end
    return nothing
end
Base.@propagate_inbounds function _value(
        x::Survival, sc::_WalkScratch, k, i, τ, l, b
    )
    return sc.S[i]
end
_add_value!(::Nothing, x::Survival, sc::_WalkScratch, v, k, i, τ, l, b) = nothing
@inline Base.@propagate_inbounds function _add_value!(
        x̄, x::Survival, sc::_WalkScratch, v, k, i, τ, l, b
    )
    sc.acc[2] += v
    return nothing
end

# Clear the cotangents of every `Survival` in `x` before a cohort's walk
# back.
_walk_clear!(sc) = nothing
_walk_clear!(sc::Tuple) = (map(_walk_clear!, sc); nothing)
function _walk_clear!(sc::_WalkScratch)
    fill!(sc.acc, zero(eltype(sc.acc)))
    _walk_clear!(sc.hazard)
    return nothing
end

# Once the cotangents of lag index `i` are added at the top, each
# `Survival` in turn, outer ones first, adds its value's cotangent to the
# running one `a`, passes `-s_{i-1} a` to its hazard at the same lag, and
# carries `a (1 - η_i)` back to the lag before.
_walk_back!(x̄, x, sc, k, i, τ, l) = nothing
function _walk_back!(x̄, x::Derived, sc, k, i, τ, l)
    ā = _arg_mirrors(cotangent(x̄, :args), x.args)
    ā === nothing && return nothing
    _walk_back_args!(ā, x.args, sc, k, i, τ, l)
    return nothing
end
_walk_back_args!(::Tuple{}, ::Tuple{}, ::Tuple{}, k, i, τ, l) = nothing
@inline function _walk_back_args!(ā::Tuple, args::Tuple, sc::Tuple, k, i, τ, l)
    _walk_back!(first(ā), first(args), first(sc), k, i, τ, l)
    rest = (Base.tail(ā), Base.tail(args), Base.tail(sc))
    return _walk_back_args!(rest..., k, i, τ, l)
end
_walk_back!(::Nothing, x::Survival, sc, k, i, τ, l) = nothing
@inline function _walk_back!(x̄, x::Survival, sc::_WalkScratch, k, i, τ, l)
    h̄ = cotangent(x̄, :hazard)
    (; S, H, acc) = sc
    T = eltype(S)
    @inbounds begin
        a = acc[1] + acc[2]
        acc[2] = zero(T)
        if l >= x.from
            prev = i == 1 ? one(T) : S[i - 1]
            _add_value!(h̄, x.hazard, sc.hazard, -prev * a, k, i, τ, l, 1)
            a *= one(T) - H[i]
        end
        acc[1] = a
    end
    _walk_back!(h̄, x.hazard, sc.hazard, k, i, τ, l)
    return nothing
end

# ---- the weights as an array, by the walk --------------------------------------

# The weights of cohorts `1:n`, lags from `o`, each one whose weight lands
# by `last`, into `K` (lags × cohorts, or strata × lags × cohorts).
function _walk_fill!(K, kernel::_ComputedKernel, o, last)
    x = kernel.x
    L = _coef_lags(x)
    sc = _walk_scratch(x, eltype(K), L)
    ks = _weights_strata(K)
    for k0 in _walk_groups(x, ks), τ in axes(K, ndims(K))
        for i in 1:_imax(τ, L, o, last)
            l = i - 1 + o
            _walk!(x, sc, k0, i, τ, l)
            for k in _walk_strata(x, ks, k0)
                @inbounds _set_weight!(K, _value(x, sc, k, i, τ, l, 1), k, i, τ)
            end
        end
    end
    return K
end

# Take the cotangent `K̄` of those weights back to the coefficients' mirror
# `x̄`.
function _walk_weights_back!(x̄, kernel::_ComputedKernel, K̄, o, last)
    x = kernel.x
    L = _coef_lags(x)
    sc = _walk_scratch(x, eltype(K̄), L)
    ks = _weights_strata(K̄)
    for k0 in _walk_groups(x, ks), τ in axes(K̄, ndims(K̄))
        imax = _imax(τ, L, o, last)
        for i in 1:imax
            _walk!(x, sc, k0, i, τ, i - 1 + o)
        end
        _walk_clear!(sc)
        for i in imax:-1:1
            l = i - 1 + o
            for k in _walk_strata(x, ks, k0)
                v = @inbounds _weight(K̄, k, i, τ)
                iszero(v) || @inbounds _add_value!(x̄, x, sc, v, k, i, τ, l, 1)
            end
            _walk_back!(x̄, x, sc, k0, i, τ, l)
        end
    end
    return nothing
end
_weights_strata(K::AbstractMatrix) = Base.OneTo(1)
_weights_strata(K::AbstractArray{<:Any, 3}) = axes(K, 1)
Base.@propagate_inbounds _weight(K::AbstractMatrix, k, i, τ) = K[i, τ]
Base.@propagate_inbounds _weight(K::AbstractArray{<:Any, 3}, k, i, τ) = K[k, i, τ]
Base.@propagate_inbounds function _set_weight!(K::AbstractMatrix, v, k, i, τ)
    K[i, τ] = v
    return nothing
end
Base.@propagate_inbounds function _set_weight!(K::AbstractArray{<:Any, 3}, v, k, i, τ)
    K[k, i, τ] = v
    return nothing
end
