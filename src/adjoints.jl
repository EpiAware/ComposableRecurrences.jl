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

@doc "
Accumulate the reverse pass of operator `op` from the cotangent `ȳ` of its
output, given the cache its forward pass recorded.

Cotangents of the operator's fields (kernel, coupling, modifier parameters)
and of its inputs are added into `op̄` and `inputs̄`.
The package defines no methods; an operator is differentiated by the AD
backend.

# Arguments
- `op̄`: the cotangent of the operator's fields.
- `inputs̄`: the cotangents of the call's inputs.
- `op`: the operator.
- `cache`: what the forward pass recorded.
- `ȳ`: the cotangent of the output.

# Examples
```@example
using ComposableRecurrences
methods(ComposableRecurrences.pullback!)
```
"
function pullback! end
