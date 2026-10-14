# Flows between the compartments of each group. A `Flow` moves part of one
# compartment into another, or out, each step, by a form applied to its
# demand: a competing hazard rate (`Hazard()`, the default), a share
# (`Share()`) or a count capped by what is there (`Truncate()` or
# `SoftTruncate(κ)`). The rates out of one compartment compete; rates and
# shares act on the incoming compartments together, then the counts in
# flow order on what remains.

@doc raw"""
The share flow form: a [`ComposableRecurrences.Flow`](@ref) with this form
moves a share ``p`` of the compartment it leaves.

Flow ``f`` out of compartment ``i``, with demand ``p_f``, moves

```math
m_f = p_f\, x_i,
```

with ``x_i`` the compartment before the step's flows, alongside any
[`ComposableRecurrences.Hazard`](@ref) flows.
Shares out of one compartment that sum to more than ``e^{-H_i}``, with
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
A flow from compartment `from` into compartment `to`, or out of the
compartments with `to = 0`, that moves its `demand` by a form.

Each step it moves an amount ``m_f`` out of compartment `from` and into
`to`,

```math
x'_{\mathrm{from}} = x_{\mathrm{from}} - m_f, \qquad
x'_{\mathrm{to}} = x_{\mathrm{to}} + m_f,
```

with the form setting ``m_f`` from the demand ``d_f`` and the compartment
``x`` it leaves:

| form | demand | ``m_f`` |
|:---- |:------ |:------- |
| [`ComposableRecurrences.Hazard`](@ref) (the default) | a hazard rate | ``x\, d_f \big(1 - e^{-H}\big) / H``, with ``H`` the sum of the hazard rates out of ``x`` |
| [`ComposableRecurrences.Share`](@ref) | a share | ``d_f\, x`` |
| [`ComposableRecurrences.Truncate`](@ref) | a count | ``\min\big(d_f, \max(x, 0)\big)`` |
| [`ComposableRecurrences.SoftTruncate`](@ref) | a count | a smooth ``\min\big(d_f, \max(x, 0)\big)`` |

The hazard rates out of one compartment compete, as in the `Hazard`
depletion form, so together they move ``x (1 - e^{-H})``; with
non-negative, finite rates a non-negative compartment stays non-negative.
A per-step probability ``p < 1`` is the rate ``-\log(1 - p)``.
A `Hazard()` flow's demand is the rate itself, with no population and no
heterogeneity, where a `Hazard()` depletion draws the value divided by
its population `N`.
Hazard and share flows act on the compartments before the step's flows,
then each count flow, in the order given, on what remains
([`ComposableRecurrences.Flows`](@ref) gives the step).
A negative count adds ``-d_f`` to compartment `from`, without a cap, and
moves nothing into `to`.
The derivative through ``\min`` and ``\max`` takes the active branch.
Rates and shares are not checked: a time-varying or [`Derived`](@ref)
demand is only known at each step.

# Arguments
- `compartments`: `from => to`, numbered from 1, with `to = 0` to leave.
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
waning = CR.Flow(2 => 1, 0.1)
transfers = CR.Flow(1 => 0, 3.0; form = CR.Truncate())
waning.form, transfers.to

# output

(ComposableRecurrences.Hazard(), 0)
```
"""
struct Flow{D, F <: _FlowForm}
    "The compartment the flow leaves."
    from::Int
    "The compartment it enters, or `0` when it leaves."
    to::Int
    "The rate, share or count, a parameter."
    demand::D
    "How the demand moves: `Hazard()`, `Share()`, `Truncate()` or `SoftTruncate(κ)`."
    form::F
    function Flow(from::Integer, to::Integer, demand::D, form::F) where {D, F}
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
        form isa _FlowForm || throw(
            ArgumentError(
                "a flow's form is Hazard(), Share(), Truncate() or " *
                    "SoftTruncate(κ), got $(_describe(form))"
            )
        )
        return new{D, F}(from, to, _check_param(:demand, demand), form)
    end
end

function Flow(compartments::Pair{<:Integer, <:Integer}, demand; form = Hazard())
    return Flow(compartments.first, compartments.second, demand, form)
end
function Flow(compartments, demand; form = Hazard())
    throw(
        ArgumentError(
            "a flow joins compartments given as from => to, got " *
                _describe(compartments)
        )
    )
end

# A count flow, which moves its demand up to what the compartment holds.
const _Count = Flow{<:Any, <:_TruncateForm}

# The flows as a non-empty tuple of `Flow`s.
function _flow_tuple(fs)
    isempty(fs) && throw(ArgumentError("give at least one Flow, got none"))
    for f in fs
        f isa Flow || throw(ArgumentError("expected a Flow, got $(_describe(f))"))
    end
    return fs
end

# That the flows name no compartment beyond the `n` there are; `there`
# says which those are.
function _check_compartments(fs, n, there)
    top = maximum(f -> max(f.from, f.to), fs)
    top <= n || throw(
        ArgumentError("the flows name compartment $top, but $there")
    )
    return nothing
