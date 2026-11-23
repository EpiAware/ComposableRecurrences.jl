# [Shapes and couplings](@id explanation-shapes-couplings)

A shape sets how a kernel, coupling or modifier parameter varies across strata and time, and a coupling mixes the strata.
The [API overview](@ref api-overview) shows where they fit among the other parts.

```@example shapes
using ComposableRecurrences
using LinearAlgebra: I
```

## [Slots and shapes](@id explanation-slots)

An operator reads numbers of two kinds.

- Data change from call to call: the inputs, the history, `gain`, `add` and the outputs.
- Coefficients belong to the operator and are set when it is built: its kernel, its coupling and its modifiers' parameters.

A *slot* is a place in an operator that holds a coefficient.
There are three kinds: a kernel, of a `Recurrence` or a `Convolution`, a coupling and a modifier parameter.
The name is that of a slot in a form: the operator fixes where a number goes, and the model chooses what goes there.

```text
Recurrence(k; coupling = K, modifiers = (Depletion(N),))
           |             |                         |
        kernel       coupling             modifier parameter
```

A *shape* is how a coefficient varies across strata and time, and so how many numbers fill its slot.
The name is that of an array's shape, its size along each axis.

- A plain array has only the slot's own axes, so one set of numbers serves every stratum and time.
  These are the lags for a kernel, `S × S` for a coupling and one value for a modifier parameter.
- A [wrapper](@ref explanation-wrappers) adds axes: [`PerStratum`](@ref) a leading strata axis, [`Pairwise`](@ref) leading `S × S` axes and [`TimeVarying`](@ref) a trailing time axis.

Slot and shape are separate because one slot takes many shapes.
The kernel slot of a `Recurrence` holds one kernel for every stratum, one per stratum or one per step.
On two strata, the last output of each shows the difference: the per-stratum kernel gives the strata different values, and the per-step kernel changes the value over time.

```@example shapes
g = [0.5, 0.3, 0.2]
x = fill(1.1, 2, 10)
h = ones(2, 3)
shared = Recurrence(g)
per_stratum = Recurrence(PerStratum([0.5 0.3 0.2; 0.6 0.3 0.1]))
per_step = Recurrence(TimeVarying([g .* (1 + 0.05t) for t in 1:10]))
[r(x; history = h)[:, end] for r in (shared, per_stratum, per_step)]
```

Data are not slots and are not wrapped; their shapes are in [Data shapes](@ref explanation-data-shapes).
Each slot accepts its own set of wrappers.

| Slot | Bare | [`PerStratum`](@ref) | [`TimeVarying`](@ref) | [`Pairwise`](@ref) | `Pairwise` routes | [`Derived`](@ref ComposableRecurrences.Derived) | [`Recent`](@ref ComposableRecurrences.Recent) |
|---|---|---|---|---|---|---|---|
| `Recurrence` kernel | lags | yes | yes | yes | yes | in `TimeVarying(d, Primary())` | no |
| `Convolution` kernel | lags | yes | yes | no | no | in `TimeVarying(d, Primary())` | no |
| coupling | `S × S` or `λI` | no | yes | no | no | no | no |
| modifier parameter | one value | yes | yes | no | no | yes | yes |

[`Primary`](@ref ComposableRecurrences.Primary) indexing is for kernels only; anywhere else it is an `ArgumentError`.

## [Wrappers](@id explanation-wrappers)

A route is one way values pass between strata, such as contact in the community or at funerals, with its own kernel and coupling.

