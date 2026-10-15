# PACKAGE-OWNED — scaffold writes this once and never overwrites it.
#
# AD-fixture registry implementing the EpiAwarePackageTools `ADRegistry`
# contract: scenarios (each with a ForwardDiff reference), a backend list,
# and broken/skip bookkeeping, consumed by the shared harness
# (`test/ad/setup.jl`) and the benchmark suite.
#
# Each scenario differentiates a scalar loss of one operator call with
# respect to a flat parameter vector holding every differentiable slot.
# Sizes are small so the per-backend CI stays fast; benchmark/matrix.jl
# times realistic sizes.
module ADFixtures

using ADTypes: AutoForwardDiff, AutoReverseDiff, AutoMooncake,
    AutoMooncakeForward, AutoEnzyme
using DifferentiationInterface: DifferentiationInterface
import DifferentiationInterfaceTest as DIT
import ForwardDiff, ReverseDiff, Enzyme, Mooncake
# Loaded so the default `Auto()` method can take the transform.
import FFTW
using ComposableRecurrences
using ComposableRecurrences: ComposableRecurrences, NoAdjoint
using Distributions: NegativeBinomial, Poisson
using LinearAlgebra: Diagonal, I
using SparseArrays: SparseMatrixCSC, sparse

export scenarios, backends, broken_scenario_names,
    backend_broken_scenarios, backend_plain_scenarios, backend_skip_scenarios,
    FlooredDepletion,
    supports, unsupported_scenarios

# ForwardDiff reference gradient for a scenario function.
function _reference(f, θ)
    return DifferentiationInterface.gradient(f, AutoForwardDiff(), θ)
end

"""
CTIDM's floored susceptible depletion as a pointwise modifier: the value is
scaled by `max(s / pop, 1e-6)` and removed from the pool `s`, which starts at
`pop`.
"""
struct FlooredDepletion{P}
    pop::P
end
function ComposableRecurrences.forward(
        m::FlooredDepletion, ::ComposableRecurrences.Init, s, history
    )
    s .= m.pop
    return nothing
end
ComposableRecurrences.ispointwise(::FlooredDepletion) = true
function ComposableRecurrences.forward(
        m::FlooredDepletion, ::ComposableRecurrences.Step, v, s, t, k
    )
    v′ = max(s / m.pop[k], 1.0e-6) * v
    return v′, s - v′
end

"""
Floored depletion from one scalar pool size `N` shared by every stratum, so
the scalar field is differentiated.
"""
struct ScalarDepletion{T}
    N::T
end
function ComposableRecurrences.forward(
        m::ScalarDepletion, ::ComposableRecurrences.Init, s, history
    )
    fill!(s, m.N)
    return nothing
end
ComposableRecurrences.ispointwise(::ScalarDepletion) = true
function ComposableRecurrences.forward(
        m::ScalarDepletion, ::ComposableRecurrences.Step, v, s, t, k
    )
    v′ = max(s / m.N, 1.0e-6) * v
    return v′, s - v′
end

# Consecutive blocks of `θ` with the given shapes, as reshaped views.
# Enzyme, up to 0.13.216 at least, fails one way of building them on each
# side of Julia 1.12:
# - On 1.11 the closure below, which captures a boxed offset, leaves every
#   scenario uninferred, and Enzyme reverse mode then returns zero for the
#   scalar parameters of an operator. So 1.11 takes the inferred recursion.
# - From 1.12 Enzyme forward mode corrupts the heap after some thousands of
#   calls of the inferred scenarios. So these versions keep the closure,
#   whose gradients are right there.
@static if VERSION < v"1.12"
    _unpack(θ, shapes...) = _unpack_from(θ, 0, shapes...)
    _unpack_from(θ, o) = ()
    function _unpack_from(θ, o, sh, rest...)
        n = prod(sh)
        x = reshape(view(θ, (o + 1):(o + n)), sh...)
        return (x, _unpack_from(θ, o + n, rest...)...)
    end
else
    function _unpack(θ, shapes...)
        o = 0
        return map(shapes) do sh
            n = prod(sh)
            x = reshape(view(θ, (o + 1):(o + n)), sh...)
            o += n
            x
        end
    end
end

# The arrays `xs` flattened into one parameter vector.
_flat(xs...) = reduce(vcat, map(vec, xs))

const S, L, T = 3, 4, 12
const W1 = [sin(t) for t in 1:T]
const WS = [cos(a * t) for a in 1:S, t in 1:T]
const G0 = exp.(-0.4 .* (1:L)) ./ sum(exp.(-0.4 .* (1:L)))
const K0 = [0.8 0.1 0.1; 0.2 0.7 0.1; 0.0 0.3 0.7]
const KS = sparse([0.8 0.2 0.0; 0.0 0.7 0.3; 0.1 0.0 0.9])
const POP = [60.0, 90.0, 70.0]
const LOGR = [0.1 * sin(a + t) for a in 1:S, t in 1:T]

# Each scenario takes `w`, which wraps the operator: `identity` runs the
# analytic adjoint and `NoAdjoint` plain AD of the same call.
function _renewal(w, θ)
    g, logh, logR = _unpack(θ, (L,), (L,), (T,))
    y = w(Recurrence(g))(exp.(logR); history = exp.(logh))
    return sum(W1 .* log.(y))
end

function _renewal_strata(w, θ)
    g, K, logh, logR = _unpack(θ, (L,), (S, S), (S, L), (S, T))
    dep = ComposableRecurrences.Depletion(
        PerStratum(POP), ComposableRecurrences.Floor()
    )
    r = Recurrence(g; coupling = K, modifiers = (dep,))
    y = w(r)(exp.(logR); history = exp.(logh))
    return sum(WS .* log.(y))
end

# A differentiated heterogeneity exponent: the built-in forms' default
# exponent is fixed, so these keep the float exponent's power and log on
# every backend.
function _heterogeneity(w, θ, form)
    α, logh, logR = _unpack(θ, (1,), (S, L), (S, T))
    dep = ComposableRecurrences.Depletion(
        PerStratum(POP), form; heterogeneity = only(α)
    )
    r = Recurrence(G0; coupling = K0, modifiers = (dep,))
    y = w(r)(exp.(logR); history = exp.(logh))
    return sum(WS .* log.(y))
end
_heterogeneity_hazard(w, θ) = _heterogeneity(w, θ, ComposableRecurrences.Hazard())
_heterogeneity_floor(w, θ) = _heterogeneity(w, θ, ComposableRecurrences.Floor())

# A scalar modifier field, a Float32 kernel and Float64 history.
const G0F = Float32.(G0)
function _scalar_field_mixed(w, θ)
    N, logR = θ[1], _unpack(view(θ, 2:length(θ)), (S, T))[1]
    r = Recurrence(G0F; coupling = K0, modifiers = (ScalarDepletion(N),))
    y = w(r)(exp.(logR); history = fill(5.0, S, L))
    return sum(WS .* log.(y))
end

# A scalar modifier field next to a modifier with an array field, under the
# default coupling: the operator holds both floats and arrays.
function _array_and_scalar_fields(w, θ)
    b = θ[1]
    logh = reshape(view(θ, 2:(1 + S * L)), S, L)
    logR = reshape(view(θ, (2 + S * L):(1 + S * L + S * T)), S, T)
    mods = (
        ComposableRecurrences.Depletion(
            PerStratum(POP), ComposableRecurrences.Floor()
        ),
        ComposableRecurrences.Add(b),
    )
    y = w(Recurrence(G0; modifiers = mods))(exp.(logR); history = exp.(logh))
    return sum(WS .* log.(y))
end

# The strata split into two groups, each rescaled to a total per group and
# day.
const GROUPS = [1:2, 3:3]
function _allocate(w, θ)
    g, logh, logR, logtot = _unpack(θ, (L,), (S, L), (S, T), (2, T))
    split = ComposableRecurrences.Allocate(
        GROUPS, TimeVarying(PerStratum(exp.(logtot)))
    )
    y = w(Recurrence(g; modifiers = (split,)))(exp.(logR); history = exp.(logh))
    return sum(WS .* log.(y))
end

# The grouped totals with imports: a share of each group's total lands in
# the pattern the other group sends, read before the first group's strata
# spill into each other. The spill kernel is differentiated too.
function _allocate_imports(w, θ)
    g, logh, logR, logtot, φ, P, K, ε = _unpack(
        θ, (L,), (S, L), (S, T), (2, T), (2, T), (S, S), (S, S), (S,)
    )
    split = ComposableRecurrences.Allocate(
        GROUPS, TimeVarying(PerStratum(exp.(logtot)));
        imports = (TimeVarying(PerStratum(φ)), P),
        spill = ComposableRecurrences.Redistribute(K, PerStratum(ε))
    )
    y = w(Recurrence(g; modifiers = (split,)))(exp.(logR); history = exp.(logh))
    return sum(WS .* log.(y))
