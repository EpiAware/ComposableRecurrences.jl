# [ForwardDiff extension](@id extension-forwarddiff)

`ComposableRecurrencesForwardDiffExt` is loaded automatically when ForwardDiff is available alongside ComposableRecurrences.

It holds the dual-number code of the local step: the default pullbacks of couplings, modifiers, depletion forms and initial states without their own `pullback!`, and the local derivative of a [`Transform`](@ref ComposableRecurrences.Transform) without a `derivative`.
It also holds the `Recurrence` constructor's check that the local step can rebuild each part it differentiates.
[What the local step needs](@ref adjoint-local-step) says when the local step runs and what it needs.

Without ForwardDiff the forward pass of every operator runs, and the rules of parts with their own `pullback!` work on every backend.
A gradient that needs the local step throws an `ArgumentError` naming the part and saying to load ForwardDiff.
ForwardDiff gradients of an operator do not use this extension: dual numbers pass through the forward pass, which takes plain AD (see [Backends](@ref adjoint-backends)).
