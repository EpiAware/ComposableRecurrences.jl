# The tutorials' hand loops with hand-written Mooncake rules, timed by the
# benchmark matrix as the `handrule` arm beside each tutorial case's `loop`
# arm. The forward passes are the hand loops of
# `test/ADFixtures/src/matrix_naive.jl`, keeping what their reverse passes
# read. As in `bvd_handrule.jl`, the rules are Mooncake rules only: every
# other backend differentiates the loops themselves.
#
# Included by `test/ADFixtures/src/matrix_cases.jl` inside `MatrixCases`.
module TutorialHandRule

import Mooncake
using Mooncake: CoDual, NoRData, primal, tangent

export ar2_handrule, depletion_handrule, imports_handrule, transform_handrule,
    delay_primary_handrule, outcomes_handrule, forecast_handrule,
    reproduction_handrule, waning_handrule, routes_handrule, ward_handrule,
    overview_handrule

const _Vec = Vector{Float64}
const _Mat = Matrix{Float64}
const _Ints = Vector{Int}

# ---- AR(2) ------------------------------------------------------------------

@doc raw"""
    ar2_handrule(φ, h, ϵ)

An AR(2) process from two past values `h`, the latest last:
``z_t = φ_1 z_{t-1} + φ_2 z_{t-2} + ϵ_t``. Returns ``z_1, …, z_T``.
"""
function ar2_handrule(φ, h, ϵ)
    V = promote_type(eltype(φ), eltype(h), eltype(ϵ))
    y = similar(ϵ, V)
    a, b = V(h[1]), V(h[2])
    for t in eachindex(ϵ)
        a, b = b, φ[1] * b + φ[2] * a + ϵ[t]
        y[t] = b
    end
    return y
end

Mooncake.@is_primitive(
    Mooncake.DefaultCtx, Tuple{typeof(ar2_handrule), _Vec, _Vec, _Vec}
)
function Mooncake.rrule!!(
        ::CoDual{typeof(ar2_handrule)}, φ::CoDual{_Vec}, h::CoDual{_Vec},
        ϵ::CoDual{_Vec}
    )
    φp, hp = primal(φ), primal(h)
    y = ar2_handrule(φp, hp, primal(ϵ))
    ȳ = zero(y)
    # From the last day back, `z̄_t` reaches `ϵ_t`, both weights and the two
    # days before it; the seed takes what reaches days 0 and -1.
    function ar2_handrule_pb(::NoRData)
        φ̄, h̄, ϵ̄ = tangent(φ), tangent(h), tangent(ϵ)
        T = length(y)
        z(t) = t >= 1 ? y[t] : hp[t + 2]
        c1, c2 = 0.0, 0.0
        for t in T:-1:1
            zt = ȳ[t] + c1
            ϵ̄[t] += zt
            φ̄[1] += zt * z(t - 1)
            φ̄[2] += zt * z(t - 2)
            c1, c2 = c2 + φp[1] * zt, φp[2] * zt
        end
        h̄[2] += c1
        h̄[1] += c2
        return NoRData(), NoRData(), NoRData(), NoRData()
    end
    return CoDual(y, ȳ), ar2_handrule_pb
end

# ---- seeded renewal with hazard depletion -----------------------------------

# The seeded renewal of the renewal and imports tutorials. From `pool0`, day
# `t` draws `P (1 − e^{-x})` with `x = (R_t f_t + b_t) / N`, `f_t` the
# renewal sum, takes it from the pool and adds `a_t` on top. Returns the
# buffer, seed first, the pool before each day and each day's renewal sum.
function _hazard_state(g, seed, R, before, after, N, pool0)
    m, T, L = length(seed), length(R), length(g)
    V = promote_type(
        eltype(g), eltype(seed), eltype(R), eltype(before), eltype(after),
        typeof(pool0)
    )
    y = zeros(V, m + T)
    y[1:m] .= seed
    P = zeros(V, T)
    F = zeros(V, T)
    pool = V(pool0)
    for t in 1:T
        f = zero(V)
        for l in 1:L
            f += g[l] * y[m + t - l]
        end
        F[t] = f
        P[t] = pool
        drawn = -pool * expm1(-(R[t] * f + before[t]) / N)
        pool -= drawn
        y[m + t] = drawn + after[t]
    end
    return (; y, P, F)
end

# The reverse of `_hazard_state`, from the last day back. With `P̄` the
# cotangent of the pool after day `t`, day `t` gives
# `x̄ = P_{t-1} e^{-x} (ȳ_t − P̄)` and `P̄ ← ȳ_t (1 − e^{-x}) + P̄ e^{-x}`;
# `x̄` reaches `R_t`, `b_t`, `N` and, through the renewal sum, `g` and earlier
# days. Returns the cotangents of `pool0` and of `N` through the hazard.
function _hazard_back!(ḡ, seed̄, R̄, b̄, ā, ȳ, st, g, R, before, N)
    (; y, P, F) = st
    T, L = length(R), length(g)
    m = length(y) - T
    P̄, N̄ = 0.0, 0.0
    for t in T:-1:1
        x = (R[t] * F[t] + before[t]) / N
        e = exp(-x)
        yt = ȳ[m + t]
        ā[t] += yt
        x̄ = P[t] * e * (yt - P̄)
        P̄ = -yt * expm1(-x) + P̄ * e
        xn = x̄ / N
        R̄[t] += xn * F[t]
        b̄[t] += xn
        N̄ -= xn * x
        f̄ = xn * R[t]
        for l in 1:L
            ḡ[l] += f̄ * y[m + t - l]
            ȳ[m + t - l] += f̄ * g[l]
        end
    end
    for j in 1:m
        seed̄[j] += ȳ[j]
    end
    return P̄, N̄
