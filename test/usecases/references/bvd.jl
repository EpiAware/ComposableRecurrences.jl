# Verbatim copies of the BVDOutbreakSize.jl renewal, delay, occupancy, lab,
# onset-reporting and zone kernels used as the reference for the use-case
# tests.
#
# Source: https://github.com/epiforecasts/BVDOutbreakSize at commit 95be3b22.
# Each block names its file and line range. Docstrings and the Mooncake rules
# are left out; the code is unchanged.
module BVDReference

using LinearAlgebra

# src/renewal.jl L272-L319
function renewal_infections(
        Rt::AbstractVector, g::AbstractVector,
        seed::AbstractVector, N::Real
    )
    return renewal_infections_with_state(Rt, g, seed, N).infections
end

function renewal_infections_with_state(
        Rt::AbstractVector, g::AbstractVector,
        seed::AbstractVector, N::Real
    )
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

# src/renewal.jl L348-L353
## The pool left once the seed is drawn from `N`. The seed can itself
## overflow on extreme warmup proposals, so the pool is floored at zero.
@inline function _pool_after_seed(N, seed)
    left = N - sum(seed)
    return left > zero(left) ? left : zero(left)
end

# src/renewal.jl L394-L409
## Importation intensity of origin `q` on day `t`. A scalar applies to every
## origin and every day; a matrix carries one level per origin over time.
@inline _eps(e::Real, q::Integer, t::Integer) = e
@inline _eps(e::AbstractMatrix, q::Integer, t::Integer) = @inbounds e[q, t]

## Renewal force of patch `p` on day `t`, `Σ_{s ≥ 1} I[p, t − s] g[s]` over
## the lags inside the grid. Shared by `patch_infections` and its rule.
## `@simd` lets the sum reassociate, so it can differ from a sequential sum
## in the last bits.
@inline function _patch_force(I::AbstractMatrix, g::AbstractVector, p, t)
    f = zero(eltype(I))
    @inbounds @simd for s in 1:min(t - 1, length(g))
        f += I[p, t - s] * g[s]
    end
    return f
end

# src/renewal.jl L470-L601
function patch_infections(
        Rt_matrix::AbstractMatrix, g::AbstractVector,
        seeds_matrix::AbstractMatrix, importation_kernel::AbstractMatrix,
        epsilon::Union{Real, AbstractMatrix}, N::AbstractVector
    )
    st = patch_infections_with_state(
        Rt_matrix, g, seeds_matrix, importation_kernel, epsilon, N
    )
    return (; st.infections, st.importation)
end

function patch_infections_with_state(
        Rt_matrix::AbstractMatrix, g::AbstractVector,
        seeds_matrix::AbstractMatrix, importation_kernel::AbstractMatrix,
        epsilon::Union{Real, AbstractMatrix}, N::AbstractVector
    )
    np, n = size(Rt_matrix)
    L = size(seeds_matrix, 2)
    Tp = promote_type(
        eltype(Rt_matrix), eltype(g), eltype(seeds_matrix),
        eltype(importation_kernel),
        epsilon isa Real ? typeof(float(epsilon)) : eltype(epsilon),
        float(eltype(N))
    )
    I = zeros(Tp, np, n)
    imports = zeros(Tp, np, n)
    S = zeros(Tp, np, n)
    rate = zeros(Tp, np, n)
    outflow = _patch_outflow(Tp, importation_kernel, np)
    pool = zeros(Tp, np)
    @inbounds for p in 1:np
        for j in 1:min(L, n)
            I[p, j] = seeds_matrix[p, j]
        end
        pool[p] = _pool_after_seed(N[p], view(I, p, 1:min(L, n)))
        for j in 1:min(L, n)
            S[p, j] = pool[p]
        end
    end
    gen = zeros(Tp, np)
    @inbounds for t in (L + 1):n
        ## What each patch generates today from its own renewal force.
        for p in 1:np
            gen[p] = Rt_matrix[p, t] * _patch_force(I, g, p, t)
        end
        ## Importation redistributes transmission rather than adding to it. A
        ## fraction `epsilon * K[p, q]` of what `q` generates is realised in
        ## `p` instead of at home, so `q` is debited exactly what the
        ## destinations are credited. The intensity belongs to the origin, so
        ## `p` is debited at its own rate and credited at each sender's.
        for p in 1:np
            arrivals = zero(Tp)
            for q in 1:np
                q == p && continue
                arrivals += _eps(epsilon, q, t) *
                    importation_kernel[p, q] * gen[q]
            end
            imports[p, t] = arrivals
            y = (one(Tp) - _eps(epsilon, p, t) * outflow[p]) * gen[p] +
                arrivals
            x = y / N[p]
            rate[p, t] = x
            I[p, t] = -pool[p] * expm1(-x)
            pool[p] *= exp(-x)
            S[p, t] = pool[p]
        end
    end
    return (; infections = I, importation = imports, susceptible = S, rate)