end

# Dense matrices held as `Matrix`, as `collect` gives them, so the dense
# pullbacks of the coupling, `Redistribute` and the import pattern run.
function _dense_matrices(w, θ)
    g, C, logh, logR, logtot, P, K, ε = _unpack(
        θ, (L,), (S, S), (S, L), (S, T), (2, T), (S, S), (S, S), (S,)
    )
    split = ComposableRecurrences.Allocate(
        GROUPS, TimeVarying(PerStratum(exp.(logtot)));
        imports = (0.2, collect(P)),
        spill = ComposableRecurrences.Redistribute(collect(K), PerStratum(ε))
    )
    mods = (ComposableRecurrences.Redistribute(collect(K), 0.1), split)
    r = Recurrence(g; coupling = collect(C), modifiers = mods)
    return sum(WS .* log.(w(r)(exp.(logR); history = exp.(logh))))
end

# Imports by a pattern that varies over time, one fraction and no spill.
function _allocate_imports_time_varying(w, θ)
    g, logh, logR, φ, P = _unpack(θ, (L,), (S, L), (S, T), (1,), (S, S, T))
    split = ComposableRecurrences.Allocate(
        GROUPS, PerStratum([6.0, 3.0]); imports = (φ[1], TimeVarying(P))
    )
    y = w(Recurrence(g; modifiers = (split,)))(exp.(logR); history = exp.(logh))
    return sum(WS .* log.(y))
end

function _sparse(w, θ)
    v, logh, R = _unpack(θ, (length(KS.nzval),), (S, L), (S, T))
    K = SparseMatrixCSC(S, S, KS.colptr, KS.rowval, collect(v))
    y = w(Recurrence(G0; coupling = K))(R; history = exp.(logh))
    return sum(WS .* y)
end

function _diagonal(w, θ)
    d, G, logh, R = _unpack(θ, (S,), (S, L), (S, L), (S, T))
    r = Recurrence(PerStratum(G); coupling = Diagonal(d))
    return sum(WS .* w(r)(R; history = exp.(logh)))
end

function _pairwise(w, θ)
    P, logh, R = _unpack(θ, (S, S, L), (S, L), (S, T))
    r = Recurrence(Pairwise(P))
    return sum(WS .* w(r)(R; history = exp.(logh)))
end

function _time_varying(w, θ)
    G, C, logh, ϵ = _unpack(θ, (L, T), (S, S, T), (S, L), (S, T))
    r = Recurrence(TimeVarying(G); coupling = TimeVarying(C))
    return sum(WS .* w(r)(0.9; history = exp.(logh), add = ϵ))
end

# The returned state feeds the loss, so its cotangent reaches the history
# and the depletion pool.
function _with_state(w, θ)
    g, logh, logR = _unpack(θ, (L,), (S, L), (S, T))
    dep = ComposableRecurrences.Depletion(PerStratum(POP))
    r = Recurrence(g; coupling = K0, modifiers = (dep,))
    y, st = ComposableRecurrences.with_state(w(r), exp.(logR); history = exp.(logh))
    return sum(WS .* log.(y)) + sum(st.history) + 0.01 * sum(only(st.states))
end

# Each infector keeps the kernel of its own infection time (`Primary()`),
# per stratum, seeded at times 1 to L.
function _primary(w, θ)
    G, logh, logR = _unpack(θ, (S, L, T), (S, L), (S, T))
    kernel = TimeVarying(PerStratum(G), ComposableRecurrences.Primary())
    r = Recurrence(kernel; coupling = K0)
    y = w(r)(exp.(logR); history = exp.(logh), start = L + 1)
    return sum(WS[:, (L + 1):end] .* log.(y))
end

# Seeded on a growth path from per-stratum levels and one rate, with the
# seed returned before the run.
const WSL = [cos(a * t) for a in 1:S, t in 1:(L + T)]
function _growth_seed(w, θ)
    logI0, r, logR = _unpack(θ, (S,), (1,), (S, T))
    h = ComposableRecurrences.exponential_history(exp.(logI0), only(r), L)
    y = w(Recurrence(G0; coupling = K0))(exp.(logR); history = h, prepend = true)
    return sum(WSL .* log.(y))
end

# The state returned after the seed and the run, with the seed prepended.
function _with_state_prepend(w, θ)
    logh, logR = _unpack(θ, (S, L), (S, T))
    r = Recurrence(G0; coupling = K0)
    y, st = ComposableRecurrences.with_state(
        w(r), exp.(logR); history = exp.(logh), start = L + 1, prepend = true
    )
    return sum(WS .* log.(y)) + sum(st.history)
end

function _delay(w, θ)
    g, w0, ϵ = _unpack(θ, (L + 1,), (L,), (T,))
    return sum(W1 .* w(Convolution(g))(ϵ; history = w0))
end

function _delay_varying(w, θ)
    G, X = _unpack(θ, (S, L, T), (S, T))
    kernel = TimeVarying(PerStratum(G), ComposableRecurrences.Primary())
    return sum(WS .* w(Convolution(kernel))(X))
end

function _delay_varying_secondary(w, θ)
    G, X, H = _unpack(θ, (L, T), (S, T), (S, 2))
    return sum(WS[:, 4:end] .* w(Convolution(TimeVarying(G)))(X; history = H, start = 4))
end

# A reported delay: a fraction of each stratum's delayed inputs on a
# shared baseline (`conv_gain`).
function _conv_gain(w, θ)
    g, logρ, A, X, H = _unpack(θ, (L,), (S, T), (T,), (S, T), (S, 2))
    y = w(Convolution(g))(X; gain = exp.(logρ), add = A, history = H)
    return sum(WS .* y)
end

# A reporting triangle (`triangle`): each input's delay pmf, of its own time,
# spread over the lags, scaled by one ascertainment.
const WT = [cos(a + d * t) for a in 1:S, d in 1:L, t in 1:T]
function _triangle(w, θ)
    G, X, ρ = _unpack(θ, (L, T), (S, T), (1,))
    kernel = TimeVarying(G, ComposableRecurrences.Primary())
    Y = ComposableRecurrences.contributions(w(Convolution(kernel)), X; gain = ρ[1])
    return sum(WT .* Y)
end

# Kernels as vectors of columns of different lengths, cut from the flat
# values `v`: column `τ` has `ns[τ]` entries.
function _columns(v, ns)
    o = cumsum([0; ns])
    return [v[(o[τ] + 1):o[τ + 1]] for τ in eachindex(ns)]
end

# A delay pmf per input time truncated at the horizon: column `τ` holds
# delays 0 to `min(L, T - τ)`.
const NS_HORIZON = [min(L + 1, T - τ + 1) for τ in 1:T]
function _delay_ragged(w, θ)
    v, X = _unpack(θ, (sum(NS_HORIZON),), (S, T))
    kernel = TimeVarying(_columns(v, NS_HORIZON), ComposableRecurrences.Primary())
    return sum(WS .* w(Convolution(kernel))(X))
end

# The same columns as views into the parameters, read by output time with
# a history: a kernel held as the caller's columns, without a copy.
function _delay_ragged_views(w, θ)
    v, X, H = _unpack(θ, (sum(NS_HORIZON),), (S, T), (S, 2))
    o = cumsum([0; NS_HORIZON])
    kernel = TimeVarying([view(v, (o[τ] + 1):o[τ + 1]) for τ in 1:T])
    return sum(WS .* w(Convolution(kernel))(X; history = H))
end

# Each infector keeps the kernel of its own infection time, of a length
# that varies with that time; times with an empty column do not transmit.
const NS_CYCLE = [mod(τ, L + 1) for τ in 1:T]
function _primary_ragged(w, θ)
    v, logh, logR = _unpack(θ, (sum(NS_CYCLE),), (S, L), (S, T))
    kernel = TimeVarying(_columns(v, NS_CYCLE), ComposableRecurrences.Primary())
    y = w(Recurrence(kernel; coupling = K0))(exp.(logR); history = exp.(logh), start = L + 1)
    return sum(WS[:, (L + 1):end] .* y)
end