end

# The output's cotangent placed after the seed in a buffer for the reverse.
function _seeded_cotangent(ō, m)
    ȳ = zeros(m + length(ō))
    ȳ[(m + 1):end] .= ō
    return ȳ
end

@doc raw"""
    depletion_handrule(g, seed, R, N)

Seeded renewal with hazard depletion from a pool of `max(N − Σ seed, 0)`:
``I_t = P_{t-1} (1 - e^{-R_t f_t / N})``, with ``f_t`` the renewal sum.
Returns the days after the seed.
"""
function depletion_handrule(g, seed, R, N)
    z = zeros(promote_type(eltype(R), typeof(N)), length(R))
    pool0 = max(N - sum(seed), zero(N - sum(seed)))
    st = _hazard_state(g, seed, R, z, z, N, pool0)
    return st.y[(length(seed) + 1):end]
end

Mooncake.@is_primitive(
    Mooncake.DefaultCtx,
    Tuple{typeof(depletion_handrule), _Vec, _Vec, _Vec, Float64}
)
function Mooncake.rrule!!(
        ::CoDual{typeof(depletion_handrule)}, g::CoDual{_Vec},
        seed::CoDual{_Vec}, R::CoDual{_Vec}, N::CoDual{Float64}
    )
    gp, sp, Rp, Np = primal(g), primal(seed), primal(R), primal(N)
    m, T = length(sp), length(Rp)
    z = zeros(T)
    left = Np - sum(sp)
    st = _hazard_state(gp, sp, Rp, z, z, Np, max(left, 0.0))
    y = st.y[(m + 1):end]
    ō = zero(y)
    function depletion_handrule_pb(::NoRData)
        seed̄ = tangent(seed)
        P̄, N̄ = _hazard_back!(
            tangent(g), seed̄, tangent(R), zeros(T), zeros(T),
            _seeded_cotangent(ō, m), st, gp, Rp, z, Np
        )
        if left > 0
            N̄ += P̄
            seed̄ .-= P̄
        end
        return NoRData(), NoRData(), NoRData(), NoRData(), N̄
    end
    return CoDual(y, ō), depletion_handrule_pb
end

@doc raw"""
    imports_handrule(g, seed, R, before, after, N)

Seeded renewal with hazard depletion from a pool of `N`, with imports
`before` the draw, taken from the pool, and `after` it, added on top:
``I_t = P_{t-1} (1 - e^{-(R_t f_t + b_t) / N}) + a_t``.
Returns the days after the seed.
"""
function imports_handrule(g, seed, R, before, after, N)
    st = _hazard_state(g, seed, R, before, after, N, N)
    return st.y[(length(seed) + 1):end]
end

Mooncake.@is_primitive(
    Mooncake.DefaultCtx,
    Tuple{typeof(imports_handrule), _Vec, _Vec, _Vec, _Vec, _Vec, Float64}
)
function Mooncake.rrule!!(
        ::CoDual{typeof(imports_handrule)}, g::CoDual{_Vec},
        seed::CoDual{_Vec}, R::CoDual{_Vec}, before::CoDual{_Vec},
        after::CoDual{_Vec}, N::CoDual{Float64}
    )
    gp, sp, Rp, bp, Np = primal(g), primal(seed), primal(R), primal(before),
        primal(N)
    m = length(sp)
    st = _hazard_state(gp, sp, Rp, bp, primal(after), Np, Np)
    y = st.y[(m + 1):end]
    ō = zero(y)
    function imports_handrule_pb(::NoRData)
        P̄, N̄ = _hazard_back!(
            tangent(g), tangent(seed), tangent(R), tangent(before),
            tangent(after), _seeded_cotangent(ō, m), st, gp, Rp, bp, Np
        )
        return (ntuple(_ -> NoRData(), 6)..., N̄ + P̄)
    end
    return CoDual(y, ō), imports_handrule_pb
end

# ---- multi-type extinction by generation ------------------------------------

# The negative binomial probability generating function.
_nb(v, r, p) = (p / (1 - (1 - p) * v))^r

# The transform tutorial's loop keeping each step's renewal sums `Q` and
# mixed sums `M`, as in `loop_transform`.
function _transform_state(g, K, r, p, T)
    S, L = length(r), length(g)
    V = promote_type(eltype(g), eltype(K), eltype(r), eltype(p))
    y = zeros(V, S, L + T)
    Q = zeros(V, S, T)
    M = zeros(V, S, T)
    for t in 1:T
        for k in 1:S
            acc = zero(V)
            for l in 1:L
                acc += g[l] * y[k, L + t - l]
            end
            Q[k, t] = acc
        end
        for a in 1:S
            v = zero(V)
            for b in 1:S
                v += K[a, b] * Q[b, t]
            end
            M[a, t] = v
            y[a, L + t] = _nb(v, r[a], p[a])
        end
    end
    return (; y, Q, M)
end

@doc raw"""
    transform_handrule(g, K, r, p, T)

Multi-type extinction by generation from a zero history: each stratum's
renewal sum ``q_t``, mixed by `K`, through stratum `a`'s negative binomial
probability generating function,
``y_{a,t} = \left(p_a / (1 - (1 - p_a) (K q_t)_a)\right)^{r_a}``.
Returns strata × `T`.
"""
function transform_handrule(g, K, r, p, T)
    return _transform_state(g, K, r, p, T).y[:, (length(g) + 1):end]
