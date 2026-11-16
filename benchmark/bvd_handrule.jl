# Hand-written reference kernels in the style of the BVDOutbreakSize
# backend, timed by the benchmark matrix (cases `bvd_renewal`, `bvd_patches`,
# `bvd_delay`, `bvd_zones`, `bvd_two_clock`, `bvd_abscond`, `bvd_onset`,
# `bvd_bins` and `bvd_knots`) against the package's operators.
#
# The forward loops follow `test/usecases/references/bvd.jl`. The reverse
# passes are hand-written Mooncake rules, as the backend writes its own, so
# the `handrule` arm times what the package has to match before the backend
# can drop its rules. The `loop` arm times the same forward loops without the
# rules, differentiated by the backend itself. The rules are Mooncake rules
# only: Enzyme differentiates the loops in both arms.
#
# The loops and rules were written in this repository, not copied, except
# `sum_to_zero_knots_loop` and `sum_to_zero_ar1!`, copied from
# BVDOutbreakSize's `sum_to_zero_knots` (`src/sum_to_zero.jl` at commit
# 73c575bd) with the level given rather than built; BVD has no rule for it,
# so its case has no `handrule` arm. The other loops follow
# `references/bvd.jl`, a frozen copy of BVDOutbreakSize at commit 95be3b22,
# and none is kept in step with BVDOutbreakSize.
#
# Included by `test/ADFixtures/src/matrix_cases.jl` inside `MatrixCases`.
module BVDHandRule

import Mooncake
using Mooncake: CoDual, NoRData, primal, tangent
using LinearAlgebra: axpy!, dot, mul!

export renewal_loop, patch_loop, delay_loop, zone_loop, bin_loop,
    renewal_infections, patch_infections, convolve_delay, zone_infections,
    bin_increments, two_clock_loop, abscond_loop, onset_table_loop,
    two_clock_confirmed, abscond_thinned_flows, onset_report_cdf_table,
    sum_to_zero_knots_loop

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

@doc raw"""
    bin_loop(daily, days)

The sums of `daily` over the windows between report days `days`, each
window from the day after the last report to its own report day, an empty
window giving zero.
"""
function bin_loop(daily::AbstractVector, days::AbstractVector{<:Integer})
    n = length(daily)
    out = zeros(eltype(daily), length(days))
    for i in eachindex(days)
        for t in _bin_window(days, i, n)
            out[i] += daily[t]
        end
    end
    return out
end

# The days of window `i`: from the day after the last report to report day
# `days[i]`, each clamped to the series of `n` days.
function _bin_window(days, i, n)
    lo = i == firstindex(days) ? 0 : clamp(days[i - 1], 0, n)
    return (lo + 1):clamp(days[i], 0, n)
end

@doc raw"""
    sum_to_zero_knots_loop(lvl, F_drift, Z, φ)

The knots of BVD's sum-to-zero drift: the level `lvl` as the first column,
then an AR(1) across the columns driven by the innovations ``F Z``,

```math
k_{i,1} = \ell_i, \qquad
k_{i,j+1} = \varphi\, k_{i,j} + (F Z)_{i,j}.
```

BVD's `sum_to_zero_knots`, with the level its shared `sum_to_zero` step
returns given instead of built.
"""
function sum_to_zero_knots_loop(
        lvl::AbstractVector, F_drift::AbstractMatrix, Z::AbstractMatrix, φ::Real
    )
    T = promote_type(eltype(lvl), eltype(F_drift), eltype(Z), typeof(φ))
    knots = zeros(T, length(lvl), size(Z, 2) + 1)
    @inbounds for i in eachindex(lvl)
        knots[i, 1] = lvl[i]
    end
    return sum_to_zero_ar1!(knots, F_drift, Z, φ, 1)
end

# BVD's `sum_to_zero_ar1!`: the AR(1) knots from column `k0` on.
function sum_to_zero_ar1!(
        knots::AbstractMatrix, F::AbstractMatrix, Z::AbstractMatrix,
        φ::Real, k0::Integer
    )
    innovations = F * Z
    @inbounds for j in axes(Z, 2), i in axes(knots, 1)
        knots[i, k0 + j] = φ * knots[i, k0 + j - 1] + innovations[i, j]
    end
    return knots
