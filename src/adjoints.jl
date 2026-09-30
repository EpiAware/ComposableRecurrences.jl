@doc "
Supertype of operators whose positional call is routed through the package's
native adjoint rules.

A subtype implements [`ComposableRecurrences.forward`](@ref) and, for an
analytic adjoint, [`ComposableRecurrences.pullback!`](@ref); calling it as
`op(args...)` then runs the analytic adjoint under Mooncake and Enzyme with no
AD declarations of its own.
Without a `pullback!` method the call is differentiated by the AD backend.

# Examples
```@example
using ComposableRecurrences
struct Double <: ComposableRecurrences.AbstractOperator end
ComposableRecurrences.forward(::Double, x) = (2 .* x, nothing)
Double()([1.0, 2.0])
```
"
abstract type AbstractOperator end

@doc "
Supertype for user-defined couplings of a [`Recurrence`](@ref).

A coupling implements [`ComposableRecurrences.pressure!`](@ref) and optionally
[`ComposableRecurrences.pressure_pullback!`](@ref).
Subtyping is optional: any object with a `pressure!` method is a coupling.

# Examples
```@example
using ComposableRecurrences
struct Twice <: ComposableRecurrences.Coupling end
function ComposableRecurrences.pressure!(q, ::Twice, p, window, t)
    q .= 2 .* p
    return q
end
Recurrence([0.5]; coupling = Twice())(ones(2, 3); history = ones(2, 1))
```
"
abstract type Coupling end

@doc "
Run operator `op` on its positional arguments, returning `(y, cache)`: the
output and whatever [`ComposableRecurrences.pullback!`](@ref) reads.

An [`ComposableRecurrences.AbstractOperator`](@ref) implements this method.
The package's operators take the positional arguments their keyword calls
build.

# Arguments
- `op`: the operator.
- `args`: its positional arguments.

# Examples
```@example
using ComposableRecurrences
c = Convolution([0.5, 0.5])
y, cache = ComposableRecurrences.forward(c, ones(3), nothing, 1)
y
```
"
function forward end

@doc "
Accumulate the reverse pass of operator `op` from the cotangent `ȳ` of its
output, given the `cache` its [`ComposableRecurrences.forward`](@ref)
recorded.

Cotangents of the operator's fields (kernel, coupling, modifier parameters)
are added into the mirror `op̄` and those of its positional arguments into
`args̄`.
A mirror is an array to accumulate into for a float array, a `Ref` for a float
scalar, a NamedTuple of field mirrors for a struct (`(; nzval)` for a sparse
matrix, `(; diag)` for a `Diagonal`), and `nothing` where there is no
cotangent; read it with [`ComposableRecurrences.cotangent`](@ref) and add to it
with [`ComposableRecurrences.add_cotangent!`](@ref).
Returns `nothing`.

# Arguments
- `op`: the operator.
- `cache`: what the forward pass recorded.
- `ȳ`: the cotangent of the output.
- `op̄`: the mirror of the operator.
- `args̄`: the mirrors of the positional arguments.

# Examples
```@example
using ComposableRecurrences
c = Convolution([0.5, 0.5])
y, cache = ComposableRecurrences.forward(c, ones(3), nothing, 1)
x̄ = zeros(3)
ComposableRecurrences.pullback!(c, cache, ones(3), nothing, x̄, nothing, nothing)
x̄
```
"
function pullback! end

@doc "
Wrap an operator so it is differentiated by the AD backend's own treatment of
its forward loop, bypassing any hand-written adjoint.

Called exactly like the wrapped operator.
Useful to time a hand-written adjoint against plain AD.
Plain Enzyme reverse AD of a sparse coupling is wrong, so an active sparse
coupling under `NoAdjoint` throws an `ArgumentError` with Enzyme.

# Examples
```@example
using ComposableRecurrences
r = Recurrence([0.2, 0.3, 0.5])
ComposableRecurrences.NoAdjoint(r)(fill(1.1, 6); history = ones(3))
```
"
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

# `op` with the routing of `route`: wrapped in `NoAdjoint` if `route` is.
_reroute(route, op) = op
_reroute(::NoAdjoint, op) = NoAdjoint(op)

# Incremented by every analytic reverse pass, so tests can prove it ran.
const _PULLBACK_CALLS = Threads.Atomic{Int}(0)
_count_pullback() = (Threads.atomic_add!(_PULLBACK_CALLS, 1); nothing)

@doc "
Whether `piece`, an operator, modifier or coupling, carries its own
analytic adjoint.

