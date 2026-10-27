# # [Spatial models](@id tutorial-spatial-strata)
#
# ## Introduction
#
# A model can run several [strata](@ref overview-step) side by side, one per place, mixed within each step.
# Strata can also be types, as for the case types of a [branching process](@ref tutorial-branching).
#
# ### What might I need to know before starting
#
# The three-town example in [Getting started](@ref overview-build).

# ## Packages used

using ComposableRecurrences
using ComposableRecurrences: Depletion, Redistribute, Allocate, movement
using CairoMakie, AlgebraOfGraphics, DataFramesMeta
using LinearAlgebra
using SparseArrays

CairoMakie.activate!(type = "png", px_per_unit = 2)

# ## A gravity coupling
#
# The coupling is the [three-town example's](@ref overview-build) gravity coupling, with the same towns as patches and 5% mixing rather than 0.2%:
#
# ```math
# K_{ij} = 0.95 \, \delta_{ij} + 0.05 \, \frac{w_{ij}}{\sum_{b} w_{ib}}, \qquad
# w_{ij} = \begin{cases} N_j / d_{ij}^2 & i \ne j, \\ 0 & i = j. \end{cases}
# ```
#
# ``K_{ij}`` weights patch ``j``'s infections in patch ``i``.
# ``\delta_{ij}`` is one when ``i = j`` and zero otherwise.
# ``N_j`` is the population of patch ``j`` and ``d_{ij}`` the distance between patches ``i`` and ``j``.
# ``w_{ij}`` is the gravity weight, so each row of ``K`` sums to one.

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
# The three models differ in the pressure ``q_{t,i}`` on patch ``i``, and share the draw from each patch's pool:
#
# ```math
# \begin{aligned}
# q^{\text{fixed}}_{t,i} &= \sum_{j} K_{ij} \sum_{l} g_l \, I_{t-l,j}, \qquad
# q^{\text{pair}}_{t,i} = \sum_{j} \sum_{l} A_{ij,l} \, I_{t-l,j}, \qquad
# q^{\text{cut}}_{t,i} = \sum_{j} K_{t,ij} \sum_{l} g_l \, I_{t-l,j}, \\
# I_{t,i} &= s_{t-1,i} \big(1 - e^{-\gamma q_{t,i} / N_i}\big), \qquad
# s_{t,i} = s_{t-1,i} - I_{t,i}.
# \end{aligned}
# ```
#
# ``I_{t,j}`` is the number of infections in patch ``j`` on day ``t``.
# ``g_l`` is the generation interval's weight on lag ``l``.
# ``A_{ij,l}`` is ``K_{ij} g_l`` within a patch and ``K_{ij} g^{\text{between}}_l`` between.
# ``g^{\text{between}}_l`` is a longer interval, `gi_between` below.
# ``K_{t,ij}`` is ``K_{ij}`` with its off-diagonal entries cut by 80% from day 30.
# ``\gamma = 1.6`` is the gain.
# ``s_{t,i}`` is patch ``i``'s susceptible pool after day ``t``, starting at its population ``N_i``.
# A [`Pairwise`](@ref) kernel weights each interval by `K`, so its coupling stays `I`.
# A [`TimeVarying`](@ref) coupling gives ``K_{t,ij}``.
# It changes once, so it is given by its change points.
# A [`Depletion`](@ref ComposableRecurrences.Depletion) per patch is the only modifier.
# Each model starts from ten infections a day in patch A on the six days before day 1.

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

# All three patches take off together, because even 5% mixing gives B more than one infection a day by day 3 and C by day 4.
# C, the smallest patch, peaks first, on day 36 with the fixed coupling, and A last, on day 40.
# Longer intervals between patches delay the peaks in B and C by one day.
# Cutting travel on day 30 lowers the peaks in A, B and C by 6%, 17% and 19%, because B and C depend most on A.

