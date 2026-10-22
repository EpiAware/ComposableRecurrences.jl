# A `Depletion` holds pools for each group of strata, and its pieces act on
# the step's value and the pools in the order given: a draw takes the value
# from the pools, or fills one, and flows move between them. Without a draw
# the pools are the step's values, carried by the recurrence, and the flows
# move them.
#
# The step is a fold of the pieces, and its pullback the fold in reverse.
# The number of pools and the pieces are in the type, so each kind has
# methods of its own: one pool drawn from before its flows, with nothing
# left over, is a pointwise step; any other is blockwise.

@doc raw"""
Depletion of pools: each group of strata holds pools, and pieces act on
the step's value and the pools in the order given.
A draw takes the value from the pools, or fills one, and
[`ComposableRecurrences.Flow`](@ref)s move between them.

With one pool ``s`` drawn from, then flows, each stratum ``i`` (see
[`PerStratum`](@ref)) at absolute time ``t`` from the call's first time
``t_0`` steps as

```math
s_{t_0 - 1, i} = s_{0,i}, \qquad
(v'_{t,i},\ s^{*}_{t,i}) = F\big(v_{t,i},\ s_{t-1,i},\ N_{t,i}\big),
\qquad s_{t,i} = \Phi_t\big(s^{*}_{t,i}\big),
```

where ``v_{t,i}`` is the value entering the modifier, ``v'_{t,i}`` the value
it passes on, ``s_{0,i}`` the starting pool, ``N_{t,i}`` the population at
time ``t``, ``F`` the draw's form, `forward!(form, Step(), v, s, N)`, and
``\Phi_t`` the flows, such as a count ``r_t`` out of the pool,
``s^{*} - \min\big(r_t, \max(s^{*}, 0)\big)``.
The hazard fraction divides by `N` whatever the pool starts at.

With ``n`` pools ``x_1, \dots, x_n`` in a group, a draw takes from the
weighted pools ``P`` and each pool loses the draw in proportion to its
weight:

```math
\begin{aligned}
P &= \sum_i w_i x_i, \qquad (v', \cdot) = F(v, P, N_t), \\
x'_i &= x_i - v' \frac{w_i x_i}{P},
\end{aligned}
```

where ``w_i`` is pool ``i``'s weight, zero for a pool `weights` does not
name.
When ``P \le 0`` the draw comes from the first pool `weights` names alone.
A draw into pool ``f`` (`into = f`) fills it instead, up to ``N_t``:
``(v', \cdot) = F(v, N_t - x_f, N_t)`` and ``x'_f = x_f + v'``, as
admissions fill beds.
Its form is `Truncate()` or `SoftTruncate(κ)`, and its capacity ``N_t`` is
not negative.
What a draw leaves of the value it takes, ``u = v - v'``, goes nowhere by
default; with `overflow = :stratum` to the group's second value,
``v'_2 = v_2 + u``, and with `overflow = :queue` to a queue held after the
pools in the state, whose content joins the draw's value at the next step.
Each draw takes the value the pieces before it pass on.

The flows act on the pools where they stand among the pieces, as when
patients leave before the day's admissions or an allowance is granted at
the start of a period.
Flows given one after another act together, as
[`ComposableRecurrences.Flow`](@ref) sets out, and a count flow from `0`
brings its demand in from outside.

A draw is a form, `Hazard()`, `Floor()`, `Truncate()`, `SoftTruncate(κ)`
or a new type with a `forward!(form, Step(), v, s, N)` method
([A depletion form](@ref extending-form)), which draws from the first pool
alone.
A built-in form given `weights`, `into` or `overflow`, such as
`Hazard(; weights = (S = 1, V = σ))` or `Truncate(; into = :O)`, is a draw
with them.
The draw's `Hazard()` takes its hazard from the value over the population,
``v / N_t``; a `Hazard()` flow's demand is read as
[`ComposableRecurrences.Flow`](@ref) sets out.
[Rules and plain AD](@ref adjoint-routing) gives the gradient of a form
without a `pullback!`.

One pool drawn from once, then flows, with nothing left over, is a
pointwise step whose state is the pool.
Any other is blockwise ([`ComposableRecurrences.blocks`](@ref)): each group
has one value, or two with `overflow = :stratum`, value ``(j - 1) G + g``
being value ``j`` of group ``g`` for ``G`` groups, and the state holds
pool 1 of every group, then pool 2, and so on, then the queue.
A `Depletion` covers every stratum, so a stratum without a cap takes an
infinite `N`.
With `overflow = :stratum` group ``g`` overflows into stratum ``G + g``, so
another pairing permutes the strata.
For groups that share one overflow stratum, a
[`ComposableRecurrences.Redistribute`](@ref) after the `Depletion`, with
``\varepsilon = 1`` on the other overflow strata and `K` sending each to the
shared one, moves their values into it.

Without a draw the pools are the step's values: the values hold ``n``
pools of ``G`` groups each, pool by pool (`blocks` is `Val((n, n))`), so
value ``(i - 1) G + g`` is pool ``i`` of group ``g``.
On a [`Recurrence`](@ref) with kernel `[1.0]` the core carries the
previous step's pools forward, and the `Depletion` applies the step's
flows, ``v' = \Phi_t(v)``.
The state then holds what flowed into each pool at the step, where a
negative count adds nothing.

| model | pieces |
|:----- |:------ |
| a population with births and deaths | a `TimeVarying` `N`, `Hazard()`, then the births as a count `Flow(0 => :S, b; form = Truncate())` and the deaths as one out of `:S` |
| leaky protection at relative susceptibility ``\sigma`` | `Hazard(; weights = (S = 1, V = σ))`, then the doses as `Flow(:S => :V, d; form = Truncate())` |
| beds that a share ``\delta`` leaves each step | `Flow(:O => 0, δ; form = Share())`, then `Truncate(; into = :O)`, with `N` the beds |
| an allowance granted ``b_t`` at each period start | `Flow(0 => :B, TimeVarying(b); form = Truncate())`, then `Truncate()` |
| the same without carry over | as above, with `Flow(:B => 0, starts; form = Share())` before the grant |

The step reads `N` at its own time, and a pool is not rescaled when `N`
changes: arrivals enter it only through the flows.
Here `starts` is a `TimeVarying` share of one at each period start and
zero otherwise, and a lifetime allowance is a starting pool alone.
The [renewal then delay](@ref tutorial-renewal-delay) tutorial builds
leaky, all-or-nothing and waning protection with a second pool; a delay
from dose to protection is a [`Convolution`](@ref) of the doses before the
call.
A share ``\delta`` leaving the beds is a geometric length of stay, with
survival ``(1 - \delta)^k`` after ``k`` steps; for another stay, convolve the
admissions with its survival, as a [`ComposableRecurrences.Primary`](@ref)
indexed [`TimeVarying`](@ref) kernel for cohorts, and bound the sum with
[`ComposableRecurrences.Clamp`](@ref) or a `Depletion` that fills a pool.
A `Depletion` holds the fields `N`, `pools` (each pool's starting value,
`nothing` for its default) and `pieces`, the draws with each pool named by
its position and the flows given one after another as one tuple.

# Arguments
- `N`: the population a draw reads, or the capacity a draw fills up to,
  a [parameter](@ref ComposableRecurrences.param) read at each step's group
  and time; left out for a `Depletion` without a draw, or whose truncated
  draws from its pools do not read it.
- `pieces`: the draws and flows, in the order they act; `Hazard()` alone
  when none are given.

# Keyword Arguments
- `pools`: each pool's name and starting value, a named tuple such as
  `(S = N, V = 0.0)`, or a tuple of names when each takes its default;
  `(S = nothing,)` by default.
  A starting value is one value or `PerStratum`, or `nothing` for `N` at
  time 1 in the first pool the first draw from the pools names, and zero
  in the others.
  A `Depletion` without a draw takes its pools from the history instead,
  so each starts at `nothing`.
  A seed drawn from the pool is `pools = (S = max(N - sum(seed), 0),)`.

A draw takes these keywords on its form:
- `weights`: each pool's weight in the draw, a named tuple such as
  `(S = 1, V = σ)`; the first pool's alone at `1` by default.
  A weight is one value or `PerStratum`, constant over time; an integer
  weight is fixed, a float one a parameter.
  One pool is drawn with weight `1`.
- `into`: the name of the pool the draw fills, in place of `weights`, or
  `nothing`.
- `overflow`: where what the draw leaves goes: `nothing` (the default),
  `:stratum` or `:queue`; one draw at most has a queue.

# Examples

Depletion from a pool that starts below the population by the seed:

```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
seed = [1.0, 2.0]
depletion = CR.Depletion(100.0, CR.Hazard(); pools = (S = 100.0 - sum(seed),))
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

A herd of 100 with 3 births a step: `N` grows by the births, and the births
enter the pool as a count from outside after the draw.

```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
births = fill(3.0, 8)
N = TimeVarying(100.0 .+ cumsum(births))
herd = CR.Depletion(
    N, CR.Hazard(), CR.Flow(0 => :S, TimeVarying(births); form = CR.Truncate());
    pools = (S = 90.0,)
)
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

Leaky vaccination: 5 doses a step move susceptibles into a pool drawn at
a third of the rate, and the protection wanes back at rate 0.1.

```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
leaky = CR.Depletion(
    1000.0, CR.Hazard(; weights = (S = 1, V = 0.3)),
    CR.Flow(:S => :V, 5.0; form = CR.Truncate()), CR.Flow(:V => :S, 0.1);
    pools = (:S, :V)
)
y = Recurrence([0.3, 0.5, 0.2]; modifiers = (leaky,))(fill(2.0, 6); history = [5.0])
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

Ten beds, a tenth of patients leaving each day before the admissions:
demand above the free beds goes to the community stratum.

```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
beds = CR.Depletion(
    10.0, CR.Flow(:O => 0, 0.1; form = CR.Share()),
    CR.Truncate(; into = :O, overflow = :stratum); pools = (O = 0.0,)
)
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
grants = TimeVarying([rem(t - 1, 7) == 0 ? 5.0 : 0.0 for t in 1:14])
doses = CR.Depletion(
    CR.Flow(0 => :B, grants; form = CR.Truncate()),
    CR.Truncate(; overflow = :stratum); pools = (:B,)
)
demand = [fill(0.5, 1, 7) fill(2.0, 1, 7); zeros(1, 14)]
y = Recurrence([0.0]; modifiers = (doses,))(; history = zeros(2, 1), add = demand)
y[1, :]'

# output

1×14 adjoint(::Vector{Float64}) with eltype Float64:
 0.5  0.5  0.5  0.5  0.5  0.5  0.5  2.0  2.0  2.0  0.5  0.0  0.0  0.0
```

A ward without a draw: suspected patients are confirmed or ruled out, and
confirmed patients are discharged, each at a hazard rate.

```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
ward = CR.Depletion(
    CR.Flow(:suspected => :confirmed, 0.3), CR.Flow(:suspected => 0, 0.4),
    CR.Flow(:confirmed => 0, 0.1); pools = (:suspected, :confirmed)
)
admitted = [fill(10.0, 1, 4); zeros(1, 4)]
y = Recurrence([1.0]; modifiers = (ward,))(; history = zeros(2, 1), add = admitted)
round.(y; digits = 3)

# output

2×4 Matrix{Float64}:
 4.966  7.432  8.656   9.264
 2.157  5.181  8.449  11.67
```
"""
struct Depletion{P, I <: NamedTuple, C <: Tuple}
    "The population the draws read, a parameter, or `nothing`."
    N::P
    "Each pool's starting value by name, `nothing` for its default."
    pools::I
    "The draws and the runs of flows, in the order they act."
    pieces::C
    function Depletion{P, I, C}(N, pools, pieces) where {P, I, C}
        _check_pieces(pieces, length(pools))
        return new{P, I, C}(N, pools, pieces)
    end
