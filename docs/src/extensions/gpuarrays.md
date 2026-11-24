# [Running on GPU arrays](@id extension-gpuarrays)

Loading a GPU array package, with KernelAbstractions, runs operator calls on its arrays as kernels on the device.
Every GPU array package loads GPUArrays, so `using CUDA, KernelAbstractions` is enough.
Put every array the call reads on the device, e.g. with `Adapt.adapt(CuArray, r)`, and the call runs there under the default executor.
Convert floats with [`convert_floats(Float32, r)`](@ref ComposableRecurrences.convert_floats) to run in `Float32`.
A sparse coupling must be a device sparse matrix, best in CSR form, one stratum's row per kernel index.
A CSC or other device sparse coupling is converted to CSR when the recurrence is built, through the array package's own conversion.
A form the package cannot convert is kept as given and runs through the package's own sparse products.
A device sparse coupling takes plain AD rather than the rule ([#834](https://github.com/EpiAware/ComposableRecurrences.jl/issues/834)).
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

Mooncake and Enzyme fail on JLArrays and are untested on a GPU ([#835](https://github.com/EpiAware/ComposableRecurrences.jl/issues/835)), so take forward-mode derivatives with dual numbers built on the device.
The gradient of the total over the two kernel weights:

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
| `ForwardDiff.gradient` errors with scalar indexing | Build the duals directly, as above |

What runs on a device, and which rules cover it, is in [GPU arrays](@ref gpu-arrays).
