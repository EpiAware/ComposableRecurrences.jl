# Flows between the compartments of each group. A `Flow` moves part of one
# compartment into another, or out, each step: at a hazard rate (`Rate`,
# the default), as a share (`Linear`) or as a count (`Amount`). The rates
# out of one compartment compete; shares and rates act on the incoming
# compartments together, then the counts in flow order on what remains.

@doc raw"""
A flow kind: a hazard rate ``r``, the default for a
[`ComposableRecurrences.Flow`](@ref).

The rate flows out of compartment ``i`` compete: with ``H_i`` the sum of
their rates, flow ``f`` moves

```math
m_f = x_i\, \frac{r_f}{H_i} \big(1 - e^{-H_i}\big),
```

so together they move ``x_i (1 - e^{-H_i})``, and with non-negative, finite
rates a non-negative compartment stays non-negative.
A per-step probability ``p < 1`` is the rate ``-\log(1 - p)``.
The rates are not checked, as a dual or [`Derived`](@ref) rate cannot be.

# Arguments
- `r`: the rate, a parameter read at each step's group and time: one
  value, [`PerStratum`](@ref) (one per group), [`TimeVarying`](@ref),
  `TimeVarying(PerStratum(r))` or [`Derived`](@ref).

# Examples
```jldoctest
using ComposableRecurrences
ComposableRecurrences.Rate(0.2)

# output

ComposableRecurrences.Rate{Float64}(0.2)
```
"""
struct Rate{R}
    "The hazard rate."
    r::R
    Rate(r::R) where {R} = new{R}(_check_param(:r, r))
end

@doc raw"""
A flow kind: a share ``p`` of the compartment it leaves.

Flow ``f`` out of compartment ``i`` moves ``m_f = p_f x_i``, from the
compartment before the step's flows, alongside any
[`ComposableRecurrences.Rate`](@ref) flows.
Shares out of one compartment that sum to more than ``e^{-H_i}`` leave it
negative.

# Arguments
- `p`: the share, a parameter read at each step's group and time, as for
  [`ComposableRecurrences.Rate`](@ref).

# Examples
```jldoctest
using ComposableRecurrences
ComposableRecurrences.Linear(0.15)

# output

ComposableRecurrences.Linear{Float64}(0.15)
```
"""
struct Linear{P}
    "The share."
    p::P
    Linear(p::P) where {P} = new{P}(_check_param(:p, p))
end

@doc raw"""
A flow kind: a count ``a``, capped by what the compartment holds.

After the [`ComposableRecurrences.Rate`](@ref) and
[`ComposableRecurrences.Linear`](@ref) flows, each count flow in turn moves

```math
m_f = \min\big(a_f,\ \max(x_i, 0)\big)
```

out of compartment ``i``, with ``x_i`` what it holds by then.
A negative count adds ``-a_f`` to compartment ``i``, without a cap, and
moves nothing into the compartment the flow enters.
The derivative through ``\min`` and ``\max`` takes the active branch.

# Arguments
- `a`: the count, a parameter read at each step's group and time, as for
  [`ComposableRecurrences.Rate`](@ref).

# Examples
```jldoctest
using ComposableRecurrences
ComposableRecurrences.Amount(TimeVarying([5.0, 0.0]))

# output

ComposableRecurrences.Amount{TimeVarying{ComposableRecurrences.Secondary, Vector{Float64}}}(TimeVarying{ComposableRecurrences.Secondary, Vector{Float64}}([5.0, 0.0]))
```
"""
struct Amount{A}
    "The count."
    a::A
    Amount(a::A) where {A} = new{A}(_check_param(:a, a))
end

const _FlowKind = Union{Rate, Linear, Amount}