The author declares it next to the pullback: `true` for an operator with a
[`ComposableRecurrences.pullback!`](@ref), a modifier with
[`ComposableRecurrences.apply_pullback!`](@ref) or the pointwise
[`ComposableRecurrences.apply_pullback`](@ref), and a coupling with
[`ComposableRecurrences.pressure_pullback!`](@ref).
The default is `false`.
A [`Recurrence`](@ref) uses its adjoint when its coupling does and each
modifier does or is pointwise with only scalar float parameters (those are
differentiated locally per value).
Otherwise the whole operator is differentiated by plain AD of its forward
loop, logged once per operator type.

# Arguments
- `piece`: the operator, modifier or coupling.

# Examples
```@example
using ComposableRecurrences
ComposableRecurrences.uses_adjoint(Recurrence([0.5, 0.5]))
```
"
uses_adjoint(piece) = false

# The entry point: the rule path when the operator uses its adjoint and
# every float leaf is IEEE, else plain AD. Both decisions are made from the
# types, so the route is static.
adjoint_call(op, args...) = _route(_route_val(op, args...), op, args...)
adjoint_call(n::NoAdjoint, args...) = _plain(n.op, args...)
_route_val(op, args...) = Val(uses_adjoint(op) && _gate(op, args...))
_route(::Val{true}, op, args...) = _ad(op, args...)
function _route(::Val{false}, op, args...)
    _note_plain(op)
    return _plain(op, args...)
end

# The primal call. The extensions make `_ad` a rule primitive for Mooncake and
# Enzyme; `_plain` is differentiated by the backend.
_primal(op, args...) = first(forward(op, args...))
_ad(op, args...) = _primal(op, args...)
_plain(op, args...) = _primal(op, args...)

# Log, once per operator type, that an operator without an adjoint for all
# of its pieces is differentiated by plain AD. The extensions mark
# `_note_plain_type` as having no derivative.
_note_plain(op) = uses_adjoint(op) ? nothing : _note_plain_type(typeof(op))
const _PLAIN_NOTED = Set{Any}()
const _PLAIN_LOCK = ReentrantLock()
@noinline function _note_plain_type(T)
    new = @lock _PLAIN_LOCK (T in _PLAIN_NOTED ? false : (push!(_PLAIN_NOTED, T); true))
    new && @info "$(nameof(T)) has a piece without an analytic adjoint, so " *
        "gradients of it use plain AD of the whole operator"
    return nothing
end

# Rules apply when every float leaf is IEEE (Float16/32/64) and every array
# is one whose tangent the wiring can read; Duals, BigFloat and other arrays
# take the plain path, as do abstractly typed fields. `_ok` is one closed
# function of the types (nothing extends it), evaluated once per signature
# by a generated function: inference does not constant-fold the recursion,
# and an unfolded gate costs a dynamic dispatch on every call under Mooncake.
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

@doc "
The cotangent of field `name` in the mirror `x̄` of a struct, or `nothing`
when `x̄` is `nothing` or has no such field.

For use in [`ComposableRecurrences.pullback!`](@ref),
[`ComposableRecurrences.apply_pullback!`](@ref) and
[`ComposableRecurrences.pressure_pullback!`](@ref) methods.

# Arguments
- `x̄`: the mirror, a NamedTuple of field mirrors or `nothing`.
- `name`: the field.

# Examples
```@example
using ComposableRecurrences
ComposableRecurrences.cotangent((; K = zeros(2)), :K)
```
"
cotangent(::Nothing, name::Symbol) = nothing
cotangent(x̄::NamedTuple, name::Symbol) = get(x̄, name, nothing)
cotangent(x̄, name::Symbol) = getfield(x̄, name)

@doc "
Add `v` to the mirror `x̄` at index `idx`: `x̄[idx...] += v` for an array,
`x̄[] += v` for a `Ref` (the index is ignored), and nothing for `nothing`.

# Arguments
- `x̄`: the mirror: an array, a `Ref` or `nothing`.
- `v`: the cotangent to add.
- `idx`: the index into an array mirror.

# Examples
```@example
using ComposableRecurrences
x̄ = zeros(2)
ComposableRecurrences.add_cotangent!(x̄, 1.5, 2)
x̄
```
"
add_cotangent!(::Nothing, v, idx...) = nothing
add_cotangent!(x̄::Base.RefValue, v, idx...) = (x̄[] += v; nothing)
add_cotangent!(x̄::AbstractArray, v, idx...) = (x̄[idx...] += v; nothing)
# A wrapper's mirror, such as a `TimeVarying` field's `(; x)`.
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

@doc "
Test the analytic adjoint of `op` on the positional arguments `args` of
[`ComposableRecurrences.forward`](@ref) with the AD `backend`'s own rule
tester.

Methods come from package extensions: `AutoMooncake` with Mooncake loaded
(`Mooncake.TestUtils.test_rule`) and `AutoEnzyme` with EnzymeTestUtils loaded
(`test_reverse`, with the operator active and constant).

# Examples
```@example
using ComposableRecurrences
methods(ComposableRecurrences.test_adjoint)
```
"
function test_adjoint end
