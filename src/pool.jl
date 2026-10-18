# A `Pool` holds pools for each group of strata: the step's value is drawn
# from them by a depletion form, then flows move between them. Without a
# draw the pools are the step's values, carried by the recurrence, and the
# flows move them.
#
# The layout `L` is a named tuple in the type: the number of pools `n`,
# whether it draws (`draw`) and the pool the draw takes from when
# the weighted pools are empty (`first`). Each layout has methods of its
# own: one pool is a pointwise step, more are blockwise.

@doc raw"""
A modifier of pools and flows: each group of strata holds pools, the step's
value is drawn from them by a depletion form, and
[`ComposableRecurrences.Flow`](@ref)s move between them.

With a draw, each group has ``n`` pools ``x_1, \dots, x_n`` in the state
and its value ``v`` is the demand.
At absolute time ``t``, with population ``N_t`` and heterogeneity
``\alpha``, the form ``F`` draws from the weighted pools ``P``, and each
pool loses the draw in proportion to its weight:

```math
\begin{aligned}
P &= \sum_i w_i x_i, \qquad (v', \cdot) = F(v, P, N_t, \alpha), \\
x^{*}_i &= x_i - v' \frac{w_i x_i}{P}, \qquad x' = \Phi_t(x^{*}),
\end{aligned}
```

where ``w_i`` is pool ``i``'s weight in the draw (zero for a pool the
draw does not name), ``v'`` the value passed on and ``\Phi_t`` the flows.
When ``P \le 0`` the draw comes from the first pool the draw names alone.
A draw into pool ``f`` (`draw = form => pool`) fills it instead, up to
``N_t``: ``(v', \cdot) = F(v, N_t - x_f, N_t, \alpha)`` and
``x^{*}_f = x_f + v'``, as admissions fill beds.
Its form is `Truncate()` or `SoftTruncate(κ)`, and its capacity ``N_t`` is
not negative.
The flows act on the pools after the draw, or before it with
`flows_first = true`, as when patients leave before the day's admissions
or an allowance is granted at the start of a period.
They act in the order [`ComposableRecurrences.Flow`](@ref) sets out, and a
count flow from `0` brings its demand in from outside the `Pool`.
What the draw leaves of the demand, ``u = v - v'``, goes nowhere by
default; with `overflow = :stratum` to the group's second value,
``v'_2 = v_2 + u``, and with `overflow = :queue` to a queue held after the
pools in the state, whose content joins the next step's demand.

The form is a variant struct with `forward(form, Step(), v, s, N, α)`:
[`ComposableRecurrences.Hazard`](@ref),
[`ComposableRecurrences.Floor`](@ref),
[`ComposableRecurrences.Truncate`](@ref),
[`ComposableRecurrences.SoftTruncate`](@ref), or a new type with that
method ([A depletion form](@ref extending-form)).
`α > 1` depletes faster as the pool shrinks (heterogeneous mixing).
The draw's `Hazard()` takes its hazard from the value over the population,
``v / N_t``; a `Hazard()` flow's demand is read as
[`ComposableRecurrences.Flow`](@ref) sets out.
A `Pool` with one pool, drawn from, flows after the draw and no overflow is
a pointwise step whose state is the pool, as
[`ComposableRecurrences.Depletion`](@ref).
Any other is blockwise ([`ComposableRecurrences.blocks`](@ref)): each group
has one value, or two with `overflow = :stratum`, value ``(j - 1) G + g``
being value ``j`` of group ``g`` for ``G`` groups, and the state holds
pool 1 of every group, then pool 2, and so on, then the queue.
A `Pool` covers every stratum, so a stratum without a cap takes an
infinite `N`.
With `overflow = :stratum` group ``g`` overflows into stratum ``G + g``, so
another pairing permutes the strata.
For groups that share one overflow stratum, a
[`ComposableRecurrences.Redistribute`](@ref) after the `Pool`, with
``\varepsilon = 1`` on the other overflow strata and `K` sending each to the
shared one, moves their values into it.

Without a draw (`draw = nothing`) the pools are the step's values: the
values hold ``n`` pools of ``G`` groups each, pool by pool
(`blocks` is `Val((n, n))`), so value ``(i - 1) G + g`` is pool ``i`` of
group ``g``.
On a [`Recurrence`](@ref) with kernel `[1.0]` the core carries the
previous step's pools forward, and the `Pool` applies the step's flows,
``v' = \Phi_t(v)``.
The state then holds what flowed into each pool at the step, where a
negative count adds nothing.

| model | pools | draw | flows |
|:----- |:------ |:---- |:----- |
| beds that a share ``\delta`` leaves each step | `(:O,)` | `Truncate() => :O`, with `N` the beds | `Flow(:O => 0, δ; form = Share())`, with `flows_first = true` |
| an allowance granted ``b_t`` at each period start | `(:B,)` | `:B => Truncate()` | `Flow(0 => :B, TimeVarying(b); form = Truncate())`, with `flows_first = true` |
| the same without carry over | `(:B,)` | `:B => Truncate()` | `Flow(:B => 0, starts; form = Share())` before the grant, with `flows_first = true` |

Here `starts` is a `TimeVarying` share of one at each period start and
zero otherwise, and a lifetime allowance is an `initial` pool alone.
The [renewal then delay](@ref tutorial-renewal-delay) tutorial builds
leaky, all-or-nothing and waning protection with a second pool; a delay
from dose to protection is a [`Convolution`](@ref) of the doses before the
call.
A share ``\delta`` leaving the beds is a geometric length of stay, with
survival ``(1 - \delta)^k`` after ``k`` steps; for another stay, convolve the
admissions with its survival, as a [`ComposableRecurrences.Primary`](@ref)
indexed [`TimeVarying`](@ref) kernel for cohorts, and bound the sum with
[`ComposableRecurrences.Clamp`](@ref) or a `Pool` whose draw fills a pool.
A `Pool` holds the fields `N`, `form`, `heterogeneity`, `initial`, `weights`
(each pool's weight in the draw, fixed at zero for a pool it does not
name) and `flows`, with each flow's pools as positions.

# Arguments
- `N`: the population the form reads, or the capacity a draw fills up to,
  a [parameter](@ref ComposableRecurrences.param) read at each step's group
  and time; `nothing` for a `Pool` without a draw, or whose truncated draw
  from its pools does not read it.

# Keyword Arguments
- `pools`: the pool names, a tuple of symbols, or the number of pools;
  `(:S,)` by default.
  A flow names a pool by its name or position.
- `initial`: each pool's value before the first step, one value or
  [`PerStratum`](@ref) each, or `nothing` for the default: `N` at time 1
  for the first pool a draw takes from when `N` is given, and zero
  otherwise.
  One value stands for a `Pool` with one pool.
  A `Pool` without a draw takes its pools from the history instead.
- `draw`: `pool => form` to draw from one pool,
  `(pool => w, ...) => form` to draw from weighted pools, `form => pool` to
  fill a pool, or `nothing` for no draw; `first(pools) => Hazard()` by
  default.
  A weight is one value or `PerStratum`, constant over time; a weight of
  `1` is fixed, not a parameter.
- `heterogeneity`: the exponent `α`; `true` by default for the built-in
  forms, an exponent of exactly one that is not a parameter, and `1` for
  other forms.
  For the built-in forms `true` and `false` stay fixed; any other integer
  takes the population's float type.
  Pass a float to differentiate the exponent.
- `flows`: a [`ComposableRecurrences.Flow`](@ref), or a tuple or vector of
  them; none by default.
- `flows_first`: whether the flows act before the draw; `false` by
  default.
- `overflow`: where what the draw leaves goes: `nothing` (the default),
  `:stratum` or `:queue`.

# Examples

Leaky vaccination: 5 doses a step move susceptibles into a pool drawn at
a third of the rate, and the protection wanes back at rate 0.1.

```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
leaky = CR.Pool(
    1000.0; pools = (:S, :V), draw = (:S => 1, :V => 0.3) => CR.Hazard(),
    flows = (CR.Flow(:S => :V, 5.0; form = CR.Truncate()), CR.Flow(:V => :S, 0.1))
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
beds = CR.Pool(
    10.0; pools = (:O,), draw = CR.Truncate() => :O, flows_first = true,
    flows = CR.Flow(:O => 0, 0.1; form = CR.Share()), overflow = :stratum
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
doses = CR.Pool(;
    pools = (:B,), draw = :B => CR.Truncate(), flows_first = true,
    flows = CR.Flow(0 => :B, grants; form = CR.Truncate()), overflow = :stratum
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
ward = CR.Pool(;
    pools = (:suspected, :confirmed), draw = nothing,
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
struct Pool{L, P, F, A, I, W, R}
    "The population the form reads, a parameter, or `nothing`."
    N::P
    "The draw form, or `nothing` without a draw."
    form::F
    "The heterogeneity exponent α, or `nothing` without a draw."
    heterogeneity::A
    "Each pool's starting value, `nothing` for its default."
    initial::I
    "Each pool's weight in the draw, or `nothing` without a draw."
    weights::W
    "The flows between the pools, by position."
    flows::R
    function Pool{L}(
            N::P, form::F, heterogeneity::A, initial::I, weights::W, flows::R
        ) where {L, P, F, A, I, W, R}
        _check_layout(Val(L))
        form === nothing || _check_form(form)
        _check_pools(flows, L.n)
        return new{L, P, F, A, I, W, R}(N, form, heterogeneity, initial, weights, flows)
    end
end
ConstructionBase.constructorof(::Type{<:Pool{L}}) where {L} = Pool{L}

const _LAYOUT_KEYS = (:n, :draw, :first, :fill, :flows_first, :overflow)

# That the flows name no pool beyond the `n` there are; the message is
# built only when one does.
_check_pools(::Tuple{}, n) = nothing
function _check_pools(fs::Tuple, n)
    f = first(fs)
    max(f.from, f.to) <= n || _too_many_pools(f, n)
    return _check_pools(Base.tail(fs), n)
end
@noinline function _too_many_pools(f, n)
    throw(
        ArgumentError(
            "the flows name pool $(max(f.from, f.to)), but there " *
                (n == 1 ? "is 1 pool" : "are $n pools")
        )
    )
end

# Whether `L` is a pool layout, decided from the type alone, so a `Pool`
# built inside a differentiated function runs no check.
@generated function _check_layout(::Val{L}) where {L}
    ok = L isa NamedTuple{_LAYOUT_KEYS, Tuple{Int, Bool, Int, Bool, Bool, Symbol}} &&
        L.n >= 1 && 0 <= L.first <= L.n && (L.first >= 1) == L.draw &&
        (L.draw || !(L.fill || L.flows_first)) &&
        L.overflow in (:none, :queue, :stratum) &&
        (L.draw || L.overflow === :none)
    ok && return :(nothing)
    msg = "not a Pool layout: $(repr(L))"
    return :(throw(ArgumentError($msg)))
end

# Inlined, so that the pool names are constants where it is called and the
# lookups on them fold, and so that a differentiated function that builds a
# pool holds no call returning it.
@inline function Pool(
        N = nothing; pools = (:S,), initial = nothing,
        draw = _first_pool(pools) => Hazard(), heterogeneity = nothing,
        flows = (), flows_first::Bool = false, overflow = nothing
    )
    names = _pool_names(pools)
    n = length(names)
    N = N === nothing ? nothing : _population(N)
    form, weights, first, fill = _draw_spec(draw, names)
    α = form === nothing ? _no_heterogeneity(heterogeneity) :
        _exponent(something(heterogeneity, _unit_exponent(form)), N, form)
    form === nothing || N !== nothing || form isa _TruncateForm && !fill ||
        throw(
        ArgumentError(
            fill ? "a draw into a pool fills it up to N, so give N" :
                "a $(nameof(typeof(form)))() draw reads the population, so give N"
        )
    )
    form === nothing && (flows_first || overflow !== nothing) && throw(
        ArgumentError(
            "flows_first and overflow order and route a draw, and the Pool has none"
        )
    )
    fs = map(f -> _placed(f, names), _pool_flows(flows))
    L = (;
        n, draw = form !== nothing, first, fill, flows_first,
        overflow = _overflow(overflow),
    )
    _check_each_nonnegative(:initial, initial)
    fill && _check_fill(form, N)
    return Pool{L}(N, form, α, _initials(initial, n, form), weights, fs)
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
_check_each_nonnegative(name, x) = _check_nonnegative(name, x)
_check_each_nonnegative(name, xs::Tuple) = foreach(x -> _check_nonnegative(name, x), xs)

# Where the value the draw leaves goes.
_overflow(::Nothing) = :none
_overflow(x::Symbol) = x in (:queue, :stratum) ? x : _bad_overflow(x)
_overflow(x) = _bad_overflow(x)
@noinline function _bad_overflow(x)
    throw(
        ArgumentError(
            "overflow is nothing, :queue or :stratum, got " * _describe(x)
        )
    )
end

# The pool names, or positions for a number of pools.
_pool_names(n::Integer) = n >= 1 ? ntuple(identity, Int(n)) : _bad_pools(n)
function _pool_names(names::Union{Tuple, AbstractVector})
    isempty(names) && _bad_pools(names)
    all(x -> x isa Symbol, names) && _distinct(Tuple(names)) || _bad_pools(names)
    return Tuple(names)
end
_pool_names(names) = _bad_pools(names)
@noinline function _bad_pools(names)
    throw(
        ArgumentError(
            "pools is a tuple of distinct names or a number of pools, got " *
                _describe(names)
        )
    )
end

# Lookups on the pool names, which are constants where a `Pool` is built,
# so that they fold when it is compiled: a `Pool` built inside a
# differentiated function then runs none of them.
Base.@assume_effects :foldable _distinct(xs::Tuple) = allunique(xs)
Base.@assume_effects :foldable function _index_of(i, places::Tuple)
    j = findfirst(==(i), places)
    return j === nothing ? 0 : j
end
Base.@assume_effects :foldable function _position(x::Int, names::Tuple)
    return 1 <= x <= length(names) ? x : 0
end
Base.@assume_effects :foldable function _position(x::Symbol, names::Tuple)
    i = findfirst(==(x), names)
    return i === nothing ? 0 : i
end

_first_pool(pools) = first(_pool_names(pools))

# The draw as its form, each pool's weight, the first pool it names and
# whether it fills that pool.
_draw_spec(::Nothing, names) = (nothing, nothing, 0, false)
function _draw_spec(draw::Pair{<:Any, <:Union{Symbol, Integer}}, names)
    draw.first isa Union{Symbol, Integer, Tuple, AbstractVector, Pair} &&
        _bad_draw(draw)
    i = _drawn_place(_end(draw.second), names)
    weights = ntuple(j -> _Fixed{j == i}(), Val(length(names)))
    return draw.first, weights, i, true
end
function _draw_spec(draw::Pair, names)
    spec = draw.first isa Union{Tuple, AbstractVector} ? Tuple(draw.first) :
        (draw.first => true,)
    isempty(spec) && _bad_draw(draw)
    places = map(spec) do x
        x isa Pair || _bad_draw(draw)
        return _drawn_place(_end(x.first), names)
    end
    _distinct(places) || _bad_draw(draw)
    weights = ntuple(Val(length(names))) do i
        j = _index_of(i, places)
        return j == 0 ? _Fixed{false}() : _weight(spec[j].second)
    end
    return draw.second, weights, first(places), false
end
_draw_spec(draw, names) = _bad_draw(draw)
@noinline function _bad_draw(draw)
    throw(
        ArgumentError(
            "draw is pool => form, (pool => weight, ...) => form with " *
                "distinct pools, form => pool, or nothing; got " *
                _describe(draw)
        )
    )
end

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

# A weight of one or zero, as an integer, is fixed; any other is a
# constant parameter.
_weight(w::Bool) = _Fixed{w}()
function _weight(w::Integer)
    isone(w) && return _Fixed{true}()
    iszero(w) && return _Fixed{false}()
    return _float_param(w)
end
_weight(w) = _float_param(_check_constant(:weight, w))

# A fixed weight, held in the type: an AD tool's type analysis can reject a
# `Bool` field when a `Pool` is built inside the differentiated function.
struct _Fixed{B} end
param(::_Fixed{B}, k, t) where {B} = B
add_param!(x̄, ::_Fixed, v, k, t) = nothing

_no_heterogeneity(::Nothing) = nothing
function _no_heterogeneity(α)
    throw(
        ArgumentError(
            "heterogeneity is an exponent of the draw, and the Pool has none"
        )
    )
end

# The starting pools: `nothing` for each default, or one value or
# `PerStratum` each.
_initials(::Nothing, n, form) = ntuple(_ -> nothing, n)
_initials(x, n, form) = _initials((x,), n, form)
function _initials(xs::Union{Tuple, AbstractVector}, n, form)
    length(xs) == n || throw(
        ArgumentError("initial has one entry per pool, $n, got $(length(xs))")
    )
    form === nothing && any(!isnothing, xs) && throw(
        ArgumentError(
            "a Pool without a draw holds its pools in the step's values, " *
                "so the history gives their start, not initial"
        )
    )
    return map(_initial_param, Tuple(xs))
end
_initial_param(::Nothing) = nothing
_initial_param(x) = _float_param(_check_constant(:initial, x))

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

# A `Pool` with one pool and a draw, as `Depletion` builds it.
const _OnePool = Pool{
    (n = 1, draw = true, first = 1, fill = false, flows_first = false, overflow = :none),
}

@doc raw"""
Susceptible depletion: each stratum's new values are drawn from a pool
that starts at `pool0` and shrinks by what is drawn.

