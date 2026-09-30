#!/usr/bin/env julia
# The benchmark matrix: every case of `test/ADFixtures/src/matrix_cases.jl`
# at every size of a tier, on every target (primal, gradient backends and
# their NoAdjoint arms). The CI suite in `benchmarks.jl` times the `ci` tier
# only; this script runs the full grid.
#
#   julia --project=benchmark benchmark/matrix.jl [options]
#
# Options:
#   --tier=ci|realistic|large   size tier (default realistic)
#   --targets=a,b               targets (default: primal and the gradients)
#   --cases=a,b                 cases (default: every case in the tier)
#   --out=DIR                   result directory (default matrix-results)
#   --label=NAME                label written into the results (default HEAD)
#   --timeout=SECONDS           per target process (default 3600)
#   --seconds=SECONDS           BenchmarkTools budget per cell (default 2)
#
# Each target runs in its own Julia process, so one backend's hang or crash
# does not stop the rest and no process loads two AD stacks. A worker writes
# `DIR/<tier>-<target>.tsv`; `matrix_report.jl` turns a directory into a
# Markdown table. Targets that need unmerged work are written as `pending`.

using ADTypes: AutoEnzyme, AutoForwardDiff, AutoMooncake, AutoMooncakeForward
using BenchmarkTools: @benchmark
using Dates: now
import DifferentiationInterface as DI
import Pkg
using Printf: @printf
using Statistics: median

const CASES_FILE = joinpath(
    @__DIR__, "..", "test", "ADFixtures", "src", "matrix_cases.jl"
)
include(CASES_FILE)
using .MatrixCases

# Gradient targets: name => (module to import, backend expression).
const GRADIENTS = Dict(
    "ForwardDiff" => (:ForwardDiff, :(AutoForwardDiff())),
    "Mooncake reverse" => (:Mooncake, :(AutoMooncake(; config = nothing))),
    "Mooncake forward" => (:Mooncake, :(AutoMooncakeForward(; config = nothing))),
    "Enzyme reverse" => (
        :Enzyme, :(
            AutoEnzyme(;
                mode = Enzyme.set_runtime_activity(Enzyme.Reverse),
                function_annotation = Enzyme.Const,
            )
        ),
    ),
    "Enzyme forward" => (
        :Enzyme, :(
            AutoEnzyme(;
                mode = Enzyme.set_runtime_activity(Enzyme.Forward),
                function_annotation = Enzyme.Const,
            )
        ),
    ),
)

const DEFAULT_TARGETS = [
    "primal", "ForwardDiff", "Mooncake reverse", "Enzyme reverse",
]

# Targets waiting on unmerged work, with what they wait for.
const PENDING_TARGETS = [
    ("CPU threaded primal", "executor (#17)"),
    ("CPU threaded gradient", "executor (#17)"),
    ("KA CPU primal", "KernelAbstractions extension (#17)"),
    ("CUDA primal", "GPU array path (#14)"),
    ("CUDA gradient", "GPU array path and rules (#14)"),
]

# ForwardDiff costs one primal per chunk of parameters: above this many it
# is skipped, and gradients are checked against the other arm instead.
const FD_MAX = 4000

const COLUMNS = [
    "case", "size", "S", "T", "L", "target", "arm", "status", "min_ns",
    "median_ns", "allocs", "memory", "prep_s", "relerr", "check", "nparams",
]

function parse_args(args)
    opts = Dict(
        "tier" => "realistic", "targets" => join(DEFAULT_TARGETS, ","),
        "cases" => "", "out" => "matrix-results", "label" => "",
        "timeout" => "3600", "seconds" => "2", "worker" => "",
    )
    for a in args
        m = match(r"^--([a-z]+)(?:=(.*))?$", a)
        m === nothing && error("unknown argument $a")
        opts[m.captures[1]] = something(m.captures[2], "true")
    end
    return opts
end

_list(s) = isempty(s) ? String[] : String.(split(s, ','))

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

# ---- worker ---------------------------------------------------------------

function metadata(opts, target)
    return [
        "label" => isempty(opts["label"]) ? git_rev()[1:min(end, 8)] : opts["label"],
        "rev" => git_rev(), "tier" => opts["tier"], "target" => target,
        "julia" => string(VERSION), "threads" => string(Threads.nthreads()),
        "host" => gethostname(), "started" => string(now()),
        "load_start" => loadavg(),
    ]
