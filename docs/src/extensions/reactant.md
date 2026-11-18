# [Reactant extension](@id extension-reactant)

`ComposableRecurrencesReactantExt` is loaded automatically when Reactant and KernelAbstractions are available alongside ComposableRecurrences.
A traced call runs its strata loops as KernelAbstractions kernels, and Reactant compiles a kernel through CUDA.jl, on the CPU too.
So load CUDA.jl as well, whatever the target; a traced call without it throws an error that says so.

Operator calls on traced arrays compile with `Reactant.@compile`:

```julia
using ComposableRecurrences, Reactant, KernelAbstractions, CUDA
r = Recurrence([0.5, 0.3])
R = Reactant.to_rarray(fill(1.1, 50))
f(R) = r(R; history = [1.0, 1.0])
y = (Reactant.@compile f(R))(R)
```

Enzyme gradients of them compile once Reactant has raised the kernels to array operations, so pass `raise = true` and `raise_first = true`:

```julia
using Enzyme
loss(R) = sum(f(R))
grad(R) = Enzyme.gradient(Enzyme.Reverse, loss, R)[1]
dR = (Reactant.@compile raise = true raise_first = true grad(R))(R)
```

Without them the gradient fails to compile, in Reactant's pass pipeline.

To [join the history in front](@ref explanation-returns) of a traced output, pass the history in as a traced array too.
Joining a host array to a traced one is a scalar-indexing error.

```julia
h = Reactant.to_rarray([1.0, 1.0])
joined(R, h) = vcat(h, r(R; history = h))
y = (Reactant.@compile joined(R, h))(R, h)
```

A traced call runs its own executor whatever [executor](@ref executors) is set, and Enzyme differentiates the traced program rather than using the hand-written gradients.
The time loop compiles to one loop whose body is a step, so the program does not grow with the number of steps.
From [`TRACED_MIN_STRATA`](@ref ComposableRecurrences.TRACED_MIN_STRATA) strata, each step runs its [strata](@ref overview-step) as one kernel, the [`Device`](@ref ComposableRecurrences.Device) executor's, so the program does not grow with the number of strata either.
Fewer strata are written out, one block a stratum: the program grows with the strata, but on the CPU it runs faster than a kernel launch each step.
The default threshold is measured on the CPU; on a GPU, where a launch costs less, a lower one may run faster:

```julia
using Base.ScopedValues: with
dR = with(ComposableRecurrences.TRACED_MIN_STRATA => 8) do
    (Reactant.@compile raise = true raise_first = true grad(R))(R)
end
```

A loop whose arguments cannot be a kernel's is written out too, so its program grows with the strata.
Such loops include a user's coupling or modifier holding a traced number, a parameter given by change points, and a view of a traced history.
The [support matrix](https://github.com/EpiAware/ComposableRecurrences.jl/blob/main/test/reactant/RESULTS.md) records, for every scenario of the AD test registry and a few cases at 20 and 400 steps on the CPU, whether the compiled call matches plain Julia and its gradient matches ForwardDiff.
