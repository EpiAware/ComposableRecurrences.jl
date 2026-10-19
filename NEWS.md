# News

## Unreleased

### Breaking

- `Depletion` is now a type alias of [`Pool`][api], so `m isa Depletion` holds as before.
  `Depletion(N, form; heterogeneity, pool0)` builds it as before; its starting pool is the field `initial[1]` rather than `pool0`, and its type parameters are `Pool`'s.
  The v0.1.0 positional constructor `Depletion(N, form, heterogeneity, pool0)` is gone.
- `seeded` is removed.
  Use `r(gain; history, start = m + 1, prepend = true)`, which places the seed at times `1:m` and returns it before the run ([renewal then delay][renewal]).
- `start = nothing` is an `ArgumentError`.
  Leave `start` out for the step after the history or the state, or pass an integer; a resumed call may pass `start = state.t`.
- Calling `pullback!` on a modifier without its own method is a `MethodError`, as the generic `Step()` methods are now internal ([extending][extending]).
- `PieceInterface` has a mandatory `adjoint` component, which fails for a `pullback!` the rules cannot find (typed `grads` or typed arguments after the role) unless the type declares `uses_adjoint`.
- A coupling or modifier holding `TimeVarying(x, Primary())` throws when the `Recurrence` is built, not at its first call.
- A call on device arrays (GPU arrays, such as `CuArray` or `JLArray`) whose kernel, coupling, modifier parameters, gain or add input, or resumed state holds a host array is now an `ArgumentError`.
  Before, such a call ran its strata loops with the host arrays inside device kernels, which works on JLArrays but not on a GPU.
  To migrate, move kernels and parameters to the device first, for example with `Adapt.adapt(CuArray, r)`, which moves every parameter of an operator `r`, or `Recurrence(cu(g))`.

- ForwardDiff is a weak dependency.
  A gradient through the local derivative of a coupling, modifier, depletion form or `Transform` without its own `pullback!` or `derivative` needs `using ForwardDiff`, and without it throws an `ArgumentError` that says so ([adjoints and backends][adjoints]).

### New

- `Recurrence(TimeVarying(K, Primary()))` runs for vector, `PerStratum` and `Pairwise` kernels, so each output keeps the kernel of the time it was produced ([time-varying delays][tv]).
- `TimeVarying(ks, indexing)` takes a vector of kernel columns of any lengths, for `Convolution` and `Recurrence` ([API overview][api]).
- `TimeVarying([t₁ => c₁, t₂ => c₂, ...], indexing)` gives a kernel, coupling or modifier parameter by its change points, storing one value per segment; a `Secondary()` kernel switches between fixed-kernel loops at the change points, and a `Primary()` convolution sums one fixed convolution per segment ([time-varying delays][tv]).
- `Convolution` takes `gain` and `add`, and `ComposableRecurrences.contributions` returns the lag contributions before the sum over lags ([API overview][api]).
- `Convolution(kernel; method = ComposableRecurrences.FFTMethod())` computes a fixed-kernel convolution by overlap-add when FFTW is loaded, with outputs and gradients that match `Direct()` to a relative 1e-10 (1e-4 in `Float32`) ([FFTW extension][fftw]).
  The default method, `Auto()`, takes it only for long `Float64` kernels and series, and otherwise takes `Direct()`.
- `Routes((C₁, g₁), (C₂, g₂), ...)` is a `Recurrence` kernel that sums transmission routes, each with its own kernel and coupling ([API overview][api]).
- `Derived(f, args...)` is a modifier parameter computed from other parameters, with arithmetic on a `Derived` building another ([API overview][api]).
- `Recent(w)` is a modifier parameter read from the recurrence's own last outputs, and `Recent(w; coupling = C)` reads them across strata through a matrix ([API overview][api]).
- A `Recurrence` keeps as many past outputs as its kernel, coupling or modifiers read, given by the public `depth` trait.
- `Transform(f, θ; derivative)` maps each value through `f(v, θ)` with parameters ([Transform tutorial][transform]).
- `Allocate(groups, total)` rescales groups of strata to exogenous totals ([spatial and multi-type models][spatial]).
  `Allocate(groups, total; imports = (fraction, pattern), spill)` places a fraction of each total by an import pattern read before a within-group spill.
