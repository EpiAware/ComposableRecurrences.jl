# # [Time-varying kernels](@id tutorial-time-varying-kernels)
#
# This tutorial uses a generation interval and a reporting delay that change
# over time.

using ComposableRecurrences
using ComposableRecurrences: Primary

T = 30

# ## A time-varying generation interval
#
# A `TimeVarying` recurrence kernel is `L × T`, one generation interval per
# day, lag 1 first.
# Here the interval shortens over the outbreak.

short = [0.5, 0.3, 0.2]
long = [0.2, 0.3, 0.5]
Gt = hcat([(1 - t / T) .* long .+ (t / T) .* short for t in 1:T]...)
renewal = Recurrence(TimeVarying(Gt))
infections = renewal(1.2; history = fill(10.0, 3), stop = T)

# ## A time-varying reporting delay
#
# A `TimeVarying` convolution kernel is `D × T`, lag 0 first.
# By default column `t` weights the inputs reaching output day `t`.

fast = [0.6, 0.3, 0.1, 0.0]
slow = [0.1, 0.3, 0.4, 0.2]
Dt = hcat([(1 - t / T) .* slow .+ (t / T) .* fast for t in 1:T]...)
reports = Convolution(TimeVarying(Dt))(infections)

# With `Primary()` column `s` is the delay of the infections on day `s`,
# which spread forward through it.

reports_primary = Convolution(TimeVarying(Dt, Primary()))(infections)
hcat(reports, reports_primary)[(end - 4):end, :]
