# The built-in modifiers and depletion forms. A `pullback!`'s `grads.piece`
# mirrors the object's fields as a NamedTuple: an array for a float array, a
# `Ref` for a float scalar, a NamedTuple for a wrapper such as `TimeVarying`,
# and `nothing` for a field without a cotangent.
#
# Every built-in modifier reads its parameters through `param`, whose
# docstring lists the parameter forms.


@doc raw"""
The value ``u_{t,k}`` of the modifier parameter `x` at stratum `k` and
absolute time `t`.

A parameter is one value ``x``, [`PerStratum`](@ref) giving ``x_k``,
[`TimeVarying`](@ref) giving ``x_t``, `TimeVarying(PerStratum(x))` giving
``x_{t,k}``, or a [`Derived`](@ref) parameter computed from these:

```math
u_{t,k} = \begin{cases}
x & \text{one value} \\
x_k & \text{per stratum} \\
x_t & \text{per time} \\
x_{t,k} & \text{per stratum and time} \\
f\big(a_{1,t,k}, \dots, a_{n,t,k}\big) & \text{derived},
\end{cases}
```

A [`Recent`](@ref) reads the recurrence's own recent outputs instead.
A modifier reads every parameter through `param`, and writes its cotangent
through [`ComposableRecurrences.add_param!`](@ref), so it accepts every
parameter form, including forms added later.

# Arguments
- `x`: the parameter.
- `k`: the stratum.
- `t`: the absolute time.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
x = TimeVarying(PerStratum([1.0 2.0; 3.0 4.0]))
CR.param(x, 2, 1), round(CR.param(2 * Derived(sqrt, x), 2, 1); digits = 3)

# output

(3.0, 3.464)
```
"""
function param end

@doc raw"""
Add the cotangent `v` of the parameter `x`, read at stratum `k` and absolute
time `t`, into its mirror `x̄`.

For a scalar loss ``\ell`` and the value ``u_{t,k}`` read by
[`ComposableRecurrences.param`](@ref),

```math
\bar x \mathrel{+}= v\, \frac{\partial u_{t,k}}{\partial x},
\qquad v = \frac{\partial \ell}{\partial u_{t,k}},
```

so `v` lands in the entry `param` read, or, for a [`Derived`](@ref)
parameter, in each of its arguments by the chain rule.
A modifier's [`ComposableRecurrences.pullback!`](@ref) writes every
parameter's cotangent through `add_param!`, with `x̄` from
[`ComposableRecurrences.cotangent`](@ref), so it accepts every parameter
form.
A `nothing` mirror takes nothing for `x` itself, but a [`Recent`](@ref)
parameter still sends its cotangent to the outputs it read, so a pullback
calls `add_param!` for every parameter whatever its mirror.

# Arguments
- `x̄`: the mirror of `x`.
- `x`: the parameter.
- `v`: the cotangent of the value read.
- `k`: the stratum.
- `t`: the absolute time.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
x̄ = (; x = zeros(3))
CR.add_param!(x̄, TimeVarying([1.0, 2.0, 3.0]), 0.5, 1, 2)
x̄.x

# output

3-element Vector{Float64}:
 0.0
 0.5
 0.0
```
"""
function add_param! end

param(x::Real, k, t) = x
param(x::PerStratum, k, t) = x.x[k]
param(x::TimeVarying{<:Any, <:AbstractVector}, k, t) = x.x[t]
param(x::TimeVarying{<:Any, <:PerStratum}, k, t) = x.x.x[k, t]
add_param!(x̄, ::Real, v, k, t) = add_cotangent!(x̄, v)
add_param!(x̄, ::PerStratum, v, k, t) = add_cotangent!(x̄, v, k)
function add_param!(x̄, ::TimeVarying{<:Any, <:AbstractVector}, v, k, t)
    return add_cotangent!(x̄, v, t)
end
function add_param!(x̄, ::TimeVarying{<:Any, <:PerStratum}, v, k, t)
    return add_cotangent!(x̄, v, k, t)
end

# Check a parameter's shape at construction.
_check_param(name, x::Real) = x
_check_param(name, x::PerStratum{<:AbstractVector}) = x
_check_param(name, x::TimeVarying{Secondary, <:AbstractVector}) = x
function _check_param(
        name, x::TimeVarying{Secondary, <:PerStratum{<:AbstractMatrix}}
    )
    return x
end
_check_param(name, x::TimeVarying{Primary}) = _primary_error(name, x)
function _check_param(name, x)
    throw(
        ArgumentError(
            "$name is one value, PerStratum($name) with one per stratum, " *
                "TimeVarying($name) with one per time, " *
                "TimeVarying(PerStratum($name)) strata × time, or " *
                "Derived(f, args...) computed from other parameters, or " *
                "Recent(w) read from the recurrence's outputs; got " *
                _describe(x)
        )
    )
end

# Check a parameter against `S` strata.
_check_param_strata(name, x, S) = _check_rows(name, x, S, "strata")

# A zero initial state, once the parameters are checked against the state's
# strata. `foreach` unrolls the pairs, so each keeps its concrete type: in a
# `for` loop a pair is a `Union`, which an AD backend on Julia 1.11 cannot
# type.
function _zero_state!(s, params::Pair...)
    foreach(p -> _check_param_strata(first(p), last(p), length(s)), params)
    fill!(s, zero(eltype(s)))
    return nothing
