@doc raw"""
A modifier parameter computed from other parameters by a function `f`.

At stratum ``k`` and absolute time ``t``,

```math
u_{t,k} = f\big(a_{1,t,k}, \dots, a_{n,t,k}\big),
```

where ``a_{j,t,k}`` is argument ``j`` read by
[`ComposableRecurrences.param`](@ref): one value, [`PerStratum`](@ref),
[`TimeVarying`](@ref), `TimeVarying(PerStratum(x))` or another `Derived`.
A `Derived` goes wherever a modifier takes a parameter.

The reverse pass, for the cotangent ``\bar u_{t,k}`` of the value read, is

```math
\bar a_{j,t,k} \mathrel{+}= \frac{\partial f}{\partial a_j}\big(a_{1,t,k}, \dots, a_{n,t,k}\big)\, \bar u_{t,k},
```

with the partial derivatives from one local forward-mode derivative of `f`.
Values captured inside `f` (a closure, or a callable struct with float
fields) are not arguments: a [`Recurrence`](@ref) with such a map is
differentiated by the AD backend instead, so they keep their gradients.

Arithmetic with a `Derived` on either side builds another `Derived`, so
`κ * x`, `x + c`, `x - c`, `x / N`, `x ^ p` and `-x` all work when `x` is
a `Derived`.
Wrap a plain parameter as `Derived(identity, x)` to start such an
expression.

Scope: modifier parameters; analytic adjoint from the local forward-mode
derivative.

# Arguments
- `f`: the function, called as `f(a_1, ..., a_n)` on the arguments' values.
- `args`: the arguments, at least one, each a parameter.

# Examples
```@example
using ComposableRecurrences
CR = ComposableRecurrences
# A reproduction number from a daily log growth rate and a scale.
logR = TimeVarying(0.3 .* sin.(1:10))
β = 0.8 * Derived(exp, logR)
Recurrence([0.5, 0.5]; modifiers = (CR.Transform(*, β),))(; history = ones(2), stop = 10)
```
"""
struct Derived{F, A <: Tuple}
    "The function, called on the arguments' values."
    f::F
    "The arguments, each a parameter."
    args::A
    function Derived(f::F, args::A) where {F, A <: Tuple}
        isempty(args) && throw(ArgumentError("Derived($f) needs at least one argument"))
        foreach(a -> _check_param(:args, a), args)
        return new{F, A}(f, args)
    end
end

Derived(f, args...) = Derived(f, args)

param(x::Derived, k, t) = x.f(map(a -> param(a, k, t), x.args)...)

function add_param!(x̄, x::Derived, v, k, t)
    ā = cotangent(x̄, :args)
    ā === nothing && return nothing
    ∂ = _forward_derivative(x.f, map(a -> param(a, k, t), x.args))
    foreach((b, a, d) -> add_param!(b, a, v * d, k, t), ā, x.args, ∂)
    return nothing
end

_check_param(name, x::Derived) = x
function _check_param_strata(name, x::Derived, S)
    foreach(a -> _check_param_strata(name, a, S), x.args)
    return nothing
end
# Constant over time when every argument is.
function _check_constant(name, x::Derived)
    foreach(a -> _check_constant(name, a), x.args)
    return x
end
_float_param(x::Derived) = x
# Walk the map and the arguments directly: the generic field walk recurses
# through a nested `Derived` past inference's recursion limit.
function _check_times(name, x::Derived, stop)
    _check_times(name, x.f, stop)
    _check_times(name, x.args, stop)
    return nothing
end

# Whether every `Derived` inside a value of type `T` has a map without float
# fields of its own, so its local derivative covers every parameter. A
# closed function of the type, evaluated once per type so the route folds.
@generated _derived_local(x) = _derived_local_type(x)
function _derived_local_type(::Type{T}) where {T}
    T <: Derived &&
        return _fieldfree_type(fieldtype(T, :f)) && _derived_local_type(fieldtype(T, :args))
    T <: Union{Real, AbstractArray, Nothing, Symbol, AbstractString} && return true
    isconcretetype(T) && isstructtype(T) || return true
    return all(_derived_local_type, fieldtypes(T))
end
# The type-level form of `_fieldfree`: no float leaves in fields.
function _fieldfree_type(::Type{T}) where {T}
    T <: Union{Bool, Integer, Nothing, Symbol, AbstractString} && return true
    T <: Real && return false
    T <: AbstractArray && return _fieldfree_type(eltype(T))
    isconcretetype(T) && isstructtype(T) || return false
    return all(_fieldfree_type, fieldtypes(T))
end

# Arithmetic with a `Derived` on either side lowers to `Derived`; the other
# side is any parameter.
const _Param = Union{Real, PerStratum, TimeVarying, Derived}
for op in (:+, :-, :*, :/, :^)
    @eval begin
        Base.$op(a::Derived, b::_Param) = Derived($op, a, b)
        Base.$op(a::Union{Real, PerStratum, TimeVarying}, b::Derived) = Derived($op, a, b)
    end
end
Base.:-(a::Derived) = Derived(-, a)
