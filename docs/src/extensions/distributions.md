# [Distributions extension](@id extension-distributions)

`ComposableRecurrencesDistributionsExt` loads when Distributions and ComposableRecurrences are both loaded.
It adds [`delay_masses`](@ref ComposableRecurrences.delay_masses) for discrete distributions, and lets `Recurrence` and `Convolution` take kernels of delay distributions with the number of lags.
[Delay distributions](@ref overview-delays) says how.
