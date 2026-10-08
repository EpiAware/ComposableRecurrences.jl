# Depletion with removals and a protected pool. Removals leave the pool
# after each step's draw, capped by what remains. With a `Protected` pool
# the removals move into it, and the draw takes from both pools in
# proportion to their susceptible mass `S + σ V`.

@doc raw"""
A protected pool for [`ComposableRecurrences.Depletion`](@ref): the
depletion's removals move into it, and it is drawn from at relative
susceptibility ``\sigma``.

At absolute time ``t``, for each stratum (one of the parallel series
computed together, such as a place or an age group) with unprotected pool
``u``, protected pool ``w``, step value ``v``, population ``N``,
heterogeneity ``\alpha`` and removals ``r_t``, the depletion form ``F``
draws from the effective pool ``P = u + \sigma w`` and the pools lose the
draw in proportion, then the removals move from ``u`` to ``w``:

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

const _Removing = Depletion{
    <:Any, <:Any, <:Any, <:Any,
    <:Union{Real, PerStratum, TimeVarying, Derived, Recent, _BoundRecent},
    Nothing,
}
const _Protecting = Depletion{
    <:Any, <:Any, <:Any, <:Any, <:Any, <:Protected,
}

# The removals at stratum `k` and time `t`; none without removals.
_removals_at(r, k, t) = param(r, k, t)
_removals_at(::Nothing, k, t) = false
_add_removals!(r̄, r, x, k, t) = add_param!(r̄, r, x, k, t)
_add_removals!(r̄, ::Nothing, x, k, t) = nothing

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

# Removals only: a pointwise step on the one pool.
function forward(m::_Removing, ::Step, v, s, t, k)
    y, s′ = forward(m.form, Step(), v, s, param(m.N, k, t), m.heterogeneity)
    return y, s′ - _removal(param(m.removals, k, t), s′)
end

function pullback!(grads, m::_Removing, ::Step, v, s, t, k)
    m̄ = grads.piece
    N, α, r = param(m.N, k, t), m.heterogeneity, param(m.removals, k, t)
    _, s′ = forward(m.form, Step(), v, s, N, α)
    r̄, s̄m = _removal_pullback(r, s′, -grads.s)
    add_param!(cotangent(m̄, :removals), m.removals, r̄, k, t)
    v̄, s̄, N̄, ᾱ = _form_pullback(
        (; piece = cotangent(m̄, :form), v = grads.v, s = grads.s + s̄m),
        m.form, v, s, N, α
    )
    add_param!(cotangent(m̄, :N), m.N, N̄, k, t)
    add_cotangent!(cotangent(m̄, :heterogeneity), ᾱ)
    return v̄, s̄
end

# With a protected pool the state holds `S` then `V`, `2S` entries, and a
# step reads both, so the step is vector-level.
ispointwise(::_Protecting) = false
nstate(::_Protecting, S) = 2S

function forward(m::_Protecting, ::Init, s, history)
    S = length(s) ÷ 2
    V = m.protected
    _check_param_strata(:N, m.N, S)
    _check_param_strata(:pool0, m.pool0, S)
    _check_param_strata(:removals, m.removals, S)
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

# One stratum's step: the draw, the pools after it and after the removal.
function _protected_step(form, v, Su, V, σ, N, α, r)
    P = Su + σ * V
    y, _ = forward(form, Step(), v, P, N, α)
    # `ifelse`, not `if`, so a traced `P` needs no branch; the guarded
    # division keeps the unused arm finite. The arm follows the primal `P`,
    # so a dual `P` with value zero takes the arm without the division.
    on = _primal_value(P) > 0
    q = y / ifelse(on, P, one(P))
    S′ = ifelse(on, Su - q * Su, Su - y)
    V′ = ifelse(on, V - q * σ * V, V)
    mr = _removal(r, S′)
    return y, S′ - mr, V′ + _protects(mr)
end

# What a removal moves into the protected pool: a negative removal adds to
# the unprotected pool only. The arm follows the primal value.
_protects(m) = ifelse(_primal_value(m) < 0, zero(m), m)

function forward(m::_Protecting, ::Step, v, s, t)
    S = length(v)
    α = m.heterogeneity
    for k in 1:S
        y, s[k], s[S + k] = _protected_step(
            m.form, v[k], s[k], s[S + k], param(m.protected.σ, k, t),
            param(m.N, k, t), α, _removals_at(m.removals, k, t)
        )
        v[k] = y
    end
    return nothing
end

# `v` and `s` are the step's incoming values; the cotangents of the output
# and of the state after the step are overwritten by those of the inputs.
function pullback!(grads, m::_Protecting, ::Step, v, s, t)
    S = length(v)
    v̄, s̄ = grads.v, grads.s
    m̄ = grads.piece
    V̄ = cotangent(m̄, :protected)
    α = m.heterogeneity
    for k in 1:S
        Su, V = s[k], s[S + k]
        σ, N = param(m.protected.σ, k, t), param(m.N, k, t)
        r = _removals_at(m.removals, k, t)
        P = Su + σ * V
        y, _ = forward(m.form, Step(), v[k], P, N, α)
        ȳ, S̄″, V̄″ = v̄[k], s̄[k], s̄[S + k]
        on = _primal_value(P) > 0
        q = on ? y / P : zero(y)
        S′ = on ? Su - q * Su : Su - y
        mr = _removal(r, S′)
        V̄m = ifelse(_primal_value(mr) < 0, zero(V̄″), V̄″)
        r̄, S̄m = _removal_pullback(r, S′, V̄m - S̄″)
        _add_removals!(cotangent(m̄, :removals), m.removals, r̄, k, t)
        S̄′ = S̄″ + S̄m
        V̄′ = V̄″
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
            v[k], P, N, α
        )
        P̄ += P̄f
        add_param!(cotangent(m̄, :N), m.N, N̄, k, t)
        add_cotangent!(cotangent(m̄, :heterogeneity), ᾱ)
        add_param!(cotangent(V̄, :σ), m.protected.σ, σ̄ + V * P̄, k, t)
        v̄[k] = v̄k
        s̄[k] = S̄u + P̄
        s̄[S + k] = V̄v + σ * P̄
    end
    return nothing
end
