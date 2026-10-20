# Discrete delay distributions as delays: their masses are their
# probabilities on whole lags, so `Recurrence(kernel; lags)` and
# `Convolution(kernel; lags)` take them as they take any type with a
# `delay_masses` method. A continuous distribution takes its masses from the
# CensoredDistributions extension, which makes the censoring choice.
module ComposableRecurrencesDistributionsExt

using ComposableRecurrences: ComposableRecurrences, _continuous_masses
using Distributions: ContinuousUnivariateDistribution,
    DiscreteUnivariateDistribution, pdf

function ComposableRecurrences.delay_masses(
        d::DiscreteUnivariateDistribution, lags
    )
    return map(l -> pdf(d, l), 0:(lags - 1))
end
function ComposableRecurrences.delay_masses(
        d::ContinuousUnivariateDistribution, lags; kwargs...
    )
    return _continuous_masses(d, lags; kwargs...)
end

# Reached only while the CensoredDistributions extension is not loaded.
@noinline function ComposableRecurrences._no_censoring(
        d::ContinuousUnivariateDistribution
    )
    throw(
        ArgumentError(
            "a continuous delay has no masses on whole lags until a " *
                "censoring choice discretises it; load CensoredDistributions " *
                "to double interval censor $(nameof(typeof(d))) with its " *
                "defaults, or pass a delay that is already discretised"
        )
    )
end

end # module ComposableRecurrencesDistributionsExt
