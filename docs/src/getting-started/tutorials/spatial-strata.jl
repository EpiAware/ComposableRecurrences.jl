# # [Spatial and multi-type models](@id tutorial-spatial-strata)
#
# ## Introduction
#
# A model can run several series side by side, one for each place, such as a town, or each type, such as an age group or traced and untraced cases.
# Each of these series is a stratum.
# A coupling mixes the series within each step, a `Pairwise` kernel gives each pair its own generation interval, and `Redistribute` moves infections between places.
# This tutorial builds a three-patch model several ways, recovers its importation series, and then treats the series as types.
#
# ### What are we going to do in this exercise
#
# 1. Build a gravity coupling from populations and distances.
# 2. Compare a fixed coupling, per-pair generation intervals and mixing that changes over time.
# 3. Move infections between patches with `Redistribute` and recompute the importation series.
# 4. Use the series as types for a multi-type process, isolation and contact tracing in expectation.
#
# ### What might I need to know before starting
#
# This tutorial builds on the [Getting started](@ref getting-started) overview and the [API overview](@ref api-overview), and uses AlgebraOfGraphics.jl and CairoMakie.jl for plotting.
# No fitting is involved.

# ## Packages used

using ComposableRecurrences
using ComposableRecurrences: Depletion, Redistribute, with_state
using CairoMakie, AlgebraOfGraphics, DataFramesMeta
using LinearAlgebra

CairoMakie.activate!(type = "png", px_per_unit = 2)

# ## A gravity coupling
#
# A gravity coupling weights each pair of patches by the destination's population over the squared distance.
# Most contact stays within a patch, so the gravity weights share a small part of each row.
# Row `a` of `K` gives the weights patch `a` puts on each patch's infections.

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
# A `Pairwise` kernel gives each pair its own interval, here longer between patches than within, and weights it by `K`, so its coupling stays `I`.
# A `TimeVarying` coupling changes by day, here cutting travel between patches by 80% from day 30.
# Each model depletes every patch's own pool and starts from ten infections a day in patch A.

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
# Cutting travel on day 30 lowers every peak, most in B and C, which depend most on infections from A.

# ## Moving infections between patches
#
# `Redistribute(K, ε)` moves a share ``\varepsilon`` of what each patch generates to the others, weighted by `K`, conserving the total.
# The diagonal of `K` is ignored.
# Here each origin has its own intensity, and it halves from day 40.
# Placed before `Depletion`, each patch's pool is depleted by what it receives.

ε = [t < 40 ? e : e / 2 for e in [0.05, 0.03, 0.02], t in 1:T]
patch = Recurrence(gi; modifiers = (Redistribute(K, TimeVarying(PerStratum(ε))), depletion))
infections, state = with_state(patch, 1.6; history = seed, stop = T)

# The importation series is not recorded, but it can be recomputed from the infections.
# Each patch's value before the modifiers is ``R`` times its generation-interval convolution, which is a convolution with a zero at lag 0.
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
# Arrivals halve on day 40 with the intensities.
#
# The modifier's state, which it carries from step to step, holds the last step's arrivals, which match the recomputed series.

maximum(abs, state.states[1] .- arrivals[:, end])

# ## Types, not places
#
# The same operators model types.
# These are expectations of branching processes, so they give mean numbers of cases, not simulated chains.
#
# ### A multi-type process
#
# With a unit kernel each step is one generation, and a mean offspring matrix `M` is the coupling.
# The growth ratio between generations converges to the spectral radius of `M`, the reproduction number.

M = [1.2 0.4; 0.3 0.6]
generations = Recurrence([1.0]; coupling = M)(1.0; history = [1.0; 0.0;;], stop = 30)
growth = norm(generations[:, end]) / norm(generations[:, end - 1])
round.((growth, maximum(abs, eigvals(M))); digits = 4)

# ### Isolation as a thinned kernel
#
# Isolating a share `p` of cases blocks a share `b` of their onward transmission once they are isolated.
# If `F_D` is the probability a case is isolated by lag `τ`, the mean offspring at lag `τ` is `R g(τ) (1 - p b F_D(τ))`.
# This assumes the generation interval is independent of the time to isolation.

p, b = 0.8, 0.9
F_D = [0.1, 0.4, 0.7, 0.9, 1.0]
gi_isolated = gi .* (1 .- p * b .* F_D)
R0 = 1.6
round.((R0 * sum(gi), R0 * sum(gi_isolated)); digits = 3)

# The effective reproduction number falls from `R0` to `R0` times the kernel's sum, which is below one here.
#
# ### Contact tracing as two types
#
# Traced and untraced cases are two types.
# A share `q` of each case's contacts is traced, and traced cases transmit on a thinned kernel.
# A `Pairwise` kernel gives each pair of types its interval, rows the infectee type and columns the infector type.
# This is an approximation, because tracing correlates an infector's and infectee's isolation times.

function traced_outbreak(q)
    A_trace = zeros(2, 2, length(gi))
    for (col, g) in enumerate([gi, gi_isolated])
        A_trace[1, col, :] = (1 - q) .* g
        A_trace[2, col, :] = q .* g
    end
    return Recurrence(Pairwise(A_trace))(R0; history = [10.0; 0.0;;], stop = 60)
end
round.((sum(traced_outbreak(0.0)), sum(traced_outbreak(0.5)), sum(traced_outbreak(0.9))))

# Total cases over 60 days fall as the traced share `q` rises from 0 to 0.5 and 0.9.

# ## Learning more
#
# - See every operator, coupling and modifier used here on the [API overview](@ref api-overview).
# - Want the full interface? See the [Public API](@ref public-api).