# ## Moving infections between patches
#
# A movement matrix ``M_t`` moves infections between patches after they occur:
#
# ```math
# \begin{aligned}
# v_{t,i} &= \gamma \sum_{l} g_l \, I_{t-l,i}, \qquad
# v'_{t,i} = \sum_j M_{t,ij} \, v_{t,j}, \\
# M_{t,ij} &= K_{ij} \, \varepsilon_{t,j} \quad (i \ne j), \qquad
# M_{t,jj} = 1 - \varepsilon_{t,j} \sum_{i \ne j} K_{ij}, \\
# I_{t,i} &= s_{t-1,i} \big(1 - e^{-v'_{t,i} / N_i}\big), \qquad
# s_{t,i} = s_{t-1,i} - I_{t,i}.
# \end{aligned}
# ```
#
# ``v_{t,i}`` is patch ``i``'s value before the move and ``v'_{t,i}`` after it.
# ``M_{t,ij}`` is the share of patch ``j``'s infections realised in patch ``i``.
# Each column of ``M_t`` sums to one, so no infections are lost.
# ``\varepsilon_{t,j}`` is the share patch ``j`` sends to the others, in proportion to ``K``.
# It is 0.05 for A, 0.03 for B and 0.02 for C, and halves from day 40.
# The coupling is `I` here, so the patches mix only through the move.
# The first modifier is [`Redistribute(M)`](@ref ComposableRecurrences.Redistribute), and [`movement(K, ε)`](@ref ComposableRecurrences.movement) builds ``M_t`` from ``K`` and ``\varepsilon``, one matrix per day.
# It sits before the [`Depletion`](@ref ComposableRecurrences.Depletion), so each pool is depleted by what its patch receives.

ε = [t < 40 ? e : e / 2 for e in [0.05, 0.03, 0.02], t in 1:T]
patch = Recurrence(gi; modifiers = (Redistribute(movement(K, ε)), depletion))
infections, state = patch(1.6; history = seed, stop = T, state = true);

# The arrivals ``u_{t,i}`` in patch ``i`` are not recorded, but the infections give them:
#
# ```math
# u_{t,i} = \sum_{j \ne i} K_{ij} \, \varepsilon_{t,j} \, v_{t,j}.
# ```
#
# ``v_{t,j}`` is ``\gamma`` times a [`Convolution`](@ref) of the infections with the generation interval, with a zero at lag 0.

force = Convolution(vcat(0.0, gi))(hcat(seed, infections))[:, (size(seed, 2) + 1):end]
K_off = K - Diagonal(diag(K))
arrivals = K_off * (ε .* (1.6 .* force))
@chain long(arrivals) begin
    @transform(:series = "Imported infections")
    data(_) * mapping(:day, :count, color = :series, layout = :patch) *
        visual(Lines, linewidth = 2)
    draw(_; axis = (xlabel = "Day", ylabel = "Imported infections"))
end

# B receives the most, 106 infections over the 120 days, from its large neighbour A.
# A receives the least, 19 infections.
# The modifier's state holds the last day's arrivals, and they match the recomputed ones:

@assert state.states[1] ≈ arrivals[:, end]

# ## Sharing a total fixed elsewhere
#
# When each patch's infections are known, from the model above or an earlier fit, [`Allocate`](@ref ComposableRecurrences.Allocate) splits them among its districts by the districts' renewals:
#
# ```math
# v_{t,i} = \gamma_i \sum_{l} g_l \, I_{t-l,i}, \qquad
# I_{t,i} = Y_{t,p} \, \frac{v_{t,i}}{\sum_{j \in \mathcal{G}_p} v_{t,j}},
#     \qquad i \in \mathcal{G}_p.
# ```
#
# ``\mathcal{G}_p`` holds the districts of patch ``p``.
# ``Y_{t,p}`` is the patch's known total, here from the fixed coupling model.
# ``v_{t,i}`` is district ``i``'s renewal value and ``\gamma_i`` its reproduction number.
# A has districts A1 to A3 with reproduction numbers 1.5, 1.6 and 1.8 and seeds 6, 3 and 1 a day.
# B has B1 and B2, both at 1.6, with seeds 2 and 1.
# C has C1 at 1.4 and C2 at 1.8, each with a seed of 1.

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

