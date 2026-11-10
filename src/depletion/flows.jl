# Flows between the pools of a `Depletion`. A `Flow` moves part of one pool
# into another, or out, each step, by a form applied to its
# demand: a competing hazard rate (`Hazard()`, the default), a share
# (`Share()`) or a count capped by what is there (`Truncate()` or
# `Truncate(κ)`); `Flow`'s docstring gives how they combine.

@doc raw"""
The share flow form: a [`ComposableRecurrences.Flow`](@ref) with this form
moves a share ``p`` of the pool it leaves.

Flow ``f`` out of pool ``i``, with demand ``p_f``, moves

```math
m_f = p_f\, x_i,
```

with ``x_i`` the pool before the step's flows, alongside any
[`ComposableRecurrences.Hazard`](@ref) flows.
Shares out of one pool that sum to more than it holds leave it negative.
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

# The forms a flow takes: without an exponent, and without a draw's
# arguments.
const _FlowHazard = Hazard{Nothing, Nothing, Nothing, _Drop}
const _FlowCount = Truncate{<:Any, Nothing, Nothing, _Drop}
const _FlowForm = Union{_FlowHazard, Share, _FlowCount}

# Marks the inner constructor of a flow whose ends `P` are already checked,
# which, unlike an outer function, can build the type with `new`.
struct _Placed end

@doc raw"""
A flow from pool `from` into pool `to` of a
[`ComposableRecurrences.Depletion`](@ref), out of it with `to = 0` or into
it with `from = 0`, that moves its `demand` by a form.

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
| [`ComposableRecurrences.Truncate`](@ref) | a count | ``\min\big(d_f, \max(x, 0)\big)``, or a smooth one with `Truncate(κ)` |

The hazard rates out of one pool compete, as in the `Hazard` depletion
form, so together they move ``x (1 - e^{-H})``; with non-negative, finite
rates a non-negative pool stays non-negative.
A per-step probability ``p < 1`` is the rate ``-\log(1 - p)``.
A constant rate out of a compartment is a geometric stay in it; for
another stay, convolve the inflow with its
[survival](@ref tutorial-occupancy).
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
Each share is between 0 and 1, checked unless it is a [`Derived`](@ref),
which is only known at each step.
Shares out of one pool that sum to more than ``e^{-H_i}`` leave it
negative.
A negative count adds ``-d_f`` to pool `from`, without a cap, and moves
nothing into `to`.
A flow from `0` is a count from outside the `Depletion`, which never runs out:
it moves ``m_f = d_f`` into `to`, and a negative one moves nothing.
Its form is `Truncate()` or `Truncate(κ)`.
The derivative through ``\min`` and ``\max`` takes the active branch.
Rates are not checked.

# Arguments
- `pools`: `from => to`, each a pool's name or its position from 1, with
  `to = 0` to leave the `Depletion` and `from = 0` to enter it.
- `demand`: the rate, share or count, a
  [parameter](@ref ComposableRecurrences.param) read at each step's group
  and time, with `PerStratum` holding one per group.

# Keyword Arguments
- `form`: `Hazard()`, the default, `Share()`, `Truncate()` or
  `Truncate(κ)`.

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
struct Flow{D, F <: _FlowForm, E, P}
    "The pool the flow leaves, by name or position."
    from::E
    "The pool it enters, by name or position, or `0` when it leaves."
    to::E
    "The rate, share or count, a parameter."
    demand::D
    "How the demand moves: `Hazard()`, `Share()`, `Truncate()` or `Truncate(κ)`."
    form::F
    Base.@constprop :aggressive function Flow(from, to, demand, form::F) where {F}
        d = _check_flow(from, to, demand, form)
        # A share is a fraction of the pool it leaves.
        form isa Share && _check_unit(:demand, d)
        E = Union{typeof(from), typeof(to)}
        return new{typeof(d), F, E, (from, to)}(from, to, d, form)
    end
    # A flow with ends `P` already checked, such as one placed among its
    # `Depletion`'s pools or rebuilt from its fields. A kernel launch
    # adapts the demand to device arrays, which the host cannot read entry
    # by entry, so this checks everything but those entries: a number's
    # share is still checked.
    function Flow(::_Placed, ::Type{E}, ::Val{P}, demand, form::F) where {E, P, F}
        d = _check_flow(P[1], P[2], demand, form)
        form isa Share && d isa Real && _check_unit(:demand, d)
        return new{typeof(d), F, E, P}(P[1], P[2], d, form)
    end
