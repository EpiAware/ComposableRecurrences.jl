# The role interface. Every operator, coupling, modifier or variant
# implements `forward`, and optionally `pullback!`, for a role.

@doc raw"
The role of an operator's whole call, `forward(op, Run(), args...; kwargs...)`,
which returns `(y, cache)`; calling the operator lowers to it.

For inputs ``u`` (the call's arguments and the operator's fields) it
computes the output over the call's times ``t = t_0, \dots, t_1``,

```math
y = f_{\mathrm{op}}(u), \qquad y = (y_{t_0}, \dots, y_{t_1}),
```

with ``f_{\mathrm{op}}`` the operator's own maths (see [`Recurrence`](@ref)
and [`Convolution`](@ref)); `cache` holds what the reverse pass needs, such
as the [`ComposableRecurrences.State`](@ref).

# Examples
```@example
using ComposableRecurrences
CR = ComposableRecurrences
y, cache = CR.forward(Recurrence([0.5, 0.5]), CR.Run(), fill(1.1, 4); history = ones(2))
```
"
struct Run end

@doc raw"
The role of one step of a modifier, or of a variant inside its owner (a
depletion form inside [`ComposableRecurrences.Depletion`](@ref)).

A modifier ``M`` maps the step's values and its own state at absolute time
``t`` to new ones,

```math
(v', s') = M(v, s, t), \qquad v, v', s, s' \in \mathbb{R}^S,
```

where ``v`` holds one value per stratum (one of ``S`` parallel series), ``s``
is the modifier's state after the previous step and ``s'`` its state after
this one.
A pointwise modifier acts on each stratum ``i`` separately,
``(v'_i, s'_i) = M_i(v_i, s_i, t)``.

  - `forward(m, Step(), v, s, t)` updates the step's values `v` and the
    modifier's state `s` in place (one entry per stratum) and returns
    `nothing`.
  - `forward(m, Step(), v, s, t, k)` is the scalar form for stratum `k`,
    returning `(v′, s′)`; a modifier with
    [`ComposableRecurrences.ispointwise`](@ref) implements this one.
  - `forward(form, Step(), v, s, N, α)` draws `v` from pool `s` for a
    depletion form, returning `(y, s′)`.

# Examples
```@example
using ComposableRecurrences
CR = ComposableRecurrences
CR.forward(CR.Hazard(), CR.Step(), 2.0, 80.0, 100.0, 1.0)
```
"
struct Step end

@doc raw"
The role of a modifier's initial state: `forward(m, Init(), s, history)`
writes the state `s` (one entry per stratum, allocated by the operator at
its buffer eltype) from the full history, and returns `nothing`.

It sets the state before the first step of the call at ``t_0``,

```math
s_{t_0 - 1} = I_M(h), \qquad h = (y_{t_0 - m}, \dots, y_{t_0 - 1}),
```

where ``h`` is the whole history of length ``m``, not only the last ``L``
values the recursion reads, and ``I_M`` is the modifier's own map.
The default is ``s_{t_0 - 1} = 0``.

# Examples
```@example
using ComposableRecurrences
CR = ComposableRecurrences
s = zeros(2)
CR.forward(CR.Depletion(PerStratum([100.0, 50.0])), CR.Init(), s, ones(2, 3))
s
```
"
struct Init end

@doc raw"
The role of a coupling: `forward(C, Pressure(), q, p, t)` writes into `q`
the mixing of the per-stratum kernel convolutions `p` at absolute time `t`,
and returns `nothing`.

For the built-in couplings

```math
q_{t,i} = \sum_{j=1}^{S} C_{t,ij}\, p_{t,j},
```

where ``p_{t,j}`` is stratum ``j``'s kernel convolution of its past values,
``q_{t,i}`` the pressure on stratum ``i`` and ``C_{t,ij}`` the weight of
stratum ``j`` in stratum ``i``, with ``S`` strata (parallel series).
`λ * I` gives ``C_{t,ij} = \lambda \delta_{ij}``, a matrix `C` gives
``C_{t,ij}`` = `C[i, j]` at every ``t``, and a [`TimeVarying`](@ref)
coupling gives ``C_{t,ij}`` = `C.x[i, j, t]`.
To add a coupling, define a type and add this method; it may compute any
``q_t`` from ``p_t`` and ``t``.

# Examples
```@example
using ComposableRecurrences
CR = ComposableRecurrences
q = zeros(2)
CR.forward([0.9 0.1; 0.2 0.8], CR.Pressure(), q, [1.0, 2.0], 1)
q
```
"
struct Pressure end

@doc raw"
Run `x` in `role` on primal arguments `args`.

For the role's inputs ``u`` it computes its outputs

```math
o = f_{\mathrm{role}}(u),
```

with ``f_{\mathrm{role}}`` the map each role's docstring gives:
[`ComposableRecurrences.Run`](@ref) an operator's whole call,
[`ComposableRecurrences.Step`](@ref) a modifier step ``(v, s) \mapsto (v', s')``,
[`ComposableRecurrences.Init`](@ref) an initial state from the history and
[`ComposableRecurrences.Pressure`](@ref) a coupling ``q_t = C_t p_t``.
Array outputs are written into the leading array arguments and the method
returns `nothing`; a scalar [`ComposableRecurrences.Step`](@ref) returns its
new scalars and [`ComposableRecurrences.Run`](@ref) returns `(y, cache)`.
To extend the package, define a type and add this method for its role:
[`ComposableRecurrences.Step`](@ref) and [`ComposableRecurrences.Init`](@ref)
for a modifier or variant, [`ComposableRecurrences.Pressure`](@ref) for a
coupling.

