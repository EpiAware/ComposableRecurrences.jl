# Capacity: routing each step's demand between an admitted and an overflow
# stratum, limited by a stock (beds) or by a budget refilled each period.
# The mode and what happens to the overflow are types, so each variant is a
# method of `_open`, `_close` and `_unserved!`.

@doc raw"""
The stock mode of [`ComposableRecurrences.Capacity`](@ref): the capacity is
a number of places, such as beds, and the state holds their occupancy.

For one pair at absolute time ``t``, with capacity ``C_t``, occupancy
``O`` after the previous step and exit fraction ``\delta_t``,

```math
f = \max\big(C_t - (1 - \delta_t)\, O,\ 0\big), \qquad
O' = (1 - \delta_t)\, O + a,
```

where ``f`` is the free capacity and ``a \le f`` the admissions.

# Arguments
- `exit`: the fraction ``\delta`` of the occupancy that leaves each step, a
  parameter read at each pair and time; `false`, none, by default.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
CR.Stock(0.2)

# output

ComposableRecurrences.Stock{Float64}(0.2)
```
"""
struct Stock{E}
    "The exit fraction δ per step."
    exit::E
    function Stock(exit = false)
        e = exit === false ? exit : _float_param(_check_param(:exit, exit))
        return new{typeof(e)}(e)
    end
end

@doc raw"""
The per-period budget mode of [`ComposableRecurrences.Capacity`](@ref): the
capacity is an allowance granted at the start of each period, such as
vaccine doses, and the state holds what is left.

For one pair at absolute time ``t``, with allowance ``B`` left after the
previous step and grant ``b_t``,

```math
\tilde B = \begin{cases}
\mathbb{1}[\text{carry over}]\, B + b_t & t \in \{1, 1 + P, 1 + 2P, \dots\} \\
B & \text{otherwise},
\end{cases}
\qquad f = \max(\tilde B, 0), \qquad B' = \tilde B - a,
```

where ``P`` is the period, ``f`` the free capacity and ``a \le f`` the
admissions.
With carry over the unused allowance accumulates; without it the allowance
resets at each period start.
`period = Inf` grants once, at time 1: a lifetime budget.

# Arguments
- `period`: the number of steps per period, a positive integer, or `Inf`.

# Keyword Arguments
- `carry_over`: whether unused allowance carries into the next period;
  `true` by default.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
CR.Budget(7; carry_over = false)

# output

ComposableRecurrences.Budget{Int64}(7, false)
```
"""
struct Budget{P}
    "Steps per period, or `nothing` for one grant at time 1."
    period::P
    "Whether unused allowance carries over."
    carry_over::Bool
    function Budget(period, carry_over::Bool)
        p = _period(period)
        return new{typeof(p)}(p, carry_over)
    end
end

Budget(period; carry_over::Bool = true) = Budget(period, carry_over)

_period(::Nothing) = nothing
_period(p::Integer) = p >= 1 ? Int(p) : _bad_period(p)
_period(p::Real) = p == Inf ? nothing : _bad_period(p)
_period(p) = _bad_period(p)
function _bad_period(p)
    throw(
        ArgumentError(
            "period is a positive integer or Inf, got $(_describe(p))"
        )
    )
end

@doc raw"""
Overflow handling for [`ComposableRecurrences.Capacity`](@ref): demand that
is not admitted is added to the pair's overflow stratum at the same step.

For one pair with admitted stratum ``a``, overflow stratum ``o``, demand
``d = v_a`` and admissions ``x``,

```math
v'_a = x, \qquad v'_o = v_o + (d - x),
```

so ``v'_a + v'_o = v_a + v_o`` at every step.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
CR.Capacity(2.0, CR.Budget(Inf); pairs = [1 => 2], overflow = CR.Route()).overflow

# output

ComposableRecurrences.Route()
```
"""
struct Route end

@doc raw"""
Overflow handling for [`ComposableRecurrences.Capacity`](@ref): demand that
is not admitted waits in a queue, held in the state, and is offered again at
the next step.

For one admitted stratum ``a`` with queue ``Q`` after the previous step and
admissions ``x``,

```math
d = v_a + Q, \qquad v'_a = x, \qquad Q' = d - x,
```

so the admissions to date plus the queue equal the demand to date.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
CR.Capacity(2.0, CR.Stock(0.5); pairs = [1], overflow = CR.Hold()).overflow

# output

ComposableRecurrences.Hold()
```
"""
struct Hold end

