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
#   --target=primal|mooncake|enzyme|forwarddiff
#                              time the loss, its Mooncake or Enzyme reverse
#                              gradient, or a ForwardDiff pushforward of one
#                              chunk of 8 tangents (default primal;
#                              `gradient` is `mooncake`)
#   --models=a,b               models (default all)
#   --works=a,b                loop work sizes (default 10 000 to 2 million)
#   --rounds=N                 sweeps over every cell (default 1); rounds
#                              alternate the executors so load on a shared
#                              machine falls on both
#   --out=FILE                 result file (default threshold-<target>-t<N>.tsv)
#   --seconds=SECONDS          BenchmarkTools budget per cell (default 2)
#
# Models, with the loop they split and its work:
#   independent  identity coupling, whole series per stratum, S T L
#   sparse       sparse ring coupling, two loops per step, S L each
#   pairwise     kernel per pair of strata, one loop per step, S² L
#   convolution  fixed pmf over S series, one loop per call, S T L
#
# The rows record the round, the minimum and median time of each executor
# and the load average when the cell ran. Times are of the whole loss, so they include
# serial work outside the split loops.

using ADTypes: AutoEnzyme, AutoForwardDiff, AutoMooncake
using BenchmarkTools: @benchmark
using Base.ScopedValues: with
import DifferentiationInterface as DI
import Enzyme
import ForwardDiff
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
        w -> Size(; T = 50, L = 20, S = ceil(Int, sqrt(w / 20))),
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
        "works" => "", "rounds" => "1",
    )
    for a in args
        m = match(r"^--([a-z]+)=(.*)$", a)
        m === nothing && error("unknown argument $a")
        opts[m.captures[1]] = m.captures[2]
    end
    opts["target"] == "gradient" && (opts["target"] = "mooncake")
    opts["target"] in TARGETS || error(
        "--target takes one of ", join(TARGETS, ", "), ", not ", opts["target"]
    )
    return opts
end

loadavg() = try
    first(split(read("/proc/loadavg", String)))
catch
    "unknown"
end

const TARGETS = ("primal", "mooncake", "enzyme", "forwarddiff")

const REVERSE = Dict(
    "mooncake" => AutoMooncake(; config = nothing),
    "enzyme" => AutoEnzyme(;
        mode = Enzyme.set_runtime_activity(Enzyme.Reverse),
        function_annotation = Enzyme.Const,
    ),
)

# The ForwardDiff target pushes forward one chunk of `NTANGENTS` tangents,
# the unit a ForwardDiff gradient repeats once per chunk of parameters.
const NTANGENTS = 8

# A thunk that times `target` on the loss `f` at `θ` under the executor in
# scope, after one call to compile it.
function timer(f, θ, target, seconds)
    if target == "primal"
        f(θ)
        return () -> @benchmark $f($θ) samples = 1000 evals = 1 seconds = seconds
    elseif target == "forwarddiff"
        backend = AutoForwardDiff()
        tx = ntuple(i -> (j -> sin(i * j)).(eachindex(θ)), NTANGENTS)
        prep = DI.prepare_pushforward(f, backend, θ, tx)
        DI.pushforward(f, prep, backend, θ, tx)
        return () -> @benchmark(
            $(DI.pushforward)($f, $prep, $backend, $θ, $tx);
            samples = 1000, evals = 1, seconds = seconds
        )
    end
    backend = REVERSE[target]
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
    models = isempty(opts["models"]) ? first.(MODELS) : split(opts["models"], ',')
    for m in models
        m in first.(MODELS) ||
            error("unknown model $m; choose from ", join(first.(MODELS), ", "))
    end
    works = isempty(opts["works"]) ? WORKS :
        parse.(Int, split(replace(opts["works"], "_" => ""), ','))
    rounds = parse(Int, opts["rounds"])
    nt = Threads.nthreads()
    out = isempty(opts["out"]) ? "threshold-$target-t$nt.tsv" : opts["out"]
    open(out, "w") do io
        println(io, "# julia=", VERSION, " threads=", nt, " host=", gethostname())
        println(io, "# cpu=", Sys.cpu_info()[1].model, " cores=", Sys.CPU_THREADS)
        println(io, "# load_start=", loadavg())
        println(
            io, join(
                [
                    "round", "model", "work", "S", "T", "L", "executor", "min_ns",
                    "median_ns", "load",
                ],
                '\t'
            )
        )
        for round in 1:rounds, (name, (loss, size_at, work)) in MODELS
            name in models || continue
            for w in works
                z = size_at(w)
                f, θ = loss(identity, z)
                # Alternate which executor runs first in each round.
                exs = isodd(round) ? EXECUTORS : reverse(EXECUTORS)
                for (exname, ex) in exs
                    b = with(CR.EXECUTOR => ex) do
                        Base.invokelatest(timer(f, θ, target, seconds))
                    end
                    row = (
                        round, name, work(z), z.S, z.T, z.L, exname,
                        minimum(b.times), median(b.times), loadavg(),
                    )
                    println(io, join(row, '\t'))
                    flush(io)
                    @printf(
                        "%d %-12s %9d %-9s %12.1f µs  load %s\n", round, name,
                        work(z), exname, minimum(b.times) / 1.0e3, loadavg()
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