end

# Rebuilt from its fields, as `constructorof` gives it.
function _Depletion(N::P, pools::I, pieces::C) where {P, I, C}
    return Depletion{P, I, C}(N, pools, pieces)
end
ConstructionBase.constructorof(::Type{<:Depletion}) = _Depletion

# A draw from the weighted pools, with `first` the pool it takes from when
# they are empty, and a draw into pool `pool`; each with where what it
# leaves goes.
struct _DrawFrom{F, W, O}
    form::F
    weights::W
    first::Int
    overflow::O
end
struct _DrawInto{F, O}
    form::F
    pool::Int
    overflow::O
end
const _Drawing = Union{_DrawFrom, _DrawInto}

# Where what a draw leaves goes: nowhere, to the group's second value or
# to a queue that joins its value at the next step.
struct _Drop end
struct _ToStratum end
struct _Queue end

# A draw as its form's keywords give it, its pools still by name.
struct _Draw{F, W, I, O}
    form::F
    weights::W
    into::I
    overflow::O
end
_drawn(form, ::Nothing, ::Nothing, ::Nothing) = form
_drawn(form, weights, into, overflow) = _Draw(form, weights, into, _overflow(overflow))

# A run of flows that act together.
const _Flows = Tuple{Flow, Vararg{Flow}}

