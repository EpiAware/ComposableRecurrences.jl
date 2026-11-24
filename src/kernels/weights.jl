# Kernels computed from coefficients: a `Derived` maps coefficients entry by
# entry and a `Survival` takes each cohort's survival through the lags
# against a hazard.

# == Survival ==

@doc raw"""
The survival of each cohort through each lag of a kernel against a hazard.

Inside a kernel `TimeVarying(s, Primary())`, the weight on lag ``l`` of
cohort ``\tau`` in stratum ``k`` is

```math
s_{k,l}(\tau) = \prod_{j = \max(f, l_0)}^{l} \big(1 - \eta_{k,j}(\tau)\big),
```

where ``\eta_{k,j}(\tau)`` is the hazard at lag ``j``, any argument of a
[`Derived`](@ref) kernel read as there, ``f`` = `from` (0 by default) is the
first lag the hazard acts at and ``l_0`` is the kernel's first lag (0 in
a [`Convolution`](@ref), 1 in a [`Recurrence`](@ref)).
Lags before `from` have survival one.
A hazard that changes with calendar time is `TimeVarying(h)`, read at the
time ``\tau + j`` each lag lands; one that changes with the lag is a vector
of lag weights.

This is the [`Recurrence`](@ref) `Recurrence([1])` with gain ``1 - \eta``
and a history of one, run over each cohort's lags, computed as part of the
kernel: one pass per cohort forward, and one back.

# Arguments
- `hazard`: the hazard, any argument of a `Derived` kernel.

# Keyword Arguments
- `from`: the first lag the hazard acts at, `0` by default.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
# Cohorts confirmed from the step after entry at a hazard `h` per step, and
# still present with probability `S[l + 1]` at lag `l`.
h = [0.1, 0.2, 0.3, 0.4]
S = [1.0, 0.8, 0.5]
confirmed = S * (1 - CR.Survival(TimeVarying(h); from = 1))
CR.kernel_weights(TimeVarying(confirmed, CR.Primary()), 2)

# output

3×2 Matrix{Float64}:
 0.0   0.0
 0.16  0.24
 0.22  0.29
```
"""
struct Survival{H}
    "The hazard."
    hazard::H
    "The first lag the hazard acts at."
    from::Int
    function Survival(::_Checked, hazard::H, from::Integer) where {H}
        _check_coefficient(hazard)
        from >= 0 || throw(
            ArgumentError(
                "from is the first lag the hazard acts at, at least 0; " *
                    "got $from"
            )
        )
        return new{H}(hazard, Int(from))
    end
end
Survival(hazard; from::Integer = 0) = Survival(_Checked(), hazard, from)

# Rebuilt from its fields, as `constructorof` gives it.
_survival_flat(hazard, from) = Survival(_Checked(), hazard, from)
ConstructionBase.constructorof(::Type{<:Survival}) = _survival_flat

# == Coefficients ==

# A kernel computed from coefficients, and the kernel it is part of.
const _Computed = Union{Derived, Survival}
const _ComputedKernel = TimeVarying{Primary, <:_Computed}
_over_time(::_Computed) = true

# The coefficients a computed kernel reads: numbers, lag weights, values per
# stratum or per time, and other computed weights.
const _TimeAxis = Union{
    AbstractVector{<:Real}, PerStratum{<:AbstractMatrix{<:Real}},
}
const _ArrayCoefficient = Union{
    AbstractVector{<:Real}, PerStratum{<:AbstractVecOrMat{<:Real}},
    TimeVarying{<:Any, <:Union{_TimeAxis, _Piecewise{<:_TimeAxis}}},
}
const _Coefficient = Union{Real, _ArrayCoefficient, _Computed}
function _check_coefficient(x::_ArrayCoefficient)
    _require_one_based(_array(x))
    return nothing
end
_check_coefficient(x::_Computed) = nothing
_check_coefficient(x::Real) = nothing
const _COEFFICIENTS = "a number, a vector of lag weights, a PerStratum " *
    "vector or matrix, a TimeVarying vector or PerStratum matrix (with or " *
    "without Primary(), or given by change points), a Derived or a Survival"
@noinline function _check_coefficient(x)
    throw(
        ArgumentError(
            "a computed kernel reads $_COEFFICIENTS; got $(_describe(x))"
        )
    )
end

