# [CensoredDistributions extension](@id extension-censored-distributions)

`ComposableRecurrencesCensoredDistributionsExt` loads when CensoredDistributions, Distributions and ComposableRecurrences are all loaded.
It gives a continuous delay distribution its masses on whole lags, so `Recurrence` and `Convolution` take it as a kernel with the number of lags.
The masses are those of `double_interval_censored(d; interval)`, with CensoredDistributions' defaults: a uniform primary event window and `interval = 1`.
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

To see the censoring choice on the page, pass `interval` to [`delay_masses`](@ref ComposableRecurrences.delay_masses) and build the operator from the masses.
