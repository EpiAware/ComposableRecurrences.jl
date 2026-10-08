# Competing flows between linked stocks. A `Flow` moves a stock at a
# hazard rate into another stock or out of the stocks; the flows out of one
# stock compete, sharing what leaves in proportion to their rates. `Flows`
# applies them to the step's values, and `Linked` to another modifier's
# state.

@doc raw"""
A flow from stock `from` into stock `to` at a hazard rate, for
[`ComposableRecurrences.Flows`](@ref) and
[`ComposableRecurrences.Linked`](@ref).

`to = 0` makes the flow leave the stocks.
The flows out of one stock compete: at absolute time ``t``, stratum ``k``
(one of ``S`` parallel series) with stock ``x_i`` and flows ``f`` out of it
at rates ``r_{f,t,k}``,

```math
H_i = \sum_{f:\ \mathrm{from}(f) = i} r_{f,t,k}, \qquad
m_f = x_i\, \frac{r_{f,t,k}}{H_i} \big(1 - e^{-H_i}\big),
```

where ``H_i`` is the total hazard out of stock ``i`` and ``m_f`` the amount
flow ``f`` moves, so ``\sum_f m_f = x_i (1 - e^{-H_i})`` and a non-negative
stock stays non-negative.
A per-step probability ``p`` is the rate ``-\log(1 - p)``.

# Arguments
- `stocks`: `from => to`, the stock the flow leaves and the one it enters,
  or `0` to leave the stocks.
- `rate`: the hazard rate, a parameter read at each step's stratum and
  time: one value, [`PerStratum`](@ref), [`TimeVarying`](@ref),
  `TimeVarying(PerStratum(r))` or [`Derived`](@ref).

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
CR.Flow(2 => 1, TimeVarying([0.1, 0.2]))

# output

ComposableRecurrences.Flow{TimeVarying{ComposableRecurrences.Secondary, Vector{Float64}}}(2, 1, TimeVarying{ComposableRecurrences.Secondary, Vector{Float64}}([0.1, 0.2]))
```
"""
struct Flow{R}
    "The stock the flow leaves."
    from::Int
    "The stock it enters, or `0` when it leaves the stocks."
    to::Int
    "The hazard rate, a parameter read at each step's stratum and time."
    rate::R
    function Flow(from::Integer, to::Integer, rate::R) where {R}
        from >= 1 || throw(
            ArgumentError("a flow leaves a stock from 1 on, got from = $from")
        )
        to >= 0 || throw(
            ArgumentError(
                "a flow enters a stock from 1 on, or 0 to leave, got to = $to"
            )
        )
        from == to && throw(
            ArgumentError("a flow joins two stocks, got $from => $to")
        )
        return new{R}(from, to, _check_param(:rate, rate))
    end
end

Flow(stocks::Pair{<:Integer, <:Integer}, rate) = Flow(stocks.first, stocks.second, rate)
function Flow(stocks, rate)
    throw(
        ArgumentError(
            "a flow joins stocks given as from => to, got $(_describe(stocks))"
        )
    )
end

# The flows as a non-empty tuple of `Flow`s.
function _flow_tuple(fs)
    isempty(fs) && throw(ArgumentError("give at least one Flow, got none"))
    for f in fs
        f isa Flow || throw(ArgumentError("expected a Flow, got $(_describe(f))"))
    end
    return fs
end

# The largest stock the flows name.
_max_stock(fs) = maximum(f -> max(f.from, f.to), fs)