end

@doc raw"""
    zone_loop(gain, add, ε, φ, ow, I_bar, g, within, between, groups)

The mixed zone share renewal, from day 1. Each zone's own force is
``u_{z,t} = γ_{z,t} \sum_s g_s I_{z,t-s} + a_{z,t}``, with the gain `γ` and
the pre-grid drive `a` formed by the caller as the package's arm forms them;
a share ``ε_z`` of it spills within its patch,
``v = (1 - ε) ∘ u + W (ε ∘ u)``, and the import pattern ``h = B (ow ∘ u)``
reads it before the spill. Patch `p`'s infections ``Ī_{p,t}`` go a share
``1 - φ_{p,t}`` by `v` and ``φ_{p,t}`` by `h` (by `v` where `h` sums to the
floor or less). `gain` and `add` are zones × days and `φ` and `I_bar`
patches × days. Returns the infections, days × zones.
"""
function zone_loop(gain, add, ε, φ, ow, I_bar, g, within, between, groups)
    return _zone_state(
        gain, add, ε, φ, ow, I_bar, g, within, between, groups
    ).infections
end

# `zone_loop` keeping each zone's own force `u` and its renewal sum `c`, the
# spilled force `v`, the import pattern `h` and per patch and day the
# unfloored sums of `v` and `h`.
function _zone_state(gain, add, ε, φ, ow, I_bar, g, within, between, groups)
    nz, nd = size(gain)
    np = length(groups)
    Tp = promote_type(
        eltype(gain), eltype(add), eltype(ε), eltype(φ), eltype(ow),
        eltype(I_bar), eltype(g), eltype(within), eltype(between)
    )
    I = zeros(Tp, nd, nz)
    U = zeros(Tp, nd, nz)
    C = zeros(Tp, nd, nz)
    V = zeros(Tp, nd, nz)
    H = zeros(Tp, nd, nz)
    patch_total = zeros(Tp, np, nd)
    share_total = zeros(Tp, np, nd)
    u = zeros(Tp, nz)
    eu = zeros(Tp, nz)
    wu = zeros(Tp, nz)
    spill = zeros(Tp, nz)
    h = zeros(Tp, nz)
    L = length(g)
    floor_ = eps(Tp)
    @inbounds for j in 1:nd
        smax = min(L, j - 1)
        for z in 1:nz
            acc = zero(Tp)
            for s in 1:smax
                acc = muladd(g[s], I[j - s, z], acc)
            end
            C[j, z] = acc
            u[z] = muladd(gain[z, j], acc, add[z, j])
            U[j, z] = u[z]
        end
        for z in 1:nz
            eu[z] = ε[z] * u[z]
            wu[z] = ow[z] * u[z]
        end
        mul!(spill, within, eu)
        mul!(h, between, wu)
        for z in 1:nz
            V[j, z] = (one(Tp) - ε[z]) * u[z] + spill[z]
            H[j, z] = h[z]
        end
        for p in eachindex(groups)
            zs = groups[p]
            Ip = I_bar[p, j]
            Mp = φ[p, j] * Ip
            sv = zero(Tp)
            sh = zero(Tp)
            for z in zs
                sv += V[j, z]
                sh += H[j, z]
            end
            patch_total[p, j] = sv
            share_total[p, j] = sh
            sv = max(sv, floor_)
            cp = (Ip - Mp) / sv
            for z in zs
                share_h = sh > floor_ ? H[j, z] / sh : V[j, z] / sv
                I[j, z] = cp * V[j, z] + Mp * share_h
            end
        end
    end
    return (;
        infections = I, u = U, c = C, v = V, h = H, patch_total, share_total,
    )
end

# ---- computed kernels: each cohort's weights walked in place -----------------