end

# Depletion forms ---------------------------------------------------------

@doc raw"""
The hazard depletion form: the value is drawn from the pool as a hazard, so
the pool never goes negative.

For one stratum at one step,

```math
\lambda = \frac{v}{N} \Big(\frac{s}{N}\Big)^{\alpha - 1}, \qquad
v' = s\,\big(1 - e^{-\lambda}\big), \qquad
s' = s\, e^{-\lambda},
```

where ``v`` is the value asked for, ``s`` the pool before the step, ``N`` the
population, ``\alpha`` the heterogeneity exponent, ``\lambda`` the hazard,
``v'`` the value drawn and ``s'`` the pool after the step.
With `α > 1`, infections slow sooner as the pool shrinks, as when the most
susceptible are infected first.

The default draw of a [`ComposableRecurrences.Depletion`](@ref).
As the form of a [`ComposableRecurrences.Flow`](@ref) it takes no
exponent.

# Arguments
- `α`: the heterogeneity exponent; `nothing`, the default, or `true` for
  an exponent of exactly one that is not a parameter, so the step skips
  the power and its derivative.
  `false` is a fixed exponent of zero.
  In a `Depletion` any other integer takes the population's float type;
  pass a float to differentiate the exponent.

# Keyword Arguments
- `weights`, `into`, `overflow`: the form's arguments as a draw in a
  [`ComposableRecurrences.Depletion`](@ref): each pool's weight, the pool
  it fills and where what it leaves goes.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
v, s = [2.0], [80.0]
CR.forward!(CR.Hazard(), CR.Step(), v, s, 100.0)
round.(v; digits = 3), round.(s; digits = 3)

# output

([1.584], [78.416])
```
"""
struct Hazard{A, W, I, O}
    "The heterogeneity exponent α, or `nothing` for one."
    α::A
    "As a draw, each pool's weight by name, or `nothing`."
    weights::W
    "As a draw, the pool it fills, or `nothing`."
    into::I
    "As a draw, where what it leaves goes."
    overflow::O
    function Hazard{A, W, I, O}(α, weights, into, overflow) where {A, W, I, O}
        return new{A, W, I, O}(α, weights, into, overflow)
    end
end

@doc raw"""
The floored depletion form: the value is scaled by the share of the pool
left, with a floor.

For one stratum at one step,

```math
f = \max\!\Big(\max\big(\tfrac{s}{N}, 0\big)^{\alpha},\ 10^{-6}\Big),
\qquad v' = f\, v, \qquad s' = s - v',
```

where ``v`` is the value asked for, ``s`` the pool before the step, ``N`` the
population, ``\alpha`` the heterogeneity exponent, ``f`` the scaling, ``v'``
the value drawn and ``s'`` the pool after the step.
The pool can go negative, and then the floor applies.

# Arguments
- `α`: the heterogeneity exponent, as for
  [`ComposableRecurrences.Hazard`](@ref).

# Keyword Arguments
- `weights`, `into`, `overflow`: the form's arguments as a draw in a
  [`ComposableRecurrences.Depletion`](@ref): each pool's weight, the pool
  it fills and where what it leaves goes.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
v, s = [2.0], [80.0]
CR.forward!(CR.Floor(), CR.Step(), v, s, 100.0)
v, s

# output

([1.6], [78.4])
```
"""
struct Floor{A, W, I, O}
    "The heterogeneity exponent α, or `nothing` for one."
    α::A
    "As a draw, each pool's weight by name, or `nothing`."
    weights::W
    "As a draw, the pool it fills, or `nothing`."
    into::I
    "As a draw, where what it leaves goes."
    overflow::O
    function Floor{A, W, I, O}(α, weights, into, overflow) where {A, W, I, O}
        return new{A, W, I, O}(α, weights, into, overflow)
    end
end

# Where what a draw leaves goes: nowhere, to the group's second value or
# to a queue that joins its value at the next step.
struct _Drop end
struct _ToStratum end
struct _Queue end
_overflow(::Nothing) = _Drop()
function _overflow(x::Symbol)
    x === :stratum && return _ToStratum()
    x === :queue && return _Queue()
    return _bad_overflow(x)
end
_overflow(x) = _bad_overflow(x)
@noinline function _bad_overflow(x)
    throw(
        ArgumentError(
            "overflow is nothing, :queue or :stratum, got " * _describe(x)
        )
    )
end
_overflow_name(::_Drop) = nothing
_overflow_name(::_ToStratum) = :stratum
_overflow_name(::_Queue) = :queue

# A form with its exponent and its arguments as a draw: `true` is the
# default exponent of one. The positional method rebuilds a form from its
# fields.
const _ExponentForm = Union{Hazard, Floor}
for F in (:Hazard, :Floor)
    @eval function $F(α = nothing; weights = nothing, into = nothing, overflow = nothing)
        return $F(_unit_exponent(α), weights, into, _overflow(overflow))
    end
    @eval function $F(α::A, weights::W, into::I, overflow::O) where {A, W, I, O}
        return $F{A, W, I, O}(_check_exponent(α), weights, into, overflow)
    end
