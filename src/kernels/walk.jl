# A computed kernel's weights for the calls that read each weight once (a
# convolution, `kernel_weights`): one walk per cohort along its lags, each
# `Survival` carrying its survival as state in a tuple that mirrors the
# kernel. The reverse pass walks the cohort again, then goes back along
# its lags once.

# Each `Survival`'s survival `S`, hazard `H` and added cotangent `P` at each
# lag index of the cohort walked: vectors of the lags, or for `S` and `H`
# columns of `n` cohorts' (lags × `n`), read one at a time through
# `_walk_column`; `P` is cleared as it is read, so one serves every cohort. When
# every walk is kept, `D` keeps the partials of a hazard whose map is
# costly to evaluate again (see `_keeps_fill`), formed with its value;
# otherwise it is `nothing`.
struct _WalkScratch{C, A <: AbstractArray, V <: AbstractVector, D}
    hazard::C
    S::A
    H::A
    P::V
    D::D
end
# A scratch that keeps its hazard's partials.
const _KeptPartials = _WalkScratch{<:Any, <:Any, <:Any, <:AbstractArray}
_walk_scratch(x, ::Type, dims, keep) = nothing
function _walk_scratch(x::Derived, ::Type{Tp}, dims, keep) where {Tp}
    return map(a -> _walk_scratch(a, Tp, dims, keep), x.args)
end
function _walk_scratch(x::Survival, ::Type{Tp}, dims, keep) where {Tp}
    return _WalkScratch(
        _walk_scratch(x.hazard, Tp, dims, keep), _alloc(Tp, dims...),
        _alloc(Tp, dims...), zeros(Tp, first(dims)),
        _hazard_partials(x.hazard, Tp, dims, keep)
    )
end
_hazard_partials(h, ::Type, dims, keep) = nothing
function _hazard_partials(
        h::Derived{F, A}, ::Type{Tp}, dims, ::Val{true}
    ) where {F, A, Tp}
    _keeps_fill_type(typeof(h)) || return nothing
    return Array{NTuple{fieldcount(A), Tp}}(undef, dims...)
end
# The scratch of a walk that keeps nothing, for a forward pass that reads
# each weight from the walk's state as it goes.
struct _NoRecord{C}
    hazard::C
end
_no_record(sc) = sc
_no_record(sc::Tuple) = map(_no_record, sc)
_no_record(sc::_WalkScratch) = _NoRecord(_no_record(sc.hazard))
@inline _record!(::_NoRecord, i, s, η) = nothing
@inline function _record!(sc::_WalkScratch, i, s, η)
    @inbounds sc.S[i] = s
    @inbounds sc.H[i] = η
    return nothing
end

# The scratch of column `j`.
_walk_column(sc, j) = sc
_walk_column(sc::Tuple, j) = map(s -> _walk_column(s, j), sc)
function _walk_column(sc::_WalkScratch{<:Any, <:AbstractMatrix}, j)
    return _WalkScratch(
        _walk_column(sc.hazard, j), view(sc.S, :, j), view(sc.H, :, j), sc.P,
        _partials_column(sc.D, j)
    )
end
_partials_column(::Nothing, j) = nothing
_partials_column(D::AbstractMatrix, j) = view(D, :, j)

# ---- forward ----------------------------------------------------------------

# The state of the walk: each `Survival`'s survival at the current lag and
# its hazard's state, a tuple per `Derived`, `nothing` elsewhere.
_walk_state(x, ::Type) = nothing
function _walk_state(x::Derived, ::Type{T}) where {T}
    return map(a -> _walk_state(a, T), x.args)
end
function _walk_state(x::Survival, ::Type{T}) where {T}
    return (one(T), _walk_state(x.hazard, T))
end

# Walk cohort `τ` from lag index 1 to `imax`, lags from `o`, for stratum
# `k`, calling `f(i, l, st)` with the state at each lag.
@inline function _walk_cohort!(
        f::F, x, sc, k, τ, o, imax, ::Type{T}
    ) where {F, T}
    st = _walk_state(x, T)
    for i in 1:imax
        l = i - 1 + o
        st = _walk(x, sc, st, k, i, τ, l)
        f(i, l, st)
    end
    return nothing
