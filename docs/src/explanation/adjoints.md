# [Adjoints](@id adjoints)

Every piece runs through `forward`, and may add a hand-written reverse pass with `pullback!`.
The core threads the cotangents between pieces, so each piece's adjoint sees only its own step.

## How the adjoints work

An operator's call lowers to `forward(op, Run(), args...)`, which returns the output and a cache.
`pullback!(grads, op, Run(), cache)` accumulates the cotangents of the operator and its inputs.
Modifiers, couplings and depletion forms do the same for their own roles.

## Plain AD with `NoAdjoint`

`NoAdjoint(op)` is called like `op` and is differentiated by the backend's own treatment of the forward loop.
Use it to check or time a hand-written adjoint against plain AD.

```@example adjoints
using ComposableRecurrences
using ComposableRecurrences: NoAdjoint

r = Recurrence([0.2, 0.3, 0.5])
NoAdjoint(r)(fill(1.1, 6); history = ones(3)) == r(fill(1.1, 6); history = ones(3))
```

## Planned tooling

!!! note "Planned"
    Mooncake and Enzyme rules that route every operator through its `pullback!` will live in package extensions.
    They will apply to IEEE float element types, and a pointwise step without a pullback will be differentiated locally with ForwardDiff.
    `test_adjoint(backend, op, args...)` will test a piece's adjoint on one backend.
    `benchmark_adjoint(op)` will time a gradient with and without its adjoint.

## Backend notes

ForwardDiff runs the plain forward code.
Element types other than IEEE floats, such as dual numbers, run the generic code.

### Enzyme and sparse couplings

Enzyme's plain AD of a sparse `mul!` repeated in a loop returns a wrong gradient.
Check a sparse coupling's Enzyme gradient against ForwardDiff until the Enzyme rules land.
