# [ADTypes + Enzyme + EnzymeTestUtils extension](@id extension-enzyme-test-utils)

Loading EnzymeTestUtils adds [`test_adjoint`](@ref ComposableRecurrences.test_adjoint) for `AutoEnzyme`.
It runs `EnzymeTestUtils.test_reverse` on the rule of an operator at its positional arguments.

```jldoctest; filter = r"Test Summary:.*\n.*\n"
using ComposableRecurrences, ADTypes, Enzyme, EnzymeTestUtils
using ComposableRecurrences: Run, test_adjoint
c = Convolution([0.5, 0.3, 0.2])
# The input, gain, add, history, start time and trace of a run.
args = (abs.(sin.(1:20)), true, nothing, [1.0, 1.0], 1, nothing)
test_adjoint(AutoEnzyme(), c, Run(), args...; rtol = 1.0e-7, atol = 1.0e-7)
true

# output

true
```

## Known issues

The [Enzyme extension's known issues](@ref extension-enzyme) apply.
