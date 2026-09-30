# [FAQ](@id faq)

## Why is there no renewal or AR constructor?

The operators describe steps, not models.
A renewal process is `Recurrence(gi)` with the reproduction number as its gain, and an AR(p) process is `Recurrence(ρ)` with the innovations as `add`.
Modelling packages such as [ComposableTuringIDModels.jl](https://composableturingidmodels.epiaware.org) name these and give them priors.

## Why does a recurrence kernel start at lag 1 and a convolution kernel at lag 0?

A recurrence's value cannot depend on itself in the same step, so its first weight is on the previous value.
A convolution can weight today's input, as a reporting delay of zero days does.
Both are written as the quantity is usually written, so a generation interval or a delay goes in unchanged.

## How do I get intermediate quantities?

Operators return only their outputs.
A step's value before the gain multiplies it is a convolution of the outputs, so `Convolution(vcat(0, g))` recomputes it.
See [Operators](@ref operators).

## Which AD backends work?

The AD tests run ForwardDiff, ReverseDiff, Mooncake and Enzyme.
The [AD comparison](@ref ad-comparison) page compares their gradient times.

## Why is my history padded with zeros?

A history shorter than the kernel means there were no earlier values, so the missing lags count as zero.

## `Recurrence` clashes with Lux

Lux also exports a `Recurrence`.
With both loaded by `using`, write `ComposableRecurrences.Recurrence` or import the one you need by name.
