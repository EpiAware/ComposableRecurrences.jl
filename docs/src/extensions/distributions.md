# [Discrete delay distributions](@id extension-distributions)

Loading Distributions lets [`Recurrence`](@ref) and [`Convolution`](@ref) take a discrete distribution as a [kernel of delays](@ref overview-delays), with the number of lags.
Each lag's mass sums the masses of the `step` whole units in it, through [`delay_masses`](@ref ComposableRecurrences.delay_masses).
A continuous distribution needs the [CensoredDistributions extension](@ref extension-censored-distributions).

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