# Which use it is checked where the `Derived` is used.
struct _DerivedArg end
@noinline function _param_error(::_DerivedArg, x)
    throw(
        ArgumentError(
            "a Derived argument is a kernel coefficient ($_COEFFICIENTS) " *
                "or a modifier parameter (one value, PerStratum, " *
                "TimeVarying, TimeVarying(PerStratum), Derived or Recent); " *
                "got $(_describe(x))"
        )
    )
end
_check_param(n::_DerivedArg, x::TimeVarying{Primary}) = _param_error(n, x)
_check_argument(x::_Coefficient) = _check_coefficient(x)
_check_argument(x) = (_check_param(_DerivedArg(), x); nothing)

# Every argument of a computed kernel is a coefficient it reads.
_check_kernel_args(x) = _check_coefficient(x)
_check_kernel_args(x::Derived) = (map(_check_kernel_args, x.args); nothing)
_check_kernel_args(x::Survival) = _check_kernel_args(x.hazard)

# The time a coefficient is read at for lag `l` of cohort `τ`: the cohort's
# own time, or the time the weight lands.
_time(::TimeVarying{Primary}, τ, l) = τ
_time(::TimeVarying{Secondary}, τ, l) = τ + l

# The number of lags and strata a coefficient sets, `0` for none.
_coef_lags(x) = 0
_coef_lags(x::AbstractVector) = length(x)
_coef_lags(x::PerStratum{<:AbstractMatrix}) = size(x.x, 2)
_coef_lags(x::Derived) = _joined(_coef_lags, x.args, "lags")
_coef_lags(x::Survival) = _coef_lags(x.hazard)
_coef_strata(x) = 0
_coef_strata(x::PerStratum) = size(x.x, 1)
_coef_strata(x::TimeVarying{<:Any, <:PerStratum}) = size(x.x.x, 1)
_coef_strata(x::_TVPiecewise) = _coef_strata(_values(x))
_coef_strata(x::Derived) = _joined(_coef_strata, x.args, "strata")
_coef_strata(x::Survival) = _coef_strata(x.hazard)
# One tuple entry at a time, so arguments of mixed types infer.
_joined(f::F, ::Tuple{}, what) where {F} = 0
function _joined(f::F, args::Tuple, what) where {F}
    n, m = f(first(args)), _joined(f, Base.tail(args), what)
    n == 0 || m == 0 || n == m || throw(
        DimensionMismatch("the arguments of a Derived have $n and $m $what")
    )
    return max(n, m)
end

# Whether a coefficient of type `T` has a strata axis (`_coef_strata` is
# then its count), from the type alone, so the kernel's shape infers.
_stratified_type(::Type) = false
_stratified_type(::Type{<:PerStratum}) = true
_stratified_type(::Type{<:TimeVarying{<:Any, <:PerStratum}}) = true
function _stratified_type(
        ::Type{<:TimeVarying{<:Any, <:_Piecewise{<:PerStratum}}}
    )
    return true
end
_stratified_type(::Type{<:Survival{H}}) where {H} = _stratified_type(H)
function _stratified_type(::Type{<:Derived{F, A}}) where {F, A}
    return any(_stratified_type, fieldtypes(A))
end
# After its helpers: a generator sees only the methods defined before it.
@generated _stratified(x) = _stratified_type(x)

function _check_kernel_shape(k::_ComputedKernel)
    _check_kernel_args(k.x)
    _coef_lags(k.x) > 0 || throw(
        ArgumentError(
            "a computed kernel takes its lags from an argument with a lag " *
                "axis, such as a vector of lag weights; got none"
        )
    )
    _coef_strata(k.x)
    return nothing
end
function _check_kernel_shape(k::TimeVarying{Secondary, <:_Computed})
    throw(
        ArgumentError(
            "a computed kernel is indexed by cohort: TimeVarying(w, Primary())"
        )
    )
end
_nlags(k::_ComputedKernel) = _coef_lags(k.x)
function _check_kernel_strata(x::_Computed, S)
    n = _coef_strata(x)
    n == 0 || n == S || throw(
        DimensionMismatch("the kernel has $n strata but the input has $S")
    )
    return nothing
end
function _check_kernel_times(k::_ComputedKernel, stop)
    return _check_coef_times(k.x, stop, stop)
end

# Each time-varying coefficient covers the cohorts up to `n` and the times
# up to `last` that the weights read.
_check_coef_times(x, n, last) = nothing
function _check_coef_times(x::TimeVarying{Primary}, n, last)
    return _check_covers(:kernel, _extent(_array(x)), n)
