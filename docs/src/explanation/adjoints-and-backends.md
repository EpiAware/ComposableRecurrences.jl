# [Adjoints and backends](@id adjoints-backends)

This page says which code runs when an AD backend differentiates an operator call, and how executors interact with each backend.
For which backend to choose, see [Choosing a backend](@ref ad-backends).

## [Rules and plain AD](@id adjoint-routing)

Each operator call takes one of two routes:

- the rule, a reverse pass written for the operator (see the [Mooncake](@ref extension-mooncake) and [Enzyme](@ref extension-enzyme) extensions);
- plain AD, where the backend differentiates the operator's forward loop.

A call takes the rule when [`uses_adjoint(op, Run())`](@ref ComposableRecurrences.uses_adjoint) is `true` and every float it holds is a `Float16`, `Float32` or `Float64`.
These floats may sit in an `Array`, a view or reshape of one, a sparse matrix or a `Diagonal`.
Dual numbers, tracked values, `BigFloat`, abstractly typed fields and other array types take plain AD.
The route is read from types, apart from the [strata](@ref glossary-stratum) limit below.

The rule of a [`Recurrence`](@ref) calls the [`pullback!`](@ref ComposableRecurrences.pullback!) of its coupling and modifiers.
`uses_adjoint` finds a part's `pullback!` from its methods, so writing the method is enough; a method of `uses_adjoint` overrides it.
A part without one is differentiated inside the rule with a local ForwardDiff step where that is cheap; otherwise the whole operator takes plain AD.

| Part without a `pullback!` | Route |
|---|---|
| pointwise modifier or depletion form with only scalar float parameters | rule, local ForwardDiff step |
| pointwise modifier with `PerStratum`, `TimeVarying` or `TimeVarying(PerStratum(x))` parameters read through [`param`](@ref ComposableRecurrences.param) | rule, local ForwardDiff step |
| pointwise modifier or depletion form with another array parameter | plain AD |
| modifier with a vector or blockwise step | plain AD |
| coupling with only scalar float parameters, strata plus scalars at most 12 | rule, local ForwardDiff step |
| the same coupling with 13 to 24 | rule on Mooncake, plain AD on Enzyme |
| the same coupling with more than 24 | plain AD |
| [`Transform`](@ref ComposableRecurrences.Transform) whose map holds floats, with no `derivative` | plain AD |

A modifier with a [`Derived`](@ref) parameter whose map holds floats takes plain AD even with a `pullback!`, as neither reaches those floats.

The local step rebuilds a part with dual numbers in place of its float parameters; [Gradient routes](@ref extending-routes) gives the contract that needs.
Above 12 strata and scalars the local step of a coupling needs more than one pass of dual numbers per step, and above 24 more than two.

The `Recurrence` constructor logs an `@info`, once per operator type, when one of these parts sends the operator to plain AD, naming the coupling, modifier or depletion form that caused it.
A call sent to plain AD by its float or array types logs nothing.

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
ReverseDiff is not a [target](@ref faq-backends).

## [Which rules are kept](@id rule-policy)

A rule is kept only where it beats plain AD, its [`NoAdjoint`](@ref ComposableRecurrences.NoAdjoint) twin, by about 10% in reverse mode on Mooncake or Enzyme.
The route depends on the backend only where the route table above says so; otherwise a rule that wins on one backend and loses on the other runs on both.
The table gives the rule time over the `NoAdjoint` time, from [benchmark matrix](@ref testing) cases at `T` 200 and `L` 20 where one covers it, else from the small CI scenarios (marked ¹).

| Rule switched on by | Mooncake reverse | Enzyme reverse | Decision |
|---|---|---|---|
| core recurrence (kernel, `I` or dense coupling) | 0.44 | 0.84 | keep |
| `Depletion`, hazard form | 0.16 | 0.31 | keep |
| `Depletion`, `Floor()`, dense coupling | 0.32 | 0.39 | keep |
| `Depletion`, `Truncate()`, dense coupling | 0.20³ | 0.24³ | keep |
| `Depletion`, `SoftTruncate(κ)`, dense coupling | 0.20³ | 0.32³ | keep |
| `Depletion` with removals and `Protected` | 0.28 | 0.40 | keep |
| `Redistribute` | 0.26 | 0.32 | keep |
| `Flows` | 0.43 | 0.43 | keep |
| `Depletion` with `Protected` and waning `flows` | 0.40 | 0.32 | keep |
| `Allocate` | 0.78¹ | 0.78¹ | keep |
| `Capacity` | 0.26 | 0.32 | keep |
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
| coupling without a `pullback!`, up to 12 strata and scalars | 0.50² | 0.78² | keep |
| coupling without a `pullback!`, 13 to 24 strata and scalars | 0.64² | 1.46² | keep on Mooncake |

² The worst of 3, 5, 10, 20, 23 and 50 strata within the row's limit, at `T` 200 and `L` 20, for the user types of the `custom_modifier_strata`, `custom_coupling` and `custom_coupling_dense` cases.

³ A local timing, not a matrix case: 5 strata, a dense coupling, `T` 200 and `L` 20.

Every rule in the table is faster than plain AD on both backends, where plain AD is right, except the local step of a pointwise modifier with scalar parameters.
That step is kept for Mooncake, so it also runs on Enzyme, where it is 1.12 to 1.38 times slower than plain AD.
On Mooncake it wins at `T` 200 and `L` 20 but is within noise or slower at small sizes.
A coupling whose cost grows with the strata squared is 1.46 times slower than plain AD on Enzyme at 20 strata, hence the limit of 12 there.
On Mooncake the same coupling is 0.83 times plain AD at 30 strata and 1.08 at 36, hence the limit of 24.
A coupling whose cost grows with the strata alone is 0.23 times plain AD on Mooncake at 50 strata, but the limit sends it to plain AD, so give such a coupling a `pullback!`.

