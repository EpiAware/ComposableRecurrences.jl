# # [Spatial strata](@id tutorial-spatial-strata)
#
# !!! note "Planned"
#     This tutorial is a stub.
#     Its code does not run yet.
#
# This tutorial will show how to
#
# - run a renewal process over several strata;
# - mix strata with a gravity coupling matrix `K`;
# - give each stratum its own generation interval with `PerStratum`;
# - deplete susceptibles in each stratum with `Depletion`;
# - add imported infections with `Imports`;
# - move infections between strata with `Redistribute`.
#
# <!-- becomes @example once couplings and modifiers land -->
# ```julia
# using ComposableRecurrences
#
# renewal = Recurrence(PerStratum(gis); coupling = K,
#     modifiers = (Imports(imports), Depletion(N), Redistribute(K, 0.05)))
# infections = renewal(R; history)
# ```
