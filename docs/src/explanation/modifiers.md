# [Modifiers](@id modifiers)

A modifier acts on `v_t = gain_t ⊙ x_t + add_t` after each recurrence step.
Modifiers run in tuple order and each keeps its own state.
Their parameters are a scalar, `PerStratum`, `TimeVarying` or `TimeVarying(PerStratum(...))`.

| Modifier | What it does | Recurrence | Convolution | Pointwise | Adjoint | Parameters |
|---|---|---|---|---|---|---|
| `Depletion(N, form)` | draws each step's values from a finite pool | yes | no | yes | hand-written | `N`, `heterogeneity`, `pool0` |
| `Redistribute(K, ε)` | moves a share `ε` of each stratum's value to others through `K` | yes, with strata | no | no | hand-written | `ε` |
| `Add(b)` | adds `b` at this point in the modifier order | yes | no | yes | hand-written | `b` |
| `Clamp(lo, hi)` | bounds each value | yes | no | yes | hand-written | `lo`, `hi` |
| `Transform(f, θ)` | maps each value through `f(v, θ_k)` | yes | no | yes | local forward-mode, or `derivative` | `θ` |

A pointwise modifier acts on each stratum separately, and the rest act on the whole step.

## Placement

`add` enters before every modifier.
`Add` enters where it sits in the tuple.
So imports passed as `add` are drawn from a `Depletion` pool like local infections, and imports in an `Add` after it are not.
A `Redistribute` moves whatever it sees, so with a nonzero `add` it moves the added values too.

```@example modifiers
using ComposableRecurrences
using ComposableRecurrences: Depletion, Floor, Add, Redistribute, Clamp, Transform
```

## Depletion

`Depletion(N, form = Hazard(); heterogeneity = 1, pool0 = N)` draws each step's values from a pool that shrinks by what is drawn.
`Hazard()` keeps the pool non-negative and `Floor()` floors the drawn fraction.
`heterogeneity` is the exponent `α` in `(S/N)^α`, and `α > 1` depletes faster as the pool shrinks.

```@example modifiers
r = Recurrence([0.2, 0.5, 0.3]; modifiers = (Depletion(1000.0),))
r(2.5; history = fill(10.0, 3), stop = 20)
```

A seed drawn from the pool starts it lower.

```@example modifiers
seed = fill(10.0, 3)
d = Depletion(1000.0, Floor(); pool0 = 1000.0 - sum(seed))
Recurrence([0.2, 0.5, 0.3]; modifiers = (d,))(2.5; history = seed, stop = 20)
```

## Add

`Add(b)` adds `b` wherever it sits in the tuple.
After a `Depletion` the added values are neither scaled by nor drawn from the pool.

```@example modifiers
imports = TimeVarying([5.0, 0.0, 0.0, 5.0, 0.0, 0.0])
mods = (Depletion(1000.0), Add(imports))
Recurrence([0.2, 0.5, 0.3]; modifiers = mods)(1.5; history = zeros(3), stop = 6)
```

## Redistribute

`Redistribute(K, ε)` moves a share `ε_q K[p, q]` of origin `q`'s value to stratum `p`, conserving the total.
The diagonal of `K` is ignored.

```@example modifiers
K = [0.0 0.3; 0.2 0.0]
r = Recurrence([0.5, 0.5]; modifiers = (Redistribute(K, 0.1),))
r(fill(1.2, 2, 5); history = [1.0 1.0; 0.0 0.0])
```

## Clamp

`Clamp(lo, hi)` bounds each value.

```@example modifiers
Recurrence([2.0]; modifiers = (Clamp(0.0, 5.0),))(1.0; history = [1.0], stop = 4)
```

## Transform

`Transform(f, θ)` maps each value through `f(v, θ_k)`, or `f(v)` without `θ`.
`θ` follows the parameter protocol, entry by entry for a NamedTuple.
Iterating a probability generating function `G` from zero gives the probability that a branching process has died out by each generation.

```@example modifiers
G(s, θ) = (θ.p / (1 - (1 - θ.p) * s))^θ.r
Recurrence([1.0]; modifiers = (Transform(G, (; r = 0.5, p = 0.2)),))(; history = [0.0], stop = 8)
```

Its pullback is a local forward-mode derivative of `f`, or `derivative` when given.
Values captured inside `f` are differentiated by the AD backend instead, so pass parameters in `θ` to keep the local derivative.

## Writing your own modifier

A modifier is a struct with `forward` on the `Step()` role, and on `Init()` when it has an initial state.
The [Occupancy and capacity](@ref tutorial-occupancy) tutorial writes one, and the Extending table on the [Concepts](@ref concepts) page lists the roles.
