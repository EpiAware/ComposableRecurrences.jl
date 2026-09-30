# The built-in modifiers and their pullbacks. A pullback's `m̄` mirrors the
# modifier's fields as a NamedTuple: an array for a float array, a `Ref` for
# a float scalar, a NamedTuple for a wrapper such as `TimeVarying`, and
# `nothing` for a field without a cotangent.

@doc "
The pullback of the scalar [`apply`](@ref) for a pointwise modifier `m`.

Given stratum `k`'s value `v` and state `s` before the step and the
cotangents `v̄′`, `s̄′` of its outputs, return the cotangents `(v̄, s̄)` of
`v` and `s`, adding parameter cotangents into `m̄`.
A pointwise modifier's [`apply_pullback!`](@ref) loops it over strata.

# Arguments
- `m̄`: the cotangent of the modifier's parameters.
- `m`: the modifier.
- `v`: the stratum's value before the modifier.
- `s`: the stratum's state before the step.
- `t`: the time index of the step.
- `k`: the stratum.
- `v̄′`: the cotangent of the value after the modifier.
- `s̄′`: the cotangent of the state after the step.

# Examples
```@example
using ComposableRecurrences
CR = ComposableRecurrences
m = CR.Imports(0.5)
m̄ = (; b = Ref(0.0))
CR.apply_pullback(m̄, m, 1.0, 0.0, 1, 1, 2.0, 0.0), m̄.b[]
```
"
function apply_pullback end

@doc "
Accumulate the reverse pass of [`init_state`](@ref) for modifier `m`.

Given the cotangent `s̄` of the initial state, add the cotangents of the
modifier's parameters into `m̄` and of the history into `h̄` (skipped when
`h̄` is `nothing`).
Implement it for a modifier whose initial state depends on its parameters
or the history.

# Arguments
- `m̄`: the cotangent of the modifier's parameters.
- `h̄`: the cotangent of the history, or `nothing`.
- `m`: the modifier.
- `history`: the history the recurrence starts from.
- `s̄`: the cotangent of the initial state.

# Examples
```@example
using ComposableRecurrences
CR = ComposableRecurrences
m = CR.Depletion([10.0, 20.0]; seeded = true)
m̄ = (; N = zeros(2), heterogeneity = Ref(0.0), seeded = nothing)
h̄ = zeros(2, 2)
CR.init_state_pullback!(m̄, h̄, m, ones(2, 2), [1.0, 2.0])
m̄.N, h̄
```
"
function init_state_pullback! end

# The mirror slot for field `name`, or `nothing` without a mirror.
_cotangent(::Nothing, name) = nothing
_cotangent(m̄, name) = getfield(m̄, name)

# Add `x` into a mirror slot at `idx`; a `Ref` takes every index.
_add_cotangent!(::Nothing, x, idx...) = nothing
_add_cotangent!(r::Base.RefValue, x, idx...) = (r[] += x; nothing)
function _add_cotangent!(a::AbstractArray, x, idx...)
    a[idx...] += x
    return nothing
end
_add_cotangent!(w::NamedTuple{(:x,)}, x, idx...) = _add_cotangent!(w.x, x, idx...)

# A parameter that is one value, or one per stratum, at stratum `k`.
_stratum(x::Real, k) = x
_stratum(x::AbstractVector, k) = x[k]
_add_stratum!(x̄, ::Real, x, k) = _add_cotangent!(x̄, x)
_add_stratum!(x̄, ::AbstractVector, x, k) = _add_cotangent!(x̄, x, k)

_check_stratum_param(name, x::Real, S) = nothing
function _check_stratum_param(name, x::AbstractVector, S)
    length(x) == S || throw(
        DimensionMismatch("$name has $(length(x)) strata, expected $S")
    )
    return nothing
end

# A pointwise modifier's vector pullback: the scalar one over strata.
function _pointwise_pullback!(m̄, m, v, s, t, v̄, s̄)
    for k in eachindex(v, s, v̄, s̄)
        v̄[k], s̄[k] = apply_pullback(m̄, m, v[k], s[k], t, k, v̄[k], s̄[k])
    end
    return nothing
end

# Depletion ---------------------------------------------------------------

@doc "
Susceptible depletion: each stratum's new values are drawn from a pool
that starts at `N` and shrinks by what is drawn.

With pool `P`, value `v` and heterogeneity exponent `α`:

  - `form = :hazard`: `x = v / N ⋅ (P / N)^(α − 1)`, the step's output is
    `P (1 − exp(−x))` and the pool becomes `P exp(−x)`, so the pool never
    goes negative.
  - `form = :floor`: the output is `max(max(P / N, 0)^α, 1e-6) v` and the
    pool becomes `P` less the output. The pool can go negative, and then the
    floor applies.

