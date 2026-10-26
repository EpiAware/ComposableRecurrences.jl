# Compare a fresh Reactant support run with the committed one.
#
#   julia test/reactant/compare.jl committed.tsv fresh.tsv [--subset]
#
# Prints every (case, mode, config, backend, steps) cell whose status
# changed, as a Markdown table, and exits with status 1 if any did. Timings
# are ignored. With `--subset` the fresh run covers only some cells, as the
# pull request smoke run does, and only those are compared.
# A newly working cell means `expected.jl` and the committed results need
# updating; a newly failing one is a regression.

function statuses(path)
    lines = readlines(path)
    keys = split(lines[2], '\t')
    col(name) = findfirst(==(name), keys)
    idx = col.(("name", "mode", "config", "backend", "status"))
    # Results from before the steps column ran at 20 steps.
    isteps = col("steps")
    d = Dict{NTuple{5, String}, String}()
    for l in lines[3:end]
        v = split(l, '\t')
        steps = isteps === nothing ? "20" : String(v[isteps])
        d[(String.(v[collect(idx[1:4])])..., steps)] = String(v[idx[5]])
    end
    return d
end

function main(committed, fresh, subset = false)
    old, new = statuses(committed), statuses(fresh)
    if subset && isempty(new)
        println("The run recorded no cells.")
        return 1
    end
    cells = subset ? collect(keys(new)) : union(keys(old), keys(new))
    changed = sort!(
        [k for k in cells if get(old, k, "missing") != get(new, k, "missing")]
    )
    if isempty(changed)
        println("Reactant support is unchanged from the committed results.")
        return 0
    end
    println("Reactant support changed in $(length(changed)) cells:\n")
    println("| Case | Mode | Config | Backend | T | Committed | Now |")
    println("|---|---|---|---|---|---|---|")
    for k in changed
        println("| ", join(k, " | "), " | ", get(old, k, "missing"), " | ", get(new, k, "missing"), " |")
    end
    println("\nRegenerate the committed results and update `expected.jl`.")
    return 1
end

if abspath(PROGRAM_FILE) == @__FILE__
    exit(main(ARGS[1], ARGS[2], "--subset" in ARGS[3:end]))
end
