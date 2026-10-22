# Discrete delay distributions as delays: their masses are their
# probabilities on whole units, summed over the `step` units of a lag, so
# `Recurrence(kernel; lags)` and `Convolution(kernel; lags)` take them as
# they take any type with a `delay_masses` method. A continuous distribution
# takes its masses from the CensoredDistributions extension, which makes the
# censoring choice.
module ComposableRecurrencesDistributionsExt

using ComposableRecurrences: ComposableRecurrences, _continuous_masses
using Distributions: ContinuousUnivariateDistribution,
    DiscreteUnivariateDistribution, pdf

function ComposableRecurrences.delay_masses(
        d::DiscreteUnivariateDistribution, lags; step = 1
    )
    n = _whole_step(step)
    isone(n) && return map(l -> pdf(d, l), 0:(lags - 1))
    return map(l -> sum(j -> pdf(d, l * n + j), 0:(n - 1)), 0:(lags - 1))
end

# A discrete delay has mass on whole units only, so a lag holds a whole
# number of them.
function _whole_step(step)
    step isa Real && step > 0 && isinteger(step) || throw(
        ArgumentError(
            "a discrete delay has mass on whole units only, so step must " *
                "be a positive whole number; got $(repr(step))"
        )
    )
    return Int(step)
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
