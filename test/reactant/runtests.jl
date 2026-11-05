# Reactant support: what compiles and differentiates under Reactant today.
# Not part of `Pkg.test`. Run it on Julia 1.12 from the repository root:
#
#   julia +1.12 --project=test/reactant -e 'using Pkg; Pkg.instantiate()'
#   julia +1.12 --project=test/reactant --startup-file=no test/reactant/runtests.jl
#
# Reactant is capped at 0.2.292: 0.2.293 hangs in MLIR's ConcatViewCSE pass
# compiling the flows case.
#
# Two suites run:
# - `registry`: every scenario of the shared AD registry (`test/ADFixtures`),
#   at its own size. Scenarios Reactant cannot run are listed in the
#   registry under the `Reactant` backend, with the cause.
# - `cases`: the hand-written cases in `cases.jl`, for what the registry
#   cannot express, at each number of steps.
#
# Each suite and number of steps runs in a subprocess, each case forward
# then reverse. A subprocess that hangs or crashes on a case is replaced by a
# new one that carries on from the next case, so one hang does not stall the
# rest. Results go to
# RESULTS.md beside this file. `@test` covers the entries expected to work
# and `@test_broken` the rest, so a newly working entry shows as an
# unexpected pass. GPU entries are skipped when Reactant finds no GPU.
#
# Environment variables:
#   REACTANT_TIMEOUT    seconds a case may run, loading included (default 600)
#   REACTANT_SUITES     comma-separated suites (default "registry,cases")
#   REACTANT_CASES      comma-separated hand-written case names (default all)
#   REACTANT_SCENARIOS  registry scenario names, separated by `;` (default all)
#   REACTANT_BACKENDS   comma-separated backends (default "cpu,gpu")
#   REACTANT_STEPS      comma-separated numbers of steps T for the
#                       hand-written cases (default "20,400")
#   REACTANT_REUSE      "1" rebuilds RESULTS.md and the tests from results.tsv
#   REACTANT_RESULTS    a name for a run with its own results, such as "gpu":
#                       it reads and writes results-<name>.tsv and
#                       RESULTS-<name>.md, so a GPU run does not change the
#                       CPU results the weekly job compares against
using Test, Dates, Printf
import Pkg
include(joinpath(@__DIR__, "registry.jl"))

include(joinpath(@__DIR__, "cases.jl"))
using .ReactantCases
include(joinpath(@__DIR__, "expected.jl"))

envlist(key, default, sep = ',') = filter(!isempty, split(get(ENV, key, default), sep))
const TIMEOUT = parse(Float64, get(ENV, "REACTANT_TIMEOUT", "600"))
const SUITES = envlist("REACTANT_SUITES", "registry,cases")
const BACKENDS = envlist("REACTANT_BACKENDS", "cpu,gpu")
const STEPS = parse.(Int, envlist("REACTANT_STEPS", "20,400"))
const MODES = ("forward", "reverse")
const FIELDS = (
    :status, :relerr, :compile_s, :run_us, :plain_us, :error, :frame,
    :message,
)

# The cases of each suite, as `(name, description)`, and the numbers of
# steps each runs at. The registry's scenarios have their own size.
function selected(key, all)
    names = envlist(key, "", key == "REACTANT_SCENARIOS" ? ';' : ',')
    isempty(names) && return all
    unknown = setdiff(names, all)
    isempty(unknown) || error("unknown $key: $(join(unknown, ", "))")
    return filter(in(names), all)
end
const SUITE_CASES = Dict(
    "cases" => selected("REACTANT_CASES", [c.name for c in CASES]),
    "registry" => selected("REACTANT_SCENARIOS", SCENARIO_NAMES),
)
const DESCRIPTIONS = Dict(c.name => c.description for c in CASES)
description(suite, name) = suite == "cases" ? DESCRIPTIONS[name] : name
suite_steps(suite) = suite == "cases" ? STEPS : [ADFixtures.T]