end

# The checks on a flow's ends, form and demand that read no demand entries;
# returns the demand.
function _check_flow(from, to, demand, form)
    _check_end(:from, from)
    _check_end(:to, to)
    from == to && throw(
        ArgumentError(
            "a flow joins two different pools, got $(repr(from)) => $(repr(to))"
        )
    )
    form isa _FlowForm || _bad_flow_form(form)
    from isa Integer && iszero(from) && !(form isa _TruncateForm) && throw(
        ArgumentError(
            "a flow from outside the Depletion is a count, with form Truncate() " *
                "or Truncate(κ), got $(_describe(form))"
        )
    )
    return _check_param(:demand, demand)
end

# A flow's ends, read from its type, so the step's selects at them fold.
_from(::Flow{<:Any, <:Any, <:Any, P}) where {P} = P[1]
_to(::Flow{<:Any, <:Any, <:Any, P}) where {P} = P[2]
# A rebuild from its fields, as a local derivative or a kernel launch
# makes, keeps its ends, so its type infers; new ends make a new `Flow`.
function ConstructionBase.constructorof(
        ::Type{<:Flow{<:Any, <:Any, E, P}}
    ) where {E, P}
    return function (from, to, d, form)
        (from, to) == P || _moved_ends(from, to, d, form)
        return Flow(_Placed(), E, Val(P), d, form)
    end
end

@noinline function _moved_ends(from, to, d, form)
    _check_flow(from, to, d, form)
    throw(
        ArgumentError(
            "a rebuilt flow keeps its ends, got $(repr(from)) => $(repr(to)); " *
                "build a new Flow to move them"
        )
    )
end

@noinline function _bad_flow_form(form)
    form isa Union{_ExponentForm, _TruncateForm} &&
        _draw_args(form) !== (nothing, nothing, _Drop()) && throw(
        ArgumentError(
            "weights, into and overflow are a draw's arguments, which a flow " *
                "does not take, got $(_describe(form))"
        )
    )
    form isa Hazard && throw(
        ArgumentError(
            "a flow's Hazard() takes no exponent: its demand is the rate, got " *
                _describe(form)
        )
    )
    throw(
        ArgumentError(
            "a flow's form is Hazard(), Share(), Truncate() or " *
                "Truncate(κ), got $(_describe(form))"
        )
    )
end

# Literal ends, as in `Flow(:S => :V, r)`, reach the type by constant
# propagation, so a `Depletion` of such flows infers.
Base.@constprop :aggressive function Flow(pools::Pair, demand; form = Hazard())
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
_check_end(name, x::Symbol) = nothing
function _check_end(name, x::Int)
    x >= 0 || throw(
        ArgumentError(
            "$name is a pool from 1, or 0 for outside the Depletion, got $name = $x"
        )
    )
    return nothing
end

# The flow with its ends as positions among the pools `names`, found from
# the types, so the placed flow's type infers whether or not the flow was
# built where its ends are literals.
function _placed(f::Flow{<:Any, <:Any, <:Any, P}, ::Val{names}) where {P, names}
    from, to = _positions(Val(P), Val(names))
    from === nothing && _unknown_pool(P[1], names, f)
    to === nothing && _unknown_pool(P[2], names, f)
    return Flow(_Placed(), Int, Val((from, to)), f.demand, f.form)
end
# An end's position among `names`: `0` outside, `nothing` for a name that is
# not a pool or a position past the last.
_end_position(x::Int, names) = x == 0 || x <= length(names) ? x : nothing
_end_position(x::Symbol, names) = findfirst(==(x), names)
# After `_end_position`: a generator sees only the methods defined before
# it, so it cannot use `_position`, which `pool.jl` defines later.
@generated function _positions(::Val{P}, ::Val{names}) where {P, names}
    return (_end_position(P[1], names), _end_position(P[2], names))
end
@noinline function _unknown_pool(x, names, f)
    throw(
        ArgumentError(
            "Flow($(repr(_from(f))) => $(repr(_to(f)))) names pool $(repr(x)), " *
                "but the pools are $(repr(names))"
        )
    )
end

# A count flow, which moves its demand up to what the pool holds.
const _Count = Flow{<:Any, <:_FlowCount}

