# Reactant capability cases. Each case maps a parameter vector `θ` to the
# operator's output through the public API. Only `θ` is traced: sizes,
# histories and loss weights are `const` globals, so Reactant sees them as
# constants rather than tracing captured values.
module ReactantCases

using ComposableRecurrences
using LinearAlgebra: I

export CASES, PENDING, case_by_name, loss

# Small sizes: the package's plain `for` loops are unrolled when traced.
const T = 20  # steps
const L = 4   # lags (recurrence) or delays (convolution)
const S = 3   # strata
const T₁ = 8  # steps in the first call of the resume case

const g0 = [0.4, 0.3, 0.2, 0.1]
const R0 = collect(range(0.9, 1.2; length = T))
const RS0 = [0.9 + 0.1 * k + 0.01 * t for k in 1:S, t in 1:T]
const H1 = [1.0, 2.0, 1.5, 1.0]
const HS = [1.0 + 0.5 * k + 0.1 * i for k in 1:S, i in 1:L]
const K0 = [0.8 0.1 0.1; 0.2 0.7 0.1; 0.1 0.2 0.7]
const d0 = [0.1, 0.4, 0.3, 0.2]
const x0 = collect(range(1.0, 3.0; length = T))
const m0 = 3  # convolution history length
const HX = [0.5, 1.0, 1.5]

# Loss weights, one per output entry.
const W1 = collect(range(0.5, 2.0; length = T))
const WS = reshape(collect(range(0.5, 2.0; length = S * T)), S, T)

# A pointwise modifier: a floor on each stratum's value.
struct Floor
    lo::Float64
end
ComposableRecurrences.ispointwise(::Floor) = true
ComposableRecurrences.apply(m::Floor, v, s, t, k) = (max(v, m.lo), s)

# A modifier that couples strata: rescale the step to a fixed total.
struct Rescale
    total::Float64
end
function ComposableRecurrences.apply!(m::Rescale, v, s, t)
    v .*= m.total / sum(v)
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

function rec_add(θ)
    return Recurrence(θ[1:2])(1.0; history = H1, add = θ[3:end])
end

function rec_tv_kernel(θ)
    k = TimeVarying(reshape(θ[1:(L * T)], L, T))
    return Recurrence(k)(θ[(L * T + 1):end]; history = H1)
end

function rec_strata_I(θ)
    R = reshape(θ[(L + 1):end], S, T)
    return Recurrence(θ[1:L])(R; history = HS)
end

function rec_dense_K(θ)
    K = reshape(θ[1:(S * S)], S, S)
    R = reshape(θ[(S * S + 1):end], S, T)
    return Recurrence(g0; coupling = K)(R; history = HS)
end

function rec_per_stratum(θ)
    k = PerStratum(reshape(θ[1:(S * L)], S, L))
    R = reshape(θ[(S * L + 1):end], S, T)
    return Recurrence(k)(R; history = HS)
end

function rec_pairwise(θ)
    P = Pairwise(reshape(θ[1:(S * S * L)], S, S, L))
    R = reshape(θ[(S * S * L + 1):end], S, T)
    return Recurrence(nothing; coupling = P)(R; history = HS)
end

function rec_tv_coupling(θ)
    C = TimeVarying(reshape(θ[1:(S * S * T)], S, S, T))
    R = reshape(θ[(S * S * T + 1):end], S, T)
    return Recurrence(g0; coupling = C)(R; history = HS)
end

function rec_resume(θ)
    r = Recurrence(θ[1:L])
    R = θ[(L + 1):end]
    y1, state = r(R[1:T₁]; history = H1, return_state = true)
    y2 = r(R[(T₁ + 1):end]; history = state)
    return vcat(y1, y2)
end

function rec_pointwise_modifier(θ)
    r = Recurrence(θ[1:L]; modifiers = (Floor(1.0),))
    return r(θ[(L + 1):end]; history = H1)
end