# That the flows and the draws name no pool beyond the `n` there are, and
# that one draw at most has a queue; the message is built only when one
# does not hold.
function _check_pieces(pieces::Tuple, n)
    foreach(p -> _check_piece_pools(p, n), pieces)
    _nqueues(pieces) <= 1 || throw(
        ArgumentError("one draw at most has overflow = :queue")
    )
    return nothing
end
_check_piece_pools(fs::Tuple, n) = foreach(f -> _check_pool(f, n), fs)
_check_piece_pools(d::_DrawFrom, n) = _check_drawn_pool(d.first, n)
_check_piece_pools(d::_DrawInto, n) = _check_drawn_pool(d.pool, n)
function _check_pool(f, n)
    max(f.from, f.to) <= n || _too_many_pools(f, n)
    return nothing
end
@noinline function _too_many_pools(f, n)
    throw(
        ArgumentError(
            "the flows name pool $(max(f.from, f.to)), but there " *
                (n == 1 ? "is 1 pool" : "are $n pools")
        )
    )
end
function _check_drawn_pool(i, n)
    1 <= i <= n || throw(ArgumentError("the draw names pool $i of $n"))
    return nothing
end

# The pieces' draws, queues and overflows into a stratum, read from their
# types.
_isdraw(p) = false
_isdraw(::_Drawing) = true
_ndraws(::Tuple{}) = 0
_ndraws(ps::Tuple) = _isdraw(first(ps)) + _ndraws(Base.tail(ps))
_overflow_of(p) = _Drop()
_overflow_of(d::_Drawing) = d.overflow
_nqueues(::Tuple{}) = 0
_nqueues(ps::Tuple) = (_overflow_of(first(ps)) isa _Queue) + _nqueues(Base.tail(ps))
_either(::_Drop, b) = b
_either(a, b) = a
_kind_of(::Tuple{}, K) = _Drop()
function _kind_of(ps::Tuple, K)
    o = _overflow_of(first(ps))
    return _either(o isa K ? o : _Drop(), _kind_of(Base.tail(ps), K))
end

# Inlined, so that a differentiated function that builds a `Depletion`
# holds no call returning it.
# A first argument that is a parameter, or an array given where one was
# meant, is the population.
const _Population = Union{
    Real, PerStratum, TimeVarying, Derived, Recent, AbstractArray,
}
@inline function Depletion(N::_Population, pieces...; pools = nothing)
    return _depletion(_population(N), pieces, pools)
end
@inline Depletion(pieces...; pools = nothing) = _depletion(nothing, pieces, pools)

@inline function _depletion(N, pieces::Tuple, pools)
    starts = _pool_starts(pools)
    placed = _tuple_map(p -> _place_piece(p, N, starts), _or_hazard(pieces))
    runs = _runs(placed)
    _check_each_nonnegative(:pools, values(starts))
    _ndraws(runs) == 0 && any(!isnothing, values(starts)) && throw(
        ArgumentError(
            "a Depletion without a draw holds its pools in the step's values, " *
                "so the history gives their start, not pools"
        )
    )
    return _Depletion(N, map(_initial_param, starts), runs)
end
_or_hazard(::Tuple{}) = (Hazard(),)
_or_hazard(pieces::Tuple) = pieces

# The pools by name with their starting values: one pool by default.
_pool_starts(::Nothing) = (S = nothing,)
function _pool_starts(pools::NamedTuple)
    isempty(pools) && _bad_pools(pools)
    return pools
end
function _pool_starts(pools::Tuple{Vararg{Symbol}})
    allunique(pools) || _bad_pools(pools)
    return _pool_starts(NamedTuple{pools}(map(_ -> nothing, pools)))
end
_pool_starts(pools) = _bad_pools(pools)
@noinline function _bad_pools(pools)
    throw(
        ArgumentError(
            "pools is a named tuple of starting values, such as (S = N, V = 0.0), " *
                "or a tuple of distinct names, got " * _describe(pools)
        )
    )
end

# A piece with its pools as positions among `starts`: a flow, a draw, or a
# form drawn from the first pool alone.
_place_piece(f::Flow, N, starts) = _placed(f, keys(starts))
function _place_piece(d::_Draw, N, starts)
    return _place_draw(d.form, d.weights, d.into, d.overflow, N, starts)
end
function _place_piece(form, N, starts)
    _check_piece(form)
    return _place_draw(form, nothing, nothing, _Drop(), N, starts)
end
_check_piece(form) = _check_form(form)
@noinline function _check_piece(fs::Union{Tuple, AbstractVector})
    throw(
        ArgumentError(
            "the pieces of a Depletion are given one by one, so splat a " *
                "collection of them, got " * _describe(fs)
        )
    )
end

# A draw from the weighted pools, first from the first pool the weights
# name, or into the pool `into` names.
function _place_draw(form, w, ::Nothing, overflow, N, starts)
    _check_drawn_population(form, N, nothing)
    drawn = _drawn_weights(w, starts)
    ws = _aligned_weights(drawn, starts)
    i = _drawn_place(first(keys(drawn)), keys(starts))
    return _DrawFrom(_exponent_form(form, N), ws, i, overflow)
end
function _place_draw(form, w, into, overflow, N, starts)
    w === nothing || throw(
        ArgumentError("a draw fills a pool or takes from weighted pools, not both")
    )
    _check_drawn_population(form, N, into)
    _check_fill(form, N)
    i = _drawn_place(into, keys(starts))
    return _DrawInto(_exponent_form(form, N), i, overflow)
end

# A draw reads `N` unless it truncates what its pools hold.
function _check_drawn_population(form, N, into)
    N !== nothing || form isa _TruncateForm && into === nothing || throw(
        ArgumentError(
            into === nothing ?
                "a $(nameof(typeof(form)))() draw reads the population, so give N" :
                "a draw into a pool fills it up to N, so give N"
        )
    )
    return nothing
end

# The weights the draw names: the first pool's alone at `1` by default.
# The names are read from the type of the pools, so the weights' names are
# known where a `Depletion` is built.
function _drawn_weights(::Nothing, ::NamedTuple{K}) where {K}
    return NamedTuple{(K[1],)}((1,))
end
_drawn_weights(w, starts) = w