`Depletion(N, form; heterogeneity, pool0, removals)` builds

```julia
Pool(N; initial = pool0, draw = :S => form, heterogeneity,
     flows = Flow(:S => 0, removals; form = Truncate()))
```

so for each stratum ``i`` (see [`PerStratum`](@ref)) and absolute time
``t`` from the call's first time ``t_0``,

```math
s_{t_0 - 1, i} = s_{0,i}, \qquad
(v'_{t,i},\ s^{*}_{t,i}) = F\big(v_{t,i},\ s_{t-1,i},\ N_{t,i},\ \alpha\big),
\qquad s_{t,i} = s^{*}_{t,i} - \min\big(r_{t,i}, \max(s^{*}_{t,i}, 0)\big),
```

where ``v_{t,i}`` is the value entering the modifier, ``v'_{t,i}`` the value
it passes on, ``s_{t,i}`` the pool after step ``t``, ``s_{0,i}`` the starting
pool `pool0` (``N_{1,i}`` by default), ``N_{t,i}`` the population at time
``t``, ``\alpha`` the heterogeneity exponent, ``F`` the form's
`forward(form, Step(), v, s, N, α)` and ``r_{t,i}`` the removals.
A negative removal adds to the pool without a cap.
The state is the pool; the hazard fraction divides by `N` whatever the
pool starts at.
Its fields are a `Pool`'s: the starting pool is `initial[1]`, and its
`weights` hold a fixed weight of one.
[Rules and plain AD](@ref adjoint-routing) gives the gradient of a form
without a `pullback!`.