@doc raw"""
Routes each step's demand between an admitted and an overflow stratum,
limited by a capacity: a bed cap in the stock mode, or an allowance per
period in the budget mode.
A stratum is one of the ``S`` parallel series computed together.
Nothing is deleted: demand that is not admitted moves to the overflow
stratum, or waits in a queue.

At absolute time ``t``, for each pair ``p`` with admitted stratum ``a``,
demand ``d`` and free capacity ``f`` from the mode,

```math
x = \min(d, f), \qquad v'_a = x,
```

and the overflow ``d - x`` routes to the pair's overflow stratum
([`ComposableRecurrences.Route`](@ref)) or to a queue offered again next
step ([`ComposableRecurrences.Hold`](@ref)).
The mode, [`ComposableRecurrences.Stock`](@ref) or
[`ComposableRecurrences.Budget`](@ref), gives ``f`` from its state and
updates the state by ``x``.
With softness ``\kappa``, the minimum is the smooth

```math
x = \Big(d^{-1/\kappa} + f^{-1/\kappa}\Big)^{-\kappa},
\qquad 0 \le x \le \min(d, f),
```

which is ``2^{-\kappa}`` of the exact minimum at ``d = f`` and tends to it as
the two part.
The exact minimum has a kink at ``d = f`` and the free capacity one at
``f = 0``; the derivative takes the active branch.
The state holds the stock or allowance of each pair, then, with `Hold()`,
each pair's queue.

# Arguments
- `C`: the capacity of each pair, a parameter read at each pair and time:
  one value, [`PerStratum`](@ref) with one per pair, [`TimeVarying`](@ref)
  or `TimeVarying(PerStratum(C))` pairs × time.
  In the stock mode it is the number of places, and in the budget mode the
  grant at each period start.
- `mode`: `Stock(exit)` or `Budget(period; carry_over)`.

# Keyword Arguments
- `pairs`: a vector of `a => o`, each admitted stratum `a` with its overflow
  stratum `o`; with `Hold()`, the admitted strata alone.
  Every stratum appears at most once.
- `overflow`: `Route()`, the default, or `Hold()`.
- `softness`: `nothing` for the exact minimum, the default, or ``\kappa``
  with ``0 < \kappa < 1`` for the smooth one.
- `initial`: the stock or allowance before the first step, one value or
  `PerStratum` with one per pair; `nothing`, zero, by default.
  A budget whose call starts between period starts has only this until the
  next start.

# Examples

Ten beds, a tenth of patients leaving each day: demand above the free beds
goes to the community stratum.

```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
beds = CR.Capacity(10.0, CR.Stock(0.1); pairs = [1 => 2])
demand = [4.0 3.0 5.0 6.0 2.0; 0.0 0.0 0.0 0.0 0.0]
y = Recurrence([0.0]; modifiers = (beds,))(; history = zeros(2, 1), add = demand)
round.(y; digits = 3)

# output

2×5 Matrix{Float64}:
 4.0  3.0  4.06  1.0  1.0
 0.0  0.0  0.94  5.0  1.0
```

A budget of 5 doses a week: the 1.5 doses left in the first week carry
over to the second.

```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
doses = CR.Capacity(5.0, CR.Budget(7); pairs = [1 => 2])
demand = [fill(0.5, 1, 7) fill(2.0, 1, 7); zeros(1, 14)]
y = Recurrence([0.0]; modifiers = (doses,))(; history = zeros(2, 1), add = demand)
y[1, :]'

# output

1×14 adjoint(::Vector{Float64}) with eltype Float64:
 0.5  0.5  0.5  0.5  0.5  0.5  0.5  2.0  2.0  2.0  0.5  0.0  0.0  0.0
```
"""
struct Capacity{M, C, O, K, I}
    "The mode, `Stock` or `Budget`."
    mode::M
    "The capacity of each pair."
    capacity::C
    "The admitted stratum of each pair."
    admitted::Vector{Int}
    "The overflow stratum of each pair, `0` for none."
    routes::Vector{Int}
    "The overflow handling, `Route()` or `Hold()`."
    overflow::O
    "The softness κ, or `nothing` for the exact minimum."
    softness::K
    "The stock or allowance before the first step, or `nothing` for zero."
    initial::I
end

function Capacity(
        C, mode; pairs, overflow = Route(), softness = nothing,
        initial = nothing
    )
    mode isa Union{Stock, Budget} || throw(
        ArgumentError("mode is Stock(exit) or Budget(period), got $(_describe(mode))")
    )
    overflow isa Union{Route, Hold} || throw(
        ArgumentError("overflow is Route() or Hold(), got $(_describe(overflow))")
    )
    admitted, routes = _pairs(overflow, pairs)
    C = _float_param(_check_param(:C, C))
    initial = _initial(initial)
    P = length(admitted)
    _check_param_pairs(:C, C, P)
    _check_param_pairs(:initial, initial, P)
    _check_mode_pairs(mode, P)
    return Capacity(
        mode, C, admitted, routes, overflow, _softness(softness), initial
    )
end

_initial(::Nothing) = nothing
_initial(x) = _float_param(_check_constant(:initial, x))