`α > 1` depletes faster as the pool shrinks (heterogeneous mixing).
With `seeded = true` the pool starts at `max(N − Σ history, 0)`, the whole
history (not only the last `L` values) drawn from it.
The state is the pool.

# Arguments
- `N`: the population, one value or one per stratum.

# Keyword Arguments
- `form`: `:hazard` (default) or `:floor`.
- `seeded`: whether the history is drawn from the pool; `false` by default.
- `heterogeneity`: the exponent `α`; `1` by default.

# Examples
```@example
using ComposableRecurrences
CR = ComposableRecurrences
depletion = CR.Depletion(100.0; seeded = true)
Recurrence([0.5, 0.5]; modifiers = (depletion,))(fill(2.0, 8); history = [1.0, 2.0])
```
"
struct Depletion{F, P, A} # F: the form, :hazard or :floor
    "The population, one value or one per stratum."
    N::P
    "The heterogeneity exponent α."
    heterogeneity::A
    "Whether the history is drawn from the pool."
    seeded::Bool
    function Depletion{F}(N::P, heterogeneity::A, seeded::Bool) where {F, P, A}
        F in (:hazard, :floor) || throw(
            ArgumentError("form must be :hazard or :floor, not :$F")
        )
        return new{F, P, A}(N, heterogeneity, seeded)
    end
end

Base.@constprop :aggressive function Depletion(
        N; form = :hazard, seeded = false, heterogeneity = 1
    )
    N = float(N)
    return Depletion{form}(N, _exponent(heterogeneity, N), seeded)
end

# An integer exponent takes the population's float type, so it has a
# cotangent and a Float32 population stays Float32.
_exponent(α::Integer, N) = convert(float(param_eltype(N)), α)
_exponent(α, N) = α

const _DEPLETION_FLOOR = 1.0e-6

ispointwise(::Depletion) = true

_history_row(h::AbstractVector, k) = h
_history_row(h::AbstractMatrix, k) = view(h, k, :)

# The pool left once stratum `k`'s history is drawn from `N`, floored at zero.
function _pool_left(N, h, k)
    left = N - sum(_history_row(h, k))
    return left > zero(left) ? left : zero(left)
end

function init_state(m::Depletion, history)
    S = _nstrata(history)
    _check_stratum_param(:N, m.N, S)
    Tp = float(promote_type(eltype(history), param_eltype(m.N)))
    return Tp[
        m.seeded ? _pool_left(_stratum(m.N, k), history, k) :
            _stratum(m.N, k) for k in 1:S
    ]
end

function init_state_pullback!(m̄, h̄, m::Depletion, history, s̄)
    N̄ = _cotangent(m̄, :N)
    for k in eachindex(s̄)
        N = _stratum(m.N, k)
        m.seeded && N - sum(_history_row(history, k)) <= 0 && continue
        _add_stratum!(N̄, m.N, s̄[k], k)
        m.seeded && h̄ !== nothing && (_history_row(h̄, k) .-= s̄[k])
    end
    return nothing
end

function apply(m::Depletion{:hazard}, v, s, t, k)
    N = _stratum(m.N, k)
    x = v / N * (s / N)^(m.heterogeneity - 1)
    return -s * expm1(-x), s * exp(-x)
end

function apply_pullback(m̄, m::Depletion{:hazard}, v, s, t, k, v̄′, s̄′)
    N = _stratum(m.N, k)
    α = m.heterogeneity
    r = s / N
    h = r^(α - 1)
    x = v / N * h
    e = exp(-x)
    x̄ = s * e * (v̄′ - s̄′)
    s̄ = -v̄′ * expm1(-x) + s̄′ * e
    α == 1 || (s̄ += e * (v̄′ - s̄′) * (α - 1) * x)
    _add_stratum!(_cotangent(m̄, :N), m.N, -x̄ * α * x / N, k)
    r > 0 && _add_cotangent!(_cotangent(m̄, :heterogeneity), x̄ * x * log(r))
    return x̄ * h / N, s̄
end

function apply(m::Depletion{:floor}, v, s, t, k)
    r = s / _stratum(m.N, k)
    f = max(max(r, zero(r))^m.heterogeneity, oftype(r, _DEPLETION_FLOOR))
    v′ = f * v
    return v′, s - v′
end