# A pool of susceptibles `S` and protected `V`, drawn from at weight `σ` on
# `V`, with the doses moving `S` into `V` and any further `flows`.
function _leaky(N, doses, σ, flows...)
    CR = ComposableRecurrences
    return CR.Pool(
        N; pools = (:S, :V), draw = (:S => 1, :V => σ) => CR.Hazard(),
        flows = (CR.Flow(:S => :V, doses; form = CR.Truncate()), flows...)
    )
end

# Leaky vaccination: removals move susceptibles into a protected pool drawn
# from at relative susceptibility σ. The doses stay below the pools, away
# from the removal cap.
function _vaccination(w, θ)
    logh, logR, doses, σ = _unpack(θ, (S, L), (S, T), (S, T), (1,))
    d = _leaky(PerStratum(POP), TimeVarying(PerStratum(doses)), only(σ))
    r = Recurrence(G0; coupling = K0, modifiers = (d,))
    y = w(r)(exp.(logR); history = exp.(logh))
    return sum(WS .* log.(y))
end

# Herd turnover: the population varies over time and births enter the pool
# as negative removals. The default pool is the population at time 1.
function _turnover(w, θ)
    logh, logR, logN, births = _unpack(θ, (S, L), (S, T), (S, L + T), (S, L + T))
    d = ComposableRecurrences.Depletion(
        TimeVarying(PerStratum(exp.(logN)));
        removals = TimeVarying(PerStratum(-births))
    )
    r = Recurrence(G0; coupling = K0, modifiers = (d,))
    y = w(r)(exp.(logR); history = exp.(logh))
    return sum(WS .* log.(y))
end

# Waning protection: leaky vaccination into a protected pool that wanes
# back to the susceptible pool at a rate per stratum and time. The doses
# and the rate are `Derived` from their logs, so the scenario also covers
# derived removals and a derived flow rate.
function _waning(w, θ)
    logh, logR, logd, σ, logω = _unpack(θ, (S, L), (S, T), (S, T), (1,), (S, T))
    CR = ComposableRecurrences
    d = _leaky(
        PerStratum(POP), Derived(exp, TimeVarying(PerStratum(logd))), only(σ),
        CR.Flow(:V => :S, Derived(exp, TimeVarying(PerStratum(logω))))
    )
    r = Recurrence(G0; coupling = K0, modifiers = (d,))
    y = w(r)(exp.(logR); history = exp.(logh))
    return sum(WS .* log.(y))
end

# Wards in each stratum: suspected patients (compartment 1) are confirmed
# at a rate or ruled out as a share; confirmed patients (compartment 2) are
# discharged at a rate and transferred out in counts. Admissions enter both.
function _ward(w, θ)
    adm, confirm, ruleout, discharge, transfer = _unpack(
        θ, (2S, T), (S,), (T,), (1,), (S, T)
    )
    CR = ComposableRecurrences
    flows = CR.Pool(;
        pools = (:suspected, :confirmed), draw = nothing, flows = (
            CR.Flow(:suspected => :confirmed, PerStratum(confirm)),
            CR.Flow(:suspected => 0, TimeVarying(ruleout); form = CR.Share()),
            CR.Flow(:confirmed => 0, only(discharge)),
            CR.Flow(
                :confirmed => 0, TimeVarying(PerStratum(transfer));
                form = CR.Truncate()
            ),
        )
    )
    r = Recurrence([1.0]; modifiers = (flows,))
    y = w(r)(; history = zeros(2S, 1), add = adm, stop = T)
    return sum([WS; WS] .* y)
end

# A negative binomial probability generating function iterated per
# stratum, mixed by the coupling, with per-stratum dispersion and
# probability.
_pgf(q, θ) = (θ.p / (1 - (1 - θ.p) * q))^θ.r
function _transform(w, θ)
    r, p = _unpack(θ, (S,), (S,))
    m = ComposableRecurrences.Transform(
        _pgf, (; r = PerStratum(r), p = PerStratum(p))
    )
    q = w(Recurrence([1.0]; coupling = K0, modifiers = (m,)))(
        ; history = zeros(S, 1), stop = T
    )
    return sum(WS .* q)
end

# A pool emptied after the first step with a differentiated heterogeneity.
# At `α = 1` the pool power is `0^0`, whose exponent tangent is `log(0)`
# unless the power avoids it.
# A removal larger than the pool takes what remains, so the pool is exactly
# empty from the second step on.
# A pool that starts empty would not do: rule testers perturb the starting
# pool itself, and a negative share has no real power.
# Imports added after the depletion keep the value drawn positive, so a
# perturbed `α < 1` gives an infinite hazard on the empty pool, not
# `0 * Inf`.
# The parameters are offsets from `α = 1`, a starting pool of 50 and a
# removal of 1000, so compiled ReverseDiff tapes, recorded at zero, take the
# branches of the scenario point.
function _empty_pool(w, θ)
    d = ComposableRecurrences.Depletion(
        100.0; heterogeneity = 1 + θ[1], pool0 = 50 + θ[2],
        removals = 1000 + θ[3]
    )
    mods = (d, ComposableRecurrences.Add(1.0))
    y = w(Recurrence(G0; modifiers = mods))(fill(2.0, T); history = fill(5.0, L))
    return sum(W1 .* y)
end

# A modifier parameter derived from a time-varying parameter and a scalar:
# imports scaled by κ, and a per-stratum, time-varying multiplier.
function _derived(w, θ)
    logh, logR, logι, κ, a = _unpack(θ, (S, L), (S, T), (T,), (1,), (S, T))
    imports = only(κ) * Derived(exp, TimeVarying(logι))
    scale = Derived((x, c) -> c / (1 + x^2), TimeVarying(PerStratum(a)), only(κ))
    mods = (
        ComposableRecurrences.Add(imports), ComposableRecurrences.Transform(*, scale),
    )
    y = w(Recurrence(G0; coupling = K0, modifiers = mods))(exp.(logR); history = exp.(logh))
    return sum(WS .* log.(y))
end

# Imports moved between strata, imports added and the values capped per
# stratum: the cap binds on strata 1 and 2 throughout and never on stratum
# 3, with a margin that keeps finite differences off the kink.
# The parameters are offsets from `CRA0`, so the scenario starts at zero.
# Compiled ReverseDiff tapes keep the branches taken where they were
# recorded, and the harness records them at zero parameters: there the cap
# would bind on every stratum.
const HI = [2.8, 3.2, 100.0]
const CRA0 = _flat(
    [0.0 0.2 0.1; 0.1 0.0 0.3; 0.2 0.1 0.0], [0.4, 0.3, 0.2],
    0.2 .+ 0.1 .* abs.(WS), HI, fill(log(5.0), S, L), LOGR,
)
function _clamp_redistribute_add(w, θ)
    K, ε, B, hi, logh, logR = _unpack(
        CRA0 .+ θ, (S, S), (S,), (S, T), (S,), (S, L), (S, T)
    )
    mods = (
        ComposableRecurrences.Redistribute(K, PerStratum(ε)),
        ComposableRecurrences.Add(TimeVarying(PerStratum(B))),
        ComposableRecurrences.Clamp(0.0, PerStratum(hi)),
    )
    y = w(Recurrence(G0; coupling = K0, modifiers = mods))(exp.(logR); history = exp.(logh))
    return sum(WS .* log.(y))
end

# The capacity scenarios' parameters are offsets from a base vector, so they
# start at zero, as `TRUNC0` below. Scalars are indexed from the sum: built
# from `only` of a view, a capacity pool makes Enzyme reverse fail with an
# `EnzymeNoShadowError` in the `Recurrence` constructor.
const GCAP = [0.5, 1.0, 1.0] .* G0'

# A bed cap on stratum 1 with its overflow in stratum 2, smoothed so finite
# differences see no kink; admitted cases transmit less. A share of the beds
# empties before each step's admissions fill them.
const CAPS0 = _flat(fill(log(5.0), 2, L), 0.5 .+ LOGR[1:2, :], [log(12.0)], [0.2], [0.1])
function _capacity_beds(w, θ)
    x = CAPS0 .+ θ
    logh, logR = _unpack(x, (2, L), (2, T))
    n = length(x)
    CR = ComposableRecurrences
    beds = CR.Pool(
        exp(x[n - 2]); pools = (:O,), draw = CR.SoftTruncate(x[n]) => :O,
        flows_first = true, flows = CR.Flow(:O => 0, x[n - 1]; form = CR.Share()),
        overflow = :stratum
    )
    r = Recurrence(PerStratum(GCAP[1:2, :]); modifiers = (beds,))
    y = w(r)(exp.(logR); history = exp.(logh))
    return sum(WS[1:2, :] .* log.(y))
