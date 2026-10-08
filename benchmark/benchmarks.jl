# PACKAGE-OWNED — scaffold writes this once and never overwrites it.
#
# Benchmark suite definition. Build a BenchmarkTools `BenchmarkGroup` named
# `SUITE`; the managed `run.jl` / `compare.jl` consume it. Put AD-gradient
# benchmarks under the `"AD gradients"` group so the comparison comment folds
# them into a compact per-(scenario x backend) matrix. Edit freely.

using BenchmarkTools
using ComposableRecurrences

const SUITE = BenchmarkGroup()

# Every entry below sets `evals = 1, seconds = 1, gctrial = false`: one
# evaluation per sample, for at most a second; the convolution body entries
# at the end, each well under a microsecond, take 100. Setting `evals` marks
# an entry as tuned, so the `tune!` pass of the history workflow skips it
# rather than spending seconds per entry estimating an evaluation count. The pull request
# workflow already measures with one evaluation and `seconds = 1`.
# `gctrial = false` drops the full garbage collections before each entry: with
# every AD backend loaded the heap is large, each collection takes seconds,
# and the minimum time reported is not sensitive to it.

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
                evals = 1, seconds = 1, gctrial = false
            )
        end
    end
    SUITE["AD gradients"] = grad
end

# The `ci` tier of the benchmark matrix (`matrix.jl` runs the full grid):
# each case's primal, and its gradient on the reverse backends with the
# operator as users call it and under `NoAdjoint`, so the comparison comment
# shows the rule gain. ForwardDiff times the operator and, where the case
# has one, the hand-written `loop` baseline, so the ratio between them is
# tracked. The history workflow runs this script, and the
# registry, against older releases: a case or arm needing a feature the
# loaded version lacks is left out (`MatrixCases.available`, and
# `ADFixtures.supports` for the scenarios above), and one that still fails
# to build or run is skipped with a warning.
using ADFixtures: MatrixCases

let eval_group = BenchmarkGroup(), grad = SUITE["AD gradients"]
    reverse = filter(
        e -> e.name in ("Mooncake reverse", "Enzyme reverse"),
        ADFixtures.backends()
    )
    forward = filter(e -> e.name == "ForwardDiff", ADFixtures.backends())
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
            $f($θ), evals = 1, seconds = 1, gctrial = false
        )
        for arm in ("rule", "NoAdjoint"), entry in reverse
            MatrixCases.available(c, arm) || continue
            c.sparse && entry.name == "Enzyme reverse" && continue
            f, θ = MatrixCases.build(c, z, arm)
            prep = try
                DI.prepare_gradient(f, entry.backend, copy(θ))
            catch
                @warn "no gradient prep" label arm entry.name
                continue
            end
            name = arm == "rule" ? label : "NoAdjoint $label"
            haskey(grad, name) || (grad[name] = BenchmarkGroup())
            grad[name][entry.name] = @benchmarkable(
                DI.gradient($f, $prep, $(entry.backend), $θ),
                evals = 1, seconds = 1, gctrial = false
            )
        end
        for arm in ("rule", "loop"), entry in forward
            arm in MatrixCases.arms(c) && MatrixCases.available(c, arm) || continue
            f, θ = MatrixCases.build(c, z, arm)
            prep = try
                DI.prepare_gradient(f, entry.backend, copy(θ))
            catch
                @warn "no gradient prep" label arm entry.name
                continue
            end
            name = arm == "rule" ? label : "$(titlecase(arm)) $label"
            haskey(grad, name) || (grad[name] = BenchmarkGroup())
            grad[name][entry.name] = @benchmarkable(
                DI.gradient($f, $prep, $(entry.backend), $θ),
                evals = 1, seconds = 1, gctrial = false
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
        evals = 100, seconds = 1, gctrial = false
    )
    body["native axpy per lag"] = @benchmarkable(
        _bench_conv_per_lag!(_bench_native_axpy!, $y, $c, $X, $L),
        evals = 100, seconds = 1, gctrial = false
    )
    if isdefined(ComposableRecurrences, :_convolve_series!) &&
            applicable(ComposableRecurrences._convolve_series!, y, c, X, 1, L, 1)
        body["package"] = @benchmarkable(
            ComposableRecurrences._convolve_series!($y, $c, $X, 1, $L, 1),
            evals = 100, seconds = 1, gctrial = false
        )
    end
    SUITE["Convolution body"] = body
end
