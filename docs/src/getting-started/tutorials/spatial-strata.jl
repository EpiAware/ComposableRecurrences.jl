# # [Spatial strata](@id tutorial-spatial-strata)
#
# This tutorial runs a renewal process over three strata with a gravity
# coupling, a generation interval per stratum, depletion, imports and
# redistribution between strata.

using ComposableRecurrences
using ComposableRecurrences: Depletion, Add, Redistribute

S, T = 3, 40

# ## Gravity coupling
#
# A gravity matrix weights each pair of strata by population over squared
# distance, then normalises each row.

pop = [1000.0, 500.0, 200.0]
dist = [0.0 1.0 2.0; 1.0 0.0 1.5; 2.0 1.5 0.0]
grav = [a == b ? 1.0 : pop[b] / dist[a, b]^2 for a in 1:S, b in 1:S]
K = grav ./ sum(grav; dims = 2)

# ## Per-stratum generation intervals

G = [0.2 0.5 0.3; 0.3 0.4 0.3; 0.4 0.4 0.2]

# ## Modifiers
#
# `Add` brings in imported infections in the first stratum, `Redistribute`
# moves a small share of each stratum's infections to the others, and
# `Depletion` draws what is left from each stratum's pool.

imports = zeros(S, T)
imports[1, 1:5] .= 2.0
mods = (
    Add(TimeVarying(PerStratum(imports))),
    Redistribute(K, 0.05),
    Depletion(PerStratum(pop)),
)

renewal = Recurrence(PerStratum(G); coupling = K, modifiers = mods)
infections = renewal(1.8; history = zeros(S, 3), stop = T)
infections[:, (end - 4):end]
