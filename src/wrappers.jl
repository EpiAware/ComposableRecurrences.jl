@doc "
The default indexing of a [`TimeVarying`](@ref) coefficient: column `t` is
read at output time `t`.

This is the only meaning outside a kernel slot.

# Examples
```@example
using ComposableRecurrences
TimeVarying([0.8 0.7; 0.2 0.3], ComposableRecurrences.Secondary())
```
"
struct Secondary end

@doc "
The indexing of a [`TimeVarying`](@ref) kernel whose column `c` is the kernel
of the input (cohort) at absolute time `c`, which spreads forward through
it.

Kernel slots only: anywhere else it is an `ArgumentError`.
In a [`Recurrence`](@ref) column `c` weights the output at time `c` at
each lag, `p_t = Σ_l k_l(t - l) y_{t-l}` with `k_l(τ)` the weight on lag
`l` in column `τ`, so a seed must sit at times from 1 (`start > m` for a
seed of length `m`).

# Examples
```@example
using ComposableRecurrences
CR = ComposableRecurrences
P = [0.6 0.2 0.4; 0.4 0.8 0.6]         # one delay pmf per input time
Convolution(TimeVarying(P, CR.Primary()))(ones(3))

# Cohorts from time 3 on transmit less.
K = [0.5 0.5 0.2 0.2 0.2 0.2; 0.5 0.5 0.2 0.2 0.2 0.2]
CR.seeded(Recurrence(TimeVarying(K, CR.Primary())), fill(1.5, 6); history = [1.0, 1.0])
```
"
struct Primary end

@doc "
A coefficient given per stratum: adds a leading strata axis to its slot.

As a kernel it is `S × L`, one row of lag weights per stratum.
As a modifier parameter it is a length-`S` vector.
`PerStratum(TimeVarying(x))` is the same object as
`TimeVarying(PerStratum(x))`.

# Examples
```@example
using ComposableRecurrences
G = [0.2 0.8; 0.5 0.5]
Recurrence(PerStratum(G))(ones(2, 4); history = ones(2, 2))
```
"
struct PerStratum{A <: AbstractArray}
    "The coefficients, strata on the first axis."
    x::A
end

@doc "
A [`Recurrence`](@ref) kernel for every pair of strata: adds leading
`S × S` axes, so it is `S × S × L`.

`x[a, b, i]` weights stratum `b`'s value at lag `i` in stratum `a`.
It is equivalent to Routes over all pairs, with a faster path: one route
per pair `(a, b)`, with kernel `x[a, b, :]` and a coupling that is the unit
matrix at `(a, b)`.
The kernel already mixes strata, so the coupling must be `I`.
`TimeVarying(Pairwise(A))` has `A` `S × S × L × T`.

# Examples
```@example
using ComposableRecurrences
P = fill(0.25, 2, 2, 2)
Recurrence(Pairwise(P))(ones(2, 4); history = ones(2, 2))
```
"
struct Pairwise{A <: AbstractArray}
    "The pairwise kernels, lag on the last axis."
    x::A
end

@doc "
A coefficient that changes over time: adds a trailing time axis to its slot.

Column `t` is read at absolute time `t`, so a resumed call carries on
through the same array.
A kernel is `L × T`, or `TimeVarying(PerStratum(G))` with `G` `S × L × T`.
A [`Recurrence`](@ref) coupling is `S × S × T`.
A modifier parameter is length `T`, or `TimeVarying(PerStratum(B))` with
`B` `S × T`.

The indexing sets which time a kernel's column belongs to, and is held as
a type parameter so nothing branches on it:

  - [`ComposableRecurrences.Secondary`](@ref) (the default): column `t`
    weights the inputs reaching output `t`. This is the only meaning
    outside a kernel.
  - [`ComposableRecurrences.Primary`](@ref): column `c` is the kernel of
    the input at time `c`, which spreads forward through it. In a
    [`Recurrence`](@ref) the input is the output at time `c`, so each
    cohort keeps its own kernel, `p_t = Σ_l k_l(t - l) y_{t-l}`.

The two agree for a fixed kernel.

# Arguments
- `x`: the coefficients, time on the last axis, or a [`PerStratum`](@ref)
  of them.
- `indexing`: `Secondary()` (default) or `Primary()`.

# Examples
```@example
using ComposableRecurrences
G = [0.8 0.7; 0.2 0.3]  # lags 1 and 2 over two steps
Recurrence(TimeVarying(G))(1.0; history = [1.0, 1.0], stop = 2)
```
"
struct TimeVarying{I, A}
    "The coefficients, time on the last axis."
    x::A
    function TimeVarying{I}(x::A) where {I, A}
        x isa TimeVarying && throw(
            ArgumentError("TimeVarying cannot wrap another TimeVarying")
        )
        x isa Union{AbstractArray, PerStratum, Pairwise} || throw(
            ArgumentError(
                "TimeVarying wraps an array, a PerStratum or a Pairwise, " *
                    "not a $(typeof(x))"
            )
        )
        return new{I, A}(x)
    end
end

TimeVarying(x) = TimeVarying{Secondary}(x)
TimeVarying(x, ::I) where {I <: Union{Primary, Secondary}} = TimeVarying{I}(x)
function TimeVarying(x, indexing)
    throw(
        ArgumentError(
            "TimeVarying indexing is Secondary() or Primary(), not " *
                "$(typeof(indexing))"
        )
    )
end

# Nesting is normalised to TimeVarying outermost.
PerStratum(x::TimeVarying{I}) where {I} = TimeVarying{I}(PerStratum(x.x))
Pairwise(x::TimeVarying{I}) where {I} = TimeVarying{I}(Pairwise(x.x))

const _PairwiseKernel = Union{Pairwise, TimeVarying{<:Any, <:Pairwise}}

# The array under any wrappers.
_array(x::AbstractArray) = x
_array(x::Union{PerStratum, Pairwise, TimeVarying}) = _array(x.x)