end

Mooncake.@is_primitive(
    Mooncake.DefaultCtx,
    Tuple{typeof(transform_handrule), _Vec, _Mat, _Vec, _Vec, Int}
)
function Mooncake.rrule!!(
        ::CoDual{typeof(transform_handrule)}, g::CoDual{_Vec}, K::CoDual{_Mat},
        r::CoDual{_Vec}, p::CoDual{_Vec}, T::CoDual{Int}
    )
    gp, Kp, rp, pp, Tp = primal(g), primal(K), primal(r), primal(p), primal(T)
    S, L = length(rp), length(gp)
    st = _transform_state(gp, Kp, rp, pp, Tp)
    y = st.y[:, (L + 1):end]
    ō = zero(y)
    # From the last step back: each output's cotangent reaches its stratum's
    # `r` and `p` and its mixed sum, which `Kᵀ` takes back to the renewal
    # sums, and those reach `g` and the earlier steps.
    function transform_handrule_pb(::NoRData)
        ḡ, K̄, r̄, p̄ = tangent(g), tangent(K), tangent(r), tangent(p)
        (; Q, M) = st
        Y = st.y
        Ȳ = zeros(S, L + Tp)
        Ȳ[:, (L + 1):end] .= ō
        v̄ = zeros(S)
        for t in Tp:-1:1
            for a in 1:S
                v, ya, yb = M[a, t], Y[a, L + t], Ȳ[a, L + t]
                D = 1 - (1 - pp[a]) * v
                v̄[a] = yb * rp[a] * ya * (1 - pp[a]) / D
                r̄[a] += yb * ya * log(pp[a] / D)
                p̄[a] += yb * rp[a] * ya * (1 - v) / (pp[a] * D)
            end
            for b in 1:S
                q̄ = 0.0
                for a in 1:S
                    K̄[a, b] += v̄[a] * Q[b, t]
                    q̄ += Kp[a, b] * v̄[a]
                end
                for l in 1:L
                    ḡ[l] += q̄ * Y[b, L + t - l]
                    Ȳ[b, L + t - l] += q̄ * gp[l]
                end
            end
        end
        return ntuple(_ -> NoRData(), 6)
    end
    return CoDual(y, ō), transform_handrule_pb
end

# ---- time-varying delay by input time ---------------------------------------

# The delay of `delay_primary_handrule`: `G[k, d + 1, s]` weights stratum
# `k`'s input at time `s` reaching time `s + d`.
function _delay_primary(G, X)
    S, L, T = size(G)
    y = zeros(promote_type(eltype(G), eltype(X)), S, T)
    for t in 1:T, k in 1:S
        acc = zero(eltype(y))
        for d in 0:min(L - 1, t - 1)
            acc += G[k, d + 1, t - d] * X[k, t - d]
        end
        y[k, t] = acc
    end
    return y
end

# The weights and inputs held in `θ`, weights first, as `S × L × T` and
# `S × T` arrays.
function _delay_primary_blocks(θ, S, L, T)
    n = S * L * T
    G = reshape(view(θ, 1:n), S, L, T)
    X = reshape(view(θ, (n + 1):(n + S * T)), S, T)
    return G, X
end

@doc raw"""
    delay_primary_handrule(θ, S, L, T)

A delay per stratum and input time, from `θ` holding the weights `G`, an
`S × L × T` array, then the inputs `X`, an `S × T` array: `G[k, d + 1, s]`
weights stratum `k`'s input at time `s` reaching time `s + d`,
``y_{k,t} = \sum_{d} G_{k,d+1,t-d} X_{k,t-d}``. Returns strata × time.
It takes the parameter vector whole, as a reverse pass over copies of
its `S L T` weights would cost more than the rule.
"""
function delay_primary_handrule(θ, S, L, T)
    return _delay_primary(_delay_primary_blocks(θ, S, L, T)...)
end

Mooncake.@is_primitive(
    Mooncake.DefaultCtx,
    Tuple{typeof(delay_primary_handrule), _Vec, Int, Int, Int}
)
function Mooncake.rrule!!(
        ::CoDual{typeof(delay_primary_handrule)}, θ::CoDual{_Vec},
        S::CoDual{Int}, L::CoDual{Int}, T::CoDual{Int}
    )
    dims = (primal(S), primal(L), primal(T))
    G, X = _delay_primary_blocks(primal(θ), dims...)
    y = _delay_primary(G, X)
    ȳ = zero(y)
    # Each input time `s` reaches times `s` to `s + L - 1`: its weights take
    # the input times those days' cotangents, and the input their weighted
    # sum.
    function delay_primary_handrule_pb(::NoRData)
        Ḡ, X̄ = _delay_primary_blocks(tangent(θ), dims...)
        Sp, Lp, Tp = dims
        for s in 1:Tp, d in 0:min(Lp - 1, Tp - s), k in 1:Sp
            yb = ȳ[k, s + d]
            Ḡ[k, d + 1, s] += yb * X[k, s]
            X̄[k, s] += yb * G[k, d + 1, s]
        end
        return ntuple(_ -> NoRData(), 5)
    end
    return CoDual(y, ȳ), delay_primary_handrule_pb
end

# ---- clinical outcomes as a chain of delays ---------------------------------

