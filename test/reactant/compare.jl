# Compare a fresh Reactant support run with the committed one.
#
#   julia test/reactant/compare.jl committed.tsv fresh.tsv
#
# Prints every (case, mode, config, backend) cell whose status changed, as a
# Markdown table, and exits with status 1 if any did. Timings are ignored.
# A newly working cell means `expected.jl` and the committed results need
# updating; a newly failing one is a regression.

function statuses(path)
    lines = readlines(path)
    keys = split(lines[2], '\t')
    col(name) = findfirst(==(name), keys)
    idx = col.(("name", "mode", "config", "backend", "status"))
    d = Dict{NTuple{4, String}, String}()
    for l in lines[3:end]
        v = split(l, '\t')
        d[Tuple(String.(v[collect(idx[1:4])]))] = String(v[idx[5]])
    end
    return d
end

function main(committed, fresh)
    old, new = statuses(committed), statuses(fresh)
    changed = sort!(
        [k for k in union(keys(old), keys(new)) if get(old, k, "missing") != get(new, k, "missing")]
    )
    if isempty(changed)
        println("Reactant support is unchanged from the committed results.")
        return 0
    end
    println("Reactant support changed in $(length(changed)) cells:\n")
    println("| Case | Mode | Config | Backend | Committed | Now |")
    println("|---|---|---|---|---|---|")
    for k in changed
        println("| ", join(k, " | "), " | ", get(old, k, "missing"), " | ", get(new, k, "missing"), " |")
    end
    println("\nRegenerate the committed results and update `expected.jl`.")
    return 1
end

exit(main(ARGS[1], ARGS[2]))