| Name | What it means |
|:--|:--|
| vector | one kernel, the weights on each lag, shared by every stratum |
| [`PerStratum(x)`](@ref PerStratum) | one kernel or parameter for each stratum, with the strata as the first index |
| [`Pairwise(A)`](@ref Pairwise) | one kernel for each pair of strata, indexed by receiving stratum, giving stratum and lag |
| [`Pairwise(K₁ => k₁, K₂ => k₂)`](@ref Pairwise) | a sum of routes, each a coupling and a kernel |
| [`TimeVarying(x)`](@ref TimeVarying) | a kernel, coupling or parameter that changes over time, with time as the last index |
| [`TimeVarying(P, Primary())`](@ref ComposableRecurrences.Primary) | a time-varying kernel whose column ``\tau`` belongs to input time ``\tau`` |
| [`Derived(f, args...)`](@ref ComposableRecurrences.Derived) | a parameter computed by `f` from other parameters, or a cohort kernel computed inside the operator, `TimeVarying(Derived(f, args...), Primary())` |
| [`Survival(h)`](@ref ComposableRecurrences.Survival) | each cohort's survival through a computed kernel's lags against a hazard `h`, as in `TimeVarying(S * (1 - Survival(TimeVarying(h))), Primary())` |
| [`Recent(n)`](@ref ComposableRecurrences.Recent) | a parameter that sums the recurrence's own last `n` outputs, for each stratum and time |

A `TimeVarying` kernel can be a vector with one kernel per step, each of any length.
It can also be change points: `start => value` pairs, each value holding from its start time.

- By default, column ``\tau`` of a time-varying kernel belongs to output time ``\tau``, [`ComposableRecurrences.Secondary()`](@ref ComposableRecurrences.Secondary).
  It holds the weights the output at ``\tau`` puts on earlier times, such as the delays of the reports at ``\tau``.
- With [`Primary()`](@ref ComposableRecurrences.Primary), column ``\tau`` belongs to input time ``\tau``.
  It holds how the value at ``\tau`` spreads over later times, such as the delays of the infections at ``\tau``.
  For a recurrence, the value at ``\tau`` is its own output.

`Derived(exp, TimeVarying(x))` is the exponential of a parameter that changes over time.
`Recent(7)` sums the last seven outputs, and `β * Recent(7)` scales that sum.
Most wrappers hold the stored array without copying it.
A bare vector where a single value is expected is an error that names the wrapper to use.

## [Data shapes](@id explanation-data-shapes)

Inputs, outputs and histories are strata × time arrays, or a vector for a single series.
The call's `gain` and `add` take three shapes:

| Shape | What it means |
|:--|:--|
| scalar | one value for every stratum and time |
| length-`T` vector | one value per time, shared by every stratum |
| `S × T` matrix | one value per stratum and time |

A bare vector is always read as time.
So a value per stratum that is constant over time is `repeat(ρ, 1, T)`, with `ρ` a vector of `S` values.
For a convolution without `add`, the same is `ρ .* c(x)`, which scales row `i` of the output by `ρ[i]`.
In a recurrence, a receiving stratum's susceptibility can instead go in the rows of the coupling, as [Where the coupling acts](@ref explanation-coupling) shows.

## [Nesting](@id explanation-nesting)

Wrappers nest from the outside in: time, then strata, then the slot's own axes.
So `TimeVarying(PerStratum(G))` is an `S × L × T` kernel and `TimeVarying(Pairwise(A))` is `S × S × L × T`.
A `Derived` or `Recent` parameter sits inside arithmetic, as in `β * Recent(7)`, and its arguments may be any other parameter.
`Recent(7; coupling = C)` mixes the recent outputs between strata, so each place responds to the incidence in both:

```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
# Each of two places responds to the incidence in both.
C = [0.8 0.2; 0.2 0.8]
β = CR.Derived(exp, -0.05 * CR.Recent(7; coupling = C))
r = Recurrence([0.2, 0.5, 0.3]; modifiers = (CR.Transform(*, β),))
round.(r([2.0 2.0 2.0; 1.0 1.0 1.0]; history = ones(2, 3)); digits = 3)

# output

2×3 Matrix{Float64}:
 1.721  1.823  2.241
 0.861  0.795  0.691
```

A `Derived` kernel's arguments may also be vectors of lag weights, `Primary()` coefficients and [`Survival`](@ref ComposableRecurrences.Survival).

Every modifier reads a parameter through [`param`](@ref ComposableRecurrences.param), which takes every form.
So a new wrapper or parameter form works with every modifier that reads through `param`.
A parameter's cotangent goes back through [`add_param!`](@ref ComposableRecurrences.add_param!), which also takes every form.

## [Delay distributions as kernels](@id explanation-delays)

