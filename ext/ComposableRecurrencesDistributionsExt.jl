# Delay distributions as kernels: the masses of a discrete distribution on
# whole lags, and the operator and wrapper constructors that take
# distributions with an explicit number of lags. A `Convolution` kernel
# starts at lag 0 and a `Recurrence` kernel at lag 1, so the constructors
# that only build `Recurrence` kernels (`Pairwise`, `Routes`) drop lag 0, and
# `PerStratum` and `TimeVarying` drop it when `lag0 = false`.
module ComposableRecurrencesDistributionsExt

using ComposableRecurrences: ComposableRecurrences, Convolution, Pairwise,
    PerStratum, Primary, Recurrence, Routes, Secondary, TimeVarying,
    delay_masses
using Distributions: ContinuousUnivariateDistribution,
    DiscreteUnivariateDistribution, UnivariateDistribution, pdf

function ComposableRecurrences.delay_masses(
        d::DiscreteUnivariateDistribution, lags
    )
    return map(l -> pdf(d, l), 0:(lags - 1))
end
function ComposableRecurrences.delay_masses(
        d::ContinuousUnivariateDistribution, lags
    )
    throw(
        ArgumentError(
            "a continuous delay has no masses on whole lags until it is " *
                "discretised; discretise $(nameof(typeof(d))) first, for " *
                "example by interval censoring, into a type with a " *
                "`delay_masses` method"
        )
    )
end

# The masses of `d` from lag 0, or from lag 1 without `lag0`, as a copy
# either way so that the type does not depend on `lag0`.
function _masses(d, lags, lag0::Bool)
    m = delay_masses(d, lags)
    return m[(firstindex(m) + !lag0):end]
end

function ComposableRecurrences.Convolution(d::UnivariateDistribution; lags, kwargs...)
    return Convolution(_masses(d, lags, true); kwargs...)
end
function ComposableRecurrences.Recurrence(d::UnivariateDistribution; lags, kwargs...)
    return Recurrence(_masses(d, lags, false); kwargs...)
end

# Strata on the first axis and lags on the second.
function ComposableRecurrences.PerStratum(
        ds::AbstractVector{<:UnivariateDistribution}; lags, lag0::Bool = true
    )
    return PerStratum(permutedims(stack(d -> _masses(d, lags, lag0), ds)))
end

# One column of masses per time.
function ComposableRecurrences.TimeVarying(
        ds::AbstractVector{<:UnivariateDistribution},
        indexing::Union{Primary, Secondary} = Secondary();
        lags, lag0::Bool = true
    )
    return TimeVarying(stack(d -> _masses(d, lags, lag0), ds), indexing)
end

# `D[i, j]` is stratum `j`'s delay in stratum `i`.
function ComposableRecurrences.Pairwise(D::AbstractMatrix{<:UnivariateDistribution}; lags)
    return Pairwise(permutedims(stack(d -> _masses(d, lags, false), D), (2, 3, 1)))
end

function ComposableRecurrences.Routes(
        route::Tuple{Any, UnivariateDistribution},
        routes::Tuple{Any, UnivariateDistribution}...; lags
    )
    return Routes(
        map(r -> (first(r), _masses(last(r), lags, false)), (route, routes...))...
    )
end

end # module ComposableRecurrencesDistributionsExt