end
function _check_coef_times(x::TimeVarying{Secondary}, n, last)
    return _check_covers(:kernel, _extent(_array(x)), last)
end
# Change points hold their last value, so they cover every time.
_check_coef_times(x::_TVPiecewise{Primary}, n, last) = nothing
_check_coef_times(x::_TVPiecewise{Secondary}, n, last) = nothing
function _check_coef_times(x::Derived, n, last)
    map(a -> _check_coef_times(a, n, last), x.args)
    return nothing
end
_check_coef_times(x::Survival, n, last) = _check_coef_times(x.hazard, n, last)

# A computed kernel is differentiated by its own reverse pass unless a map
# holds floats of its own.
_kernel_adjoint(k::_ComputedKernel) = _derived_local(k)
function _no_adjoint_kernel(k::_ComputedKernel)
    _derived_local(k) && return ()
    return ("the kernel has a Derived map that holds floats",)
end

# The first array a coefficient reads, or `nothing`: on a device, the
# weights and the walks' scratch are allocated like it.
_coef_array(x) = nothing
_coef_array(x::AbstractArray) = x
_coef_array(x::Union{PerStratum, TimeVarying}) = _coef_array(x.x)
_coef_array(x::_Piecewise) = _coef_array(x.x)
_coef_array(x::Survival) = _coef_array(x.hazard)
_coef_array(x::Derived) = _first_array(map(_coef_array, x.args))
_first_array(::Tuple{}) = nothing
_first_array(a::Tuple{Nothing, Vararg}) = _first_array(Base.tail(a))
_first_array(a::Tuple) = first(a)

# == Change points, made dense for a call ==

# A call's fill reads coefficients given by change points as the dense
# coefficient over the times `1:last` it reads, so the walks run as they do
# on arrays; the reverse pass folds the dense cotangent back onto the
# segments. A coefficient without change points is passed through.
_pieces_type(::Type) = false
_pieces_type(::Type{<:_TVPiecewise}) = true
_pieces_type(::Type{<:Survival{H}}) where {H} = _pieces_type(H)
function _pieces_type(::Type{<:Derived{F, A}}) where {F, A}
    return any(_pieces_type, fieldtypes(A))
end
@generated _has_pieces(x) = _pieces_type(x)

# The dense coefficient is built again in the reverse pass rather than kept:
# it is one array over the times read, small beside the weights.
function _densified(k::_ComputedKernel, last)
    return _has_pieces(k.x) ? TimeVarying{Primary}(_dense_coef(k.x, last)) : k
end
_dense_coef(x, last) = x
# Typed on their parts, so each rebuild infers its arguments.
function _dense_coef(x::Survival{H}, last::Integer) where {H}
    return Survival(_dense_coef(x.hazard::H, last); from = x.from)
end
function _dense_coef(x::Derived{F, A}, last::Integer) where {F, A}
    return Derived(x.f, map(a -> _dense_coef(a, last), x.args::A))
end
function _dense_coef(x::_TVPiecewise{I}, last) where {I}
    V = _array(x.x)
    D = similar(V, size(V)[1:(end - 1)]..., max(last, 1))
    _each_segment((t, j) -> _copy_time!(D, t, V, j), x.x, size(D, ndims(D)))
    return TimeVarying{I}(x.x.x isa PerStratum ? PerStratum(D) : D)
end
_copy_time!(D::AbstractVector, t, V, j) = (D[t] = V[j]; nothing)
function _copy_time!(D::AbstractMatrix, t, V, j)
    for k in axes(D, 1)
        D[k, t] = V[k, j]
    end
    return nothing
end
# `f(t, j)` for each time `t` in `1:n` and its segment `j`.
function _each_segment(f::F, p::_Piecewise, n) where {F}
    j = 1
    for t in 1:n
        while j < length(p.starts) && p.starts[j + 1] <= t
            j += 1
        end
        f(t, j)
    end
    return nothing
end

# The mirror of the dense coefficients, from the mirror `x̄` of the kernel's
# coefficients: a zero array for each made dense, and the coefficient's own
# mirror elsewhere.
function _densified_mirror(x̄, k::_ComputedKernel, last)
    return _has_pieces(k.x) ? _dense_mirror_of(x̄, k.x, last) : x̄
end
_dense_mirror_of(x̄, x, last) = x̄
function _dense_mirror_of(x̄, x::Survival, last)
    x̄ === nothing && return nothing
    h̄ = _dense_mirror_of(cotangent(x̄, :hazard), x.hazard, last)
    return (; hazard = h̄)
