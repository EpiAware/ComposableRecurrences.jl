# Continuous delay distributions as delays. A continuous delay has masses on
# whole lags once it is double interval censored, so its masses on lags
# `step` units wide are those of `double_interval_censored(d;
# primary_event = Uniform(0, step), interval = step)`: the primary event is
# uniform over one lag and the delay is read on lags of the same width. A
# step of 1 is CensoredDistributions' defaults. The censoring arithmetic
# stays in CensoredDistributions.
module ComposableRecurrencesCensoredDistributionsExt

using ComposableRecurrences: ComposableRecurrences
using CensoredDistributions: double_interval_censored
using Distributions: ContinuousUnivariateDistribution, Uniform, pdf

function ComposableRecurrences._continuous_masses(
        d::ContinuousUnivariateDistribution, lags; step = 1
    )
    c = double_interval_censored(
        d; primary_event = Uniform(0, step), interval = step
    )
    # Lag `l` is read at the middle of its interval, so rounding in
    # `l * step` cannot move the read into the interval before.
    return map(l -> pdf(c, (l + 0.5) * step), 0:(lags - 1))
end

end # module ComposableRecurrencesCensoredDistributionsExt
