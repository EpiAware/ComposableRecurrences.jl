# A verbatim copy of the BVDOutbreakSize.jl Mooncake rules for the backend
# kernels the benchmark matrix times, on the reference forward passes in
# `bvd.jl`.
#
# Source: https://github.com/epiforecasts/BVDOutbreakSize at commit 73c575bd,
# src/mooncake_rules.jl, at the lines given above each rule. The code is
# unchanged; the module wrapper and imports stand in for that file's own.
#
# It is kept apart from `bvd.jl` so that the use-case tests, which load
# `bvd.jl`, do not need Mooncake. The benchmark matrix includes both, after
# `bvd.jl`, for the `handrule` arms of the backend cases.
module BVDReferenceRules

import Mooncake
using Mooncake: CoDual, NoRData, primal, tangent
using ..BVDReference: accumulate_occupancy, _accumulate_occupancy,
    _OCC_UNCONF, _OCC_DENOM, _OCC_BVD, _OCC_BG, _OCC_CONF_X, _OCC_CONF_HI,
    _OCC_SUSP, abscond_thinned_flows, two_clock_confirmed, patch_infections,
    patch_infections_with_state, _patch_force, _patch_outflow,
    onset_report_cdf_table, _onset_columns!

# src/mooncake_rules.jl L776-L898
Mooncake.@is_primitive(
    Mooncake.MinimalCtx,
    Tuple{
        typeof(accumulate_occupancy), Array{<:Mooncake.IEEEFloat},
        Array{<:Mooncake.IEEEFloat}, Array{<:Mooncake.IEEEFloat},
        Array{<:Mooncake.IEEEFloat}, Array{<:Mooncake.IEEEFloat},
        Mooncake.IEEEFloat, Array{<:Mooncake.IEEEFloat},
    },
)

function Mooncake.rrule!!(
        ::CoDual{typeof(accumulate_occupancy)},
        A_bvd::CoDual{<:Array{<:Mooncake.IEEEFloat}},
        A_bg::CoDual{<:Array{<:Mooncake.IEEEFloat}},
        deaths::CoDual{<:Array{<:Mooncake.IEEEFloat}},
        recover::CoDual{<:Array{<:Mooncake.IEEEFloat}},
        ruleout::CoDual{<:Array{<:Mooncake.IEEEFloat}},
        κ::CoDual{<:Mooncake.IEEEFloat},
        conf_hazard::CoDual{<:Array{<:Mooncake.IEEEFloat}}
    )
    κp = primal(κ)
    hp = primal(conf_hazard)
    dp = primal(deaths)
    rp = primal(recover)
    Āb = tangent(A_bvd)
    Āg = tangent(A_bg)
    d̄ = tangent(deaths)
    r̄ = tangent(recover)
    ō = tangent(ruleout)
    h̄ = tangent(conf_hazard)
    y, O_bg, flags = _accumulate_occupancy(
        Val(true), primal(A_bvd), primal(A_bg), dp, rp, primal(ruleout), κp,
        hp
    )
    ȳ = map(zero, y)
    function accumulate_occupancy_pullback!!(::NoRData)
        Tf = eltype(y.demand)
        z = zero(Tf)
        ε = eps(Tf)
        κ̄ = zero(Tf)
        ## Adjoints of the day-`t` stocks, carried back from day `t + 1`.
        cb = z
        cg = z
        cc = z
        cs = z
        @inbounds for t in length(flags):-1:1
            f = flags[t]
            Pb = t > 1 ? y.O_bvd[t - 1] : z
            Pg = t > 1 ? O_bg[t - 1] : z
            Pc = t > 1 ? y.O_conf[t - 1] : z
            Ps = t > 1 ? y.O_susp[t - 1] : z
            bvd_out = dp[t] + rp[t]
            ab = κp * Ps
            unconf = f & _OCC_UNCONF != 0 ? Pb - Pc : z
            denom = f & _OCC_DENOM != 0 ? Ps : ε
            share = Pb > z ? Pc / Pb : z
            gOb = ȳ.O_bvd[t] + cb
            gOg = cg
            gOc = ȳ.O_conf[t] + cc
            gOs = ȳ.O_susp[t] + cs
            gD = ȳ.demand[t]
            gab = ȳ.abscond[t]
            ## `O_susp = max(D − O_conf, 0)`
            if f & _OCC_SUSP != 0
                gD += gOs
                gOc -= gOs
            end
            ## `O_conf = clamp(x_conf, 0, O_bvd)`
            gx_c = z
            if f & _OCC_CONF_X != 0
                gx_c = gOc
            elseif f & _OCC_CONF_HI != 0
                gOb += gOc
            end
            nb = z
            nc = gx_c
            gbo = -gx_c * share
            if Pb > z
                gshare = -gx_c * bvd_out
                nc += gshare / Pb
                nb -= gshare * share / Pb
            end
            h̄[t] += gx_c * unconf
            gu = gx_c * hp[t]
            ## `D = O_bvd + O_bg`, each `max(x, 0)` of its balance
            gOb += gD
            gOg += gD
            gx_b = f & _OCC_BVD != 0 ? gOb : z
            gx_g = f & _OCC_BG != 0 ? gOg : z
            nb += gx_b
            Āb[t] += gx_b
            gbo -= gx_b
            ng = gx_g
            Āg[t] += gx_g
            ō[t] -= gx_g
            ## Abscond split `ab · (unconf / denom)` and `ab · (O_bg / denom)`
            qu = unconf / denom
            qg = Pg / denom
            gab -= gx_b * qu + gx_g * qg
            gqu = -gx_b * ab
            gqg = -gx_g * ab
            gu += gqu / denom
            ng += gqg / denom
            gden = -(gqu * qu + gqg * qg) / denom
            ns = f & _OCC_DENOM != 0 ? gden : z
            if f & _OCC_UNCONF != 0
                nb += gu
                nc -= gu
            end
            κ̄ += gab * Ps
            ns += gab * κp
            d̄[t] += gbo
            r̄[t] += gbo
            cb = nb
            cg = ng
            cc = nc
            cs = ns
        end
        return NoRData(), NoRData(), NoRData(), NoRData(), NoRData(),
            NoRData(), convert(typeof(κp), κ̄), NoRData()
    end
    return CoDual(y, ȳ), accumulate_occupancy_pullback!!
