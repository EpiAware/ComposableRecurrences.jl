# Each cohort walks its lags once, each `Survival` carrying its survival.

# == Scratch ==

# `P` is cleared as it is read, so one serves every cohort a walk takes in
# turn; on a device each block of walks has its own column. `D` keeps the
# partials of a costly hazard map when every walk is kept.
struct _WalkScratch{C, A <: AbstractArray, V <: AbstractArray, D}
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
        _walk_column(sc.hazard, j), view(sc.S, :, j), view(sc.H, :, j),
        _cotangent_column(sc.P, j), _partials_column(sc.D, j)
    )
end
_cotangent_column(P::AbstractVector, j) = P
_cotangent_column(P::AbstractMatrix, j) = view(P, :, j)
_partials_column(::Nothing, j) = nothing
_partials_column(D::AbstractMatrix, j) = view(D, :, j)

# == Forward ==

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
function _walk_cohort!(x, sc, k, τ, o, imax, ::Type{T}) where {T}
    return _walk_cohort!(_skip, x, sc, k, τ, o, imax, T)
end
_skip(i, l, st) = nothing

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
function _value_and_partials(
        f::Union{_Arithmetic, typeof(identity)}, xs::Tuple
    )
    return f(xs...), _partials(f, xs)
end

# The value of a coefficient at an entry, from the walk's state.
@inline function _walk_value(x, st, k, i, τ, l)
    return @inbounds _value(x, nothing, k, i, τ, l, 1)
end
@inline _walk_value(x::Survival, st, k, i, τ, l) = st[1]
@inline _walk_value(x::Increments, st, k, i, τ, l) = st[3]
@inline _walk_value(x::Normalised, st, k, i, τ, l) = st[1]
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
# A lag map keeps the values of one stratum's walk.
_walks_strata_type(::Type{<:Increments{X}}) where {X} = _stratified_type(X)
_walks_strata_type(::Type{<:Normalised{X}}) where {X} = _stratified_type(X)
function _walks_strata_type(::Type{<:Derived{F, A}}) where {F, A}
    return any(_walks_strata_type, fieldtypes(A))
end
@generated _walks_strata(x) = _walks_strata_type(x)

# The strata each walk serves: one walk for all of `ks` when no `Survival`
# has strata, else one walk per stratum.
_walk_groups(x, ks) = _walks_strata(x) ? ks : (first(ks):first(ks))
_walk_strata(x, ks, k0) = _walks_strata(x) ? (k0:k0) : ks

# == Lag maps ==

# A lag map's walk keeps the values `U` of the kernel inside for the cohort,
# the map's `W`, and `W̄` their cotangents; its kernel inside records only
# where the walk does, then with a costly hazard map's partials, as each
# cohort is walked back straight after it is walked.
struct _LagWalk{C, V <: AbstractVector}
    inner::C
    U::V
    W::V
    W̄::V
end
function _walk_scratch(x::_LagMap, ::Type{Tp}, dims, keep) where {Tp}
    L = first(dims)
    inner = _walk_scratch(x.x, Tp, (L,), Val(true))
    return _LagWalk(inner, zeros(Tp, L), zeros(Tp, L), zeros(Tp, L))
end
_no_record(sc::_LagWalk) = _LagWalk(_no_record(sc.inner), sc.U, sc.W, sc.W̄)
_walk_kept(sc::_LagWalk) = false

# Increments stream along the lags: the state holds the last value inside,
# the walk inside and the weight.
function _walk_state(x::Increments, ::Type{T}) where {T}
    return (zero(T), _walk_state(x.x, T), zero(T))
end
@inline function _walk(x::Increments, sc, st, k, i, τ, l)
    inner = _walk(x.x, sc.inner, st[2], k, i, τ, l)
    u = _walk_value(x.x, inner, k, i, τ, l)
    w = u - st[1]
    @inbounds sc.W[i] = w
    return (u, inner, w)
end
# A total needs every lag, so the first lag walks the kernel inside through
# all of them; the state holds the weight.
_walk_state(x::Normalised, ::Type{T}) where {T} = (zero(T),)
@inline function _walk(x::Normalised, sc, st, k, i, τ, l)
    i == 1 && _walk_total!(x, sc, k, τ, l, typeof(first(st)))
    return (@inbounds(sc.W[i]),)
end
function _walk_total!(x::Normalised, sc, k, τ, o, ::Type{T}) where {T}
    (; U, W) = sc
    L = length(U)
    ist = _walk_state(x.x, T)
    for j in 1:L
        lj = j - 1 + o
        ist = _walk(x.x, sc.inner, ist, k, j, τ, lj)
        @inbounds U[j] = _walk_value(x.x, ist, k, j, τ, lj)
    end
    _lag_map!(W, x, U, L)
    return nothing