function apply_pullback(m̄, m::Depletion{:floor}, v, s, t, k, v̄′, s̄′)
    N = _stratum(m.N, k)
    α = m.heterogeneity
    r = s / N
    p = max(r, zero(r))^α
    fl = oftype(p, _DEPLETION_FLOOR)
    ḡ = v̄′ - s̄′
    p > fl || return ḡ * fl, s̄′
    f̄ = ḡ * v
    _add_stratum!(_cotangent(m̄, :N), m.N, -f̄ * α * p / N, k)
    _add_cotangent!(_cotangent(m̄, :heterogeneity), f̄ * p * log(r))
    return ḡ * p, s̄′ + f̄ * α * r^(α - 1) / N
end

function apply_pullback!(m̄, m::Depletion, v, s, t, v̄, s̄)
    return _pointwise_pullback!(m̄, m, v, s, t, v̄, s̄)
end

# Imports -----------------------------------------------------------------

@doc "
Imported values added to each stratum wherever the modifier sits in the
tuple: after a [`Depletion`](@ref), imports are neither scaled by nor drawn
from the pool.

`b` is one value, a length-`T` vector over time shared by every stratum,
or `S × T`, each optionally wrapped in [`TimeVarying`](@ref).
A vector is indexed by time because imports vary over time and a single
series has no strata axis; [`Redistribute`](@ref) acts between strata, so
its vector is indexed by stratum instead.
Time is the absolute index, so with `start` the first step reads `b` at
`start`.
Alone, `Imports(b)` gives the same values as passing `b` as `add`.
The state is unused.

# Arguments
- `b`: the imports: a scalar, length `T` or `S × T`, or a `TimeVarying`
  of either array.

# Examples
```@example
using ComposableRecurrences
CR = ComposableRecurrences
mods = (CR.Depletion(50.0; form = :floor), CR.Imports([1.0, 0.0, 2.0]))
Recurrence([1.0]; modifiers = mods)(1.0; history = [2.0], add = zeros(3))
```
"
struct Imports{B}
    "The imports: a scalar, length `T`, `S × T` or `TimeVarying`."
    b::B
end

ispointwise(::Imports) = true
init_state_pullback!(m̄, h̄, ::Imports, history, s̄) = nothing

_import_at(b::Real, k, t) = b
_import_at(b::AbstractVector, k, t) = b[t]
_import_at(b::AbstractMatrix, k, t) = b[k, t]
_import_at(b::TimeVarying, k, t) = _import_at(b.x, k, t)
_add_import!(b̄, ::Real, x, k, t) = _add_cotangent!(b̄, x)
_add_import!(b̄, ::AbstractVector, x, k, t) = _add_cotangent!(b̄, x, t)
_add_import!(b̄, ::AbstractMatrix, x, k, t) = _add_cotangent!(b̄, x, k, t)
_add_import!(b̄, b::TimeVarying, x, k, t) = _add_import!(b̄, b.x, x, k, t)

apply(m::Imports, v, s, t, k) = (v + _import_at(m.b, k, t), s)

function apply_pullback(m̄, m::Imports, v, s, t, k, v̄′, s̄′)
    _add_import!(_cotangent(m̄, :b), m.b, v̄′, k, t)
    return v̄′, s̄′
end

function apply_pullback!(m̄, m::Imports, v, s, t, v̄, s̄)
    return _pointwise_pullback!(m̄, m, v, s, t, v̄, s̄)
end

# Redistribute ------------------------------------------------------------

@doc "
Moves a share of each stratum's values to others, conserving the total: a
share `ε_q K[p, q]` of origin `q`'s value is realised in `p` instead.

    v′_p = (1 − ε_p Σ_{r ≠ p} K[r, p]) v_p + Σ_{q ≠ p} ε_q K[p, q] v_q

The diagonal of `K` is not read: a stratum does not import from itself.
The intensity `ε` belongs to the origin: one value, one per stratum (a
length-`S` vector), or a [`TimeVarying`](@ref) `S × T` array read at the
absolute time.
The modifier only acts between strata, so a plain vector is indexed by
stratum, unlike [`Imports`](@ref), whose vector is indexed by time.
The state is the step's arrivals in each stratum, `Σ_{q ≠ p} ε_q K[p, q] v_q`.
Place it before a [`Depletion`](@ref) to deplete each stratum's pool by what
it realises; a modifier sees `gain ⊙ x + add`, so the `add` values move too.

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
"
struct Redistribute{K <: AbstractMatrix, E}
    "The kernel, `K[p, q]` from origin `q` to destination `p`."
    K::K
    "The origin intensity: a scalar, per stratum or `TimeVarying` `S × T`."
    ε::E
    function Redistribute(K::M, ε::E) where {M <: AbstractMatrix, E}
        size(K, 1) == size(K, 2) || throw(
            DimensionMismatch("K is $(size(K)), expected a square matrix")
        )
        ε isa AbstractMatrix && throw(
            ArgumentError("wrap a strata × time intensity as TimeVarying(ε)")
        )
        return new{M, E}(K, ε)
    end
