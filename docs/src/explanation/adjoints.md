# [Adjoints](@id adjoints)

!!! note "Planned"
    This page describes the planned plug-in adjoints.
    Its examples do not run yet.

Each operator has a hand-written adjoint for reverse-mode AD.
It is wired into Mooncake and Enzyme through package extensions.
ForwardDiff runs the plain forward code.

## How the adjoints work

A section on the forward pass, its cache and the accumulating `pullback!`.

## Which element types use the adjoint

The adjoints apply to IEEE float element types.
A section on other element types, such as dual numbers, which run the generic code.

## Plain AD with `NoAdjoint`

`NoAdjoint(op)` turns the adjoint off so a backend differentiates the plain code.
A section on using it for A/B timing.

## Timing an adjoint

A section on `benchmark_adjoint` and `scenarios`.

```@raw html
<!-- becomes @example once benchmark_adjoint lands -->
```
```julia
benchmark_adjoint(Recurrence(kernel))
```

## Backend notes

A section per backend: ForwardDiff, Mooncake and Enzyme.

### Enzyme and sparse couplings

Enzyme's plain AD of a sparse `mul!` repeated in a loop returns a wrong gradient.
The adjoint path is correct.
`NoAdjoint` with a sparse coupling under Enzyme throws an `ArgumentError`.
