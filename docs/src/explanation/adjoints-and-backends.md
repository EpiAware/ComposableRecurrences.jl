# [Adjoints and backends](@id adjoints-backends)

[Forward mode](@ref ad-backends) costs one pass per parameter, so it suits a model with few parameters, and reverse mode one with many.

## [Rules and plain AD](@id adjoint-routing)

Each operator call takes one of two routes:

- the rule, a reverse pass written for the operator, which the [Mooncake](@ref extension-mooncake) and [Enzyme](@ref extension-enzyme) extensions register;
- plain AD, where the backend differentiates the operator's forward loop.

A call takes the rule when [`uses_adjoint(op, Run())`](@ref ComposableRecurrences.uses_adjoint) is `true` and every float it holds is a `Float16`, `Float32` or `Float64`.
These floats may sit in an `Array`, a view or reshape of one, a sparse matrix or a `Diagonal`.
Dual numbers, tracked values, `BigFloat`, abstractly typed fields and other array types take plain AD.
The route is read from types, apart from the rebuild check and the [strata](@ref overview-step) limit below.

The rule of a [`Recurrence`](@ref) calls the [`pullback!`](@ref ComposableRecurrences.pullback!) of its coupling and modifiers.
It runs the step of the [API overview](@ref api-overview) backwards in time.
That step computes ``p_t = \sum_{l} k_l \, y_{t-l}`` from the kernel ``k``, then ``v_t = \gamma_t \odot K_t \, p_t + a_t`` from the gain ``\gamma_t``, the coupling ``K_t`` and the `add` ``a_t``.
The modifiers then map ``v_t`` to the output ``y_t``.
With ``\bar x`` the cotangent of ``x``, each step from `stop` down to `start` computes

```math
\begin{aligned}
\big(\bar v_t,\ \bar s_{t-1}\big) &= M^{*}_t\big(\bar y_t,\ \bar s_t\big), \\
\bar \gamma_t &= \bar v_t \odot K_t \, p_t, \qquad \bar a_t = \bar v_t, \\
\bar p_t &= K_t^{\top} \big(\gamma_t \odot \bar v_t\big), \qquad
\bar K_t = \big(\gamma_t \odot \bar v_t\big) \, p_t^{\top}, \\
\bar y_{t-l} &\mathrel{+}= k_l \, \bar p_t, \qquad
\bar k_l \mathrel{+}= \bar p_t^{\top} y_{t-l}, \qquad l = 1, \dots, L,
\end{aligned}
```

where ``s_t`` is the modifiers' state and ``M^{*}_t`` their `pullback!` methods in reverse tuple order.
``\bar y_t`` holds the cotangent of the output plus what later steps added to it.
The coupling's `pullback!` for [`Pressure()`](@ref ComposableRecurrences.Pressure) gives ``\bar p_t`` and ``\bar K_t``.
The last line is for a kernel shared by every stratum.
`uses_adjoint` finds a part's `pullback!` from its methods, so writing the method is enough; a method of `uses_adjoint` overrides it.
A part without one is differentiated inside the rule with a local ForwardDiff step where that is cheap; otherwise the whole operator takes plain AD.

| Part without a `pullback!` | Route |
|---|---|
| pointwise modifier or depletion form with only scalar float parameters | rule, local ForwardDiff step |
| pointwise modifier with `PerStratum`, `TimeVarying` or `TimeVarying(PerStratum(x))` parameters read through [`param`](@ref ComposableRecurrences.param) | rule, local ForwardDiff step |
| pointwise modifier with other float arrays, or views of them, that its step indexes, at most 24 entries a step | rule, local ForwardDiff step |
| pointwise modifier with a `Diagonal`, sparse or other structured float array, or a depletion form with any array parameter | plain AD |
| whole-step modifier (neither pointwise nor blockwise) with float scalars and float arrays, its values, state and parameters at most 24, counting only the entries a step reads for one that reads fewer than its arrays hold | rule, local ForwardDiff step |
| the same with 25 to 48 | rule on Mooncake, plain AD on Enzyme |
| the same with more than 48 | plain AD |
| blockwise modifier with float scalars and `PerStratum`, `TimeVarying` or `TimeVarying(PerStratum(x))` parameters read through `param` at its group | rule, local ForwardDiff step per group |
| blockwise modifier with other float arrays | plain AD |
| coupling with float scalars and float arrays, strata plus scalars and array entries at most 24 | rule, local ForwardDiff step |
| the same coupling with 25 to 48 | rule on Mooncake, plain AD on Enzyme |
| the same coupling with more than 48 | plain AD |
| coupling with a `Diagonal`, sparse or other structured float array | plain AD |
| coupling, or whole-step modifier with no state of its own, declared linear with [`islinear`](@ref ComposableRecurrences.islinear) | rule, the matrix its `forward!` gives, built once per call outside the rule |
| [`Pairwise`](@ref) route coupling | as a coupling, the widest route coupling setting the call's route |
| [`Transform`](@ref ComposableRecurrences.Transform) whose map holds floats, with no `derivative` | plain AD |
| part that the local step cannot rebuild from its parameters | plain AD |