end
function _dense_mirror_of(x̄, x::Derived, last)
    x̄ === nothing && return nothing
    ā = cotangent(x̄, :args)
    ā === nothing && return x̄
    d̄ = map((b, a) -> _dense_mirror_of(b, a, last), Tuple(ā), x.args)
    return (; args = d̄)
end
function _dense_mirror_of(x̄, x::_TVPiecewise, last)
    _values_cotangent(x̄) === nothing && return nothing
    V = _array(x.x)
    D = fill!(similar(V, size(V)[1:(end - 1)]..., max(last, 1)), zero(eltype(V)))
    return x.x.x isa PerStratum ? (; x = (; x = D)) : (; x = D)
end

# Each dense cotangent summed onto the value of its time's segment.
function _fold_dense!(x̄, k::_ComputedKernel, x̄d)
    _has_pieces(k.x) && _fold!(x̄, k.x, x̄d)
    return nothing
end
_fold!(x̄, x, x̄d) = nothing
function _fold!(x̄, x::Survival, x̄d)
    x̄ === nothing && return nothing
    return _fold!(cotangent(x̄, :hazard), x.hazard, cotangent(x̄d, :hazard))
end
function _fold!(x̄, x::Derived, x̄d)
    x̄ === nothing && return nothing
    ā, d̄ = cotangent(x̄, :args), cotangent(x̄d, :args)
    (ā === nothing || d̄ === nothing) && return nothing
    foreach(_fold!, Tuple(ā), x.args, d̄)
    return nothing
end
function _fold!(x̄, x::_TVPiecewise, x̄d)
    x̄ === nothing && return nothing
    V̄ = _values_cotangent(x̄)
    V̄ === nothing || _fold_values!(V̄, x̄d.x, x.x)
    return nothing
end
function _fold_values!(V̄, D̄::AbstractVector, p)
    _each_segment((t, j) -> add_cotangent!(V̄, D̄[t], j), p, length(D̄))
    return nothing
end
function _fold_values!(V̄, D̄::NamedTuple, p)
    M, W = D̄.x, cotangent(V̄, :x)
    _each_segment(p, size(M, 2)) do t, j
        for k in axes(M, 1)
            add_cotangent!(W, M[k, t], k, j)
        end
    end
    return nothing
end

# == The weights, a block of cohorts at a time ==

# Cohort innermost, so a block's survival products run side by side. The
# reverse pass recomputes a block before taking its cotangent back, so no
# weight is stored past its block (`_fill_kernel` says when one keeps all).
const _BLOCK = 32

# `P` is whether the hazard has a strata axis; without one, row 1 serves all.
struct _SurvivalScratch{
        P, C, A <: AbstractArray{<:Any, 3}, V <: AbstractVector,
    }
    hazard::C
    S::A
    H::A
    S̄::A
    acc::V
    function _SurvivalScratch{P}(
            hazard::C, S::A, H::A, S̄::A, acc::V
        ) where {P, C, A, V}
        return new{P, C, A, V}(hazard, S, H, S̄, acc)
    end
end
# A scratch buffer of element type `T`, its entries written before they are
# read; an extension may give another array type for its own element types.
function _alloc(::Type{T}, dims::Vararg{Int, N}) where {T, N}
    return Array{T}(undef, dims...)
end
_scratch(x, ::Type, L, B = _BLOCK) = nothing
function _scratch(x::Derived, ::Type{Tp}, L, B = _BLOCK) where {Tp}
    return map(a -> _scratch(a, Tp, L, B), x.args)
end
function _scratch(x::Survival, ::Type{Tp}, L, B = _BLOCK) where {Tp}
    ns = max(_coef_strata(x.hazard), 1)
    return _SurvivalScratch{_stratified(x.hazard)}(
        _scratch(x.hazard, Tp, L, B), _alloc(Tp, B, L, ns),
        _alloc(Tp, B, L, ns), zeros(Tp, 0, 0, 0), zeros(Tp, B)
    )
end
# The forward fill keeps no cotangents; the reverse pass takes the scratch
# again with `S̄` allocated, sharing its values and hazards.
_back_scratch(sc) = nothing
_back_scratch(sc::Tuple) = map(_back_scratch, sc)
function _back_scratch(sc::_SurvivalScratch{P}) where {P}
    S̄ = zeros(eltype(sc.S), size(sc.S))
    return _SurvivalScratch{P}(_back_scratch(sc.hazard), sc.S, sc.H, S̄, sc.acc)
