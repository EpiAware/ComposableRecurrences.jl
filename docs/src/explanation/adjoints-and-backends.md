# [Adjoints and backends](@id adjoints-backends)

Every operator call can be differentiated, and an executor sets where its loops run.
The [API overview](@ref api-overview) shows where gradients and executors fit among the other parts.

[Forward mode](@ref ad-backends) costs one pass per parameter, so it suits a model with few parameters, and reverse mode one with many.

## [Rules and plain AD](@id adjoint-routing)

Each operator call is differentiated in one of two ways:

- the rule, a reverse pass written for the operator, which the [Mooncake](@ref extension-mooncake) and [Enzyme](@ref extension-enzyme) extensions register;
- plain automatic differentiation (AD), where the backend differentiates the operator's forward loop.

A call takes the rule when [`uses_adjoint(op, Run())`](@ref ComposableRecurrences.uses_adjoint) is `true` and every float it holds is a `Float16`, `Float32` or `Float64`.
These floats may sit in an `Array`, a view or reshape of one, a sparse matrix or a `Diagonal`.
Dual numbers, tracked values, `BigFloat`, abstractly typed fields and other array types take plain AD.
The choice between the rule and plain AD depends only on these types, except for two checks described below: whether the local step can rebuild each component, and the number of [strata](@ref explanation-step).

The rule of a [`Recurrence`](@ref) calls the [`pullback!`](@ref ComposableRecurrences.pullback!) of its coupling and modifiers.
It runs [the step](@ref explanation-step) backwards in time, with the symbols defined there.
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
`uses_adjoint` finds a component's `pullback!` from its methods, so writing the method is enough; a method of `uses_adjoint` overrides it.
A component without one is differentiated inside the rule with a local ForwardDiff step where that is cheap; otherwise the whole operator takes plain AD.

| Component without a `pullback!` | Rule or plain AD |
|---|---|
| pointwise modifier or depletion form with only scalar float parameters | rule, local ForwardDiff step |
| pointwise modifier with `PerStratum`, `TimeVarying` or `TimeVarying(PerStratum(x))` parameters read through [`param`](@ref ComposableRecurrences.param) | rule, local ForwardDiff step |
| pointwise modifier with other float arrays, or views of them, that its step indexes, at most 24 entries a step | rule, local ForwardDiff step |
| pointwise modifier with a `Diagonal`, sparse or other structured float array, or a depletion form with any array parameter | plain AD |
| whole-step modifier (neither pointwise nor blockwise) with float scalars and float arrays, its values, state and parameters at most 24, counting only the entries a step reads for one that reads fewer than its arrays hold | rule, local ForwardDiff step |
| the same with 25 to 48 | rule on Mooncake; on Enzyme the rule with at least 10 kernel lags per stratum on Julia 1.12 or later, else plain AD |
| the same with more than 48 | plain AD |
| blockwise modifier with float scalars and `PerStratum`, `TimeVarying` or `TimeVarying(PerStratum(x))` parameters read through `param` at its group | rule, local ForwardDiff step per group |
| blockwise modifier with other float arrays | plain AD |
| coupling with float scalars and float arrays, strata plus scalars and array entries at most 24 | rule, local ForwardDiff step |
| the same coupling with 25 to 48 | rule on Mooncake; on Enzyme the rule with at least 10 kernel lags per stratum on Julia 1.12 or later, else plain AD |
| the same coupling with more than 48 | plain AD |
| coupling with a `Diagonal`, sparse or other structured float array | plain AD |
| coupling, or whole-step modifier with no state of its own, declared linear with [`islinear`](@ref ComposableRecurrences.islinear) | rule, the matrix its `forward!` gives, built once per call outside the rule |
| [`Pairwise`](@ref) route coupling | as a coupling, the widest route coupling setting whether the call takes the rule |
| [`Transform`](@ref ComposableRecurrences.Transform) whose map holds floats | plain AD |
| component that the local step cannot rebuild from its parameters | plain AD |

A modifier with a [`Derived`](@ref ComposableRecurrences.Derived) parameter whose map holds floats takes plain AD even with a `pullback!`, as neither reaches those floats.
An operator whose kernel is a `Derived` with such a map takes plain AD for the same reason.

