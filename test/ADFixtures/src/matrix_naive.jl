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

# ---- unit lag-1 processes ------------------------------------------------------

# The case's loss with the walk built by `run(z0, ϵ)`.
function _random_walk_baseline(run)
    return function (z::Size)
        (; T) = z
        W = [_noise(t, 9) for t in 1:(T + 1)]
        _, θ = random_walk(identity, z)
        return θ -> sum(W .* run(θ[1], θ[2:end])), θ
    end
end

function loop_random_walk(z0, ϵ)
    y = similar(ϵ, promote_type(typeof(z0), eltype(ϵ)), length(ϵ) + 1)
    y[1] = z0
    for t in eachindex(ϵ)
        y[t + 1] = y[t] + ϵ[t]
    end
    return y
end

BASELINES["random_walk"] = [
    "loop" => _random_walk_baseline(loop_random_walk),
    "accumulate" => _random_walk_baseline(
        (z0, ϵ) -> vcat(z0, accumulate(+, ϵ; init = z0))
    ),
]

function _ar1_baseline(run)
    return function (z::Size)
        (; T) = z
        W = _weights(T)
        _, θ = ar1(identity, z)
        return θ -> sum(W .* run(θ[1], θ[2], θ[3:end])), θ
    end
end

function loop_ar1(φ, z0, ϵ)
    y = similar(ϵ, promote_type(typeof(φ), typeof(z0), eltype(ϵ)))
    z = z0
    for t in eachindex(ϵ)
        z = φ * z + ϵ[t]
        y[t] = z
    end
    return y
end

BASELINES["ar1"] = [
    "loop" => _ar1_baseline(loop_ar1),
    "accumulate" => _ar1_baseline(
        (φ, z0, ϵ) -> accumulate((z, e) -> φ * z + e, ϵ; init = z0)
    ),
]

# ---- the tutorials' models -----------------------------------------------------

# Hand loops for the tutorials' models, as a user would write each one
# without the package: one preallocated buffer holding the seed and the
# run, scalar loops, and the pools as scalars or one vector per pool.

# `θ` and the loss of case `c` at size `z`, with the operators replaced by
# `run(z)`, a function of `θ` returning the loss.
function _tutorial_baseline(case, run)
    return function (z::Size)
        _, θ = case(identity, z)
        return run(z), θ
    end
end

# The renewal sum of stratum `k` at step `t` of a buffer whose first `m`
# columns are the seed.
function _renewal_sum(g, y, k, m, t)
    acc = zero(eltype(y))
    for l in eachindex(g)
        acc += g[l] * y[k, m + t - l]
    end
    return acc
end

# A buffer of `S` rows holding the seed `h` then `T` steps.
function _seeded(V, h, T)
    y = zeros(V, size(h, 1), size(h, 2) + T)
    y[:, 1:size(h, 2)] .= h
    return y
end

# Seeded renewal with hazard depletion from a pool less the seed.
function loop_renewal_depletion(g, seed, R, N)
    m, T = length(seed), length(R)
    V = promote_type(eltype(g), eltype(seed), eltype(R))
    y = _seeded(V, reshape(seed, 1, m), T)
    pool = max(N - sum(seed), zero(V))
    for t in 1:T
        drawn = -pool * expm1(-R[t] * _renewal_sum(g, y, 1, m, t) / N)
        pool -= drawn
        y[1, m + t] = drawn
    end
    return view(y, 1, (m + 1):(m + T))
end

BASELINES["renewal_depletion"] = [
    "loop" => _tutorial_baseline(
        renewal_depletion, function (z)
            (; T, L) = z
            W = _weights(T)
            return function (θ)
                g, logh, logR = _unpack(θ, (L,), (L,), (T,))
                y = loop_renewal_depletion(g, exp.(logh), exp.(logR), 1.0e5)
                return sum(W .* log.(y))
            end
        end
    ),
]