# Each pool's weight, zero for a pool the weights do not name.
function _aligned_weights(w::NamedTuple, ::NamedTuple{K}) where {K}
    isempty(w) && _bad_weights(w, K)
    all(in(K), keys(w)) || _bad_weights(w, K)
    ws = map(k -> haskey(w, k) ? _weight(w[k]) : 0, NamedTuple{K}(K))
    length(ws) == 1 && !(only(ws) isa Integer && isone(only(ws))) && throw(
        ArgumentError("one pool is drawn with weight 1, got $(only(ws))")
    )
    return ws
end
_aligned_weights(w, starts) = _bad_weights(w, keys(starts))
@noinline function _bad_weights(w, names)
    throw(
        ArgumentError(
            "weights is a named tuple of weights of the pools $(repr(names)), " *
                "such as (S = 1, V = σ), got " * _describe(w)
        )
    )
end

# An integer weight is fixed; any other is a constant parameter.
_weight(w::Integer) = Int(w)
_weight(w) = _float_param(_check_constant(:weight, w))

# The position of a pool the draw names.
function _drawn_place(x, names)
    i = _position(x, names)
    return i == 0 ? _unknown_drawn(x, names) : i
end
@noinline function _unknown_drawn(x, names)
    throw(
        ArgumentError(
            "the draw names pool $(repr(x)), but the pools are $(repr(names))"
        )
    )
end

# The position of a pool among `names`, by name or position, or zero.
_position(x::Int, names::Tuple) = 1 <= x <= length(names) ? x : 0
function _position(x::Symbol, names::Tuple)
    i = findfirst(==(x), names)
    return i === nothing ? 0 : i
end
_position(x, names) = 0

# A draw into a pool takes what is asked for up to the free capacity, which
# is not negative.
function _check_fill(form, N)
    _check_fill_form(form)
    _check_nonnegative(:N, N)
    return nothing
end
_check_fill_form(::_TruncateForm) = nothing
@noinline function _check_fill_form(form)
    throw(
        ArgumentError(
            "a draw into a pool is Truncate() or SoftTruncate(κ), got " *
                _describe(form)
        )
    )
end
_check_each_nonnegative(name, xs::Tuple) = foreach(x -> _check_nonnegative(name, x), xs)

# Where the value a draw leaves goes.
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

_initial_param(::Nothing) = nothing
_initial_param(x) = _float_param(_check_constant(:pools, x))

# The placed pieces with each run of flows given one after another as one
# tuple, as they act together. Generated from the pieces' types, so a run
# of more flows than inference's tuple recursion follows still infers.
@generated function _runs(ps::Tuple)
    out, run = Any[], Any[]
    for (i, P) in enumerate(ps.parameters)
        if P <: Flow
            push!(run, :(ps[$i]))
        else
            isempty(run) || push!(out, Expr(:tuple, run...))
            run = Any[]
            push!(out, :(ps[$i]))
        end
    end
    isempty(run) || push!(out, Expr(:tuple, run...))
    return Expr(:tuple, out...)
end

# One pool drawn from once with nothing left over, then a run of flows or
# none: a pointwise step.
const _OnePool{C} = Depletion{<:Any, <:NamedTuple{<:Any, <:Tuple{Any}}, C}
const _PointDraw = _DrawFrom{<:Any, <:Any, _Drop}
const _Depleting = _OnePool{<:Tuple{_PointDraw}}
const _Flowing = _OnePool{<:Tuple{_PointDraw, _Flows}}
const _Pointwise = Union{_Depleting, _Flowing}

# A `Depletion` without a draw: one run of flows.
const _Drawless = Depletion{<:Any, <:NamedTuple, <:Tuple{_Flows}}

# The population a form reads, one where the `Depletion` has none.
_pop(N, k, t) = param(N, k, t)
_pop(::Nothing, k, t) = true
_add_pop!(N̄, N, x, k, t) = add_param!(N̄, N, x, k, t)
_add_pop!(N̄, ::Nothing, x, k, t) = nothing

_draws(m::Depletion) = _ndraws(m.pieces) > 0
_npools(m::Depletion) = length(m.pools)
_queue_of(m::Depletion) = _kind_of(m.pieces, _Queue)
_stratum_of(m::Depletion) = _kind_of(m.pieces, _ToStratum)

# The values and state entries of each group: with a draw, one value (two
# with an overflow into a stratum) and one entry per pool (and the queue);
# without, the pools are both.
blocks(m::_Pointwise) = nothing
function blocks(m::Depletion)
    n = _npools(m)
    _draws(m) || return Val((n, n))
    return Val((1 + (_stratum_of(m) isa _ToStratum), n + (_queue_of(m) isa _Queue)))
end
ispointwise(m::Depletion) = blocks(m) === nothing

# The groups of `S` strata.
_pool_groups(m::Depletion, S) = _pool_groups(blocks(m), S)
_pool_groups(::Nothing, S) = S
_pool_groups(b::Val, S) = _ngroups(b, S)

function _check_modifier_strata(m::Depletion, S)
    G = _pool_groups(m, S)
    _check_param_strata(:N, m.N, G)
    _check_each_strata(:pools, values(m.pools), G)
    foreach(p -> _check_piece_groups(p, G), m.pieces)
    return nothing
end
_check_piece_groups(fs::Tuple, G) = _check_flow_groups(fs, G)
function _check_piece_groups(d::_DrawFrom, G)
    return _check_each_strata(:weight, _by_position(d.weights), G)
end
_check_piece_groups(d::_DrawInto, G) = nothing

# Each parameter of a tuple against the groups, unrolled so each check is
# compiled for its type.
_check_each_strata(name, ::Union{Tuple{}, Nothing}, G) = nothing
function _check_each_strata(name, xs::Tuple, G)
    _check_param_strata(name, first(xs), G)
    return _check_each_strata(name, Base.tail(xs), G)
end

# A named tuple, or its mirror, by position.
_by_position(x::NamedTuple) = values(x)
_by_position(x) = x

# The pool the first draw from the pools takes from when they are empty,
# or zero.
_first_drawn(::Tuple{}) = 0
_first_drawn(ps::Tuple) = _first_drawn(first(ps), Base.tail(ps))
_first_drawn(d::_DrawFrom, rest) = d.first
_first_drawn(p, rest) = _first_drawn(rest)

# Pool `i`'s value before the first step at group `k`, and its cotangent:
# by default `N` at time 1 for the pool the first draw takes from first,
# else zero.
_initial(x, m, i, k) = param(x, k, 1)
function _initial(::Nothing, m, i, k)
    N = m.N === nothing ? false : param(m.N, k, 1)
    return ifelse(_starts_full(m, i), N, zero(N))
