@doc "
Wrap an operator so it is differentiated by the AD backend's own treatment of
its forward loop, bypassing any hand-written adjoint.

Called exactly like the wrapped operator.
Useful to time a hand-written adjoint against plain AD.

# Examples
```@example
using ComposableRecurrences
r = Recurrence([0.2, 0.3, 0.5])
ComposableRecurrences.NoAdjoint(r)(fill(1.1, 6); history = ones(3))
```
"
struct NoAdjoint{O}
    "The wrapped operator."
    op::O
end

(n::NoAdjoint)(args...; kwargs...) = n.op(args...; kwargs...)