end
Base.@propagate_inbounds function _value(
        x::_LagMap, sc::_LagWalk, k, i, τ, l, b
    )
    return sc.W[i]
end

# == Reverse ==

# A `Survival` keeps the cotangent added to its value at a lag for its step
# back.
function _add_value!(
        ::Nothing, x::Survival, sc::_WalkScratch, v, k, i, τ, l, b
    )
    return nothing
end
Base.@propagate_inbounds function _add_value!(
        x̄, x::Survival, sc::_WalkScratch, v, k, i, τ, l, b
    )
    sc.P[i] += v
    return nothing
end

# A lag map keeps the cotangents of its weights for its step back.
function _add_value!(
        ::Nothing, x::_LagMap, sc::_LagWalk, v, k, i, τ, l, b
    )
    return nothing
end
Base.@propagate_inbounds function _add_value!(
        x̄, x::_LagMap, sc::_LagWalk, v, k, i, τ, l, b
    )
    sc.W̄[i] += v
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
# Increments carry the cotangent of the next lag's weight; a total is taken
# back whole at the last lag walked, after which nothing is carried.
function _walk_cotangent(x::Increments, ::Type{T}) where {T}
    return (zero(T), _walk_cotangent(x.x, T))
end
_walk_cotangent(x::Normalised, ::Type) = (true,)

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
@inline function _walk_back_args(
        ā, x::Tuple, sc::Tuple, a::Tuple, k, i, τ, l
    )
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
# The weight `w_i = u_i - u_{i-1}` sends `w̄_i - w̄_{i+1}` to the value
# inside at lag `i`.
@inline _walk_back(::Nothing, x::Increments, sc, a, k, i, τ, l) = a
@inline _walk_back(::Nothing, x::Normalised, sc, a, k, i, τ, l) = a
@inline function _walk_back(x̄, x::Increments, sc, a, k, i, τ, l)
    x̄x = cotangent(x̄, :x)
    w̄ = @inbounds sc.W̄[i]
    @inbounds sc.W̄[i] = zero(w̄)
    _add_value!(x̄x, x.x, sc.inner, w̄ - a[1], k, i, τ, l, 1)
    return (w̄, _walk_back(x̄x, x.x, sc.inner, a[2], k, i, τ, l))
end
@inline function _walk_back(x̄, x::Normalised, sc, a, k, i, τ, l)
    first(a) && _walk_total_back!(x̄, x, sc, k, τ, l - i + 1)
    return (false,)
end
function _walk_total_back!(x̄, x::Normalised, sc, k, τ, o)
    x̄x = cotangent(x̄, :x)
    (; U, W̄) = sc
    L = length(U)
    T = eltype(U)
    _lag_map_back!(W̄, x, W̄, U, L)
    ia = _walk_cotangent(x.x, T)
    for j in L:-1:1
        lj = j - 1 + o
        v = @inbounds W̄[j]
        @inbounds W̄[j] = zero(T)
        _add_value!(x̄x, x.x, sc.inner, v, k, j, τ, lj, 1)
        ia = _walk_back(x̄x, x.x, sc.inner, ia, k, j, τ, lj)
    end
    return nothing
end

# `a` is the cotangent of the survival from the current lag on; its parent
# reads it once per lag, so it is whole once the parent's share is added.
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

# == The weights as an array ==

# Arithmetic maps are walked again in the reverse pass, which costs less than
# keeping the walk; costlier ones keep every cohort's walk when `keep`.
function _walk_fill!(
        K, kernel::_ComputedKernel, o, last, keep::Val = Val(false)
    )
    x = _densified(kernel, last).x
    L = _coef_lags(x)
    T = eltype(K)
    ks = _weights_strata(K)
    gs = _walk_groups(x, ks)
    n = size(K, ndims(K))
    cols = _walk_keeps(x, keep) ? length(gs) * n : 1
    sc = _walk_scratch(x, T, (L, cols), keep)
    for (g, k0) in enumerate(gs), τ in 1:n
        imax = _imax(τ, L, o, last)
        scj = _walk_column(sc, _walk_index(sc, g, τ, n))
        kw = _walk_strata(x, ks, k0)
        # One stratum writes each weight as its lag is walked; several read
        # the finished walk, keeping the strata loop out of the products.
        if length(kw) == 1
            k1 = first(kw)
            scw = keep isa Val{true} ? scj : _no_record(scj)
            _walk_cohort!(x, scw, k0, τ, o, imax, T) do i, l, st
                w1 = _walk_value(x, st, k1, i, τ, l)
                @inbounds _set_weight!(K, w1, k1, i, τ)
            end
        else
            _walk_cohort!(x, scj, k0, τ, o, imax, T)
            for k in kw, i in 1:imax
                w = @inbounds _value(x, scj, k, i, τ, i - 1 + o, 1)
                @inbounds _set_weight!(K, w, k, i, τ)
            end
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
    x̄d = _densified_mirror(x̄, kernel, last)
    _dense_walk_back!(x̄d, _densified(kernel, last).x, K̄, o, last, sc)
    _fold_dense!(x̄, kernel, x̄d)
    return nothing
