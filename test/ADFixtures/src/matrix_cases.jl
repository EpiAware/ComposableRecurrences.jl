# The benchmark matrix cases: realistic operator and model losses at a
# chosen size, shared by `benchmark/benchmarks.jl` (the CI subset) and
# `benchmark/matrix.jl` (the full grid).
#
# Each case builds a scalar loss `f(θ)` of a flat parameter vector holding
# every differentiable slot, in two arms: `rule` calls the operator as a user
# would, `NoAdjoint` wraps it so the AD backend differentiates the forward
# loop itself. Headline cases add baseline arms written without the package
# (`matrix_naive.jl`): the same loss as a hand loop or an `accumulate`.
# Inputs are deterministic (no RNG), so every revision and process times the
# same numbers.
module MatrixCases

using ComposableRecurrences
using ComposableRecurrences: ComposableRecurrences as CR, NoAdjoint
using LinearAlgebra: I
using SparseArrays: SparseMatrixCSC, nonzeros, sparse
using ..ADFixtures: supports, _TWIN_REQUIRES

export Size, Case, CASES, TIERS, case, sizes, build, arms, pending_cases,
    available

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

# Strata mixing through a kernel per pair of strata, with floored depletion:
# each stratum's force reads every stratum's own past at its own weights.
function strata_pairwise(wrap, z::Size)
    (; T, L, S) = z
    W = _weights(S, T)
    pop = CR.PerStratum(fill(1.0e5, S))
    f = function (θ)
        A, logh, logR = _unpack(θ, (S, S, L), (S, L), (S, T))
        r = Recurrence(Pairwise(A); modifiers = (CR.Depletion(pop, CR.Floor()),))
        return sum(W .* log.(wrap(r)(exp.(logR); history = exp.(logh))))
    end
    K0 = 0.8I(S) .+ 0.2 / S .* ones(S, S)
    A0 = [K0[a, b] * g for a in 1:S, b in 1:S, g in _gi(L)]
    return f, _flat(A0, fill(log(5.0), S, L), 0.1 .+ 0.05 .* _weights(S, T))
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

# BVD's unmixed zone split: the zones renew from their own infections and
# each group of zones (a province) takes its total from outside, shared by
# the force each zone earns. Five zones per group.
function zone_allocate(wrap, z::Size)
    (; T, L, S) = z
    W = _weights(S, T)
    P = max(S ÷ 5, 1)
    edges = round.(Int, range(0, S; length = P + 1))
    groups = [(edges[p] + 1):edges[p + 1] for p in 1:P]
    f = function (θ)
        g, logh, logR, logtot = _unpack(θ, (L,), (S, L), (S, T), (P, T))
        split = CR.Allocate(groups, TimeVarying(PerStratum(exp.(logtot))))
        r = Recurrence(g; modifiers = (split,))
        return sum(W .* log.(wrap(r)(exp.(logR); history = exp.(logh))))
    end
    logtot = [log(50.0) + 0.2 * _noise(t, p + 7) for p in 1:P, t in 1:T]
    return f, _flat(_gi(L), fill(log(5.0), S, L), 0.1 .* _weights(S, T), logtot)
end

# A renewal whose kernel belongs to each infector's own infection time
# (Primary indexing), seeded at times 1 to L.
function renewal_primary(wrap, z::Size)
    (; T, L) = z
    W = _weights(T)
    f = function (θ)
        K, logh, logR = _unpack(θ, (L, T), (L,), (T,))
        r = wrap(Recurrence(TimeVarying(K, CR.Primary())))
        y = r(exp.(logR); history = exp.(logh), start = L + 1)
        return sum(W[(L + 1):end] .* log.(y))
    end
    K0 = [g * (1 - 0.3 * (c > T ÷ 2)) for g in _gi(L), c in 1:T]
    return f, _flat(K0, fill(log(10.0), L), [0.05 * _noise(t, 2) for t in 1:T])
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

# The getting-started model: three towns under a gravity coupling, per-town
# hazard depletion, then a reporting delay. The loss weights the reports and
# `θ` is the reproduction number of every town on every day. At `L = 6` the
# kernels are the page's own.
const TOWN_POP = [60_000.0, 25_000.0, 10_000.0]
const TOWN_DIST = [0.0 20.0 45.0; 20.0 0.0 30.0; 45.0 30.0 0.0]

"The towns' populations and gravity coupling."
function towns()
    pop = TOWN_POP
    gravity = [a == b ? 0.0 : pop[b] / TOWN_DIST[a, b]^2 for a in 1:3, b in 1:3]
    K = 0.98 * [a == b for a in 1:3, b in 1:3] +
        0.02 * gravity ./ sum(gravity; dims = 2)
    return pop, K
