# # [Compiling with Reactant](@id tutorial-reactant)
#
# ## Introduction
#
# [Reactant.jl](https://github.com/EnzymeAD/Reactant.jl) traces a Julia function into one compiled program that runs on the CPU or a GPU.
# Loading Reactant loads the package's Reactant extension, so `Recurrence` and `Convolution` compile as they are, forward and with Enzyme gradients.
# This page shows how, what is supported, and what compiling costs and gains.
# Reactant needs Julia 1.12, so the code below is not run when the docs are built; the numbers come from `benchmark/results/reactant.csv`.
#
# ### What are we going to do in this exercise
#
# 1. Compile a renewal process and its gradient with `Reactant.@compile`.
# 2. Check which operators, couplings and modifiers compile.
# 3. Compare compile and run times with plain Julia.
#
# ### What might I need to know before starting
#
# This page builds on the [Renewal then delay](@ref tutorial-renewal-delay) tutorial.

# ## Packages used

using ComposableRecurrences
using CairoMakie, AlgebraOfGraphics, DataFramesMeta

CairoMakie.activate!(type = "png", px_per_unit = 2)

# ## Compiling a renewal process
#
# Put the model in a function of the parameters, move the parameters to Reactant arrays with `Reactant.to_rarray`, and compile with `@compile`.
# Only the arguments are traced: values the function reads from outside, such as the history or the loss weights, are constants of the compiled program.
#
# ```julia
# using ComposableRecurrences, Reactant, Enzyme
# Reactant.set_default_backend("cpu")  # or "gpu"
#
# const T, L = 200, 20
# const history = ones(L)
# const w = sin.(1:T)
# g = exp.(-0.2 .* (1:L)); g ./= sum(g)
#
# renewal(θ) = Recurrence(θ[1:L])(θ[(L + 1):end]; history)
# loss(θ) = sum(w .* renewal(θ))
# gradient(θ) = Enzyme.gradient(Enzyme.Reverse, loss, θ)[1]
#
# θ = Reactant.to_rarray(vcat(g, fill(1.02, T)))
# renewal_c = @compile renewal(θ)
# gradient_c = @compile gradient(θ)
# y = renewal_c(θ)
# ∇ = gradient_c(θ)
# ```
#
# The compiled functions are called like the originals and return Reactant arrays; `Array(y)` copies one back.
# The gradient is Enzyme's reverse pass of the traced program.
# Custom adjoints do not apply under Reactant, and none are needed.

# ## What compiles
#
# The Reactant test suite in `test/reactant` compiles every case forward and reverse on the CPU and a GPU, and checks the result against plain Julia and ForwardDiff.
# Its latest table is in [`test/reactant/RESULTS.md`](https://github.com/EpiAware/ComposableRecurrences.jl/blob/main/test/reactant/RESULTS.md).
#
# | Piece | Forward | Gradient |
# |---|---|---|
# | `Recurrence`: vector, `PerStratum`, `TimeVarying` and `Pairwise` kernels | yes | yes |
# | Couplings: `I`, dense, `TimeVarying` | yes | yes |
# | Modifiers: `Depletion`, `Add`, `Clamp`, `Redistribute`, custom pointwise and all-strata | yes | yes |
# | Resuming with `with_state` and `state` | yes | yes |
# | `Convolution`: fixed and `TimeVarying` kernels, `Primary()` and `Secondary()` | yes | yes |
#
# The recurrence's step loop is traced as one loop, so compile time does not grow with the number of steps.
# `Convolution` has no step loop: it works over whole series.

# ## Compile and run times
#
# The benchmark matrix times each case compiled with Reactant, including the first call, and then the compiled call on its own.
# The plain Julia times are of the same call without Reactant, on one CPU thread.

results = let
    file = joinpath(pkgdir(ComposableRecurrences), "benchmark", "results", "reactant.csv")
    lines = readlines(file)
    header = Symbol.(split(first(lines), ','))
    rows = [split(l, ',') for l in lines[2:end]]
    DataFrame([h => [r[i] for r in rows] for (i, h) in enumerate(header)])
end
ok = @chain results begin
    @rsubset :status == "ok"
    @rtransform :median_us = parse(Float64, :median_us) :plain_median_us =
        parse(Float64, :plain_median_us) :prep_s = parse(Float64, :prep_s)
end

# Run time of the compiled call against plain Julia:

@chain ok begin
    stack([:median_us, :plain_median_us]; variable_name = :method, value_name = :us)
    @rtransform :method = :method == "median_us" ? "Reactant" : "plain Julia"
    data(_) *
        mapping(:case, :us => "Median time (µs)", color = :method, dodge = :method, col = :target) *
        visual(BarPlot)
    draw(_; axis = (xticklabelrotation = π / 4, yscale = log10))
end

# Compile time, including the first call:

@chain ok begin
    data(_) * mapping(:case, :prep_s => "Compile (s)", col = :target) * visual(BarPlot)
    draw(_; axis = (xticklabelrotation = π / 4,))
end
