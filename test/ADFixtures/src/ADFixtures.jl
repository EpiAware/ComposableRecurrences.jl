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
    backend_broken_scenarios, backend_skip_scenarios, FlooredDepletion,
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
    dep = ComposableRecurrences.Depletion(
        PerStratum(POP), ComposableRecurrences.Floor()
    )
    r = Recurrence(g; coupling = K, modifiers = (dep,))
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

# Leaky vaccination: removals move susceptibles into a protected pool drawn
# from at relative susceptibility σ. The doses stay below the pools, away
# from the removal cap.
function _vaccination(w, θ)
    logh, logR, doses, σ = _unpack(θ, (S, L), (S, T), (S, T), (1,))
    d = ComposableRecurrences.Depletion(
        PerStratum(POP); removals = TimeVarying(PerStratum(doses)),
        protected = ComposableRecurrences.Protected(only(σ))
    )
    r = Recurrence(G0; coupling = K0, modifiers = (d,))
    y = w(r)(exp.(logR); history = exp.(logh))
    return sum(WS .* log.(y))
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
        "Recurrence vaccination into a protected pool", _vaccination,
        () -> _flat(zeros(S, L), 0.3 .+ LOGR, 1 .+ 0.5 .* abs.(LOGR), [0.3]),
    ),
    (
        "Recurrence grouped totals (Allocate)", _allocate,
        () -> _flat(
            G0, fill(log(5.0), S, L), LOGR, [log(8.0 + p + t) for p in 1:2, t in 1:T]
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
        "Recurrence Transform with per-stratum parameters", _transform,
        () -> _flat([0.5, 0.6, 0.7], [0.2, 0.3, 0.4]),
    ),
    (
        "Recurrence Derived modifier parameters", _derived,
        () -> _flat(zeros(S, L), LOGR, W1 .- 1, [0.8], 0.5 .* WS),
    ),
]

"""
    supports(features...)

Whether the loaded ComposableRecurrences defines every name in `features`.

The benchmark history workflow runs this registry, as on `main`, against the
last few tagged releases.
A scenario that needs a feature newer than the oldest of those lists it in
`_REQUIRES`, and is left out where the loaded version lacks it.
"""
supports(features::Symbol...) = all(s -> isdefined(ComposableRecurrences, s), features)

# The features each scenario needs beyond the first release, by scenario
# name. A scenario not listed needs none. Add an entry with each scenario
# that uses a new public name, e.g. `"..." => (:Transform,)`.
const _REQUIRES = Dict{String, Tuple{Vararg{Symbol}}}(
    "Recurrence grouped totals (Allocate)" => (:Allocate,),
    "Recurrence vaccination into a protected pool" => (:Protected,),
    "Recurrence Transform with per-stratum parameters" => (:Transform,),
    "Recurrence Derived modifier parameters" => (:Derived,),
    # A Primary() kernel in a Recurrence: the seed check came with it.
    "Recurrence Primary time-varying kernel" => (:_check_primary_seed,),
)

# A `NoAdjoint` twin compares the analytic adjoint with plain AD of the same
# call. Releases before the adjoint (`uses_adjoint`) have no rule to compare,
# and some calls fail under their `NoAdjoint`, so the twins are left out.
const _TWIN_REQUIRES = (:uses_adjoint,)

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

None: every scenario and its `NoAdjoint` twin passes on every backend.
"""
backend_broken_scenarios() = Dict{String, Set{String}}()

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

# The benchmark matrix cases at realistic sizes (see benchmark/matrix.jl).
include("matrix_cases.jl")

end # module ADFixtures
