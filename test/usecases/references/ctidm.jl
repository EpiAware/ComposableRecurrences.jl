# Verbatim copies of the ComposableTuringIDModels.jl step code used as the
# reference for the use-case tests.
#
# Source: https://github.com/EpiAware/ComposableTuringIDModels.jl at commit
# f7d6cc9f. Each block names its file and line range. Docstrings are left
# out and Runic re-indents one block; the code is otherwise unchanged, so the
# reference runs the package's own arithmetic without loading Turing.
# The drivers at the end are not copied: each wraps the `accumulate_scan` call
# or expression of the cited model body so it can be called without
# `DynamicPPL`.
module CTIDMReference

using LinearAlgebra

# src/steps/AbstractAccumulationStep.jl L12-L12
abstract type AbstractAccumulationStep end

# src/steps/accumulate_scan.jl L25-L28
function accumulate_scan(acc_step::AbstractAccumulationStep, initial_state, ϵ_t)
    result = accumulate(acc_step, ϵ_t; init = initial_state)
    return get_state(acc_step, initial_state, result)
end

# src/steps/accumulate_scan.jl L50-L52
function get_state(acc_step::AbstractAccumulationStep, initial_state, state)
    return vcat(collect(initial_state), last.(state))
end

# src/base/priors.jl L230-L233
at(p::Number, t) = p
at(p::AbstractVector, t) = p[t]
# A strata × time parameter read at step `t` is that step's column.
at(p::AbstractMatrix, t) = view(p, :, t)

# src/infection_models/utils.jl L144-L145
_steps(Rt::AbstractVector) = Rt
_steps(Rt::AbstractMatrix) = collect.(eachcol(Rt))

# src/steps/RWStep.jl L6-L7
struct RWStep <: AbstractAccumulationStep end
(::RWStep)(state, ϵ) = state + ϵ

# src/steps/ARStep.jl L6-L18
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

# src/steps/TVARStep.jl L20-L24
struct TVARStep{C} <: AbstractAccumulationStep
    ρ::C
end

(s::TVARStep)(state, tϵ) = at(s.ρ, tϵ[1]) * state + tϵ[2]

# src/steps/MAStep.jl L6-L23
struct MAStep{C <: AbstractVector{<:Real}} <: AbstractAccumulationStep
    θ::C
end

function (ma::MAStep)(state, ϵ)
    new_val = ϵ + dot(ma.θ, state.state)
    new_state = vcat(ϵ, state.state[1:(end - 1)])
    return (; val = new_val, state = new_state)
end

function get_state(acc_step::MAStep, initial_state, state)
    # `initial_state.state` is stored newest-first (see `MA.jl`); the first `q`
    # outputs are the raw warm-up innovations in natural (oldest-first) order, so
    # reverse the seed back before prepending it.
    init_vals = reverse(initial_state.state)
    new_vals = state .|> x -> x.val
    return vcat(init_vals, new_vals)
end

# src/steps/LDStep.jl L7-L17
struct LDStep{D <: AbstractVector{<:Real}} <: AbstractAccumulationStep
    rev_pmf::D
end

function (ld::LDStep)(state, ϵ)
    val = dot(ld.rev_pmf, state.current)
    current = vcat(state.current[2:end], ϵ)
    return (; val, current)
end

get_state(::LDStep, initial_state, state) = state .|> x -> x.val

# src/steps/TimeVaryingLDStep.jl L20-L29
struct TimeVaryingLDStep <: AbstractAccumulationStep end

function (::TimeVaryingLDStep)(state, input)
    ϵ, rev_pmf_t = input
    val = dot(rev_pmf_t, state.current)
    current = vcat(state.current[2:end], ϵ)
    return (; val, current)
end

get_state(::TimeVaryingLDStep, initial_state, state) = state .|> x -> x.val

# src/steps/RenewalSteps.jl L8-L8
abstract type AbstractConstantRenewalStep <: AbstractAccumulationStep end

# src/steps/RenewalSteps.jl L63-L102
renewal_pressure(::UniformScaling, g, window::AbstractVector) = dot(window, g)

# Row-wise reductions rather than `window * g` and `K * v`: Enzyme forward has
# no runtime-activity `gemv`. The vector case above is a `dot`, which it does
# support.
function renewal_pressure(::UniformScaling, g, window::AbstractMatrix)
    return vec(sum(window .* reshape(g, 1, :); dims = 2))
end

# A `strata × lags` generation interval: each stratum convolves its own row of
# the window with its own interval.
function renewal_pressure(
        ::UniformScaling, g::AbstractMatrix, window::AbstractMatrix
    )
    return vec(sum(window .* g; dims = 2))
