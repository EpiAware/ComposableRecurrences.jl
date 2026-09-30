# PACKAGE-OWNED — scaffold writes this once and never overwrites it.
#
# AD-fixture registry implementing the EpiAwarePackageTools `ADRegistry`
# contract: scenarios (each with a ForwardDiff reference), a backend list,
# and broken/skip bookkeeping, consumed by the shared harness
# (`test/ad/setup.jl`) and the benchmark suite.
#
# Each scenario differentiates a scalar loss of one operator call with
# respect to a flat parameter vector holding every differentiable slot.
# Sizes are small so the per-backend CI stays fast; benchmark/gradients.jl
# times harness-sized cases.
module ADFixtures

using ADTypes: AutoForwardDiff, AutoReverseDiff, AutoMooncake,
    AutoMooncakeForward, AutoEnzyme
using DifferentiationInterface: DifferentiationInterface
import DifferentiationInterfaceTest as DIT
import ForwardDiff, ReverseDiff, Enzyme, Mooncake
using ComposableRecurrences
using ComposableRecurrences: ComposableRecurrences, NoAdjoint
using LinearAlgebra: Diagonal
using SparseArrays: SparseMatrixCSC, sparse

export scenarios, backends, broken_scenario_names,
    backend_broken_scenarios, backend_skip_scenarios, FlooredDepletion

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
ComposableRecurrences.init_state(m::FlooredDepletion, history) = collect(m.pop)
ComposableRecurrences.ispointwise(::FlooredDepletion) = true
function ComposableRecurrences.apply(m::FlooredDepletion, v, s, t, k)
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
function ComposableRecurrences.init_state(m::ScalarDepletion, history)
    return fill(m.N, size(history, 1))
end
ComposableRecurrences.ispointwise(::ScalarDepletion) = true
function ComposableRecurrences.apply(m::ScalarDepletion, v, s, t, k)
    v′ = max(s / m.N, 1.0e-6) * v
    return v′, s - v′
end

# Consecutive blocks of `θ` with the given shapes.
function _unpack(θ, shapes...)
    o = 0
    return map(shapes) do sh
        n = prod(sh)
        x = reshape(view(θ, (o + 1):(o + n)), sh...)
        o += n
        x
    end
end

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
    r = Recurrence(g; coupling = K, modifiers = (ComposableRecurrences.Depletion(POP; form = :floor),))
    y = w(r)(exp.(logR); history = exp.(logh))
    return sum(WS .* log.(y))
end

# A scalar modifier field, a Float32 kernel and Float64 history.
const G0F = Float32.(G0)
function _scalar_field_mixed(w, θ)
    N, logR = θ[1], _unpack(view(θ, 2:length(θ)), (S, T))[1]
    r = Recurrence(G0F; coupling = K0, modifiers = (ScalarDepletion(N),))
    y = w(r)(exp.(logR); history = fill(5.0, S, L))
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
    r = Recurrence(nothing; coupling = Pairwise(P))
    return sum(WS .* w(r)(R; history = exp.(logh)))
end

function _time_varying(w, θ)
    G, C, logh, ϵ = _unpack(θ, (L, T), (S, S, T), (S, L), (S, T))
    r = Recurrence(TimeVarying(G); coupling = TimeVarying(C))
    return sum(WS .* w(r)(0.9; history = exp.(logh), add = ϵ))
end

# The returned state feeds the loss, so its cotangent reaches the history
# and the modifier's pool.
function _with_state(w, θ)
    g, logh, logR = _unpack(θ, (L,), (S, L), (S, T))
    r = Recurrence(g; coupling = K0, modifiers = (ComposableRecurrences.Depletion(POP; form = :floor),))
    y, st = w(r)(exp.(logR); history = exp.(logh), return_state = true)
    return sum(WS .* log.(y)) + sum(st.history) + 0.01 * sum(only(st.states))
end

