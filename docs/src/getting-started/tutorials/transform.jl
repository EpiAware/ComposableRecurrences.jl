# # [Branching processes](@id tutorial-branching)
#
# ## Introduction
#
# A branching process follows the offspring of each case, and its expectations, such as the mean cases by type or the probability of extinction, are recurrences.
# The operators compute these expectations; they do not simulate chains.
#
# ### What might I need to know before starting
#
# The [Getting started](@ref getting-started) overview, and the couplings and [`Pairwise`](@ref) kernels of [Shapes and couplings](@ref explanation-shapes-couplings).

# ## Packages used

using ComposableRecurrences
using ComposableRecurrences: Transform
using CairoMakie, AlgebraOfGraphics, DataFramesMeta
using ForwardDiff
using LinearAlgebra

CairoMakie.activate!(type = "png", px_per_unit = 2)

gi = [0.1, 0.3, 0.3, 0.2, 0.1]

# ## A multi-type process
#
# With a unit kernel each step is one generation:
#
# ```math
# I_n = K \, I_{n-1},
# ```
#
# where ``I_n`` holds the mean cases of each type in generation ``n``.
# The coupling ``K`` is the mean offspring matrix, `M` in the code.
# Its entry ``K_{ij}`` is the mean number of type ``i`` cases that one type ``j`` case causes.
# The kernel is ``k_1 = 1`` and the gain is ``\gamma_n = 1``.
# Growth per generation converges to the spectral radius of ``K``, the reproduction number.

M = [1.2 0.4; 0.3 0.6]
by_generation = Recurrence([1.0]; coupling = M)(1.0; history = [1.0; 0.0;;], stop = 30)
growth = norm(by_generation[:, end]) / norm(by_generation[:, end - 1])
radius = maximum(abs, eigvals(M))

@chain DataFrame(
    "generation" => 0:30, "Type 1" => [1.0; by_generation[1, :]], "Type 2" => [0.0; by_generation[2, :]]
) begin
    stack(Not(:generation); variable_name = :type, value_name = :cases)
    @subset(:cases .> 0)
    data(_) * mapping(:generation, :cases, color = :type) * visual(Lines, linewidth = 2)
    draw(_; axis = (xlabel = "Generation", ylabel = "Mean cases (log scale)", yscale = log10))
end

# After a few generations both types grow at the same rate, in a fixed ratio.
# By generation 30 the growth per generation is 1.3583, the spectral radius of ``K`` to four decimal places.
# The ratio of type 1 to type 2 cases is then 2.53.

# ## [Isolation as a thinned kernel](@id tutorial-isolation-thinning)
#
# Isolating a share ``p`` of cases blocks a share ``b`` of their later transmission.
# The mean offspring at lag ``l`` and the reproduction number are then
#
# ```math
# m_l = R \, g_l \big(1 - p \, b \, F_{D,l}\big), \qquad
# R_{\text{iso}} = \sum_{l=1}^{L} m_l,
# ```
#
# where ``g_l`` is the generation interval on lag ``l``, `gi` in the code, and ``R`` the reproduction number without isolation.
# The probability that a case is isolated by lag ``l`` is ``F_{D,l}``, `F_D` in the code.
# The thinned kernel ``g_l (1 - p \, b \, F_{D,l})`` is `gi_isolated`.
# Here ``p = 0.8``, ``b = 0.9`` and ``R = 1.6``.
# This assumes the generation interval is independent of the time to isolation.

p, b = 0.8, 0.9
F_D = [0.1, 0.4, 0.7, 0.9, 1.0]
gi_isolated = gi .* (1 .- p * b .* F_D)
R0 = 1.6
R_iso = R0 * sum(gi_isolated)

@chain DataFrame("lag" => eachindex(gi), "No isolation" => gi, "Isolation" => gi_isolated) begin
    stack(Not(:lag); variable_name = :kernel, value_name = :weight)
    data(_) * mapping(:lag, :weight, color = :kernel, dodge = :kernel) * visual(BarPlot)
    draw(_; axis = (xlabel = "Lag (days)", ylabel = "Generation interval weight"))
end

# Isolation thins the later lags most.
# It brings the reproduction number from 1.6 to 0.886, below one.
# The mean offspring with and without isolation match seeded branching-process simulations from [EpiBranch.jl](https://github.com/epiforecasts/EpiBranch.jl); the [isolation use case](https://github.com/EpiAware/ComposableRecurrences.jl/blob/main/test/usecases/expectation.jl) checks them.
#
# ## Isolation delay by type
#
# The delay to isolation can depend on a case's state.
# Once a household's first case is found, later cases in it are found sooner.
# In expectation each infector type gets its own thinned kernel, a [`PerStratum`](@ref) kernel.
# Type 1 is a household's first case and type 2 a later case.
# The next-generation matrix scales each column of the coupling by its type's kernel sum.
# Its spectral radius is the reproduction number:
#
# ```math
# I_{t,i} = \gamma_t \sum_{j} K_{ij} \sum_{l} k_{j,l} \, I_{t-l,j}, \qquad
# \mathcal{K} = \gamma \, K \operatorname{diag}\Big(\sum_{l} k_{1,l},\ \sum_{l} k_{2,l}\Big).
# ```
#
# Here ``I_{t,i}`` is the mean number of type ``i`` cases on day ``t`` and ``\gamma_t = 1.6`` the gain.
# The coupling ``K`` is the mean offspring matrix, `M_house` in the code.
# The weight ``k_{j,l}`` is type ``j``'s thinned kernel on lag ``l``, row ``j`` of `W_house`.
# The next-generation matrix ``\mathcal{K}`` is `K_house`.

