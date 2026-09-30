# [Modifiers](@id modifiers)

A modifier acts on `v_t = gain_t ⊙ x_t + add_t` after each recurrence step.
Modifiers run in tuple order and each keeps its own state.
Their parameters are a scalar, `PerStratum`, `TimeVarying` or `TimeVarying(PerStratum(...))`.

```@example modifiers
using ComposableRecurrences
using ComposableRecurrences: Depletion, Floor, Add, Redistribute, Clamp
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
A modifier sees `gain ⊙ x + add`, so with a nonzero `add` a `Redistribute` also moves the added values.

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

## Planned modifiers

!!! note "Planned"
    `Transform(f, θ)` will apply a user function to each value, with optional per-stratum parameters.
    `Capacity(C)` will cap a stratum and carry the overflow in its state.

## Writing your own modifier

A modifier is a struct with `forward` on the `Step()` role, and on `Init()` when it has an initial state.
See [Extending](@ref extending).
