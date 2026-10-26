# Which (case, mode, config, backend) entries work under Reactant today, at
# every number of steps the harness runs. Unlisted entries are expected to
# fail. With the package's Reactant extension every case works, forward and
# reverse, on CPU; see RESULTS.md. No GPU cell has been run, so none is
# listed: a GPU run shows each cell that works as an unexpected pass, to be
# recorded here.
const EXPECTED = let d = Dict{Tuple{String, String, String, String}, Bool}()
    for mode in ("forward", "reverse"), c in ReactantCases.CASES
        d[(c.name, mode, "extension", "cpu")] = true
    end
    d
end
