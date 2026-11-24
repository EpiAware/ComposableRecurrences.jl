# == Roles ==

@doc raw"""
The role of an operator's whole call, `forward(op, Run(), args...; kwargs...)`,
which returns `(y, cache)`; calling the operator lowers to it.

For inputs ``u`` (the call's arguments and the operator's fields) it
computes the output over the call's times ``t = t_0, \dots, t_1``,

```math
y = f_{\mathrm{op}}(u), \qquad y = (y_{t_0}, \dots, y_{t_1}),
```

with ``f_{\mathrm{op}}`` the maths of the operator, a [`Recurrence`](@ref)
or a [`Convolution`](@ref); `cache` holds what the reverse pass needs, such
as the [`ComposableRecurrences.State`](@ref).
It is the role an operator is asked about, as in
`uses_adjoint(op, Run())`, `PieceInterface` with `role = Run()` and
`test_adjoint(backend, op, Run(), args...)`.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
r = Recurrence([0.5, 0.5])
y, cache = CR.forward(r, CR.Run(), fill(1.1, 4); history = ones(2))
round.(y; digits = 3)

# output

4-element Vector{Float64}:
 1.1
 1.155
 1.24
 1.317
```
"""
struct Run end

@doc raw"""
The role of one step of a modifier, or of a depletion form inside its
[`ComposableRecurrences.Depletion`](@ref).

A modifier ``M`` maps the step's values and its own state at absolute time
``t`` to new ones,

```math
(v', s') = M(v, s, t), \qquad v, v', s, s' \in \mathbb{R}^S,
```

where ``v`` holds one value per [stratum](@ref PerStratum), ``s`` is the
modifier's state after the previous step and ``s'`` its state after this
one.
A pointwise modifier acts on each stratum ``i`` separately,
``(v'_i, s'_i) = M_i(v_i, s_i, t)``.

  - `forward!(m, Step(), v, s, t)` updates the step's values `v` and the
    modifier's state `s` in place (one entry per stratum, or one per pool
    for a [`ComposableRecurrences.Depletion`](@ref) with several) and
    returns `nothing`.
    A pointwise modifier, with [`ComposableRecurrences.blocks`](@ref)
    `(1, 1)`, writes entry `k` from entry `k` only, and may be called on
    a one-entry view of stratum `k`.
  - `forward!(m, Step(), v, s, t, g)` is the group step of a blockwise
    modifier ([`ComposableRecurrences.blocks`](@ref)), with `v` and `s`
    tuples of one-entry views of group `g`'s values and state.
  - `forward!(form, Step(), v, s, N)` draws `v` from pool `s` in place
    for a depletion form, with `v` and `s` views and `N` a number.

A step writes its outputs and returns `nothing`; one that returns anything
else is an error.
The matching [`ComposableRecurrences.pullback!`](@ref) takes `grads` first
and then the same arguments, as `pullback!(grads, m, Step(), v, s, t)`.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
v, s = [2.0], [80.0]
CR.forward!(CR.Hazard(), CR.Step(), v, s, 100.0)
round.(v; digits = 3), round.(s; digits = 3)

# output

([1.584], [78.416])
```
"""
struct Step end

@doc raw"""
The role of a modifier's initial state: `forward!(m, Init(), s, history)`
writes the state `s` (one entry per stratum, or one per pool for a
[`ComposableRecurrences.Depletion`](@ref) with several, allocated
by the operator at its buffer eltype) from the full history, and returns
`nothing`.

It sets the state before the first step of the call at ``t_0``,

```math
s_{t_0 - 1} = I_M(h), \qquad h = (y_{t_0 - m}, \dots, y_{t_0 - 1}),
```

where ``h`` is the whole history of length ``m``, not only the last ``L``
values the recursion reads, and ``I_M`` is the modifier's own map.
The default is ``s_{t_0 - 1} = 0``.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
s = zeros(2)
CR.forward!(CR.Depletion(PerStratum([100.0, 50.0])), CR.Init(), s, ones(2, 3))
s

# output

2-element Vector{Float64}:
 100.0
  50.0
```
"""
struct Init end

@doc raw"""
The role of a coupling: `forward!(C, Pressure(), q, p, t)` writes into `q`
the mixing of the per-stratum kernel convolutions `p` at absolute time `t`,
and returns `nothing`.

For the built-in couplings

```math
q_{t,i} = \sum_{j=1}^{S} K_{t,ij}\, p_{t,j},
```

where ``p_{t,j}`` is stratum ``j``'s kernel convolution of its past values,
``q_{t,i}`` the pressure on stratum ``i`` and ``K_{t,ij}`` the weight of
stratum ``j`` in stratum ``i``, with ``S`` [strata](@ref PerStratum).
`λ * I` gives ``K_{t,ij} = \lambda \delta_{ij}``, a matrix `C` gives
``K_{t,ij}`` = `C[i, j]` at every ``t``, and a [`TimeVarying`](@ref)
coupling gives ``K_{t,ij}`` = `C.x[i, j, t]`.
To add a coupling, define a type and add this method; it may compute any
``q_t`` from ``p_t`` and ``t``.
Add a [`ComposableRecurrences.pullback!`](@ref) method for a
[rule](@ref extending-coupling).

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
q = zeros(2)
CR.forward!([0.9 0.1; 0.2 0.8], CR.Pressure(), q, [1.0, 2.0], 1)
q

# output

2-element Vector{Float64}:
 1.1
 1.8
```
"""
struct Pressure end

