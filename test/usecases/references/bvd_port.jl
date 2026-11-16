# A verbatim copy of the BVDOutbreakSize.jl port's `occupancy_outputs` and
# its Mooncake rule: the outputs of the occupancy balance from its three
# pools, in one loop with its own reverse pass.
#
# Source: https://github.com/epiforecasts/BVDOutbreakSize at commit b4d4c602
# (epiforecasts/BVDOutbreakSize#1152), src/models/observations.jl
# L2088-L2117 and src/mooncake_rules.jl L1280-L1317. The code is unchanged;
# the module wrapper and imports stand in for those files' own, and a comment
# stands in for the docstring.
#
# The benchmark matrix includes it for the package arm of `bvd_occupancy`,
# which spells the balance as that port does.
module BVDPort

import Mooncake
using Mooncake: CoDual, NoRData, primal, tangent, zero_fcodual

# The outputs of the occupancy balance from its three pools `Y` `(3 × n)`,
# unconfirmed and confirmed true cases and the non-case stock, and the
# abscond rate `κ`: the demand, the true-case, confirmed and suspect stocks,
# and the abscond flow off the previous day's suspect stock.
# src/models/observations.jl L2098-L2117
function occupancy_outputs(Y::AbstractMatrix, κ::Real)
    n = size(Y, 2)
    T = promote_type(eltype(Y), typeof(κ))
    demand = Vector{T}(undef, n)
    O_bvd = Vector{T}(undef, n)
    O_conf = Vector{T}(undef, n)
    O_susp = Vector{T}(undef, n)
    abscond = Vector{T}(undef, n)
    prev = zero(T)
    @inbounds for t in 1:n
        u, c, b = Y[1, t], Y[2, t], Y[3, t]
        O_conf[t] = c
        O_bvd[t] = u + c
        O_susp[t] = u + b
        demand[t] = u + c + b
        abscond[t] = κ * prev
        prev = u + b
    end
    return (; demand, O_bvd, O_conf, O_susp, abscond)
end

## The occupancy outputs from its pools: each output is a sum of pool
## rows, and the abscond flow is `κ` times the previous day's suspect stock.
# src/mooncake_rules.jl L1280-L1317
Mooncake.@is_primitive(
    Mooncake.MinimalCtx,
    Tuple{
        typeof(occupancy_outputs), Matrix{<:Mooncake.IEEEFloat},
        Mooncake.IEEEFloat,
    }
)
function Mooncake.rrule!!(
        ::CoDual{typeof(occupancy_outputs)}, Y::CoDual, κ::CoDual
    )
    Yp, κp = primal(Y), primal(κ)
    out = zero_fcodual(occupancy_outputs(Yp, κp))
    ȳ = tangent(out)
    function occupancy_outputs_pullback!!(::NoRData)
        Ȳ = tangent(Y)
        n = size(Yp, 2)
        κ̄ = zero(κp)
        @inbounds for t in 1:n
            d̄ = ȳ.demand[t]
            ū = d̄ + ȳ.O_bvd[t] + ȳ.O_susp[t]
            c̄ = d̄ + ȳ.O_bvd[t] + ȳ.O_conf[t]
            b̄ = d̄ + ȳ.O_susp[t]
            if t < n
                ā = ȳ.abscond[t + 1]
                κ̄ += ā * (Yp[1, t] + Yp[3, t])
                ū += ā * κp
                b̄ += ā * κp
            end
            Ȳ[1, t] += ū
            Ȳ[2, t] += c̄
            Ȳ[3, t] += b̄
        end
        return NoRData(), NoRData(), κ̄
    end
    return out, occupancy_outputs_pullback!!
end

end
