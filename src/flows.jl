# Flows between the pools of a `Pool`. A `Flow` moves part of one pool
# into another, or out, each step, by a form applied to its
# demand: a competing hazard rate (`Hazard()`, the default), a share
# (`Share()`) or a count capped by what is there (`Truncate()` or
# `SoftTruncate(κ)`). The rates out of one pool compete; rates and
# shares act on the incoming pools together, then the counts in
# flow order on what remains.

@doc raw"""
The share flow form: a [`ComposableRecurrences.Flow`](@ref) with this form
moves a share ``p`` of the pool it leaves.

Flow ``f`` out of pool ``i``, with demand ``p_f``, moves

```math
m_f = p_f\, x_i,
```

with ``x_i`` the pool before the step's flows, alongside any
[`ComposableRecurrences.Hazard`](@ref) flows.
Shares out of one pool that sum to more than ``e^{-H_i}``, with
``H_i`` the sum of its hazard rates, leave it negative.
`Share()` is a form for flows only, not a depletion form.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
CR.Flow(1 => 0, 0.15; form = CR.Share()).form

# output

ComposableRecurrences.Share()
```
"""
struct Share end

# The forms a flow takes: rates and shares act together, the truncated
# forms in order after them.
const _TruncateForm = Union{Truncate, SoftTruncate}
const _FlowForm = Union{Hazard, Share, _TruncateForm}

@doc raw"""
A flow from pool `from` into pool `to` of a
[`ComposableRecurrences.Pool`](@ref), or out of it with `to = 0`,
that moves its `demand` by a form.

Each step it moves an amount ``m_f`` out of pool `from` and into `to`,

```math
x'_{\mathrm{from}} = x_{\mathrm{from}} - m_f, \qquad
x'_{\mathrm{to}} = x_{\mathrm{to}} + m_f,
```

with the form setting ``m_f`` from the demand ``d_f`` and the pool ``x``
it leaves:

| form | demand | ``m_f`` |
|:---- |:------ |:------- |
| [`ComposableRecurrences.Hazard`](@ref) (the default) | a hazard rate | ``x\, d_f \big(1 - e^{-H}\big) / H``, with ``H`` the sum of the hazard rates out of ``x`` |
| [`ComposableRecurrences.Share`](@ref) | a share | ``d_f\, x`` |
| [`ComposableRecurrences.Truncate`](@ref) | a count | ``\min\big(d_f, \max(x, 0)\big)`` |
| [`ComposableRecurrences.SoftTruncate`](@ref) | a count | a smooth ``\min\big(d_f, \max(x, 0)\big)`` |

The hazard rates out of one pool compete, as in the `Hazard` depletion
form, so together they move ``x (1 - e^{-H})``; with non-negative, finite
rates a non-negative pool stays non-negative.
A per-step probability ``p < 1`` is the rate ``-\log(1 - p)``.
A constant rate out of a compartment is a geometric stay in it; for
another stay, convolve the inflow with its survival, as
[Occupancy and capacity](@ref tutorial-occupancy) does.
A `Hazard()` flow's demand is the rate itself, with no population and no
heterogeneity, where a `Hazard()` depletion draws the value divided by
its population `N`.
For each group at absolute time ``t``, with pools ``x``, hazard flows
``f`` at rates ``r_f`` and share flows at shares ``p_f``, these act
together on the pools before the step's flows,

```math
\begin{aligned}
H_i &= \sum_{\mathrm{Hazard}\ f \text{ out of } i} r_f, \qquad
P_i = \sum_{\mathrm{Share}\ f \text{ out of } i} p_f, \\
y_j &= \big(e^{-H_j} - P_j\big) x_j + \sum_{f \text{ into } j} m_f,
\end{aligned}
```

then each count flow, in the order given, moves its ``m_f`` out of what
remains in ``y``.
Shares out of one pool that sum to more than ``e^{-H_i}`` leave it
negative.
A negative count adds ``-d_f`` to pool `from`, without a cap, and moves
nothing into `to`.
The derivative through ``\min`` and ``\max`` takes the active branch.
Rates and shares are not checked: a time-varying or [`Derived`](@ref)
demand is only known at each step.

# Arguments
- `pools`: `from => to`, each a pool's name or its position from 1, with
  `to = 0` to leave the `Pool`.
- `demand`: the rate, share or count, a
  [parameter](@ref ComposableRecurrences.param) read at each step's group
  and time, with `PerStratum` holding one per group.

# Keyword Arguments
- `form`: `Hazard()`, the default, `Share()`, `Truncate()` or
  `SoftTruncate(κ)`.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
waning = CR.Flow(:V => :S, 0.1)
transfers = CR.Flow(1 => 0, 3.0; form = CR.Truncate())
waning.form, transfers.to

# output

(ComposableRecurrences.Hazard(), 0)
```
"""
struct Flow{D, F <: _FlowForm, E}
    "The pool the flow leaves, by name or position."
    from::E
    "The pool it enters, by name or position, or `0` when it leaves."
    to::E
    "The rate, share or count, a parameter."
    demand::D
    "How the demand moves: `Hazard()`, `Share()`, `Truncate()` or `SoftTruncate(κ)`."
    form::F
    function Flow(from, to, demand::D, form::F) where {D, F}
        _check_end(:from, from, 1)
        _check_end(:to, to, 0)
        from == to && throw(
            ArgumentError(
                "a flow joins two different pools, got $(repr(from)) => $(repr(to))"
            )
        )
        form isa _FlowForm || throw(
            ArgumentError(
                "a flow's form is Hazard(), Share(), Truncate() or " *
                    "SoftTruncate(κ), got $(_describe(form))"
            )
        )
        E = Union{typeof(from), typeof(to)}
        return new{D, F, E}(from, to, _check_param(:demand, demand), form)
    end
