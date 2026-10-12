# # [Threads and GPUs](@id tutorial-threads-gpus)
#
# !!! note "Draft"
#     This tutorial is a draft and is not in the docs build yet: it is not
#     listed in `docs/docs_config.jl`, and the docs environment does not have
#     JLArrays.jl or KernelAbstractions.jl.
#     Before it is listed it needs speed-up results from 8 to 16 threads on a
#     dedicated machine (`benchmark/threshold.jl`), with the hardware stated.
#
# ## Introduction
#
# A stratum is one of `S` series computed together, such as a place or an age group.
# Strata that do not mix within a step, and the strata of a convolution, can be computed at the same time.
# An executor sets how: `Serial()` runs them in order, `Threaded()` splits them across CPU threads, and `Device(backend)` runs them as a kernel on a GPU.
# The executor is chosen for a block of code, so the model code does not change.
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
# This tutorial builds on the [Spatial and multi-type models](@ref tutorial-spatial-strata) tutorial.
# Start Julia with more than one thread, for example `julia --threads=4`, to see a speed-up.

# ## Packages used

using ComposableRecurrences
using ComposableRecurrences: EXECUTOR, Serial, Threaded, Device
using Base.ScopedValues: with
using JLArrays, KernelAbstractions

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

# ## When threads pay off
#
# Starting and joining the tasks costs tens of microseconds, so `Threaded()` runs a loop in order when its work, in multiply-adds, is below `min_work`.
# [`Threaded`](@ref ComposableRecurrences.Threaded) gives the default, and says which loops a model has, and so when mixing strata gain.
# The timings below depend on the machine, and are of whole calls, including serial work outside the split loops.
# On a quiet 4-core virtual machine (Intel Xeon at 2.1 GHz, Julia 1.12), four threads began to beat one from about 500 000 multiply-adds per loop for independent strata and pairwise kernels.
# At two million multiply-adds, independent strata ran 1.1 to 1.2 times faster and pairwise kernels 1.4 to 1.6 times faster.
# A sparse coupling gained inconsistently: 0.94 to 1.16 times between 200 000 and 500 000 multiply-adds, and up to 1.5 times at two million.
# At 10 000 multiply-adds, threads were 1.6 to 3.8 times slower than the serial loop.
# A convolution gained at most 1.2 times, and lost from 500 000 multiply-adds in some runs and from one million in all.
# Under Mooncake reverse mode only the rule's forward pass is threaded, so gradients of independent strata and pairwise kernels gained at most 1.15 times, and a convolution's gradient did not gain.
#
# Set `min_work` to move the break-even point.
# This model's work is `S × T × L`, two million multiply-adds, so it still splits with a higher threshold:

with(EXECUTOR => Threaded(; min_work = 1_000_000)) do
    r(R; history = seed)
end == y_serial

# ## GPU arrays
#
# `Device(backend)` runs the same strata loops as one GPU kernel each.
# Calls on arrays that live on a GPU use it without being asked.
# Every array a call reads moves to the device: the inputs, the history, the kernel, the coupling and the modifiers' parameters.
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
# A recurrence pays one kernel launch per step when its strata mix, so a GPU pays off only with many strata or many series.
# On arrays that live on a GPU, `Threaded()` spawns CPU tasks that index the arrays from the host, so use `Device(backend)` there.
# To compile a model with Reactant.jl instead, see the [FAQ](@ref faq-reactant).

# ## What each executor supports
#
# [Executors](@ref executors) lists what each executor supports under each AD backend.
