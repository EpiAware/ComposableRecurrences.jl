<!-- PACKAGE-OWNED — your benchmark narrative. scaffold writes this once and
never overwrites it. The managed build splices this file verbatim into the
generated `docs/src/benchmarks/over-time.md`, at the FOOT of the page under an
"## About these benchmarks" heading. The page itself is a presentation of
results — a summary across the package, then one section per suite — so this
is the supporting material a reader wants after the numbers, not before them:
what the suite covers, how to run it locally, and anything needed to read the
history correctly. Add your own `## ...` subsections freely. Keep it short;
setup and CI plumbing belongs in the repo, not on a results page. -->

`ComposableRecurrences` benchmarks its core operations to track performance over time.

The "AD gradients" group times the gradient of each scenario in the package's AD test registry on each backend the package targets: ForwardDiff, and Enzyme and Mooncake in forward and reverse mode.
The AD tests also run ReverseDiff, but the suite does not time it.
Scenarios declared broken or skipped for a backend are left out of that backend's rows.
The "Evaluation" group times the forward run of each benchmark matrix case at its CI size.
Each matrix case also has gradient rows on the reverse-mode backends, once as users call the operator and once, prefixed "NoAdjoint", with any hand-written adjoint bypassed.

Each entry takes one evaluation per sample for up to a second, so a single history point is indicative rather than exact.

Run the suite locally with `julia --project=benchmark benchmark/run.jl`.