end

function Flow(pools::Pair, demand; form = Hazard())
    return Flow(_end(pools.first), _end(pools.second), demand, form)
end
function Flow(pools, demand; form = Hazard())
    throw(
        ArgumentError(
            "a flow joins pools given as from => to, got " * _describe(pools)
        )
    )
end

# A flow's end: a pool's name, or its position from 1, with `0` outside.
_end(x::Symbol) = x
_end(x::Integer) = Int(x)
function _end(x)
    throw(
        ArgumentError(
            "a flow's ends are pool names or positions, got " * _describe(x)
        )
    )
end
_check_end(name, x::Symbol, lo) = nothing
function _check_end(name, x::Int, lo)
    x >= lo || throw(
        ArgumentError(
            lo == 1 ? "pools are numbered from 1, got $name = $x" :
                "$name is a pool from 1, or 0 to leave, got $name = $x"
        )
    )
    return nothing
end

# The flow with its ends as positions among the pools `names`.
function _placed(f::Flow, names)
    return Flow(_place(f.from, names, f), _place(f.to, names, f), f.demand, f.form)
end
_place(x::Int, names, f) = x == 0 ? 0 : _placed_pool(x, names, f)
_place(x::Symbol, names, f) = _placed_pool(x, names, f)
function _placed_pool(x, names, f)
    i = _position(x, names)
    i == 0 && _unknown_pool(x, names, f)
    return i
end
@noinline function _unknown_pool(x, names, f)
    throw(
        ArgumentError(
            "Flow($(repr(f.from)) => $(repr(f.to))) names pool $(repr(x)), " *
                "but the pools are $(repr(names))"
        )
    )
end

# A count flow, which moves its demand up to what the pool holds.
const _Count = Flow{<:Any, <:_TruncateForm}

# The flows as a non-empty tuple of `Flow`s.
function _flow_tuple(fs)
    isempty(fs) && throw(ArgumentError("give at least one Flow, got none"))
    for f in fs
        f isa Flow || throw(ArgumentError("expected a Flow, got $(_describe(f))"))
    end
    return fs
end

# The hazard rate and share of a flow, zero for another form.
_rate(f::Flow{<:Any, Hazard}, g, t) = param(f.demand, g, t)
_rate(f::Flow, g, t) = false
_share(f::Flow{<:Any, Share}, g, t) = param(f.demand, g, t)
_share(f::Flow, g, t) = false

# Sum `h(f, g, t)` over the flows out of pool `i`.
_out(h, ::Tuple{}, i, g, t, z) = z
function _out(h, fs::Tuple, i, g, t, z)
    f = first(fs)
    x = h(f, g, t)
    return _out(h, Base.tail(fs), i, g, t, z + ifelse(f.from == i, x, zero(x)))
end

# `exp(-H)` and the share that leaves per unit hazard,
# `g(H) = (1 - exp(-H)) / H`. Near zero `g` is 0/0, so it takes its series;
# the arm follows the primal value, and the guarded division keeps the
# unused arm finite.
function _leave(H)
    small = abs(_primal_value(H)) < _series_cut(H)
    Hd = ifelse(small, one(H), H)
    g = ifelse(
        small,
        1 - H / 2 * (1 - H / 3 * (1 - H / 4 * (1 - H / 5 * (1 - H / 6 * (1 - H / 7))))),
        -expm1(-Hd) / Hd
    )
    return exp(-H), g