The [local step](@ref adjoint-local-step) rebuilds a component with dual numbers in place of its float parameters.
For a coupling or a whole-step modifier, one pass of dual numbers seeds up to 24 inputs.
Its limit of 24 in the table is therefore one pass per step, and its limit of 48 is two.
A pointwise modifier's reads take passes of up to 12, so its limit of 24 is two passes.
The `Recurrence` constructor checks the rebuild once and stores the result in the field `rebuilds`.

The `Recurrence` constructor logs an `@info` when one of these components sends the operator to plain AD, naming the component and the reason.
It logs each message once per session, whatever the number types.
A call sent to plain AD by its number of strata, or by its float or array types, logs nothing.

### [What the local step needs](@id adjoint-local-step)

#### ForwardDiff

The local step needs `using ForwardDiff`, which the package loads only as an [extension](@ref extension-forwarddiff).
Without it, a call with a component that takes the local step uses plain AD instead, and logs once which component and what to load.
The gradient is the same, but slower.
An initial state without its own `pullback!` still throws an `ArgumentError` that says to load ForwardDiff.

A `Recurrence` built before ForwardDiff loads stores `nothing` in `rebuilds` and checks its components at each call that takes the rule, so it takes the local step once ForwardDiff is loaded.

#### Types it can rebuild

The local step rebuilds a type with dual numbers through `ConstructionBase.constructorof`, from its fields in order.
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

#### Ties and kinks

The local step's dual numbers, and those of a `Transform` whose map has no [local rule](@ref extending-local-rules), compare by value only, as plain floats do.
So at a tie, such as `x > 0 ? y / x : zero(x)` at `x = 0`, the local step takes the branch the step takes.

ForwardDiff and the backends have derivative rules of their own for some functions, and such a rule picks the side of the function's kink.
The local step and plain AD can pick different sides, as for `abs` at zero and, on Mooncake, `clamp` at a bound.

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

Forward-mode backends run the same forward code with the rule or plain AD, so a rule only changes the cost of reverse mode.
The targets are ForwardDiff, Mooncake and Enzyme.
The AD tests also run ReverseDiff, which is not a target, so it appears in the README's coverage badges.
Enzyme reverse loses the derivatives of values passed through `vcat` of pair vectors, as in change points written `[1 => a; pairs]`.
The `vcat` runs before the package sees the pairs, so build them with `Pair.(starts, values)` or a comma-separated literal.

