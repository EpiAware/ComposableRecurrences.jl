# Hand-written reference kernels in the style of the BVDOutbreakSize
# backend, timed by the benchmark matrix (cases `bvd_renewal`, `bvd_patches`
# and `bvd_delay`) against the package's operators.
#
# The forward loops follow `test/usecases/references/bvd.jl`. The reverse
# passes are hand-written Mooncake rules, as the backend writes its own, so
# the `handrule` arm times what the package has to match before the backend
# can drop its rules. The `loop` arm times the same forward loops without the
# rules, differentiated by the backend itself. The rules are Mooncake rules
# only: Enzyme differentiates the loops in both arms.
#
# Included by `test/ADFixtures/src/matrix_cases.jl` inside `MatrixCases`.
module BVDHandRule

import Mooncake
using Mooncake: CoDual, NoRData, primal, tangent
using LinearAlgebra: axpy!, dot

export renewal_loop, patch_loop, delay_loop, renewal_infections,
    patch_infections, convolve_delay

# ---- forward loops ----------------------------------------------------------

# The pool left once the seed is drawn from `N`, floored at zero.
@inline function _pool_after_seed(N, seed)
    left = N - sum(seed)
    return left > zero(left) ? left : zero(left)
end

@doc raw"""
    renewal_loop(Rt, g, seed, N)

Seeded renewal with hazard depletion. The first `L = length(seed)` days are
the seed; from day `L + 1`

```math
f_t = \sum_{s=1}^{\min(t - 1, G)} g_s I_{t-s}, \quad
x_t = R_t f_t / N, \quad
I_t = P_{t-1} (1 - e^{-x_t}), \quad
P_t = P_{t-1} e^{-x_t},
```

with the pool `P` starting at `max(N - Σ seed, 0)`.
`R_t` is read on the same day, so `Rt` covers the seed days too.
"""
renewal_loop(Rt, g, seed, N) = _renewal_state(Rt, g, seed, N).infections

# `renewal_loop` keeping the force and the pool after each day.
function _renewal_state(Rt, g, seed, N)
    n = length(Rt)
    L = length(seed)
    G = length(g)
    Tp = promote_type(eltype(Rt), eltype(g), eltype(seed), typeof(float(N)))
    I = zeros(Tp, n)
    force = zeros(Tp, n)
    S = zeros(Tp, n)
    @inbounds for j in 1:min(L, n)
        I[j] = seed[j]
    end
    pool = convert(Tp, _pool_after_seed(N, view(I, 1:min(L, n))))
    @inbounds for j in 1:min(L, n)
        S[j] = pool
    end
    rg = reverse(g)
    for t in (L + 1):n
        k = min(t - 1, G)
        f = dot(view(rg, (G - k + 1):G), view(I, (t - k):(t - 1)))
        force[t] = f
        x = Rt[t] * f / N
        I[t] = -pool * expm1(-x)
        pool *= exp(-x)
        S[t] = pool
    end
    return (; infections = I, force, susceptible = S)
end

# Renewal force of patch `p` on day `t`, `Σ_{s ≥ 1} I[p, t − s] g[s]`.
@inline function _patch_force(I::AbstractMatrix, g::AbstractVector, p, t)
    f = zero(eltype(I))
    @inbounds @simd for s in 1:min(t - 1, length(g))
        f += I[p, t - s] * g[s]
    end
    return f
end

# What each origin sends away per unit it generates, `Σ_{r ≠ q} K[r, q]`.
function _patch_outflow(::Type{T}, K::AbstractMatrix, np::Integer) where {T}
    outflow = zeros(T, np)
    @inbounds for q in 1:np, r in 1:np
        r == q && continue
        outflow[q] += K[r, q]
    end
    return outflow
end

@doc raw"""
    patch_loop(Rt, g, seeds, K, ε, N)

Patch renewal with importation by redistribution, then hazard depletion per
patch. Each patch generates ``G_{p,t} = R_{p,t} f_{p,t}`` from its own
renewal force; a share ``ε_{q,t} K_{pq}`` of what origin `q` generates is
realised in `p` instead:

```math
y_{p,t} = (1 - ε_{p,t} o_p) G_{p,t} + \sum_{q \ne p} ε_{q,t} K_{pq} G_{q,t},
\quad o_q = \sum_{r \ne q} K_{rq},
```

and `y / N` is the hazard that depletes the patch's pool. `Rt` and `ε` are
patches × days and cover the seed days too. Returns the infections only.
"""
patch_loop(Rt, g, seeds, K, ε, N) = _patch_state(Rt, g, seeds, K, ε, N).infections

