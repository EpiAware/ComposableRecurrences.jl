# [Shapes and couplings](@id explanation-shapes-couplings)

This page explains which slot takes which shape, how wrappers nest, and how a coupling mixes series.
The [shapes](@ref overview-shapes) and [couplings](@ref overview-couplings) tables list the names, and each wrapper's docstring gives its axes.

```@example shapes
using ComposableRecurrences
using LinearAlgebra: I
```

## [Slots](@id explanation-slots)

A slot is a place an operator reads a coefficient from: a kernel, a coupling or a modifier parameter.
Data (inputs, history and outputs) are not slots, and are always series × time.
Each slot accepts its own set of wrappers.

| Slot | Bare | [`PerStratum`](@ref) | [`TimeVarying`](@ref) | [`Pairwise`](@ref) | [`Routes`](@ref) | [`Derived`](@ref) | [`Recent`](@ref) | [`Weights`](@ref ComposableRecurrences.Weights), [`Survival`](@ref ComposableRecurrences.Survival) |
|---|---|---|---|---|---|---|---|---|
| `Recurrence` kernel | lags | yes | yes | yes | yes | no | no | in `TimeVarying(w, Primary())` |
| `Convolution` kernel | lags | yes | yes | no | no | no | no | in `TimeVarying(w, Primary())` |
| coupling | `S × S` or `λI` | no | yes | no | no | no | no | no |
| modifier parameter | one value | yes | yes | no | no | yes | yes | no |

[`Primary`](@ref ComposableRecurrences.Primary) indexing is for kernels only, as the [time-varying tutorial](@ref tutorial-time-varying-kernels) explains.

## [Nesting](@id explanation-nesting)

Wrappers nest from the outside in: time, then strata, then the slot's own axes.
So `TimeVarying(PerStratum(G))` is an `S × L × T` kernel and `TimeVarying(Pairwise(A))` is `S × S × L × T`.
A `Derived` or `Recent` parameter sits inside arithmetic, as in `κ * Recent(7)`, and its arguments may be any other parameter.

Every modifier reads a parameter through [`param`](@ref ComposableRecurrences.param), which takes every form.
So a new wrapper or parameter form works with every modifier that reads through `param`, with no change to the modifier.
[The gradient mirror](@ref extending-mirror) gives the matching rule for gradients.

## [Where the coupling acts](@id explanation-coupling)

The coupling mixes the series after the kernel and before the gain.
It has no lag of its own: it mixes each series' kernel-weighted past at the current step.
For ``S`` series, before the modifiers, a step computes

```math
v_{t,i} = g_{t,i} \sum_{j=1}^{S} C_{ij} \sum_{l=1}^{L} k_{j,l} \, y_{t-l,j} + a_{t,i},
```

where ``y_{t,j}`` is series ``j`` on day ``t`` and ``k_{j,l}`` its kernel weight on lag ``l``.
``C_{ij}`` is the coupling's weight of series ``j`` in series ``i``, and ``g_{t,i}`` and ``a_{t,i}`` the gain and `add` of series ``i``.

This order sets what a per-series coefficient means.

- A [`PerStratum`](@ref) kernel belongs to the series sending, since the kernel weights each series' own past.
- A gain of `S` rows belongs to the series receiving, since it multiplies the mixed value.
- A row of the coupling is the series receiving, and a column the series sending.

So a sender's transmissibility goes in the kernel or the columns of the coupling, and a receiver's susceptibility in the gain or the rows.
Scaling ``k_{j,l}`` by a transmissibility ``\sigma_j`` gives the same step as scaling ``C_{ij}`` by ``\sigma_j``.

```@example shapes
k = [0.4, 0.4, 0.2]
C = [0.8 0.3; 0.2 0.7]
gain = fill(1.1, 2, 8)
h = ones(2, 3)
σ = [1.0, 0.5]                  # transmissibility of each sender
by_kernel = Recurrence(PerStratum(σ .* k'); coupling = C)(gain; history = h)
by_columns = Recurrence(k; coupling = C .* σ')(gain; history = h)
by_kernel ≈ by_columns
```

## [Coupling or pairwise kernel](@id explanation-pairwise)

A coupling with a shared kernel assumes every pair of series has the same lag shape, scaled by the coupling.
A [`Pairwise`](@ref) kernel gives each pair its own lag shape, so it does the coupling's job and the coupling stays `I`:

```math
v_{t,i} = g_{t,i} \sum_{j=1}^{S} \sum_{l=1}^{L} A_{ij,l} \, y_{t-l,j} + a_{t,i},
```

where ``A_{ij,l}`` weights series ``j`` in series ``i`` at lag ``l``.
When every pair shares the shape, ``A_{ij,l} = C_{ij} k_l``, the two give the same values, and the coupling is cheaper.

```@example shapes
A = reshape(C, 2, 2, 1) .* reshape(k, 1, 1, :)
pairwise = Recurrence(Pairwise(A))(gain; history = h)
coupled = Recurrence(k; coupling = C)(gain; history = h)
pairwise ≈ coupled
```

[`Routes`](@ref) sits between the two: a sum of a few kernels, each with its own coupling, such as household and community contacts with different generation intervals.
With routes ``r``, each a coupling ``C^{(r)}`` and a kernel ``k^{(r)}``,

```math
v_{t,i} = g_{t,i} \sum_{r} \sum_{j=1}^{S} C^{(r)}_{ij} \sum_{l=1}^{L} k^{(r)}_l \, y_{t-l,j} + a_{t,i}.
```

Use a coupling when one lag shape fits, `Routes` for a few shapes, and `Pairwise` when the shape differs by pair.

## [Your own coupling](@id explanation-own-coupling)

Write your own coupling type when the mixing has structure a matrix wastes, such as low rank or a formula in time; [A coupling](@ref extending-coupling) gives the contract and [Specialising for speed](@ref specialising) a low-rank example.
