# Depletion with flows and a protected pool. The flows move between the
# pools after each step's draw: removals are the first count flow, out of
# the pool or into a `Protected` pool. With a protected pool the draw
# takes from both pools in proportion to their susceptible mass `S + σ V`.

@doc raw"""
A protected pool for [`ComposableRecurrences.Depletion`](@ref): the
depletion's removals move into it, and it is drawn from at relative
susceptibility ``\sigma``.

At absolute time ``t``, for each stratum (one of the parallel series
computed together, such as a place or an age group) with unprotected pool
``u``, protected pool ``w``, step value ``v``, population ``N``,
heterogeneity ``\alpha`` and removals ``r_t``, the depletion form ``F``
draws from the effective pool ``P = u + \sigma w`` and the pools lose the
draw in proportion, then the removals move from ``u`` to ``w`` (with no
other flows):

```math
\begin{aligned}
(v', \cdot) &= F(v, P, N, \alpha) \\
u^{*} &= u - v' \frac{u}{P}, \qquad w^{*} = w - v' \frac{\sigma w}{P} \\
m &= \min\big(r_t, \max(u^{*}, 0)\big) \\
u' &= u^{*} - m, \qquad w' = w^{*} + \max(m, 0)
\end{aligned}
```

When ``P \le 0`` the draw comes from ``u`` alone, ``u^{*} = u - v'``.
A negative removal, such as births, adds to ``u`` and leaves ``w`` as it is.
A ``\sigma`` with ``0 \le \sigma \le 1`` gives protection, and
``\sigma > 1`` makes the protected pool more susceptible than ``u``.
With vaccine efficacy ``e``, ``\sigma = 0`` with removals ``e`` times the
doses gives all-or-nothing protection, and ``\sigma = 1 - e`` with removals
equal to the doses gives leaky protection.
A delay from dose to protection is a [`Convolution`](@ref) of the doses
before the call.
The removals are the depletion's first count flow,
`Flow(1 => 2, Amount(r))`, and its other `flows` move between the pools
too, with ``u`` as compartment 1 and ``w`` as compartment 2; rate and
share flows act on ``(u^{*}, w^{*})`` before the removals.
Waning protection at rate ``\omega`` is `flows = (Flow(2 => 1, ω),)`.
The derivative through ``\min`` and ``\max`` takes the active branch.
The depletion's state holds ``u`` for every stratum, then ``w``.

# Arguments
- `σ`: the relative susceptibility, one value or [`PerStratum`](@ref),
  constant over time.

# Keyword Arguments
- `pool0`: the starting protected pool, one value or `PerStratum`; `0` by
  default.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
doses = TimeVarying(fill(5.0, 10))
leaky = CR.Depletion(1000.0; removals = doses, protected = CR.Protected(0.3))
y = Recurrence([0.3, 0.5, 0.2]; modifiers = (leaky,))(fill(2.0, 10); history = [5.0])
round.(y; digits = 3)

# output

10-element Vector{Float64}:
  2.996
  6.73
  8.843
 12.765
 18.15
 25.033
 33.976
 44.517
 55.964
 66.668
```
"""
struct Protected{Σ, V0}
    "The relative susceptibility, one value or `PerStratum`."
    σ::Σ
    "The starting protected pool, one value or `PerStratum`."
    pool0::V0
end

function Protected(σ; pool0 = 0)
    σ = _float_param(_check_constant(:σ, σ))
    pool0 = _float_param(_check_constant(:pool0, pool0))
    return Protected{typeof(σ), typeof(pool0)}(σ, pool0)
end

# The removals as the first count flow, into the protected pool if there is
# one.
_removal_flows(::Nothing, protected) = ()
function _removal_flows(r, protected)
    to = protected === nothing ? 0 : 2
    return (Flow(1, to, Amount(_check_param(:removals, r))),)
end

# The `flows` keyword as a tuple of `Flow`s.
_pool_flows(fs::Tuple) = _flows_only(fs)
_pool_flows(fs::AbstractVector) = _flows_only(Tuple(fs))
_pool_flows(f::Flow) = (f,)
function _pool_flows(fs)
    throw(
        ArgumentError(
            "flows is a Flow, or a tuple or vector of Flows, got " *
                _describe(fs)
        )
    )
end
function _flows_only(fs)
    for f in fs
        f isa Flow || throw(
            ArgumentError("flows holds Flows, got $(_describe(f))")
        )
    end
    return fs
end

# The flows name the pool (1) and the protected pool (2) only.
function _check_pool_flows(fs, protected)
    isempty(fs) && return nothing
    n = protected === nothing ? 1 : 2
    top = _max_compartment(fs)
    top <= n || throw(
        ArgumentError(
            "the flows name compartment $top, but the depletion has $n " *
                "pool(s): the pool is 1 and a protected pool 2"
        )
    )
    return nothing
end

const _Flowing = Depletion{
    <:Any, <:Any, <:Any, <:Any, <:Tuple{Flow, Vararg{Flow}}, Nothing,
}
const _Protecting = Depletion{
    <:Any, <:Any, <:Any, <:Any, <:Tuple, <:Protected,
}

