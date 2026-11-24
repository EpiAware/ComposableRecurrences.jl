# [Continuous delay distributions](@id extension-censored-distributions)

Loading CensoredDistributions lets [`Recurrence`](@ref) and [`Convolution`](@ref) take a continuous delay distribution as a [kernel of delays](@ref overview-delays), with the number of lags.
Its masses on lags `step` units wide are those of `double_interval_censored(d; primary_event = Uniform(0, step), interval = step)`.

```jldoctest
using ComposableRecurrences, CensoredDistributions, Distributions
d = LogNormal(1.5, 0.75)
delay = Convolution(d; lags = 30)
censored = double_interval_censored(d; interval = 1)
delay.kernel ≈ [pdf(censored, l) for l in 0:29]

# output

true
```

For another censoring choice, build the masses with CensoredDistributions and pass the vector.
