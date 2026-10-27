# # [Spatial models](@id tutorial-spatial-strata)
#
# ## Introduction
#
# A model can run several series side by side, the [strata](@ref glossary-stratum), one per place, mixed within each step.
# Series as types rather than places are in [Branching processes](@ref tutorial-branching).
#
# ### What are we going to do in this exercise
#
# 1. Reuse the overview's gravity coupling.
# 2. Compare a fixed coupling, per-pair generation intervals and a travel cut.
# 3. Move infections between patches with `Redistribute`.
# 4. Split each patch's known infections among its districts with `Allocate`.
# 5. Combine community and funeral transmission with `Routes`.
#
# ### What might I need to know before starting
#
# This extends the three-town example in [Getting started](@ref overview-build).
# No fitting is involved.

# ## Packages used

using ComposableRecurrences
using ComposableRecurrences: Depletion, Redistribute, Allocate, movement
using CairoMakie, AlgebraOfGraphics, DataFramesMeta
using LinearAlgebra

CairoMakie.activate!(type = "png", px_per_unit = 2)

# ## A gravity coupling
#
# The coupling is the [three-town example's](@ref overview-build) gravity coupling ``K``, with the same towns as patches and 5% mixing rather than 0.2%.

patches = ["A", "B", "C"]
S, T = 3, 120
pop = [60_000.0, 25_000.0, 10_000.0]
dist = [0.0 20.0 45.0; 20.0 0.0 30.0; 45.0 30.0 0.0]
gravity = [a == b ? 0.0 : pop[b] / dist[a, b]^2 for a in 1:S, b in 1:S]
K = 0.95 * I(S) + 0.05 * gravity ./ sum(gravity; dims = 2)

@chain DataFrame(K, patches) begin
    @transform(:to = patches)
    stack(Not(:to); variable_name = :from, value_name = :weight)
    data(_) * mapping(:from, :to, :weight => "Weight") * visual(Heatmap)
    draw(_; axis = (xlabel = "From patch", ylabel = "To patch"))
end

# Most weight sits on the diagonal.
# A and B, the closest pair, share the most, and C is the most isolated.

# ## Three ways to mix
#
# The three models differ in the pressure ``q_{t,i}`` on patch ``i``:
#
# ```math
# q^{\text{fixed}}_{t,i} = \sum_{j} K_{ij} \sum_{l} g_l \, y_{t-l,j}, \qquad
# q^{\text{pair}}_{t,i} = \sum_{j} \sum_{l} A_{ij,l} \, y_{t-l,j}, \qquad
# q^{\text{cut}}_{t,i} = \sum_{j} K_{ij}(t) \sum_{l} g_l \, y_{t-l,j}.
# ```
#
# ``y_{t,j}`` is the number of infections in patch ``j`` on day ``t``.
# ``g_l`` is the generation interval's weight on lag ``l``.
# ``A_{ij,l}`` is ``K_{ij} g_l`` within a patch and ``K_{ij} g^{\text{between}}_l`` between.
# ``g^{\text{between}}_l`` is a longer interval, `gi_between` below.
# ``K_{ij}(t)`` is ``K_{ij}`` with its off-diagonal entries cut by 80% from day 30.
# A [`Pairwise`](@ref) kernel weights each interval by `K`, so its coupling stays `I`.
# A [`TimeVarying`](@ref) coupling gives ``K_{ij}(t)``.
# It changes once, so it is given by its change points.
# Each model depletes every patch's pool and starts from ten infections a day in patch A.

gi = [0.1, 0.3, 0.3, 0.2, 0.1]
gi_between = [0.0, 0.1, 0.2, 0.3, 0.2, 0.2]
A = zeros(S, S, length(gi_between))
for a in 1:S, b in 1:S
    A[a, b, :] = K[a, b] .* (a == b ? vcat(gi, 0.0) : gi_between)
end
K_travel(cut) = Diagonal(diag(K)) + (1 - cut) * (K - Diagonal(diag(K)))
Kt = TimeVarying([1 => K_travel(0.0), 30 => K_travel(0.8)])

