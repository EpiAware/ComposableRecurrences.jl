# [CensoredDistributions extension](@id extension-censored-distributions)

`ComposableRecurrencesCensoredDistributionsExt` loads when CensoredDistributions, Distributions and ComposableRecurrences are all loaded.
It gives a continuous delay distribution its masses on whole lags, so `Recurrence` and `Convolution` take it as a kernel with the number of lags.
On lags `step` units wide the masses are those of `double_interval_censored(d; primary_event = Uniform(0, step), interval = step)`, read at each lag's interval.
With the default `step = 1` these are CensoredDistributions' defaults: a uniform primary event window of one unit and `interval = 1`.
The censoring arithmetic stays in CensoredDistributions.
[Delay distributions](@ref overview-delays) says how kernels of delays work.

```jldoctest
using ComposableRecurrences, CensoredDistributions, Distributions
d = LogNormal(1.5, 0.75)
delay = Convolution(d; lags = 30)
delay.kernel ≈ [pdf(double_interval_censored(d; interval = 1), l) for l in 0:29]

# output

true
```

For another censoring choice, build the masses with CensoredDistributions and pass them to the operator.
