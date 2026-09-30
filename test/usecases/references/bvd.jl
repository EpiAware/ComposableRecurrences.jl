# Verbatim copies of the BVDOutbreakSize.jl renewal, delay and occupancy
# kernels used as the reference for the use-case tests.
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

end
