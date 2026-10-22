# [Testing and benchmarking](@id testing)

These tools check a new modifier, coupling or depletion form, and time the package.

[Checking a new type](@ref extending-checks) tests a new type's `forward!` against [`PieceInterface`](@ref ComposableRecurrences.PieceInterface) and its `pullback!` against ForwardDiff and plain AD.

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

Time a rule on a reverse-mode backend; [Backends](@ref adjoint-backends) says why.

## [Rule timings](@id rule-timings)

[Which rules are kept](@ref rule-policy) gives the policy these timings support.
The table gives the rule time over the `NoAdjoint` time, from benchmark matrix cases at `T` 200 and `L` 20 where one covers it, else from the small CI scenarios (marked ¹).

| Rule switched on by | Mooncake reverse | Enzyme reverse | Decision |
|---|---|---|---|
| core recurrence (kernel, `I` or dense coupling) | 0.44 | 0.84 | keep |
| `Depletion`, hazard form | 0.16 | 0.31 | keep |
| `Depletion`, `Floor()`, dense coupling | 0.32 | 0.39 | keep |
| `Depletion`, `Truncate()`, dense coupling | 0.20³ | 0.24³ | keep |
| `Depletion`, `SoftTruncate(κ)`, dense coupling | 0.20³ | 0.32³ | keep |
| `Depletion` with two pools and a count flow | 0.28 | 0.40 | keep |
| `Redistribute` | 0.07 | 0.35 | keep |
| `Depletion` without a draw | 0.43 | 0.43 | keep |
| `Depletion` with two pools and waning | 0.40 | 0.32 | keep |
| `Allocate` | 0.78¹ | 0.78¹ | keep |
| `Allocate` with `imports` and `spill`, 64 strata | 0.05 | 0.11 | keep |
| `Depletion` filled up to a capacity, flows first | 0.26 | 0.32 | keep |
| `Transform` | 0.18 | 0.43 | keep |
| `Primary()` kernel | 0.51 | 0.66 | keep |
| `Pairwise` kernel | 0.68¹ | 0.61¹ | keep |
| `Routes` kernel, dense and sparse routes, 50 strata | 0.11 | plain AD is wrong | keep |
| `Diagonal` coupling | 0.84¹ | 0.98¹ | keep |
| sparse coupling | 0.75¹ | plain AD is wrong | keep |
| `TimeVarying` kernel and coupling | 0.71¹ | 0.85¹ | keep |
| `Convolution` | 0.48 | 0.64 | keep |
| pointwise modifier without a `pullback!` | 0.64 | 1.12 | keep, slower on Enzyme |
| pointwise modifier without a `pullback!`, `PerStratum` parameter | 0.52² | 0.95² | keep |
| coupling without a `pullback!`, up to 24 strata and scalars | 0.47² | 0.96² | keep |
| coupling without a `pullback!`, 25 to 48 strata and scalars | 0.81² | 1.84² | keep on Mooncake |
| pointwise modifier without a `pullback!`, float vector read by time | 0.39⁴ | plain AD | keep on Mooncake |
| coupling without a `pullback!`, holding a matrix | 0.39⁴ | 0.55⁴ | keep |
| `Routes` with a route coupling without a `pullback!`, up to 24 strata and scalars | 0.35⁵ | 0.83⁵ | keep |
| the same with 25 to 48 strata and scalars | 0.59⁵ | plain AD | keep on Mooncake |

² The worst within the row's limit, at `T` 200 and `L` 20, for the user types of the `custom_modifier_strata`, `custom_coupling` and `custom_coupling_dense` cases.
The modifier was timed at 3, 5, 10, 20, 23 and 50 strata, the couplings at 5, 13, 20, 23, 26, 30, 36, 40 and 44.

³ A local timing, not a matrix case: 5 strata, a dense coupling, `T` 200 and `L` 20.

⁴ The worst within the route's limit, at `T` 200 and `L` 20, for the user types of the `custom_modifier_vector` and `custom_coupling_matrix` cases.
The modifier was timed at 1, 5 and 20 strata, the coupling at 2 to 5.
On Enzyme the modifier's local step was 1.6 to 1.7 times plain AD at 1 and 5 strata, so it takes plain AD there.

⁵ A local timing, not a matrix case: the worst within the row's limit against plain AD of the same model, at `T` 100 and `L` 6.
The model has two routes, a dense user coupling with one scalar and a dense matrix.
It was timed at 5, 11, 20, 22 and 23 strata, one pass, and at 30, 46 and 47, two passes.
At 60 strata the call takes plain AD, within noise of the time before: 1.02 times it on Mooncake and 0.98 on Enzyme.

Every rule in the table is faster than plain AD on both backends, where plain AD is right, except the local step of a pointwise modifier with scalar parameters.
That step is kept for Mooncake, so it also runs on Enzyme, where it is 1.12 to 1.38 times slower than plain AD.
On Mooncake it wins at `T` 200 and `L` 20 but is within noise or slower at small sizes.
The limits sit where a coupling whose cost grows with the strata squared stops beating plain AD, with 24 inputs per pass.
On Enzyme it is 0.96 times plain AD at 23 strata, one pass, and 1.58 at 26, two passes.
On Mooncake it is 0.77 at 44 strata, two passes, and 1.08 at 50, three.
A coupling whose cost grows with the strata alone is 0.23 times plain AD on Mooncake at 50 strata, but the limit sends it to plain AD, so give such a coupling a `pullback!`.

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
The `bvd_renewal`, `bvd_patches` and `bvd_delay` cases run in the `realistic` and `docs` tiers; the [backend case study](@ref tutorial-backend-case-study) builds the model they time.
They add a `loop` arm, a hand loop in the style of the BVDOutbreakSize backend, and a `handrule` arm, the same loop with the hand-written Mooncake rules in `benchmark/bvd_handrule.jl`.
The `handrule` arm runs on Mooncake reverse only, since on any other target it is the `loop` arm.

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