end
_row(sc::_SurvivalScratch{false}, k) = 1
_row(sc::_SurvivalScratch{true}, k) = k

# The last lag index of cohort `τ` whose weight lands by `last`, for lags
# from `o`.
_imax(τ, L, o, last) = clamp(last - τ - o + 1, 0, L)

# Of the `nb` cohorts from `τ0`, those whose weight on lag index `i` (lags
# from `o`) lands by `last` are the first `_bmax`: cohort `τ0 + b - 1`'s lag
# `i - 1 + o` lands at `τ0 + b + i + o - 2`.
_bmax(τ0, nb, i, o, last) = clamp(last - o - i - τ0 + 2, 0, nb)

# Fill the scratch of every `Survival` in `x` for the block, inner ones
# first.
_block!(x, sc, τ0, nb, o, last) = nothing
function _block!(x::Derived, sc, τ0, nb, o, last)
    _block_args!(x.args, sc, τ0, nb, o, last)
    return nothing
end
_block_args!(::Tuple{}, ::Tuple{}, τ0, nb, o, last) = nothing
function _block_args!(args::Tuple, sc::Tuple, τ0, nb, o, last)
    _block!(first(args), first(sc), τ0, nb, o, last)
    return _block_args!(Base.tail(args), Base.tail(sc), τ0, nb, o, last)
end
function _block!(x::Survival, sc, τ0, nb, o, last)
    _block!(x.hazard, sc.hazard, τ0, nb, o, last)
    (; S, H) = sc
    T = eltype(S)
    for k in axes(S, 3)
        for i in axes(S, 2)
            l = i - 1 + o
            bm = _bmax(τ0, nb, i, o, last)
            bm == 0 && break
            if l < x.from
                @inbounds for b in 1:bm
                    S[b, i, k] = one(T)
                end
            elseif i == 1
                @inbounds for b in 1:bm
                    η = _value(x.hazard, sc.hazard, k, i, τ0 + b - 1, l, b)
                    H[b, i, k] = η
                    S[b, i, k] = one(T) - η
                end
            else
                @inbounds for b in 1:bm
                    η = _value(x.hazard, sc.hazard, k, i, τ0 + b - 1, l, b)
                    H[b, i, k] = η
                    S[b, i, k] = S[b, i - 1, k] * (one(T) - η)
                end
            end
        end
    end
    return nothing
end

# The call's checks fix every shape, so reads skip bounds checks.
Base.@propagate_inbounds _value(x::Real, sc, k, i, τ, l, b) = x
Base.@propagate_inbounds _value(x::AbstractVector, sc, k, i, τ, l, b) = x[i]
Base.@propagate_inbounds function _value(
        x::PerStratum{<:AbstractVector}, sc, k, i, τ, l, b
    )
    return x.x[k]
end
Base.@propagate_inbounds function _value(
        x::PerStratum{<:AbstractMatrix}, sc, k, i, τ, l, b
    )
    return x.x[k, i]
end
Base.@propagate_inbounds function _value(
        x::TimeVarying{<:Any, <:AbstractVector}, sc, k, i, τ, l, b
    )
    return x.x[_time(x, τ, l)]
end
Base.@propagate_inbounds function _value(
        x::TimeVarying{<:Any, <:PerStratum{<:AbstractMatrix}}, sc, k, i, τ, l,
        b
    )
    return x.x.x[k, _time(x, τ, l)]
end
@inline function _value(x::Derived, sc, k, i, τ, l, b)
    return x.f(@inbounds(_values_at(x.args, sc, k, i, τ, l, b))...)
end
Base.@propagate_inbounds function _value(x::Survival, sc, k, i, τ, l, b)
    return sc.S[b, i, _row(sc, k)]
end

# The arguments' values, one tuple entry at a time, so a tuple of mixed
# types infers.
_values_at(::Tuple{}, ::Tuple{}, k, i, τ, l, b) = ()
@inline Base.@propagate_inbounds function _values_at(
        a::Tuple, sc::Tuple, k, i, τ, l, b
    )
    v = _value(first(a), first(sc), k, i, τ, l, b)
    return (v, _values_at(Base.tail(a), Base.tail(sc), k, i, τ, l, b)...)
end

