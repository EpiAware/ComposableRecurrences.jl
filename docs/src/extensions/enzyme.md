# [Enzyme extension](@id extension-enzyme)

`ComposableRecurrencesEnzymeExt` is loaded automatically when Enzyme is available alongside ComposableRecurrences.

It registers the rule of every operator as an Enzyme reverse-mode rule.
[Rules and plain AD](@ref adjoint-routing) says when a call takes the rule.
It refuses [`NoAdjoint`](@ref ComposableRecurrences.NoAdjoint) on an active sparse coupling, where plain Enzyme reverse AD gives wrong gradients.

On Julia 1.11, an operator built in code that Julia cannot infer can get a zero Enzyme reverse gradient for its scalar float fields, such as `b` in `Add(b)` or the population of a `Depletion`.
Uninferred code includes a closure that captures a variable it reassigns, or a call through a global that is not constant.
Enzyme loses the gradient in that code, before any rule runs, so the extension cannot detect or refuse it.
Instead it warns once per operator type, the first time Enzyme reverse mode differentiates an operator with an active scalar field on 1.11.
Use Julia 1.12 or later, where Enzyme keeps these gradients, or build operators in type-stable code (check it with `@code_warntype`).
