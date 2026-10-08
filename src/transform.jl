@doc raw"""
Maps each stratum's value through a function `f`, with optional
parameters `θ`.
A stratum is one of ``S`` parallel series computed together, such as a
place or an age group.

At time ``t``, for each stratum ``i``,

```math
v'_i = f(v_i, \theta_{t,i}), \qquad s'_i = s_i,
```

where ``v_i`` is the stratum's value when the modifier is reached (after
the modifiers before it in the tuple), ``v'_i`` its value after, and
``s_i`` the unused state.
``\theta_{t,i}`` is `θ` read at stratum ``i`` and absolute time ``t``, as
every modifier parameter is: one value ``\theta``, `PerStratum(θ)` giving
``\theta_i``, `TimeVarying(θ)` giving ``\theta_t``, or
`TimeVarying(PerStratum(θ))` giving ``\theta_{t,i}``.
A tuple or NamedTuple of these is read entry by entry, so `f` receives a
tuple or NamedTuple of scalars.
Without `θ` the map is ``v'_i = f(v_i)``.

The reverse pass, for output cotangent ``\bar v'_i``, is

```math
\bar v_i = \frac{\partial f}{\partial v}(v_i, \theta_{t,i})\, \bar v'_i,
\qquad
\bar\theta_{t,i} \mathrel{+}= \frac{\partial f}{\partial \theta}(v_i, \theta_{t,i})\, \bar v'_i,
```

with the partial derivatives from `derivative` when given, or else from a
local forward-mode derivative of `f`.
`derivative(v)` returns ``\partial f / \partial v`` without `θ`, and
`derivative(v, θ)` returns
``(\partial f / \partial v, \partial f / \partial \theta)``, the second
shaped as ``\theta_{t,i}``.
Values captured inside `f` (a closure, or a callable struct with float
fields) are not in ``\theta``: without `derivative` the
[`Recurrence`](@ref) holding such a map is differentiated by the AD
backend instead, so they keep their gradients.

Scope: [`Recurrence`](@ref); pointwise; analytic adjoint from the local
forward-mode derivative or `derivative`.

# Arguments
- `f`: the map, called as `f(v)` or `f(v, θ)`.
- `θ`: the parameters, or `nothing`.

# Keyword Arguments
- `derivative`: the derivative of `f`, or `nothing` for the local one.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
# Iterate a probability generating function, q_t = G(q_{t-1}) from q_0 = 0:
# q_t is the probability that a negative binomial branching process has
# died out by generation t.
G(s, θ) = (θ.p / (1 - (1 - θ.p) * s))^θ.r
q = CR.Transform(G, (; r = 0.5, p = 0.4))
y = Recurrence([1.0]; modifiers = (q,))(; history = [0.0], stop = 6)
round.(y; digits = 3)

# output

6-element Vector{Float64}:
 0.632
 0.803
 0.879
 0.92
 0.945
 0.961
```

```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
# One saturation level per stratum.
sat = CR.Transform((v, c) -> c * v / (c + v), PerStratum([5.0, 20.0]))
y = Recurrence([0.5, 0.5]; modifiers = (sat,))(fill(1.5, 2, 6); history = ones(2, 2))
round.(y; digits = 3)

# output

2×6 Matrix{Float64}:
 1.154  1.221  1.313  1.377  1.438  1.484
 1.395  1.648  2.049  2.435  2.879  3.324
```
"""
struct Transform{F, P, D}
    "The map, called as `f(v)` or `f(v, θ)`."
    f::F
    "The parameters, or `nothing`."
    θ::P
    "The derivative of `f`, or `nothing` for the local one."
    derivative::D
    function Transform(f::F, θ::P, derivative::D) where {F, P, D}
        _check_theta(θ)
        return new{F, P, D}(f, θ, derivative)
    end
end

function Transform(f, θ = nothing; derivative = nothing)
    return Transform(f, θ, derivative)
end

_check_theta(::Nothing) = nothing
function _check_theta(θ::Union{Tuple, NamedTuple})
    foreach(x -> _check_param(:θ, x), θ)
    return nothing
end
_check_theta(θ) = (_check_param(:θ, θ); nothing)

# Whether the local derivative covers every parameter: a supplied
# derivative, or a map with no float fields of its own.
_local_derivative(m::Transform) = m.derivative !== nothing || _fieldfree(m.f)
_fieldfree(f) = param_eltype(f) <: Union{Bool, Integer}

ispointwise(::Transform) = true
_stateless(::Transform) = true
# The reverse pass below covers every parameter type when the derivative
# is local. A map with float fields of its own is left to plain AD, not to
# the default pointwise pullback, which does not reach a closure's fields.
uses_adjoint(m::Transform, ::Step) = _local_derivative(m)
_scalar_params(::Transform) = false

_theta_pairs(::Nothing) = ()
_theta_pairs(θ::Union{Tuple, NamedTuple}) = map(x -> :θ => x, Tuple(θ))
_theta_pairs(θ) = (:θ => θ,)

