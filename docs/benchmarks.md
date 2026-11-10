<!-- PACKAGE-OWNED — your benchmark narrative. scaffold writes this once and
never overwrites it. The managed build splices this file verbatim into the
generated `docs/src/benchmarks/over-time.md`, at the FOOT of the page under an
"## About these benchmarks" heading. The page itself is a presentation of
results — a summary across the package, then one section per suite — so this
is the supporting material a reader wants after the numbers, not before them:
what the suite covers, how to run it locally, and anything needed to read the
history correctly. Add your own `## ...` subsections freely. Keep it short;
setup and CI plumbing belongs in the repo, not on a results page. -->

### [Against hand-written code](@id benchmarks-hand-written)

The aim is to be as fast as hand-written code with hand-written adjoints.
Each tutorial's model is timed against a hand-written loop of the same model, differentiated by the same backend.
The table gives the loop's minimum time over the package's, so above 1 the package is faster and below 1 it is slower.

```@example benchmarks
using ComposableRecurrences # hide
include(joinpath(pkgdir(ComposableRecurrences), "docs", "performance.jl")) # hide
performance_table()
```

Reverse-mode gradients gain most, because the package's own adjoints replace differentiating the loop.
The forward run and ForwardDiff use no adjoints, so they are near the loop's speed and slower than it on several models.
Every cell below 1, on any target, is a case where the package is slower.
[Issue #417](https://github.com/EpiAware/ComposableRecurrences.jl/issues/417) tracks the slower cases and [issue #506](https://github.com/EpiAware/ComposableRecurrences.jl/issues/506) forward-mode adjoints.

The second table compares the package's Mooncake gradient with Mooncake on the same loop given hand-written Mooncake adjoints:

```@example benchmarks
performance_table(; reference = :hand_rules)
```

Each row names its case in `test/ADFixtures/src/matrix_cases.jl`, timed at the docs tier, and `task -t benchmark/Taskfile.yml matrix-docs` regenerates `benchmark/results/docs.csv`, which these tables read.
The [AD comparison](@ref ad-comparison) times the gradient of every scenario in the AD test registry on each backend.

### The suite

`ComposableRecurrences` benchmarks its core operations to track performance over time.

The "AD gradients" group times the gradient of each scenario in the package's AD test registry on each backend the package targets: ForwardDiff, and Enzyme and Mooncake in forward and reverse mode.
The AD tests also run ReverseDiff, but the suite does not time it.
Scenarios declared broken or skipped for a backend are left out of that backend's rows.
The "Evaluation" group times the forward run of each benchmark matrix case at its CI size.
Each matrix case also has gradient rows on the reverse-mode backends, once as users call the operator and once, prefixed "NoAdjoint", with any hand-written adjoint bypassed.

Each entry takes one evaluation per sample for up to a second, so a single history point is indicative rather than exact.

Run the suite locally with `julia --project=benchmark benchmark/run.jl`.
