# PACKAGE-OWNED — scaffold writes this once and never overwrites it.
#
# Benchmark suite definition. Build a BenchmarkTools `BenchmarkGroup` named
# `SUITE`; the managed `run.jl` / `compare.jl` consume it. Put AD-gradient
# benchmarks under the `"AD gradients"` group so the comparison comment folds
# them into a compact per-(scenario x backend) matrix. Edit freely.

using BenchmarkTools
using ComposableRecurrences

const SUITE = BenchmarkGroup()

# Every entry below sets
# `evals = 1, samples = 100, seconds = 1, gctrial = false`.
# That is one evaluation per sample, for at most 100 samples or a second,
# whichever comes first.
# The convolution body entries at the end take 100 evaluations a sample,
# since each is well under a microsecond.
# Setting `evals` marks an entry as tuned, so the `tune!` pass of the
# history workflow skips it rather than spending seconds per entry
# estimating an evaluation count.
# The pull request workflow measures with `seconds = 1` and keeps each
# entry's sample cap, so a fast entry stops after 100 samples rather than
# running for the full second.
# `gctrial = false` drops the full garbage collections before each entry.
# With every AD backend loaded the heap is large, each collection takes
# seconds, and the minimum time reported is not sensitive to it.

# BenchmarkTools runs full garbage collections (`gcscrub`) before every
# group it tunes or runs, whatever the entries set. The AD grid has a group
# per scenario, and with the AD backends loaded each collection takes
# seconds. Compiling a group allocates more than a tenth of the live heap,
# so the allocation threshold BenchmarkTools 1.9 adds would not skip them.
# A collection before a group does not change the minimum time reported,
# and Julia still collects as it allocates, so they are skipped here.
if isdefined(BenchmarkTools, :gcscrub)
    BenchmarkTools.gcscrub() = nothing
end

# The AD gradient grid, read from the package-owned `test/ADFixtures`
# registry: declare a scenario or a broken pair there, not here.
using ADFixtures
import DifferentiationInterface as DI

# The backends the package targets: ForwardDiff, and Enzyme and Mooncake in
# forward and reverse mode. The registry also lists ReverseDiff, which the AD
# tests still run, but the suite does not time it.
const BENCHMARK_BACKENDS = filter(
    e -> !startswith(e.name, "ReverseDiff"), ADFixtures.backends()
)

let grad = BenchmarkGroup()
    broken = Set(ADFixtures.broken_scenario_names())
    per_backend = ADFixtures.backend_broken_scenarios()
    skipped = ADFixtures.backend_skip_scenarios()
    for entry in BENCHMARK_BACKENDS
        excluded = union(
            broken,
            get(per_backend, entry.name, Set{String}()),
            get(skipped, entry.name, Set{String}())
        )
        for scen in ADFixtures.scenarios()
            scen.name in excluded && continue
            prep = try
                DI.prepare_gradient(
                    scen.f, entry.backend, scen.x, scen.contexts...
                )
            catch
                @warn "no gradient prep" scen.name entry.name
                continue
            end
            haskey(grad, scen.name) ||
                (grad[scen.name] = BenchmarkGroup())
            grad[scen.name][entry.name] = @benchmarkable(
                DI.gradient(
                    $(scen.f), $prep, $(entry.backend), $(scen.x),
                    $(scen.contexts)...
                ),
                evals = 1, samples = 100, seconds = 1, gctrial = false
            )
        end
    end
    SUITE["AD gradients"] = grad
end

# The `ci` tier of the benchmark matrix (`matrix.jl` runs the full grid):
# each case's primal, and its gradient on every benchmarked backend in three
# arms: the operator as users call it, under `NoAdjoint`, and, where the
# case has one, the hand-written `loop` baseline. The comparison comment
# then shows each backend's rule gain and its ratio to the loop.
# On the forward modes and ForwardDiff the rule and `NoAdjoint` arms run the
# same code, as the rules are reverse rules; both are timed so every backend
# covers the same cells.
# Plain Enzyme reverse is wrong on a repeated sparse `mul!`, so it skips the
# sparse cases.
# Each gradient is taken once here, so an arm a backend cannot run is left
# out with a warning rather than failing the whole run.
# The history workflow runs this script, and the
# registry, against older releases: a case or arm needing a feature the
# loaded version lacks is left out (`MatrixCases.available`, and
# `ADFixtures.supports` for the scenarios above), and one that still fails
# to build or run is skipped with a warning.
using ADFixtures: MatrixCases

