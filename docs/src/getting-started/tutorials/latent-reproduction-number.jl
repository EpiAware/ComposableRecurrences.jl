# # [Latent AR and TVAR processes driving R_t](@id tutorial-latent-rt)
#
# !!! note "Planned"
#     This tutorial is a stub.
#     Its code does not run yet.
#
# This tutorial will show how to
#
# - write an AR(p) process as a `Recurrence` with an additive input;
# - let the AR coefficients vary over time with `TimeVarying`;
# - map the latent process to a reproduction number;
# - use that reproduction number as the gain of a renewal process.
#
# becomes @example once Recurrence and TimeVarying land #src
# ```julia
# using ComposableRecurrences
#
# ar = Recurrence([0.6, 0.2])
# log_R = ar(1.0; history = zeros(2), add = 0.1 .* randn(60))
# renewal = Recurrence([0.2, 0.5, 0.3])
# infections = renewal(exp.(log_R); history = fill(10.0, 3))
# ```
