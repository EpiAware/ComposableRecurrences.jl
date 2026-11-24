@doc raw"""
A modifier that maps each stratum's value through a function `f`, with
optional parameters `θ`.

At time ``t``, for each [stratum](@ref PerStratum) ``i``,

```math
v'_i = f(v_i, \theta_{t,i}), \qquad s'_i = s_i,
```

where ``v_i`` is the stratum's value when the modifier is reached (after
the modifiers before it in the tuple), ``v'_i`` its value after, and
``s_i`` the unused state.
``\theta_{t,i}`` is the [parameter](@ref ComposableRecurrences.param)
`θ` read at stratum ``i`` and time ``t``.
A tuple or NamedTuple of these is read entry by entry, so `f` receives a
tuple or NamedTuple of scalars.
Without `θ` the map is ``v'_i = f(v_i)``.

The reverse pass, for output cotangent ``\bar v'_i``, is

```math
\bar v_i = \frac{\partial f}{\partial v}(v_i, \theta_{t,i})\, \bar v'_i,
\qquad
\bar\theta_{t,i} \mathrel{+}=
    \frac{\partial f}{\partial \theta}(v_i, \theta_{t,i})\, \bar v'_i,
```

with the partial derivatives from `derivative` when given, or else from a
local forward-mode derivative of `f`.
`derivative(v)` returns ``\partial f / \partial v`` without `θ`, and
`derivative(v, θ)` returns
``(\partial f / \partial v, \partial f / \partial \theta)``, the second
shaped as ``\theta_{t,i}``.
A `derivative` with any method that takes three arguments, a catch-all or
varargs one included, is called as `derivative(v, θ, y)` instead, with the
step's output ``y = f(v, \theta)`` (and `θ` `nothing` without parameters),
returning the same pair.
The reverse pass of a [`Recurrence`](@ref) passes ``y`` from the forward
pass, so a derivative written in terms of the value need not recompute it.
Values captured by `f` (a closure, or a callable struct with float fields)
are not in ``\theta``, so without `derivative` the AD backend
differentiates the [`Recurrence`](@ref) holding such a map.

Two maps have their own pullbacks, used unless `derivative` is given.
`Transform(+, b)` adds ``b_{t,i}`` where it sits in the tuple.
After a [`ComposableRecurrences.Depletion`](@ref), the added values are
neither scaled by nor drawn from the pool.
Alone, `Transform(+, TimeVarying(PerStratum(B)))` gives the values of
passing `B` as `add`.
`Transform(clamp, lo, hi)` bounds each value to
``[\ell_{t,i}, u_{t,i}]``, the parameters `lo` and `hi`, with
``\ell_{t,i} \le u_{t,i}``.
Its pullback sends the cotangent to the active bound, or to ``v_i`` when
neither is.

It acts on a [`Recurrence`](@ref) and is pointwise.
Its rule takes the local forward-mode derivative or `derivative`, or a
hand-written pullback for `+` and `clamp`.

# Arguments
- `f`: the map, called as `f(v)` or `f(v, θ)`.
- `θ`: the parameters, or `nothing`.
- `lo`, `hi`: with `clamp`, the lower and upper bounds, each a parameter.

# Keyword Arguments
- `derivative`: the derivative of `f`, called as `derivative(v)`,
  `derivative(v, θ)` or `derivative(v, θ, y)`, or `nothing` for the local
  one.

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

Each partial derivative of `G` contains `G` itself, so its derivative can
take the output:

```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
G(s, θ) = (θ.p / (1 - (1 - θ.p) * s))^θ.r
function dG(s, θ, y)
    D = 1 - (1 - θ.p) * s
    return y * θ.r * (1 - θ.p) / D,
        (; r = y * log(θ.p / D), p = y * θ.r * (1 - s) / (θ.p * D))
end
q = CR.Transform(G, (; r = 0.5, p = 0.4); derivative = dG)
y = Recurrence([1.0]; modifiers = (q,))(; history = [0.0], stop = 3)
round.(y; digits = 3)

# output

3-element Vector{Float64}:
 0.632
 0.803
 0.879
```
"""
struct Transform{F, P, D}
    "The map, called as `f(v)` or `f(v, θ)`."
    f::F
    "The parameters, or `nothing`."
    θ::P
    "The derivative of `f`, or `nothing` for the local one."
    derivative::D
    function Transform{F, P, D}(f::F, θ::P, derivative::D) where {F, P, D}
        _check_theta(θ)
        return new{F, P, D}(f, θ, derivative)
    end
end

function Transform(f, θ = nothing; derivative = nothing)
    d = _output_form(derivative)
    return Transform{typeof(f), typeof(θ), typeof(d)}(f, θ, d)
end
# The bounds are held as `θ = (lo, hi)`, and passed only as `lo, hi`.
function Transform(::typeof(clamp), lo, hi)
    θ = (_check_param(:lo, lo), _check_param(:hi, hi))
    return Transform{typeof(clamp), typeof(θ), Nothing}(clamp, θ, nothing)
