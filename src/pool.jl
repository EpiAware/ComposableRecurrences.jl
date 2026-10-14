# A pool holds stocks for each group of strata: the step's value is drawn
# from them by a depletion form, then flows move between them. Without a
# draw the stocks are the step's values, carried by the recurrence, and the
# flows move them. `Depletion(N)` is a pool with one stock.
#
# The layout `L` is a named tuple in the type: the number of stocks `n`,
# whether the pool draws (`draw`) and the stock the draw takes from when
# the weighted stocks are empty (`first`). Each layout has methods of its
# own: one stock is a pointwise step, more are blockwise.

@doc raw"""
A stock-and-flow modifier: each group of strata holds stocks, the step's
value is drawn from them by a depletion form, and
[`ComposableRecurrences.Flow`](@ref)s move between them.

With a draw, each stratum is a group with ``n`` stocks
``x_1, \dots, x_n``.
At absolute time ``t``, for a group with value ``v``, population ``N_t``
and heterogeneity ``\alpha``, the form ``F`` draws from the weighted stocks
``P``, and each stock loses the draw in proportion to its weight:

```math
\begin{aligned}
P &= \sum_i w_i x_i, \qquad (v', \cdot) = F(v, P, N_t, \alpha), \\
x^{*}_i &= x_i - v' \frac{w_i x_i}{P}, \qquad x' = \Phi_t(x^{*}),
\end{aligned}
```

where ``w_i`` is stock ``i``'s weight in the draw (zero for a stock the
draw does not name), ``v'`` the value passed on and ``\Phi_t`` the flows.
When ``P \le 0`` the draw comes from the first stock the draw names alone.
The flows act on the stocks after the draw: hazard and share flows
together, then the count flows in order ([`ComposableRecurrences.Flow`](@ref)
gives each form).
The form is a variant struct with `forward(form, Step(), v, s, N, α)`:
[`ComposableRecurrences.Hazard`](@ref),
[`ComposableRecurrences.Floor`](@ref),
[`ComposableRecurrences.Truncate`](@ref),
[`ComposableRecurrences.SoftTruncate`](@ref), or a new type with that
method ([A depletion form](@ref extending-form)).
`α > 1` depletes faster as the pool shrinks (heterogeneous mixing).
The draw's `Hazard()` takes its hazard from the value over the population,
``v / N_t``, where a `Hazard()` flow's demand is the rate itself, without
``N`` or ``\alpha``.
With one stock the step is pointwise and the state is the stock; with more
it is blockwise ([`ComposableRecurrences.blocks`](@ref) is `Val((1, n))`)
and the state holds stock 1 of every stratum, then stock 2, and so on.

Without a draw (`draw = nothing`) the stocks are the step's values: the
values hold ``n`` stocks of ``G`` groups each, stock by stock
(`blocks` is `Val((n, n))`), so value ``(i - 1) G + g`` is stock ``i`` of
group ``g``.
On a [`Recurrence`](@ref) with kernel `[1.0]` the core carries the
previous step's stocks forward, and the pool applies the step's flows,
``v' = \Phi_t(v)``.
The state then holds what flowed into each stock at the step, where a
negative count adds nothing.

Leaky vaccination with efficacy ``e`` is a second stock ``V`` drawn at
weight ``1 - e``, with the doses a count `Flow(:S => :V, doses; form =
Truncate())`; all-or-nothing protection is weight zero with ``e`` times the
doses.
Waning protection is a hazard `Flow(:V => :S, ω)`, and a delay from dose to
protection is a [`Convolution`](@ref) of the doses before the call.
[`ComposableRecurrences.Depletion`](@ref) is a pool with one stock.
A pool holds the fields `N`, `form`, `heterogeneity`, `initial`, `weights`
(each stock's weight in the draw, fixed at zero for a stock it does not
name) and `flows`, with each flow's stocks as positions.

# Arguments
- `N`: the population the form reads, a
  [parameter](@ref ComposableRecurrences.param) read at each step's group
  and time; `nothing` for a pool without a draw, or whose form does not
  read it.

# Keyword Arguments
- `stocks`: the stock names, a tuple of symbols, or the number of stocks;
  `(:S,)` by default.
  A flow names a stock by its name or position.
- `initial`: each stock's value before the first step, one value or
  [`PerStratum`](@ref) each, or `nothing` for the default: `N` at time 1
  for the first stock the draw names when `N` is given, and zero
  otherwise.
  One value stands for a pool with one stock.
  A pool without a draw takes its stocks from the history instead.
- `draw`: `stock => form` to draw from one stock, `(stock => w, ...) =>
  form` to draw from weighted stocks, or `nothing` for no draw;
  `first(stocks) => Hazard()` by default.
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

# Examples

Leaky vaccination: 5 doses a step move susceptibles into a stock drawn at
a third of the rate, and the protection wanes back at rate 0.1.

```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
leaky = CR.Pool(
    1000.0; stocks = (:S, :V), draw = (:S => 1, :V => 0.3) => CR.Hazard(),
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

A ward without a draw: suspected patients are confirmed or ruled out, and
confirmed patients are discharged, each at a hazard rate.

```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
ward = CR.Pool(;
    stocks = (:suspected, :confirmed), draw = nothing,
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
    "Each stock's starting value, `nothing` for its default."
    initial::I
    "Each stock's weight in the draw, or `nothing` without a draw."
    weights::W
    "The flows between the stocks, by position."
    flows::R
    function Pool{L}(
            N::P, form::F, heterogeneity::A, initial::I, weights::W, flows::R
        ) where {L, P, F, A, I, W, R}
        _check_layout(Val(L))
        form === nothing || _check_form(form)
        _check_stocks(flows, L.n)
        return new{L, P, F, A, I, W, R}(N, form, heterogeneity, initial, weights, flows)
    end
end
ConstructionBase.constructorof(::Type{<:Pool{L}}) where {L} = Pool{L}

# That the flows name no stock beyond the `n` there are; the message is
# built only when one does.
_check_stocks(::Tuple{}, n) = nothing
function _check_stocks(fs::Tuple, n)
    f = first(fs)
    max(f.from, f.to) <= n || _too_many_stocks(f, n)
    return _check_stocks(Base.tail(fs), n)
end
@noinline function _too_many_stocks(f, n)
    throw(
        ArgumentError(
            "the flows name stock $(max(f.from, f.to)), but there are $n stocks"
        )
    )
end

# Whether `L` is a pool layout, decided from the type alone, so a pool
# built inside a differentiated function runs no check.
@generated function _check_layout(::Val{L}) where {L}
    ok = L isa NamedTuple{(:n, :draw, :first), Tuple{Int, Bool, Int}} &&
        L.n >= 1 && 0 <= L.first <= L.n && (L.first >= 1) == L.draw
    ok && return :(nothing)
    msg = "not a pool layout: $(repr(L))"
    return :(throw(ArgumentError($msg)))
end

# Inlined, so that the stock names are constants where it is called and the
# lookups on them fold, and so that a differentiated function that builds a
# pool holds no call returning it.
@inline function Pool(
        N = nothing; stocks = (:S,), initial = nothing,
        draw = _first_stock(stocks) => Hazard(), heterogeneity = nothing,
        flows = ()
    )
    names = _stock_names(stocks)
    n = length(names)
    N = N === nothing ? nothing : _population(N)
    form, weights, first = _draw_spec(draw, names)
    α = form === nothing ? _no_heterogeneity(heterogeneity) :
        _exponent(something(heterogeneity, _unit_exponent(form)), N, form)
    form === nothing || N !== nothing || form isa _TruncateForm || throw(
        ArgumentError(
            "a $(nameof(typeof(form)))() draw reads the population, so give N"
        )
    )
    fs = map(f -> _placed(f, names), _pool_flows(flows))
    L = (; n, draw = form !== nothing, first)
    return Pool{L}(N, form, α, _initials(initial, n, form), weights, fs)
end

# The stock names, or positions for a number of stocks.
_stock_names(n::Integer) = n >= 1 ? ntuple(identity, Int(n)) : _bad_stocks(n)
function _stock_names(names::Union{Tuple, AbstractVector})
    isempty(names) && _bad_stocks(names)
    all(x -> x isa Symbol, names) && _distinct(Tuple(names)) || _bad_stocks(names)
    return Tuple(names)
end
_stock_names(names) = _bad_stocks(names)
@noinline function _bad_stocks(names)
    throw(
        ArgumentError(
            "stocks is a tuple of distinct names or a number of stocks, got " *
                _describe(names)
        )
    )
end

# Lookups on the stock names, which are constants where a pool is built,
# so that they fold when it is compiled: a pool built inside a
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

_first_stock(stocks) = first(_stock_names(stocks))

# The draw as its form, each stock's weight and the first stock it names.
_draw_spec(::Nothing, names) = (nothing, nothing, 0)
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
    return draw.second, weights, first(places)
end
_draw_spec(draw, names) = _bad_draw(draw)
@noinline function _bad_draw(draw)
    throw(
        ArgumentError(
            "draw is stock => form, (stock => weight, ...) => form with " *
                "distinct stocks, or nothing; got " * _describe(draw)
        )
    )
end

# The position of a stock the draw names.
function _drawn_place(x, names)
    i = _position(x, names)
    return i == 0 ? _unknown_drawn(x, names) : i
end
@noinline function _unknown_drawn(x, names)
    throw(
        ArgumentError(
            "the draw names stock $(repr(x)), but the stocks are $(repr(names))"
        )
    )
end

# A weight of one is fixed; any other is a constant parameter.
_weight(w::Bool) = _Fixed{w}()
function _weight(w::Integer)
    isone(w) && return _Fixed{true}()
    iszero(w) && return _Fixed{false}()
    return _float_param(w)
end
_weight(w) = _float_param(_check_constant(:weight, w))

# A fixed weight, held in the type: an AD tool's type analysis can reject a
# `Bool` field when a pool is built inside the differentiated function.
struct _Fixed{B} end
param(::_Fixed{B}, k, t) where {B} = B
add_param!(x̄, ::_Fixed, v, k, t) = nothing

_no_heterogeneity(::Nothing) = nothing
function _no_heterogeneity(α)
    throw(
        ArgumentError(
            "heterogeneity is an exponent of the draw, and the pool has none"
        )
    )
end

# The starting stocks: `nothing` for each default, or one value or
# `PerStratum` each.
_initials(::Nothing, n, form) = ntuple(_ -> nothing, n)
_initials(x, n, form) = _initials((x,), n, form)
function _initials(xs::Union{Tuple, AbstractVector}, n, form)
    length(xs) == n || throw(
        ArgumentError("initial has one entry per stock, $n, got $(length(xs))")
    )
    form === nothing && any(!isnothing, xs) && throw(
        ArgumentError(
            "a pool without a draw holds its stocks in the step's values, " *
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

# A pool with one stock and a draw, as `Depletion` builds it.
const _OneStock = Pool{(n = 1, draw = true, first = 1)}

@doc raw"""
Susceptible depletion: each stratum's new values are drawn from a pool
that starts at `pool0` and shrinks by what is drawn.