# The hazard rate and share of a flow, zero for another form.
_rate(f::Flow{<:Any, _FlowHazard}, g, t) = param(f.demand, g, t)
_rate(f::Flow, g, t) = false
_share(f::Flow{<:Any, Share}, g, t) = param(f.demand, g, t)
_share(f::Flow, g, t) = false

# Sum `h(f, g, t)` over the flows out of pool `i`.
@inline function _out(h, fs::Tuple, i, g, t, z)
    add = @inline function (s, f, _)
        x = h(f, g, t)
        return s + ifelse(_from(f) == i, x, zero(x))
    end
    return _tuple_fold(add, z, fs)
end

# `exp(-H)` and the share that leaves per unit hazard,
# `g(H) = (1 - exp(-H)) / H`. Near zero `g` is 0/0, so it takes its series;
# the arm follows the primal value, and the guarded division keeps the
# unused arm finite.
function _leave(H)
    small = abs(_primal_value(H)) < _series_cut(H)
    Hd = ifelse(small, one(H), H)
    E, em = _exp_neg(H)
    g = ifelse(small, evalpoly(H, _coefficients(H, _LEAVE)), -em / Hd)
    return E, g
end

# The slope `g′(H) = (exp(-H) - g) / H`, with its series near zero.
function _leave_slope(H, E, g)
    small = abs(_primal_value(H)) < _series_cut(H)
    Hd = ifelse(small, one(H), H)
    return ifelse(small, evalpoly(H, _coefficients(H, _SLOPE)), (E - g) / Hd)
end

# The series of `g` and `g′` about zero, as products rather than divisions.
const _LEAVE = (1, -1 / 2, 1 / 6, -1 / 24, 1 / 120, -1 / 720, 1 / 5040)
const _SLOPE = (-1 / 2, 1 / 3, -1 / 8, 1 / 30, -1 / 144, 1 / 840)
_coefficients(H, c) = map(float(_primal_type(typeof(H))), c)

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

# Tuple entry `i` of `x`, chosen by `ifelse` in a fold over the entries, so
# the tuple is read where it is held, without an indexed load.
_get(x::Tuple, i) = _tuple_fold(@inline((v, y, j) -> ifelse(j == i, y, v)), first(x), x)

# What moves out of pool `i` per unit held, `(e^{-H}, g(H), P)`.
@inline function _leaves(fs, i, g, t, z)
    E, gH = _leave(_out(_rate, fs, i, g, t, z))
    return E, gH, _out(_share, fs, i, g, t, z)
end
# Without a hazard flow nothing leaves at a rate, so `e^{-0}` and `g(0)` are
# one, exactly as `_leave` gives them, without the exponentials. The shares
# are summed in their own type, not the pools': under a dual number that
# would make each share's product with a pool one of two duals.
const _NoHazard = Tuple{Vararg{Flow{<:Any, <:Union{Share, _FlowCount}}}}
_leaves(fs::_NoHazard, i, g, t, z) = _no_hazard_leaves(fs, i, g, t)
_no_hazard_leaves(fs, i, g, t) = true, true, _out(_share, fs, i, g, t, false)

# The same for a step, which reads `g(H)` only where a hazard flow out of
# pool `i` enters a pool: elsewhere it is one, without its expm1 and
# divisions.
@inline function _step_leaves(fs, i, g, t, z)
    H = _out(_rate, fs, i, g, t, z)
    E, gH = _rated_into(fs, i) ? _leave(H) : (exp(-H), one(H))
    return E, gH, _out(_share, fs, i, g, t, z)
end
_step_leaves(fs::_NoHazard, i, g, t, z) = _leaves(fs, i, g, t, z)

# Leave terms for the forward step. A pool whose one hazard flow enters a
# pool moves `-expm1(-H)` of what it holds, so no `g(H)` is needed.
@inline function _group_leaves(fs, i, g, t, z)
    return _group_leaves(fs, i, Val(_leave_kind(fs, i)), g, t, z)
end
# No hazard flow out: `e^{-0}` and `g(0)` are one, with no dual exponential.
@inline _group_leaves(fs, i, ::Val{:none}, g, t, z) = _no_hazard_leaves(fs, i, g, t)
@inline _group_leaves(fs, i, ::Val{:step}, g, t, z) = _step_leaves(fs, i, g, t, z)
@inline function _group_leaves(fs, i, ::Val{:moved}, g, t, z)
    E, em = _exp_neg(_out(_rate, fs, i, g, t, z))
    return E, _Moved(-em), _out(_share, fs, i, g, t, z)
