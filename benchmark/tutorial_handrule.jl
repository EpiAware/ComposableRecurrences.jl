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

export ar2_handrule, depletion_handrule, imports_handrule, transform_handrule

const _Vec = Vector{Float64}
const _Mat = Matrix{Float64}

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

end # module TutorialHandRule
