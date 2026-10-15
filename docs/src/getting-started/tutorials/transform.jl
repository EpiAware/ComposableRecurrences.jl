# # [Branching processes](@id tutorial-branching)
#
# ## Introduction
#
# A branching process follows the offspring of each case.
# Its expectations, such as the mean cases by type or the probability of extinction, are recurrences.
# This tutorial computes mean cases with types, isolation and contact tracing, and the probability of extinction by generation.
# These are expectations of branching processes, not simulated chains.
#
# ### What are we going to do in this exercise
#
# 1. Grow a multi-type process one generation per step.
# 2. Thin the generation interval for isolation, with a delay that depends on the type.
# 3. Treat traced and untraced cases as two types.
# 4. Compute the probability of extinction by generation, and its derivative.
#
# ### What might I need to know before starting
#
# This tutorial builds on [Getting started](@ref getting-started) and uses couplings and [`Pairwise`](@ref) kernels from [Shapes and couplings](@ref explanation-shapes-couplings).
# No fitting is involved.

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
# y_n = M \, y_{n-1},
# ```
#
# where ``y_n`` holds the mean cases of each type in generation ``n``.
# The mean offspring matrix ``M`` is the coupling.
# ``M_{ij}`` is the mean number of type ``i`` cases that one type ``j`` case causes.
# Growth per generation converges to the spectral radius of `M`, the reproduction number.

M = [1.2 0.4; 0.3 0.6]
by_generation = Recurrence([1.0]; coupling = M)(1.0; history = [1.0; 0.0;;], stop = 30)
growth = norm(by_generation[:, end]) / norm(by_generation[:, end - 1])
round.((growth, maximum(abs, eigvals(M))); digits = 4)

#-

@chain DataFrame(
    "generation" => 0:30, "Type 1" => [1.0; by_generation[1, :]], "Type 2" => [0.0; by_generation[2, :]]
) begin
    stack(Not(:generation); variable_name = :type, value_name = :cases)
    @subset(:cases .> 0)
    data(_) * mapping(:generation, :cases, color = :type) * visual(Lines, linewidth = 2)
    draw(_; axis = (xlabel = "Generation", ylabel = "Mean cases (log scale)", yscale = log10))
end

# After a few generations both types grow at the same rate, in a fixed ratio.

# ## Isolation as a thinned kernel
#
# Isolating a share `p` of cases blocks a share `b` of their later transmission.
# ``F_D(\tau)`` is the probability a case is isolated by lag ``\tau``.
# The mean offspring at lag ``\tau`` is then
#
# ```math
# m(\tau) = R \, g(\tau) \big(1 - p \, b \, F_D(\tau)\big).
# ```
#
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
# The mean offspring with and without isolation match seeded branching-process simulations from [EpiBranch.jl](https://github.com/epiforecasts/EpiBranch.jl); the [isolation use case](https://github.com/EpiAware/ComposableRecurrences.jl/blob/main/test/usecases/expectation.jl) checks them.
#
# ## Isolation delay by type
#
# The delay to isolation can depend on a case's state.
# Once a household's first case is found, later cases in it are found sooner.
# In expectation each type gets its own thinned kernel.
# This is a [`PerStratum`](@ref) kernel by infector type.
# Type 1 is a household's first case and type 2 a later case.
# `M_house` is the mean offspring matrix.
# The next-generation matrix scales each column of `M_house` by its type's kernel sum.
# Its spectral radius is the reproduction number:
#
# ```math
# y_{t,i} = R \sum_{j} M_{ij} \sum_{l} W_{j,l} \, y_{t-l,j}, \qquad
# K = R \, M \operatorname{diag}\Big(\sum_{l} W_{1,l},\ \sum_{l} W_{2,l}\Big).
# ```
#
# ``W_{j,l}`` is type ``j``'s thinned kernel on lag ``l``, `W_house` below.
# ``y_{t,i}`` is the mean number of type ``i`` cases on day ``t``, and ``K`` is `K_house`.

F_fast = [0.3, 0.7, 0.9, 1.0, 1.0]
W_house = permutedims([gi_isolated gi .* (1 .- p * b .* F_fast)])
M_house = [0.6 0.3; 0.6 0.5]
house_model = Recurrence(PerStratum(W_house); coupling = M_house)
house = house_model(R0; history = [10.0; 0.0;;], stop = 60)
K_house = R0 * M_house * Diagonal(vec(sum(W_house; dims = 2)))
round.((maximum(abs, eigvals(K_house)), sum(house[:, end])); digits = 3)

#-

@chain DataFrame(
    "day" => 1:60, "First case" => house[1, :], "Later case" => house[2, :]
) begin
    stack(Not(:day); variable_name = :type, value_name = :cases)
    data(_) * mapping(:day, :cases, color = :type) * visual(Lines, linewidth = 2)
    draw(_; axis = (xlabel = "Day", ylabel = "Mean cases (log scale)", yscale = log10))
end

# The reproduction number is below one.
# From 10 seed cases the mean number of cases of both types falls towards zero.
#
# ## Contact tracing as two types
#
# Traced and untraced cases are two types.
# A share `q` of each case's contacts is traced, and traced cases use the thinned kernel.
# A `Pairwise` kernel gives each pair of types its interval.
# Rows are the infectee type and columns the infector type:
#
# ```math
# A_{1j,l} = (1 - q) \, g^{(j)}_l, \qquad A_{2j,l} = q \, g^{(j)}_l, \qquad
# y_{t,i} = R \sum_{j} \sum_{l} A_{ij,l} \, y_{t-l,j},
# ```
#
# where type 1 is untraced and type 2 traced.
# ``g^{(1)}`` is the full kernel and ``g^{(2)}`` the thinned one.
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

# ## Extinction by generation
#
# A branching process dies out by generation ``n`` with probability ``q_n = G(q_{n-1})``.
# It starts from ``q_0 = 0``.
# ``G`` is the offspring probability generating function.
# Offspring are negative binomial (Lloyd-Smith et al. 2005).
# With mean ``R`` and dispersion ``k``,
#
# ```math
# G(s) = \left(1 + \frac{R}{k} (1 - s)\right)^{-k}.
# ```

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

# The derivative of the probability of extinction by generation 30 with respect to ``k`` comes from the same call:

ForwardDiff.derivative(k -> last(extinction((; R = 1.5, k), generations)), 0.5)

# ## References
#
# - Lloyd-Smith, Schreiber, Kopp and Getz (2005), "Superspreading and the
#   effect of individual variation on disease emergence", Nature 438, 355-359,
#   [10.1038/nature04153](https://doi.org/10.1038/nature04153)

# ## Learning more
#
# - The [API overview](@ref api-overview) lists every operator, coupling and modifier.
# - Want the full interface? See the [Public API](@ref public-api).