end

# The share of a pool its one hazard flow moves, in place of `g(H)`.
struct _Moved{T}
    F::T
end

# What a flow moves per unit held at its rate: `r g(H)`, or the share its
# pool's one hazard flow moves. The `_Moved` is that of the flow's own pool,
# which has one hazard flow, so it is this flow's. Other forms have rate
# zero, as `_rate` gives them.
_by_rate(f, g, t, gH) = _rate(f, g, t) * gH
_by_rate(f::Flow{<:Any, _FlowHazard}, g, t, w::_Moved) = w.F
_by_rate(f::Flow, g, t, w::_Moved) = _rate(f, g, t)

# Whether pool `i` has one hazard flow out, and it enters a pool.
_one_rated_into(fs, i) = _rated_into(fs, i) & (_hazards_out(fs, i) == 1)
# Which leave terms pool `i` takes: `:none` with no hazard flow out,
# `:moved` with one that enters a pool, else `:step`.
function _leave_kind(fs, i)
    _hazards_out(fs, i) == 0 && return :none
    return _one_rated_into(fs, i) ? :moved : :step
end
# `_group_leaves` for each of `N` pools, with the pool and its `_leave_kind`
# written in as constants, read from the flows' types, which hold their
# ends. Past 32 flows `_leave_kind` is not folded to a constant for each
# pool, and under dual numbers an index into a tuple of the answers is not
# either, so the pools' leave terms would be held boxed.
@generated function _group_leaves_each(fs::Tuple, g, t, z, ::Val{N}) where {N}
    ok = N isa Int && all(f -> f <: Flow && isconcretetype(f), fs.parameters)
    ok || return :(ntuple(i -> _group_leaves(fs, i, g, t, z), Val(N)))
    hazard = [f <: Flow{<:Any, _FlowHazard} for f in fs.parameters]
    ends = [f.parameters[4] for f in fs.parameters]
    function kind(i)
        out = [k for k in eachindex(ends) if hazard[k] && ends[k][1] == i]
        isempty(out) && return QuoteNode(:none)
        return QuoteNode(length(out) == 1 && ends[only(out)][2] > 0 ? :moved : :step)
    end
    calls = (:(_group_leaves(fs, $i, Val{$(kind(i))}(), g, t, z)) for i in 1:N)
    return Expr(:block, Expr(:meta, :inline), Expr(:tuple, calls...))
end

# The number of hazard flows out of pool `i`.
function _hazards_out(fs::Tuple, i)
    count = @inline (n, f, _) -> n + (f isa Flow{<:Any, _FlowHazard} && _from(f) == i)
    return _tuple_fold(count, 0, fs)
end

# Whether a hazard flow out of pool `i` enters a pool.
function _rated_into(fs::Tuple, i)
    into = @inline function (b, f, _)
        return b | (f isa Flow{<:Any, _FlowHazard} && _from(f) == i && _to(f) > 0)
    end
    return _tuple_fold(into, false, fs)
end

# Add each hazard and share flow's amount into the pool it enters, in
# `y` and the arrivals `a`.
@inline function _spread(fs::Tuple, x, L, y, a, g, t)
    spread = @inline ((y, a), f, _) -> _spread_one(f, x, L, y, a, g, t)
    return _tuple_fold(spread, (y, a), fs)
end
_spread_one(f::_Count, x, L, y, a, g, t) = (y, a)
@inline function _spread_one(f::Flow, x, L, y, a, g, t)
    _to(f) > 0 || return (y, a)
    _, gH, _ = L[_from(f)]
    m = x[_from(f)] * (_by_rate(f, g, t, gH) + _share(f, g, t))
    return _add(y, _to(f), m), _add(a, _to(f), m)
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
_moved(::_HardTruncate, a, s) = _removal(a, s)
_moved(form::_SoftTruncate, a, s) = _soft_min(form.κ, a, _pool_left(s))
function _moved_back(::_HardTruncate, a, s, m̄)
    ā, s̄ = _removal_pullback(a, s, m̄)
    return ā, s̄, zero(m̄)
end
function _moved_back(form::_SoftTruncate, a, s, m̄)
    ā, c̄, κ̄ = _soft_min_back(form.κ, a, _pool_left(s), m̄)
    return ā, ifelse(s > 0, c̄, zero(c̄)), κ̄
