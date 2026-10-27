# [GPUArrays extension](@id extension-gpuarrays)

`ComposableRecurrencesGPUArraysExt` is loaded automatically when GPUArrays, GPUArraysCore and KernelAbstractions are available alongside ComposableRecurrences.

It runs a coupling that is a [device](@ref gpu-arrays) sparse matrix in CSR form as one kernel per step, each stratum's row one index of it.
