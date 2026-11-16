# ---- float precision of a model ----------------------------------------------

@doc raw"""
    convert_floats(T, x)

`x` with every float it holds converted to the float type `T`: float
arrays, which stay on their device, and single floats, such as a
population or a scale.
Each float ``v`` becomes the nearest value of type `T`,

```math
v \mapsto \operatorname{round}_T(v).
```

Integers, `Bool`s, numbers that are not floats (such as dual numbers),
functions and the structure of `x` are kept.

An operator's output takes its float type from every array and number it
is given, so a `Float64` parameter promotes a run on `Float32` arrays to
`Float64`.
Converting the whole model keeps the run in `T`, which a GPU needs: most
run `Float32` much faster, and some have no `Float64` at all.
Compose it with a device move, for example
`adapt(CuArray, convert_floats(Float32, r))`.

It needs Functors.jl, whose `fmap` walks the model: run `using Functors`
first.

# Arguments
- `T`: the float type, such as `Float32`.
- `x`: an operator, a modifier, a coefficient or an array.

# Examples
```jldoctest
using ComposableRecurrences, Functors
using ComposableRecurrences: Depletion, convert_floats
r = Recurrence([0.5, 0.3]; modifiers = (Depletion(60.0),))
y = convert_floats(Float32, r)(Float32.(fill(1.2, 4)); history = Float32[1, 1])
eltype(y)

# output

Float32
```
"""
function convert_floats(::Type{T}, x) where {T <: AbstractFloat}
    return _convert_floats(T, x)
end
# The Functors extension walks the model.
_convert_floats(T, x) = _no_functors()
@noinline function _no_functors()
    throw(ArgumentError("convert_floats needs Functors.jl: run `using Functors` first"))
end
