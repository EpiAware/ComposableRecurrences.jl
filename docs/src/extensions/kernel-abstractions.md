# [Adapt + KernelAbstractions extension](@id extension-kernel-abstractions)

Loading KernelAbstractions runs each loop of the [`Parallel`](@ref ComposableRecurrences.Parallel) executor as one kernel on a backend.
It also adds the Adapt.jl rules that carry coefficient wrappers and built-in modifiers into a kernel.
It works without a GPU package, here on the CPU backend:

```jldoctest
using ComposableRecurrences, KernelAbstractions
using ComposableRecurrences: EXECUTOR, Parallel
using Base.ScopedValues: with
r = Recurrence([0.5, 0.3])
R, h = fill(1.1, 3, 4), ones(3, 2)
y = with(() -> r(R; history = h), EXECUTOR => Parallel(CPU()))
y ≈ r(R; history = h)

# output

true
```

## Known issues

| Symptom | Workaround |
|---|---|
| An error inside a loop body loses its type on the CPU backend | Rerun under `Serial()` to see it |
| `Parallel(CPU())` is slower than `Threaded()` | Use [`Threaded`](@ref ComposableRecurrences.Threaded) on the CPU |
| A new modifier type holding arrays fails inside a kernel | Add an `Adapt.adapt_structure` method |

Executors are compared in [Executors](@ref executors); device arrays need the [GPUArrays extension](@ref extension-gpuarrays).

All extensions are listed in the [overview](@ref extensions-overview).
