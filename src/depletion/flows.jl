# Flows between the pools of a `Depletion`.

# == Share ==

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

# == Split ==

@doc raw"""
The split flow form: a [`ComposableRecurrences.Flow`](@ref) with this form
draws one count ``b`` from several pools, in proportion to the pools the
step starts from.

A split flow names its sources as a tuple, `(i_1, …, i_n) => to`, with
``n \ge 2``.
With ``w_j`` the pool ``i_j`` before the step's flows and
``W = \sum_j w_j``, source ``j``'s share is

```math
c_j = b\, \frac{w_j}{W},
```

or, when ``W \le 0``, all of ``b`` for the first source.
A source that holds less than its share when the flow runs passes the
part it cannot cover, ``\max(c_j - y_j, 0)`` with ``y_j`` what it holds,
to the other sources in proportion to their ``w``, or to the first other
source when theirs sum to zero or less.
Each source then loses its share and what it was passed, capped as a
`Truncate()` count is, and `to` gains what they lose.
`Split()` is a form for flows only, not a depletion form.

# Examples
Discharges ``b`` split between unconfirmed and confirmed patients by the
patients present at the start of each day, after half the unconfirmed
patients are confirmed.
On the second day the unconfirmed patients' share is 1.25, but they hold
0.75, so the confirmed patients take the other 0.5:

```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
leave = CR.Flow((:u, :c) => 0, CR.TimeVarying([2.0, 5.0]); form = CR.Split())
d = CR.Depletion(
    CR.Flow(:u => :c, 0.5; form = CR.Share()), leave; pools = (:u, :c)
)
Recurrence([true]; modifiers = (d,))(; history = [6.0; 2.0;;], stop = 2)

# output

2×2 Matrix{Float64}:
 1.5  0.0
 4.5  1.0
```
"""
struct Split end

# == Flow: type, construction and checks ==

# The forms a flow takes: without an exponent, and without a draw's
# arguments.
const _FlowHazard = Hazard{Nothing, Nothing, Nothing, _Drop}
const _FlowCount = Truncate{<:Any, Nothing, Nothing, _Drop}
const _FlowForm = Union{_FlowHazard, Share, _FlowCount, Split}

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
| [`ComposableRecurrences.Split`](@ref) | a count, from several pools | each source's part of ``d_f``, in proportion to the pools the step starts from |

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
  `to = 0` to leave the `Depletion` and `from = 0` to enter it; for
  `Split()`, `from` is a tuple of two or more pools.
- `demand`: the rate, share or count, a
  [parameter](@ref ComposableRecurrences.param) read at each step's group
  and time, with `PerStratum` holding one per group; a bare matrix is
  read as groups × time.

# Keyword Arguments
- `form`: `Hazard()`, the default, `Share()`, `Truncate()`,
  `Truncate(κ)` or `Split()`.

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
struct Flow{D, F <: _FlowForm, E, P, G}
    "The pool the flow leaves, by name or position; a tuple for `Split()`."
    from::E
    "The one pool it enters, by name or position, or `0` when it leaves."
    to::G
    "The rate, share or count, a parameter."
    demand::D
    "How the demand moves: `Hazard()`, `Share()`, `Truncate` or `Split()`."
    form::F
    Base.@constprop :aggressive function Flow(
            from, to, demand, form::F
        ) where {F}
        d = _check_flow(from, to, demand, form)
        # A share is a fraction of the pool it leaves.
        form isa Share && _check_unit(:demand, d)
        return new{typeof(d), F, typeof(from), (from, to), typeof(to)}(
            from, to, d, form
        )
    end
    # A flow with ends already checked. A kernel launch adapts the demand to
    # device arrays the host cannot read entry by entry, so those entries are
    # not checked; a number's share still is.
    function Flow(
            ::_Placed, ::Type{E}, ::Val{P}, demand, form::F
        ) where {E, P, F}
        d = _check_flow(P[1], P[2], demand, form)
        form isa Share && d isa Real && _check_unit(:demand, d)
        return new{typeof(d), F, typeof(P[1]), P, typeof(P[2])}(
            P[1], P[2], d, form
        )
    end
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

# The checks on a flow's ends, form and demand that read no demand entries;
# returns the demand.
function _check_flow(from, to, demand, form)
    d = _as_param(demand)
    _check_flow_parts(from, to, d, form)
    return d