@doc raw"""
A flow from compartment `from` into compartment `to`, or out of the
compartments with `to = 0`, for [`ComposableRecurrences.Flows`](@ref).

The kind sets how much it moves each step:
[`ComposableRecurrences.Rate`](@ref) a competing hazard rate,
[`ComposableRecurrences.Linear`](@ref) a share or
[`ComposableRecurrences.Amount`](@ref) a count.
A bare parameter is a `Rate`.

# Arguments
- `compartments`: `from => to`, numbered from 1, with `to = 0` to leave.
- `kind`: a `Rate`, `Linear` or `Amount`, or a parameter for a `Rate`.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
CR.Flow(2 => 1, 0.1).kind, CR.Flow(1 => 0, CR.Amount(3.0)).to

# output

(ComposableRecurrences.Rate{Float64}(0.1), 0)
```
"""
struct Flow{K <: _FlowKind}
    "The compartment the flow leaves."
    from::Int
    "The compartment it enters, or `0` when it leaves."
    to::Int
    "How much it moves: a `Rate`, `Linear` or `Amount`."
    kind::K
    function Flow(from::Integer, to::Integer, kind::K) where {K <: _FlowKind}
        from >= 1 || throw(
            ArgumentError("compartments are numbered from 1, got from = $from")
        )
        to >= 0 || throw(
            ArgumentError(
                "to is a compartment from 1, or 0 to leave, got to = $to"
            )
        )
        from == to && throw(
            ArgumentError(
                "a flow joins two different compartments, got $from => $to"
            )
        )
        return new{K}(from, to, kind)
    end
end

Flow(from::Integer, to::Integer, r) = Flow(from, to, Rate(r))
function Flow(compartments::Pair{<:Integer, <:Integer}, kind)
    return Flow(compartments.first, compartments.second, kind)