# A delay of `x`, lag 0 first, with no history.
function _delay(d, x)
    y = zeros(promote_type(eltype(d), eltype(x)), length(x))
    for t in eachindex(y)
        acc = zero(eltype(y))
        for i in 1:min(length(d), t)
            acc += d[i] * x[t - i + 1]
        end
        y[t] = acc
    end
    return y
end

# The reverse of `_delay`: `ū` is the cotangent of its output.
function _delay_back!(d̄, x̄, ū, d, x)
    for t in eachindex(ū), i in 1:min(length(d), t)
        d̄[i] += ū[t] * x[t - i + 1]
        x̄[t - i + 1] += ū[t] * d[i]
    end
    return nothing
end

@doc raw"""
    outcomes_handrule(d1, d2, d3, p, x)

Onsets as `x` delayed by `d1`, admissions as onsets delayed by `d2` times
`p[1]`, and deaths as admissions delayed by `d3` times `p[2]`. Returns time
× 2, admissions then deaths.
"""
function outcomes_handrule(d1, d2, d3, p, x)
    onsets = _delay(d1, x)
    admissions = p[1] .* _delay(d2, onsets)
    deaths = p[2] .* _delay(d3, admissions)
    return hcat(admissions, deaths)
end

Mooncake.@is_primitive(
    Mooncake.DefaultCtx,
    Tuple{typeof(outcomes_handrule), _Vec, _Vec, _Vec, _Vec, _Vec}
)
function Mooncake.rrule!!(
        ::CoDual{typeof(outcomes_handrule)}, d1::CoDual{_Vec},
        d2::CoDual{_Vec}, d3::CoDual{_Vec}, p::CoDual{_Vec}, x::CoDual{_Vec}
    )
    d1p, d2p, d3p, pp, xp = primal(d1), primal(d2), primal(d3), primal(p),
        primal(x)
    onsets = _delay(d1p, xp)
    c2 = _delay(d2p, onsets)
    admissions = pp[1] .* c2
    c3 = _delay(d3p, admissions)
    y = hcat(admissions, pp[2] .* c3)
    ȳ = zero(y)
    # Deaths back to admissions, admissions back to onsets, onsets back to
    # infections; each gain takes its cotangent times the unscaled delay.
    function outcomes_handrule_pb(::NoRData)
        p̄ = tangent(p)
        T = length(xp)
        D̄ = ȳ[:, 2]
        p̄[2] += sum(D̄ .* c3)
        Ā = ȳ[:, 1]
        _delay_back!(tangent(d3), Ā, pp[2] .* D̄, d3p, admissions)
        p̄[1] += sum(Ā .* c2)
        Ō = zeros(T)
        _delay_back!(tangent(d2), Ō, pp[1] .* Ā, d2p, onsets)
        _delay_back!(tangent(d1), tangent(x), Ō, d1p, xp)
        return ntuple(_ -> NoRData(), 6)
    end
    return CoDual(y, ȳ), outcomes_handrule_pb
end

# ---- renewal forecast -------------------------------------------------------

# The seeded renewal over every day in one pass, keeping each day's renewal
# sum.
function _forecast_state(g, seed, R)
    m, T, L = length(seed), length(R), length(g)
    V = promote_type(eltype(g), eltype(seed), eltype(R))
    y = zeros(V, m + T)
    y[1:m] .= seed
    F = zeros(V, T)
    for t in 1:T
        f = zero(V)
        for l in 1:L
            f += g[l] * y[m + t - l]
        end
        F[t] = f
        y[m + t] = R[t] * f
    end
    return (; y, F)
end

@doc raw"""
    forecast_handrule(g, seed, R)

The seeded renewal ``I_t = R_t \sum_l g_l I_{t-l}`` over every day in one
pass, as a forecast continues the fitted run. Returns the days after the
seed.
"""
function forecast_handrule(g, seed, R)
    return _forecast_state(g, seed, R).y[(length(seed) + 1):end]
end

Mooncake.@is_primitive(
    Mooncake.DefaultCtx, Tuple{typeof(forecast_handrule), _Vec, _Vec, _Vec}
)
function Mooncake.rrule!!(
        ::CoDual{typeof(forecast_handrule)}, g::CoDual{_Vec},
        seed::CoDual{_Vec}, R::CoDual{_Vec}
    )
    gp, sp, Rp = primal(g), primal(seed), primal(R)
    m = length(sp)
    st = _forecast_state(gp, sp, Rp)
    y = st.y[(m + 1):end]
    ō = zero(y)
    # From the last day back, each day's cotangent reaches `R_t` and, through
    # the renewal sum, `g` and the days before it.
    function forecast_handrule_pb(::NoRData)
        ḡ, seed̄, R̄ = tangent(g), tangent(seed), tangent(R)
        (; F) = st
        Y = st.y
        T, L = length(Rp), length(gp)
        ȳ = _seeded_cotangent(ō, m)
        for t in T:-1:1
            yt = ȳ[m + t]
            R̄[t] += yt * F[t]
            f̄ = yt * Rp[t]
            for l in 1:L
                ḡ[l] += f̄ * Y[m + t - l]
                ȳ[m + t - l] += f̄ * gp[l]
            end
        end
        for j in 1:m
            seed̄[j] += ȳ[j]
        end
        return NoRData(), NoRData(), NoRData(), NoRData()
    end
    return CoDual(y, ō), forecast_handrule_pb
end

# ---- effective reproduction number ------------------------------------------

# The renewal sum of stratum `k` at step `t` of a buffer whose first `m`
# columns are the seed.
function _renewal_sum(g, y, k, m, t)
    acc = zero(eltype(y))
    for l in eachindex(g)
        acc += g[l] * y[k, m + t - l]
    end
    return acc
