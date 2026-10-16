# [GPUArraysCore + KernelAbstractions extension](@id extension-gpuarrays-core)

`ComposableRecurrencesGPUArraysCoreExt` is loaded automatically when GPUArraysCore and KernelAbstractions are available alongside ComposableRecurrences; KernelAbstractions loads Adapt, its third trigger.

It makes calls on GPU arrays under the default [`Serial`](@ref ComposableRecurrences.Serial) executor run on their [`Device`](@ref ComposableRecurrences.Device).
It also adds the device methods those calls need: kernels reversed without scalar indexing, and dense, `Diagonal` and time-varying couplings as `mul!` or a broadcast.
The Adapt.jl rules that carry the wrappers and modifiers into a kernel come from the [KernelAbstractions extension](@ref extension-kernel-abstractions).
[GPU arrays](@ref gpu-arrays) says how each part runs on a device.
