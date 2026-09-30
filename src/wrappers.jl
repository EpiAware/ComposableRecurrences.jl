# The indexing of a time-varying kernel, held as TimeVarying's first type
# parameter so no loop branches on it.
struct _Secondary end
struct _Primary end

_indexing(name::Symbol) = _indexing(Val(name))
_indexing(::Val{:secondary}) = _Secondary()
_indexing(::Val{:primary}) = _Primary()
function _indexing(::Val{name}) where {name}
    throw(
        ArgumentError(
            "unknown indexed_by :$name for TimeVarying (choose :secondary " *
                "or :primary)"
        )
    )
end

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

@doc "
A coefficient that changes over time: adds a trailing time axis to its slot.

Column `t` is read at absolute time `t`, so a resumed call carries on
through the same array.
A kernel is `L × T`, or `TimeVarying(PerStratum(G))` with `G` `S × L × T`.
A [`Recurrence`](@ref) coupling is `S × S × T`.
A modifier parameter is length `T`, or `TimeVarying(PerStratum(B))` with
`B` `S × T`.

`indexed_by` sets which time a kernel's column belongs to:

  - `:secondary` (the default): column `t` weights the inputs reaching
    output `t`. This is the only meaning outside a kernel.
  - `:primary`: column `c` is the kernel of the input at time `c`, which
    spreads forward through it. [`Convolution`](@ref) kernels only.

The two agree for a fixed kernel.

# Arguments
- `x`: the coefficients, time on the last axis, or a [`PerStratum`](@ref)
  of them.

# Keyword Arguments
- `indexed_by`: `:secondary` (default) or `:primary`.

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

Base.@constprop :aggressive function TimeVarying(
        x; indexed_by::Symbol = :secondary
    )
    return TimeVarying{typeof(_indexing(indexed_by))}(x)
end

# Nesting is normalised to TimeVarying outermost.
PerStratum(x::TimeVarying{I}) where {I} = TimeVarying{I}(PerStratum(x.x))

# The array under any wrappers.
_array(x::AbstractArray) = x
_array(x::Union{PerStratum, Pairwise, TimeVarying}) = _array(x.x)