- `Pool(N; pools, initial, draw, heterogeneity, flows)` holds pools for each group of strata: each step's value is drawn from weighted pools by a depletion form, then `Flow(from => to, demand; form)`s move between the pools ([renewal then delay][renewal]).
  A second pool drawn at weight `σ` gives all-or-nothing or leaky protection, and `Flow(:V => :S, ω)` gives waning protection.
  The first pool the draw takes from starts at `N` when `N` is given; every other pool, and a pool the draw fills, starts empty, in the state's element type.
  A draw into a pool fills it up to a capacity, such as beds, and the flows can act before the draw (`flows_first = true`), such as a share leaving the beds or a grant `Flow(0 => :B, b; form = Truncate())` into an allowance at the start of each period ([occupancy and capacity][occupancy]).
  What the draw leaves of the demand goes to a second stratum (`overflow = :stratum`), to a queue in the state that joins the next step's demand (`overflow = :queue`), or nowhere.
  Without a draw the pools are the step's values, and the `Pool` moves values between the compartments of each group ([occupancy and capacity][occupancy]).
  A flow's form says how its demand moves: a competing hazard rate (`Hazard()`, the default), a share (`Share()`) or a count capped by what remains (`Truncate()` or `SoftTruncate(κ)`).
- `Depletion(N; removals)` takes removals from the pool after each draw ([renewal then delay][renewal]).
- A call with `trace = true` returns `(y, trace)`, with `trace.modifiers` holding each modifier's series per step, differentiable as the output is; a modifier can record its own through a `Trace()` role ([extending][extending]).
  A call without it runs as before.
- `Depletion`'s population `N` can vary over time, by stratum or as a `Derived`.
- `Truncate()` and `SoftTruncate(κ)` are draw forms that take what is asked for up to what is left, exactly or smoothly ([API overview][api]).
- `ComposableRecurrences.exponential_history(I0, r, L)` builds an exponential-growth seed.
- `delay_masses(d, lags)` returns a delay's masses on lags `0` to `lags - 1`, and packages that own delay types add methods for them.
  With Distributions loaded, `Recurrence(kernel; lags)` and `Convolution(kernel; lags)` take a kernel of delay distributions, alone or in `PerStratum`, `Pairwise`, `TimeVarying` or `Routes`, from each operator's own lag origin ([delay distributions][delays]).
- Executors run the strata loops of every operator: `Serial()` (the default), `Threaded(; min_work, ntasks)` and `Device(backend)`, set for a block with `with(ComposableRecurrences.EXECUTOR => ...)` ([API overview][api]).
- Under `Threaded()`, the reverse rules of `Recurrence` and `Convolution` split strata across tasks, as their forward passes do ([adjoints and backends][adjoints]).
  Cotangents of parameters that several chunks of strata share are summed per chunk, so they match `Serial()` up to rounding.
  A coupling that mixes strata, a pairwise kernel, routes, modifiers with a vector step, parameters that read across strata and a mirror entry with no copy rule run on the calling task.
- Every operator, coupling and built-in modifier runs its forward pass on GPU arrays, without scalar indexing.
  Dense and time-varying couplings use `mul!`, and device CSR couplings run one kernel per step.
  `Adapt.adapt` moves an operator's parameters to a device.
  A ragged `TimeVarying` kernel runs there too, with its column offsets on the device.
  The GPU arrays section of the adjoints and backends explanation says how each part runs on a device.
- `Recurrence` and `Convolution` have native reverse rules for Mooncake and Enzyme, and `NoAdjoint(op)` runs the same call through plain AD ([adjoints and backends][adjoints]).
- A coupling or pointwise modifier without a `pullback!` keeps the rules through a local ForwardDiff derivative when its parameters allow.
  The `Recurrence` constructor logs, once, the part that sends an operator to plain AD; a `true` `uses_adjoint` with no matching `pullback!` is a `MethodError`.
  A coupling's local derivative keeps the rules up to 24 strata and scalars on every backend, and up to 48 on Mooncake ([adjoints and backends][adjoints]).
  A coupling's local derivative also seeds the entries of its float arrays, which count towards those limits.
  A pointwise modifier's local derivative seeds the entries of its other float arrays that a step reads, and keeps the rule on Mooncake ([adjoints and backends][adjoints]).
