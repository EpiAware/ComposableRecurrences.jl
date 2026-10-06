# The built-in modifiers and depletion forms. A `pullback!`'s `grads.piece`
# mirrors the object's fields as a NamedTuple: an array for a float array, a
# `Ref` for a float scalar, a NamedTuple for a wrapper such as `TimeVarying`,
# and `nothing` for a field without a cotangent.
#
# A parameter is one value, `PerStratum` (one per stratum),
# `TimeVarying` (one per time) or `TimeVarying(PerStratum(x))` (strata ×
# time); every built-in modifier reads its parameters through `_param`.


# A parameter at stratum `k` and absolute time `t`, and its cotangent.
_param(x::Real, k, t) = x
_param(x::PerStratum, k, t) = x.x[k]
_param(x::TimeVarying{<:Any, <:AbstractVector}, k, t) = x.x[t]
_param(x::TimeVarying{<:Any, <:PerStratum}, k, t) = x.x.x[k, t]
_add_param!(x̄, ::Real, v, k, t) = add_cotangent!(x̄, v)
_add_param!(x̄, ::PerStratum, v, k, t) = add_cotangent!(x̄, v, k)
function _add_param!(x̄, ::TimeVarying{<:Any, <:AbstractVector}, v, k, t)
    return add_cotangent!(x̄, v, t)
end
function _add_param!(x̄, ::TimeVarying{<:Any, <:PerStratum}, v, k, t)
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
function _check_param(name, x::TimeVarying{Primary})
    throw(
        ArgumentError(
            "$name: Primary() indexing is only meaningful for a kernel; " *
                "got $(_describe(x))"
        )
    )
end
function _check_param(name, x)
    throw(
        ArgumentError(
            "$name is one value, PerStratum($name) with one per stratum, " *
                "TimeVarying($name) with one per time, or " *
                "TimeVarying(PerStratum($name)) strata × time; got " *
                _describe(x)
        )
    )
end

# Check a parameter against `S` strata.
_check_param_strata(name, x, S) = nothing
_check_param_strata(name, x::TimeVarying, S) = _check_param_strata(name, x.x, S)
function _check_param_strata(name, x::PerStratum, S)
    size(x.x, 1) == S || throw(
        DimensionMismatch("$name has $(size(x.x, 1)) strata, expected $S")
    )
    return nothing