depletion = Depletion(PerStratum(pop))
seed = [fill(10.0, 1, 6); zeros(2, 6)]
models = [
    "Fixed coupling" => Recurrence(gi; coupling = K, modifiers = (depletion,)),
    "Per-pair intervals" => Recurrence(Pairwise(A); modifiers = (depletion,)),
    "Travel cut on day 30" => Recurrence(gi; coupling = Kt, modifiers = (depletion,)),
]
long(y) = @chain DataFrame(permutedims(y), patches) begin
    @transform(:day = 1:size(y, 2))
    stack(Not(:day); variable_name = :patch, value_name = :count)
end
@chain models begin
    map(_) do (name, r)
        @transform(long(r(1.6; history = seed, stop = T)), :model = name)
    end
    reduce(vcat, _)
    data(_) * mapping(:day, :count, color = :model, layout = :patch) *
        visual(Lines, linewidth = 2)
    draw(_; axis = (xlabel = "Day", ylabel = "Infections"))
end

# All three patches take off together, because even 5% mixing seeds B and C within days.
# Longer intervals between patches delay the peaks in B and C slightly.
# Cutting travel on day 30 lowers every peak, most in B and C, which depend most on A.

# ## Moving infections between patches
#
# A movement matrix ``M_t`` moves infections between patches after they occur:
#
# ```math
# v'_{t,i} = \sum_j M_{t,ij} \, v_{t,j},
# ```
#
# where ``v_{t,i}`` is patch ``i``'s value before the move and ``v'_{t,i}`` after it.
# ``M_{t,ij}`` is the share of patch ``j``'s infections realised in patch ``i``.
# Each column sums to one, so no infections are lost.
# The modifier is [`Redistribute(M)`](@ref ComposableRecurrences.Redistribute).
# It sits before [`Depletion`](@ref ComposableRecurrences.Depletion), so each pool is depleted by what its patch receives.
#
# Here each patch sends a share ``\varepsilon_{t,j}`` of its infections to the others, in proportion to ``K``.
# Each origin has its own share, which halves from day 40.
# [`movement(K, ε)`](@ref ComposableRecurrences.movement) builds ``M_t`` from them, one matrix per day.

ε = [t < 40 ? e : e / 2 for e in [0.05, 0.03, 0.02], t in 1:T]
patch = Recurrence(gi; modifiers = (Redistribute(movement(K, ε)), depletion))
infections, state = patch(1.6; history = seed, stop = T, state = true);

# The importation series is not recorded, but the infections give it.
# Each patch's value before the modifiers is ``R`` times a [`Convolution`](@ref).
# Its kernel is the generation interval with a zero at lag 0.
# The arrivals are the off-diagonal `K` applied to each origin's `ε`-weighted value.

force = Convolution(vcat(0.0, gi))(hcat(seed, infections))[:, (size(seed, 2) + 1):end]
K_off = K - Diagonal(diag(K))
arrivals = K_off * (ε .* (1.6 .* force))
@chain long(arrivals) begin
    @transform(:series = "Imported infections")
    data(_) * mapping(:day, :count, color = :series, layout = :patch) *
        visual(Lines, linewidth = 2)
    draw(_; axis = (xlabel = "Day", ylabel = "Imported infections"))
end

# B receives the most, from its large neighbour A, and A receives the least.
#
# The modifier's state holds the last step's arrivals, which match the recomputed series.

maximum(abs, state.states[1] .- arrivals[:, end])

# ## Sharing a total fixed elsewhere
#
# When each patch's infections are known, from the model above or an earlier fit, [`Allocate`](@ref ComposableRecurrences.Allocate) splits them among its districts by the districts' renewals:
#
# ```math
# y_{t,i} = Y_{t,p} \, \frac{v_{t,i}}{\sum_{j \in \mathcal{G}_p} v_{t,j}},
#     \qquad i \in \mathcal{G}_p,
# ```
#
# ``\mathcal{G}_p`` holds the districts of patch ``p``.
# ``Y_{t,p}`` is the patch's known total.
# ``v_{t,i}`` is district ``i``'s renewal value.

