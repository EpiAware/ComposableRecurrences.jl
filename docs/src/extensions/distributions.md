# [Distributions extension](@id extension-distributions)

`ComposableRecurrencesDistributionsExt` loads when Distributions and ComposableRecurrences are both loaded.
It adds [`delay_masses`](@ref ComposableRecurrences.delay_masses) for discrete distributions, and kernel constructors that take a delay distribution and the number of lags.
[Delay distributions](@ref overview-delays) lists them.