# == The role functions ==

@doc raw"""
Run operator `op` over a whole call, returning `(y, cache)`.

This is the [`ComposableRecurrences.Run`](@ref) role: calling the operator
lowers to `forward(op, Run(), args...; kwargs...)`.
For inputs ``u`` it computes

```math
y = f_{\mathrm{op}}(u),
```

with ``f_{\mathrm{op}}`` the operator's own maths, and `cache` holds what
the reverse pass needs.
Couplings, modifiers and depletion forms write their outputs in place
through [`ComposableRecurrences.forward!`](@ref) instead.

# Arguments
- `op`: the operator.
- `role`: `Run()`.
- `args`: the call's arguments.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
y, cache = CR.forward(Convolution([0.5, 0.5]), CR.Run(), [1.0, 2.0, 3.0])
y

# output

3-element Vector{Float64}:
 0.5
 1.5
 2.5
```
"""
function forward end

@doc raw"""
Run `x` in `role` on primal arguments `args`, writing the outputs in place.

For the role's inputs ``u`` it computes its outputs

```math
o = f_{\mathrm{role}}(u),
```

with ``f_{\mathrm{role}}`` the map of the role:
[`ComposableRecurrences.Step`](@ref) a modifier step
``(v, s) \mapsto (v', s')``,
[`ComposableRecurrences.Init`](@ref) an initial state from the history,
[`ComposableRecurrences.Pressure`](@ref) a coupling ``q_t = K_t p_t`` and
[`ComposableRecurrences.Trace`](@ref) a modifier's record
``r_t = R_M(v_t, s_{t-1}, v'_t, s_t)``.
The outputs are written into the leading array arguments, and the method
returns `nothing`; returning anything else is an error.
To extend the package, define a type and add this method for its
[role](@ref extending-roles):
[`ComposableRecurrences.Step`](@ref) and [`ComposableRecurrences.Init`](@ref)
for a modifier or depletion form, [`ComposableRecurrences.Pressure`](@ref)
for a coupling and [`ComposableRecurrences.Trace`](@ref) for a modifier's
record.

A pointwise step runs under [`ComposableRecurrences.Parallel`](@ref) when
it reads and writes only `eachindex(v)` entries, and allocates nothing.

# Arguments
- `x`: the coupling, modifier or depletion form.
- `role`: `Step()`, `Init()`, `Pressure()` or `Trace()`.
- `args`: the role's arguments.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
struct Offset{T}
    b::T
end
CR.blocks(::Offset) = (1, 1)
function CR.forward!(m::Offset, ::CR.Step, v, s, t)
    for k in eachindex(v)
        v[k] += m.b
    end
    return nothing
end
r = Recurrence([0.5, 0.5]; modifiers = (Offset(1.0),))
r(1.0; history = ones(2), stop = 4)

# output

4-element Vector{Float64}:
 2.0
 2.5
 3.25
 3.875
```
"""
function forward! end

@doc raw"""
Accumulate the reverse pass of [`ComposableRecurrences.forward!`](@ref) for
`x` in `role`.

For `forward!` computing outputs ``o = f(u, \theta)`` from inputs ``u`` and
the object's parameters ``\theta``, given the output cotangent ``\bar o``
(the gradient of a scalar loss with respect to ``o``) it adds

```math
\bar u \mathrel{+}= \Big(\frac{\partial o}{\partial u}\Big)^{\top} \bar o,
\qquad
\bar\theta \mathrel{+}=
\Big(\frac{\partial o}{\partial \theta}\Big)^{\top} \bar o .
```

`grads` is a NamedTuple: `grads.piece` holds ``\bar\theta``, mirroring the
object's parameters (or is `nothing`), and the other fields are named after
the role's arguments.
Output cotangents are read on entry and input cotangents accumulated; a
buffer `forward!` updated in place is overwritten with the cotangent of its
incoming value.
It returns `nothing`.
A pointwise or blockwise `Step` gets the same views as its `forward!`, with
`grads.v` and `grads.s` views of the same entries.
The [mirror](@ref extending-mirror) `grads.piece` has one entry per field:
a `Ref` for a float scalar, an array of the same shape for a float array
and `nothing` for a field held constant.
An operator's native rule calls a method whose `grads` and arguments after
the role are untyped, as only such a method sets
[`ComposableRecurrences.uses_adjoint`](@ref).
Without one, the object is differentiated by a
[local dual-number step](@ref adjoint-local-step) inside the rule where that
is cheap, and the whole operator takes plain AD otherwise.

# Arguments
- `grads`: the cotangents, `(; piece, ...)`, with `piece` the mirror of
  `x`'s parameters.
- `x`: the operator, coupling, modifier or depletion form.
- `role`: the role.
- `args`: the primal arguments `forward!` was given.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
m = CR.Transform(clamp, 0.0, 1.0)
grads = (; piece = (; θ = (Ref(0.0), Ref(0.0))), v = [1.0], s = [0.0])
CR.pullback!(grads, m, CR.Step(), [2.0], [0.0], 1)
grads.v, grads.piece.θ[2][]

# output

([0.0], 1.0)
```
"""
function pullback! end

