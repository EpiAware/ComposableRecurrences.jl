# Reactant cases the AD registry (`test/ADFixtures`) cannot express: the
# harness control, a call resumed from a returned state, a traced history
# joined before the output, a check run at the call while traced, a
# parameter held as host constants in a traced call, a kernel computed from
# a `Derived` alone (the registry has one only inside a `Survival`), and how
# compile and run time grow with the number of steps and of strata. The
# registry's scenarios cover the operators, kernels, couplings and
# modifiers.
#
# Each case maps a parameter vector `θ` to the operator's output through the
# public API. Only `θ` is traced: sizes, histories and loss weights are
# `const` globals, so Reactant sees them as constants rather than tracing
# captured values.
module ReactantCases

using ComposableRecurrences
using ComposableRecurrences: Primary, Step

export CASES, case_by_name, loss

# Steps default to 20; `REACTANT_T` sets them, to measure how compile and
# run time grow with the length of a run.
const T = parse(Int, get(ENV, "REACTANT_T", "20"))  # steps
const L = 4   # lags (recurrence) or delays (convolution)
const S = 3   # strata
const T₁ = 8  # steps in the first call of the resume case

const g0 = [0.4, 0.3, 0.2, 0.1]
const R0 = collect(range(0.9, 1.2; length = T))
# The same span at the midpoints of `T` steps, which never meets 1 exactly,
# so a floor at 1 is not met exactly at a step and the gradient is defined.
const RM0 = 0.9 .+ 0.3 .* ((1:T) .- 0.5) ./ T
const RS0 = [0.9 + 0.1 * k + 0.01 * t for k in 1:S, t in 1:T]
const H1 = [1.0, 2.0, 1.5, 1.0]
const HS = [1.0 + 0.5 * k + 0.1 * i for k in 1:S, i in 1:L]
const K0 = [0.8 0.1 0.1; 0.2 0.7 0.1; 0.1 0.2 0.7]
const d0 = [0.1, 0.4, 0.3, 0.2]
const x0 = collect(range(1.0, 3.0; length = T))
const HX = [0.5, 1.0, 1.5]
# A wide call: many strata, with only the kernel traced, so its gradient's
# ForwardDiff reference stays cheap.
const SW = 1000
const RSW = [0.9 + 0.2 * k / SW + 0.01 * t for k in 1:SW, t in 1:T]
const HSW = [1.0 + k / SW + 0.1 * i for k in 1:SW, i in 1:L]
const WSW = reshape(collect(range(0.5, 2.0; length = SW * T)), SW, T)

# Loss weights, one per output entry.
const W1 = collect(range(0.5, 2.0; length = T))
const WS = reshape(collect(range(0.5, 2.0; length = S * T)), S, T)
# A joined output holds the history before the steps.
weights_after(m) = reshape(collect(range(0.5, 2.0; length = S * (m + T))), S, m + T)

# A pointwise modifier: a floor on each stratum's value.
struct Lower
    lo::Float64
end
ComposableRecurrences.blocks(::Lower) = (1, 1)
function ComposableRecurrences.forward!(m::Lower, ::Step, v, s, t)
    for k in eachindex(v, s)
        v[k] = max(v[k], m.lo)
    end
    return nothing
end

"A case: `fwd(θ)` is the operator's output at parameters `θ`."
struct Case
    name::String
    description::String
    fwd::Function
    θ::Vector{Float64}
    weights::Array{Float64}
end

"The loss the reverse pass differentiates: a weighted sum of the output."
loss(c::Case, y) = sum(c.weights .* y)

control(θ) = 2 .* θ

rec_single(θ) = Recurrence(θ[1:L])(θ[(L + 1):end]; history = H1)

function rec_strata_I(θ)
    R = reshape(θ[(L + 1):end], S, T)
    return Recurrence(θ[1:L])(R; history = HS)
end