end
_starts_full(m, i) = i == _first_drawn(m.pieces)
function _add_initial!(m̄, x, x̄s, m, i, x̄, k)
    return add_param!(x̄s, x, x̄, k, 1)
end
function _add_initial!(m̄, ::Nothing, x̄s, m, i, x̄, k)
    _starts_full(m, i) || return nothing
    return _add_pop!(cotangent(m̄, :N), m.N, x̄, k, 1)
end

# Every pool's value before the first step at group `k`, and their
# cotangents from the state cotangent `s̄` of `G` groups, mapped over the
# pools so each reads its own starting value.
_places(xs::Tuple) = ntuple(identity, Val(length(xs)))
function _initials(m::Depletion, k)
    xs = values(m.pools)
    return map((x, i) -> _initial(x, m, i, k), xs, _places(xs))
end
function _add_initials!(m̄, m::Depletion, s̄, G, k)
    xs = values(m.pools)
    x̄s = _pool_mirrors(cotangent(m̄, :pools), xs)
    map(xs, x̄s, _places(xs)) do x, x̄s, i
        return _add_initial!(m̄, x, x̄s, m, i, s̄[(i - 1) * G + k], k)
    end
    return nothing
end
_pool_mirrors(::Nothing, xs) = map(_ -> nothing, xs)
_pool_mirrors(x̄::NamedTuple, xs) = values(x̄)

# The values of each group.
_nvalues(::Nothing) = 1
_nvalues(::Val{B}) where {B} = B[1]

# The state entries of each group: the pools, then the queue.
_nentries(m::Depletion) = _npools(m) + (_queue_of(m) isa _Queue)

function forward!(m::Depletion, ::Init, s, history)
    G = length(s) ÷ _nentries(m)
    _check_modifier_strata(m, _nvalues(blocks(m)) * G)
    _each!(_initial_body!, Serial(), s, G, length(s), s, m, G)
    return nothing
end
function forward!(m::_Drawless, ::Init, s, history)
    G = length(s) ÷ _nentries(m)
    _check_modifier_strata(m, _nvalues(blocks(m)) * G)
    fill!(s, zero(eltype(s)))
    return nothing
end

function _initial_body!(k, s, m, G)
    x = _initials(m, k)
    _scatter!(s, _with_queue(_queue_of(m), x, false), G, k)
    return nothing
end

function pullback!(grads, m::Depletion, ::Init, s, history)
    G = length(s) ÷ _nentries(m)
    s̄ = grads.s
    for k in 1:G
        _add_initials!(grads.piece, m, s̄, G, k)
    end
    return nothing
end
pullback!(grads, m::_Drawless, ::Init, s, history) = nothing

# The mirrors of the first piece and of the run of flows after it.
_draw_mirror(m̄) = _head(cotangent(m̄, :pieces))
_run_mirror(m̄) = _head(_tail(cotangent(m̄, :pieces)))

# One pool drawn from once: the form's draw from each stratum's pool.
function forward!(m::_Depleting, ::Step, v, s, t)
    form = only(m.pieces).form
    for k in eachindex(v, s)
        v[k], s[k] = _draw(form, v[k], s[k], _pop(m.N, k, t))
    end
    return nothing
end

function pullback!(grads, m::_Depleting, ::Step, v, s, t)
    m̄, v̄, s̄ = grads.piece, grads.v, grads.s
    form = only(m.pieces).form
    f̄ = cotangent(_draw_mirror(m̄), :form)
    for k in eachindex(v, s)
        v̄[k], s̄[k], N̄ = _form_pullback(
            (; piece = f̄, v = v̄[k], s = s̄[k]), form, v[k], s[k], _pop(m.N, k, t)
        )
        _add_pop!(cotangent(m̄, :N), m.N, N̄, k, t)
    end
    return nothing
end

# One pool drawn from, then flows on the pool.
function forward!(m::_Flowing, ::Step, v, s, t)
    d, fs = m.pieces
    for k in eachindex(v, s)
        y, s′ = _draw(d.form, v[k], s[k], _pop(m.N, k, t))
        (s″,) = _flow_only(fs, (s′,), k, t)
        v[k], s[k] = y, s″
    end
    return nothing
end

function pullback!(grads, m::_Flowing, ::Step, v, s, t)
    m̄, v̄, s̄ = grads.piece, grads.v, grads.s
    d, fs = m.pieces
    f̄ = cotangent(_draw_mirror(m̄), :form)
    f̄s = _run_mirror(m̄)
    for k in eachindex(v, s)
        N = _pop(m.N, k, t)
        _, s′ = _draw(d.form, v[k], s[k], N)
        s̄′ = only(_flows_pullback(fs, f̄s, (s′,), (s̄[k],), (zero(s̄[k]),), k, t))
        v̄[k], s̄[k], N̄ = _form_pullback(
            (; piece = f̄, v = v̄[k], s = s̄′), d.form, v[k], s[k], N
        )
        _add_pop!(cotangent(m̄, :N), m.N, N̄, k, t)
    end
    return nothing
end

# A group's step and its pullback. They, the pieces' steps and their
# helpers are inlined, as their calls are (see `_vector_step!`): the
# call-site inline reaches only the first method, and across the inner
# calls the rule's reverse pass took about 45% longer per group.
_block_step(m::Depletion, v::Tuple, s::Tuple, t, g) = _group_step(m, v, s, t, g)

# Without a draw: the flows on the group's values.
@inline function _group_step(m::_Drawless, v, s, t, g)
    return _flow_group(only(m.pieces), v, g, t)
end

# With a draw: the pieces fold over the group's value, the value of its
# overflow stratum, its pools and its queue, `(a, b, x, Q)`, with
# `nothing` for an overflow it lacks.
@inline function _group_step(m, v, s, t, g)
    q, st = _queue_of(m), _stratum_of(m)
    x, Q = _pools_queue(q, s, Val(_npools(m)))
    c = (first(v), _second(st, v), x, Q)
    a, b, x′, Q′ = _pieces_step(m.pieces, m, c, t, g)
    return _out_values(st, a, b), _with_queue(q, x′, Q′)
end

# The pools and the queue in a group's state, `nothing` without a queue,
# and the second value with an overflow into a stratum.
_pools_queue(q, s, ::Val{n}) where {n} = s, nothing
_pools_queue(::_Queue, s, ::Val{n}) where {n} = ntuple(i -> s[i], Val(n)), s[n + 1]
_with_queue(q, x, u) = x
_with_queue(::_Queue, x, u) = (x..., u)
_second(st, v) = nothing
_second(::_ToStratum, v) = v[2]
_out_values(st, a, b) = (a,)
_out_values(::_ToStratum, a, b) = (a, b)