A modifier with a [`Derived`](@ref ComposableRecurrences.Derived) parameter whose map holds floats takes plain AD even with a `pullback!`, as neither reaches those floats.
An operator whose kernel is a `Derived` with such a map takes plain AD for the same reason.

The [local step](@ref adjoint-local-step) rebuilds a part with dual numbers in place of its float parameters.
The `Recurrence` constructor checks the rebuild once and stores the result.
Each limit on a coupling's strata and scalars is where its local step needs one more pass of dual numbers per step.

The `Recurrence` constructor logs an `@info` when one of these parts sends the operator to plain AD, naming the part and the reason.
It logs each message once per session, whatever the number types.
A call sent to plain AD by its number of strata, or by its float or array types, logs nothing.

### [What the local step needs](@id adjoint-local-step)

#### ForwardDiff

The local step needs `using ForwardDiff`, which the package loads only as an [extension](@ref extension-forwarddiff).
Without it:

- the forward pass runs, and a gradient through the local step throws an `ArgumentError` that names the part and says to load ForwardDiff;
- a part that the local step cannot rebuild also throws, rather than taking plain AD, as the check itself needs ForwardDiff.

A `Recurrence` built before ForwardDiff loads checks its parts at each call rather than once at construction.

#### Types it can rebuild

The local step rebuilds a type with dual numbers through `ConstructionBase.constructorof`, from its fields in order.
For that:

- give each float field a type parameter, as `struct Smooth{A}; a::A; end`, so that it can hold a dual number;
- let the constructor keep its arguments as given.

These send the operator to plain AD:

- a float field typed abstractly or as `Float64`;
- a closure that captures a float;
- a keyword-only constructor;
- a constructor that changes its arguments.

Integer fields, index ranges and integer arrays are structure, not parameters.
Add a `ConstructionBase.constructorof` method for a type whose positional constructor differs.

#### Parameters read with `param`

A pointwise modifier's local step passes a `PerStratum` or `TimeVarying` parameter as the one entry the step reads at its stratum and time.
So the step must read it at its own `k` and `t`, as `param(m.κ, k, t)`:

- a step that indexes the array sends the operator to plain AD;
- a step that reads another stratum or time gets the wrong entry, so it needs a `pullback!`.

A blockwise modifier's local step does the same for each group.
It seeds the group's values, its state and the entries its parameters read at group `g`, as `param(m.a, g, t)`.
So its dual numbers are as wide as one group, whatever the number of strata.

#### Other float arrays

What the local step seeds:

- a pointwise modifier: the entries of its other float arrays that a step reads, as `m.a[t]`;
- a whole-step modifier: the step's values and state, and every scalar and array entry of its parameters;
- a whole-step modifier whose step reads fewer entries of a strided float array outside `PerStratum` and `TimeVarying` than it holds, as `m.total[t]`: only the entries read, as for a pointwise modifier;
- a coupling: every entry of its float arrays;
- a `Diagonal` or sparse matrix: nothing, as a step may read its fields rather than its entries.

How the reads are counted:

- for a pointwise modifier, the `Recurrence` constructor runs one step at the first stratum and time;
- for a whole-step modifier, each call runs one step at each of the first two times;
- a whole-step modifier that reads a different number of entries at each, as a step that sums every entry up to `t`, seeds every entry instead.

The seeded entries set the passes of dual numbers:

- up to four reads take one pass;
- more run once more with room for 8 or 12;
- past 12, the step runs in passes of 12.

A step that reads more at a later time than when counted still gets the right gradient, in more passes.

The limits:

- a pointwise modifier with more than 24 reads takes plain AD, which is then faster, and the constructor says so;
- a coupling or whole-step modifier whose entries need a second pass takes the rule on Mooncake and plain AD on Enzyme, where the rule is slower than plain AD;
- past two passes it takes plain AD on every backend;
- a coupling over more strata than the route table allows needs a `pullback!` to take the rule.

#### Ties and kinks

The local step's dual numbers, and those of a `Transform` without a `derivative`, compare by value only, as plain floats do.
So at a tie, such as `x > 0 ? y / x : zero(x)` at `x = 0`, the local step takes the branch the step takes.

ForwardDiff and the backends have derivative rules of their own for some functions, and such a rule picks the side of the function's kink.
So the local step and plain AD can differ there, as for `abs` at zero and, on Mooncake, `clamp` at a bound.

## [Backends](@id adjoint-backends)

