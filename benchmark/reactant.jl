#!/usr/bin/env julia
# Reactant targets of the benchmark matrix: every case of
# `test/ADFixtures/src/matrix_cases.jl` at every size of a tier, compiled
# with Reactant on the CPU or GPU, forward (`primal`) and reverse
# (`gradient`, Enzyme inside the compiled function). Reactant needs Julia
# 1.12 and its own environment, so this runs apart from `matrix.jl` and
# writes the same result files for `matrix_report.jl`.
#
#   julia +1.12 --project=test/reactant benchmark/reactant.jl [options]
#
# Options:
#   --tier=NAME           size tier (default realistic)
#   --targets=a,b         of "Reactant CPU primal", "Reactant CPU gradient",
#                         "Reactant GPU primal", "Reactant GPU gradient"
#                         (default all four)
#   --cases=a,b           cases (default: every case in the tier)
#   --out=DIR             result directory (default matrix-results)
#   --label=NAME          label written into the results (default HEAD)
#   --timeout=SECONDS     per cell (default 900)
#   --seconds=SECONDS     timing budget per cell (default 2)
#   --lock=FILE           a lock file each cell holds while it runs
#
# Each cell runs in its own process, so a compile that hangs costs one
# cell. `prep_s` is the compile time; the times are of the compiled
# function. There are no rules under Reactant: the `rule` arm is the
# operator as users call it, and the `NoAdjoint` arm is not run.

using Dates: now
using Enzyme: Enzyme
using ForwardDiff: ForwardDiff
import Pkg
using Reactant: Reactant
using Printf: @printf
using Statistics: median

include(joinpath(@__DIR__, "..", "test", "ADFixtures", "src", "matrix_cases.jl"))
using .MatrixCases

const TARGETS = [
    "Reactant CPU primal", "Reactant CPU gradient",
    "Reactant GPU primal", "Reactant GPU gradient",
]
const COLUMNS = [
    "case", "size", "S", "T", "L", "target", "arm", "status", "min_ns",
    "median_ns", "allocs", "memory", "prep_s", "relerr", "check", "nparams",
]
# ForwardDiff checks the gradient up to this many parameters.
const FD_MAX = 4000

function parse_args(args)
    opts = Dict(
        "tier" => "realistic", "targets" => join(TARGETS, ","), "cases" => "",
        "out" => "matrix-results", "label" => "", "timeout" => "900",
        "seconds" => "2", "lock" => "", "cell" => "",
    )
    for a in args
        m = match(r"^--([a-z]+)(?:=(.*))?$", a)
        m === nothing && error("unknown argument $a")
        opts[m.captures[1]] = something(m.captures[2], "true")
    end
    return opts
end

_list(s) = isempty(s) ? String[] : String.(split(s, ','))
_file(opts, target) = joinpath(
    opts["out"], "$(opts["tier"])-$(replace(target, ' ' => '_')).tsv"
)
_row(row) = [string(get(row, k, "")) for k in COLUMNS]

function git_rev()
    return try
        readchomp(`git -C $(@__DIR__) rev-parse HEAD`)
    catch
        "unknown"
    end
end

loadavg() = try
    first(split(read("/proc/loadavg", String)))
catch
    "unknown"
end

function versions()
    names = ("ComposableRecurrences", "Reactant", "Enzyme", "ForwardDiff")
    return [
        n => string(something(d.version, "dev"))
            for d in values(Pkg.dependencies()) for n in names if d.name == n
    ]
end

# ---- one cell -------------------------------------------------------------

# The loss under compilation. Calling it through a constant keeps the
# closure's captured sizes and weights out of the trace.
const LOSS = Ref{Any}()
loss(θ) = LOSS[](θ)
gradient(θ) = Enzyme.gradient(Enzyme.Reverse, loss, θ)[1]

relerr(a, b) = maximum(abs.(a .- b)) / max(1.0, maximum(abs.(b)))

function time_cell(f, θr, seconds)
    Reactant.synchronize(f(θr))
    ts = Float64[]
    t_end = time() + seconds
    while length(ts) < 1000 && (length(ts) < 5 || time() < t_end)
        t0 = time_ns()
        Reactant.synchronize(f(θr))
        push!(ts, time_ns() - t0)
    end
    return minimum(ts), median(ts)
end

function run_cell(opts)
    target = opts["target"]
    name, szs = split(opts["cell"], '/')
    c = MatrixCases.case(name)
    z = only(filter(z -> string(z) == szs, MatrixCases.sizes(c, opts["tier"])))
    row = Dict{String, Any}(
        "case" => c.name, "size" => string(z), "S" => z.S, "T" => z.T,
        "L" => z.L, "target" => target, "arm" => "rule",
    )
    f, θ = MatrixCases.build(c, z, "rule")
    row["nparams"] = length(θ)
    grad = endswith(target, "gradient")
    try
        Reactant.set_default_backend(occursin("GPU", target) ? "gpu" : "cpu")
    catch
        row["status"] = "skipped: no GPU"
        return row
    end
    LOSS[] = f
    θr = Reactant.to_rarray(θ)
    fn = grad ? gradient : loss
    t0 = time()
    compiled = Reactant.@compile fn(θr)
    row["prep_s"] = round(time() - t0; digits = 2)
    out = Array(compiled(θr))
    if grad
        if length(θ) <= FD_MAX
            row["relerr"] = relerr(out, ForwardDiff.gradient(f, θ))
            row["check"] = "ForwardDiff"
        else
            row["check"] = "none"
        end
    else
        row["relerr"] = relerr(out, f(θ))
        row["check"] = "plain"
    end
    row["min_ns"], row["median_ns"] = time_cell(
        compiled, θr, parse(Float64, opts["seconds"])
    )
    row["status"] = "ok"
    return row
