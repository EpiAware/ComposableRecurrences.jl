@doc raw"""
    delay_masses(k, lags; step = 1)

The masses of a delay `k` on lags `0` to `lags - 1`, lag 0 first, as a
vector of length `lags`:

```math
\big(p_0, p_1, \dots, p_{L-1}\big), \qquad
p_l = P\big(l \Delta \le D < (l + 1) \Delta\big),
```

where ``D`` is the delay in its own unit, ``\Delta`` = `step` is the width
of a lag in that unit and ``L`` = `lags`.
With the default `step = 1` a lag is one unit of the delay.
A [`Convolution`](@ref) kernel is this vector.
A [`Recurrence`](@ref) kernel starts at lag 1, so it is the vector without
``p_0``, and its sum ``\sum_{l=1}^{L-1} p_l`` scales the gain.
`lags` has no default: a kernel of delays without `lags` is an error, and
so is `lags` on a kernel with no delays.
Both operators pass `step` on, and `step` without `lags` is an error.
A step other than 1 suits a model whose [time unit](@ref time-units)
differs from the delay's unit, such as `step = 7` for weekly steps and
delays in days.

The method for a vector returns it as it is, whatever `lags` and `step`.
A package that owns a delay type adds a method for that type:

  - it returns an `AbstractVector` of length `lags`, lag 0 first;
  - it takes `step` as a keyword, defaulting to 1, and gives lag `l` the
    mass on ``[l \Delta, (l + 1) \Delta)``; a method without the keyword
    serves `step = 1` only, and the operators call it without it then;
  - it builds the masses from the delay's parameters with differentiable
    operations, so that gradients reach those parameters through the
    kernel;
  - it does not normalise the masses or fold the mass past `lags - 1` into
    the last lag, since where a delay is cut is the caller's choice.

A type with a method is a delay, whatever its supertype, so
`Recurrence(kernel; lags)` and `Convolution(kernel; lags)` take it.
An array of delays is read by its element type, so that type, or a
supertype of it, needs the method.

A delay on continuous time has masses only once a censoring choice turns it
into one on whole steps, so a method for it belongs with that choice.
A [package extension](@ref overview-delays) adds one that double interval
censors the delay.

# Arguments
- `k`: the delay, or a vector of masses.
- `lags`: the number of lags, from lag 0.

# Keyword Arguments
- `step`: the width of a lag in the delay's own unit; `1` by default.

# Examples
```jldoctest
using ComposableRecurrences
k = [0.2, 0.5, 0.3]
ComposableRecurrences.delay_masses(k, 3) === k

# output

true
```

A delay type of its own, with masses ``p (1 - p)^l`` on whole units, and
the masses of `step` units summed for a lag:

```jldoctest
using ComposableRecurrences
struct GeometricDelay
    p::Float64
end
function ComposableRecurrences.delay_masses(d::GeometricDelay, lags; step = 1)
    q = (1 - d.p)^step
    return map(l -> (1 - q) * q^l, 0:(lags - 1))
end
Convolution(GeometricDelay(0.5); lags = 3).kernel,
Recurrence(GeometricDelay(0.5); lags = 3, step = 2).kernel

# output

([0.5, 0.25, 0.125], [0.1875, 0.046875])
```
"""
delay_masses(k::AbstractVector, lags; step = 1) = k

@doc raw"""
    delay_masses(ds::Tuple, lags; step = 1)

The masses of a chain of delays `ds`, each a delay or a vector of masses:
the first `lags` masses of their full linear convolution,

```math
(a \circledast b)_l = \sum_{j=0}^{l} a_j\, b_{l-j},
\qquad l = 0, \dots, L - 1.
```

Each delay's masses come from its own method, on lags `step` units wide.
A vector of masses is read as given, whatever its length and `step`, so
it must already be on lags of that width.

A chain of discretised delays and a
[sum of continuous delays discretised once](@ref time-units-chained) are
different models.

# Examples
```jldoctest
using ComposableRecurrences
a, b = [0.5, 0.5], [0.2, 0.8]
ComposableRecurrences.delay_masses((a, b), 3),
Convolution((a, b); lags = 4).kernel

# output

([0.1, 0.5, 0.4], [0.1, 0.5, 0.4, 0.0])
```
"""
function delay_masses(ds::Tuple{Any, Vararg{Any}}, lags; step = 1)
    return _chain_masses(map(d -> _link_masses(d, lags, step), ds), lags)
