module ComposableRecurrencesLogExpFunctionsExt

# Local rules for the link functions, so a `Derived` or `Transform` map of
# one of them takes its derivative from its value rather than by dual
# numbers.
using ComposableRecurrences: ComposableRecurrences, Local
using LogExpFunctions: logistic, log1pexp, logit

import ComposableRecurrences: pullback!

function pullback!(grads, ::typeof(logistic), ::Local, y, a::Real)
    return (y * (one(y) - y),)
end
function pullback!(grads, ::typeof(log1pexp), ::Local, y, a::Real)
    return (logistic(a),)
end
function pullback!(grads, ::typeof(logit), ::Local, y, a::Real)
    return (inv(a * (one(a) - a)),)
end

end
