module ComposableRecurrencesReactantExt

using ComposableRecurrences: ComposableRecurrences as CR, PerStratum
using Reactant: Reactant, AnyTracedRArray, AnyTracedRMatrix, AnyTracedRVector,
    TracedRNumber

# A traced array's eltype is a traced number, not a `Real`.
CR.param_eltype(x::AbstractArray{<:TracedRNumber}) = eltype(x)

# The buffer loops index traced arrays element by element.
CR._elementwise(f, ::Type{<:TracedRNumber}) = Reactant.@allowscalar f()

# Buffers are traced arrays even when allocated like a constant history.
function CR._zeros(x, ::Type{T}, dims...) where {T <: TracedRNumber}
    return zeros(T, dims...)
end
function CR._state_vector(::Type{T}, s) where {T <: TracedRNumber}
    return copyto!(zeros(T, length(s)), s)
end

# Traced `reverse` also reverses its argument, so reverse a copy.
CR._oldest_first(g::AnyTracedRVector) = reverse(copy(g))
function CR._oldest_first(g::PerStratum{<:AnyTracedRMatrix})
    return PerStratum(reverse(copy(g.x); dims = 2))
end

# `dot` of a constant kernel with a traced window does not trace.
function CR._kdot(g::AbstractVector, H::AnyTracedRArray, t, τ, L, a)
    return sum(g .* view(H, t:(t + L - 1), a))
end

end # module ComposableRecurrencesReactantExt