end

# A mixing matrix redistributes the convolved histories, whichever generation
# interval produced them.
function renewal_pressure(K::AbstractMatrix, g, window::AbstractMatrix)
    return vec(sum(K .* reshape(renewal_pressure(I, g, window), 1, :); dims = 2))
end

# A per-pair generation interval, `K[g, h, i]` being the weight stratum `h`
# puts on stratum `g` at lag `i`. The window runs oldest to newest, so lag `i`
# is column `end - i + 1`; the reversed generation interval `g` is unused,
# because the array carries the intervals itself.
function renewal_pressure(
        K::AbstractArray{<:Any, 3}, g, window::AbstractMatrix
    )
    last_lag = size(window, 2)
    return sum(
        vec(
            sum(
                view(K, :, :, i) .*
                    reshape(view(window, :, last_lag - i + 1), 1, :); dims = 2
            )
        ) for i in axes(K, 3)
    )
end

# src/steps/RenewalSteps.jl L132-L134
function renewal_foi(step::AbstractConstantRenewalStep, window, Rt)
    return Rt .* renewal_pressure(step.mixing, step.rev_gen_int, window)
end

# src/steps/RenewalSteps.jl L154-L197
struct ConstantRenewalStep{T, K} <: AbstractConstantRenewalStep
    "The reversed generation interval."
    rev_gen_int::T
    "The coupling operator applied to the convolved window."
    mixing::K
end

ConstantRenewalStep(rev_gen_int) = ConstantRenewalStep(rev_gen_int, I)

# --- window arithmetic ------------------------------------------------------
#
# One incidence window serves both shapes. A single series is a vector of the
# last `lags` incidences. Several strata are a `strata × lags` matrix, one row
# per stratum. Each helper has one method per shape, so the recursion, the
# state assembly and the seeding are written once.

# The newest entry of the window is the incidence just committed.
_newest(window::AbstractVector) = last(window)
_newest(window::AbstractMatrix) = window[:, end]

# Assemble the scanned states into the returned series: a path stays a vector,
# per-stratum columns become a `strata × time` matrix, which is `size(I_t)`.
_series(v::AbstractVector{<:Real}) = v
_series(v::AbstractVector{<:AbstractVector}) = reduce(hcat, v)

# Drop the oldest entry and commit the new incidence.
_advance(window::AbstractVector, new) = vcat(window[2:end], new)
function _advance(window::AbstractMatrix, new)
    return hcat(collect(view(window, :, 2:size(window, 2))), new)
end

# The number of lags a generation interval covers.
_n_lags(g::AbstractVector) = length(g)
_n_lags(g::AbstractMatrix) = size(g, 2)

# Reverse a generation interval along its lag axis, whatever its shape.
_reverse_lags(g::AbstractVector) = reverse(g)
_reverse_lags(g::AbstractMatrix) = reverse(g; dims = 2)

function (recurrent_step::ConstantRenewalStep)(state, Rt)
    new_incidence = renewal_foi(recurrent_step, state.window, Rt)
    new_window = _advance(state.window, new_incidence)
    return (; val = new_incidence, window = new_window)
end

# src/steps/RenewalSteps.jl L224-L232
function renewal_init_window(::ConstantRenewalStep, I₀::Real, r, len_gen_int)
    return I₀ * [exp(-r * t) for t in (len_gen_int - 1):-1:0]
end

function renewal_init_window(
        ::ConstantRenewalStep, I₀::AbstractVector, r, len_gen_int
    )
    return I₀ .* exp.(.-r .* permutedims((len_gen_int - 1):-1:0))
end

# src/steps/RenewalSteps.jl L259-L266
function renewal_init_state(step::ConstantRenewalStep, I₀, r, len_gen_int)
    window = renewal_init_window(step, I₀, r, len_gen_int)
    return (; val = _newest(window), window = window)
end

function get_state(::ConstantRenewalStep, initial_state, state)
    return _series(state .|> x -> x.val)
end

# src/steps/RenewalStep.jl L60-L60
abstract type AbstractRenewalModifier end

# src/steps/RenewalStep.jl L121-L150
struct SusceptibleDepletion{T} <: AbstractRenewalModifier
    "The population size, one value or one per stratum."
    pop_size::T
end

# The susceptible pool has to match the incidence it depletes, so a scalar pool
# given to a stratified renewal is spread over the strata rather than left as a
# scalar that the first step would silently widen.
function modifier_init_state(mod::SusceptibleDepletion, window)
    return _match_strata(mod.pop_size, window)