end

# The towns' depleted run from the seed's columns, keeping each day's
# renewal sums `P`, mixed sums `Q` and the pools before the draw.
function _reproduction_state(g, R, seed, K, pop)
    S, T = size(R)
    m = size(seed, 2)
    V = promote_type(
        eltype(g), eltype(R), eltype(seed), eltype(K), eltype(pop)
    )
    y = zeros(V, S, m + T)
    y[:, 1:m] .= seed
    P = zeros(V, S, T)
    Q = zeros(V, S, T)
    pools = zeros(V, S, T)
    pool = V.(pop)
    for t in 1:T
        for k in 1:S
            P[k, t] = _renewal_sum(g, y, k, m, t)
        end
        for a in 1:S
            q = zero(V)
            for b in 1:S
                q += K[a, b] * P[b, t]
            end
            Q[a, t] = q
            pools[a, t] = pool[a]
            drawn = -pool[a] * expm1(-R[a, t] * q / pop[a])
            pool[a] -= drawn
            y[a, m + t] = drawn
        end
    end
    return (; y, P, Q, pools)
end

# The reverse of `_reproduction_state` from the last day back. `Ī` holds
# the cotangents of the draws, seed columns first, and gains those of the
# seed; `ȳ` is the cotangent of each draw over its mixed sum, or `nothing`.
function _reproduction_back!(ḡ, R̄, K̄, pop̄, Ī, ȳ, st, g, R, K, pop, m)
    (; P, Q, pools) = st
    Y = st.y
    S, T = size(R)
    pool̄, q̄ = zeros(S), zeros(S)
    for t in T:-1:1
        for a in 1:S
            q, drawn = Q[a, t], Y[a, m + t]
            r̄ = ȳ === nothing ? 0.0 : ȳ[a, t] / q
            d̄ = Ī[a, m + t] + r̄ - pool̄[a]
            x = R[a, t] * q / pop[a]
            x̄ = d̄ * pools[a, t] * exp(-x)
            pool̄[a] -= d̄ * expm1(-x)
            xn = x̄ / pop[a]
            R̄[a, t] += xn * q
            pop̄[a] -= xn * x
            q̄[a] = xn * R[a, t] - r̄ * drawn / q
        end
        for b in 1:S
            p̄ = 0.0
            for a in 1:S
                K̄[a, b] += q̄[a] * P[b, t]
                p̄ += K[a, b] * q̄[a]
            end
            for l in eachindex(g)
                ḡ[l] += p̄ * Y[b, m + t - l]
                Ī[b, m + t - l] += p̄ * g[l]
            end
        end
    end
    pop̄ .+= pool̄
    return nothing
end

@doc raw"""
    reproduction_handrule(g, R, seed, K, pop)

The effective reproduction number of a depleted run over strata coupled by
`K`: each day's infections over the mixed renewal sum they come from,
``I_{a,t} / q_{a,t}`` with ``q_t = K p_t``, ``p_t`` the renewal sums and
``I_{a,t} = U_{a,t} (1 - e^{-R_{a,t} q_{a,t} / N_a})``, with ``U_{a,t}`` the
pool before day ``t``'s draw, starting at `pop`. Returns strata × time.
"""
function reproduction_handrule(g, R, seed, K, pop)
    st = _reproduction_state(g, R, seed, K, pop)
    m = size(seed, 2)
    return st.y[:, (m + 1):end] ./ st.Q
end

Mooncake.@is_primitive(
    Mooncake.DefaultCtx,
    Tuple{typeof(reproduction_handrule), _Vec, _Mat, _Mat, _Mat, _Vec}
)
function Mooncake.rrule!!(
        ::CoDual{typeof(reproduction_handrule)}, g::CoDual{_Vec},
        R::CoDual{_Mat}, seed::CoDual{_Mat}, K::CoDual{_Mat},
        pop::CoDual{_Vec}
    )
    gp, Rp, Kp, popp = primal(g), primal(R), primal(K), primal(pop)
    m = size(primal(seed), 2)
    st = _reproduction_state(gp, Rp, primal(seed), Kp, popp)
    y = st.y[:, (m + 1):end] ./ st.Q
    ȳ = zero(y)
    function reproduction_handrule_pb(::NoRData)
        Ī = zeros(size(st.y))
        _reproduction_back!(
            tangent(g), tangent(R), tangent(K), tangent(pop), Ī, ȳ, st, gp,
            Rp, Kp, popp, m
        )
        tangent(seed) .+= view(Ī, :, 1:m)
        return ntuple(_ -> NoRData(), 6)
    end
    return CoDual(y, ȳ), reproduction_handrule_pb
end

# ---- leaky vaccination with waning ------------------------------------------

# The vaccination tutorial's loop, keeping what the reverse pass needs.
function _waning_state(g, h, R, doses, σ, ω, N)
    S, T = size(R)
    m = size(h, 2)
    V = promote_type(
        eltype(g), eltype(h), eltype(R), eltype(doses), typeof(σ),
        eltype(ω), eltype(N)
    )
    y = zeros(V, S, m + T)
    y[:, 1:m] .= h
    F, sus0, pro0 = zeros(V, S, T), zeros(V, S, T), zeros(V, S, T)
    s2s = zeros(V, S, T)
    sus, pro = V.(N), zeros(V, S)
    for t in 1:T, k in 1:S
        f = _renewal_sum(g, y, k, m, t)
        F[k, t], sus0[k, t], pro0[k, t] = f, sus[k], pro[k]
        P = sus[k] + σ * pro[k]
        drawn = -P * expm1(-R[k, t] * f / N[k])
        s = sus[k] - drawn * sus[k] / P
        v = pro[k] - drawn * σ * pro[k] / P
        waned = -v * expm1(-ω[k, t])
        s += waned
        v -= waned
        s2s[k, t] = s
        moved = min(doses[k, t], max(s, zero(V)))
        sus[k] = s - moved
        pro[k] = v + moved
        y[k, m + t] = drawn
    end
    return (; y, F, sus0, pro0, s2s)