end

# The slope `g′(H) = (exp(-H) - g) / H`, with its series near zero.
function _leave_slope(H, E, g)
    small = abs(_primal_value(H)) < _series_cut(H)
    Hd = ifelse(small, one(H), H)
    series = -one(H) / 2 + H / 3 - H^2 / 8 + H^3 / 30 - H^4 / 144 + H^5 / 840
    return ifelse(small, series, (E - g) / Hd)
end

# Where the slope's next series term, about `H^6 / 5760`, matches the
# rounding of its closed form, about `2 eps / H`.
function _series_cut(H)
    T = float(_primal_type(typeof(H)))
    return (11520 * eps(T))^(one(T) / 7)
end

# Tuple entry `i` of `x` replaced by `v`, in the tuple's eltype.
# Built with `ntuple`, which infers where `Base.setindex` with a runtime
# index does not.
function _set(x::Tuple, i, v)
    w = convert(eltype(x), v)
    return ntuple(j -> ifelse(j == i, w, x[j]), Val(length(x)))
end

# Tuple entry `i` of `x` plus `v`, or `x` for an `i` it lacks; arrivals of
# `nothing` are not kept.
_add(x::Tuple, i, v) = ntuple(j -> ifelse(j == i, x[j] + v, x[j]), Val(length(x)))
_add(::Nothing, i, v) = nothing

# Tuple entry `i` of `x`, chosen by `ifelse` over the entries: a small tuple
# is read where it is held, without an indexed load.
_get(x::Tuple, i) = _get(Base.tail(x), i, 2, first(x))
_get(::Tuple{}, i, j, v) = v
_get(x::Tuple, i, j, v) = _get(Base.tail(x), i, j + 1, ifelse(j == i, first(x), v))

# What moves out of pool `i` per unit held, `(e^{-H}, g(H), P)`.
function _leaves(fs, i, g, t, z)
    E, gH = _leave(_out(_rate, fs, i, g, t, z))
    return E, gH, _out(_share, fs, i, g, t, z)
end
# Without a hazard flow nothing leaves at a rate, so `e^{-0}` and `g(0)` are
# one, exactly as `_leave` gives them, without the exponentials.
const _NoHazard = Tuple{Vararg{Flow{<:Any, <:Union{Share, _TruncateForm}}}}
_leaves(fs::_NoHazard, i, g, t, z) = one(z), one(z), _out(_share, fs, i, g, t, z)

# Add each hazard and share flow's amount into the pool it enters, in
# `y` and the arrivals `a`.
_spread(::Tuple{}, x, L, y, a, g, t) = y, a
function _spread(fs::Tuple, x, L, y, a, g, t)
    y, a = _spread_one(first(fs), x, L, y, a, g, t)
    return _spread(Base.tail(fs), x, L, y, a, g, t)
end
_spread_one(f::_Count, x, L, y, a, g, t) = (y, a)
function _spread_one(f::Flow, x, L, y, a, g, t)
    f.to > 0 || return (y, a)
    _, gH, _ = L[f.from]
    m = x[f.from] * (_rate(f, g, t) * gH + _share(f, g, t))
    return _add(y, f.to, m), _add(a, f.to, m)
end

# A count `r` out of a pool holding `s`, `min(r, max(s, 0))`; it is
# also a depletion's removal from what remains after the draw. The arms
# follow primal values, as in the pullback: a dual with value zero is
# ordered by its partials, so `min` and `max` on duals could take the other
# arm at an empty pool. `s + z` turns `-0.0` into `0.0` as `max` does; a NaN
# in either input is returned, as `min` does; `ifelse` keeps a traced step
# branch-free.
function _removal(r, s)
    r, s = promote(r, s)
    z = zero(s)
    c = ifelse(_primal_value(s) < 0, z, s + z)
    return ifelse(_takes_pool(_primal_value(r), _primal_value(c)), c, r)
end

# Whether the removal is the pool `c` rather than `r`: `r` on a tie.
_takes_pool(r, c) = (c < r) | isnan(c)

# Its cotangents `(r̄, s̄)` from the removal's cotangent `m̄`, on the arm
# `_removal` takes.
function _removal_pullback(r, s, m̄)
    z = zero(m̄)
    _takes_pool(r, max(s, zero(s))) || return m̄, z
    return z, s < 0 ? z : m̄
end

# What a count moves into the pool it enters: a negative count adds
# to the pool it leaves only. The arm follows the primal value.
_moved_in(m) = ifelse(_primal_value(m) < 0, zero(m), m)