@doc raw"""
    two_clock_loop(A, h, S)

Admissions confirmed by hazard `h` and still present (`S`):

```math
O_t = \sum_{d=0}^{\min(L, t) - 1} A_{t-d} S_{d+1}
    \Bigl(1 - \prod_{j=1}^{d} (1 - h_{t-d+j})\Bigr).
```
"""
function two_clock_loop(A::AbstractVector, h::AbstractVector, S::AbstractVector)
    n = length(A)
    T = promote_type(eltype(A), eltype(h), eltype(S))
    O = zeros(T, n)
    L = length(S)
    @inbounds for u in 1:n
        a = A[u]
        P = one(T)
        O[u] += a * (one(T) - P) * S[1]
        for d in 1:min(L - 1, n - u)
            P *= one(T) - h[u + d]
            O[u + d] += a * (one(T) - P) * S[d + 1]
        end
    end
    return O
end

@doc raw"""
    abscond_loop(adm, pmf, κ, h)

Discharges by flow (days × flows) thinned by absconding.
`adm` is days × flows and `pmf` lags × flows, the shorter flow's padded with
zeros.
Cohort ``t`` is unconfirmed after ``d`` days with probability
``U_{t,d} = \prod_{j=1}^{d} (1 - h_{t+j-1})``, and has not absconded with
probability ``V_{t,d} = \prod_{j=1}^{d} (1 - κ U_{t,j})``:

```math
\mathrm{out}_{s,k} = \sum_{t + d = s} \mathrm{adm}_{t,k} \,
    \mathrm{pmf}_{d+1,k} V_{t,d}.
```
"""
function abscond_loop(adm::AbstractMatrix, pmf::AbstractMatrix, κ::Real, h)
    n, nf = size(adm)
    L = size(pmf, 1)
    T = promote_type(eltype(adm), eltype(pmf), typeof(κ), eltype(h))
    out = zeros(T, n, nf)
    @inbounds for t in 1:n
        for k in 1:nf
            out[t, k] += adm[t, k] * pmf[1, k]
        end
        U = one(T)
        V = one(T)
        for d in 1:min(L - 1, n - t)
            U *= one(T) - h[t + d - 1]
            V *= one(T) - κ * U
            for k in 1:nf
                out[t + d, k] += adm[t, k] * pmf[d + 1, k] * V
            end
        end
    end
    return out
end

_logistic(x) = inv(one(x) + exp(-x))

@doc raw"""
    onset_table_loop(logit_h0, γ, nu)

The report-delay CDF of each onset date ``k = 1, \dots, nu``, with `γ`
covering the days up to `nu + length(logit_h0) - 1`:

```math
F_{j,k} = 1 - \prod_{i=1}^{j}
    \bigl(1 - \mathrm{logistic}(\mathrm{logit\_h0}_i + γ_{k+i-1})\bigr).
```
"""
function onset_table_loop(
        logit_h0::AbstractVector, γ::AbstractVector, nu::Integer
    )
    T = promote_type(eltype(logit_h0), eltype(γ))
    D = length(logit_h0)
    F = Matrix{T}(undef, D, nu)
    @inbounds for k in 1:nu
        s = one(T)
        for j in 1:D
            s *= one(T) - _logistic(logit_h0[j] + γ[k + j - 1])
            F[j, k] = one(T) - s
        end
    end
    return F
end

# ---- the same loops with hand-written Mooncake rules ------------------------

# Each rule is a primitive for `Float64` arguments only (`_Vec`, `_Mat`); other
# element types take Mooncake through the loop.

"`renewal_loop` with a hand-written Mooncake rule."
renewal_infections(Rt, g, seed, N) = renewal_loop(Rt, g, seed, N)

"`patch_loop` with a hand-written Mooncake rule."
patch_infections(Rt, g, seeds, K, ε, N) = patch_loop(Rt, g, seeds, K, ε, N)

"`delay_loop` with a hand-written Mooncake rule."
convolve_delay(x, delay) = delay_loop(x, delay)

"`zone_loop` with a hand-written Mooncake rule."
function zone_infections(gain, add, ε, φ, ow, I_bar, g, within, between, groups)
    return zone_loop(gain, add, ε, φ, ow, I_bar, g, within, between, groups)
end

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

