# [ADTypes + Enzyme + EnzymeTestUtils extension](@id extension-enzyme-test-utils)

`ComposableRecurrencesEnzymeTestUtilsExt` is loaded automatically when ADTypes, Enzyme and EnzymeTestUtils are available alongside ComposableRecurrences.

It adds [`ComposableRecurrences.test_adjoint`](@ref) for `AutoEnzyme`: `test_adjoint(AutoEnzyme(), op, ComposableRecurrences.Run(), args...)` runs `EnzymeTestUtils.test_reverse` on the rule of operator `op` at its positional arguments `args`.