end
function _dense_walk_back!(x̄, x, K̄, o, last, sc)
    _on_gpu(K̄) && return _device_weights_back!(x̄, x, K̄, o, last)
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

# == On a device ==

# One thread per cohort (and stratum), so the weights fill in one launch; a
# thread holds one walk, so a survival without strata is walked per stratum.
function _device_fill(x, like, ::Type{Tp}, ns, L, n, o, last) where {Tp}
    K = _stratified(x) ? similar(like, Tp, ns, L, n) : similar(like, Tp, L, n)
    fill!(K, zero(Tp))
    nk = _stratified(x) ? ns : 1
    ex = _resolve(Serial(), like)
    each!(_fill_cohort!, ex, nk * n, typemax(Int), K, x, o, last, nk)
    return K, nothing
end
function _fill_cohort!(j, K, x, o, last, nk)
    k, τ = _cohort_item(j, nk)
    T = eltype(K)
    imax = _imax(τ, size(K, ndims(K) - 1), o, last)
    sc = _no_walk(x)
    st = _walk_state(x, T)
    for i in 1:imax
        l = i - 1 + o
        st = _walk(x, sc, st, k, i, τ, l)
        @inbounds _set_weight!(K, _walk_value(x, st, k, i, τ, l), k, i, τ)
    end
    return nothing
end
# Item `j` is stratum `k` of cohort `τ`.
_cohort_item(j, nk) = ((j - 1) % nk + 1, (j - 1) ÷ nk + 1)
# The scratch of a walk that records nothing, built inside a kernel.
_no_walk(x) = nothing
_no_walk(x::Derived) = map(_no_walk, x.args)
_no_walk(x::Survival) = _NoRecord(_no_walk(x.hazard))

# With strata, blocks are blocks of strata and each writes a per-stratum
# coefficient's cotangent only at its own rows, so it is shared
# (`_param_slots`); other shared cotangents are copied per block and summed.
function _device_weights_back!(x̄, x, K̄, o, last)
    n = size(K̄, ndims(K̄))
    strata = ndims(K̄) == 3
    N = strata ? size(K̄, 1) : n
    slots = strata ? _param_slots(x̄, x) : x̄
    accs = _accumulators(Serial(), K̄, N, N, slots)
    st = accs[2]
    L = size(K̄, ndims(K̄) - 1)
    sc = _device_walk_scratch(x, eltype(K̄), L, st.m, K̄)
    block = _WalkBack(N, st.m)
    each!(block, st.ex, st.m, typemax(Int), st.copies, sc, x, K̄, o, last)
    _reduce!(accs)
    return nothing
end
_device_walk_scratch(x, ::Type, L, m, like) = nothing
function _device_walk_scratch(x::Derived, ::Type{T}, L, m, like) where {T}
    return map(a -> _device_walk_scratch(a, T, L, m, like), x.args)
end
function _device_walk_scratch(x::Survival, ::Type{T}, L, m, like) where {T}
    return _WalkScratch(
        _device_walk_scratch(x.hazard, T, L, m, like), similar(like, T, L, m),
        similar(like, T, L, m), fill!(similar(like, T, L, m), zero(T)), nothing
    )
end
struct _WalkBack
    n::Int
    m::Int
end
function (w::_WalkBack)(b, copies, sc, x, K̄, o, last)
    x̄ = _unown(_block(copies, b))
    scb = _walk_column(sc, b)
    js = _chunk(b, w.n, w.m)
    if ndims(K̄) == 3
        for k in js, τ in axes(K̄, 3)
            _walk_back_one!(x̄, x, scb, K̄, k, τ, o, last)
        end
    else
        for τ in js
            _walk_back_one!(x̄, x, scb, K̄, 1, τ, o, last)
        end
    end
    return nothing
end
# Cohort `τ` of stratum `k`: walked again, its weights' cotangents added,
# and walked back.
function _walk_back_one!(x̄, x, sc, K̄, k, τ, o, last)
    T = eltype(K̄)
    imax = _imax(τ, size(K̄, ndims(K̄) - 1), o, last)
    _walk_cohort!(x, sc, k, τ, o, imax, T)
    for i in 1:imax
        v = @inbounds _weight(K̄, k, i, τ)
        @inbounds _add_value!(x̄, x, sc, v, k, i, τ, i - 1 + o, 1)
    end
    _walk_cohort_back!(x̄, x, sc, k, τ, o, imax, T)
    return nothing
end