# The removal from what remains after the draw, `min(r, max(s, 0))`. The
# arms follow primal values, as in the pullback: a dual with value zero is
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

# Flows on the one pool: a pointwise step, the draw then the flows.
function forward(m::_Flowing, ::Step, v, s, t, k)
    y, s′ = forward(m.form, Step(), v, s, param(m.N, k, t), m.heterogeneity)
    (s″,) = _flow_only(m.flows, (s′,), k, t)
    return y, s″
end

function pullback!(grads, m::_Flowing, ::Step, v, s, t, k)
    m̄ = grads.piece
    N, α = param(m.N, k, t), m.heterogeneity
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
    add_param!(cotangent(m̄, :N), m.N, N̄, k, t)
    add_cotangent!(cotangent(m̄, :heterogeneity), ᾱ)
    return v̄, s̄
end

# With a protected pool each stratum has one value and two pools, the
# unprotected then the protected, so the step is blockwise: the state holds
# `S` then `V`, `2S` entries.
blocks(::_Protecting) = Val((1, 2))

function forward(m::_Protecting, ::Init, s, history)
    S = length(s) ÷ 2
    V = m.protected
    _check_param_strata(:N, m.N, S)
    _check_param_strata(:pool0, m.pool0, S)
    _check_flow_groups(m.flows, S)
    _check_param_strata(:σ, V.σ, S)
    _check_param_strata(:pool0, V.pool0, S)
    for k in 1:S
        s[k] = _pool0(m, k)
        s[S + k] = param(V.pool0, k, 1)
    end
    return nothing
end

function pullback!(grads, m::_Protecting, ::Init, s, history)
    S = length(s) ÷ 2
    s̄ = grads.s
    V̄0 = cotangent(cotangent(grads.piece, :protected), :pool0)
    for k in 1:S
        _add_pool0!(grads.piece, m, s̄[k], k)
        add_param!(V̄0, m.protected.pool0, s̄[S + k], k, 1)
    end
    return nothing
end

# One stratum's draw from both pools, and the pools after it.
function _protected_draw(form, v, Su, V, σ, N, α)
    P = Su + σ * V
    y, _ = forward(form, Step(), v, P, N, α)
    # `ifelse`, not `if`, so a traced `P` needs no branch; the guarded
    # division keeps the unused arm finite. The arm follows the primal `P`,
    # so a dual `P` with value zero takes the arm without the division.
    on = _primal_value(P) > 0
    q = y / ifelse(on, P, one(P))
    S′ = ifelse(on, Su - q * Su, Su - y)
    V′ = ifelse(on, V - q * σ * V, V)
    return y, S′, V′
end

# What a removal moves into the protected pool: a negative removal adds to
# the unprotected pool only. The arm follows the primal value.
_protects(m) = ifelse(_primal_value(m) < 0, zero(m), m)

function forward(m::_Protecting, ::Step, v::Tuple, s::Tuple, t, k)
    y, Su, V = _protected_draw(
        m.form, only(v), s[1], s[2], param(m.protected.σ, k, t),
        param(m.N, k, t), m.heterogeneity
    )
    pools = _flow_only(m.flows, (Su, V), k, t)
    return (y,), pools
end

# `v` and `s` are the stratum's incoming value and pools; returns the
# cotangents of the inputs from those of the output and of the pools after
# the step.
function pullback!(grads, m::_Protecting, ::Step, v, s, t, k)
    m̄ = grads.piece
    V̄ = cotangent(m̄, :protected)
    α = m.heterogeneity
    vk = only(v)
    Su, V = s
    σ, N = param(m.protected.σ, k, t), param(m.N, k, t)
    P = Su + σ * V
    y, _ = forward(m.form, Step(), vk, P, N, α)
    ȳ = only(grads.v)
    on = _primal_value(P) > 0
    q = on ? y / P : zero(y)
    S′ = on ? Su - q * Su : Su - y
    V′ = on ? V - q * σ * V : V
    z = zero(ȳ)
    S̄′, V̄′ = _flows_pullback(
        m.flows, cotangent(m̄, :flows), (S′, V′), grads.s, (z, z), k, t
    )
    if on
        q̄ = -S̄′ * Su - V̄′ * σ * V
        S̄u = S̄′ * (1 - q)
        V̄v = V̄′ * (1 - q * σ)
        σ̄ = -V̄′ * q * V
        ȳ += q̄ / P
        P̄ = -q̄ * q / P
    else
        S̄u, V̄v, σ̄ = S̄′, V̄′, zero(S̄′)
        ȳ -= S̄′
        P̄ = zero(S̄′)
    end
    v̄k, P̄f, N̄, ᾱ = _form_pullback(
        (; piece = cotangent(m̄, :form), v = ȳ, s = zero(ȳ)), m.form,
        vk, P, N, α
    )
    P̄ += P̄f
    add_param!(cotangent(m̄, :N), m.N, N̄, k, t)
    add_cotangent!(cotangent(m̄, :heterogeneity), ᾱ)
    add_param!(cotangent(V̄, :σ), m.protected.σ, σ̄ + V * P̄, k, t)
    return (v̄k,), (S̄u + P̄, V̄v + σ * P̄)
end
