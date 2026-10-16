# Marks the constructor that takes the flat fields as they are.
struct _Flat end

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
A coefficient per stratum and per time is `TimeVarying(PerStratum(x))`.

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
It is equivalent to [`Routes`](@ref) over all pairs, with a faster path: one route
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
A kernel is `L × T`, or `TimeVarying(PerStratum(G))` with `G` `S × L × T`:
`TimeVarying` is always the outer wrapper.
It may also be a vector of `T` columns of any lengths, `ks[τ]` being
column ``\tau``, with zero weight past each column's end, so a `Primary()`
pmf truncated at the horizon visits only its entries.
Like an array, the columns are held as given, not copied: host columns of
one concrete type, vectors or views, are read where they are, so changing
one after building the kernel changes the kernel.
Columns of mixed types, columns of tracked numbers and columns on a device
are stacked into one vector instead, as is a kernel that `adapt` moves to a
device.
A [`Recurrence`](@ref) coupling is `S × S × T`.
A modifier parameter is length `T`, or `TimeVarying(PerStratum(B))` with
`B` `S × T`.

A coefficient that changes at a few times is given by its change points,
`[t_1 => c_1, t_2 => c_2, ..., t_J => c_J]` with ``1 = t_1 < t_2 < \dots < t_J``:

```math
c(\tau) = c_j, \qquad t_j \le \tau < t_{j+1}, \quad t_{J+1} = \infty,
```

so the last value holds at every later time and the coefficient covers any
`stop`.
Each value has the form of one column: a number for a parameter, a vector
of lag weights for a kernel (shorter ones padded with zero weights), an
`S × S` matrix for a coupling, or a [`PerStratum`](@ref) of these.
Only the ``J`` values are stored: they are copied when stacked into one
array, so changing a value after building the coefficient does not change
it.
[`Pairwise`](@ref) values are not taken; a pairwise kernel is the dense
`TimeVarying(Pairwise(A))`.
Values and gradients equal those of the dense array that repeats each
value over its segment.

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
- `x`: the coefficients, time on the last axis, a [`PerStratum`](@ref)
  of them, a vector of kernel columns, or a vector of `start => value`
  change points.
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

A delay pmf per input time, truncated at the horizon:

```jldoctest
using ComposableRecurrences
ks = [[0.5, 0.5], [0.75, 0.25], [1.0]]
Convolution(TimeVarying(ks, ComposableRecurrences.Primary()))(ones(3))

# output

3-element Vector{Float64}:
 0.5
 1.25
 1.25
```

A generation interval that shortens from time 6, given by its change
points, against the dense array that repeats each kernel:

```jldoctest
using ComposableRecurrences
long_gi, short_gi = [0.2, 0.5, 0.3], [0.6, 0.4]
r = Recurrence(TimeVarying([1 => long_gi, 6 => short_gi]))
y = r(1.2; history = ones(3), start = 4, stop = 8)
G = hcat([t < 6 ? long_gi : [short_gi; 0.0] for t in 1:8]...)
dense = Recurrence(TimeVarying(G))(1.2; history = ones(3), start = 4, stop = 8)
y ≈ dense, round.(y; digits = 3)

# output

(true, [1.2, 1.248, 1.475, 1.661, 1.904])
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
        x isa Union{AbstractArray, PerStratum, Pairwise, _AnyRagged, _Piecewise} || throw(
            ArgumentError(
                "TimeVarying wraps an array, a PerStratum, a Pairwise, a " *
                    "vector of kernel columns or a vector of start => value " *
                    "change points, got $(_describe(x))"
            )
        )
        return new{I, A}(x)
    end
end

# A kernel's columns, of any lengths, stacked: column `τ` is
# `values[(offsets[τ] + 1):offsets[τ + 1]]`, lag first. Loops read each
# column to its own end, so no padding is stored or visited, and the
# integer offsets carry no cotangent. The offsets live where the values
# do, so a device loop reads them. The checked constructor validates the
# offsets on the host, so a loop that reads column `τ ≤ ncols` within its
# range skips bounds checks; the `_Flat` form takes the fields of a checked
# one as they are, as `adapt` does.
struct _Ragged{V <: AbstractVector, O <: AbstractVector{Int}}
    values::V
    offsets::O
    function _Ragged(::_Flat, values::V, offsets::O) where {
            V <: AbstractVector, O <: AbstractVector{Int},
        }
        return new{V, O}(values, offsets)
    end
    function _Ragged(values::V, offsets::AbstractVector{<:Integer}) where {
            V <: AbstractVector,
        }
        Base.require_one_based_indexing(values, offsets)
        host = convert(Vector{Int}, offsets)
        ok = !isempty(host) && first(host) == 0 &&
            last(host) == length(values) && issorted(host)
        ok || throw(
            ArgumentError(
                "ragged kernel offsets rise from 0 to the number of values " *
                    "($(length(values))), got $(_describe(host))"
            )
        )
        o = _like(values, host)
        return new{V, typeof(o)}(values, o)
    end
end

# Stacks the columns with one `copyto!` each, which AD backends
# differentiate as a block copy. The values live where the columns do.
function _Ragged(ks::AbstractVector{<:AbstractVector})
    Base.require_one_based_indexing(ks)
    offsets = Vector{Int}(undef, length(ks) + 1)
    offsets[1] = 0
    for (τ, k) in enumerate(ks)
        offsets[τ + 1] = offsets[τ] + length(k)
    end
    T = _column_eltype(ks)
    n = last(offsets)
    values = _like(ks, Vector{T}(undef, n))
    for (τ, k) in enumerate(ks)
        copyto!(values, offsets[τ] + 1, k, firstindex(k), length(k))
    end
    return _Ragged(values, offsets)
end
function _column_eltype(ks)
    isconcretetype(eltype(ks)) && return eltype(eltype(ks))
    return mapreduce(eltype, promote_type, ks; init = Bool)
end

_ncols(g::_Ragged) = length(g.offsets) - 1
Base.@propagate_inbounds _colrange(g::_Ragged, τ) = (g.offsets[τ] + 1):g.offsets[τ + 1]
function _maxlen(g::_Ragged)
    n = 0
    for τ in 1:_ncols(g)
        n = max(n, g.offsets[τ + 1] - g.offsets[τ])
    end
    return n
end
param_eltype(x::_Ragged) = param_eltype(x.values)

# A kernel's columns as the caller gave them, lag first: column `τ` is
# `columns[τ]`. Holding them rather than stacking them saves a copy of every
# weight on each call that builds the kernel, as a loss differentiating the
# weights does. Each column's mirror is the column's own cotangent.
struct _Columns{K <: AbstractVector{<:AbstractVector}}
    columns::K
    function _Columns(ks::K) where {K <: AbstractVector{<:AbstractVector}}
        Base.require_one_based_indexing(ks)
        for k in ks
            Base.require_one_based_indexing(k)
        end
        return new{K}(ks)
    end
end

_ncols(g::_Columns) = length(g.columns)
# Plain loops, which AD backends that trace the call step through cheaply.
function _maxlen(g::_Columns)
    n = 0
    for k in g.columns
        n = max(n, length(k))
    end
    return n
end
# The column eltype as a constant: promoting over the columns infers only
# a union of types.
param_eltype(g::_Columns) = eltype(eltype(g.columns))

# Either form of a kernel given as columns.
const _AnyRagged = Union{_Ragged, _Columns}

# Column `τ` of a column-form kernel, and the same column of the mirror `m`
# of its storage, or `nothing` without one.
Base.@propagate_inbounds _colview(g::_Ragged, τ) = view(g.values, _colrange(g, τ))
Base.@propagate_inbounds _colview(g::_Columns, τ) = g.columns[τ]
function _column_mirror(m, g::_Ragged, τ)
    return _mirror_view(cotangent(m, :values), _colrange(g, τ))
end
_column_mirror(m, g::_Columns, τ) = _mirror_at(cotangent(m, :columns), τ)
_mirror_at(::Nothing, τ) = nothing
_mirror_at(m, τ) = m[τ]

function TimeVarying{I}(ks::AbstractVector{<:AbstractVector}) where {I}
    return TimeVarying{I}(_ragged(ks))
end

# A coefficient that holds its value between change points: segment `j`
# covers the times from `starts[j]` to `starts[j + 1] - 1`, the last one
# every later time, and its value is column `j` of `x`. `x` has the form of
# a dense coefficient (an array, or a `PerStratum` of one) with one column
# per segment in place of one per time, so the readers of a dense
# coefficient read it at column `_segment(p, t)`. The starts rise from 1 and
# carry no cotangent. The `_Flat` form takes the fields of a checked one as
# they are.
struct _Piecewise{X, P <: AbstractVector{Int}}
    x::X
    starts::P
    function _Piecewise(::_Flat, x::X, starts::P) where {X, P <: AbstractVector{Int}}
        return new{X, P}(x, starts)
    end
    function _Piecewise(x::X, starts::AbstractVector{<:Integer}) where {X}
        Base.require_one_based_indexing(starts)
        s = convert(Vector{Int}, starts)
        ok = !isempty(s) && first(s) == 1 && all(i -> s[i] < s[i + 1], 1:(length(s) - 1))
        ok || throw(
            ArgumentError(
                "change points start at time 1 and rise, got the starts " *
                    repr(s)
            )
        )
        n = _extent(_array(x))
        n == length(s) || throw(
            DimensionMismatch("$(length(s)) change points but $n values")
        )
        return new{X, Vector{Int}}(x, s)
    end
end

_array(p::_Piecewise) = _array(p.x)
param_eltype(p::_Piecewise) = param_eltype(p.x)

# The segment of time `t`: the last whose start is at or before `t`, the
# first for a time before 1. A linear scan from the last segment, as there
# are few and a run reads them in time order.
Base.@propagate_inbounds _segment(p::_Piecewise, t) = _segment_of(p.starts, t)
Base.@propagate_inbounds function _segment_of(s, t)
    j = length(s)
    while j > 1 && s[j] > t
        j -= 1
    end
    return j
end

# The values `start => value` of a coefficient given by change points,
# stacked along a new last axis: numbers into a vector, arrays into an array
# with one more axis, and `PerStratum` values into a `PerStratum` of that.
# Kernels of different lengths are padded with zero weights.
function _piecewise(ps::AbstractVector{<:Pair})
    Base.require_one_based_indexing(ps)
    isempty(ps) && throw(
        ArgumentError("TimeVarying needs at least one start => value pair")
    )
    starts = [_start_time(p) for p in ps]
    V = _values_type(_value_type(eltype(ps)), last, ps)
    return _Piecewise(_stack_values(V, last, ps), starts)
end
_start_time(p::Pair{<:Integer}) = first(p)
function _start_time(p::Pair)
    throw(
        ArgumentError(
            "a change point is an integer start time => value, got " * _describe(p)
        )
    )
end
_value_type(::Type{<:Pair{<:Any, V}}) where {V} = V
# The type that picks how the values `get(p)` stack: `V` when it is
# concrete, else the join of the values' own types, so that a vector of
# pairs typed `Pair{Int, Any}`, or of `PerStratum` values with different
# eltypes, takes the form its values share.
_values_type(::Type{V}, get, ps) where {V} = isconcretetype(V) ? V : _join_types(get, ps)
_join_types(get, ps) = mapreduce(p -> typeof(get(p)), typejoin, ps)

# The values `get(p)` of the pairs `ps`, of type `V`, read from the pairs
# where they are: a vector of the values would be a copy of each that
# reverse-mode AD cannot always type.
_stack_values(::Type{<:Real}, get, ps) = [float(get(p)) for p in ps]
function _stack_values(::Type{V}, get, ps) where {V <: AbstractVector}
    n = 0
    for p in ps
        n = max(n, length(get(p)))
    end
    return _stack(V, get, ps, (n,))
end
function _stack_values(::Type{V}, get, ps) where {V <: AbstractArray}
    sz = size(get(first(ps)))
    for p in ps
        size(get(p)) == sz || _size_error(sz, size(get(p)))
    end
    return _stack(V, get, ps, sz)
end
_stack_values(::Type{<:Pairwise}, get, ps) = _pairwise_piecewise(map(get, ps))
function _stack_values(::Type{V}, get, ps) where {V <: PerStratum}
    getx = p -> get(p).x
    x = _stack_values(_values_type(_field_type(V), getx, ps), getx, ps)
    return constructorof(V)(x)
end
_field_type(::Type{V}) where {V} = isconcretetype(V) ? fieldtype(V, :x) : Any
function _stack_values(::Type, get, ps)
    throw(
        ArgumentError(
            "the values between change points are numbers, arrays or " *
                "PerStratum, all of one form; got $(_describe(map(get, ps)))"
        )
    )
end
@noinline function _size_error(sz, other)
    throw(
        DimensionMismatch(
            "the values between change points have one size, got $sz and $other"
        )
    )
end
# Each value copied into its slice of one zeroed array, where its type and
# device are, as `_Ragged` stacks columns: AD backends differentiate the
# copies as block copies. A shorter vector leaves zeros after its entries.
# The eltype comes from the values' type `V`, read off the pairs' type, so
# no inference runs at call time.
_stack(::Type{V}, get, ps, sz) where {V} = _stack(V, get, ps, sz, get(first(ps)))
function _stack(::Type{V}, get, ps, sz, v1) where {V}
    T = _values_eltype(V, get, ps)
    A = _zeros(v1, T, sz..., length(ps))
    n = prod(sz)
    for (j, p) in enumerate(ps)
        v = get(p)
        copyto!(A, (j - 1) * n + 1, v, firstindex(v), length(v))
    end
    return A
end
_values_eltype(::Type{V}, get, ps) where {V} = _values_eltype(Val(isconcretetype(V)), V, get, ps)
_values_eltype(::Val{true}, ::Type{V}, get, ps) where {V} = eltype(V)
function _values_eltype(::Val{false}, ::Type{V}, get, ps) where {V}
    T = Bool
    for p in ps
        T = promote_type(T, eltype(get(p)))
    end
    return T
end

function TimeVarying{I}(ps::AbstractVector{<:Pair}) where {I}
    return TimeVarying{I}(_piecewise(ps))
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

# `TimeVarying` is the outer wrapper, the only order the docs show; the
# other order builds the same object so that it is not an error.
PerStratum(x::TimeVarying{I}) where {I} = TimeVarying{I}(PerStratum(x.x))
Pairwise(x::TimeVarying{I}) where {I} = TimeVarying{I}(Pairwise(x.x))
PerStratum(x::TimeVarying{<:Any, <:_AnyRagged}) = _strata_ragged(x)
Pairwise(x::TimeVarying{<:Any, <:_AnyRagged}) = _strata_ragged(x)
function PerStratum(x::TimeVarying{I, <:_Piecewise}) where {I}
    return TimeVarying{I}(_Piecewise(_Flat(), PerStratum(x.x.x), x.x.starts))
end
Pairwise(x::TimeVarying{<:Any, <:_Piecewise}) = _pairwise_piecewise(x)
function _pairwise_piecewise(x)
    throw(
        ArgumentError(
            "change points take numbers, arrays or PerStratum values, not " *
                "Pairwise; give a pairwise kernel as the dense " *
                "TimeVarying(Pairwise(A)), got $(_describe(x))"
        )
    )
end
function _strata_ragged(x)
    throw(
        ArgumentError(
            "a vector of kernel columns is shared by every stratum; use a " *
                "dense array for a kernel per stratum, got $(_describe(x))"
        )
    )
end

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