districts = [1:3, 4:5, 6:7]
totals = models[1].second(1.6; history = seed, stop = T)
district_seed = repeat([6.0, 3.0, 1.0, 2.0, 1.0, 1.0, 1.0], 1, 6)
share = Allocate(districts, TimeVarying(PerStratum(totals)))
R_district = repeat([1.5, 1.6, 1.8, 1.6, 1.6, 1.4, 1.8], 1, T)
by_district = Recurrence(gi; modifiers = (share,))(R_district; history = district_seed)
@chain DataFrame(permutedims(by_district), ["A1", "A2", "A3", "B1", "B2", "C1", "C2"]) begin
    @transform(:day = 1:T)
    stack(Not(:day); variable_name = :district, value_name = :count)
    @transform(:patch = first.(:district, 1))
    data(_) * mapping(:day, :count, color = :district, layout = :patch) *
        visual(Lines, linewidth = 2)
    draw(_; axis = (xlabel = "Day", ylabel = "Infections"))
end

# B1 and B2 share a reproduction number, so B1 keeps twice B2's infections throughout.
# A district with a higher reproduction number takes a growing share of its patch.
# A3 overtakes A1 on day 26 despite starting with a sixth of its seed.
# C2 leads C1 from the first day.
# The districts still sum to their patch's infections:

maximum(abs, reduce(vcat, [sum(by_district[zs, :]; dims = 1) for zs in districts]) .- totals)

# ## Routes: community and funeral transmission
#
# Some diseases spread by more than one route, each with its own timing and contacts.
# Ebola spreads in the community while a case is ill and at the funeral after death.
# [`Routes`](@ref) pairs each route's kernel with its own coupling.
# The funeral route has coupling ``K^{\text{funeral}}`` and kernel ``g^{\text{funeral}}_l``:
#
# ```math
# q_t = K \sum_{l} g_l \, y_{t-l}
#     + K^{\text{funeral}} \sum_{l} g^{\text{funeral}}_l \, y_{t-l},
# ```
#
# where ``y_t`` holds each patch's infections on day ``t``.
# ``q_t`` is the pressure the gain scales.
# The routes are the recurrence's kernel, so its coupling stays `I`.
# The `Routes` docstring gives the cost and how it relates to `Pairwise`.
#
# The funeral kernel is the infection-to-death delay convolved with the funeral days.
# The fatality ratio scales it, and a [`Convolution`](@ref) builds it.
# Funerals draw mourners from the patch and its neighbours, so their coupling is sparse.

using SparseArrays
death = [0.0, 0.0, 0.0, 0.0, 0.1, 0.2, 0.3, 0.2, 0.1, 0.1]
funeral_days = [0.6, 0.4]
cfr = 0.5
gi_funeral = cfr .* Convolution(funeral_days)(vcat(death, 0.0))
K_funeral = sparse([0.9 0.1 0.0; 0.1 0.8 0.1; 0.0 0.1 0.9])
routes = Routes((K, gi), (K_funeral, gi_funeral))
ebola = Recurrence(routes; modifiers = (depletion,))
ebola_cases = ebola(0.9; history = seed, stop = T);

# Each route's share of the force is not recorded.
# It is the route's coupling applied to a `Convolution` of the infections with its kernel.
# This is the force before depletion, so the routes sum to more than the cases.

function route_force(C, w)
    y = hcat(seed, ebola_cases)
    return 0.9 .* (C * Convolution(vcat(0.0, w))(y)[:, (size(seed, 2) + 1):end])
end
@chain [("Community", K, gi), ("Funeral", K_funeral, gi_funeral)] begin
    map(_) do (name, C, w)
        @transform(long(route_force(C, w)), :route = name)
    end
    reduce(vcat, _)
    data(_) * mapping(:day, :count, color = :route, layout = :patch) *
        visual(Lines, linewidth = 2)
    draw(_; axis = (xlabel = "Day", ylabel = "Force of infection"))
end

# Neither route alone sustains spread: their reproduction numbers are 0.9 and 0.45.
# Together they do, and 40% to 57% of each patch is infected.
# The funeral force peaks a few days after the community force.
# Its mean lag is about five days longer.

# ## Performance
#
# Each bar times five strata with a dense route and a sparse route and floored depletion over 200 days with a 20-day kernel, written with the operators or as a preallocated hand-written loop.

include(joinpath(pkgdir(ComposableRecurrences), "docs", "performance.jl")) #hide
performance_plot("spatial strata")

# ## Learning more
#
# - See every operator, coupling and modifier on the [API overview](@ref api-overview).
# - Want the full interface? See the [Public API](@ref public-api).