A delay distribution, such as a gamma generation interval, can stand in for a kernel.
The operator turns it into masses: the probability that the delay falls on each whole lag.
`Gamma` comes from the Distributions.jl package, and a continuous delay such as it needs CensoredDistributions.jl loaded.

```@example shapes
using Distributions, CensoredDistributions
Recurrence(Gamma(2.0, 2.5); lags = 15)
masses = ComposableRecurrences.delay_masses(Gamma(2.0, 2.5), 15)
round(masses[1]; digits = 3), round(sum(masses[2:end]); digits = 3)
```

The recurrence keeps the masses on lags 1 to 14, 0.957 of the delay, and drops the mass of 0.022 on lag 0.
A convolution's kernel starts at lag 0, so it keeps the delay's mass on lag 0.
A recurrence's kernel [starts at lag 1](@ref explanation-lag-origin), so it drops that mass.
So `Convolution(d; lags = 4)` has 4 kernel entries and `Recurrence(d; lags = 4)` has 3.
The keyword `step` is the width of one lag in the delay's unit, 1 by default.
A model with a weekly [time unit](@ref time-units) and delays in days takes `step = 7`.

With [Distributions.jl](@ref extension-distributions) loaded, discrete distributions have masses.
With [CensoredDistributions.jl](@ref extension-censored-distributions) loaded, continuous distributions have them too.
Any other type works as a delay when it has a [`delay_masses`](@ref ComposableRecurrences.delay_masses) method, which gives its masses on lags `0` to `lags - 1`.
Here is a delay type with masses ``p (1 - p)^l`` on whole units, and the masses of `step` units summed for a lag:

```jldoctest
using ComposableRecurrences
struct GeometricDelay
    p::Float64
end
function ComposableRecurrences.delay_masses(d::GeometricDelay, lags; step = 1)
    q = (1 - d.p)^step
    return map(l -> (1 - q) * q^l, 0:(lags - 1))
end
Convolution(GeometricDelay(0.5); lags = 3).kernel,
Recurrence(GeometricDelay(0.5); lags = 3, step = 2).kernel

# output

([0.5, 0.25, 0.125], [0.1875, 0.046875])
```

Delays take the same wrappers as arrays:

| Kernel | Holds |
|:--|:--|
| `d` | one delay |
| `(d₁, d₂)` | a [chain of delays](@ref time-units-chained), one after another |
| `PerStratum(ds)` | a vector of delays, one per stratum |
| `Pairwise(D)` | a matrix of delays, with `D[i, j]` the delay of stratum `j` in stratum `i` |
| `TimeVarying(ds, indexing)` | a vector of delays, one per step |
| `Pairwise(K₁ => d₁, K₂ => d₂)` | delays or arrays as route kernels |

The argument `indexing` is `Primary()`, or left out for the default, as for any [time-varying kernel](@ref explanation-wrappers).
`TimeVarying` also takes `PerStratum` or `Pairwise` of delays, with time last.
`Pairwise` kernels work with `Recurrence` only.
A chain may also hold mass vectors, and it is itself a delay, so it fits wherever `d` does.

## [Where the coupling acts](@id explanation-coupling)

The coupling mixes the strata after the kernel and before the gain.
It has no lag of its own: it mixes each stratum's kernel-weighted past at the current step.
For ``S`` strata, the [step](@ref explanation-step) before the modifiers is, stratum by stratum,

```math
v_{t,i} = \gamma_{t,i} \sum_{j=1}^{S} K_{ij} \sum_{l=1}^{L} k_{j,l} \, y_{t-l,j} + a_{t,i},
```

where ``y_{t,j}`` is the value of stratum ``j`` at time ``t`` and ``k_{j,l}`` its kernel weight on lag ``l``.
``K_{ij}`` is the coupling's weight of stratum ``j`` in stratum ``i``, and ``\gamma_{t,i}`` and ``a_{t,i}`` the gain and `add` of stratum ``i``.

This order sets what a per-stratum coefficient means.