end
_unit_exponent(α) = α
_unit_exponent(α::Bool) = α ? nothing : α
_check_exponent(α::Union{Nothing, Real}) = α
@noinline function _check_exponent(α)
    throw(
        ArgumentError(
            "the heterogeneity exponent is a number or nothing, got " * _describe(α)
        )
    )
end

# A built-in form's arguments as a draw, and the form without them, which
# a draw holds; a form of another type is drawn from the first pool alone.
_draw_args(form) = (nothing, nothing, _Drop())
_draw_args(form::_ExponentForm) = (form.weights, form.into, form.overflow)
_bare(form) = form
_bare(form::_ExponentForm) = typeof(form).name.wrapper(form.α)

# Printed as written.
function Base.show(io::IO, form::_ExponentForm)
    show(io, typeof(form).name.wrapper)
    print(io, "(")
    form.α === nothing || print(io, form.α)
    _show_draw_args(io, form)
    print(io, ")")
    return nothing
end
function _show_draw_args(io, form)
    w, i, o = _draw_args(form)
    args = filter(
        p -> p.second !== nothing,
        (:weights => w, :into => i, :overflow => _overflow_name(o))
    )
    isempty(args) && return nothing
    print(io, "; ", join(("$(k) = $(repr(v))" for (k, v) in args), ", "))
    return nothing
end

# The population: any parameter, read at each step's stratum and time.
_population(N) = _float_param(_check_param(:N, N))

# A form is a type with an in-place Step on one-entry views, for a scalar
# `N` of any real type or of one float type.
function _check_form(form::F) where {F}
    _is_form(F) || throw(
        ArgumentError(
            "$(_describe(form)) is not a draw or a Flow: a draw's form " *
                "implements forward!(form, Step(), v, s, N), writing v and s " *
                "in place, and the population N comes first"
        )
    )
    return nothing
end
_is_form(x) = _is_form(typeof(x))
function _is_form(::Type{F}) where {F}
    return _form_step_for(F, Real) || _form_step_for(F, Float64) ||
        _form_step_for(F, Float32)
end
# A modifier's step takes the same arguments, with the time in place of
# `N`, so the default vector step, which takes any type, is not a form's.
function _form_step_for(::Type{F}, ::Type{T}) where {F, T}
    V = _At{T, Base.RefValue{T}}
    sig = Tuple{F, Step, V, V, T}
    hasmethod(forward!, sig) || return false
    return Base.unwrap_unionall(which(forward!, sig).sig).parameters[2] !== Any
end

# The starting pool is per stratum, not over time.
_check_constant(name, x) = _check_param(name, x)
_check_constant(name, x::TimeVarying) = _not_constant_error(name, x)

_float_param(x::Real) = float(x)
_float_param(x::PerStratum) = PerStratum(float(x.x))
_float_param(x::TimeVarying{I, <:AbstractArray}) where {I} = TimeVarying{I}(float(x.x))
function _float_param(x::TimeVarying{I, <:PerStratum}) where {I}
    return TimeVarying{I}(_float_param(x.x))
end

# A form's exponent in a `Depletion`: an integer takes the population's
# float type, so it has a cotangent and a Float32 population stays Float32.
# A dual population gives its primal type: a dual exponent with zero
# partials makes `(s / N)^(α - 1)` carry `log(0) * 0 = NaN` at an empty
# pool. `nothing` and `false` stay fixed, without a cotangent.
_exponent_form(form, N) = form
function _exponent_form(form::F, N) where {F <: _ExponentForm}
    return typeof(form).name.wrapper(_exponent(form.α, N))
end
_exponent(α::Integer, N) = convert(float(_primal_type(param_eltype(N))), α)
_exponent(α::Bool, N) = α
_exponent(α, N) = α

# The exponent a step reads: `true` for `nothing`, an exponent of exactly
# one that the powers below branch on, without a cotangent.
# A float exponent with an `isone` branch in the steps was measured in its
# place: the reverse passes were up to 16% slower and allocated more, as
# they still take the exponent's `log` term, so the fixed form stays.
_alpha(form) = _alpha_value(form.α)
_alpha_value(::Nothing) = true
_alpha_value(α) = α

# The powers of the share of the pool left `r`: `r^(α - 1)` scales the
# hazard (through `_pool_power` in the step) and `r^α` the floor. A `Bool`
# exponent is a fixed integer, so each power is a branch on it, and it has
# no cotangent, so neither has its log term.
_share_power(r, α) = _pool_power(r, α - 1)
_share_power(r, α::Bool) = _power_m1(r, α)
_power_m1(r, α) = r^(α - 1)
_power_m1(r, α::Bool) = α ? one(r) : inv(r)
_floor_power(r, α) = r^α
_floor_power(r, α::Bool) = α ? r : one(r)
_times_log(α, r, c) = c * log(r)
_times_log(::Bool, r, c) = zero(c)

function forward!(form::Hazard, ::Step, v, s, N)
    α = _alpha(form)
    for k in eachindex(v, s)
        x = v[k] / N * _share_power(s[k] / N, α)
        e, em = _exp_neg(x)
        v[k], s[k] = -s[k] * em, s[k] * e
    end
    return nothing
end

