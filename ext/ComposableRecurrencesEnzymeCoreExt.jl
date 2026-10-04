module ComposableRecurrencesEnzymeCoreExt

using ComposableRecurrences: ComposableRecurrences, Serial, _Current, _current
using EnzymeCore: Const
using EnzymeCore.EnzymeRules: EnzymeRules, AugmentedReturn, needs_primal

EnzymeRules.inactive_type(::Type{_Current}) = true

# Enzyme reverse mode does not differentiate the threaded loop, so a call it
# differentiates runs serially whatever executor is set. The executor
# carries no derivative.
function EnzymeRules.augmented_primal(
        config, ::Const{typeof(_current)}, ::Type{<:Const}
    )
    primal = needs_primal(config) ? _Current(Serial()) : nothing
    return AugmentedReturn(primal, nothing, nothing)
end

function EnzymeRules.reverse(
        config, ::Const{typeof(_current)}, ::Type{<:Const}, tape
    )
    return ()
end

end
