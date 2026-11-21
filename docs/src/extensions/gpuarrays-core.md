# [GPUArraysCore + KernelAbstractions extension](@id extension-gpuarrays-core)

Loading GPUArraysCore and KernelAbstractions with ComposableRecurrences loads `ComposableRecurrencesGPUArraysCoreExt`.

It makes calls on [GPU arrays](@ref gpu-arrays) under the default [`Serial`](@ref ComposableRecurrences.Serial) executor run with [`Parallel`](@ref ComposableRecurrences.Parallel) on their backend.
It also adds the device methods those calls need: kernels reversed without scalar indexing, and dense, `Diagonal` and time-varying couplings as `mul!` or a broadcast.
The Adapt.jl rules that carry the wrappers and modifiers into a kernel come from the [KernelAbstractions extension](@ref extension-kernel-abstractions).
