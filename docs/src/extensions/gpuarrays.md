# [GPUArrays + KernelAbstractions extension](@id extension-gpuarrays)

Loading a GPU array package, with KernelAbstractions, runs operator calls on its arrays as kernels on the device.
Every GPU array package loads GPUArrays, so `using CUDA, KernelAbstractions` is enough.
Put the inputs, history and parameters on the device, and the call runs there under the default executor.
JLArrays stands in for a GPU here; CUDA, AMDGPU and Metal arrays work the same way.

```jldoctest gpu
using ComposableRecurrences, JLArrays, KernelAbstractions
r = Recurrence(JLArray([0.5, 0.3]); coupling = JLArray([0.9 0.1; 0.2 0.8]))
R, h = JLArray([1.2, 0.9] .* ones(2, 4)), JLArray(ones(2, 2))
y = r(R; history = h)
round.(Array(y); digits = 3)

# output

2×4 Matrix{Float64}:
 0.96  0.922  0.872  0.822
 0.72  0.616  0.512  0.445
```

Mooncake and Enzyme fail on JLArrays and are untested on a GPU, so take forward-mode derivatives with dual numbers built on the device.
Here, the gradient of the total over the two kernel weights:

```jldoctest gpu
using ForwardDiff: Dual, partials
g = JLArray([Dual(0.5, 1.0, 0.0), Dual(0.3, 0.0, 1.0)])
rg = Recurrence(g; coupling = JLArray([0.9 0.1; 0.2 0.8]))
round.(Tuple(partials(sum(rg(R; history = h)))); digits = 3)

# output

(13.736, 14.662)
```

## Known issues

| Symptom | Workaround |
|---|---|
| `ArgumentError` naming a host array | Move every array the call reads to the device, e.g. `Adapt.adapt(CuArray, r)` |
| Runs in `Float64` and is slow | Convert with [`convert_floats(Float32, r)`](@ref ComposableRecurrences.convert_floats), from the [Functors extension](@ref extension-functors) |
| Scalar-indexing error from a user coupling or modifier | Write its `forward!` with broadcasts and `mul!` |
| `ForwardDiff.gradient` errors with scalar indexing | Build the duals directly, as above |
| `ArgumentError` for a `SparseMatrixCSC` coupling on device inputs | Move it to the device in CSR form, e.g. `CuSparseMatrixCSR(C)` |
| A device sparse coupling in another form uses the array package's `mul!` | Untested; prefer CSR |
| Enzyme or Mooncake fail on JLArrays; untested on a GPU | Use dual numbers, as above |

What runs on a device, and which rules cover it, is in [GPU arrays](@ref gpu-arrays).

All extensions are listed in the [overview](@ref extensions-overview).