padfields(v, n, x) = vcat(v, fill(x, max(0, n - length(v))))
blank_result() = NamedTuple{FIELDS}(ntuple(_ -> "", length(FIELDS)))

# The last lines of a log, for a subprocess that died without a result.
function log_tail(log)
    isfile(log) || return ""
    lines = filter(!isempty, readlines(log))
    return replace(join(last(lines, 3), " "), r"[\t|]+" => " ")
end

# A cell the registry skips on Reactant: too unstable to run at all.
const SKIPPED_CELL = merge(
    blank_result(), (; status = "skipped", message = "skipped in the AD registry")
)

# The rows written so far to a batch's result file, by case name.
function read_rows(out)
    done = Dict{String, Dict{String, Any}}()
    isfile(out) || return done
    for l in readlines(out)
        v = split(l, '\t')
        fields = padfields(v[3:end], length(FIELDS), "")
        get!(done, v[1], Dict{String, Any}())[v[2]] = NamedTuple{FIELDS}(Tuple(fields))
    end
    return done
end

# Run `names` of `suite` in one subprocess, which loads Reactant (and the
# registry) once. A subprocess that writes no line for `TIMEOUT` seconds is
# killed; the case it was on is a timeout, one it crashed on a crash, and a
# new subprocess carries on from the next case.
function run_batch(suite, names, backend, steps, dir)
    stem = joinpath(dir, "$suite-$backend-$steps")
    out = "$stem.tsv"
    results = NamedTuple[]
    todo = collect(names)
    attempt = 0
    while !isempty(todo)
        attempt += 1
        list, log = "$stem-$attempt.names", "$stem-$attempt.log"
        write(list, join(todo, '\n'))
        cmd = `$(Base.julia_cmd()) --project=$(@__DIR__) --startup-file=no
            $(joinpath(@__DIR__, "probe.jl")) $suite $list $backend $out`
        cmd = addenv(cmd, "REACTANT_T" => string(steps))
        p = run(pipeline(cmd; stdout = log, stderr = log); wait = false)
        nlines() = isfile(out) ? countlines(out) : 0
        seen, last = nlines(), time()
        timedout = false
        while !process_exited(p)
            sleep(1.0)
            n = nlines()
            n == seen || ((seen, last) = (n, time()))
            if time() - last > TIMEOUT
                kill(p, Base.SIGKILL)
                wait(p)
                timedout = true
            end
        end
        done = read_rows(out)
        i = findfirst(n -> length(get(done, n, ())) < length(MODES), todo)
        if i !== nothing
            stuck = todo[i]
            why = if timedout
                (;
                    status = "timeout", error = "Timeout",
                    message = "no result after $(Int(TIMEOUT)) s",
                )
            else
                (;
                    status = "error", error = "Crash",
                    message = first("exit code $(p.exitcode): " * log_tail(log), 300),
                )
            end
            for mode in MODES
                haskey(get!(done, stuck, Dict{String, Any}()), mode) ||
                    (done[stuck][mode] = merge(blank_result(), why))
            end
            # Keep the stuck case's rows for the next pass.
            open(out, "a") do io
                for mode in MODES
                    r = done[stuck][mode]
                    println(io, join((stuck, mode, (getfield(r, k) for k in FIELDS)...), '\t'))
                end
            end
        end
        filter!(n -> length(get(done, n, ())) < length(MODES), todo)
    end
    done = read_rows(out)
    for name in names, mode in MODES
        r = done[name][mode]
        @printf(
            "%-9s %-50s %-8s %-4s %4d %-8s %s %s\n",
            suite, first(name, 50), mode, backend, steps, r.status, r.error,
            r.frame
        )
        push!(
            results,
            merge(r, (; name, mode, suite, backend, steps = string(steps), wall = 0.0))
        )
    end
    flush(stdout)
    return results
end

function versions()
    deps = Pkg.dependencies()
    v(name) = string(only(d.version for d in values(deps) if d.name == name))
    return (; Reactant = v("Reactant"), Enzyme = v("Enzyme"))
end