# Each piece on `(a, b, x, Q)` in turn.
@inline _pieces_step(::Tuple{}, m, c, t, g) = c
@inline function _pieces_step(ps::Tuple, m, c, t, g)
    return _pieces_step(Base.tail(ps), m, _piece_step(first(ps), m, c, t, g), t, g)
end

# A run of flows moves the pools.
@inline function _piece_step(fs::_Flows, m, c, t, g)
    a, b, x, Q = c
    return a, b, _flow_only(fs, x, g, t), Q
end

# A draw takes its value, with the queue for the draw that holds it, from
# the pools or into one, and sends what it leaves to its overflow.
@inline function _piece_step(p::_Drawing, m, c, t, g)
    a, b, x, Q = c
    o = p.overflow
    d = _demand(o, a, Q)
    y, x′ = _take(p, m, d, x, t, g)
    u = d - y
    return y, _to_stratum(o, b, u), x′, _to_queue(o, Q, u)
end
_demand(o, a, Q) = a
_demand(::_Queue, a, Q) = a + Q
_to_stratum(o, b, u) = b
_to_stratum(::_ToStratum, b, u) = b + u
_to_queue(o, Q, u) = Q
_to_queue(::_Queue, Q, u) = u

# The weights at group `g` and time `t`, promoted to one type so a step
# indexes them without a union, and the weighted pools `Σ w_i x_i`, summed
# in order. A fixed weight of one promotes to an exact one.
function _weights_at(p, ::Val{n}, g, t) where {n}
    return promote(ntuple(i -> param(p.weights[i], g, t), Val(n))...)
end
function _weighted(w::Tuple, x::Tuple)
    return _weighted_sum(Base.tail(w), Base.tail(x), first(w) * first(x))
end
_weighted_sum(::Tuple{}, ::Tuple{}, P) = P
function _weighted_sum(w::Tuple, x::Tuple, P)
    return _weighted_sum(Base.tail(w), Base.tail(x), P + first(w) * first(x))
end

# The draw from the pools: out of the weighted pools, or into one pool
# up to `N`. Returns the value drawn and the pools after it.
@inline _take(p::_DrawFrom, m, d, x, t, g) = _draw_pools(p, m, d, x, t, g)
@inline function _take(p::_DrawInto, m, d, x::NTuple{n}, t, g) where {n}
    f = p.pool
    N = _pop(m.N, g, t)
    y, _ = _draw(p.form, d, N - x[f], N)
    return y, ntuple(i -> i == f ? x[i] + y : x[i], Val(n))
end

# One pool: it loses the draw.
@inline function _draw_pools(p, m, v, x::Tuple{Any}, t, g)
    w = param(only(p.weights), g, t)
    y, _ = _draw(p.form, v, w * only(x), _pop(m.N, g, t))
    return y, (only(x) - y,)
end

# Several pools: each loses the draw in proportion to its weighted pool.
@inline function _draw_pools(p, m, v, x::NTuple{n}, t, g) where {n}
    w = _weights_at(p, Val(n), g, t)
    P = _weighted(w, x)
    y, _ = _draw(p.form, v, P, _pop(m.N, g, t))
    # `ifelse`, not `if`, so a traced `P` needs no branch; the guarded
    # division keeps the unused arm finite. The arm follows the primal `P`,
    # so a dual `P` with value zero takes the arm without the division.
    on = _primal_value(P) > 0
    q = y / ifelse(on, P, one(P))
    d = p.first
    x′ = ntuple(Val(n)) do i
        return ifelse(on, x[i] - q * w[i] * x[i], ifelse(i == d, x[i] - y, x[i]))
    end
    return y, x′
end

# The group step and its pullback on tuples of one-entry views, from the
# kernels.
function forward!(m::Depletion, ::Step, v::Tuple, s::Tuple, t, g)
    v′, s′ = _block_step(m, map(getindex, v), map(getindex, s), t, g)
    foreach(setindex!, v, v′)
    foreach(setindex!, s, s′)
    return nothing
end
function pullback!(grads, m::Depletion, ::Step, v::Tuple, s::Tuple, t, g)
    gg = (; piece = grads.piece, v = map(getindex, grads.v), s = map(getindex, grads.s))
    v̄, s̄ = _block_back(gg, m, map(getindex, v), map(getindex, s), t, g)
    foreach(setindex!, grads.v, v̄)
    foreach(setindex!, grads.s, s̄)
    return nothing
end
function _block_back(grads, m::Depletion, v::Tuple, s::Tuple, t, g)
    return _group_pullback(grads, m, v, s, t, g)
end
@inline function _group_pullback(grads, m::_Drawless, v, s, t, g)
    x̄ = _flows_pullback(
        only(m.pieces), _head(cotangent(grads.piece, :pieces)), v, grads.v, grads.s,
        g, t
    )
    return x̄, map(_ -> zero(eltype(x̄)), x̄)
end

# `v` and `s` are the group's incoming values and state; returns their
# cotangents from those of the values and state after the step.
@inline function _group_pullback(grads, m, v, s, t, g)
    q, st = _queue_of(m), _stratum_of(m)
    n = Val(_npools(m))
    x, Q = _pools_queue(q, s, n)
    x̄, Q̄ = _pools_queue(q, grads.s, n)
    c = (first(v), _second(st, v), x, Q)
    c̄ = (first(grads.v), _second(st, grads.v), x̄, Q̄)
    p̄s = cotangent(grads.piece, :pieces)
    ā, b̄, x̄0, Q̄0 = _pieces_back(m.pieces, p̄s, grads.piece, m, c, c̄, t, g)
    return _out_values(st, ā, b̄), _with_queue(q, x̄0, Q̄0)
end

# The fold in reverse: each piece's step forward, so the pieces after it
# read what it gives, then its pullback, last first. The last piece's step
# is not run: its pullback reads what it gives only where it says so.
@inline function _pieces_back(ps::Tuple{Any}, p̄s, m̄, m, c, c̄, t, g)
    return _piece_back(first(ps), _head(p̄s), m̄, m, c, nothing, c̄, t, g)
end
@inline function _pieces_back(ps::Tuple, p̄s, m̄, m, c, c̄, t, g)
    p = first(ps)
    c′ = _piece_step(p, m, c, t, g)
    c̄′ = _pieces_back(Base.tail(ps), _tail(p̄s), m̄, m, c′, c̄, t, g)
    return _piece_back(p, _head(p̄s), m̄, m, c, c′, c̄′, t, g)
end