end

@doc raw"""
    waning_handrule(g, h, R, doses, σ, ω, N)

Leaky vaccination with waning, per stratum: infections drawn by hazard from
``S + σ V``, then waning moves ``V`` back to ``S`` at rate ``ω``, then the
doses move ``S`` into ``V``, capped by what ``S`` holds. Returns strata ×
time.
"""
function waning_handrule(g, h, R, doses, σ, ω, N)
    return _waning_state(g, h, R, doses, σ, ω, N).y[:, (size(h, 2) + 1):end]
end

Mooncake.@is_primitive(
    Mooncake.DefaultCtx,
    Tuple{typeof(waning_handrule), _Vec, _Mat, _Mat, _Mat, Float64, _Mat, _Vec}
)
function Mooncake.rrule!!(
        ::CoDual{typeof(waning_handrule)}, g::CoDual{_Vec}, h::CoDual{_Mat},
        R::CoDual{_Mat}, doses::CoDual{_Mat}, σ::CoDual{Float64},
        ω::CoDual{_Mat}, N::CoDual{_Vec}
    )
    gp, hp, Rp, dp, σp, ωp, Np = primal(g), primal(h), primal(R),
        primal(doses), primal(σ), primal(ω), primal(N)
    m = size(hp, 2)
    st = _waning_state(gp, hp, Rp, dp, σp, ωp, Np)
    y = st.y[:, (m + 1):end]
    ȳ = zero(y)
    function waning_handrule_pb(::NoRData)
        ḡ, h̄, R̄, d̄, ω̄, N̄ = tangent(g), tangent(h), tangent(R),
            tangent(doses), tangent(ω), tangent(N)
        (; F, sus0, pro0, s2s) = st
        Y = st.y
        S, T = size(Rp)
        Ȳ = zeros(S, m + T)
        Ȳ[:, (m + 1):end] .= ȳ
        σ̄ = 0.0
        for k in 1:S
            s̄, p̄ = 0.0, 0.0
            for t in T:-1:1
                sus, pro, f = sus0[k, t], pro0[k, t], F[k, t]
                x = Rp[k, t] * f / Np[k]
                e = expm1(-x)
                v = pro * (1 + σp * e)
                eω = exp(-ωp[k, t])
                s2 = s2s[k, t]
                # The doses moved: the one taken by `min(doses, max(s2, 0))`.
                c = 0 > s2 ? 0.0 : s2
                m̄ = p̄ - s̄
                s̄2, v̄2 = s̄, p̄
                if c < dp[k, t]
                    0 > s2 || (s̄2 += m̄)
                else
                    d̄[k, t] += m̄
                end
                v̄ = v̄2 * eω + s̄2 * (1 - eω)
                ω̄[k, t] += v * eω * (s̄2 - v̄2)
                yd = Ȳ[k, m + t]
                P = sus + σp * pro
                ē = s̄2 * sus + v̄ * pro * σp - yd * P
                P̄ = -yd * e
                σ̄ += v̄ * pro * e + P̄ * pro
                s̄ = s̄2 * (1 + e) + P̄
                p̄ = v̄ * (1 + σp * e) + σp * P̄
                xn = -ē * (1 + e) / Np[k]
                R̄[k, t] += xn * f
                N̄[k] -= xn * x
                f̄ = xn * Rp[k, t]
                for l in eachindex(gp)
                    ḡ[l] += f̄ * Y[k, m + t - l]
                    Ȳ[k, m + t - l] += f̄ * gp[l]
                end
            end
            N̄[k] += s̄
        end
        h̄ .+= view(Ȳ, :, 1:m)
        return NoRData(), NoRData(), NoRData(), NoRData(), NoRData(), σ̄,
            NoRData(), NoRData()
    end
    return CoDual(y, ȳ), waning_handrule_pb
end

# ---- dense and sparse routes ------------------------------------------------

# The spatial strata tutorial's loop, keeping what the reverse pass needs.
function _routes_state(K1, g1, v, g2, h, R, colptr, rowval, pop)
    S, T = size(R)
    m = size(h, 2)
    V = promote_type(
        eltype(K1), eltype(g1), eltype(v), eltype(g2), eltype(h), eltype(R),
        eltype(pop)
    )
    y = zeros(V, S, m + T)
    y[:, 1:m] .= h
    P1, P2, Q, pools = zeros(V, S, T), zeros(V, S, T), zeros(V, S, T),
        zeros(V, S, T)
    pool = V.(pop)
    for t in 1:T
        for k in 1:S
            P1[k, t] = _renewal_sum(g1, y, k, m, t)
            P2[k, t] = _renewal_sum(g2, y, k, m, t)
        end
        for a in 1:S
            acc = zero(V)
            for b in 1:S
                acc += K1[a, b] * P1[b, t]
            end
            Q[a, t] = acc
        end
        for b in 1:S, j in colptr[b]:(colptr[b + 1] - 1)
            Q[rowval[j], t] += v[j] * P2[b, t]
        end
        for a in 1:S
            pools[a, t] = pool[a]
            drawn = max(pool[a] / pop[a], 1.0e-6) * R[a, t] * Q[a, t]
            pool[a] -= drawn
            y[a, m + t] = drawn
        end
    end
    return (; y, P1, P2, Q, pools)