function cell(r)
    r === nothing && return "not run"
    r.status == "works" &&
        return "works ($(r.compile_s) s / $(r.run_us) µs)"
    r.status == "wrong" && return "wrong (relerr $(r.relerr))"
    r.status in ("timeout", "skipped") && return r.status
    return r.frame in ("", "-") ? "error: $(r.error)" :
        "error: $(r.error) in `$(r.frame)`"
end

const SUITE_TITLES = Dict(
    "registry" => "AD registry scenarios",
    "cases" => "Hand-written cases",
)

function write_results(path, results, elapsed)
    function find(s, n, m, b, T)
        i = findfirst(
            r -> (r.suite, r.name, r.mode, r.backend, r.steps) ==
                (s, n, m, b, string(T)),
            results
        )
        return i === nothing ? nothing : results[i]
    end
    vs = versions()
    # A backend that ran no cell, such as a GPU on a machine without one,
    # gets no columns.
    ran(b) = any(r -> r.backend == b && r.status != "skipped", results)
    backends = filter(ran, ["cpu", "gpu"])
    io = IOBuffer()
    println(io, "# Reactant support\n")
    println(io, "Generated by `test/reactant/runtests.jl`; do not edit by hand.")
    println(io, "Run on $(Dates.today()), Julia $(VERSION), Reactant $(vs.Reactant), Enzyme $(vs.Enzyme).")
    println(io, "Total run time $(round(elapsed / 60; digits = 1)) min, timeout $(Int(TIMEOUT)) s a case.\n")
    println(io, "- `forward`: `Reactant.@compile` of the call against plain Julia.")
    println(io, "- `reverse`: `Enzyme.gradient` inside `@compile` of the loss, against ForwardDiff.")
    println(io, "- AD registry scenarios (`test/ADFixtures`) are at the registry's size and are checked as the AD tests check them: entry by entry, at the scenario's tolerance (`1e-8`, or `1e-4` with single-precision parameters). Scenarios Reactant cannot run are listed in the registry with the reason.")
    println(io, "- Hand-written cases (`cases.jl`) cover what the registry cannot: the harness control, a resumed call, a joined traced history, a check at the call, and how compile and run time grow with the number of steps (L = $(ReactantCases.L) lags, S = $(ReactantCases.S) strata). Their loss is a weighted sum of the output, checked to a relative error below `1e-8`.")
    println(io, "- `works` cells give compile time (s) / median run time (µs); `wrong` means the check failed.")
    println(io, "- Each suite runs in one process, so the first row's forward compile time includes Reactant's fixed first-compile cost; the control row of the hand-written cases measures it.")
    for b in setdiff(["cpu", "gpu"], backends)
        println(io, "- No $(uppercase(b)) cell was run.")
    end
    for suite in ("registry", "cases")
        suite in SUITES || continue
        steps = sort!(unique(parse(Int, r.steps) for r in results if r.suite == suite))
        cols = [(m, b, T) for b in backends for m in MODES for T in steps]
        println(io, "\n## $(SUITE_TITLES[suite])\n")
        heads = [
            length(steps) > 1 ? "$(uppercasefirst(m)) $(uppercase(b)), T = $T" :
                "$(uppercasefirst(m)) $(uppercase(b))" for (m, b, T) in cols
        ]
        println(io, "| Case | ", join(heads, " | "), " |")
        println(io, "|---", "|---"^length(cols), "|")
        for name in SUITE_CASES[suite]
            cells = [cell(find(suite, name, m, b, T)) for (m, b, T) in cols]
            println(io, "| ", description(suite, name), " | ", join(cells, " | "), " |")
        end
    end
    println(io, "\n## Details\n")
    println(io, "Plain Julia is the call (forward) or `ForwardDiff.gradient` (reverse), on the CPU.\n")
    println(io, "| Suite | Case | Mode | Backend | T | Status | Rel. error | Compile (s) | Run (µs) | Plain Julia (µs) | Where | Message |")
    println(io, "|---|---|---|---|---|---|---|---|---|---|---|---|")
    for r in results
        row = (
            r.suite, r.name, r.mode, r.backend, r.steps, r.status, r.relerr,
            r.compile_s, r.run_us, r.plain_us, r.frame, first(r.message, 160),
        )
        println(io, "| ", join(row, " | "), " |")
    end
    println(io)
    print(io, read(joinpath(@__DIR__, "extension.md"), String))
    write(path, String(take!(io)))
    return path