# Arguments
- `x`: the operator, coupling, modifier or variant.
- `role`: `Run()`, `Step()`, `Init()` or `Pressure()`.
- `args`: the role's arguments.

# Examples
```@example
using ComposableRecurrences
CR = ComposableRecurrences
struct Offset
    b::Float64
end
CR.ispointwise(::Offset) = true
CR.forward(m::Offset, ::CR.Step, v, s, t, k) = (v + m.b, s)
Recurrence([0.5, 0.5]; modifiers = (Offset(1.0),))(1.0; history = ones(2), stop = 4)
```
"
function forward end

@doc raw"
Accumulate the reverse pass of [`ComposableRecurrences.forward`](@ref) for
`x` in `role`.

For `forward` computing outputs ``o = f(u, \theta)`` from inputs ``u`` and
the object's parameters ``\theta``, given the output cotangent ``\bar o``
(the gradient of a scalar loss with respect to ``o``) it adds

```math
\bar u \mathrel{+}= \Big(\frac{\partial o}{\partial u}\Big)^{\top} \bar o,
\qquad
\bar\theta \mathrel{+}= \Big(\frac{\partial o}{\partial \theta}\Big)^{\top} \bar o .
```

`grads` is a NamedTuple: `grads.piece` holds ``\bar\theta``, mirroring the
object's parameters (or is `nothing`), and the other fields are named after
the role's arguments.
Output cotangents are read on entry and input cotangents accumulated; a
buffer `forward` updated in place is overwritten with the cotangent of its
incoming value, and a scalar `Step` returns its input cotangents instead.
Declare [`ComposableRecurrences.uses_adjoint`](@ref) for the same role so
an operator's native rule calls it.
Without one, a pointwise modifier with only scalar float parameters is
differentiated locally with `ForwardDiff`, and any other object makes the AD
backend differentiate the whole operator.

# Arguments
- `grads`: the cotangents, `(; piece, ...)`, with `piece` the mirror of
  `x`'s parameters.
- `x`: the operator, coupling, modifier or variant.
- `role`: the role.
- `args`: the primal arguments `forward` was given.

# Examples
```@example
using ComposableRecurrences
CR = ComposableRecurrences
m = CR.Clamp(0.0, 1.0)
grads = (; piece = (; lo = Ref(0.0), hi = Ref(0.0)), v = [1.0, 1.0], s = [0.0, 0.0])
CR.pullback!(grads, m, CR.Step(), [0.5, 2.0], [0.0, 0.0], 1)
grads.v, grads.piece.hi[]
```
"
function pullback! end

@doc raw"
Whether modifier `m` acts on each stratum separately.

A pointwise modifier's step factorises over strata (the ``S`` parallel
series): at absolute time ``t``, stratum ``i``'s new value and state depend
only on its own,

```math
(v'_i, s'_i) = M_i(v_i, s_i, t), \qquad i = 1, \dots, S .
```

This sets which [`ComposableRecurrences.Step`](@ref) a modifier implements:
a per-stratum map sets `ispointwise(m) = true` and implements the scalar
`forward(m, Step(), v, s, t, k)`, which the default vector step loops over
strata; a modifier that couples strata implements
`forward(m, Step(), v, s, t)` instead.
The default is `false`.

# Arguments
- `m`: the modifier.

# Examples
```@example
using ComposableRecurrences
ComposableRecurrences.ispointwise(nothing)
```
"
ispointwise(m) = false

# Defaults: a zero initial state, and a vector step that loops the scalar
# one for a pointwise modifier.
function forward(m, ::Init, s, history)
    fill!(s, zero(eltype(s)))
    return nothing
end

function forward(m, ::Step, v, s, t)
    ispointwise(m) || throw(
        ArgumentError(
            "$(typeof(m)) implements neither forward(m, Step(), v, s, t) " *
                "nor a pointwise forward(m, Step(), v, s, t, k)"
        )
    )
    for k in eachindex(v, s)
        v[k], s[k] = forward(m, Step(), v[k], s[k], t, k)
    end
    return nothing
end

function pullback!(grads, m, ::Step, v, s, t)
    v̄, s̄ = grads.v, grads.s
    for k in eachindex(v, s, v̄, s̄)
        v̄[k], s̄[k] = pullback!(
            (; piece = grads.piece, v = v̄[k], s = s̄[k]), m, Step(), v[k],
            s[k], t, k
        )
    end
    return nothing
end

# Run the modifiers in tuple order on the step's values, in place.
_stages!(::Tuple{}, ::Tuple{}, v, t) = nothing
function _stages!(ms::Tuple, states::Tuple, v, t)
    forward(first(ms), Step(), v, first(states), t)
    return _stages!(Base.tail(ms), Base.tail(states), v, t)
end