end

@doc raw"""
    routes_handrule(K1, g1, v, g2, h, R, colptr, rowval, pop)

Two routes, a dense coupling `K1` on kernel `g1` and a sparse one held as
its column pointers, row indices and values `v` on kernel `g2`, then floored
depletion,
``I_{a,t} = \max(U_{a,t} / N_a, 10^{-6}) R_{a,t} q_{a,t}``, with ``U_{a,t}``
the pool before day ``t``'s draw. Returns strata × time.
"""
function routes_handrule(K1, g1, v, g2, h, R, colptr, rowval, pop)
    st = _routes_state(K1, g1, v, g2, h, R, colptr, rowval, pop)
    return st.y[:, (size(h, 2) + 1):end]
end

Mooncake.@is_primitive(
    Mooncake.DefaultCtx,
    Tuple{
        typeof(routes_handrule), _Mat, _Vec, _Vec, _Vec, _Mat, _Mat, _Ints,
        _Ints, _Vec,
    }
)
function Mooncake.rrule!!(
        ::CoDual{typeof(routes_handrule)}, K1::CoDual{_Mat}, g1::CoDual{_Vec},
        v::CoDual{_Vec}, g2::CoDual{_Vec}, h::CoDual{_Mat}, R::CoDual{_Mat},
        colptr::CoDual{_Ints}, rowval::CoDual{_Ints}, pop::CoDual{_Vec}
    )
    K1p, g1p, vp, g2p, Rp, popp = primal(K1), primal(g1), primal(v),
        primal(g2), primal(R), primal(pop)
    cp, rv = primal(colptr), primal(rowval)
    m = size(primal(h), 2)
    st = _routes_state(K1p, g1p, vp, g2p, primal(h), Rp, cp, rv, popp)
    y = st.y[:, (m + 1):end]
    ȳ = zero(y)
    function routes_handrule_pb(::NoRData)
        K̄1, ḡ1, v̄, ḡ2, h̄, R̄, pop̄ = tangent(K1), tangent(g1), tangent(v),
            tangent(g2), tangent(h), tangent(R), tangent(pop)
        (; P1, P2, Q, pools) = st
        Y = st.y
        S, T = size(Rp)
        Ȳ = zeros(S, m + T)
        Ȳ[:, (m + 1):end] .= ȳ
        pool̄, q̄, p̄1, p̄2 = zeros(S), zeros(S), zeros(S), zeros(S)
        for t in T:-1:1
            for a in 1:S
                d̄ = Ȳ[a, m + t] - pool̄[a]
                share = pools[a, t] / popp[a]
                # While the floor binds, the draw does not reach the pool.
                floored = 1.0e-6 > share
                c = floored ? 1.0e-6 : share
                R̄[a, t] += d̄ * c * Q[a, t]
                q̄[a] = d̄ * c * Rp[a, t]
                if !floored
                    c̄ = d̄ * Rp[a, t] * Q[a, t]
                    pool̄[a] += c̄ / popp[a]
                    pop̄[a] -= c̄ * share / popp[a]
                end
            end
            fill!(p̄2, 0.0)
            for b in 1:S, j in cp[b]:(cp[b + 1] - 1)
                v̄[j] += q̄[rv[j]] * P2[b, t]
                p̄2[b] += vp[j] * q̄[rv[j]]
            end
            for b in 1:S
                acc = 0.0
                for a in 1:S
                    K̄1[a, b] += q̄[a] * P1[b, t]
                    acc += K1p[a, b] * q̄[a]
                end
                p̄1[b] = acc
            end
            for b in 1:S
                for l in eachindex(g1p)
                    ḡ1[l] += p̄1[b] * Y[b, m + t - l]
                    Ȳ[b, m + t - l] += p̄1[b] * g1p[l]
                end
                for l in eachindex(g2p)
                    ḡ2[l] += p̄2[b] * Y[b, m + t - l]
                    Ȳ[b, m + t - l] += p̄2[b] * g2p[l]
                end
            end
        end
        pop̄ .+= pool̄
        h̄ .+= view(Ȳ, :, 1:m)
        return ntuple(_ -> NoRData(), 10)
    end
    return CoDual(y, ȳ), routes_handrule_pb
end

# ---- ward occupancy ---------------------------------------------------------

@doc raw"""
    ward_handrule(adm, confirm, ruleout, discharge, transfer)

Suspected and confirmed patients per ward, after each day's admissions
`adm` (suspected rows first): suspected patients are confirmed at rate
`confirm` or ruled out as the share `ruleout`, confirmed ones discharged at
rate `discharge` and transferred out in counts `transfer`, capped by what is
there. Returns 2 × wards rows by time, suspected first.
"""
function ward_handrule(adm, confirm, ruleout, discharge, transfer)
    S, T = size(transfer)
    V = promote_type(
        eltype(adm), eltype(confirm), eltype(ruleout), typeof(discharge),
        eltype(transfer)
    )
    y = zeros(V, 2S, T)
    for t in 1:T, k in 1:S
        sus = (t > 1 ? y[k, t - 1] : zero(V)) + adm[k, t]
        con = (t > 1 ? y[S + k, t - 1] : zero(V)) + adm[S + k, t]
        stay = exp(-confirm[k])
        con = exp(-discharge) * con + (1 - stay) * sus
        sus = (stay - ruleout[t]) * sus
        con -= min(transfer[k, t], max(con, zero(V)))
        y[k, t] = sus
        y[S + k, t] = con
    end
    return y