end

const KEYS = (FIELDS..., :name, :mode, :suite, :backend, :steps, :wall)

# Raw results, one row per cell, so the tests and RESULTS.md can be
# rebuilt without rerunning (`REACTANT_REUSE=1`).
function write_raw(path, results, elapsed)
    open(path, "w") do io
        println(io, "# elapsed_s\t", elapsed)
        println(io, join(KEYS, '\t'))
        for r in results
            println(io, join((getfield(r, k) for k in KEYS), '\t'))
        end
    end
    return path
end
function read_raw(path)
    lines = readlines(path)
    elapsed = parse(Float64, split(lines[1], '\t')[2])
    rows = map(lines[3:end]) do l
        v = padfields(split(l, '\t'), length(KEYS), "")
        NamedTuple{KEYS}(Tuple(v))
    end
    return rows, elapsed
end

# Whether a cell is expected to work: every hand-written case (see
# `expected.jl`), and every registry scenario the registry does not list as
# broken on Reactant (`registry.jl`).
function expected(r)
    r.suite == "cases" && return get(EXPECTED, (r.name, r.mode, r.backend), false)
    return registry_works(r.name)
end

const RESULTS_NAME = get(ENV, "REACTANT_RESULTS", "")
results_file(stem, ext) = joinpath(
    @__DIR__, isempty(RESULTS_NAME) ? "$stem.$ext" : "$stem-$RESULTS_NAME.$ext"
)
const RAW = results_file("results", "tsv")
if get(ENV, "REACTANT_REUSE", "") == "1"
    results, elapsed = read_raw(RAW)
else
    results = NamedTuple[]
    elapsed = @elapsed mktempdir() do dir
        for suite in SUITES, backend in BACKENDS, steps in suite_steps(suite)
            names = SUITE_CASES[suite]
            skip = suite == "registry" ? REGISTRY_SKIP : Set{String}()
            for name in names, mode in MODES
                name in skip || continue
                push!(
                    results, merge(
                        SKIPPED_CELL, (;
                            name, mode, suite, backend, steps = string(steps),
                            wall = 0.0,
                        )
                    )
                )
            end
            todo = filter(!in(skip), names)
            isempty(todo) ||
                append!(results, run_batch(suite, todo, backend, steps, dir))
        end
    end
    write_raw(RAW, results, elapsed)
end
write_results(results_file("RESULTS", "md"), results, elapsed)
@printf("Total %.1f min\n", elapsed / 60)

@testset "Reactant support" begin
    @testset "extension loads without ambiguities" begin
        cmd = `$(Base.julia_cmd()) --project=$(@__DIR__) --startup-file=no
            $(joinpath(@__DIR__, "extension_check.jl"))`
        @test success(pipeline(cmd; stdout, stderr))
    end
    # A misspelt name in the registry's Reactant lists would match nothing.
    @testset "the registry's Reactant lists name its scenarios" begin
        @test REGISTRY_BROKEN ⊆ Set(SCENARIO_NAMES)
        @test REGISTRY_SKIP ⊆ Set(SCENARIO_NAMES)
    end

    for suite in SUITES, backend in BACKENDS
        @testset "$suite $backend" begin
            for r in results
                (r.suite, r.backend) == (suite, backend) || continue
                @testset "$(r.name) $(r.mode) T = $(r.steps)" begin
                    if r.status == "skipped"
                        @test_skip r.status == "works"
                    elseif expected(r)
                        @test r.status == "works"
                    else
                        # The reason is in the registry or expected.jl, and
                        # the error in RESULTS.md.
                        @test_broken r.status == "works"
                    end
                end
            end
        end
    end
end
