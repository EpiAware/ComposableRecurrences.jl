# # [Renewal then delay](@id tutorial-renewal-delay)
#
# This tutorial builds a renewal process, passes its infections through a
# reporting delay, and differentiates the reports with respect to the
# reproduction number.

using ComposableRecurrences

# ## A renewal process
#
# The generation interval is the recurrence kernel, lag 1 first.
# The reproduction number `R` is the gain, one value per day.
# The history holds the infections on the days before the first step.

gi = [0.2, 0.5, 0.3]
renewal = Recurrence(gi)
R = vcat(fill(1.3, 20), fill(0.8, 20))
infections = renewal(R; history = fill(10.0, 3))

# ## A reporting delay
#
# The delay is a convolution kernel, lag 0 first.

delay = Convolution([0.1, 0.4, 0.3, 0.2])
reports = delay(infections)

# ## Differentiating the reports
#
# Both operators run on dual numbers, so ForwardDiff gives the gradient of the
# total reports with respect to each day's reproduction number.

using ForwardDiff

total_reports(R) = sum(delay(renewal(R; history = fill(10.0, 3))))
ForwardDiff.gradient(total_reports, R)[1:5]
