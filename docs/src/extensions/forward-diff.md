# [ForwardDiff extension](@id extension-forwarddiff)

Loading ForwardDiff with ComposableRecurrences, as with `using ForwardDiff`, loads `ComposableRecurrencesForwardDiffExt`.

It holds the dual-number code of the [local step](@ref adjoint-routing).
This is the default pullback of each coupling, modifier, depletion form and initial state without its own `pullback!`, and the local derivative of a [`Transform`](@ref ComposableRecurrences.Transform) without a `derivative`.
It also holds the [`Recurrence`](@ref) constructor's check that the local step can rebuild each component it differentiates.
Without this extension, a gradient through the local step throws an `ArgumentError`, and so does one through a component the local step [cannot rebuild](@ref adjoint-local-step).
ForwardDiff gradients take [plain automatic differentiation (AD)](@ref adjoint-backends), so they do not use the local step.
