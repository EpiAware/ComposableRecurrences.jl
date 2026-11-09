# `test_adjoint` for Enzyme: EnzymeTestUtils' `test_reverse` on the rule's
# entry point `_ad`, with the operator as an argument.
module ComposableRecurrencesEnzymeTestUtilsExt

using ADTypes: AutoEnzyme
using ComposableRecurrences: ComposableRecurrences, Run, _ad, _run_forward
using Enzyme: Enzyme, Const, Active, Duplicated, MixedDuplicated
using EnzymeTestUtils: test_reverse

# Arrays are Duplicated, scalars Active, `nothing` and integers Const.
function _act(x)
    x isa Union{Nothing, Integer, Symbol} && return Const
    return Enzyme.guess_activity(typeof(x), Enzyme.Reverse) <: Active ? Active :
        Duplicated
end

# The rule's entry point with the operator read from a `Ref`.
_ad_ref(r, args...) = _ad(r[], args...)

# The operator is tested active (as Enzyme would annotate it) and constant;
# a constant operator needs runtime activity. EnzymeTestUtils cannot build
# MixedDuplicated, so an operator with array and scalar fields is tested
# active in a `Duplicated` `Ref`, whose shadow takes its cotangent. On Julia
# 1.11 Enzyme drops the cotangent of a scalar field read from a `Ref`, so
# that check runs from 1.12.
function ComposableRecurrences.test_adjoint(::AutoEnzyme, op, ::Run, args...; kwargs...)
    ret = _act(first(_run_forward(op, args...)))
    xs = map(x -> (x, _act(x)), args)
    opact = Enzyme.guess_activity(typeof(op), Enzyme.Reverse)
    if opact <: MixedDuplicated
        if VERSION >= v"1.12"
            test_reverse(_ad_ref, ret, (Ref(op), Duplicated), xs...; kwargs...)
        else
            @info "On Julia 1.11 an operator with array and scalar fields " *
                "is checked as Const only: Enzyme drops the cotangent of its " *
                "scalar fields read from a Ref." maxlog = 1
        end
        acts = (Const,)
    else
        acts = opact <: Active ? (Active, Const) : (Duplicated, Const)
    end
    for a in acts
        test_reverse(_ad, ret, (op, a), xs...; runtime_activity = a === Const, kwargs...)
    end
    return nothing
end

end