function _delay(w, θ)
    g, w0, ϵ = _unpack(θ, (L + 1,), (L,), (T,))
    return sum(W1 .* w(Convolution(g))(ϵ; history = w0))
end

function _delay_varying(w, θ)
    G, X = _unpack(θ, (S, L, T), (S, T))
    return sum(WS .* w(Convolution(TimeVarying(G)))(X))
end

function _delay_varying_secondary(w, θ)
    G, X, H = _unpack(θ, (L, T + 3), (S, T), (S, 2))
    c = Convolution(TimeVarying(G); indexed_by = :secondary)
    return sum(WS .* w(c)(X; history = H, start = 4))
end

_flat(xs...) = reduce(vcat, map(vec, xs))

# `(name, loss, θ0)`; every scenario also runs as its `NoAdjoint` twin.
const _SCENARIOS = [
    ("Recurrence renewal", _renewal, () -> _flat(G0, zeros(L), LOGR[1, :])),
    (
        "Recurrence strata, coupling and depletion", _renewal_strata,
        () -> _flat(G0, K0, fill(log(5.0), S, L), LOGR),
    ),
    (
        "Recurrence scalar modifier field, mixed eltypes", _scalar_field_mixed,
        () -> _flat([80.0], 0.3 .+ LOGR),
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
        "Recurrence returning its state", _with_state,
        () -> _flat(G0, fill(log(5.0), S, L), LOGR),
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
        () -> _flat(fill(0.25, L, T + 3), 1 .+ LOGR, ones(S, 2)),
    ),
]

const _TWINS = Tuple{String, Any, Any}[
    (prefix * name, Base.Fix1(f, wrap), θ0)
        for (prefix, wrap) in (("", identity), ("NoAdjoint ", NoAdjoint))
        for (name, f, θ0) in _SCENARIOS
]

"""
    scenarios(; with_reference = false, category = :marginal)

The AD gradient scenarios. Each is a `DIT.Scenario{:gradient, :out}` whose
`res1` carries a ForwardDiff reference when `with_reference = true`.
There is one category, `:marginal`.
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
"""
function backends()
    return [
        (name = "ForwardDiff", backend = AutoForwardDiff()),
        (name = "ReverseDiff (tape)", backend = AutoReverseDiff(compile = false)),
        (name = "ReverseDiff (compiled)", backend = AutoReverseDiff(compile = true)),
        (name = "Enzyme forward", backend = AutoEnzyme(mode = Enzyme.set_runtime_activity(Enzyme.Forward))),
        (name = "Enzyme reverse", backend = AutoEnzyme(mode = Enzyme.set_runtime_activity(Enzyme.Reverse))),
        (name = "Mooncake reverse", backend = AutoMooncake(config = nothing)),
        (name = "Mooncake forward", backend = AutoMooncakeForward()),
    ]
end

"Scenario names broken on every backend."
broken_scenario_names() = String[]

"""
Per-backend broken scenario names (`Dict{String, Set{String}}`).

Enzyme forward mode with runtime activity returns a wrong gradient when a
modifier reads a constant array, here the population; reverse mode is
correct.
"""
function backend_broken_scenarios()
    return Dict(
        "Enzyme forward" => Set(
            [
                "Recurrence strata, coupling and depletion",
                "NoAdjoint Recurrence strata, coupling and depletion",
                "Recurrence returning its state",
                "NoAdjoint Recurrence returning its state",
            ]
        ),
    )
end

"""
Per-backend scenario names too unstable to run at all.

Plain Enzyme reverse AD of a sparse coupling repeated over steps returns
silently wrong gradients, so `NoAdjoint` on a sparse coupling throws on
Enzyme reverse; the analytic rule is correct and runs.
"""
function backend_skip_scenarios()
    return Dict(
        "Enzyme reverse" => Set(["NoAdjoint Recurrence sparse coupling"]),
    )
end

end # module ADFixtures