function rec_apply_modifier(θ)
    r = Recurrence(g0; modifiers = (Rescale(6.0),))
    return r(reshape(θ, S, T); history = HS)
end

conv_fixed(θ) = Convolution(θ[1:L])(θ[(L + 1):end]; history = HX)

# `:primary` needs a kernel column for every history input, so the kernel
# covers times 1 to `m0 + T` and the first output is at `m0 + 1`.
function conv_tv_primary(θ)
    k = TimeVarying(reshape(θ[1:(L * (m0 + T))], L, m0 + T))
    c = Convolution(k; indexed_by = :primary)
    return c(θ[(L * (m0 + T) + 1):end]; history = HX, start = m0 + 1)
end

function conv_tv_secondary(θ)
    k = TimeVarying(reshape(θ[1:(L * T)], L, T))
    c = Convolution(k; indexed_by = :secondary)
    return c(θ[(L * T + 1):end]; history = HX)
end

tv_kernel(n) = vec(repeat(g0, 1, n) .* (1 .+ 0.01 .* (1:n)'))

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
        "rec_add", "Recurrence with add (AR(2))", rec_add,
        vcat([0.5, 0.2], 0.1 .* sin.(1:T)), W1
    ),
    Case(
        "rec_tv_kernel", "Recurrence, TimeVarying kernel",
        rec_tv_kernel, vcat(tv_kernel(T), R0), W1
    ),
    Case(
        "rec_strata_I", "Recurrence, $S strata, I coupling",
        rec_strata_I, vcat(g0, vec(RS0)), WS
    ),
    Case(
        "rec_dense_K", "Recurrence, $S strata, dense K coupling",
        rec_dense_K, vcat(vec(K0), vec(RS0)), WS
    ),
    Case(
        "rec_per_stratum", "Recurrence, PerStratum kernel",
        rec_per_stratum,
        vcat(vec(repeat(g0', S) .* (1:S) ./ S), vec(RS0)), WS
    ),
    Case(
        "rec_pairwise", "Recurrence, Pairwise coupling",
        rec_pairwise,
        vcat(vec(reshape(K0, S, S, 1) .* reshape(g0, 1, 1, L)), vec(RS0)),
        WS
    ),
    Case(
        "rec_tv_coupling", "Recurrence, TimeVarying coupling",
        rec_tv_coupling,
        vcat(vec(repeat(K0, 1, 1, T) .* reshape(1 .+ 0.01 .* (1:T), 1, 1, T)), vec(RS0)),
        WS
    ),
    Case(
        "rec_resume", "Recurrence, resume from returned state",
        rec_resume, vcat(g0, R0), W1
    ),
    Case(
        "rec_pointwise_modifier", "Recurrence, custom pointwise modifier",
        rec_pointwise_modifier, vcat(g0, R0), W1
    ),
    Case(
        "rec_apply_modifier", "Recurrence, custom apply! modifier",
        rec_apply_modifier, vec(RS0), WS
    ),
    Case(
        "conv_fixed", "Convolution, fixed kernel", conv_fixed,
        vcat(d0, x0), W1
    ),
    Case(
        "conv_tv_primary", "Convolution, TimeVarying kernel, :primary",
        conv_tv_primary, vcat(tv_kernel(m0 + T), x0), W1
    ),
    Case(
        "conv_tv_secondary", "Convolution, TimeVarying kernel, :secondary",
        conv_tv_secondary, vcat(tv_kernel(T), x0), W1
    ),
]

# Modifiers not yet on main: listed so the matrix shows them as pending.
const PENDING = [
    ("mod_depletion", "Recurrence with Depletion"),
    ("mod_imports", "Recurrence with Imports"),
    ("mod_clamp", "Recurrence with Clamp"),
    ("mod_redistribute", "Recurrence with Redistribute"),
]

function case_by_name(name)
    i = findfirst(c -> c.name == name, CASES)
    i === nothing && throw(ArgumentError("unknown case $name"))
    return CASES[i]
end

end # module ReactantCases
