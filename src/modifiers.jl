# The modifier interface. A modifier is any object; these functions give it
# its behaviour, and modifiers run in tuple order after the core of each step
# of a Recurrence, or on each output step of a Convolution.

@doc "
The initial state of modifier `m`: a vector with one entry per stratum.

The default is zeros.
The state is copied into the operator's buffer eltype before the first step.

# Arguments
- `m`: the modifier.
- `history`: the full history passed to the call (length `m`, or `S × m`),
  not only the last `L` values.

# Examples
```@example
using ComposableRecurrences
ComposableRecurrences.init_state(nothing, ones(2, 3))
```
"
init_state(m, history) = zeros(eltype(history), _nstrata(history))

@doc "
Whether modifier `m` acts on each stratum separately.

A pointwise modifier implements the scalar [`apply`](@ref), and the default
[`apply!`](@ref) loops it over strata.
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

@doc "
Apply pointwise modifier `m` to stratum `k`'s value `v` and state `s` at step
`t`, returning the new `(v, s)`.

Implement this, with [`ispointwise`](@ref) returning `true`, for a modifier
that acts on each stratum separately.

# Arguments
- `m`: the modifier.
- `v`: the stratum's value at this step.
- `s`: the stratum's state before this step.
- `t`: the time index of the step.
- `k`: the stratum.

# Examples
```@example
using ComposableRecurrences
struct Offset
    b::Float64
end
ComposableRecurrences.ispointwise(::Offset) = true
ComposableRecurrences.apply(m::Offset, v, s, t, k) = (v + m.b, s)
Recurrence([0.5, 0.5]; modifiers = (Offset(1.0),))(1.0; history = ones(2), add = zeros(4))
```
"
function apply(m, v, s, t, k)
    throw(ArgumentError("$(typeof(m)) implements no pointwise apply"))
end

@doc "
Apply modifier `m` in place at step `t`: overwrite the step's values `v` and
the modifier's state `s` (both one entry per stratum).

The default loops the scalar [`apply`](@ref) over strata when
[`ispointwise`](@ref) is `true`.
A modifier that couples strata implements this method.

# Arguments
- `m`: the modifier.
- `v`: the step's values, `gain ⊙ x + add` after earlier modifiers.
- `s`: the modifier's state before this step.
- `t`: the time index of the step.

# Examples
```@example
using ComposableRecurrences
struct Normalise end
function ComposableRecurrences.apply!(::Normalise, v, s, t)
    v ./= sum(v)
    return nothing
end
Recurrence([0.5, 0.5]; modifiers = (Normalise(),))(ones(2, 4); history = ones(2, 2))
```
"
function apply!(m, v, s, t)
    ispointwise(m) || throw(
        ArgumentError(
            "$(typeof(m)) implements neither apply! nor a pointwise apply"
        )
    )
    for k in eachindex(v, s)
        v[k], s[k] = apply(m, v[k], s[k], t, k)
    end
    return nothing
end

@doc "
Accumulate the reverse pass of [`apply!`](@ref) for modifier `m` at step `t`.

Given the step's inputs `v`, `s` and the cotangents of its outputs in `v̄`,
`s̄`, overwrite `v̄`, `s̄` with the cotangents of the inputs and add parameter
cotangents into `m̄`.
The package defines no methods; an operator is differentiated by the AD
backend.

# Arguments
- `m̄`: the cotangent of the modifier's parameters.
- `m`: the modifier.
- `v`: the step's values before the modifier.
- `s`: the modifier's state before the step.
- `t`: the step.
- `v̄`: the cotangent of the values after the modifier.
- `s̄`: the cotangent of the state after the step.

# Examples
```@example
using ComposableRecurrences
methods(ComposableRecurrences.apply_pullback!)
```
"
function apply_pullback! end

# Run the modifiers in tuple order on the step's values, in place.
_stages!(::Tuple{}, ::Tuple{}, v, t) = nothing
function _stages!(ms::Tuple, states::Tuple, v, t)
    apply!(first(ms), v, first(states), t)
    return _stages!(Base.tail(ms), Base.tail(states), v, t)
end

_all_pointwise(::Tuple{}) = true
_all_pointwise(ms::Tuple) = ispointwise(first(ms)) && _all_pointwise(Base.tail(ms))

# Thread one stratum's value through pointwise modifiers in tuple order.
_thread(::Tuple{}, ::Tuple{}, v, τ, k) = v
function _thread(ms::Tuple, states::Tuple, v, τ, k)
    s = first(states)
    v′, s[k] = apply(first(ms), v, s[k], τ, k)
    return _thread(Base.tail(ms), Base.tail(states), v′, τ, k)
end

# Pass step `τ`'s values `v` through the modifiers into `y`: stratum by
# stratum when every modifier is pointwise, else stage by stage on `v`.
function _modify!(y, modifiers, states, v, τ)
    if _all_pointwise(modifiers)
        for k in eachindex(y, v)
            y[k] = _thread(modifiers, states, v[k], τ, k)
        end
    else
        _stages!(modifiers, states, v, τ)
        for k in eachindex(y, v)
            y[k] = v[k]
        end
    end
    return y
end

# Each modifier's state at eltype `Tp`: its initial state from `history`, or
# the states `s0` returned by an earlier call.
function _init_states(::Type{Tp}, modifiers, history, s0) where {Tp}
    s0 === nothing &&
        return map(m -> _state_vector(Tp, init_state(m, history)), modifiers)
    return map(s -> _state_vector(Tp, s), s0)
end

function _check_states(s0, modifiers)
    s0 === nothing || length(s0) == length(modifiers) || throw(
        ArgumentError(
            "$(length(s0)) modifier states given for " *
                "$(length(modifiers)) modifiers"
        )
    )
    return nothing
end
