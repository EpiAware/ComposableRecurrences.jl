# The benchmark matrix cases: realistic operator and model losses at a
# chosen size, shared by `benchmark/benchmarks.jl` (the CI subset) and
# `benchmark/matrix.jl` (the full grid).
#
# Each case builds a scalar loss `f(θ)` of a flat parameter vector holding
# every differentiable slot, in two arms: `rule` calls the operator as a user
# would, `NoAdjoint` wraps it so the AD backend differentiates the forward
# loop itself. Inputs are deterministic (no RNG), so every revision and
# process times the same numbers.
module MatrixCases

using ComposableRecurrences
using ComposableRecurrences: ComposableRecurrences as CR, NoAdjoint
using LinearAlgebra: I
using SparseArrays: SparseMatrixCSC, nonzeros, sparse

export Size, Case, CASES, TIERS, case, sizes, build, pending_cases

"A problem size: `T` steps, `L` lags (or delays) and `S` strata."
struct Size
    T::Int
    L::Int
    S::Int
end
Size(; T, L, S = 1) = Size(T, L, S)
Base.show(io::IO, z::Size) = print(io, "T", z.T, "_L", z.L, "_S", z.S)

"""
A matrix case: `loss(wrap, z)` returns `(f, θ)` where `f(θ)` is the scalar
loss with the operator wrapped by `wrap` (`identity` or `NoAdjoint`) and `θ`
is the flat parameter vector at size `z`. `strata` lists the strata counts
the case is meaningful at; `sparse` marks a sparse coupling.
"""
struct Case
    name::String
    description::String
    loss::Function
    strata::Vector{Int}
    sparse::Bool
end

# Deterministic pseudo-noise in [-1, 1].
_noise(a, b) = sin(12.9898 * a + 78.233 * b)
_weights(T) = [_noise(t, 1) for t in 1:T]
_weights(S, T) = [_noise(t, k + 1) for k in 1:S, t in 1:T]
_gi(L) = (g = exp.(-0.2 .* (1:L)); g ./ sum(g))

# Consecutive blocks of `θ` with the given shapes.
function _unpack(θ, shapes...)
    o = 0
    return map(shapes) do sh
        n = prod(sh)
        x = reshape(view(θ, (o + 1):(o + n)), sh...)
        o += n
        x
    end
end

_flat(xs...) = reduce(vcat, map(vec, xs))

# Single renewal, log loss.
function renewal(wrap, z::Size)
    (; T, L) = z
    W = _weights(T)
    f = function (θ)
        g, logh, logR = _unpack(θ, (L,), (L,), (T,))
        y = wrap(Recurrence(g))(exp.(logR); history = exp.(logh))
        return sum(W .* log.(y))
    end
    return f, _flat(_gi(L), fill(log(10.0), L), [0.05 * _noise(t, 2) for t in 1:T])
end

# Seeded renewal with hazard depletion: the pool starts at the population
# less the seed.
function renewal_depletion(wrap, z::Size)
    (; T, L) = z
    W = _weights(T)
    N = 1.0e5
    f = function (θ)
        g, logh, logR = _unpack(θ, (L,), (L,), (T,))
        seed = exp.(logh)
        d = CR.Depletion(N; pool0 = max(N - sum(seed), zero(eltype(θ))))
        y = wrap(Recurrence(g; modifiers = (d,)))(exp.(logR); history = seed)
        return sum(W .* log.(y))
    end
    return f, _flat(_gi(L), fill(log(10.0), L), [0.05 + 0.05 * _noise(t, 3) for t in 1:T])
end

# Strata with dense mixing and floored depletion (the 5-strata bar at S = 5,
# the zones at S = 50).
function strata_mixing(wrap, z::Size)
    (; T, L, S) = z
    W = _weights(S, T)
    pop = CR.PerStratum(fill(1.0e5, S))
    f = function (θ)
        g, K, logh, logR = _unpack(θ, (L,), (S, S), (S, L), (S, T))
        r = Recurrence(g; coupling = K, modifiers = (CR.Depletion(pop, CR.Floor()),))
        return sum(W .* log.(wrap(r)(exp.(logR); history = exp.(logh))))
    end
    K0 = 0.8I(S) .+ 0.2 / S .* ones(S, S)
    return f, _flat(_gi(L), Matrix(K0), fill(log(5.0), S, L), 0.1 .+ 0.05 .* _weights(S, T))
