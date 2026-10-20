# [Distributions extension](@id extension-distributions)

`ComposableRecurrencesDistributionsExt` loads when Distributions and ComposableRecurrences are both loaded.
It adds [`delay_masses`](@ref ComposableRecurrences.delay_masses) for discrete distributions, so `Recurrence` and `Convolution` take kernels of them with the number of lags, as they take any type with a `delay_masses` method.
[Delay distributions](@ref overview-delays) says how.
A continuous distribution takes its masses from the [CensoredDistributions extension](@ref extension-censored-distributions), and is an error that names it until that loads.