# Leaky vaccination with waning: infections drawn by hazard from `S + σV`,
# then waning moves `V` back to `S` at rate `ω`, then the doses move `S`
# into `V`, capped by what `S` holds.
function loop_waning(g, h, R, doses, σ, ω, N)
    S, T = size(R)
    m = size(h, 2)
    V = promote_type(
        eltype(g), eltype(h), eltype(R), eltype(doses), typeof(σ), eltype(ω)
    )
    y = _seeded(V, h, T)
    sus = V.(N)
    pro = zeros(V, S)
    for t in 1:T, k in 1:S
        P = sus[k] + σ * pro[k]
        drawn = -P * expm1(-R[k, t] * _renewal_sum(g, y, k, m, t) / N[k])
        s = sus[k] - drawn * sus[k] / P
        v = pro[k] - drawn * σ * pro[k] / P
        waned = -v * expm1(-ω[k, t])
        s += waned
        v -= waned
        moved = min(doses[k, t], max(s, zero(V)))
        sus[k] = s - moved
        pro[k] = v + moved
        y[k, m + t] = drawn
    end
    return view(y, :, (m + 1):(m + T))
end

BASELINES["strata_waning"] = [
    "loop" => _tutorial_baseline(
        strata_waning, function (z)
            (; T, L, S) = z
            W = _weights(S, T)
            N = fill(1.0e5, S)
            return function (θ)
                g, logh, logR, doses, σ, ω = _unpack(
                    θ, (L,), (S, L), (S, T), (S, T), (1,), (S, T)
                )
                y = loop_waning(g, exp.(logh), exp.(logR), doses, only(σ), ω, N)
                return sum(W .* log.(y))
            end
        end
    ),
]

# Hazard depletion with imports before the draw, taken from the pool, and
# after it, added on top.
function loop_imports(g, seed, R, before, after, N)
    m, T = length(seed), length(R)
    V = promote_type(
        eltype(g), eltype(seed), eltype(R), eltype(before), eltype(after)
    )
    y = _seeded(V, reshape(seed, 1, m), T)
    pool = V(N)
    for t in 1:T
        drawn = -pool * expm1(-(R[t] * _renewal_sum(g, y, 1, m, t) + before[t]) / N)
        pool -= drawn
        y[1, m + t] = drawn + after[t]
    end
    return view(y, 1, (m + 1):(m + T))
end

BASELINES["renewal_imports"] = [
    "loop" => _tutorial_baseline(
        renewal_imports, function (z)
            (; T, L) = z
            W = _weights(T)
            return function (θ)
                g, logh, logR, before, after = _unpack(
                    θ, (L,), (L,), (T,), (T,), (T,)
                )
                y = loop_imports(g, exp.(logh), exp.(logR), before, after, 1.0e5)
                return sum(W .* log.(y))
            end
        end
    ),
]

# A delay, lag 0 first, scaled by `gain`, written into `y`.
function _delay!(y, d, x, gain)
    for t in eachindex(y)
        acc = zero(eltype(y))
        for i in 1:min(length(d), t)
            acc += d[i] * x[t - i + 1]
        end
        y[t] = gain * acc
    end
    return y
end

function loop_outcomes(d1, d2, d3, p, x)
    V = promote_type(eltype(d1), eltype(d2), eltype(d3), eltype(p), eltype(x))
    onsets = _delay!(zeros(V, length(x)), d1, x, one(V))
    admissions = _delay!(zeros(V, length(x)), d2, onsets, p[1])
    deaths = _delay!(zeros(V, length(x)), d3, admissions, p[2])
    return admissions, deaths
end

BASELINES["outcome_chain"] = [
    "loop" => _tutorial_baseline(
        outcome_chain, function (z)
            (; T, L) = z
            W = _weights(T)
            V = [_noise(t, 15) for t in 1:T]
            return function (θ)
                d1, d2, d3, p, x = _unpack(θ, (L,), (L,), (L,), (2,), (T,))
                admissions, deaths = loop_outcomes(d1, d2, d3, p, x)
                return sum(W .* admissions) + sum(V .* deaths)
            end
        end
    ),
]

