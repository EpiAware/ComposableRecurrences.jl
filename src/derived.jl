@doc raw"""
A value computed from other values by a function `f`: a modifier parameter,
or the weights of a cohort kernel.

As a modifier parameter, at stratum ``k`` and absolute time ``t``,

```math
u_{t,k} = f\big(a_{1,t,k}, \dots, a_{n,t,k}\big),
```

where ``a_{j,t,k}`` is argument ``j`` read by
[`ComposableRecurrences.param`](@ref), any parameter including another
`Derived`.
A `Derived` of parameters goes wherever a modifier takes a parameter.

As a kernel, `TimeVarying(d, Primary())`, the weight on lag ``l`` of cohort
``\tau`` (the input at time ``\tau``) in stratum ``k`` is

```math
w_{k,l}(\tau) = f\big(a_{1,k,l}(\tau), \dots, a_{n,k,l}(\tau)\big),
```

with each argument read at that entry:

| argument                          | read at entry ``(k, l, \tau)``    |
|:--------------------------------- |:--------------------------------- |
| a number `c`                      | `c`                               |
| a vector `p` of lag weights       | `p[i]`, the kernel's `i`th lag    |
| `PerStratum(v)`, `PerStratum(P)`  | `v[k]`, `P[k, i]`                 |
| `TimeVarying(x, Primary())`       | at time ``\tau``                  |
| `TimeVarying(x)`                  | at time ``\tau + l``              |
| `Derived`, [`ComposableRecurrences.Survival`](@ref) | its own weight |

`i` is the lag's index in the kernel: lag ``l = i - 1`` in a
[`Convolution`](@ref) and ``l = i`` in a [`Recurrence`](@ref).
So a `TimeVarying(x)` argument is read, in both uses, at the time the value
acts: the step ``t`` of a modifier, or the time ``\tau + l`` a weight lands,
and a calendar-time series such as a hazard is `TimeVarying(h)`.
Every argument with a lag axis has the kernel's number of lags, and every
argument with a strata axis the call's strata; a kernel with any of them is
per stratum.
The arguments with a lag axis, and those with `Primary()` indexing, make a
`Derived` a kernel only: as a modifier parameter it is an error.

A call with a kernel computes the weights it reads inside its own call, a
block of cohorts at a time, and runs as with the dense kernel of those
weights, on the calling task and on host arrays.
[`ComposableRecurrences.kernel_weights`](@ref) returns them as an array.

The reverse pass, for the cotangent ``\bar u`` of a value read, is

```math
\bar a_j \mathrel{+}= \frac{\partial f}{\partial a_j}\big(a_1, \dots, a_n\big)\, \bar u,
```

with the partial derivatives in closed form for `+`, `-`, `*` and `/` in a
kernel, and otherwise from one local forward-mode derivative of `f`, which
needs the dual-number extension loaded.
Values captured inside `f` (a closure, or a callable struct with float
fields) are not arguments: an operator with such a map is differentiated by
the AD backend instead, so they keep their gradients.

Arithmetic with a `Derived` on either side builds another `Derived`, so
`κ * x`, `x + c`, `x - c`, `x / N`, `x ^ p` and `-x` all work when `x` is
a `Derived`, with a number, a vector, `PerStratum`, `TimeVarying` or a
`Survival` on the other side.
Wrap a plain parameter as `Derived(identity, x)` to start such an
expression.

# Arguments
- `f`: the function, called as `f(a_1, ..., a_n)` on the arguments' values.
- `args`: the arguments, at least one.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
# A reproduction number from a daily log growth rate and a scale.
logR = TimeVarying(0.3 .* sin.(1:10))
β = 0.8 * Derived(exp, logR)
r = Recurrence([0.5, 0.5]; modifiers = (CR.Transform(*, β),))
round.(r(; history = ones(2), stop = 10); digits = 3)

# output

10-element Vector{Float64}:
 1.03
 1.067
 0.875
 0.619
 0.448
 0.392
 0.409
 0.432
 0.381
 0.276
```

A delay pmf whose mass is scaled down for cohorts from time 3 on:

```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
p = [0.5, 0.3, 0.2]
scale = TimeVarying([1.0, 1.0, 0.5, 0.5], CR.Primary())
K = TimeVarying(Derived(*, p, scale), CR.Primary())
round.(Convolution(K)(ones(4)); digits = 3)

# output

4-element Vector{Float64}:
 0.5
 0.8
 0.75
 0.6
```
"""
struct Derived{F, A <: Tuple}
    "The function, called on the arguments' values."
    f::F
    "The arguments."
    args::A
    function Derived(f::F, args::A) where {F, A <: Tuple}
        isempty(args) && throw(ArgumentError("Derived($f) needs at least one argument"))
        map(_check_argument, args)
        _joined(_coef_lags, args, "lags")
        _joined(_coef_strata, args, "strata")
        return new{F, A}(f, args)
    end
end

Derived(f, args...) = Derived(f, args)

param(x::Derived, k, t) = x.f(_params_at(x.args, k, t)...)

# Unrolled over the arguments, so a nested `Derived` recurses only into
# simpler `Derived` types and infers: a helper shared by every level would
# meet inference's recursion limit and dispatch at run time.
@generated function add_param!(x̄, x::Derived{F, A}, v, k, t) where {F, A}
    calls = (
        :(add_param!(ā[$i], x.args[$i], v * ∂[$i], k, t)) for i in 1:fieldcount(A)
    )
    return quote
        ā = _arg_mirrors(cotangent(x̄, :args), x.args)
        ā === nothing && return nothing
        ∂ = _forward_derivative(x.f, _params_at(x.args, k, t))
        $(calls...)
        return nothing
    end
end

# The arguments' values, read one tuple entry at a time: a `map` closure
# over arguments of mixed types allocates on each read in the reverse pass.
_params_at(::Tuple{}, k, t) = ()
function _params_at(a::Tuple, k, t)
    return (param(first(a), k, t), _params_at(Base.tail(a), k, t)...)
end

# As a modifier parameter every argument is a parameter.
function _check_param(name, x::Derived)
    map(a -> _check_param(name, a), x.args)
    return x
end
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

# Whether every `Derived` inside a value of type `T` has a map without float
# fields of its own, so its local derivative covers every parameter. A
# closed function of the type, evaluated once per type so the route folds.
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
# After its helpers: a generator sees only the methods defined before it.
@generated _derived_local(x) = _derived_local_type(x)

# Arithmetic with a `Derived` on either side lowers to `Derived`; the other
# side is any parameter.
# A vector of lag weights is an operand too, for a kernel.
const _Param = Union{Real, PerStratum, TimeVarying, Derived}
const _Operand = Union{Real, AbstractVector{<:Real}, PerStratum, TimeVarying}
for op in (:+, :-, :*, :/, :^)
    @eval begin
        Base.$op(a::Derived, b::Union{_Operand, Derived}) = Derived($op, a, b)
        Base.$op(a::_Operand, b::Derived) = Derived($op, a, b)
    end
end
Base.:-(a::Derived) = Derived(-, a)