# Add `v` to the cotangent of a coefficient's value at an entry, through
# its mirror `x̄`; a `Survival` adds it to its scratch.
Base.@propagate_inbounds function _add_value!(
        x̄, x::Real, sc, v, k, i, τ, l, b
    )
    return add_cotangent!(x̄, v)
end
Base.@propagate_inbounds function _add_value!(
        x̄, x::AbstractVector, sc, v, k, i, τ, l, b
    )
    return add_cotangent!(x̄, v, i)
end
Base.@propagate_inbounds function _add_value!(
        x̄, x::PerStratum{<:AbstractVector}, sc, v, k, i, τ, l, b
    )
    return add_cotangent!(cotangent(x̄, :x), v, k)
end
Base.@propagate_inbounds function _add_value!(
        x̄, x::PerStratum{<:AbstractMatrix}, sc, v, k, i, τ, l, b
    )
    return add_cotangent!(cotangent(x̄, :x), v, k, i)
end
Base.@propagate_inbounds function _add_value!(
        x̄, x::TimeVarying{<:Any, <:AbstractVector}, sc, v, k, i, τ, l, b
    )
    return add_cotangent!(cotangent(x̄, :x), v, _time(x, τ, l))
end
Base.@propagate_inbounds function _add_value!(
        x̄, x::TimeVarying{<:Any, <:PerStratum{<:AbstractMatrix}}, sc, v, k,
        i, τ, l, b
    )
    x̄x = cotangent(cotangent(x̄, :x), :x)
    return add_cotangent!(x̄x, v, k, _time(x, τ, l))
end
_add_value!(::Nothing, x::Derived, sc, v, k, i, τ, l, b) = nothing
_add_value!(::Nothing, x::Survival, sc, v, k, i, τ, l, b) = nothing
@inline Base.@propagate_inbounds function _add_value!(
        x̄, x::Survival, sc, v, k, i, τ, l, b
    )
    sc.S̄[b, i, _row(sc, k)] += v
    return nothing
end
# Unrolled over the arguments, so each reads its own mirror and scratch
# with a constant index.
@inline Base.@propagate_inbounds function _add_value!(
        x̄, x::Derived, sc, v, k, i, τ, l, b
    )
    _arg_mirrors(cotangent(x̄, :args), x.args) === nothing && return nothing
    ∂ = _partials(x.f, @inbounds _values_at(x.args, sc, k, i, τ, l, b))
    return _add_value_partials!(x̄, x, sc, v, ∂, k, i, τ, l, b)
end
# The same with the partials `∂` of the map at the entry given.
@generated function _add_value_partials!(
        x̄, x::Derived{F, A}, sc, v, ∂, k, i, τ, l, b
    ) where {F, A}
    calls = (
        :(
            @inbounds _add_value!(
                ā[$j], x.args[$j], sc[$j], v * ∂[$j], k, i, τ, l, b
            )
        ) for j in 1:fieldcount(A)
    )
    return quote
        $(Expr(:meta, :inline))
        ā = _arg_mirrors(cotangent(x̄, :args), x.args)
        ā === nothing && return nothing
        $(calls...)
        return nothing
    end
end

# The partial derivatives of `f` at `xs`: closed forms for the arithmetic,
# and a local forward-mode derivative otherwise.
_partials(f, xs::Tuple) = _forward_derivative(f, xs)
_partials(::typeof(identity), (a,)::Tuple{Real}) = (one(a),)
_partials(::typeof(+), (a, b)::Tuple{Real, Real}) = (one(a), one(b))
_partials(::typeof(-), (a, b)::Tuple{Real, Real}) = (one(a), -one(b))
_partials(::typeof(-), (a,)::Tuple{Real}) = (-one(a),)
_partials(::typeof(*), (a, b)::Tuple{Real, Real}) = (b, a)
_partials(::typeof(/), (a, b)::Tuple{Real, Real}) = (inv(b), -a / b^2)

# `η̄_i = -s_{i-1} a_i`, with `a` the survival's cotangent carried back along
# the lags. Cotangents are cleared for the next block.
_block_back!(x̄, x, sc, τ0, nb, o, last) = nothing
function _block_back!(x̄, x::Derived, sc, τ0, nb, o, last)
    ā = _arg_mirrors(cotangent(x̄, :args), x.args)
    ā === nothing && return nothing
    _block_back_args!(ā, x.args, sc, τ0, nb, o, last)
    return nothing