@doc raw"""
The role of a map's local derivative at one entry: the partial derivatives
of a [`Derived`](@ref) map or a [`ComposableRecurrences.Transform`](@ref)
map at its arguments, given its value there.

For a map ``y = f(x_1, \dots, x_n)`` of scalars,
`pullback!(grads, f, Local(), y, x...)` returns the partial derivatives
```math
\left(\frac{\partial f}{\partial x_1}, \dots,
\frac{\partial f}{\partial x_n}\right),
```
one per argument and shaped as it is: a `Transform` map `f(v, θ)` with a
tuple or NamedTuple `θ` returns `(∂f/∂v, ∂f/∂θ)`, the second shaped as
`θ`.
`y` is the map's value at the arguments, as the forward pass computed it,
so a derivative written in terms of the value does not compute it again.
`grads` holds no cotangents for this role.
Unlike the other roles' pullbacks, it returns its partials, as a scalar map
has nothing to write into.

Add a method for the type of a function you own, a named function or a
callable struct; the operators find it from the types alone.
Without one the partials come from a local forward-mode derivative, which
needs `ForwardDiff` loaded.
The package adds methods for `+`, `-`, `*`, `/`, `identity`, `exp`,
`log`, `min` and `max`, and, with `LogExpFunctions` loaded, for
`logistic`, `log1pexp` and `logit`.
For `min` and `max` the first argument takes the cotangent on a tie, so a
NaN or a tie of `0.0` and `-0.0` can differ from `ForwardDiff`'s convention.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
# A logistic hazard of the sum of its arguments, whose derivative reads its
# value.
struct LogisticSum end
(::LogisticSum)(a, b) = inv(1 + exp(-(a + b)))
function CR.pullback!(grads, ::LogisticSum, ::CR.Local, y, a, b)
    d = y * (1 - y)
    return d, d
end
h = CR.Derived(LogisticSum(), [-2.0, -1.0], 0.5)
cdf = TimeVarying(1 - CR.Survival(h), CR.Primary())
round.(CR.kernel_weights(cdf, 1); digits = 3)

# output

2×1 Matrix{Float64}:
 0.182
 0.491
```
"""
struct Local end

# Without a method for `f`, a map has no local rule, and the operators take
# the forward-mode derivative.
pullback!(grads, f, ::Local, y, xs...) = nothing

# Whether `f` has a local rule at arguments of the types of `xs`: decided
# from the inferred type of its `pullback!`, so it folds at compile time.
function _has_local(f::F, xs::Tuple) where {F}
    Y = Core.Compiler.return_type(f, Tuple{map(typeof, xs)...})
    R = Core.Compiler.return_type(
        pullback!, Tuple{typeof((;)), F, Local, Y, map(typeof, xs)...}
    )
    return !(R <: Nothing)
end

# The value of `f` at `xs` and its partial derivatives there: from its local
# rule when it has one, or from one local forward-mode evaluation.
@inline function _value_and_partials(f, xs::Tuple)
    return _value_and_partials(Val(_has_local(f, xs)), f, xs)
end
@inline function _value_and_partials(::Val{true}, f, xs::Tuple)
    y = f(xs...)
    return y, _local_partials(f, y, xs)
end
@inline function _value_and_partials(::Val{false}, f, xs::Tuple)
    return _forward_value_and_derivative(f, xs)
end
# The same with the value the forward pass computes, `f(xs...)` on the plain
# arguments, where a caller reads it: a forward-mode evaluation's value can
# differ from it in the last bits.
@inline function _primal_and_partials(f, xs::Tuple)
    return _primal_and_partials(Val(_has_local(f, xs)), f, xs)
end
@inline function _primal_and_partials(::Val{true}, f, xs::Tuple)
    return _value_and_partials(Val(true), f, xs)
end
@inline function _primal_and_partials(::Val{false}, f, xs::Tuple)
    return f(xs...), last(_forward_value_and_derivative(f, xs))
end
# The partials at `xs`, given the value `y` there.
@inline _local_partials(f, y, xs::Tuple) = pullback!((;), f, Local(), y, xs...)
@inline _partials(f, xs::Tuple) = last(_value_and_partials(f, xs))