end
# The checks alone, returning nothing, so that AD can take them as having
# no derivative.
function _check_flow_parts(from, to, demand, form)
    _check_end(:from, from)
    _check_end(:to, to)
    from == to && throw(
        ArgumentError(
            "a flow joins two different pools, got $(repr(from)) => $(repr(to))"
        )
    )
    form isa _FlowForm || _bad_flow_form(form)
    to isa Tuple && throw(
        ArgumentError(
            "a flow enters one pool, or 0 to leave, got to = $(repr(to))"
        )
    )
    _check_split(from, to, form)
    from isa Integer && iszero(from) && !(form isa Truncate) && throw(
        ArgumentError(
            "a flow from outside the Depletion is a count, with form " *
                "Truncate() or Truncate(κ), got $(_describe(form))"
        )
    )
    _check_param(:demand, demand)
    return nothing
end

# Several sources go with `Split()`, and `Split()` with several sources,
# each a pool of the `Depletion` other than `to`.
function _check_split(from::Tuple, to, form)
    form isa Split || throw(
        ArgumentError(
            "a flow from several pools has form Split(), got " *
                _describe(form)
        )
    )
    length(from) >= 2 || throw(
        ArgumentError(
            "a Split() flow draws from two or more pools, got " * repr(from)
        )
    )
    any(x -> x isa Integer && iszero(x), from) && throw(
        ArgumentError(
            "a Split() flow draws from pools of the Depletion, not 0, got " *
                repr(from)
        )
    )
    allunique(from) || throw(
        ArgumentError(
            "a Split() flow draws from different pools, got " * repr(from)
        )
    )
    to in from && throw(
        ArgumentError(
            "a Split() flow enters a pool it does not draw from, got " *
                "$(repr(from)) => $(repr(to))"
        )
    )
    return nothing
end
function _check_split(from, to, form)
    form isa Split && throw(
        ArgumentError(
            "a Split() flow draws from a tuple of pools, as " *
                "(:a, :b) => to, got $(repr(from)) => $(repr(to))"
        )
    )
    return nothing
end

# A flow's float type is its demand's and its form's: its ends hold no
# floats, and a split's tuple of them would stop the fields' unrolled read.
param_eltype(f::Flow) = promote_type(param_eltype(f.demand), param_eltype(f.form))

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
            "a rebuilt flow keeps its ends, got " *
                "$(repr(from)) => $(repr(to)); build a new Flow to move them"
        )
    )
end

@noinline function _bad_flow_form(form)
    form isa _BuiltinForm &&
        _draw_args(form) !== (nothing, nothing, _Drop()) && throw(
        ArgumentError(
            "weights, into and overflow are a draw's arguments, which a flow " *
                "does not take, got $(_describe(form))"
        )
    )
    form isa Hazard && throw(
        ArgumentError(
            "a flow's Hazard() takes no exponent: its demand is the rate, " *
                "got " * _describe(form)
        )
    )
    throw(
        ArgumentError(
            "a flow's form is Hazard(), Share(), Split(), Truncate() or " *
                "Truncate(κ), got $(_describe(form))"
        )
    )
end

# A flow's end: a pool's name, or its position from 1, with `0` outside.
_end(x::Symbol) = x
_end(x::Integer) = Int(x)
_end(x::Tuple) = map(_end, x)
function _end(x)
    throw(
        ArgumentError(
            "a flow's ends are pool names or positions, got " * _describe(x)
        )
    )
end
_check_end(name, x::Symbol) = nothing
_check_end(name, x::Tuple) = foreach(y -> _check_end(name, y), x)
function _check_end(name, x::Int)
    x >= 0 || throw(
        ArgumentError(
            "$name is a pool from 1, or 0 for outside the Depletion, " *
                "got $name = $x"
        )
    )
    return nothing
end

# == Placing a flow among its pools ==

# Found from the types, so the placed flow's type infers.
function _placed(f::Flow{<:Any, <:Any, <:Any, P}, ::Val{names}) where {P, names}
    from, to = _positions(Val(P), Val(names))
    from === nothing && _unknown_pool(_first_unknown(P[1], names), names, f)
    to === nothing && _unknown_pool(P[2], names, f)
    _check_split_placed(from, to, f)
    return Flow(_Placed(), typeof(from), Val((from, to)), f.demand, f.form)
end
# An end's position among `names`: `0` outside, `nothing` for a name that is
# not a pool or a position past the last.
_end_position(x::Int, names) = x == 0 || x <= length(names) ? x : nothing
_end_position(x::Symbol, names) = findfirst(==(x), names)
# A split's sources as positions: a name and a position for one pool are
# the same source, which the check on the ends as written cannot see.
_check_split_placed(from, to, f) = nothing
function _check_split_placed(from::Tuple, to, f)
    allunique(from) && !(to in from) && return nothing
    throw(
        ArgumentError(
            "Flow($(repr(_from(f))) => $(repr(_to(f)))) names one pool twice, " *
                "as sources or as a source and where it enters"
        )
    )
