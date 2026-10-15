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
The route is read from types, apart from the rebuild check and the [strata](@ref glossary-stratum) limit below.

The rule of a [`Recurrence`](@ref) calls the [`pullback!`](@ref ComposableRecurrences.pullback!) of its coupling and modifiers.
It runs the step of the [API overview](@ref api-overview) backwards in time.
That step computes ``p_t = \sum_{l} k_l \, y_{t-l}`` from the kernel ``k``, then ``v_t = g_t \odot C_t \, p_t + a_t`` from the gain ``g_t``, the coupling ``C_t`` and the `add` ``a_t``.
The modifiers then map ``v_t`` to the output ``y_t``.
With ``\bar x`` the cotangent of ``x``, each step from `stop` down to `start` computes

```math
\begin{aligned}
\big(\bar v_t,\ \bar s_{t-1}\big) &= M^{*}_t\big(\bar y_t,\ \bar s_t\big), \\
\bar g_t &= \bar v_t \odot C_t \, p_t, \qquad \bar a_t = \bar v_t, \\
\bar p_t &= C_t^{\top} \big(g_t \odot \bar v_t\big), \qquad
\bar C_t = \big(g_t \odot \bar v_t\big) \, p_t^{\top}, \\
\bar y_{t-l} &\mathrel{+}= k_l \, \bar p_t, \qquad
\bar k_l \mathrel{+}= \bar p_t^{\top} y_{t-l}, \qquad l = 1, \dots, L,
\end{aligned}
```

where ``s_t`` is the modifiers' state and ``M^{*}_t`` their `pullback!` methods in reverse tuple order.
``\bar y_t`` holds the cotangent of the output plus what later steps added to it.
The coupling's `pullback!` for [`Pressure()`](@ref ComposableRecurrences.Pressure) gives ``\bar p_t`` and ``\bar C_t``.
The last line is for a kernel shared by every series.
`uses_adjoint` finds a part's `pullback!` from its methods, so writing the method is enough; a method of `uses_adjoint` overrides it.
A part without one is differentiated inside the rule with a local ForwardDiff step where that is cheap; otherwise the whole operator takes plain AD.

| Part without a `pullback!` | Route |
|---|---|
| pointwise modifier or depletion form with only scalar float parameters | rule, local ForwardDiff step |
| pointwise modifier with `PerStratum`, `TimeVarying` or `TimeVarying(PerStratum(x))` parameters read through [`param`](@ref ComposableRecurrences.param) | rule, local ForwardDiff step |
| pointwise modifier with other float arrays, or views of them, that its step indexes | rule on Mooncake, plain AD on Enzyme |
| pointwise modifier with a `Diagonal`, sparse or other structured float array, or a depletion form with any array parameter | plain AD |
| modifier with a vector or blockwise step | plain AD |
| coupling with float scalars and float arrays, strata plus scalars and array entries at most 24 | rule, local ForwardDiff step |
| the same coupling with 25 to 48 | rule on Mooncake, plain AD on Enzyme |
| the same coupling with more than 48 | plain AD |
| coupling with a `Diagonal`, sparse or other structured float array | plain AD |
| [`Transform`](@ref ComposableRecurrences.Transform) whose map holds floats, with no `derivative` | plain AD |
| part that the local step cannot rebuild from its parameters | plain AD |

A modifier with a [`Derived`](@ref) parameter whose map holds floats takes plain AD even with a `pullback!`, as neither reaches those floats.

The local step rebuilds a part with dual numbers in place of its float parameters; [What the local step needs](@ref adjoint-local-step) lists the conditions.
The `Recurrence` constructor checks the rebuild once and stores the result.
Each limit on a coupling's strata and scalars is where its local step needs one more pass of dual numbers per step.

The `Recurrence` constructor logs an `@info` when one of these parts sends the operator to plain AD, naming the part and the reason.
It logs each message once per session, whatever the number types.
A call sent to plain AD by its number of strata, or by its float or array types, logs nothing.

### [What the local step needs](@id adjoint-local-step)

Give each float field a type parameter, as `struct Smooth{A}; a::A; end`, since an abstractly typed field takes plain AD.

The local step rebuilds the type with dual numbers through `ConstructionBase.constructorof`, from its fields in order.
Its type parameters must let a float field hold a dual number, and the constructor must keep its arguments as given.
So these send the operator to plain AD: a closure that captures a float, a keyword-only constructor, a float field typed `Float64`, or a constructor that changes its arguments.
Integer fields, index ranges and integer arrays are structure, not parameters.
Add a `ConstructionBase.constructorof` method for a type whose positional constructor differs.

The local step of a pointwise modifier passes a `PerStratum` or `TimeVarying` parameter as the one entry the step reads at its stratum and time.
So the step must read it through `param` at its own `k` and `t`, as `param(m.κ, k, t)`.
A step that indexes the array sends the operator to plain AD, and one that reads another stratum or time gets the wrong entry, so such a step needs a `pullback!`.
A coupling over more strata than the route table allows needs a `pullback!` to take the rule.

The local step of a pointwise modifier seeds the entries of its other float arrays that a step reads, as `m.a[t]`, and records which they are.
A step that reads more than four entries takes a Jacobian in every entry instead, which is slower.
The local step of a coupling seeds every entry of its float arrays, so they count towards its limit.
A `Diagonal` or sparse matrix is not seeded, as a step may read its fields rather than its entries.

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
The targets are ForwardDiff, Mooncake and Enzyme.
The AD tests also run ReverseDiff, which is not a target, so the README shows coverage badges for it.
The [AD comparison](@ref ad-comparison) page compares the gradient times.

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
| `Allocate` with `imports` and `spill`, 64 strata | 0.05 | 0.11 | keep |
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
| coupling without a `pullback!`, up to 24 strata and scalars | 0.47² | 0.96² | keep |
| coupling without a `pullback!`, 25 to 48 strata and scalars | 0.81² | 1.84² | keep on Mooncake |
| pointwise modifier without a `pullback!`, float vector read by time | 0.39⁴ | plain AD | keep on Mooncake |
| coupling without a `pullback!`, holding a matrix | 0.39⁴ | 0.55⁴ | keep |

² The worst within the row's limit, at `T` 200 and `L` 20, for the user types of the `custom_modifier_strata`, `custom_coupling` and `custom_coupling_dense` cases.
The modifier was timed at 3, 5, 10, 20, 23 and 50 strata, the couplings at 5, 13, 20, 23, 26, 30, 36, 40 and 44.

³ A local timing, not a matrix case: 5 strata, a dense coupling, `T` 200 and `L` 20.

⁴ The worst within the route's limit, at `T` 200 and `L` 20, for the user types of the `custom_modifier_vector` and `custom_coupling_matrix` cases.
The modifier was timed at 1, 5 and 20 strata, the coupling at 2 to 5.
On Enzyme the modifier's local step was 1.6 to 1.7 times plain AD at 1 and 5 strata, so it takes plain AD there.

Every rule in the table is faster than plain AD on both backends, where plain AD is right, except the local step of a pointwise modifier with scalar parameters.
That step is kept for Mooncake, so it also runs on Enzyme, where it is 1.12 to 1.38 times slower than plain AD.
On Mooncake it wins at `T` 200 and `L` 20 but is within noise or slower at small sizes.
The limits sit where a coupling whose cost grows with the strata squared stops beating plain AD, with 24 inputs per pass.
On Enzyme it is 0.96 times plain AD at 23 strata, one pass, and 1.58 at 26, two passes.
On Mooncake it is 0.77 at 44 strata, two passes, and 1.08 at 50, three.
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
