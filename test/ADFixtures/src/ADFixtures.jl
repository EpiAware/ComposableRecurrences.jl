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

function _renewal(θ)
    g, logh, logR = _unpack(θ, (L,), (L,), (T,))
    y = Recurrence(g)(exp.(logR); history = exp.(logh))
    return sum(W1 .* log.(y))
end

function _renewal_noadjoint(θ)
    g, logh, logR = _unpack(θ, (L,), (L,), (T,))
    y = NoAdjoint(Recurrence(g))(exp.(logR); history = exp.(logh))
    return sum(W1 .* log.(y))
end

function _renewal_strata(θ)
    g, K, logh, logR = _unpack(θ, (L,), (S, S), (S, L), (S, T))
    r = Recurrence(g; coupling = K, modifiers = (FlooredDepletion(POP),))
    y = r(exp.(logR); history = exp.(logh))
    return sum(WS .* log.(y))
end

# A scalar modifier field, a Float32 kernel and Float64 history.
const G0F = Float32.(G0)
function _scalar_field_mixed(θ)
    N, logR = θ[1], _unpack(view(θ, 2:length(θ)), (S, T))[1]
    r = Recurrence(G0F; coupling = K0, modifiers = (ScalarDepletion(N),))
    y = r(exp.(logR); history = fill(5.0, S, L))
    return sum(WS .* log.(y))
end

function _sparse(θ)
    v, logh, R = _unpack(θ, (length(KS.nzval),), (S, L), (S, T))
    K = SparseMatrixCSC(S, S, KS.colptr, KS.rowval, collect(v))
    y = Recurrence(G0; coupling = K)(R; history = exp.(logh))
    return sum(WS .* y)
end

function _diagonal(θ)
    d, G, logh, R = _unpack(θ, (S,), (S, L), (S, L), (S, T))
    r = Recurrence(PerStratum(G); coupling = Diagonal(d))
    return sum(WS .* r(R; history = exp.(logh)))
end

function _pairwise(θ)
    P, logh, R = _unpack(θ, (S, S, L), (S, L), (S, T))
    r = Recurrence(Pairwise(P))
    return sum(WS .* r(R; history = exp.(logh)))
end

function _time_varying(θ)
    G, C, logh, ϵ = _unpack(θ, (L, T), (S, S, T), (S, L), (S, T))
    r = Recurrence(TimeVarying(G); coupling = TimeVarying(C))
    return sum(WS .* r(0.9; history = exp.(logh), add = ϵ))
end

function _delay(θ)
    g, w0, ϵ = _unpack(θ, (L + 1,), (L,), (T,))
    return sum(W1 .* Convolution(g)(ϵ; history = w0))
end

function _delay_varying(θ)
    G, X = _unpack(θ, (S, L, T), (S, T))
    kernel = TimeVarying(PerStratum(G), ComposableRecurrences.Primary())
    return sum(WS .* Convolution(kernel)(X))
end

_flat(xs...) = reduce(vcat, map(vec, xs))

const _SCENARIOS = [
    ("Recurrence renewal", _renewal, () -> _flat(G0, zeros(L), LOGR[1, :])),
    (
        "NoAdjoint Recurrence renewal", _renewal_noadjoint,
        () -> _flat(G0, zeros(L), LOGR[1, :]),
    ),
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
        "Convolution delay with history", _delay,
        () -> _flat([0.0; G0], ones(L), 1 .+ LOGR[1, :]),
    ),
    (
        "Convolution time-varying kernel", _delay_varying,
        () -> _flat(fill(0.25, S, L, T), 1 .+ LOGR),
    ),
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
    return map(_SCENARIOS) do (name, f, θ0)
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

Enzyme forward mode with runtime activity returns a wrong gradient when a
modifier reads a constant array, here the population; reverse mode is
correct.
"""
function backend_broken_scenarios()
    return Dict(
        "Enzyme forward" => Set(["Recurrence strata, coupling and depletion"]),
    )
end

"""
Per-backend scenario names too unstable to run at all.

Plain Enzyme reverse AD of a sparse coupling repeated over steps has
returned silently wrong gradients, so the sparse scenario is not run on
Enzyme reverse.
"""
function backend_skip_scenarios()
    return Dict(
        "Enzyme reverse" => Set(["Recurrence sparse coupling"]),
    )
end

# The benchmark matrix cases at realistic sizes (see benchmark/matrix.jl).
include("matrix_cases.jl")

end # module ADFixtures
