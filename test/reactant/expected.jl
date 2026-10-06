# Which (case, mode, config, backend) entries work under Reactant today.
# Unlisted entries are expected to fail: every `baseline` case other than
# the control fails at trace time in `param_eltype` (MethodError), before
# any loop runs; see RESULTS.md. With the candidate changes in `shims.jl`
# every case works, forward and reverse, on CPU and GPU, the `Depletion`
# removals and `Protected` cases, `Allocate` and `Transform` included.
const EXPECTED = let d = Dict{Tuple{String, String, String, String}, Bool}()
    for mode in ("forward", "reverse"), backend in ("cpu", "gpu")
        d[("control", mode, "baseline", backend)] = true
        for c in ReactantCases.CASES
            d[(c.name, mode, "shims", backend)] = true
        end
    end
    d
end