A population that changes over time, through births, deaths or turnover,
is a `TimeVarying` `N`, with arrivals as negative `removals` and
susceptible departures as positive ones.
The step reads `N` at its own time, and the pool is not rescaled when `N`
changes: arrivals enter the pool only through the removals.

# Arguments
- `N`: the population, a [parameter](@ref ComposableRecurrences.param)
  read at each step's stratum and time.
- `form`: the depletion form; `Hazard()` by default.

# Keyword Arguments
- `heterogeneity`: the exponent `α`, as for `Pool`.
- `pool0`: the starting pool, one value or `PerStratum`; `N` at time 1 by
  default.
  A seed drawn from the pool is `pool0 = max(N - sum(seed), 0)`.
- `removals`: values taken out of the pool at each step after the draw,
  capped by what remains; a parameter, or `nothing` for none.

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
const Depletion = _OnePool

function Depletion(
        N, form = Hazard(); heterogeneity = nothing, pool0 = nothing,
        removals = nothing
    )
    flows = removals === nothing ? () :
        (Flow(1, 0, _check_param(:removals, removals), Truncate()),)
    N = _population(N)
    α = _exponent(something(heterogeneity, _unit_exponent(form)), N, form)
    _check_nonnegative(:pool0, pool0)
    # Built without the names, as the one-pool layout needs no lookup.
    return Depletion(N, form, α, (_initial_param(pool0),), (_Fixed{true}(),), flows)