end
function Flow(compartments, kind)
    throw(
        ArgumentError(
            "a flow joins compartments given as from => to, got " *
                _describe(compartments)
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

# The largest compartment the flows name.
_max_compartment(fs) = maximum(f -> max(f.from, f.to), fs)

@doc raw"""
Moves the step's values between the compartments of each group by
[`ComposableRecurrences.Flow`](@ref)s.

The values hold ``n`` compartments of ``G`` groups each, compartment by
compartment ([`ComposableRecurrences.blocks`](@ref) is `Val((n, n))`): with
``S = nG`` strata, value ``(i - 1) G + g`` is compartment ``i`` of group
``g``, and a [`PerStratum`](@ref) parameter has ``G`` entries.
At absolute time ``t``, for each group with compartments ``x``, rate flows
``f`` at rates ``r_f`` and share flows at shares ``p_f``,

```math
\begin{aligned}
H_i &= \sum_{\mathrm{Rate}\ f \text{ out of } i} r_f, \qquad
P_i = \sum_{\mathrm{Linear}\ f \text{ out of } i} p_f, \\
m_f &= x_i\, r_f\, \frac{1 - e^{-H_i}}{H_i} \ \text{(Rate)}, \qquad
m_f = x_i\, p_f \ \text{(Linear)}, \\
y_j &= \big(e^{-H_j} - P_j\big) x_j + \sum_{f \text{ into } j} m_f,
\end{aligned}
```

then each [`ComposableRecurrences.Amount`](@ref) flow, in the order given,
moves ``\min(a_f, \max(y_i, 0))`` out of compartment ``i``.
The result is the value passed on, and the state holds what flowed into
each compartment at the step.
On a [`Recurrence`](@ref) with kernel `[1.0]`, the core carries the
previous step's compartments forward and the modifier applies the step's
flows.

# Arguments
- `flows`: one or more [`ComposableRecurrences.Flow`](@ref)s.

# Keyword Arguments
- `compartments`: the number of compartments ``n``; the largest a flow
  names by default.

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
struct Flows{N, F <: Tuple}
    "The flows, a tuple of `Flow`s."
    flows::F
    function Flows{N}(flows::F) where {N, F <: Tuple}
        _flow_tuple(flows)
        N isa Int && N >= 1 || throw(
            ArgumentError("compartments is a positive integer, got $(repr(N))")
        )
        top = _max_compartment(flows)
        N >= top || throw(
            ArgumentError(
                "compartments must cover every compartment a flow names, up " *
                    "to $top, got compartments = $N"
            )
        )
        return new{N, F}(flows)
    end
end

function Flows(fs...; compartments = nothing)
    fs = _flow_tuple(fs)
    n = compartments === nothing ? _max_compartment(fs) : compartments
    return Flows{n}(fs)
end
ConstructionBase.constructorof(::Type{<:Flows{N}}) where {N} = Flows{N}

blocks(::Flows{N}) where {N} = Val((N, N))

# The rate, share and count of a flow, zero for another kind.
_rate(f::Flow{<:Rate}, g, t) = param(f.kind.r, g, t)
_rate(f::Flow, g, t) = false
_share(f::Flow{<:Linear}, g, t) = param(f.kind.p, g, t)
_share(f::Flow, g, t) = false

# Sum `h(f, g, t)` over the flows out of compartment `i`.
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
_set(x::NTuple{N, T}, i, v) where {N, T} = Base.setindex(x, convert(T, v), i)

# What moves out of compartment `i` per unit held, `(e^{-H}, g(H), P)`.
function _leaves(fs, i, g, t, z)
    E, gH = _leave(_out(_rate, fs, i, g, t, z))
    return E, gH, _out(_share, fs, i, g, t, z)
end

# Add each rate and share flow's amount into the compartment it enters, in
# `y` and the arrivals `a`.
_spread(::Tuple{}, x, L, y, a, g, t) = y, a
function _spread(fs::Tuple, x, L, y, a, g, t)
    f = first(fs)
    if f.to > 0 && !(f isa Flow{<:Amount})
        _, gH, _ = L[f.from]
        m = x[f.from] * (_rate(f, g, t) * gH + _share(f, g, t))
        y = _set(y, f.to, y[f.to] + m)
        a = _set(a, f.to, a[f.to] + m)
    end
    return _spread(Base.tail(fs), x, L, y, a, g, t)
end

# The count flows in order on the compartments `y` and arrivals `a`.
_counts(::Tuple{}, y, a, g, t) = y, a
function _counts(fs::Tuple, y, a, g, t)
    y, a = _count(first(fs), y, a, g, t)
    return _counts(Base.tail(fs), y, a, g, t)
end
_count(f::Flow, y, a, g, t) = y, a
function _count(f::Flow{<:Amount}, y, a, g, t)
    m = _removal(param(f.kind.a, g, t), y[f.from])
    y = _set(y, f.from, y[f.from] - m)
    f.to > 0 || return y, a
    p = _protects(m)
    return _set(y, f.to, y[f.to] + p), _set(a, f.to, a[f.to] + p)
end

# One group's step: the compartments `x` after the flows, and arrivals.
function _flow_group(fs, x::NTuple{N}, g, t) where {N}
    z = zero(first(x))
    L = ntuple(i -> _leaves(fs, i, g, t, z), Val(N))
    y = ntuple(i -> (L[i][1] - L[i][3]) * x[i], Val(N))
    y, a = _spread(fs, x, L, y, ntuple(_ -> z, Val(N)), g, t)
    return _counts(fs, y, a, g, t)
end

function forward(m::Flows, ::Step, v::Tuple, s::Tuple, t, g)
    return _flow_group(m.flows, v, g, t)
end

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
function _count_back(f::Flow{<:Amount}, f̄, y, ȳ, ā, g, t)
    c = param(f.kind.a, g, t)
    m = _removal(c, y[f.from])
    m̄ = -ȳ[f.from]
    if f.to > 0 && _primal_value(m) >= 0
        m̄ += ȳ[f.to] + ā[f.to]
    end
    c̄, s̄ = _removal_pullback(c, y[f.from], m̄)
    add_param!(cotangent(cotangent(f̄, :kind), :a), f.kind.a, c̄, g, t)
    return _set(ȳ, f.from, ȳ[f.from] + s̄)
end

# The first flow's mirror, or `nothing` when the flows have none.
_head(::Nothing) = nothing
_head(x̄::Tuple) = first(x̄)

# `Σ_f r_f ā_to(f)` over the rate flows out of compartment `i`, exits
# adding nothing.
_arrivals_back(::Tuple{}, ā, i, g, t, B) = B
function _arrivals_back(fs::Tuple, ā, i, g, t, B)
    f = first(fs)
    if f.from == i && f.to > 0
        B += _rate(f, g, t) * ā[f.to]
    end
    return _arrivals_back(Base.tail(fs), ā, i, g, t, B)
end

function pullback!(grads, m::Flows{N}, ::Step, v, s, t, g) where {N}
    fs = m.flows
    f̄s = cotangent(grads.piece, :flows)
    x = v
    z = zero(first(x))
    L = ntuple(i -> _leaves(fs, i, g, t, z), Val(N))
    y0 = ntuple(i -> (L[i][1] - L[i][3]) * x[i], Val(N))
    y, a = _spread(fs, x, L, y0, ntuple(_ -> z, Val(N)), g, t)
    ā = grads.s
    ȳ = _counts_back(fs, f̄s, y, a, grads.v, ā, g, t)
    # The rate and share arrivals feed both the compartments and the state.
    āt = ntuple(j -> ȳ[j] + ā[j], Val(N))
    H = ntuple(i -> _out(_rate, fs, i, g, t, z), Val(N))
    B = ntuple(i -> _arrivals_back(fs, āt, i, g, t, zero(eltype(āt))), Val(N))
    _rates_back!(fs, f̄s, x, L, H, B, ȳ, āt, g, t)
    x̄ = ntuple(Val(N)) do i
        E, gH, P = L[i]
        (E - P) * ȳ[i] + gH * B[i] + _shares_back(fs, āt, i, g, t, zero(gH))
    end
    return x̄, ntuple(_ -> zero(eltype(āt)), Val(N))
end

# `Σ_f p_f ā_to(f)` over the share flows out of compartment `i`.
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
_rate_back!(f::Flow{<:Amount}, f̄, x, L, H, B, ȳ, ā, g, t) = nothing
function _rate_back!(f::Flow{<:Rate}, f̄, x, L, H, B, ȳ, ā, g, t)
    i = f.from
    E, gH, _ = L[i]
    āto = f.to > 0 ? ā[f.to] : zero(eltype(ā))
    r̄ = x[i] * (gH * āto + _leave_slope(H[i], E, gH) * B[i] - E * ȳ[i])
    add_param!(cotangent(cotangent(f̄, :kind), :r), f.kind.r, r̄, g, t)
    return nothing
end
function _rate_back!(f::Flow{<:Linear}, f̄, x, L, H, B, ȳ, ā, g, t)
    i = f.from
    āto = f.to > 0 ? ā[f.to] : zero(eltype(ā))
    add_param!(cotangent(cotangent(f̄, :kind), :p), f.kind.p, x[i] * (āto - ȳ[i]), g, t)
    return nothing
end

# Each flow's parameter against the groups.
function _check_flow_groups(fs, G)
    for f in fs
        _check_kind_groups(f.kind, G)
    end
    return nothing
end
_check_kind_groups(k::Rate, G) = _check_param_strata(:r, k.r, G)
_check_kind_groups(k::Linear, G) = _check_param_strata(:p, k.p, G)
_check_kind_groups(k::Amount, G) = _check_param_strata(:a, k.a, G)

function _check_modifier_strata(m::Flows, S)
    _check_flow_groups(m.flows, _ngroups(blocks(m), S))
    return nothing
end

function forward(m::Flows, ::Init, s, history)
    _check_modifier_strata(m, length(s))
    fill!(s, zero(eltype(s)))
    return nothing
end
pullback!(grads, ::Flows, ::Init, s, history) = nothing