# `patch_loop` keeping the force, the hazard and the pool after each day.
function _patch_state(Rt, g, seeds, K, ε, N)
    np, n = size(Rt)
    L = size(seeds, 2)
    Tp = promote_type(
        eltype(Rt), eltype(g), eltype(seeds), eltype(K), eltype(ε),
        float(eltype(N))
    )
    I = zeros(Tp, np, n)
    force = zeros(Tp, np, n)
    S = zeros(Tp, np, n)
    rate = zeros(Tp, np, n)
    outflow = _patch_outflow(Tp, K, np)
    pool = zeros(Tp, np)
    @inbounds for p in 1:np
        for j in 1:min(L, n)
            I[p, j] = seeds[p, j]
        end
        pool[p] = _pool_after_seed(N[p], view(I, p, 1:min(L, n)))
        for j in 1:min(L, n)
            S[p, j] = pool[p]
        end
    end
    gen = zeros(Tp, np)
    @inbounds for t in (L + 1):n
        for p in 1:np
            force[p, t] = _patch_force(I, g, p, t)
            gen[p] = Rt[p, t] * force[p, t]
        end
        for p in 1:np
            arrivals = zero(Tp)
            for q in 1:np
                q == p && continue
                arrivals += ε[q, t] * K[p, q] * gen[q]
            end
            y = (one(Tp) - ε[p, t] * outflow[p]) * gen[p] + arrivals
            x = y / N[p]
            rate[p, t] = x
            I[p, t] = -pool[p] * expm1(-x)
            pool[p] *= exp(-x)
            S[p, t] = pool[p]
        end
    end
    return (; infections = I, force, susceptible = S, rate)
end

@doc raw"""
    delay_loop(x, delay)

Causal convolution with lag 0 first, the same length as `x`:
``y_t = \sum_{d=1}^{\min(D, t)} \mathrm{delay}_d x_{t-d+1}``.
"""
function delay_loop(x::AbstractVector, delay::AbstractVector)
    n = length(x)
    y = zeros(promote_type(eltype(x), eltype(delay)), n)
    for d in 1:min(length(delay), n)
        axpy!(delay[d], view(x, 1:(n - d + 1)), view(y, d:n))
    end
    return y
end

# ---- the same loops with hand-written Mooncake rules ------------------------

"`renewal_loop` with a hand-written Mooncake rule."
renewal_infections(Rt, g, seed, N) = renewal_loop(Rt, g, seed, N)

"`patch_loop` with a hand-written Mooncake rule."
patch_infections(Rt, g, seeds, K, ε, N) = patch_loop(Rt, g, seeds, K, ε, N)

"`delay_loop` with a hand-written Mooncake rule."
convolve_delay(x, delay) = delay_loop(x, delay)

const _Vec = Vector{Float64}
const _Mat = Matrix{Float64}

Mooncake.@is_primitive(
    Mooncake.DefaultCtx, Tuple{typeof(renewal_infections), _Vec, _Vec, _Vec, Float64}
)
function Mooncake.rrule!!(
        ::CoDual{typeof(renewal_infections)}, Rt::CoDual{_Vec},
        g::CoDual{_Vec}, seed::CoDual{_Vec}, N::CoDual{Float64}
    )
    args = (primal(Rt), primal(g), primal(seed), primal(N))
    st = _renewal_state(args...)
    Ī = zero(st.infections)
    function renewal_infections_pb(::NoRData)
        N̄ = _renewal_back!(
            tangent(Rt), tangent(g), tangent(seed), copy(Ī), st, args...
        )
        return NoRData(), NoRData(), NoRData(), NoRData(), N̄
    end
    return CoDual(st.infections, Ī), renewal_infections_pb
end

# The reverse of `renewal_loop`, from the last day back. With `P̄` the
# cotangent of the pool after day `t`, day `t` gives
# `x̄ = P_{t-1} e^{-x} (Ī_t − P̄)` and `P̄ ← Ī_t (1 − e^{-x}) + P̄ e^{-x}`;
# `x̄` reaches `R_t`, `N` and, through the force, `g` and earlier days.
function _renewal_back!(R̄, ḡ, seed̄, Ī, st, Rt, g, seed, N)
    n, L, G = length(Rt), length(seed), length(g)
    (; infections, force, susceptible) = st
    P̄ = 0.0
    N̄ = 0.0
    @inbounds for t in n:-1:(L + 1)
        x = Rt[t] * force[t] / N
        e = exp(-x)
        x̄ = susceptible[t - 1] * e * (Ī[t] - P̄)
        P̄ = -Ī[t] * expm1(-x) + P̄ * e
        R̄[t] += x̄ * force[t] / N
        N̄ -= x̄ * x / N
        f̄ = x̄ * Rt[t] / N
        for s in 1:min(t - 1, G)
            ḡ[s] += f̄ * infections[t - s]
            Ī[t - s] += f̄ * g[s]
        end
    end
    m = min(L, n)
    if N - sum(view(seed, 1:m)) > 0
        N̄ += P̄
        @inbounds for j in 1:m
            seed̄[j] -= P̄
        end
    end
    @inbounds for j in 1:m
        seed̄[j] += Ī[j]
    end
    return N̄