# `(exp(-x), expm1(-x))` from one exponential: `expm1` below `1/2`, where
# it keeps the digits `1 - e^{-x}` would lose and `1 + expm1(-x)` loses
# none, and `exp` above, where neither subtraction cancels. Plain floats
# and dual numbers branch on their value; a traced number would fix the
# branch when its trace is recorded, or reject it, so takes both.
_exp_neg(x) = (exp(-x), expm1(-x))
_exp_neg(x::AbstractFloat) = _exp_neg_branch(x)
function _exp_neg_branch(x)
    if x < 0.5
        em = expm1(-x)
        return 1 + em, em
    end
    e = exp(-x)
    return e, e - 1
end

# `r^e` for the share of the pool left. At an empty pool the exponent's
# tangent is `log(0) * ė`; the pullback sets the exponent's cotangent to
# zero there, and so does the power. With `e = 0` the power is one for any
# positive share, so an empty share is swapped for one: the value is
# unchanged and neither tangent sees `log(0)`. `ifelse` keeps this
# branch-free for traced shares and exponents. A NaN share is kept, so its
# NaN reaches the tangent.
_pool_power(r, e) = ifelse(r <= 0, ifelse(iszero(e), one(r), r), r)^e

function pullback!(grads, form::Hazard, ::Step, v, s, N)
    α = _alpha(form)
    ᾱs = cotangent(grads.piece, :α)
    for k in eachindex(v, s)
        ȳ, s̄′ = grads.v[k], grads.s[k]
        r = s[k] / N
        h = _power_m1(r, α)
        x = v[k] / N * h
        e, em = _exp_neg(x)
        x̄ = s[k] * e * (ȳ - s̄′)
        s̄ = -ȳ * em + s̄′ * e
        α == 1 || (s̄ += e * (ȳ - s̄′) * (α - 1) * x)
        ᾱ = _primal_value(r) <= 0 ? zero(x̄ * x) : _times_log(α, r, x̄ * x)
        grads.v[k], grads.s[k] = x̄ * h / N, s̄
        grads.N[k] += -x̄ * α * x / N
        add_cotangent!(ᾱs, ᾱ)
    end
    return nothing
end

const _DEPLETION_FLOOR = 1.0e-6

function forward!(form::Floor, ::Step, v, s, N)
    α = _alpha(form)
    for k in eachindex(v, s)
        r = s[k] / N
        f = max(_floor_power(max(r, zero(r)), α), oftype(r, _DEPLETION_FLOOR))
        y = f * v[k]
        v[k], s[k] = y, s[k] - y
    end
    return nothing
end

function pullback!(grads, form::Floor, ::Step, v, s, N)
    α = _alpha(form)
    ᾱs = cotangent(grads.piece, :α)
    for k in eachindex(v, s)
        ȳ, s̄′ = grads.v[k], grads.s[k]
        r = s[k] / N
        p = _floor_power(max(r, zero(r)), α)
        fl = oftype(p, _DEPLETION_FLOOR)
        ḡ = ȳ - s̄′
        if p > fl
            f̄ = ḡ * v[k]
            ᾱ = _primal_value(r) <= 0 ? zero(f̄ * p) : _times_log(α, r, f̄ * p)
            grads.v[k], grads.s[k] = ḡ * p, s̄′ + f̄ * α * _power_m1(r, α) / N
            grads.N[k] += -f̄ * α * p / N
            add_cotangent!(ᾱs, ᾱ)
        else
            grads.v[k] = ḡ * fl
        end
    end
    return nothing
end

# Add ---------------------------------------------------------------------

@doc raw"""
Adds `b` to each stratum's value wherever the modifier sits in the tuple:
after a [`ComposableRecurrences.Depletion`](@ref), the added values are
neither scaled by nor drawn from the pool.

For each [stratum](@ref PerStratum) ``i`` at absolute time ``t``,

```math
v'_{t,i} = v_{t,i} + b_{t,i},
```

where ``v_{t,i}`` is the value entering the modifier, ``v'_{t,i}`` the value
it passes on and ``b_{t,i}`` the parameter read at stratum ``i`` and time
``t``.

`b` is a [parameter](@ref ComposableRecurrences.param).
Alone, `Add(TimeVarying(PerStratum(B)))` gives the same values as passing
`B` as `add`.
The state is unused.

# Arguments
- `b`: the values to add.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
mods = (CR.Depletion(50.0, CR.Floor()), CR.Add(TimeVarying([1.0, 0.0, 2.0])))
Recurrence([1.0]; modifiers = mods)(1.0; history = [2.0], stop = 3)

# output

3-element Vector{Float64}:
 3.0
 2.88
 4.598912
```
"""
struct Add{B}
    "The values to add, a parameter."
    b::B
    Add(b::B) where {B} = new{B}(_check_param(:b, b))
end

blocks(::Add) = (1, 1)
_stateless(::Add) = true
forward!(m::Add, ::Init, s, history) = _zero_state!(s, :b => m.b)
pullback!(grads, ::Add, ::Init, s, history) = nothing

function forward!(m::Add, ::Step, v, s, t)
    for k in eachindex(v)
        v[k] += param(m.b, k, t)
    end
    return nothing
end
function pullback!(grads, m::Add, ::Step, v, s, t)
    b̄ = cotangent(grads.piece, :b)
    for k in eachindex(v)
        add_param!(b̄, m.b, grads.v[k], k, t)
    end
    return nothing
end

# Redistribute ------------------------------------------------------------