end

# The count flows in order on the pools `y` and arrivals `a`.
@inline function _counts(fs::Tuple, y, a, g, t)
    return _tuple_fold(@inline(((y, a), f, _) -> _count(f, y, a, g, t)), (y, a), fs)
end
_count(f::Flow, y, a, g, t) = y, a
_count(f::_Count, y, a, g, t) = _count_demand(f, param(f.demand, g, t), y, a)
# One pass over the pools, by `ifelse`, for the count's demand `c`: a flow
# out of the system (`to = 0`) adds to no pool.
@inline function _count_demand(f::_Count, c, y, a)
    i, j = _from(f), _to(f)
    m = _moved(f.form, c, _source(y, i))
    p = _moved_in(m)
    y′ = ntuple(Val(length(y))) do l
        return ifelse(l == i, y[l] - m, ifelse(l == j, y[l] + p, y[l]))
    end
    return y′, _add(a, j, p)
end

# What pool `i` holds for a count out of it, or an unbounded pool for a
# count from outside the `Depletion` (`i = 0`), so the count moves its demand.
_source(y, i) = ifelse(i == 0, oftype(first(y), Inf), _get(y, i))

# Count flows only, such as a depletion's removals: nothing moves at a
# rate or as a share, so the counts act on `x` directly.
const _Counts = Tuple{Vararg{_Count}}

# One group's step: the pools `x` after the flows, and arrivals.
function _flow_group(fs::_Counts, x::NTuple{N}, g, t) where {N}
    return _counts(fs, x, ntuple(_ -> zero(first(x)), Val(N)), g, t)
end

# Inlined, with the spread of the rates and shares, so that a step on dual
# numbers passes no tuple of them through a call, which cost a filling
# pool's step about 40% in forward mode.
@inline _flow_group(fs, x, g, t) = _flow_step(fs, x, g, t, Val(true))
@inline function _flow_step(fs, x::NTuple{N}, g, t, keep_arrivals) where {N}
    z = zero(first(x))
    L = _group_leaves_each(fs, g, t, z, Val(N))
    # No name a closure captures is reassigned, or the closure would box it.
    y0 = ntuple(@inline(i -> (L[i][1] - L[i][3]) * x[i]), Val(N))
    y, a = _spread(fs, x, L, y0, _start_arrivals(keep_arrivals, y0), g, t)
    return _counts(fs, y, a, g, t)
end
# The arrivals before the flows: zeros, or `nothing` when they are not
# kept, which the flows' `_add` passes through.
@inline _start_arrivals(::Val{true}, y::NTuple{N}) where {N} = ntuple(_ -> zero(first(y)), Val(N))
@inline _start_arrivals(::Val{false}, y) = nothing

# The pools after the flows, without the arrivals, which are not built.
_flow_only(fs::_Counts, x, g, t) = first(_counts(fs, x, nothing, g, t))
@inline _flow_only(fs, x, g, t) = first(_flow_step(fs, x, g, t, Val(false)))

# The amount each flow moves at one step, in the order given, from the
# pools `x`: a hazard or share flow's from `x`, as the step spreads it,
# and a count's from what remains when it acts.
function _amounts(fs, x::NTuple{N}, g, t) where {N}
    z = zero(first(x))
    L = ntuple(i -> _leaves(fs, i, g, t, z), Val(N))
    y0 = ntuple(i -> (L[i][1] - L[i][3]) * x[i], Val(N))
    y, _ = _spread(fs, x, L, y0, ntuple(_ -> zero(first(y0)), Val(N)), g, t)
    return _amounts_each(fs, x, L, y, g, t)
end
function _amounts_each(fs::Tuple, x, L, y, g, t)
    return _tuple_scan(@inline((y, f, _) -> _amount(f, x, L, y, g, t)), y, fs)
end
function _amount(f::Flow, x, L, y, g, t)
    return x[_from(f)] * (_rate(f, g, t) * L[_from(f)][2] + _share(f, g, t)), y
end
function _amount(f::_Count, x, L, y, g, t)
    m = _moved(f.form, param(f.demand, g, t), _source(y, _from(f)))
    return m, first(_count(f, y, nothing, g, t))
end

