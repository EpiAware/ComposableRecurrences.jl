# [FAQ](@id faq)

## Why is there no renewal or AR constructor?

The operators describe steps, not models.
A renewal process is [`Recurrence(gi)`](@ref Recurrence) with the reproduction number as its gain, and an AR(p) process is `Recurrence(ρ)` with the innovations as `add`.
Modelling packages such as [ComposableTuringIDModels.jl](https://composableturingidmodels.epiaware.org) name these and give them priors.

## Why does a recurrence kernel start at lag 1 and a convolution kernel at lag 0?

A recurrence's value cannot depend on itself in the same step, so its first weight is on the previous value.
A convolution can weight today's input, as a reporting delay of zero days does.
Both are written as the quantity is usually written, so a generation interval or a delay goes in unchanged.

## How do I get intermediate quantities?

Operators return only their outputs.
Recompute the rest; [`Convolution`](@ref) shows how for the value before the gain.

## Which AD backends work?

The targets are ForwardDiff, Mooncake and Enzyme.
[Adjoints and backends](@ref adjoint-backends) says what each runs, and the [AD comparison](@ref ad-comparison) page compares their gradient times.

## [Does it run under Reactant?](@id faq-reactant)

Yes.
With [Reactant.jl](https://github.com/EnzymeAD/Reactant.jl) loaded, operator calls on traced arrays compile with `Reactant.@compile`, and so do Enzyme gradients of them:

```julia
using ComposableRecurrences, Reactant
r = Recurrence([0.5, 0.3])
R = Reactant.to_rarray(fill(1.1, 50))
f(R) = r(R; history = [1.0, 1.0])
y = (Reactant.@compile f(R))(R)
```

A traced call runs serially whatever executor is set, and Enzyme differentiates the traced program rather than using the hand-written gradients.
The step loops are unrolled when traced, so compile time grows with the number of steps and strata.
[`test/reactant/RESULTS.md`](https://github.com/EpiAware/ComposableRecurrences.jl/blob/main/test/reactant/RESULTS.md) lists the cases checked.

## Why is my history padded with zeros?

A shorter history means no earlier values; see `history` in [`Recurrence`](@ref).

## `Recurrence` clashes with Lux

Lux also exports a `Recurrence`.
With both loaded by `using`, write [`ComposableRecurrences.Recurrence`](@ref Recurrence) or import the one you need by name.
