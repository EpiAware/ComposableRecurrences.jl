# The native adjoint rules' entry point. An operator's call builds its
# positional arguments and goes through `adjoint_call`, which routes to the
# rule primitive `_ad` (`Mooncake` `rrule!!` and `Enzyme` rules in the
# extensions) when the operator declares its adjoint and every float is
# IEEE, and otherwise to `_plain`, which the AD backend differentiates.

# Supertype of operators whose call is routed through the native rules. An
# operator type implements `forward(op, Run(), args...) -> (y, cache)` and
# `pullback!(grads, op, Run(), cache)` with `uses_adjoint(op, Run()) = true`.
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
```@example
using ComposableRecurrences
r = Recurrence([0.2, 0.3, 0.5])
ComposableRecurrences.NoAdjoint(r)(fill(1.1, 6); history = ones(3))
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
parameters ``\theta``, a declared adjoint computes the cotangents

```math
\bar u = \Big(\frac{\partial o}{\partial u}\Big)^{\top} \bar o, \qquad
\bar\theta = \Big(\frac{\partial o}{\partial \theta}\Big)^{\top} \bar o
```

by hand, where ``\bar o`` is the gradient of a scalar loss with respect to
``o``.

The author declares it next to the `pullback!` method; the default is
`false`.
An operator uses its adjoint in [`ComposableRecurrences.Run`](@ref) when it
declares it; a [`Recurrence`](@ref) does when its coupling does in
[`ComposableRecurrences.Pressure`](@ref) and each modifier does in
[`ComposableRecurrences.Step`](@ref) or is pointwise with only scalar float
parameters (those are differentiated locally per value).
Otherwise the whole operator is differentiated by plain AD of its forward
loop, logged once per operator type.

# Arguments
- `piece`: the operator, coupling, modifier or variant.
- `role`: the role.

# Examples
```@example
using ComposableRecurrences
CR = ComposableRecurrences
CR.uses_adjoint(Recurrence([0.5, 0.5]), CR.Run())
```
"""
uses_adjoint(piece, role) = false

# The entry point: the rule path when the operator uses its adjoint and
# every float leaf is IEEE, else plain AD. Both decisions are made from the
# types, so the route is static.
adjoint_call(op, args...) = _route(_route_val(op, args...), op, args...)
adjoint_call(n::NoAdjoint, args...) = _plain(n.op, args...)
_route_val(op, args...) = Val(uses_adjoint(op, Run()) && _gate(op, args...))
_route(::Val{true}, op, args...) = _ad(op, args...)
function _route(::Val{false}, op, args...)
    _note_plain(op)
    return _plain(op, args...)
end

# The positional Run of an operator and its pullback. Operators with a
# keyword `forward` on `Run()` add methods for their positional form.
_run_forward(op, args...) = forward(op, Run(), args...)
_run_pullback!(grads, op, cache) = pullback!(grads, op, Run(), cache)

# The primal call. The extensions make `_ad` a rule primitive for `Mooncake`
# and `Enzyme`; `_plain` is differentiated by the backend.
_primal(op, args...) = first(_run_forward(op, args...))
_ad(op, args...) = _primal(op, args...)
_plain(op, args...) = _primal(op, args...)

# Log, once per operator type, that an operator without an adjoint for all
# of its parts is differentiated by plain AD. The extensions mark
# `_note_plain_type` as having no derivative.
_note_plain(op) = uses_adjoint(op, Run()) ? nothing : _note_plain_type(typeof(op))
const _PLAIN_NOTED = Set{Any}()
const _PLAIN_LOCK = ReentrantLock()
@noinline function _note_plain_type(T)
    new = @lock _PLAIN_LOCK (T in _PLAIN_NOTED ? false : (push!(_PLAIN_NOTED, T); true))
    new && @info "$(nameof(T)) has a coupling or modifier without an analytic " *
        "adjoint, so gradients of it use plain AD of the whole operator"
    return nothing
end

# Rules apply when every float leaf is IEEE (Float16/32/64) and every array
# is one whose tangent the wiring can read; dual numbers, BigFloat and other
# arrays take the plain path, as do abstractly typed fields. `_ok` is one
# closed function of the types (nothing extends it), evaluated once per
# signature by a generated function: inference does not constant-fold the
# recursion, and an unfolded gate costs a dynamic dispatch on every call
# under `Mooncake`.
const _IEEEFloat = Union{Float16, Float32, Float64}
@generated _gate(xs...) = all(_ok, xs)
function _ok(::Type{T}) where {T}
    T <: _IEEEFloat && return true
    T <: Union{Integer, Nothing, Symbol} && return true
    T <: Real && return false
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
[`ComposableRecurrences.pullback!`](@ref): an array to accumulate into for a
float array, a `Ref` for a float scalar, a NamedTuple of field mirrors for
a struct (`(; nzval)` for a sparse matrix, `(; diag)` for a `Diagonal`,
`(; x)` for a wrapper such as [`TimeVarying`](@ref)), and `nothing` where
there is no cotangent.

# Arguments
- `x̄`: the mirror, a NamedTuple of field mirrors or `nothing`.
- `name`: the field.

# Examples
```@example
using ComposableRecurrences
ComposableRecurrences.cotangent((; K = zeros(2)), :K)
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
```@example
using ComposableRecurrences
x̄ = zeros(2)
ComposableRecurrences.add_cotangent!(x̄, 1.5, 2)
x̄
```
"""
add_cotangent!(::Nothing, v, idx...) = nothing
add_cotangent!(x̄::Base.RefValue, v, idx...) = (x̄[] += v; nothing)
add_cotangent!(x̄::AbstractArray, v, idx...) = (x̄[idx...] += v; nothing)
add_cotangent!(x̄::NamedTuple{(:x,)}, v, idx...) = add_cotangent!(x̄.x, v, idx...)

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
```@example
using ComposableRecurrences
methods(ComposableRecurrences.test_adjoint)
```
"""
function test_adjoint end
