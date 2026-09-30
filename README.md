# ComposableRecurrences <img src="docs/src/assets/logo.svg" width="150" alt="ComposableRecurrences logo" align="right">

<!-- badges:start -->
| **Documentation** | **Build Status** | **Code Quality** | **License & DOI** | **Downloads** |
|:-----------------:|:----------------:|:----------------:|:-----------------:|:-------------:|
| [![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://composablerecurrences.epiaware.org/stable/) [![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://composablerecurrences.epiaware.org/dev/) | [![Test](https://github.com/EpiAware/ComposableRecurrences.jl/actions/workflows/test.yaml/badge.svg?branch=main)](https://github.com/EpiAware/ComposableRecurrences.jl/actions/workflows/test.yaml) [![codecov](https://codecov.io/gh/EpiAware/ComposableRecurrences.jl/graph/badge.svg)](https://codecov.io/gh/EpiAware/ComposableRecurrences.jl) [![AD](https://github.com/EpiAware/ComposableRecurrences.jl/actions/workflows/ad.yaml/badge.svg?branch=main)](https://github.com/EpiAware/ComposableRecurrences.jl/actions/workflows/ad.yaml) | [![code style: runic](https://img.shields.io/badge/code_style-%E1%9A%B1%E1%9A%A2%E1%9A%BE%E1%9B%81%E1%9A%B2-black)](https://github.com/fredrikekre/Runic.jl) [![Aqua QA](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl) [![JET](https://img.shields.io/badge/%E2%9C%88%EF%B8%8F%20tested%20with%20-%20JET.jl%20-%20red)](https://github.com/aviatesk/JET.jl) | [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) | [![Downloads](https://img.shields.io/badge/dynamic/json?url=http%3A%2F%2Fjuliapkgstats.com%2Fapi%2Fv1%2Ftotal_downloads%2FComposableRecurrences&query=total_requests&label=Downloads)](https://juliapkgstats.com/pkg/ComposableRecurrences) [![Downloads](https://img.shields.io/badge/dynamic/json?url=http%3A%2F%2Fjuliapkgstats.com%2Fapi%2Fv1%2Fmonthly_downloads%2FComposableRecurrences&query=total_requests&suffix=%2Fmonth&label=Downloads)](https://juliapkgstats.com/pkg/ComposableRecurrences) |

| ForwardDiff | ReverseDiff (tape) | ReverseDiff (compiled) | Enzyme forward | Enzyme reverse | Mooncake reverse | Mooncake forward |
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| [![cov ForwardDiff](https://codecov.io/gh/EpiAware/ComposableRecurrences.jl/graph/badge.svg?flag=ad-forwarddiff)](https://app.codecov.io/gh/EpiAware/ComposableRecurrences.jl?flags%5B0%5D=ad-forwarddiff) | [![cov ReverseDiff](https://codecov.io/gh/EpiAware/ComposableRecurrences.jl/graph/badge.svg?flag=ad-reversediff)](https://app.codecov.io/gh/EpiAware/ComposableRecurrences.jl?flags%5B0%5D=ad-reversediff) | [![cov ReverseDiff compiled](https://codecov.io/gh/EpiAware/ComposableRecurrences.jl/graph/badge.svg?flag=ad-reversediff-compiled)](https://app.codecov.io/gh/EpiAware/ComposableRecurrences.jl?flags%5B0%5D=ad-reversediff-compiled) | [![cov Enzyme forward](https://codecov.io/gh/EpiAware/ComposableRecurrences.jl/graph/badge.svg?flag=ad-enzyme-forward)](https://app.codecov.io/gh/EpiAware/ComposableRecurrences.jl?flags%5B0%5D=ad-enzyme-forward) | [![cov Enzyme reverse](https://codecov.io/gh/EpiAware/ComposableRecurrences.jl/graph/badge.svg?flag=ad-enzyme-reverse)](https://app.codecov.io/gh/EpiAware/ComposableRecurrences.jl?flags%5B0%5D=ad-enzyme-reverse) | [![cov Mooncake reverse](https://codecov.io/gh/EpiAware/ComposableRecurrences.jl/graph/badge.svg?flag=ad-mooncake-reverse)](https://app.codecov.io/gh/EpiAware/ComposableRecurrences.jl?flags%5B0%5D=ad-mooncake-reverse) | [![cov Mooncake forward](https://codecov.io/gh/EpiAware/ComposableRecurrences.jl/graph/badge.svg?flag=ad-mooncake-forward)](https://app.codecov.io/gh/EpiAware/ComposableRecurrences.jl?flags%5B0%5D=ad-mooncake-forward) |
<!-- badges:end -->

Fast, composable and differentiable recurrences and causal convolutions in Julia.

## Why ComposableRecurrences?

- One pair of operators, `Recurrence` and `Convolution`, covers renewal processes, reporting delays and latent processes such as random walks.
- Models are built from small pieces, such as depletion or mixing between groups, and your own pieces plug in alongside them.
- Gradients are fast under ForwardDiff, Mooncake and Enzyme, so models fit with gradient-based samplers such as NUTS.
- It is designed as the shared base that other EpiAware modelling packages build on.

## Getting started

A renewal process followed by a reporting delay.

```julia
using ComposableRecurrences

renewal = Recurrence([0.2, 0.5, 0.3])
delay = Convolution([0.1, 0.4, 0.3, 0.2])
infections = renewal(fill(1.2, 30); history = fill(10.0, 3))
reports = delay(infections)
round.(reports[(end - 4):end])
```

See the [documentation](https://composablerecurrences.epiaware.org/stable/) for a three-town model with depletion, its gradients and a full walkthrough.

## Related packages

- [ComposableTuringIDModels.jl](https://composableturingidmodels.epiaware.org) builds infectious disease models from renewal, delay and latent process components.
- [ConvolvedDistributions.jl](https://convolveddistributions.epiaware.org) builds convolutions of distributions, such as the total of two independent delays.
- [CensoredDistributions.jl](https://censoreddistributions.epiaware.org) discretises delay distributions into the probability mass functions these operators take as kernels.

## Where to learn more

- [GitHub Repository](https://github.com/EpiAware/ComposableRecurrences.jl)

<!-- standard-sections:start -->
<!-- MANAGED by EpiAwarePackageTools.scaffold — do not edit between the
     markers. These standard sections are re-rendered on every update;
     edit the package-owned sections outside them, or CITATION.cff. -->

## Part of the EpiAware ecosystem

ComposableRecurrences is part of [EpiAware](https://epiaware.org), a set of composable tools for infectious disease modelling. See the [other packages](https://github.com/EpiAware) in the ecosystem.

## Contributing

We welcome contributions and new contributors! Please open an issue or pull request on [GitHub](https://github.com/EpiAware/ComposableRecurrences.jl). This package follows [ColPrac](https://github.com/SciML/ColPrac) and is formatted with [Runic](https://github.com/fredrikekre/Runic.jl).

## How to cite

If you use ComposableRecurrences in your work, please cite it. Citation metadata lives in [`CITATION.cff`](https://github.com/EpiAware/ComposableRecurrences.jl/blob/main/CITATION.cff), which GitHub renders as a "Cite this repository" button on the repository page.

## Code of conduct

Please note that the ComposableRecurrences project is released with a [Contributor Code of Conduct](https://github.com/EpiAware/.github/blob/main/CODE_OF_CONDUCT.md). By contributing, you agree to abide by its terms.
<!-- standard-sections:end -->
