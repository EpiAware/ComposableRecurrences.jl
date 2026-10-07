# [GPUArraysCore + KernelAbstractions extension](@id extension-gpuarrays-core)

`ComposableRecurrencesGPUArraysCoreExt` is loaded automatically when GPUArraysCore and KernelAbstractions are available alongside ComposableRecurrences.

It makes calls on GPU arrays under the default [`Serial`](@ref ComposableRecurrences.Serial) executor run on their [`Device`](@ref ComposableRecurrences.Device).