end
overview_gi(L) = L == 6 ? [0.05, 0.2, 0.3, 0.25, 0.12, 0.08] : _gi(L)
function overview_delay(L)
    return L == 6 ? [0.0, 0.1, 0.25, 0.3, 0.2, 0.1, 0.05] : vcat(0.0, _gi(L))
end
overview_seed(S, L) = [k == 1 ? 10.0 : 0.0 for k in 1:S, _ in 1:L]
overview_R(S, T) = [t < T ÷ 2 ? 1.5 : 0.8 for _ in 1:S, t in 1:T]

function overview(wrap, z::Size)
    (; T, L, S) = z
    pop, K = towns()
    seed = overview_seed(S, L)
    W = _weights(S, T)
    renewal = Recurrence(
        overview_gi(L); coupling = K,
        modifiers = (CR.Depletion(PerStratum(pop)),)
    )
    delay = Convolution(overview_delay(L))
    f = function (θ)
        R = reshape(θ, S, T)
        return sum(W .* wrap(delay)(wrap(renewal)(R; history = seed)))
    end
    return f, vec(overview_R(S, T))
end

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

# Delay convolutions shaped as a delay-distribution package calls them: a
# lag-0-first pmf over a single series with no history, the loss weighting
# every output (or, `masked`, only the last 14).
function _conv_inputs(T, L)
    pmf = [0.5 + 0.5 * _noise(i, 7) for i in 1:L] ./ L
    x = [50.0 + 40.0 * _noise(t, 8) for t in 1:T]
    return pmf, x, collect(range(0.5, 2.0; length = T))
end

function conv_fixed(wrap, z::Size)
    (; T, L) = z
    pmf, x, w = _conv_inputs(T, L)
    f = θ -> sum(w .* wrap(Convolution(θ[1:L]))(θ[(L + 1):end]))
    return f, vcat(pmf, x)
end

function conv_masked(wrap, z::Size)
    (; T, L) = z
    pmf, x, w = _conv_inputs(T, L)
    f = θ -> sum(
        w[(T - 13):T] .*
            wrap(Convolution(θ[1:L]))(θ[(L + 1):end]; start = T - 13)
    )
    return f, vcat(pmf, x)
end

function _conv_matrix(wrap, z::Size, indexing)
    (; T, L) = z
    pmf, x, w = _conv_inputs(T, L)
    P = [pmf[i] * (1 + 0.1 * _noise(i, t)) for i in 1:L, t in 1:T]
    f = function (θ)
        K = TimeVarying(reshape(θ[1:(L * T)], L, T), indexing)
        return sum(w .* wrap(Convolution(K))(θ[(L * T + 1):end]))
    end
    return f, vcat(vec(P), x)
end
conv_primary(wrap, z::Size) = _conv_matrix(wrap, z, CR.Primary())
conv_secondary(wrap, z::Size) = _conv_matrix(wrap, z, CR.Secondary())

# The `conv_primary` pmfs truncated at the horizon and given as a vector of
# columns, as a delay-distribution package returns them: column `τ` holds
# delays 0 to `min(L, T - τ + 1) - 1`.
_horizon(T, L) = [min(L, T - τ + 1) for τ in 1:T]
function _columns(v, ns)
    o = cumsum([0; ns])
    return [v[(o[τ] + 1):o[τ + 1]] for τ in eachindex(ns)]
end
function _ragged_inputs(z::Size)
    (; T, L) = z
    pmf, x, w = _conv_inputs(T, L)
    ns = _horizon(T, L)
    v = [pmf[i] * (1 + 0.1 * _noise(i, t)) for t in 1:T for i in 1:ns[t]]
    return ns, w, vcat(v, x)
end
function conv_primary_ragged(wrap, z::Size)
    ns, w, θ0 = _ragged_inputs(z)
    n = sum(ns)
    f = function (θ)
        K = TimeVarying(_columns(view(θ, 1:n), ns), CR.Primary())
        return sum(w .* wrap(Convolution(K))(θ[(n + 1):end]))
    end
    return f, θ0
end

