# [Testing and benchmarking](@id testing)

This page covers the tools for checking a new modifier, coupling or depletion form, and for timing the package.

[Checking a new type](@ref extending-checks) tests a new type's `forward` against [`PieceInterface`](@ref ComposableRecurrences.PieceInterface) and its `pullback!` against ForwardDiff and plain AD.

## [Comparing with plain automatic differentiation](@id compare-plain-ad)

[`NoAdjoint`](@ref ComposableRecurrences.NoAdjoint) gives the plain automatic differentiation route to compare with.

```@example testing
using ComposableRecurrences
using ComposableRecurrences: NoAdjoint, Depletion
using ForwardDiff, Chairmarks

r = Recurrence([0.2, 0.5, 0.3]; modifiers = (Depletion(1000.0),))
loss(op) = R -> sum(op(R; history = fill(5.0, 3)))
R = fill(1.4, 60)
(
    operator = @b(ForwardDiff.gradient($(loss(r)), $R), seconds = 0.2).time,
    no_adjoint = @b(ForwardDiff.gradient($(loss(NoAdjoint(r))), $R), seconds = 0.2).time,
)
```

ForwardDiff runs the same code on both routes, so time a rule on a reverse-mode backend.
[Which rules are kept](@ref rule-policy) gives the policy and the timings behind it.

## The benchmark matrix

`benchmark/matrix.jl` times every case in `test/ADFixtures/src/matrix_cases.jl` at every size of a tier, on the primal run and each gradient backend, with and without `NoAdjoint`.
Each backend runs in its own Julia process.

```bash
task -t benchmark/Taskfile.yml matrix -- --tier=ci --targets=primal
task -t benchmark/Taskfile.yml matrix-rules
task -t benchmark/Taskfile.yml matrix-report -- matrix-results
```

The report lists the median time of every cell, and the gain of each hand-written gradient as the `NoAdjoint` median over the operator's median.
A new case is a `Case` entry in `matrix_cases.jl` whose loss takes a `wrap` argument (`identity` or `NoAdjoint`), so the matrix times both arms.
Cases in `LOCAL_CASES` also run a `local` arm, which replaces the `pullback!` of each pointwise modifier and user coupling with the local `ForwardDiff` step.

`--executor` and `--threads` time the operators under an executor.
`--threads=1,2,4` runs each target once per thread count, and `--executor=threaded` runs the `rule` arm under `Threaded()` (the default is `serial`).
Each run writes `<tier>-<run>.tsv` and `<tier>-<run>.log`, where `<run>` is the target with the thread count and any executor other than serial appended, such as `primal_t4` or `primal_Threaded_t4`.

```bash
task -t benchmark/Taskfile.yml matrix -- --tier=realistic --targets=primal
task -t benchmark/Taskfile.yml matrix -- --tier=realistic --targets=primal \
    --executor=threaded --threads=2,4
```

The report adds an executor table with each threaded run's speed-up over the serial one-thread run of the same target.
Run the serial one-thread run into the same directory first; without it the report says so and leaves the table out.
Serial runs on more than one thread are labelled `<target> @ t<n>` and stay out of the executor table.
[Executors](@ref executors) says which passes run threaded under each backend.
Each row records the load average when its cell started, so a busy machine shows in the results.

## Gradient tests and use-case tests

`test/ADFixtures` holds the scenarios the gradient tests run on every backend, each checked against a ForwardDiff reference.
A scenario is a name, a scalar loss of a flat parameter vector and its starting value, added to `_SCENARIOS`.

```julia
("Recurrence renewal", _renewal, () -> _flat(G0, zeros(L), LOGR[1, :]))
```

Run one backend with `TAG=mooncake_reverse task test-ad-backend`.

`test/usecases` rebuilds real models from modelling packages with the operators and compares values and gradients with reference code in `test/usecases/references`.
Run them with `julia --project=test test/runtests.jl usecase_only`.

## Threads and Reactant in CI

The `Threads` workflow runs the tests with four threads, so `Threaded` loops run on separate threads.
Run `julia --threads=4 --project=test test/runtests.jl skip_quality` to do the same locally.

The Reactant support matrix in `test/reactant/` runs weekly and on `main`, and fails when a cell's status differs from the committed `results.tsv`.
After a change, rerun it on Julia 1.12 from the repository root:

```bash
julia +1.12 --project=test/reactant -e 'using Pkg; Pkg.instantiate()'
julia +1.12 --project=test/reactant --startup-file=no test/reactant/runtests.jl
```

Then commit `results.tsv` and `RESULTS.md` and update `expected.jl`.
The main tests check that these three agree.
