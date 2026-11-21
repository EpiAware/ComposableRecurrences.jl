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

## Getting help

For usage questions, ask on the [Julia Discourse](https://discourse.julialang.org) or the [epinowcast community forum](https://community.epinowcast.org), our home for epidemiological modelling questions.
Please use [GitHub issues](https://github.com/EpiAware/ComposableRecurrences.jl/issues) for bug reports and feature requests only.