_check_mode_pairs(m::Stock, P) = _check_param_pairs(:exit, m.exit, P)
_check_mode_pairs(::Budget, P) = nothing

_softness(::Nothing) = nothing
function _softness(κ::Real)
    0 < κ < 1 || throw(
        ArgumentError("softness is nothing or between 0 and 1, got $κ")
    )
    return float(κ)
end
function _softness(κ)
    throw(ArgumentError("softness is nothing or a number, got $(_describe(κ))"))
end

# The pairs as flat index vectors: the admitted strata and their overflow
# strata, `0` where there is none.
function _pairs(overflow, pairs)
    pairs isa AbstractVector && !isempty(pairs) || throw(
        ArgumentError(
            "pairs is a non-empty vector of admitted => overflow strata, got " *
                _describe(pairs)
        )
    )
    admitted = Int[_pair(overflow, x)[1] for x in pairs]
    routes = Int[_pair(overflow, x)[2] for x in pairs]
    seen = filter(!iszero, vcat(admitted, routes))
    allunique(seen) || throw(
        ArgumentError(
            "each stratum appears at most once in pairs, got $(repr(pairs))"
        )
    )
    return admitted, routes
end

_pair(::Route, x::Pair{<:Integer, <:Integer}) = (_index(x.first), _index(x.second))
function _pair(::Route, x)
    throw(
        ArgumentError(
            "Route() moves the overflow to another stratum, so each entry of " *
                "pairs is admitted => overflow, got $(repr(x))"
        )
    )
end
_pair(::Hold, x::Integer) = (_index(x), 0)
function _pair(::Hold, x)
    throw(
        ArgumentError(
            "Hold() keeps the overflow in a queue, so each entry of pairs is " *
                "an admitted stratum, got $(repr(x))"
        )
    )
end
function _index(k)
    k >= 1 || throw(ArgumentError("stratum indices start at 1, got $k"))
    return Int(k)
end

# A parameter over pairs, checked against their number.
_check_param_pairs(name, x, P) = nothing
_check_param_pairs(name, x::TimeVarying, P) = _check_param_pairs(name, x.x, P)
function _check_param_pairs(name, x::PerStratum, P)
    size(x.x, 1) == P || throw(
        DimensionMismatch("$name has $(size(x.x, 1)) pairs, expected $P")
    )
    return nothing
end

_npairs(m::Capacity) = length(m.admitted)
nstate(m::Capacity{<:Any, <:Any, Route}, S) = _npairs(m)
nstate(m::Capacity{<:Any, <:Any, Hold}, S) = 2 * _npairs(m)

# The indices hold no parameters.
function param_eltype(m::Capacity)
    return promote_type(
        param_eltype(m.mode), param_eltype(m.capacity),
        param_eltype(m.softness), param_eltype(m.initial)
    )
end
param_eltype(::Budget) = Bool

function _check_modifier_strata(m::Capacity, S)
    k = max(maximum(m.admitted), maximum(m.routes))
    k <= S || throw(
        DimensionMismatch("Capacity pairs name stratum $k, but there are $S strata")
    )
    return nothing
end

function forward(m::Capacity, ::Init, s, history)
    _check_modifier_strata(m, _nstrata(history))
    fill!(s, zero(eltype(s)))
    m.initial === nothing && return nothing
    for p in 1:_npairs(m)
        s[p] = param(m.initial, p, 1)
    end
    return nothing
end

function pullback!(grads, m::Capacity, ::Init, s, history)
    m.initial === nothing && return nothing
    Ī = cotangent(grads.piece, :initial)
    for p in 1:_npairs(m)
        add_param!(Ī, m.initial, grads.s[p], p, 1)
    end
    return nothing
end

# The mode opens a pair's stock at time `t`: the free capacity and the
# stock held before admission. Closing it adds or takes the admissions.
function _open(mode::Stock, c, O, p, t)
    kept = (1 - param(mode.exit, p, t)) * O
    return c - kept, kept
end
function _open(mode::Budget, b, B, p, t)
    B̃ = _refills(mode.period, t) ? ifelse(mode.carry_over, B, zero(B)) + b : B
    return B̃, B̃
end
_close(::Stock, kept, x) = kept + x
_close(::Budget, B̃, x) = B̃ - x

_refills(period::Int, t) = rem(t - 1, period) == 0
_refills(::Nothing, t) = t == 1

# Their pullbacks. `_close_back` gives the cotangents of the held stock and
# of the admissions from that of the closed stock; `_open_back` takes those
# of the free capacity and the held stock, adds the parameters' and returns
# the incoming stock's.
_close_back(::Stock, s̄′) = (s̄′, s̄′)
_close_back(::Budget, s̄′) = (s̄′, -s̄′)
function _open_back(mode::Stock, m̄, m, O, f̄, h̄, p, t)
    δ = param(mode.exit, p, t)
    add_param!(cotangent(m̄, :capacity), m.capacity, f̄, p, t)
    k̄ = h̄ - f̄
    add_param!(cotangent(cotangent(m̄, :mode), :exit), mode.exit, -k̄ * O, p, t)
    return k̄ * (1 - δ)
