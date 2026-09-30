# PACKAGE-OWNED — scaffold writes this once and never overwrites it.
#
# Benchmark suite definition. Build a BenchmarkTools `BenchmarkGroup` named
# `SUITE`; the managed `run.jl` / `compare.jl` consume it. Put AD-gradient
# benchmarks under the `"AD gradients"` group so the comparison comment folds
# them into a compact per-(scenario x backend) matrix. Edit freely.

using BenchmarkTools
using ComposableRecurrences

const SUITE = BenchmarkGroup()

# The AD gradient grid, read from the package-owned `test/ADFixtures`
# registry: declare a scenario or a broken pair there, not here.
using ADFixtures
import DifferentiationInterface as DI

let grad = BenchmarkGroup()
    broken = Set(ADFixtures.broken_scenario_names())
    per_backend = ADFixtures.backend_broken_scenarios()
    skipped = ADFixtures.backend_skip_scenarios()
    for entry in ADFixtures.backends()
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
            grad[scen.name][entry.name] = @benchmarkable DI.gradient(
                $(scen.f), $prep, $(entry.backend), $(scen.x),
                $(scen.contexts)...
            )
        end
    end
    SUITE["AD gradients"] = grad
end

# The `ci` tier of the benchmark matrix (`matrix.jl` runs the full grid):
# each case's primal, and its gradient on the reverse backends with the
# operator as users call it and under `NoAdjoint`, so the comparison comment
# shows the rule gain. A case the checked-out revision cannot build is
# skipped, since the history workflow runs this script on older revisions.
using ADFixtures: MatrixCases

let eval_group = BenchmarkGroup(), grad = SUITE["AD gradients"]
    reverse = filter(
        e -> e.name in ("Mooncake reverse", "Enzyme reverse"),
        ADFixtures.backends()
    )
    for c in MatrixCases.CASES, z in MatrixCases.sizes(c, "ci")
        label = "Matrix $(c.name) $(z)"
        f, θ = try
            MatrixCases.build(c, z, "rule")
        catch
            @warn "matrix case not built" c.name
            continue
        end
        eval_group[label] = @benchmarkable $f($θ)
        for arm in ("rule", "NoAdjoint"), entry in reverse
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
            grad[name][entry.name] = @benchmarkable DI.gradient(
                $f, $prep, $(entry.backend), $θ
            )
        end
    end
    SUITE["Evaluation"] = eval_group
end
