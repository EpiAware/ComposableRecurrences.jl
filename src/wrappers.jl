@doc "
A coefficient that changes over time, with time on the last axis.

As a kernel it is `L × T` (shared by every stratum) or `S × L × T` (one
kernel per stratum).
As a [`Recurrence`](@ref) coupling it is `S × S × T`.
Slot `t` is read at time index `t`: the first output of a call is at its
`start`, so a resumed call carries on through the same array.

# Examples
```@example
using ComposableRecurrences
G = [0.8 0.7; 0.2 0.3]  # lags 1 and 2 over two steps
Recurrence(TimeVarying(G))(1.0; history = [1.0, 1.0])
```
"
struct TimeVarying{A <: AbstractArray}
    "The coefficients, time on the last axis."
    x::A
end

@doc "
A kernel with one row per stratum, `S × L`, lag first.

# Examples
```@example
using ComposableRecurrences
G = [0.2 0.8; 0.5 0.5]
Recurrence(PerStratum(G))(ones(2, 4); history = ones(2, 2))
```
"
struct PerStratum{A <: AbstractMatrix}
    "The kernels, one row per stratum."
    x::A
end

@doc "
A kernel for every pair of strata, `S × S × L`, used as the coupling of a
[`Recurrence`](@ref) whose kernel is `nothing`.

`x[a, b, i]` weights stratum `b`'s value at lag `i` in stratum `a`.

# Examples
```@example
using ComposableRecurrences
P = fill(0.25, 2, 2, 2)
Recurrence(nothing; coupling = Pairwise(P))(ones(2, 4); history = ones(2, 2))
```
"
struct Pairwise{A <: AbstractArray{<:Any, 3}}
    "The pairwise kernels, lag on the last axis."
    x::A
end
