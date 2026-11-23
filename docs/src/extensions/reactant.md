# [Adapt + KernelAbstractions + Reactant extension](@id extension-reactant)

Loading Reactant and KernelAbstractions lets operator calls on traced arrays compile with `Reactant.@compile`.
A loop over many strata runs as one kernel, and the time loop compiles to one loop, so the program does not grow with steps or strata.
Reactant compiles kernels through CUDA.jl, so load it too, on the CPU as well.
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
| Plain loops fail to compile, with no message | Load KernelAbstractions; without it the extension does not load |
| Error asking for CUDA.jl once a loop has [`TRACED_MIN_STRATA`](@ref ComposableRecurrences.TRACED_MIN_STRATA) strata | `using CUDA`, whatever the target |
| Enzyme gradient fails in Reactant's pass pipeline | Pass `raise = true raise_first = true` to `@compile` |
| Scalar-indexing error when [joining the history](@ref explanation-returns) to a traced output | Pass the history as a traced array: `h = Reactant.to_rarray(h)` |
| `if` refuses a traced `Bool` in a user modifier | Use `ifelse(v > c, c, v)` |
| `NaN` gradient through `ifelse` | Keep both arms finite: `ifelse(n > 0, k / ifelse(n > 0, n, one(n)), zero(n))` |
| Program grows with the strata | Loops below `TRACED_MIN_STRATA` strata, or holding a traced number or change points, are written out; lower the threshold with `with(ComposableRecurrences.TRACED_MIN_STRATA => 8) do ... end` |

A traced call ignores the set [executor](@ref executors), and Enzyme differentiates the traced program rather than the package's rules.
The [support matrix](https://github.com/EpiAware/ComposableRecurrences.jl/blob/main/test/reactant/RESULTS.md) records which scenarios compile and match.
How Reactant compares with other backends is in [Backends](@ref adjoint-backends).

All extensions are listed in the [overview](@ref extensions-overview).
