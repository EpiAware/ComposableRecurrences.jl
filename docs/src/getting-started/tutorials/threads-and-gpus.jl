# # [Threads and GPUs](@id tutorial-threads-gpus)
#
# !!! note "Draft"
#     This tutorial is a draft and is not in the docs build yet: it is not listed in `docs/docs_config.jl` or the navigation in `docs/pages.jl`, and the docs environment does not have JLArrays.jl or KernelAbstractions.jl.
#     Its timings come from a shared 4-core machine; before it is listed it needs speed-ups from 8 to 16 threads on a dedicated machine (`benchmark/threshold.jl`), with the hardware stated.
#
# ## Introduction
#
# [Strata](@ref glossary-stratum) that do not mix within a step, and the strata of a convolution, can be computed at the same time.
# An [executor](@ref executors), chosen for a block of code, sets how, so the model code does not change.
#
# ### What are we going to do in this exercise
#
# 1. Run a many-strata renewal model on threads and check it matches the serial run.
# 2. See when threads pay off.
# 3. Run the same model on GPU-style arrays.
# 4. See what each executor supports.
#
# ### What might I need to know before starting
#
# This builds on [Spatial models](@ref tutorial-spatial-strata).
# Start Julia with more than one thread, for example `julia --threads=4`, to see a speed-up.

# ## Packages used

using ComposableRecurrences
using ComposableRecurrences: EXECUTOR, Serial, Threaded, Device
using Base.ScopedValues: with
using JLArrays, KernelAbstractions

# ## Threads
#
# Each of the `S` strata has its own reproduction number and generation interval, with no mixing:
#
# ```math
# y_{t,i} = R_{t,i} \sum_{l=1}^{L} k_{i,l} \, y_{t-l,i}, \qquad i = 1, \ldots, S.
# ```
#
# The strata are independent, so each thread can run a block of them over the whole series.

S, T, L = 1000, 200, 20
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

# Each stratum's output is written by one thread only, so the results are identical.

Threads.nthreads()

# ## When threads pay off
#
# Starting and joining the tasks costs tens of microseconds, so `Threaded()` runs a loop in order when its work is below `min_work`.
# [`Threaded`](@ref ComposableRecurrences.Threaded) gives the default and how each kind of loop counts its work.
#
# The table gives the speed-up of four threads over one for whole losses, including the serial work outside the split loops.
# The machine was a shared 4-core virtual machine (Intel Xeon at 2.1 GHz, Julia 1.12, load about 2).
# Each range is the spread over three rounds that alternate the executors.
# ForwardDiff is one pushforward of 8 tangents.
# The work is that of the loop the executor splits, in multiply-adds: `S × T × L` for independent strata and a convolution, `S² × L` per step for a pairwise kernel and `S × L` per step for a sparse coupling.
#
# | Model | Work | Primal | Mooncake reverse | Enzyme reverse | ForwardDiff |
# |---|---|---|---|---|---|
# | independent strata | 10 000 | 0.52–0.89 | 0.58–0.76 | 0.52–0.88 | 0.93–1.00 |
# | independent strata | 500 000 | 0.94–1.02 | 0.99–1.14 | 0.98–1.04 | 1.15–1.44 |
# | independent strata | 2 million | 1.03–1.07 | 1.04–1.16 | 1.11–1.26 | 1.71–1.82 |
# | independent strata | 4 million | 1.05–1.20 | 1.16–1.35 | 1.16–1.31 | |
# | independent strata | 16 million | 1.46–1.70 | 1.34–1.93 | 1.54–1.63 | |
# | pairwise kernel | 10 000 | 0.21–0.22 | 0.29–0.33 | 0.25–0.33 | 0.93–1.09 |
# | pairwise kernel | 200 000 | 0.87–0.97 | 0.80–0.84 | 0.78–0.86 | 1.34–1.74 |
# | pairwise kernel | 500 000 | 1.24–1.36 | 0.91–1.03 | 0.90–0.95 | 1.31–1.72 |
# | pairwise kernel | 2 million | 1.39–1.69 | 1.03–1.15 | 0.93–1.00 | 2.33–2.72 |
# | sparse coupling | 10 000 | 0.29–0.31 | 0.49–0.53 | 0.41–0.43 | 0.56–0.76 |
# | sparse coupling | 200 000 | 0.94–1.03 | 0.94–1.13 | 0.96–1.12 | 1.08–1.31 |
# | sparse coupling | 500 000 | 0.91–1.12 | 0.99–1.10 | 0.99–1.22 | 1.23–1.48 |
# | sparse coupling | 2 million | 0.83–1.22 | 1.18–2.31 | 1.13–1.93 | 1.15–1.74 |
# | convolution | 10 000 | 0.46–0.67 | 0.58–0.64 | 0.58–0.66 | 0.53–0.82 |
# | convolution | 2 million | 0.81–0.85 | 1.00–1.06 | 0.87–0.94 | 1.64–1.71 |
# | convolution | 8 million | 0.82–1.13 | 1.07–1.17 | 1.13–1.15 | |
#
# The machine was shared, so the ranges are indicative.
# A second run of independent strata at two million multiply-adds gave 0.92 to 0.98 on the primal and in reverse mode, so that row is break-even.
# Below a few hundred thousand multiply-adds threads lost on the primal and in reverse mode.
# With dual numbers each multiply-add costs more, so threads gained from less work; below 500 000 the gains for strata that mix varied between runs.
# A convolution with a fixed kernel vectorises well, and its primal gained little at any size.
# Much of a recurrence's call is serial: allocating its buffer and output and, in these losses, the transforms of its inputs and outputs.
#
# `min_work` moves the break-even point.
# This model's work is `S × T × L`, four million multiply-adds, so it splits under the default threshold but not under one twice as high:

with(EXECUTOR => Threaded(; min_work = 1_000_000)) do
    r(R; history = seed)
end == y_serial

# The result is the same either way.

# ## GPU arrays
#
# `Device(backend)` runs the same strata loops as one GPU kernel each.
# Calls on arrays that live on a GPU use it by default.
# Every array a call reads must be on the device; [GPU arrays](@ref gpu-arrays) lists them.
# JLArrays.jl provides GPU-style arrays that run on the CPU, so this section runs anywhere.

JLArrays.allowscalar(false)
r_device = Recurrence(PerStratum(JLArray(kernel.x)))
y_device = r_device(JLArray(R); history = JLArray(seed))
Array(y_device) ≈ y_serial

# On a real GPU the code is the same, with the arrays moved to the device:
#
# ```julia
# using CUDA
# r_cuda = Recurrence(PerStratum(CuArray(kernel.x)))
# y = r_cuda(CuArray(R); history = CuArray(seed))
# ```
#
# [GPU arrays](@ref gpu-arrays) gives the cost of strata that mix on a GPU.
# On arrays that live on a GPU, `Threaded()` spawns CPU tasks that index the arrays from the host, so use `Device(backend)` there.
# To compile a model with Reactant.jl instead, see the [Reactant extension](@ref extension-reactant).

# ## What each executor supports
#
# [Executors](@ref executors) lists what each executor supports under each AD backend.
