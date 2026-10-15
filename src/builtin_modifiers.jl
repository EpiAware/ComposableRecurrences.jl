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
# strata.
function _zero_state!(s, params::Pair...)
    for (name, x) in params
        _check_param_strata(name, x, length(s))
    end
    fill!(s, zero(eltype(s)))
    return nothing
end

# Depletion ---------------------------------------------------------------

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

The default form of [`ComposableRecurrences.Depletion`](@ref).

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
y, s = CR.forward(CR.Hazard(), CR.Step(), 2.0, 80.0, 100.0, 1.0)
round(y; digits = 3), round(s; digits = 3)

# output

(1.584, 78.416)
```
"""
struct Hazard end

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

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
CR.forward(CR.Floor(), CR.Step(), 2.0, 80.0, 100.0, 1.0)

# output

(1.6, 78.4)
```
"""
struct Floor end

@doc raw"""
Susceptible depletion: each stratum's new values are drawn from a pool
that starts at `pool0` and shrinks by what is drawn.

For each stratum ``i`` (see [`PerStratum`](@ref)) and absolute time
``t`` from the call's first time ``t_0``,

```math
s_{t_0 - 1, i} = s_{0,i}, \qquad
(v'_{t,i},\ s^{*}_{t,i}) = F\big(v_{t,i},\ s_{t-1,i},\ N_{t,i},\ \alpha\big),
\qquad s_{t,i} = \Phi_{t,i}\big(s^{*}_{t,i}\big),
```

where ``v_{t,i}`` is the value entering the modifier, ``v'_{t,i}`` the value
it passes on, ``s_{t,i}`` the pool after step ``t``, ``s_{0,i}`` the starting
pool `pool0` (``N_{1,i}`` by default), ``N_{t,i}`` the population at time
``t``, ``\alpha`` the heterogeneity exponent, ``F`` the form's
`forward(form, Step(), v, s, N, α)` and ``\Phi_{t,i}`` the `flows` after
the draw: the compartments after the step of
[`ComposableRecurrences.Flows`](@ref), with the pool as compartment 1 and
a [`ComposableRecurrences.Protected`](@ref) pool as compartment 2.
So `Flow(2 => 1, ω)` is waning protection at rate ``\omega`` and
`Flow(1 => 0, μ)` removes susceptibles at rate ``\mu``.
Rate and share flows act on the pools after the draw, then the count
flows in order on what remains.
The `removals` are the first count flow, `Flow(1 => 0, Amount(removals))`,
or `Flow(1 => 2, Amount(removals))` with a protected pool.
Rate and share flows are not capped, so a rate out of a pool the draw has
taken below zero moves a negative amount.

The form is a variant struct that draws value `v` from pool `s` with
population `N` and heterogeneity exponent `α` through
`forward(form, Step(), v, s, N, α)`:
[`ComposableRecurrences.Hazard`](@ref) (the default),
[`ComposableRecurrences.Floor`](@ref),
[`ComposableRecurrences.Truncate`](@ref),
[`ComposableRecurrences.SoftTruncate`](@ref), or a new type with that
method.
[A depletion form](@ref extending-form) writes a new form, and
[Rules and plain AD](@ref adjoint-routing) gives the gradient of one without
a `pullback!`.
`α > 1` depletes faster as the pool shrinks (heterogeneous mixing).
The state is the pool; the hazard fraction divides by `N` whatever the
pool starts at.

A population that changes over time, through births, deaths or turnover,
is a `TimeVarying` `N`, with arrivals as negative `removals` and
susceptible departures as positive ones.
The step reads `N` at its own time, and the pool is not rescaled when `N`
changes: arrivals enter the pool only through the flows.

# Arguments
- `N`: the population, a [parameter](@ref ComposableRecurrences.param)
  read at each step's stratum and time.
- `form`: the depletion form; `Hazard()` by default.

# Keyword Arguments
- `heterogeneity`: the exponent `α`.
  The default is `true` for the built-in forms, an exponent of exactly one
  that is not a parameter, so their steps skip the power, and `1` for other
  forms.
  For the built-in forms `true` and `false` stay fixed; any other integer
  takes the population's float type.
  Pass a float to differentiate the exponent.