end

# The population a form reads, one where the `Pool` has none.
_pop(N, k, t) = param(N, k, t)
_pop(::Nothing, k, t) = true
_add_pop!(N̄, N, x, k, t) = add_param!(N̄, N, x, k, t)
_add_pop!(N̄, ::Nothing, x, k, t) = nothing

_layout(::Pool{L}) where {L} = L
_draws(m::Pool) = _layout(m).draw
_npools(m::Pool) = _layout(m).n

# The values and state entries of each group: with a draw, one value (two
# with the overflow in a stratum) and one entry per pool (and the queue);
# without, the pools are both. A `Pool` laid out as `Depletion` is a
# pointwise step.
blocks(m::Pool) = _pool_blocks(Val(_layout(m)))
function _pool_blocks(::Val{L}) where {L}
    L.draw || return Val((L.n, L.n))
    L == _layout_of(_OnePool) && return nothing
    return Val((1 + (L.overflow === :stratum), L.n + (L.overflow === :queue)))
end
_layout_of(::Type{<:Pool{L}}) where {L} = L
ispointwise(m::Pool) = blocks(m) === nothing

# The groups of `S` strata.
_pool_groups(m::Pool, S) = _pool_groups(blocks(m), S)
_pool_groups(::Nothing, S) = S
_pool_groups(b::Val, S) = _ngroups(b, S)