end

# ---- orchestrator ---------------------------------------------------------

function write_header(opts, target)
    file = _file(opts, target)
    open(file, "w") do io
        label = isempty(opts["label"]) ? git_rev()[1:min(end, 8)] : opts["label"]
        meta = [
            "label" => label, "rev" => git_rev(), "tier" => opts["tier"],
            "target" => target, "julia" => string(VERSION),
            "threads" => string(Threads.nthreads()), "host" => gethostname(),
            "started" => string(now()), "load_start" => loadavg(),
            "rules" => "false",
        ]
        for (k, v) in vcat(meta, versions())
            println(io, "# ", k, "=", v)
        end
        println(io, join(COLUMNS, '\t'))
    end
    return file
end

function run_all(opts)
    mkpath(opts["out"])
    timeout = parse(Float64, opts["timeout"])
    names = _list(opts["cases"])
    for target in _list(opts["targets"])
        target in TARGETS ||
            error("unknown target $target; choose from ", join(TARGETS, ", "))
        file = write_header(opts, target)
        for c in MatrixCases.CASES, z in MatrixCases.sizes(c, opts["tier"])
            isempty(names) || c.name in names || continue
            row = run_one(opts, target, "$(c.name)/$z", timeout)
            open(io -> println(io, join(_row(row), '\t')), file, "a")
            @printf(
                "%-20s %-14s %-22s %-8s %s\n", c.name, string(z), target,
                get(row, "prep_s", ""), _cell(row)
            )
            flush(stdout)
        end
        open(file, "a") do io
            println(io, "# load_end=", loadavg())
            println(io, "# finished=", now())
        end
        println("wrote ", file)
    end
    return nothing
end

function _cell(row)
    haskey(row, "median_ns") || return string(get(row, "status", ""))
    return string(round(parse(Float64, row["median_ns"]) / 1.0e3; digits = 1), " µs")
end

# Run one cell in its own process; under a lock, the timeout starts once
# the process holds it.
function run_one(opts, target, cell, timeout)
    dir = mktempdir()
    out, log, started = joinpath.(dir, ("row.tsv", "cell.log", "started"))
    args = [
        "--tier=$(opts["tier"])", "--target=$target", "--cell=$cell",
        "--seconds=$(opts["seconds"])", "--rowfile=$out",
    ]
    cmd = `$(Base.julia_cmd()) --project=$(Base.active_project())
        --startup-file=no --threads=1 $(@__FILE__) $args`
    lock = opts["lock"]
    if !isempty(lock)
        cmd = `flock $lock sh -c 'touch "$0" && exec "$@"' $started $cmd`
    end
    p = run(pipeline(cmd; stdout = log, stderr = log); wait = false)
    isempty(lock) || while !isfile(started) && process_running(p)
        sleep(1)
    end
    timed_out = timedwait(() -> process_exited(p), timeout; pollint = 1.0) ===
        :timed_out
    if timed_out
        kill(p, Base.SIGKILL)
        wait(p)
    end
    name, sz = split(cell, '/')
    z = only(
        filter(z -> string(z) == sz, MatrixCases.sizes(MatrixCases.case(name), opts["tier"]))
    )
    base = Dict{String, Any}(
        "case" => name, "size" => sz, "S" => z.S, "T" => z.T, "L" => z.L,
        "target" => target, "arm" => "rule",
    )
    if timed_out
        base["status"] = "timeout: no result after $(Int(timeout)) s"
    elseif isfile(out)
        for (k, v) in zip(COLUMNS, split(readchomp(out), '\t'))
            isempty(v) || (base[k] = v)
        end
    else
        tail = filter(!isempty, readlines(log))
        base["status"] = "error: exit $(p.exitcode) " *
            first(replace(join(last(tail, 2), " "), r"\s+" => " "), 150)
    end
    return base
end

if abspath(PROGRAM_FILE) == @__FILE__
    opts = parse_args(ARGS)
    if isempty(opts["cell"])
        run_all(opts)
    else
        row = try
            run_cell(opts)
        catch e
            Dict{String, Any}(
                "case" => first(split(opts["cell"], '/')),
                "target" => opts["target"], "arm" => "rule",
                "status" => "error: " *
                    first(replace(sprint(showerror, e), r"\s+" => " "), 150),
            )
        end
        open(io -> println(io, join(_row(row), '\t')), opts["rowfile"], "w")
    end
end