end

## What each of the first `np` origins sends away per unit of its own
## generated infections: the importation kernel's off-diagonal column sums
## over those patches, constant in time. The kernel may cover more patches
## than the model runs, so `np` comes from the caller.
function _patch_outflow(::Type{T}, K::AbstractMatrix, np::Integer) where {T}
    outflow = zeros(T, np)
    @inbounds for q in 1:np, r in 1:np
        r == q && continue
        outflow[q] += K[r, q]
    end
    return outflow
end

function convolve_delay(x::AbstractVector, delay::AbstractVector)
    n = length(x)
    y = zeros(promote_type(eltype(x), eltype(delay)), n)
    for d in 1:min(length(delay), n)
        axpy!(delay[d], view(x, 1:(n - d + 1)), view(y, d:n))
    end
    return y
end

function convolve_pmf(a::AbstractVector, b::AbstractVector)
    (isempty(a) || isempty(b)) &&
        return zeros(promote_type(eltype(a), eltype(b)), 0)
    na = length(a)
    nb = length(b)
    Tp = promote_type(eltype(a), eltype(b))
    y = zeros(Tp, na + nb - 1)
    @inbounds for i in 1:na, j in 1:nb
        y[i + j - 1] += a[i] * b[j]
    end
    return y
end

# src/models/observations.jl L1922-L1930
function accumulate_occupancy(
        A_bvd::AbstractVector, A_bg::AbstractVector,
        deaths::AbstractVector, recover::AbstractVector,
        ruleout::AbstractVector, κ::Real, conf_hazard::AbstractVector
    )
    return _accumulate_occupancy(
        Val(false), A_bvd, A_bg, deaths, recover, ruleout, κ, conf_hazard
    )
end