end

@doc raw"""
Moves the step's values between the compartments of each group by
[`ComposableRecurrences.Flow`](@ref)s.

The values hold ``n`` compartments of ``G`` groups each, compartment by
compartment ([`ComposableRecurrences.blocks`](@ref) is `Val((n, n))`): with
``S = nG`` strata, value ``(i - 1) G + g`` is compartment ``i`` of group
``g``, and a [`PerStratum`](@ref) parameter has ``G`` entries.
At absolute time ``t``, for each group with compartments ``x``, hazard
flows ``f`` at rates ``r_f`` and share flows at shares ``p_f``,

```math
\begin{aligned}
H_i &= \sum_{\mathrm{Hazard}\ f \text{ out of } i} r_f, \qquad
P_i = \sum_{\mathrm{Share}\ f \text{ out of } i} p_f, \\
m_f &= x_i\, r_f\, \frac{1 - e^{-H_i}}{H_i} \ \text{(Hazard)}, \qquad
m_f = x_i\, p_f \ \text{(Share)}, \\
y_j &= \big(e^{-H_j} - P_j\big) x_j + \sum_{f \text{ into } j} m_f,
\end{aligned}
```

then each count flow, with form [`ComposableRecurrences.Truncate`](@ref)
or [`ComposableRecurrences.SoftTruncate`](@ref), in the order given, moves
``m_f = \min(a_f, \max(y_i, 0))``, or its smooth version, out of
compartment ``i``.
The result is the value passed on, and the state holds what flowed into
each compartment at the step,

```math
s'_j = \sum_{f \text{ into } j} m_f,
```

where a negative count adds nothing.
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
        _check_compartments(flows, N, "compartments = $N")
        return new{N, F}(flows)
    end
end

function Flows(fs...; compartments = nothing)
    fs = _flow_tuple(fs)
    n = compartments === nothing ? maximum(f -> max(f.from, f.to), fs) :
        compartments
    return Flows{n isa Integer ? Int(n) : n}(fs)
end
ConstructionBase.constructorof(::Type{<:Flows{N}}) where {N} = Flows{N}

blocks(::Flows{N}) where {N} = Val((N, N))

# The hazard rate and share of a flow, zero for another form.
_rate(f::Flow{<:Any, Hazard}, g, t) = param(f.demand, g, t)
_rate(f::Flow, g, t) = false
_share(f::Flow{<:Any, Share}, g, t) = param(f.demand, g, t)
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

# What moves out of compartment `i` per unit held, `(e^{-H}, g(H), P)`.
function _leaves(fs, i, g, t, z)
    E, gH = _leave(_out(_rate, fs, i, g, t, z))
    return E, gH, _out(_share, fs, i, g, t, z)
end

# Add each hazard and share flow's amount into the compartment it enters, in
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

# A count `r` out of a compartment holding `s`, `min(r, max(s, 0))`; it is
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

# What a count moves into the compartment it enters: a negative count adds
# to the compartment it leaves only. The arm follows the primal value.
_moved_in(m) = ifelse(_primal_value(m) < 0, zero(m), m)

# What a count `a` moves out of a compartment holding `s`, and the
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

# The count flows in order on the compartments `y` and arrivals `a`.
_counts(::Tuple{}, y, a, g, t) = y, a
function _counts(fs::Tuple, y, a, g, t)
    y, a = _count(first(fs), y, a, g, t)
    return _counts(Base.tail(fs), y, a, g, t)
end
_count(f::Flow, y, a, g, t) = y, a
# One pass over the compartments, by `ifelse`: a flow out of the system
# (`to = 0`) adds to no compartment.
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

# One group's step: the compartments `x` after the flows, and arrivals.
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

# The compartments after the flows, without the arrivals.
_flow_only(fs::_Counts, x, g, t) = first(_counts(fs, x, nothing, g, t))
_flow_only(fs, x, g, t) = first(_flow_group(fs, x, g, t))

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
    x̄ = _flows_pullback(
        m.flows, cotangent(grads.piece, :flows), v, grads.v, grads.s, g, t
    )
    return x̄, ntuple(_ -> zero(eltype(x̄)), Val(N))
end

# The cotangent of one group's compartments `x` before the flows, from
# those of the compartments `ȳ` and arrivals `ā` after them; the flows'
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
    # The hazard and share arrivals feed both the compartments and the state.
    āt = ntuple(j -> ȳ[j] + ā[j], Val(N))
    H = ntuple(i -> _out(_rate, fs, i, g, t, z), Val(N))
    B = ntuple(i -> _arrivals_back(fs, āt, i, g, t, zero(eltype(āt))), Val(N))
    _rates_back!(fs, f̄s, x, L, H, B, ȳ, āt, g, t)
    return ntuple(Val(N)) do i
        E, gH, P = L[i]
        (E - P) * ȳ[i] + gH * B[i] + _shares_back(fs, āt, i, g, t, zero(gH))
    end
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