end
# The end to name in an error: a split's first unknown source.
_first_unknown(x, names) = x
function _first_unknown(x::Tuple, names)
    return x[something(findfirst(y -> _end_position(y, names) === nothing, x), 1)]
end
# A split flow's sources: their positions, or `nothing` if one is unknown.
function _end_position(x::Tuple, names)
    p = map(y -> _end_position(y, names), x)
    return any(isnothing, p) ? nothing : p
end
# After `_end_position`: a generator sees only the methods defined before
# it, so it cannot use `_position`, which `pool.jl` defines later.
@generated function _positions(::Val{P}, ::Val{names}) where {P, names}
    return (_end_position(P[1], names), _end_position(P[2], names))
end
@noinline function _unknown_pool(x, names, f)
    throw(
        ArgumentError(
            "Flow($(repr(_from(f))) => $(repr(_to(f)))) names pool " *
                "$(repr(x)), but the pools are $(repr(names))"
        )
    )
end

# == The step: leave terms, spread and counts ==

# A count flow, which moves its demand up to what the pool holds.
const _Count = Flow{<:Any, <:_FlowCount}
# A split flow, which draws one count from several pools.
const _SplitFlow = Flow{<:Any, Split}
const _CountLike = Union{_Count, _SplitFlow}

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

# Near zero `g(H) = (1 - exp(-H)) / H` is 0/0, so it takes its series; the
# arm follows the primal value, and the guarded division keeps the other
# arm finite.
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

# `ntuple` infers where `Base.setindex` with a runtime index does not.
function _set(x::Tuple, i, v)
    w = convert(eltype(x), v)
    return ntuple(j -> ifelse(j == i, w, x[j]), Val(length(x)))
end

# Tuple entry `i` of `x` plus `v`, or `x` for an `i` it lacks; arrivals of
# `nothing` are not kept.
function _add(x::Tuple, i, v)
    return ntuple(j -> ifelse(j == i, x[j] + v, x[j]), Val(length(x)))
end
_add(::Nothing, i, v) = nothing

# Tuple entry `i` of `x`, chosen by `ifelse` in a fold over the entries, so
# the tuple is read where it is held, without an indexed load.
function _get(x::Tuple, i)
    return _tuple_fold(@inline((v, y, j) -> ifelse(j == i, y, v)), first(x), x)
end

# What moves out of pool `i` per unit held, `(e^{-H}, g(H), P)`.
@inline function _leaves(fs, i, g, t, z)
    E, gH = _leave(_out(_rate, fs, i, g, t, z))
    return E, gH, _out(_share, fs, i, g, t, z)
end
# Without a hazard flow `e^{-0}` and `g(0)` are exactly one, as `_leave` gives
# them. Shares sum in their own type: in the pools' dual type each share's
# product with a pool would be one of two duals.
const _NoHazard = Tuple{Vararg{Flow{<:Any, <:Union{Share, _FlowCount, Split}}}}
_leaves(fs::_NoHazard, i, g, t, z) = _no_hazard_leaves(fs, i, g, t)
_no_hazard_leaves(fs, i, g, t) = true, true, _out(_share, fs, i, g, t, false)

# A step reads `g(H)` only where a hazard flow out of pool `i` enters a pool:
# elsewhere it is one, without its expm1 and divisions.
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
@inline function _group_leaves(fs, i, ::Val{:none}, g, t, z)
    return _no_hazard_leaves(fs, i, g, t)
end
@inline function _group_leaves(fs, i, ::Val{:step}, g, t, z)
    return _step_leaves(fs, i, g, t, z)
end
@inline function _group_leaves(fs, i, ::Val{:moved}, g, t, z)
    E, em = _exp_neg(_out(_rate, fs, i, g, t, z))
    return E, _Moved(-em), _out(_share, fs, i, g, t, z)
end

# The share of a pool its one hazard flow moves, in place of `g(H)`.
struct _Moved{T}
    F::T
end

