# [Getting started](@id getting-started)

A recurrence computes each value from its own past values, such as infections from earlier infections.
A convolution weights the past values of another series, such as reported cases from earlier infections.
[`Recurrence`](@ref) and [`Convolution`](@ref) are the two operators.
Couplings link strata, such as towns, and modifiers add behaviour such as finite pools to each step.
Every operator is differentiable.
Operators run on CPU threads and on [GPU arrays](@ref gpu-arrays) through [executors](@ref executors).
On Julia 1.12 and later, a forward run compiles into a [trimmed executable](@ref trimming) with `juliac`.

## Where to start

- New to the package? [Three towns, step by step](@ref tutorial-three-towns) builds an outbreak model one part at a time.
- Looking for an operator, coupling or modifier? See the [API overview](@ref api-overview).
- Is your data weekly or monthly? See [Time units](@ref time-units).
- Have a model in mind? Each tutorial in this section builds one, starting with [Renewal then delay](@ref tutorial-renewal-delay).
- Coming from epidemiology? [Infectious disease models](@ref infectious-disease-models) maps renewal processes, delays and occupancy to the package.
- Want to know how it works? The Explanation pages start with [Operators](@ref explanation-operators).
- Want to write your own modifier or coupling? See the [Developer documentation](@ref developer).
- Want the full interface? See the [Public API](@ref public-api).
- Need GPUs, an AD backend or distributions? See [Extensions](@ref extensions-overview).

## [Extensions](@id extensions-overview)

Each extension loads by itself when you load its packages alongside ComposableRecurrences.
None is needed to build or run a model.

| Load | Adds | Use it for | Page |
|---|---|---|---|
| `using Distributions` | Discrete distributions as delay kernels | Delays from a named distribution | [Distributions](@ref extension-distributions) |
| `using CensoredDistributions, Distributions` | Continuous distributions as kernels, censored to whole lags | Continuous delays | [CensoredDistributions](@ref extension-censored-distributions) |
| `using ForwardDiff` | Dual-number local step for couplings and modifiers without a `pullback!` | Faster reverse-mode gradients through them | [ForwardDiff](@ref extension-forwarddiff) |
| `using Enzyme` | Enzyme reverse-mode rules | Enzyme gradients | [Enzyme](@ref extension-enzyme) |
| `using Mooncake` | Mooncake reverse-mode rules and `test_adjoint` | Mooncake gradients | [Mooncake](@ref extension-mooncake) |
| `using ADTypes, Enzyme, EnzymeTestUtils` | `test_adjoint` for `AutoEnzyme` | Testing a new rule | [EnzymeTestUtils](@ref extension-enzyme-test-utils) |
| `using FFTW` | FFT lag sums for `Convolution` | Long kernels over long series | [FFTW](@ref extension-fftw) |
| `using Functors` | `convert_floats` | Runs in `Float32` | [Functors](@ref extension-functors) |
| `using KernelAbstractions` | `Parallel` executor and Adapt rules | Kernels without a GPU package | [KernelAbstractions](@ref extension-kernel-abstractions) |
| `using CUDA, KernelAbstractions`, or any GPUArrays backend | Calls on device arrays run as kernels | GPUs | [GPU arrays](@ref extension-gpuarrays-core) |
| As above | Device CSR couplings | Sparse couplings on a GPU | [GPU sparse couplings](@ref extension-gpuarrays) |
| `using Reactant, KernelAbstractions, CUDA` | Compiled calls on traced arrays | Compiling a model with Reactant | [Reactant](@ref extension-reactant) |

## Getting help

For usage questions, ask on the [Julia Discourse](https://discourse.julialang.org) or the [epinowcast community forum](https://community.epinowcast.org), our home for epidemiological modelling questions.
Please use [GitHub issues](https://github.com/EpiAware/ComposableRecurrences.jl/issues) for bug reports and feature requests only.
