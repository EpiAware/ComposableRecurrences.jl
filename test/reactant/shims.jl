# Candidate changes for a Reactant extension, loaded by `probe.jl` only in
# the `shims` configuration. The probe also wraps the operator call in
# `Reactant.@allowscalar`, which a caller can do without a package change.

# A traced array's eltype is `TracedRNumber{T}`, which is not a `Real`, so
# `param_eltype` took the generic array method. Its
# `mapreduce(param_eltype, promote_type, x; init = Bool)` is overlaid by
# Reactant as a traced reduction over types and fails. Returning the eltype
# covers traced arrays and wrappers of them (reshapes, views), and buffers
# then allocate as traced arrays.
function ComposableRecurrences.param_eltype(
        x::AbstractArray{<:Reactant.TracedRNumber}
    )
    return eltype(x)
end

# `dot` of a constant kernel (a plain `Vector`) with a view of the traced
# buffer calls `conj` on the plain vector with a traced-op keyword and
# fails; this hits every fixed-kernel path that is not a plain `I`
# coupling. An elementwise product and sum traces.
function ComposableRecurrences._kdot(
        g::AbstractVector, H::Reactant.AnyTracedRArray, t, τ, L, k
    )
    return sum(g .* view(H, t:(t + L - 1), k))
end

# Reactant's traced `reverse(g)` reverses `g` in place as well as returning
# it, so the kernel a caller passed is left reversed. A second call with the
# same kernel (resume from state) then reads it the wrong way round. A copy
# first keeps the caller's kernel intact.
function ComposableRecurrences._oldest_first(g::Reactant.AnyTracedRVector)
    return reverse(copy(g))
end
function ComposableRecurrences._oldest_first(
        g::PerStratum{<:Reactant.AnyTracedRMatrix}
    )
    return PerStratum(reverse(copy(g.x); dims = 2))
end
