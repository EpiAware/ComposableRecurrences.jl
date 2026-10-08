# The native adjoint rules' entry point. An operator's call builds its
# positional arguments and goes through `adjoint_call`, which routes to the
# rule primitive `_ad` (`Mooncake` `rrule!!` and `Enzyme` rules in the
# extensions) when the operator uses its adjoint and every float is IEEE,
# and otherwise to `_plain`, which the AD backend differentiates.

# Supertype of operators whose call is routed through the native rules. An
# operator type implements `forward(op, Run(), args...) -> (y, cache)` and
# `pullback!(grads, op, Run(), cache)`.
abstract type AbstractOperator end

@doc raw"""
Wrap an operator so it is differentiated by the AD backend's own treatment of
its forward loop, bypassing any hand-written adjoint.

Called exactly like the wrapped operator, it computes the same output,

```math
f_{\mathrm{NoAdjoint(op)}}(u) = f_{\mathrm{op}}(u),
```

for every input ``u``, so its gradient ``\nabla_u f`` is the same quantity
by a different route: the backend's derivative of the forward loop rather
than the hand-written pullback.
Useful to time a hand-written adjoint against plain AD, and to check the two
gradients agree.
Plain `Enzyme` reverse AD of a sparse coupling is wrong, so an active sparse
coupling under `NoAdjoint` throws an `ArgumentError` with `Enzyme`.

# Examples
```jldoctest
using ComposableRecurrences
r = Recurrence([0.2, 0.3, 0.5])
y = ComposableRecurrences.NoAdjoint(r)(fill(1.1, 6); history = ones(3))
round.(y; digits = 3)

# output

6-element Vector{Float64}:
 1.1
 1.122
 1.16
 1.23
 1.271
 1.323
```
"""
struct NoAdjoint{O}
    "The wrapped operator."
    op::O
end

# The call. `route` is the operator itself or its `NoAdjoint`; operators
# with keyword calls add `_invoke` methods that build the positional
# arguments.
_invoke(op::AbstractOperator, route, args...) = adjoint_call(route, args...)
(op::AbstractOperator)(args...; kwargs...) = _invoke(op, op, args...; kwargs...)
(n::NoAdjoint)(args...; kwargs...) = _invoke(n.op, n, args...; kwargs...)
function forward(n::NoAdjoint, ::Run, args...; kwargs...)
    return forward(n.op, Run(), args...; kwargs...)
end

# `op` with the routing of `route`: wrapped in `NoAdjoint` if `route` is.
_reroute(route, op) = op
_reroute(::NoAdjoint, op) = NoAdjoint(op)

# Incremented by every analytic reverse pass, so tests can prove it ran.
const _PULLBACK_CALLS = Threads.Atomic{Int}(0)
_count_pullback() = (Threads.atomic_add!(_PULLBACK_CALLS, 1); nothing)

@doc raw"""
Whether `piece` carries its own analytic adjoint in `role`: a
[`ComposableRecurrences.pullback!`](@ref) method for that role.

For outputs ``o = f(u, \theta)`` of the role, with inputs ``u`` and
parameters ``\theta``, the adjoint computes the cotangents

```math
\bar u = \Big(\frac{\partial o}{\partial u}\Big)^{\top} \bar o, \qquad
\bar\theta = \Big(\frac{\partial o}{\partial \theta}\Big)^{\top} \bar o
```

by hand, where ``\bar o`` is the gradient of a scalar loss with respect to
``o``.

By default it is `true` when `pullback!` has a method for the type of
`piece` and `role` whose other arguments are untyped, so writing the
method is enough.
The lookup is read from the types, so the route costs nothing per call.
A method with a typed `grads` or typed arguments is not found; declare
`uses_adjoint(::T, role) = true` for it, which
[`ComposableRecurrences.PieceInterface`](@ref) checks.
A method of `uses_adjoint` also overrides the default, for example when
the adjoint covers only some values of a type.
If it is `true` but no `pullback!` method fits the arguments, the reverse
pass throws an `ArgumentError`.
An operator uses its adjoint in [`ComposableRecurrences.Run`](@ref) when it
has one.
A [`Recurrence`](@ref) does when its coupling and modifiers allow it;
[Rules and plain AD](@ref adjoint-routing) gives the conditions.

# Arguments
- `piece`: the operator, coupling, modifier or variant.
- `role`: the role.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
CR.uses_adjoint(Recurrence([0.5, 0.5]), CR.Run())

# output

true
```
"""
uses_adjoint(piece, role) = _has_pullback(piece, role)

