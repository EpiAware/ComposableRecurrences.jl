# # [Occupancy](@id tutorial-occupancy)
#
# !!! note "Planned"
#     This tutorial is a stub.
#     Its code does not run yet.
#
# This tutorial will show how to
#
# - turn admissions into occupancy with a `Convolution` over a length-of-stay survival kernel;
# - write the same occupancy as a `Recurrence` with a daily discharge probability and admissions as `add`;
# - cap that occupancy at a bed count with `Clamp`.
#
# becomes @example once Convolution and Clamp land #src
# ```julia
# using ComposableRecurrences
#
# stay = Convolution(survival)
# occupancy = stay(admissions)
#
# census = Recurrence([1 - discharge]; modifiers = (Clamp(0.0, beds),))
# occupancy_capped = census(1.0; history = [0.0], add = admissions)
# ```