end
@noinline function Transform(::typeof(clamp), θ = nothing; derivative = nothing)
    throw(ArgumentError("pass clamp's bounds as Transform(clamp, lo, hi)"))
end
# `Adapt` and the dual-number rebuild construct it from its fields.
ConstructionBase.constructorof(::Type{<:Transform}) = _transform
function _transform(f, θ, derivative)
    d = _output_form(derivative)
    return Transform{typeof(f), typeof(θ), typeof(d)}(f, θ, d)
end

# A derivative that also takes the step's output, `derivative(v, θ, y)`, is
# marked once here, so the reverse pass picks its form by dispatch.
struct _WithOutput{D}
    derivative::D
end
_output_form(d) = hasmethod(d, Tuple{Any, Any, Any}) ? _WithOutput(d) : d
_output_form(::Nothing) = nothing
_output_form(d::_WithOutput) = d
_user_derivative(d) = d
_user_derivative(d::_WithOutput) = d.derivative

_check_theta(::Nothing) = nothing
function _check_theta(θ::Union{Tuple, NamedTuple})
    foreach(x -> _check_param(:θ, x), θ)
    return nothing
end
_check_theta(θ) = (_check_param(:θ, θ); nothing)

# == Traits ==

# Whether the local derivative covers every parameter. A closure's float
# fields are out of its reach, so plain AD runs instead.
function _local_derivative(m::Transform)
    return m.derivative !== nothing || param_eltype(m.f) <: Union{Bool, Integer}
end

blocks(::Transform) = (1, 1)
isstateless(::Transform) = true
uses_adjoint(m::Transform, ::Step) = _local_derivative(m)
# Only the local derivative takes dual numbers: `+` without `b` and `clamp`
# have their own pullbacks.
function _needs_duals(m::Transform)
    return m.derivative === nothing && _local_derivative(m) && !_own_pullback(m)
end
_own_pullback(::Transform) = false
_own_pullback(::Transform{typeof(+), Nothing, Nothing}) = true
_own_pullback(::Transform{typeof(clamp), <:Tuple{Any, Any}, Nothing}) = true
function _dual_why(::Transform)
    return "a `Transform` without a `derivative` takes its local derivative " *
        "with `ForwardDiff`; add `using ForwardDiff` for the faster rule"
end
_scalar_params(::Transform) = false
_local_params(::Transform) = false
_array_params(::Transform) = false

_theta_pairs(::Nothing) = ()
_theta_pairs(θ::Union{Tuple, NamedTuple}) = map(x -> :θ => x, Tuple(θ))
_theta_pairs(θ) = (:θ => θ,)

# == Init and Step ==

function forward!(m::Transform, ::Init, s, history)
    return _zero_state!(s, _theta_pairs(m.θ)...)
end
pullback!(grads, ::Transform, ::Init, s, history) = nothing

# The parameters at stratum `k` and absolute time `t`.
_theta_at(::Nothing, k, t) = nothing
_theta_at(θ::Union{Tuple, NamedTuple}, k, t) = map(x -> param(x, k, t), θ)
_theta_at(θ, k, t) = param(θ, k, t)

_call(f, v, ::Nothing) = f(v)
_call(f, v, θ) = f(v, θ)
_call(::typeof(clamp), v, θ::Tuple{Any, Any}) = clamp(v, θ...)

function forward!(m::Transform, ::Step, v, s, t)
    for k in eachindex(v)
        v[k] = _call(m.f, v[k], _theta_at(m.θ, k, t))
    end
    return nothing
end

# == Pullbacks ==

function pullback!(grads, m::Transform, ::Step, v, s, t)
    _local_derivative(m) || throw(
        ArgumentError(
            "a Transform whose map has float fields is differentiated by " *
                "the AD backend; pass them in θ or supply derivative"
        )
    )
    v̄, θ̄ = grads.v, cotangent(grads.piece, :θ)
    for k in eachindex(v)
        θk = _theta_at(m.θ, k, t)
        ∂v, ∂θ = _derivative(m.derivative, m.f, v[k], θk, grads, k)
        _add_theta!(θ̄, m.θ, ∂θ, v̄[k], k, t)
        v̄[k] *= ∂v
    end
    return nothing
end

# Without `b`, `Transform(+)` is the identity.
function pullback!(
        grads, ::Transform{typeof(+), Nothing, Nothing}, ::Step, v, s, t
    )
    return nothing
end

# `Transform(clamp, lo, hi)` matches `clamp`'s branches: above `hi`, then
# below `lo`, else `v`.
function pullback!(
        grads, m::Transform{typeof(clamp), <:Tuple{Any, Any}, Nothing}, ::Step,
        v, s, t
    )
    v̄ = grads.v
    lo, hi = m.θ
    θ̄ = _arg_mirrors(cotangent(grads.piece, :θ), m.θ)
    l̄o, h̄i = θ̄ === nothing ? (nothing, nothing) : Tuple(θ̄)
    for k in eachindex(v)
        if v[k] > param(hi, k, t)
            add_param!(h̄i, hi, v̄[k], k, t)
            v̄[k] = zero(v̄[k])
        elseif v[k] < param(lo, k, t)
            add_param!(l̄o, lo, v̄[k], k, t)
            v̄[k] = zero(v̄[k])
        end
    end
    return nothing
