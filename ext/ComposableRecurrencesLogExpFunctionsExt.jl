module ComposableRecurrencesLogExpFunctionsExt

# Local rules for the link functions, so a `Derived` or `Transform` map of
# one of them takes its closed-form derivative rather than dual numbers.
using ComposableRecurrences: ComposableRecurrences, Local
using LogExpFunctions: logistic, log1pexp, logit

import ComposableRecurrences: pullback!

# `1 - y` rounds to zero in the upper tail, so it is taken as `logistic(-a)`
# there.
function pullback!(grads, ::typeof(logistic), ::Local, y, a::Real)
    return (y * (a < 0 ? one(y) - y : logistic(-a)),)
end
function pullback!(grads, ::typeof(log1pexp), ::Local, y, a::Real)
    return (logistic(a),)
end
function pullback!(grads, ::typeof(logit), ::Local, y, a::Real)
    return (inv(a * (one(a) - a)),)
end

end
