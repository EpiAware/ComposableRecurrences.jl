# # [Occupancy](@id tutorial-occupancy)
#
# This tutorial turns daily admissions into bed occupancy two ways, then caps
# occupancy at the number of beds.

using ComposableRecurrences
using ComposableRecurrences: Clamp

admissions = vcat(1.0:10.0, fill(10.0, 10), 10.0:-1.0:1.0)

# ## Occupancy as a convolution
#
# Each admission stays `d` or more days with the survival probability
# `survival[d + 1]`, lag 0 first.

discharge = 0.2
survival = (1 - discharge) .^ (0:19)
occupancy = Convolution(survival)(admissions)

# ## Occupancy as a recurrence
#
# The same occupancy is yesterday's occupancy that stays, plus today's
# admissions.

census = Recurrence([1 - discharge])
occupancy_rec = census(; history = [0.0], add = admissions)
maximum(abs, occupancy_rec .- occupancy)

# ## A bed cap
#
# `Clamp` caps each day's occupancy at the number of beds.

beds = 30.0
capped = Recurrence([1 - discharge]; modifiers = (Clamp(0.0, beds),))
capped(; history = [0.0], add = admissions)