function _check_modifier_strata(m::Pool, S)
    G = _pool_groups(m, S)
    _check_param_strata(:N, m.N, G)
    _check_each_strata(:initial, m.initial, G)
    _check_each_strata(:weight, m.weights, G)
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

# Pool `i`'s value before the first step at group `k`, and its cotangent:
# by default `N` at time 1 for the pool a draw takes from first, else zero.
function _initial(m::Pool, ::Val{i}, k) where {i}
    return _initial(m.initial[i], m, Val(_starts_full(m, i)), k)
end
_starts_full(m, i) = i == _layout(m).first && !_layout(m).fill
_initial(x, m, ::Val, k) = param(x, k, 1)
_initial(::Nothing, m, ::Val{false}, k) = false
_initial(::Nothing, m, ::Val{true}, k) = m.N === nothing ? false : param(m.N, k, 1)
function _add_initial!(m̄, m::Pool, ::Val{i}, x̄, k) where {i}
    return _add_initial!(
        m̄, m.initial[i], m, Val(i), Val(_starts_full(m, i)), x̄, k
    )
end
function _add_initial!(m̄, x, m, ::Val{i}, ::Val, x̄, k) where {i}
    return add_param!(_entry(cotangent(m̄, :initial), Val(i)), x, x̄, k, 1)
end
_add_initial!(m̄, ::Nothing, m, ::Val, ::Val{false}, x̄, k) = nothing
function _add_initial!(m̄, ::Nothing, m, ::Val, ::Val{true}, x̄, k)
    return _add_pop!(cotangent(m̄, :N), m.N, x̄, k, 1)
end
_entry(::Nothing, ::Val) = nothing
_entry(x̄::Tuple, ::Val{i}) where {i} = x̄[i]

# Every pool's value before the first step at group `k`, and their
# cotangents from the state cotangent `s̄` of `G` groups, unrolled over the
# pools so each reads its own entry of `initial` without a closure.
@generated function _initials(m::Pool{L}, k) where {L}
    return Expr(:tuple, (:(_initial(m, $(Val(i)), k)) for i in 1:L.n)...)
end
@generated function _add_initials!(m̄, m::Pool{L}, s̄, G, k) where {L}
    calls = (
        :(_add_initial!(m̄, m, $(Val(i)), s̄[$(i - 1) * G + k], k)) for i in 1:L.n
    )
    return Expr(:block, calls..., :(return nothing))
end

# The values of each group.
_nvalues(::Nothing) = 1
_nvalues(::Val{B}) where {B} = B[1]

# The state entries of each group: the pools, then the queue.
_nentries(m::Pool) = _npools(m) + (_layout(m).overflow === :queue)

function forward(m::Pool, ::Init, s, history)
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
    _scatter!(s, _with_queue(Val(_layout(m).overflow), x, false), G, k)
    return nothing
end

function pullback!(grads, m::Pool, ::Init, s, history)
    _draws(m) || return nothing
    G = length(s) ÷ _nentries(m)
    s̄ = grads.s
    for k in 1:G
        _add_initials!(grads.piece, m, s̄, G, k)
    end
    return nothing
end

# One pool and no flows: the form's step.
const _Depleting = _OnePool{<:Any, <:Any, <:Any, <:Any, <:Any, Tuple{}}