`Depletion` is the [`ComposableRecurrences.Pool`](@ref) with one stock and
a draw, and `Depletion(N, form; heterogeneity, pool0, removals)` builds

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
Its fields are a pool's: the starting pool is `initial[1]`, and its
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
const Depletion = _OneStock

function Depletion(
        N, form = Hazard(); heterogeneity = nothing, pool0 = nothing,
        removals = nothing
    )
    flows = removals === nothing ? () :
        (Flow(1, 0, _check_param(:removals, removals), Truncate()),)
    N = _population(N)
    α = _exponent(something(heterogeneity, _unit_exponent(form)), N, form)
    # Built without the names, as the one-stock layout needs no lookup.
    return Depletion(N, form, α, (_initial_param(pool0),), (_Fixed{true}(),), flows)
end

# The population a form reads, one where the pool has none.
_pop(N, k, t) = param(N, k, t)
_pop(::Nothing, k, t) = true
_add_pop!(N̄, N, x, k, t) = add_param!(N̄, N, x, k, t)
_add_pop!(N̄, ::Nothing, x, k, t) = nothing

_layout(::Pool{L}) where {L} = L
_draws(m::Pool) = _layout(m).draw
_nstocks(m::Pool) = _layout(m).n

# One stock with a draw is a pointwise step; more stocks, or none drawn, a
# blockwise one.
blocks(m::Pool) = _pool_blocks(Val(_layout(m)))
function _pool_blocks(::Val{L}) where {L}
    L.draw || return Val((L.n, L.n))
    return L.n == 1 ? nothing : Val((1, L.n))