- A [`PerStratum`](@ref) kernel belongs to the stratum sending, since the kernel weights each stratum's own past.
- A gain of `S` rows belongs to the stratum receiving, since it multiplies the mixed value.
- A row of the coupling is the stratum receiving, and a column the stratum sending.

So a sender's transmissibility goes in the kernel or the columns of the coupling, and a receiver's susceptibility in the gain or the rows.
Scaling ``k_{j,l}`` by a transmissibility ``\sigma_j`` gives the same step as scaling ``K_{ij}`` by ``\sigma_j``.

```@example shapes
k = [0.4, 0.4, 0.2]
K = [0.8 0.3; 0.2 0.7]
gain = fill(1.1, 2, 8)
h = ones(2, 3)
σ = [1.0, 0.5]                  # transmissibility of each sender
by_kernel = Recurrence(PerStratum(σ .* k'); coupling = K)(gain; history = h)
by_columns = Recurrence(k; coupling = K .* σ')(gain; history = h)
by_kernel ≈ by_columns
```

A receiver's susceptibility ``\rho_i`` in the gain gives the same run as in the rows of the coupling:

```jldoctest
using ComposableRecurrences
ρ, T = [1.0, 2.0], 3
h = ones(2, 1)
by_gain = Recurrence([0.5])(repeat(ρ, 1, T); history = h)
by_rows = Recurrence([0.5]; coupling = ρ .* [1 0; 0 1])(; history = h, stop = T)
by_gain == by_rows

# output

true
```

The coupling can be any of these:

| Coupling | What it does |
|:--|:--|
| `LinearAlgebra.I`, the identity matrix | no mixing |
| `λ * LinearAlgebra.I`, the identity times a number `λ` | every sum scaled by `λ` |
| strata × strata matrix, dense, `Diagonal` or sparse | mixing such as contact or travel |
| [`TimeVarying(K)`](@ref TimeVarying), with `K` strata × strata × time | mixing that changes over time |
| a type you write | a [new coupling](@ref explanation-own-coupling) |

## [Coupling or pairwise kernel](@id explanation-pairwise)

A coupling with a shared kernel assumes every pair of strata has the same lag shape, scaled by the coupling.
A [`Pairwise`](@ref) kernel gives each pair its own lag shape, so it does the coupling's job and the coupling stays `I`:

```math
v_{t,i} = \gamma_{t,i} \sum_{j=1}^{S} \sum_{l=1}^{L} A_{ij,l} \, y_{t-l,j} + a_{t,i},
```

where ``A_{ij,l}`` weights stratum ``j`` in stratum ``i`` at lag ``l``.
When every pair shares the shape, ``A_{ij,l} = K_{ij} k_l``, the two give the same values, and the coupling is cheaper.

```@example shapes
A = reshape(K, 2, 2, 1) .* reshape(k, 1, 1, :)
pairwise = Recurrence(Pairwise(A))(gain; history = h)
coupled = Recurrence(k; coupling = K)(gain; history = h)
pairwise ≈ coupled
```

[`Pairwise(K₁ => k₁, K₂ => k₂)`](@ref Pairwise) sits between the two: a sum of a few kernels, each with its own coupling, such as household and community contacts with different generation intervals.
With routes ``r``, each a coupling ``K^{(r)}`` and a kernel ``k^{(r)}``,

```math
v_{t,i} = \gamma_{t,i} \sum_{r} \sum_{j=1}^{S} K^{(r)}_{ij} \sum_{l=1}^{L} k^{(r)}_l \, y_{t-l,j} + a_{t,i}.
```

Use a coupling when one lag shape fits, `Pairwise` routes for a few shapes, and a `Pairwise` array when the shape differs by pair.

## [Your own coupling](@id explanation-own-coupling)

Write your own coupling type when the mixing has structure a matrix wastes, such as low rank or a formula in time.
The type needs a [`forward!`](@ref ComposableRecurrences.forward!) method that writes the [pressure](@ref extending-coupling) `q` on each stratum from each stratum's kernel-weighted past `p`, and may add a `pullback!` for a hand-written gradient.
A [rank-one coupling](@ref specialising) ``K = u w^\top`` mixes the strata in ``2S`` operations, where a dense matrix takes ``S^2``.