- `pool0`: the starting pool, one value or `PerStratum`; `N` at time 1 by
  default.
  A seed drawn from the pool is `pool0 = max(N - sum(seed), 0)`.
- `removals`: values taken out of the pool at each step, capped by what
  remains, as the first count flow above; a parameter, or `nothing` for
  none.
  A negative removal adds to the pool, without a cap.
- `protected`: a [`ComposableRecurrences.Protected`](@ref) pool that the
  removals move into and that is drawn from at a relative susceptibility,
  or `nothing` for none.
- `flows`: [`ComposableRecurrences.Flow`](@ref)s between the pools,
  numbered and ordered as above; a tuple or vector, none by default.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
seed = [1.0, 2.0]
depletion = CR.Depletion(100.0; pool0 = 100.0 - sum(seed))
y = Recurrence([0.5, 0.5]; modifiers = (depletion,))(fill(2.0, 8); history = seed)
round.(y; digits = 3)

# output

8-element Vector{Float64}:
  2.867
  4.472
  6.344
  8.541
 10.342
 11.087
 10.29
  8.287
```

Leaky vaccination gives 5 doses a step, and the protection wanes back to
the pool at rate 0.1.

```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
d = CR.Depletion(
    1000.0; removals = 5.0, protected = CR.Protected(0.3),
    flows = CR.Flow(2 => 1, 0.1)
)
y = Recurrence([0.3, 0.5, 0.2]; modifiers = (d,))(fill(2.0, 6); history = [5.0])
round.(y; digits = 3)

# output

6-element Vector{Float64}:
  2.996
  6.73
  8.846
 12.779
 18.196
 25.151
```

A herd of 100 with 3 births a step: `N` grows by the births, and the births
enter the pool as negative removals.

```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
births = fill(3.0, 8)
N = TimeVarying(100.0 .+ cumsum(births))
herd = CR.Depletion(N; pool0 = 90.0, removals = TimeVarying(-births))
y = Recurrence([0.5, 0.5]; modifiers = (herd,))(fill(1.5, 8); history = [5.0, 5.0])
round.(y; digits = 3)

# output

8-element Vector{Float64}:
 6.32
 6.672
 7.099
 6.951
 6.563
 5.876
 5.085
 4.261