end
function _walk_cohort!(x, sc, k, τ, o, imax, T)
    return _walk_cohort!(_skip, x, sc, k, τ, o, imax, T)
end
_skip(i, l, st) = nothing

# Walk cohort `τ` for the strata `kw` that share its walk, calling
# `sink(k, i, w)` with each weight `w`. One stratum uses each weight as its
# lag is walked, on `sc1` (which may record nothing). Several read the
# recorded walk after it, since a loop over the strata inside the walk
# would hold up its chain of products.
@inline function _walk_weights!(
        sink::F, x, sc, sc1, kw, k0, τ, o, imax, ::Type{T}
    ) where {F, T}
    if length(kw) == 1
        k1 = first(kw)
        _walk_cohort!(x, sc1, k0, τ, o, imax, T) do i, l, st
            sink(k1, i, _walk_value(x, st, k1, i, τ, l))
            return nothing
        end
    else
        _walk_cohort!(x, sc, k0, τ, o, imax, T)
        for k in kw, i in 1:imax
            sink(k, i, @inbounds _value(x, sc, k, i, τ, i - 1 + o, 1))
        end
    end
    return nothing
end

# The state at lag index `i` (lag `l`) of cohort `τ`, stratum `k`, from the
# state at the lag before, inner `Survival`s first.
@inline _walk(x, sc, st, k, i, τ, l) = st
@inline function _walk(x::Derived, sc, st, k, i, τ, l)
    return _walk_args(x.args, sc, st, k, i, τ, l)
end
@inline _walk_args(::Tuple{}, ::Tuple{}, ::Tuple{}, k, i, τ, l) = ()
@inline function _walk_args(a::Tuple, sc::Tuple, st::Tuple, k, i, τ, l)
    head = _walk(first(a), first(sc), first(st), k, i, τ, l)
    rest = _walk_args(Base.tail(a), Base.tail(sc), Base.tail(st), k, i, τ, l)
    return (head, rest...)
end
@inline function _walk(x::Survival, sc, st, k, i, τ, l)
    inner = _walk(x.hazard, sc.hazard, st[2], k, i, τ, l)
    s = st[1]
    η = l < x.from ? zero(s) : _walk_hazard!(sc, x.hazard, inner, k, i, τ, l)
    s *= one(s) - η
    _record!(sc, i, s, η)
    return (s, inner)
end

# A `Survival`'s hazard at an entry, keeping its partials where `sc` holds
# them.
@inline _walk_hazard!(sc, h, st, k, i, τ, l) = _walk_value(h, st, k, i, τ, l)
@inline function _walk_hazard!(
        sc::_KeptPartials, h::Derived, st, k, i, τ, l
    )
    v, ∂ = _value_and_partials(h.f, _walk_values(h.args, st, k, i, τ, l))
    @inbounds sc.D[i] = ∂
    return v
end

# The value of `f` at `xs` and its partial derivatives there, from one
# local forward-mode evaluation for a map without closed forms.
_value_and_partials(f, xs::Tuple) = _forward_value_and_derivative(f, xs)
function _value_and_partials(f::Union{_Arithmetic, typeof(identity)}, xs::Tuple)
    return f(xs...), _partials(f, xs)
end

# The value of a coefficient at an entry, from the walk's state.
@inline function _walk_value(x, st, k, i, τ, l)
    return @inbounds _value(x, nothing, k, i, τ, l, 1)
end
@inline _walk_value(x::Survival, st, k, i, τ, l) = st[1]
@inline function _walk_value(x::Derived, st, k, i, τ, l)
    return x.f(_walk_values(x.args, st, k, i, τ, l)...)
end
@inline _walk_values(::Tuple{}, ::Tuple{}, k, i, τ, l) = ()
@inline function _walk_values(a::Tuple, st::Tuple, k, i, τ, l)
    v = _walk_value(first(a), first(st), k, i, τ, l)
    return (v, _walk_values(Base.tail(a), Base.tail(st), k, i, τ, l)...)
end