# src/models/observations.jl L1943-L2014
## The forward balance of `accumulate_occupancy`. With `Val(true)` it also
## returns the non-case stock `O_bg` and the branch flags for each day, which
## the Mooncake rule in `src/mooncake_rules.jl` reads.
function _accumulate_occupancy(
        ::Val{record}, A_bvd, A_bg, deaths, recover, ruleout, κ,
        conf_hazard
    ) where {record}
    n = length(A_bvd)
    T = promote_type(
        eltype(A_bvd), eltype(A_bg), eltype(deaths),
        eltype(recover), eltype(ruleout), typeof(κ), eltype(conf_hazard)
    )
    demand = Vector{T}(undef, n)
    O_bvd = Vector{T}(undef, n)
    O_conf = Vector{T}(undef, n)
    O_susp = Vector{T}(undef, n)
    abscond = Vector{T}(undef, n)
    O_bg = record ? Vector{T}(undef, n) : nothing
    flags = record ? Vector{UInt8}(undef, n) : nothing
    z = zero(T)
    Obvd_prev = z
    Obg_prev = z
    Oconf_prev = z
    Osusp_prev = z
    ## Floor for the abscond denominator so a zero suspect pool gives a zero
    ## split rather than 0/0.
    ε = eps(T)
    @inbounds for t in 1:n
        bvd_out = deaths[t] + recover[t]
        ab = κ * Osusp_prev
        x_u = Obvd_prev - Oconf_prev
        unconf = max(x_u, z)
        denom = max(Osusp_prev, ε)
        ab_bvd = ab * (unconf / denom)
        ab_bg = ab * (Obg_prev / denom)
        x_bvd = Obvd_prev + A_bvd[t] - bvd_out - ab_bvd
        Obvd_t = max(x_bvd, z)
        x_bg = Obg_prev + A_bg[t] - ruleout[t] - ab_bg
        Obg_t = max(x_bg, z)
        Dt = Obvd_t + Obg_t
        conf_in = conf_hazard[t] * unconf
        share = Obvd_prev > z ? Oconf_prev / Obvd_prev : z
        x_conf = Oconf_prev + conf_in - bvd_out * share
        Oconf_t = clamp(x_conf, z, Obvd_t)
        x_susp = Dt - Oconf_t
        Osusp_t = max(x_susp, z)
        demand[t] = Dt
        O_bvd[t] = Obvd_t
        O_conf[t] = Oconf_t
        O_susp[t] = Osusp_t
        abscond[t] = ab
        if record
            f = 0x00
            x_u > z && (f |= _OCC_UNCONF)
            Osusp_prev > ε && (f |= _OCC_DENOM)
            x_bvd > z && (f |= _OCC_BVD)
            x_bg > z && (f |= _OCC_BG)
            if x_conf > z
                f |= x_conf < Obvd_t ? _OCC_CONF_X : _OCC_CONF_HI
            end
            x_susp > z && (f |= _OCC_SUSP)
            O_bg[t] = Obg_t
            flags[t] = f
        end
        Obvd_prev = Obvd_t
        Obg_prev = Obg_t
        Oconf_prev = Oconf_t
        Osusp_prev = Osusp_t
    end
    y = (; demand, O_bvd, O_conf, O_susp, abscond)
    return record ? (y, O_bg, flags) : y
end

# `logistic` is StatsFuns' (imported at src/BVDOutbreakSize.jl L33), written
# out here so the reference needs no StatsFuns.
logistic(x) = inv(one(x) + exp(-x))

# src/renewal.jl L13-L17
@inline safe_rate(x) = _safe_rate_on(x) ? x : eps(typeof(x))

## Whether `safe_rate` passes `x` through rather than flooring it, which is
## where its slope is one.
@inline _safe_rate_on(x) = isfinite(x) && x > eps(typeof(x))

# src/models/observations.jl L18-L36
function bin_increments(
        daily::AbstractVector,
        days::AbstractVector{<:Integer}
    )
    n = length(daily)
    out = Vector{eltype(daily)}(undef, length(days))
    ## Concrete zero for empty bins, dispatched on the runtime element type
    ## so it works when the container has widened to `Vector{Any}` in predict
    ## mode (`zero(eltype(daily))` would call `zero(::Type{Any})` and error).
    zfill = isempty(daily) ? zero(eltype(daily)) : zero(@inbounds daily[begin])
    prev = 0
    @inbounds for (i, d) in enumerate(days)
        hi = clamp(Int(d), 0, n)
        lo = clamp(prev, 0, n)
        out[i] = hi > lo ? sum(@view daily[(lo + 1):hi]) : zfill
        prev = hi
    end
    return out
end