- The extension API is public: `forward`, `pullback!`, `blocks`, `nstate`, `depth`, `param`, `add_param!`, `cotangent`, `add_cotangent!`, `uses_adjoint`, `test_adjoint`, `Executor` and `each!` ([extending][extending]).
- `blocks(m)` marks a modifier that steps groups of compartments together, and `nstate(m, S)` sizes a modifier's state; a resumed call checks each state against it.
- Extensions for Distributions, ForwardDiff, Enzyme, Mooncake, EnzymeTestUtils, FFTW, KernelAbstractions, GPUArraysCore, GPUArrays and Reactant, each loaded with its package ([extensions][extensions]).

### Changed

- ConstructionBase is a hard dependency.
- Julia 1.13 is supported.
- `Hazard()` and `Floor()` take a fixed heterogeneity of one by default; pass a float to make it a parameter.
- `Redistribute` checks its kernel against the strata once, in `Init` or on a resumed state, rather than every step.
- Argument errors name the value they got as well as what they expected.
- The fixed-kernel convolution, time-varying kernels, `Pairwise` kernels and ForwardDiff paths are faster.
- `Threaded()` counts each loop's work by its kind, so one `min_work` sets where each kind breaks even: independent strata split from eight times `min_work` and a fixed-kernel convolution from sixteen times, and in these loops a dual number with 8 partials counts 9 multiply-adds.
  With the default `min_work` of 500 000, strata that mix through a sparse or dense coupling run in order at the sizes usually fitted.
- Under Reactant, the time loop of `Recurrence` and `Convolution` compiles to one loop rather than one block per step, so compile time no longer grows with the number of steps ([Reactant extension][reactant]).
- The reverse rule of a `Recurrence` records less: no per-step state for `Add`, `Clamp`, `Transform` and `Allocate`, and no pressure record for `I` and `Diagonal` couplings.
- The reverse rule of `Allocate` with imports reads its spilled values and pattern from a record of each step instead of computing them again, and a dense pattern or spill kernel takes its cotangent in one matrix product after the last step.
- Mooncake and Enzyme no longer differentiate the check a `Depletion` makes on its form, which cost Mooncake about 8 µs a gradient.
- On Julia 1.11, the Enzyme extension warns once per operator type when Enzyme reverse mode differentiates an operator with an active scalar field.
  Enzyme on 1.11 returns a zero gradient for such a field when the operator is built by code it cannot infer, such as a closure over a boxed variable, and the extension cannot detect that case (#181).
  Use Julia 1.12 or later, or build operators in type-stable code.

### Fixed

- A `Convolution` kernel with offset axes is an `ArgumentError`, where before it gave wrong values.
- ForwardDiff, Enzyme and Mooncake gradients are finite at an empty depletion or protected pool and agree with the reverse rules.
- On Julia 1.11, the Enzyme reverse rule no longer drops the gradient of a scalar field held next to arrays, such as `b` in `Add(b)`.
- `FFTMethod()` is correct under Enzyme on Julia 1.11.
- Enzyme without runtime activity works for a constant input or history.
- `param_eltype` infers through nested structs such as `Depletion`.

[api]: https://composablerecurrences.epiaware.org/stable/getting-started/api-overview/
[delays]: https://composablerecurrences.epiaware.org/stable/getting-started/api-overview/#overview-delays
[renewal]: https://composablerecurrences.epiaware.org/stable/getting-started/tutorials/renewal-then-delay/
[tv]: https://composablerecurrences.epiaware.org/stable/getting-started/tutorials/time-varying-delays/
[spatial]: https://composablerecurrences.epiaware.org/stable/getting-started/tutorials/spatial-strata/
[occupancy]: https://composablerecurrences.epiaware.org/stable/getting-started/tutorials/occupancy/
[transform]: https://composablerecurrences.epiaware.org/stable/getting-started/tutorials/transform/
[adjoints]: https://composablerecurrences.epiaware.org/stable/explanation/adjoints-and-backends/
[extending]: https://composablerecurrences.epiaware.org/stable/developer/extending/
[extensions]: https://composablerecurrences.epiaware.org/stable/extensions/enzyme/
[fftw]: https://composablerecurrences.epiaware.org/stable/extensions/fftw/
[reactant]: https://composablerecurrences.epiaware.org/stable/extensions/reactant/
