# [Distributions extension](@id extension-distributions)

Loading Distributions with ComposableRecurrences loads `ComposableRecurrencesDistributionsExt`.
It adds [`delay_masses`](@ref ComposableRecurrences.delay_masses) for discrete distributions, summing the masses of the `step` whole units in each lag.
So [`Recurrence`](@ref) and [`Convolution`](@ref) take [kernels of them](@ref explanation-delays) with the number of lags, as they take any type with a `delay_masses` method.
A continuous distribution takes its masses from the [CensoredDistributions extension](@ref extension-censored-distributions), and is an error that names it until that loads.

A Poisson delay with mean 1.5 days, cut at 4 lags, applied to doubling counts:

```jldoctest
using ComposableRecurrences, Distributions
delay = Convolution(Poisson(1.5); lags = 4)
round.(delay([10.0, 20.0, 40.0, 80.0]); digits = 3)

# output

4-element Vector{Float64}:
  2.231
  7.81
 18.129
 37.514
```