@doc raw"""
Moves a share of each stratum's value to others through a movement matrix
whose columns sum to one, so the total is conserved.

For each [stratum](@ref PerStratum) ``i`` at absolute time ``t``,

```math
\begin{aligned}
s'_i &= \sum_{j \ne i} M_{t,ij}\, v_j, \\
v'_i &= M_{t,ii}\, v_i + s'_i = \sum_j M_{t,ij}\, v_j,
\end{aligned}
```

where ``v_i`` is the value entering the modifier, ``v'_i`` the value it
passes on, ``M_{t,ij}`` = `M[i, j]` the share of origin ``j``'s value that
is realised in destination ``i`` and ``s'_i`` the arrivals, kept as the
state.
The columns of ``M`` sum to one, so summing ``v'_i`` over ``i`` gives
``\sum_i v_i``; this is checked at `Init` to within the square root of the
machine epsilon.
With `leak = true` a column may sum to less than one, for a share lost on
the way.
`M` is an `S × S` matrix, or `TimeVarying` of an `S × S × T` array for
movement that changes over time; its entries are its parameters, and a
gradient with respect to anything they are built from, such as an
intensity, flows through that construction
([`ComposableRecurrences.movement`](@ref) builds one from a kernel and an
intensity).
Place it before a [`ComposableRecurrences.Depletion`](@ref) to deplete each
stratum's pool by what it realises; a modifier sees
``\gamma_t \odot q_t + a_t``, the gain times the coupled pressure plus the add
input, so the `add` values move too.
The step is the coupling product ``M_t v``, and its reverse pass the
transposed product, ``\bar v = M_t^\top \bar v'`` and
``\bar M_t \mathrel{+}= \bar v' v^\top``.

# Arguments
- `M`: the movement matrix, `M[p, q]` the share of origin `q` realised in
  destination `p`.

# Keyword Arguments
- `leak`: `false` (the default), or `true` to allow columns summing to less
  than one.
  It sets the type parameter `L` of `Redistribute{L}`, so pass it as a
  literal, which is folded at compile time.
  For a flag read from a variable, `Redistribute{leak}(M)` names the type
  directly.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
M = CR.movement([0.0 0.3; 0.2 0.0], 0.1)
r = Recurrence([0.5, 0.5]; modifiers = (CR.Redistribute(M),))
y = r(fill(1.2, 2, 5); history = [1.0 1.0; 0.0 0.0])
round.(y; digits = 3)

# output

2×5 Matrix{Float64}:
 1.176  1.28  1.445  1.604  1.796
 0.024  0.04  0.067  0.095  0.131
```
"""
struct Redistribute{L, A}
    "The movement matrix, `M[p, q]` from origin `q` to destination `p`."
    M::A
    function Redistribute{L}(M::A) where {L, A}
        L isa Bool || throw(ArgumentError("leak is true or false, got $(repr(L))"))
        _check_movement_shape(M)
        return new{L, A}(M)
    end
end
# A branch on a literal `leak` names the type parameter in each arm, so the
# call is inferred.
Redistribute(M; leak::Bool = false) = leak ? Redistribute{true}(M) : Redistribute{false}(M)
ConstructionBase.constructorof(::Type{<:Redistribute{L}}) where {L} = Redistribute{L}

function _check_movement_shape(M::AbstractMatrix)
    size(M, 1) == size(M, 2) || throw(
        DimensionMismatch("M is $(size(M)), expected a square matrix")
    )
    return nothing
end
function _check_movement_shape(M::TimeVarying)
    _check_coupling_shape(M)
    size(M.x, 1) == size(M.x, 2) || throw(
        DimensionMismatch("M is $(size(M.x)), expected S × S × T")
    )
    return nothing
end
function _check_movement_shape(M)
    throw(
        ArgumentError(
            "M is an S × S matrix or TimeVarying of an S × S × T array, got " *
                _describe(M)
        )
    )
end

@doc raw"""
The movement matrix of a kernel ``K`` and an origin intensity
``\varepsilon``: a share ``\varepsilon_q K_{pq}`` of origin ``q``'s value is
realised in ``p \ne q``, and the rest stays,

```math
M = I - \operatorname{diag}(\varepsilon \odot o) + K \operatorname{diag}(\varepsilon),
\qquad o_q = \sum_p K_{pq},
```

so ``M_{qq} = 1 - \varepsilon_q \sum_{p \ne q} K_{pq}`` whatever the
diagonal of ``K``, and every column of ``M`` sums to one.
`ε` is one value or a vector over origins, which gives a matrix, or an
origins × time matrix, which gives `TimeVarying` of an `S × S × T` array.
`PerStratum(ε)` and `TimeVarying(PerStratum(E))` are read as the vector and
the matrix they hold.
Any other [parameter](@ref ComposableRecurrences.param), such as
`TimeVarying(ε)` over time or one built with `Derived` or
[`Recent`](@ref) that reads the outputs, gives a movement read at each step
as ``M_t`` above with ``\varepsilon_{t,q}`` that parameter at origin ``q``.
The array is held as ``K`` and ``\varepsilon`` and read from them, the
column sums ``o`` taken as each column is read, so a step costs one product
with ``K`` and its reverse pass gives the cotangents of ``K`` and
``\varepsilon`` without storing a matrix per time.

# Arguments
- `K`: the `S × S` kernel, `K[p, q]` the weight from origin `q` to `p`.
- `ε`: the origin intensity.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
CR.movement([0.0 0.3; 0.2 0.0], [0.1, 0.5])

# output

2×2 Matrix{Float64}:
 0.98  0.15
 0.02  0.85
```
"""
movement(K::AbstractMatrix, ε::Union{Real, AbstractVector}) = _movement(K, _origins(ε))
movement(K::AbstractMatrix, ε::AbstractMatrix) = TimeVarying(_Movement(K, ε))
movement(K::AbstractMatrix, ε::PerStratum{<:AbstractVector}) = movement(K, ε.x)
function movement(K::AbstractMatrix, ε::TimeVarying{<:Any, <:PerStratum{<:AbstractMatrix}})
    return movement(K, ε.x.x)
