# # [Case study: a backend model](@id tutorial-backend-case-study)
#
# ## Introduction
#
# The [BVDOutbreakSize](https://github.com/epiforecasts/BVDOutbreakSize) backend models an outbreak across 11 patches, writing its renewal, movement between patches and reporting delay as loops with hand-written Mooncake rules.
# The inputs are invented and nothing is fitted.
#
# ### What are we going to do in this exercise
#
# 1. Build the backend model: a seeded renewal with depletion and movement between patches, then delayed.
# 2. Check it against the backend-style loops.
# 3. Take its gradient with Mooncake and Enzyme, checked against ForwardDiff.
# 4. Compare gradient times with the loops and their hand-written rules.
# 5. Map the hand-written loops in `BVDOutbreakSize` and `ComposableTuringIDModels` to the package.
#
# ### What might I need to know before starting
#
# This builds on [Renewal then delay](@ref tutorial-renewal-delay), [Spatial models](@ref tutorial-spatial-strata) and [Adjoints and backends](@ref adjoints-backends).

# ## Packages used

using ComposableRecurrences
using ComposableRecurrences: Depletion, Redistribute, movement
using CairoMakie, AlgebraOfGraphics, DataFramesMeta
using ADTypes: AutoEnzyme, AutoForwardDiff, AutoMooncake
import DifferentiationInterface as DI
import Enzyme, ForwardDiff, Mooncake

CairoMakie.activate!(type = "png", px_per_unit = 2)

# ## The backend model
#
# Each patch ``p`` runs a renewal process seeded by ``m`` days of infections.
# Its value on day ``t`` is ``G_{p,t} = R_{p,t} \sum_{l=1}^{L} g_l I_{p,t-l}``.
# A share ``\varepsilon_{q,t} K_{pq}`` of what origin ``q`` generates is realised in patch ``p`` instead.
# Each patch then draws its infections from its own pool by the hazard form of depletion.
# Reports follow a delay ``d_l``, lag 0 first:
#
# ```math
# \begin{aligned}
# v_{p,t} &= \Big(1 - \varepsilon_{p,t} \sum_{q \ne p} K_{qp}\Big) G_{p,t}
#     + \sum_{q \ne p} \varepsilon_{q,t} K_{pq} \, G_{q,t}, \\
# I_{p,t} &= s_{p,t-1} \big(1 - e^{-v_{p,t} / N_p}\big), \qquad
# s_{p,t} = s_{p,t-1} \, e^{-v_{p,t} / N_p}, \\
# C_{p,t} &= \sum_{l=0}^{D-1} d_l \, I_{p,t-l}.
# \end{aligned}
# ```
#
# ``N_p`` is patch ``p``'s population, and its pool starts at ``s_{p,0} = \max(N_p - \sum \text{seed}_p, 0)``.
# The model runs at the backend's size: 11 patches, 200 days, a 20-day generation interval and a 30-day delay.

S, T, L, D = 11, 200, 20, 30
gi = let w = [l^2 * exp(-l / 2.5) for l in 1:L]
    w ./ sum(w)
end
delay = let w = [exp(-l / 6) for l in 0:(D - 1)]
    w ./ sum(w)
end
N = [2.0e4 + 4.0e3 * p for p in 1:S]
## Importation falls with the distance between patches on a line.
K = [p == q ? 0.0 : 0.1 / abs(p - q) for p in 1:S, q in 1:S]
ε = [0.02 + 0.01 * sin((t + 9 * p) / 15) for p in 1:S, t in 1:T]
R = [1.6 - 0.6 * t / T + 0.1 * cos(p) for p in 1:S, t in 1:T]
## The outbreak is seeded in patch 1, with a few cases elsewhere.
seeds = [p == 1 ? 1.0 : 0.02 for p in 1:S, l in 1:L]
inputs = (; gi, delay, K, seeds);

# The model is two modifiers on one `Recurrence`, then a `Convolution`.
# [`Redistribute`](@ref ComposableRecurrences.Redistribute) moves each origin's share, and [`Depletion`](@ref ComposableRecurrences.Depletion) draws from each patch's pool.
# The seeds are the [history](@ref explanation-seeding), so the run starts on the day after them.
# The fixed inputs come in as one named tuple, so the function reads no globals.

function backend_model(R, ε, N, inputs)
    (; gi, delay, K, seeds) = inputs
    S = PerStratum(max.(N .- vec(sum(seeds; dims = 2)), 0))
    modifiers = (
        Redistribute(movement(K, ε)),
        Depletion(PerStratum(N); pools = (; S)),
    )
    infections = Recurrence(gi; modifiers)(R; history = seeds)
    return (; infections, reports = Convolution(delay)(infections))