# The package's own local rules.
pullback!(grads, ::typeof(identity), ::Local, y, a::Real) = (one(a),)
pullback!(grads, ::typeof(+), ::Local, y, a::Real, b::Real) = (one(a), one(b))
pullback!(grads, ::typeof(-), ::Local, y, a::Real, b::Real) = (one(a), -one(b))
pullback!(grads, ::typeof(-), ::Local, y, a::Real) = (-one(a),)
pullback!(grads, ::typeof(*), ::Local, y, a::Real, b::Real) = (b, a)
pullback!(grads, ::typeof(/), ::Local, y, a::Real, b::Real) = (inv(b), -a / b^2)
pullback!(grads, ::typeof(exp), ::Local, y, a::Real) = (y,)
pullback!(grads, ::typeof(log), ::Local, y, a::Real) = (inv(a),)
# The smaller or larger argument takes the cotangent, and the first on a tie,
# as the forward-mode derivative the operators took before gives.
function pullback!(grads, ::typeof(min), ::Local, y, a::Real, b::Real)
    return a <= b ? (one(a), zero(b)) : (zero(a), one(b))
end
function pullback!(grads, ::typeof(max), ::Local, y, a::Real, b::Real)
    return a >= b ? (one(a), zero(b)) : (zero(a), one(b))
end

# == Modifier traits ==

@doc raw"""
Return whether modifier `m` acts on each stratum separately: whether its
[`ComposableRecurrences.blocks`](@ref) is `(1, 1)`.

A pointwise modifier's step factorises over the ``S``
[strata](@ref PerStratum): at absolute time ``t``, stratum ``i``'s new
value and state depend only on its own,

```math
(v'_i, s'_i) = M_i(v_i, s_i, t), \qquad i = 1, \dots, S .
```

It follows from `blocks`, which is the trait to define.

# Arguments
- `m`: the modifier.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
CR.ispointwise(CR.Transform(clamp, 0.0, 1.0)), CR.ispointwise(nothing)

# output

(true, false)
```
"""
ispointwise(m) = blocks(m) === (1, 1)

@doc raw"""
Return the group shape of modifier `m`: `(nv, ns)`, its values and state
entries per group, or `nothing` when its step reads the whole vectors.

A modifier with `(nv, ns)` holds ``n_v`` pools of ``G`` groups each in its
values and ``n_s`` in its state, pool by pool: with ``S = n_v G`` strata,
value ``(i - 1) G + g`` is pool ``i`` of group ``g`` and state entry
``(j - 1) G + g`` is state pool ``j`` of group ``g``.
Its step factorises over groups: at absolute time ``t``, group ``g``'s new
values and state depend only on its own,

```math
\big(v'_{1:n_v,\,g},\ s'_{1:n_s,\,g}\big) =
M_g\big(v_{1:n_v,\,g},\ s_{1:n_s,\,g},\ t\big),
\qquad g = 1, \dots, G .
```

`(1, 1)` is a pointwise modifier ([`ComposableRecurrences.ispointwise`](@ref)),
whose groups are the strata: it implements `forward!(m, Step(), v, s, t)`
writing entry `k` of `v` and `s` from entry `k` only, for each `k` in
`eachindex(v)`.
The operator may call it on a one-entry view of stratum `k`, whose axes are
`k:k`, so a parameter read at `k` through
[`ComposableRecurrences.param`](@ref) reads the right entry; a broadcast
against a field with one entry per stratum, such as `v .*= m.w`, cannot run
on such a view.
Any other shape is blockwise: the modifier implements
`forward!(m, Step(), v, s, t, g)` with `v` and `s` tuples of one-entry views
of group `g`'s ``n_v`` values and ``n_s`` state entries, writing them in
place, and optionally `pullback!(grads, m, Step(), v, s, t, g)` with
`grads.v` and `grads.s` tuples of views, overwritten with the input
cotangents.
Both return `nothing`, and the default vector
[`ComposableRecurrences.Step`](@ref) loops the groups.
The group step reads parameters at group `g`, so a [`PerStratum`](@ref)
parameter has ``G`` entries.
`blocks` should follow from the type of `m`, not from the value of a field,
so the loops are compiled for its shape; a shape read from a field is known
only at run time.
[`ComposableRecurrences.ispointwise`](@ref) and
[`ComposableRecurrences.nstate`](@ref) follow from it.
The default is `nothing`.
Groups of different sizes, such as the patches of
[`ComposableRecurrences.Allocate`](@ref), are a value of the modifier, so
its `blocks` is `nothing`.

# Arguments
- `m`: the modifier.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
weights = (S = 1, V = 0.3)
leaky = CR.Depletion(100.0, CR.Hazard(; weights); pools = (:S, :V))
CR.blocks(leaky), CR.blocks(CR.Transform(clamp, 0.0, 1.0)), CR.blocks(nothing)

# output

((1, 2), (1, 1), nothing)
```
"""
blocks(m) = nothing

