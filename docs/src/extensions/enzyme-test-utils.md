# [ADTypes + Enzyme + EnzymeTestUtils extension](@id extension-enzyme-test-utils)

Loading ADTypes, Enzyme and EnzymeTestUtils with ComposableRecurrences loads `ComposableRecurrencesEnzymeTestUtilsExt`.

It adds [`ComposableRecurrences.test_adjoint`](@ref) for `AutoEnzyme`: `test_adjoint(AutoEnzyme(), op, ComposableRecurrences.Run(), args...)` runs `EnzymeTestUtils.test_reverse` on the rule of operator `op` at its positional arguments `args`.