end

# Independent strata (identity coupling) with floored depletion: the
# large-scale point's dense-free renewal.
function strata_independent(wrap, z::Size)
    (; T, L, S) = z
    W = _weights(S, T)
    pop = CR.PerStratum(fill(1.0e5, S))
    f = function (θ)
        g, logh, logR = _unpack(θ, (L,), (S, L), (S, T))
        r = Recurrence(g; modifiers = (CR.Depletion(pop, CR.Floor()),))
        return sum(W .* log.(wrap(r)(exp.(logR); history = exp.(logh))))
    end
    return f, _flat(_gi(L), fill(log(5.0), S, L), 0.1 .+ 0.05 .* _weights(S, T))
end

# A ring of neighbours: self plus two either side, rows sum to one.
function _ring(S)
    I_, J_, V_ = Int[], Int[], Float64[]
    for i in 1:S, d in -2:2
        push!(I_, i)
        push!(J_, mod1(i + d, S))
        push!(V_, d == 0 ? 0.8 : 0.05)
    end
    return sparse(I_, J_, V_, S, S)
end

# Zones on a sparse ring coupling with floored depletion.
function zones_sparse(wrap, z::Size)
    (; T, L, S) = z
    W = _weights(S, T)
    K0 = _ring(S)
    pop = CR.PerStratum(fill(1.0e5, S))
    f = function (θ)
        g, v, logh, logR = _unpack(θ, (L,), (length(nonzeros(K0)),), (S, L), (S, T))
        K = SparseMatrixCSC(S, S, K0.colptr, K0.rowval, collect(v))
        r = Recurrence(g; coupling = K, modifiers = (CR.Depletion(pop, CR.Floor()),))
        return sum(W .* log.(wrap(r)(exp.(logR); history = exp.(logh))))
    end
    return f, _flat(_gi(L), nonzeros(K0), fill(log(5.0), S, L), 0.1 .+ 0.05 .* _weights(S, T))
end

# The BVD patch model: importation by redistribution, then seeded hazard
# depletion per patch.
function bvd_patch(wrap, z::Size)
    (; T, L, S) = z
    W = _weights(S, T)
    N = fill(1.0e5, S)
    f = function (θ)
        g, K, logh, logR, ε = _unpack(θ, (L,), (S, S), (S, L), (S, T), (1,))
        seeds = exp.(logh)
        pool0 = CR.PerStratum(max.(N .- vec(sum(seeds; dims = 2)), 0))
        mods = (
            CR.Redistribute(K, only(ε)),
            CR.Depletion(CR.PerStratum(N); pool0),
        )
        y = wrap(Recurrence(g; modifiers = mods))(exp.(logR); history = seeds)
        return sum(W .* log.(y))
    end
    K0 = 0.05 .* (ones(S, S) .- I(S))
    return f, _flat(_gi(L), K0, fill(log(5.0), S, L), 0.1 .+ 0.05 .* _weights(S, T), [0.5])
end

# Strata with leaky vaccination: doses move susceptibles into a protected
# pool drawn from at relative susceptibility σ.
function strata_vaccination(wrap, z::Size)
    (; T, L, S) = z
    W = _weights(S, T)
    pop = CR.PerStratum(fill(1.0e5, S))
    f = function (θ)
        g, logh, logR, doses, σ = _unpack(θ, (L,), (S, L), (S, T), (S, T), (1,))
        d = CR.Depletion(
            pop; removals = TimeVarying(PerStratum(doses)),
            protected = CR.Protected(only(σ))
        )
        r = Recurrence(g; modifiers = (d,))
        return sum(W .* log.(wrap(r)(exp.(logR); history = exp.(logh))))
    end
    doses = [100.0 * (1 + _noise(t, k + 9)) for k in 1:S, t in 1:T]
    return f, _flat(_gi(L), fill(log(5.0), S, L), 0.1 .+ 0.05 .* _weights(S, T), doses, [0.3])
end

# A fixed reporting delay with history.
function delay_fixed(wrap, z::Size)
    (; T, L) = z
    W = _weights(T)
    f = function (θ)
        g, h, x = _unpack(θ, (L,), (L,), (T,))
        return sum(W .* wrap(Convolution(vcat(zero(eltype(θ)), g)))(x; history = h))
    end
    return f, _flat(_gi(L), ones(L), [1.0 + 0.5 * _noise(t, 4) for t in 1:T])
end