@assert reduce(vcat, [sum(by_district[zs, :]; dims = 1) for zs in districts]) ≈ totals

# ## Routes: community and funeral transmission
#
# Some diseases spread by more than one route, each with its own timing and contacts.
# Ebola spreads in the community while a case is ill and at the funeral after death.
# A [`Routes`](@ref) kernel pairs each route's kernel with its own coupling:
#
# ```math
# \begin{aligned}
# q_t &= K \sum_{l} g_l \, I_{t-l}
#     + K^{\text{funeral}} \sum_{l} g^{\text{funeral}}_l \, I_{t-l}, \qquad
# g^{\text{funeral}}_l = c \, \big(f_0 \, d_l + f_1 \, d_{l-1}\big), \\
# I_{t,i} &= s_{t-1,i} \big(1 - e^{-\gamma q_{t,i} / N_i}\big), \qquad
# s_{t,i} = s_{t-1,i} - I_{t,i}.
# \end{aligned}
# ```
#
# ``I_t`` holds each patch's infections on day ``t`` and ``q_t`` the pressure the gain ``\gamma = 0.9`` scales.
# ``K^{\text{funeral}}`` is the funeral coupling and ``g^{\text{funeral}}_l`` the funeral kernel on lag ``l``.
# ``d_l`` is the infection-to-death delay, with a mean of 7.3 days.
# ``f_0 = 0.6`` and ``f_1 = 0.4`` are the funeral's weights on the day of death and the day after.
# ``c = 0.5`` is the fatality ratio, and a [`Convolution`](@ref) builds the funeral kernel.
# Funerals draw mourners from the patch and its neighbours, so their coupling is sparse.
# The routes are the recurrence's kernel, so its coupling stays `I`.
# They equal a [`Pairwise`](@ref) kernel ``A_{ij,l} = K_{ij} g_l + K^{\text{funeral}}_{ij} g^{\text{funeral}}_l``, held as two routes so the sparse coupling stays sparse.

death = [0.0, 0.0, 0.0, 0.0, 0.1, 0.2, 0.3, 0.2, 0.1, 0.1]
funeral_days = [0.6, 0.4]
cfr = 0.5
gi_funeral = cfr .* Convolution(funeral_days)(vcat(death, 0.0))
K_funeral = sparse([0.9 0.1 0.0; 0.1 0.8 0.1; 0.0 0.1 0.9])
routes = Routes((K, gi), (K_funeral, gi_funeral))
ebola = Recurrence(routes; modifiers = (depletion,))
ebola_cases = ebola(0.9; history = seed, stop = T);

# Each route's share of the force is not recorded, but the infections give it:
#
# ```math
# \gamma \, K^{(r)} \sum_{l} g^{(r)}_l \, I_{t-l},
# ```
#
# where ``K^{(r)}`` and ``g^{(r)}_l`` are route ``r``'s coupling and kernel.
# The kernel sum is a `Convolution` of the infections with the kernel, with a zero at lag 0.
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
# The funeral force peaks five days after the community force in each patch.
# Its mean lag is 7.7 days, against 2.9 days for the community route.

# ## Performance
#
# Each bar times five strata with a dense route and a sparse route and floored depletion over 200 days with a 20-day kernel, written with the operators or as a preallocated hand-written loop.

include(joinpath(pkgdir(ComposableRecurrences), "docs", "performance.jl")) #hide
performance_plot("spatial strata")

# ## Learning more
#
# - See every operator, coupling and modifier on the [API overview](@ref api-overview).
# - Want the full interface? See the [Public API](@ref public-api).