# A `Survival`'s value at lag index `i`, once its cohort is walked.
Base.@propagate_inbounds function _value(
        x::Survival, sc::_WalkScratch, k, i, τ, l, b
    )
    return sc.S[i]
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

# ---- reverse ----------------------------------------------------------------

# A `Survival` keeps the cotangent added to its value at a lag for its step
# back.
function _add_value!(::Nothing, x::Survival, sc::_WalkScratch, v, k, i, τ, l, b)
    return nothing
end
Base.@propagate_inbounds function _add_value!(
        x̄, x::Survival, sc::_WalkScratch, v, k, i, τ, l, b
    )
    sc.P[i] += v
    return nothing
end

# The cotangents carried back: each `Survival`'s, of its survival from the
# current lag on, and its hazard's, in the shape of the walk's state.
_walk_cotangent(x, ::Type) = nothing
function _walk_cotangent(x::Derived, ::Type{T}) where {T}
    return map(a -> _walk_cotangent(a, T), x.args)
end
function _walk_cotangent(x::Survival, ::Type{T}) where {T}
    return (zero(T), _walk_cotangent(x.hazard, T))
end

# Back along cohort `τ`'s lags from `imax`, once the cotangents of its
# weights are added.
function _walk_cohort_back!(x̄, x, sc, k, τ, o, imax, ::Type{T}) where {T}
    a = _walk_cotangent(x, T)
    for i in imax:-1:1
        a = _walk_back(x̄, x, sc, a, k, i, τ, i - 1 + o)
    end
    return nothing
end

# One lag index back: `a` holds the carried cotangents, and the result
# those at the lag before.
@inline _walk_back(x̄, x, sc, a, k, i, τ, l) = a
@inline function _walk_back(x̄, x::Derived, sc, a, k, i, τ, l)
    ā = _arg_mirrors(cotangent(x̄, :args), x.args)
    return _walk_back_args(ā, x.args, sc, a, k, i, τ, l)
end
@inline _walk_back_args(ā, ::Tuple{}, ::Tuple{}, ::Tuple{}, k, i, τ, l) = ()
@inline function _walk_back_args(ā, x::Tuple, sc::Tuple, a::Tuple, k, i, τ, l)
    head = _walk_back(
        _first_mirror(ā), first(x), first(sc), first(a), k, i, τ, l
    )
    rest = _walk_back_args(
        _tail_mirrors(ā), Base.tail(x), Base.tail(sc), Base.tail(a), k, i, τ, l
    )
    return (head, rest...)
end
# Add `v` to the cotangent of a `Survival`'s hazard at an entry, from its
# kept partials where `sc` holds them.
@inline function _add_hazard!(h̄, h, sc, v, k, i, τ, l)
    return _add_value!(h̄, h, sc.hazard, v, k, i, τ, l, 1)
end
@inline function _add_hazard!(
        h̄, h::Derived, sc::_KeptPartials, v, k, i, τ, l
    )
    ∂ = @inbounds sc.D[i]
    return _add_value_partials!(h̄, h, sc.hazard, v, ∂, k, i, τ, l, 1)
end
_first_mirror(::Nothing) = nothing
_first_mirror(ā::Tuple) = first(ā)
_tail_mirrors(::Nothing) = nothing
_tail_mirrors(ā::Tuple) = Base.tail(ā)
# A `Survival` carries `a`, the cotangent of its survival from the current
# lag on. At lag index `i` the cotangent its parent added joins it,
# `-s_{i-1} a` goes to its hazard at the same lag, and `a (1 - η_i)` goes on
# to the lag before. Its parent reads it once per lag, so `a` is whole once
# the parent's share is added.
@inline _walk_back(::Nothing, x::Survival, sc, a, k, i, τ, l) = a
@inline function _walk_back(x̄, x::Survival, sc, a, k, i, τ, l)
    h̄ = cotangent(x̄, :hazard)
    (; S, H, P) = sc
    @inbounds begin
        c = a[1] + P[i]
        T = typeof(c)
        P[i] = zero(T)
        if l >= x.from
            prev = i == 1 ? one(T) : S[i - 1]
            _add_hazard!(h̄, x.hazard, sc, -prev * c, k, i, τ, l)
        end
        c *= one(T) - H[i]
    end
    return (c, _walk_back(h̄, x.hazard, sc.hazard, a[2], k, i, τ, l))