end

function versions(names)
    deps = Pkg.dependencies()
    return [
        n => string(something(d.version, "dev")) for d in values(deps)
            for n in names if d.name == n
    ]
end

# Whether the package's rules for `pkg` are loaded on this revision.
function has_rules(CR, pkg)
    ext = Symbol("ComposableRecurrences", pkg, "Ext")
    return Base.get_extension(CR, ext) !== nothing
end

# Why a cell is not run, or `nothing` to run it.
function skip_reason(c, target, arm, θ, rules)
    target == "primal" && arm == "NoAdjoint" && return "same as rule arm"
    if startswith(target, "ForwardDiff")
        arm == "NoAdjoint" && return "rules do not apply to dual numbers"
        length(θ) > FD_MAX && return "over $FD_MAX parameters"
    end
    if target == "Enzyme reverse" && c.sparse && (arm == "NoAdjoint" || !rules)
        return "known wrong: plain Enzyme on a repeated sparse mul!"
    end
    if target in ("Enzyme forward", "Mooncake forward") && length(θ) > FD_MAX
        return "over $FD_MAX parameters"
    end
    if target == "Enzyme forward" && occursin("depletion", c.description)
        return "known wrong: forward Enzyme with a modifier constant"
    end
    return nothing
end

relerr(a, b) = maximum(abs.(a .- b)) / max(1.0, maximum(abs.(b)))

function run_worker(opts)
    target = opts["worker"]
    outdir = mkpath(opts["out"])
    file = joinpath(outdir, "$(opts["tier"])-$(replace(target, ' ' => '_')).tsv")
    meta = metadata(opts, target)
    grad = target != "primal"
    backend = nothing
    if grad
        mod, backend_expr = GRADIENTS[target]
        @eval import ForwardDiff, $mod
        backend = @eval $backend_expr
    end
    CR = MatrixCases.ComposableRecurrences
    rules = grad && has_rules(CR, String(GRADIENTS[target][1]))
    push!(meta, "rules" => string(rules))
    append!(
        meta, versions(
            [
                "ComposableRecurrences", "Mooncake", "Enzyme", "ForwardDiff",
                "DifferentiationInterface",
            ]
        )
    )
    # Rows are written as they finish, so a crash keeps the cells before it.
    open(file, "w") do io
        for (k, v) in meta
            println(io, "# ", k, "=", v)
        end
        println(io, join(COLUMNS, '\t'))
        flush(io)
        # The backend's methods are newer than this function: run the cells
        # in the latest world.
        Base.invokelatest(run_cells, io, opts, target, backend, rules)
        println(io, "# load_end=", loadavg())
        println(io, "# finished=", now())
    end
    println("wrote ", file)
    return nothing
end

function run_cells(io, opts, target, backend, rules)
    grad = backend !== nothing
    tier = opts["tier"]
    seconds = parse(Float64, opts["seconds"])
    names = _list(opts["cases"])
    for c in MatrixCases.CASES
        isempty(names) || c.name in names || continue
        for z in MatrixCases.sizes(c, tier)
            grads = Dict{String, Vector{Float64}}()
            for arm in ("rule", "NoAdjoint")
                row = Dict{String, Any}(
                    "case" => c.name, "size" => string(z), "S" => z.S,
                    "T" => z.T, "L" => z.L, "target" => target, "arm" => arm,
                )
                f, θ = MatrixCases.build(c, z, arm)
                row["nparams"] = length(θ)
                reason = skip_reason(c, target, arm, θ, rules)
                if reason !== nothing
                    row["status"] = "skipped: $reason"
                    println(io, join(_row(row), '\t'))
                    continue
                end
                try
                    if grad
                        _time_gradient!(row, grads, f, θ, backend, seconds, arm)
                    else
                        _time_primal!(row, f, θ, seconds)
                    end
                    row["status"] = "ok"
                catch e
                    row["status"] = "error: " *
                        first(replace(sprint(showerror, e), r"\s+" => " "), 150)
                end
                println(io, join(_row(row), '\t'))
                flush(io)
                @printf(
                    "%-18s %-14s %-9s %-16s %s\n", c.name, string(z), arm,
                    target, _cell(row)
                )
                flush(stdout)
            end
        end
    end
    return nothing
