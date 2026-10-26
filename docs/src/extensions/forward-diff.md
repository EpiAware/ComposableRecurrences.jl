# [ForwardDiff extension](@id extension-forwarddiff)

`ComposableRecurrencesForwardDiffExt` is loaded automatically when ForwardDiff is loaded alongside ComposableRecurrences, as with `using ForwardDiff`.

It holds the dual-number code of the [local step](@ref adjoint-routing): the default pullbacks of couplings, modifiers, depletion forms and initial states without their own `pullback!`, and the local derivative of a [`Transform`](@ref ComposableRecurrences.Transform) without a `derivative`.
It also holds the `Recurrence` constructor's check that the local step can rebuild each part it differentiates.
Without this extension, a gradient through the local step throws an `ArgumentError`, and so does one through a part the local step [cannot rebuild](@ref adjoint-local-step).
ForwardDiff gradients take [plain AD](@ref adjoint-backends), so they do not use the local step.
