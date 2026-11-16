# A verbatim copy of the BVDOutbreakSize.jl port's helpers that carry their
# own Mooncake rules: `occupancy_outputs`, the outputs of the occupancy
# balance from its three pools, and `abscond_inputs`, `hold_last` and
# `split_rows`, the fills and splits around the abscond-thinned flows and
# the two-clock confirmed stock, `patch_outputs`, the outputs of the patch
# renewal from its seeds, run and arrivals, and `onset_offsets`, the
# calendar offsets the onset report table reads.
#
# Source: https://github.com/epiforecasts/BVDOutbreakSize at commit b4d4c602
# (epiforecasts/BVDOutbreakSize#1152), src/models/observations.jl,
# src/renewal.jl and src/mooncake_rules.jl, at the lines given above each
# piece. The code is unchanged; the module wrapper and imports stand in for
# those files' own, and comments stand in for the docstrings.
#
# The benchmark matrix includes it for the package arms of `bvd_occupancy`,
# `bvd_abscond_port`, `bvd_two_clock_port`, `bvd_patches_port` and
# `bvd_onset_port`, which spell those kernels as that port does.
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

# The CR spelling's helpers, each one fill or split with its own reverse
# rule. src/models/observations.jl L1909-L1942
function abscond_inputs(
        adm1::AbstractVector, pmf1::AbstractVector,
        adm2::AbstractVector, pmf2::AbstractVector,
        conf_hazard::AbstractVector
    )
    n = length(adm1)
    L1, L2 = length(pmf1), length(pmf2)
    D = max(L1, L2)
    T = promote_type(
        eltype(adm1), eltype(pmf1), eltype(adm2), eltype(pmf2),
        eltype(conf_hazard)
    )
    late = Vector{T}(undef, n + D + 1)
    late[1] = conf_hazard[1]
    @inbounds for t in 1:n
        late[t + 1] = conf_hazard[t]
    end
    @inbounds for j in 1:D
        late[n + 1 + j] = conf_hazard[n]
    end
    pmfs = zeros(T, 2, D)
    @inbounds for j in 1:L1
        pmfs[1, j] = pmf1[j]
    end
    @inbounds for j in 1:L2
        pmfs[2, j] = pmf2[j]
    end
    adm = Matrix{T}(undef, 2, n)
    @inbounds for t in 1:n
        adm[1, t] = adm1[t]
        adm[2, t] = adm2[t]
    end
    return (; late, pmfs, adm)
end

# src/models/observations.jl L1949-L1959
function hold_last(x::AbstractVector, m::Integer)
    n = length(x)
    y = Vector{eltype(x)}(undef, n + m)
    @inbounds for t in 1:n
        y[t] = x[t]
    end
    @inbounds for j in 1:m
        y[n + j] = x[n]
    end
    return y
end

# src/models/observations.jl L1966-L1975
function split_rows(M::AbstractMatrix)
    n = size(M, 2)
    r1 = Vector{eltype(M)}(undef, n)
    r2 = Vector{eltype(M)}(undef, n)
    @inbounds for t in 1:n
        r1[t] = M[1, t]
        r2[t] = M[2, t]
    end
    return r1, r2
end

# src/mooncake_rules.jl L1164-L1215
## The CR abscond inputs: each filled entry's adjoint goes back to the
## entry it was copied from. The hazard's first day is read twice and its
## last day once per padded day. The two admission tangents may alias, so
## the pullback only adds into them.
Mooncake.@is_primitive(
    Mooncake.MinimalCtx,
    Tuple{
        typeof(abscond_inputs), Vector{<:Mooncake.IEEEFloat},
        Vector{<:Mooncake.IEEEFloat}, Vector{<:Mooncake.IEEEFloat},
        Vector{<:Mooncake.IEEEFloat}, Vector{<:Mooncake.IEEEFloat},
    }
)
function Mooncake.rrule!!(
        ::CoDual{typeof(abscond_inputs)}, adm1::CoDual, pmf1::CoDual,
        adm2::CoDual, pmf2::CoDual, conf_hazard::CoDual
    )
    out = zero_fcodual(
        abscond_inputs(
            primal(adm1), primal(pmf1), primal(adm2), primal(pmf2),
            primal(conf_hazard)
        )
    )
    ȳ = tangent(out)
    function abscond_inputs_pullback!!(::NoRData)
        ā1, p̄1, ā2, p̄2 = tangent(adm1), tangent(pmf1), tangent(adm2),
            tangent(pmf2)
        h̄ = tangent(conf_hazard)
        n = length(ā1)
        D = size(ȳ.pmfs, 2)
        @inbounds begin
            h̄[1] += ȳ.late[1]
            for t in 1:n
                h̄[t] += ȳ.late[t + 1]
            end
            for j in 1:D
                h̄[n] += ȳ.late[n + 1 + j]
            end
            for j in eachindex(p̄1)
                p̄1[j] += ȳ.pmfs[1, j]
            end
            for j in eachindex(p̄2)
                p̄2[j] += ȳ.pmfs[2, j]
            end
            for t in 1:n
                ā1[t] += ȳ.adm[1, t]
                ā2[t] += ȳ.adm[2, t]
            end
        end
        return ntuple(_ -> NoRData(), 6)
    end
    return out, abscond_inputs_pullback!!
