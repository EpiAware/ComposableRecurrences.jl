# # [Case study: a backend model](@id tutorial-backend-case-study)
#
# ## Introduction
#
# The `BVDOutbreakSize` backend fits an outbreak model across 11 patches, writing its renewal, movement between patches and reporting delay as loops with hand-written Mooncake rules.
# This page builds the same model from the package's operators and compares the two.
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
# No fitting is involved.

# ## Packages used

using ComposableRecurrences
using ComposableRecurrences: Depletion, Redistribute, movement
using CairoMakie, AlgebraOfGraphics, DataFramesMeta
using Markdown
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
# The seeds are the history, so the run starts on the day after them (see [Seeding](@ref explanation-seeding)).
# The fixed inputs come in as one named tuple, so the function reads no globals.

function backend_model(R, ε, N, inputs)
    (; gi, delay, K, seeds) = inputs
    pool0 = PerStratum(max.(N .- vec(sum(seeds; dims = 2)), 0))
    modifiers = (
        Redistribute(movement(K, ε)),
        Depletion(PerStratum(N); pool0),
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
# The package's gradient needs no rule written for the model; [Rules and plain AD](@ref adjoint-routing) says which code each operator runs.
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
# The kernels are the single-patch renewal, the patch model at 1 and 11 patches, and the delay.
# The figure reads the times from the benchmark results, so this page times nothing itself.

results = joinpath(pkgdir(ComposableRecurrences), "benchmark", "results", "docs.csv")
blocks = [
    "backend renewal" => "Renewal", "backend patches" => "Patches",
    "backend delay" => "Delay",
]
bench = if isfile(results)
    lines = readlines(results)
    header = Symbol.(split(first(lines), ','))
    rows = split.(lines[2:end], ',')
    @chain DataFrame([h => String.(getindex.(rows, i)) for (i, h) in enumerate(header)]) begin
        @subset(
            in.(:block, Ref(first.(blocks))), :status .== "ok",
            in.(:target, Ref(["Mooncake reverse", "Enzyme reverse"]))
        )
        @transform(
            :min_us = parse.(Float64, :min_us),
            :median_us = parse.(Float64, :median_us)
        )
    end
else
    nothing
end
have_bench = bench !== nothing && !isempty(bench.block)
arms = ["ComposableRecurrences", "plain AD", "hand loop", "hand rules"]
targets = ["Mooncake reverse" => "Mooncake", "Enzyme reverse" => "Enzyme"]
sizelabel(s) = replace(s, "_" => " ")
if !have_bench
    md"The benchmark results are not available in this build."
else
    @chain bench begin
        ## The hand rules are Mooncake rules: under Enzyme that arm is the loop.
        @subset(.!((:target .== "Enzyme reverse") .& (:method .== "hand rules")))
        @transform(:case = getindex.(Ref(Dict(blocks)), :block) .* ", " .* sizelabel.(:size))
        data(_) * mapping(
            :case => "",
            :min_us => "Minimum gradient time (μs)",
            color = :method => sorter(arms...) => "",
            dodge = :method => sorter(arms...) => "",
            row = :target => renamer(targets...),
        ) * visual(BarPlot, fillto = 1)
        draw(
            _; axis = (yscale = log10, xticklabelrotation = π / 6),
            figure = (size = (900, 700),), legend = (position = :bottom,)
        )
    end
end

# For each backend the package is compared with the fastest hand-written option: on Mooncake the loop with its rules, on Enzyme the loop itself.
# The table gives the package's time over that option's, for the minimum and the median times.
# A ratio below one means the package is faster.

function ratio_to(bench, target, method)
    pkg = @subset(bench, :target .== target, :method .== "ComposableRecurrences")
    ref = @subset(bench, :target .== target, :method .== method)
    both = innerjoin(
        pkg, ref; on = [:block, :size, :target], renamecols = "" => "_ref"
    )
    return @chain both begin
        @transform(
            :case = getindex.(Ref(Dict(blocks)), :block),
            :size = sizelabel.(:size),
            :min_ratio = round.(:min_us ./ :min_us_ref; digits = 2),
            :median_ratio = round.(:median_us ./ :median_us_ref; digits = 2)
        )
        @select(:case, :size, :target, :min_ratio, :median_ratio)
    end
end
ratio_table = if have_bench
    vcat(
        ratio_to(bench, "Mooncake reverse", "hand rules"),
        ratio_to(bench, "Enzyme reverse", "hand loop")
    )
end

# From the same results:

function span(t, target)
    r = t[t.target .== target, :min_ratio]
    return isempty(r) ? nothing : "$(minimum(r)) to $(maximum(r))"
end
function takeaway(bench, ratio_table)
    said = String[]
    mooncake = @subset(ratio_table, :target .== "Mooncake reverse")
    e = span(ratio_table, "Enzyme reverse")
    e === nothing ||
        push!(said, "On Enzyme the package takes $e times the time of the hand loop.")
    m = span(ratio_table, "Mooncake reverse")
    m === nothing ||
        push!(said, "On Mooncake it takes $m times the time of the hand rules.")
    l = span(ratio_to(bench, "Mooncake reverse", "hand loop"), "Mooncake reverse")
    l === nothing ||
        push!(said, "Against the loop without its rules, the package takes $l times its time.")
    s11 = @subset(mooncake, :case .== "Patches", endswith.(:size, "S11"))
    isempty(s11.case) || push!(
        said,
        "At 11 patches the package takes $(join(s11.min_ratio, " and ")) times the time of the hand rules, " *
            "with `Redistribute` and `Depletion` differentiated by the package's own rules."
    )
    ## A cell counts as slower only when the minimum and the median both
    ## exceed the hand rules by more than 10%, as in the benchmark report.
    where(t) = join(t.case .* " at " .* t.size, ", ")
    slower = @subset(mooncake, :min_ratio .> 1.1, :median_ratio .> 1.1)
    isempty(slower.case) ||
        push!(said, "It is slower than the hand rules on $(where(slower)).")
    split = @subset(mooncake, (:min_ratio .> 1) .!= (:median_ratio .> 1))
    isempty(split.case) || push!(
        said,
        "On $(where(split)) the minimum and the median fall on opposite sides of the hand rules, " *
            "so the run does not settle which is faster there."
    )
    level = @subset(
        mooncake, :min_ratio .> 1, :median_ratio .> 1,
        (:min_ratio .<= 1.1) .| (:median_ratio .<= 1.1)
    )
    isempty(level.case) || push!(
        said,
        "On $(where(level)) the package is slower by 10% or less on one of the two measures, " *
            "which is within the run's noise."
    )
    revs = unique(bench.revision)
    push!(
        said,
        "The ratios above are of minimum times at " *
            (length(revs) == 1 ? "revision " : "revisions ") *
            join("`" .* revs .* "`", " and ") * "."
    )
    return Markdown.parse(join(said, " "))
end
have_bench && takeaway(bench, ratio_table)

# A hand-written rule earns its place only where it is faster than the package.
#
# ## [Porting from a hand-written loop](@id porting-hand-loops)
#
# A hand-written loop maps to one operator call per kernel.
# The [domain guide](@ref infectious-disease-models) gives the operator for each model part.
# The tables below give the call for each loop in two backends, and the use-case test that checks it.
# Each test matches values and ForwardDiff gradients against a verbatim copy of the loop in `test/usecases/references/`.
#
# `BVDOutbreakSize` writes its kernels as functions over the whole series:
#
# | Loop | Package | Test |
# |:--|:--|:--|
# | `renewal_infections(Rt, g, seed, N)` | `Recurrence(g; modifiers = (Depletion(N; pool0 = max(N - sum(seed), 0)),))`, called as `r(Rt; history = seed, start = length(seed) + 1, prepend = true)` | `BVD renewal_infections` |
# | `patch_infections(Rt, g, seeds, K, ε, N)` | `Recurrence(g; modifiers = (Redistribute(movement(K, ε)), Depletion(PerStratum(N); pool0)))`, with `pool0 = PerStratum(max.(N .- vec(sum(seeds; dims = 2)), 0))`, called as `r(Rt; history = seeds, start = size(seeds, 2) + 1, prepend = true)` | `BVD patch model` |
# | `convolve_delay(x, delay)` | `Convolution(delay)(x)` | `BVD convolve_delay` |
#
# `ComposableTuringIDModels` writes each step for an `accumulate_scan`:
#
# | Step | Package | Test |
# |:--|:--|:--|
# | `RenewalStep` with `UniformScaling` mixing | `Recurrence(g)`, one series or one row per stratum | `renewal`, `strata with identity mixing` |
# | `RenewalStep` with matrix mixing `K` | `Recurrence(g; coupling = K)` | `strata with a mixing matrix` |
# | `RenewalStep` with `SusceptibleDepletion(N)` | `Depletion(N, Floor())` in `modifiers` | `renewal with susceptible depletion` |
# | `LDStep` in `LatentDelay` | `Convolution(pmf)(Y)[d:end]` | `fixed reporting delay (LatentDelay)` |
# | `TimeVaryingLDStep` in `LatentDelay` | `Convolution(TimeVarying(P))(Y)[d:end]`, one pmf per column | `time-varying reporting delay` |
#
# Four conventions differ between the loops and the package:
#
# - `ComposableTuringIDModels` stores the generation interval reversed; the package takes it lag 1 first, as the [FAQ](@ref faq-lag-origin) explains.
# - `BVDOutbreakSize` reads `Rt` on the seed days and returns them first: `start` skips them and `prepend` returns them.
# - `ComposableTuringIDModels` seeds on a growth path: [`exponential_history`](@ref ComposableRecurrences.exponential_history) gives the same window.
# - `ComposableTuringIDModels` reports only the days with a full delay window, `d:n`, so the call keeps those days.

# ## Learning more
#
# - [Adjoints and backends](@ref adjoints-backends) says which code each backend runs.
# - [Testing and benchmarking](@ref testing) describes the use-case tests and the benchmark matrix.
# - Want the full interface? See the [Public API](@ref public-api).