# A run of flows: the cotangent of the pools before it.
@inline function _piece_back(fs::_Flows, f̄s, m̄, m, c, c′, c̄, t, g)
    x = c[3]
    ā, b̄, x̄′, Q̄ = c̄
    z = map(_ -> zero(ā), x)
    return ā, b̄, _flows_pullback(fs, f̄s, x, x̄′, z, g, t), Q̄
end

# A draw: the cotangents of its value, with the queue's for the draw that
# holds it, and of the pools before it, from those of the value it passes
# on, its overflow and the pools after it.
@inline function _piece_back(p::_Drawing, p̄, m̄, m, c, c′, c̄, t, g)
    a, b, x, Q = c
    ā′, b̄′, x̄′, Q̄′ = c̄
    o = p.overflow
    d = _demand(o, a, Q)
    ū = _left_back(o, ā′, b̄′, Q̄′)
    ȳ = ā′ - ū
    y = _drawn_value(p, c′, m, d, x, t, g)
    d̄, x̄ = _take_back(p, p̄, m̄, m, d, x, y, ȳ, x̄′, t, g)
    d̄ += ū
    return d̄, b̄′, x̄, _queue_back(o, Q̄′, d̄)
end

# The cotangent of what the draw leaves, and of the queue before it.
_left_back(o, ā, b̄, Q̄) = zero(ā)
_left_back(::_ToStratum, ā, b̄, Q̄) = b̄
_left_back(::_Queue, ā, b̄, Q̄) = Q̄
_queue_back(o, Q̄, d̄) = Q̄
_queue_back(::_Queue, Q̄, d̄) = d̄

# The value drawn, where the draw's pullback reads it: from several pools.
# The last piece's is drawn again.
_drawn_value(p, c′, m, d, x, t, g) = nothing
function _drawn_value(p::_DrawFrom, c′, m, d, x::NTuple{n, Any}, t, g) where {n}
    return n > 1 ? _drawn_again(c′, p, m, d, x, t, g) : nothing
end
_drawn_again(c′::Tuple, p, m, d, x, t, g) = first(c′)
_drawn_again(::Nothing, p, m, d, x, t, g) = first(_take(p, m, d, x, t, g))

# The draw's pullback: the cotangents of the value it takes and of the
# pools before it, from those of the value drawn `y`, `ȳ`, and of the
# pools after it, `x̄′`; the parameters' are added into the mirrors of the
# draw `p̄` and of the `Depletion` `m̄`.
@inline function _take_back(
        p::_DrawInto, p̄, m̄, m, d, x::NTuple{n}, y, ȳ, x̄′, t, g
    ) where {n}
    f = p.pool
    N = _pop(m.N, g, t)
    d̄, P̄, N̄ = _form_pullback(
        (; piece = cotangent(p̄, :form), v = ȳ + x̄′[f], s = zero(ȳ)), p.form,
        d, N - x[f], N
    )
    _add_pop!(cotangent(m̄, :N), m.N, N̄ + P̄, g, t)
    return d̄, ntuple(i -> i == f ? x̄′[i] - P̄ : x̄′[i], Val(n))
end
@inline function _take_back(
        p::_DrawFrom, p̄, m̄, m, v, x::Tuple{Any}, y, ȳ, x̄′, t, g
    )
    w = param(only(p.weights), g, t)
    N = _pop(m.N, g, t)
    v̄, P̄, N̄ = _form_pullback(
        (; piece = cotangent(p̄, :form), v = ȳ - only(x̄′), s = zero(ȳ)), p.form,
        v, w * only(x), N
    )
    _add_pop!(cotangent(m̄, :N), m.N, N̄, g, t)
    _add_weights!(cotangent(p̄, :weights), p.weights, (only(x) * P̄,), g, t)
    return v̄, (only(x̄′) + w * P̄,)
end
@inline function _take_back(
        p::_DrawFrom, p̄, m̄, m, vk, x::NTuple{n}, y, ȳ, x̄′, t, g
    ) where {n}
    N = _pop(m.N, g, t)
    w = _weights_at(p, Val(n), g, t)
    P = _weighted(w, x)
    on = _primal_value(P) > 0
    q = on ? y / P : zero(y)
    d = p.first
    z = zero(ȳ)
    # The shares' pullback, from a function so that no name the closures
    # below capture is assigned twice, which would box it.
    x̄, w̄, ȳd, P̄d = _shares_back(on, x̄′, w, x, q, P, ȳ, d, z, Val(n))
    v̄k, P̄f, N̄ = _form_pullback(
        (; piece = cotangent(p̄, :form), v = ȳd, s = zero(ȳ)), p.form, vk, P, N
    )
    P̄ = P̄d + P̄f
    _add_pop!(cotangent(m̄, :N), m.N, N̄, g, t)
    _add_weights!(
        cotangent(p̄, :weights), p.weights, ntuple(i -> w̄[i] + x[i] * P̄, Val(n)),
        g, t
    )
    return v̄k, ntuple(i -> x̄[i] + w[i] * P̄, Val(n))
end

# The cotangents of the pools, the weights, the value drawn and the
# weighted pools from those of the pools after the draw `x̄′`: each pool
# lost the share `q = y / P` of its weighted pool, or with `P <= 0` the
# first pool drawn lost `y`.
@inline function _shares_back(on, x̄′, w, x, q, P, ȳ, d, z, ::Val{n}) where {n}
    on || return x̄′, ntuple(_ -> z, Val(n)), ȳ - x̄′[d], z
    q̄ = _weighted_back(x̄′, w, x)
    x̄ = ntuple(i -> x̄′[i] * (1 - q * w[i]), Val(n))
    w̄ = ntuple(i -> -x̄′[i] * q * x[i], Val(n))
    return x̄, w̄, ȳ + q̄ / P, -q̄ * q / P
end

# `q̄ = -Σ x̄′_i w_i x_i`, the cotangent of the share drawn, in order.
function _weighted_back(x̄′, w, x)
    q̄ = -first(x̄′) * first(w) * first(x)
    return _weighted_back(Base.tail(x̄′), Base.tail(w), Base.tail(x), q̄)
end
_weighted_back(::Tuple{}, ::Tuple{}, ::Tuple{}, q̄) = q̄
function _weighted_back(x̄′::Tuple, w::Tuple, x::Tuple, q̄)
    q̄ -= first(x̄′) * first(w) * first(x)
    return _weighted_back(Base.tail(x̄′), Base.tail(w), Base.tail(x), q̄)
end

# Each weight's cotangent into its mirror.
function _add_weights!(w̄s, ws::NamedTuple, vals, g, t)
    return _add_weights!(_by_position(w̄s), values(ws), vals, g, t)
