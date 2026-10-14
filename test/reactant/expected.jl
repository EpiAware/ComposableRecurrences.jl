# Which (case, mode, config, backend, steps) entries work under Reactant
# today, for the step counts the harness is run at. Unlisted entries are
# expected to fail. With the package's Reactant extension every case works,
# forward and reverse, on CPU; see RESULTS.md.
# GPU has not been run, so the GPU entries are untested.
#
# One entry is not expected to match: from 100 steps the floor of the custom
# pointwise modifier meets a value exactly at it, `max(v, 1.0)` with
# `v == 1.0`, where ForwardDiff and Enzyme take different sides of the kink,
# both valid. Its reverse gradient differs there by design, not by error.
const EXPECTED = let d = Dict{Tuple{String, String, String, String, Int}, Bool}()
    for mode in ("forward", "reverse"), backend in ("cpu", "gpu"), T in (20, 100, 400)
        for c in ReactantCases.CASES
            d[(c.name, mode, "extension", backend, T)] = true
        end
        if T >= 100
            d[("rec_pointwise_modifier", "reverse", "extension", backend, T)] = false
        end
    end
    d
end