# Whether `pullback!` has a method for `piece` in `role` that takes untyped
# cotangents and arguments, so a method that fits every call.
# `Core._hasmethod` folds at compile time, and adding a method invalidates
# the code that read it.
_has_pullback(piece, role) = false
function _has_pullback(x, ::Run)
    return Core._hasmethod(Tuple{typeof(pullback!), Any, typeof(x), Run, Any})
end
function _has_pullback(x, ::Pressure)
    sig = Tuple{typeof(pullback!), Any, typeof(x), Pressure, Any, Any, Any}
    return Core._hasmethod(sig)
end
_has_pullback(x, ::Step) = _has_scalar_pullback(x) || _has_vector_pullback(x)
function _has_scalar_pullback(x)
    sig = Tuple{typeof(pullback!), Any, typeof(x), Step, Any, Any, Any, Any}
    return Core._hasmethod(sig)
end
function _has_vector_pullback(x)
    return Core._hasmethod(Tuple{typeof(pullback!), Any, typeof(x), Step, Any, Any, Any})
end

# `pullback!` for an object that uses its adjoint, with a clear error when it
# declares one but has no method for these arguments. The check is on the
# types, so it folds.
function _call_pullback!(grads, x, role, args...)
    sig = Tuple{
        typeof(pullback!), typeof(grads), typeof(x), typeof(role),
        map(typeof, args)...,
    }
    Core._hasmethod(sig) || _no_pullback(x, role)
    return pullback!(grads, x, role, args...)
end
@noinline function _no_pullback(x, role)
    R = nameof(typeof(role))
    throw(
        ArgumentError(
            "$(nameof(typeof(x))) uses its adjoint in $R() (uses_adjoint is " *
                "true) but has no pullback! method for $R() and these " *
                "arguments; add one or declare uses_adjoint(x, $R()) = false"
        )
    )
end

# The entry point: the rule when the operator uses its adjoint and every
# float leaf is IEEE, else plain AD. Both decisions are made from the
# types, so the route is static. An operator whose local derivative
# rebuilds a modifier from its parameters stores at construction whether
# that works (`_rebuilds`), and one whose local derivative suits only some
# arguments says so per call (`_fits`): each is `Val(true)` when nothing
# needs it, so the route still folds, else a `Bool` read here.
# `Vararg{Any, N}` makes the routes specialise on the arguments, which they
# pass to two calls.
adjoint_call(op, args...) = _route(_route_val(op, args...), op, args...)
adjoint_call(n::NoAdjoint, args...) = _plain(n.op, args...)
function _route_val(op, args...)
    return Val(_type_adjoint(op, Run()) && _gate(op, args...) ? :rule : :plain)
end
function _route(::Val{:rule}, op, args::Vararg{Any, N}) where {N}
    return _rule(_both(_rebuilds(op), _fits(op, args...)), op, args...)
end
_fits(op, args...) = Val(true)
_both(::Val{true}, b) = b
_both(a::Bool, ::Val{true}) = a
_both(a::Bool, b::Bool) = a && b
function _route(::Val{:plain}, op, args::Vararg{Any, N}) where {N}
    _note_plain(op, args...)
    return _plain(op, args...)
end
_rule(::Val{true}, op, args::Vararg{Any, N}) where {N} = _ad(op, args...)
function _rule(rebuilds::Bool, op, args::Vararg{Any, N}) where {N}
    rebuilds && return _ad(op, args...)
    _note_plain_type(op, args...)
    return _plain(op, args...)
