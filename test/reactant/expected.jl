# Which (case, mode, backend) entries of the hand-written cases work under
# Reactant today, at every number of steps the harness runs. Unlisted
# entries are expected to fail. Every case works, forward and reverse, on
# CPU; see RESULTS.md. CPU only; add GPU cells here once they have been run.
# The registry scenarios' expectations are in the registry itself (see
# `expected` in runtests.jl).
const EXPECTED = let d = Dict{Tuple{String, String, String}, Bool}()
    for mode in ("forward", "reverse"), c in ReactantCases.CASES
        d[(c.name, mode, "cpu")] = true
    end
    d
end