end

# A weekly budget per stratum, carried over, with unserved demand queued for
# the next step: the grants are a flow into each allowance at each week's
# start.
const CAPB0 = _flat(
    fill(log(5.0), S, L), 0.5 .+ LOGR,
    [log(9.0 + p + 0.5 * sin(t)) for p in 1:S, t in 1:(L + T)], [1.0, 2.0, 0.5],
)
const WEEKS = [t > L && rem(t - L - 1, 4) == 0 for p in 1:S, t in 1:(L + T)]
function _capacity_budget(w, θ)
    logh, logR, logb, init = _unpack(CAPB0 .+ θ, (S, L), (S, T), (S, L + T), (S,))
    CR = ComposableRecurrences
    grants = WEEKS .* exp.(logb)
    doses = CR.Pool(;
        pools = (:B,), initial = PerStratum(collect(init)),
        draw = :B => CR.Truncate(), flows_first = true, overflow = :queue,
        flows = CR.Flow(0 => :B, TimeVarying(PerStratum(grants)); form = CR.Truncate())
    )
    r = Recurrence(PerStratum(GCAP); modifiers = (doses,))
    y = w(r)(exp.(logR); history = exp.(logh))
    return sum(WS .* y)
end

# A pool that runs low, drawn with the smooth truncation, then a bed cap per
# stratum whose overflow is dropped: the pool, softness and beds are
# parameters.
const CAPD0 = _flat(
    fill(log(5.0), S, L), 0.5 .+ LOGR,
    [log(500.0), 0.15, log(8.0), log(20.0), log(6.0)]
)
function _capacity_drop(w, θ)
    x = CAPD0 .+ θ
    logh, logR = _unpack(x, (S, L), (S, T))
    n = length(x)
    CR = ComposableRecurrences
    pool = CR.Depletion(exp(x[n - 4]), CR.SoftTruncate(x[n - 3]))
    beds = CR.Pool(
        PerStratum(exp.(x[(n - 2):n])); pools = (:O,),
        draw = CR.SoftTruncate(0.2) => :O, flows_first = true,
        flows = CR.Flow(:O => 0, 0.3; form = CR.Share())
    )
    r = Recurrence(PerStratum(GCAP); modifiers = (pool, beds))
    y = w(r)(exp.(logR); history = exp.(logh))
    return sum(WS .* log.(y))
end

# Depletion that draws up to a small pool per stratum, so the pools run out
# within the run: exact, and smooth with its softness differentiated. The
# parameters are offsets from `TRUNC0`, so the scenarios start at zero:
# compiled ReverseDiff tapes keep the branches taken where they are
# recorded, which the harness does at zero parameters.
const TRUNC0 = _flat(fill(log(5.0), S, L), 0.5 .+ LOGR, log.([40.0, 60.0, 300.0]), [0.1])
function _truncate(w, θ)
    x = TRUNC0[1:length(θ)] .+ θ
    logh, logR, logpool = _unpack(x, (S, L), (S, T), (S,))
    d = ComposableRecurrences.Depletion(
        PerStratum(exp.(logpool)), ComposableRecurrences.Truncate()
    )
    y = w(Recurrence(G0; coupling = K0, modifiers = (d,)))(exp.(logR); history = exp.(logh))
    return sum(WS .* y)
end
function _soft_truncate(w, θ)
    x = TRUNC0 .+ θ
    logh, logR, logpool = _unpack(x, (S, L), (S, T), (S,))
    form = ComposableRecurrences.SoftTruncate(x[length(x)])
    d = ComposableRecurrences.Depletion(PerStratum(exp.(logpool)), form)
    y = w(Recurrence(G0; coupling = K0, modifiers = (d,)))(exp.(logR); history = exp.(logh))
    return sum(WS .* y)
end

# Every float in single precision: the kernel, coupling, history and gain.
const K0F, WSF = Float32.(K0), Float32.(WS)
function _float32(w, θ)
    g, logh, logR = _unpack(θ, (L,), (S, L), (S, T))
    y = w(Recurrence(g; coupling = K0F))(exp.(logR); history = exp.(logh))
    return sum(WSF .* log.(y))
end

# Vaccination into a protected pool, every float in single precision and the
# protected pool starting from its default.
const POPF = Float32.(POP)
function _protected_float32(w, θ)
    logh, logR, doses, σ = _unpack(θ, (S, L), (S, T), (S, T), (1,))
    d = _leaky(PerStratum(POPF), TimeVarying(PerStratum(doses)), only(σ))
    r = Recurrence(G0F; coupling = K0F, modifiers = (d,))
    y = w(r)(exp.(logR); history = exp.(logh))
    return sum(WSF .* log.(y))
end

# A fixed kernel per stratum, with history.
function _conv_per_stratum(w, θ)
    G, X, H = _unpack(θ, (S, L + 1), (S, T), (S, L))
    return sum(WS .* w(Convolution(PerStratum(G)))(X; history = H))
end

# Coefficients given by change points: the generation interval shortens
# from day 6 and again from day 10, mixed by a coupling.
function _piecewise_kernel(w, θ)
    g1, g2, g3, logh, logR = _unpack(θ, (L,), (L,), (L - 1,), (S, L), (S, T))
    kernel = TimeVarying([1 => g1, 6 => g2, 10 => g3])
    y = w(Recurrence(kernel; coupling = K0))(exp.(logR); history = exp.(logh))
    return sum(WS .* log.(y))
end

# Each infector keeps the kernel of its infection time, per stratum, from
# change points; seeded at times 1 to L.
function _piecewise_primary(w, θ)
    G1, G2, logh, logR = _unpack(θ, (S, L), (S, L), (S, L), (S, T))
    kernel = TimeVarying(
        [1 => PerStratum(G1), 7 => PerStratum(G2)], ComposableRecurrences.Primary()
    )
    r = w(Recurrence(kernel; coupling = K0))
    y = r(exp.(logR); history = exp.(logh), start = L + 1)
    return sum(WS[:, (L + 1):end] .* log.(y))
end

# A delay that lengthens from day 5, read by output time with a history.
function _piecewise_delay(w, θ)
    g1, g2, X, H = _unpack(θ, (L,), (L + 1,), (S, T), (S, 2))
    kernel = TimeVarying([1 => g1, 5 => g2])
    return sum(WS[:, 3:end] .* w(Convolution(kernel))(X; history = H, start = 3))
end

# A delay per input time that changes on days 4 and 9.
function _piecewise_delay_primary(w, θ)
    g1, g2, g3, X = _unpack(θ, (L,), (L,), (L,), (S, T))
    kernel = TimeVarying([1 => g1, 4 => g2, 9 => g3], ComposableRecurrences.Primary())
    return sum(WS .* w(Convolution(kernel))(X))
end

# A travel cut from day 7: the coupling changes once.
function _piecewise_coupling(w, θ)
    C1, C2, logh, logR = _unpack(θ, (S, S), (S, S), (S, L), (S, T))
    r = Recurrence(G0; coupling = TimeVarying([1 => C1, 7 => C2]))
    y = w(r)(exp.(logR); history = exp.(logh))
    return sum(WS .* log.(y))
end

# Importations that step down on day 8, one number shared by every stratum,
# and a per-stratum one that steps up on day 5.
function _piecewise_parameter(w, θ)
    a, b1, b2, logh, logR = _unpack(θ, (2,), (S,), (S,), (S, L), (S, T))
    mods = (
        ComposableRecurrences.Add(TimeVarying([1 => a[1], 8 => a[2]])),
        ComposableRecurrences.Add(TimeVarying([1 => PerStratum(b1), 5 => PerStratum(b2)])),
    )
    r = Recurrence(G0; coupling = K0, modifiers = mods)
    y = w(r)(exp.(logR); history = exp.(logh))
    return sum(WS .* log.(y))
end

# A long delay on a long series, with history: the default `Auto()`
# method takes the transform under a native rule. Its `NoAdjoint` twin
# takes the method a traced call gets, which depends on the backend and
# the Julia version: the direct method, or the transform through its own
# Enzyme rules on Julia 1.11.
const LA, TA = 300, 1000
const WA = [cos(0.1 * t) for t in 1:TA]
function _conv_auto(w, θ)
    g, x, h = _unpack(θ, (LA,), (TA,), (5,))
    return sum(WA .* w(Convolution(g))(x; history = h))
end

# The same delay on a series spanning 22 orders of magnitude, under a log:
# the default method takes the direct sums the transform cannot give to a
# relative 1e-10.
const XW = 10.0 .^ range(-22, 0; length = TA)
function _conv_auto_wide(w, θ)
    g, x = _unpack(θ, (LA,), (TA,))
    return sum(WA .* log.(w(Convolution(g))(x)))
