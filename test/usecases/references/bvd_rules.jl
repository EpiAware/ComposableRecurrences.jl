# A verbatim copy of the BVDOutbreakSize.jl Mooncake rule for
# `accumulate_occupancy`, on the reference forward pass in `bvd.jl`.
#
# Source: https://github.com/epiforecasts/BVDOutbreakSize at commit 73c575bd,
# src/mooncake_rules.jl L776-L898, unchanged since 95be3b22. The code is
# unchanged; the module wrapper and imports stand in for that file's own.
#
# It is kept apart from `bvd.jl` so that the use-case tests, which load
# `bvd.jl`, do not need Mooncake. The benchmark matrix includes both, after
# `bvd.jl`, for the `handrule` arm of `bvd_occupancy`.
module BVDReferenceRules

import Mooncake
using Mooncake: CoDual, NoRData, primal, tangent
using ..BVDReference: accumulate_occupancy, _accumulate_occupancy,
    _OCC_UNCONF, _OCC_DENOM, _OCC_BVD, _OCC_BG, _OCC_CONF_X, _OCC_CONF_HI,
    _OCC_SUSP

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

end
