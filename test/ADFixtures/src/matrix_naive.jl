# Baseline arms for the headline matrix cases, written without the package:
# the loss each case times, as a preallocated hand loop, as a naive loop that
# copies its window every step, and as an `accumulate` over a NamedTuple
# state. The ragged convolution also times its columns padded into a
# dense kernel, as a caller without the ragged form would. `CTIDM` below
# is a verbatim copy of the step code of an existing accumulate-based model
# package, so that arm runs its exact arithmetic.
# Included by `matrix_cases.jl` inside `MatrixCases`.

# Step code copied verbatim from ComposableTuringIDModels (f7d6cc9f,
# src/steps/*.jl, src/infection_models/utils.jl), docstrings removed.
module CTIDM

    using LinearAlgebra

    abstract type AbstractAccumulationStep end

    function accumulate_scan(acc_step::AbstractAccumulationStep, initial_state, ϵ_t)
        result = accumulate(acc_step, ϵ_t; init = initial_state)
        return get_state(acc_step, initial_state, result)
    end

    function get_state(acc_step::AbstractAccumulationStep, initial_state, state)
        return vcat(collect(initial_state), last.(state))
    end

    struct RWStep <: AbstractAccumulationStep end
    (::RWStep)(state, ϵ) = state + ϵ

    struct ARStep{D <: AbstractVector{<:Real}} <: AbstractAccumulationStep
        damp_AR::D
    end
    function (ar::ARStep)(state, ϵ)
        new_val = dot(ar.damp_AR, state.window) + ϵ
        new_window = vcat(state.window[2:end], new_val)
        return (; val = new_val, window = new_window)
    end
    function get_state(::ARStep, initial_state, state)
        return vcat(collect(initial_state.window), state .|> x -> x.val)
    end

    struct LDStep{D <: AbstractVector{<:Real}} <: AbstractAccumulationStep
        rev_pmf::D
    end
    function (ld::LDStep)(state, ϵ)
        val = dot(ld.rev_pmf, state.current)
        current = vcat(state.current[2:end], ϵ)
        return (; val, current)
    end
    get_state(::LDStep, initial_state, state) = state .|> x -> x.val

    abstract type AbstractConstantRenewalStep <: AbstractAccumulationStep end

    renewal_pressure(::UniformScaling, g, window::AbstractVector) = dot(window, g)
    function renewal_pressure(::UniformScaling, g, window::AbstractMatrix)
        return vec(sum(window .* reshape(g, 1, :); dims = 2))
    end
    function renewal_pressure(
            ::UniformScaling, g::AbstractMatrix, window::AbstractMatrix
        )
        return vec(sum(window .* g; dims = 2))
    end
    function renewal_pressure(K::AbstractMatrix, g, window::AbstractMatrix)
        return vec(sum(K .* reshape(renewal_pressure(I, g, window), 1, :); dims = 2))
    end

    function renewal_foi(step::AbstractConstantRenewalStep, window, Rt)
        return Rt .* renewal_pressure(step.mixing, step.rev_gen_int, window)
    end

    struct ConstantRenewalStep{T, K} <: AbstractConstantRenewalStep
        rev_gen_int::T
        mixing::K
    end
    ConstantRenewalStep(rev_gen_int) = ConstantRenewalStep(rev_gen_int, I)

    _newest(window::AbstractVector) = last(window)
    _newest(window::AbstractMatrix) = window[:, end]
    _series(v::AbstractVector{<:Real}) = v
    _series(v::AbstractVector{<:AbstractVector}) = reduce(hcat, v)
    _advance(window::AbstractVector, new) = vcat(window[2:end], new)
    function _advance(window::AbstractMatrix, new)
        return hcat(collect(view(window, :, 2:size(window, 2))), new)
    end

    function (recurrent_step::ConstantRenewalStep)(state, Rt)
        new_incidence = renewal_foi(recurrent_step, state.window, Rt)
        new_window = _advance(state.window, new_incidence)
        return (; val = new_incidence, window = new_window)
    end
    function get_state(::ConstantRenewalStep, initial_state, state)
        return _series(state .|> x -> x.val)
    end

    abstract type AbstractRenewalModifier end
    struct SusceptibleDepletion{T} <: AbstractRenewalModifier
        pop_size::T
    end
    function apply_modifier(mod::SusceptibleDepletion, incidence, S)
        new_incidence = max.(S ./ mod.pop_size, 1.0e-6) .* incidence
        return new_incidence, S .- new_incidence
    end

    struct RenewalStep{R <: AbstractConstantRenewalStep, M <: Tuple} <:
        AbstractConstantRenewalStep
        core::R
        modifiers::M
    end
    renewal_foi(step::RenewalStep, window, Rt) = renewal_foi(step.core, window, Rt)

    _thread_modifiers(::Tuple{}, incidence, ::Tuple{}) = (incidence, ())
    function _thread_modifiers(mods::Tuple, incidence, substates::Tuple)
        inc, s = apply_modifier(first(mods), incidence, first(substates))
        rest_inc, rest_states = _thread_modifiers(
            Base.tail(mods), inc, Base.tail(substates)
        )
        return rest_inc, (s, rest_states...)
    end
    function (step::RenewalStep)(state, Rt)
        foi = renewal_foi(step.core, state.window, Rt)
        new_incidence, new_substates = _thread_modifiers(
            step.modifiers, foi, state.substates
        )
        new_window = _advance(state.window, new_incidence)
        return (; val = new_incidence, window = new_window, substates = new_substates)
    end
    function get_state(::RenewalStep, initial_state, state)
        return _series(state .|> x -> x.val)
    end

    _steps(Rt::AbstractVector) = Rt
    _steps(Rt::AbstractMatrix) = collect.(eachcol(Rt))