# A time-varying per-stratum delay, indexed by output (secondary) or input
# (primary) time.
function _delay_varying(wrap, z::Size, indexing)
    (; T, L, S) = z
    W = _weights(S, T)
    f = function (θ)
        G, X = _unpack(θ, (S, L, T), (S, T))
        kernel = TimeVarying(PerStratum(G), indexing)
        return sum(W .* wrap(Convolution(kernel))(X))
    end
    G0 = repeat(reshape(_gi(L), 1, L, 1), S, 1, T)
    return f, _flat(G0, 1.0 .+ 0.5 .* _weights(S, T))
end
delay_secondary(wrap, z::Size) = _delay_varying(wrap, z, CR.Secondary())
delay_primary(wrap, z::Size) = _delay_varying(wrap, z, CR.Primary())

# An AR(2) latent process driven by additive innovations; `L` is unused.
function ar(wrap, z::Size)
    (; T) = z
    W = _weights(T)
    f = function (θ)
        φ, h, ϵ = _unpack(θ, (2,), (2,), (T,))
        return sum(W .* wrap(Recurrence(φ))(; history = h, add = ϵ))
    end
    return f, _flat([0.6, 0.2], [0.1, -0.1], [0.1 * _noise(t, 5) for t in 1:T])
end

"The cases, in report order."
const CASES = [
    Case("renewal", "single renewal", renewal, [1], false),
    Case(
        "renewal_depletion", "seeded renewal, hazard depletion",
        renewal_depletion, [1], false,
    ),
    Case(
        "strata_mixing", "dense mixing, floored depletion", strata_mixing,
        [5, 50], false,
    ),
    Case(
        "strata_independent", "identity coupling, floored depletion",
        strata_independent, [5, 50, 500], false,
    ),
    Case(
        "zones_sparse", "sparse ring coupling, floored depletion",
        zones_sparse, [50, 500], true,
    ),
    Case(
        "bvd_patch", "importation redistribution, seeded hazard depletion",
        bvd_patch, [5, 50], false,
    ),
    Case(
        "strata_vaccination", "leaky vaccination into a protected pool",
        strata_vaccination, [5, 50], false,
    ),
    Case("delay_fixed", "fixed delay with history", delay_fixed, [1], false),
    Case(
        "delay_secondary", "time-varying delay by output time",
        delay_secondary, [5, 50], false,
    ),
    Case(
        "delay_primary", "time-varying delay by input time", delay_primary,
        [5, 50], false,
    ),
    Case("ar", "AR(2) with additive innovations", ar, [1], false),
]

"Cases not yet on `main`, listed so the report shows them as pending."
pending_cases() = [("transform", "pointwise Transform modifier (M4)")]

"The case called `name`."
case(name) = CASES[findfirst(c -> c.name == name, CASES)]

"""
The size tiers. `smoke` checks every case at a tiny size; `ci` is the AirspeedVelocity subset; `realistic` spans
T 200-400, L 20-60 and S 1/5/50; `large` is S = 500, T = 2000.
"""
const TIERS = Dict(
    "smoke" => (
        cases = [c.name for c in CASES],
        sizes = [(T = 20, L = 4)],
        strata = [1, 5, 50],
    ),
    "ci" => (
        cases = ["renewal", "strata_mixing", "bvd_patch", "delay_fixed"],
        sizes = [(T = 200, L = 20)],
        strata = [1, 5],
    ),
    "realistic" => (
        cases = [c.name for c in CASES],
        sizes = [(T = 200, L = 20), (T = 400, L = 60)],
        strata = [1, 5, 50],
    ),
    "large" => (
        cases = ["strata_independent", "zones_sparse", "delay_fixed"],
        sizes = [(T = 2000, L = 20)],
        strata = [1, 500],
    ),
)

"The sizes of case `c` in tier `tier`."
function sizes(c::Case, tier)
    spec = TIERS[tier]
    c.name in spec.cases || return Size[]
    strata = intersect(c.strata, spec.strata)
    return [Size(sz.T, sz.L, S) for sz in spec.sizes for S in strata]
end

"`(f, θ)` for case `c` at size `z` in arm `arm` (`\"rule\"` or `\"NoAdjoint\"`)."
function build(c::Case, z::Size, arm::AbstractString)
    wrap = arm == "NoAdjoint" ? NoAdjoint : identity
    return c.loss(wrap, z)
end

end # module MatrixCases