Mooncake.@is_primitive(
    Mooncake.DefaultCtx,
    Tuple{
        typeof(zone_infections), _Mat, _Mat, _Vec, _Mat, _Vec, _Mat, _Vec,
        _Mat, _Mat, Vector{UnitRange{Int}},
    }
)
function Mooncake.rrule!!(
        ::CoDual{typeof(zone_infections)}, gain::CoDual{_Mat},
        add::CoDual{_Mat}, ε::CoDual{_Vec}, φ::CoDual{_Mat}, ow::CoDual{_Vec},
        I_bar::CoDual{_Mat}, g::CoDual{_Vec}, within::CoDual{_Mat},
        between::CoDual{_Mat}, groups::CoDual{Vector{UnitRange{Int}}}
    )
    duals = (gain, add, ε, φ, ow, I_bar, g, within, between)
    args = (map(primal, duals)..., primal(groups))
    st = _zone_state(args...)
    Ī = zero(st.infections)
    function zone_infections_pb(::NoRData)
        _zone_back!(map(tangent, duals), copy(Ī), st, args...)
        return ntuple(_ -> NoRData(), 11)
    end
    return CoDual(st.infections, Ī), zone_infections_pb
end

# The reverse of `zone_loop`, the backend's rule with the cotangents of its
# other outputs (shares, forces and imports) left out, from the last day
# back. Per patch, `I = c_p v + M_p h / Σh` with both sums pooling over the
# patch; the spill and the pattern each transpose into `ū` with one
# product a day, and their own cotangents are one outer product after the
# walk.
function _zone_back!(
        bars, acc, st, gain, add, ε, φ, ow, I_bar, g, within, between, groups
    )
    γ̄, ā, ε̄, φ̄, ōw, Ī_bar, ḡ, W̄, B̄ = bars
    nz, nd = size(gain)
    L = length(g)
    floor_ = eps(Float64)
    ū = zeros(nz)
    v̄ = zeros(nz)
    h̄ = zeros(nz)
    ēu = zeros(nz)
    w̄u = zeros(nz)
    V̄ = zeros(nd, nz)
    H̄ = zeros(nd, nz)
    @inbounds for j in nd:-1:1
        fill!(ū, 0.0)
        fill!(v̄, 0.0)
        fill!(h̄, 0.0)
        for p in eachindex(groups)
            zs = groups[p]
            Ip = I_bar[p, j]
            frac = φ[p, j]
            Mp = frac * Ip
            raw = st.patch_total[p, j]
            sv = max(raw, floor_)
            sh = st.share_total[p, j]
            cp = (Ip - Mp) / sv
            c̄p = 0.0
            M̄p = 0.0
            s̄v = 0.0
            s̄h = 0.0
            for z in zs
                Īz = acc[j, z]
                c̄p += Īz * st.v[j, z]
                v̄[z] += Īz * cp
                if sh > floor_
                    M̄p += Īz * st.h[j, z] / sh
                    h̄[z] += Īz * Mp / sh
                    s̄h -= Īz * Mp * st.h[j, z] / (sh * sh)
                else
                    M̄p += Īz * st.v[j, z] / sv
                    v̄[z] += Īz * Mp / sv
                    s̄v -= Īz * Mp * st.v[j, z] / (sv * sv)
                end
            end
            Ī_bar[p, j] += c̄p / sv
            M̄p -= c̄p / sv
            s̄v -= c̄p * (Ip - Mp) / (sv * sv)
            Ī_bar[p, j] += M̄p * frac
            φ̄[p, j] += M̄p * Ip
            if raw > floor_
                for z in zs
                    v̄[z] += s̄v
                end
            end
            for z in zs
                h̄[z] += s̄h
            end
        end
        for z in 1:nz
            ε̄[z] -= v̄[z] * st.u[j, z]
            ū[z] += v̄[z] * (1.0 - ε[z])
            V̄[j, z] = v̄[z]
            H̄[j, z] = h̄[z]
        end
        mul!(ēu, transpose(within), v̄)
        mul!(w̄u, transpose(between), h̄)
        for z in 1:nz
            uz = st.u[j, z]
            ε̄[z] += ēu[z] * uz
            ū[z] += ēu[z] * ε[z]
            ōw[z] += w̄u[z] * uz
            ū[z] += w̄u[z] * ow[z]
        end
        smax = min(L, j - 1)
        for z in 1:nz
            Λ̄ = ū[z] * gain[z, j]
            γ̄[z, j] += ū[z] * st.c[j, z]
            ā[z, j] += ū[z]
            for s in 1:smax
                acc[j - s, z] += Λ̄ * g[s]
                ḡ[s] += Λ̄ * st.infections[j - s, z]
            end
        end
    end
    mul!(W̄, transpose(V̄), st.u .* transpose(ε), 1.0, 1.0)
    mul!(B̄, transpose(H̄), st.u .* transpose(ow), 1.0, 1.0)
    return nothing