end
y = backend_model(R, ε, N, inputs)

long(x, name) = DataFrame(
    patch = repeat(1:S, outer = T), day = repeat(1:T, inner = S),
    count = vec(x), series = name
)
@chain vcat(long(y.infections, "Infections"), long(y.reports, "Reports")) begin
    @subset(in.(:patch, Ref([1, 4, 7, 11])))
    @transform(:patch = "Patch " .* string.(:patch))
    data(_) * mapping(:day, :count, color = :series => "", layout = :patch) *
        visual(Lines, linewidth = 2)
    draw(_; axis = (xlabel = "Day", ylabel = "Daily count"))
end

# The outbreak grows first in patch 1 and reaches the far patches through importation.
# Reports lag infections by the delay.
#
# ## Checking against the backend loops
#
# The benchmark keeps loops in the backend's style, each with a hand-written Mooncake rule.
# They read ``R_t`` and ``\varepsilon_t`` on the seed days too and return those days first, so the check pads and trims them.

include(joinpath(pkgdir(ComposableRecurrences), "benchmark", "bvd_handrule.jl"))
pad(X, m) = hcat(zeros(eltype(X), size(X, 1), m), X)
function loop_model(R, ε, N, inputs)
    (; gi, delay, K, seeds) = inputs
    m = size(seeds, 2)
    infections = BVDHandRule.patch_infections(
        pad(R, m), gi, seeds, K, pad(ε, m), N
    )[:, (m + 1):end]
    reports = reduce(
        vcat,
        [BVDHandRule.convolve_delay(collect(x), delay)' for x in eachrow(infections)]
    )
    return (; infections, reports)
end
z = loop_model(R, ε, N, inputs)
maximum(abs, y.reports .- z.reports) / maximum(z.reports)

# The two agree to rounding.
# The use-case tests check each kernel against the backend's own code, as listed under [Porting from a hand-written loop](@ref porting-hand-loops).
#
# ## Gradients
#
# The loss is a Poisson log-likelihood of fixed counts given the reports.
# Its parameters are the log reproduction numbers, the importation shares and the populations:
#
# ```math
# \ell(\theta) = \sum_{p,t} \big(c_{p,t} \log C_{p,t} - C_{p,t}\big),
# \qquad \theta = (\log R, \varepsilon, N).
# ```

counts = round.(y.reports .* (1 .+ 0.2 .* sin.(reshape(1:(S * T), S, T))))
function unpack(θ, S, T)
    n = S * T
    logR = reshape(θ[1:n], S, T)
    return exp.(logR), reshape(θ[(n + 1):(2n)], S, T), θ[(2n + 1):end]
end
poisson(C, counts) = sum(counts .* log.(C) .- C)
function make_loss(model, inputs, counts)
    S, T = size(counts)
    return θ -> poisson(model(unpack(θ, S, T)..., inputs).reports, counts)
end
loss = make_loss(backend_model, inputs, counts)
loop_loss = make_loss(loop_model, inputs, counts)
θ0 = vcat(vec(log.(R)), vec(ε), N)
length(θ0)

# Mooncake and Enzyme differentiate the model in reverse mode, ForwardDiff in forward mode as the reference.
# Mooncake also differentiates the loops through their hand-written rules.

backends = [
    "ForwardDiff" => AutoForwardDiff(),
    "Mooncake" => AutoMooncake(; config = nothing),
    "Enzyme" => AutoEnzyme(;
        mode = Enzyme.set_runtime_activity(Enzyme.Reverse),
        function_annotation = Enzyme.Const,
    ),
]
grads = Dict(name => DI.gradient(loss, b, θ0) for (name, b) in backends)
grads["Mooncake, hand rules"] = DI.gradient(loop_loss, last(backends[2]), θ0)
relerr(a, b) = maximum(abs, a .- b) / maximum(abs, b)
DataFrame(
    gradient = ["Mooncake", "Enzyme", "Mooncake, hand rules"],
    relative_error = [
        relerr(grads[k], grads["ForwardDiff"])
            for k in ["Mooncake", "Enzyme", "Mooncake, hand rules"]
    ]
)

# Each reverse-mode gradient matches the ForwardDiff reference to rounding.
# The package's gradient needs no rule written for the model: each operator call takes its own [rule](@ref adjoint-routing) or plain AD.
#
# ## Timing against the backend loops
#
# The [benchmark matrix](@ref testing) times the gradient of each backend kernel in four arms:
#
# - the package as written here, `ComposableRecurrences`;
# - the package with its rules turned off, `plain AD`;
# - the backend-style loop differentiated by the backend, `hand loop`;
# - the same loop with its hand-written Mooncake rules, `hand rules`.
#
# The table gives the minimum times in microseconds, read from `benchmark/results/docs.csv`, so this page times nothing itself.
# The size gives the days `T`, the kernel length `L` and the patches `S`.
# The hand rules are Mooncake rules, so Enzyme has no time for them.

results = joinpath(pkgdir(ComposableRecurrences), "benchmark", "results", "docs.csv")
timings = if isfile(results)
    lines = readlines(results)
    header = Symbol.(split(first(lines), ','))
    rows = split.(lines[2:end], ',')
    @chain DataFrame([h => String.(getindex.(rows, i)) for (i, h) in enumerate(header)]) begin
        @subset(
            startswith.(:block, "backend "), :status .== "ok",
            in.(:target, Ref(["Mooncake reverse", "Enzyme reverse"]))
        )
        @transform(:kernel = chopprefix.(:block, "backend "), :min_us = parse.(Float64, :min_us))
        unstack([:kernel, :size, :target], :method, :min_us)
    end
end

# ## [Porting from a hand-written loop](@id porting-hand-loops)
#
# A hand-written loop maps to one operator call per kernel.
# The [domain guide](@ref infectious-disease-models) gives the operator for each model part.
# Each use-case test in the tables matches values and ForwardDiff gradients against a verbatim copy of the loop in `test/usecases/references/`.
#
# `BVDOutbreakSize` writes its kernels as functions over the whole series:
#
# | Loop | Package | Test |
# |:--|:--|:--|
# | `renewal_infections(Rt, g, seed, N)` | `Recurrence(g; modifiers = (Depletion(N; pools = (S = max(N - sum(seed), 0),)),))`, called as `r(Rt; history = seed, start = length(seed) + 1, prepend = true)` | `BVD renewal_infections` |
# | `patch_infections(Rt, g, seeds, K, ε, N)` | `Recurrence(g; modifiers = (Redistribute(movement(K, ε)), Depletion(PerStratum(N); pools = (; S))))`, with `S = PerStratum(max.(N .- vec(sum(seeds; dims = 2)), 0))`, called as `r(Rt; history = seeds, start = size(seeds, 2) + 1, prepend = true)` | `BVD patch model` |
# | `convolve_delay(x, delay)` | `Convolution(delay)(x)` | `BVD convolve_delay` |
#
# `ComposableTuringIDModels` writes each step for an `accumulate_scan`:
#
# | Step | Package | Test |
# |:--|:--|:--|
# | `RenewalStep` with `UniformScaling` mixing | `Recurrence(g)`, one series or one row per stratum | `renewal`, `strata with identity mixing` |
# | `RenewalStep` with matrix mixing `K` | `Recurrence(g; coupling = K)` | `strata with a mixing matrix` |
# | `RenewalStep` with `SusceptibleDepletion(N)` | `Depletion(N; form = Floor())` in `modifiers` | `renewal with susceptible depletion` |
# | `LDStep` in `LatentDelay` | `Convolution(pmf)(Y)[d:end]` | `fixed reporting delay (LatentDelay)` |
# | `TimeVaryingLDStep` in `LatentDelay` | `Convolution(TimeVarying(P))(Y)[d:end]`, one pmf per column | `time-varying reporting delay` |
#
# Four conventions differ between the loops and the package:
#
# - `ComposableTuringIDModels` stores the generation interval reversed; the package takes it lag 1 first, as a recurrence's first weight is on the [previous value](@ref explanation-lag-origin).
# - `BVDOutbreakSize` reads `Rt` on the seed days and returns them first: `start` skips them and `prepend` returns them.
# - `ComposableTuringIDModels` seeds on a growth path: [`exponential_history`](@ref ComposableRecurrences.exponential_history) gives the same window.
# - `ComposableTuringIDModels` reports only the days with a full delay window, `d:n`, so the call keeps those days.

# ## Learning more
#
# - [Adjoints and backends](@ref adjoints-backends): which code each backend runs.
# - [Testing and benchmarking](@ref testing): the use-case tests and the benchmark matrix.
# - Want the full interface? See the [Public API](@ref public-api).