@doc raw"""
Moves the step's values between stocks by competing
[`ComposableRecurrences.Flow`](@ref)s.

The values hold ``n`` stocks of ``S`` strata each, stock by stock: entry
``(i - 1) S + k`` is stock ``i`` of stratum ``k``, and ``n`` is the largest
stock a flow names.
At absolute time ``t``, with ``x_i`` stock ``i``'s value entering the
modifier, ``H_i`` the total hazard out of it and ``m_f`` the amount flow
``f`` moves (see [`ComposableRecurrences.Flow`](@ref)),

```math
\begin{aligned}
a_j &= \sum_{f:\ \mathrm{to}(f) = j} m_f, \\
x'_i &= e^{-H_i} x_i + a_i,
\end{aligned}
```

where ``a_j`` is what flows into stock ``j`` and ``x'_i`` the value passed
on; each stratum's stocks move separately.
The state holds the arrivals ``a``.
On a [`Recurrence`](@ref) with kernel `[1.0]` and the stocks as strata,
the core carries yesterday's stocks forward and the modifier applies the
day's flows.

# Arguments
- `flows`: one or more [`ComposableRecurrences.Flow`](@ref)s.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
flows = CR.Flows(CR.Flow(1 => 2, 0.3), CR.Flow(1 => 0, 0.4), CR.Flow(2 => 0, 0.1))
ward = Recurrence([1.0]; modifiers = (flows,))
admitted = [fill(10.0, 1, 4); zeros(1, 4)]
round.(ward(; history = zeros(2, 1), add = admitted); digits = 3)

# output

2×4 Matrix{Float64}:
 4.966  7.432  8.656   9.264
 2.157  5.181  8.449  11.67
```
"""
struct Flows{F <: Tuple}
    "The flows, a tuple of `Flow`s."
    flows::F
    "The number of stocks, the largest stock a flow names."
    stocks::Int
end

Flows(fs...) = (fs = _flow_tuple(fs); Flows(fs, _max_stock(fs)))

@doc raw"""
Moves another modifier's state between its stocks by competing
[`ComposableRecurrences.Flow`](@ref)s, then runs that modifier's step.

The modifier `m` keeps [`ComposableRecurrences.nstate`](@ref)`(m, S)`
``= n S`` state entries for ``S`` strata, ``n`` stocks stock by stock:
entry ``(i - 1) S + k`` is stock ``i`` of stratum ``k``.
At absolute time ``t``, with ``x`` the modifier's state after the previous
step, ``H_i`` the total hazard out of stock ``i`` and ``m_f`` the amount
flow ``f`` moves (see [`ComposableRecurrences.Flow`](@ref)),

```math
\begin{aligned}
a_j &= \sum_{f:\ \mathrm{to}(f) = j} m_f, \qquad
x^{*}_i = e^{-H_i} x_i + a_i, \\
(v', x') &= M(v, x^{*}, t),
\end{aligned}
```

where ``a_j`` is what flows into stock ``j``, ``x^{*}`` the state after the
flows, ``M`` the step of `m` and ``(v', x')`` its new values and state.
The state holds ``x'`` then the arrivals ``a``, so
``n(\mathrm{Linked}, S) = 2 n S``.

With a [`ComposableRecurrences.Protected`](@ref) pool the depletion keeps
the unprotected pool (stock 1) then the protected pool (stock 2), so
`Flow(2 => 1, ω)` is waning protection at rate ``\omega``.
`Flow(1 => 0, μ)` on a [`ComposableRecurrences.Depletion`](@ref) without a
protected pool removes susceptibles at rate ``\mu``.

# Arguments
- `m`: the modifier whose stocks the flows move.
- `flows`: one or more [`ComposableRecurrences.Flow`](@ref)s.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
leaky = CR.Depletion(1000.0; removals = 5.0, protected = CR.Protected(0.3))
waning = CR.Linked(leaky, CR.Flow(2 => 1, 0.1))
y = Recurrence([0.3, 0.5, 0.2]; modifiers = (waning,))(fill(2.0, 6); history = [5.0])
round.(y; digits = 3)

# output

6-element Vector{Float64}:
  2.996
  6.733
  8.853
 12.797
 18.235
 25.226
```
"""
struct Linked{M, F <: Tuple}
    "The modifier whose stocks the flows move."
    modifier::M
    "The flows, a tuple of `Flow`s."
    flows::F
end

function Linked(m, fs...)
    m isa Flow && throw(
        ArgumentError(
            "Linked takes the modifier whose stocks the flows move first, " *
                "got $(_describe(m))"
        )
    )
    return Linked(m, _flow_tuple(fs))
end

nstate(m::Linked, S) = 2 * nstate(m.modifier, S)

# The index of stock `i` of stratum `k` among `S` strata.
_stock(i, k, S) = (i - 1) * S + k

