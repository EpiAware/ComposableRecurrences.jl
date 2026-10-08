# # [Spatial and multi-type models](@id tutorial-spatial-strata)
#
# ## Introduction
#
# A model can run several series side by side, the [strata](@ref PerStratum).
# A stratum is a place, such as a town, or a type, such as an age group or traced cases.
# A coupling mixes the series within each step.
# A [`Pairwise`](@ref) kernel gives each pair its own generation interval.
# [`Redistribute`](@ref ComposableRecurrences.Redistribute) moves infections between places.
# This tutorial builds a three-patch model several ways and recovers its importation series.
# It then treats the series as types.
#
# ### What are we going to do in this exercise
#
# 1. Build a gravity coupling from populations and distances.
# 2. Compare a fixed coupling, per-pair generation intervals and changing mixing.
# 3. Move infections between patches with `Redistribute` and recompute the imports.
# 4. Share each patch's known infections among its districts with `Allocate`.
# 5. Use the series as types for a multi-type process, isolation and contact tracing.
#
# ### What might I need to know before starting
#
# It extends the three-town [Getting started](@ref getting-started) example.
# No fitting is involved.

# ## Packages used

using ComposableRecurrences
using ComposableRecurrences: Depletion, Redistribute, Allocate, with_state
using CairoMakie, AlgebraOfGraphics, DataFramesMeta
using LinearAlgebra

CairoMakie.activate!(type = "png", px_per_unit = 2)

# ## A gravity coupling
#
# A gravity coupling weights each pair of patches by population over squared distance.
# Most contact stays within a patch, so the gravity weights share a small part of each row.

patches = ["A", "B", "C"]
S, T = 3, 120
pop = [50_000.0, 30_000.0, 20_000.0]
dist = [0.0 15.0 40.0; 15.0 0.0 25.0; 40.0 25.0 0.0]
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
# The fixed coupling applies `K` after the generation interval.
# A `Pairwise` kernel gives each pair its own interval, longer between patches than within.
# It weights each interval by `K`, so its coupling stays `I`.
# A [`TimeVarying`](@ref) coupling changes by day, here cutting travel by 80% from day 30.
# Each model depletes every patch's pool and starts from ten infections a day in patch A.

gi = [0.1, 0.3, 0.3, 0.2, 0.1]
gi_between = [0.0, 0.1, 0.2, 0.3, 0.2, 0.2]
A = zeros(S, S, length(gi_between))
for a in 1:S, b in 1:S
    A[a, b, :] = K[a, b] .* (a == b ? vcat(gi, 0.0) : gi_between)
end
K_travel(cut) = Diagonal(diag(K)) + (1 - cut) * (K - Diagonal(diag(K)))
Kt = cat([K_travel(t < 30 ? 0.0 : 0.8) for t in 1:T]...; dims = 3)