end
_block_back_args!(::Tuple{}, ::Tuple{}, ::Tuple{}, τ0, nb, o, last) = nothing
function _block_back_args!(ā::Tuple, args::Tuple, sc::Tuple, τ0, nb, o, last)
    _block_back!(first(ā), first(args), first(sc), τ0, nb, o, last)
    rest = (Base.tail(ā), Base.tail(args), Base.tail(sc))
    return _block_back_args!(rest..., τ0, nb, o, last)
end
_block_back!(::Nothing, x::Survival, sc, τ0, nb, o, last) = nothing
function _block_back!(x̄, x::Survival, sc, τ0, nb, o, last)
    h̄ = cotangent(x̄, :hazard)
    (; S, H, S̄, acc) = sc
    T = eltype(S)
    for k in axes(S, 3)
        fill!(acc, zero(T))
        for i in reverse(axes(S, 2))
            l = i - 1 + o
            bm = _bmax(τ0, nb, i, o, last)
            bm == 0 && continue
            @inbounds for b in 1:bm
                acc[b] += S̄[b, i, k]
                S̄[b, i, k] = zero(T)
            end
            l >= x.from || continue
            @inbounds for b in 1:bm
                prev = i == 1 ? one(T) : S[b, i - 1, k]
                v = -prev * acc[b]
                _add_value!(h̄, x.hazard, sc.hazard, v, k, i, τ0 + b - 1, l, b)
                acc[b] *= one(T) - H[b, i, k]
            end
        end
    end
    _block_back!(h̄, x.hazard, sc.hazard, τ0, nb, o, last)
    return nothing
end

# The block's weights into `W` (cohorts × lags × strata), and their
# cotangents `W̄` back to the mirror `x̄`.
function _fill_block!(W, x, sc, τ0, nb, o, last)
    _block!(x, sc, τ0, nb, o, last)
    for k in _strata_axis(W)
        for i in _lag_axis(W)
            bm = _bmax(τ0, nb, i, o, last)
            bm == 0 && break
            @inbounds for b in 1:bm
                W[b, i, k] = _value(x, sc, k, i, τ0 + b - 1, i - 1 + o, b)
            end
        end
    end
    return W
end
function _back_block!(x̄, x, sc, W̄, τ0, nb, o, last)
    # Each cohort's lags in turn, so no two adds in a row hit one lag's
    # cotangent.
    for k in _strata_axis(W̄), b in 1:nb
        @inbounds for i in 1:_imax(τ0 + b - 1, length(_lag_axis(W̄)), o, last)
            v = W̄[b, i, k]
            iszero(v) ||
                _add_value!(x̄, x, sc, v, k, i, τ0 + b - 1, i - 1 + o, b)
        end
    end
    _block_back!(x̄, x, sc, τ0, nb, o, last)
    return nothing
end

# Arithmetic maps fill in blocks the reverse pass recomputes; costlier maps
# fill one block of every cohort, kept for it.
function _fill_kernel(
        kernel::_ComputedKernel, o, n, last, keep::Val = Val(true)
    )
    x = _densified(kernel, last).x
    n = max(n, 0)
    _check_coef_times(x, n, last)
    Tp = float(param_eltype(x))
    L = _coef_lags(x)
    ns = max(_coef_strata(x), 1)
    like = _coef_array(x)
    _on_gpu(like) && return _device_fill(x, like, Tp, ns, L, n, o, last)
    B = _block_size(x, n, keep)
    sc = _scratch(x, Tp, L, B)
    K = _weights_array(Val(_stratified(x)), Tp, ns, L, n)
    for τ0 in 1:B:n
        nb = min(B, n - τ0 + 1)
        _fill_block!(_KernelBlock(K, τ0), x, sc, τ0, nb, o, last)
    end
    return K, sc
end
# `keep` is the run's cache flag: `true` or `:traced` keep a reverse cache.
function _block_size(x, n, ::Val{keep}) where {keep}
    keeps = keep === true || keep === :traced
    return keeps && _keeps_fill(x) ? max(n, 1) : _BLOCK
end
function _weights_array(::Val{false}, ::Type{Tp}, ns, L, n) where {Tp}
    return zeros(Tp, L, n)
end
function _weights_array(::Val{true}, ::Type{Tp}, ns, L, n) where {Tp}
    return zeros(Tp, ns, L, n)
end

# Entry `[b, i, k]` is stratum `k`'s weight on lag `i` of cohort `τ0 + b - 1`,
# so a block is filled, or its cotangent read, in place.
struct _KernelBlock{A <: AbstractArray}
    K::A
    τ0::Int
