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

    # Floored susceptible depletion as a pointwise modifier whose state
    # starts at the population size.
    struct FlooredDepletion{P}
        pop::P
    end
    function ComposableRecurrences.forward!(m::FlooredDepletion, ::ComposableRecurrences.Init, s, history)
        s .= m.pop
        return nothing
    end
    ComposableRecurrences.ispointwise(::FlooredDepletion) = true
    function ComposableRecurrences.forward!(m::FlooredDepletion, ::ComposableRecurrences.Step, v, s, t)
        for k in eachindex(v, s)
            v′ = max(s[k] / m.pop[k], 1.0e-6) * v[k]
            v[k], s[k] = v′, s[k] - v′
        end
        return nothing
    end

    # Vector-level: scale every value, and keep a running total in the state.
    struct Scale{A}
        a::A
    end
    function ComposableRecurrences.forward!(m::Scale, ::ComposableRecurrences.Step, v, s, t)
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
    function ComposableRecurrences.forward!(m::LooseScale, ::ComposableRecurrences.Step, v, s, t)
        for k in eachindex(v, s)
            v[k], s[k] = m.a * v[k] + m.params.b, s[k]
        end
        return nothing
    end

    # Adds each stratum's history total, set once by its Init.
    struct HistoryTotal end
    function ComposableRecurrences.forward!(::HistoryTotal, ::ComposableRecurrences.Init, s, history)
        s .= vec(sum(history; dims = ndims(history)))
        return nothing
    end
    ComposableRecurrences.ispointwise(::HistoryTotal) = true
    function ComposableRecurrences.forward!(::HistoryTotal, ::ComposableRecurrences.Step, v, s, t)
        for k in eachindex(v, s)
            v[k], s[k] = v[k] + s[k], s[k]
        end
        return nothing
    end

    # Pointwise and time-varying: add `b[t]`.
    struct Shift{B}
        b::B
    end
    ComposableRecurrences.ispointwise(::Shift) = true
    function ComposableRecurrences.forward!(m::Shift, ::ComposableRecurrences.Step, v, s, t)
        for k in eachindex(v, s)
            v[k], s[k] = v[k] + m.b[t], s[k]
        end
        return nothing
    end
end

# Pullback checks for modifiers against a local ForwardDiff Jacobian, shared
# by the modifier test files.
@testmodule ModifierChecks begin
    using ComposableRecurrences, ForwardDiff, LinearAlgebra
    const CR = ComposableRecurrences

    # A zero cotangent mirror, as the adjoint wiring builds it: an array per
    # float array, a `Ref` per float scalar, a tuple of mirrors per tuple
    # field, a NamedTuple per struct and `nothing` for anything without a
    # cotangent.
    mirror(x::AbstractFloat) = Ref(zero(x))
    mirror(x::AbstractArray{<:AbstractFloat}) = zero(x)
    mirror(::AbstractArray) = nothing
    mirror(::Union{Integer, Symbol, Nothing}) = nothing
    mirror(x::Tuple) = map(mirror, x)
    function mirror(x)
        names = fieldnames(typeof(x))
        return NamedTuple{names}(map(n -> mirror(getfield(x, n)), names))
    end

    # The mirror's float leaves in field order, flattened.
    flat(::Nothing) = Float64[]
    flat(x::Base.RefValue) = [x[]]
    flat(x::AbstractArray) = vec(copy(x))
    flat(x::Union{Tuple, NamedTuple}) = reduce(vcat, map(flat, values(x)); init = Float64[])

    # Compare the Step's `pullback!` with the transposed Jacobian of its
    # `forward!` in `[v; s; θ]`, for a modifier `build(θ)` whose mirror
    # flattens in the order of `θ`; `mirror_of` and `flatten` replace
    # `mirror` and `flat` for a modifier whose mirror needs another order.
    # The state may be longer than `v`. Returns the parameter cotangent for
    # further checks.
    function check_pullback(
            build, θ, v, s, t; v̄ = nothing, s̄ = nothing, mirror_of = mirror,
            flatten = flat
        )
        S, n = length(v), length(s)
        v̄′ = v̄ === nothing ? collect(range(0.3, 1.7; length = S)) : v̄
        s̄′ = s̄ === nothing ? collect(range(-0.4, 0.9; length = n)) : s̄
        step = function (x)
            vv, ss = x[1:S], x[(S + 1):(S + n)]
            CR.forward!(build(x[(S + n + 1):end]), CR.Step(), vv, ss, t)
            return vcat(vv, ss)
        end
        # The tag and chunk `ReferenceAD` uses, so the dual code is shared.
        x0 = vcat(v, s, θ)
        tag = ForwardDiff.Tag(CR._run_forward, eltype(x0))
        cfg = ForwardDiff.JacobianConfig(step, x0, ForwardDiff.Chunk{min(8, length(x0))}(), tag)
        J = ForwardDiff.jacobian(step, x0, cfg, Val(false))
        expected = transpose(J) * vcat(v̄′, s̄′)
        m = build(θ)
        m̄ = mirror_of(m)
        gv, gs = copy(v̄′), copy(s̄′)
        CR._vector_pullback!((; piece = m̄, v = gv, s = gs), m, copy(v), copy(s), t)
        return (;
            v = gv ≈ expected[1:S],
            s = gs ≈ expected[(S + 1):(S + n)],
            θ = flatten(m̄) ≈ expected[(S + n + 1):end],
            θ̄ = flatten(m̄),
        )
    end
end

# Reference derivatives through ForwardDiff with one tag and a fixed chunk,
# so the dual code compiled for one test is reused by every other test in
# the same worker, whatever its function or number of inputs. ForwardDiff's
# default tags the duals by the function's type and picks the chunk from
# the input's length, which compiles each operator again for every closure
# and length. Not for nested derivatives, which need distinct tags.
@testmodule ReferenceAD begin
    using ComposableRecurrences, ForwardDiff

    _tag(::Type{V}) where {V} = ForwardDiff.Tag(ComposableRecurrences._run_forward, V)
    _chunk(x) = ForwardDiff.Chunk{min(8, length(x))}()

    function gradient(f, x)
        cfg = ForwardDiff.GradientConfig(f, x, _chunk(x), _tag(eltype(x)))
        return ForwardDiff.gradient(f, x, cfg, Val(false))
    end
    function jacobian(f, x)
        cfg = ForwardDiff.JacobianConfig(f, x, _chunk(x), _tag(eltype(x)))
        return ForwardDiff.jacobian(f, x, cfg, Val(false))
    end
    function derivative(f, x::Real)
        T = typeof(_tag(typeof(x)))
        return ForwardDiff.extract_derivative(T, f(ForwardDiff.Dual{T}(x, one(x))))
    end
end
