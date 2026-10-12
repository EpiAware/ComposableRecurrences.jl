# [GPUArrays extension](@id extension-gpuarrays)

`ComposableRecurrencesGPUArraysExt` is loaded automatically when GPUArrays, GPUArraysCore and KernelAbstractions are available alongside ComposableRecurrences.

It runs a coupling that is a device sparse matrix in CSR form as one kernel per step, each stratum's row one index of it.
[GPU arrays](@ref gpu-arrays) says how each part runs on a device.
