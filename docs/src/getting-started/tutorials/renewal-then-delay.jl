# # [Renewal then delay](@id tutorial-renewal-delay)
#
# !!! note "Planned"
#     This tutorial is a stub.
#     Its code does not run yet.
#
# This tutorial will show how to
#
# - build a renewal process as a `Recurrence` with a generation interval kernel;
# - drive it with a reproduction number as the gain;
# - pass its output through a reporting delay as a `Convolution`;
# - differentiate the reports with respect to the reproduction number.
#
# becomes @example once Recurrence and Convolution land #src
# ```julia
# using ComposableRecurrences
#
# gi = [0.2, 0.5, 0.3]
# renewal = Recurrence(gi)
# R = fill(1.1, 60)
# infections = renewal(R; history = fill(10.0, 3))
#
# delay = Convolution([0.1, 0.4, 0.3, 0.2])
# reports = delay(infections)
# ```
