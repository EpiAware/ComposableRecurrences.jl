#!/usr/bin/env julia
# Reactant targets of the benchmark matrix: every case of
# `test/ADFixtures/src/matrix_cases.jl` at every size of a tier, compiled
# with Reactant on the CPU or GPU, forward (`primal`) and reverse
# (`gradient`, Enzyme inside the compiled function). Reactant needs Julia
# 1.12 and its own environment, so this runs apart from `matrix.jl` and
# writes the same result files for `matrix_report.jl`.
#
#   julia +1.12 --project=test/reactant benchmark/reactant_matrix.jl [options]
#
# Options:
#   --tier=NAME           size tier (default realistic)
#   --targets=a,b         of "Reactant CPU primal", "Reactant CPU gradient",
#                         "Reactant GPU primal", "Reactant GPU gradient",
#                         "Reactant CPU unrolled primal",
#                         "Reactant CPU unrolled gradient" (default all)
#   --cases=a,b           cases (default: every case in the tier)
#   --out=DIR             result directory (default matrix-results)
#   --label=NAME          label written into the results (default HEAD)
#   --timeout=SECONDS     per cell (default 900)
#   --seconds=SECONDS     timing budget per cell (default 2)
#   --lock=FILE           a lock file each cell holds while it runs
#   --csv=FILE            also write a summary with the plain CPU times
#
# Each cell runs in its own process, so a compile that hangs costs one
# cell. `prep_s` is the compile and first call; the times are of the
# compiled function. Rules are not used under Reactant, so each case runs
# once, as users call it, in the `traced` arm.

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
    "Reactant CPU unrolled primal", "Reactant CPU unrolled gradient",
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
        "seconds" => "2", "lock" => "", "cell" => "", "csv" => "",
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
# A cell also times the plain CPU call: the primal, or Enzyme's gradient.
const CELL_COLUMNS = [COLUMNS; "plain_median_ns"]
const CSV_COLUMNS = [
    "case", "size", "target", "status", "prep_s", "median_us",
    "plain_median_us", "relerr", "revision",
]
_row(row, cols = COLUMNS) = [string(get(row, k, "")) for k in cols]

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
function plain_gradient(f, θ)
    mode = Enzyme.set_runtime_activity(Enzyme.Reverse)
    return Enzyme.gradient(mode, Enzyme.Const(f), θ)[1]
end

# The unrolled targets remove the extension's traced step loop, so the
# recurrence's plain loop is unrolled into one step per time point.
function unroll_step_loop()
    CR = MatrixCases.ComposableRecurrences
    for m in methods(CR._run)
        m.module === CR && continue
        Base.delete_method(m)
    end
    return nothing
end

relerr(a, b) = maximum(abs.(a .- b)) / max(1.0, maximum(abs.(b)))

_sync(x) = x
_sync(x::Union{Reactant.RArray, Reactant.RNumber}) = Reactant.synchronize(x)

function time_cell(f, θr, seconds)
    _sync(f(θr))
    ts = Float64[]
    t_end = time() + seconds
    while length(ts) < 1000 && (length(ts) < 5 || time() < t_end)
        t0 = time_ns()
        _sync(f(θr))
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
        "L" => z.L, "target" => target, "arm" => "traced",
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
    occursin("unrolled", target) && unroll_step_loop()
    LOSS[] = f
    θr = Reactant.to_rarray(θ)
    fn = grad ? gradient : loss
    t0 = time()
    compiled = Reactant.@compile fn(θr)
    out = Array(compiled(θr))
    row["prep_s"] = round(time() - t0; digits = 2)
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
    seconds = parse(Float64, opts["seconds"])
    row["min_ns"], row["median_ns"] = time_cell(compiled, θr, seconds)
    plain = grad ? () -> plain_gradient(f, θ) : () -> f(θ)
    row["plain_median_ns"] = try
        last(time_cell(_ -> plain(), nothing, seconds))
    catch
        ""
    end
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

_us(x) = (v = tryparse(Float64, string(x)); v === nothing ? "" : round(v / 1.0e3; digits = 2))

function write_csv_row(file, row)
    csv = merge(
        row, Dict(
            "median_us" => _us(get(row, "median_ns", "")),
            "plain_median_us" => _us(get(row, "plain_median_ns", "")),
            "revision" => git_rev()[1:min(end, 8)],
            "status" => replace(string(get(row, "status", "")), ',' => ';'),
        )
    )
    open(io -> println(io, join(_row(csv, CSV_COLUMNS), ',')), file, "a")
    return nothing
end

function run_all(opts)
    mkpath(opts["out"])
    if !isempty(opts["csv"])
        mkpath(dirname(opts["csv"]))
        open(io -> println(io, join(CSV_COLUMNS, ',')), opts["csv"], "w")
    end
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
            isempty(opts["csv"]) || write_csv_row(opts["csv"], row)
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
        "target" => target, "arm" => "traced",
    )
    if timed_out
        base["status"] = "timeout: no result after $(Int(timeout)) s"
    elseif isfile(out)
        for (k, v) in zip(CELL_COLUMNS, split(readchomp(out), '\t'))
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
                "target" => opts["target"], "arm" => "traced",
                "status" => "error: " *
                    first(replace(sprint(showerror, e), r"\s+" => " "), 150),
            )
        end
        open(opts["rowfile"], "w") do io
            println(io, join(_row(row, CELL_COLUMNS), '\t'))
        end
    end
end
