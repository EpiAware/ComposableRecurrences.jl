@doc raw"""
The default indexing of a [`TimeVarying`](@ref) coefficient: column `t` is
read at time `t`.

For a kernel, the weight on lag ``l`` of the output at time ``t`` is

```math
k_l(t),
```

where ``k_l(\tau)`` is the kernel's weight on lag ``l`` in column ``\tau``
and ``t`` is the absolute time of the output, counted from 1.
A time-varying coupling or modifier parameter ``\theta`` is likewise read
as ``\theta(t)``.
This is the only indexing outside a kernel.

# Examples
```jldoctest
using ComposableRecurrences
TimeVarying([0.8 0.7; 0.2 0.3], ComposableRecurrences.Secondary())

# output

TimeVarying{ComposableRecurrences.Secondary, Matrix{Float64}}([0.8 0.7; 0.2 0.3])
```
"""
struct Secondary end

@doc raw"""
The indexing of a [`TimeVarying`](@ref) kernel whose column `τ` is the kernel
of the input at absolute time `τ`, which spreads forward through it.

For a [`Convolution`](@ref) with kernel length ``L``,

```math
y_{t,i} = \sum_{l=0}^{L-1} k_{i,l}(t - l)\, x_{t-l,i},
```

where ``y_{t,i}`` is the output of stratum ``i`` at absolute time ``t``,
``x_{t-l,i}`` the input ``l`` steps earlier, and ``k_{i,l}(\tau)`` the weight
on delay ``l`` (`kernel[l + 1]`) in column ``\tau``, the column of the
input's own time.
When every column sums to one, each input's total is kept once all its
delays fall inside the window.
In a [`Recurrence`](@ref) with kernel length ``L`` the input is the
output itself, so each output keeps the kernel of the time it was produced:

```math
p_{t,i} = \sum_{l=1}^{L} k_{i,l}(t - l)\, y_{t-l,i},
```

where ``p_{t,i}`` is stratum ``i``'s kernel convolution at time ``t``,
``y_{t-l,i}`` its output ``l`` steps earlier and ``k_{i,l}(\tau)`` the weight
on lag ``l`` (`kernel[l]`) in column ``\tau``.
Only outputs at times from 1 have a column, so a seed of length ``m`` needs
`start > m`.
Kernel slots only: anywhere else it is an `ArgumentError`.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
P = [0.6 0.2 0.4; 0.4 0.8 0.6]         # one delay pmf per input time
Convolution(TimeVarying(P, CR.Primary()))(ones(3))

# Cohorts from time 3 on transmit less.
K = [0.5 0.5 0.2 0.2 0.2 0.2; 0.5 0.5 0.2 0.2 0.2 0.2]
r = Recurrence(TimeVarying(K, CR.Primary()))
y = r(fill(1.5, 6); history = [1.0, 1.0], start = 3, prepend = true)
round.(y; digits = 3)

# output

6-element Vector{Float64}:
 1.0
 1.0
 1.5
 1.2
 0.81
 0.603
```
"""
struct Primary end

@doc raw"""
A coefficient given per stratum: adds a leading strata axis to its slot.

A stratum is one of ``S`` parallel series computed together, such as a
place or an age group.
As a [`Recurrence`](@ref) kernel it is `S × L`, one row of lag weights per
stratum, and stratum ``i`` convolves only its own past values:

```math
p_{t,i} = \sum_{l=1}^{L} k_{i,l}\, y_{t-l,i},
```

with ``k_{i,l}`` = `x[i, l]` the weight on lag ``l``, ``y_{t-l,i}`` the
output of stratum ``i`` at absolute time ``t - l`` and ``p_{t,i}`` the
value passed on to the coupling.
A [`Convolution`](@ref) kernel is read the same way from lag 0.
As a modifier parameter it is a length-`S` vector, ``\theta_i`` = `x[i]`.
`PerStratum(TimeVarying(x))` is the same object as
`TimeVarying(PerStratum(x))`.

# Examples
```jldoctest
using ComposableRecurrences
G = [0.2 0.8; 0.5 0.5]
Recurrence(PerStratum(G))(ones(2, 4); history = ones(2, 2))

# output

2×4 Matrix{Float64}:
 1.0  1.0  1.0  1.0
 1.0  1.0  1.0  1.0
```
"""
struct PerStratum{A <: AbstractArray}
    "The coefficients, strata on the first axis."
    x::A
end

