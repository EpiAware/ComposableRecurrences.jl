# Shared test setup: naive reference loops written from the operator
# definitions, and small modifiers that exercise the modifier interface.

@testsnippet Reference begin
    # Recurrence from its definition, one scalar at a time:
    #   v_t[a] = gain(a, t) Σ_b Σ_i w(t, a, b, i) y_{t-i}[b] + add(a, t)
    #   y_t = post!(v_t, t)
    # `w(t, a, b, i)` is the weight of stratum `b`'s value at lag `i` in
    # stratum `a`. `hist` is S × L, oldest first. Returns S × T.
    function naive_recurrence(
            w, hist::AbstractMatrix, T; gain = (a, t) -> 1,
            add = (a, t) -> 0, post! = (v, t) -> v
        )
        S, L = size(hist)
        Y = zeros(float(eltype(hist)), S, L + T)
        Y[:, 1:L] .= hist
        for t in 1:T
            v = [
                gain(a, t) * sum(
                    w(t, a, b, i) * Y[b, L + t - i] for b in 1:S, i in 1:L
                ) + add(a, t) for a in 1:S
            ]
            post!(v, t)
            Y[:, L + t] .= v
        end
        return Y[:, (L + 1):end]
    end

    # Causal convolution from its definition:
    #   y_t[k] = Σ_{d = 0}^{D - 1} c(t, k, d) x_{t-d}[k]
    # with `x_τ` for `τ ≤ 0` read from `hist` (S × m, oldest first) and zero
    # before it.
    function naive_convolution(c, x::AbstractMatrix, D; hist = nothing)
        S, T = size(x)
        m = hist === nothing ? 0 : size(hist, 2)
        at(k, τ) = τ >= 1 ? x[k, τ] : (τ >= 1 - m ? hist[k, τ + m] : 0.0)
        return [
            sum(c(t, k, d) * at(k, t - d) for d in 0:(D - 1)) for k in 1:S,
                t in 1:T
        ]
    end
end

@testsnippet TestModifiers begin
    using ComposableRecurrences: ComposableRecurrences

    # CTIDM's floored susceptible depletion (`SusceptibleDepletion`), as a
    # pointwise modifier whose state starts at the population size.
    struct FlooredDepletion{P}
        pop::P
    end
    ComposableRecurrences.init_state(m::FlooredDepletion, history) = collect(m.pop)
    ComposableRecurrences.ispointwise(::FlooredDepletion) = true
    function ComposableRecurrences.apply(m::FlooredDepletion, v, s, t, k)
        v′ = max(s / m.pop[k], 1.0e-6) * v
        return v′, s - v′
    end

    # Vector-level: scale every value, and keep a running total in the state.
    struct Scale{A}
        a::A
    end
    function ComposableRecurrences.apply!(m::Scale, v, s, t)
        v .*= m.a
        s .+= v
        return nothing
    end

    # Parameters in an untyped field and a NamedTuple field: `a v + b`.
    struct LooseScale
        a
        params::NamedTuple
    end
    ComposableRecurrences.ispointwise(::LooseScale) = true
    function ComposableRecurrences.apply(m::LooseScale, v, s, t, k)
        return m.a * v + m.params.b, s
    end

    # Adds each stratum's history total, set once by `init_state`.
    struct HistoryTotal end
    function ComposableRecurrences.init_state(::HistoryTotal, history)
        return vec(sum(history; dims = ndims(history)))
    end
    ComposableRecurrences.ispointwise(::HistoryTotal) = true
    ComposableRecurrences.apply(::HistoryTotal, v, s, t, k) = (v + s, s)

    # Pointwise and time-varying: add `b[t]`.
    struct Shift{B}
        b::B
    end
    ComposableRecurrences.ispointwise(::Shift) = true
    ComposableRecurrences.apply(m::Shift, v, s, t, k) = (v + m.b[t], s)
end