# src/models/observations.jl L1823-L1865
function abscond_thinned_flows(
        adm1::AbstractVector, pmf1::AbstractVector,
        adm2::AbstractVector, pmf2::AbstractVector,
        κ::Real, conf_hazard::AbstractVector
    )
    n = length(adm1)
    T = promote_type(
        eltype(adm1), eltype(pmf1), eltype(adm2), eltype(pmf2),
        typeof(κ), eltype(conf_hazard)
    )
    out1 = zeros(T, n)
    out2 = zeros(T, n)
    one_T = one(T)
    nmax1 = length(pmf1)
    nmax2 = length(pmf2)
    @inbounds for t in 1:n
        a1 = adm1[t]
        a2 = adm2[t]
        dmax1 = min(nmax1 - 1, n - t)
        dmax2 = min(nmax2 - 1, n - t)
        ## Both schedules run to `dboth`; only the longer one runs past it.
        dboth = min(dmax1, dmax2)
        ## Admission day: the cohort is not yet in the stock the balance
        ## charges absconds against, so it faces no abscond hazard.
        out1[t] += a1 * pmf1[1]
        out2[t] += a2 * pmf2[1]
        surv = one_T
        unconf = one_T
        for d in 1:dboth
            unconf *= one_T - conf_hazard[t + d - 1]
            surv *= one_T - κ * unconf
            out1[t + d] += a1 * pmf1[d + 1] * surv
            out2[t + d] += a2 * pmf2[d + 1] * surv
        end
        for d in (dboth + 1):max(dmax1, dmax2)
            unconf *= one_T - conf_hazard[t + d - 1]
            surv *= one_T - κ * unconf
            d <= dmax1 && (out1[t + d] += a1 * pmf1[d + 1] * surv)
            d <= dmax2 && (out2[t + d] += a2 * pmf2[d + 1] * surv)
        end
    end
    return out1, out2
end

# src/models/observations.jl L2091-L2116
function two_clock_confirmed(
        A_bvd::AbstractVector, conf_hazard::AbstractVector,
        S_clin::AbstractVector
    )
    n = length(A_bvd)
    T = promote_type(eltype(A_bvd), eltype(conf_hazard), eltype(S_clin))
    O_conf = Vector{T}(undef, n)
    L = length(S_clin)
    one_T = one(T)
    @inbounds for t in 1:n
        acc = zero(T)
        ## `prod_unconf` = probability cohort `u` is still unconfirmed at day
        ## `t`, `∏_{j=u+1}^{t}(1 − hazard_j)`, extended one factor per step as
        ## `u` walks back from `t`. `S_clin` is zero past its support, so the
        ## walk stops at cohort age `L - 1`.
        prod_unconf = one_T
        for u in t:-1:max(1, t - L + 1)
            d = t - u
            cdf_conf = one_T - prod_unconf
            acc += A_bvd[u] * cdf_conf * S_clin[d + 1]
            prod_unconf *= (one_T - conf_hazard[u])
        end
        O_conf[t] = acc
    end
    return O_conf
end

# src/models/observations.jl L3265-L3302
function onset_report_cdf_table(
        logit_h0::AbstractVector,
        γ::AbstractVector, grid_start::Integer, u_lo::Integer,
        u_hi::Integer
    )
    T = promote_type(eltype(logit_h0), eltype(γ))
    nu = max(Int(u_hi) - Int(u_lo) + 1, 0)
    table = Matrix{T}(undef, length(logit_h0), nu)
    ## The survival products, then their complements in place.
    _onset_columns!(nothing, table, logit_h0, γ, grid_start, u_lo)
    @. table = one(T) - table
    return table
end

## The survival recurrence of each onset date's delay column, the one walk
## `onset_report_cdf_table`, `onset_report_expected_total` and the table's
## Mooncake rule share. Column `k` is onset date `u_lo + k - 1`: `S[j + 1, k]` is the
## survival product up to and including delay `j`, and, unless `H` is
## `nothing`, `H[j + 1, k]` is that delay's hazard.
function _onset_columns!(
        H::Union{Nothing, AbstractMatrix}, S::AbstractMatrix,
        logit_h0::AbstractVector, γ::AbstractVector, grid_start::Integer,
        u_lo::Integer
    )
    ng = length(γ)
    T = eltype(S)
    @inbounds for k in axes(S, 2)
        u = Int(u_lo) + k - 1
        surv = one(T)
        for j in axes(S, 1)
            hj = logistic(logit_h0[j] + γ[clamp(u + j - grid_start, 1, ng)])
            surv *= (one(T) - hj)
            S[j, k] = surv
            H === nothing || (H[j, k] = hj)
        end
    end
    return nothing