end

# ---- the weights as an array, by the walk -----------------------------------

# The weights of cohorts `1:n`, lags from `o`, each one whose weight lands
# by `last`, into `K` (lags × cohorts, or strata × lags × cohorts), and the
# scratch of the walks. A kernel whose maps are only arithmetic walks each
# cohort again in the reverse pass, which costs less than keeping its walk;
# any other map is costly enough to recompute that `keep` keeps every
# cohort's walk, as a column of the scratch, and returns it.
function _walk_fill!(
        K, kernel::_ComputedKernel, o, last, keep::Val = Val(false)
    )
    x = kernel.x
    L = _coef_lags(x)
    T = eltype(K)
    ks = _weights_strata(K)
    gs = _walk_groups(x, ks)
    n = size(K, ndims(K))
    sc = _walk_keeps(x, keep) ? _walk_scratch(x, T, (L, length(gs) * n), keep) :
        _walk_scratch(x, T, (L, 1), keep)
    for (g, k0) in enumerate(gs), τ in 1:n
        imax = _imax(τ, L, o, last)
        scj = _walk_column(sc, _walk_index(sc, g, τ, n))
        sc1 = keep isa Val{true} ? scj : _no_record(scj)
        kw = _walk_strata(x, ks, k0)
        _walk_weights!(x, scj, sc1, kw, k0, τ, o, imax, T) do k, i, w
            @inbounds _set_weight!(K, w, k, i, τ)
            return nothing
        end
    end
    return K, sc
end
_walk_keeps(x, ::Val{keep}) where {keep} = keep && _keeps_fill(x)
# The column of group `g` and cohort `τ`, when every walk is kept.
_walk_index(sc, g, τ, n) = _walk_kept(sc) ? (g - 1) * n + τ : 1
_walk_kept(sc) = false
_walk_kept(sc::Tuple) = any(_walk_kept, sc)
_walk_kept(sc::_WalkScratch) = size(sc.S, 2) > 1 || _walk_kept(sc.hazard)

# Take the cotangent `K̄` of those weights back to the coefficients' mirror
# `x̄`, walking each cohort again unless `sc` kept its walk.
function _walk_weights_back!(x̄, kernel::_ComputedKernel, K̄, o, last, sc)
    x = kernel.x
    L = _coef_lags(x)
    T = eltype(K̄)
    ks = _weights_strata(K̄)
    n = size(K̄, ndims(K̄))
    kept = _walk_kept(sc)
    for (g, k0) in enumerate(_walk_groups(x, ks)), τ in 1:n
        imax = _imax(τ, L, o, last)
        scj = _walk_column(sc, _walk_index(sc, g, τ, n))
        kept || _walk_cohort!(x, scj, k0, τ, o, imax, T)
        for k in _walk_strata(x, ks, k0), i in 1:imax
            v = @inbounds _weight(K̄, k, i, τ)
            @inbounds _add_value!(x̄, x, scj, v, k, i, τ, i - 1 + o, 1)
        end
        _walk_cohort_back!(x̄, x, scj, k0, τ, o, imax, T)
    end
    return nothing
end
_weights_strata(K::AbstractMatrix) = Base.OneTo(1)
_weights_strata(K::AbstractArray{<:Any, 3}) = axes(K, 1)
Base.@propagate_inbounds _weight(K::AbstractMatrix, k, i, τ) = K[i, τ]
Base.@propagate_inbounds function _weight(K::AbstractArray{<:Any, 3}, k, i, τ)
    return K[k, i, τ]
end
Base.@propagate_inbounds function _set_weight!(K::AbstractMatrix, v, k, i, τ)
    K[i, τ] = v
    return nothing
end
Base.@propagate_inbounds function _set_weight!(
        K::AbstractArray{<:Any, 3}, v, k, i, τ
    )
    K[k, i, τ] = v
    return nothing
end
