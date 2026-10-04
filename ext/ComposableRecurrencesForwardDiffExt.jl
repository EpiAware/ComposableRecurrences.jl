module ComposableRecurrencesForwardDiffExt

# The local forward-mode derivative of a `Transform`'s map: one dual per
# scalar of `(v, θ)`, evaluated once.

using ComposableRecurrences: ComposableRecurrences
using ForwardDiff: ForwardDiff

const CR = ComposableRecurrences

struct TransformTag end

function CR._forward_derivative(f, v::Real, ::Nothing)
    return first(_partials(f(first(_seeds((v,)))), Val(1))), nothing
end
function CR._forward_derivative(f, v::Real, θ::Real)
    x, a = _seeds(promote(v, θ))
    ∂ = _partials(f(x, a), Val(2))
    return ∂[1], ∂[2]
end
function CR._forward_derivative(f, v::Real, θ::Union{Tuple, NamedTuple})
    xs = _seeds(promote(v, values(θ)...))
    y = f(first(xs), _restructure(θ, Base.tail(xs)))
    ∂ = _partials(y, Val(length(xs)))
    return first(∂), _restructure(θ, Base.tail(∂))
end

_restructure(::Tuple, x) = x
_restructure(::NamedTuple{K}, x) where {K} = NamedTuple{K}(x)

# A `ForwardDiff.Tag` orders this dual against any outer one, so the
# derivative also runs on dual inputs.
function _seeds(xs::Tuple{T, Vararg{T, M}}) where {T, M}
    N = Val(M + 1)
    tag = typeof(ForwardDiff.Tag(TransformTag(), T))
    return ntuple(N) do i
        ForwardDiff.Dual{tag}(xs[i], ntuple(j -> T(i == j), N))
    end
end

# The partials of `f`'s output; an output without this tag is constant in
# `(v, θ)`.
function _partials(
        y::ForwardDiff.Dual{<:ForwardDiff.Tag{TransformTag}}, ::Val{N}
    ) where {N}
    return ntuple(i -> ForwardDiff.partials(y, i), Val(N))
end
_partials(y::Real, ::Val{N}) where {N} = ntuple(_ -> zero(y), Val(N))

end