# What a count `a` moves out of a pool holding `s`, and the
# cotangents `(ā, s̄, κ̄)` from that of the move; `κ̄` is the softness's.
_moved(::Truncate, a, s) = _removal(a, s)
_moved(form::SoftTruncate, a, s) = _soft_min(form.κ, a, _pool_left(s))
function _moved_back(::Truncate, a, s, m̄)
    ā, s̄ = _removal_pullback(a, s, m̄)
    return ā, s̄, zero(m̄)
end
function _moved_back(form::SoftTruncate, a, s, m̄)
    ā, c̄, κ̄ = _soft_min_back(form.κ, a, _pool_left(s), m̄)
    return ā, ifelse(s > 0, c̄, zero(c̄)), κ̄
end

# The count flows in order on the pools `y` and arrivals `a`.
_counts(::Tuple{}, y, a, g, t) = y, a
function _counts(fs::Tuple, y, a, g, t)
    y, a = _count(first(fs), y, a, g, t)
    return _counts(Base.tail(fs), y, a, g, t)
end
_count(f::Flow, y, a, g, t) = y, a
# One pass over the pools, by `ifelse`: a flow out of the system
# (`to = 0`) adds to no pool.
function _count(f::_Count, y, a, g, t)
    i, j = f.from, f.to
    m = _moved(f.form, param(f.demand, g, t), _get(y, i))
    p = _moved_in(m)
    y′ = ntuple(Val(length(y))) do l
        return ifelse(l == i, y[l] - m, ifelse(l == j, y[l] + p, y[l]))
    end
    return y′, _add(a, j, p)
end

# Count flows only, such as a depletion's removals: nothing moves at a
# rate or as a share, so the counts act on `x` directly.
const _Counts = Tuple{Vararg{_Count}}

# One group's step: the pools `x` after the flows, and arrivals.
function _flow_group(fs::_Counts, x::NTuple{N}, g, t) where {N}
    return _counts(fs, x, ntuple(_ -> zero(first(x)), Val(N)), g, t)
end

function _flow_group(fs, x::NTuple{N}, g, t) where {N}
    z = zero(first(x))
    L = ntuple(i -> _leaves(fs, i, g, t, z), Val(N))
    # No name a closure captures is reassigned, or the closure would box it.
    y0 = ntuple(i -> (L[i][1] - L[i][3]) * x[i], Val(N))
    y, a = _spread(fs, x, L, y0, ntuple(_ -> zero(first(y0)), Val(N)), g, t)
    return _counts(fs, y, a, g, t)
end

# The pools after the flows, without the arrivals.
_flow_only(fs::_Counts, x, g, t) = first(_counts(fs, x, nothing, g, t))
_flow_only(fs, x, g, t) = first(_flow_group(fs, x, g, t))

# Reverse of the count flows: recurse forward, keeping each flow's input,
# then pull back last first. `ȳ` and `ā` are the cotangents after the
# flows; returns those before them.
_counts_back(::Tuple{}, f̄s, y, a, ȳ, ā, g, t) = ȳ
function _counts_back(fs::Tuple, f̄s, y, a, ȳ, ā, g, t)
    f = first(fs)
    y′, a′ = _count(f, y, a, g, t)
    ȳ′ = _counts_back(Base.tail(fs), _tail(f̄s), y′, a′, ȳ, ā, g, t)
    return _count_back(f, _head(f̄s), y, ȳ′, ā, g, t)
end
_count_back(f::Flow, f̄, y, ȳ, ā, g, t) = ȳ
function _count_back(f::_Count, f̄, y, ȳ, ā, g, t)
    c = param(f.demand, g, t)
    m = _moved(f.form, c, y[f.from])
    m̄ = -ȳ[f.from]
    if f.to > 0 && _primal_value(m) >= 0
        m̄ += ȳ[f.to] + ā[f.to]
    end
    c̄, s̄, κ̄ = _moved_back(f.form, c, y[f.from], m̄)
    add_cotangent!(cotangent(cotangent(f̄, :form), :κ), κ̄)
    add_param!(cotangent(f̄, :demand), f.demand, c̄, g, t)
    return _set(ȳ, f.from, ȳ[f.from] + s̄)
end

# The first flow's mirror, or `nothing` when the flows have none.
_head(::Nothing) = nothing
_head(x̄::Tuple) = first(x̄)

# `Σ_f r_f ā_to(f)` over the rate flows out of pool `i`, exits
# adding nothing.
_arrivals_back(::Tuple{}, ā, i, g, t, B) = B
function _arrivals_back(fs::Tuple, ā, i, g, t, B)
    f = first(fs)
    if f.from == i && f.to > 0
        B += _rate(f, g, t) * ā[f.to]
    end
    return _arrivals_back(Base.tail(fs), ā, i, g, t, B)