@doc raw"""
Return the number of state entries modifier `m` keeps for `S`
[strata](@ref PerStratum), from its [`ComposableRecurrences.blocks`](@ref).

The recurrence allocates each modifier's state ``s`` with

```math
|s| = n(m, S), \qquad
n(m, S) = \begin{cases} n_s S / n_v & \text{for blocks } (n_v, n_s), \\
S & \text{otherwise}, \end{cases}
```

passes it to the modifier's [`ComposableRecurrences.Init`](@ref) and
[`ComposableRecurrences.Step`](@ref), and checks a resumed state against it.
A pointwise modifier keeps one entry per stratum, and a `Depletion` with two
pools keeps the first pool then the second, ``n(m, S) = 2S``.
Of the built-ins with `blocks` `nothing`, an
[`ComposableRecurrences.Allocate`](@ref) with imports keeps its import
pattern as well.

# Arguments
- `m`: the modifier.
- `S`: the number of strata.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
weights = (S = 1, V = 0.3)
leaky = CR.Depletion(100.0, CR.Hazard(; weights); pools = (:S, :V))
CR.nstate(CR.Transform(clamp, 0.0, 1.0), 3), CR.nstate(leaky, 3)

# output

(3, 6)
```
"""
nstate(m, S) = _blocks_nstate(_blocks(m), S)

@doc raw"""
Return how many rows each top-level parameter field of a whole-step modifier
`m` has in a call over `S` strata, or `nothing` to skip the check.

A row is one entry of a [`PerStratum`](@ref) or one row of a
`TimeVarying(PerStratum(x))`.
Before its [`ComposableRecurrences.Init`](@ref), each call checks

```math
\operatorname{rows}(x_f) = r(m, S) \quad \text{for each such field } f,
```

where ``x_f`` is the field and ``r(m, S)`` this count, and throws a
`DimensionMismatch` that names a field that fails.
Pointwise and blockwise modifiers ignore it: their rows follow from
[`ComposableRecurrences.blocks`](@ref).

# Arguments
- `m`: the modifier, with `blocks(m) === nothing`.
- `S`: the number of strata in the call.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
struct Mix{A}
    a::A
end
function CR.forward!(m::Mix, ::CR.Step, v, s, t)
    v .*= CR.param.(Ref(m.a), eachindex(v), t)
    return nothing
end
CR.param_rows(::Mix, S) = S
r = Recurrence([0.5]; modifiers = (Mix(PerStratum([1.0, 2.0])),))
r(ones(3, 2); history = ones(3, 1))

# output

ERROR: DimensionMismatch: a has 2 rows, expected 3
```
"""
param_rows(m, S) = nothing
_blocks_nstate(::Nothing, S) = S
_blocks_nstate(::Val{B}, S) where {B} = B[2] * _ngroups(Val(B), S)

@doc raw"""
Return whether `forward!` of coupling or modifier `x` is linear in its input
and does not read the time.

For a coupling this is `forward!(C, Pressure(), q, p, t)` linear in `p`;
for a whole-step modifier ([`ComposableRecurrences.blocks`](@ref) `nothing`,
neither pointwise nor blockwise) with no state of its own, it is
`forward!(m, Step(), v, s, t)` linear in `v`.
Either is then a matrix ``A`` with

```math
q = A p \quad \text{or} \quad v' = A v,
```

for every ``t``.
A [`Recurrence`](@ref) call builds ``A`` once, from `forward!` on the
``S`` basis vectors, and runs the built-in dense coupling, or a dense step,
in its place, so the gradient takes the built-in's `pullback!` and the
outer AD differentiates the ``S`` calls of `forward!`.
A `forward!` written as a matrix product, such as `mul!(q, C.K, p)`, then
gives a gradient close to the built-in's; one written as scalar loops is
differentiated loop by loop, so a `pullback!` of its own is still faster.
A type with its own `pullback!` for the role keeps it, as does a call
through [`ComposableRecurrences.NoAdjoint`](@ref).
Declare it from the type, `ComposableRecurrences.islinear(::MyType) = true`,
so the route folds.
[`ComposableRecurrences.PieceInterface`](@ref) checks the declaration.
The default is `false`.

# Arguments
- `x`: the coupling or modifier.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
struct Mix{M}
    K::M
end
function CR.forward!(C::Mix, ::CR.Pressure, q, p, t)
    q .= C.K * p
    return nothing
end
CR.islinear(::Mix) = true
r = Recurrence([0.5, 0.3]; coupling = Mix([0.9 0.1; 0.2 0.8]))
y = r(fill(1.1, 2, 4); history = ones(2, 2))
y ≈ Recurrence([0.5, 0.3]; coupling = [0.9 0.1; 0.2 0.8])(
    fill(1.1, 2, 4); history = ones(2, 2)
)

# output

true
```
"""
islinear(x) = false