end

"`two_clock_loop` with a hand-written Mooncake rule."
two_clock_confirmed(A, h, S) = two_clock_loop(A, h, S)

"`abscond_loop` with a hand-written Mooncake rule."
abscond_thinned_flows(adm, pmf, κ, h) = abscond_loop(adm, pmf, κ, h)

"`onset_table_loop` with a hand-written Mooncake rule."
onset_report_cdf_table(logit_h0, γ, nu) = onset_table_loop(logit_h0, γ, nu)

Mooncake.@is_primitive(
    Mooncake.DefaultCtx, Tuple{typeof(two_clock_confirmed), _Vec, _Vec, _Vec}
)
function Mooncake.rrule!!(
        ::CoDual{typeof(two_clock_confirmed)}, A::CoDual{_Vec},
        h::CoDual{_Vec}, S::CoDual{_Vec}
    )
    Ap, hp, Sp = primal(A), primal(h), primal(S)
    O = two_clock_loop(Ap, hp, Sp)
    Ō = zero(O)
    function two_clock_confirmed_pb(::NoRData)
        _two_clock_back!(tangent(A), tangent(h), tangent(S), Ō, Ap, hp, Sp)
        return NoRData(), NoRData(), NoRData(), NoRData()
    end
    return CoDual(O, Ō), two_clock_confirmed_pb
end

# Each cohort's walk again, keeping its survival `P`, then back along the
# lags with the running cotangent `acc` of the survival from lag `d` on:
# `h̄_{u+d} = -P_{d-1} acc`.
function _two_clock_back!(Ā, h̄, S̄, Ō, A, h, S)
    n = length(A)
    L = length(S)
    P = ones(L)
    @inbounds for u in 1:n
        a = A[u]
        dm = min(L - 1, n - u)
        for d in 1:dm
            P[d + 1] = P[d] * (1.0 - h[u + d])
        end
        acc = 0.0
        ā = 0.0
        for d in dm:-1:0
            ō = Ō[u + d]
            c = 1.0 - P[d + 1]
            ā += c * S[d + 1] * ō
            S̄[d + 1] += a * c * ō
            acc -= a * S[d + 1] * ō
            d == 0 && break
            h̄[u + d] -= P[d] * acc
            acc *= 1.0 - h[u + d]
        end
        Ā[u] += ā
    end
    return nothing
end

Mooncake.@is_primitive(
    Mooncake.DefaultCtx,
    Tuple{typeof(abscond_thinned_flows), _Mat, _Mat, Float64, _Vec}
)
function Mooncake.rrule!!(
        ::CoDual{typeof(abscond_thinned_flows)}, adm::CoDual{_Mat},
        pmf::CoDual{_Mat}, κ::CoDual{Float64}, h::CoDual{_Vec}
    )
    args = (primal(adm), primal(pmf), primal(κ), primal(h))
    out = abscond_loop(args...)
    ō = zero(out)
    function abscond_thinned_flows_pb(::NoRData)
        κ̄ = _abscond_back!(tangent(adm), tangent(pmf), tangent(h), ō, args...)
        return NoRData(), NoRData(), NoRData(), κ̄, NoRData()
    end
    return CoDual(out, ō), abscond_thinned_flows_pb
end