end

# The same delay on an epidemic curve: a few early outputs are taken
# directly, one by one, and the rest by the transform.
const XE = [10 * exp(0.01 * t) * (1 + 0.2 * sin(t / 7)) for t in 1:TA]
function _conv_auto_epidemic(w, θ)
    g, x = _unpack(θ, (LA,), (TA,))
    return sum(WA .* w(Convolution(g))(x))
end

# Two routes: a dense coupling with a short kernel, and a sparse coupling
# with a longer one.
function _routes(w, θ)
    K, g1, v, g2, logh, logR = _unpack(
        θ, (S, S), (L - 1,), (length(KS.nzval),), (L,), (S, L), (S, T)
    )
    Ks = SparseMatrixCSC(S, S, KS.colptr, KS.rowval, collect(v))
    r = Recurrence(Routes((K, g1), (Ks, g2)))
    return sum(WS .* log.(w(r)(exp.(logR); history = exp.(logh))))
end

# Routes on scaled identities, which fold into one summed kernel.
function _routes_folded(w, θ)
    λ, g1, g2, logh, logR = _unpack(θ, (2,), (L - 1,), (L,), (S, L), (S, T))
    r = Recurrence(Routes((λ[1] * I, g1), (λ[2] * I, g2)))
    return sum(WS .* log.(w(r)(exp.(logR); history = exp.(logh))))
end

# A pointwise modifier that passes the value through and asks for a buffer
# `w` steps deep, deeper than the kernel. Releases before `depth` have no
# such buffer, so the method is defined only where they do.
struct DeepBuffer
    w::Int
end
ComposableRecurrences.ispointwise(::DeepBuffer) = true
function ComposableRecurrences.forward(
        ::DeepBuffer, ::ComposableRecurrences.Step, v, s, t, k
    )
    return v, s
end
if isdefined(ComposableRecurrences, :depth)
    ComposableRecurrences.depth(m::DeepBuffer) = m.w
end

# A coupled renewal whose buffer is twice the kernel length, seeded from a
# history as long as the buffer.
function _deep_buffer(w, θ)
    g, K, logh, logR = _unpack(θ, (L,), (S, S), (S, 2L), (S, T))
    r = Recurrence(g; coupling = K, modifiers = (DeepBuffer(2L),))
    y = w(r)(exp.(logR); history = exp.(logh))
    return sum(WS .* log.(y))
end

# Transmission scaled down by recent incidence: the gain multiplier reads
# the last `L + 2` outputs through weights that are themselves parameters.
function _recent_feedback(w, θ)
    g, κ, wts, logh, logR = _unpack(θ, (L,), (1,), (L + 2,), (S, L + 2), (S, T))
    β = Derived(exp, -κ[1] * ComposableRecurrences.Recent(wts))
    r = Recurrence(g; coupling = K0, modifiers = (ComposableRecurrences.Transform(*, β),))
    y = w(r)(exp.(logR); history = exp.(logh))
    return sum(WS .* log.(y))
end

# Ring vaccination: removals from the susceptible pool scale with the sum of
# the last week's cases. The scale is read from `θ` directly: Enzyme reverse
# finds no shadow for a scalar read from a reshaped view of `θ` and passed
# through the `Depletion` keyword constructor.
function _recent_removals(w, θ)
    logh, logR = _unpack(view(θ, 2:length(θ)), (S, 7), (S, T))
    dep = ComposableRecurrences.Depletion(
        PerStratum(10 .* POP); removals = θ[1] * ComposableRecurrences.Recent(7)
    )
    r = Recurrence(G0; coupling = K0, modifiers = (dep,))
    y = w(r)(exp.(logR); history = exp.(logh))
    return sum(WS .* log.(y))
end

# Each stratum responds to the recent incidence it sees through a contact
# matrix that is itself a parameter.
function _recent_coupled(w, θ)
    C, logh, logR = _unpack(θ, (S, S), (S, 6), (S, T))
    β = Derived(exp, -0.02 * ComposableRecurrences.Recent(6; coupling = C))
    r = Recurrence(G0; modifiers = (ComposableRecurrences.Transform(*, β),))
    y = w(r)(exp.(logR); history = exp.(logh))
    return sum(WS .* log.(y))
end

# Dense and sparse routes in a buffer twice the longest route kernel.
function _routes_deep(w, θ)
    K, g1, v, g2, logh, logR = _unpack(
        θ, (S, S), (L - 1,), (length(KS.nzval),), (L,), (S, 2L), (S, T)
    )
    Ks = SparseMatrixCSC(S, S, KS.colptr, KS.rowval, collect(v))
    r = Recurrence(Routes((K, g1), (Ks, g2)); modifiers = (DeepBuffer(2L),))
    return sum(WS .* log.(w(r)(exp.(logR); history = exp.(logh))))
end

# The relative tolerance of Enzyme's rule tester in `test_adjoint`.
# EnzymeTestUtils compares the rule with finite differences taken in the
# arguments' precision. In single precision these differ from the rule by up
# to about 5e-4 relative (on a Float32 history with Float64 gains), so an
# entry with Float32 values carries `FLOAT32_RTOL`.
const ENZYME_RTOL = 1.0e-7
const FLOAT32_RTOL = 1.0e-3
const _F32 = (; enzyme_rtol = FLOAT32_RTOL)

"""
    enzyme_rtol(entry)

The tolerance `test_adjoint` gives Enzyme's rule tester on the operator of
`entry`: its optional fourth element's `enzyme_rtol`, else `ENZYME_RTOL`.
"""
enzyme_rtol(entry) = length(entry) > 3 ? entry[4].enzyme_rtol : ENZYME_RTOL