@doc raw"""
Return whether modifier `m` leaves its state unchanged in its
[`ComposableRecurrences.Step`](@ref).

A stateless modifier's state after every step is the state it started
with,

```math
s_t = s_0, \qquad t = 1, \dots, T,
```

where ``s_t`` is the state after the step at time ``t`` and ``T`` the
number of steps.
Its [trace](@ref ComposableRecurrences.Trace) then has no rows, and the
reverse pass reads ``s_0`` in place of a record of the state per step.
The default is `false`; a modifier declares it for its type, and the
optional `stateless` component of
[`ComposableRecurrences.PieceInterface`](@ref) checks the declaration.

# Arguments
- `m`: the modifier.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
CR.isstateless(CR.Transform(clamp, 0.0, 1.0)), CR.isstateless(CR.Depletion(9.0))

# output

(true, false)
```
"""
isstateless(m) = false

@doc raw"""
Return the number of past outputs `x` reads from a recurrence's buffer,
before the current step.

A [`Recurrence`](@ref) keeps

```math
D = \max\big(L,\ d(\text{kernel}),\ d(\text{coupling}),\
    d(M_1), \dots, d(M_m)\big)
```

past outputs per stratum, where ``L`` is the kernel length, ``d`` is
`depth` and ``M_1, \dots, M_m`` are the modifiers.
The kernel reads the last ``L`` of them; the deeper rows are kept for
objects that read further back than the kernel.
A [`ComposableRecurrences.State`](@ref) holds the last ``D`` outputs, so a
resumed call reads the same past.
The default recurses by value through the fields of immutable structs,
tuples and named tuples and takes the largest.
Numbers, arrays, functions, mutable objects and operators (which keep
their own buffers) read nothing, ``d = 0``, so an object held inside an
array or a mutable struct is not counted.
Add a method for a type that reads the buffer.

# Arguments
- `x`: any object, such as a modifier, coupling or kernel.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
struct Window
    w::Int
end
CR.depth(x::Window) = x.w
x = (Window(5), (; a = Window(9), b = 1.0))
CR.depth(x), CR.depth(CR.Transform(clamp, 0.0, 1.0))

# output

(9, 0)
```
"""
depth(x) = _fields_depth(x)
depth(::Union{Number, AbstractArray, Nothing, Symbol, AbstractString}) = 0
depth(::Union{Type, Module, Function}) = 0

# The largest depth over the fields of `x`, unrolled so a concrete type
# infers. Each field is checked, so the maximum cannot hide a bad one; mutable
# objects are not walked, so a cycle or undefined field cannot stop a call.
@generated function _fields_depth(x)
    ismutabletype(x) && return 0
    calls = (
        :(isdefined(x, $i) ? _checked_depth(getfield(x, $i)) : 0)
            for i in 1:fieldcount(x)
    )
    return :(max(0, $(calls...)))
end

function _checked_depth(x)
    d = depth(x)
    d isa Integer && d >= 0 || throw(
        ArgumentError(
            "depth($(nameof(typeof(x)))) must be a non-negative integer; " *
                "got $(repr(d))"
        )
    )
    return Int(d)::Int
end

# == Step shapes ==

# `Val((nv, ns))` runs a group kernel per group, `nothing` a step per stratum
# or on the whole vectors; fixed by the type so it folds. A one-pool
# `Depletion` without a step of its own runs a pointwise shape on its kernel.
_blocks(m) = _static_blocks(blocks(m))
_static_blocks(::Nothing) = nothing
_static_blocks(b::Tuple) = _group_shape(Val(b))
@noinline function _static_blocks(b)
    throw(
        ArgumentError(
            "blocks(m) is nothing or a tuple (nv, ns), got $(repr(b))"
        )
    )
end
_group_shape(::Val{(1, 1)}) = nothing
_group_shape(b::Val) = b

# An execution choice, not `ispointwise`: a `Depletion` filling one pool is
# pointwise but runs a group kernel.
_strata_loop(m) = blocks(m) === (1, 1) && _blocks(m) === nothing

# The number of groups of a blockwise modifier over `S` strata.
function _ngroups(::Val{B}, S) where {B}
    nv = _check_blocks(Val(B))
    rem(S, nv) == 0 || _strata_mismatch(nv, S)
    return S ÷ nv
end
@noinline function _strata_mismatch(nv, S)
    throw(
        DimensionMismatch(
            "a blockwise modifier with $nv value compartments needs a " *
                "multiple of $nv strata, got $S"
        )
    )
end

# The value compartments of a group shape, after checking the shape.
function _check_blocks(::Val{B}) where {B}
    B isa Tuple{Int, Int} && B[1] >= 1 && B[2] >= 0 || throw(
        ArgumentError(
            "blocks(m) is (nv, ns) with integers nv >= 1 and ns >= 0, " *
                "got $(repr(B))"
        )
    )
    return B[1]
end

# == Default steps ==

# A modifier's shape checks against `S` strata, run once per call by its
# `Init` and on a resumed state.
_check_modifier_strata(m, S) = nothing

# Defaults: a zero initial state, and a vector step that loops the
# per-stratum or per-group step.
function forward!(m, ::Init, s, history)
    fill!(s, zero(eltype(s)))
    return nothing
end

forward!(m, ::Step, v, s, t) = _vector_step!(_blocks(m), m, v, s, t)

