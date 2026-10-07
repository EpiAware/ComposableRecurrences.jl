# [Enzyme extension](@id extension-enzyme)

`ComposableRecurrencesEnzymeExt` is loaded automatically when Enzyme is available alongside ComposableRecurrences.

It registers the rule of every operator as an Enzyme reverse-mode rule.
[Rules and plain AD](@ref adjoint-routing) says when a call takes the rule.
It refuses [`NoAdjoint`](@ref ComposableRecurrences.NoAdjoint) on an active sparse coupling, where plain Enzyme reverse AD gives wrong gradients.
