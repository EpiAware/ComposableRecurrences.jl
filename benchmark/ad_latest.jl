#!/usr/bin/env julia
# Package-owned: merges the per-backend runs of `ad-benchmarks.yaml` into
# the file the AD comparison page reads.
#
#   julia --project=benchmark benchmark/ad_latest.jl OUT RESULTS...
#
# Each RESULTS file is what `benchmark/run.jl` saves for one backend, with
# `BENCHMARK_BACKENDS` set to that backend and `BENCHMARK_MATRIX=false`.
# OUT gets the registry's entries of their `"AD gradients"` groups in the
# layout the history workflow publishes as `history/results/latest.json`,
# which `EpiAwarePackageTools.load_ad_benchmarks` reads: nested `data`
# dictionaries down to each (scenario, backend) trial, with the trial's
# minimum time as its one sample.
# Entries that are not registry scenarios are left out, so the page covers
# the registry and nothing else.
#
# The script then lists, per backend, each registry scenario without a
# number and why: declared broken or skipped in the registry, or no number
# in the run, whose job log has the warning. It fails when a backend has no
# numbers at all, so a job that died does not publish a page short of a
# backend without saying so.

using ADFixtures
using BenchmarkTools

const JSON = BenchmarkTools.JSON

# The page reports a trial's minimum time and its memory, so a leaf keeps
# the minimum as its one sample: every sample of five backends' grids would
# make the file too large for the branch.
_leaf(t) = Dict(
    "times" => [minimum(t.times)], "memory" => t.memory, "allocs" => t.allocs
)
_group(data) = Dict("tags" => String[], "data" => data)

function merge_results(files, scenarios)
    grid = Dict{String, Dict{String, Any}}()
    for file in files
        results = first(BenchmarkTools.load(file))
        haskey(results, "AD gradients") || continue
        for (name, group) in results["AD gradients"]
            name in scenarios || continue
            cell = get!(grid, name, Dict{String, Any}())
            for (backend, trial) in group
                cell[backend] = _leaf(trial)
            end
        end
    end
    return grid
end

function why_missing(name, backend)
    name in ADFixtures.broken_scenario_names() &&
        return "broken in the registry"
    name in get(ADFixtures.backend_broken_scenarios(), backend, Set{String}()) &&
        return "broken on this backend in the registry"
    name in get(ADFixtures.backend_skip_scenarios(), backend, Set{String}()) &&
        return "skipped on this backend in the registry"
    return "no number in the run (see that job's log)"
end

function main(args)
    length(args) >= 2 ||
        error("usage: ad_latest.jl OUT RESULTS...")
    out, files = args[1], args[2:end]
    names = [s.name for s in ADFixtures.scenarios()]
    backends = [
        e.name for e in ADFixtures.backends()
            if !startswith(e.name, "ReverseDiff")
    ]
    grid = merge_results(files, Set(names))
    data = Dict(
        "AD gradients" => _group(
            Dict(name => _group(cell) for (name, cell) in grid)
        )
    )
    mkpath(dirname(abspath(out)))
    open(io -> JSON.print(io, _group(data)), out, "w")

    empty = String[]
    for backend in backends
        gaps = [n for n in names if !haskey(get(grid, n, Dict()), backend)]
        println(
            backend, ": ", length(names) - length(gaps), " of ",
            length(names), " registry scenarios"
        )
        for n in gaps
            println("  missing: ", n, " (", why_missing(n, backend), ")")
        end
        length(gaps) == length(names) && push!(empty, backend)
    end
    isempty(empty) || error("no numbers for $(join(empty, ", "))")
    println("Wrote ", out)
    return nothing
end

main(ARGS)