# The total hazard out of stock `i` of stratum `k` at time `t`, added to `H`.
_out_hazard(::Tuple{}, i, k, t, H) = H
function _out_hazard(fs::Tuple, i, k, t, H)
    f = first(fs)
    r = param(f.rate, k, t)
    return _out_hazard(Base.tail(fs), i, k, t, H + ifelse(f.from == i, r, zero(r)))
end

# Add `c` times each rate out of stock `i` into the stock it enters, for
# stratum `k` of `S`.
_spread!(::Tuple{}, a, i, k, t, c, S) = nothing
function _spread!(fs::Tuple, a, i, k, t, c, S)
    f = first(fs)
    if f.from == i && f.to > 0
        j = _stock(f.to, k, S)
        a[j] += c * param(f.rate, k, t)
    end
    return _spread!(Base.tail(fs), a, i, k, t, c, S)
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

# Move the stocks `x` (`n` stocks of `S` strata) in place by the flows at
# time `t`, writing the arrivals into `a`.
function _flow!(x, a, fs, n, S, t)
    fill!(a, zero(eltype(a)))
    for k in 1:S, i in 1:n
        j = _stock(i, k, S)
        xi = x[j]
        E, g = _leave(_out_hazard(fs, i, k, t, zero(xi)))
        _spread!(fs, a, i, k, t, xi * g, S)
        x[j] = E * xi
    end
    for j in eachindex(x, a)
        x[j] += a[j]
    end
    return nothing
end

# The stocks after the flows, `y = exp(-H) x + a`, into `y`.
function _flowed!(y, x, fs, n, S, t)
    fill!(y, zero(eltype(y)))
    for k in 1:S, i in 1:n
        j = _stock(i, k, S)
        xi = x[j]
        E, g = _leave(_out_hazard(fs, i, k, t, zero(xi)))
        _spread!(fs, y, i, k, t, xi * g, S)
        y[j] += E * xi
    end
    return y
end

# `Σ_f r_f ā_to(f)` over the flows out of stock `i`, exits adding nothing.
_arrivals_back(::Tuple{}, ā, i, k, t, S, B) = B
function _arrivals_back(fs::Tuple, ā, i, k, t, S, B)
    f = first(fs)
    if f.from == i && f.to > 0
        B += param(f.rate, k, t) * ā[_stock(f.to, k, S)]
    end
    return _arrivals_back(Base.tail(fs), ā, i, k, t, S, B)
end

# The first flow's mirror, or `nothing` when the flows have none; `_tail`
# moves on to the next.
_head(::Nothing) = nothing
_head(x̄::Tuple) = first(x̄)

# Each rate out of stock `i` takes `c0 + c1 ā_to(f)`.
_rates_back!(::Tuple{}, f̄s, ā, i, k, t, S, c0, c1) = nothing
function _rates_back!(fs::Tuple, f̄s, ā, i, k, t, S, c0, c1)
    f = first(fs)
    if f.from == i
        r̄ = f.to > 0 ? c0 + c1 * ā[_stock(f.to, k, S)] : c0
        add_param!(cotangent(_head(f̄s), :rate), f.rate, r̄, k, t)
    end
    return _rates_back!(Base.tail(fs), _tail(f̄s), ā, i, k, t, S, c0, c1)
end

# The reverse of `_flow!` from the incoming stocks `x`: `x̄` holds the
# cotangent of the stocks after the flows and becomes that of `x`; `ā`
# holds the arrivals' and is used, then zeroed, as `a` does not read its
# incoming value. With `B = Σ_f r_f ā_to(f)` over the flows out of stock
# `i`, `x̄_i ← e^{-H} x̄_i + g B` and each rate takes
# `x_i (g ā_to(f) + g′ B - e^{-H} x̄_i)`.
function _flow_back!(x̄, ā, f̄s, fs, x, n, S, t)
    for j in eachindex(x̄, ā)
        ā[j] += x̄[j]
    end
    for k in 1:S, i in 1:n
        j = _stock(i, k, S)
        xi = x[j]
        H = _out_hazard(fs, i, k, t, zero(xi))
        E, g = _leave(H)
        B = _arrivals_back(fs, ā, i, k, t, S, zero(eltype(ā)))
        c0 = xi * (_leave_slope(H, E, g) * B - E * x̄[j])
        _rates_back!(fs, f̄s, ā, i, k, t, S, c0, xi * g)
        x̄[j] = E * x̄[j] + g * B
    end
    fill!(ā, zero(eltype(ā)))
    return nothing
