# [Shapes and coefficients](@id shapes)

!!! note "Planned"
    This page describes the planned argument shapes and coefficient wrappers.

## Axes

`T` is time, `S` is strata and `L` is lags.
Time is always the last axis.
A single series drops the `S` axis.
Public arrays are strata × time.

## Kernel orientation

Every kernel is lag-first.
Index 1 of a recurrence kernel is the weight on `y_{t-1}`.
Index 1 of a convolution kernel is lag 0.
`PerStratum`, `TimeVarying` and `Pairwise` kernels follow the same order.
A generation interval or a set of AR coefficients goes in as written, with no reversal.

## History length

`history` may be longer than `L`, and the recurrence reads its last `L` columns.
A history shorter than `L` is zero-padded, meaning no earlier values.

## Shape table

| Slot | Fixed | Per stratum | Time-varying |
|---|---|---|---|
| kernel (lag-first) | Vector L | PerStratum(S × L) | TimeVarying(L × T or S × L × T) |
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