| Backend | Rule | Plain AD |
|---|---|---|
| ForwardDiff | never | always, on dual numbers |
| ReverseDiff | never | always, on tracked values |
| Mooncake forward | never | always |
| Enzyme forward | never | always |
| Mooncake reverse | when the call takes the rule | otherwise |
| Enzyme reverse | when the call takes the rule | otherwise |
| [Reactant](@ref extension-reactant) (Enzyme reverse inside its `@compile`) | never | always, on the traced program |

Forward-mode backends run the same forward code on both routes, so a rule only changes the cost of reverse mode.
The targets are ForwardDiff, Mooncake and Enzyme.
The AD tests also run ReverseDiff, which is not a target; the README's coverage badges include it because those tests run.

Reactant traces a call into one compiled program and Enzyme differentiates that program, so the package's rules never run under it.
DifferentiationInterface has no Reactant extension, so Reactant is not one of the AD jobs.
Its own suite, `test/reactant/`, compiles every scenario of the AD registry forward and in reverse and checks each against ForwardDiff, entry by entry.
The [support matrix](https://github.com/EpiAware/ComposableRecurrences.jl/blob/main/test/reactant/RESULTS.md) gives each scenario's result.
The scenarios that do not run are listed in the registry under the `Reactant` backend, grouped by cause.
Most are parts built from traced values, such as sparse couplings, ragged kernels and delay masses, or traces recorded into a traced buffer.
A model that does not run under Reactant runs as it is on the other backends, so Enzyme reverse is the fallback for its gradient.

## [Which rules are kept](@id rule-policy)

A rule is kept only where it beats plain AD, its [`NoAdjoint`](@ref ComposableRecurrences.NoAdjoint) twin, by about 10% in reverse mode on Mooncake or Enzyme; it then runs on both, unless the route table above splits by backend.
The [rule timings](@ref rule-timings) are each rule's time over its twin's, at `T` 200 and `L` 20 where a benchmark case covers it.

`NoAdjoint` turns off the operator's rules, so its call is differentiated as the forward loop, with two deliberate exceptions inside the call.

- Under Mooncake, two BLAS overlays stay: a convolution adds each lag with `axpy!`, which Mooncake differentiates with its own rule.
  Without them Mooncake's plain AD of a convolution is 1.3 to 3.1 times slower.
- Under Enzyme, a sparse route coupling's pressure is differentiated by the coupling's own `pullback!`.
  Plain AD reaches it under `NoAdjoint`, and in the default route when `Pairwise` routes with a route coupling without a `pullback!` take plain AD on Enzyme; without the rule that default route is 3 to 4 times slower.

Rules for building parts before the call, the masses of a chain of delays and the movement of `Redistribute(K, ε)`, are not the operator's and stay too.

## [Checking a rule](@id adjoint-checks)

A rule is checked against [plain AD](@ref compare-plain-ad) through its [`NoAdjoint`](@ref ComposableRecurrences.NoAdjoint) twin.
With Mooncake, or Enzyme and EnzymeTestUtils, loaded, [`ComposableRecurrences.test_adjoint`](@ref) runs that backend's own rule tester on an operator's rule; the [Mooncake](@ref extension-mooncake) and [EnzymeTestUtils](@ref extension-enzyme-test-utils) extensions add it.

## [Executors](@id executors)

An executor sets how an operator's loops over strata or output times run.
[`EXECUTOR`](@ref ComposableRecurrences.EXECUTOR) holds the one in use, [`Serial`](@ref ComposableRecurrences.Serial) by default.
[`Threaded`](@ref ComposableRecurrences.Threaded) splits a loop across CPU threads, and [`Parallel`](@ref ComposableRecurrences.Parallel) runs it as a kernel on a KernelAbstractions backend, such as a GPU.
The older name [`Device(backend)`](@ref ComposableRecurrences.Device) makes the same executor as `Parallel(backend)`.

The threaded executor runs its chunks as Julia tasks rather than on the KernelAbstractions CPU backend, which compiles kernels through OpenCL:

- on that backend a loop body follows the rules of a GPU kernel, and an error inside it loses its type;
- it was also slower: at 10 000 independent strata it ran 1.36 times faster than `Serial` forward and 1.05 times in reverse, against 1.63 and 1.60 for `Threaded`.

| Executor | Forward | ForwardDiff | ReverseDiff | Mooncake, Enzyme forward | Mooncake, Enzyme reverse |
|---|---|---|---|---|---|
| `Serial()` | all operators | yes | yes | yes | yes |
| `Threaded()` | all operators | yes, threaded | not tested | yes, serial | rule's forward and reverse passes threaded, all else serial |
| `Parallel(backend)` | all operators, couplings and built-in modifiers | dual-number inputs only | not tested | not tested | the rules of a fixed convolution and of independent strata; not tested on a GPU |

Mooncake and Enzyme do not differentiate tasks, so code they trace runs serially whatever executor is set.
A rule is different:

- its forward pass is not traced, so it uses the set executor;
- its reverse pass splits strata with the executor set when it runs.

In the reverse pass:

- each chunk of strata adds the cotangents of parameters it shares with other chunks, such as a scalar modifier parameter, into its own copy;
- the copies are summed after the loop, so these cotangents agree with `Serial()` up to rounding;
- the cotangents of the inputs, the history and an `S × T` gain or add input match exactly;
- these run their reverse steps on the calling task:
  - a coupling that mixes strata;
  - a pairwise kernel;
  - routes;
  - modifiers with a vector step;
  - parameters that read across strata.

The `Parallel(backend)` row was checked on JLArrays only, which run kernels on the CPU.

### [GPU arrays](@id gpu-arrays)

A call on arrays that live on a GPU runs each loop over strata or output times as one kernel:

- independent strata are one kernel per call, each thread stepping its stratum through time;
- strata that mix are one kernel per step, with the time loop on the host, so such a recurrence pays a kernel launch per step and a GPU pays off only with many strata.

Every array the call reads must live on the same device: the inputs, the gain and add inputs, the history, a resumed state, the kernel, the coupling and the modifiers' parameters.

- A call with device inputs and a host float array among these is an error.
- `Adapt.adapt(CuArray, r)` moves every parameter of an operator `r` to the device.
- Buffers, states and outputs are allocated from the inputs, so they live there too.

Float types:

- a GPU runs `Float32` much faster than `Float64`;
- an output takes its float type from every array and number a call holds, so a `Float64` scalar parameter, such as a population, promotes the run to `Float64`;
- [`convert_floats(Float32, r)`](@ref ComposableRecurrences.convert_floats) converts every float of `r`, scalars included, so `Adapt.adapt(CuArray, convert_floats(Float32, r))` runs on the device in `Float32`.

- Dense and time-varying couplings mix the strata with one `mul!` per step; `I` and `Diagonal` couplings scale each stratum inside the strata kernel.
- A sparse coupling is a device sparse matrix: in CSR form each stratum's row is one index of a kernel.
  Other forms use the array package's own `mul!`, such as CUSPARSE on CUDA; JLArrays has none, so they are not tested.
- Modifiers with a vector step (`Redistribute`, `Allocate` and a `Depletion` with several pools or without a draw) run each stratum, or each `Allocate` group, as one index of a kernel; `Allocate` copies its groups to the device each step.
- A modifier or wrapper that holds arrays is rebuilt with its device arrays inside a kernel through Adapt.jl; a new modifier type that holds arrays needs an `Adapt.adapt_structure` method.
  Arrays captured by the function of a `Transform` or `Derived` are not moved.
- A ragged `TimeVarying` kernel (a vector of columns) keeps its column offsets where its values live.
  Columns that live on a device, or `Adapt.adapt`, put both there.
- Routes (`Pairwise(K₁ => k₁, K₂ => k₂)`), a convolution's transpose and a `Recent` without a coupling run on a device too.
  A `Recent` with a coupling fills each stratum's window on the host once a step, so a call with device inputs refuses it.

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

The package's own rules run on device arrays for:

- a convolution with a kernel that is:
  - fixed (a vector or `PerStratum`);
  - time-varying as a dense array (a `TimeVarying` matrix or `PerStratum` array);
- a recurrence with:
  - a kernel that is fixed, or time-varying as a dense array;
  - an identity, scalar or `Diagonal` coupling, or a dense matrix on the device;
  - modifiers that are `Transform`s and `Depletion`s whose steps run per stratum, including a `Depletion` with flows or a floor.

Their forward pass and pullback run as kernels, and AD backends see only the rule, so they never trace a kernel.
Each block of strata adds the cotangents it shares with other blocks, such as the kernel's, into its own copy, and the copies are summed after the loop.
A per-stratum time-varying kernel's cotangent (S × L × T) is not copied, as each stratum writes only its own rows.

Other calls on device arrays take plain AD, as their reverse passes still index the arrays from the host:

- a kernel given by change points or as ragged columns;
- a time-varying coupling;
- a modifier with a vector step, such as `Allocate`;
- a modifier type the package does not define.

What is checked:

- these rule passes run on JLArrays, whose kernels compile through OpenCL;
- the reverse-mode backends are not checked on JLArrays, as none gets that far: Enzyme's KernelAbstractions rules have no JLArrays backend, and Mooncake does not differentiate the JLArray allocator.

Dual-number inputs on device arrays give forward-mode derivatives through the device forward pass.
`ForwardDiff.gradient` seeds its inputs by scalar indexing, so build the duals directly.