end

# Add `ȳ ∂θ` into the mirror of `θ` at stratum `k` and time `t`. The mirror
# holds `param_eltype`, a dual under forward-over-reverse, as each `∂θ`
# depends on all of `(v, θ)`.
_add_theta!(θ̄, ::Nothing, ∂θ, ȳ, k, t) = nothing
function _add_theta!(θ̄, θ::Union{Tuple, NamedTuple}, ∂θ, ȳ, k, t)
    θ̄ = _arg_mirrors(θ̄, θ)
    θ̄ === nothing && return nothing
    map(values(θ̄), values(θ), values(∂θ)) do b, x, d
        add_param!(b, x, ȳ * d, k, t)
    end
    return nothing
end
_add_theta!(θ̄, θ, ∂θ, ȳ, k, t) = add_param!(θ̄, θ, ȳ * ∂θ, k, t)

# == Local derivative ==

# `(∂f/∂v, ∂f/∂θ)`: from a supplied derivative, or else the local
# forward-mode derivative, one dual per scalar of `(v, θ)`.
_derivative(df, f, v, θ) = θ === nothing ? (df(v), nothing) : df(v, θ)
_derivative(::Nothing, f, v, θ) = _forward_derivative(f, v, θ)
# The output form reads the step's output from `grads.out` where the
# reverse pass passes it, and recomputes it where it does not.
_derivative(df, f, v, θ, grads, k) = _derivative(df, f, v, θ)
function _derivative(df::_WithOutput, f, v, θ, grads, k)
    return df.derivative(v, θ, _step_output(grads, f, v, θ, k))
end
function _step_output(grads::NamedTuple{N}, f, v, θ, k) where {N}
    return :out in N ? @inbounds(grads.out[k]) : _call(f, v, θ)
end
# Whether a modifier's step pullback reads its output, `grads.out`.
_wants_output(m) = false
_wants_output(::Transform{<:Any, <:Any, <:_WithOutput}) = true

struct _TransformTag end

# The value of `f(xs...)` with its partial derivatives in each of its
# scalar arguments, from one evaluation.
function _forward_value_and_derivative(f, xs::Tuple{Real, Vararg{Real}})
    y = f(_transform_seeds(promote(xs...))...)
    return _transform_value(y), _transform_partials(y, Val(length(xs)))
end
function _forward_derivative(f, xs::Tuple{Real, Vararg{Real}})
    return last(_forward_value_and_derivative(f, xs))
end
function _forward_derivative(f, v::Real, ::Nothing)
    return only(_forward_derivative(f, (v,))), nothing
end
_forward_derivative(f, v::Real, θ::Real) = _forward_derivative(f, (v, θ))
function _forward_derivative(f, v::Real, θ::Union{Tuple, NamedTuple})
    xs = _transform_seeds(promote(v, values(θ)...))
    y = f(first(xs), _restructure(θ, Base.tail(xs)))
    ∂ = _transform_partials(y, Val(length(xs)))
    return first(∂), _restructure(θ, Base.tail(∂))
end

_restructure(::Tuple, x) = x
_restructure(::NamedTuple{K}, x) where {K} = NamedTuple{K}(x)

# The seeds and the partials of the map's output are in the dual-number
# extension; an output without the seeds' tag is constant in `(v, θ)`.
function _transform_seeds(xs...)
    return _need_forwarddiff("`Transform` without a `derivative`")
end
_transform_partials(y::Real, ::Val{N}) where {N} = ntuple(_ -> zero(y), Val(N))
_transform_value(y::Real) = y

@implements PieceInterface{(:pointwise, :nstate, :pullback)} Transform [
    Arguments(;
        piece = Transform(
            (v, θ) -> θ.a * v + θ.b, (; a = PerStratum([0.5, 2.0]), b = 0.1)
        ),
        role = Step(), args = ([2.0, 3.0], [0.0, 0.0], 1)
    ),
    Arguments(;
        piece = Transform(log1p), role = Init(), args = (zeros(2), ones(2, 3))
    ),
    Arguments(;
        piece = Transform(+, TimeVarying(PerStratum([0.5 1.0; 0.2 0.1]))),
        role = Step(), args = ([2.0, 3.0], [0.0, 0.0], 2)
    ),
    Arguments(;
        piece = Transform(+, 0.5), role = Init(), args = (zeros(2), ones(2, 3))
    ),
    Arguments(;
        piece = Transform(clamp, 0.0, 2.5), role = Step(),
        args = ([2.0, 3.0], [0.0, 0.0], 1)
    ),
]