```
"""
struct Depletion{F, P, A, P0, R <: Tuple, V}
    "The population, a parameter read at each step's stratum and time."
    N::P
    "The depletion form."
    form::F
    "The heterogeneity exponent α."
    heterogeneity::A
    "The starting pool, or `nothing` for `N`."
    pool0::P0
    "The flows between the pools after the draw, removals first."
    flows::R
    "The protected pool, or `nothing`."
    protected::V
    function Depletion(
            N::P, form::F, heterogeneity::A, pool0::P0, flows::R,
            protected::V
        ) where {P, F, A, P0, R, V}
        _check_form(form)
        _check_pool_flows(flows, protected)
        return new{F, P, A, P0, R, V}(
            N, form, heterogeneity, pool0, flows, protected
        )
    end
end

function Depletion(
        N, form = Hazard(); heterogeneity = _unit_exponent(form), pool0 = nothing,
        removals = nothing, protected = nothing, flows = ()
    )
    N = _population(N)
    pool0 = pool0 === nothing ? nothing :
        _float_param(_check_constant(:pool0, pool0))
    protected === nothing || protected isa Protected || throw(
        ArgumentError(
            "protected must be a Protected pool or nothing, got " *
                _describe(protected)
        )
    )
    fs = (_removal_flows(removals, protected)..., _pool_flows(flows)...)
    return Depletion(
        N, form, _exponent(heterogeneity, N, form), pool0, fs, protected
    )
end

# The population: any parameter, read at each step's stratum and time.
_population(N) = _float_param(_check_param(:N, N))

# A form is a type with a scalar Step, for generic reals or one float type.
function _check_form(form::F) where {F}
    _is_form(F) || throw(
        ArgumentError(
            "$(_describe(form)) is not a depletion form: a form implements " *
                "forward(form, Step(), v, s, N, α) -> (y, s′)"
        )
    )
    return nothing
end
function _is_form(::Type{F}) where {F}
    return hasmethod(forward, Tuple{F, Step, Vararg{Real, 4}}) ||
        hasmethod(forward, Tuple{F, Step, Vararg{Float64, 4}}) ||
        hasmethod(forward, Tuple{F, Step, Vararg{Float32, 4}})
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

# An integer exponent takes the population's float type, so it has a
# cotangent and a Float32 population stays Float32. A dual population gives
# its primal type: a dual exponent with zero partials makes
# `(s / N)^(α - 1)` carry `log(0) * 0 = NaN` at an empty pool. The built-in
# forms keep a `Bool` exponent as a fixed one, without a cotangent.
_exponent(α::Integer, N, form) = convert(float(_primal_type(param_eltype(N))), α)
_exponent(α::Bool, N, ::Union{Hazard, Floor}) = _FixedExponent{α}()
_exponent(α, N, form) = α

# A fixed `Bool` exponent held in the type, so a `Depletion` stores no byte
# for it. An AD tool's type analysis can reject a `Bool` field stored into a
# tuple of modifiers when the construction is compiled into the loss. The
# steps read it back as the `Bool` constant `B`.
# A float exponent with an `isone` branch in the steps was measured in its
# place: the reverse passes were up to 16% slower and allocated more, as
# they still take the exponent's `log` term, so the fixed form stays.
struct _FixedExponent{B} end
_exponent_value(::_FixedExponent{B}) where {B} = B
_exponent_value(α) = α

# The default exponent: a fixed exponent of one for the built-in forms, not
# a parameter, so their steps skip the power and its derivative; `1` for
# other forms, which may type their exponent as a float.
_unit_exponent(form) = 1
_unit_exponent(::Union{Hazard, Floor}) = _FixedExponent{true}()

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

function forward(::Hazard, ::Step, v, s, N, α)
    x = v / N * _share_power(s / N, α)
    e, em = _exp_neg(x)
    return -s * em, s * e
end

# `(exp(-x), expm1(-x))` from one exponential: `expm1` below `1/2`, where
# it keeps the digits `1 - e^{-x}` would lose and `1 + expm1(-x)` loses
# none, and `exp` above, where neither subtraction cancels. Plain floats
# and dual numbers branch on their value; a traced number would fix the
# branch when its trace is recorded, or reject it, so takes both.
_exp_neg(x) = (exp(-x), expm1(-x))
function _exp_neg(x::Union{AbstractFloat, ForwardDiff.Dual})
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
# With a dual exponent the power at an empty pool takes the primal
# exponent. A dual exponent is never traced, so a branch computes only one
# power.
function _pool_power(r, e::ForwardDiff.Dual)
    _primal_value(r) <= 0 || return r^e
    return convert(promote_type(typeof(r), typeof(e)), r^_primal_value(e))
end

function pullback!(grads, ::Hazard, ::Step, v, s, N, α)
    ȳ, s̄′ = grads.v, grads.s
    r = s / N
    h = _power_m1(r, α)
    x = v / N * h
    e, em = _exp_neg(x)
    x̄ = s * e * (ȳ - s̄′)
    s̄ = -ȳ * em + s̄′ * e
    α == 1 || (s̄ += e * (ȳ - s̄′) * (α - 1) * x)
    ᾱ = _primal_value(r) <= 0 ? zero(x̄ * x) : _times_log(α, r, x̄ * x)
    return x̄ * h / N, s̄, -x̄ * α * x / N, ᾱ
end

const _DEPLETION_FLOOR = 1.0e-6

function forward(::Floor, ::Step, v, s, N, α)
    r = s / N
    f = max(_floor_power(max(r, zero(r)), α), oftype(r, _DEPLETION_FLOOR))
    y = f * v
    return y, s - y
end

function pullback!(grads, ::Floor, ::Step, v, s, N, α)
    ȳ, s̄′ = grads.v, grads.s
    r = s / N
    p = _floor_power(max(r, zero(r)), α)
    fl = oftype(p, _DEPLETION_FLOOR)
    ḡ = ȳ - s̄′
    p > fl || return ḡ * fl, s̄′, zero(ḡ), zero(ḡ)
    f̄ = ḡ * v
    ᾱ = _primal_value(r) <= 0 ? zero(f̄ * p) : _times_log(α, r, f̄ * p)
    return ḡ * p, s̄′ + f̄ * α * _power_m1(r, α) / N, -f̄ * α * p / N, ᾱ
end

# A depletion is pointwise unless its pools make it blockwise.
ispointwise(m::Depletion) = blocks(m) === nothing

# The starting pool of stratum `k` and its cotangent slot.
_pool0(m::Depletion{<:Any, <:Any, <:Any, Nothing}, k) = param(m.N, k, 1)
_pool0(m::Depletion, k) = param(m.pool0, k, 1)
function _add_pool0!(m̄, m::Depletion{<:Any, <:Any, <:Any, Nothing}, x, k)
    return add_param!(cotangent(m̄, :N), m.N, x, k, 1)
end
function _add_pool0!(m̄, m::Depletion, x, k)
    return add_param!(cotangent(m̄, :pool0), m.pool0, x, k, 1)
end

function forward(m::Depletion, ::Init, s, history)
    _check_param_strata(:N, m.N, length(s))
    _check_param_strata(:pool0, m.pool0, length(s))
    _check_flow_groups(m.flows, length(s))
    _each!(_pool0_body!, Serial(), s, length(s), length(s), s, m)
    return nothing
end

function _pool0_body!(k, s, m)
    s[k] = _pool0(m, k)
    return nothing
end

function pullback!(grads, m::Depletion, ::Init, s, history)
    for k in eachindex(grads.s)
        _add_pool0!(grads.piece, m, grads.s[k], k)
    end
    return nothing
end

# A depletion with neither flows nor a protected pool. Flows, the removals
# among them, and the protected pool have methods of their own.
const _Depleting = Depletion{<:Any, <:Any, <:Any, <:Any, Tuple{}, Nothing}

function forward(m::_Depleting, ::Step, v, s, t, k)
    return forward(
        m.form, Step(), v, s, param(m.N, k, t), _exponent_value(m.heterogeneity)
    )
end

function pullback!(grads, m::_Depleting, ::Step, v, s, t, k)
    m̄ = grads.piece
    v̄, s̄, N̄, ᾱ = _form_pullback(
        (; piece = cotangent(m̄, :form), v = grads.v, s = grads.s), m.form,
        v, s, param(m.N, k, t), _exponent_value(m.heterogeneity)
    )
    add_param!(cotangent(m̄, :N), m.N, N̄, k, t)
    add_cotangent!(cotangent(m̄, :heterogeneity), ᾱ)
    return v̄, s̄
end

# Add ---------------------------------------------------------------------

@doc raw"""
Adds `b` to each stratum's value wherever the modifier sits in the tuple:
after a [`ComposableRecurrences.Depletion`](@ref), the added values are
neither scaled by nor drawn from the pool.

For each stratum ``i`` (see [`PerStratum`](@ref)) at absolute time ``t``,

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

ispointwise(::Add) = true
_stateless(::Add) = true
forward(m::Add, ::Init, s, history) = _zero_state!(s, :b => m.b)
pullback!(grads, ::Add, ::Init, s, history) = nothing

forward(m::Add, ::Step, v, s, t, k) = (v + param(m.b, k, t), s)

function pullback!(grads, m::Add, ::Step, v, s, t, k)
    add_param!(cotangent(grads.piece, :b), m.b, grads.v, k, t)
    return grads.v, grads.s
end

# Redistribute ------------------------------------------------------------

@doc raw"""
Moves a share of each stratum's value to others through a movement matrix
whose columns sum to one, so the total is conserved.

For each stratum ``i`` (see [`PerStratum`](@ref)) at absolute time ``t``,

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
``g_t \odot q_t + a_t``, the gain times the coupled pressure plus the add
input, so the `add` values move too.
The step is the coupling product ``M_t v``, and its reverse pass the
transposed product, ``\bar v = M_t^\top \bar v'`` and
``\bar M_t \mathrel{+}= \bar v' v^\top``.

# Arguments
- `M`: the movement matrix, `M[p, q]` the share of origin `q` realised in
  destination `p`.

# Keyword Arguments
- `leak`: allow columns summing to less than one. Defaults to `false`.

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
Redistribute(M; leak::Bool = false) = Redistribute{leak}(M)
function Redistribute(K, ε)
    throw(
        ArgumentError(
            "Redistribute takes one movement matrix; for a kernel K and an " *
                "intensity ε use Redistribute(movement(K, ε))"
        )
    )
end
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
The array is held as ``K``, ``\varepsilon`` and the column sums ``o`` and
read from them, so a step costs one product with ``K`` and its reverse pass
gives the cotangents of ``K`` and ``\varepsilon`` without storing a matrix
per time.

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
# with `o` the column sums of `K`. Its columns sum to one by construction.
# It is a struct of its arrays, not an array, so the rules read its
# cotangent field by field.
struct _Movement{KT <: AbstractMatrix, ET <: AbstractMatrix, OT <: AbstractVector}
    K::KT
    E::ET
    o::OT
end
function _Movement(K::AbstractMatrix, E::AbstractMatrix)
    size(K, 1) == size(K, 2) == size(E, 1) || throw(
        DimensionMismatch(
            "K is $(size(K)) and ε is $(size(E)); expected S × S and S × T"
        )
    )
    return _Movement(K, E, vec(sum(K; dims = 1)))
end
Base.size(m::_Movement) = (size(m.K, 1), size(m.K, 2), size(m.E, 2))
Base.size(m::_Movement, d::Integer) = size(m)[d]
Base.ndims(::_Movement) = 3
function Base.getindex(m::_Movement, p::Integer, q::Integer, t::Integer)
    e = m.E[q, t]
    return (p == q) * (1 - e * m.o[q]) + m.K[p, q] * e
end
_over_time(::_Movement) = true
_array(m::_Movement) = m
_extent(m::_Movement) = size(m.E, 2)
_check_coupling_shape(::TimeVarying{Secondary, <:_Movement}) = nothing
_check_columns(::_Movement, leak) = nothing
# With one stratum a movement of a kernel and an intensity is the identity
# whatever their values (`1 − ε o + K ε` with `o = K`), so nothing moves and
# neither has a gradient: the step passes the value on with no arrivals.
_stays(M) = false
_stays(M::TimeVarying{<:Any, <:_Movement}) = size(M.x.K, 1) == 1

# The step reads `M_t v = (1 − E_t ∘ o) ∘ v + K (E_t ∘ v)`.
function forward(C::TimeVarying{Secondary, <:_Movement}, ::Pressure, q, p, t)
    (; K, E, o) = C.x
    checkbounds(E, :, t)
    _check_pressure(K, q, p)
    fill!(q, zero(eltype(q)))
    for b in axes(K, 2)
        w = E[b, t] * p[b]
        for a in axes(K, 1)
            q[a] += K[a, b] * w
        end
    end
    for a in eachindex(q, p)
        q[a] += (1 - E[a, t] * o[a]) * p[a]
    end
    return nothing
end

# With `c = Kᵀ q̄`: `p̄ += E_t ∘ c + (1 − E_t ∘ o) ∘ q̄`, `K̄ += q̄ (E_t ∘ p)ᵀ`,
# `Ē_t += p ∘ (c − o ∘ q̄)` and `ō −= E_t ∘ p ∘ q̄`.
function pullback!(
        grads, C::TimeVarying{Secondary, <:_Movement}, ::Pressure, q, p, t
    )
    X̄ = cotangent(grads.piece, :x)
    q̄, p̄ = grads.q, grads.p
    (; K, E, o) = C.x
    K̄, Ē, ō = cotangent(X̄, :K), cotangent(X̄, :E), cotangent(X̄, :o)
    for b in axes(K, 2)
        c = zero(eltype(p̄))
        w = E[b, t] * p[b]
        for a in axes(K, 1)
            c += K[a, b] * q̄[a]
            add_cotangent!(K̄, q̄[a] * w, a, b)
        end
        p̄[b] += E[b, t] * c + (1 - E[b, t] * o[b]) * q̄[b]
        add_cotangent!(Ē, p[b] * (c - o[b] * q̄[b]), b, t)
        add_cotangent!(ō, -w * q̄[b], b)
    end
    return nothing
end

# Entry `(a, b)` at `t` of the mirror of a movement's array.
_add_movement_entry!(::Nothing, X::_Movement, x, a, b, t) = nothing
function _add_movement_entry!(X̄, X::_Movement, x, a, b, t)
    e = X.E[b, t]
    add_cotangent!(cotangent(X̄, :K), x * e, a, b)
    add_cotangent!(cotangent(X̄, :E), x * (X.K[a, b] - (a == b) * X.o[b]), b, t)
    a == b && add_cotangent!(cotangent(X̄, :o), -x * e, b)
    return nothing
end

# The matrix is checked against the strata, and its columns, once, here
# and on a resumed state, not on every step.
function forward(m::Redistribute, ::Init, s, history)
    _check_modifier_strata(m, length(s))
    fill!(s, zero(eltype(s)))
    return nothing
end
function _check_modifier_strata(m::Redistribute{L}, S) where {L}
    _check_coupling(m.M, S)
    _check_columns(_movement_array(m.M), L)
    return nothing
end
_movement_array(M::AbstractMatrix) = M
_movement_array(M::TimeVarying) = M.x
function _check_columns(A, leak)
    tol = sqrt(eps(float(_primal_type(eltype(A)))))
    sums = sum(A; dims = 1)
    ok = leak ? all(<=(1 + tol), sums) : all(x -> abs(x - 1) <= tol, sums)
    ok || throw(
        ArgumentError(
            "every column of M must sum to " * (leak ? "at most one" : "one") *
                (leak ? "" : " (or pass leak = true for columns that lose a share)") *
                "; the column sums range over $(extrema(sums))"
        )
    )
    return nothing
end
pullback!(grads, ::Redistribute, ::Init, s, history) = nothing

# The product `s = M v`, then each stratum keeps its own share and the
# arrivals are what the others sent.
function forward(m::Redistribute, ::Step, v, s, t)
    _stays(m.M) && return (fill!(s, zero(eltype(s))); nothing)
    forward(m.M, Pressure(), s, v, t)
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
        v̄[p] = -_diag_at(M, p, t) * s̄p
        iszero(s̄p) || _add_diag!(M̄, M, -s̄p * v[p], p, t)
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

For each stratum ``i`` (see [`PerStratum`](@ref)) at absolute time ``t``,

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

ispointwise(::Clamp) = true
_stateless(::Clamp) = true
forward(m::Clamp, ::Init, s, history) = _zero_state!(s, :lo => m.lo, :hi => m.hi)
pullback!(grads, ::Clamp, ::Init, s, history) = nothing

function forward(m::Clamp, ::Step, v, s, t, k)
    return clamp(v, param(m.lo, k, t), param(m.hi, k, t)), s
end

# Matches `clamp`'s branches: above `hi`, then below `lo`, else `v`.
function pullback!(grads, m::Clamp, ::Step, v, s, t, k)
    v̄′, s̄′ = grads.v, grads.s
    if v > param(m.hi, k, t)
        add_param!(cotangent(grads.piece, :hi), m.hi, v̄′, k, t)
        return zero(v̄′), s̄′
    elseif v < param(m.lo, k, t)
        add_param!(cotangent(grads.piece, :lo), m.lo, v̄′, k, t)
        return zero(v̄′), s̄′
    end
    return v̄′, s̄′
end

# The built-in modifiers and depletion forms carry their adjoints through
# their `pullback!` methods; a depletion uses its own when its form does or
# the form's local derivative covers it (see `_form_pullback`).
uses_adjoint(m::Depletion, ::Step) = _form_adjoint(m.form)
