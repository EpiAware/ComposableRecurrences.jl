module ComposableRecurrencesReactantExt

using ComposableRecurrences: ComposableRecurrences as CR, PerStratum,
    TimeVarying
using Reactant: Reactant, @trace, AnyTracedRArray, AnyTracedRMatrix,
    AnyTracedRVector, TracedRNumber

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

# The step loop is traced as one loop instead of unrolled step by step.
# Numbers from outside a traced loop are traced inside it, so the lag count
# `L` is traced there and the kernel dots below read it from the kernel.
function CR._run(
        ::Type{Tp}, r, gain, add, h, s0, τ0, L, S, T
    ) where {Tp <: TracedRNumber}
    (; coupling, modifiers) = r
    kernel = CR._oldest_first(r.kernel)
    H = CR._load_history!(CR._zeros(h, Tp, L + T, S), h, L)
    p = CR._zeros(h, Tp, S)
    q = CR._zeros(h, Tp, S)
    v = CR._zeros(h, Tp, S)
    states = if s0 === nothing
        map(m -> CR._init_state(Tp, m, h, S), modifiers)
    else
        map(s -> CR._state_vector(Tp, s), s0)
    end
    @trace for t in 1:T
        τ = τ0 + t - 1
        CR._prepare!(p, q, coupling, kernel, H, t, τ, L)
        if CR._all_pointwise(modifiers)
            for k in eachindex(v)
                x = CR._at(gain, k, τ) *
                    CR._pressure_at(coupling, kernel, q, H, t, τ, L, k) +
                    CR._at(add, k, τ)
                H[L + t, k] = CR._thread(modifiers, states, x, τ, k)
            end
        else
            for k in eachindex(v)
                v[k] = CR._at(gain, k, τ) *
                    CR._pressure_at(coupling, kernel, q, H, t, τ, L, k) +
                    CR._at(add, k, τ)
            end
            CR._stages!(modifiers, states, v, τ)
            for k in eachindex(v)
                H[L + t, k] = v[k]
            end
        end
    end
    return CR._public(H, (L + 1):(L + T), h), H, states
end

# Kernel dots at a traced step `t`: the window is a dynamic slice.
function _window(H, t, n, a)
    return vec(Reactant.Ops.dynamic_slice(H, [t, a], [n, 1]))
end
function CR._kdot(
        g::AbstractVector, H::AnyTracedRArray, t::TracedRNumber, τ, L, a
    )
    return sum(g .* _window(H, t, length(g), a))
end
function CR._kdot(
        g::PerStratum, H::AnyTracedRArray, t::TracedRNumber, τ, L, a
    )
    return sum(g.x[a, :] .* _window(H, t, size(g.x, 2), a))
end
function CR._kdot(
        g::TimeVarying, H::AnyTracedRArray, t::TracedRNumber, τ, L, a
    )
    n = CR._nlags(g)
    acc = zero(eltype(H))
    for i in 1:n
        acc += CR._weight(g, a, a, i, τ) * H[t + n - i, a]
    end
    return acc
end
function CR._kdot(
        g::CR._PairwiseKernel, H::AnyTracedRArray, t::TracedRNumber, τ, L, a
    )
    n = CR._nlags(g)
    acc = zero(eltype(H))
    for i in 1:n, b in axes(H, 2)
        acc += CR._weight(g, a, b, i, τ) * H[t + n - i, b]
    end
    return acc
end

end # module ComposableRecurrencesReactantExt