# A renewal over every day in one pass: the loop needs no state to
# continue from.
function loop_renewal_forecast(g, seed, R)
    m, T = length(seed), length(R)
    V = promote_type(eltype(g), eltype(seed), eltype(R))
    y = _seeded(V, reshape(seed, 1, m), T)
    for t in 1:T
        y[1, m + t] = R[t] * _renewal_sum(g, y, 1, m, t)
    end
    return view(y, 1, (m + 1):(m + T))
end

BASELINES["renewal_forecast"] = [
    "loop" => _tutorial_baseline(
        renewal_forecast, function (z)
            (; T, L) = z
            W = _weights(T)
            return function (θ)
                g, logh, logR = _unpack(θ, (L,), (L,), (T,))
                y = loop_renewal_forecast(g, exp.(logh), exp.(logR))
                return sum(W .* log.(y))
            end
        end
    ),
]

# The towns' depleted run, keeping each day's infections over the renewal
# sum as it goes.
function loop_reproduction(g, R, seed, K, pop)
    S, T = size(R)
    m = size(seed, 2)
    V = promote_type(eltype(g), eltype(R))
    y = _seeded(V, seed, T)
    Reff = zeros(V, S, T)
    pool = V.(pop)
    p = zeros(V, S)
    for t in 1:T
        for k in 1:S
            p[k] = _renewal_sum(g, y, k, m, t)
        end
        for a in 1:S
            q = zero(V)
            for b in 1:S
                q += K[a, b] * p[b]
            end
            drawn = -pool[a] * expm1(-R[a, t] * q / pop[a])
            pool[a] -= drawn
            y[a, m + t] = drawn
            Reff[a, t] = drawn / q
        end
    end
    return Reff
end

BASELINES["reproduction"] = [
    "loop" => _tutorial_baseline(
        reproduction, function (z)
            (; T, L, S) = z
            pop, K = towns()
            seed = overview_seed(S, L)
            W = _weights(S, T)
            return function (θ)
                g, logR = _unpack(θ, (L,), (S, T))
                return sum(W .* loop_reproduction(g, exp.(logR), seed, K, pop))
            end
        end
    ),
]

# Two routes, a dense coupling on kernel `g1` and a sparse one held as its
# column pointers, row indices and values on kernel `g2`, then floored
# depletion.
function loop_routes(K1, g1, colptr, rowval, v, g2, h, R, pop)
    S, T = size(R)
    m = size(h, 2)
    V = promote_type(
        eltype(K1), eltype(g1), eltype(v), eltype(g2), eltype(h), eltype(R)
    )
    y = _seeded(V, h, T)
    pool = V.(pop)
    p1, p2, q = zeros(V, S), zeros(V, S), zeros(V, S)
    for t in 1:T
        for k in 1:S
            p1[k] = _renewal_sum(g1, y, k, m, t)
            p2[k] = _renewal_sum(g2, y, k, m, t)
        end
        for a in 1:S
            acc = zero(V)
            for b in 1:S
                acc += K1[a, b] * p1[b]
            end
            q[a] = acc
        end
        for b in 1:S, j in colptr[b]:(colptr[b + 1] - 1)
            q[rowval[j]] += v[j] * p2[b]
        end
        for a in 1:S
            drawn = max(pool[a] / pop[a], 1.0e-6) * R[a, t] * q[a]
            pool[a] -= drawn
            y[a, m + t] = drawn
        end
    end
    return view(y, :, (m + 1):(m + T))
end

BASELINES["strata_routes"] = [
    "loop" => _tutorial_baseline(
        strata_routes, function (z)
            (; T, L, S) = z
            W = _weights(S, T)
            K2 = _ring(S)
            n2 = length(nonzeros(K2))
            L1 = cld(L, 2)
            pop = fill(1.0e5, S)
            return function (θ)
                K1, g1, v, g2, logh, logR = _unpack(
                    θ, (S, S), (L1,), (n2,), (L,), (S, L), (S, T)
                )
                y = loop_routes(
                    K1, g1, K2.colptr, K2.rowval, v, g2, exp.(logh), exp.(logR), pop
                )
                return sum(W .* log.(y))
            end
        end
    ),
]