end
movement(K::AbstractMatrix, ε) = TimeVarying(_Movement(K, _check_param(:ε, ε)))
function movement(K, ε)
    throw(
        ArgumentError("movement takes an S × S kernel matrix, got $(_describe(K))")
    )
end
_origins(ε::Real) = ε
_origins(ε::AbstractVector) = permutedims(ε)
function _movement(K, E)
    size(K, 1) == size(K, 2) || throw(
        DimensionMismatch("K is $(size(K)), expected a square matrix")
    )
    o = sum(K; dims = 1)
    return (axes(K, 1) .== permutedims(axes(K, 2))) .* (1 .- o .* E) .+ K .* E
end

# The movement of a kernel `K` and an intensity `E` (origins × time), read
# entry by entry: `M[p, q, t] = δ_pq (1 − E[q, t] o[q]) + K[p, q] E[q, t]`
# with `o` the column sums of `K`, summed where they are read. Its columns
# sum to one by construction. It is a struct of its arrays, not an array, so
# the rules read its cotangent field by field. Its own loops below are kept
# over the generic array ones because they measured faster than building
# the `S × S × T` array first, on the primal and every AD backend measured;
# see the `materialised` arm of the patch-model benchmark case.
struct _Movement{KT <: AbstractMatrix, ET}
    K::KT
    E::ET
    function _Movement(K::KT, E::ET) where {KT <: AbstractMatrix, ET}
        _check_movement_sizes(K, E)
        return new{KT, ET}(K, E)
    end
end
# The intensity is an origins × time matrix, or a parameter read at each
# origin and time (its strata are checked where the run's are known).
@noinline function _check_movement_sizes(K, E::AbstractMatrix)
    size(K, 1) == size(K, 2) == size(E, 1) || throw(
        DimensionMismatch(
            "K is $(size(K)) and ε is $(size(E)); expected S × S and S × T"
        )
    )
    return nothing
end
@noinline function _check_movement_sizes(K, E)
    size(K, 1) == size(K, 2) || throw(
        DimensionMismatch("K is $(size(K)), expected a square matrix")
    )
    return nothing
end
_intensity(E::AbstractMatrix, q, t) = E[q, t]
_intensity(E, q, t) = param(E, q, t)
_add_intensity!(Ē, E::AbstractMatrix, x, q, t) = add_cotangent!(Ē, x, q, t)
_add_intensity!(Ē, E, x, q, t) = add_param!(Ē, E, x, q, t)
_check_time(E::AbstractMatrix, t) = checkbounds(E, :, t)
_check_time(E, t) = nothing
_ntimes(E::AbstractMatrix) = size(E, 2)
_ntimes(E) = 1
Base.size(m::_Movement) = (size(m.K, 1), size(m.K, 2), _ntimes(m.E))
Base.size(m::_Movement, d::Integer) = size(m)[d]
Base.ndims(::_Movement) = 3
function _colsum(K, b)
    o = zero(eltype(K))
    for a in axes(K, 1)
        o += K[a, b]
    end
    return o
end
function Base.getindex(m::_Movement, p::Integer, q::Integer, t::Integer)
    e = _intensity(m.E, q, t)
    return (p == q) * (1 - e * _colsum(m.K, q)) + m.K[p, q] * e
end
_over_time(::_Movement) = true
_array(m::_Movement) = m
_extent(m::_Movement{<:AbstractMatrix, <:AbstractMatrix}) = size(m.E, 2)
_extent(m::_Movement) = nothing
# A movement covers the times its intensity does: an origins × time matrix
# its columns, a parameter whatever its own time-varying parts cover.
function _check_leaf(name, x::TimeVarying{Secondary, <:_Movement}, stop)
    E = x.x.E
    E isa AbstractMatrix && return _check_covers(name, size(E, 2), stop)
    return _check_times(name, E, stop)
end
_check_leaf(name, ::TimeVarying{Secondary, <:_Movement}, ::Nothing) = nothing
_check_coupling_shape(::TimeVarying{Secondary, <:_Movement}) = nothing
_check_columns(::_Movement, leak) = nothing
# With one stratum a movement of a kernel and an intensity is the identity
# whatever their values (`1 − ε o + K ε` with `o = K`), so nothing moves and
# neither has a gradient: the step passes the value on with no arrivals.
_stays(M) = false
_stays(M::TimeVarying{<:Any, <:_Movement}) = size(M.x.K, 1) == 1