# The `_Moved` is that of the flow's own pool, which has one hazard flow, so
# it is this flow's. Other forms have rate zero, as `_rate` gives them.
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
# The pool and its `_leave_kind` are written in as constants: past 32 flows
# neither folds, and the pools' leave terms would be held boxed.
@generated function _group_leaves_each(fs::Tuple, g, t, z, ::Val{N}) where {N}
    ok = N isa Int && all(f -> f <: Flow && isconcretetype(f), fs.parameters)
    ok || return :(ntuple(i -> _group_leaves(fs, i, g, t, z), Val(N)))
    hazard = [f <: Flow{<:Any, _FlowHazard} for f in fs.parameters]
    ends = [f.parameters[4] for f in fs.parameters]
    function kind(i)
        out = [k for k in eachindex(ends) if hazard[k] && ends[k][1] == i]
        isempty(out) && return QuoteNode(:none)
        moved = length(out) == 1 && ends[only(out)][2] > 0
        return QuoteNode(moved ? :moved : :step)
    end
    calls = (:(_group_leaves(fs, $i, Val{$(kind(i))}(), g, t, z)) for i in 1:N)
    return Expr(:block, Expr(:meta, :inline), Expr(:tuple, calls...))
end

# The number of hazard flows out of pool `i`.
function _hazards_out(fs::Tuple, i)
    count = @inline function (n, f, _)
        return n + (f isa Flow{<:Any, _FlowHazard} && _from(f) == i)
    end
    return _tuple_fold(count, 0, fs)
end

# Whether a hazard flow out of pool `i` enters a pool.
function _rated_into(fs::Tuple, i)
    into = @inline function (b, f, _)
        hazard = f isa Flow{<:Any, _FlowHazard}
        return b | (hazard && _from(f) == i && _to(f) > 0)
    end
    return _tuple_fold(into, false, fs)
end

# Add each hazard and share flow's amount into the pool it enters, in
# `y` and the arrivals `a`.
@inline function _spread(fs::Tuple, x, L, y, a, g, t)
    spread = @inline ((y, a), f, _) -> _spread_one(f, x, L, y, a, g, t)
    return _tuple_fold(spread, (y, a), fs)
end
_spread_one(f::_CountLike, x, L, y, a, g, t) = (y, a)
@inline function _spread_one(f::Flow, x, L, y, a, g, t)
    _to(f) > 0 || return (y, a)
    _, gH, _ = L[_from(f)]
    m = x[_from(f)] * (_by_rate(f, g, t, gH) + _share(f, g, t))
    return _add(y, _to(f), m), _add(a, _to(f), m)
end

# Arms follow primal values: a zero dual is ordered by its partials, so
# `min`/`max` could pick the other arm at an empty pool. `s + z` maps `-0.0`
# to `0.0`, a NaN input is returned as `min` does; `ifelse` is branch-free.
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

# The count flows in order on the pools `y` and arrivals `a`, with `x` the
# pools the step starts from, which a split reads.
@inline function _counts(fs::Tuple, x, y, a, g, t)
    count = @inline ((y, a), f, _) -> _count(f, x, y, a, g, t)
    return _tuple_fold(count, (y, a), fs)
end
_count(f::Flow, x, y, a, g, t) = y, a
function _count(f::_CountLike, x, y, a, g, t)
    return _count_demand(f, param(f.demand, g, t), x, y, a)
end
# One pass over the pools, by `ifelse`, for the count's demand `c`: a flow
# out of the system (`to = 0`) adds to no pool.
@inline function _count_demand(f::_Count, c, x, y, a)
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

# A split's step: the demand on each source, what each loses, and the pools.
@inline function _count_demand(f::_SplitFlow, b, x, y, a)
    I, j = _from(f), _to(f)
    ys = map(i -> y[i], I)
    m = map(_removal, _split_demands(b, map(i -> x[i], I), ys), ys)
    p = sum(map(_moved_in, m))
    y′ = ntuple(Val(length(y))) do l
        return y[l] - _at_sources(m, I, l) + ifelse(l == j, p, zero(p))
    end
    return y′, _add(a, j, p)
end
# What sources `I` lose from pool `l`: the loss of the source that is `l`.
@inline function _at_sources(m, I, l)
    return sum(ntuple(k -> ifelse(I[k] == l, m[k], zero(m[k])), Val(length(I))))
end

# The demand on each source of a split of count `b`, from the pools the step
# starts from, `w`, and what the sources hold when the split runs, `y`:
# each source's share, and the parts of the others' shares they cannot
# cover. Arms follow primal values, as `_removal` does.
@inline function _split_demands(b, w::NTuple{n}, y::NTuple{n}) where {n}
    c, u, W = _split_parts(b, w, y)
    return ntuple(i -> c[i] + _passed(u, w, W, i), Val(n))
