# # [Time-varying kernels](@id tutorial-time-varying-kernels)
#
# !!! note "Planned"
#     This tutorial is a stub.
#     Its code does not run yet.
#
# This tutorial will show how to
#
# - build a generation interval that changes over time with `TimeVarying`;
# - use a reporting delay that changes over time in a `Convolution`;
# - check the shapes each time-varying kernel needs.
#
# <!-- becomes @example once TimeVarying lands -->
# ```julia
# using ComposableRecurrences
#
# gis = rand(3, 60)
# renewal = Recurrence(TimeVarying(gis ./ sum(gis; dims = 1)))
# infections = renewal(fill(1.1, 60); history = fill(10.0, 3))
# ```