# Each cohort's walk again, keeping `U` and `V`, then back along the lags
# with the running cotangents of both survivals: the outer one's hazard
# `κ U_d` passes `-V_{d-1} accV` to `κ` and to `U_d`, whose own sweep then
# passes `-U_{d-1} accU` to `h_{t+d-1}`.
function _abscond_back!(ādm, p̄mf, h̄, ō, adm, pmf, κ, h)
    n, nf = size(adm)
    L = size(pmf, 1)
    U = ones(L)
    V = ones(L)
    κ̄ = 0.0
    @inbounds for t in 1:n
        dm = min(L - 1, n - t)
        for d in 1:dm
            U[d + 1] = U[d] * (1.0 - h[t + d - 1])
            V[d + 1] = V[d] * (1.0 - κ * U[d + 1])
        end
        accV = 0.0
        accU = 0.0
        for d in dm:-1:0
            v = V[d + 1]
            V̄ = 0.0
            for k in 1:nf
                o = ō[t + d, k]
                ādm[t, k] += pmf[d + 1, k] * v * o
                p̄mf[d + 1, k] += adm[t, k] * v * o
                V̄ += adm[t, k] * pmf[d + 1, k] * o
            end
            d == 0 && break
            accV += V̄
            η̄ = -V[d] * accV
            accV *= 1.0 - κ * U[d + 1]
            κ̄ += η̄ * U[d + 1]
            accU += η̄ * κ
            h̄[t + d - 1] -= U[d] * accU
            accU *= 1.0 - h[t + d - 1]
        end
    end
    return κ̄
end

Mooncake.@is_primitive(
    Mooncake.DefaultCtx, Tuple{typeof(onset_report_cdf_table), _Vec, _Vec, Int}
)
function Mooncake.rrule!!(
        ::CoDual{typeof(onset_report_cdf_table)}, logit_h0::CoDual{_Vec},
        γ::CoDual{_Vec}, nu::CoDual{Int}
    )
    z, γp, n = primal(logit_h0), primal(γ), primal(nu)
    D = length(z)
    H = Matrix{Float64}(undef, D, n)
    S = Matrix{Float64}(undef, D, n)
    @inbounds for k in 1:n
        s = 1.0
        for j in 1:D
            η = _logistic(z[j] + γp[k + j - 1])
            s *= 1.0 - η
            H[j, k] = η
            S[j, k] = s
        end
    end
    F = 1.0 .- S
    F̄ = zero(F)
    function onset_report_cdf_table_pullback!!(::NoRData)
        _onset_back!(tangent(logit_h0), tangent(γ), F̄, H, S)
        return NoRData(), NoRData(), NoRData(), NoRData()
    end
    return CoDual(F, F̄), onset_report_cdf_table_pullback!!
end

# The forward pass keeps each column's hazards and survivals. `1 - s_j` has
# derivative `s_j η_i` in the logit of hazard `i ≤ j`, so a column's
# adjoint is one backward running sum, `x̄_i = η_i Σ_{j ≥ i} F̄_j s_j`.
function _onset_back!(z̄, γ̄, F̄, H, S)
    D, nu = size(H)
    @inbounds for k in 1:nu
        acc = 0.0
        for j in D:-1:1
            acc += F̄[j, k] * S[j, k]
            x̄ = H[j, k] * acc
            z̄[j] += x̄
            γ̄[k + j - 1] += x̄
        end
    end
    return nothing
end

"`bin_loop` with a hand-written Mooncake rule."
bin_increments(daily, days) = bin_loop(daily, days)

Mooncake.@is_primitive(
    Mooncake.DefaultCtx, Tuple{typeof(bin_increments), _Vec, Vector{Int}}
)
function Mooncake.rrule!!(
        ::CoDual{typeof(bin_increments)}, daily::CoDual{_Vec},
        days::CoDual{Vector{Int}}
    )
    xp, dp = primal(daily), primal(days)
    y = bin_loop(xp, dp)
    ȳ = zero(y)
    # Each day in a window takes that window's cotangent.
    function bin_increments_pb(::NoRData)
        x̄ = tangent(daily)
        n = length(xp)
        for i in eachindex(dp)
            for t in _bin_window(dp, i, n)
                x̄[t] += ȳ[i]
            end
        end
        return NoRData(), NoRData(), NoRData()
    end
    return CoDual(y, ȳ), bin_increments_pb
end

end # module BVDHandRule
