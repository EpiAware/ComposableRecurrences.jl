#!/usr/bin/env julia
# Package-owned: merges the per-backend runs of `benchmark-full.yaml`.
#
#   julia --project=benchmark benchmark/full_latest.jl OUT RESULTS...
#
# OUT gets the RESULTS files' groups merged into one `BenchmarkGroup`,
# saved as `benchmark/run.jl` saves a run, so `BenchmarkTools.load(OUT)[1]`
# reads it. Each job times one backend, or the primal groups, so their
# entries do not overlap. A job with no results gets a workflow warning; the
# script fails only when no job has any.

using BenchmarkTools

@doc raw"""
    merge_groups!(dst, src)

Copy every entry of the `BenchmarkGroup` `src` into `dst`, descending into
nested groups, and return `dst`. An entry already in `dst` is an error, as
the per-backend runs share no entry.
"""
function merge_groups!(dst::BenchmarkGroup, src::BenchmarkGroup)
    for (key, value) in src
        if value isa BenchmarkGroup
            haskey(dst, key) || (dst[key] = BenchmarkGroup())
            merge_groups!(dst[key], value)
        else
            haskey(dst, key) && error("two runs hold the entry $(repr(key))")
            dst[key] = value
        end
    end
    return dst
end

@doc raw"""
    merge_results(files)

The saved results `files` merged into one `BenchmarkGroup`; a missing file
adds nothing.
"""
function merge_results(files)
    merged = BenchmarkGroup()
    for file in files
        isfile(file) || continue
        merge_groups!(merged, first(BenchmarkTools.load(file)))
    end
    return merged
end

@doc raw"""
    count_entries(merged, jobs)

The number of entries each job in `jobs` contributed to `merged`: for a
backend, the `"AD gradients"` entries under its name; for `"primal"`, every
entry outside `"AD gradients"`.
"""
function count_entries(merged, jobs)
    counts = Dict(job => 0 for job in jobs)
    for (group, entries) in merged
        if group == "AD gradients"
            for (_, cell) in entries, (backend, _) in cell
                haskey(counts, backend) && (counts[backend] += 1)
            end
        elseif haskey(counts, "primal")
            counts["primal"] += length(BenchmarkTools.leaves(entries))
        end
    end
    return counts
end

@doc raw"""
    report(io, counts, jobs)

Print each job's count of entries and return the jobs with none.
"""
function report(io, counts, jobs)
    for job in jobs
        println(io, job, ": ", counts[job], " entries")
    end
    return [job for job in jobs if counts[job] == 0]
end

function main(
        args; jobs = ["primal"; [e.name for e in ADFixtures.benchmarked_backends()]]
    )
    length(args) >= 2 || error("usage: full_latest.jl OUT RESULTS...")
    out, files = args[1], args[2:end]
    merged = merge_results(files)
    empty_jobs = report(stdout, count_entries(merged, jobs), jobs)
    length(empty_jobs) == length(jobs) && error("no results from any job")
    for job in empty_jobs
        println("::warning::no full benchmark results for ", job)
    end
    mkpath(dirname(abspath(out)))
    BenchmarkTools.save(out, merged)
    println("Wrote ", out, " with groups ", join(sort!(collect(keys(merged))), ", "))
    return nothing
end

if abspath(PROGRAM_FILE) == @__FILE__
    using ADFixtures
    Base.invokelatest(main, ARGS)
end