function forward(m::_Depleting, ::Step, v::Number, s::Number, t, k)
    return forward(
        m.form, Step(), v, s, _pop(m.N, k, t), _exponent_value(m.heterogeneity)
    )
end

function pullback!(grads, m::_Depleting, ::Step, v::Number, s::Number, t, k)
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
const _Flowing = _OnePool{
    <:Any, <:Any, <:Any, <:Any, <:Any, <:Tuple{Flow, Vararg{Flow}},
}

function forward(m::_Flowing, ::Step, v::Number, s::Number, t, k)
    y, s′ = forward(
        m.form, Step(), v, s, _pop(m.N, k, t), _exponent_value(m.heterogeneity)
    )
    (s″,) = _flow_only(m.flows, (s′,), k, t)
    return y, s″
end

function pullback!(grads, m::_Flowing, ::Step, v::Number, s::Number, t, k)
    m̄ = grads.piece
    N, α = _pop(m.N, k, t), _exponent_value(m.heterogeneity)
    _, s′ = forward(m.form, Step(), v, s, N, α)
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

# A group's step without a draw: the flows on its values. The step, its
# pullback and their helpers are inlined, as their calls are (see
# `_vector_step!`): the call-site inline reaches only the first method, and
# across the inner calls the rule's reverse pass took about 45% longer per
# group.
function forward(m::Pool, ::Step, v::Tuple, s::Tuple, t, g)
    return _group_step(Val(_layout(m)), m, v, s, t, g)
end
@inline function _group_step(::Val{L}, m, v, s, t, g) where {L}
    return _group_step(Val(L.draw), Val(L), m, v, s, t, g)
end
@inline _group_step(::Val{false}, ::Val, m, v, s, t, g) = _flow_group(m.flows, v, g, t)

# With a draw: the demand is the group's value (and its queue); the flows
# act on the pools before or after the draw, and what the draw leaves of
# the demand goes to the queue, the group's second value or nowhere.
@inline function _group_step(::Val{true}, ::Val{L}, m, v, s, t, g) where {L}
    x, Q = _pools_queue(Val(L.overflow), s, Val(L.n))
    d = first(v) + Q
    x1 = L.flows_first ? _flow_only(m.flows, x, g, t) : x
    y, x2 = _take(Val(L.fill), m, d, x1, t, g)
    x3 = L.flows_first ? x2 : _flow_only(m.flows, x2, g, t)
    out = _out_values(Val(L.overflow), v, d - y, y)
    return out, _with_queue(Val(L.overflow), x3, d - y)
end

# The pools and the queue in a group's state, zero without a queue.
_pools_queue(::Val, s, ::Val{n}) where {n} = s, false
_pools_queue(::Val{:queue}, s, ::Val{n}) where {n} = ntuple(i -> s[i], Val(n)), s[n + 1]
_with_queue(::Val, x, u) = x
_with_queue(::Val{:queue}, x, u) = (x..., u)
_out_values(::Val, v, u, y) = (y,)
_out_values(::Val{:stratum}, v, u, y) = (y, v[2] + u)

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
@inline _take(::Val{false}, m, d, x, t, g) = _draw_pools(m, d, x, t, g)
@inline function _take(::Val{true}, m, d, x::NTuple{n}, t, g) where {n}
    f = _layout(m).first
    N = _pop(m.N, g, t)
    y, _ = forward(m.form, Step(), d, N - x[f], N, _exponent_value(m.heterogeneity))
    return y, ntuple(i -> i == f ? x[i] + y : x[i], Val(n))
end

# One pool: it loses the draw.
@inline function _draw_pools(m, v, x::Tuple{Any}, t, g)
    w = param(only(m.weights), g, t)
    y, _ = forward(
        m.form, Step(), v, w * only(x), _pop(m.N, g, t),
        _exponent_value(m.heterogeneity)
    )
    return y, (only(x) - y,)
end

# Several pools: each loses the draw in proportion to its weighted pool.
@inline function _draw_pools(m, v, x::NTuple{n}, t, g) where {n}
    w = _weights_at(m, Val(n), g, t)
    P = _weighted(w, x)
    y, _ = forward(
        m.form, Step(), v, P, _pop(m.N, g, t), _exponent_value(m.heterogeneity)
    )
    # `ifelse`, not `if`, so a traced `P` needs no branch; the guarded
    # division keeps the unused arm finite. The arm follows the primal `P`,
    # so a dual `P` with value zero takes the arm without the division.
    on = _primal_value(P) > 0
    q = y / ifelse(on, P, one(P))
    d = _layout(m).first
    x′ = ntuple(Val(n)) do i
        return ifelse(on, x[i] - q * w[i] * x[i], ifelse(i == d, x[i] - y, x[i]))
    end
    return y, x′
end

function pullback!(grads, m::Pool, ::Step, v::Tuple, s::Tuple, t, g)
    return _group_pullback(Val(_layout(m)), grads, m, v, s, t, g)
end
@inline function _group_pullback(::Val{L}, grads, m, v, s, t, g) where {L}
    return _group_pullback(Val(L.draw), Val(L), grads, m, v, s, t, g)