# The cotangent of one group's pools `x` from those of the amounts, `r̄`,
# one per flow; the flows' parameter cotangents are added into `f̄s`. As in
# `_flows_pullback`, with a hazard or share flow's amount `m_f` taking its
# own cotangent and that of the pool it enters, `q_f = r̄_f + ȳ_to`, where
# the step's pullback takes the second only, and each count adding its own.
function _amounts_pullback(fs, f̄s, r̄, x::NTuple{N}, g, t) where {N}
    z = zero(first(x))
    L = ntuple(i -> _leaves(fs, i, g, t, z), Val(N))
    y0 = ntuple(i -> (L[i][1] - L[i][3]) * x[i], Val(N))
    y, _ = _spread(fs, x, L, y0, ntuple(_ -> zero(first(y0)), Val(N)), g, t)
    z̄ = zero(promote_type(eltype(x), eltype(r̄)))
    ȳ = _amount_counts_back(fs, f̄s, r̄, y, ntuple(_ -> z̄, Val(N)), g, t)
    q = _amount_cotangents(fs, r̄, ȳ)
    H = ntuple(i -> _out(_rate, fs, i, g, t, z), Val(N))
    B = ntuple(i -> _rated(fs, q, i, g, t, z̄), Val(N))
    _amount_rates_back!(fs, f̄s, q, x, L, H, B, ȳ, g, t)
    return ntuple(Val(N)) do i
        E, gH, P = L[i]
        (E - P) * ȳ[i] + gH * B[i] + _shared(fs, q, i, g, t, z̄)
    end
end

# The counts' pullback, last first, from the cotangent `ȳ` of the pools
# after them, each count's own amount cotangent added to its move's.
function _amount_counts_back(fs::Tuple, f̄s, r̄, y, ȳ, g, t)
    fwd(y, (f, _), _) = (first(_count(f, y, nothing, g, t)), y)
    back(ȳ, (f, f̄), y, k) = _amount_count_back(f, f̄, r̄[k], y, ȳ, g, t)
    return _tuple_forward_back(fwd, back, y, ȳ, _with_mirrors(fs, f̄s))
end
_amount_count_back(f::Flow, f̄, r̄, y, ȳ, g, t) = ȳ
function _amount_count_back(f::_Count, f̄, r̄, y, ȳ, g, t)
    i = _from(f)
    c = param(f.demand, g, t)
    s = _source(y, i)
    m = _moved(f.form, c, s)
    m̄ = r̄ + ifelse(i == 0, zero(r̄), -_get(ȳ, i))
    if _to(f) > 0 && _primal_value(m) >= 0
        m̄ += ȳ[_to(f)]
    end
    c̄, s̄, κ̄ = _moved_back(f.form, c, s, m̄)
    add_cotangent!(cotangent(cotangent(f̄, :form), :κ), κ̄)
    add_param!(cotangent(f̄, :demand), f.demand, c̄, g, t)
    return _set(ȳ, i, _get(ȳ, i) + s̄)
end

# Each flow's `q_f`: its amount's cotangent, and the cotangent of the pool
# it enters for a hazard or share flow.
function _amount_cotangents(fs::Tuple, r̄, ȳ)
    return _tuple_map_index(fs) do f, k
        f isa _Count || _to(f) == 0 ? r̄[k] : r̄[k] + ȳ[_to(f)]
    end
end

# `Σ_f r_f q_f` over the rate flows out of pool `i`, and `Σ_f p_f q_f` over
# the share flows.
function _rated(fs::Tuple, q, i, g, t, B)
    return _tuple_fold((B, f, k) -> _from(f) == i ? B + _rate(f, g, t) * q[k] : B, B, fs)
end
function _shared(fs::Tuple, q, i, g, t, z)
    return _tuple_fold((z, f, k) -> _from(f) == i ? z + _share(f, g, t) * q[k] : z, z, fs)
end

# Each rate takes `x_i (g q_f + g′ B_i - e^{-H_i} ȳ_i)` and each share
# `x_i (q_f - ȳ_i)`.
function _amount_rates_back!(fs::Tuple, f̄s, q, x, L, H, B, ȳ, g, t)
    return _tuple_fold(nothing, _with_mirrors(fs, f̄s)) do _, (f, f̄), k
        _amount_rate_back!(f, f̄, q[k], x, L, H, B, ȳ, g, t)
    end
