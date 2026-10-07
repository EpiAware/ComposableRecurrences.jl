# # [Transforms inside a recurrence](@id tutorial-transform)
#
# ## Introduction
#
# Some models pass each day's value through a function before it carries into the next day.
# [`Transform`](@ref ComposableRecurrences.Transform) is the modifier that does this.
# This tutorial uses it for a behavioural response and for a branching process, and takes gradients through it.
#
# ### What are we going to do in this exercise
#
# 1. Saturate transmission as incidence rises.
# 2. Combine the transform with `Depletion`.
# 3. Compute the probability of extinction by generation.
# 4. Take gradients with respect to the transform's parameters.
#
# ### What might I need to know before starting
#
# This tutorial builds on the [Renewal then delay](@ref tutorial-renewal-delay) tutorial and the [modifiers](@ref overview-modifiers) section of the API overview, and uses AlgebraOfGraphics.jl and CairoMakie.jl for plotting.
# No fitting is involved.

# ## Packages used

using ComposableRecurrences
using ComposableRecurrences: Transform, Depletion
using CairoMakie, AlgebraOfGraphics, DataFramesMeta
using ForwardDiff

CairoMakie.activate!(type = "png", px_per_unit = 2)

# ## Transmission that saturates with incidence
#
# People may reduce their contacts when incidence is high (@placeholder).
# One form caps each day's infections below ``\kappa``:
#
# ```math
# f(v, \kappa) = \frac{v}{1 + v / \kappa}.
# ```
#
# With a constant ``R > 1`` infections settle at ``\kappa (R - 1) / R``.

gi = [0.1, 0.3, 0.3, 0.2, 0.1]
T = 100
R = fill(1.5, T)
saturate(v, κ) = v / (1 + v / κ)

@chain [100.0, 300.0] begin
    map(_) do κ
        y = Recurrence(gi; modifiers = (Transform(saturate, κ),))(R; history = [5.0])
        DataFrame(day = 1:T, series = "κ = $(Int(κ))", count = y)
    end
    reduce(vcat, _)
    vcat(_, DataFrame(day = 1:T, series = "No response", count = Recurrence(gi)(R; history = [5.0])))
    data(_) * mapping(:day, :count, color = :series) * visual(Lines, linewidth = 2)
    draw(_; axis = (xlabel = "Day", ylabel = "Infections (log scale)", yscale = log10))
end

# ## Combining with depletion
#
# Placed before [`Depletion`](@ref ComposableRecurrences.Depletion), the transform lowers the force of infection, and the pool loses the infections that occur.
# Placed after it, the pool loses the draws before the response, which are more than the infections recorded.

N = 5_000.0
κ = 100.0
orders = [
    "Transform then Depletion" => (Transform(saturate, κ), Depletion(N)),
    "Depletion then Transform" => (Depletion(N), Transform(saturate, κ)),
    "Depletion only" => (Depletion(N),),
]
runs = @chain orders begin
    map(_) do (name, modifiers)
        y = Recurrence(gi; modifiers)(R; history = [5.0])
        DataFrame(day = 1:T, order = name, count = y)
    end
    reduce(vcat, _)
end
@chain runs begin
    data(_) * mapping(:day, :count, color = :order) * visual(Lines, linewidth = 2)
    draw(_; axis = (xlabel = "Day", ylabel = "Infections"))
end

#-

@combine(groupby(runs, :order), :total = round(sum(:count)))

# ## Extinction by generation
#
# A branching process dies out by generation ``n`` with probability ``q_n = G(q_{n-1})``, from ``q_0 = 0``, where ``G`` is the offspring probability generating function (@placeholder).
# For negative binomial offspring with mean ``R`` and dispersion ``k``,
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

# ## Gradients
#
# The gradient of the total infections with respect to ``\kappa`` and a constant ``R``:

function total_infections(x)
    modifiers = (Transform(saturate, x[1]), Depletion(N))
    return sum(Recurrence(gi; modifiers)(fill(x[2], T); history = [5.0]))
end
ForwardDiff.gradient(total_infections, [κ, 1.5])

# The derivative of the probability of extinction by generation 30 with respect to ``k``:

ForwardDiff.derivative(k -> last(extinction((; R = 1.5, k), generations)), 0.5)

# Mooncake and Enzyme run on the same code.
# The [`Transform`](@ref ComposableRecurrences.Transform) docstring gives the reverse-mode rule they use, and the [AD comparison](@ref ad-comparison) page compares the backends.

# ## Learning more
#
# - See every operator, coupling and modifier used here on the [API overview](@ref api-overview).
# - Want the full interface? See the [Public API](@ref public-api).