end

Mooncake.@is_primitive(
    Mooncake.DefaultCtx,
    Tuple{typeof(ward_handrule), _Mat, _Vec, _Vec, Float64, _Mat}
)
function Mooncake.rrule!!(
        ::CoDual{typeof(ward_handrule)}, adm::CoDual{_Mat},
        confirm::CoDual{_Vec}, ruleout::CoDual{_Vec},
        discharge::CoDual{Float64}, transfer::CoDual{_Mat}
    )
    ap, cp, rp, δ, trp = primal(adm), primal(confirm), primal(ruleout),
        primal(discharge), primal(transfer)
    y = ward_handrule(ap, cp, rp, δ, trp)
    ȳ = zero(y)
    # The step is cheap, so its values are recomputed from the output.
    function ward_handrule_pb(::NoRData)
        ā, c̄, r̄, t̄ = tangent(adm), tangent(confirm), tangent(ruleout),
            tangent(transfer)
        S, T = size(trp)
        eδ = exp(-δ)
        δ̄ = 0.0
        Ȳ = copy(ȳ)
        for k in 1:S
            stay = exp(-cp[k])
            stay̅ = 0.0
            for t in T:-1:1
                sus = (t > 1 ? y[k, t - 1] : 0.0) + ap[k, t]
                con = (t > 1 ? y[S + k, t - 1] : 0.0) + ap[S + k, t]
                con1 = eδ * con + (1 - stay) * sus
                s̄1, c̄1 = Ȳ[k, t], Ȳ[S + k, t]
                # The cap takes the branch `min(transfer, max(con1, 0))` took.
                t̄r = -c̄1
                c = 0 > con1 ? 0.0 : con1
                if c < trp[k, t]
                    0 > con1 || (c̄1 += t̄r)
                else
                    t̄[k, t] += t̄r
                end
                stay̅ += s̄1 * sus - c̄1 * sus
                r̄[t] -= s̄1 * sus
                s̄ = s̄1 * (stay - rp[t]) + c̄1 * (1 - stay)
                c̄0 = c̄1 * eδ
                δ̄ -= c̄1 * eδ * con
                ā[k, t] += s̄
                ā[S + k, t] += c̄0
                if t > 1
                    Ȳ[k, t - 1] += s̄
                    Ȳ[S + k, t - 1] += c̄0
                end
            end
            c̄[k] -= stay̅ * stay
        end
        return NoRData(), NoRData(), NoRData(), NoRData(), δ̄, NoRData()
    end
    return CoDual(y, ȳ), ward_handrule_pb
end

# ---- the getting-started model ----------------------------------------------

@doc raw"""
    overview_handrule(R, seed, gi, K, pop, d)

The getting-started model: towns coupled by `K`, each drawing from its pool
by hazard, ``I_{a,t} = U_{a,t} (1 - e^{-R_{a,t} q_{a,t} / N_a})`` with
``q_t = K p_t``, ``p_t`` the renewal sums on `gi` and ``U_{a,t}`` the pool
before day ``t``'s draw, then reported after the delay `d`, lag 0 first.
Returns towns × time.
"""
function overview_handrule(R, seed, gi, K, pop, d)
    st = _reproduction_state(gi, R, seed, K, pop)
    return _delay_rows(st.y[:, (size(seed, 2) + 1):end], d)
end

# The delay `d`, lag 0 first, along each row of `x`.
function _delay_rows(x, d)
    z = similar(x, promote_type(eltype(x), eltype(d)))
    for s in axes(x, 1)
        z[s, :] .= _delay(d, view(x, s, :))
    end
    return z
end

Mooncake.@is_primitive(
    Mooncake.DefaultCtx,
    Tuple{typeof(overview_handrule), _Mat, _Mat, _Vec, _Mat, _Vec, _Vec}
)
function Mooncake.rrule!!(
        ::CoDual{typeof(overview_handrule)}, R::CoDual{_Mat},
        seed::CoDual{_Mat}, gi::CoDual{_Vec}, K::CoDual{_Mat},
        pop::CoDual{_Vec}, d::CoDual{_Vec}
    )
    Rp, gp, Kp, popp, dp = primal(R), primal(gi), primal(K), primal(pop),
        primal(d)
    m = size(primal(seed), 2)
    st = _reproduction_state(gp, Rp, primal(seed), Kp, popp)
    x = st.y[:, (m + 1):end]
    z = _delay_rows(x, dp)
    z̄ = zero(z)
    function overview_handrule_pb(::NoRData)
        S, T = size(Rp)
        Ī = zeros(S, m + T)
        for s in 1:S
            _delay_back!(
                tangent(d), view(Ī, s, (m + 1):(m + T)), view(z̄, s, :), dp,
                view(x, s, :)
            )
        end
        _reproduction_back!(
            tangent(gi), tangent(R), tangent(K), tangent(pop), Ī, nothing,
            st, gp, Rp, Kp, popp, m
        )
        tangent(seed) .+= view(Ī, :, 1:m)
        return ntuple(_ -> NoRData(), 7)
    end
    return CoDual(z, z̄), overview_handrule_pb
end

end # module TutorialHandRule
