# [Enzyme extension](@id extension-enzyme)

`ComposableRecurrencesEnzymeExt` is loaded automatically when Enzyme is available alongside ComposableRecurrences.

It registers the rule of every operator as an Enzyme reverse-mode rule.
[Rules and plain AD](@ref adjoint-routing) says when a call takes the rule.
It refuses [`NoAdjoint`](@ref ComposableRecurrences.NoAdjoint) on an active sparse coupling, where plain Enzyme reverse AD gives wrong gradients.

On Julia 1.11, Enzyme reverse mode can return a zero gradient for a scalar float field of an operator, such as `b` in `Add(b)`.
This happens when the code that builds the operator is not type-stable, for example a closure that captures a variable it reassigns.
The loss happens in that code, before any rule runs, so the extension cannot refuse the call.
It warns once instead, the first time it differentiates an operator with an active scalar field on 1.11.
Keep the code that builds operators type-stable, or use Julia 1.12 or later, where Enzyme keeps these gradients.