end

_match_strata(pop_size, ::AbstractVector) = pop_size
_match_strata(pop_size::Real, window::AbstractMatrix) = fill(pop_size, size(window, 1))
function _match_strata(pop_size::AbstractVector, window::AbstractMatrix)
    @assert length(pop_size) == size(window, 1) "`pop_size` has " *
        "$(length(pop_size)) entries " *
        "but the renewal has " *
        "$(size(window, 1)) strata"
    return pop_size
end

# The susceptible fraction is floored because a large force of infection can
# take more than the pool holds, leaving `S` negative for the rest of the run.
# The floor keeps the recursion going there. Every operation is broadcast, so
# one line serves a scalar and a per-stratum pool.
function apply_modifier(mod::SusceptibleDepletion, incidence, S)
    new_incidence = max.(S ./ mod.pop_size, 1.0e-6) .* incidence
    return new_incidence, S .- new_incidence
end

# src/steps/RenewalStep.jl L168-L222
struct RenewalStep{R <: AbstractConstantRenewalStep, M <: Tuple} <:
    AbstractConstantRenewalStep
    core::R
    modifiers::M
end

RenewalStep(core::AbstractConstantRenewalStep) = RenewalStep(core, ())

# The renewal force of infection is defined by the core primitive.
renewal_foi(step::RenewalStep, window, Rt) = renewal_foi(step.core, window, Rt)

# No modifiers: behave exactly as the plain force-of-infection core (bare-window
# state, no per-step overhead), so a modifier-free renewal is unchanged.
const _PlainRenewalStep = RenewalStep{<:AbstractConstantRenewalStep, Tuple{}}

(step::_PlainRenewalStep)(state, Rt) = step.core(state, Rt)

function renewal_init_state(step::_PlainRenewalStep, I₀, r_approx, len_gen_int)
    return renewal_init_state(step.core, I₀, r_approx, len_gen_int)
end

function get_state(step::_PlainRenewalStep, initial_state, state)
    return get_state(step.core, initial_state, state)
end

# Thread the proposed incidence through the modifier tuple, collecting each
# modifier's updated substate. Recursive over the tuple to stay type-stable and
# AD-friendly (no mutation of tracked state).
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

function renewal_init_state(step::RenewalStep, I₀, r_approx, len_gen_int)
    window = renewal_init_window(step.core, I₀, r_approx, len_gen_int)
    substates = map(mod -> modifier_init_state(mod, window), step.modifiers)
    return (; val = _newest(window), window = window, substates = substates)
end

function get_state(::RenewalStep, initial_state, state)
    return _series(state .|> x -> x.val)
end

# src/steps/ImportedCases.jl L150-L162
struct ImportedRate{V} <: AbstractRenewalModifier
    "The positive importation rate: one constant, or one value per time."
    rate::V
end

# The substate is the step counter: a scan step has no clock of its own, so a
# per-time modifier carries the index it has reached. The window is unused —
# a step counter has no shape of its own to match.
modifier_init_state(::ImportedRate, window) = 0

function apply_modifier(mod::ImportedRate, incidence, t)
    return incidence + at(mod.rate, t + 1), t + 1
end

# src/steps/Gravity.jl L50-L59
function gravity(pop, dist; α = 1.0, β = 1.0, γ = 2.0, within = 1.0)
    n = length(pop)
    @assert size(dist) == (n, n) "`dist` must be $n x $n for $n strata"
    p = pop ./ (sum(pop) / n)
    K = [
        g == h ? within : p[g]^α * p[h]^β / dist[g, h]^γ
            for g in 1:n, h in 1:n
    ]
    return K ./ sum(K; dims = 2)
end

# src/steps/Gravity.jl L155-L174
function pairwise_gen_int(K::AbstractMatrix, G::AbstractArray{<:Any, 3})
    @assert size(G)[1:2] == size(K) "`G` must be $(size(K)) x lags to match `K`"
    for idx in CartesianIndices(K)
        _assert_pmf(view(G, idx[1], idx[2], :))
    end
    return K .* G
end

function pairwise_gen_int(K::AbstractMatrix, g::AbstractVector)
    _assert_pmf(g)
    return pairwise_gen_int(
        K, repeat(reshape(g, 1, 1, :), size(K, 1), size(K, 2))
    )
end

function _assert_pmf(g)
    @assert all(>=(0), g) "A generation interval must be non-negative"
    @assert sum(g) ≈ 1 "A generation interval must sum to 1"
    return nothing