end
_add_weights!(w̄s, ::Tuple{}, vals, g, t) = nothing
function _add_weights!(w̄s, ws::Tuple, vals, g, t)
    add_param!(_head(w̄s), first(ws), first(vals), g, t)
    return _add_weights!(_tail(w̄s), Base.tail(ws), Base.tail(vals), g, t)
end

# A `Depletion` uses its own pullback when each draw's form has one or the
# form's local derivative covers it (see `_form_pullback`).
uses_adjoint(m::Depletion, ::Step) = _forms_adjoint(m.pieces)
_forms_adjoint(::Tuple{}) = true
_forms_adjoint(ps::Tuple) = _piece_adjoint(first(ps)) && _forms_adjoint(Base.tail(ps))
_piece_adjoint(p) = true
_piece_adjoint(d::_Drawing) = _form_adjoint(d.form)

# The draws' forms.
_forms(::Tuple{}) = ()
_forms(ps::Tuple) = (_piece_form(first(ps))..., _forms(Base.tail(ps))...)
_piece_form(p) = ()
_piece_form(d::_Drawing) = (d.form,)

# A draw's form among the parts the local step rebuilds, marked as a form:
# its step takes the same arguments as a modifier's.
struct _FormPart{F}
    form::F
end

# Trace ---------------------------------------------------------------------

# A pool's trace: with a draw, its pools after the step, the value passed
# on and what the draws leave of the demand, per stratum for one pool and
# per group otherwise; without one, the amount each flow moves, per group.
function ntrace(m::Depletion, S)
    B = blocks(m)
    B === nothing && return 3S
    return (_npools(m) + 2) * _ngroups(B, S)
end
ntrace(m::_Drawless, S) = length(only(m.pieces)) * (S ÷ _npools(m))

function forward!(m::_Pointwise, ::Trace, r, v, s, v′, s′, t)
    pools, drawn, left = r
    for k in eachindex(v, v′, s′)
        pools[k], drawn[k], left[k] = s′[k], v′[k], v[k] - v′[k]
    end
    return nothing
end
function pullback!(grads, m::_Pointwise, ::Trace, v, s, t)
    p̄, ȳ, ū = grads.trace
    for k in eachindex(v)
        grads.v[k] += ū[k]
        grads.v′[k] += ȳ[k] - ū[k]
        grads.s′[k] += p̄[k]
    end
    return nothing
end

function forward!(
        m::Depletion, ::Trace, r::Tuple, v::Tuple, s::Tuple, v′::Tuple, s′::Tuple, t, g
    )
    vals = _pool_trace(
        m, _view_entries(v), _view_entries(s), _view_entries(v′),
        _view_entries(s′), t, g
    )
    foreach((x, y) -> x[] = y, r, vals)
    return nothing
end
# A pool's group trace and its pullback on the gathered values, without
# views, as its step runs.
@inline function _group_trace!(
        m::Depletion, ::Val{B}, col, v, s, v′, s′, t, G, g
    ) where {B}
    nv, ns = B
    r = _pool_trace(
        m, _gather(v, Val(nv), G, g), _gather(s, Val(ns), G, g),
        _gather(v′, Val(nv), G, g), _gather(s′, Val(ns), G, g), t, g
    )
    _scatter!(col, r, G, g)
    return nothing
end
@inline function _group_trace_back!(
        m::Depletion, ::Val{B}, R, m̄, v̄, s̄, r̄, v, s, τ, G, g
    ) where {B}
    nv, ns = B
    inner = (; piece = m̄, trace = _gather(r̄, Val(ntrace(m, nv)), G, g))
    a, b, c, d = _pool_trace_back(
        inner, m, _gather(v, Val(nv), G, g), _gather(s, Val(ns), G, g), τ, g
    )
    _scatter!(v̄, map(+, _gather(v̄, Val(nv), G, g), c), G, g)
    _scatter!(s̄, map(+, _gather(s̄, Val(ns), G, g), d), G, g)
    _scatter!(R.V̄, map(+, _gather(R.V̄, Val(nv), G, g), a), G, g)
    _scatter!(R.S̄, map(+, _gather(R.S̄, Val(ns), G, g), b), G, g)
    return nothing
end
# The entries of a group's one-entry views.
_view_entries(xs::Tuple) = map(x -> x[], xs)
_pool_trace(m::_Drawless, v, s, v′, s′, t, g) = _amounts(only(m.pieces), v, g, t)
function _pool_trace(m, v, s, v′, s′, t, g)
    n = Val(_npools(m))
    q = _queue_of(m)
    x, _ = _pools_queue(q, s′, n)
    _, Q = _pools_queue(q, s, n)
    y = first(v′)
    return (x..., y, _demand(q, first(v), Q) - y)
end

function pullback!(grads, m::Depletion, ::Trace, v::Tuple, s::Tuple, t, g)
    inner = (; piece = grads.piece, trace = _view_entries(grads.trace))
    a, b, c, d = _pool_trace_back(inner, m, _view_entries(v), _view_entries(s), t, g)
    foreach((x̄, y) -> x̄[] += y, grads.v, a)
    foreach((x̄, y) -> x̄[] += y, grads.s, b)
    foreach((x̄, y) -> x̄[] += y, grads.v′, c)
    foreach((x̄, y) -> x̄[] += y, grads.s′, d)
    return nothing
end
_pool_trace_back(grads, m::_Drawless, v, s, t, g) = _amounts_back(grads, m, v, s, t, g)
function _pool_trace_back(grads, m, v, s, t, g)
    n = _npools(m)
    r̄ = grads.trace
    ȳ, ū = r̄[n + 1], r̄[n + 2]
    z = zero(ū)
    x̄ = ntuple(i -> r̄[i], Val(n))
    zx = ntuple(_ -> z, Val(n))
    v̄ = ntuple(i -> i == 1 ? ū : z, Val(length(v)))
    v̄′ = ntuple(i -> i == 1 ? ȳ - ū : z, Val(length(v)))
    q = _queue_of(m)
    return v̄, _with_queue(q, zx, ū), v̄′, _with_queue(q, x̄, z)
end

# The flows' amounts back to the pools before them, and to each flow's
# demand and softness.
function _amounts_back(grads, m, x, s, t, g)
    f̄s = _head(cotangent(grads.piece, :pieces))
    x̄ = _amounts_pullback(only(m.pieces), f̄s, grads.trace, x, g, t)
    z = zero(eltype(x̄))
    zs = map(_ -> z, s)
    return x̄, zs, map(_ -> z, x), zs
end