end
@inline function _group_pullback(::Val{false}, ::Val{L}, grads, m, v, s, t, g) where {L}
    x̄ = _flows_pullback(
        m.flows, cotangent(grads.piece, :flows), v, grads.v, grads.s, g, t
    )
    return x̄, ntuple(_ -> zero(eltype(x̄)), Val(L.n))
end

# `v` and `s` are the group's incoming values and state; returns their
# cotangents from those of the values and state after the step.
@inline function _group_pullback(::Val{true}, ::Val{L}, grads, m, v, s, t, g) where {L}
    f̄s = cotangent(grads.piece, :flows)
    x, Q = _pools_queue(Val(L.overflow), s, Val(L.n))
    d = first(v) + Q
    x1 = L.flows_first ? _flow_only(m.flows, x, g, t) : x
    # The draw again, only where its pullback reads it: the pools after it
    # for flows that follow it, the value for a draw from several pools.
    retake = !L.flows_first || (!L.fill && L.n > 1)
    y, x2 = _retake(Val(retake), Val(L.fill), m, d, x1, t, g)
    # The cotangent of what the draw leaves, `d - y`, and of the pools
    # after the step.
    ū, x̄3 = _left_back(Val(L.overflow), grads.v, grads.s, Val(L.n))
    z = ntuple(_ -> zero(ū), Val(L.n))
    x̄2 = L.flows_first ? x̄3 : _flows_pullback(m.flows, f̄s, x2, x̄3, z, g, t)
    ȳ = first(grads.v) - ū
    d̄, x̄1 = _take_back(Val(L.fill), grads.piece, m, d, x1, y, ȳ, x̄2, t, g)
    x̄ = L.flows_first ? _flows_pullback(m.flows, f̄s, x, x̄1, z, g, t) : x̄1
    d̄ += ū
    return _in_values(Val(L.overflow), d̄, ū), _with_queue(Val(L.overflow), x̄, d̄)
end

# Without the draw, the pools before it stand in for those after it, which
# the pullback does not read then, so both arms have the pools' type.
_retake(::Val{true}, fill, m, d, x, t, g) = _take(fill, m, d, x, t, g)
_retake(::Val{false}, fill, m, d, x, t, g) = nothing, x

# The cotangent of the overflow and of the pools after the step, from the
# cotangents of the group's values and state.
_left_back(::Val, v̄, s̄, ::Val{n}) where {n} = zero(first(v̄)), s̄
_left_back(::Val{:stratum}, v̄, s̄, ::Val{n}) where {n} = v̄[2], s̄
function _left_back(::Val{:queue}, v̄, s̄, ::Val{n}) where {n}
    return s̄[n + 1], ntuple(i -> s̄[i], Val(n))
end
_in_values(::Val, d̄, ū) = (d̄,)
_in_values(::Val{:stratum}, d̄, ū) = (d̄, ū)

# The draw's pullback: the cotangents of the demand and of the pools
# before the draw, from those of the value drawn `y`, `ȳ`, and of the
# pools after it, `x̄′`; the parameters' are added into the mirror `m̄`.
@inline function _take_back(
        ::Val{true}, m̄, m, d, x::NTuple{n}, y, ȳ, x̄′, t, g
    ) where {n}
    f = _layout(m).first
    N, α = _pop(m.N, g, t), _exponent_value(m.heterogeneity)
    d̄, P̄, N̄, ᾱ = _form_pullback(
        (; piece = cotangent(m̄, :form), v = ȳ + x̄′[f], s = zero(ȳ)), m.form,
        d, N - x[f], N, α
    )
    _add_pop!(cotangent(m̄, :N), m.N, N̄ + P̄, g, t)
    add_cotangent!(cotangent(m̄, :heterogeneity), ᾱ)
    return d̄, ntuple(i -> i == f ? x̄′[i] - P̄ : x̄′[i], Val(n))
end
@inline function _take_back(::Val{false}, m̄, m, v, x::Tuple{Any}, y, ȳ, x̄′, t, g)
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
        ::Val{false}, m̄, m, vk, x::NTuple{n}, y, ȳ, x̄′, t, g
    ) where {n}
    α = _exponent_value(m.heterogeneity)
    N = _pop(m.N, g, t)
    w = _weights_at(m, Val(n), g, t)
    P = _weighted(w, x)
    on = _primal_value(P) > 0
    q = on ? y / P : zero(y)
    d = _layout(m).first
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
_add_weights!(w̄s, ::Tuple{}, vals, g, t) = nothing
function _add_weights!(w̄s, ws::Tuple, vals, g, t)
    add_param!(_head(w̄s), first(ws), first(vals), g, t)
    return _add_weights!(_tail(w̄s), Base.tail(ws), Base.tail(vals), g, t)
end

# A `Pool` uses its own pullback when its form has one or the form's local
# derivative covers it (see `_form_pullback`).
uses_adjoint(m::Pool, ::Step) = _form_adjoint(m.form)

# Trace ---------------------------------------------------------------------

