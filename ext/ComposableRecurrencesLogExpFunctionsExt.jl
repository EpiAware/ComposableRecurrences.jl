module ComposableRecurrencesLogExpFunctionsExt

# Closed-form partials for the link functions, so a `Derived` map of one of
# them takes its derivative from its value rather than by dual numbers.
using ComposableRecurrences: ComposableRecurrences
using LogExpFunctions: logistic, log1pexp, logit

const _Links = Union{typeof(logistic), typeof(log1pexp), typeof(logit)}

function ComposableRecurrences._partials(f::_Links, xs::Tuple{Real})
    return last(ComposableRecurrences._value_and_partials(f, xs))
end
function ComposableRecurrences._value_and_partials(
        ::typeof(logistic), (a,)::Tuple{Real}
    )
    h = logistic(a)
    return h, (h * (one(h) - h),)
end
function ComposableRecurrences._value_and_partials(
        ::typeof(log1pexp), (a,)::Tuple{Real}
    )
    return log1pexp(a), (logistic(a),)
end
function ComposableRecurrences._value_and_partials(
        ::typeof(logit), (a,)::Tuple{Real}
    )
    return logit(a), (inv(a * (one(a) - a)),)
end

end