end
function _open_back(mode::Budget, m̄, m, B, f̄, h̄, p, t)
    B̄ = f̄ + h̄
    _refills(mode.period, t) || return B̄
    add_param!(cotangent(m̄, :capacity), m.capacity, B̄, p, t)
    return ifelse(mode.carry_over, B̄, zero(B̄))
end

# The admissions from demand `d` and free capacity `f`: the minimum, or the
# smooth minimum `m g(m / M)` with `g(r) = (1 + r^(1/κ))^(-κ)`, `m` and `M`
# the smaller and larger of the two. On a tie the exact minimum takes `d`.
_admit(::Nothing, d, f) = ifelse(d <= f, d, f)
function _admit(κ, d, f)
    lo, hi = minmax(d, f)
    lo > 0 || return lo
    r = lo / hi
    return lo * (1 + r^inv(κ))^(-κ)
end

# Its pullback: the cotangents of `d`, `f` and `κ` from that of `x`.
function _admit_back(::Nothing, d, f, x̄)
    z = zero(x̄)
    return d <= f ? (x̄, z, z) : (z, x̄, z)
end
function _admit_back(κ, d, f, x̄)
    z = zero(x̄)
    lo, hi = minmax(d, f)
    if !(lo > 0)
        return d <= f ? (x̄, z, z) : (z, x̄, z)
    end
    r = lo / hi
    rp = r^inv(κ)
    g = (1 + rp)^(-κ)
    q = rp / (1 + rp)
    l̄o = x̄ * g * (1 - q)
    h̄i = x̄ * g * q * r
    κ̄ = x̄ * lo * g * (q * log(r) / κ - log1p(rp))
    return d <= f ? (l̄o, h̄i, κ̄) : (h̄i, l̄o, κ̄)
end

# The demand of pair `p`, and where its overflow goes.
_demand(::Route, v, s, a, p, P) = v[a]
_demand(::Hold, v, s, a, p, P) = v[a] + s[P + p]
function _unserved!(::Route, v, s, o, p, P, u)
    v[o] += u
    return nothing
end
function _unserved!(::Hold, v, s, o, p, P, u)
    s[P + p] = u
    return nothing
end

function forward(m::Capacity, ::Step, v, s, t)
    P = _npairs(m)
    for p in 1:P
        a = m.admitted[p]
        d = _demand(m.overflow, v, s, a, p, P)
        f, held = _open(m.mode, param(m.capacity, p, t), s[p], p, t)
        x = _admit(m.softness, d, max(f, zero(f)))
        s[p] = _close(m.mode, held, x)
        v[a] = x
        _unserved!(m.overflow, v, s, m.routes[p], p, P, d - x)
    end
    return nothing
end

# The overflow's cotangent `ū` from the output cotangents, and the demand's
# cotangent added into the inputs.
_unserved_back(::Route, v̄, s̄, o, p, P) = v̄[o]
_unserved_back(::Hold, v̄, s̄, o, p, P) = s̄[P + p]
function _demand_back!(::Route, v̄, s̄, a, p, P, d̄)
    v̄[a] = d̄
    return nothing
end
function _demand_back!(::Hold, v̄, s̄, a, p, P, d̄)
    v̄[a] = d̄
    s̄[P + p] = d̄
    return nothing
end

# Each pair reads and writes only its own entries, so the pairs reverse in
# any order; `v` and `s` are the step's incoming values.
function pullback!(grads, m::Capacity, ::Step, v, s, t)
    v̄, s̄, m̄ = grads.v, grads.s, grads.piece
    P = _npairs(m)
    for p in 1:P
        a = m.admitted[p]
        d = _demand(m.overflow, v, s, a, p, P)
        c = param(m.capacity, p, t)
        f, _ = _open(m.mode, c, s[p], p, t)
        ū = _unserved_back(m.overflow, v̄, s̄, m.routes[p], p, P)
        h̄, x̄s = _close_back(m.mode, s̄[p])
        x̄ = v̄[a] - ū + x̄s
        d̄, f̄, κ̄ = _admit_back(m.softness, d, max(f, zero(f)), x̄)
        add_cotangent!(cotangent(m̄, :softness), κ̄)
        f̄ = f > 0 ? f̄ : zero(f̄)
        s̄[p] = _open_back(m.mode, m̄, m, s[p], f̄, h̄, p, t)
        _demand_back!(m.overflow, v̄, s̄, a, p, P, d̄ + ū)
    end
    return nothing
end
