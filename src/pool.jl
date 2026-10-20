# A `Depletion` holds pools for each group of strata: the step's value is
# drawn from them by a depletion form, then flows move between them.
# Without a draw the pools are the step's values, carried by the
# recurrence, and the flows move them.
#
# The number of pools is the length of `pools`, and how the draw takes,
# when the flows act and where what it leaves goes are singleton fields, so
# each kind has methods of its own: one pool drawn from before its flows,
# with nothing left over, is a pointwise step; any other is blockwise.

@doc raw"""
Depletion of pools: each group of strata holds pools, the step's value is
drawn from them by a depletion form, and
[`ComposableRecurrences.Flow`](@ref)s move between them.

With one pool ``s``, the default, each stratum ``i`` (see
[`PerStratum`](@ref)) at absolute time ``t`` from the call's first time
``t_0`` steps as

```math
s_{t_0 - 1, i} = s_{0,i}, \qquad
(v'_{t,i},\ s^{*}_{t,i}) = F\big(v_{t,i},\ s_{t-1,i},\ N_{t,i},\ \alpha\big),
\qquad s_{t,i} = \Phi_t\big(s^{*}_{t,i}\big),
```

where ``v_{t,i}`` is the value entering the modifier, ``v'_{t,i}`` the value
it passes on, ``s_{0,i}`` the starting pool, ``N_{t,i}`` the population at
time ``t``, ``\alpha`` the heterogeneity exponent, ``F`` the form's
`forward!(form, Step(), v, s, N, α)` and ``\Phi_t`` the flows, such as the
removals ``s^{*} - \min\big(r_t, \max(s^{*}, 0)\big)``.
The hazard fraction divides by `N` whatever the pool starts at.

With ``n`` pools ``x_1, \dots, x_n`` in a group, the form draws from the
weighted pools ``P`` and each pool loses the draw in proportion to its
weight:

```math
\begin{aligned}
P &= \sum_i w_i x_i, \qquad (v', \cdot) = F(v, P, N_t, \alpha), \\
x^{*}_i &= x_i - v' \frac{w_i x_i}{P}, \qquad x' = \Phi_t(x^{*}),
\end{aligned}
```

where ``w_i`` is pool ``i``'s weight, zero for a pool `weights` does not
name.
When ``P \le 0`` the draw comes from the first pool `weights` names alone.
A draw into pool ``f`` (`fill = f`) fills it instead, up to ``N_t``:
``(v', \cdot) = F(v, N_t - x_f, N_t, \alpha)`` and ``x^{*}_f = x_f + v'``,
as admissions fill beds.
Its form is `Truncate()` or `SoftTruncate(κ)`, and its capacity ``N_t`` is
not negative.
The flows act on the pools after the draw, or before it with
`flows_first = true`, as when patients leave before the day's admissions
or an allowance is granted at the start of a period.
They act in the order [`ComposableRecurrences.Flow`](@ref) sets out, and a
count flow from `0` brings its demand in from outside.
What the draw leaves of the demand, ``u = v - v'``, goes nowhere by
default; with `overflow = :stratum` to the group's second value,
``v'_2 = v_2 + u``, and with `overflow = :queue` to a queue held after the
pools in the state, whose content joins the next step's demand.

The form is a variant struct with `forward!(form, Step(), v, s, N, α)`:
[`ComposableRecurrences.Hazard`](@ref),
[`ComposableRecurrences.Floor`](@ref),
[`ComposableRecurrences.Truncate`](@ref),
[`ComposableRecurrences.SoftTruncate`](@ref), or a new type with that
method ([A depletion form](@ref extending-form)).
`α > 1` depletes faster as the pool shrinks (heterogeneous mixing).
The draw's `Hazard()` takes its hazard from the value over the population,
``v / N_t``; a `Hazard()` flow's demand is read as
[`ComposableRecurrences.Flow`](@ref) sets out.
[Rules and plain AD](@ref adjoint-routing) gives the gradient of a form
without a `pullback!`.

One pool drawn from, with its flows after the draw and no overflow, is a
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

Without a draw (`form = nothing`) the pools are the step's values: the
values hold ``n`` pools of ``G`` groups each, pool by pool
(`blocks` is `Val((n, n))`), so value ``(i - 1) G + g`` is pool ``i`` of
group ``g``.
On a [`Recurrence`](@ref) with kernel `[1.0]` the core carries the
previous step's pools forward, and the `Depletion` applies the step's
flows, ``v' = \Phi_t(v)``.
The state then holds what flowed into each pool at the step, where a
negative count adds nothing.

| model | keywords |
|:----- |:-------- |
| a population with births and deaths | a `TimeVarying` `N`, with arrivals as negative `removals` and departures as positive ones |
| leaky protection at relative susceptibility ``\sigma`` | `protected = σ`, with doses as `removals` |
| beds that a share ``\delta`` leaves each step | `form = Truncate()`, `fill = :O`, `flows = Flow(:O => 0, δ; form = Share())`, `flows_first = true`, with `N` the beds |
| an allowance granted ``b_t`` at each period start | `form = Truncate()`, `flows = Flow(0 => :B, TimeVarying(b); form = Truncate())`, `flows_first = true` |
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
A `Depletion` holds the fields `N`, `form`, `heterogeneity`, `pools`
(each pool's starting value, `nothing` for its default), `weights` (each
pool's weight in the draw, `nothing` without one), `flows` (with each
flow's pools as positions), `draw`, `order` and `overflow`.

# Arguments
- `N`: the population the form reads, or the capacity a draw fills up to,
  a [parameter](@ref ComposableRecurrences.param) read at each step's group
  and time; `nothing` for a `Depletion` without a draw, or whose truncated
  draw from its pools does not read it.

# Keyword Arguments
- `pools`: each pool's name and starting value, a named tuple such as
  `(S = N, V = 0.0)`, or a tuple of names when each takes its default;
  `(S = nothing,)` by default.
  A starting value is one value or `PerStratum`, or `nothing` for `N` at
  time 1 in the first pool drawn from and zero in the others.
  A `Depletion` without a draw takes its pools from the history instead,
  so each starts at `nothing`.
  A seed drawn from the pool is `pools = (S = max(N - sum(seed), 0),)`.
- `form`: the depletion form; `Hazard()` by default, or `nothing` for no
  draw.
- `weights`: each pool's weight in the draw, a named tuple such as
  `(S = 1, V = σ)`; the first pool's alone at `1` by default.
  A weight is one value or `PerStratum`, constant over time; an integer
  weight is fixed, a float one a parameter.
  One pool is drawn with weight `1`.
- `fill`: the name of the pool the draw fills, in place of `weights`, or
  `nothing`.
- `heterogeneity`: the exponent `α`; `true` by default for the built-in
  forms, an exponent of exactly one that is not a parameter, and `1` for
  other forms.
  For the built-in forms `true` and `false` stay fixed; any other integer
  takes the population's float type.
  Pass a float to differentiate the exponent.
- `removals`: a count taken out of the first pool at each step, capped by
  what it holds, as a `Truncate()` flow before `flows`; a negative removal
  adds to the pool without a cap.
- `protected`: a relative susceptibility ``\sigma``, for two pools drawn
  with `weights = (S = 1, V = σ)`, the `removals` moving from the first
  into the second; `nothing` by default.
- `flows`: a [`ComposableRecurrences.Flow`](@ref), or a tuple or vector of
  them, naming the pools by name or position; none by default.
- `flows_first`: whether the flows act before the draw; `false` by
  default.
- `overflow`: where what the draw leaves goes: `nothing` (the default),
  `:stratum` or `:queue`.

# Examples

Depletion from a pool that starts below the population by the seed:

```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
seed = [1.0, 2.0]
depletion = CR.Depletion(100.0; pools = (S = 100.0 - sum(seed),))
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
enter the pool as negative removals.

```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
births = fill(3.0, 8)
N = TimeVarying(100.0 .+ cumsum(births))
herd = CR.Depletion(N; pools = (S = 90.0,), removals = TimeVarying(-births))
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
    1000.0; protected = 0.3, removals = 5.0, flows = CR.Flow(:V => :S, 0.1)
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
    10.0; pools = (O = 0.0,), form = CR.Truncate(), fill = :O,
    flows = CR.Flow(:O => 0, 0.1; form = CR.Share()), flows_first = true,
    overflow = :stratum
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
doses = CR.Depletion(;
    pools = (:B,), form = CR.Truncate(),
    flows = CR.Flow(0 => :B, grants; form = CR.Truncate()), flows_first = true,
    overflow = :stratum
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
ward = CR.Depletion(;
    pools = (:suspected, :confirmed), form = nothing,
    flows = (
        CR.Flow(:suspected => :confirmed, 0.3), CR.Flow(:suspected => 0, 0.4),
        CR.Flow(:confirmed => 0, 0.1),
    )
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
struct Depletion{P, F, A, I, W, R, D, O, Q}
    "The population the form reads, a parameter, or `nothing`."
    N::P
    "The draw form, or `nothing` without a draw."
    form::F
    "The heterogeneity exponent α, or `nothing` without a draw."
    heterogeneity::A
    "Each pool's starting value by name, `nothing` for its default."
    pools::I
    "Each pool's weight in the draw by name, or `nothing` without one."
    weights::W
    "The flows between the pools, by position."
    flows::R
    "How the form draws: from the weighted pools, into one, or `nothing`."
    draw::D
    "Whether the flows act before or after the draw."
    order::O
    "Where what the draw leaves goes."
    overflow::Q
    function Depletion(
            N::P, form::F, heterogeneity::A, pools::I, weights::W, flows::R,
            draw::D, order::O, overflow::Q
        ) where {P, F, A, I, W, R, D, O, Q}
        form === nothing || _check_form(form)
        n = length(pools)
        for f in flows
            _check_pool(f, n)
        end
        _check_drawn(draw, n)
        return new{P, F, A, I, W, R, D, O, Q}(
            N, form, heterogeneity, pools, weights, flows, draw, order, overflow
        )
    end
end

# How the form draws: from the weighted pools, with `first` the pool it
# takes from when they are empty, or into pool `pool`.
struct _DrawFrom
    first::Int
end
struct _DrawInto
    pool::Int
end

# Whether the flows act before or after the draw.
struct _FlowsAfter end
struct _FlowsFirst end

# Where what the draw leaves goes: nowhere, to the group's second value or
# to a queue that joins the next step's demand.
struct _Drop end
struct _ToStratum end
struct _Queue end

# That the flows and the draw name no pool beyond the `n` there are; the
# message is built only when one does.
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
_check_drawn(::Nothing, n) = nothing
_check_drawn(d::_DrawFrom, n) = _check_drawn_pool(d.first, n)
_check_drawn(d::_DrawInto, n) = _check_drawn_pool(d.pool, n)
function _check_drawn_pool(i, n)
    1 <= i <= n || throw(ArgumentError("the draw names pool $i of $n"))
    return nothing
end

# Inlined, so that a differentiated function that builds a `Depletion`
# holds no call returning it.
@inline function Depletion(
        N = nothing; pools = nothing, form = Hazard(), weights = nothing,
        fill = nothing, heterogeneity = nothing, removals = nothing,
        protected = nothing, flows = (), flows_first::Bool = false,
        overflow = nothing
    )
    form === nothing && _check_no_draw(
        weights, fill, heterogeneity, protected, flows_first, overflow
    )
    starts = _pool_starts(pools, protected)
    names = keys(starts)
    N = N === nothing ? nothing : _population(N)
    ws, draw = _draw_spec(form, weights, fill, protected, starts)
    α = form === nothing ? nothing :
        _exponent(something(heterogeneity, _unit_exponent(form)), N, form)
    form === nothing || N !== nothing || form isa _TruncateForm && fill === nothing ||
        throw(
        ArgumentError(
            fill === nothing ?
                "a $(nameof(typeof(form)))() draw reads the population, so give N" :
                "a draw into a pool fills it up to N, so give N"
        )
    )
    fs = (
        _removals(removals, protected)...,
        _tuple_map(f -> _placed(f, names), _pool_flows(flows))...,
    )
    _check_each_nonnegative(:pools, values(starts))
    form === nothing && any(!isnothing, values(starts)) && throw(
        ArgumentError(
            "a Depletion without a draw holds its pools in the step's values, " *
                "so the history gives their start, not pools"
        )
    )
    fill === nothing || _check_fill(form, N)
    return Depletion(
        N, form, α, map(_initial_param, starts), ws, fs, draw,
        flows_first ? _FlowsFirst() : _FlowsAfter(), _overflow(overflow)
    )
end

# The pools by name with their starting values: one pool by default, two
# for a protected one.
_pool_starts(::Nothing, ::Nothing) = (S = nothing,)
_pool_starts(::Nothing, σ) = (S = nothing, V = nothing)
_pool_starts(pools, σ) = _named_pools(pools, σ)
function _named_pools(pools::NamedTuple, σ)
    isempty(pools) && _bad_pools(pools)
    σ === nothing || length(pools) >= 2 || throw(
        ArgumentError("a protected Depletion holds two pools, got $(keys(pools))")
    )
    return pools
end
function _named_pools(pools::Tuple{Vararg{Symbol}}, σ)
    allunique(pools) || _bad_pools(pools)
    return _named_pools(NamedTuple{pools}(map(_ -> nothing, pools)), σ)
end
_named_pools(pools, σ) = _bad_pools(pools)
@noinline function _bad_pools(pools)
    throw(
        ArgumentError(
            "pools is a named tuple of starting values, such as (S = N, V = 0.0), " *
                "or a tuple of distinct names, got " * _describe(pools)
        )
    )
end

# Without a draw, nothing shapes one.
function _check_no_draw(w, fill, α, σ, flows_first, overflow)
    w === nothing && fill === nothing && α === nothing && σ === nothing &&
        !flows_first && overflow === nothing && return nothing
    throw(
        ArgumentError(
            "weights, fill, heterogeneity, protected, flows_first and overflow " *
                "shape a draw, and form = nothing has none"
        )
    )
end

# Each pool's weight in the draw, by name, and how the form draws: from the
# weighted pools, first from the first pool the weights name, or into the
# pool `fill` names. Without a draw, or with one that fills a pool, there
# are no weights.
_draw_spec(::Nothing, w, fill, σ, starts) = nothing, nothing
_draw_spec(form, w, fill, σ, starts) = _drawn_spec(w, fill, σ, starts)
function _drawn_spec(w, ::Nothing, σ, starts)
    drawn = _drawn_weights(w, σ, starts)
    ws = _aligned_weights(drawn, starts)
    return ws, _DrawFrom(_drawn_place(first(keys(drawn)), keys(starts)))
end
function _drawn_spec(w, fill, σ, starts)
    w === nothing && σ === nothing || throw(
        ArgumentError("a draw fills a pool or takes from weighted pools, not both")
    )
    return nothing, _DrawInto(_drawn_place(fill, keys(starts)))
end

# The weights the draw names: the first pool's alone at `1` by default, and
# for a protected `Depletion` one for its first pool and `σ` for its second.
# The names are read from the type of the pools, so the weights' names are
# known where a `Depletion` is built.
function _drawn_weights(::Nothing, ::Nothing, ::NamedTuple{K}) where {K}
    return NamedTuple{(K[1],)}((1,))
end
_drawn_weights(w, ::Nothing, starts) = w
function _drawn_weights(::Nothing, σ, ::NamedTuple{K}) where {K}
    return NamedTuple{(K[1], K[2])}((1, σ))
end
function _drawn_weights(w, σ, starts)
    throw(ArgumentError("protected sets the weights, so give one of them"))
end

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

# The removals: a count out of the first pool, into the second for a
# protected `Depletion`.
_removals(::Nothing, σ) = ()
function _removals(r, σ)
    return (Flow(1, σ === nothing ? 0 : 2, _check_param(:removals, r), Truncate()),)
end

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

# Where the value the draw leaves goes.
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

# The `flows` keyword as a tuple of `Flow`s, possibly empty.
_pool_flows(fs::Union{Tuple, AbstractVector}) =
    isempty(fs) ? () : _flow_tuple(Tuple(fs))
_pool_flows(f::Flow) = (f,)
_pool_flows(::Nothing) = ()
function _pool_flows(fs)
    throw(
        ArgumentError(
            "flows is a Flow, or a tuple or vector of Flows, got " *
                _describe(fs)
        )
    )
end

# A `Depletion` with one pool drawn from before its flows `R`, and nothing
# left over: a pointwise step.
const _OnePool{R <: Tuple} = Depletion{
    <:Any, <:Any, <:Any, <:NamedTuple{<:Any, <:Tuple{Any}}, <:Any, R, _DrawFrom,
    _FlowsAfter, _Drop,
}

# The population a form reads, one where the `Depletion` has none.
_pop(N, k, t) = param(N, k, t)
_pop(::Nothing, k, t) = true
_add_pop!(N̄, N, x, k, t) = add_param!(N̄, N, x, k, t)
_add_pop!(N̄, ::Nothing, x, k, t) = nothing

_draws(m::Depletion) = m.form !== nothing
_npools(m::Depletion) = length(m.pools)
_flows_first(m::Depletion) = m.order isa _FlowsFirst

# The values and state entries of each group: with a draw, one value (two
# with the overflow in a stratum) and one entry per pool (and the queue);
# without, the pools are both. One pool drawn from before its flows, with
# nothing left over, is a pointwise step.
blocks(m::_OnePool) = nothing
function blocks(m::Depletion)
    n = _npools(m)
    _draws(m) || return Val((n, n))
    return Val((1 + (m.overflow isa _ToStratum), n + (m.overflow isa _Queue)))
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
    _check_each_strata(:weight, _by_position(m.weights), G)
    _check_flow_groups(m.flows, G)
    return nothing
end

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

# Pool `i`'s value before the first step at group `k`, and its cotangent:
# by default `N` at time 1 for the pool a draw takes from first, else zero.
_initial(x, m, i, k) = param(x, k, 1)
function _initial(::Nothing, m, i, k)
    N = m.N === nothing ? false : param(m.N, k, 1)
    return ifelse(_starts_full(m.draw, i), N, zero(N))
end
_starts_full(d::_DrawFrom, i) = i == d.first
_starts_full(d, i) = false
function _add_initial!(m̄, x, x̄s, m, i, x̄, k)
    return add_param!(x̄s, x, x̄, k, 1)
end
function _add_initial!(m̄, ::Nothing, x̄s, m, i, x̄, k)
    _starts_full(m.draw, i) || return nothing
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
_nentries(m::Depletion) = _npools(m) + (m.overflow isa _Queue)

function forward!(m::Depletion, ::Init, s, history)
    G = length(s) ÷ _nentries(m)
    _check_modifier_strata(m, _nvalues(blocks(m)) * G)
    if _draws(m)
        _each!(_initial_body!, Serial(), s, G, length(s), s, m, G)
    else
        fill!(s, zero(eltype(s)))
    end
    return nothing
end

function _initial_body!(k, s, m, G)
    x = _initials(m, k)
    _scatter!(s, _with_queue(m.overflow, x, false), G, k)
    return nothing
end

function pullback!(grads, m::Depletion, ::Init, s, history)
    _draws(m) || return nothing
    G = length(s) ÷ _nentries(m)
    s̄ = grads.s
    for k in 1:G
        _add_initials!(grads.piece, m, s̄, G, k)
    end
    return nothing
end

# One pool and no flows: the form's step.
const _Depleting = _OnePool{Tuple{}}

_kernel(::_Depleting) = true
function _step(m::_Depleting, v::Number, s::Number, t, k)
    return _draw(
        m.form, v, s, _pop(m.N, k, t), _exponent_value(m.heterogeneity)
    )
end

function _step_back(grads, m::_Depleting, v::Number, s::Number, t, k)
    m̄ = grads.piece
    v̄, s̄, N̄, ᾱ = _form_pullback(
        (; piece = cotangent(m̄, :form), v = grads.v, s = grads.s), m.form,
        v, s, _pop(m.N, k, t), _exponent_value(m.heterogeneity)
    )
    _add_pop!(cotangent(m̄, :N), m.N, N̄, k, t)
    add_cotangent!(cotangent(m̄, :heterogeneity), ᾱ)
    return v̄, s̄
end

# One pool with flows: the draw, then the flows on the pool.
const _Flowing = _OnePool{<:Tuple{Flow, Vararg{Flow}}}

_kernel(::_Flowing) = true
function _step(m::_Flowing, v::Number, s::Number, t, k)
    y, s′ = _draw(
        m.form, v, s, _pop(m.N, k, t), _exponent_value(m.heterogeneity)
    )
    (s″,) = _flow_only(m.flows, (s′,), k, t)
    return y, s″
end

function _step_back(grads, m::_Flowing, v::Number, s::Number, t, k)
    m̄ = grads.piece
    N, α = _pop(m.N, k, t), _exponent_value(m.heterogeneity)
    _, s′ = _draw(m.form, v, s, N, α)
    s̄′ = only(
        _flows_pullback(
            m.flows, cotangent(m̄, :flows), (s′,), (grads.s,),
            (zero(grads.s),), k, t
        )
    )
    v̄, s̄, N̄, ᾱ = _form_pullback(
        (; piece = cotangent(m̄, :form), v = grads.v, s = s̄′),
        m.form, v, s, N, α
    )
    _add_pop!(cotangent(m̄, :N), m.N, N̄, k, t)
    add_cotangent!(cotangent(m̄, :heterogeneity), ᾱ)
    return v̄, s̄
end
for P in (:_Depleting, :_Flowing)
    @eval pullback!(grads, m::$P, ::Step, v, s, t) = _strata_pullback!(grads, m, v, s, t)
end

# A group's step without a draw: the flows on its values. The step, its
# pullback and their helpers are inlined, as their calls are (see
# `_vector_step!`): the call-site inline reaches only the first method, and
# across the inner calls the rule's reverse pass took about 45% longer per
# group.
_block_step(m::Depletion, v::Tuple, s::Tuple, t, g) = _group_step(m.draw, m, v, s, t, g)
@inline _group_step(::Nothing, m, v, s, t, g) = _flow_group(m.flows, v, g, t)

# With a draw: the demand is the group's value (and its queue); the flows
# act on the pools before or after the draw, and what the draw leaves of
# the demand goes to the queue, the group's second value or nowhere.
@inline function _group_step(draw, m, v, s, t, g)
    q = m.overflow
    x, Q = _pools_queue(q, s, Val(_npools(m)))
    d = first(v) + Q
    x1 = _flows_first(m) ? _flow_only(m.flows, x, g, t) : x
    y, x2 = _take(draw, m, d, x1, t, g)
    x3 = _flows_first(m) ? x2 : _flow_only(m.flows, x2, g, t)
    out = _out_values(q, v, d - y, y)
    return out, _with_queue(q, x3, d - y)
end

# The pools and the queue in a group's state, zero without a queue.
_pools_queue(q, s, ::Val{n}) where {n} = s, false
_pools_queue(::_Queue, s, ::Val{n}) where {n} = ntuple(i -> s[i], Val(n)), s[n + 1]
_with_queue(q, x, u) = x
_with_queue(::_Queue, x, u) = (x..., u)
_out_values(q, v, u, y) = (y,)
_out_values(::_ToStratum, v, u, y) = (y, v[2] + u)

# The weights at group `g` and time `t`, promoted to one type so a step
# indexes them without a union, and the weighted pools `Σ w_i x_i`, summed
# in order. A fixed weight of one promotes to an exact one.
function _weights_at(m, ::Val{n}, g, t) where {n}
    return promote(ntuple(i -> param(m.weights[i], g, t), Val(n))...)
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
@inline _take(::_DrawFrom, m, d, x, t, g) = _draw_pools(m, d, x, t, g)
@inline function _take(draw::_DrawInto, m, d, x::NTuple{n}, t, g) where {n}
    f = draw.pool
    N = _pop(m.N, g, t)
    y, _ = _draw(m.form, d, N - x[f], N, _exponent_value(m.heterogeneity))
    return y, ntuple(i -> i == f ? x[i] + y : x[i], Val(n))
end

# One pool: it loses the draw.
@inline function _draw_pools(m, v, x::Tuple{Any}, t, g)
    w = param(only(m.weights), g, t)
    y, _ = _draw(
        m.form, v, w * only(x), _pop(m.N, g, t),
        _exponent_value(m.heterogeneity)
    )
    return y, (only(x) - y,)
end

# Several pools: each loses the draw in proportion to its weighted pool.
@inline function _draw_pools(m, v, x::NTuple{n}, t, g) where {n}
    w = _weights_at(m, Val(n), g, t)
    P = _weighted(w, x)
    y, _ = _draw(
        m.form, v, P, _pop(m.N, g, t), _exponent_value(m.heterogeneity)
    )
    # `ifelse`, not `if`, so a traced `P` needs no branch; the guarded
    # division keeps the unused arm finite. The arm follows the primal `P`,
    # so a dual `P` with value zero takes the arm without the division.
    on = _primal_value(P) > 0
    q = y / ifelse(on, P, one(P))
    d = m.draw.first
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
    return _group_pullback(m.draw, grads, m, v, s, t, g)
end
@inline function _group_pullback(::Nothing, grads, m, v, s, t, g)
    x̄ = _flows_pullback(
        m.flows, cotangent(grads.piece, :flows), v, grads.v, grads.s, g, t
    )
    return x̄, map(_ -> zero(eltype(x̄)), x̄)
end

# `v` and `s` are the group's incoming values and state; returns their
# cotangents from those of the values and state after the step.
@inline function _group_pullback(draw, grads, m, v, s, t, g)
    f̄s = cotangent(grads.piece, :flows)
    q = m.overflow
    n = _npools(m)
    x, Q = _pools_queue(q, s, Val(n))
    d = first(v) + Q
    first_ = _flows_first(m)
    x1 = first_ ? _flow_only(m.flows, x, g, t) : x
    # The draw again, only where its pullback reads it: the pools after it
    # for flows that follow it, the value for a draw from several pools.
    retake = !first_ || (draw isa _DrawFrom && n > 1)
    y, x2 = _retake(Val(retake), draw, m, d, x1, t, g)
    # The cotangent of what the draw leaves, `d - y`, and of the pools
    # after the step.
    ū, x̄3 = _left_back(q, grads.v, grads.s, Val(n))
    z = ntuple(_ -> zero(ū), Val(n))
    x̄2 = first_ ? x̄3 : _flows_pullback(m.flows, f̄s, x2, x̄3, z, g, t)
    ȳ = first(grads.v) - ū
    d̄, x̄1 = _take_back(draw, grads.piece, m, d, x1, y, ȳ, x̄2, t, g)
    x̄ = first_ ? _flows_pullback(m.flows, f̄s, x, x̄1, z, g, t) : x̄1
    d̄ += ū
    return _in_values(q, d̄, ū), _with_queue(q, x̄, d̄)
end

# Without the draw, the pools before it stand in for those after it, which
# the pullback does not read then, so both arms have the pools' type.
_retake(::Val{true}, draw, m, d, x, t, g) = _take(draw, m, d, x, t, g)
_retake(::Val{false}, draw, m, d, x, t, g) = nothing, x

# The cotangent of the overflow and of the pools after the step, from the
# cotangents of the group's values and state.
_left_back(q, v̄, s̄, ::Val{n}) where {n} = zero(first(v̄)), s̄
_left_back(::_ToStratum, v̄, s̄, ::Val{n}) where {n} = v̄[2], s̄
function _left_back(::_Queue, v̄, s̄, ::Val{n}) where {n}
    return s̄[n + 1], ntuple(i -> s̄[i], Val(n))
end
_in_values(q, d̄, ū) = (d̄,)
_in_values(::_ToStratum, d̄, ū) = (d̄, ū)

# The draw's pullback: the cotangents of the demand and of the pools
# before the draw, from those of the value drawn `y`, `ȳ`, and of the
# pools after it, `x̄′`; the parameters' are added into the mirror `m̄`.
@inline function _take_back(
        draw::_DrawInto, m̄, m, d, x::NTuple{n}, y, ȳ, x̄′, t, g
    ) where {n}
    f = draw.pool
    N, α = _pop(m.N, g, t), _exponent_value(m.heterogeneity)
    d̄, P̄, N̄, ᾱ = _form_pullback(
        (; piece = cotangent(m̄, :form), v = ȳ + x̄′[f], s = zero(ȳ)), m.form,
        d, N - x[f], N, α
    )
    _add_pop!(cotangent(m̄, :N), m.N, N̄ + P̄, g, t)
    add_cotangent!(cotangent(m̄, :heterogeneity), ᾱ)
    return d̄, ntuple(i -> i == f ? x̄′[i] - P̄ : x̄′[i], Val(n))
end
@inline function _take_back(::_DrawFrom, m̄, m, v, x::Tuple{Any}, y, ȳ, x̄′, t, g)
    w = param(only(m.weights), g, t)
    N, α = _pop(m.N, g, t), _exponent_value(m.heterogeneity)
    v̄, P̄, N̄, ᾱ = _form_pullback(
        (; piece = cotangent(m̄, :form), v = ȳ - only(x̄′), s = zero(ȳ)), m.form,
        v, w * only(x), N, α
    )
    _add_pop!(cotangent(m̄, :N), m.N, N̄, g, t)
    add_cotangent!(cotangent(m̄, :heterogeneity), ᾱ)
    _add_weights!(cotangent(m̄, :weights), m.weights, (only(x) * P̄,), g, t)
    return v̄, (only(x̄′) + w * P̄,)
end
@inline function _take_back(
        draw::_DrawFrom, m̄, m, vk, x::NTuple{n}, y, ȳ, x̄′, t, g
    ) where {n}
    α = _exponent_value(m.heterogeneity)
    N = _pop(m.N, g, t)
    w = _weights_at(m, Val(n), g, t)
    P = _weighted(w, x)
    on = _primal_value(P) > 0
    q = on ? y / P : zero(y)
    d = draw.first
    z = zero(ȳ)
    # The shares' pullback, from a function so that no name the closures
    # below capture is assigned twice, which would box it.
    x̄, w̄, ȳd, P̄d = _shares_back(on, x̄′, w, x, q, P, ȳ, d, z, Val(n))
    v̄k, P̄f, N̄, ᾱ = _form_pullback(
        (; piece = cotangent(m̄, :form), v = ȳd, s = zero(ȳ)), m.form,
        vk, P, N, α
    )
    P̄ = P̄d + P̄f
    _add_pop!(cotangent(m̄, :N), m.N, N̄, g, t)
    add_cotangent!(cotangent(m̄, :heterogeneity), ᾱ)
    _add_weights!(
        cotangent(m̄, :weights), m.weights, ntuple(i -> w̄[i] + x[i] * P̄, Val(n)),
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

# A `Depletion` uses its own pullback when its form has one or the form's
# local derivative covers it (see `_form_pullback`).
uses_adjoint(m::Depletion, ::Step) = _form_adjoint(m.form)

# Trace ---------------------------------------------------------------------

# A pool's trace: with a draw, its pools after the step, the value drawn
# and what the draw leaves of the demand, per stratum for one pool and per
# group otherwise; without one, the amount each flow moves, per group.
function ntrace(m::Depletion, S)
    _draws(m) || return length(m.flows) * (S ÷ _npools(m))
    B = blocks(m)
    B === nothing && return 3S
    return (_npools(m) + 2) * _ngroups(B, S)
end

function forward(m::_OnePool, ::Trace, v::Number, s::Number, v′, s′, t, k)
    return s′, v′, v - v′
end
function pullback!(grads, m::_OnePool, ::Trace, v::Number, s::Number, t, k)
    p̄, ȳ, ū = grads.trace
    return ū, zero(ū), ȳ - ū, p̄
end

function forward(m::Depletion, ::Trace, v::Tuple, s::Tuple, v′::Tuple, s′::Tuple, t, g)
    return _pool_trace(m.draw, m, v, s, v′, s′, t, g)
end
_pool_trace(::Nothing, m, v, s, v′, s′, t, g) = _amounts(m.flows, v, g, t)
function _pool_trace(draw, m, v, s, v′, s′, t, g)
    n = Val(_npools(m))
    x, _ = _pools_queue(m.overflow, s′, n)
    _, Q = _pools_queue(m.overflow, s, n)
    y = first(v′)
    return (x..., y, first(v) + Q - y)
end

function pullback!(grads, m::Depletion, ::Trace, v::Tuple, s::Tuple, t, g)
    return _pool_trace_back(m.draw, grads, m, v, s, t, g)
end
_pool_trace_back(::Nothing, grads, m, v, s, t, g) = _amounts_back(grads, m, v, s, t, g)
function _pool_trace_back(draw, grads, m, v, s, t, g)
    n = _npools(m)
    r̄ = grads.trace
    ȳ, ū = r̄[n + 1], r̄[n + 2]
    z = zero(ū)
    x̄ = ntuple(i -> r̄[i], Val(n))
    zx = ntuple(_ -> z, Val(n))
    v̄ = ntuple(i -> i == 1 ? ū : z, Val(length(v)))
    v̄′ = ntuple(i -> i == 1 ? ȳ - ū : z, Val(length(v)))
    q = m.overflow
    return v̄, _with_queue(q, zx, ū), v̄′, _with_queue(q, x̄, z)
end

# The flows' amounts back to the pools before them, and to each flow's
# demand and softness.
function _amounts_back(grads, m, x, s, t, g)
    x̄ = _amounts_pullback(m.flows, cotangent(grads.piece, :flows), grads.trace, x, g, t)
    z = zero(eltype(x̄))
    zs = map(_ -> z, s)
    return x̄, zs, map(_ -> z, x), zs
end
