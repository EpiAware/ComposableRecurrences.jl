# [Testing and benchmarking](@id testing)

This page covers the tools for checking a new modifier, coupling or depletion form, and for timing the package.

## Conformance with `PieceInterface`

`PieceInterface` declares, with Interfaces.jl, what a `forward` method must do for each job.
Test a new type by passing one `Arguments(; piece, role, args)` object per job it supports.

```@example testing
using ComposableRecurrences
using ComposableRecurrences: PieceInterface, Step
using Interfaces: Interfaces, Arguments

struct Scale
    a::Float64
end
ComposableRecurrences.ispointwise(::Scale) = true
ComposableRecurrences.forward(m::Scale, ::Step, v, s, t, k) = (m.a * v, s)

Interfaces.test(
    PieceInterface, Scale,
    [Arguments(; piece = Scale(0.9), role = Step(), args = ([1.0, 2.0], [0.0, 0.0], 1))]
)
```

The mandatory check runs `forward` and confirms it keeps to the job's conventions.
The optional `pointwise` check confirms that the step for all series matches the step for one value.

## Comparing with plain automatic differentiation

`NoAdjoint(op)` is called like `op`, but an automatic differentiation backend differentiates its forward loop instead of any hand-written gradient.
Comparing the two checks a gradient and shows what the hand-written one saves.

```@example testing
using ComposableRecurrences: NoAdjoint, Depletion
using ForwardDiff, Chairmarks

r = Recurrence([0.2, 0.5, 0.3]; modifiers = (Depletion(1000.0),))
loss(op) = R -> sum(op(R; history = fill(5.0, 3)))
R = fill(1.4, 60)
maximum(abs, ForwardDiff.gradient(loss(r), R) .- ForwardDiff.gradient(loss(NoAdjoint(r)), R))
```

```@example testing
(
    operator = @b(ForwardDiff.gradient($(loss(r)), $R), seconds = 0.2).time,
    no_adjoint = @b(ForwardDiff.gradient($(loss(NoAdjoint(r))), $R), seconds = 0.2).time,
)
```

ForwardDiff differentiates the same forward code in both, so a hand-written gradient only matters on a reverse-mode backend such as Mooncake or Enzyme.
A hand-written gradient is worth keeping when it is about 10% faster than plain automatic differentiation on the backend it targets.

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
On Enzyme and Mooncake reverse mode the rule's forward pass runs under the executor and its reverse pass runs serially, so their threaded rows speed up only the forward pass.
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