end

# Whether an operator uses its adjoint from its type alone; an operator
# that also stores a value check adds a method.
_type_adjoint(op, role) = uses_adjoint(op, role)

# The positional Run of an operator and its pullback. Operators with a
# keyword `forward` on `Run()` add methods for their positional form.
_run_forward(op, args...) = forward(op, Run(), args...)
_run_pullback!(grads, op, cache) = _call_pullback!(grads, op, Run(), cache)

# The primal call. The extensions make `_ad` a rule primitive for `Mooncake`
# and `Enzyme`; `_plain` is differentiated by the backend.
_primal(op, args...) = first(_run_forward(op, args...))
_ad(op, args...) = _primal(op, args...)
_plain(op, args...) = _primal(op, args...)

# Note that an operator is differentiated by plain AD: it has a part
# without an adjoint, or a modifier the default pullback cannot rebuild
# from its parameters. The primal `_note_plain_type` does nothing, so a
# call that is not differentiated logs nothing; the extensions' reverse
# rules for it log, once per operator type. It takes the operator and its
# arguments so that a backend sees an active argument and runs the rule,
# and `donotdelete` keeps the call, which has no effect of its own.
function _note_plain(op, args...)
    uses_adjoint(op, Run()) && return nothing
    return _note_plain_type(op, args...)
end
@noinline _note_plain_type(op, args...) = (Base.donotdelete(op, args...); nothing)
const _PLAIN_NOTED = Set{Any}()
const _PLAIN_LOCK = ReentrantLock()
function _log_plain(op)
    T = typeof(op)
    new = @lock _PLAIN_LOCK (T in _PLAIN_NOTED ? false : (push!(_PLAIN_NOTED, T); true))
    new && @info "$(nameof(T)) $(_plain_why(op)), so gradients of it use " *
        "plain AD of the whole operator"
    return nothing
end

# Why an operator takes plain AD; operators that store a failed rebuild
# check name the modifiers it failed for.
const _ADJOINT_NOTE = "has a coupling or modifier without an analytic adjoint"
_plain_why(op) = _ADJOINT_NOTE

# Rules apply when every float leaf is IEEE (Float16/32/64) and every array
# is one whose tangent the wiring can read; dual numbers, BigFloat and other
# arrays take the plain path, as do abstractly typed fields. Integer arrays
# of any type, such as index ranges, and arrays of them carry no tangent.
# `_ok` is one closed function of the types (nothing extends it), evaluated
# once per signature by a generated function: inference does not
# constant-fold the recursion, and an unfolded gate costs a dynamic dispatch
# on every call under `Mooncake`.
const _IEEEFloat = Union{Float16, Float32, Float64}
@generated _gate(xs...) = all(_ok, xs)
function _ok(::Type{T}) where {T}
    T <: _IEEEFloat && return true
    T <: Union{Integer, Nothing, Symbol} && return true
    T <: Real && return false
    T <: AbstractArray{<:Integer} && return true
    T <: Array && return _ok(eltype(T))
    T <: SparseMatrixCSC && return _ok(eltype(T))
    T <: Diagonal && return _ok(fieldtype(T, :diag))
    T <: Union{SubArray, Base.ReshapedArray} && return _ok(fieldtype(T, :parent))
    T <: AbstractArray && return false
    isconcretetype(T) && isstructtype(T) || return false
    for F in fieldtypes(T)
        _ok(F) || return false
    end
    return true
end

@doc raw"""
The cotangent of field `name` in the mirror `x̄` of a struct, or `nothing`
when `x̄` is `nothing` or has no such field.

For a struct with fields ``\theta_1, \dots, \theta_n`` and a scalar loss
``\ell``, the mirror holds

```math
\bar\theta_j = \frac{\partial \ell}{\partial \theta_j},
\qquad j = 1, \dots, n,
```

and this returns ``\bar\theta_j`` for the field named `name`.

A mirror holds a struct's cotangents for a
[`ComposableRecurrences.pullback!`](@ref);
[The gradient mirror](@ref extending-mirror) gives its entry for each field
type.

# Arguments
- `x̄`: the mirror, a NamedTuple of field mirrors or `nothing`.
- `name`: the field.

# Examples
```jldoctest
using ComposableRecurrences
ComposableRecurrences.cotangent((; K = zeros(2)), :K)

# output

2-element Vector{Float64}:
 0.0
 0.0
```
"""
cotangent(::Nothing, name::Symbol) = nothing
cotangent(x̄::NamedTuple, name::Symbol) = get(x̄, name, nothing)
cotangent(x̄, name::Symbol) = getfield(x̄, name)

