# [Enzyme extension](@id extension-enzyme)

`ComposableRecurrencesEnzymeExt` is loaded automatically when Enzyme is available alongside ComposableRecurrences.

It registers the [rule](@ref adjoint-routing) of every operator as an Enzyme reverse-mode rule.

On Julia 1.11, an operator built in code that Julia cannot infer can get a zero Enzyme reverse gradient for its scalar float fields, such as `b` in `Transform(+, b)` or the population of a `Depletion`.
Uninferred code includes a closure that captures a variable it reassigns, or a call through a global that is not constant.
Enzyme loses the gradient in that code, before any rule runs, so the extension cannot detect or refuse it.
Instead it warns once per operator type, the first time Enzyme reverse mode differentiates an operator with an active scalar field on 1.11.
Use Julia 1.12 or later, where Enzyme keeps these gradients, or build operators in type-stable code (check it with `@code_warntype`).

Under Enzyme reverse mode, a modifier whose type depends on a run-time branch, such as `m = flag ? Depletion(N) : Depletion(N, Floor())`, makes the call fail with `TypeError: in new, expected Tuple{...}, got a value of type Tuple{Base.RefValue{...}}`.
The error comes from Enzyme when it differentiates the caller's keyword call `Recurrence(g; modifiers = (m,))`, before any package code runs.
Call a function on each concrete modifier instead, such as `flag ? model(Depletion(N), θ) : model(Depletion(N, Floor()), θ)`, so that the operator is built from a value of one type.