end

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
```@example
using ComposableRecurrences
CR = ComposableRecurrences
CR.forward(CR.Hazard(), CR.Step(), 2.0, 80.0, 100.0, 1.0)
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
```@example
using ComposableRecurrences
CR = ComposableRecurrences
CR.forward(CR.Floor(), CR.Step(), 2.0, 80.0, 100.0, 1.0)
```
"""
struct Floor end

@doc raw"""
Susceptible depletion: each stratum's new values are drawn from a pool
that starts at `pool0` and shrinks by what is drawn.

For each stratum ``i`` (one of ``S`` parallel series) and absolute time
``t`` from the call's first time ``t_0``,

```math
s_{t_0 - 1, i} = s_{0,i}, \qquad
(v'_{t,i},\ s_{t,i}) = F\big(v_{t,i},\ s_{t-1,i},\ N_i,\ \alpha\big),
```

where ``v_{t,i}`` is the value entering the modifier, ``v'_{t,i}`` the value
it passes on, ``s_{t,i}`` the pool after step ``t``, ``s_{0,i}`` the starting
pool `pool0` (``N_i`` by default), ``N_i`` the population, ``\alpha`` the
heterogeneity exponent and ``F`` the form's
`forward(form, Step(), v, s, N, α)`.

The form is a variant struct that draws value `v` from pool `s` with
population `N` and heterogeneity exponent `α` through
`forward(form, Step(), v, s, N, α)`:
[`ComposableRecurrences.Hazard`](@ref) (the default),
[`ComposableRecurrences.Floor`](@ref), or a new type with that method.
A new form without a `pullback!` is differentiated locally with
`ForwardDiff` in ``(v, s, N, \alpha)`` and its own float scalars.
`α > 1` depletes faster as the pool shrinks (heterogeneous mixing).
The state is the pool; the hazard fraction divides by `N` whatever the
pool starts at.

# Arguments
- `N`: the population, one value or [`PerStratum`](@ref), constant over
  time: a `TimeVarying` `N` is an `ArgumentError`.
- `form`: the depletion form; `Hazard()` by default.

# Keyword Arguments
- `heterogeneity`: the exponent `α`; `1` by default.
- `pool0`: the starting pool, one value or `PerStratum`; `N` by default.
  A seed drawn from the pool is `pool0 = max(N - sum(seed), 0)`.
- `removals`: values taken out of the pool after each step's draw, capped
  by what remains; a parameter (one value, `PerStratum`, `TimeVarying` or
  `TimeVarying(PerStratum(r))`), or `nothing` for none.
- `protected`: a [`ComposableRecurrences.Protected`](@ref) pool that the
  removals move into and that is drawn from at a relative susceptibility,
  or `nothing` for none.

# Examples
```@example
using ComposableRecurrences
CR = ComposableRecurrences
seed = [1.0, 2.0]
depletion = CR.Depletion(100.0; pool0 = 100.0 - sum(seed))
Recurrence([0.5, 0.5]; modifiers = (depletion,))(fill(2.0, 8); history = seed)
```
"""
struct Depletion{F, P, A, P0, R, V}
    "The population, one value or `PerStratum`."
    N::P
    "The depletion form."
    form::F
    "The heterogeneity exponent α."
    heterogeneity::A
    "The starting pool, or `nothing` for `N`."
    pool0::P0
    "The removals, or `nothing`."
    removals::R
    "The protected pool, or `nothing`."
    protected::V
    function Depletion(
            N::P, form::F, heterogeneity::A, pool0::P0, removals::R,
            protected::V
        ) where {P, F, A, P0, R, V}
        _check_form(form)
        return new{F, P, A, P0, R, V}(
            N, form, heterogeneity, pool0, removals, protected
        )
    end
end

function Depletion(
        N, form = Hazard(); heterogeneity = 1, pool0 = nothing,
        removals = nothing, protected = nothing
    )
    N = _float_param(_check_constant(:N, N))
    pool0 = pool0 === nothing ? nothing :
        _float_param(_check_constant(:pool0, pool0))
    removals = removals === nothing ? nothing : _check_param(:removals, removals)
    protected === nothing || protected isa Protected || throw(
        ArgumentError(
            "protected must be a Protected pool or nothing, got " *
                _describe(protected)
        )
    )
    return Depletion(
        N, form, _exponent(heterogeneity, N), pool0, removals, protected
    )
end

# A form is a type with a scalar Step.
function _check_form(form::F) where {F}
    hasmethod(forward, Tuple{F, Step, Float64, Float64, Float64, Float64}) ||
        throw(
        ArgumentError(
            "$(_describe(form)) is not a depletion form: a form implements " *
                "forward(form, Step(), v, s, N, α) -> (y, s′)"
        )
    )
    return nothing
end

# The population and starting pool are per stratum, not over time.
_check_constant(name, x) = _check_param(name, x)
function _check_constant(name, x::TimeVarying)
    throw(
        ArgumentError(
            "$name is one value or PerStratum($name); it does not vary over " *
                "time, got $(_describe(x))"
        )
    )
end

_float_param(x::Real) = float(x)
_float_param(x::PerStratum) = PerStratum(float(x.x))

# An integer exponent takes the population's float type, so it has a
# cotangent and a Float32 population stays Float32.
_exponent(α::Integer, N) = convert(float(param_eltype(N)), α)
_exponent(α, N) = α

function forward(::Hazard, ::Step, v, s, N, α)
    x = v / N * (s / N)^(α - 1)
    return -s * expm1(-x), s * exp(-x)
end

function pullback!(grads, ::Hazard, ::Step, v, s, N, α)
    ȳ, s̄′ = grads.v, grads.s
    r = s / N
    h = r^(α - 1)
    x = v / N * h
    e = exp(-x)
    x̄ = s * e * (ȳ - s̄′)
    s̄ = -ȳ * expm1(-x) + s̄′ * e
    α == 1 || (s̄ += e * (ȳ - s̄′) * (α - 1) * x)
    ᾱ = _primal_value(r) > 0 ? x̄ * x * log(r) : zero(x̄ * x)
    return x̄ * h / N, s̄, -x̄ * α * x / N, ᾱ
end

const _DEPLETION_FLOOR = 1.0e-6

function forward(::Floor, ::Step, v, s, N, α)
    r = s / N
    f = max(max(r, zero(r))^α, oftype(r, _DEPLETION_FLOOR))
    y = f * v
    return y, s - y
end

function pullback!(grads, ::Floor, ::Step, v, s, N, α)
    ȳ, s̄′ = grads.v, grads.s
    r = s / N
    p = max(r, zero(r))^α
    fl = oftype(p, _DEPLETION_FLOOR)
    ḡ = ȳ - s̄′
    p > fl || return ḡ * fl, s̄′, zero(ḡ), zero(ḡ)
    f̄ = ḡ * v
    return ḡ * p, s̄′ + f̄ * α * r^(α - 1) / N, -f̄ * α * p / N, f̄ * p * log(r)
end

ispointwise(::Depletion) = true

# The starting pool of stratum `k` and its cotangent slot.
_pool0(m::Depletion{<:Any, <:Any, <:Any, Nothing}, k) = _param(m.N, k, 1)
_pool0(m::Depletion, k) = _param(m.pool0, k, 1)
function _add_pool0!(m̄, m::Depletion{<:Any, <:Any, <:Any, Nothing}, x, k)
    return _add_param!(cotangent(m̄, :N), m.N, x, k, 1)
end
function _add_pool0!(m̄, m::Depletion, x, k)
    return _add_param!(cotangent(m̄, :pool0), m.pool0, x, k, 1)
end

function forward(m::Depletion, ::Init, s, history)
    _check_param_strata(:N, m.N, length(s))
    _check_param_strata(:pool0, m.pool0, length(s))
    _check_param_strata(:removals, m.removals, length(s))
    for k in eachindex(s)
        s[k] = _pool0(m, k)
    end
    return nothing
end

function pullback!(grads, m::Depletion, ::Init, s, history)
    for k in eachindex(grads.s)
        _add_pool0!(grads.piece, m, grads.s[k], k)
    end
    return nothing
end

function forward(m::Depletion, ::Step, v, s, t, k)
    return forward(m.form, Step(), v, s, _param(m.N, k, t), m.heterogeneity)
end

function pullback!(grads, m::Depletion, ::Step, v, s, t, k)
    m̄ = grads.piece
    v̄, s̄, N̄, ᾱ = _form_pullback(
        (; piece = cotangent(m̄, :form), v = grads.v, s = grads.s), m.form,
        v, s, _param(m.N, k, t), m.heterogeneity
    )
    _add_param!(cotangent(m̄, :N), m.N, N̄, k, t)
    add_cotangent!(cotangent(m̄, :heterogeneity), ᾱ)
    return v̄, s̄
end

# Add ---------------------------------------------------------------------

@doc raw"""
Adds `b` to each stratum's value wherever the modifier sits in the tuple:
after a [`ComposableRecurrences.Depletion`](@ref), the added values are
neither scaled by nor drawn from the pool.

For each stratum ``i`` (one of ``S`` parallel series) at absolute time ``t``,

```math
v'_{t,i} = v_{t,i} + b_{t,i},
```

where ``v_{t,i}`` is the value entering the modifier, ``v'_{t,i}`` the value
it passes on and ``b_{t,i}`` the parameter read at stratum ``i`` and time
``t``.

`b` is a parameter: one value, [`PerStratum`](@ref), [`TimeVarying`](@ref)
(one per time, shared by every stratum) or `TimeVarying(PerStratum(B))`
with `B` strata × time, read at the absolute time.
Alone, `Add(TimeVarying(PerStratum(B)))` gives the same values as passing
`B` as `add`.
The state is unused.

# Arguments
- `b`: the values to add.

# Examples
```@example
using ComposableRecurrences
CR = ComposableRecurrences
mods = (CR.Depletion(50.0, CR.Floor()), CR.Add(TimeVarying([1.0, 0.0, 2.0])))
Recurrence([1.0]; modifiers = mods)(1.0; history = [2.0], stop = 3)
```
"""
struct Add{B}
    "The values to add: one value, `PerStratum` or `TimeVarying`."
    b::B
    Add(b::B) where {B} = new{B}(_check_param(:b, b))
end

ispointwise(::Add) = true
forward(m::Add, ::Init, s, history) = _zero_state!(s, :b => m.b)
pullback!(grads, ::Add, ::Init, s, history) = nothing

forward(m::Add, ::Step, v, s, t, k) = (v + _param(m.b, k, t), s)

function pullback!(grads, m::Add, ::Step, v, s, t, k)
    _add_param!(cotangent(grads.piece, :b), m.b, grads.v, k, t)
    return grads.v, grads.s
end

# Redistribute ------------------------------------------------------------

@doc raw"""
Moves a share of each stratum's values to others, conserving the total: a
share ``\varepsilon_{t,j} K_{ij}`` of origin ``j``'s value is realised in
destination ``i`` instead.

For each stratum ``i`` (one of ``S`` parallel series) at absolute time ``t``,

```math
\begin{aligned}
s'_i &= \sum_{j \ne i} \varepsilon_{t,j} K_{ij}\, v_j, \\
v'_i &= \Big(1 - \varepsilon_{t,i} \sum_{j \ne i} K_{ji}\Big) v_i + s'_i,
\end{aligned}
```

where ``v_i`` is the value entering the modifier, ``v'_i`` the value it
passes on, ``K_{ij}`` = `K[i, j]` the share from origin ``j`` to destination
``i``, ``\varepsilon_{t,j}`` origin ``j``'s intensity at time ``t`` and
``s'_i`` the arrivals, kept as the state.
Summing ``v'_i`` over ``i`` gives ``\sum_i v_i``.
The diagonal of `K` is not read: a stratum does not import from itself.
The intensity `ε` belongs to the origin and is a parameter: one value,
[`PerStratum`](@ref), [`TimeVarying`](@ref) or `TimeVarying(PerStratum(ε))`
with `ε` strata × time, read at the absolute time.
Place it before a [`ComposableRecurrences.Depletion`](@ref) to deplete each
stratum's pool by what it realises; a modifier sees
``g_t \odot q_t + a_t``, the gain times the coupled pressure plus the add
input, so the `add` values move too.

# Arguments
- `K`: the `S × S` kernel, `K[p, q]` from origin `q` to destination `p`.
- `ε`: the origin intensity.

# Examples
```@example
using ComposableRecurrences
CR = ComposableRecurrences
K = [0.0 0.3; 0.2 0.0]
r = Recurrence([0.5, 0.5]; modifiers = (CR.Redistribute(K, 0.1),))
r(fill(1.2, 2, 5); history = [1.0 1.0; 0.0 0.0])
```
"""
struct Redistribute{K <: AbstractMatrix, E}
    "The kernel, `K[p, q]` from origin `q` to destination `p`."
    K::K
    "The origin intensity: one value, `PerStratum` or `TimeVarying`."
    ε::E
    function Redistribute(K::M, ε::E) where {M <: AbstractMatrix, E}
        size(K, 1) == size(K, 2) || throw(
            DimensionMismatch("K is $(size(K)), expected a square matrix")
        )
        return new{M, E}(K, _check_param(:ε, ε))
    end
end

forward(m::Redistribute, ::Init, s, history) = _zero_state!(s, :ε => m.ε)
pullback!(grads, ::Redistribute, ::Init, s, history) = nothing

# Origin `q`'s total share sent away, Σ_{r ≠ q} K[r, q].
function _outflow(K, q)
    out = zero(eltype(K))
    for r in axes(K, 1)
        r == q || (out += K[r, q])
    end
    return out
end

function forward(m::Redistribute, ::Step, v, s, t)
    (; K, ε) = m
    _check_coupling(K, length(v))
    for p in eachindex(v, s)
        acc = zero(eltype(s))
        for q in eachindex(v)
            q == p || (acc += _param(ε, q, t) * K[p, q] * v[q])
        end
        s[p] = acc
    end
    for p in eachindex(v, s)
        v[p] = (1 - _param(ε, p, t) * _outflow(K, p)) * v[p] + s[p]
    end
    return nothing
end

# The arrivals `s′` feed both outputs, so their cotangent is `s̄′ + v̄′`;
# the incoming state is not read.
function pullback!(grads, m::Redistribute, ::Step, v, s, t)
    (; K, ε) = m
    v̄, s̄ = grads.v, grads.s
    K̄, ε̄ = cotangent(grads.piece, :K), cotangent(grads.piece, :ε)
    for p in eachindex(v̄, s̄)
        s̄[p] += v̄[p]
    end
    for q in eachindex(v, v̄)
        εq = _param(ε, q, t)
        out = _outflow(K, q)
        acc = zero(eltype(v̄))
        for p in eachindex(v)
            p == q && continue
            acc += s̄[p] * K[p, q]
            _add_entry!(K̄, K, εq * v[q] * (s̄[p] - v̄[q]), p, q)
        end
        _add_param!(ε̄, ε, v[q] * (acc - v̄[q] * out), q, t)
        v̄[q] = v̄[q] * (1 - εq * out) + εq * acc
    end
    fill!(s̄, zero(eltype(s̄)))
    return nothing
end

# Clamp -------------------------------------------------------------------

@doc raw"""
Clamps each stratum's value to `[lo, hi]`, as `clamp`.

For each stratum ``i`` (one of ``S`` parallel series) at absolute time ``t``,

```math
v'_{t,i} = \min\big(\max(v_{t,i},\ \ell_{t,i}),\ u_{t,i}\big),
```

where ``v_{t,i}`` is the value entering the modifier, ``v'_{t,i}`` the value
it passes on, and ``\ell_{t,i} \le u_{t,i}`` the bounds `lo` and `hi` read
at stratum ``i`` and time ``t``.

`lo` and `hi` are parameters: each one value, [`PerStratum`](@ref),
[`TimeVarying`](@ref) or `TimeVarying(PerStratum(x))`.
The state is unused.

# Arguments
- `lo`: the lower bound.
- `hi`: the upper bound.

# Examples
```@example
using ComposableRecurrences
CR = ComposableRecurrences
Recurrence([2.0]; modifiers = (CR.Clamp(0.0, 5.0),))(1.0; history = [1.0], stop = 4)
```
"""
struct Clamp{L, H}
    "The lower bound, one value, `PerStratum` or `TimeVarying`."
    lo::L
    "The upper bound, one value, `PerStratum` or `TimeVarying`."
    hi::H
    function Clamp(lo::L, hi::H) where {L, H}
        return new{L, H}(_check_param(:lo, lo), _check_param(:hi, hi))
    end
end

ispointwise(::Clamp) = true
forward(m::Clamp, ::Init, s, history) = _zero_state!(s, :lo => m.lo, :hi => m.hi)
pullback!(grads, ::Clamp, ::Init, s, history) = nothing

function forward(m::Clamp, ::Step, v, s, t, k)
    return clamp(v, _param(m.lo, k, t), _param(m.hi, k, t)), s
end

# Matches `clamp`'s branches: above `hi`, then below `lo`, else `v`.
function pullback!(grads, m::Clamp, ::Step, v, s, t, k)
    v̄′, s̄′ = grads.v, grads.s
    if v > _param(m.hi, k, t)
        _add_param!(cotangent(grads.piece, :hi), m.hi, v̄′, k, t)
        return zero(v̄′), s̄′
    elseif v < _param(m.lo, k, t)
        _add_param!(cotangent(grads.piece, :lo), m.lo, v̄′, k, t)
        return zero(v̄′), s̄′
    end
    return v̄′, s̄′
end

# The built-in modifiers and depletion forms carry their adjoints; a
# depletion does when its form does or the form's local derivative covers
# it (see `_form_pullback`).
uses_adjoint(::Union{Hazard, Floor, Add, Redistribute, Clamp}, ::Step) = true
uses_adjoint(m::Depletion, ::Step) = _form_adjoint(m.form)
