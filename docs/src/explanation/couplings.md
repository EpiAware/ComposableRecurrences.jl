# [Couplings](@id couplings)

!!! note "Planned"
    This page describes the planned coupling interface for spatial mixing.
    Its examples do not run yet.

A coupling mixes the lagged outputs of several strata before the gain is applied.
The default `I` keeps strata independent.

## Fixed mixing

A section on an `S × S` matrix coupling, dense or sparse.

## Mixing by lag

A section on `Pairwise(S × S × L)`, where the mixing depends on the lag.

## Mixing over time

A section on `TimeVarying(S × S × T)`.

## The coupling interface

A section on `pressure` and `pressure_pullback!`, the two functions a coupling defines.

```@raw html
<!-- becomes @example once couplings land -->
```
```julia
K = [0.9 0.1; 0.2 0.8]
r = Recurrence(PerStratum(kernels); coupling = K)
y = r(gain; history)
```