end

# src/mooncake_rules.jl L1239-L1261
## `x` then `m` copies of its last value: the padded days' adjoints all
## land on that last value.
Mooncake.@is_primitive(
    Mooncake.MinimalCtx,
    Tuple{typeof(hold_last), Vector{<:Mooncake.IEEEFloat}, Integer}
)
function Mooncake.rrule!!(::CoDual{typeof(hold_last)}, x::CoDual, m::CoDual)
    xp, mp = primal(x), primal(m)
    out = zero_fcodual(hold_last(xp, mp))
    ȳ = tangent(out)
    function hold_last_pullback!!(::NoRData)
        x̄ = tangent(x)
        n = length(xp)
        @inbounds for t in 1:n
            x̄[t] += ȳ[t]
        end
        @inbounds for j in 1:mp
            x̄[n] += ȳ[n + j]
        end
        return NoRData(), NoRData(), NoRData()
    end
    return out, hold_last_pullback!!
end

# src/mooncake_rules.jl L1263-L1278
Mooncake.@is_primitive(
    Mooncake.MinimalCtx, Tuple{typeof(split_rows), Matrix{<:Mooncake.IEEEFloat}}
)
function Mooncake.rrule!!(::CoDual{typeof(split_rows)}, M::CoDual)
    out = zero_fcodual(split_rows(primal(M)))
    r̄1, r̄2 = tangent(out)
    function split_rows_pullback!!(::NoRData)
        M̄ = tangent(M)
        @inbounds for t in axes(M̄, 2)
            M̄[1, t] += r̄1[t]
            M̄[2, t] += r̄2[t]
        end
        return NoRData(), NoRData()
    end
    return out, split_rows_pullback!!
end

# src/renewal.jl L439-L456
function patch_outputs(
        seeds::AbstractMatrix, run::AbstractMatrix, arrivals::AbstractMatrix
    )
    np, L = size(seeds)
    m = size(run, 2)
    T = promote_type(eltype(seeds), eltype(run), eltype(arrivals))
    infections = Matrix{T}(undef, np, L + m)
    importation = Matrix{T}(undef, np, L + m)
    @inbounds for t in 1:L, p in 1:np
        infections[p, t] = seeds[p, t]
        importation[p, t] = zero(T)
    end
    @inbounds for t in 1:m, p in 1:np
        infections[p, L + t] = run[p, t]
        importation[p, L + t] = arrivals[p, t]
    end
    return (; infections, importation)
end

# src/mooncake_rules.jl L1318-L1348

## The patch renewal's outputs: each block of the infections' and the
## importation's adjoints goes back to the input it was copied from.
Mooncake.@is_primitive(
    Mooncake.MinimalCtx,
    Tuple{
        typeof(patch_outputs), Matrix{<:Mooncake.IEEEFloat},
        Matrix{<:Mooncake.IEEEFloat}, Matrix{<:Mooncake.IEEEFloat},
    }
)
function Mooncake.rrule!!(
        ::CoDual{typeof(patch_outputs)}, seeds::CoDual, run::CoDual,
        arrivals::CoDual
    )
    sp, rp, ap = primal(seeds), primal(run), primal(arrivals)
    out = zero_fcodual(patch_outputs(sp, rp, ap))
    ȳ = tangent(out)
    function patch_outputs_pullback!!(::NoRData)
        s̄, r̄, ā = tangent(seeds), tangent(run), tangent(arrivals)
        np, L = size(sp)
        @inbounds for t in 1:L, p in 1:np
            s̄[p, t] += ȳ.infections[p, t]
        end
        @inbounds for t in axes(rp, 2), p in 1:np
            r̄[p, t] += ȳ.infections[p, L + t]
            ā[p, t] += ȳ.importation[p, L + t]
        end
        return NoRData(), NoRData(), NoRData(), NoRData()
    end
    return out, patch_outputs_pullback!!
end

# src/models/observations.jl L3532-L3539
function onset_offsets(γ::AbstractVector, off::Integer, m::Integer)
    ng = length(γ)
    y = Vector{eltype(γ)}(undef, m)
    @inbounds for t in 1:m
        y[t] = γ[clamp(t + off, 1, ng)]
    end
    return y
end

# src/mooncake_rules.jl L1217-L1237
## The clamped offset read: each day's adjoint lands on the offset it read.
Mooncake.@is_primitive(
    Mooncake.MinimalCtx,
    Tuple{typeof(onset_offsets), Vector{<:Mooncake.IEEEFloat}, Integer, Integer}
)
function Mooncake.rrule!!(
        ::CoDual{typeof(onset_offsets)}, γ::CoDual, off::CoDual, m::CoDual
    )
    γp, op, mp = primal(γ), primal(off), primal(m)
    out = zero_fcodual(onset_offsets(γp, op, mp))
    ȳ = tangent(out)
    function onset_offsets_pullback!!(::NoRData)
        γ̄ = tangent(γ)
        ng = length(γp)
        @inbounds for t in 1:mp
            γ̄[clamp(t + op, 1, ng)] += ȳ[t]
        end
        return ntuple(_ -> NoRData(), 4)
    end
    return out, onset_offsets_pullback!!
end

end
