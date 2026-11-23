# [GPUArrays + GPUArraysCore + KernelAbstractions extension](@id extension-gpuarrays)

Loading GPUArrays runs a coupling that is a device sparse matrix in CSR form, one stratum's row per kernel index.
Every GPU array package loads GPUArrays, so this loads with the [GPUArraysCore extension](@ref extension-gpuarrays-core).
A host `SparseMatrixCSC` coupling on device inputs is an error.
Other device sparse forms use the array package's own `mul!` and are untested ([#834](https://github.com/EpiAware/ComposableRecurrences.jl/issues/834)).
JLArrays has no device sparse matrix; with CUDA:

```julia
using ComposableRecurrences, CUDA, CUDA.CUSPARSE, SparseArrays
C = CuSparseMatrixCSR(sparse([0.9 0.1; 0.2 0.8]))
r = Recurrence(CuArray([0.5, 0.3]); coupling = C)
y = r(CuArray(fill(1.1f0, 2, 4)); history = CuArray(ones(Float32, 2, 2)))
```

All extensions are listed in the [overview](@ref extensions-overview).