end

Mooncake.@is_primitive(
    Mooncake.DefaultCtx,
    Tuple{typeof(patch_infections), _Mat, _Vec, _Mat, _Mat, _Mat, _Vec}
)
function Mooncake.rrule!!(
        ::CoDual{typeof(patch_infections)}, Rt::CoDual{_Mat},
        g::CoDual{_Vec}, seeds::CoDual{_Mat}, K::CoDual{_Mat},
        ε::CoDual{_Mat}, N::CoDual{_Vec}
    )
    args = map(primal, (Rt, g, seeds, K, ε, N))
    st = _patch_state(args...)
    Ī = zero(st.infections)
    function patch_infections_pb(::NoRData)
        _patch_back!(map(tangent, (Rt, g, seeds, K, ε, N)), copy(Ī), st, args...)
        return ntuple(_ -> NoRData(), 7)
    end
    return CoDual(st.infections, Ī), patch_infections_pb
end

# The reverse of `patch_loop`. Each day the hazard cotangents `ȳ` go back
# through the redistribution with one transpose product,
# `c_q = Σ_{p ≠ q} K[p, q] ȳ_p`: what origin `q` generated gets
# `(1 − ε_q o_q) ȳ_q + ε_q c_q`, and `ε_q` gets `G_q (c_q − o_q ȳ_q)`.
function _patch_back!(bars, Ī, st, Rt, g, seeds, K, ε, N)
    R̄, ḡ, seeds̄, K̄, ε̄, N̄ = bars
    np, n = size(Rt)
    L, G = size(seeds, 2), length(g)
    (; infections, force, susceptible, rate) = st
    outflow = _patch_outflow(Float64, K, np)
    P̄ = zeros(np)
    ȳ = zeros(np)
    c = zeros(np)
    ō = zeros(np)
    @inbounds for t in n:-1:(L + 1)
        for p in 1:np
            x = rate[p, t]
            e = exp(-x)
            x̄ = susceptible[p, t - 1] * e * (Ī[p, t] - P̄[p])
            P̄[p] = -Ī[p, t] * expm1(-x) + P̄[p] * e
            ȳ[p] = x̄ / N[p]
            N̄[p] -= x̄ * x / N[p]
        end
        for q in 1:np
            acc = 0.0
            for p in 1:np
                p == q || (acc += K[p, q] * ȳ[p])
            end
            c[q] = acc
        end
        for q in 1:np
            gen = Rt[q, t] * force[q, t]
            εq = ε[q, t]
            ḡen = (1 - εq * outflow[q]) * ȳ[q] + εq * c[q]
            ε̄[q, t] += gen * (c[q] - outflow[q] * ȳ[q])
            ō[q] -= εq * gen * ȳ[q]
            for p in 1:np
                p == q || (K̄[p, q] += εq * gen * ȳ[p])
            end
            R̄[q, t] += ḡen * force[q, t]
            f̄ = ḡen * Rt[q, t]
            for s in 1:min(t - 1, G)
                ḡ[s] += f̄ * infections[q, t - s]
                Ī[q, t - s] += f̄ * g[s]
            end
        end
    end
    @inbounds for q in 1:np, r in 1:np
        r == q || (K̄[r, q] += ō[q])
    end
    m = min(L, n)
    @inbounds for p in 1:np
        if N[p] - sum(view(seeds, p, 1:m)) > 0
            N̄[p] += P̄[p]
            for j in 1:m
                seeds̄[p, j] -= P̄[p]
            end
        end
        for j in 1:m
            seeds̄[p, j] += Ī[p, j]
        end
    end
    return nothing
end

Mooncake.@is_primitive(
    Mooncake.DefaultCtx, Tuple{typeof(convolve_delay), _Vec, _Vec}
)
function Mooncake.rrule!!(
        ::CoDual{typeof(convolve_delay)}, x::CoDual{_Vec}, delay::CoDual{_Vec}
    )
    xp, dp = primal(x), primal(delay)
    y = delay_loop(xp, dp)
    ȳ = zero(y)
    # Each lag is an axpy, so its reverse is an axpy into `x̄` and a dot
    # into the lag's weight.
    function convolve_delay_pb(::NoRData)
        x̄, d̄ = tangent(x), tangent(delay)
        n = length(xp)
        for d in 1:min(length(dp), n)
            axpy!(dp[d], view(ȳ, d:n), view(x̄, 1:(n - d + 1)))
            d̄[d] += dot(view(xp, 1:(n - d + 1)), view(ȳ, d:n))
        end
        return NoRData(), NoRData(), NoRData()
    end
    return CoDual(y, ȳ), convolve_delay_pb
end

end # module BVDHandRule