end

# src/models/observations.jl L3360-L3385
function onset_report_anchor_series(
        cdf_table::AbstractMatrix,
        u_lo::Integer, a::AbstractVector
    )
    D = size(cdf_table, 1)
    nu = size(cdf_table, 2)
    T = promote_type(eltype(cdf_table), eltype(a))
    na = length(a)
    out = Vector{T}(undef, nu)
    ## `G(u, d)` shares one survival product across every `d`, and its
    ## denominator does not depend on `d`, so the weighted sum runs off the
    ## onset date's table column rather than rebuilding `G` per delay.
    @inbounds for k in 1:nu
        u = Int(u_lo) + k - 1
        invden = inv(safe_rate(D > 0 ? cdf_table[D, k] : zero(T)))
        g_prev = zero(T)
        acc = zero(T)
        for d in 0:(D - 1)
            g_cur = cdf_table[d + 1, k] * invden
            acc += (g_cur - g_prev) * a[clamp(u + d, 1, na)]
            g_prev = g_cur
        end
        out[k] = acc
    end
    return out
end

# src/renewal.jl L853-L946
function deviation_knots(
        z_level::AbstractVector, z_drift::AbstractVector,
        σ_level::Real, σ_δ::AbstractVector, φ::Real,
        groups::AbstractVector{<:UnitRange},
        factors::AbstractVector, drift_factors::AbstractVector,
        walking::AbstractVector{Bool},
        walk_index::AbstractVector{<:Integer},
        n_walking::Integer, n_knots::Integer
    )
    Tp = promote_type(
        eltype(z_level), eltype(z_drift), typeof(float(σ_level)),
        eltype(σ_δ), typeof(float(φ)),
        _factor_eltype(factors), _factor_eltype(drift_factors)
    )
    nu = length(z_level)
    δ = zeros(Tp, nu, n_knots)
    scaled = zeros(Tp, nu)
    @inbounds for (i, us) in enumerate(groups)
        isempty(us) && continue
        _correlate!(scaled, z_level, us, i <= length(factors) ? factors[i] : nothing)
        m = zero(Tp)
        for u in us
            scaled[u] *= σ_level
            m += scaled[u]
        end
        m /= length(us)
        for u in us
            δ[u, 1] = scaled[u] - m
        end
    end
    n_knots > 1 || return δ
    ## The walking units of each group, in order, so a group's innovations
    ## are one contiguous slice of its drift factor.
    walkers = [[u for u in us if walking[u]] for us in groups]
    innov = zeros(Tp, nu)
    @inbounds for k in 2:n_knots
        off = (k - 2) * n_walking
        for (i, us) in enumerate(groups)
            isempty(us) && continue
            ws = walkers[i]
            F = i <= length(drift_factors) ? drift_factors[i] : nothing
            m = zero(Tp)
            for (a, u) in enumerate(ws)
                acc = zero(Tp)
                if F === nothing
                    acc = z_drift[off + walk_index[u]]
                else
                    for b in 1:a
                        acc += F[a, b] * z_drift[off + walk_index[ws[b]]]
                    end
                end
                innov[u] = σ_δ[u] * acc
                m += innov[u]
            end
            m = isempty(ws) ? zero(Tp) : m / length(ws)
            for u in us
                δ[u, k] = φ * δ[u, k - 1] +
                    (walking[u] ? innov[u] - m : zero(Tp))
            end
        end
    end
    return δ
end

## Element type of a list of correlation factors, ignoring the `nothing`
## entries that stand for independent draws.
function _factor_eltype(factors::AbstractVector)
    T = Float64
    for F in factors
        F === nothing && continue
        T = promote_type(T, eltype(F))
    end
    return T
end

## `out[us] = F * z[us]` for a lower-triangular `F` over the group's units,
## or a copy when `F` is `nothing`.
function _correlate!(out, z, us, ::Nothing)
    @inbounds for u in us
        out[u] = z[u]
    end
    return out
