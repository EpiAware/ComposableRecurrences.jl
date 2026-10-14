# News

## Unreleased

### Breaking

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

### New

- `Recurrence(TimeVarying(K, Primary()))` runs for vector, `PerStratum` and `Pairwise` kernels, so each output keeps the kernel of the time it was produced ([time-varying delays][tv]).
- `TimeVarying(ks, indexing)` takes a vector of kernel columns of any lengths, for `Convolution` and `Recurrence` ([API overview][api]).
- `Convolution` takes `gain` and `add`, and `ComposableRecurrences.contributions` returns the lag contributions before the sum over lags ([API overview][api]).
- `Convolution(kernel; method = ComposableRecurrences.FFTMethod())` computes a fixed-kernel convolution by overlap-add when FFTW is loaded; `Direct()` stays the default ([FFTW extension][fftw]).
- `Routes((C₁, g₁), (C₂, g₂), ...)` is a `Recurrence` kernel that sums transmission routes, each with its own kernel and coupling ([API overview][api]).
- `Derived(f, args...)` is a modifier parameter computed from other parameters, with arithmetic on a `Derived` building another ([API overview][api]).
- `Recent(w)` is a modifier parameter read from the recurrence's own last outputs, and `Recent(w; coupling = C)` reads them across strata through a matrix ([API overview][api]).
- A `Recurrence` keeps as many past outputs as its kernel, coupling or modifiers read, given by the public `depth` trait.
- `Transform(f, θ; derivative)` maps each value through `f(v, θ)` with parameters ([Transform tutorial][transform]).
- `Allocate(groups, total)` rescales groups of strata to exogenous totals ([spatial and multi-type models][spatial]).
- `Depletion(N; removals, protected)` takes removals from the pool and, with `Protected(σ; pool0)`, keeps them in a second pool for all-or-nothing or leaky protection ([renewal then delay][renewal]).
  `Protected`'s default `pool0` is an empty pool in the state's element type, so a `Float32` model stays `Float32`.
- `Depletion`'s population `N` can vary over time, by stratum or as a `Derived`.
- `Truncate()` and `SoftTruncate(κ)` are draw forms that take what is asked for up to what is left, exactly or smoothly ([API overview][api]).
- `Depletion(N; flows)` moves between the depletion's pools after each draw, such as waning protection `Flow(2 => 1, ω)` back from a `Protected` pool or a rate `Flow(1 => 0, μ)` out of the pool; the `removals` are its first count flow ([renewal then delay][renewal]).
- `Flows(Flow(from => to, kind)...)` moves values between the compartments of each group, with `Rate`, `Linear` and `Amount` flow kinds ([occupancy and capacity][occupancy]).
- `Capacity(C, mode; pairs, overflow, form)` admits demand up to free `Beds` or a per-period `Budget` and sends the rest to an overflow stratum (`Route()`), a queue (`Hold()`) or nowhere (`Drop()`) ([occupancy and capacity][occupancy]).
- `ComposableRecurrences.exponential_history(I0, r, L)` builds an exponential-growth seed.
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
- A coupling or pointwise modifier without a `pullback!` keeps the rules through a local ForwardDiff derivative when its parameters allow, and the plain-AD note names the part that has none.
- The extension API is public: `forward`, `pullback!`, `blocks`, `nstate`, `depth`, `param`, `add_param!`, `cotangent`, `add_cotangent!`, `uses_adjoint`, `test_adjoint`, `Executor` and `each!` ([extending][extending]).
- `blocks(m)` marks a modifier that steps groups of compartments together, and `nstate(m, S)` sizes a modifier's state; a resumed call checks each state against it.
- Extensions for Enzyme, Mooncake, EnzymeTestUtils, FFTW, KernelAbstractions, GPUArraysCore, GPUArrays and Reactant, each loaded with its package ([extensions][extensions]).

### Changed

- ConstructionBase and ForwardDiff are hard dependencies.
- Julia 1.13 is supported.
- `Hazard()` and `Floor()` take a fixed heterogeneity of one by default; pass a float to make it a parameter.
- `Redistribute` checks its kernel against the strata once, in `Init` or on a resumed state, rather than every step.
- Argument errors name the value they got as well as what they expected.
- The fixed-kernel convolution, time-varying kernels, `Pairwise` kernels and ForwardDiff paths are faster.
- The reverse rule of a `Recurrence` records less: no per-step state for `Add`, `Clamp`, `Transform` and `Allocate`, and no pressure record for `I` and `Diagonal` couplings.

### Fixed

- A `Convolution` kernel with offset axes is an `ArgumentError`, where before it gave wrong values.
- ForwardDiff, Enzyme and Mooncake gradients are finite at an empty depletion or protected pool and agree with the reverse rules.
- On Julia 1.11, the Enzyme reverse rule no longer drops the gradient of a scalar field held next to arrays, such as `b` in `Add(b)`.
  On 1.11, Enzyme itself still drops the gradient of such a field when the operator is built by code it cannot infer, such as a closure over a boxed variable (#181).
  The Enzyme extension now warns once on 1.11 when it differentiates an operator with an active scalar field in reverse mode.
- `FFTMethod()` is correct under Enzyme on Julia 1.11.
- Enzyme without runtime activity works for a constant input or history.
- `param_eltype` infers through nested structs such as `Depletion`.

[api]: https://composablerecurrences.epiaware.org/stable/getting-started/api-overview/
[renewal]: https://composablerecurrences.epiaware.org/stable/getting-started/tutorials/renewal-then-delay/
[tv]: https://composablerecurrences.epiaware.org/stable/getting-started/tutorials/time-varying-delays/
[spatial]: https://composablerecurrences.epiaware.org/stable/getting-started/tutorials/spatial-strata/
[occupancy]: https://composablerecurrences.epiaware.org/stable/getting-started/tutorials/occupancy/
[transform]: https://composablerecurrences.epiaware.org/stable/getting-started/tutorials/transform/
[adjoints]: https://composablerecurrences.epiaware.org/stable/explanation/adjoints-and-backends/
[extending]: https://composablerecurrences.epiaware.org/stable/developer/extending/
[extensions]: https://composablerecurrences.epiaware.org/stable/extensions/enzyme/
[fftw]: https://composablerecurrences.epiaware.org/stable/extensions/fftw/
