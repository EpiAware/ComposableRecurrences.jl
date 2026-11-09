# ---- float precision of a model ----------------------------------------------

@doc raw"""
    f32(x)

`x` with every float it holds converted to `Float32`: float arrays, which
stay on their device, and single floats, such as a population or a scale.
Each float ``v`` of `x` becomes the nearest `Float32`,

```math
v \mapsto \operatorname{round}_{\mathrm{Float32}}(v).
```

Integers, `Bool`s, numbers that are not floats (such as dual numbers),
functions, symbols and the structure of `x` are kept.

An operator's output takes its element type from every array and number it
is given, so a `Float64` parameter promotes a run on `Float32` arrays to
`Float64`.
Converting the whole model runs it in `Float32`, as the `f32` of a neural
network library does, and also converts the scalar parameters such a
function leaves alone.

It walks tuples, named tuples, arrays of arrays and immutable structs, which
it rebuilds with `ConstructionBase.constructorof`, so a modifier of your own
is converted when it can be rebuilt from its fields.
Compose it with a device move, for example `adapt(CuArray, f32(r))`.

See also [`f64`](@ref ComposableRecurrences.f64) and
[`f16`](@ref ComposableRecurrences.f16).

# Examples
```jldoctest
using ComposableRecurrences
using ComposableRecurrences: Depletion, f32
r = Recurrence([0.5, 0.3]; modifiers = (Depletion(60.0),))
y = f32(r)(f32(fill(1.2, 4)); history = f32([1.0, 1.0]))
eltype(y)

# output

Float32
```
"""
f32(x) = _floats(Float32, x)

@doc raw"""
    f64(x)

`x` with every float it holds converted to `Float64`; see
[`f32`](@ref ComposableRecurrences.f32).
Each float ``v`` becomes

```math
v \mapsto \operatorname{round}_{\mathrm{Float64}}(v).
```

# Examples
```jldoctest
using ComposableRecurrences
using ComposableRecurrences: Depletion, f64
r = Recurrence([0.5, 0.3]; modifiers = (Depletion(60.0f0),))
y = f64(r)(f64(fill(1.2f0, 4)); history = f64(ones(Float32, 2)))
eltype(y)

# output

Float64
```
"""
f64(x) = _floats(Float64, x)

@doc raw"""
    f16(x)

`x` with every float it holds converted to `Float16`; see
[`f32`](@ref ComposableRecurrences.f32).
Each float ``v`` becomes

```math
v \mapsto \operatorname{round}_{\mathrm{Float16}}(v).
```

# Examples
```jldoctest
using ComposableRecurrences
using ComposableRecurrences: Depletion, f16
r = Recurrence([0.5, 0.3]; modifiers = (Depletion(60.0f0),))
y = f16(r)(f16(fill(1.2f0, 4)); history = f16(ones(Float32, 2)))
eltype(y)

# output

Float16
```
"""
f16(x) = _floats(Float16, x)

_floats(::Type{T}, x::AbstractFloat) where {T} = T(x)
_floats(::Type, x::Number) = x
_floats(::Type{T}, x::AbstractArray{<:AbstractFloat}) where {T} = T.(x)
_floats(::Type, x::AbstractArray{<:Number}) = x
_floats(::Type{T}, x::AbstractArray) where {T} = map(a -> _floats(T, a), x)
_floats(::Type{T}, x::Union{Tuple, NamedTuple}) where {T} = map(a -> _floats(T, a), x)
_floats(::Type, x::Union{Function, Type, Symbol, AbstractString, Module}) = x
# Any other immutable struct is rebuilt from its converted fields.
function _floats(::Type{T}, x::S) where {T, S}
    (isstructtype(S) && !ismutabletype(S) && fieldcount(S) > 0) || return x
    fields = map(f -> _floats(T, f), Tuple(ConstructionBase.getfields(x)))
    return constructorof(S)(fields...)
end