# A pool's trace: with a draw, its pools after the step, the value drawn
# and what the draw leaves of the demand, per stratum for one pool and per
# group otherwise; without one, the amount each flow moves, per group.
ntrace(m::Pool, S) = _pool_ntrace(Val(_layout(m)), m, S)
function _pool_ntrace(::Val{L}, m, S) where {L}
    L.draw || return length(m.flows) * (S ÷ L.n)
    B = blocks(m)
    B === nothing && return 3S
    return (L.n + 2) * _ngroups(B, S)
end

forward(m::_OnePool, ::Trace, v::Number, s::Number, v′, s′, t, k) = (s′, v′, v - v′)
function pullback!(grads, m::_OnePool, ::Trace, v::Number, s::Number, t, k)
    p̄, ȳ, ū = grads.trace
    return ū, zero(ū), ȳ - ū, p̄
end

function forward(m::Pool, ::Trace, v::Tuple, s::Tuple, v′::Tuple, s′::Tuple, t, g)
    return _pool_trace(Val(_layout(m)), m, v, s, v′, s′, t, g)
end
function _pool_trace(::Val{L}, m, v, s, v′, s′, t, g) where {L}
    L.draw || return _amounts(m.flows, v, g, t)
    x, _ = _pools_queue(Val(L.overflow), s′, Val(L.n))
    _, Q = _pools_queue(Val(L.overflow), s, Val(L.n))
    y = first(v′)
    return (x..., y, first(v) + Q - y)
end

function pullback!(grads, m::Pool, ::Trace, v::Tuple, s::Tuple, t, g)
    return _pool_trace_back(Val(_layout(m)), grads, m, v, s, t, g)
end
function _pool_trace_back(::Val{L}, grads, m, v, s, t, g) where {L}
    L.draw || return _amounts_back(grads, m, v, s, t, g)
    r̄ = grads.trace
    ȳ, ū = r̄[L.n + 1], r̄[L.n + 2]
    z = zero(ū)
    x̄ = ntuple(i -> r̄[i], Val(L.n))
    zx = ntuple(_ -> z, Val(L.n))
    v̄ = ntuple(i -> i == 1 ? ū : z, Val(length(v)))
    v̄′ = ntuple(i -> i == 1 ? ȳ - ū : z, Val(length(v)))
    return v̄, _with_queue(Val(L.overflow), zx, ū), v̄′, _with_queue(Val(L.overflow), x̄, z)
end

# The flows' amounts back to the pools before them, and to each flow's
# demand and softness, through a local forward-mode derivative of
# `_amounts` at the group's pools, demands and softnesses.
function _amounts_back(grads, m, x::NTuple{N}, s, t, g) where {N}
    fs, r̄ = m.flows, grads.trace
    z0 = [x..., map(f -> param(f.demand, g, t), fs)..., _softnesses(fs)...]
    function traced(z)
        xs = ntuple(i -> z[i], Val(N))
        return sum(map(*, r̄, _amounts(_rebuild_flows(fs, z, N), xs, g, t)))
    end
    z̄ = _amounts_gradient(traced, z0)
    _add_flows!(cotangent(grads.piece, :flows), fs, z̄, N, length(fs) + N, g, t)
    zs = map(_ -> zero(eltype(z̄)), s)
    return ntuple(i -> z̄[i], Val(N)), zs, map(_ -> zero(eltype(z̄)), x), zs
end

# The softness of each smooth count, in order.
_softnesses(::Tuple{}) = ()
_softnesses(fs::Tuple) = (_softness_of(first(fs).form)..., _softnesses(Base.tail(fs))...)
_softness_of(form::SoftTruncate) = (form.κ,)
_softness_of(form) = ()

# The flows with their demands and softnesses read from `z`: demands from
# entry `N + 1`, then softnesses after the demands.
function _rebuild_flows(fs, z, N)
    return _rebuild_flows(fs, z, N, N + length(fs))
end
_rebuild_flows(::Tuple{}, z, i, j) = ()
function _rebuild_flows(fs::Tuple, z, i, j)
    f = first(fs)
    form, j′ = _rebuild_form(f.form, z, j)
    head = Flow(f.from, f.to, z[i + 1], form)
    return (head, _rebuild_flows(Base.tail(fs), z, i + 1, j′)...)
end
_rebuild_form(::SoftTruncate, z, j) = SoftTruncate(z[j + 1]), j + 1
_rebuild_form(form, z, j) = form, j

# Each flow's demand and softness cotangent into its mirror.
_add_flows!(f̄s, ::Tuple{}, z̄, i, j, g, t) = nothing
function _add_flows!(f̄s, fs::Tuple, z̄, i, j, g, t)
    f, f̄ = first(fs), _head(f̄s)
    add_param!(cotangent(f̄, :demand), f.demand, z̄[i + 1], g, t)
    j′ = _add_softness!(f̄, f.form, z̄, j)
    return _add_flows!(_tail(f̄s), Base.tail(fs), z̄, i + 1, j′, g, t)
end
function _add_softness!(f̄, ::SoftTruncate, z̄, j)
    add_cotangent!(cotangent(cotangent(f̄, :form), :κ), z̄[j + 1])
    return j + 1
end
_add_softness!(f̄, form, z̄, j) = j