end
_amount_rate_back!(f::_Count, f̄, q, x, L, H, B, ȳ, g, t) = nothing
function _amount_rate_back!(f::Flow{<:Any, _FlowHazard}, f̄, q, x, L, H, B, ȳ, g, t)
    i = _from(f)
    E, gH, _ = L[i]
    r̄ = x[i] * (gH * q + _leave_slope(H[i], E, gH) * B[i] - E * ȳ[i])
    add_param!(cotangent(f̄, :demand), f.demand, r̄, g, t)
    return nothing
end
function _amount_rate_back!(f::Flow{<:Any, Share}, f̄, q, x, L, H, B, ȳ, g, t)
    i = _from(f)
    add_param!(cotangent(f̄, :demand), f.demand, x[i] * (q - ȳ[i]), g, t)
    return nothing
end

# Reverse of the count flows: recurse forward, keeping each flow's input,
# then pull back last first. `ȳ` and `ā` are the cotangents after the
# flows; returns those before them. A demand that reads the outputs or has
# a map costs more to read than the rest of a count, so each count's
# demand `d`, its value and partials, is read once and serves both passes.
function _counts_back(fs::Tuple, f̄s, y, a, ȳ, ā, g, t)
    function fwd((y, a), (f, f̄), _)
        d = _demand(f, f̄, g, t)
        return _count_demand(f, first(d), y, a), (y, d)
    end
    back(ȳ, (f, f̄), (y, d), _) = _count_back(f, d, f̄, y, ȳ, ā, g, t)
    return _tuple_forward_back(fwd, back, (y, a), ȳ, _with_mirrors(fs, f̄s))
end
# What a count's pullback reads of its demand (`_param_partials`); a flow of
# another form moves no count.
_demand(f::_Count, f̄, g, t) = _param_partials(cotangent(f̄, :demand), f.demand, g, t)
_demand(f::Flow, f̄, g, t) = (nothing, nothing)
_count_demand(f::Flow, c, y, a) = y, a
_count_back(f::Flow, d, f̄, y, ȳ, ā, g, t) = ȳ
# A count from outside the `Depletion` (`from = 0`) takes from no pool, so its
# source has no cotangent.
function _count_back(f::_Count, d, f̄, y, ȳ, ā, g, t)
    c, ∂ = d
    i = _from(f)
    s = _source(y, i)
    m = _moved(f.form, c, s)
    m̄ = ifelse(i == 0, zero(eltype(ȳ)), -_get(ȳ, i))
    if _to(f) > 0 && _primal_value(m) >= 0
        m̄ += ȳ[_to(f)] + ā[_to(f)]
    end
    c̄, s̄, κ̄ = _moved_back(f.form, c, s, m̄)
    add_cotangent!(cotangent(cotangent(f̄, :form), :κ), κ̄)
    _add_param_partials!(cotangent(f̄, :demand), f.demand, c̄, ∂, g, t)
    return _set(ȳ, i, _get(ȳ, i) + s̄)
end

# The first flow's mirror, or `nothing` when the flows have none.
_head(::Nothing) = nothing
_head(x̄::Tuple) = first(x̄)
# Each flow paired with its mirror, or with `nothing`.
_with_mirrors(fs, ::Nothing) = _tuple_map(f -> (f, nothing), fs)
_with_mirrors(fs, f̄s::Tuple) = _tuple_zip(fs, f̄s)

# `Σ_f r_f ā_to(f)` over the rate flows out of pool `i`, exits
# adding nothing.
function _arrivals_back(fs::Tuple, ā, i, g, t, B)
    return _tuple_fold(B, fs) do B, f, _
        _from(f) == i && _to(f) > 0 ? B + _rate(f, g, t) * ā[_to(f)] : B
    end
end

# The cotangent of one group's pools `x` before the flows, from
# those of the pools `ȳ` and arrivals `ā` after them; the flows'
# parameter cotangents are added into their mirrors `f̄s`.
function _flows_pullback(fs::_Counts, f̄s, x::NTuple{N}, ȳout, ā, g, t) where {N}
    return _counts_back(fs, f̄s, x, ntuple(_ -> zero(first(x)), Val(N)), ȳout, ā, g, t)
