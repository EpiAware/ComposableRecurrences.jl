# The AD registry's scenarios and what it lists for Reactant, shared by
# `runtests.jl`, and a check that a results file agrees with those lists.
#
#   julia --project=test/reactant test/reactant/registry.jl results.tsv
#
# The check exits with status 1 when a registry row's status disagrees with
# the lists, or a scenario has no row, so a list edited without a fresh full
# run fails a pull request's smoke job too.
using ADFixtures: ADFixtures

const SCENARIO_NAMES = [
    s.name for s in ADFixtures.scenarios(; category = :rules)
]

# Broken on every backend, or under Reactant, forward and reverse.
const REGISTRY_BROKEN = union(
    Set(ADFixtures.broken_scenario_names()),
    get(ADFixtures.backend_broken_scenarios(), "Reactant", Set{String}())
)
const REGISTRY_SKIP = get(
    ADFixtures.backend_skip_scenarios(), "Reactant", Set{String}()
)

"Whether registry scenario `name` is expected to work under Reactant."
registry_works(name) = !(name in REGISTRY_BROKEN)

# The registry rows of a results file whose status disagrees with the
# lists, and the CPU cells with no row, as messages.
function registry_mismatches(path)
    lines = readlines(path)
    keys = split(lines[2], '\t')
    col(k) = findfirst(==(k), keys)
    status = Dict{Tuple{String, String}, String}()
    for l in lines[3:end]
        v = split(l, '\t')
        (v[col("suite")], v[col("backend")]) == ("registry", "cpu") || continue
        status[(String(v[col("name")]), String(v[col("mode")]))] = String(v[col("status")])
    end
    out = String[]
    for name in SCENARIO_NAMES, mode in ("forward", "reverse")
        s = get(status, (name, mode), nothing)
        if s === nothing
            push!(out, "no row: $name $mode")
        elseif s != "skipped" && (s == "works") != registry_works(name)
            push!(out, "$name $mode is $s, the registry expects $(registry_works(name) ? "works" : "broken")")
        end
    end
    return out
end

if abspath(PROGRAM_FILE) == @__FILE__
    bad = registry_mismatches(ARGS[1])
    foreach(println, bad)
    isempty(bad) && println("The registry rows agree with the registry's Reactant lists.")
    exit(isempty(bad) ? 0 : 1)
end