F_fast = [0.3, 0.7, 0.9, 1.0, 1.0]
W_house = permutedims([gi_isolated gi .* (1 .- p * b .* F_fast)])
M_house = [0.6 0.3; 0.6 0.5]
house_model = Recurrence(PerStratum(W_house); coupling = M_house)
house = house_model(R0; history = [10.0; 0.0;;], stop = 60)
K_house = R0 * M_house * Diagonal(vec(sum(W_house; dims = 2)))
R_house = maximum(abs, eigvals(K_house))

@chain DataFrame(
    "day" => 1:60, "First case" => house[1, :], "Later case" => house[2, :]
) begin
    stack(Not(:day); variable_name = :type, value_name = :cases)
    data(_) * mapping(:day, :cases, color = :type) * visual(Lines, linewidth = 2)
    draw(_; axis = (xlabel = "Day", ylabel = "Mean cases (log scale)", yscale = log10))
end

# The reproduction number, the spectral radius of ``\mathcal{K}``, is 0.773.
# From 10 seed cases the mean number of cases of both types falls towards zero, to 0.014 in total on day 60.
#
# ## Contact tracing as two types
#
# Traced and untraced cases are two types.
# A share ``q`` of each case's contacts is traced, and traced cases use the thinned kernel.
# A `Pairwise` kernel gives each pair of types its interval.
# Rows are the infectee type and columns the infector type:
#
# ```math
# A_{1j,l} = (1 - q) \, g^{(j)}_l, \qquad A_{2j,l} = q \, g^{(j)}_l, \qquad
# I_{t,i} = \gamma_t \sum_{j} \sum_{l} A_{ij,l} \, I_{t-l,j},
# ```
#
# where type 1 is untraced and type 2 traced.
# The kernel ``A_{ij,l}`` is the `Pairwise` weight on lag ``l`` from infector type ``j`` to infectee type ``i``.
# The full kernel ``g^{(1)}`` is `gi` and the thinned one ``g^{(2)}`` is `gi_isolated`.
# The gain is ``\gamma_t = 1.6``.
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

# More tracing means fewer cases.
# On day 60 there are 90 252 cases with no tracing, 590 with half traced and 2.3 with 90% traced.
# With 90% traced the outbreak declines.

# ## Extinction by generation
#
# A branching process from one case dies out by generation ``n`` with probability ``q_n``.
# Offspring are negative binomial (Lloyd-Smith et al. 2005), with mean ``R`` and dispersion ``k``:
#
# ```math
# q_n = G(q_{n-1}), \qquad q_0 = 0, \qquad
# G(s) = \left(1 + \frac{R}{k} (1 - s)\right)^{-k}.
# ```
#
# Here ``G`` is the offspring probability generating function.
# The recurrence has the unit kernel `[1.0]` and no gain, so the value entering the modifiers is ``q_{n-1}``.
# Its one modifier ``M_1`` is a `Transform` that applies ``G`` with parameters ``\theta = (R, k)``.
# Here ``R = 1.5``, and the history is ``q_0 = 0``.

G(s, θ) = (1 + θ.R / θ.k * (1 - s))^(-θ.k)
function extinction(θ, n)
    return Recurrence([1.0]; modifiers = (Transform(G, θ),))(; history = [0.0], stop = n)
end

generations = 30
@chain [0.1, 0.5, 1.0, 10.0] begin
    map(_) do k
        q = extinction((; R = 1.5, k), generations)
        DataFrame(generation = 1:generations, k = "k = $k", q = q)
    end
    reduce(vcat, _)
    data(_) * mapping(:generation, :q, color = :k) * visual(Lines, linewidth = 2)
    draw(_; axis = (xlabel = "Generation", ylabel = "Probability of extinction"))
end

# Smaller ``k`` concentrates offspring in fewer cases, so chains die out more often.
# By generation 30 the probability of extinction is 0.93 with ``k = 0.1`` and 0.46 with ``k = 10``.

# The derivative of ``q_{30}`` with respect to ``k`` comes from the same call, with ForwardDiff:

dq30_dk = ForwardDiff.derivative(k -> last(extinction((; R = 1.5, k), generations)), 0.5)
nothing #hide

# At ``k = 0.5`` it is -0.28, so a larger dispersion parameter lowers the probability of extinction.

# ## Performance
#
# Each bar times extinction by generation for five mixing types with a 20-lag generation interval over 200 steps, written with the operators or as a preallocated hand-written loop.

include(joinpath(pkgdir(ComposableRecurrences), "docs", "performance.jl")) #hide
performance_plot("transform")

# ## References
#
# - Lloyd-Smith, Schreiber, Kopp and Getz (2005), "Superspreading and the
#   effect of individual variation on disease emergence", Nature 438, 355-359,
#   [10.1038/nature04153](https://doi.org/10.1038/nature04153)

# ## Learning more
#
# - The [API overview](@ref api-overview) lists every operator, coupling and modifier.
# - Want the full interface? See the [Public API](@ref public-api).
