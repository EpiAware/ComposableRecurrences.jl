# [Adapt + KernelAbstractions + Reactant extension](@id extension-reactant)

Loading Reactant and KernelAbstractions lets operator calls on traced arrays compile with `Reactant.@compile`.
A loop over at least [`TRACED_MIN_STRATA`](@ref ComposableRecurrences.TRACED_MIN_STRATA) strata runs as one kernel, and the time loop compiles to one loop, so the program does not grow with steps or strata.
Without KernelAbstractions the extension does not load, and plain loops fail to compile.
Pass the history as a traced array too, to [join it](@ref explanation-returns) to a traced output.
These blocks are not run in the docs build, which has no Reactant:

```julia
using ComposableRecurrences, Reactant, KernelAbstractions, CUDA, Enzyme
r = Recurrence([0.5, 0.3])
R = Reactant.to_rarray(fill(1.1, 50))
f(R) = r(R; history = [1.0, 1.0])
y = (Reactant.@compile f(R))(R)

loss(R) = sum(f(R))
grad(R) = Enzyme.gradient(Enzyme.Reverse, loss, R)[1]
dR = (Reactant.@compile raise = true raise_first = true grad(R))(R)
```

## Known issues

| Symptom | Workaround |
|---|---|
| Error asking for CUDA.jl once a loop has `TRACED_MIN_STRATA` strata, as Reactant compiles kernels through it | `using CUDA`, on the CPU too |
| Enzyme gradient fails in Reactant's pass pipeline | Pass `raise = true raise_first = true` to `@compile` |
| `if` refuses a traced `Bool` in a user modifier | Use `ifelse(v > c, c, v)` |
| `NaN` gradient through `ifelse` | Keep both arms finite: `ifelse(n > 0, k / ifelse(n > 0, n, one(n)), zero(n))` |

A traced call ignores the set [executor](@ref executors), and Enzyme differentiates the traced program rather than the package's rules.
The [support matrix](https://github.com/EpiAware/ComposableRecurrences.jl/blob/main/test/reactant/RESULTS.md) records which scenarios compile and match.
How Reactant compares with other backends is in [Backends](@ref adjoint-backends).

All extensions are listed in the [overview](@ref extensions-overview).
