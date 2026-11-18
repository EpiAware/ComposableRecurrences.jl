# [GPUArrays + GPUArraysCore + KernelAbstractions extension](@id extension-gpuarrays)

Loading GPUArrays, GPUArraysCore and KernelAbstractions with ComposableRecurrences loads `ComposableRecurrencesGPUArraysExt`.

It runs a coupling that is a [device](@ref gpu-arrays) sparse matrix in CSR form as one kernel per step, each stratum's row one index of it.
