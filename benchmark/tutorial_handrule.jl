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
    reproduction_handrule

const _Vec = Vector{Float64}
const _Mat = Matrix{Float64}
const _Arr3 = Array{Float64, 3}

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

@doc raw"""
    delay_primary_handrule(G, X)

A delay per stratum and input time: `G[k, d + 1, s]` weights stratum `k`'s
input at time `s` reaching time `s + d`,
``y_{k,t} = \sum_{d} G_{k,d+1,t-d} X_{k,t-d}``. Returns strata × time.
"""
function delay_primary_handrule(G, X)
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

Mooncake.@is_primitive(
    Mooncake.DefaultCtx, Tuple{typeof(delay_primary_handrule), _Arr3, _Mat}
)
function Mooncake.rrule!!(
        ::CoDual{typeof(delay_primary_handrule)}, G::CoDual{_Arr3},
        X::CoDual{_Mat}
    )
    Gp, Xp = primal(G), primal(X)
    y = delay_primary_handrule(Gp, Xp)
    ȳ = zero(y)
    # Each input time `s` reaches times `s` to `s + L - 1`: its weights take
    # the input times those days' cotangents, and the input their weighted
    # sum.
    function delay_primary_handrule_pb(::NoRData)
        Ḡ, X̄ = tangent(G), tangent(X)
        S, L, T = size(Gp)
        for s in 1:T, d in 0:min(L - 1, T - s), k in 1:S
            yb = ȳ[k, s + d]
            Ḡ[k, d + 1, s] += yb * Xp[k, s]
            X̄[k, s] += yb * Gp[k, d + 1, s]
        end
        return NoRData(), NoRData(), NoRData()
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

# The towns' depleted run from the seed's columns, keeping each day's
# renewal sums `P`, mixed sums `Q` and the pools before the draw.
function _reproduction_state(g, R, seed, K, pop)
    S, T = size(R)
    m, L = size(seed, 2), length(g)
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
            acc = zero(V)
            for l in 1:L
                acc += g[l] * y[k, m + t - l]
            end
            P[k, t] = acc
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

@doc raw"""
    reproduction_handrule(g, R, seed, K, pop)

The effective reproduction number of a depleted run over strata coupled by
`K`: each day's infections over the mixed renewal sum they come from,
``I_{a,t} / q_{a,t}`` with ``q_t = K p_t``, ``p_t`` the renewal sums and
``I_{a,t} = P_{a,t-1} (1 - e^{-R_{a,t} q_{a,t} / N_a})`` from pools that
start at `pop`. Returns strata × time.
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
    # From the last day back: each day's draw takes the output's cotangent
    # over its mixed sum, the infections' cotangent and the pool's. The draw
    # reaches the pool before it, `R`, `N` and the mixed sum, which `Kᵀ`
    # takes back to the renewal sums, and those reach `g` and earlier days.
    function reproduction_handrule_pb(::NoRData)
        ḡ, R̄, K̄, pop̄ = tangent(g), tangent(R), tangent(K), tangent(pop)
        seed̄ = tangent(seed)
        (; P, Q, pools) = st
        Y = st.y
        S, T = size(Rp)
        L = length(gp)
        Ī = zeros(S, m + T)
        pool̄ = zeros(S)
        q̄ = zeros(S)
        for t in T:-1:1
            for a in 1:S
                q, drawn = Q[a, t], Y[a, m + t]
                r̄ = ȳ[a, t] / q
                d̄ = Ī[a, m + t] + r̄ - pool̄[a]
                x = Rp[a, t] * q / popp[a]
                x̄ = d̄ * pools[a, t] * exp(-x)
                pool̄[a] -= d̄ * expm1(-x)
                xn = x̄ / popp[a]
                R̄[a, t] += xn * q
                pop̄[a] -= xn * x
                q̄[a] = xn * Rp[a, t] - r̄ * drawn / q
            end
            for b in 1:S
                p̄ = 0.0
                for a in 1:S
                    K̄[a, b] += q̄[a] * P[b, t]
                    p̄ += Kp[a, b] * q̄[a]
                end
                for l in 1:L
                    ḡ[l] += p̄ * Y[b, m + t - l]
                    Ī[b, m + t - l] += p̄ * gp[l]
                end
            end
        end
        pop̄ .+= pool̄
        seed̄ .+= view(Ī, :, 1:m)
        return ntuple(_ -> NoRData(), 6)
    end
    return CoDual(y, ȳ), reproduction_handrule_pb
end

end # module TutorialHandRule