@doc raw"""
A [`Recurrence`](@ref) kernel for every pair of strata: adds leading
`S × S` axes, so it is `S × S × L`.

Each stratum's pressure sums every stratum's past values through its own
lag weights:

```math
q_{t,i} = \sum_{j=1}^{S} \sum_{l=1}^{L} k_{ij,l}\, y_{t-l,j},
```

where ``k_{ij,l}`` = `x[i, j, l]` weights stratum ``j``'s output at lag
``l`` in stratum ``i``, ``y_{t-l,j}`` is that output at absolute time
``t - l``, and ``q_{t,i}`` replaces the coupled pressure ``C_t p_t`` of a
[`Recurrence`](@ref).
A stratum is one of ``S`` parallel series computed together.
It is equivalent to Routes over all pairs, with a faster path: one route
per pair `(i, j)`, with kernel `x[i, j, :]` and a coupling that is the unit
matrix at `(i, j)`.
The kernel already mixes strata, so the coupling must be `I`.
`TimeVarying(Pairwise(A))` has `A` `S × S × L × T`.

# Examples
```jldoctest
using ComposableRecurrences
P = fill(0.25, 2, 2, 2)
Recurrence(Pairwise(P))(ones(2, 4); history = ones(2, 2))

# output

2×4 Matrix{Float64}:
 1.0  1.0  1.0  1.0
 1.0  1.0  1.0  1.0
```
"""
struct Pairwise{A <: AbstractArray}
    "The pairwise kernels, lag on the last axis."
    x::A
end

@doc raw"""
A coefficient that changes over time: adds a trailing time axis to its slot.

Column ``\tau`` of the array holds the coefficient ``c(\tau)`` for absolute
time ``\tau``, counted from 1, so a resumed call carries on through the same
array.
With the default indexing the step at time ``t`` reads ``c(t)``; a
`Primary()` kernel's weight on lag ``l`` is read from column ``t - l``:

```math
\text{Secondary: } k_l(t), \qquad \text{Primary: } k_l(t - l).
```
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
    output keeps the kernel of the time it was produced.

The two agree for a fixed kernel.

# Arguments
- `x`: the coefficients, time on the last axis, or a [`PerStratum`](@ref)
  of them.
- `indexing`: `Secondary()` (default) or `Primary()`.

# Examples
```jldoctest
using ComposableRecurrences
G = [0.8 0.7; 0.2 0.3]  # lags 1 and 2 over two steps
Recurrence(TimeVarying(G))(1.0; history = [1.0, 1.0], stop = 2)

# output

2-element Vector{Float64}:
 1.0
 1.0
```
"""
struct TimeVarying{I, A}
    "The coefficients, time on the last axis."
    x::A
    function TimeVarying{I}(x::A) where {I, A}
        x isa TimeVarying && throw(
            ArgumentError(
                "TimeVarying cannot wrap another TimeVarying, got " *
                    _describe(x)
            )
        )
        x isa Union{AbstractArray, PerStratum, Pairwise} || throw(
            ArgumentError(
                "TimeVarying wraps an array, a PerStratum or a Pairwise, " *
                    "got $(_describe(x))"
            )
        )
        return new{I, A}(x)
    end
end

TimeVarying(x) = TimeVarying{Secondary}(x)
# The indexing is a type parameter with no field, so a rebuild from the
# fields names it, or `TimeVarying(x)` would read the kernel as `Secondary()`.
ConstructionBase.constructorof(::Type{<:TimeVarying{I}}) where {I} = TimeVarying{I}
TimeVarying(x, ::I) where {I <: Union{Primary, Secondary}} = TimeVarying{I}(x)
function TimeVarying(x, indexing)
    throw(
        ArgumentError(
            "TimeVarying indexing is Secondary() or Primary(), got " *
                _describe(indexing)
        )
    )
end

# Nesting is normalised to TimeVarying outermost.
PerStratum(x::TimeVarying{I}) where {I} = TimeVarying{I}(PerStratum(x.x))
Pairwise(x::TimeVarying{I}) where {I} = TimeVarying{I}(Pairwise(x.x))

# A fixed pairwise kernel as a call prepares it: `x[L + 1 - i, b, a]` is
# the weight of stratum `b`'s value at lag `i` in stratum `a`, so the dot of
# each pair's weights with its window reads both in memory order.
struct _OldestFirstPairwise{A <: AbstractArray}
    x::A
end

const _PairwiseKernel = Union{
    Pairwise, TimeVarying{<:Any, <:Pairwise}, _OldestFirstPairwise,
}

# The array under any wrappers.
_array(x::AbstractArray) = x
_array(x::Union{PerStratum, Pairwise, TimeVarying}) = _array(x.x)