end

# The rules for `abscond_thinned_flows` and `two_clock_confirmed`, on the
# reference forward passes in `bvd.jl`, which match 73c575bd's.
# src/mooncake_rules.jl L541-L549
Mooncake.@is_primitive(
    Mooncake.MinimalCtx,
    Tuple{
        typeof(abscond_thinned_flows), Array{<:Mooncake.IEEEFloat},
        Array{<:Mooncake.IEEEFloat}, Array{<:Mooncake.IEEEFloat},
        Array{<:Mooncake.IEEEFloat}, Mooncake.IEEEFloat,
        Array{<:Mooncake.IEEEFloat},
    },
)

# src/mooncake_rules.jl L580-L668

## Adjoint of the confirmation-stopped abscond thinning. Per cohort `t` the
## forward walk is
##
##     u[d] = u[d−1] · (1 − h[t+d−1]),    s[d] = s[d−1] · (1 − κ u[d])
##     outk[t+d] += admk[t] · pmfk[d+1] · s[d]
##
## The pullback recomputes `u` and `s` for one cohort into scratch buffers,
## then walks the cohort backwards carrying `s̄` and `ū`.
function Mooncake.rrule!!(
        ::CoDual{typeof(abscond_thinned_flows)},
        adm1::CoDual{<:Array{<:Mooncake.IEEEFloat}},
        pmf1::CoDual{<:Array{<:Mooncake.IEEEFloat}},
        adm2::CoDual{<:Array{<:Mooncake.IEEEFloat}},
        pmf2::CoDual{<:Array{<:Mooncake.IEEEFloat}},
        κ::CoDual{<:Mooncake.IEEEFloat},
        conf_hazard::CoDual{<:Array{<:Mooncake.IEEEFloat}}
    )
    a1p, p1p = primal(adm1), primal(pmf1)
    a2p, p2p = primal(adm2), primal(pmf2)
    κp = primal(κ)
    hp = primal(conf_hazard)
    ## `abscond_thinned_flow` passes the same arrays twice, so these tangents
    ## can alias: the pullback only ever adds into them.
    ā1, p̄1 = tangent(adm1), tangent(pmf1)
    ā2, p̄2 = tangent(adm2), tangent(pmf2)
    h̄ = tangent(conf_hazard)
    y1, y2 = abscond_thinned_flows(a1p, p1p, a2p, p2p, κp, hp)
    ȳ1 = zero(y1)
    ȳ2 = zero(y2)
    function abscond_thinned_flows_pullback!!(::NoRData)
        n = length(a1p)
        nmax1 = length(p1p)
        nmax2 = length(p2p)
        T = eltype(y1)
        one_T = one(T)
        u = Vector{T}(undef, max(nmax1, nmax2))
        s = similar(u)
        κ̄ = zero(T)
        @inbounds for t in 1:n
            a1 = a1p[t]
            a2 = a2p[t]
            dmax1 = min(nmax1 - 1, n - t)
            dmax2 = min(nmax2 - 1, n - t)
            dm = max(dmax1, dmax2)
            ## `u[d+1]`, `s[d+1]` hold the survivals at cohort age `d`.
            ā1[t] += ȳ1[t] * p1p[1]
            ā2[t] += ȳ2[t] * p2p[1]
            p̄1[1] += ȳ1[t] * a1
            p̄2[1] += ȳ2[t] * a2
            u[1] = one_T
            s[1] = one_T
            for d in 1:dm
                u[d + 1] = u[d] * (one_T - hp[t + d - 1])
                s[d + 1] = s[d] * (one_T - κp * u[d + 1])
            end
            ūc = zero(T)
            s̄c = zero(T)
            for d in dm:-1:1
                sd = s[d + 1]
                if d <= dmax1
                    g = ȳ1[t + d]
                    ā1[t] += g * p1p[d + 1] * sd
                    p̄1[d + 1] += g * a1 * sd
                    s̄c += g * a1 * p1p[d + 1]
                end
                if d <= dmax2
                    g = ȳ2[t + d]
                    ā2[t] += g * p2p[d + 1] * sd
                    p̄2[d + 1] += g * a2 * sd
                    s̄c += g * a2 * p2p[d + 1]
                end
                ## s[d] = s[d−1] · (1 − κ u[d])
                ud = u[d + 1]
                sprev = s[d]
                κ̄ -= s̄c * sprev * ud
                ūc -= s̄c * sprev * κp
                s̄c *= one_T - κp * ud
                ## u[d] = u[d−1] · (1 − h[t+d−1])
                hd = hp[t + d - 1]
                h̄[t + d - 1] -= ūc * u[d]
                ūc *= one_T - hd
            end
        end
        return NoRData(), NoRData(), NoRData(), NoRData(), NoRData(),
            oftype(κp, κ̄), NoRData()
    end
    return CoDual((y1, y2), (ȳ1, ȳ2)), abscond_thinned_flows_pullback!!