end

# The cotangent of one group's pools `x` before the flows, from
# those of the pools `ȳ` and arrivals `ā` after them; the flows'
# parameter cotangents are added into their mirrors `f̄s`.
function _flows_pullback(fs::_Counts, f̄s, x::NTuple{N}, ȳout, ā, g, t) where {N}
    return _counts_back(fs, f̄s, x, ntuple(_ -> zero(first(x)), Val(N)), ȳout, ā, g, t)
end
function _flows_pullback(fs, f̄s, x::NTuple{N}, ȳout, ā, g, t) where {N}
    z = zero(first(x))
    L = ntuple(i -> _leaves(fs, i, g, t, z), Val(N))
    y0 = ntuple(i -> (L[i][1] - L[i][3]) * x[i], Val(N))
    y, a = _spread(fs, x, L, y0, ntuple(_ -> zero(first(y0)), Val(N)), g, t)
    ȳ = _counts_back(fs, f̄s, y, a, ȳout, ā, g, t)
    # The hazard and share arrivals feed both the pools and the state.
    āt = ntuple(j -> ȳ[j] + ā[j], Val(N))
    H = ntuple(i -> _out(_rate, fs, i, g, t, z), Val(N))
    B = ntuple(i -> _arrivals_back(fs, āt, i, g, t, zero(eltype(āt))), Val(N))
    _rates_back!(fs, f̄s, x, L, H, B, ȳ, āt, g, t)
    return ntuple(Val(N)) do i
        E, gH, P = L[i]
        (E - P) * ȳ[i] + gH * B[i] + _shares_back(fs, āt, i, g, t, zero(gH))
    end
end

# `Σ_f p_f ā_to(f)` over the share flows out of pool `i`.
_shares_back(::Tuple{}, ā, i, g, t, z) = z
function _shares_back(fs::Tuple, ā, i, g, t, z)
    f = first(fs)
    if f.from == i && f.to > 0
        z += _share(f, g, t) * ā[f.to]
    end
    return _shares_back(Base.tail(fs), ā, i, g, t, z)
end

# Each rate takes `x_i (g ā_to + g′ B_i - e^{-H_i} ȳ_i)` and each share
# `x_i (ā_to - ȳ_i)`, with `ā_to = 0` for an exit.
_rates_back!(::Tuple{}, f̄s, x, L, H, B, ȳ, ā, g, t) = nothing
function _rates_back!(fs::Tuple, f̄s, x, L, H, B, ȳ, ā, g, t)
    _rate_back!(first(fs), _head(f̄s), x, L, H, B, ȳ, ā, g, t)
    return _rates_back!(Base.tail(fs), _tail(f̄s), x, L, H, B, ȳ, ā, g, t)
end
_rate_back!(f::_Count, f̄, x, L, H, B, ȳ, ā, g, t) = nothing
function _rate_back!(f::Flow{<:Any, Hazard}, f̄, x, L, H, B, ȳ, ā, g, t)
    i = f.from
    E, gH, _ = L[i]
    āto = f.to > 0 ? ā[f.to] : zero(eltype(ā))
    r̄ = x[i] * (gH * āto + _leave_slope(H[i], E, gH) * B[i] - E * ȳ[i])
    add_param!(cotangent(f̄, :demand), f.demand, r̄, g, t)
    return nothing
end
function _rate_back!(f::Flow{<:Any, Share}, f̄, x, L, H, B, ȳ, ā, g, t)
    i = f.from
    āto = f.to > 0 ? ā[f.to] : zero(eltype(ā))
    add_param!(cotangent(f̄, :demand), f.demand, x[i] * (āto - ȳ[i]), g, t)
    return nothing
end

# Each flow's parameter against the groups, unrolled over the tuple so each
# flow's check is compiled for its type.
_check_flow_groups(::Tuple{}, G) = nothing
function _check_flow_groups(fs::Tuple, G)
    f = first(fs)
    _check_param_strata(_Named(:demand, f), f.demand, G)
    return _check_flow_groups(Base.tail(fs), G)
end

# A flow parameter's name in errors, such as `demand of Flow(1 => 2)`.
# Printed only when an error is thrown, so a check that passes builds no
# string.
struct _Named
    name::Symbol
    from::Int
    to::Int
end
_Named(name, f::Flow) = _Named(name, f.from, f.to)
function Base.print(io::IO, n::_Named)
    return print(io, n.name, " of Flow(", n.from, " => ", n.to, ")")
end
