# [ADTypes + Mooncake + Random extension](@id extension-mooncake)

`ComposableRecurrencesMooncakeExt` is loaded automatically when ADTypes, Mooncake and Random are available alongside ComposableRecurrences.

It registers the rule of every operator as a Mooncake reverse-mode `rrule!!`, and adds [`test_adjoint`](@ref ComposableRecurrences.test_adjoint) for `AutoMooncake`.
[Rules and plain AD](@ref adjoint-routing) says when a call takes the rule.
Plain Mooncake AD of a [`Convolution`](@ref) calls BLAS `axpy!` per lag, which Mooncake differentiates with one rule.
