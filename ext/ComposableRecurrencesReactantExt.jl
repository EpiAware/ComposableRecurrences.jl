module ComposableRecurrencesReactantExt

using ComposableRecurrences: ComposableRecurrences, PerStratum, Serial
using Reactant: @allowscalar, AnyTracedRArray, AnyTracedRMatrix, AnyTracedRVector,
    TracedRNumber

# A traced array's eltype is a traced number, which is not a `Real`, so the
# generic array method would reduce over its entries' types; the eltype
# is the answer, also for reshapes and views of traced arrays.
function ComposableRecurrences.param_eltype(x::AbstractArray{<:TracedRNumber})
    return eltype(x)
end

# Traced `reverse` also reverses its argument in place, so a second call
# with the same kernel (as when resuming from a returned state) would read
# it backwards; reversing a copy leaves the caller's kernel intact.
function ComposableRecurrences._oldest_first(g::AnyTracedRVector)
    return reverse(copy(g))
end
function ComposableRecurrences._oldest_first(g::PerStratum{<:AnyTracedRMatrix})
    return PerStratum(reverse(copy(g.x); dims = 2))
end

# One broadcast product and sum of the kernel with the window traces to
# two operations rather than `L` scalar reads.
function ComposableRecurrences._kdot(g::AbstractVector, H::AnyTracedRArray, t, τ, L, a)
    return sum(g .* view(H, t:(t + L - 1), a))
end

# The step loops read and write one entry at a time, so a traced run allows
# scalar indexing. It runs serially: the executors split work across
# threads or devices, which the traced program does itself.
function ComposableRecurrences._run(
        ::Type{Tp}, r, gain, add, h, s0, τ0, L, S, T, record::Val
    ) where {Tp <: TracedRNumber}
    return @allowscalar ComposableRecurrences._run(
        Tp, Serial(), r, gain, add, h, s0, τ0, L, S, T, record
    )
end

function ComposableRecurrences._conv_buffers(
        ::Type{Tp}, kernel, x, history, m, S, start, stop
    ) where {Tp <: TracedRNumber}
    return @allowscalar invoke(
        ComposableRecurrences._conv_buffers,
        Tuple{Type, Any, Any, Any, Any, Any, Any, Any},
        Tp, kernel, x, history, m, S, start, stop
    )
end

end
