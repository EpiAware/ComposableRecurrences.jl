# [Adjoints and backends](@id adjoints-backends)

This page says which code runs when an AD backend differentiates an operator call, and how executors interact with each backend.
For which backend to choose, see [Choosing a backend](@ref ad-backends).

## [Rules and plain AD](@id adjoint-routing)

Each operator call takes one of two routes:

- the rule, a reverse pass written for the operator, which the [Mooncake](@ref extension-mooncake) and [Enzyme](@ref extension-enzyme) extensions register with those backends;
- plain AD, where the backend differentiates the operator's forward loop.

A call takes the rule when [`uses_adjoint(op, Run())`](@ref ComposableRecurrences.uses_adjoint) is `true` and every float it holds is a `Float16`, `Float32` or `Float64`.
These floats may sit in an `Array`, a view or reshape of one, a sparse matrix or a `Diagonal`.
Dual numbers, tracked values, `BigFloat`, abstractly typed fields and other array types take plain AD.
The route is read from types, apart from the rebuild check and the strata limit below.

The rule of a [`Recurrence`](@ref) calls the [`pullback!`](@ref ComposableRecurrences.pullback!) of its coupling and modifiers.
A part without one is differentiated inside the rule with a local ForwardDiff step where that is cheap; otherwise the whole operator takes plain AD.

| Part without a `pullback!` | Route |
|---|---|
| pointwise modifier or depletion form with only scalar float parameters | rule, local ForwardDiff step |
| pointwise modifier or depletion form with a `PerStratum`, `TimeVarying` or array parameter | plain AD |
| modifier with a vector step | plain AD |
| coupling with only scalar float parameters, strata plus scalars at most 12 | rule, local ForwardDiff step |
| the same coupling with more than 12 | plain AD |
| [`Transform`](@ref ComposableRecurrences.Transform) whose map holds floats, with no `derivative` | plain AD |
| part that the local step cannot rebuild from its parameters | plain AD |

A modifier with a [`Derived`](@ref) parameter whose map holds floats takes plain AD even with a `pullback!`, as neither reaches those floats.

The local step rebuilds a part with dual numbers in place of its float parameters; [Adding a modifier](@ref extending) lists what that needs.
The `Recurrence` constructor checks the rebuild once and stores the result.
Above 12 strata and scalars the local step of a coupling needs more than one pass of dual numbers per step.

Under Mooncake or Enzyme reverse mode, the first call of each operator type that one of these parts sends to plain AD logs an `@info` saying why.
A `NoAdjoint` call, or one sent to plain AD by its float or array types, logs nothing.

## [Backends](@id adjoint-backends)

| Backend | Rule | Plain AD |
|---|---|---|
| ForwardDiff | never | always, on dual numbers |
| ReverseDiff | never | always, on tracked values |
| Mooncake forward | never | always |
| Enzyme forward | never | always |
| Mooncake reverse | when the call takes the rule | otherwise |
| Enzyme reverse | when the call takes the rule | otherwise |

Forward-mode backends run the same forward code on both routes, so a rule only changes the cost of reverse mode.
ReverseDiff runs in the AD tests but is not a target.

## [Which rules are kept](@id rule-policy)

A rule is kept only where it beats plain AD, its [`NoAdjoint`](@ref ComposableRecurrences.NoAdjoint) twin, by about 10% in reverse mode on Mooncake or Enzyme.
The route does not depend on the backend, so a rule that wins on one backend and loses on the other runs on both.
The table gives the rule time over the `NoAdjoint` time, from [benchmark matrix](@ref testing) cases at `T` 200 and `L` 20 where one covers it, else from the small CI scenarios (marked ¹).

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
| pointwise modifier without a `pullback!` | 0.64 | 1.12 | keep, slower on Enzyme |
| coupling without a `pullback!`, up to 12 strata and scalars | 0.64² | 0.68² | keep |

² The worst of 3 and 10 strata for a user type, at `T` 200 and `L` 20.

Every rule in the table is faster than plain AD on both backends, where plain AD is right, except the local step of a pointwise modifier.
That step is kept for Mooncake, so it also runs on Enzyme, where it is 1.12 to 1.38 times slower than plain AD.
On Mooncake it wins at `T` 200 and `L` 20 but is within noise or slower at small sizes.
A coupling whose cost grows with the strata squared was 1.7 to 4 times slower than plain AD on Enzyme from 16 strata, hence the limit of 12.

## [Checking a rule](@id adjoint-checks)

[`NoAdjoint(op)`](@ref ComposableRecurrences.NoAdjoint) sends every call of `op` to plain AD, to compare gradients and times with the rule.
[Testing and benchmarking](@ref compare-plain-ad) shows how.
[`test_adjoint`](@ref ComposableRecurrences.test_adjoint) runs a backend's own rule tester on an operator's rule.

## [Executors](@id executors)

An executor sets how an operator's loops over strata, series or output times run.
[`EXECUTOR`](@ref ComposableRecurrences.EXECUTOR) holds the one in use, [`Serial`](@ref ComposableRecurrences.Serial) by default.
[`Threaded`](@ref ComposableRecurrences.Threaded) splits a loop across CPU threads, and [`Device`](@ref ComposableRecurrences.Device) runs it as a kernel on a GPU.
A new executor is a subtype of [`Executor`](@ref ComposableRecurrences.Executor) with a method of [`each!`](@ref ComposableRecurrences.each!).

| Executor | Forward | ForwardDiff | ReverseDiff | Mooncake, Enzyme forward | Mooncake, Enzyme reverse |
|---|---|---|---|---|---|
| `Serial()` | all operators | yes | yes | yes | yes |
| `Threaded()` | all operators | yes, threaded | not tested | yes, serial | rule's forward pass threaded, all else serial |
| `Device(backend)` | convolutions; recurrences with an `I` coupling and no modifiers, `Add` or `Clamp` | not tested | not tested | not tested | not tested |

Mooncake and Enzyme do not differentiate tasks, so code they trace runs serially whatever executor is set.
A rule's forward pass is not traced, so it uses the set executor.
Its reverse pass runs on the calling task, because it adds every stratum's terms into shared kernel and parameter cotangents.
The `Device(backend)` row was checked on JLArrays only; the [`Device`](@ref ComposableRecurrences.Device) docstring lists what does not run on a device.