# `(name, loss, θ0)`, with an optional fourth element of test options (see
# `enzyme_rtol`); every scenario also runs as its `NoAdjoint` twin.
# test/ad/adjoints.jl runs each scenario's operator through `test_adjoint`
# and checks that its rule fires, so a scenario added here is covered there.
const _SCENARIOS = [
    ("Recurrence renewal", _renewal, () -> _flat(G0, zeros(L), LOGR[1, :])),
    (
        "Recurrence strata, coupling and depletion", _renewal_strata,
        () -> _flat(G0, K0, fill(log(5.0), S, L), LOGR),
    ),
    (
        "Recurrence depletion with a differentiated heterogeneity",
        _heterogeneity_hazard, () -> _flat([1.3], fill(log(5.0), S, L), LOGR),
    ),
    (
        "Recurrence floored depletion with a differentiated heterogeneity",
        _heterogeneity_floor, () -> _flat([1.3], fill(log(5.0), S, L), LOGR),
    ),
    (
        "Recurrence scalar modifier field, mixed eltypes", _scalar_field_mixed,
        () -> _flat([80.0], 0.3 .+ LOGR), _F32,
    ),
    (
        "Recurrence array-field and scalar-field modifiers",
        _array_and_scalar_fields,
        () -> _flat([0.5], fill(log(5.0), S, L), 0.3 .+ LOGR),
    ),
    (
        "Recurrence vaccination into a protected pool", _vaccination,
        () -> _flat(zeros(S, L), 0.3 .+ LOGR, 1 .+ 0.5 .* abs.(LOGR), [0.3]),
    ),
    (
        "Recurrence waning protection (Pool flows)", _waning,
        () -> _flat(
            zeros(S, L), 0.3 .+ LOGR, log.(1 .+ 0.5 .* abs.(LOGR)), [0.3],
            log.(0.05 .+ 0.02 .* abs.(LOGR)),
        ),
    ),
    (
        "Recurrence ward with competing flows (Pool without a draw)", _ward,
        () -> _flat(
            [10 .+ 2 .* sin.(LOGR); 1 .+ cos.(LOGR)], [0.3, 0.4, 0.5],
            0.2 .+ 0.05 .* sin.(1:T), [0.1], 0.5 .+ 0.2 .* abs.(LOGR),
        ),
    ),
    (
        "Recurrence protected pool in Float32", _protected_float32,
        () -> Float32.(_flat(zeros(S, L), 0.3 .+ LOGR, 1 .+ 0.5 .* abs.(LOGR), [0.3])),
        _F32,
    ),
    (
        "Recurrence grouped totals (Allocate)", _allocate,
        () -> _flat(
            G0, fill(log(5.0), S, L), LOGR, [log(8.0 + p + t) for p in 1:2, t in 1:T]
        ),
    ),
    (
        "Recurrence grouped totals with imports and a spill (Allocate)",
        _allocate_imports,
        () -> _flat(
            G0, fill(log(5.0), S, L), LOGR,
            [log(8.0 + p + t) for p in 1:2, t in 1:T],
            [0.1 + 0.05 * p + 0.01 * t for p in 1:2, t in 1:T],
            [0.0 0.0 0.6; 0.0 0.0 0.4; 0.3 0.7 0.0],
            [0.0 0.8 0.0; 0.9 0.0 0.0; 0.1 0.2 0.0], [0.1, 0.2, 0.3],
        ),
    ),
    (
        "Recurrence dense coupling, Redistribute and imports as Matrix",
        _dense_matrices,
        () -> _flat(
            G0, K0, fill(log(5.0), S, L), LOGR,
            [log(8.0 + p + t) for p in 1:2, t in 1:T],
            [0.0 0.0 0.6; 0.0 0.0 0.4; 0.3 0.7 0.0],
            [0.0 0.8 0.0; 0.9 0.0 0.0; 0.1 0.2 0.0], [0.1, 0.2, 0.3],
        ),
    ),
    (
        "Recurrence grouped totals with time-varying imports (Allocate)",
        _allocate_imports_time_varying,
        () -> _flat(
            G0, fill(log(5.0), S, L), LOGR, [0.2],
            repeat([0.0 0.0 0.6; 0.0 0.0 0.4; 0.3 0.7 0.0], 1, 1, T) .+
                0.01 .* reshape(1:(S * S * T), S, S, T),
        ),
    ),
    (
        "Recurrence sparse coupling", _sparse,
        () -> _flat(KS.nzval, zeros(S, L), 1 .+ LOGR),
    ),
    (
        "Recurrence per-stratum kernel, Diagonal coupling", _diagonal,
        () -> _flat([0.9, 1.0, 1.1], repeat(G0', S), zeros(S, L), 1 .+ LOGR),
    ),
    (
        "Recurrence pairwise kernel", _pairwise,
        () -> _flat(fill(0.1, S, S, L), zeros(S, L), 1 .+ LOGR),
    ),
    (
        "Recurrence time-varying kernel and coupling", _time_varying,
        () -> _flat(repeat(G0, 1, T), repeat(K0, 1, 1, T), zeros(S, L), LOGR),
    ),
    (
        "Recurrence Primary time-varying kernel", _primary,
        () -> _flat(
            [G0[i] * (1 - 0.3 * (c > T ÷ 2)) for a in 1:S, i in 1:L, c in 1:T],
            fill(log(5.0), S, L), LOGR,
        ),
    ),
    (
        "Recurrence returning its state", _with_state,
        () -> _flat(G0, fill(log(5.0), S, L), LOGR),
    ),
    (
        "Recurrence seeded on a growth path", _growth_seed,
        () -> _flat(log.([5.0, 2.0, 1.0]), [0.1], LOGR),
    ),
    (
        "Recurrence returning its state after its seed", _with_state_prepend,
        () -> _flat(fill(log(5.0), S, L), LOGR),
    ),
    (
        "Convolution delay with history", _delay,
        () -> _flat([0.0; G0], ones(L), 1 .+ LOGR[1, :]),
    ),
    (
        "Convolution time-varying kernel", _delay_varying,
        () -> _flat(fill(0.25, S, L, T), 1 .+ LOGR),
    ),
    (
        "Convolution time-varying kernel indexed by output", _delay_varying_secondary,
        () -> _flat(fill(0.25, L, T), 1 .+ LOGR, ones(S, 2)),
    ),
    (
        "Convolution ragged kernel truncated at the horizon", _delay_ragged,
        () -> _flat(
            [0.2 + 0.1 * sin(τ + i) for τ in 1:T for i in 1:NS_HORIZON[τ]], 1 .+ LOGR
        ),
    ),
    (
        "Convolution ragged kernel of views into the parameters", _delay_ragged_views,
        () -> _flat(
            [0.2 + 0.1 * sin(τ + i) for τ in 1:T for i in 1:NS_HORIZON[τ]], 1 .+ LOGR,
            ones(S, 2),
        ),
    ),
    (
        "Convolution with gain and add", _conv_gain,
        () -> _flat(G0, LOGR, W1, 1 .+ LOGR, ones(S, 2)),
    ),
    (
        "Convolution lag contributions", _triangle,
        () -> _flat(fill(0.25, L, T), 1 .+ LOGR, [0.4]),
    ),
    (
        "Recurrence ragged Primary kernel", _primary_ragged,
        () -> _flat(
            [G0[i] * (1 + 0.1 * cos(τ)) for τ in 1:T for i in 1:NS_CYCLE[τ]],
            fill(log(5.0), S, L), LOGR,
        ),
    ),
    (
        "Recurrence Transform with per-stratum parameters", _transform,
        () -> _flat([0.5, 0.6, 0.7], [0.2, 0.3, 0.4]),
    ),
    (
        "Recurrence population varying over time with births", _turnover,
        () -> _flat(
            fill(log(5.0), S, L), LOGR,
            [log(POP[k] + 2t) for k in 1:S, t in 1:(L + T)],
            [1.0 + 0.5 * sin(k + t) for k in 1:S, t in 1:(L + T)],
        ),
    ),
    (
        "Recurrence empty pool with a differentiated heterogeneity", _empty_pool,
        () -> zeros(3),
    ),
    (
        "Recurrence Derived modifier parameters", _derived,
        () -> _flat(zeros(S, L), LOGR, W1 .- 1, [0.8], 0.5 .* WS),
    ),
    (
        "Recurrence Redistribute, Add and Clamp", _clamp_redistribute_add,
        () -> zero(CRA0),
    ),
    (
        "Recurrence capacity, beds with overflow", _capacity_beds,
        () -> zero(CAPS0),
    ),
    (
        "Recurrence capacity, weekly budget with a queue", _capacity_budget,
        () -> zero(CAPB0),
    ),
    (
        "Recurrence capacity, dropped overflow after a truncated draw",
        _capacity_drop, () -> zero(CAPD0),
    ),
    (
        "Recurrence depletion with truncated draws", _truncate,
        () -> zeros(length(TRUNC0) - 1),
    ),
    (
        "Recurrence depletion with smoothly truncated draws", _soft_truncate,
        () -> zero(TRUNC0),
    ),
    (
        "Recurrence in Float32", _float32,
        () -> Float32.(_flat(G0, fill(log(5.0), S, L), LOGR)), _F32,
    ),
    (
        "Recurrence routes folded on scaled identities", _routes_folded,
        () -> _flat([0.7, 0.4], G0[1:(L - 1)], G0, zeros(S, L), LOGR),
    ),
    (
        "Recurrence routes, dense and sparse", _routes,
        () -> _flat(K0, G0[1:(L - 1)], 0.5 .* KS.nzval, G0, zeros(S, L), LOGR),
    ),
    (
        "Recurrence routes in a buffer deeper than the kernels", _routes_deep,
        () -> _flat(
            K0, G0[1:(L - 1)], 0.5 .* KS.nzval, G0, fill(log(5.0), S, 2L), LOGR
        ),
    ),
    (
        "Recurrence with a buffer deeper than the kernel", _deep_buffer,
        () -> _flat(G0, K0, fill(log(5.0), S, 2L), LOGR),
    ),
    (
        "Recurrence feedback from recent outputs", _recent_feedback,
        () -> _flat(G0, [0.05], exp.(-0.3 .* (1:(L + 2))), fill(log(5.0), S, L + 2), LOGR),
    ),
    (
        "Recurrence removals from recent outputs", _recent_removals,
        () -> _flat([0.1], fill(log(5.0), S, 7), LOGR),
    ),
    (
        "Recurrence feedback from recent outputs across strata", _recent_coupled,
        () -> _flat(K0, fill(log(5.0), S, 6), LOGR),
    ),
    (
        "Convolution per-stratum kernel with history", _conv_per_stratum,
        () -> _flat(repeat([0.0; G0]', S) .* [0.9, 1.0, 1.1], 1 .+ LOGR, ones(S, L)),
    ),
    (
        "Recurrence kernel from change points", _piecewise_kernel,
        () -> _flat(G0, 0.8 .* G0, G0[1:(L - 1)], fill(log(5.0), S, L), LOGR),
    ),
    (
        "Recurrence Primary per-stratum kernel from change points", _piecewise_primary,
        () -> _flat(
            repeat(G0', S), 0.7 .* repeat(G0', S) .* [0.9, 1.0, 1.1],
            fill(log(5.0), S, L), LOGR,
        ),
    ),
    (
        "Convolution kernel from change points with history", _piecewise_delay,
        () -> _flat(G0, [0.0; G0], 1 .+ LOGR, ones(S, 2)),
    ),
    (
        "Convolution Primary kernel from change points", _piecewise_delay_primary,
        () -> _flat(G0, 0.5 .* G0, reverse(G0), 1 .+ LOGR),
    ),
    (
        "Recurrence coupling from change points", _piecewise_coupling,
        () -> _flat(K0, 0.6 .* K0, zeros(S, L), LOGR),
    ),
    (
        "Recurrence parameters from change points", _piecewise_parameter,
        () -> _flat([0.3, 0.1], [0.1, 0.2, 0.3], [0.4, 0.2, 0.1], zeros(S, L), LOGR),
    ),
    (
        "Convolution long kernel by the automatic method", _conv_auto,
        () -> _flat(
            [exp(-0.05 * l) / 20 for l in 1:LA], [1.0 + 0.5 * sin(t) for t in 1:TA],
            ones(5),
        ),
    ),
    (
        "Convolution wide-range series by the automatic method", _conv_auto_wide,
        () -> _flat([exp(-0.05 * l) / 20 for l in 1:LA], XW),
    ),
    (
        "Convolution epidemic curve by the automatic method", _conv_auto_epidemic,
        () -> _flat([exp(-0.05 * l) / 20 for l in 1:LA], XE),
    ),
]

# Delays given as distributions: the gradient reaches each distribution's
# parameters through its masses on lags `0:L`.
function _delay_distribution(w, θ)
    logλ, w0, ϵ = _unpack(θ, (1,), (L,), (T,))
    c = Convolution(Poisson(exp(only(logλ))); lags = L + 1)
    return sum(W1 .* w(c)(ϵ; history = w0))
end

function _generation_distribution(w, θ)
    logr, logitp, logh, logR = _unpack(θ, (1,), (1,), (S, L), (S, T))
    p = 1 / (1 + exp(-only(logitp)))
    ds = [NegativeBinomial(a * exp(only(logr)), p) for a in (1.0, 1.5, 2.0)]
    r = Recurrence(PerStratum(ds); lags = L + 1, coupling = K0)
    y = w(r)(exp.(logR); history = exp.(logh))
    return sum(WS .* log.(y))
end

push!(
    _SCENARIOS,
    (
        "Convolution Poisson delay distribution", _delay_distribution,
        () -> _flat([log(1.5)], ones(L), 1 .+ LOGR[1, :]),
    ),
    (
        "Recurrence negative binomial generation interval per stratum", _generation_distribution,
        () -> _flat([log(3.0)], [0.2], fill(log(5.0), S, L), LOGR),
    ),
)

"""
    supports(features...)

Whether the loaded ComposableRecurrences has every feature in `features`: a
name it defines, or a key of `_PROBES` whose probe passes.

The benchmark history workflow runs this registry, as on `main`, against the
last few tagged releases.
A scenario that needs a feature newer than the oldest of those lists it in
`_REQUIRES`, and is left out where the loaded version lacks it.
"""
supports(features::Symbol...) = all(_supports, features)
function _supports(feature::Symbol)
    haskey(_PROBES, feature) && return _PROBES[feature]()
    return isdefined(ComposableRecurrences, feature)
end

# Features that came without a name of their own, found by trying them.
# `Primary` predates its use in a Recurrence, which older releases reject
# at construction.
function _accepts(build)
    try
        build()
    catch
        return false
    end
    return true
end
const _PROBES = Dict{Symbol, Function}(
    :primary_recurrence => () -> _accepts(
        () -> Recurrence(TimeVarying(ones(1, 2), ComposableRecurrences.Primary()))
    ),
    :removals => () -> _accepts(
        () -> ComposableRecurrences.Depletion(1.0; removals = 1.0)
    ),
    # A `Pool` whose draw fills a pool up to a capacity.
    :pool_fill => () -> _accepts(
        () -> ComposableRecurrences.Pool(
            1.0; pools = (:O,), draw = ComposableRecurrences.Truncate() => :O
        )
    ),
)

# The features each scenario needs beyond the first release, by scenario
# name. A scenario not listed needs none. Add an entry with each scenario
# that uses a new feature, named by a public or internal name that came
# with it, e.g. `"..." => (:Transform,)`.
const _REQUIRES = Dict{String, Tuple{Vararg{Symbol}}}(
    "Recurrence grouped totals (Allocate)" => (:Allocate,),
    "Recurrence grouped totals with imports and a spill (Allocate)" =>
        (:_AllocateImports,),
    "Recurrence grouped totals with time-varying imports (Allocate)" =>
        (:_AllocateImports,),
    "Recurrence dense coupling, Redistribute and imports as Matrix" =>
        (:_AllocateImports,),
    "Recurrence capacity, beds with overflow" => (:pool_fill,),
    "Recurrence capacity, weekly budget with a queue" => (:pool_fill,),
    "Recurrence capacity, dropped overflow after a truncated draw" => (:pool_fill,),
    "Recurrence depletion with truncated draws" => (:Truncate,),
    "Recurrence depletion with smoothly truncated draws" => (:SoftTruncate,),
    "Recurrence vaccination into a protected pool" => (:Pool,),
    "Recurrence ward with competing flows (Pool without a draw)" => (:Pool,),
    "Recurrence waning protection (Pool flows)" => (:Pool,),
    "Recurrence protected pool in Float32" => (:Pool,),
    "Recurrence empty pool with a differentiated heterogeneity" => (:removals,),
    "Recurrence Transform with per-stratum parameters" => (:Transform,),
    "Recurrence Derived modifier parameters" => (:Derived,),
    "Recurrence routes, dense and sparse" => (:Routes,),
    "Recurrence routes folded on scaled identities" => (:Routes,),
    "Recurrence with a buffer deeper than the kernel" => (:depth,),
    "Recurrence feedback from recent outputs" => (:Recent,),
    "Recurrence removals from recent outputs" => (:Recent,),
    "Recurrence routes in a buffer deeper than the kernels" => (:Routes, :depth),
    # The coupling on `Recent` came after `Recent`.
    "Recurrence feedback from recent outputs across strata" => (:Recent, :_reads_across),
    # A population that varies over time came with `_population`.
    "Recurrence population varying over time with births" => (:_population,),
    "Recurrence Primary time-varying kernel" => (:primary_recurrence,),
    # Kernels as vectors of columns came with `_Ragged`.
    "Convolution ragged kernel truncated at the horizon" => (:_Ragged,),
    "Recurrence ragged Primary kernel" => (:_Ragged,),
    # Columns held as given came after the stacked form.
    "Convolution ragged kernel of views into the parameters" => (:_Columns,),
    # Gain and add on a convolution came with `contributions`.
    "Convolution with gain and add" => (:contributions,),
    "Convolution lag contributions" => (:contributions,),
    "Convolution long kernel by the automatic method" => (:Auto,),
    "Convolution wide-range series by the automatic method" => (:Auto,),
    "Convolution epidemic curve by the automatic method" => (:Auto,),
    # The growth-path seed and `prepend` came together.
    "Recurrence seeded on a growth path" => (:exponential_history,),
    # `prepend` on `with_state`, for a `NoAdjoint` too, came after the
    # growth-path seed but before any release with it.
    "Recurrence returning its state after its seed" => (:exponential_history,),
    # Coefficients from change points came with `_Piecewise`.
    "Recurrence kernel from change points" => (:_Piecewise,),
    "Recurrence Primary per-stratum kernel from change points" => (:_Piecewise,),
    "Convolution kernel from change points with history" => (:_Piecewise,),
    "Convolution Primary kernel from change points" => (:_Piecewise,),
    "Recurrence coupling from change points" => (:_Piecewise,),
    "Recurrence parameters from change points" => (:_Piecewise,),
)

# A `NoAdjoint` twin compares the analytic adjoint with plain AD of the same
# call. Releases before the adjoint (`uses_adjoint`) have no rule to compare,
# and some calls fail under their `NoAdjoint`, so the twins are left out.
const _TWIN_REQUIRES = (:uses_adjoint,)

# A user coupling and a user modifier with array parameters, neither with a
# `pullback!`: the rule differentiates each step locally.
"A share `a` of every other stratum's pressure goes to the first."
struct ShareFirst{A}
    a::A
end
function ComposableRecurrences.forward(
        C::ShareFirst, ::ComposableRecurrences.Pressure, q, p, t
    )
    tot = sum(view(p, 2:length(p)))
    q[1] = p[1] + C.a * tot
    for k in 2:length(p)
        q[k] = (1 - C.a) * p[k]
    end
    return nothing
end

"Saturation at a per-stratum `κ`, scaled by a time-varying `β`."
struct StrataCap{K, B}
    κ::K
    β::B
end
ComposableRecurrences.ispointwise(::StrataCap) = true
function ComposableRecurrences.forward(
        m::StrataCap, ::ComposableRecurrences.Step, v, s, t, k
    )
    κ = ComposableRecurrences.param(m.κ, k, t)
    return ComposableRecurrences.param(m.β, k, t) * v * κ / (κ + v), s
end

function _user_coupling(w, θ)
    logh, logR, a = _unpack(θ, (S, L), (S, T), (1,))
    r = Recurrence(G0; coupling = ShareFirst(only(a)))
    y = w(r)(exp.(logR); history = exp.(logh))
    return sum(WS .* log.(y))
end

function _strata_modifier(w, θ)
    logh, logR, logκ, β = _unpack(θ, (S, L), (S, T), (S,), (T,))
    m = StrataCap(PerStratum(exp.(logκ)), TimeVarying(β))
    r = Recurrence(G0; coupling = K0, modifiers = (m,))
    y = w(r)(exp.(logR); history = exp.(logh))
    return sum(WS .* log.(y))
end

# The same coupling across 30 strata: its local derivative takes two passes
# of dual numbers, a rule on Mooncake and plain AD on Enzyme.
const SW = 30
const WSW = [cos(0.3 * a + 0.1 * t) for a in 1:SW, t in 1:T]
function _user_coupling_wide(w, θ)
    logh, logR, a = _unpack(θ, (SW, L), (SW, T), (1,))
    r = Recurrence(G0; coupling = ShareFirst(only(a)))
    y = w(r)(exp.(logR); history = exp.(logh))
    return sum(WSW .* log.(y))
end

# The same modifier with its scale from change points: the local derivative
# reads one entry of it per step.
function _strata_modifier_piecewise(w, θ)
    logh, logR, logκ, β = _unpack(θ, (S, L), (S, T), (S,), (2,))
    m = StrataCap(PerStratum(exp.(logκ)), TimeVarying([1 => β[1], 6 => β[2]]))
    r = Recurrence(G0; coupling = K0, modifiers = (m,))
    y = w(r)(exp.(logR); history = exp.(logh))
    return sum(WS .* log.(y))
end

push!(
    _SCENARIOS,
    (
        "Recurrence user coupling without a pullback", _user_coupling,
        () -> _flat(zeros(S, L), LOGR, [0.3]),
    ),
    (
        "Recurrence per-stratum modifier without a pullback", _strata_modifier,
        () -> _flat(zeros(S, L), LOGR, [log(2.0), log(3.0), log(4.0)], 1 .+ 0.2 .* W1),
    ),
    (
        "Recurrence user coupling across 30 strata", _user_coupling_wide,
        () -> _flat(zeros(SW, L), [0.1 * sin(a + t) for a in 1:SW, t in 1:T], [0.3]),
    ),
    (
        "Recurrence modifier without a pullback, parameter from change points",
        _strata_modifier_piecewise,
        () -> _flat(zeros(S, L), LOGR, [log(2.0), log(3.0), log(4.0)], [1.2, 0.8]),
    ),
)
# The local derivatives of a coupling and of array parameters read one
# entry per step came together.
_REQUIRES["Recurrence user coupling without a pullback"] = (:_local_pressure!,)
_REQUIRES["Recurrence user coupling across 30 strata"] = (:_local_pressure!,)
_REQUIRES["Recurrence per-stratum modifier without a pullback"] = (:_EntryParam,)
let name = "Recurrence modifier without a pullback, parameter from change points"
    _REQUIRES[name] = (:_Piecewise,)
end
_REQUIRES["Convolution Poisson delay distribution"] = (:delay_masses,)
_REQUIRES["Recurrence negative binomial generation interval per stratum"] = (:delay_masses,)

_requires(name) = get(_REQUIRES, name, ())

"""
    unsupported_scenarios()

The scenario names left out because the loaded ComposableRecurrences lacks a
feature they need. Empty on the current version.
"""
function unsupported_scenarios()
    return [
        prefix * name
            for (prefix, extra) in (("", ()), ("NoAdjoint ", _TWIN_REQUIRES))
            for (name, _, _) in _SCENARIOS
            if !supports(_requires(name)..., extra...)
    ]
end

const _TWINS = Tuple{String, Any, Any}[
    (prefix * name, Base.Fix1(f, wrap), θ0)
        for (prefix, wrap, extra) in (
            ("", identity, ()), ("NoAdjoint ", NoAdjoint, _TWIN_REQUIRES),
        )
        for (name, f, θ0) in _SCENARIOS
        if supports(_requires(name)..., extra...)
]

"""
    scenarios(; with_reference = false, category = :marginal)

The AD gradient scenarios. Each is a `DIT.Scenario{:gradient, :out}` whose
`res1` carries a ForwardDiff reference when `with_reference = true`.
There is one category, `:marginal`.
Scenarios the loaded ComposableRecurrences cannot run are left out (see
`unsupported_scenarios`).
"""
function scenarios(; with_reference::Bool = false, category::Symbol = :marginal)
    category === :marginal || throw(
        ArgumentError("unknown category $(repr(category)); choose :marginal")
    )
    return map(_TWINS) do (name, f, θ0)
        θ = θ0()
        DIT.Scenario{:gradient, :out}(
            f, θ; name, res1 = with_reference ? _reference(f, θ) : nothing
        )
    end
end

"""
    backends()

The AD backends to test, as `(; name, backend)` named tuples.

The Enzyme backends mark the function `Const`.
The matrix-case losses are closures over constant data (weights,
populations, kernels), which Enzyme cannot always prove read-only.
Without the annotation, Enzyme reverse on Julia 1.13 throws an
`EnzymeMutabilityException` on them.
"""
function backends()
    return [
        (name = "ForwardDiff", backend = AutoForwardDiff()),
        (name = "ReverseDiff (tape)", backend = AutoReverseDiff(compile = false)),
        (name = "ReverseDiff (compiled)", backend = AutoReverseDiff(compile = true)),
        (name = "Enzyme forward", backend = _enzyme(Enzyme.Forward)),
        (name = "Enzyme reverse", backend = _enzyme(Enzyme.Reverse)),
        (name = "Mooncake reverse", backend = AutoMooncake(config = nothing)),
        (name = "Mooncake forward", backend = AutoMooncakeForward()),
    ]
end

function _enzyme(mode)
    return AutoEnzyme(;
        mode = Enzyme.set_runtime_activity(mode),
        function_annotation = Enzyme.Const
    )
end

"Scenario names broken on every backend."
broken_scenario_names() = String[]

"""
Per-backend broken scenario names (`Dict{String, Set{String}}`).

On Julia 1.11, plain Enzyme reverse AD of the `NoAdjoint` twin of
"Recurrence Redistribute, Add and Clamp" throws `EnzymeNoTypeError`; the
rule is correct and runs. Every other scenario and its `NoAdjoint` twin
passes on every backend.
"""
function backend_broken_scenarios()
    VERSION < v"1.12" || return Dict{String, Set{String}}()
    return Dict(
        "Enzyme reverse" => Set(["NoAdjoint Recurrence Redistribute, Add and Clamp"]),
    )
end

"""
Per-backend scenario names too unstable to run at all.

Plain Enzyme reverse AD of a sparse coupling repeated over steps returns
silently wrong gradients, so `NoAdjoint` on a sparse coupling, or a sparse
route coupling, throws on Enzyme reverse; the analytic rule is correct and
runs.
"""
function backend_skip_scenarios()
    return Dict(
        "Enzyme reverse" => Set(
            [
                "NoAdjoint Recurrence sparse coupling",
                "NoAdjoint Recurrence routes, dense and sparse",
                "NoAdjoint Recurrence routes in a buffer deeper than the kernels",
            ]
        ),
    )
end

"""
Per-backend scenario names whose call takes plain AD by design, so the
analytic reverse pass does not run: a coupling's local derivative in two
passes of dual numbers is a rule on Mooncake only.
"""
function backend_plain_scenarios()
    return Dict("Enzyme reverse" => Set(["Recurrence user coupling across 30 strata"]))
end

# The benchmark matrix cases at realistic sizes (see benchmark/matrix.jl).
include("matrix_cases.jl")

end # module ADFixtures