end
@inline function _split_parts(b, w::NTuple{n}, y::NTuple{n}) where {n}
    W = sum(w)
    on = _primal_value(W) > 0
    Wd = ifelse(on, W, one(W))
    c = ntuple(Val(n)) do j
        q = b * w[j] / Wd
        return ifelse(on, q, ifelse(j == 1, oftype(q, b), zero(q)))
    end
    u = ntuple(Val(n)) do j
        e = c[j] - y[j]
        return ifelse(_uncovered(c[j], y[j]), e, zero(e))
    end
    return c, u, W
end
_uncovered(c, y) = _primal_value(c) > _primal_value(y)
# What source `i` takes of the others' uncovered parts `u`: with two
# sources the other's whole.
_passed(u, w::NTuple{2}, W, i) = u[3 - i]
@inline function _passed(u, w::NTuple{n}, W, i) where {n}
    return sum(
        ntuple(Val(n)) do j
            return ifelse(j == i, zero(u[j]), u[j] * _passed_share(w, W, i, j))
        end
    )
end
# The part of source `j`'s uncovered part that source `i` takes: in
# proportion to the other sources' `w`, or all to the first other source
# when they sum to zero or less.
@inline function _passed_share(w, W, i, j)
    Q = W - w[j]
    on = _primal_value(Q) > 0
    q = w[i] / ifelse(on, Q, one(Q))
    first_other = ifelse(j == 1, 2, 1)
    return ifelse(on, q, ifelse(i == first_other, one(q), zero(q)))
end

# Its cotangents `(b̄, w̄, ȳ)` from those `m̄` of what each source loses.
function _split_back(b, w::NTuple{n}, y::NTuple{n}, m̄) where {n}
    c, u, W = _split_parts(b, w, y)
    d = ntuple(i -> c[i] + _passed(u, w, W, i), Val(n))
    r̄s = map(_removal_pullback, d, y, m̄)
    d̄ = map(first, r̄s)
    ȳ0 = map(last, r̄s)
    ū, w̄q = _passed_back(d̄, u, w, W)
    c̄ = ntuple(j -> d̄[j] + ifelse(_uncovered(c[j], y[j]), ū[j], zero(ū[j])), Val(n))
    ȳ = ntuple(
        j -> ȳ0[j] - ifelse(_uncovered(c[j], y[j]), ū[j], zero(ū[j])), Val(n)
    )
    if _primal_value(W) > 0
        b̄ = sum(ntuple(j -> c̄[j] * w[j], Val(n))) / W
        W̄ = -sum(ntuple(j -> c̄[j] * c[j], Val(n))) / W
        w̄ = ntuple(j -> w̄q[j] + c̄[j] * b / W + W̄, Val(n))
    else
        b̄ = first(c̄)
        w̄ = w̄q
    end
    return b̄, w̄, ȳ
end
# The cotangents of the uncovered parts and of the weights through the
# passed shares, from those `d̄` of the demands.
function _passed_back(d̄, u, w::NTuple{2}, W)
    z = zero(first(d̄))
    return (d̄[2], d̄[1]), (z, z)
end
function _passed_back(d̄, u, w::NTuple{n}, W) where {n}
    ū = ntuple(Val(n)) do j
        sum(ntuple(i -> i == j ? zero(d̄[i]) : d̄[i] * _passed_share(w, W, i, j), Val(n)))
    end
    # Through `Q_j = W - w_j` for each `j` with `Q_j > 0`: `d̄_i u_j / Q_j`
    # into each other source's weight, and `Q̄_j` into every weight but
    # source `j`'s. Straight-line, so the cotangents keep their type.
    Q = ntuple(j -> W - w[j], Val(n))
    on = ntuple(j -> _primal_value(Q[j]) > 0, Val(n))
    Qd = ntuple(j -> ifelse(on[j], Q[j], one(Q[j])), Val(n))
    Q̄ = ntuple(Val(n)) do j
        s = sum(ntuple(i -> i == j ? zero(d̄[i]) : d̄[i] * w[i], Val(n)))
        return ifelse(on[j], -s * u[j] / Qd[j]^2, zero(s))
    end
    w̄ = ntuple(Val(n)) do i
        sum(
            ntuple(Val(n)) do j
                (j == i || !on[j]) && return zero(d̄[i])
                return d̄[i] * u[j] / Qd[j] + Q̄[j]
            end
        )
    end
    return ū, w̄
end

# Count flows only, such as a depletion's removals: nothing moves at a
# rate or as a share, so the counts act on `x` directly.
const _Counts = Tuple{Vararg{_CountLike}}

# One group's step: the pools `x` after the flows, and arrivals.
function _flow_group(fs::_Counts, x::NTuple{N}, g, t) where {N}
    return _counts(fs, x, x, ntuple(_ -> zero(first(x)), Val(N)), g, t)
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
    return _counts(fs, x, y, a, g, t)