end

# ---- getting-started model ---------------------------------------------------

# The renewal as the getting-started page writes it by hand: one output
# buffer allocated up front, no window copies.
function loop_renewal(R, seed, gi, K, pop)
    S, T = size(R)
    L, m = length(gi), size(seed, 2)
    V = promote_type(eltype(R), Float64)
    y = zeros(V, S, m + T)
    y[:, 1:m] .= seed
    pool = V.(pop)
    p = zeros(V, S)
    for t in 1:T
        for s in 1:S
            p[s] = sum(gi[i] * y[s, m + t - i] for i in 1:L)
        end
        for a in 1:S
            h = R[a, t] * sum(K[a, b] * p[b] for b in 1:S) / pop[a]
            y[a, m + t] = pool[a] * (1 - exp(-h))
            pool[a] *= exp(-h)
        end
    end
    return y[:, (m + 1):end]
end

# A causal convolution, lag 0 first, into one preallocated output.
function loop_delay(x, d)
    S, T = size(x)
    y = zeros(eltype(x), S, T)
    for t in 1:T, s in 1:S
        acc = zero(eltype(x))
        for i in 1:min(length(d), t)
            acc += d[i] * x[s, t - i + 1]
        end
        y[s, t] = acc
    end
    return y
end

# The renewal written naively: the window is copied and every step
# allocates its vectors.
function copy_renewal(R, seed, gi, K, pop)
    window = seed .+ zero(eltype(R))
    pool = pop .+ zero(eltype(R))
    ys = Vector{typeof(pool)}()
    for Rt in eachcol(R)
        h = Rt .* (K * (window * reverse(gi))) ./ pop
        new = pool .* (1 .- exp.(-h))
        pool = pool .* exp.(-h)
        window = hcat(window[:, 2:end], new)
        push!(ys, new)
    end
    return reduce(hcat, ys)
end

function copy_delay(x, d)
    window = zeros(eltype(x), size(x, 1), length(d))
    ys = Vector{Vector{eltype(x)}}()
    for xt in eachcol(x)
        window = hcat(window[:, 2:end], xt)
        push!(ys, window * reverse(d))
    end
    return reduce(hcat, ys)
end

# The renewal as the getting-started page writes it with `accumulate`.
function accumulate_renewal(R, seed, gi, K, pop)
    init = (
        window = seed, pool = pop .+ zero(eltype(R)),
        y = zeros(eltype(R), size(R, 1)),
    )
    steps = accumulate(eachcol(R); init) do state, Rt
        h = Rt .* (K * (state.window * reverse(gi))) ./ pop
        new = state.pool .* (1 .- exp.(-h))
        (
            window = hcat(state.window[:, 2:end], new),
            pool = state.pool .* exp.(-h), y = new,
        )
    end
    return reduce(hcat, getfield.(steps, :y))
