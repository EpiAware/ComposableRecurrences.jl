# Discrete delay distributions as delays: their masses are their
# probabilities on whole lags, so `Recurrence(kernel; lags)` and
# `Convolution(kernel; lags)` take them as they take any type with a
# `delay_masses` method.
module ComposableRecurrencesDistributionsExt

using ComposableRecurrences: ComposableRecurrences
using Distributions: ContinuousUnivariateDistribution,
    DiscreteUnivariateDistribution, pdf

function ComposableRecurrences.delay_masses(
        d::DiscreteUnivariateDistribution, lags
    )
    return map(l -> pdf(d, l), 0:(lags - 1))
end
function ComposableRecurrences.delay_masses(
        d::ContinuousUnivariateDistribution, lags
    )
    throw(
        ArgumentError(
            "a continuous delay has no masses on whole lags until it is " *
                "discretised; discretise $(nameof(typeof(d))) first, for " *
                "example by interval censoring, into a type with a " *
                "`delay_masses` method"
        )
    )
end

end # module ComposableRecurrencesDistributionsExt