# Suspected patients confirmed at a rate or ruled out as a share, confirmed
# patients discharged at a rate and transferred out in counts, after each
# day's admissions.
function loop_ward(adm, confirm, ruleout, discharge, transfer)
    S, T = size(transfer)
    V = promote_type(
        eltype(adm), eltype(confirm), eltype(ruleout), typeof(discharge),
        eltype(transfer),
    )
    y = zeros(V, 2S, T)
    for t in 1:T, k in 1:S
        sus = (t > 1 ? y[k, t - 1] : zero(V)) + adm[k, t]
        con = (t > 1 ? y[S + k, t - 1] : zero(V)) + adm[S + k, t]
        stay = exp(-confirm[k])
        con = exp(-discharge) * con + (1 - stay) * sus
        sus = (stay - ruleout[t]) * sus
        con -= min(transfer[k, t], max(con, zero(V)))
        y[k, t] = sus
        y[S + k, t] = con
    end
    return y
end

BASELINES["ward_flows"] = [
    "loop" => _tutorial_baseline(
        ward_flows, function (z)
            (; T, S) = z
            W = _weights(2S, T)
            return function (θ)
                adm, confirm, ruleout, discharge, transfer = _unpack(
                    θ, (2S, T), (S,), (T,), (1,), (S, T)
                )
                y = loop_ward(adm, confirm, ruleout, only(discharge), transfer)
                return sum(W .* y)
            end
        end
    ),
]

# An AR(2) process from two past values, the latest last.
function loop_ar2(φ, h, ϵ)
    V = promote_type(eltype(φ), eltype(h), eltype(ϵ))
    y = similar(ϵ, V)
    a, b = V(h[1]), V(h[2])
    for t in eachindex(ϵ)
        a, b = b, φ[1] * b + φ[2] * a + ϵ[t]
        y[t] = b
    end
    return y
end

BASELINES["ar"] = [
    "loop" => _tutorial_baseline(
        ar, function (z)
            W = _weights(z.T)
            return function (θ)
                φ, h, ϵ = _unpack(θ, (2,), (2,), (z.T,))
                return sum(W .* loop_ar2(φ, h, ϵ))
            end
        end
    ),
]

# A delay per stratum and input time: `G[k, d + 1, s]` weights stratum
# `k`'s input at time `s` reaching time `s + d`.
function loop_delay_primary(G, X)
    S, L, T = size(G)
    y = zeros(promote_type(eltype(G), eltype(X)), S, T)
    for t in 1:T, k in 1:S
        acc = zero(eltype(y))
        for d in 0:min(L - 1, t - 1)
            acc += G[k, d + 1, t - d] * X[k, t - d]
        end
        y[k, t] = acc
    end
    return y
end

BASELINES["delay_primary"] = [
    "loop" => _tutorial_baseline(
        delay_primary, function (z)
            (; T, L, S) = z
            W = _weights(S, T)
            return function (θ)
                G, X = _unpack(θ, (S, L, T), (S, T))
                return sum(W .* loop_delay_primary(G, X))
            end
        end
    ),
]

# Multi-type extinction by generation: each stratum's mixed renewal sum
# through its negative binomial probability generating function.
function loop_transform(g, K, r, p, T)
    S, L = length(r), length(g)
    V = promote_type(eltype(g), eltype(r), eltype(p))
    y = zeros(V, S, L + T)
    q = zeros(V, S)
    for t in 1:T
        for k in 1:S
            q[k] = _renewal_sum(g, y, k, L, t)
        end
        for a in 1:S
            v = zero(V)
            for b in 1:S
                v += K[a, b] * q[b]
            end
            y[a, L + t] = _nb_pgf(v, (; r = r[a], p = p[a]))
        end
    end
    return view(y, :, (L + 1):(L + T))
end

BASELINES["transform"] = [
    "loop" => _tutorial_baseline(
        transform, function (z)
            (; T, L, S) = z
            W = _weights(S, T)
            K = S == 1 ? ones(1, 1) :
                fill(0.2 / (S - 1), S, S) + (0.8 - 0.2 / (S - 1)) * I
            return function (θ)
                g, r, p = _unpack(θ, (L,), (S,), (S,))
                return sum(W .* loop_transform(g, K, r, p, T))
            end
        end
    ),
]
