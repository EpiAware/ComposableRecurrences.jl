# [Testing and benchmarking](@id testing)

This page covers the tools for checking a new modifier, coupling or depletion form, and for timing the package.

## Conformance with `PieceInterface`

Test a new type against [`PieceInterface`](@ref ComposableRecurrences.PieceInterface), which lists the checks and the `Arguments` form.

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

## [Comparing with plain automatic differentiation](@id rule-policy)

[`NoAdjoint`](@ref ComposableRecurrences.NoAdjoint) gives the plain automatic differentiation gradient to compare with.

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
A hand-written rule is kept only where it beats plain automatic differentiation, its [`NoAdjoint`](@ref ComposableRecurrences.NoAdjoint) twin, by about 10% in reverse mode on Mooncake or Enzyme.
Where it does not, [`uses_adjoint`](@ref ComposableRecurrences.uses_adjoint) is `false` for that operator or modifier, so dispatch sends the operator to plain automatic differentiation.
This route does not depend on the backend, so a rule that wins on one backend and loses on the other runs on both.
The table gives the rule time over the `NoAdjoint` time, from matrix cases at `T` 200 and `L` 20 where one covers it, else from the small CI scenarios (marked ¹).
Every rule passes on both backends except the local `ForwardDiff` step of a pointwise modifier without a `pullback!`, timed by the `local` arm below.
It is 1.12 to 1.38 times slower than plain automatic differentiation on Enzyme, and on Mooncake it is within noise or slower at small sizes.

| Rule switched on by | Mooncake reverse | Enzyme reverse | Decision |
|---|---|---|---|
| core recurrence (kernel, `I` or dense coupling) | 0.44 | 0.84 | keep |
| `Depletion`, hazard form | 0.16 | 0.31 | keep |
| `Depletion`, `Floor()`, dense coupling | 0.32 | 0.39 | keep |
| `Depletion` with removals and `Protected` | 0.28 | 0.40 | keep |
| `Redistribute` | 0.26 | 0.32 | keep |
| `Allocate` | 0.78¹ | 0.78¹ | keep |
| `Transform` | 0.18 | 0.43 | keep |
| `Primary()` kernel | 0.51 | 0.66 | keep |
| `Pairwise` kernel | 0.68¹ | 0.61¹ | keep |
| `Diagonal` coupling | 0.84¹ | 0.98¹ | keep |
| sparse coupling | 0.75¹ | plain AD is wrong | keep |
| `TimeVarying` kernel and coupling | 0.71¹ | 0.85¹ | keep |
| `Convolution` | 0.48 | 0.64 | keep |
| pointwise modifier without a `pullback!` | 0.64 | 1.12 | fails on Enzyme |

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
Cases in `LOCAL_CASES` also run a `local` arm, which replaces each pointwise modifier's `pullback!` with the local `ForwardDiff` step.

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
See [`EXECUTOR`](@ref ComposableRecurrences.EXECUTOR) for which passes run threaded under each backend.
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
