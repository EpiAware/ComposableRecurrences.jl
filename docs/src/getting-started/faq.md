# [FAQ](@id faq)

## Why is there no renewal or AR constructor?

The operators describe steps, not models.
A renewal process is [`Recurrence(gi)`](@ref Recurrence) with the reproduction number as its gain, and an AR(p) process is `Recurrence(ρ)` with the innovations as `add`.
Modelling packages such as [ComposableTuringIDModels.jl](https://composableturingidmodels.epiaware.org) name these and give them priors.

## [Why does a recurrence kernel start at lag 1 and a convolution kernel at lag 0?](@id faq-lag-origin)

See [A recurrence is a convolution of its own outputs](@ref explanation-lag-origin).

## How do I get intermediate quantities?

Recompute them from the outputs; see [A recurrence is a convolution of its own outputs](@ref explanation-lag-origin).

## [Which AD backends work?](@id faq-backends)

ForwardDiff, Mooncake and Enzyme; see [Backends](@ref adjoint-backends).

## [Does it run under Reactant?](@id faq-reactant)

Yes; see the [Reactant extension](@ref extension-reactant).

## Why is my history padded with zeros?

A shorter history means no earlier values; see `history` in [`Recurrence`](@ref).

## `Recurrence` clashes with Lux

Lux also exports a `Recurrence`.
With both loaded by `using`, write [`ComposableRecurrences.Recurrence`](@ref Recurrence) or import the one you need by name.