end
# The arrivals before the flows: zeros, or `nothing` when they are not
# kept, which the flows' `_add` passes through.
@inline function _start_arrivals(::Val{true}, y::NTuple{N}) where {N}
    return ntuple(_ -> zero(first(y)), Val(N))
end
@inline _start_arrivals(::Val{false}, y) = nothing

# The pools after the flows, without the arrivals, which are not built.
_flow_only(fs::_Counts, x, g, t) = first(_counts(fs, x, x, nothing, g, t))
@inline _flow_only(fs, x, g, t) = first(_flow_step(fs, x, g, t, Val(false)))

# == Each flow's amount, for a trace without a draw ==

function _amounts(fs, x, g, t)
    L, y = _amount_start(fs, x, g, t)
    return _amounts_each(fs, x, L, y, g, t)
end
# The leave terms `L` and the pools `y` after the hazard and share flows,
# before the counts.
@inline function _amount_start(fs, x::NTuple{N}, g, t) where {N}
    z = zero(first(x))
    L = ntuple(i -> _leaves(fs, i, g, t, z), Val(N))
    y0 = ntuple(i -> (L[i][1] - L[i][3]) * x[i], Val(N))
    y, _ = _spread(fs, x, L, y0, ntuple(_ -> zero(first(y0)), Val(N)), g, t)
    return L, y
end
function _amounts_each(fs::Tuple, x, L, y, g, t)
    return _tuple_scan(@inline((y, f, _) -> _amount(f, x, L, y, g, t)), y, fs)
end
function _amount(f::Flow, x, L, y, g, t)
    return x[_from(f)] * (_rate(f, g, t) * L[_from(f)][2] + _share(f, g, t)), y
end
function _amount(f::_Count, x, L, y, g, t)
    m = _moved(f.form, param(f.demand, g, t), _source(y, _from(f)))
    return m, first(_count(f, x, y, nothing, g, t))
end
# A split's amount is what its sources lose together.
function _amount(f::_SplitFlow, x, L, y, g, t)
    I = _from(f)
    ys = map(i -> y[i], I)
    b = param(f.demand, g, t)
    m = map(_removal, _split_demands(b, map(i -> x[i], I), ys), ys)
    return sum(m), first(_count(f, x, y, nothing, g, t))
end

# A hazard or share flow's amount takes its own cotangent and that of the pool
# it enters, `q_f = r̄_f + ȳ_to`, where the step's pullback takes the second
# only; each count adds its own.
function _amounts_pullback(fs, f̄s, r̄, x::NTuple{N}, g, t) where {N}
    z = zero(first(x))
    L, y = _amount_start(fs, x, g, t)
    z̄ = zero(promote_type(eltype(x), eltype(r̄)))
    ȳ, x̄w = _amount_counts_back(
        fs, f̄s, r̄, x, y, ntuple(_ -> z̄, Val(N)), g, t
    )
    q = _amount_cotangents(fs, r̄, ȳ)
    H = ntuple(i -> _out(_rate, fs, i, g, t, z), Val(N))
    B = ntuple(i -> _rated(fs, q, i, g, t, z̄), Val(N))
    _amount_rates_back!(fs, f̄s, q, x, L, H, B, ȳ, g, t)
    x̄ = ntuple(Val(N)) do i
        E, gH, P = L[i]
        (E - P) * ȳ[i] + gH * B[i] + _shared(fs, q, i, g, t, z̄)
    end
    return _with_split(x̄, x̄w)
end

# The counts' pullback, last first, from the cotangent `ȳ` of the pools
# after them, each count's own amount cotangent added to its move's.
function _amount_counts_back(fs::Tuple, f̄s, r̄, x, y, ȳ, g, t)
    fwd(y, (f, _), _) = (first(_count(f, x, y, nothing, g, t)), y)
    function back((ȳ, x̄), (f, f̄), y, k)
        return _amount_count_back(f, f̄, r̄[k], x, y, ȳ, x̄, g, t)
    end
    b = (ȳ, _split_zero(fs, x))
    return _tuple_forward_back(fwd, back, y, b, _with_mirrors(fs, f̄s))
end
_amount_count_back(f::Flow, f̄, r̄, x, y, ȳ, x̄, g, t) = ȳ, x̄
function _amount_count_back(f::_SplitFlow, f̄, r̄, x, y, ȳ, x̄, g, t)
    b = param(f.demand, g, t)
    b̄, ȳ′, x̄′ = _split_count_back(f, b, r̄, x, y, ȳ, x̄, zero(eltype(ȳ)))
    add_param!(cotangent(f̄, :demand), f.demand, b̄, g, t)
    return ȳ′, x̄′
