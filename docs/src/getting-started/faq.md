# [FAQ](@id faq)

## Why is there no renewal or AR constructor?

The operators describe steps, not models.
A renewal process is [`Recurrence(gi)`](@ref Recurrence) with the reproduction number as its gain, and an AR(p) process is `Recurrence(ρ)` with the innovations as `add`.
Modelling packages such as [ComposableTuringIDModels.jl](https://composableturingidmodels.epiaware.org) name these and give them priors.

## `Recurrence` clashes with Lux

Lux also exports a `Recurrence`.
With both loaded by `using`, write [`ComposableRecurrences.Recurrence`](@ref Recurrence) or import the one you need by name.