# The step reads `M_t v = (1 − E_t ∘ o) ∘ v + K (E_t ∘ v)`, with each
# column's sum taken as the column is read.
function forward!(C::TimeVarying{Secondary, <:_Movement}, ::Pressure, q, p, t)
    (; K, E) = C.x
    _check_time(E, t)
    _check_pressure(K, q, p)
    fill!(q, zero(eltype(q)))
    for b in axes(K, 2)
        e = _intensity(E, b, t)
        w = e * p[b]
        o = zero(eltype(K))
        for a in axes(K, 1)
            q[a] += K[a, b] * w
            o += K[a, b]
        end
        q[b] += (1 - e * o) * p[b]
    end
    return nothing
end

# With `c = Kᵀ q̄`: `p̄ += E_t ∘ c + (1 − E_t ∘ o) ∘ q̄` and
# `Ē_t += p ∘ (c − o ∘ q̄)`; `K̄[a, b] += w_b (q̄_a − q̄_b)` with
# `w = E_t ∘ p`, the second term through the column sum.
function pullback!(
        grads, C::TimeVarying{Secondary, <:_Movement}, ::Pressure, q, p, t
    )
    X̄ = cotangent(grads.piece, :x)
    q̄, p̄ = grads.q, grads.p
    (; K, E) = C.x
    K̄, Ē = cotangent(X̄, :K), cotangent(X̄, :E)
    for b in axes(K, 2)
        c = zero(eltype(p̄))
        o = zero(eltype(K))
        e = _intensity(E, b, t)
        w = e * p[b]
        for a in axes(K, 1)
            c += K[a, b] * q̄[a]
            o += K[a, b]
            add_cotangent!(K̄, w * (q̄[a] - q̄[b]), a, b)
        end
        p̄[b] += e * c + (1 - e * o) * q̄[b]
        _add_intensity!(Ē, E, p[b] * (c - o * q̄[b]), b, t)
    end
    return nothing
end

# Entry `(a, b)` at `t` of the mirror of a movement's array: through `K`,
# `E` and, on the diagonal, the column sum of `K`.
_add_movement_entry!(::Nothing, X::_Movement, x, a, b, t) = nothing
function _add_movement_entry!(X̄, X::_Movement, x, a, b, t)
    e = _intensity(X.E, b, t)
    K̄ = cotangent(X̄, :K)
    add_cotangent!(K̄, x * e, a, b)
    _add_intensity!(
        cotangent(X̄, :E), X.E, x * (X.K[a, b] - (a == b) * _colsum(X.K, b)), b, t
    )
    if a == b
        for r in axes(X.K, 1)
            add_cotangent!(K̄, -x * e, r, b)
        end
    end
    return nothing
end

# Redistribute over a movement of a kernel and an intensity in one pass:
# column `b` adds `K[:, b] w_b` to the arrivals, finds its sum, and sets
# `v[b]` to its own share `M_bb v_b`; the arrivals then join.
function forward!(
        m::Redistribute{<:Any, <:TimeVarying{Secondary, <:_Movement}}, ::Step, v, s, t
    )
    _stays(m.M) && return (fill!(s, zero(eltype(s))); nothing)
    (; K, E) = m.M.x
    _check_time(E, t)
    _check_pressure(K, s, v)
    fill!(s, zero(eltype(s)))
    for b in axes(K, 2)
        e = _intensity(E, b, t)
        w = e * v[b]
        o = zero(eltype(K))
        for a in axes(K, 1)
            s[a] += K[a, b] * w
            o += K[a, b]
        end
        s[b] -= K[b, b] * w
        v[b] = (1 - e * o) * v[b] + K[b, b] * w
    end
    for a in eachindex(v, s)
        v[a] += s[a]
    end
    return nothing
end

# The matrix is checked against the strata, and its columns, once, here
# and on a resumed state, not on every step.
function forward!(m::Redistribute, ::Init, s, history)
    _check_modifier_strata(m, length(s))
    fill!(s, zero(eltype(s)))
    return nothing
end
function _check_modifier_strata(m::Redistribute{L}, S) where {L}
    _check_coupling(m.M, S)
    _check_columns(_movement_array(m.M), L)
    _check_intensity_strata(m.M, S)
    return nothing
end
_check_intensity_strata(M, S) = nothing
function _check_intensity_strata(M::TimeVarying{<:Any, <:_Movement}, S)
    E = M.x.E
    E isa AbstractMatrix || _check_param_strata(:ε, E, S)
    return nothing
end
_movement_array(M::AbstractMatrix) = M
_movement_array(M::TimeVarying) = M.x
function _check_columns(A, leak)
    tol = sqrt(eps(float(_primal_type(eltype(A)))))
    lo, hi = _column_sum_range(A)
    ok = leak ? hi <= 1 + tol : (abs(lo - 1) <= tol && abs(hi - 1) <= tol)
    ok || _columns_error(leak, lo, hi)
    return nothing
end
# The smallest and largest column sums over every column (and time): one
# pass over a host array, a reduction elsewhere.
_column_sum_range(A) = extrema(sum(A; dims = 1))
function _column_sum_range(A::Array)
    cs = CartesianIndices(Base.tail(axes(A)))
    lo = hi = _column_sum(A, first(cs))
    for c in cs
        o = _column_sum(A, c)
        lo, hi = min(lo, o), max(hi, o)
    end
    return lo, hi
end
function _column_sum(A, c)
    o = zero(eltype(A))
    for a in axes(A, 1)
        o += A[a, c]
    end
    return o