end
function _amount_count_back(f::_Count, f̄, r̄, x, y, ȳ, x̄, g, t)
    return __amount_count_back(f, f̄, r̄, y, ȳ, g, t), x̄
end
function __amount_count_back(f::_Count, f̄, r̄, y, ȳ, g, t)
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
        f isa _CountLike || _to(f) == 0 ? r̄[k] : r̄[k] + ȳ[_to(f)]
    end
end

# `Σ_f r_f q_f` over the rate flows out of pool `i`, and `Σ_f p_f q_f` over
# the share flows.
function _rated(fs::Tuple, q, i, g, t, B)
    add = (B, f, k) -> _from(f) == i ? B + _rate(f, g, t) * q[k] : B
    return _tuple_fold(add, B, fs)
end
function _shared(fs::Tuple, q, i, g, t, z)
    add = (z, f, k) -> _from(f) == i ? z + _share(f, g, t) * q[k] : z
    return _tuple_fold(add, z, fs)
end

# Each rate takes `x_i (g q_f + g′ B_i - e^{-H_i} ȳ_i)` and each share
# `x_i (q_f - ȳ_i)`.
function _amount_rates_back!(fs::Tuple, f̄s, q, x, L, H, B, ȳ, g, t)
    return _tuple_fold(nothing, _with_mirrors(fs, f̄s)) do _, (f, f̄), k
        _amount_rate_back!(f, f̄, q[k], x, L, H, B, ȳ, g, t)
    end
end
_amount_rate_back!(f::_CountLike, f̄, q, x, L, H, B, ȳ, g, t) = nothing
function _amount_rate_back!(
        f::Flow{<:Any, _FlowHazard}, f̄, q, x, L, H, B, ȳ, g, t
    )
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

# == The step's pullback ==

# A demand that reads the outputs or has a map costs more to read than the
# rest of a count, so each demand is read once and serves both passes.
# Returns the cotangents of `y`, and of `x` through the splits' shares,
# `nothing` without a split.
function _counts_back(fs::Tuple, f̄s, x, y, a, ȳ, ā, g, t)
    function fwd((y, a), (f, f̄), _)
        d = _demand(f, f̄, g, t)
        return _count_demand(f, first(d), x, y, a), (y, d)
    end
    function back((ȳ, x̄), (f, f̄), (y, d), _)
        return _count_back(f, d, f̄, x, y, ȳ, x̄, ā, g, t)
    end
    b = (ȳ, _split_zero(fs, x))
    return _tuple_forward_back(fwd, back, (y, a), b, _with_mirrors(fs, f̄s))
end
# What a count's pullback reads of its demand (`_param_partials`); a flow of
# another form moves no count.
function _demand(f::_CountLike, f̄, g, t)
    return _param_partials(cotangent(f̄, :demand), f.demand, g, t)
end
_demand(f::Flow, f̄, g, t) = (nothing, nothing)
_count_demand(f::Flow, c, x, y, a) = y, a
_count_back(f::Flow, d, f̄, x, y, ȳ, x̄, ā, g, t) = ȳ, x̄
function _count_back(f::_SplitFlow, d, f̄, x, y, ȳ, x̄, ā, g, t)
    b, ∂ = d
    j = _to(f)
    āj = j > 0 ? ā[j] : zero(eltype(ȳ))
    b̄, ȳ′, x̄′ = _split_count_back(f, b, zero(eltype(ȳ)), x, y, ȳ, x̄, āj)
    _add_param_partials!(cotangent(f̄, :demand), f.demand, b̄, ∂, g, t)
    return ȳ′, x̄′
end
# A split's cotangents from those of the pools after it, `ȳ`, of the
# arrivals into `to`, `āj`, and of its amount, `r̄`: those of its count, of
# the pools before it, and of the pools the step starts from.
function _split_count_back(f, b, r̄, x, y, ȳ, x̄, āj)
    I, j = _from(f), _to(f)
    ys = map(i -> y[i], I)
    w = map(i -> x[i], I)
    m = map(_removal, _split_demands(b, w, ys), ys)
    m̄ = map(m, I) do mk, i
        into = j > 0 && _primal_value(mk) >= 0
        return r̄ - ȳ[i] + ifelse(into, ȳ[max(j, 1)] + āj, zero(r̄))
    end
    b̄, w̄, ȳs = _split_back(b, w, ys, m̄)
    ȳ′ = ntuple(l -> ȳ[l] + _at_sources(ȳs, I, l), Val(length(ȳ)))
    x̄′ = ntuple(l -> x̄[l] + _at_sources(w̄, I, l), Val(length(x̄)))
    return b̄, ȳ′, x̄′