end

# src/mooncake_rules.jl L670-L676
Mooncake.@is_primitive(
    Mooncake.MinimalCtx,
    Tuple{
        typeof(two_clock_confirmed), Array{<:Mooncake.IEEEFloat},
        Array{<:Mooncake.IEEEFloat}, Array{<:Mooncake.IEEEFloat},
    },
)

# src/mooncake_rules.jl L685-L735
function Mooncake.rrule!!(
        ::CoDual{typeof(two_clock_confirmed)},
        A_bvd::CoDual{<:Array{<:Mooncake.IEEEFloat}},
        conf_hazard::CoDual{<:Array{<:Mooncake.IEEEFloat}},
        S_clin::CoDual{<:Array{<:Mooncake.IEEEFloat}}
    )
    Ap = primal(A_bvd)
    hp = primal(conf_hazard)
    Sp = primal(S_clin)
    Ā = tangent(A_bvd)
    h̄ = tangent(conf_hazard)
    S̄ = tangent(S_clin)
    O = two_clock_confirmed(Ap, hp, Sp)
    Ō = zero(O)
    function two_clock_confirmed_pullback!!(::NoRData)
        n = length(Ap)
        L = length(Sp)
        one_T = one(eltype(O))
        ## Day `t` walks cohorts `u = t, t-1, …` with the unconfirmed
        ## product `p` extended by `(1 − h[u])` after each is scored:
        ##
        ##     O[t] += A[u] · (1 − p) · S[t−u+1],   p ← p · (1 − h[u])
        ##
        ## The pullback replays each day's products into `p_at`, then walks
        ## the cohorts back in the opposite order carrying the adjoint of
        ## `p`, so no factor is divided out.
        p_at = Vector{eltype(O)}(undef, L)
        @inbounds for t in 1:n
            g = Ō[t]
            iszero(g) && continue
            umin = max(1, t - L + 1)
            p = one_T
            for u in t:-1:umin
                p_at[t - u + 1] = p
                p *= (one_T - hp[u])
            end
            p̄ = zero(one_T)
            for u in umin:t
                d = t - u
                pk = p_at[d + 1]
                s = Sp[d + 1]
                h̄[u] -= p̄ * pk
                Ā[u] += g * (one_T - pk) * s
                S̄[d + 1] += g * Ap[u] * (one_T - pk)
                p̄ = p̄ * (one_T - hp[u]) - g * Ap[u] * s
            end
        end
        return NoRData(), NoRData(), NoRData(), NoRData()
    end
    return CoDual(O, Ō), two_clock_confirmed_pullback!!
