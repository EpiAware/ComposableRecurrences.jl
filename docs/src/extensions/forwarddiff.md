# [ForwardDiff extension](@id extension-forwarddiff)

`ComposableRecurrencesForwardDiffExt` is loaded automatically when ForwardDiff is loaded alongside ComposableRecurrences, as with `using ForwardDiff`.

It holds the dual-number code of the local step: the default pullbacks of couplings, modifiers, depletion forms and initial states without their own `pullback!`, and the local derivative of a [`Transform`](@ref ComposableRecurrences.Transform) without a `derivative`.
So is the pullback of the flow amounts that a [`Pool`](@ref ComposableRecurrences.Pool) without a draw records in a trace.
It also holds the `Recurrence` constructor's check that the local step can rebuild each part it differentiates.
[What the local step needs](@ref adjoint-local-step) says when the local step runs, what it needs, and what a gradient does without this extension.

ForwardDiff gradients of an operator do not use its local step: dual numbers pass through the forward pass, which takes plain AD (see [Backends](@ref adjoint-backends)).