## [Checking a rule](@id adjoint-checks)

[Testing and benchmarking](@ref compare-plain-ad) compares a rule with plain AD through [`NoAdjoint`](@ref ComposableRecurrences.NoAdjoint).
[`test_adjoint`](@ref ComposableRecurrences.test_adjoint) runs a backend's own rule tester on an operator's rule.

## [Executors](@id executors)

An executor sets how an operator's loops over strata, series or output times run.
[`EXECUTOR`](@ref ComposableRecurrences.EXECUTOR) holds the one in use, [`Serial`](@ref ComposableRecurrences.Serial) by default.
[`Threaded`](@ref ComposableRecurrences.Threaded) splits a loop across CPU threads, and [`Device`](@ref ComposableRecurrences.Device) runs it as a kernel on a GPU.
A new executor is a subtype of [`Executor`](@ref ComposableRecurrences.Executor) with a method of [`each!`](@ref ComposableRecurrences.each!).

| Executor | Forward | ForwardDiff | ReverseDiff | Mooncake, Enzyme forward | Mooncake, Enzyme reverse |
|---|---|---|---|---|---|
| `Serial()` | all operators | yes | yes | yes | yes |
| `Threaded()` | all operators | yes, threaded | not tested | yes, serial | rule's forward and reverse passes threaded, all else serial |
| `Device(backend)` | all operators, couplings and built-in modifiers | dual-number inputs only | not tested | not tested | not tested |

Mooncake and Enzyme do not differentiate tasks, so code they trace runs serially whatever executor is set.
A rule's forward pass is not traced, so it uses the set executor.
Its reverse pass splits strata with the executor set when it runs.
Each chunk of strata adds the cotangents of parameters it shares with other chunks, such as a scalar modifier parameter, into its own copy.
The copies are summed after the loop, so these cotangents agree with `Serial()` up to rounding.
The cotangents of the inputs, the history and an `S × T` gain or add input match exactly.
A coupling that mixes strata, a pairwise kernel, routes, modifiers with a vector step and parameters that read across strata run their reverse steps on the calling task.
The `Device(backend)` row was checked on JLArrays only, which run kernels on the CPU; the [`Device`](@ref ComposableRecurrences.Device) docstring says how each part runs on a device.

### [GPU arrays](@id gpu-arrays)

A call on arrays that live on a GPU runs each loop over strata, series or output times as one kernel.
Independent strata are one kernel per call, each thread stepping its stratum through time.
Strata that mix are one kernel per step, with the time loop on the host, so such a recurrence pays a kernel launch per step and a GPU pays off only with many strata or many series.
Every array the call reads must live on the same device: the inputs, the gain and add inputs, the history, a resumed state, the kernel, the coupling and the modifiers' parameters.
A call with device inputs and a host float array among these is an error; move each array to the device first; `Adapt.adapt(CuArray, r)` moves every parameter of an operator `r`.
Buffers, states and outputs are allocated from the inputs, so they live there too.

- Dense and time-varying couplings mix the strata with one `mul!` per step; `I` and `Diagonal` couplings scale each stratum inside the strata kernel.
- A sparse coupling is a device sparse matrix: in CSR form each stratum's row is one index of a kernel.
  Other forms use the array package's own `mul!`, such as CUSPARSE on CUDA; JLArrays has none, so they are not tested.
- Modifiers with a vector step (`Redistribute`, `Allocate` and `Depletion` with a protected pool) run each stratum, or each `Allocate` group, as one index of a kernel; `Allocate` copies its groups to the device each step.
- A modifier or wrapper that holds arrays is rebuilt with its device arrays inside a kernel through Adapt.jl; a new modifier type that holds arrays needs an `Adapt.adapt_structure` method.
  Arrays captured by the function of a `Transform` or `Derived` are not moved.
- A ragged `TimeVarying` kernel (a vector of columns) keeps its column offsets where its values live.
  Columns that live on a device, or `Adapt.adapt`, put both there.

`test/unit/gpu_arrays.jl` runs every operator, coupling and built-in modifier on JLArrays, with scalar indexing disallowed, on every pull request.
On a machine with an NVIDIA GPU, the same checks run on CUDA arrays by hand:

```julia
using CUDA, ComposableRecurrences
CUDA.allowscalar(false)
r = Recurrence(CuArray([0.4, 0.3, 0.2, 0.1]); coupling = CuArray([0.9 0.1; 0.2 0.8]))
y = r(CuArray(fill(1.1, 2, 50)); history = CuArray(ones(2, 4)))
Array(y) ≈ Recurrence([0.4, 0.3, 0.2, 0.1]; coupling = [0.9 0.1; 0.2 0.8])(
    fill(1.1, 2, 50); history = ones(2, 4)
)
```

Gradients through the package's own pullbacks do not run on device arrays yet: the reverse passes index the arrays from the host, and calls on device arrays take plain AD.
On JLArrays no reverse-mode backend gets that far: Enzyme's KernelAbstractions rules have no JLArrays backend, and Mooncake does not differentiate the JLArray allocator.
Dual-number inputs on device arrays give forward-mode derivatives through the device forward pass; `ForwardDiff.gradient` seeds its inputs by scalar indexing, so build the duals directly.
