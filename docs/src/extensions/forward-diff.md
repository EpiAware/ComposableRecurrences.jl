# [ForwardDiff extension](@id extension-forwarddiff)

Loading ForwardDiff with ComposableRecurrences, as with `using ForwardDiff`, loads `ComposableRecurrencesForwardDiffExt`.

It holds the dual-number code of the [local step](@ref adjoint-routing).
This is the default pullback of each coupling, modifier, depletion form and initial state without its own `pullback!`, and the local derivative of a [`Transform`](@ref ComposableRecurrences.Transform) without a `derivative`.
It also holds the [`Recurrence`](@ref) constructor's check that the local step can rebuild each component it differentiates.
Without this extension, a gradient through a component that needs the local step uses plain AD instead, which is [slower](@ref adjoint-local-step).
ForwardDiff gradients take [plain automatic differentiation (AD)](@ref adjoint-backends), so they do not use the local step.