let eval_group = BenchmarkGroup(), grad = SUITE["AD gradients"]
    for c in MatrixCases.CASES, z in MatrixCases.sizes(c, "ci")
        MatrixCases.available(c) || continue
        label = "Matrix $(c.name) $(z)"
        f, θ = try
            built = MatrixCases.build(c, z, "rule")
            first(built)(last(built))
            built
        catch
            @warn "matrix case not built" c.name
            continue
        end
        eval_group[label] = @benchmarkable(
            $f($θ), evals = 1, samples = 100, seconds = 1, gctrial = false
        )
        for arm in ("rule", "NoAdjoint", "loop"), entry in BENCHMARK_BACKENDS
            arm in MatrixCases.arms(c) && MatrixCases.available(c, arm) ||
                continue
            c.sparse && entry.name == "Enzyme reverse" && continue
            f, θ = MatrixCases.build(c, z, arm)
            prep = try
                p = DI.prepare_gradient(f, entry.backend, copy(θ))
                DI.gradient(f, p, entry.backend, θ)
                p
            catch
                @warn "no gradient" label arm entry.name
                continue
            end
            name = arm == "rule" ? label :
                arm == "loop" ? "Loop $label" : "NoAdjoint $label"
            haskey(grad, name) || (grad[name] = BenchmarkGroup())
            grad[name][entry.name] = @benchmarkable(
                DI.gradient($f, $prep, $(entry.backend), $θ),
                evals = 1, samples = 100, seconds = 1, gctrial = false
            )
        end
    end
    SUITE["Evaluation"] = eval_group
end

# The fixed-kernel convolution body against the forms it replaced, at
# `T = 200`, `L = 20`: BLAS `axpy!` per lag, a native loop per lag, and the
# package's body. A Julia or BLAS upgrade that reorders them shows up here.
using LinearAlgebra: axpy!

function _bench_conv_per_lag!(axpy, y, c, X, m)
    T = length(y)
    for d in 0:(length(c) - 1)
        j0 = max(1, d + 1 - m)
        j0 > T && break
        axpy(c[d + 1], view(X, (m + j0 - d):(m + T - d), 1), view(y, j0:T))
    end
    return y
end
function _bench_native_axpy!(α, x, y)
    @inbounds @simd ivdep for i in eachindex(x, y)
        y[i] += α * x[i]
    end
    return y
end

let body = BenchmarkGroup(), T = 200, L = 20
    c = fill(1 / L, L)
    X = ones(L + T, 1)
    y = zeros(T)
    body["BLAS axpy per lag"] = @benchmarkable(
        _bench_conv_per_lag!(axpy!, $y, $c, $X, $L),
        evals = 100, samples = 100, seconds = 1, gctrial = false
    )
    body["native axpy per lag"] = @benchmarkable(
        _bench_conv_per_lag!(_bench_native_axpy!, $y, $c, $X, $L),
        evals = 100, samples = 100, seconds = 1, gctrial = false
    )
    if isdefined(ComposableRecurrences, :_convolve_series!) &&
            applicable(ComposableRecurrences._convolve_series!, y, c, X, 1, L, 1)
        body["package"] = @benchmarkable(
            ComposableRecurrences._convolve_series!($y, $c, $X, 1, $L, 1),
            evals = 100, samples = 100, seconds = 1, gctrial = false
        )
    end
    SUITE["Convolution body"] = body
end

# Direct against FFT lag sums, forward and Mooncake gradient, either side of
# the crossover: FFT pays only for long kernels.
using FFTW: FFTW
using Mooncake: Mooncake
using ADTypes: AutoMooncake

if isdefined(ComposableRecurrences, :FFTMethod)
    let methods = BenchmarkGroup()
        backend = AutoMooncake(; config = nothing)
        sizes = (
            (1, 200, 32), (1, 200, 64), (1, 300, 60), (1, 2000, 32),
            (1, 2000, 100), (1, 20000, 500), (50, 200, 64),
        )
        arms = (
            ("Direct", ComposableRecurrences.Direct()),
            ("FFT", ComposableRecurrences.FFTMethod()),
        )
        for (S, T, L) in sizes, (name, method) in arms
            x = S == 1 ? rand(T) : rand(S, T)
            w = rand(size(x)...)
            label = "S $S T $T L $L"
            haskey(methods, label) || (methods[label] = BenchmarkGroup())
            c = Convolution(fill(1 / L, L); method)
            methods[label]["$name forward"] = @benchmarkable(
                $c($x),
                evals = 1, samples = 100, seconds = 1, gctrial = false
            )
            loss = k -> sum(w .* Convolution(k; method)(x))
            k = fill(1 / L, L)
            prep = DI.prepare_gradient(loss, backend, k)
            methods[label]["$name Mooncake gradient"] = @benchmarkable(
                DI.gradient($loss, $prep, $backend, $k),
                evals = 1, samples = 100, seconds = 1, gctrial = false
            )
        end
        SUITE["Convolution methods"] = methods
    end
end
