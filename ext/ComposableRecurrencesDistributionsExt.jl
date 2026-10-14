# Delay distributions as kernels. A wrapper holds distributions as they are,
# and the operator turns them into masses: `Recurrence(kernel; lags)` and
# `Convolution(kernel; lags)` walk the kernel once and replace each
# distribution with its masses on lags `0:(lags - 1)`, from lag 1 for a
# `Recurrence` and from lag 0 for a `Convolution`, so the lag origin is the
# operator's.
module ComposableRecurrencesDistributionsExt

using ComposableRecurrences: ComposableRecurrences, Convolution, Pairwise,
    PerStratum, Recurrence, Routes, TimeVarying, delay_masses
using Distributions: ContinuousUnivariateDistribution,
    DiscreteUnivariateDistribution, UnivariateDistribution, pdf

const _D = UnivariateDistribution

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

# The kernels that hold distributions, which need `lags` to become masses.
const _Delay = Union{
    _D, AbstractArray{<:_D}, PerStratum{<:AbstractVector{<:_D}},
    Pairwise{<:AbstractMatrix{<:_D}}, TimeVarying{<:Any, <:AbstractVector{<:_D}},
    TimeVarying{<:Any, <:PerStratum{<:AbstractMatrix{<:_D}}},
    TimeVarying{<:Any, <:Pairwise{<:AbstractArray{<:_D, 3}}},
}

# A route kernel may hold distributions until the operator is built.
ComposableRecurrences._check_route_kernel(::_Delay) = nothing

function _check_lags(lags, origin)
    lags isa Integer && lags > origin || throw(
        ArgumentError(
            "lags counts the lags from 0 and must be an integer above " *
                "$(origin), as a $(origin == 0 ? "Convolution" : "Recurrence") " *
                "kernel starts at lag $(origin); got $(repr(lags))"
        )
    )
    return nothing
end

# The masses of `d` from lag `origin`.
function _masses(d, lags, origin)
    m = delay_masses(d, lags)
    length(m) == lags || throw(
        ArgumentError(
            "delay_masses($(nameof(typeof(d))), $(lags)) returned " *
                "$(length(m)) masses, not $(lags)"
        )
    )
    return m[(firstindex(m) + origin):end]
end

# The kernel with each distribution replaced by its masses from lag
# `origin`, the lag axis where the wrapper reads it.
_kernel(x, lags, origin) = x
_kernel(d::_D, lags, origin) = _masses(d, lags, origin)
function _kernel(::AbstractArray{<:_D}, lags, origin)
    throw(
        ArgumentError(
            "an array of delays needs a wrapper to say what its axes are: " *
                "PerStratum, Pairwise or TimeVarying"
        )
    )
end
_stack(A, lags, origin) = stack(d -> _masses(d, lags, origin), A)
function _kernel(x::PerStratum{<:AbstractVector{<:_D}}, lags, origin)
    return PerStratum(permutedims(_stack(x.x, lags, origin)))
end
function _kernel(x::Pairwise{<:AbstractMatrix{<:_D}}, lags, origin)
    return Pairwise(permutedims(_stack(x.x, lags, origin), (2, 3, 1)))
end
function _kernel(x::TimeVarying{I, <:AbstractVector{<:_D}}, lags, origin) where {I}
    return TimeVarying{I}(_stack(x.x, lags, origin))
end
function _kernel(
        x::TimeVarying{I, <:PerStratum{<:AbstractMatrix{<:_D}}}, lags, origin
    ) where {I}
    G = permutedims(_stack(x.x.x, lags, origin), (2, 1, 3))
    return TimeVarying{I}(PerStratum(G))
end
function _kernel(
        x::TimeVarying{I, <:Pairwise{<:AbstractArray{<:_D, 3}}}, lags, origin
    ) where {I}
    A = permutedims(_stack(x.x.x, lags, origin), (2, 3, 1, 4))
    return TimeVarying{I}(Pairwise(A))
end
function _kernel(R::Routes, lags, origin)
    kernels = map(g -> _kernel(g, lags, origin), R.kernels)
    return Routes(map(tuple, R.couplings, kernels)...)
end

function ComposableRecurrences.Convolution(k::_Delay; lags, kwargs...)
    _check_lags(lags, 0)
    return Convolution(_kernel(k, lags, 0); kwargs...)
end
function ComposableRecurrences.Recurrence(k::_Delay; lags, kwargs...)
    _check_lags(lags, 1)
    return Recurrence(_kernel(k, lags, 1); kwargs...)
end

# Routes may mix array and delay kernels, so every `Routes` takes this
# method; without `lags` it is the method for arrays.
_has_delay(R::Routes) = any(g -> g isa _Delay, R.kernels)
function ComposableRecurrences.Recurrence(R::Routes; lags = nothing, kwargs...)
    if lags === nothing
        _has_delay(R) && throw(
            ArgumentError(
                "routes holding delay distributions need `lags`: " *
                    "Recurrence(routes; lags)"
            )
        )
        return invoke(Recurrence, Tuple{Any}, R; kwargs...)
    end
    _check_lags(lags, 1)
    return invoke(Recurrence, Tuple{Any}, _kernel(R, lags, 1); kwargs...)
end

end # module ComposableRecurrencesDistributionsExt