end

# A vector in a chain is its masses whatever its length; a delay's masses
# are checked to have `lags` entries.
_link_masses(k::AbstractVector, lags, step) = k
_link_masses(d, lags, step) = _masses(d, lags, 0, step)

_chain_masses(ms::Tuple{Any}, lags) = _cut(only(ms), lags)
function _chain_masses(ms::Tuple{Any, Any}, lags)
    return _convolve_masses(ms[1], ms[2], lags)
end
function _chain_masses(ms::Tuple, lags)
    m = _convolve_masses(ms[1], ms[2], lags)
    return _chain_masses((m, Base.tail(Base.tail(ms))...), lags)
end

# The masses of `a` on lags `0` to `lags - 1`, with zeros past its end.
function _cut(a, lags)
    i, n = firstindex(a), length(a)
    return map(l -> l < n ? a[i + l] : zero(eltype(a)), 0:(lags - 1))
end

# The full linear convolution of `a` and `b` on lags `0` to `lags - 1`,
# added to `c`: only the products of entries that both exist are taken.
function _convolve_masses(a, b, lags)
    c = zeros(promote_type(eltype(a), eltype(b)), lags)
    return _convolve_masses!(c, a, b)
end

# Floats take each entry of `a` times `b` in turn, which vectorises; other
# numbers, such as dual numbers, take each lag's sum in one accumulator,
# which keeps it out of memory.
function _convolve_masses!(c::AbstractVector{<:_IEEEFloat}, a, b)
    i₀, j₀, k₀ = firstindex(a), firstindex(b), firstindex(c)
    L, nb = length(c), length(b)
    @inbounds for i in 0:(min(length(a), L) - 1)
        aᵢ = a[i₀ + i]
        @simd for j in 0:(min(nb, L - i) - 1)
            c[k₀ + i + j] += aᵢ * b[j₀ + j]
        end
    end
    return c
end
function _convolve_masses!(c, a, b)
    i₀, j₀, k₀ = firstindex(a), firstindex(b), firstindex(c)
    na, nb = length(a), length(b)
    @inbounds for l in 0:(length(c) - 1)
        s = c[k₀ + l]
        for m in max(0, l - nb + 1):min(l, na - 1)
            s += a[i₀ + m] * b[j₀ + l - m]
        end
        c[k₀ + l] = s
    end
    return c
end

# The reverse pass of `c += a ⊛ b` for the rules: `ā` and `b̄` take the
# cotangent `c̄` correlated with `b` and with `a`, and either may be
# `nothing`. The cotangent of `c` passes through unchanged.
function _convolve_masses_back!(ā, b̄, c̄, a, b)
    ā === nothing || _correlate_masses!(ā, c̄, b)
    b̄ === nothing || _correlate_masses!(b̄, c̄, a)
    return nothing
end
function _correlate_masses!(x̄, c̄, y)
    i₀, j₀, k₀ = firstindex(x̄), firstindex(y), firstindex(c̄)
    L, ny = length(c̄), length(y)
    @inbounds for i in 0:(min(length(x̄), L) - 1)
        s = zero(eltype(x̄))
        @simd for j in 0:(min(ny, L - i) - 1)
            s += c̄[k₀ + i + j] * y[j₀ + j]
        end
        x̄[i₀ + i] += s
    end
    return x̄
end

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
# A tuple is a delay when each of its links is a delay or a vector of
# masses, so a tuple of anything else keeps the kernel-shape error.
_isdelay(::Type{Tuple{}}) = false
function _isdelay(::Type{T}) where {T <: Tuple}
    T isa Union && return _isdelay(T.a) && _isdelay(T.b)
    (T isa DataType && !Base.isvatuple(T)) || return false
    return _links(T)
