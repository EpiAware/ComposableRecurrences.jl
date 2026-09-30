# Which (case, mode, backend) entries work under Reactant: all of them, with
# the package's Reactant extension. A failing entry that is expected goes in
# `BROKEN` with its error class.
const BROKEN = Set{Tuple{String, String, String}}()
const EXPECTED = Dict(
    (c.name, mode, backend) => !((c.name, mode, backend) in BROKEN)
        for c in ReactantCases.CASES, mode in ("forward", "reverse"),
        backend in ("cpu", "gpu")
)