end
# The leave terms are the step's, `_Moved` for a pool whose one hazard flow
# enters a pool.
function _flows_pullback(fs, f̄s, x::NTuple{N}, ȳout, ā, g, t) where {N}
    z = zero(first(x))
    L = _group_leaves_each(fs, g, t, z, Val(N))
    y0 = ntuple(@inline(i -> (L[i][1] - L[i][3]) * x[i]), Val(N))
    y, a = _spread(fs, x, L, y0, ntuple(_ -> zero(first(y0)), Val(N)), g, t)
    ȳ = _counts_back(fs, f̄s, y, a, ȳout, ā, g, t)
    # The hazard and share arrivals feed both the pools and the state.
    āt = ntuple(j -> ȳ[j] + ā[j], Val(N))
    H = ntuple(i -> _out(_rate, fs, i, g, t, z), Val(N))
    B = ntuple(i -> _arrivals_back(fs, āt, i, g, t, zero(eltype(āt))), Val(N))
    _rates_back!(fs, f̄s, x, L, H, B, ȳ, āt, g, t)
    # Inlined, so each pool reads its own leave terms from `L`, whose types
    # differ by pool, with a constant index.
    x̄ = @inline function (i)
        E, gH, P = L[i]
        return (E - P) * ȳ[i] + _leave_back(gH, B[i], fs, āt, i) +
            _shares_back(fs, āt, i, g, t, zero(E))
    end
    return ntuple(x̄, Val(N))
end

# What leaves pool `i` at a rate, against the arrivals' cotangents:
# `g(H) B_i`, or for a pool whose one hazard flow enters a pool, the share
# it moves times that pool's arrival cotangent.
_leave_back(gH, B, fs, ā, i) = gH * B
_leave_back(w::_Moved, B, fs, ā, i) = w.F * _hazard_arrival(fs, ā, i)
function _hazard_arrival(fs::Tuple, ā, i)
    return _tuple_fold(@inline((a, f, _) -> a + _arrival(f, ā, i)), zero(eltype(ā)), fs)
end
_arrival(f, ā, i) = zero(eltype(ā))
_arrival(f::Flow{<:Any, _FlowHazard}, ā, i) = _into(f, i) ? ā[_to(f)] : zero(eltype(ā))
_into(f, i) = _from(f) == i && _to(f) > 0

# `Σ_f p_f ā_to(f)` over the share flows out of pool `i`.
function _shares_back(fs::Tuple, ā, i, g, t, z)
    return _tuple_fold(z, fs) do z, f, _
        _from(f) == i && _to(f) > 0 ? z + _share(f, g, t) * ā[_to(f)] : z
    end
end

# Each rate takes its `_rate_bar` and each share `x_i (ā_to - ȳ_i)`, with
# `ā_to = 0` for an exit.
function _rates_back!(fs::Tuple, f̄s, x, L, H, B, ȳ, ā, g, t)
    return _tuple_fold(nothing, _with_mirrors(fs, f̄s)) do _, (f, f̄), _
        _rate_back!(f, f̄, x, L, H, B, ȳ, ā, g, t)
    end
end
_rate_back!(f::_Count, f̄, x, L, H, B, ȳ, ā, g, t) = nothing
function _rate_back!(f::Flow{<:Any, _FlowHazard}, f̄, x, L, H, B, ȳ, ā, g, t)
    i = _from(f)
    E, gH, _ = L[i]
    āto = _to(f) > 0 ? ā[_to(f)] : zero(eltype(ā))
    r̄ = _rate_bar(x[i], E, gH, H[i], B[i], āto, ȳ[i])
    add_param!(cotangent(f̄, :demand), f.demand, r̄, g, t)
    return nothing
end
# The rate's cotangent `x (g ā_to + g′ B - e^{-H} ȳ)`; with one hazard flow
# out of the pool, `d(H g)/dH = e^{-H}`, so it is `x e^{-H} (ā_to - ȳ)`.
_rate_bar(x, E, gH, H, B, āto, ȳ) = x * (gH * āto + _leave_slope(H, E, gH) * B - E * ȳ)
_rate_bar(x, E, w::_Moved, H, B, āto, ȳ) = x * E * (āto - ȳ)
function _rate_back!(f::Flow{<:Any, Share}, f̄, x, L, H, B, ȳ, ā, g, t)
    i = _from(f)
    āto = _to(f) > 0 ? ā[_to(f)] : zero(eltype(ā))
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
_Named(name, f::Flow) = _Named(name, _from(f), _to(f))
function Base.print(io::IO, n::_Named)
    return print(io, n.name, " of Flow(", n.from, " => ", n.to, ")")
end
