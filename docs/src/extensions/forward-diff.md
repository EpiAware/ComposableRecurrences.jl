# [ForwardDiff extension](@id extension-forwarddiff)

`ComposableRecurrencesForwardDiffExt` is loaded automatically when ForwardDiff is loaded alongside ComposableRecurrences, as with `using ForwardDiff`.

It holds the dual-number code of the local step: the default pullbacks of couplings, modifiers, depletion forms and initial states without their own `pullback!`, and the local derivative of a [`Transform`](@ref ComposableRecurrences.Transform) without a `derivative`.
It also holds the `Recurrence` constructor's check that the local step can rebuild each part it differentiates.
[Rules and plain AD](@ref adjoint-routing) says when a call uses the local step, and [What the local step needs](@ref adjoint-local-step) what a gradient does without this extension.
ForwardDiff gradients take plain AD, so they do not use the local step ([Backends](@ref adjoint-backends)).
