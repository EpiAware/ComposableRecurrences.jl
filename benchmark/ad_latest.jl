#!/usr/bin/env julia
# Package-owned: merges the per-backend runs of `ad-benchmarks.yaml`.
#
#   julia --project=benchmark benchmark/ad_latest.jl OUT RESULTS...
#
# OUT gets the registry scenarios of the RESULTS files' `"AD gradients"`
# groups, as nested `data` dictionaries down to each (scenario, backend)
# entry, whose minimum time is its one sample: the layout the AD page reads.
# A backend with no numbers at all gets a workflow warning, and the page
# names it; the script fails only when no backend has numbers.

using BenchmarkTools

const JSON = BenchmarkTools.JSON

_leaf(t) = Dict(
    "times" => [minimum(t.times)], "memory" => t.memory, "allocs" => t.allocs
)
_group(data) = Dict("tags" => String[], "data" => data)

@doc raw"""
    merge_results(files, scenario_names)

The `"AD gradients"` entries of the saved results `files` whose scenario is
in `scenario_names`, as scenario => backend => leaf; a missing file adds
none.
"""
function merge_results(files, scenario_names)
    grid = Dict{String, Dict{String, Any}}()
    for file in files
        isfile(file) || continue
        results = first(BenchmarkTools.load(file))
        haskey(results, "AD gradients") || continue
        for (name, group) in results["AD gradients"]
            name in scenario_names || continue
            cell = get!(grid, name, Dict{String, Any}())
            for (backend, trial) in group
                cell[backend] = _leaf(trial)
            end
        end
    end
    return grid
end

@doc raw"""
    write_latest(out, grid)

Write `grid` to `out` in the layout of the published results.
"""
function write_latest(out, grid)
    data = Dict(
        "AD gradients" => _group(
            Dict(name => _group(cell) for (name, cell) in grid)
        )
    )
    mkpath(dirname(abspath(out)))
    open(io -> JSON.print(io, _group(data)), out, "w")
    return out
end

@doc raw"""
    report_gaps(io, grid, scenario_names, backends, reason)

Print each backend's count of scenarios with a number, and each one without
and why (`reason(name, backend)`, or no number in the run). Return the
backends with no numbers at all.
"""
function report_gaps(io, grid, scenario_names, backends, reason)
    empty_backends = String[]
    for backend in backends
        gaps = [
            n for n in scenario_names if !haskey(get(grid, n, Dict()), backend)
        ]
        println(
            io, backend, ": ", length(scenario_names) - length(gaps), " of ",
            length(scenario_names), " registry scenarios"
        )
        for n in gaps
            why = something(
                reason(n, backend), "no number in the run (see that job's log)"
            )
            println(io, "  missing: ", n, " (", why, ")")
        end
        length(gaps) == length(scenario_names) && push!(empty_backends, backend)
    end
    return empty_backends
end

function main(args)
    length(args) >= 2 || error("usage: ad_latest.jl OUT RESULTS...")
    out, files = args[1], args[2:end]
    scenario_names = [s.name for s in ADFixtures.scenarios()]
    backends = [e.name for e in ADFixtures.benchmarked_backends()]
    grid = merge_results(files, Set(scenario_names))
    write_latest(out, grid)
    empty_backends = report_gaps(
        stdout, grid, scenario_names, backends, ADFixtures.exclusion_reason
    )
    length(empty_backends) == length(backends) &&
        error("no numbers for any backend")
    for backend in empty_backends
        println("::warning::no AD gradient numbers for ", backend)
    end
    println("Wrote ", out)
    return nothing
end

if abspath(PROGRAM_FILE) == @__FILE__
    using ADFixtures
    Base.invokelatest(main, ARGS)
end