end
_links(::Type{Tuple{}}) = true
function _links(::Type{T}) where {T <: Tuple}
    H = Base.tuple_type_head(T)
    return (H <: AbstractVector{<:Real} || _isdelay(H)) &&
        _links(Base.tuple_type_tail(T))
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

# `step` is the width of a lag in a delay's own unit, so it is positive,
# and it has meaning only where `lags` turns delays into masses.
function _check_step(step)
    step isa Real && step > 0 || throw(
        ArgumentError(
            "step is the width of a lag in the delay's unit and must be a " *
                "positive number; got $(repr(step))"
        )
    )
    return nothing
end
function _check_no_step(step)
    step isa Real && isone(step) || throw(
        ArgumentError(
            "step sets the width of a lag for a kernel of delays, so it " *
                "needs `lags`; got step = $(repr(step)) without it"
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
# lag axis where the wrapper reads it, on lags `step` units wide. Arrays of
# masses, such as a route kernel beside a route of delays, stay as they
# are, but a kernel with no delays at all takes no `lags`.
function _delay_kernel(kernel, lags, origin, step)
    _check_lags(lags, origin)
    _check_step(step)
    _has_delays(typeof(kernel)) || throw(
        ArgumentError(
            "`lags` turns delays into masses, and $(_describe(kernel)) holds " *
                "no delays; build the operator without `lags`"
        )
    )
    return _masses_kernel(kernel, lags, origin, step)
end

# The masses of `d` from lag `origin`. A step of 1 calls the method without
# `step`, so a method that only serves whole units still works.
function _masses(d, lags, origin, step)
    m = isone(step) ? delay_masses(d, lags) : delay_masses(d, lags; step)
    length(m) == lags || throw(
        ArgumentError(
            "delay_masses($(nameof(typeof(d))), $(lags)) returned " *
                "$(length(m)) masses, not $(lags)"
        )
    )
    return m[(firstindex(m) + origin):end]
end

function _stack_masses(A, lags, origin, step)
    return stack(d -> _masses(d, lags, origin, step), A)
end

function _masses_kernel(x, lags, origin, step)
    return _isdelay(typeof(x)) ? _masses(x, lags, origin, step) : x
end
function _masses_kernel(A::AbstractArray, lags, origin, step)
    _isdelay(eltype(A)) && throw(
        ArgumentError(
            "an array of delays needs a wrapper to say what its axes are: " *
                "PerStratum, Pairwise or TimeVarying"
        )
    )
    return A
end
function _masses_kernel(x::PerStratum{<:AbstractVector}, lags, origin, step)
    _isdelay(eltype(x.x)) || return x
    return PerStratum(permutedims(_stack_masses(x.x, lags, origin, step)))
end
function _masses_kernel(x::Pairwise{<:AbstractMatrix}, lags, origin, step)
    _isdelay(eltype(x.x)) || return x
    M = _stack_masses(x.x, lags, origin, step)
    return Pairwise(permutedims(M, (2, 3, 1)))
end
function _masses_kernel(
        x::TimeVarying{I, <:AbstractVector}, lags, origin, step
    ) where {I}
    _isdelay(eltype(x.x)) || return x
    return TimeVarying{I}(_stack_masses(x.x, lags, origin, step))
end
function _masses_kernel(
        x::TimeVarying{I, <:PerStratum{<:AbstractMatrix}}, lags, origin, step
    ) where {I}
    _isdelay(eltype(x.x.x)) || return x
    G = permutedims(_stack_masses(x.x.x, lags, origin, step), (2, 1, 3))
    return TimeVarying{I}(PerStratum(G))
end
function _masses_kernel(
        x::TimeVarying{I, <:Pairwise{<:AbstractArray{<:Any, 3}}},
        lags, origin, step
    ) where {I}
    _isdelay(eltype(x.x.x)) || return x
    A = permutedims(_stack_masses(x.x.x, lags, origin, step), (2, 3, 1, 4))
    return TimeVarying{I}(Pairwise(A))
end
function _masses_kernel(R::Routes, lags, origin, step)
    kernels = map(g -> _masses_kernel(g, lags, origin, step), R.kernels)
    return Routes(map(tuple, R.couplings, kernels)...)
end
