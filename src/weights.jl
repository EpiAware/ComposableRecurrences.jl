# Kernels computed from coefficients: `Weights` maps coefficients entry by
# entry and `Survival` takes each cohort's survival through the lags against
# a hazard. A call fills the weights it reads once, and its reverse pass takes
# their cotangent back to the coefficients.

@doc raw"""
Kernel weights computed entry by entry from coefficients by a function `f`.

Inside a kernel `TimeVarying(w, Primary())`, the weight on lag ``l`` of
cohort ``\tau`` (the input at time ``\tau``) in stratum ``k`` is

```math
w_{k,l}(\tau) = f\big(a_{1,k,l}(\tau), \dots, a_{n,k,l}(\tau)\big),
```

where ``a_{j,k,l}(\tau)`` is argument ``j`` read at that entry:

| argument                            | read at entry ``(k, l, \tau)``      |
|:----------------------------------- |:----------------------------------- |
| a number `c`                        | `c`                                 |
| a vector `p` of lag weights         | `p[i]`, the kernel's `i`th lag      |
| `PerStratum(v)`, `PerStratum(P)`    | `v[k]`, `P[k, i]`                   |
| `TimeVarying(x, Primary())`         | at time ``\tau``                    |
| `TimeVarying(x)`                    | at time ``\tau + l``                |
| `Weights`, [`ComposableRecurrences.Survival`](@ref) | its own weight   |

`i` is the lag's index in the kernel: lag ``l = i - 1`` in a
[`Convolution`](@ref) and ``l = i`` in a [`Recurrence`](@ref).
A `TimeVarying` argument has the shape of a modifier parameter (a vector of
times, or `PerStratum` strata × times) or of a kernel (lags × times, or
`PerStratum` strata × lags × times).
With `Primary()` it is read at the cohort's own time, and with the default
`Secondary()` at the time ``\tau + l`` the weight lands, so a
calendar-time series such as a hazard is `TimeVarying(h)`.
Every argument with a lag axis has the kernel's number of lags, and every
argument with a strata axis the call's strata; a kernel with any of them is
per stratum.

A call computes each weight it reads once, a block of cohorts at a time,
and runs as with the dense kernel of those weights.
Its reverse pass takes the weights' cotangent back to the arguments, with
the partial derivatives of `f` in closed form for `+`, `-`, `*` and `/`,
and from one local forward-mode derivative otherwise, which needs
ForwardDiff loaded.
Values captured inside `f` (a closure, or a callable struct with float
fields) are not arguments: an operator with such a map is differentiated by
the AD backend instead, so they keep their gradients.

Arithmetic with a `Weights` or `Survival` on either side builds another
`Weights`, with a number, a vector of lag weights, `PerStratum` or
`TimeVarying` on the other side: `p * (1 - s)` is
`Weights(*, p, Weights(-, 1, s))`.
[`ComposableRecurrences.kernel_weights`](@ref) returns the weights as an
array.

# Arguments
- `f`: the function, called as `f(a_1, ..., a_n)` on the arguments' values.
- `args`: the arguments, at least one.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
# A delay pmf whose mass is scaled down for cohorts from time 3 on.
p = [0.5, 0.3, 0.2]
scale = TimeVarying([1.0, 1.0, 0.5, 0.5], CR.Primary())
K = TimeVarying(CR.Weights(*, p, scale), CR.Primary())
round.(Convolution(K)(ones(4)); digits = 3)

# output

4-element Vector{Float64}:
 0.5
 0.8
 0.75
 0.6
```
"""
struct Weights{F, A <: Tuple}
    "The function, called on the arguments' values."
    f::F
    "The arguments."
    args::A
    function Weights(f::F, args::A) where {F, A <: Tuple}
        isempty(args) && throw(
            ArgumentError("Weights($f) needs at least one argument")
        )
        map(_check_coefficient, args)
        return new{F, A}(f, args)
    end
end
Weights(f, args...) = Weights(f, args)

