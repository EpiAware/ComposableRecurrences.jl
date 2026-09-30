# Verbatim copies of the ComposableTuringIDModels step code (f7d6cc9f,
# src/steps/*.jl, src/infection_models/utils.jl), docstrings removed, so the
# reference checks in ctidm.jl run exactly the package's arithmetic without
# loading the package (Turing, MTK, Catalyst).
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