@doc raw"""
Add `v` to the mirror `x̄` at index `idx`,

```math
\bar x_{\mathrm{idx}} \leftarrow \bar x_{\mathrm{idx}} + v,
```

so the cotangents from every use of a parameter sum.
This is `x̄[idx...] += v` for an array, `x̄[] += v` for a `Ref` (the index
is ignored), the same into the array of a wrapper's `(; x)` mirror, and
nothing for `nothing`.

# Arguments
- `x̄`: the mirror: an array, a `Ref`, `(; x)` or `nothing`.
- `v`: the cotangent to add.
- `idx`: the index into an array mirror.

# Examples
```jldoctest
using ComposableRecurrences
x̄ = zeros(2)
ComposableRecurrences.add_cotangent!(x̄, 1.5, 2)
x̄

# output

2-element Vector{Float64}:
 0.0
 1.5
```
"""
add_cotangent!(::Nothing, v, idx...) = nothing
add_cotangent!(x̄::Base.RefValue, v, idx...) = (x̄[] += v; nothing)
Base.@propagate_inbounds function add_cotangent!(x̄::AbstractArray, v, idx...)
    x̄[idx...] += v
    return nothing
end
Base.@propagate_inbounds function add_cotangent!(x̄::NamedTuple{(:x,)}, v, idx...)
    return add_cotangent!(x̄.x, v, idx...)
end

# Add `v` to entry `(p, q)` of the mirror `K̄` of matrix `K`. A sparse or
# `Diagonal` matrix keeps its structure: an entry outside it gets nothing.
_add_entry!(K̄, K, v, p, q) = add_cotangent!(K̄, v, p, q)
function _add_entry!(K̄, K::SparseMatrixCSC, v, p, q)
    nz̄ = cotangent(K̄, :nzval)
    nz̄ === nothing && return nothing
    rows = rowvals(K)
    for idx in nzrange(K, q)
        rows[idx] == p && (nz̄[idx] += v; break)
    end
    return nothing
end
function _add_entry!(K̄, K::Diagonal, v, p, q)
    p == q && add_cotangent!(cotangent(K̄, :diag), v, p)
    return nothing
end

@doc raw"""
Test the analytic adjoint of `piece` in `role` on the primal arguments
`args` with the AD `backend`'s own rule tester.

The tester checks the pullback against finite differences of the forward
map ``o = f(u)``: for random directions ``\dot u`` and cotangents
``\bar o``,

```math
\big\langle \bar o,\ J \dot u \big\rangle =
\big\langle J^{\top} \bar o,\ \dot u \big\rangle,
\qquad J = \frac{\partial o}{\partial u},
```

with ``J \dot u`` from finite differences and ``J^{\top} \bar o`` from the
pullback.

For an operator, `role` is [`ComposableRecurrences.Run`](@ref) and `args`
are its positional arguments.
Methods come from package extensions: `AutoMooncake` with `Mooncake` loaded
(`Mooncake.TestUtils.test_rule`) and `AutoEnzyme` with `EnzymeTestUtils`
loaded (`test_reverse`, with the operator active and constant).

# Arguments
- `backend`: an `AutoMooncake` or `AutoEnzyme` from ADTypes.
- `piece`: the operator.
- `role`: `Run()`.
- `args`: the positional arguments.

# Examples
```julia
using ComposableRecurrences
methods(ComposableRecurrences.test_adjoint)
```
"""
function test_adjoint end