# The history joined before the output. It is read from the traced
# parameters: joining a host array to a traced output is an error.
function rec_joined(θ)
    K = reshape(θ[1:(S * S)], S, S)
    h = reshape(θ[(S * S + 1):(S * S + S * L)], S, L)
    R = reshape(θ[(S * S + S * L + 1):end], S, T)
    return hcat(h, Recurrence(g0; coupling = K)(R; history = h))
end

function rec_resume(θ)
    r = Recurrence(θ[1:L])
    R = θ[(L + 1):end]
    y1, state = r(R; history = H1, stop = T₁, record = (:state,))
    y2 = r(R; state)
    return vcat(y1, y2)
end

# The operator built before the local step's check could run (as before
# `ForwardDiff` loads): the call checks the modifier while traced.
function rec_checked_at_call(θ)
    r0 = Recurrence(θ[1:L]; modifiers = (Lower(1.0),))
    r = Recurrence(
        ComposableRecurrences._Checked(), r0.kernel, r0.coupling, r0.modifiers,
        nothing
    )
    return r(θ[(L + 1):end]; history = H1)
end

rec_strata_wide(θ) = Recurrence(θ)(RSW; history = HSW)

conv_fixed(θ) = Convolution(θ[1:L])(θ[(L + 1):end]; history = HX)

# A per-stratum parameter given by change points, held as host constants
# while only the series is traced: the registry traces every parameter.
const BCP = TimeVarying(
    [1 => PerStratum([0.1, 0.2, 0.3]), max(2, T ÷ 2) => PerStratum([0.4, 0.2, 0.1])]
)
function rec_cp_strata_const(θ)
    r = Recurrence(g0; modifiers = (ComposableRecurrences.Transform(+, BCP),))
    return r(reshape(θ, S, T); history = HS)
end

# A `Primary()` kernel computed from a `Derived` of lag weights and a
# traced `TimeVarying` rate, filled densely in the traced call.
function conv_derived_kernel(θ)
    k = TimeVarying(
        ComposableRecurrences.Derived((a, b) -> a * exp(-b), θ[1:L], TimeVarying(θ[(L + 1):end])),
        Primary()
    )
    return Convolution(k)(x0)
end

const CASES = [
    Case(
        "control", "harness control: 2θ, no package code", control,
        collect(range(0.1, 1.0; length = 5)), collect(1.0:5.0)
    ),
    Case(
        "rec_single", "Recurrence, single series, fixed kernel",
        rec_single, vcat(g0, R0), W1
    ),
    Case(
        "rec_strata_I", "Recurrence, $S strata, I coupling",
        rec_strata_I, vcat(g0, vec(RS0)), WS
    ),
    Case(
        "rec_strata_wide", "Recurrence, $SW strata, I coupling, traced kernel",
        rec_strata_wide, copy(g0), WSW
    ),
    Case(
        "rec_joined", "Recurrence, $S strata, dense K, traced history joined",
        rec_joined, vcat(vec(K0), vec(HS), vec(RS0)), weights_after(L)
    ),
    Case(
        "rec_resume", "Recurrence, resume from returned state",
        rec_resume, vcat(g0, R0), W1
    ),
    Case(
        "rec_checked_at_call",
        "Recurrence, custom pointwise modifier checked at the call",
        rec_checked_at_call, vcat(g0, RM0), W1
    ),
    Case(
        "conv_fixed", "Convolution, fixed kernel", conv_fixed,
        vcat(d0, x0), W1
    ),
    Case(
        "conv_derived_kernel", "Convolution, kernel computed from a Derived",
        conv_derived_kernel, vcat(d0, fill(0.1, T + L)), W1
    ),
    Case(
        "rec_cp_strata_const",
        "Recurrence, per-stratum change points held as host constants",
        rec_cp_strata_const, vec(RS0), WS
    ),
]

function case_by_name(name)
    i = findfirst(c -> c.name == name, CASES)
    i === nothing && throw(ArgumentError("unknown case $name"))
    return CASES[i]
end

end # module ReactantCases