depletion = Depletion(PerStratum(pop))
seed = [fill(10.0, 1, 6); zeros(2, 6)]
models = [
    "Fixed coupling" => Recurrence(gi; coupling = K, modifiers = (depletion,)),
    "Per-pair intervals" => Recurrence(Pairwise(A); modifiers = (depletion,)),
    "Travel cut on day 30" => Recurrence(gi; coupling = TimeVarying(Kt), modifiers = (depletion,)),
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
# Each patch sends a share `ε` of its infections to the others.
# Each origin has its own share, which halves from day 40.
# The modifier is [`Redistribute(K, ε)`](@ref ComposableRecurrences.Redistribute).
# It sits before [`Depletion`](@ref ComposableRecurrences.Depletion).
# Each pool is then depleted by what its patch receives.

ε = [t < 40 ? e : e / 2 for e in [0.05, 0.03, 0.02], t in 1:T]
patch = Recurrence(gi; modifiers = (Redistribute(K, TimeVarying(PerStratum(ε))), depletion))
infections, state = with_state(patch, 1.6; history = seed, stop = T);

# The importation series is not recorded, but it can be recomputed from the infections.
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
# Sometimes each patch's infections are known, from the model above or an earlier fit.
# The question is how they split among the patch's districts.
# [`Allocate`](@ref ComposableRecurrences.Allocate) splits them by the districts' renewals.

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

# ## Types, not places
#
# The same operators model types.
# These are expectations of branching processes: mean cases, not simulated chains.
#
# ### A multi-type process
#
# With a unit kernel each step is one generation.
# The mean offspring matrix `M` is the coupling.
# Growth per generation converges to the spectral radius of `M`, the reproduction number.

M = [1.2 0.4; 0.3 0.6]
generations = Recurrence([1.0]; coupling = M)(1.0; history = [1.0; 0.0;;], stop = 30)
growth = norm(generations[:, end]) / norm(generations[:, end - 1])
round.((growth, maximum(abs, eigvals(M))); digits = 4)

#-

@chain DataFrame(
    "generation" => 0:30, "Type 1" => [1.0; generations[1, :]], "Type 2" => [0.0; generations[2, :]]
) begin
    stack(Not(:generation); variable_name = :type, value_name = :cases)
    @subset(:cases .> 0)
    data(_) * mapping(:generation, :cases, color = :type) * visual(Lines, linewidth = 2)
    draw(_; axis = (xlabel = "Generation", ylabel = "Mean cases (log scale)", yscale = log10))
end

# After a few generations both types grow at the same rate, in a fixed ratio.

# ### Isolation as a thinned kernel
#
# Isolating a share `p` of cases blocks a share `b` of their later transmission.
# `F_D(τ)` is the probability a case is isolated by lag `τ`.
# The mean offspring at lag `τ` is then `R g(τ) (1 - p b F_D(τ))`.
# This assumes the generation interval is independent of the time to isolation.

p, b = 0.8, 0.9
F_D = [0.1, 0.4, 0.7, 0.9, 1.0]
gi_isolated = gi .* (1 .- p * b .* F_D)
R0 = 1.6
round.((R0 * sum(gi), R0 * sum(gi_isolated)); digits = 3)

#-

@chain DataFrame("lag" => eachindex(gi), "No isolation" => gi, "Isolation" => gi_isolated) begin
    stack(Not(:lag); variable_name = :kernel, value_name = :weight)
    data(_) * mapping(:lag, :weight, color = :kernel, dodge = :kernel) * visual(BarPlot)
    draw(_; axis = (xlabel = "Lag (days)", ylabel = "Generation interval weight"))
end

# Isolation thins the later lags most and brings the reproduction number below one.
#
# ### Contact tracing as two types
#
# Traced and untraced cases are two types.
# A share `q` of each case's contacts is traced, and traced cases use the thinned kernel.
# A `Pairwise` kernel gives each pair of types its interval.
# Rows are the infectee type and columns the infector type.
# This is an approximation: tracing correlates an infector's and infectee's isolation times.

function traced_outbreak(q)
    A_trace = zeros(2, 2, length(gi))
    for (col, g) in enumerate([gi, gi_isolated])
        A_trace[1, col, :] = (1 - q) .* g
        A_trace[2, col, :] = q .* g
    end
    return Recurrence(Pairwise(A_trace))(R0; history = [10.0; 0.0;;], stop = 60)
end
@chain [0.0, 0.5, 0.9] begin
    map(q -> DataFrame(day = 1:60, q = string(q), cases = vec(sum(traced_outbreak(q); dims = 1))), _)
    reduce(vcat, _)
    data(_) * mapping(:day, :cases, color = :q => "Traced share") * visual(Lines, linewidth = 2)
    draw(_; axis = (xlabel = "Day", ylabel = "Cases (log scale)", yscale = log10))
end

# More tracing means fewer cases, and with 90% traced the outbreak declines.

# ## Routes: community and funeral transmission
#
# Some diseases spread by more than one route, each with its own timing and contacts.
# Ebola spreads in the community while a case is ill and at the funeral after death.
# [`Routes`](@ref) pairs each route's kernel with its own coupling.
# The routes are the recurrence's kernel, so its coupling stays `I`.
# Its docstring gives the maths, the cost and how it relates to `Pairwise`.
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

# Each route's share of the force is not recorded, but it can be recomputed.
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
# Together they do, and about four in ten people are infected in each patch.
# The funeral force peaks a few days after the community force.
# Its mean lag is about five days longer.

# ## Learning more
#
# - See every operator, coupling and modifier on the [API overview](@ref api-overview).
# - Want the full interface? See the [Public API](@ref public-api).