@doc raw"""
The survival of each cohort through each lag of a kernel against a hazard.

Inside a kernel `TimeVarying(s, Primary())`, the weight on lag ``l`` of
cohort ``\tau`` in stratum ``k`` is

```math
s_{k,l}(\tau) = \prod_{j = \max(f, l_0)}^{l} \big(1 - \eta_{k,j}(\tau)\big),
```

where ``\eta_{k,j}(\tau)`` is the hazard at lag ``j``, read as an argument
of [`ComposableRecurrences.Weights`](@ref) is, ``f`` = `from` is the first
lag the hazard acts at and ``l_0`` is the kernel's first lag (0 in a
[`Convolution`](@ref), 1 in a [`Recurrence`](@ref)).
So it is the probability that a cohort has not left by the end of lag
``l``, and lags before `from` have survival one.
A hazard that changes with calendar time is `TimeVarying(h)`, read at the
time ``\tau + j`` each lag lands; one that changes with the lag is a vector
of lag weights.

This is the [`Recurrence`](@ref) `Recurrence([1])` with gain ``1 - \eta``
and a history of one, run over each cohort's lags, computed as part of the
kernel: one pass per cohort forward, and one back.

# Arguments
- `hazard`: the hazard, any argument of `Weights`.

# Keyword Arguments
- `from`: the first lag the hazard acts at, `0` by default.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
# Cohorts confirmed from the day after entry at a daily hazard `h`, and
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
    function Survival(hazard::H, from::Integer) where {H}
        _check_coefficient(hazard)
        from >= 0 || throw(
            ArgumentError("from is the first lag the hazard acts at, at least 0; got $from")
        )
        return new{H}(hazard, Int(from))
    end
end
Survival(hazard; from::Integer = 0) = Survival(hazard, from)

# A kernel computed from coefficients, and the kernel it is part of.
const _Computed = Union{Weights, Survival}
const _ComputedKernel = TimeVarying{Primary, <:_Computed}
_over_time(::_Computed) = true

# The coefficients a computed kernel reads: numbers, lag weights, values per
# stratum or per time, and other computed weights.
const _TimeAxis = Union{
    AbstractVector{<:Real}, AbstractMatrix{<:Real},
    PerStratum{<:AbstractMatrix{<:Real}}, PerStratum{<:AbstractArray{<:Real, 3}},
}
const _Coefficient = Union{
    Real, AbstractVector{<:Real}, PerStratum{<:AbstractVecOrMat{<:Real}},
    TimeVarying{<:Any, <:_TimeAxis}, _Computed,
}
function _check_coefficient(x::_Coefficient)
    _require_one_based(_array(x))
    return nothing
end
_check_coefficient(x::_Computed) = nothing
_check_coefficient(x::Real) = nothing
@noinline function _check_coefficient(x)
    throw(
        ArgumentError(
            "a computed kernel reads numbers, vectors of lag weights, " *
                "PerStratum values, TimeVarying values or kernels, Weights " *
                "and Survival; got $(_describe(x))"
        )
    )
end

# The time a coefficient is read at for lag `l` of cohort `τ`: the cohort's
# own time, or the time the weight lands.
_time(::TimeVarying{Primary}, τ, l) = τ
_time(::TimeVarying{Secondary}, τ, l) = τ + l

# The number of lags and strata a coefficient sets, `0` for none.
_coef_lags(x) = 0
_coef_lags(x::AbstractVector) = length(x)
_coef_lags(x::PerStratum{<:AbstractMatrix}) = size(x.x, 2)
_coef_lags(x::TimeVarying{<:Any, <:AbstractMatrix}) = size(x.x, 1)
_coef_lags(x::TimeVarying{<:Any, <:PerStratum{<:AbstractArray{<:Any, 3}}}) = size(x.x.x, 2)
_coef_lags(x::Weights) = _joined(_coef_lags, x.args, "lags")
_coef_lags(x::Survival) = _coef_lags(x.hazard)
_coef_strata(x) = 0
_coef_strata(x::PerStratum) = size(x.x, 1)
_coef_strata(x::TimeVarying{<:Any, <:PerStratum}) = size(x.x.x, 1)
_coef_strata(x::Weights) = _joined(_coef_strata, x.args, "strata")
_coef_strata(x::Survival) = _coef_strata(x.hazard)
# One tuple entry at a time, so arguments of mixed types infer.
_joined(f::F, ::Tuple{}, what) where {F} = 0
function _joined(f::F, args::Tuple, what) where {F}
    n, m = f(first(args)), _joined(f, Base.tail(args), what)
    n == 0 || m == 0 || n == m || throw(
        DimensionMismatch("the arguments of Weights have $n and $m $what")
    )
    return max(n, m)
end

# Whether a coefficient of type `T` has a strata axis, from the type, so the
# kernel's shape infers.
_typed_strata(::Type) = false
_typed_strata(::Type{<:PerStratum}) = true
_typed_strata(::Type{<:TimeVarying{<:Any, <:PerStratum}}) = true
_typed_strata(::Type{<:Survival{H}}) where {H} = _typed_strata(H)
function _typed_strata(::Type{<:Weights{F, A}}) where {F, A}
    return any(_typed_strata, fieldtypes(A))
end
@generated _has_strata(x) = _typed_strata(x)

function _check_kernel_shape(k::_ComputedKernel)
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
_check_kernel_times(k::_ComputedKernel, stop) = _check_coef_times(k.x, stop, stop)

# Each time-varying coefficient covers the cohorts up to `n` and the times
# up to `last` that the weights read.
_check_coef_times(x, n, last) = nothing
function _check_coef_times(x::TimeVarying{Primary}, n, last)
    return _check_covers(:kernel, _extent(_array(x)), n)
end
function _check_coef_times(x::TimeVarying{Secondary}, n, last)
    return _check_covers(:kernel, _extent(_array(x)), last)
end
function _check_coef_times(x::Weights, n, last)
    map(a -> _check_coef_times(a, n, last), x.args)
    return nothing
end
_check_coef_times(x::Survival, n, last) = _check_coef_times(x.hazard, n, last)

# A computed kernel is differentiated by its own reverse pass unless a map
# holds floats of its own.
_kernel_adjoint(k::_ComputedKernel) = _derived_local(k)
function _no_adjoint_kernel(k::_ComputedKernel)
    _derived_local(k) && return ()
    return ("the kernel has a Weights map that holds floats",)
end

# ---- the weights, a block of cohorts at a time --------------------------------

# A computed kernel is filled a block of `_BLOCK` cohorts at a time, lag
# outermost and cohort innermost: each cohort's survival is a product along
# its lags, so the cohorts of a block run side by side. Each `Survival`
# keeps the block's values `S`, hazards `H` and cotangents `S̄` (cohorts ×
# lags × the strata of its hazard, or one) in a scratch tree that mirrors
# the kernel, and the reverse pass recomputes a block before taking its
# cotangent back. So no weight is stored past its block, and a call
# allocates `O(L)` beyond the arrays it returns.
const _BLOCK = 32

struct _SurvivalScratch{C, A <: AbstractArray{<:Any, 3}, V <: AbstractVector}
    hazard::C
    S::A
    H::A
    S̄::A
    acc::V
end
_scratch(x, ::Type, L) = nothing
_scratch(x::Weights, ::Type{Tp}, L) where {Tp} = map(a -> _scratch(a, Tp, L), x.args)
function _scratch(x::Survival, ::Type{Tp}, L) where {Tp}
    ns = max(_coef_strata(x.hazard), 1)
    return _SurvivalScratch(
        _scratch(x.hazard, Tp, L), Array{Tp}(undef, _BLOCK, L, ns),
        Array{Tp}(undef, _BLOCK, L, ns), zeros(Tp, _BLOCK, L, ns), zeros(Tp, _BLOCK)
    )
end
_row(sc::_SurvivalScratch, k) = size(sc.S, 3) == 1 ? 1 : k

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
function _block!(x::Weights, sc, τ0, nb, o, last)
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

# The value of a coefficient at stratum `k`, lag index `i` (lag `l`) and
# cohort `τ`, the `b`th of its block, with its scratch `sc` filled for the
# block. The call's checks fix every shape, so reads skip bounds checks.
Base.@propagate_inbounds _value(x::Real, sc, k, i, τ, l, b) = x
Base.@propagate_inbounds _value(x::AbstractVector, sc, k, i, τ, l, b) = x[i]
Base.@propagate_inbounds function _value(x::PerStratum{<:AbstractVector}, sc, k, i, τ, l, b)
    return x.x[k]
end
Base.@propagate_inbounds function _value(x::PerStratum{<:AbstractMatrix}, sc, k, i, τ, l, b)
    return x.x[k, i]
end
Base.@propagate_inbounds function _value(
        x::TimeVarying{<:Any, <:AbstractVector}, sc, k, i, τ, l, b
    )
    return x.x[_time(x, τ, l)]
end
Base.@propagate_inbounds function _value(
        x::TimeVarying{<:Any, <:AbstractMatrix}, sc, k, i, τ, l, b
    )
    return x.x[i, _time(x, τ, l)]
end
Base.@propagate_inbounds function _value(
        x::TimeVarying{<:Any, <:PerStratum{<:AbstractMatrix}}, sc, k, i, τ, l, b
    )
    return x.x.x[k, _time(x, τ, l)]
end
Base.@propagate_inbounds function _value(
        x::TimeVarying{<:Any, <:PerStratum{<:AbstractArray{<:Any, 3}}}, sc, k, i, τ, l, b
    )
    return x.x.x[k, i, _time(x, τ, l)]
end
@inline function _value(x::Weights, sc, k, i, τ, l, b)
    return x.f(@inbounds(_values_at(x.args, sc, k, i, τ, l, b))...)
end
Base.@propagate_inbounds function _value(x::Survival, sc, k, i, τ, l, b)
    return sc.S[b, i, _row(sc, k)]
end

# The arguments' values, one tuple entry at a time, so a tuple of mixed
# types infers.
_values_at(::Tuple{}, ::Tuple{}, k, i, τ, l, b) = ()
@inline Base.@propagate_inbounds function _values_at(a::Tuple, sc::Tuple, k, i, τ, l, b)
    v = _value(first(a), first(sc), k, i, τ, l, b)
    return (v, _values_at(Base.tail(a), Base.tail(sc), k, i, τ, l, b)...)
end

# Add `v` to the cotangent of a coefficient's value at an entry, through
# its mirror `x̄`; a `Survival` adds it to its scratch.
Base.@propagate_inbounds function _add_value!(x̄, x::Real, sc, v, k, i, τ, l, b)
    return add_cotangent!(x̄, v)
end
Base.@propagate_inbounds function _add_value!(x̄, x::AbstractVector, sc, v, k, i, τ, l, b)
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
        x̄, x::TimeVarying{<:Any, <:AbstractMatrix}, sc, v, k, i, τ, l, b
    )
    return add_cotangent!(cotangent(x̄, :x), v, i, _time(x, τ, l))
end
Base.@propagate_inbounds function _add_value!(
        x̄, x::TimeVarying{<:Any, <:PerStratum{<:AbstractMatrix}}, sc, v, k, i, τ, l, b
    )
    return add_cotangent!(cotangent(cotangent(x̄, :x), :x), v, k, _time(x, τ, l))
end
Base.@propagate_inbounds function _add_value!(
        x̄, x::TimeVarying{<:Any, <:PerStratum{<:AbstractArray{<:Any, 3}}}, sc, v,
        k, i, τ, l, b
    )
    return add_cotangent!(cotangent(cotangent(x̄, :x), :x), v, k, i, _time(x, τ, l))
end
_add_value!(::Nothing, x::_Computed, sc, v, k, i, τ, l, b) = nothing
@inline Base.@propagate_inbounds function _add_value!(x̄, x::Survival, sc, v, k, i, τ, l, b)
    sc.S̄[b, i, _row(sc, k)] += v
    return nothing
end
# Unrolled over the arguments, so each reads its own mirror and scratch
# with a constant index.
@generated function _add_value!(x̄, x::Weights{F, A}, sc, v, k, i, τ, l, b) where {F, A}
    calls = (
        :(@inbounds _add_value!(ā[$j], x.args[$j], sc[$j], v * ∂[$j], k, i, τ, l, b))
            for j in 1:fieldcount(A)
    )
    return quote
        $(Expr(:meta, :inline))
        ā = _arg_mirrors(cotangent(x̄, :args), x.args)
        ā === nothing && return nothing
        ∂ = _partials(x.f, @inbounds _values_at(x.args, sc, k, i, τ, l, b))
        $(calls...)
        return nothing
    end
end

# The partial derivatives of `f` at `xs`: closed forms for the arithmetic,
# and a local forward-mode derivative otherwise.
_partials(f, xs::Tuple) = _forward_derivative(f, xs)
_partials(::typeof(+), (a, b)::Tuple{Real, Real}) = (one(a), one(b))
_partials(::typeof(-), (a, b)::Tuple{Real, Real}) = (one(a), -one(b))
_partials(::typeof(-), (a,)::Tuple{Real}) = (-one(a),)
_partials(::typeof(*), (a, b)::Tuple{Real, Real}) = (b, a)
_partials(::typeof(/), (a, b)::Tuple{Real, Real}) = (inv(b), -a / b^2)

# Once the block's own cotangents are added, each `Survival` takes the
# cotangents of its values back to its hazard, back along the lags: with
# `a` the cotangent of the survival from lag `i` on carried back to it,
# `η̄_i = -s_{i-1} a_i`. It clears its cotangents for the next block.
_block_back!(x̄, x, sc, τ0, nb, o, last) = nothing
function _block_back!(x̄, x::Weights, sc, τ0, nb, o, last)
    ā = _arg_mirrors(cotangent(x̄, :args), x.args)
    ā === nothing && return nothing
    _block_back_args!(ā, x.args, sc, τ0, nb, o, last)
    return nothing
end
_block_back_args!(::Tuple{}, ::Tuple{}, ::Tuple{}, τ0, nb, o, last) = nothing
function _block_back_args!(ā::Tuple, args::Tuple, sc::Tuple, τ0, nb, o, last)
    _block_back!(first(ā), first(args), first(sc), τ0, nb, o, last)
    return _block_back_args!(Base.tail(ā), Base.tail(args), Base.tail(sc), τ0, nb, o, last)
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
                _add_value!(h̄, x.hazard, sc.hazard, -prev * acc[b], k, i, τ0 + b - 1, l, b)
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
    for k in axes(W, 3)
        for i in axes(W, 2)
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
    for k in axes(W̄, 3), b in 1:nb
        @inbounds for i in 1:_imax(τ0 + b - 1, size(W̄, 2), o, last)
            _add_value!(x̄, x, sc, W̄[b, i, k], k, i, τ0 + b - 1, i - 1 + o, b)
        end
    end
    _block_back!(x̄, x, sc, τ0, nb, o, last)
    return nothing
end
# The block of weights of a kernel with `L` lags and `ns` strata.
_block_weights(::Type{Tp}, L, ns) where {Tp} = zeros(Tp, _BLOCK, L, ns)

# The weights of a computed kernel for cohorts `1:n`, lags from `o`, each
# one whose weight lands by `last`, as an array (lags × cohorts, or strata
# × lags × cohorts); unfilled weights are zero.
function _fill_kernel(kernel::_ComputedKernel, o, n, last)
    x = kernel.x
    n = max(n, 0)
    _check_coef_times(x, n, last)
    Tp = float(param_eltype(x))
    L = _coef_lags(x)
    ns = max(_coef_strata(x), 1)
    sc = _scratch(x, Tp, L)
    W = _block_weights(Tp, L, ns)
    K = _weights_array(Val(_has_strata(x)), Tp, ns, L, n)
    for τ0 in 1:_BLOCK:n
        nb = min(_BLOCK, n - τ0 + 1)
        _fill_block!(W, x, sc, τ0, nb, o, last)
        for b in 1:nb, i in 1:L, k in 1:ns
            b <= _bmax(τ0, nb, i, o, last) || continue
            @inbounds _setweight!(K, W[b, i, k], k, i, τ0 + b - 1)
        end
    end
    return K
end
_weights_array(::Val{false}, ::Type{Tp}, ns, L, n) where {Tp} = zeros(Tp, L, n)
_weights_array(::Val{true}, ::Type{Tp}, ns, L, n) where {Tp} = zeros(Tp, ns, L, n)
Base.@propagate_inbounds _setweight!(K::AbstractMatrix, v, k, i, τ) = (K[i, τ] = v; nothing)
Base.@propagate_inbounds _setweight!(K::AbstractArray{<:Any, 3}, v, k, i, τ) = (K[k, i, τ] = v; nothing)
Base.@propagate_inbounds _getweight(K::AbstractMatrix, k, i, τ) = K[i, τ]
Base.@propagate_inbounds _getweight(K::AbstractArray{<:Any, 3}, k, i, τ) = K[k, i, τ]

# Take the cotangent `K̄` of the weights `_fill_kernel` returned back to the
# kernel coefficients' mirror `x̄`, one recomputed block at a time.
_weights_back!(::Nothing, kernel, K̄, o, last) = nothing
function _weights_back!(x̄, kernel::_ComputedKernel, K̄, o, last)
    x = kernel.x
    n = size(K̄, ndims(K̄))
    Tp = eltype(K̄)
    L = _coef_lags(x)
    ns = max(_coef_strata(x), 1)
    sc = _scratch(x, Tp, L)
    W̄ = _block_weights(Tp, L, ns)
    for τ0 in 1:_BLOCK:n
        nb = min(_BLOCK, n - τ0 + 1)
        _block!(x, sc, τ0, nb, o, last)
        for b in 1:nb, i in 1:L, k in 1:ns
            @inbounds W̄[b, i, k] = b <= _bmax(τ0, nb, i, o, last) ?
                _getweight(K̄, k, i, τ0 + b - 1) : zero(Tp)
        end
        _back_block!(x̄, x, sc, W̄, τ0, nb, o, last)
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

# ---- arithmetic --------------------------------------------------------------

# Arithmetic with a computed coefficient on either side lowers to `Weights`.
const _CoefOperand = Union{Real, AbstractVector{<:Real}, PerStratum, TimeVarying}
for op in (:+, :-, :*, :/, :^)
    @eval begin
        Base.$op(a::_Computed, b::Union{_CoefOperand, _Computed}) = Weights($op, a, b)
        Base.$op(a::_CoefOperand, b::_Computed) = Weights($op, a, b)
    end
end
Base.:-(a::_Computed) = Weights(-, a)
