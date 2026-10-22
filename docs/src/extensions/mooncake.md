# [ADTypes + Mooncake + Random extension](@id extension-mooncake)

`ComposableRecurrencesMooncakeExt` is loaded automatically when ADTypes, Mooncake and Random are available alongside ComposableRecurrences.

It registers the rule of every operator as a Mooncake reverse-mode `rrule!!`, and adds [`ComposableRecurrences.test_adjoint`](@ref) for `AutoMooncake`: `test_adjoint(AutoMooncake(; config = nothing), op, ComposableRecurrences.Run(), args...)` runs `Mooncake.TestUtils.test_rule` on the rule of operator `op` at its positional arguments `args`.
[Rules and plain AD](@ref adjoint-routing) says when a call takes the rule.
Plain Mooncake AD of a [`Convolution`](@ref) calls BLAS `axpy!` per lag, which Mooncake differentiates with one rule.