end
@noinline function _columns_error(leak, lo, hi)
    throw(
        ArgumentError(
            "every column of M must sum to " * (leak ? "at most one" : "one") *
                (leak ? "" : " (or pass leak = true for columns that lose a share)") *
                "; the column sums range over $((lo, hi))"
        )
    )
end
pullback!(grads, ::Redistribute, ::Init, s, history) = nothing

# The product `s = M v`, then each stratum keeps its own share and the
# arrivals are what the others sent.
function forward!(m::Redistribute, ::Step, v, s, t)
    _stays(m.M) && return (fill!(s, zero(eltype(s))); nothing)
    forward!(m.M, Pressure(), s, v, t)
    S = length(eachindex(v, s))
    _each!(_redistribute_body!, Serial(), v, S, S, v, s, m.M, t)
    return nothing
end
function _redistribute_body!(p, v, s, M, t)
    kept = _diag_at(M, p, t) * v[p]
    v[p] = s[p]
    s[p] -= kept
    return nothing
end
_diag_at(M::AbstractMatrix, p, t) = M[p, p]
_diag_at(M::TimeVarying, p, t) = M.x[p, p, t]

# `v′ = M v` and `s′ = M v − diag(M) ∘ v`, so with `q̄ = v̄′ + s̄′` the
# input's cotangent is `Mᵀ q̄ − diag(M) ∘ s̄′` and the matrix's
# `q̄ vᵀ − diag(s̄′ ∘ v)`: the coupling's own transposed product, started
# from the diagonal term.
function pullback!(grads, m::Redistribute, ::Step, v, s, t)
    M = m.M
    v̄, s̄ = grads.v, grads.s
    _stays(M) && return (fill!(s̄, zero(eltype(s̄))); nothing)
    M̄ = cotangent(grads.piece, :M)
    for p in eachindex(v, v̄, s̄)
        s̄p = s̄[p]
        s̄[p] = v̄[p] + s̄p
        # The diagonal is read only when the state's cotangent asks for it.
        if iszero(s̄p)
            v̄[p] = zero(eltype(v̄))
        else
            v̄[p] = -_diag_at(M, p, t) * s̄p
            _add_diag!(M̄, M, -s̄p * v[p], p, t)
        end
    end
    pullback!((; piece = M̄, q = s̄, p = v̄), M, Pressure(), s̄, v, t)
    fill!(s̄, zero(eltype(s̄)))
    return nothing
end
_add_diag!(M̄, M::AbstractMatrix, x, p, t) = _add_entry!(M̄, M, x, p, p)
_add_diag!(M̄, M::TimeVarying, x, p, t) = add_cotangent!(cotangent(M̄, :x), x, p, p, t)
function _add_diag!(M̄, M::TimeVarying{<:Any, <:_Movement}, x, p, t)
    return _add_movement_entry!(cotangent(M̄, :x), M.x, x, p, p, t)
end

# Clamp -------------------------------------------------------------------

@doc raw"""
Clamps each stratum's value to `[lo, hi]`, as `clamp`.

For each [stratum](@ref PerStratum) ``i`` at absolute time ``t``,

```math
v'_{t,i} = \min\big(\max(v_{t,i},\ \ell_{t,i}),\ u_{t,i}\big),
```

where ``v_{t,i}`` is the value entering the modifier, ``v'_{t,i}`` the value
it passes on, and ``\ell_{t,i} \le u_{t,i}`` the bounds `lo` and `hi` read
at stratum ``i`` and time ``t``.

`lo` and `hi` are each a [parameter](@ref ComposableRecurrences.param).
The state is unused.

# Arguments
- `lo`: the lower bound.
- `hi`: the upper bound.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
Recurrence([2.0]; modifiers = (CR.Clamp(0.0, 5.0),))(1.0; history = [1.0], stop = 4)

# output

4-element Vector{Float64}:
 2.0
 4.0
 5.0
 5.0
```
"""
struct Clamp{L, H}
    "The lower bound, a parameter."
    lo::L
    "The upper bound, a parameter."
    hi::H
    function Clamp(lo::L, hi::H) where {L, H}
        return new{L, H}(_check_param(:lo, lo), _check_param(:hi, hi))
    end
end

blocks(::Clamp) = (1, 1)
_stateless(::Clamp) = true
forward!(m::Clamp, ::Init, s, history) = _zero_state!(s, :lo => m.lo, :hi => m.hi)
pullback!(grads, ::Clamp, ::Init, s, history) = nothing

function forward!(m::Clamp, ::Step, v, s, t)
    for k in eachindex(v)
        v[k] = clamp(v[k], param(m.lo, k, t), param(m.hi, k, t))
    end
    return nothing
end

# Matches `clamp`'s branches: above `hi`, then below `lo`, else `v`.
function pullback!(grads, m::Clamp, ::Step, v, s, t)
    v̄ = grads.v
    for k in eachindex(v)
        if v[k] > param(m.hi, k, t)
            add_param!(cotangent(grads.piece, :hi), m.hi, v̄[k], k, t)
            v̄[k] = zero(v̄[k])
        elseif v[k] < param(m.lo, k, t)
            add_param!(cotangent(grads.piece, :lo), m.lo, v̄[k], k, t)
            v̄[k] = zero(v̄[k])
        end
    end
    return nothing
end