end

# Each rate against the strata of a stock.
function _check_rates(fs, S)
    for f in fs
        _check_param_strata(:rate, f.rate, S)
    end
    return nothing
end

# Flows --------------------------------------------------------------------

function _check_modifier_strata(m::Flows, S)
    n = m.stocks
    rem(S, n) == 0 || throw(
        DimensionMismatch(
            "Flows moves $n stocks, so the strata are a multiple of $n, " *
                "got $S strata"
        )
    )
    _check_rates(m.flows, S ÷ n)
    return nothing
end

function forward(m::Flows, ::Init, s, history)
    _check_modifier_strata(m, length(s))
    fill!(s, zero(eltype(s)))
    return nothing
end
pullback!(grads, ::Flows, ::Init, s, history) = nothing

function forward(m::Flows, ::Step, v, s, t)
    n = m.stocks
    _flow!(v, s, m.flows, n, length(v) ÷ n, t)
    return nothing
end

function pullback!(grads, m::Flows, ::Step, v, s, t)
    n = m.stocks
    _flow_back!(
        grads.v, grads.s, cotangent(grads.piece, :flows), m.flows, v, n,
        length(v) ÷ n, t
    )
    return nothing
end

# Linked -------------------------------------------------------------------

function _check_modifier_strata(m::Linked, S)
    _check_modifier_strata(m.modifier, S)
    name = nameof(typeof(m.modifier))
    nm = nstate(m.modifier, S)
    rem(nm, S) == 0 || throw(
        ArgumentError(
            "$name keeps $nm state entries for $S strata, not a whole " *
                "number of stocks per stratum"
        )
    )
    top = _max_stock(m.flows)
    top <= nm ÷ S || throw(
        ArgumentError(
            "the flows name stock $top, but $name keeps $(nm ÷ S) per stratum"
        )
    )
    _check_rates(m.flows, S)
    return nothing
end

function forward(m::Linked, ::Init, s, history)
    _check_modifier_strata(m, _nstrata(history))
    nm = length(s) ÷ 2
    forward(m.modifier, Init(), view(s, 1:nm), history)
    fill!(view(s, (nm + 1):length(s)), zero(eltype(s)))
    return nothing
end

function pullback!(grads, m::Linked, ::Init, s, history)
    nm = length(s) ÷ 2
    pullback!(
        (;
            piece = cotangent(grads.piece, :modifier),
            s = view(grads.s, 1:nm), history = grads.history,
        ),
        m.modifier, Init(), view(s, 1:nm), history
    )
    return nothing
end

function forward(m::Linked, ::Step, v, s, t)
    S = length(v)
    nm = length(s) ÷ 2
    x = view(s, 1:nm)
    _flow!(x, view(s, (nm + 1):(2nm)), m.flows, nm ÷ S, S, t)
    forward(m.modifier, Step(), v, x, t)
    return nothing
end

# The modifier's step is reversed at the stocks after the flows, which the
# state does not keep, so they are rebuilt from the incoming stocks.
function pullback!(grads, m::Linked, ::Step, v, s, t)
    S = length(v)
    nm = length(s) ÷ 2
    x = view(s, 1:nm)
    x̄, ā = view(grads.s, 1:nm), view(grads.s, (nm + 1):(2nm))
    y = _flowed!(similar(x), x, m.flows, nm ÷ S, S, t)
    _vector_pullback!(
        (; piece = cotangent(grads.piece, :modifier), v = grads.v, s = x̄),
        m.modifier, v, y, t
    )
    _flow_back!(x̄, ā, cotangent(grads.piece, :flows), m.flows, x, nm ÷ S, S, t)
    return nothing
end

# The rule reverses a linked step when the modifier carries its own
# adjoint; one the rule would rebuild with dual numbers is left to plain AD.
function uses_adjoint(m::Linked, ::Step)
    return _modifier_adjoint(m.modifier) === :pullback && !_rebuilt(m.modifier)
end
