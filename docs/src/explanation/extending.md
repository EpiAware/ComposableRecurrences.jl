# [Extending](@id extending)

!!! note "Planned"
    This page describes how to add your own operators, modifiers and couplings.

Operators, modifiers and couplings each declare an interface with Interfaces.jl.
A new type that passes the interface tests works with the rest of the package.

## A custom modifier

A section on the modifier interface and its tests.
See [Modifiers](@ref modifiers) for the functions a modifier defines.

## A custom coupling

A section on the coupling interface and its tests.
See [Couplings](@ref couplings) for the functions a coupling defines.

## A custom operator

A section on the operator interface and its adjoint.
See [Adjoints](@ref adjoints) for how an adjoint is wired to each backend.

## Checking an extension

A section on running the interface tests on a new type.
