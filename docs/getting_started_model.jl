# The three-town model of Getting started, for other docs pages.
# `docs/src/getting-started/index.md` is the source: this file evaluates
# its assignments to the names below, so the definitions live in one place.
# A page includes this file in its `@setup` block.
let page = joinpath(@__DIR__, "src", "getting-started", "index.md"),
        names = ("gi", "T", "towns", "pop", "dist", "gravity", "K", "seed", "R")
    for line in eachline(page)
        m = match(r"^(\w+) = ", line)
        m !== nothing && m[1] in names && eval(Meta.parse(line))
    end
end