end

# The rule for `patch_infections`, on the reference forward pass in
# `bvd.jl`, which matches 73c575bd's.
# src/mooncake_rules.jl L64-L72
Mooncake.@is_primitive(
    Mooncake.MinimalCtx,
    Tuple{
        typeof(patch_infections), Matrix{<:Mooncake.IEEEFloat},
        Vector{<:Mooncake.IEEEFloat}, Matrix{<:Mooncake.IEEEFloat},
        Matrix{<:Mooncake.IEEEFloat}, Matrix{<:Mooncake.IEEEFloat},
        Vector{<:Mooncake.IEEEFloat},
    },
)

# src/mooncake_rules.jl L1358-L1459
function Mooncake.rrule!!(
        ::CoDual{typeof(patch_infections)},
        Rt::CoDual{<:Matrix{<:Mooncake.IEEEFloat}},
        g::CoDual{<:Vector{<:Mooncake.IEEEFloat}},
        seeds::CoDual{<:Matrix{<:Mooncake.IEEEFloat}},
        K::CoDual{<:Matrix{<:Mooncake.IEEEFloat}},
        ε::CoDual{<:Matrix{<:Mooncake.IEEEFloat}},
        N::CoDual{<:Vector{<:Mooncake.IEEEFloat}}
    )
    Rp = primal(Rt)
    gp = primal(g)
    Kp = primal(K)
    εp = primal(ε)
    Np = primal(N)
    seedsp = primal(seeds)
    R̄ = tangent(Rt)
    ḡ = tangent(g)
    s̄ = tangent(seeds)
    K̄ = tangent(K)
    ε̄ = tangent(ε)
    N̄ = tangent(N)
    np, n = size(Rp)
    L = size(seedsp, 2)
    st = patch_infections_with_state(Rp, gp, seedsp, Kp, εp, Np)
    y = (; st.infections, st.importation)
    out = Mooncake.zero_fcodual(y)
    Ī = tangent(out).infections
    Ā = tangent(out).importation
    I, S, rate = st.infections, st.susceptible, st.rate
    function patch_infections_pullback!!(::NoRData)
        Tf = eltype(I)
        outflow = _patch_outflow(Tf, Kp, np)
        ## Each day's force and generated infections are rebuilt from the
        ## forward infections rather than stored. The walk runs backwards so
        ## a day's adjoint is complete before it is pushed onto earlier days,
        ## and it accumulates into a copy since `Ī` is Mooncake's buffer.
        acc = copy(Ī)
        force = zeros(Tf, np)
        gen = zeros(Tf, np)
        ḡen = zeros(Tf, np)
        ōut = zeros(Tf, np)
        ȳ = zeros(Tf, np)
        S̄ = zeros(Tf, np)
        @inbounds for t in n:-1:(L + 1)
            kmax = min(t - 1, length(gp))
            for p in 1:np
                f = _patch_force(I, gp, p, t)
                force[p] = f
                gen[p] = Rp[p, t] * f
                ḡen[p] = zero(Tf)
            end
            ## Depletion, as in the single-patch rule, on the rate
            ## `x = y / N[p]` with `y` the force after the transfer.
            for p in 1:np
                x = rate[p, t]
                e = exp(-x)
                x̄ = e * S[p, t - 1] * (acc[p, t] - S̄[p])
                S̄[p] = -acc[p, t] * expm1(-x) + S̄[p] * e
                ȳ[p] = x̄ / Np[p]
                N̄[p] -= x̄ * x / Np[p]
            end
            ## y[p] = (1 - ε[p, t] outflow[p]) gen[p] + arrivals[p], and
            ## the importation output is arrivals[p] alone.
            for p in 1:np
                a = ȳ[p]
                ā = a + Ā[p, t]
                ḡen[p] += a * (one(Tf) - εp[p, t] * outflow[p])
                ε̄[p, t] -= a * outflow[p] * gen[p]
                ōut[p] -= a * εp[p, t] * gen[p]
                for q in 1:np
                    q == p && continue
                    ε̄[q, t] += ā * Kp[p, q] * gen[q]
                    K̄[p, q] += ā * εp[q, t] * gen[q]
                    ḡen[q] += ā * εp[q, t] * Kp[p, q]
                end
            end
            for p in 1:np
                R̄[p, t] += ḡen[p] * force[p]
                f̄ = ḡen[p] * Rp[p, t]
                for s in 1:kmax
                    acc[p, t - s] += f̄ * gp[s]
                    ḡ[s] += f̄ * I[p, t - s]
                end
            end
        end
        @inbounds for q in 1:np, r in 1:np
            r == q && continue
            K̄[r, q] += ōut[q]
        end
        ## Each pool after the seed is `N[p] − Σ seeds[p, :]`.
        m = min(L, n)
        @inbounds for p in 1:np
            live = Np[p] - sum(view(seedsp, p, 1:m)) > zero(Tf)
            live && (N̄[p] += S̄[p])
            for j in 1:m
                s̄[p, j] += acc[p, j] - (live ? S̄[p] : zero(Tf))
            end
        end
        return ntuple(_ -> NoRData(), 7)
    end
    return out, patch_infections_pullback!!
