# The extension interface. Every operator, coupling, modifier or depletion
# form has a `forward` method, and optionally `pullback!`, for a role.

@doc "
The role of an operator's whole call, `forward(op, Run(), args...; kwargs...)`,
which returns `(y, cache)`; calling the operator lowers to it.

# Examples
```@example
using ComposableRecurrences
CR = ComposableRecurrences
y, cache = CR.forward(Recurrence([0.5, 0.5]), CR.Run(), fill(1.1, 4); history = ones(2))
```
"
struct Run end

@doc "
The role of one step of a modifier, or of a variant inside its owner (a
depletion form inside [`ComposableRecurrences.Depletion`](@ref)).

  - `forward(m, Step(), v, s, t)` updates the step's values `v` and the
    modifier's state `s` in place (one entry per stratum) and returns
    `nothing`.
  - `forward(m, Step(), v, s, t, k)` is the scalar form for stratum `k`,
    returning `(v′, s′)`; a modifier with
    [`ComposableRecurrences.ispointwise`](@ref) implements this one.
  - `forward(form, Step(), v, s, N, α)` draws `v` from pool `s` for a
    depletion form, returning `(y, s′)`.

`t` is the absolute time of the step.

# Examples
```@example
using ComposableRecurrences
CR = ComposableRecurrences
CR.forward(CR.Hazard(), CR.Step(), 2.0, 80.0, 100.0, 1.0)
```
"
struct Step end

@doc "
The role of a modifier's initial state: `forward(m, Init(), s, history)`
writes the state `s` (one entry per stratum, allocated by the operator at
its buffer eltype) from the full history, and returns `nothing`.

The default writes zeros.

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

@doc "
The role of a coupling: `forward(C, Pressure(), q, p, t)` writes into `q`
the mixing of the per-stratum kernel convolutions `p` at absolute time `t`,
and returns `nothing`.

`I` scales `p`, a matrix `C` gives `q = C p` and a [`TimeVarying`](@ref)
coupling uses its `t`-th slice.
A new coupling is a struct with this method.

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

@doc "
Run an operator, coupling, modifier or depletion form `piece` for the job
selected by the singleton `role`, on primal arguments `args`.

Array outputs are written into the leading array arguments and the method
returns `nothing`; a scalar [`ComposableRecurrences.Step`](@ref) returns its
new scalars and [`ComposableRecurrences.Run`](@ref) returns `(y, cache)`.
To extend the package, define a type and add this method for it:
[`ComposableRecurrences.Step`](@ref) and [`ComposableRecurrences.Init`](@ref)
for a modifier or depletion form, [`ComposableRecurrences.Pressure`](@ref)
for a coupling.

# Arguments
- `piece`: the operator, coupling, modifier or depletion form.
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

@doc "
Accumulate the reverse pass of [`ComposableRecurrences.forward`](@ref) for
the operator, coupling, modifier or depletion form `piece` in `role`.

`grads` is a NamedTuple: `grads.piece` mirrors `piece`'s parameters (or is
`nothing`) and the other fields are named after the role's arguments.
Output cotangents are read on entry and input cotangents accumulated; a
buffer `forward` updated in place is overwritten with the cotangent of its
incoming value, and a scalar `Step` returns its input cotangents instead.
A type without this method is differentiated by the AD backend.

# Arguments
- `grads`: the cotangents, `(; piece, ...)`.
- `piece`: the operator, coupling, modifier or depletion form.
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

@doc "
Whether modifier `m` acts on each stratum separately.

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