Reactant traces a call into one compiled program and Enzyme differentiates that program, so the package's rules never run under it.
DifferentiationInterface has no Reactant extension, so Reactant is not one of the AD jobs.
Its own suite, `test/reactant/`, compiles every scenario of the AD registry forward and in reverse and checks each against ForwardDiff, entry by entry.
The [support matrix](https://github.com/EpiAware/ComposableRecurrences.jl/blob/main/test/reactant/RESULTS.md) gives each scenario's result.
The scenarios that do not run are listed in the registry under the `Reactant` backend, grouped by cause.
Most are components built from traced values, such as sparse couplings and delay distributions, or user modifiers that branch with `if` on traced values.
A model that does not run under Reactant runs as it is on the other backends, so Enzyme reverse is the fallback for its gradient.

## [Which rules are kept](@id rule-policy)

A rule is kept only where it beats plain AD, its [`NoAdjoint`](@ref ComposableRecurrences.NoAdjoint) twin, by about 10% in reverse mode on Mooncake or Enzyme; it then runs on both, unless the table above splits by backend.
The [rule timings](@ref rule-timings) are each rule's time over its twin's, at `T` 200 and `L` 20 where a benchmark case covers it.

`NoAdjoint` turns off the operator's rules, so its call is differentiated as the forward loop, with two deliberate exceptions inside the call.

- Under Mooncake, two BLAS overlays stay: a convolution adds each lag with `axpy!`, which Mooncake differentiates with its own rule.
  Without them Mooncake's plain AD of a convolution is 1.3 to 3.1 times slower.
- Under Enzyme, a sparse route coupling's pressure is differentiated by the coupling's own `pullback!`.
  Plain AD reaches it under `NoAdjoint`, and by default when `Pairwise` routes with a route coupling without a `pullback!` take plain AD on Enzyme.
  Without the rule that default is 3 to 4 times slower.

Rules for building components before the call, the masses of a chain of delays and the movement of `Redistribute(K, ε)`, are not the operator's and stay too.

## [Checking a rule](@id adjoint-checks)

A rule is checked against [plain AD](@ref compare-plain-ad) through its [`NoAdjoint`](@ref ComposableRecurrences.NoAdjoint) twin.
With Mooncake, or Enzyme and EnzymeTestUtils, loaded, [`ComposableRecurrences.test_adjoint`](@ref) runs that backend's own rule tester on an operator's rule; the [Mooncake](@ref extension-mooncake) and [EnzymeTestUtils](@ref extension-enzyme-test-utils) extensions add it.

## [Executors](@id executors)

An executor sets how an operator's loops over strata or output times run.
[`EXECUTOR`](@ref ComposableRecurrences.EXECUTOR) holds the one in use, [`Serial`](@ref ComposableRecurrences.Serial) by default.
[`Threaded`](@ref ComposableRecurrences.Threaded) splits a loop across CPU threads, and [`Parallel`](@ref ComposableRecurrences.Parallel) runs it as a kernel on a KernelAbstractions backend, such as a GPU.
On arrays that live on a GPU, `Serial` and `Threaded` both run as `Parallel` on the arrays' own backend, as host threads cannot index them.
The older name [`Device(backend)`](@ref ComposableRecurrences.Device) makes the same executor as `Parallel(backend)`.

Starting and joining tasks costs tens of microseconds, so `Threaded` runs a loop in order when its work is below `min_work`, 500 000 multiply-adds by default.
The work counts each kind of loop so that one `min_work` sets where each breaks even; the [`Threaded`](@ref ComposableRecurrences.Threaded) docstring gives the counts.
Raise `min_work` when threads slow a model down, and lower it when they speed up loops below the default:

```julia
using Base.ScopedValues: with
using ComposableRecurrences: EXECUTOR, Threaded
with(EXECUTOR => Threaded(; min_work = 1_000_000)) do
    r(R; history = seed)
end
```

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

The `Parallel(backend)` row is tested on JLArrays only, which run kernels on the CPU.

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
- A sparse coupling is a device sparse matrix in CSR form, and each stratum's row is one index of a kernel.
  A CSC or other device sparse coupling is converted to CSR when the recurrence is built, where the array package can convert it.
- Modifiers with a vector step (`Redistribute`, `Allocate` and a `Depletion` with several pools or without a draw) run each stratum, or each `Allocate` group, as one index of a kernel.
  `Allocate` copies its groups to the device each step.
- A modifier or wrapper that holds arrays is rebuilt with its device arrays inside a kernel through Adapt.jl; a new modifier type that holds arrays needs an `Adapt.adapt_structure` method.
  Arrays captured by the function of a `Transform` or `Derived` are not moved.
- A ragged `TimeVarying` kernel (a vector of columns) keeps its column offsets where its values live.
  Columns that live on a device, or `Adapt.adapt`, put both there.
- Routes (`Pairwise(K₁ => k₁, K₂ => k₂)`), a convolution's transpose and a `Recent` run on a device too.
  A `Recent` with a coupling fills each stratum's window as one kernel once a step, before the strata read them.
- A computed kernel (a `Survival` or a `Derived` kernel) fills its weights as one kernel, each thread walking one cohort's lags for one stratum.
  `kernel_weights` fills them the same way when its coefficients live on a device.
- A modifier's trace is written per stratum, or per group of a blockwise modifier, as one index of a kernel.
  A modifier whose step runs on the whole vectors writes its trace with its own code, which must not index the arrays from the host.
- A pointwise or blockwise modifier's step runs per stratum or group inside a kernel, so its `forward!` may loop over its entries.
  A coupling the package does not define, a modifier whose step runs on the whole vectors, and an `Init` get the whole device vectors on the host instead.
  Their `forward!` must use array operations, such as broadcasts and `mul!`; a loop over entries stops with the array package's scalar-indexing error.
- `window_sums` runs each sum as one index of a kernel.
- `pressure` runs each step's pressures as one kernel, after the step's kernel convolutions and coupling.
- Views and reshapes of device arrays, such as views into one parameter vector, run on the device as the arrays themselves do.

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
  - time-varying as a dense array (a `TimeVarying` matrix or `PerStratum` array) or as ragged columns;
  - computed from coefficients (a `Survival` or a `Derived` kernel);
- a recurrence with:
  - a kernel that is fixed, time-varying as a dense array or as ragged columns, computed, or one per pair of strata (`Pairwise`), fixed or over time;
  - an identity, scalar or `Diagonal` coupling, or a dense matrix on the device, fixed or over time (a `TimeVarying` array);
  - modifiers that are `Transform`s, `Depletion`s, `Allocate`s and `Redistribute`s.
    An `Allocate` with imports takes the rule when its pattern is a matrix on the device, fixed or over time, and its spill, if it has one, takes the rule too.
    A `Depletion` may have flows, a floor, several pools, several draws on one pool or a queue.
    A `Redistribute` moves by a matrix, or by a kernel and an intensity per origin and time or read from a parameter, such as recent outputs.
    A modifier the package does not define takes the rule when it runs per stratum or on fixed groups of strata and its parameters are scalars.
    An `Init` of its own reverses once per call on host copies of the state and the history, unless it is written only for device states.
- a recurrence over routes (a `Pairwise` of couplings and kernels) whose couplings are matrices on the device and whose kernels are fixed.
  A sparse route coupling becomes a dense matrix on the device.

Their forward pass and pullback run as kernels, and AD backends see only the rule, so they never trace a kernel.
Each block of strata adds the cotangents it shares with other blocks, such as the kernel's, into its own copy, and the copies are summed after the loop.
A per-stratum kernel's cotangent, fixed (S × L) or time-varying (S × L × T), is not copied, as each stratum writes only its own rows.
The cotangent of a modifier's `PerStratum` parameter in a vector step is not copied either, as each stratum or group writes only its own entries.
A computed kernel's reverse pass walks its cohorts again in blocks, and each block adds into its own copy of the coefficients' cotangents, as cohorts share them.
With strata the blocks are blocks of strata, so a per-stratum coefficient's cotangent is not copied either.
`kernel_weights` takes the rule the same way.
A run that returns its modifiers' traces takes the rule too: each stratum's or group's trace pullback is one index of a kernel.
Groups that share a parameter add into stacked copies of its cotangent, as their steps do.
A modifier type the package does not define with scalar parameters reverses one stratum or fixed group per kernel index, through its `pullback!` or, without one, its local derivative.
A `Redistribute` step runs as kernels, one index per stratum, and each origin writes only its own column of the kernel's cotangent, so nothing is copied.
An intensity read from a parameter may share a cotangent between origins, such as a scale's, and blocks of origins add into their own copies of it.
The rule covers `window_sums` too: each sum is one index of a kernel, and in the reverse pass each time adds the cotangents of the windows it falls in.
The rule covers `pressure` as it covers its recurrence: each step's pressures are one kernel, one stratum per index, and its reverse pass runs the recurrence's coupling and kernel pullbacks at each step.
A convolution's transpose takes the rule when the convolution does, as it runs the convolution's bodies with their inputs and outputs swapped; a series extended past its end (`tail`) takes a cotangent too.
Routes reverse one route at a time on the calling task: each route's coupling as a dense coupling's pressure does, then its kernel.
The kernel runs one stratum per kernel index, as each stratum writes only its own entries.
A pairwise kernel reverses one sender per kernel index, as every stratum reads a sender's window.
The sender's index loops over the strata and writes only its own column of the buffer's cotangent and its own pairs of the kernel's, so nothing is copied.
A coupling over time reverses each step's slice as two products, and writes only that slice of its cotangent, so nothing is copied.
A fixed dense coupling's step reverses in the same kernel as the kernels' step, one stratum per index, from a transposed copy of the coupling made once per call.
Each stratum records its step's cotangent, and the coupling's cotangent is one product of those records after the loop.

Other calls on device arrays take plain AD, as their reverse passes still index the arrays from the host:

- a kernel given by change points;
- routes with a coupling that is not a matrix, such as a scaled identity beside a matrix, or with a time-varying kernel;
- a `Redistribute` whose moves are a time-varying array;
- a modifier type the package does not define that works on the whole step, holds an array, has a `pullback!` for the whole step, or has an `Init` written only for device states.

What is checked:

- these rule passes run on JLArrays, whose kernels compile through OpenCL;
- the reverse-mode backends are not checked on JLArrays, as none gets that far: Enzyme's KernelAbstractions rules have no JLArrays backend, and Mooncake does not differentiate the JLArray allocator.

Dual-number inputs on device arrays give forward-mode derivatives through the device forward pass.
`ForwardDiff.gradient` seeds its inputs by scalar indexing, so build the duals directly.
