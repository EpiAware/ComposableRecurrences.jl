# PACKAGE-OWNED — scaffold writes this once and never overwrites it.
#
# Main test entry. Discovers `@testitem`s (the managed QA testset under
# `test/package/` plus the package's own unit tests) with TestItemRunner.
# `:ad`-tagged items live under `test/ad/` with their own environment and
# run in dedicated per-backend CI, so are excluded here (test/ad/runtests.jl).
#
# Which files are searched is scoped by the managed `JuliaTestItems.toml` at
# the package root, so a nested worktree checked out under the repo cannot
# inject test items or shadow a same-named `@testsnippet` (#191).
#
# Filters:
#   skip_quality  — skip the QA testset (fast local iteration)
#   quality_only  — run only the QA testset
#   readme_only   — run only `:readme`-tagged items (README/tutorial tests)
#   usecase_only  — run only `:usecase`-tagged items (real models in
#                   test/usecases/ checked against their original code)
#
# `:usecase_pending` items need API that has not landed yet, so only
# `usecase_only` runs them; drop the tag once they pass.
#
# Quality items check the source, not the platform, so in CI they run in one
# cell of the Test matrix: Linux on a released Julia. Elsewhere in CI the
# default run skips them; `quality_only` and local runs keep them.
#
# The selected items are split across worker processes, balanced by the
# times recorded in `item_times.tsv`, and each worker's output is printed
# once it finishes. `CR_TEST_WORKERS` sets the number of workers; the
# default is one per core, at most four, and one per 3 GiB of memory.
# `record_times` writes the measured item times back to `item_times.tsv`.
# The run warns when its wall time exceeds the budget the standards tests
# hold the recorded times to (`TEST_BUDGET` in `item_times.jl`).

using TestItemRunner

const TEST_DIR = @__DIR__
const PKG_DIR = dirname(TEST_DIR)

include(joinpath(TEST_DIR, "item_times.jl"))

function in_quality_cell()
    get(ENV, "CI", "false") == "true" || return true
    return Sys.islinux() && isempty(VERSION.prerelease)
end

function mode_filter(args)
    "quality_only" in args && return ti -> :quality in ti.tags
    "readme_only" in args && return ti -> :readme in ti.tags
    "usecase_only" in args && return ti -> :usecase in ti.tags
    quality = !("skip_quality" in args) && in_quality_cell()
    return ti -> (quality || !(:quality in ti.tags)) && !(:ad in ti.tags) &&
        !(:usecase_pending in ti.tags)
end

# The item testsets of a finished run, found by name below its root.
function item_times!(out, ts, names)
    for r in ts.results
        r isa TestItemRunner.Test.DefaultTestSet || continue
        if r.description in names && r.time_end !== nothing
            out[r.description] = r.time_end - r.time_start
        else
            item_times!(out, r, names)
        end
    end
    return out
end

# A worker runs the items assigned to it and writes their times to `out`,
# whether or not they pass.
function run_worker(args, i, n, out)
    keep = mode_filter(args)
    names = String[]
    TestItemRunner.run_tests(PKG_DIR; filter = ti -> (keep(ti) && push!(names, ti.name); false))
    shard, _ = assign(names, read_times(), n)
    mine = Set(k for k in names if shard[k] == i)
    root = Ref{Any}(nothing)
    function testset(name; kw...)
        ts = TestItemRunner.Test.DefaultTestSet(name; kw...)
        root[] === nothing && (root[] = ts)
        return ts
    end
    try
        TestItemRunner.run_tests(PKG_DIR; filter = ti -> ti.name in mine, testset)
    finally
        times = root[] === nothing ? Dict{String, Float64}() :
            item_times!(Dict{String, Float64}(), root[], mine)
        open(out, "w") do io
            for (k, t) in times
                println(io, round(t; digits = 2), '\t', k)
            end
        end
    end
    return nothing
end

function nworkers()
    haskey(ENV, "CR_TEST_WORKERS") && return parse(Int, ENV["CR_TEST_WORKERS"])
    by_memory = Int(Sys.total_memory() ÷ (3 * 2^30))
    return clamp(min(Sys.CPU_THREADS, by_memory), 1, 4)
end

function run_parallel(args, n)
    budget = TEST_BUDGET.minutes
    dir = mktempdir()
    cmd = Base.julia_cmd()
    project = Base.active_project()
    threads = Threads.threadpoolsize()
    start = time()
    tasks = map(1:n) do i
        log, out = joinpath(dir, "worker$i.log"), joinpath(dir, "worker$i.tsv")
        worker = `$cmd --project=$project --threads=$threads $(@__FILE__) $args worker=$i/$n out=$out`
        Threads.@spawn begin
            p = run(pipeline(ignorestatus(worker); stdout = log, stderr = log))
            t = round((time() - start) / 60; digits = 1)
            println("──── worker $i of $n: $(success(p) ? "passed" : "FAILED") after $t min ────")
            print(read(log, String))
            (success(p), out)
        end
    end
    results = fetch.(tasks)
    wall = (time() - start) / 60
    times = Dict{String, Float64}()
    for (_, out) in results
        isfile(out) && merge!(times, read_times(out))
    end
    if !isempty(times)
        println("──── slowest items ────")
        for (k, t) in first(sort!(collect(times); by = last, rev = true), 20)
            println(lpad(round(t; digits = 1), 8), " s  ", k)
        end
        println(
            "items: $(length(times)), summed item time ",
            round(sum(values(times)) / 60; digits = 1), " min, wall time ",
            round(wall; digits = 1), " min on $n workers"
        )
    end
    passed = all(first, results)
    if "record_times" in args
        # A failed worker may not have reached all its items; keep the
        # recorded times of any it missed.
        passed || (times = merge(read_times(), times))
        open(TIMES_FILE, "w") do io
            println(io, "# seconds\titem, written by `test/runtests.jl record_times`")
            for (k, t) in sort!(collect(times); by = first)
                println(io, round(t; digits = 1), '\t', k)
            end
        end
    end
    wall > budget && @warn "The test run took $(round(wall; digits = 1)) min, " *
        "over the $budget min budget."
    passed || error("a test worker failed; see its output above")
    return nothing
end

let args = filter(a -> !startswith(a, "worker=") && !startswith(a, "out="), ARGS)
    worker = findfirst(startswith("worker="), ARGS)
    if worker !== nothing
        i, n = parse.(Int, split(ARGS[worker][8:end], '/'))
        out = ARGS[findfirst(startswith("out="), ARGS)][5:end]
        run_worker(args, i, n, out)
    elseif nworkers() > 1
        run_parallel(args, nworkers())
    else
        TestItemRunner.run_tests(PKG_DIR; filter = mode_filter(args))
    end
end
