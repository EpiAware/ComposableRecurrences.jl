# # [Latent AR and TVAR processes driving R_t](@id tutorial-latent-rt)
#
# This tutorial writes an autoregression as a recurrence, lets its
# coefficients vary over time, and uses it as the log reproduction number of a
# renewal process.

using ComposableRecurrences
using Random

rng = Xoshiro(1)
T = 60
ϵ = 0.05 .* randn(rng, T)

# ## An AR(2) process
#
# The AR coefficients are the kernel, lag 1 first.
# The noise enters through `add`, and the call takes its length from it.

ar = Recurrence([0.6, 0.2])
log_R = ar(; history = zeros(2), add = ϵ)

# ## A time-varying AR process
#
# A `TimeVarying` kernel has one column of coefficients per time.

Φ = vcat(range(0.8, 0.4; length = T)', fill(0.1, 1, T))
tvar = Recurrence(TimeVarying(Φ))
log_R_tv = tvar(; history = zeros(2), add = ϵ)

# ## Driving a renewal process
#
# The exponentiated process is the renewal's gain.

renewal = Recurrence([0.2, 0.5, 0.3])
infections = renewal(exp.(log_R_tv); history = fill(10.0, 3))
infections[(end - 4):end]