forward(m::Transform, ::Init, s, history) = _zero_state!(s, _theta_pairs(m.θ)...)
pullback!(grads, ::Transform, ::Init, s, history) = nothing

# The parameters at stratum `k` and absolute time `t`.
_theta_at(::Nothing, k, t) = nothing
_theta_at(θ::Union{Tuple, NamedTuple}, k, t) = map(x -> param(x, k, t), θ)
_theta_at(θ, k, t) = param(θ, k, t)

_call(f, v, ::Nothing) = f(v)
_call(f, v, θ) = f(v, θ)

function forward(m::Transform, ::Step, v, s, t, k)
    return _call(m.f, v, _theta_at(m.θ, k, t)), s
end

function pullback!(grads, m::Transform, ::Step, v, s, t, k)
    _local_derivative(m) || throw(
        ArgumentError(
            "a Transform whose map has float fields is differentiated by " *
                "the AD backend; pass them in θ or supply derivative"
        )
    )
    ∂v, ∂θ = _derivative(m.derivative, m.f, v, _theta_at(m.θ, k, t))
    _add_theta!(cotangent(grads.piece, :θ), m.θ, ∂θ, grads.v, k, t)
    return grads.v * ∂v, grads.s
end

# Add `ȳ ∂θ` into the mirror of `θ` at stratum `k` and time `t`. Each
# entry's `∂θ` depends on every entry of `(v, θ)`, so a mirror holds the
# modifier's `param_eltype` (a dual for forward-over-reverse), not each
# entry's own type.
_add_theta!(θ̄, ::Nothing, ∂θ, ȳ, k, t) = nothing
function _add_theta!(θ̄, θ::Union{Tuple, NamedTuple}, ∂θ, ȳ, k, t)
    θ̄ === nothing && return nothing
    map(values(θ̄), values(θ), values(∂θ)) do b, x, d
        add_param!(b, x, ȳ * d, k, t)
    end
    return nothing
end
_add_theta!(θ̄, θ, ∂θ, ȳ, k, t) = add_param!(θ̄, θ, ȳ * ∂θ, k, t)

# `(∂f/∂v, ∂f/∂θ)`: from a supplied derivative, or else the local
# forward-mode derivative.
_derivative(df, f, v, θ) = _supplied_derivative(df, v, θ)
_derivative(::Nothing, f, v, θ) = _forward_derivative(f, v, θ)

_supplied_derivative(df, v, ::Nothing) = (df(v), nothing)
_supplied_derivative(df, v, θ) = df(v, θ)

# The local forward-mode derivative of the map: one dual per scalar of
# `(v, θ)`, evaluated once.
struct _TransformTag end

# The partial derivatives of `f(xs...)` in each of its scalar arguments.
function _forward_derivative(f, xs::Tuple{Real, Vararg{Real}})
    return _transform_partials(f(_transform_seeds(promote(xs...))...), Val(length(xs)))
end
_forward_derivative(f, v::Real, ::Nothing) = (only(_forward_derivative(f, (v,))), nothing)
_forward_derivative(f, v::Real, θ::Real) = _forward_derivative(f, (v, θ))
function _forward_derivative(f, v::Real, θ::Union{Tuple, NamedTuple})
    xs = _transform_seeds(promote(v, values(θ)...))
    y = f(first(xs), _restructure(θ, Base.tail(xs)))
    ∂ = _transform_partials(y, Val(length(xs)))
    return first(∂), _restructure(θ, Base.tail(∂))
end

_restructure(::Tuple, x) = x
_restructure(::NamedTuple{K}, x) where {K} = NamedTuple{K}(x)

# A `ForwardDiff.Tag` orders this dual against any outer one, so the
# derivative also runs on dual inputs.
function _transform_seeds(xs::Tuple{T, Vararg{T, M}}) where {T, M}
    N = Val(M + 1)
    tag = typeof(ForwardDiff.Tag(_TransformTag(), T))
    return ntuple(N) do i
        ForwardDiff.Dual{tag}(xs[i], ntuple(j -> T(i == j), N))
    end
end

# The partials of the map's output; an output without this tag is constant
# in `(v, θ)`.
function _transform_partials(
        y::ForwardDiff.Dual{<:ForwardDiff.Tag{_TransformTag}}, ::Val{N}
    ) where {N}
    return ntuple(i -> ForwardDiff.partials(y, i), Val(N))
end
_transform_partials(y::Real, ::Val{N}) where {N} = ntuple(_ -> zero(y), Val(N))

@implements PieceInterface{(:pointwise, :nstate)} Transform [
    Arguments(;
        piece = Transform(
            (v, θ) -> θ.a * v + θ.b, (; a = PerStratum([0.5, 2.0]), b = 0.1)
        ),
        role = Step(), args = ([2.0, 3.0], [0.0, 0.0], 1)
    ),
    Arguments(;
        piece = Transform(log1p), role = Init(), args = (zeros(2), ones(2, 3))
    ),
]
