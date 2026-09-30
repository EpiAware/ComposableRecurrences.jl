# PACKAGE-OWNED — scaffold writes this once and never overwrites it.
#
# Benchmark suite definition. Build a BenchmarkTools `BenchmarkGroup` named
# `SUITE`; the managed `run.jl` / `compare.jl` consume it. Put AD-gradient
# benchmarks under the `"AD gradients"` group so the comparison comment folds
# them into a compact per-(scenario x backend) matrix. Edit freely.

using BenchmarkTools
using ComposableRecurrences

const SUITE = BenchmarkGroup()

# Example evaluation benchmark — replace with the package's own:
# SUITE["Evaluation"]["example"] = @benchmarkable sum(rand(100))

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
