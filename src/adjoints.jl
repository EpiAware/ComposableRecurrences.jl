@doc raw"
Wrap an operator so it is differentiated by the AD backend's own treatment of
its forward loop, bypassing any hand-written adjoint.

Called exactly like the wrapped operator, it computes the same output,

```math
f_{\mathrm{NoAdjoint(op)}}(u) = f_{\mathrm{op}}(u),
```

for every input ``u``, so its gradient ``\nabla_u f`` is the same quantity
by a different route: the backend's derivative of the forward loop rather
than the hand-written pullback.
Useful to time a hand-written adjoint against plain AD, and to check the two
gradients agree.

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
