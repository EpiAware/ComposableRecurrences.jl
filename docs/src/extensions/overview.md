# [Extensions](@id extensions-overview)

Each extension loads by itself when you load its packages alongside ComposableRecurrences.
None is needed to build or run a model.

| Load | Adds | Use it for | Page |
|---|---|---|---|
| `using Distributions` | Discrete distributions as delay kernels | Delays from a named distribution | [Distributions](@ref extension-distributions) |
| `using CensoredDistributions, Distributions` | Continuous distributions as kernels, censored to whole lags | Continuous delays | [CensoredDistributions](@ref extension-censored-distributions) |
| `using ForwardDiff` | Dual-number local step for couplings and modifiers without a `pullback!` | Faster reverse-mode gradients through them | [ForwardDiff](@ref extension-forwarddiff) |
| `using Enzyme` | Enzyme reverse-mode rules | Enzyme gradients | [Enzyme](@ref extension-enzyme) |
| `using Mooncake` | Mooncake reverse-mode rules and `test_adjoint` | Mooncake gradients | [Mooncake](@ref extension-mooncake) |
| `using Enzyme, EnzymeTestUtils` | `test_adjoint` for `AutoEnzyme` | Testing a new rule | [EnzymeTestUtils](@ref extension-enzyme-test-utils) |
| `using FFTW` | FFT lag sums for `Convolution` | Long kernels over long series | [FFTW](@ref extension-fftw) |
| `using Functors` | `convert_floats` | Runs in `Float32` | [Functors](@ref extension-functors) |
| `using KernelAbstractions` | `Parallel` executor and Adapt rules | Kernels without a GPU package | [KernelAbstractions](@ref extension-kernel-abstractions) |
| `using CUDA, KernelAbstractions`, or any GPUArrays backend | Calls on device arrays, including CSR couplings, run as kernels | GPUs | [GPUArrays](@ref extension-gpuarrays) |
| `using Reactant, KernelAbstractions, CUDA` | Compiled calls on traced arrays | Compiling a model with Reactant | [Reactant](@ref extension-reactant) |