end

function accumulate_delay(x, d)
    init = (
        window = zeros(eltype(x), size(x, 1), length(d)),
        y = zeros(eltype(x), size(x, 1)),
    )
    steps = accumulate(eachcol(x); init) do state, xt
        window = hcat(state.window[:, 2:end], xt)
        (window = window, y = window * reverse(d))
    end
    return reduce(hcat, getfield.(steps, :y))
end

function _overview_baseline(renewal, delay)
    return function (z::Size)
        (; T, L, S) = z
        pop, K = towns()
        gi, d = overview_gi(L), overview_delay(L)
        seed = overview_seed(S, L)
        W = _weights(S, T)
        f = function (θ)
            R = reshape(θ, S, T)
            return sum(W .* delay(renewal(R, seed, gi, K, pop), d))
        end
        return f, vec(overview_R(S, T))
    end
end

BASELINES["overview"] = [
    "loop" => _overview_baseline(loop_renewal, loop_delay),
    "copy loop" => _overview_baseline(copy_renewal, copy_delay),
    "accumulate" => _overview_baseline(accumulate_renewal, accumulate_delay),
]

# ---- strata with dense mixing and floored depletion --------------------------

function _strata_mixing_baseline(run)
    return function (z::Size)
        (; T, L, S) = z
        W = _weights(S, T)
        pop = fill(1.0e5, S)
        _, θ = strata_mixing(identity, z)
        f = function (θ)
            g, K, logh, logR = _unpack(θ, (L,), (S, S), (S, L), (S, T))
            return sum(W .* log.(run(g, K, exp.(logh), exp.(logR), pop)))
        end
        return f, θ
    end
end

function loop_strata(g, K, h, R, pop)
    S, T = size(R)
    L, m = length(g), size(h, 2)
    V = promote_type(eltype(R), eltype(g), eltype(K), eltype(h))
    y = zeros(V, S, m + T)
    y[:, 1:m] .= h
    pool = V.(pop)
    p = zeros(V, S)
    for t in 1:T
        for s in 1:S
            p[s] = sum(g[i] * y[s, m + t - i] for i in 1:L)
        end
        for a in 1:S
            v = R[a, t] * sum(K[a, b] * p[b] for b in 1:S)
            y[a, m + t] = max(pool[a] / pop[a], 1.0e-6) * v
            pool[a] -= y[a, m + t]
        end
    end
    return y[:, (m + 1):end]
end

function accumulate_strata(g, K, h, R, pop)
    step = CTIDM.RenewalStep(
        CTIDM.ConstantRenewalStep(reverse(g), K),
        (CTIDM.SusceptibleDepletion(pop),)
    )
    init = (; val = h[:, end], window = h, substates = (pop .+ 0 .* h[:, end],))
    return CTIDM.accumulate_scan(step, init, CTIDM._steps(R))
end

BASELINES["strata_mixing"] = [
    "loop" => _strata_mixing_baseline(loop_strata),
    "accumulate" => _strata_mixing_baseline(accumulate_strata),
]

# ---- fixed delay -------------------------------------------------------------

# The case's kernel is `[0; g]`, so an output weights inputs at lags 1 to L.
function _delay_baseline(run)
    return function (z::Size)
        (; T, L) = z
        W = _weights(T)
        _, θ = delay_fixed(identity, z)
        f = function (θ)
            g, h, x = _unpack(θ, (L,), (L,), (T,))
            return sum(W .* run(g, h, x))
        end
        return f, θ
    end
end

function loop_conv(g, h, x)
    L, T = length(g), length(x)
    y = zeros(promote_type(eltype(g), eltype(h), eltype(x)), T)
    for t in 1:T
        acc = zero(eltype(y))
        for i in 1:L
            τ = t - i
            acc += g[i] * (τ >= 1 ? x[τ] : h[L + τ])
        end
        y[t] = acc
    end
    return y
end

function accumulate_conv(g, h, x)
    step = CTIDM.LDStep(reverse(g))
    init = (; val = zero(eltype(x)), current = h .+ zero(eltype(x)))
    return CTIDM.accumulate_scan(step, init, x)
