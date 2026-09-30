# [Modifiers](@id modifiers)

!!! note "Planned"
    This page describes the planned modifiers.
    Its examples do not run yet.

A modifier acts on `v_t = gain_t ⊙ x_t + add_t` after each step.
Modifiers run in the order given and each keeps its own state.

## Depletion

A section on `Depletion(N; form = :hazard | :floor, seeded = false)`.
It will cover the heterogeneity option, which scales by `(S/N)^α`.

## Imports

A section on `Imports(b)`, which adds a time-indexed input.
It can sit anywhere in the modifier tuple.

## Redistribute

A section on `Redistribute(K, ε)`, with `ε` a scalar, a per-stratum vector or `TimeVarying(S × T)`.
The diagonal of `K` is ignored.
A modifier sees `gain ⊙ x + add`, so with a nonzero `add` a `Redistribute` also moves the added values.

## Clamp

A section on `Clamp(lo, hi)`.

## Planned next

`Capacity(C)` caps a stratum and carries the overflow in its state.

## Writing your own modifier

A section on the modifier interface.

- `init_state` sets the state before the first step.
- `apply!(m, v, s, t)` updates the step in place.
- `apply_pullback!(m̄, m, v, s, t, v̄, s̄)` is its adjoint.
- `ispointwise(m) = true` opts in to a scalar method looped over strata.

A modifier without a hand-written pullback is differentiated locally for its step.

<!-- becomes @example once modifiers land -->
```julia
r = Recurrence(kernel; modifiers = (Depletion(N), Clamp(0.0, Inf)))
y = r(gain; history)
```
