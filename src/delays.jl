@doc raw"""
    delay_masses(k, lags)

The masses of a delay `k` on lags `0` to `lags - 1`, lag 0 first, as a
vector of length `lags`:

```math
\big(p_0, p_1, \dots, p_{L-1}\big), \qquad p_l = P(D = l),
```

where ``D`` is the delay in whole steps and ``L`` = `lags`.
A [`Convolution`](@ref) kernel is this vector.
A [`Recurrence`](@ref) kernel starts at lag 1, so it is the vector without
``p_0``, and its sum ``\sum_{l=1}^{L-1} p_l`` scales the gain.
`lags` has no default: a kernel of delays without `lags` is an error, and
so is `lags` on a kernel with no delays.

The method for a vector returns it as it is, whatever `lags`.
A package that owns a delay type adds a method for that type:

  - it returns an `AbstractVector` of length `lags`, lag 0 first;
  - it builds the masses from the delay's parameters with differentiable
    operations, so that gradients reach those parameters through the
    kernel;
  - it does not normalise the masses or fold the mass past `lags - 1` into
    the last lag, since where a delay is cut is the caller's choice.

A type with a method is a delay, whatever its supertype, so
`Recurrence(kernel; lags)` and `Convolution(kernel; lags)` take it.
An array of delays is read by its element type, so that type, or a
supertype of it, needs the method.
[Delay distributions](@ref overview-delays) lists the kernels that hold
delays.

A delay on continuous time has masses only once a censoring choice turns it
into one on whole steps, so a method for it belongs with that choice.
[Delay distributions](@ref overview-delays) says which extension makes it.

# Arguments
- `k`: the delay, or a vector of masses.
- `lags`: the number of lags, from lag 0.

# Examples
```jldoctest
using ComposableRecurrences
k = [0.2, 0.5, 0.3]
ComposableRecurrences.delay_masses(k, 3) === k

# output

true
```

A delay type of its own, with masses ``p (1 - p)^l``:

```jldoctest
using ComposableRecurrences
struct GeometricDelay
    p::Float64
end
function ComposableRecurrences.delay_masses(d::GeometricDelay, lags)
    return map(l -> d.p * (1 - d.p)^l, 0:(lags - 1))
end
Convolution(GeometricDelay(0.5); lags = 3).kernel,
Recurrence(GeometricDelay(0.5); lags = 3).kernel

# output

([0.5, 0.25, 0.125], [0.25, 0.125])
```
"""
delay_masses(k::AbstractVector, lags) = k

# The masses of a continuous delay, from the extension that makes the
# censoring choice; until it loads, the error says which package to load.
_continuous_masses(d, lags; kwargs...) = _no_censoring(d)
@noinline function _no_censoring(d)
    throw(
        ArgumentError(
            "$(nameof(typeof(d))) has no masses on whole lags until a " *
                "censoring choice discretises it"
        )
    )
end

# A delay is a value whose type has a `delay_masses` method. An array of
# masses has the vector method but is a kernel, not a delay. Read from the
# type, so the branches on it fold, and a method added later invalidates
# them.
function _isdelay(::Type{T}) where {T}
    return !(T <: AbstractArray) &&
        Core._hasmethod(Tuple{typeof(delay_masses), T, Int})
end

# Whether a kernel holds delays, from its type.
_has_delays(::Type{T}) where {T} = _isdelay(T)
_has_delays(::Type{<:AbstractArray{E}}) where {E} = _isdelay(E)
_has_delays(::Type{<:PerStratum{A}}) where {A} = _has_delays(A)
_has_delays(::Type{<:Pairwise{A}}) where {A} = _has_delays(A)
_has_delays(::Type{<:TimeVarying{I, A}}) where {I, A} = _has_delays(A)
_has_delays(::Type{<:Routes{C, G}}) where {C, G} = _any_delays(G)
_any_delays(::Type{Tuple{}}) = false
function _any_delays(::Type{G}) where {G <: Tuple}
    return _has_delays(Base.tuple_type_head(G)) ||
        _any_delays(Base.tuple_type_tail(G))