# Multi-type branching-process extinction by generation: a negative
# binomial probability generating function per stratum, iterated through a
# generation interval and a mixing matrix.
_nb_pgf(q, θ) = (θ.p / (1 - (1 - θ.p) * q))^θ.r
function transform(wrap, z::Size)
    (; T, L, S) = z
    W = _weights(S, T)
    K = S == 1 ? ones(1, 1) : fill(0.2 / (S - 1), S, S) + (0.8 - 0.2 / (S - 1)) * I
    f = function (θ)
        g, r, p = _unpack(θ, (L,), (S,), (S,))
        m = CR.Transform(_nb_pgf, (; r = PerStratum(r), p = PerStratum(p)))
        y = wrap(Recurrence(g; coupling = K, modifiers = (m,)))(
            ; history = zeros(S, L), stop = T
        )
        return sum(W .* y)
    end
    return f, _flat(_gi(L), fill(0.5, S), [0.2 + 0.2 * k / S for k in 1:S])
end

"The cases, in report order."
const CASES = [
    Case(
        "overview", "three towns, gravity, hazard depletion, delay", overview,
        [3], false,
    ),
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
        "strata_pairwise", "kernel per pair of strata, floored depletion",
        strata_pairwise, [5, 50], false,
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
    Case(
        "zone_allocate", "zones sharing exogenous group totals",
        zone_allocate, [5, 50], false,
    ),
    Case(
        "renewal_primary", "renewal with a kernel per infection time",
        renewal_primary, [1], false,
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
    Case("conv_fixed", "fixed pmf, no history", conv_fixed, [1], false),
    Case(
        "conv_masked", "fixed pmf, last 14 outputs", conv_masked, [1], false,
    ),
    Case(
        "conv_primary", "pmf per input time (L × T)", conv_primary, [1],
        false,
    ),
    Case(
        "conv_secondary", "pmf per output time (L × T)", conv_secondary, [1],
        false,
    ),
    Case(
        "conv_primary_ragged", "pmf per input time, ragged at the horizon",
        conv_primary_ragged, [1], false,
    ),
    Case(
        "transform", "per-stratum PGF iteration, Transform modifier",
        transform, [5, 50], false,
    ),
]

"Cases not yet on `main`, listed so the report shows them as pending."
pending_cases() = Tuple{String, String}[]

# The features each case needs beyond the first release, by case name, as
# `ADFixtures._REQUIRES` for the scenarios. A case not listed needs none.
const REQUIRES = Dict{String, Tuple{Vararg{Symbol}}}(
    "zone_allocate" => (:Allocate,),
    "strata_vaccination" => (:Protected,),
    "transform" => (:Transform,),
    "renewal_primary" => (:_check_primary_seed,),
    "conv_primary_ragged" => (:_Ragged,),
)

"""
    available(c::Case, arm = "rule")

Whether the loaded ComposableRecurrences can run case `c` in arm `arm`.
The benchmark history workflow builds the cases against older releases.
The `NoAdjoint` and `local` arms also need the analytic adjoint
(`uses_adjoint`).
"""
function available(c::Case, arm::AbstractString = "rule")
    extra = arm in ("NoAdjoint", "local") ? _TWIN_REQUIRES : ()
    return supports(get(REQUIRES, c.name, ())..., extra...)
end

"The case called `name`."
case(name) = CASES[findfirst(c -> c.name == name, CASES)]

"""
The size tiers. `smoke` checks every case at a tiny size; `docs` is the
getting-started model at the page's size and at T 200, L 20; `convolved`
holds the delay-distribution shapes; `ci` is the AirspeedVelocity subset;
`realistic` spans T 200-400, L 20-60 and S 1/5/50; `large` is S = 500,
T = 2000.
"""
const TIERS = Dict(
    "smoke" => (
        cases = [c.name for c in CASES],
        sizes = [(T = 20, L = 4)],
        strata = [1, 3, 5, 50],
    ),
    "ci" => (
        cases = [
            "overview", "renewal", "strata_mixing", "bvd_patch", "delay_fixed",
            "conv_fixed",
        ],
        sizes = [(T = 200, L = 20)],
        strata = [1, 3, 5],
    ),
    "docs" => (
        cases = ["overview"],
        sizes = [(T = 100, L = 6), (T = 200, L = 20)],
        strata = [1, 3],
    ),
    "convolved" => (
        cases = [
            "conv_fixed", "conv_masked", "conv_primary", "conv_secondary",
            "conv_primary_ragged",
        ],
        sizes = [(T = 400, L = 60), (T = 100, L = 10)],
        strata = [1],
        bycase = Dict(
            "conv_primary" => [(T = 400, L = 60)],
            "conv_primary_ragged" => [(T = 400, L = 60)],
            "conv_secondary" => [(T = 100, L = 10)],
        ),
    ),
    "realistic" => (
        cases = filter(n -> !startswith(n, "conv_"), [c.name for c in CASES]),
        sizes = [(T = 200, L = 20), (T = 400, L = 60)],
        strata = [1, 3, 5, 50],
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
    szs = haskey(spec, :bycase) ? get(spec.bycase, c.name, spec.sizes) : spec.sizes
    return [Size(sz.T, sz.L, S) for sz in szs for S in strata]
end

# Baseline arms without the package, by case name: `arm => builder(z)`.
const BASELINES = Dict{String, Vector{Pair{String, Function}}}()

"""
A pointwise modifier with its hand-written `pullback!` hidden, so the rule
differentiates its step locally with `ForwardDiff` in its place.
"""
struct LocalStep{M}
    m::M
end
# Older releases, which the history workflow loads, have no adjoints.
if supports(_TWIN_REQUIRES...)
    _inner(grads) = merge(grads, (; piece = CR.cotangent(grads.piece, :m)))
    CR.ispointwise(::LocalStep) = true
    # Releases that read the adjoint off `pullback!` methods differentiate
    # a step without one locally; earlier ones needed it declared.
    supports(:_local_pullback) || (CR.uses_adjoint(::LocalStep, ::CR.Step) = true)
    CR.forward(w::LocalStep, ::CR.Init, s, h) = CR.forward(w.m, CR.Init(), s, h)
    function CR.pullback!(grads, w::LocalStep, ::CR.Init, s, h)
        return CR.pullback!(_inner(grads), w.m, CR.Init(), s, h)
    end
    function CR.forward(w::LocalStep, ::CR.Step, v, s, t, k)
        return CR.forward(w.m, CR.Step(), v, s, t, k)
    end
end

"""
A user coupling with its hand-written `pullback!` hidden, so the rule
differentiates its `Pressure()` step locally with `ForwardDiff`.
"""
struct LocalPressure{C}
    C::C
end
if supports(_TWIN_REQUIRES...)
    function CR.forward(w::LocalPressure, ::CR.Pressure, q, p, t)
        return CR.forward(w.C, CR.Pressure(), q, p, t)
    end
end

# The `local` arm's wrap: each pointwise modifier with a hand-written
# `pullback!`, and a user coupling with one, is differentiated locally
# instead, the rest of the rule kept.
_hide(m) = CR.ispointwise(m) && CR.uses_adjoint(m, CR.Step()) ? LocalStep(m) : m
_hide_coupling(C) = C
function _local(r::Recurrence)
    return Recurrence(r.kernel, _hide_coupling(r.coupling), map(_hide, r.modifiers))
end
_local(op) = op

# Cases with a pointwise modifier that has a hand-written `pullback!`: they
# also run the `local` arm.
const LOCAL_CASES = Set(
    [
        "overview", "renewal_depletion", "strata_mixing", "strata_independent",
        "zones_sparse", "bvd_patch",
    ]
)

"""
The arms of case `c`: `rule`, `NoAdjoint`, `local` where the case has a
pointwise modifier or user coupling with a hand-written `pullback!`, and
its baselines.
"""
function arms(c::Case)
    return vcat(
        ["rule", "NoAdjoint"], c.name in LOCAL_CASES ? ["local"] : String[],
        first.(get(BASELINES, c.name, []))
    )
end

"""
`(f, θ)` for case `c` at size `z` in arm `arm`: `\"rule\"`, `\"NoAdjoint\"`,
`\"local\"` or one of its baselines.
"""
function build(c::Case, z::Size, arm::AbstractString)
    arm == "rule" && return c.loss(identity, z)
    arm == "NoAdjoint" && return c.loss(NoAdjoint, z)
    arm == "local" && return c.loss(_local, z)
    return Dict(get(BASELINES, c.name, []))[arm](z)
end

include("matrix_naive.jl")

# The user-written modifier of the "Writing your own modifier" page, from
# the repository's benchmark folder, in a single renewal: once with
# `forward` only and once with its `pullback!`. Skipped where the file is
# absent (a copied fixture package).
const DOCS_MODIFIER = joinpath(
    @__DIR__, "..", "..", "..", "benchmark", "docs_modifier.jl"
)
if isfile(DOCS_MODIFIER)
    include(DOCS_MODIFIER)
    function _custom_modifier(M)
        return function (wrap, z::Size)
            (; T, L) = z
            W = _weights(T)
            f = function (θ)
                g, logh, logR, logκ = _unpack(θ, (L,), (L,), (T,), (1,))
                r = Recurrence(g; modifiers = (M(exp(only(logκ))),))
                y = wrap(r)(exp.(logR); history = exp.(logh))
                return sum(W .* log.(y))
            end
            θ = _flat(
                _gi(L), fill(log(10.0), L),
                [0.3 + 0.05 * _noise(t, 6) for t in 1:T], [log(50.0)]
            )
            return f, θ
        end
    end
    push!(
        CASES,
        Case(
            "custom_modifier", "renewal with a user modifier, forward only",
            _custom_modifier(Saturation), [1], false,
        ),
        Case(
            "custom_modifier_pullback",
            "renewal with a user modifier and its pullback!",
            _custom_modifier(SaturationPullback), [1], false,
        ),
    )
    append!(TIERS["docs"].cases, ["custom_modifier", "custom_modifier_pullback"])
end

# A user coupling and a user modifier with per-stratum parameters, each
# with a hand-written `pullback!`: the `local` arm times the local
# derivative that runs without one, and `NoAdjoint` plain AD.
"A share `a` of every other stratum's pressure goes to the first."
struct ToFirst{A}
    a::A
end
"Saturation at a per-stratum or time-varying `κ`, read through `param`."
struct StrataSaturation{K}
    κ::K
end
if supports(:_local_pressure!, :_EntryParam)
    function CR.forward(C::ToFirst, ::CR.Pressure, q, p, t)
        tot = sum(view(p, 2:length(p)))
        q[1] = p[1] + C.a * tot
        for k in 2:length(p)
            q[k] = (1 - C.a) * p[k]
        end
        return nothing
    end
    function CR.pullback!(grads, C::ToFirst, ::CR.Pressure, q, p, t)
        q̄, p̄ = grads.q, grads.p
        tot = sum(view(p, 2:length(p)))
        ā = q̄[1] * tot
        p̄[1] += q̄[1]
        for k in 2:length(p)
            ā -= q̄[k] * p[k]
            p̄[k] += C.a * q̄[1] + (1 - C.a) * q̄[k]
        end
        CR.add_cotangent!(CR.cotangent(grads.piece, :a), ā)
        return nothing
    end
    _hide_coupling(C::ToFirst) = LocalPressure(C)

    CR.ispointwise(::StrataSaturation) = true
    function CR.forward(m::StrataSaturation, ::CR.Step, v, s, t, k)
        κ = CR.param(m.κ, k, t)
        return v * κ / (κ + v), s
    end
    function CR.pullback!(grads, m::StrataSaturation, ::CR.Step, v, s, t, k)
        κ = CR.param(m.κ, k, t)
        d = inv(κ + v)^2
        CR.add_param!(CR.cotangent(grads.piece, :κ), m.κ, grads.v * v^2 * d, k, t)
        return grads.v * κ^2 * d, grads.s
    end

    function custom_coupling(wrap, z::Size)
        (; T, L, S) = z
        W = _weights(S, T)
        f = function (θ)
            g, logh, logR, a = _unpack(θ, (L,), (S, L), (S, T), (1,))
            r = Recurrence(g; coupling = ToFirst(only(a)))
            y = wrap(r)(exp.(logR); history = exp.(logh))
            return sum(W .* log.(y))
        end
        θ = _flat(
            _gi(L), fill(log(10.0), S, L),
            [0.05 * _noise(t, k + 7) for k in 1:S, t in 1:T], [0.2]
        )
        return f, θ
    end

    function custom_modifier_strata(wrap, z::Size)
        (; T, L, S) = z
        W = _weights(S, T)
        f = function (θ)
            g, logh, logR, logκ = _unpack(θ, (L,), (S, L), (S, T), (S,))
            r = Recurrence(g; modifiers = (StrataSaturation(PerStratum(exp.(logκ))),))
            y = wrap(r)(exp.(logR); history = exp.(logh))
            return sum(W .* log.(y))
        end
        θ = _flat(
            _gi(L), fill(log(10.0), S, L),
            [0.3 + 0.05 * _noise(t, k + 8) for k in 1:S, t in 1:T],
            [log(40.0 + 5k) for k in 1:S]
        )
        return f, θ
    end

    push!(
        CASES,
        Case(
            "custom_coupling", "renewal across strata with a user coupling",
            custom_coupling, [3, 5, 50], false,
        ),
        Case(
            "custom_modifier_strata",
            "renewal with a user modifier with a per-stratum parameter",
            custom_modifier_strata, [3, 5, 50], false,
        ),
    )
    REQUIRES["custom_coupling"] = (:_local_pressure!,)
    REQUIRES["custom_modifier_strata"] = (:_EntryParam,)
    push!(LOCAL_CASES, "custom_coupling", "custom_modifier_strata")
    for tier in ("smoke", "realistic")
        append!(TIERS[tier].cases, ["custom_coupling", "custom_modifier_strata"])
    end
end

end # module MatrixCases
