# Continuous delay distributions as delays. A continuous delay has masses on
# whole lags once it is double interval censored, so its masses are those of
# `double_interval_censored(d; interval)`, with CensoredDistributions'
# defaults. The censoring arithmetic stays in CensoredDistributions.
module ComposableRecurrencesCensoredDistributionsExt

using ComposableRecurrences: ComposableRecurrences, _isdelay, delay_masses
using CensoredDistributions: double_interval_censored
using Distributions: ContinuousUnivariateDistribution, pdf

function ComposableRecurrences._continuous_masses(
        d::ContinuousUnivariateDistribution, lags; interval = 1
    )
    return _censored_masses(double_interval_censored(d; interval), lags)
end

# The masses of a censored delay: its own `delay_masses` method where
# CensoredDistributions defines one, otherwise its probability on each lag.
function _censored_masses(c, lags)
    _isdelay(typeof(c)) && return delay_masses(c, lags)
    return map(l -> pdf(c, l), 0:(lags - 1))
end

end # module ComposableRecurrencesCensoredDistributionsExt