end
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

# Stock `i`'s value before the first step at group `k`, and its cotangent.
function _initial(m::Pool, ::Val{i}, k) where {i}
    return _initial(m.initial[i], m, Val(i == _layout(m).first), k)
end
_initial(x, m, ::Val, k) = param(x, k, 1)
_initial(::Nothing, m, ::Val{false}, k) = false
_initial(::Nothing, m, ::Val{true}, k) = m.N === nothing ? false : param(m.N, k, 1)
function _add_initial!(m̄, m::Pool, ::Val{i}, x̄, k) where {i}
    return _add_initial!(
        m̄, m.initial[i], m, Val(i), Val(i == _layout(m).first), x̄, k
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

# Every stock's value before the first step at group `k`, and their
# cotangents from the state cotangent `s̄` of `G` groups, unrolled over the
# stocks so each reads its own entry of `initial` without a closure.
@generated function _initials(m::Pool{L}, k) where {L}
    return Expr(:tuple, (:(_initial(m, $(Val(i)), k)) for i in 1:L.n)...)
end
@generated function _add_initials!(m̄, m::Pool{L}, s̄, G, k) where {L}
    calls = (
        :(_add_initial!(m̄, m, $(Val(i)), s̄[$(i - 1) * G + k], k)) for i in 1:L.n
    )
    return Expr(:block, calls..., :(return nothing))
end

function forward(m::Pool, ::Init, s, history)
    n = _nstocks(m)
    G = length(s) ÷ n
    _check_modifier_strata(m, _draws(m) ? G : length(s))
    if _draws(m)
        _each!(_initial_body!, Serial(), s, G, length(s), s, m, G)
    else
        fill!(s, zero(eltype(s)))
    end
    return nothing
end

function _initial_body!(k, s, m, G)
    _scatter!(s, _initials(m, k), G, k)
    return nothing
end

function pullback!(grads, m::Pool, ::Init, s, history)
    _draws(m) || return nothing
    n = _nstocks(m)
    G = length(s) ÷ n
    s̄ = grads.s
    for k in 1:G
        _add_initials!(grads.piece, m, s̄, G, k)
    end
    return nothing
end

# One stock and no flows: the form's step.
const _Depleting = _OneStock{<:Any, <:Any, <:Any, <:Any, <:Any, Tuple{}}

function forward(m::_Depleting, ::Step, v::Real, s::Real, t, k)
    return forward(
        m.form, Step(), v, s, _pop(m.N, k, t), _exponent_value(m.heterogeneity)
    )
end

function pullback!(grads, m::_Depleting, ::Step, v::Real, s::Real, t, k)
    m̄ = grads.piece
    v̄, s̄, N̄, ᾱ = _form_pullback(
        (; piece = cotangent(m̄, :form), v = grads.v, s = grads.s), m.form,
        v, s, _pop(m.N, k, t), _exponent_value(m.heterogeneity)
    )
    _add_pop!(cotangent(m̄, :N), m.N, N̄, k, t)
    add_cotangent!(cotangent(m̄, :heterogeneity), ᾱ)
    return v̄, s̄
end

# One stock with flows: the draw, then the flows on the stock.
const _Flowing = _OneStock{
    <:Any, <:Any, <:Any, <:Any, <:Any, <:Tuple{Flow, Vararg{Flow}},
}

function forward(m::_Flowing, ::Step, v::Real, s::Real, t, k)
    y, s′ = forward(
        m.form, Step(), v, s, _pop(m.N, k, t), _exponent_value(m.heterogeneity)
    )
    (s″,) = _flow_only(m.flows, (s′,), k, t)
    return y, s″
end

function pullback!(grads, m::_Flowing, ::Step, v::Real, s::Real, t, k)
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

# A group's step: the draw from its weighted stocks then the flows, or the
# flows on its values.
function forward(m::Pool, ::Step, v::Tuple, s::Tuple, t, g)
    return _group_step(Val(_draws(m)), m, v, s, t, g)
end
_group_step(::Val{false}, m, v, s, t, g) = _flow_group(m.flows, v, g, t)
function _group_step(::Val{true}, m, v, s, t, g)
    y, x = _draw_stocks(m, only(v), s, t, g)
    return (y,), _flow_only(m.flows, x, g, t)
end

# The weights at group `g` and time `t`, promoted to one type so a step
# indexes them without a union, and the weighted stocks `Σ w_i x_i`, summed
# in order. A fixed weight of one promotes to an exact one.
function _weights_at(m, ::Val{n}, g, t) where {n}
    return promote(ntuple(i -> param(m.weights[i], g, t), Val(n))...)
end
_weighted(w::Tuple{Any}, x::Tuple{Any}) = first(w) * first(x)
function _weighted(w::Tuple, x::Tuple)
    return _weighted_sum(Base.tail(w), Base.tail(x), first(w) * first(x))
end
_weighted_sum(::Tuple{}, ::Tuple{}, P) = P
function _weighted_sum(w::Tuple, x::Tuple, P)
    return _weighted_sum(Base.tail(w), Base.tail(x), P + first(w) * first(x))
end

# One group's draw from its stocks `x`, and the stocks after it.
function _draw_stocks(m, v, x::NTuple{n}, t, g) where {n}
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
    return _group_pullback(Val(_draws(m)), grads, m, v, s, t, g)
end
function _group_pullback(::Val{false}, grads, m, v, s::NTuple{n}, t, g) where {n}
    x̄ = _flows_pullback(
        m.flows, cotangent(grads.piece, :flows), v, grads.v, grads.s, g, t
    )
    return x̄, ntuple(_ -> zero(eltype(x̄)), Val(n))
end

# `v` and `x` are the group's incoming value and stocks; returns the
# cotangents of the inputs from those of the output and of the stocks after
# the step.
function _group_pullback(::Val{true}, grads, m, v, x::NTuple{n}, t, g) where {n}
    m̄ = grads.piece
    α = _exponent_value(m.heterogeneity)
    vk, N = only(v), _pop(m.N, g, t)
    w = _weights_at(m, Val(n), g, t)
    P = _weighted(w, x)
    y, _ = forward(m.form, Step(), vk, P, N, α)
    ȳ = only(grads.v)
    on = _primal_value(P) > 0
    q = on ? y / P : zero(y)
    d = _layout(m).first
    x′ = ntuple(i -> on ? x[i] - q * w[i] * x[i] : (i == d ? x[i] - y : x[i]), Val(n))
    z = zero(ȳ)
    x̄′ = _flows_pullback(
        m.flows, cotangent(m̄, :flows), x′, grads.s, ntuple(_ -> z, Val(n)), g, t
    )
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
    return (v̄k,), ntuple(i -> x̄[i] + w[i] * P̄, Val(n))
end

# The cotangents of the stocks, the weights, the value drawn and the
# weighted stocks from those of the stocks after the draw `x̄′`: each stock
# lost the share `q = y / P` of its weighted stock, or with `P <= 0` the
# first stock drawn lost `y`.
function _shares_back(on, x̄′, w, x, q, P, ȳ, d, z, ::Val{n}) where {n}
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

# A pool uses its own pullback when its form has one or the form's local
# derivative covers it (see `_form_pullback`).
uses_adjoint(m::Pool, ::Step) = _form_adjoint(m.form)
