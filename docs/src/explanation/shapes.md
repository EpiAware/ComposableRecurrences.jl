# [Shapes and coefficients](@id shapes)

## Axes

`T` is time, `S` is strata and `L` is lags.
Time is always the last axis.
A single series drops the `S` axis.
Data (inputs, history and outputs) are strata × time and are never wrapped.

## Kernel orientation

Every kernel is lag-first.
Index 1 of a recurrence kernel weights `y_{t-1}`.
Index 1 of a convolution kernel weights lag 0.
`PerStratum`, `Pairwise` and `TimeVarying` kernels follow the same order.
A generation interval or a set of AR coefficients goes in as written.

## History length

`history` may be longer than `L`, and the recurrence reads its last `L` columns.
A history shorter than `L` is zero-padded, meaning no earlier values.

## Shape table

A bare array has the slot's own axes only.
`PerStratum` adds a leading strata axis, `Pairwise` adds leading `S × S` axes and `TimeVarying` adds a trailing time axis.

| Slot | Fixed | Per stratum | Time-varying |
|---|---|---|---|
| kernel (lag-first) | vector `L` | `PerStratum(S × L)`, `Pairwise(S × S × L)` | `TimeVarying(L × T)`, `TimeVarying(PerStratum(S × L × T))` |
| coupling | `I`, `λI`, `S × S` matrix (dense, `Diagonal`, sparse) | – | `TimeVarying(S × S × T)` |
| modifier parameter | scalar | `PerStratum(S)` | `TimeVarying(T)`, `TimeVarying(PerStratum(S × T))` |
| gain, add | scalar | – | `T` or `S × T` |
| history | `m` or `S × m` | | |
| output | `T` or `S × T` | | |

## Coefficient wrappers

`PerStratum` gives each stratum its own kernel or parameter.

```@example shapes
using ComposableRecurrences

G = [0.2 0.5 0.3; 0.5 0.3 0.2]
r = Recurrence(PerStratum(G))
r(fill(1.1, 2, 6); history = fill(10.0, 2, 3))
```

`TimeVarying` gives a kernel or parameter one column per time.

```@example shapes
g = [0.2, 0.5, 0.3]
Gt = hcat([g .* (1 + 0.05t) for t in 1:6]...)
Recurrence(TimeVarying(Gt))(1.0; history = fill(10.0, 3), stop = 6)
```

A time-varying convolution kernel is indexed by output time by default (`Secondary()`).
With `Primary()` column `s` is the kernel of the input at time `s`, which it spreads forward.

```@example shapes
using ComposableRecurrences: Primary

P = repeat([0.5, 0.3, 0.2], 1, 6)
Convolution(TimeVarying(P, Primary()))(ones(6))
```

In a `Recurrence` a `Primary()` kernel gives each output its own kernel by the time it was produced, `x_t = Σ_i K[i, t - i] y_{t-i}`.
This is a cohort effect: an infector's onward transmission depends on when it was infected, as with an isolation policy that starts on a set day.
A `Secondary()` kernel is a period effect instead, the same for every infector on a day.
The kernel reads the column of each seed value's own time, so the seed must sit at times from 1: pass `start = m + 1` for a seed of length `m`, or use `seeded`.

```@example shapes
using ComposableRecurrences: seeded

g = [0.2, 0.5, 0.3]
K = hcat([g .* (c >= 5 ? 0.5 : 1.0) for c in 1:12]...)  # cohorts from time 5 transmit half
seeded(Recurrence(TimeVarying(K, Primary())), fill(2.0, 12); history = [1.0, 1.0, 1.0])
```

`Pairwise` gives each pair of strata its own kernel.
It already mixes strata, so its coupling stays `I`.

```@example shapes
A = zeros(2, 2, 2)
A[1, 1, :] = [0.4, 0.2]
A[2, 2, :] = [0.4, 0.2]
A[1, 2, :] = [0.1, 0.1]
Recurrence(Pairwise(A))(1.0; history = [1.0 1.0; 0.0 0.0], stop = 4)
```

## Wrapper rules

The wrappers are tags over one stored array, so they add no copies.
Nesting works in either order and is normalised with `TimeVarying` outermost.

```@example shapes
Gs = rand(2, 3, 6)
typeof(PerStratum(TimeVarying(Gs)))
```

A modifier parameter is one value unless wrapped, so a bare vector there is an error that names the wrapper to use.

```@example shapes
using ComposableRecurrences: Depletion

try
    Depletion([1000.0, 500.0])
catch err
    err
end
```

Data are never wrapped, so time enters a call one way, as a plain array.

## Array types

Every slot accepts any `AbstractArray` with any `Real` element type.
`Float32` inputs give `Float32` outputs, and a dual-number input promotes the buffer to match.