end

function _correlate!(out, z, us, F::AbstractMatrix)
    @inbounds for (a, u) in enumerate(us)
        acc = zero(eltype(out))
        for b in 1:a
            acc += F[a, b] * z[first(us) + b - 1]
        end
        out[u] = acc
    end
    return out
end

# src/models/zone.jl L214-L249
function zone_fixed_terms(
        I_bar::AbstractMatrix, g::AbstractVector,
        f::AbstractVector, t0::Integer
    )
    np, n = size(I_bar)
    Tp = promote_type(eltype(I_bar), eltype(g), eltype(f))
    force_pre = zeros(Tp, np, n)
    report_pre = zeros(Tp, np, n)
    report_pre_cum = zeros(Tp, np, n)
    infections_pre = zeros(Tp, np)
    @inbounds for p in 1:np
        for t in 1:n
            acc = zero(Tp)
            for s in 1:min(length(g), t - 1)
                t - s < t0 || continue
                acc += g[s] * I_bar[p, t - s]
            end
            force_pre[p, t] = acc
            acc = zero(Tp)
            for s in 0:min(length(f) - 1, t - 1)
                t - s < t0 || continue
                acc += f[s + 1] * I_bar[p, t - s]
            end
            report_pre[p, t] = acc
        end
        run = zero(Tp)
        for t in 1:n
            t < t0 && (run += report_pre[p, t])
            report_pre_cum[p, t] = run
        end
        for t in 1:min(t0 - 1, n)
            infections_pre[p] += I_bar[p, t]
        end
    end
    return (; force_pre, report_pre, report_pre_cum, infections_pre)
end

# src/models/zone.jl L897-L1063
function zone_share_renewal(
        I_bar::AbstractMatrix, g::AbstractVector,
        δ_daily::AbstractMatrix, w0::AbstractVector,
        patch_ranges::AbstractVector{<:UnitRange}, t0::Integer,
        force_pre::AbstractMatrix;
        mix = nothing,
        ε::Union{Nothing, AbstractVector} = nothing
    )
    return zone_share_renewal_kernel(
        I_bar, g, δ_daily, w0, patch_ranges, t0, force_pre, mix, ε
    )
end

## `zone_share_renewal` with `mix` and `ε` positional, the form the reverse
## rule in `mooncake_rules.jl` is written against.
function zone_share_renewal_kernel(
        I_bar::AbstractMatrix, g::AbstractVector,
        δ_daily::AbstractMatrix, w0::AbstractVector,
        patch_ranges::AbstractVector{<:UnitRange}, t0::Integer,
        force_pre::AbstractMatrix, mix, ε
    )
    st = zone_share_renewal_with_state(
        I_bar, g, δ_daily, w0, patch_ranges, t0, force_pre, mix, ε
    )
    return (; st.shares, st.forces, st.infections, st.imports)
end