end
# The cotangent of the pools the step starts from that splits add to: zeros,
# or `nothing` without a split, and its sum with the rest of that cotangent.
const _SingleForm = Union{_FlowHazard, Share, _FlowCount}
_split_zero(fs, x) = map(zero, x)
_split_zero(::Tuple{Vararg{Flow{<:Any, <:_SingleForm}}}, x) = nothing
_with_split(x̄, ::Nothing) = x̄
_with_split(x̄, x̄w) = map(+, x̄, x̄w)
# A count from outside the `Depletion` (`from = 0`) takes from no pool, so its
# source has no cotangent.
function _count_back(f::_Count, d, f̄, x, y, ȳ, x̄, ā, g, t)
    return __count_back(f, d, f̄, y, ȳ, ā, g, t), x̄
end
function __count_back(f::_Count, d, f̄, y, ȳ, ā, g, t)
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

function _flows_pullback(
        fs::_Counts, f̄s, x::NTuple{N}, ȳout, ā, g, t
    ) where {N}
    a = ntuple(_ -> zero(first(x)), Val(N))
    return _with_split(_counts_back(fs, f̄s, x, x, a, ȳout, ā, g, t)...)
end
# The leave terms are the step's, `_Moved` for a pool whose one hazard flow
# enters a pool.
function _flows_pullback(fs, f̄s, x::NTuple{N}, ȳout, ā, g, t) where {N}
    z = zero(first(x))
    L = _group_leaves_each(fs, g, t, z, Val(N))
    y0 = ntuple(@inline(i -> (L[i][1] - L[i][3]) * x[i]), Val(N))
    y, a = _spread(fs, x, L, y0, ntuple(_ -> zero(first(y0)), Val(N)), g, t)
    ȳ, x̄w = _counts_back(fs, f̄s, x, y, a, ȳout, ā, g, t)
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
    return _with_split(ntuple(x̄, Val(N)), x̄w)
end

# What leaves pool `i` at a rate, against the arrivals' cotangents:
# `g(H) B_i`, or for a pool whose one hazard flow enters a pool, the share
# it moves times that pool's arrival cotangent.
_leave_back(gH, B, fs, ā, i) = gH * B
_leave_back(w::_Moved, B, fs, ā, i) = w.F * _hazard_arrival(fs, ā, i)
function _hazard_arrival(fs::Tuple, ā, i)
    add = @inline (a, f, _) -> a + _arrival(f, ā, i)
    return _tuple_fold(add, zero(eltype(ā)), fs)
end
_arrival(f, ā, i) = zero(eltype(ā))
function _arrival(f::Flow{<:Any, _FlowHazard}, ā, i)
    return _into(f, i) ? ā[_to(f)] : zero(eltype(ā))
end
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
_rate_back!(f::_CountLike, f̄, x, L, H, B, ȳ, ā, g, t) = nothing
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
function _rate_bar(x, E, gH, H, B, āto, ȳ)
    return x * (gH * āto + _leave_slope(H, E, gH) * B - E * ȳ)
end
_rate_bar(x, E, w::_Moved, H, B, āto, ȳ) = x * E * (āto - ȳ)
function _rate_back!(f::Flow{<:Any, Share}, f̄, x, L, H, B, ȳ, ā, g, t)
    i = _from(f)
    āto = _to(f) > 0 ? ā[_to(f)] : zero(eltype(ā))
    add_param!(cotangent(f̄, :demand), f.demand, x[i] * (āto - ȳ[i]), g, t)
    return nothing
end

# == Checks against the groups ==

# Each flow's parameter against the groups, unrolled over the tuple so each
# flow's check is compiled for its type.
_check_flow_groups(::Tuple{}, G) = nothing
function _check_flow_groups(fs::Tuple, G)
    f = first(fs)
    _check_param_strata(_Named(:demand, f), f.demand, G)
    return _check_flow_groups(Base.tail(fs), G)
end

# Printed only on error, so a passing check builds no string.
struct _Named
    name::Symbol
    from::Union{Int, Tuple{Vararg{Int}}}
    to::Int
end
_Named(name, f::Flow) = _Named(name, _from(f), _to(f))
function Base.print(io::IO, n::_Named)
    return print(io, n.name, " of Flow(", n.from, " => ", n.to, ")")
end