end

function _check_no_delays(kernel)
    _has_delays(typeof(kernel)) && throw(
        ArgumentError(
            "a kernel of delays needs `lags`, the number of lags from lag 0, " *
                "to become masses; got $(_describe(kernel))"
        )
    )
    return nothing
end

function _check_lags(lags, origin)
    lags isa Integer && lags > origin || throw(
        ArgumentError(
            "lags counts the lags from 0 and must be an integer above " *
                "$(origin), as a $(origin == 0 ? "Convolution" : "Recurrence") " *
                "kernel starts at lag $(origin); got $(repr(lags))"
        )
    )
    return nothing
end

# The kernel with each delay replaced by its masses from lag `origin`, the
# lag axis where the wrapper reads it. Arrays of masses, such as a route
# kernel beside a route of delays, stay as they are, but a kernel with no
# delays at all takes no `lags`.
function _delay_kernel(kernel, lags, origin)
    _check_lags(lags, origin)
    _has_delays(typeof(kernel)) || throw(
        ArgumentError(
            "`lags` turns delays into masses, and $(_describe(kernel)) holds " *
                "no delays; build the operator without `lags`"
        )
    )
    return _masses_kernel(kernel, lags, origin)
end

# The masses of `d` from lag `origin`.
function _masses(d, lags, origin)
    m = delay_masses(d, lags)
    length(m) == lags || throw(
        ArgumentError(
            "delay_masses($(nameof(typeof(d))), $(lags)) returned " *
                "$(length(m)) masses, not $(lags)"
        )
    )
    return m[(firstindex(m) + origin):end]
end

_stack_masses(A, lags, origin) = stack(d -> _masses(d, lags, origin), A)

function _masses_kernel(x, lags, origin)
    return _isdelay(typeof(x)) ? _masses(x, lags, origin) : x
end
function _masses_kernel(A::AbstractArray, lags, origin)
    _isdelay(eltype(A)) && throw(
        ArgumentError(
            "an array of delays needs a wrapper to say what its axes are: " *
                "PerStratum, Pairwise or TimeVarying"
        )
    )
    return A
end
function _masses_kernel(x::PerStratum{<:AbstractVector}, lags, origin)
    _isdelay(eltype(x.x)) || return x
    return PerStratum(permutedims(_stack_masses(x.x, lags, origin)))
end
function _masses_kernel(x::Pairwise{<:AbstractMatrix}, lags, origin)
    _isdelay(eltype(x.x)) || return x
    return Pairwise(permutedims(_stack_masses(x.x, lags, origin), (2, 3, 1)))
end
function _masses_kernel(
        x::TimeVarying{I, <:AbstractVector}, lags, origin
    ) where {I}
    _isdelay(eltype(x.x)) || return x
    return TimeVarying{I}(_stack_masses(x.x, lags, origin))
end
function _masses_kernel(
        x::TimeVarying{I, <:PerStratum{<:AbstractMatrix}}, lags, origin
    ) where {I}
    _isdelay(eltype(x.x.x)) || return x
    G = permutedims(_stack_masses(x.x.x, lags, origin), (2, 1, 3))
    return TimeVarying{I}(PerStratum(G))
end
function _masses_kernel(
        x::TimeVarying{I, <:Pairwise{<:AbstractArray{<:Any, 3}}}, lags, origin
    ) where {I}
    _isdelay(eltype(x.x.x)) || return x
    A = permutedims(_stack_masses(x.x.x, lags, origin), (2, 3, 1, 4))
    return TimeVarying{I}(Pairwise(A))
end
function _masses_kernel(R::Routes, lags, origin)
    kernels = map(g -> _masses_kernel(g, lags, origin), R.kernels)
    return Routes(map(tuple, R.couplings, kernels)...)
end
