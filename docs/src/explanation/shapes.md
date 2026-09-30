# [Shapes and coefficients](@id shapes)

!!! note "Planned"
    This page describes the planned argument shapes and coefficient wrappers.

## Axes

`T` is time, `S` is strata and `L` is lags.
Time is always the last axis.
A single series drops the `S` axis.
Public arrays are strata × time.

## Shape table

| Slot | Fixed | Per stratum | Time-varying |
|---|---|---|---|
| kernel | Vector L | PerStratum(S × L) | TimeVarying(L × T or S × L × T) |
| coupling | I, Matrix S × S | Pairwise(S × S × L) | TimeVarying(S × S × T) |
| gain | scalar | – | T or S × T |
| add | scalar / nothing | – | T or S × T |
| history | L or S × L | | |
| output | T or S × T | | |

## Coefficient wrappers

`TimeVarying(x)`, `PerStratum(x)` and `Pairwise(x)` mark how a kernel or coupling array is indexed.
A section on when each wrapper is needed and how it reads its array.

## Array types

Every slot accepts any `AbstractArray` with any `Real` element type.
A section on sparse, structured and GPU arrays.