end

# The rule for `onset_report_cdf_table`, on the reference forward pass in
# `bvd.jl`, which matches 73c575bd's.
# src/mooncake_rules.jl L1162-L1168
Mooncake.@is_primitive(
    Mooncake.MinimalCtx,
    Tuple{
        typeof(onset_report_cdf_table), Array{<:Mooncake.IEEEFloat},
        Array{<:Mooncake.IEEEFloat}, Integer, Integer, Integer,
    },
)

# src/mooncake_rules.jl L1188-L1208
## Adjoint of one `_onset_columns!` column, with `c̄` the cotangent of
## `1 - surv`. `1 - surv[j]` has derivative `surv[j] · h[i]` in the logit
## `x_i` for every `i ≤ j`, so a column's adjoint is
## `x̄_i = h_i · Σ_{j ≥ i} c̄_j surv_j`, one backward running sum. Each `x̄_i`
## lands on `logit_h0[i]` and on the (clamped) calendar day it read from `γ`.
function _onset_column_adjoint!(
        l̄::AbstractVector, γ̄::AbstractVector, c̄::AbstractVector,
        h::AbstractVector, surv::AbstractVector, u::Integer,
        grid_start::Integer
    )
    D = length(h)
    ng = length(γ̄)
    acc = zero(eltype(l̄))
    @inbounds for j in (D - 1):-1:0
        acc += c̄[j + 1] * surv[j + 1]
        x̄ = h[j + 1] * acc
        l̄[j + 1] += x̄
        γ̄[clamp(u + j - grid_start + 1, 1, ng)] += x̄
    end
    return nothing
end

# src/mooncake_rules.jl L1210-L1245
function Mooncake.rrule!!(
        ::CoDual{typeof(onset_report_cdf_table)},
        logit_h0::CoDual{<:Array{<:Mooncake.IEEEFloat}},
        γ::CoDual{<:Array{<:Mooncake.IEEEFloat}},
        grid_start::CoDual{<:Integer}, u_lo::CoDual{<:Integer},
        u_hi::CoDual{<:Integer}
    )
    lp = primal(logit_h0)
    γp = primal(γ)
    gs = primal(grid_start)
    lo = Int(primal(u_lo))
    l̄ = tangent(logit_h0)
    γ̄ = tangent(γ)
    ## The forward pass keeps each column's hazards and survival products,
    ## so the pullback reuses them rather than re-evaluating the logistic.
    D = length(lp)
    nu = max(Int(primal(u_hi)) - lo + 1, 0)
    T = promote_type(eltype(lp), eltype(γp))
    H = Matrix{T}(undef, D, nu)
    S = Matrix{T}(undef, D, nu)
    _onset_columns!(H, S, lp, γp, gs, lo)
    table = one(T) .- S
    out = Mooncake.zero_fcodual(table)
    t̄ = tangent(out)
    function onset_report_cdf_table_pullback!!(::NoRData)
        ## `table = 1 - surv`, so the column adjoint is `t̄` itself.
        @inbounds for k in 1:nu
            _onset_column_adjoint!(
                l̄, γ̄, view(t̄, :, k), view(H, :, k), view(S, :, k),
                lo + k - 1, gs
            )
        end
        return ntuple(_ -> NoRData(), 6)
    end
    return out, onset_report_cdf_table_pullback!!
end

end