# A pointwise modifier's step on stratum `k`, as new scalars: on one-entry
# views of local slots, kept in registers when fully inlined.
@inline function _step(m, v, s, t, k)
    vr, sr = _slot(m, v), _slot(m, s)
    _written(m, @inline forward!(m, Step(), _At(vr, k), _At(sr, k), t))
    return vr[], sr[]
end
# The same for its `pullback!`: the cotangents of the step's inputs from
# those of its outputs, `grads.v` and `grads.s`.
@inline function _step_back(grads, m, v, s, t, k)
    T = promote_type(
        typeof(grads.v), typeof(grads.s), typeof(v), typeof(s), param_eltype(m),
    )
    v̄r, s̄r = Base.RefValue{T}(grads.v), Base.RefValue{T}(grads.s)
    g = _at_output(grads, (; piece = grads.piece, v = _At(v̄r, k), s = _At(s̄r, k)), k)
    _written(
        m, @inline pullback!(g, m, Step(), _At(Ref(v), k), _At(Ref(s), k), t)
    )
    return v̄r[], s̄r[]
end
# The step's output, where the reverse pass gives it, at stratum `k`.
_at_output(grads, g, k) = g
function _at_output(grads::NamedTuple{(:piece, :v, :s, :out)}, g, k)
    return merge(g, (; out = _At(Ref(grads.out), k)))
end
# A slot for a scalar the step may write a value of the modifier's float type
# into, such as a dual number from a parameter.
@inline _slot(m, x) = Base.RefValue{promote_type(typeof(x), param_eltype(m))}(x)

# A step writes its outputs in place and returns `nothing`; a returned
# value is an error, not a silent no-op.
@inline _written(m, ::Nothing) = nothing
@noinline function _written(m, x)
    throw(
        ArgumentError(
            "the step of $(nameof(typeof(m))) returned a $(typeof(x)); " *
                "forward! and pullback! write their outputs in place and " *
                "return nothing"
        )
    )
end

# The group `g` entries of `x`, compartment by compartment, as a tuple, and
# their write-back. Generated as straight-line indexing, which AD backends
# differentiate more cheaply than a closure or a recursion over the tuple.
@generated function _gather(x, ::Val{n}, G, g) where {n}
    return Expr(:tuple, (:(x[$(i - 1) * G + g]) for i in 1:n)...)
end
@generated function _scatter!(x, xs::Tuple, G, g)
    body = (:(x[$(i - 1) * G + g] = xs[$i]) for i in 1:fieldcount(xs))
    return Expr(:block, body..., :(return x))
end

# A built-in's kernel, or the modifier's `forward!` on tuples of one-entry
# views of local slots.
@inline function _block_step(m, v::Tuple, s::Tuple, t, g)
    vr, sr = map(x -> _slot(m, x), v), map(x -> _slot(m, x), s)
    at = r -> _At(r, g)
    _written(m, @inline forward!(m, Step(), map(at, vr), map(at, sr), t, g))
    return map(getindex, vr), map(getindex, sr)
end
@inline function _block_back(grads, m, v::Tuple, s::Tuple, t, g)
    uses_adjoint(m, Step()) || return _block_local_back(grads, m, v, s, t, g)
    T = promote_type(
        map(typeof, (grads.v..., grads.s..., v..., s...))..., param_eltype(m),
    )
    v̄r, s̄r = map(Base.RefValue{T}, grads.v), map(Base.RefValue{T}, grads.s)
    at = r -> _At(r, g)
    gg = (; piece = grads.piece, v = map(at, v̄r), s = map(at, s̄r))
    vv, sv = map(at ∘ Ref, v), map(at ∘ Ref, s)
    _written(m, @inline pullback!(gg, m, Step(), vv, sv, t, g))
    return map(getindex, v̄r), map(getindex, s̄r)
end

# The group step and its pullback are inlined at their calls: across a call
# boundary, plain reverse AD of the returned tuples was markedly slower, and
# the rule's reverse pass slightly slower.
function _vector_step!(::Val{B}, m, v, s, t) where {B}
    G = _ngroups(Val(B), length(v))
    _each!(_group_body!, Serial(), v, G, G, v, s, m, t, Val(B), G)
    return nothing
end

# Group `g`'s step, on one-entry views of its entries of `v` and `s`.
function _group_body!(g, v, s, m, t, ::Val{B}, G) where {B}
    nv, ns = B
    vg, sg = _entries(v, Val(nv), G, g), _entries(s, Val(ns), G, g)
    _written(m, @inline forward!(m, Step(), vg, sg, t, g))
    return nothing
end

# The group `g` entries of `x`, compartment by compartment, as one-entry
# views of `x` itself with the axis `g:g`: immutable, so a step that is not
# inlined, such as one over more than 32 entries, puts nothing on the heap.
@generated function _entries(x, ::Val{n}, G, g) where {n}
    return Expr(:tuple, (:(_At(_Shifted(x, $(i - 1) * G), g)) for i in 1:n)...)