end

BASELINES["delay_fixed"] = [
    "loop" => _delay_baseline(loop_conv),
    "accumulate" => _delay_baseline(accumulate_conv),
]

# ---- delay convolutions -------------------------------------------------------

function loop_conv_fixed(pmf, x, start = 1)
    T, L = length(x), length(pmf)
    y = zeros(promote_type(eltype(pmf), eltype(x)), T - start + 1)
    for t in start:T
        acc = zero(eltype(y))
        for d in 0:min(L - 1, t - 1)
            acc += pmf[d + 1] * x[t - d]
        end
        y[t - start + 1] = acc
    end
    return y
end

# Column `s` of `P` spreads the input at time `s` forward.
function loop_conv_primary(P, x)
    L, T = size(P)
    y = zeros(promote_type(eltype(P), eltype(x)), T)
    for s in 1:T, d in 0:min(L - 1, T - s)
        y[s + d] += P[d + 1, s] * x[s]
    end
    return y
end

# Column `t` of `P` weights the inputs reaching output `t`.
function loop_conv_secondary(P, x)
    L, T = size(P)
    y = zeros(promote_type(eltype(P), eltype(x)), T)
    for t in 1:T
        acc = zero(eltype(y))
        for d in 0:min(L - 1, t - 1)
            acc += P[d + 1, t] * x[t - d]
        end
        y[t] = acc
    end
    return y
end

function _conv_baseline(case, run)
    return function (z::Size)
        (; T, L) = z
        _, θ = case(identity, z)
        _, _, w = _conv_inputs(T, L)
        return run(θ, T, L, w), θ
    end
end

BASELINES["conv_fixed"] = [
    "loop" => _conv_baseline(
        conv_fixed, (θ, T, L, w) -> θ -> sum(w .* loop_conv_fixed(θ[1:L], θ[(L + 1):end]))
    ),
]
BASELINES["conv_masked"] = [
    "loop" => _conv_baseline(
        conv_masked,
        (θ, T, L, w) -> θ -> sum(
            w[(T - 13):T] .* loop_conv_fixed(θ[1:L], θ[(L + 1):end], T - 13)
        )
    ),
]
BASELINES["conv_primary"] = [
    "loop" => _conv_baseline(
        conv_primary,
        (θ, T, L, w) -> θ -> sum(
            w .* loop_conv_primary(reshape(θ[1:(L * T)], L, T), θ[(L * T + 1):end])
        )
    ),
]
# Column `s` of the ragged `ks` spreads the input at time `s` forward.
function loop_conv_primary(ks::AbstractVector{<:AbstractVector}, x)
    T = length(x)
    y = zeros(promote_type(eltype(eltype(ks)), eltype(x)), T)
    for s in 1:T, d in 0:min(length(ks[s]) - 1, T - s)
        y[s + d] += ks[s][d + 1] * x[s]
    end
    return y
end

# The ragged columns padded with zeros into the dense `L × T` kernel a
# caller builds without the ragged form; it runs through the package.
function _pad_columns(ks, L)
    P = zeros(eltype(eltype(ks)), L, length(ks))
    for (τ, k) in enumerate(ks), i in eachindex(k)
        P[i, τ] = k[i]
    end
    return P
end

function _ragged_baseline(run)
    return function (z::Size)
        ns, w, θ = _ragged_inputs(z)
        n = sum(ns)
        return θ -> run(_columns(view(θ, 1:n), ns), θ[(n + 1):end], z.L, w), θ
    end
end

BASELINES["conv_primary_ragged"] = [
    "loop" => _ragged_baseline((ks, x, L, w) -> sum(w .* loop_conv_primary(ks, x))),
    "padded" => _ragged_baseline(
        (ks, x, L, w) -> sum(
            w .* Convolution(TimeVarying(_pad_columns(ks, L), CR.Primary()))(x)
        )
    ),
]
BASELINES["conv_secondary"] = [
    "loop" => _conv_baseline(
        conv_secondary,
        (θ, T, L, w) -> θ -> sum(
            w .* loop_conv_secondary(reshape(θ[1:(L * T)], L, T), θ[(L * T + 1):end])
        )
    ),
]
