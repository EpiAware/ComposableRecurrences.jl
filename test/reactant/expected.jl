# Which (case, mode, config, backend) entries work under Reactant today.
# Unlisted entries are expected to fail. With the package's Reactant
# extension every case works, forward and reverse, on CPU and GPU; see
# RESULTS.md.
const EXPECTED = let d = Dict{Tuple{String, String, String, String}, Bool}()
    for mode in ("forward", "reverse"), backend in ("cpu", "gpu")
        for c in ReactantCases.CASES
            d[(c.name, mode, "extension", backend)] = true
        end
    end
    d
end
