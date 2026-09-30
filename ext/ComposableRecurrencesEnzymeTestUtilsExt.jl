# `test_adjoint` for Enzyme: EnzymeTestUtils' `test_reverse` on the rule's
# entry point `_ad`, with the operator as an argument.
module ComposableRecurrencesEnzymeTestUtilsExt

using ADTypes: AutoEnzyme
using ComposableRecurrences: ComposableRecurrences, _ad, forward
using Enzyme: Enzyme, Const, Active, Duplicated, MixedDuplicated
using EnzymeTestUtils: test_reverse

# Arrays are Duplicated, scalars Active, `nothing` and integers Const.
function _act(x)
    x isa Union{Nothing, Integer, Symbol} && return Const
    return Enzyme.guess_activity(typeof(x), Enzyme.Reverse) <: Active ? Active :
        Duplicated
end

# The operator is tested active (as Enzyme would annotate it) and constant;
# a constant operator needs runtime activity. EnzymeTestUtils cannot build
# MixedDuplicated, so an operator with array and scalar fields is tested
# constant only.
function ComposableRecurrences.test_adjoint(::AutoEnzyme, op, args...; kwargs...)
    ret = _act(first(forward(op, args...)))
    xs = map(x -> (x, _act(x)), args)
    opact = Enzyme.guess_activity(typeof(op), Enzyme.Reverse)
    acts = opact <: MixedDuplicated ? (Const,) :
        opact <: Active ? (Active, Const) : (Duplicated, Const)
    for a in acts
        test_reverse(_ad, ret, (op, a), xs...; runtime_activity = a === Const, kwargs...)
    end
    return nothing
end

end