end
# The lag and strata axes of a block of weights.
_lag_axis(W::AbstractArray{<:Any, 3}) = axes(W, 2)
_strata_axis(W::AbstractArray{<:Any, 3}) = axes(W, 3)
_lag_axis(W::_KernelBlock{<:AbstractMatrix}) = axes(W.K, 1)
_strata_axis(W::_KernelBlock{<:AbstractMatrix}) = Base.OneTo(1)
_lag_axis(W::_KernelBlock{<:AbstractArray{<:Any, 3}}) = axes(W.K, 2)
_strata_axis(W::_KernelBlock{<:AbstractArray{<:Any, 3}}) = axes(W.K, 1)
Base.@propagate_inbounds function Base.getindex(
        W::_KernelBlock{<:AbstractMatrix}, b, i, k
    )
    return W.K[i, W.τ0 + b - 1]
end
Base.@propagate_inbounds function Base.getindex(
        W::_KernelBlock{<:AbstractArray{<:Any, 3}}, b, i, k
    )
    return W.K[k, i, W.τ0 + b - 1]
end
Base.@propagate_inbounds function Base.setindex!(
        W::_KernelBlock{<:AbstractMatrix}, v, b, i, k
    )
    return W.K[i, W.τ0 + b - 1] = v
end
Base.@propagate_inbounds function Base.setindex!(
        W::_KernelBlock{<:AbstractArray{<:Any, 3}}, v, b, i, k
    )
    return W.K[k, i, W.τ0 + b - 1] = v
end

# Whether a coefficient of type `T` has a map other than `+`, `-`, `*` and
# `/`, from the type.
const _Arithmetic = Union{typeof(+), typeof(-), typeof(*), typeof(/)}
_keeps_fill_type(::Type) = false
function _keeps_fill_type(::Type{<:Derived{F, A}}) where {F, A}
    return !(F <: _Arithmetic) || any(_keeps_fill_type, fieldtypes(A))
end
_keeps_fill_type(::Type{<:Survival{H}}) where {H} = _keeps_fill_type(H)
@generated _keeps_fill(x) = _keeps_fill_type(x)

# Blocks are recomputed unless `_fill_kernel` kept every cohort's scratch.
_weights_back!(::Nothing, kernel::_ComputedKernel, K̄, o, last, sc) = nothing
function _weights_back!(x̄, kernel::_ComputedKernel, K̄, o, last, sc)
    x̄d = _densified_mirror(x̄, kernel, last)
    _dense_weights_back!(x̄d, _densified(kernel, last).x, K̄, o, last, sc)
    _fold_dense!(x̄, kernel, x̄d)
    return nothing
end
function _dense_weights_back!(x̄, x, K̄, o, last, sc)
    _on_gpu(K̄) && return _device_weights_back!(x̄, x, K̄, o, last)
    n = size(K̄, ndims(K̄))
    B = _block_size(x, n, Val(true))
    sc = _back_scratch(sc)
    for τ0 in 1:B:n
        nb = min(B, n - τ0 + 1)
        B < n && _block!(x, sc, τ0, nb, o, last)
        _back_block!(x̄, x, sc, _KernelBlock(K̄, τ0), τ0, nb, o, last)
    end
    return nothing
end

# The dense kernel of a weights array, and the mirror of one.
_dense_kernel(K::AbstractMatrix) = TimeVarying{Primary}(K)
_dense_kernel(K::AbstractArray{<:Any, 3}) = TimeVarying{Primary}(PerStratum(K))
_dense_mirror(::Nothing) = nothing
_dense_mirror(K̄::AbstractMatrix) = (; x = K̄)
_dense_mirror(K̄::AbstractArray{<:Any, 3}) = (; x = (; x = K̄))

# The cotangent of the weights `K` to fill, or `nothing` when the kernel's
# mirror `x̄` is absent.
_weights_cotangent(::Nothing, K) = nothing
_weights_cotangent(x̄, K) = zero(K)

# == Arithmetic ==

# Arithmetic with a `Survival` on either side lowers to `Derived`, for the
# four operations a kernel has closed-form partials for.
for op in (:+, :-, :*, :/)
    @eval begin
        Base.$op(a::Survival, b::Union{_Operand, _Computed}) =
            Derived($op, a, b)
        Base.$op(a::Union{_Operand, Derived}, b::Survival) = Derived($op, a, b)
    end
end