## `zone_share_renewal` keeping the per-day intermediates its adjoint reads:
## each zone's own force `u`, the mixed force `v`, the import pattern `h`,
## and per patch and day the unclamped denominators `patch_total` (the sum
## of `u` unmixed, of `v` mixed) and `share_total` (the sum of `h`). The
## rule calls this so the recursion is defined once.
function zone_share_renewal_with_state(
        I_bar::AbstractMatrix, g::AbstractVector,
        δ_daily::AbstractMatrix, w0::AbstractVector,
        patch_ranges::AbstractVector{<:UnitRange}, t0::Integer,
        force_pre::AbstractMatrix, mix, ε
    )
    nd, nz = size(δ_daily)
    np = length(patch_ranges)
    on = mix !== nothing && ε !== nothing
    ## The loop reads the per-day terms by absolute day under `@inbounds`,
    ## so one that stops short of the last day is read past its end rather
    ## than raising. Checked once per call, not per day.
    last_day = t0 + nd - 1
    size(I_bar, 2) >= last_day && size(force_pre, 2) >= last_day || throw(
        DimensionMismatch(
            "zone_share_renewal: the patch trajectories and forces must " *
                "reach day $(last_day); got $(size(I_bar, 2)) and " *
                "$(size(force_pre, 2))."
        )
    )
    if on && size(mix.import_fraction, 2) < last_day
        throw(
            DimensionMismatch(
                "zone_share_renewal: the import fractions must reach day " *
                    "$(last_day); got $(size(mix.import_fraction, 2)). " *
                    "A forecast extension has to carry the mixing forward."
            )
        )
    end
    Tp = promote_type(
        eltype(I_bar), eltype(g), eltype(δ_daily),
        eltype(w0), eltype(force_pre),
        ε === nothing ? Float64 : eltype(ε),
        on ? eltype(mix.within) : Float64,
        on ? eltype(mix.import_fraction) : Float64,
        on ? eltype(mix.origin_weight) : Float64
    )
    I = zeros(Tp, nd, nz)
    Λ = zeros(Tp, nd, nz)
    W = zeros(Tp, nd, nz)
    imports = zeros(Tp, nd, nz)
    U = zeros(Tp, nd, nz)
    V = zeros(Tp, nd, nz)
    H = zeros(Tp, nd, nz)
    patch_total = zeros(Tp, np, nd)
    share_total = zeros(Tp, np, nd)
    u = zeros(Tp, nz)
    eu = zeros(Tp, nz)
    wu = zeros(Tp, nz)
    L = length(g)
    floor_ = eps(Tp)
    @inbounds for j in 1:nd
        t = t0 + j - 1
        smax = min(L, j - 1)
        ## Every zone's own force first, since the between-patch pattern
        ## reads the zones of the other patches on the same day.
        for p in eachindex(patch_ranges)
            zs = patch_ranges[p]
            fp = force_pre[p, t]
            for z in zs
                acc = w0[z] * fp
                for s in 1:smax
                    acc += g[s] * I[j - s, z]
                end
                Λ[j, z] = acc
                u[z] = exp(δ_daily[j, z]) * acc
                U[j, z] = u[z]
            end
        end
        if !on
            for p in eachindex(patch_ranges)
                zs = patch_ranges[p]
                isempty(zs) && continue
                tot = zero(Tp)
                for z in zs
                    tot += u[z]
                end
                patch_total[p, j] = tot
                tot = max(tot, floor_)
                Ip = I_bar[p, t]
                for z in zs
                    W[j, z] = u[z] / tot
                    I[j, z] = Ip * W[j, z]
                end
            end
            continue
        end
        ## Within-patch spill, per origin as the province model exports:
        ## zone `q` sends `ε_q` of its force through the within block and
        ## keeps the rest, so the patch total is conserved exactly. The
        ## pattern the parent's arrivals land in comes from the zones of the
        ## other patches, weighted by the province model's own per-origin
        ## intensity.
        ##
        ## The within block is zero on the diagonal and across patches and
        ## the between block is zero within a patch, so each full product is
        ## exactly the restricted sum.
        for z in 1:nz
            eu[z] = ε[z] * u[z]
            wu[z] = mix.origin_weight[z] * u[z]
        end
        spill = mix.within * eu
        h = mix.between * wu
        for z in 1:nz
            V[j, z] = (one(Tp) - ε[z]) * u[z] + spill[z]
            H[j, z] = h[z]
        end
        for p in eachindex(patch_ranges)
            zs = patch_ranges[p]
            isempty(zs) && continue
            Ip = I_bar[p, t]
            Mp = mix.import_fraction[p, t] * Ip
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
                imports[j, z] = Mp * share_h
                I[j, z] = cp * V[j, z] + imports[j, z]
                W[j, z] = I[j, z] / max(Ip, floor_)
            end
        end
    end
    return (;
        shares = W, forces = Λ, infections = I, imports,
        u = U, v = V, h = H, patch_total, share_total,
    )
end

end
