#!/usr/bin/env julia
# Time `Serial()` against `Threaded(; min_work = 0)` across loop work sizes,
# to find where splitting a loop across threads starts to win and so set the
# default `Threaded` `min_work`. Each model's sizes are chosen so the work of
# the loop the executor splits runs from 10 000 to 2 million multiply-adds.
#
#   julia --project=benchmark --threads=N benchmark/threshold.jl [options]
#   task -t benchmark/Taskfile.yml threshold -- [options]
#
# Options:
#   --target=primal|gradient   time the loss or its Mooncake reverse
#                              gradient (default primal)
#   --models=a,b               models (default all)
#   --out=FILE                 result file (default threshold-<target>-t<N>.tsv)
#   --seconds=SECONDS          BenchmarkTools budget per cell (default 2)
#
# Models, with the loop they split and its work:
#   independent  identity coupling, whole series per stratum, S T L
#   sparse       sparse ring coupling, one loop per step, S L
#   pairwise     kernel per pair of strata, one loop per step, S² L
#   convolution  fixed pmf over S series, one loop per call, S T L
#
# The rows record the minimum and median time of each executor and the load
# average when the cell ran.

using ADTypes: AutoMooncake
using BenchmarkTools: @benchmark
using Base.ScopedValues: with
import DifferentiationInterface as DI
import Mooncake
using Printf: @printf
using Statistics: median

using ADFixtures: MatrixCases
using ADFixtures.MatrixCases: Size

const CR = MatrixCases.ComposableRecurrences

const WORKS = [10_000, 20_000, 50_000, 100_000, 200_000, 500_000, 1_000_000, 2_000_000]

# A convolution of `S` series by one pmf, with a weighted sum as the loss.
function convolution(wrap, z::Size)
    (; T, L, S) = z
    W = MatrixCases._weights(S, T)'
    f = function (θ)
        pmf = θ[1:L]
        X = reshape(view(θ, (L + 1):length(θ)), T, S)
        return sum(W .* wrap(CR.Convolution(pmf))(X))
    end
    X0 = [50.0 + 40.0 * MatrixCases._noise(t, k) for t in 1:T, k in 1:S]
    return f, vcat(MatrixCases._gi(L), vec(X0))
end

# name => (loss, size giving loop work `w`, the loop's work at a size).
const MODELS = [
    "independent" => (
        MatrixCases.strata_independent,
        w -> Size(; T = 100, L = 20, S = cld(w, 2000)),
        z -> z.S * z.T * z.L,
    ),
    "sparse" => (
        MatrixCases.zones_sparse,
        w -> Size(; T = 50, L = 20, S = cld(w, 20)),
        z -> z.S * z.L,
    ),
    "pairwise" => (
        MatrixCases.strata_pairwise,
        w -> Size(; T = 50, L = 20, S = round(Int, sqrt(w / 20))),
        z -> z.S^2 * z.L,
    ),
    "convolution" => (
        convolution,
        w -> Size(; T = 100, L = 20, S = cld(w, 2000)),
        z -> z.S * z.T * z.L,
    ),
]

const EXECUTORS = ["Serial" => CR.Serial(), "Threaded" => CR.Threaded(; min_work = 0)]

function parse_args(args)
    opts = Dict(
        "target" => "primal", "models" => "", "out" => "", "seconds" => "2",
    )
    for a in args
        m = match(r"^--([a-z]+)=(.*)$", a)
        m === nothing && error("unknown argument $a")
        opts[m.captures[1]] = m.captures[2]
    end
    opts["target"] in ("primal", "gradient") ||
        error("--target takes primal or gradient, not $(opts["target"])")
    return opts
end

loadavg() = first(split(read("/proc/loadavg", String)))

function timer(f, θ, target, seconds)
    if target == "primal"
        f(θ)
        return () -> @benchmark $f($θ) samples = 1000 evals = 1 seconds = seconds
    end
    backend = AutoMooncake(; config = nothing)
    prep = DI.prepare_gradient(f, backend, copy(θ))
    g = similar(θ)
    DI.gradient!(f, g, prep, backend, θ)
    return () -> @benchmark(
        $(DI.gradient!)($f, $g, $prep, $backend, $θ);
        samples = 1000, evals = 1, seconds = seconds
    )
end

function main(opts)
    target = opts["target"]
    seconds = parse(Float64, opts["seconds"])
    names = isempty(opts["models"]) ? first.(MODELS) : split(opts["models"], ',')
    nt = Threads.nthreads()
    out = isempty(opts["out"]) ? "threshold-$target-t$nt.tsv" : opts["out"]
    open(out, "w") do io
        println(io, "# julia=", VERSION, " threads=", nt, " host=", gethostname())
        println(io, "# cpu=", Sys.cpu_info()[1].model, " cores=", Sys.CPU_THREADS)
        println(io, "# load_start=", loadavg())
        println(
            io, join(
                ["model", "work", "S", "T", "L", "executor", "min_ns", "median_ns", "load"],
                '\t'
            )
        )
        for (name, (loss, size, work)) in MODELS
            name in names || continue
            for w in WORKS
                z = size(w)
                f, θ = loss(identity, z)
                for (exname, ex) in EXECUTORS
                    b = with(CR.EXECUTOR => ex) do
                        Base.invokelatest(timer(f, θ, target, seconds))
                    end
                    row = (
                        name, work(z), z.S, z.T, z.L, exname, minimum(b.times),
                        median(b.times), loadavg(),
                    )
                    println(io, join(row, '\t'))
                    flush(io)
                    @printf(
                        "%-12s %9d %-9s %12.1f µs  load %s\n", name, work(z),
                        exname, minimum(b.times) / 1.0e3, loadavg()
                    )
                end
            end
        end
        println(io, "# load_end=", loadavg())
    end
    println("wrote ", out)
    return nothing
end

main(parse_args(ARGS))
