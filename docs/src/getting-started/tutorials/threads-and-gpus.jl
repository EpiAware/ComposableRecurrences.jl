# # [Threads and GPUs](@id tutorial-threads-gpus)
#
# ## Introduction
#
# A stratum is one of `S` series computed together, such as a place or an age group.
# Strata that do not mix within a step, and the outputs of a convolution, can be computed at the same time.
# An executor sets how: `Serial()` runs them in order, `Threaded()` splits them across CPU threads, and `Device(backend)` runs them as a kernel on a GPU.
# The executor is chosen for a block of code, so the model code does not change.
#
# ### What are we going to do in this exercise
#
# 1. Run a many-strata renewal model on threads and check it matches the serial run.
# 2. Read how the speed-up grows with threads and strata.
# 3. Run the same model, and its gradient, on GPU-style arrays.
# 4. See what each executor supports.
#
# ### What might I need to know before starting
#
# This tutorial builds on the [Spatial and multi-type models](@ref tutorial-spatial-strata) tutorial, and uses AlgebraOfGraphics.jl and CairoMakie.jl for plotting.
# Start Julia with more than one thread, for example `julia --threads=4`, to see a speed-up.

# ## Packages used

using ComposableRecurrences
using ComposableRecurrences: EXECUTOR, Serial, Threaded, Device
using Base.ScopedValues: with
using CairoMakie, AlgebraOfGraphics, DataFramesMeta, CSV
using JLArrays, KernelAbstractions
using ForwardDiff

CairoMakie.activate!(type = "png", px_per_unit = 2)

# ## Threads
#
# Each of the `S` strata has its own reproduction number and generation interval, with no mixing between strata:
#
# ```math
# y_{t,i} = R_{t,i} \sum_{l=1}^{L} k_{i,l} \, y_{t-l,i}, \qquad i = 1, \ldots, S.
# ```
#
# The strata are independent, so each thread can run a block of them over the whole series.

S, T, L = 500, 200, 20
gi = [exp(-0.2 * l) for l in 1:L]
kernel = PerStratum(repeat((gi ./ sum(gi))', S))
R = [1.0 + 0.05 * sin(i + t) for i in 1:S, t in 1:T]
seed = ones(S, L)
r = Recurrence(kernel)

y_serial = r(R; history = seed)
y_threaded = with(EXECUTOR => Threaded()) do
    r(R; history = seed)
end
y_threaded == y_serial

# Each stratum's output is written by one thread only, so the results are identical, not just close.

Threads.nthreads()

# ## Speed-up over threads
#
# The benchmark run times the model above at `S` = 5, 50 and 500 strata over 1 to 8 threads.
# The numbers are read from the published results, not timed while these docs were built.

results_file = joinpath(pkgdir(ComposableRecurrences), "benchmark", "results", "executors.csv")
if isfile(results_file)
    speedup = @chain CSV.read(results_file, DataFrame) begin
        @rsubset :device == "CPU"
        @groupby :case :S :arm
        @transform :speedup = first(:time_us[:threads .== 1]) ./ :time_us
    end
    draw(
        data(speedup) *
            mapping(
            :threads => "Threads", :speedup => "Speed-up over one thread",
            color = :S => nonnumeric => "Strata", col = :arm
        ) *
            visual(ScatterLines);
        axis = (xticks = [1, 2, 4, 8],)
    )
else
    @info "No executor benchmark results at $results_file; run `task benchmark-executor`."
end

# TODO(numbers): one sentence on the break-even size, from the results file.

# ## GPU arrays
#
# `Device(backend)` runs the same per-stratum loops as one GPU kernel each.
# Calls on arrays that live on a GPU use it without being asked.
# JLArrays.jl provides GPU-style arrays that run on the CPU, so this section runs anywhere.

JLArrays.allowscalar(false)
y_device = r(JLArray(R); history = JLArray(seed))
Array(y_device) ≈ y_serial

# The gradient of a loss with respect to the reproduction numbers goes through the same kernels.

loss(R) = sum(abs2, r(R; history = JLArray(seed)))
# TODO(gradient): gradient on JLArrays through the package's adjoints, compared with the CPU gradient.

# On a real GPU the code is the same, with the arrays moved to the device:
#
# ```julia
# using CUDA
# y = r(CuArray(R); history = CuArray(seed))
# ```
#
# TODO(numbers): RTX 2070 timings from the results file, with the hardware stated.

# ## What each executor supports
#
# TODO(table): forward and gradient support per executor and AD backend, filled from the tests.
#
# | executor | forward | ForwardDiff | Mooncake | Enzyme |
# |:-------- |:------- |:----------- |:-------- |:------ |
# | `Serial()` | | | | |
# | `Threaded()` | | | | |
# | `Device(backend)` | | | | |
#
# Calls that an AD backend traces itself, rather than differentiating through the package's adjoints, always run serially.

# ## Compiling the whole model with Reactant
#
# Reactant.jl compiles a whole model, including the loops, for a CPU or GPU, and differentiates it with Enzyme.
# See the [Reactant](@ref reactant) page for what runs.