end

# src/latent_models/modifiers/DiffLatentModel.jl L69-L75
function _combine_diff(init, diff, d)
    combined = vcat(collect(init), collect(diff))
    for _ in 1:d
        combined = cumsum(combined)
    end
    return combined
end

# src/infection_models/ExpGrowthRate.jl L77-L78
_cumsum(Z_t::AbstractVector) = cumsum(Z_t)
_cumsum(Z_t::AbstractMatrix) = cumsum(Z_t; dims = 2)

# --- drivers (not copied) ----------------------------------------------------
#
# Each driver is the `accumulate_scan` call of the cited model body, with the
# sampled quantities passed in as arguments.

# src/latent_models/models/RandomWalk.jl L46
random_walk(init, ϵ_t) = accumulate_scan(RWStep(), init, ϵ_t)

# src/latent_models/models/AR.jl L138-140 (order p > 1)
function ar(damp_AR, ar_init, ϵ_t)
    return accumulate_scan(
        ARStep(reverse(damp_AR)), (; val = last(ar_init), window = ar_init), ϵ_t
    )
end

# src/latent_models/models/AR.jl L125-128 (order 1, time-varying coefficient)
function tvar(ρ, ar_init, ϵ_t)
    n = length(ϵ_t) + 1
    return accumulate_scan(TVARStep(ρ), ar_init, collect(zip(1:(n - 1), ϵ_t)))
end

# src/latent_models/models/MA.jl L77-79 (order q > 1)
function ma(θ, ϵ_t)
    q = length(θ)
    return accumulate_scan(
        MAStep(θ), (; val = 0.0, state = reverse(ϵ_t[1:q])), ϵ_t[(q + 1):end]
    )
end

# src/observation_models/modifiers/LatentDelay.jl L357-372 (fixed pmf)
function latent_delay(pmf, Y_t)
    rev_pmf = reverse(pmf)
    d = length(rev_pmf)
    return accumulate_scan(
        LDStep(rev_pmf), (; val = 0, current = Y_t[1:d]),
        vcat(Y_t[(d + 1):end], 0.0)
    )
end

# src/observation_models/modifiers/LatentDelay.jl L336-356 (one pmf per time)
function time_varying_latent_delay(pmfs, Y_t)
    rev_pmfs = reverse.(pmfs)
    d = length(first(rev_pmfs))
    return accumulate_scan(
        TimeVaryingLDStep(), (; val = 0, current = Y_t[1:d]),
        collect(zip(vcat(Y_t[(d + 1):end], 0.0), rev_pmfs[d:end]))
    )
end

# src/infection_models/Renewal.jl L248-251 and L287-289, with the growth rate
# `r` of the initial window given rather than solved from R_0.
function renewal(step, gen_int, I₀, r, Rt)
    init = renewal_init_state(step, I₀, r, _n_lags(gen_int))
    return accumulate_scan(step, init, _steps(Rt))
end

# A renewal whose mixing matrix changes each step: the copied
# `ConstantRenewalStep` rebuilt with `Ks[:, :, t]` at step `t`.
function time_varying_mixing_renewal(rev_gen_int, Ks, window, Rt)
    state = (; val = _newest(window), window = window)
    out = map(axes(Rt, 2)) do t
        state = ConstantRenewalStep(rev_gen_int, Ks[:, :, t])(state, Rt[:, t])
        state.val
    end
    return _series(out)
end

# src/latent_models/models/MA.jl L70 (order 1, a coefficient path)
ma1(θ, ϵ_t) = vcat(ϵ_t[1], ϵ_t[2:end] .+ θ .* ϵ_t[1:(end - 1)])

# src/latent_models/combinations/arma.jl and arima.jl: an AR whose
# innovations are an MA, differenced `d` times (DiffLatentModel.jl L61-L66).
function arima(damp, ar_init, θ, ϵ_t, diff_init)
    return _combine_diff(diff_init, ar(damp, ar_init, ma(θ, ϵ_t)), length(diff_init))
end

# src/infection_models/ExpGrowthRate.jl L85, with the identity transformation
# so the log incidence is returned.
exp_growth(I₀, Z_t) = I₀ .+ _cumsum(Z_t)

# src/observation_models/modifiers/Aggregate.jl L113-L137, the window sums
# alone for a `y_t` as long as `Y_t` (no offset).
function aggregate(aggregation, Y_t)
    idx = findall(aggregation .!= 0)
    return map(i -> sum(Y_t[max(1, i - aggregation[i] + 1):i]), idx)
end

end