end
# The entries of one-entry views, and their write-back, as straight-line
# code: past 32 entries `map` and `foreach` on a tuple do not unroll.
@generated function _held(v::Tuple)
    return Expr(:tuple, (:(v[$i][]) for i in 1:fieldcount(v))...)
end
@generated function _hold!(v::Tuple, x::Tuple)
    body = (:(v[$i][] = x[$i]) for i in 1:fieldcount(v))
    return Expr(:block, body..., :(return nothing))
end

function _vector_step!(::Nothing, m, v, s, t)
    blocks(m) === (1, 1) && throw(
        ArgumentError(
            "$(typeof(m)) has blocks (1, 1), so it is pointwise and " *
                "needs forward!(m, Step(), v, s, t); a group step " *
                "forward!(m, Step(), v, s, t, g) is called only for " *
                "another shape"
        )
    )
    throw(
        ArgumentError(
            "$(typeof(m)) has no forward!(m, Step(), v, s, t), and is not " *
                "blockwise (see blocks)"
        )
    )
end

function _pointwise_body!(k, v, s, m, t)
    v[k], s[k] = _step(m, v[k], s[k], t, k)
    return nothing
end

# The modifier's own, or per stratum or group for a pointwise or blockwise one
# without; not a `pullback!` method, which would count as every modifier's
# own. On device arrays a pointwise modifier reverses per stratum.
function _vector_pullback!(grads, m, v, s, t)
    _has_vector_pullback(m) && !(_on_gpu(v) && _strata_loop(m)) &&
        return pullback!(grads, m, Step(), v, s, t)
    return _split_pullback!(_blocks(m), grads, m, v, s, t)
end
function _split_pullback!(::Nothing, grads, m, v, s, t)
    _strata_loop(m) && return _strata_pullback!(grads, m, v, s, t)
    uses_adjoint(m, Step()) && return pullback!(grads, m, Step(), v, s, t)
    return _local_step_back!(grads, m, v, s, t)
end
# Groups that share a parameter add into stacked copies of its cotangent.
function _split_pullback!(::Val{B}, grads, m, v, s, t) where {B}
    G = _ngroups(Val(B), length(v))
    accs = _accumulators(Serial(), v, G, G, _param_slots(grads.piece, m))
    _reduce_blocks!(
        _group_back!, accs, G, grads.v, grads.s, m, v, s, t, Val(B), G
    )
    _reduce!(accs)
    return nothing
end
function _group_back!(gs, acc, v̄, s̄, m, v, s, t, ::Val{B}, G) where {B}
    nv, ns = B
    m̄ = _unown(acc)
    for g in gs
        gg = (;
            piece = m̄, v = _entries(v̄, Val(nv), G, g),
            s = _entries(s̄, Val(ns), G, g),
        )
        vg, sg = _entries(v, Val(nv), G, g), _entries(s, Val(ns), G, g)
        if uses_adjoint(m, Step())
            _written(m, @inline pullback!(gg, m, Step(), vg, sg, t, g))
        else
            gl = (; piece = m̄, v = _held(gg.v), s = _held(gg.s))
            v̄g, s̄g = _block_local_back(gl, m, _held(vg), _held(sg), t, g)
            _hold!(gg.v, v̄g)
            _hold!(gg.s, s̄g)
        end
    end
    return nothing
end
# A cotangent the strata share is copied per block and summed by `_reduce!`.
function _strata_pullback!(grads, m, v, s, t)
    v̄, s̄ = grads.v, grads.s
    n = length(eachindex(v, s, v̄, s̄))
    accs = _accumulators(Serial(), v, n, n, _param_slots(grads.piece, m))
    _reduce_blocks!(_strata_steps_back!, accs, n, v̄, s̄, m, v, s, t)
    _reduce!(accs)
    return nothing
end
function _strata_steps_back!(ks, acc, v̄, s̄, m, v, s, t)
    m̄ = _unown(acc)
    for k in ks
        @inbounds v̄[k], s̄[k] = _step_pullback(
            (; piece = m̄, v = v̄[k], s = s̄[k]), m, v[k], s[k], t, k
        )
    end
    return nothing
end

# == Modifier stages ==

# Run the modifiers in tuple order on the step's values, in place.
_stages!(::Tuple{}, ::Tuple{}, v, t) = nothing
function _stages!(ms::Tuple, states::Tuple, v, t)
    _stage!(first(ms), v, first(states), t)
    return _stages!(Base.tail(ms), Base.tail(states), v, t)
end

# A pointwise modifier runs per stratum, so the strata loop runs where the
# executor puts it, on a device too; any other on the whole vectors.
_stage!(m, v, s, t) = _stage!(Val(_strata_loop(m)), m, v, s, t)
_stage!(::Val{false}, m, v, s, t) = forward!(m, Step(), v, s, t)
function _stage!(::Val{true}, m, v, s, t)
    n = length(eachindex(v, s))
    _each!(_pointwise_body!, Serial(), v, n, n, v, s, m, t)
    return nothing
end
