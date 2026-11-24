# [Converting floats with Functors](@id extension-functors)

Loading Functors lets [`convert_floats`](@ref ComposableRecurrences.convert_floats) walk an operator and convert every float it holds.
Without Functors, `convert_floats` throws an error that says to load it.
Use it to keep a run in `Float32`, as a GPU needs:

```jldoctest
using ComposableRecurrences, Functors
using ComposableRecurrences: Depletion, convert_floats
r = Recurrence([0.5, 0.3]; modifiers = (Depletion(60.0),))
r32 = convert_floats(Float32, r)
eltype(r32(fill(1.2f0, 4); history = Float32[1, 1]))

# output

Float32
```