end

_row(row) = [string(get(row, k, "")) for k in COLUMNS]
function _cell(row)
    haskey(row, "median_ns") || return string(get(row, "status", ""))
    return string(round(row["median_ns"] / 1.0e3; digits = 1), " µs")
end

function _record!(row, b)
    row["min_ns"] = minimum(b.times)
    row["median_ns"] = median(b.times)
    row["allocs"] = b.allocs
    row["memory"] = b.memory
    return row
end

function _time_primal!(row, f, θ, seconds)
    t0 = time()
    f(θ)
    row["prep_s"] = round(time() - t0; digits = 2)
    b = @benchmark $f($θ) samples = 1000 evals = 1 seconds = seconds
    return _record!(row, b)
end

function _time_gradient!(row, grads, f, θ, backend, seconds, arm)
    t0 = time()
    prep = DI.prepare_gradient(f, backend, copy(θ))
    g = similar(θ)
    DI.gradient!(f, g, prep, backend, θ)
    row["prep_s"] = round(time() - t0; digits = 2)
    # Check against ForwardDiff where affordable, else against the other arm.
    if length(θ) <= FD_MAX
        row["relerr"] = relerr(g, ForwardDiff.gradient(f, θ))
        row["check"] = "ForwardDiff"
    elseif haskey(grads, "rule")
        row["relerr"] = relerr(g, grads["rule"])
        row["check"] = "rule arm"
    else
        row["check"] = "none"
    end
    grads[arm] = copy(g)
    b = @benchmark(
        $(DI.gradient!)($f, $g, $prep, $backend, $θ);
        samples = 1000, evals = 1, seconds = seconds
    )
    return _record!(row, b)
end

# ---- orchestrator ---------------------------------------------------------

function write_pending(opts, outdir)
    file = joinpath(outdir, "$(opts["tier"])-pending.tsv")
    open(file, "w") do io
        println(io, "# tier=", opts["tier"])
        println(io, join(COLUMNS, '\t'))
        for (target, waits) in PENDING_TARGETS
            row = Dict("target" => target, "status" => "pending: $waits")
            println(io, join(_row(row), '\t'))
        end
        for (name, waits) in MatrixCases.pending_cases()
            row = Dict("case" => name, "status" => "pending: $waits")
            println(io, join(_row(row), '\t'))
        end
    end
    return file
end

function run_all(opts)
    outdir = mkpath(opts["out"])
    timeout = parse(Float64, opts["timeout"])
    project = Base.active_project()
    for target in _list(opts["targets"])
        target == "primal" || haskey(GRADIENTS, target) ||
            error(
            "unknown target $target; choose from primal, ",
            join(keys(GRADIENTS), ", ")
        )
        args = [
            "--worker=$target", "--tier=$(opts["tier"])",
            "--cases=$(opts["cases"])", "--out=$outdir",
            "--label=$(opts["label"])", "--seconds=$(opts["seconds"])",
        ]
        cmd = `$(Base.julia_cmd()) --project=$project --startup-file=no
            --threads=1 $(@__FILE__) $args`
        log = joinpath(outdir, "$(opts["tier"])-$(replace(target, ' ' => '_')).log")
        println("== $target (log: $log)")
        t0 = time()
        p = run(pipeline(cmd; stdout = log, stderr = log); wait = false)
        timed_out = timedwait(() -> process_exited(p), timeout; pollint = 2.0) ===
            :timed_out
        if timed_out
            kill(p, Base.SIGKILL)
            wait(p)
        end
        @printf(
            "   %s after %.0f s\n",
            timed_out ? "timed out" : "exit $(p.exitcode)", time() - t0
        )
    end
    println("wrote ", write_pending(opts, outdir))
    return nothing
end

if abspath(PROGRAM_FILE) == @__FILE__
    opts = parse_args(ARGS)
    haskey(MatrixCases.TIERS, opts["tier"]) ||
        error("unknown tier $(opts["tier"]); choose from ", join(keys(MatrixCases.TIERS), ", "))
    isempty(opts["worker"]) ? run_all(opts) : run_worker(opts)
end