end

init_state_pullback!(m̄, h̄, ::Redistribute, history, s̄) = nothing

_origin_at(ε::Real, q, t) = ε
_origin_at(ε::AbstractVector, q, t) = ε[q]
_origin_at(ε::TimeVarying{<:AbstractMatrix}, q, t) = ε.x[q, t]
_add_origin!(ε̄, ::Real, x, q, t) = _add_cotangent!(ε̄, x)
_add_origin!(ε̄, ::AbstractVector, x, q, t) = _add_cotangent!(ε̄, x, q)
_add_origin!(ε̄, ::TimeVarying, x, q, t) = _add_cotangent!(ε̄, x, q, t)

# Origin `q`'s total share sent away, Σ_{r ≠ q} K[r, q].
function _outflow(K, q)
    out = zero(eltype(K))
    for r in axes(K, 1)
        r == q || (out += K[r, q])
    end
    return out
end

function apply!(m::Redistribute, v, s, t)
    (; K, ε) = m
    _check_coupling(K, length(v))
    for p in eachindex(v, s)
        acc = zero(eltype(s))
        for q in eachindex(v)
            q == p || (acc += _origin_at(ε, q, t) * K[p, q] * v[q])
        end
        s[p] = acc
    end
    for p in eachindex(v, s)
        v[p] = (1 - _origin_at(ε, p, t) * _outflow(K, p)) * v[p] + s[p]
    end
    return nothing
end

# The arrivals `s′` feed both outputs, so their cotangent is `s̄′ + v̄′`;
# the incoming state is not read.
function apply_pullback!(m̄, m::Redistribute, v, s, t, v̄, s̄)
    (; K, ε) = m
    K̄, ε̄ = _cotangent(m̄, :K), _cotangent(m̄, :ε)
    for p in eachindex(v̄, s̄)
        s̄[p] += v̄[p]
    end
    for q in eachindex(v, v̄)
        εq = _origin_at(ε, q, t)
        out = _outflow(K, q)
        acc = zero(eltype(v̄))
        for p in eachindex(v)
            p == q && continue
            acc += s̄[p] * K[p, q]
            _add_cotangent!(K̄, εq * v[q] * (s̄[p] - v̄[q]), p, q)
        end
        _add_origin!(ε̄, ε, v[q] * (acc - v̄[q] * out), q, t)
        v̄[q] = v̄[q] * (1 - εq * out) + εq * acc
    end
    fill!(s̄, zero(eltype(s̄)))
    return nothing
end

# Clamp -------------------------------------------------------------------

@doc "
Clamps each stratum's value to `[lo, hi]`, as `clamp`.

`lo` and `hi` are each one value or one per stratum.
The state is unused.

# Arguments
- `lo`: the lower bound.
- `hi`: the upper bound.

# Examples
```@example
using ComposableRecurrences
CR = ComposableRecurrences
Recurrence([2.0]; modifiers = (CR.Clamp(0.0, 5.0),))(1.0; history = [1.0], add = zeros(4))
```
"
struct Clamp{L, H}
    "The lower bound, one value or one per stratum."
    lo::L
    "The upper bound, one value or one per stratum."
    hi::H
end

ispointwise(::Clamp) = true
init_state_pullback!(m̄, h̄, ::Clamp, history, s̄) = nothing

function apply(m::Clamp, v, s, t, k)
    return clamp(v, _stratum(m.lo, k), _stratum(m.hi, k)), s
end

# Matches `clamp`'s branches: above `hi`, then below `lo`, else `v`.
function apply_pullback(m̄, m::Clamp, v, s, t, k, v̄′, s̄′)
    if v > _stratum(m.hi, k)
        _add_stratum!(_cotangent(m̄, :hi), m.hi, v̄′, k)
        return zero(v̄′), s̄′
    elseif v < _stratum(m.lo, k)
        _add_stratum!(_cotangent(m̄, :lo), m.lo, v̄′, k)
        return zero(v̄′), s̄′
    end
    return v̄′, s̄′
end

function apply_pullback!(m̄, m::Clamp, v, s, t, v̄, s̄)
    return _pointwise_pullback!(m̄, m, v, s, t, v̄, s̄)
end
