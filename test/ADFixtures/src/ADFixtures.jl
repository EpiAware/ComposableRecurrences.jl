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
using ComposableRecurrences: Derived, Recent
using ComposableRecurrences: ComposableRecurrences, NoAdjoint
using Distributions: NegativeBinomial, Poisson
using LinearAlgebra: Diagonal, I
using SparseArrays: SparseMatrixCSC, sparse

export scenarios, backends, broken_scenario_names,
    backend_broken_scenarios, backend_plain_scenarios, backend_skip_scenarios,
    FlooredDepletion,
    supports, unsupported_scenarios

# The benchmark history loads these fixtures with the last few tagged
# releases (see `supports`). Releases before `forward!` call `forward` for
# every role, with a pointwise modifier's step on stratum `k`'s scalars
# returning `(v′, s′)`, so each user type here defines that method there.
const IN_PLACE = isdefined(ComposableRecurrences, :forward!)

# A `Depletion` with a form and a starting pool, spelled as the loaded release
# takes it: as a draw and flows since `Depletion` took its pieces, with the
# exponent held by the form and removals a count out of the pool after the
# draw, and as a positional form with `pool0` before.
const PIECE_DEPLETION =
    :α in fieldnames(Base.unwrap_unionall(ComposableRecurrences.Hazard))
function depletion(N; form = ComposableRecurrences.Hazard(), pool0 = nothing, kw...)
    PIECE_DEPLETION || return ComposableRecurrences.Depletion(N, form; pool0, kw...)
    return _piece_depletion(N, form, pool0; kw...)
end
function _piece_depletion(
        N, form, pool0; heterogeneity = nothing, removals = nothing
    )
    return ComposableRecurrences.Depletion(
        N, _with_exponent(form, heterogeneity), _removals(removals)...;
        pools = (S = pool0,)
    )
end
_with_exponent(form, α) = _exponent_of(form, α)
_with_exponent(form, ::Nothing) = form
_exponent_of(::ComposableRecurrences.Hazard, α) = ComposableRecurrences.Hazard(α)
_exponent_of(::ComposableRecurrences.Floor, α) = ComposableRecurrences.Floor(α)
_removals(::Nothing) = ()
function _removals(r)
    CR = ComposableRecurrences
    return (CR.Flow(:S => 0, r; form = CR.Truncate()),)
end

# A `forward!` method that writes in place on every release, an `Init` or a
# `Pressure`: as written, or on a release before `forward!` as `forward`.
macro in_place(def)
    return esc(IN_PLACE ? def : _as_forward(def))
end
_as_forward(x) = x
_as_forward(x::QuoteNode) = x.value === :forward! ? QuoteNode(:forward) : x
_as_forward(x::Expr) = Expr(x.head, map(_as_forward, x.args)...)

# A pointwise modifier, declared as the loaded release takes it: `blocks`
# `(1, 1)` where `ispointwise` follows from `blocks`, and `ispointwise`
# before. The probe asks the release itself; a release without `blocks`
# takes `ispointwise`.
struct _BlocksProbe end
const POINTWISE_BLOCKS = isdefined(ComposableRecurrences, :blocks) && begin
    @eval ComposableRecurrences.blocks(::_BlocksProbe) = (1, 1)
    Base.invokelatest(ComposableRecurrences.ispointwise, _BlocksProbe())
end
macro pointwise(T)
    POINTWISE_BLOCKS && return :($ComposableRecurrences.blocks(::$(esc(T))) = (1, 1))
    return :($ComposableRecurrences.ispointwise(::$(esc(T))) = true)
end

# A call that also returns its state, as the loaded release spells it:
# `state = true` on the call, and `with_state` before.
const STATE_KEYWORD = !isdefined(ComposableRecurrences, :with_state)
function returning_state(op, args...; kwargs...)
    STATE_KEYWORD && return op(args...; kwargs..., state = true)
    return ComposableRecurrences.with_state(op, args...; kwargs...)
end

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
@in_place function ComposableRecurrences.forward!(
        m::FlooredDepletion, ::ComposableRecurrences.Init, s, history
    )
    s .= m.pop
    return nothing
end
@pointwise FlooredDepletion
if IN_PLACE
    function ComposableRecurrences.forward!(
            m::FlooredDepletion, ::ComposableRecurrences.Step, v, s, t
        )
        for k in eachindex(v, s)
            v′ = max(s[k] / m.pop[k], 1.0e-6) * v[k]
            v[k], s[k] = v′, s[k] - v′
        end
        return nothing
    end
else
    function ComposableRecurrences.forward(
            m::FlooredDepletion, ::ComposableRecurrences.Step, v, s, t, k
        )
        v′ = max(s / m.pop[k], 1.0e-6) * v
        return v′, s - v′
    end
end

"""
Floored depletion from one scalar pool size `N` shared by every stratum, so
the scalar field is differentiated.
"""
struct ScalarDepletion{T}
    N::T
end
@in_place function ComposableRecurrences.forward!(
        m::ScalarDepletion, ::ComposableRecurrences.Init, s, history
    )
    fill!(s, m.N)
    return nothing
end
@pointwise ScalarDepletion
if IN_PLACE
    function ComposableRecurrences.forward!(
            m::ScalarDepletion, ::ComposableRecurrences.Step, v, s, t
        )
        for k in eachindex(v, s)
            v′ = max(s[k] / m.N, 1.0e-6) * v[k]
            v[k], s[k] = v′, s[k] - v′
        end
        return nothing
    end
else
    function ComposableRecurrences.forward(
            m::ScalarDepletion, ::ComposableRecurrences.Step, v, s, t, k
        )
        v′ = max(s / m.N, 1.0e-6) * v
        return v′, s - v′
    end
end

# Consecutive blocks of `θ` with the given shapes, as reshaped views. The
# block ends are a tuple computed before the blocks are built, so the blocks
# are inferred: a closure that captured and advanced an offset would box it,
# and Enzyme cannot differentiate every scenario built from uninferred
# blocks. It is not inlined, so the block ranges are not folded into
# constants that Enzyme cannot type when a scenario is called dynamically.
@noinline function _unpack(θ, shapes::Vararg{Tuple, N}) where {N}
    lens = map(prod, shapes)
    return map(shapes, cumsum(lens), lens) do sh, stop, n
        reshape(view(θ, (stop - n + 1):stop), sh...)
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
    dep = depletion(PerStratum(POP); form = ComposableRecurrences.Floor())
    r = Recurrence(g; coupling = K, modifiers = (dep,))
    y = w(r)(exp.(logR); history = exp.(logh))
    return sum(WS .* log.(y))
end

# A differentiated heterogeneity exponent: the built-in forms' default
# exponent is fixed, so these keep the float exponent's power and log on
# every backend.
function _heterogeneity(w, θ, form)
    α, logh, logR = _unpack(θ, (1,), (S, L), (S, T))
    dep = depletion(PerStratum(POP); form = form, heterogeneity = only(α))
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
        depletion(PerStratum(POP); form = ComposableRecurrences.Floor()),
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

# A `Redistribute` of a fixed movement matrix whose columns sum to 0.9,
# with `leak = true`. Enzyme's rule tester perturbs the operator's matrix
# itself by finite differences, which a matrix whose columns must sum to
# one would refuse at `Init`; columns below one leave it room.
_leaky(M) = ComposableRecurrences.Redistribute(0.9 .* M; leak = true)

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
        spill = _leaky(ComposableRecurrences.movement(K, ε))
    )
    y = w(Recurrence(g; modifiers = (split,)))(exp.(logR); history = exp.(logh))
    return sum(WS .* log.(y))
end

# The same groups with an empty group between them and one after them: their
# totals and fractions are in `θ` but unused, so their gradients are zero.
const GROUPS_EMPTY = [1:2, 3:2, 3:3, 4:3]
function _allocate_empty(w, θ)
    g, logh, logR, logtot = _unpack(θ, (L,), (S, L), (S, T), (4, T))
    split = ComposableRecurrences.Allocate(
        GROUPS_EMPTY, TimeVarying(PerStratum(exp.(logtot)))
    )
    y = w(Recurrence(g; modifiers = (split,)))(exp.(logR); history = exp.(logh))
    return sum(WS .* log.(y))
end
function _allocate_empty_imports(w, θ)
    g, logh, logR, logtot, φ, P, K, ε = _unpack(
        θ, (L,), (S, L), (S, T), (4, T), (4, T), (S, S), (S, S), (S,)
    )
    split = ComposableRecurrences.Allocate(
        GROUPS_EMPTY, TimeVarying(PerStratum(exp.(logtot)));
        imports = (TimeVarying(PerStratum(φ)), P),
        spill = _leaky(ComposableRecurrences.movement(K, ε))
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
        spill = _leaky(ComposableRecurrences.movement(collect(K), ε))
    )
    mods = (
        _leaky(ComposableRecurrences.movement(collect(K), 0.1)),
        split,
    )
    r = Recurrence(g; coupling = collect(C), modifiers = mods)
    return sum(WS .* log.(w(r)(exp.(logR); history = exp.(logh))))
end

# Movement between strata from a kernel and an intensity per origin and
# time, both reshaped from θ, before a depletion.
function _movement_time_varying(w, θ)
    g, K, ε, logh, logR = _unpack(θ, (L,), (S, S), (S, T), (S, L), (S, T))
    mods = (
        ComposableRecurrences.Redistribute(ComposableRecurrences.movement(K, ε)),
        ComposableRecurrences.Depletion(PerStratum(POP)),
    )
    y = w(Recurrence(g; modifiers = mods))(exp.(logR); history = exp.(logh))
    return sum(WS .* log.(y))
end

# Movement whose intensity reads the recent outputs: each origin sends
# more as its own incidence rises, through a kernel and a scale in `θ`.
function _movement_recent(w, θ)
    K, κ, logh, logR = _unpack(θ, (S, S), (1,), (S, L), (S, T))
    ε = Derived(x -> 0.2 * tanh(x), κ[1] * ComposableRecurrences.Recent(3))
    mods = (
        ComposableRecurrences.Redistribute(ComposableRecurrences.movement(K, ε)),
        ComposableRecurrences.Depletion(PerStratum(POP)),
    )
    y = w(Recurrence(G0; modifiers = mods))(exp.(logR); history = exp.(logh))
    return sum(WS .* log.(y))
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
    y, st = returning_state(w(r), exp.(logR); history = exp.(logh))
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
# seed joined before the run.
const WSL = [cos(a * t) for a in 1:S, t in 1:(L + T)]
function _growth_seed(w, θ)
    logI0, r, logR = _unpack(θ, (S,), (1,), (S, T))
    h = ComposableRecurrences.exponential_history(exp.(logI0), only(r), L)
    y = cat(h, w(Recurrence(G0; coupling = K0))(exp.(logR); history = h); dims = 2)
    return sum(WSL .* log.(y))
end

# A history read straight from the parameters is a view, as a probabilistic
# model hands it over: a random walk (a unit lag-1 kernel) with its seed
# joined in front, and strata whose history is a reshaped view, joined too.
# The unit lag-1 pullbacks are checked against ForwardDiff in the unit tests.
# The join is `cat` with `dims`, as ReverseDiff cannot `hcat` its tracked
# arrays and Enzyme cannot `vcat` a view and an array.
function _joined_view(w, θ)
    z0, H, ϵ, E = _unpack(θ, (1,), (S, 2), (T,), (S, T))
    y = cat(z0, w(Recurrence([1.0]))(1.0; history = z0, add = ϵ); dims = 1)
    Y = cat(H, w(Recurrence([0.5, 0.2]))(ones(S, T); history = H, add = E); dims = 2)
    return sum(abs2, y) + sum(W1 .* y[2:end]) + sum(WS .* Y[:, 3:end])
end

# The state returned after the seed and the run, with the seed joined in
# front.
function _with_state_joined(w, θ)
    logh, logR = _unpack(θ, (S, L), (S, T))
    r = Recurrence(G0; coupling = K0)
    h = exp.(logh)
    y, st = returning_state(w(r), exp.(logR); history = h, start = L + 1)
    y = cat(h, y; dims = 2)
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

# A sum that reads forward from each time (`transpose`): each column is a
# cohort's delay pmf, over a series extended past its end by its last value.
function _forward_sum(w, θ)
    G, X = _unpack(θ, (L, T), (S, T))
    c = Convolution(TimeVarying(G, ComposableRecurrences.Primary()))
    y = w(transpose(c))(X; tail = repeat(X[:, end], 1, L - 1), start = 2)
    return sum(WS[:, 2:end] .* y)
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
    return CR.Depletion(
        N, CR.Hazard(; weights = (S = 1, V = σ)),
        CR.Flow(:S => :V, doses; form = CR.Truncate()), flows...; pools = (:S, :V)
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
    CR = ComposableRecurrences
    d = CR.Depletion(
        TimeVarying(PerStratum(exp.(logN))), CR.Hazard(),
        CR.Flow(:S => 0, TimeVarying(PerStratum(-births)); form = CR.Truncate())
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

# A ring of four pools with twelve flows, each with its own scalar rate, so
# the operator and its arguments have more than 32 leaves: past the length
# at which `map` over a tuple no longer infers.
const NFLOWS = 12
const RING = (:A, :B, :C, :D)
const RING0 = (
    PerStratum(POP .- 30), PerStratum(fill(10.0, S)), PerStratum(fill(10.0, S)),
    PerStratum(fill(10.0, S)),
)
_ring_flow(ρ, i) = ComposableRecurrences.Flow(
    RING[mod1(i, 4)] => RING[mod1(i + 1, 4)], exp(ρ[i])
)
function _many_flows(w, θ)
    logh, logR, logρ = _unpack(θ, (S, L), (S, T), (NFLOWS,))
    fs = ntuple(i -> _ring_flow(logρ, i), Val(NFLOWS))
    d = ComposableRecurrences.Depletion(
        PerStratum(POP), ComposableRecurrences.Hazard(), fs...;
        pools = NamedTuple{RING}(RING0)
    )
    r = Recurrence(G0; coupling = K0, modifiers = (d,))
    y = w(r)(exp.(logR); history = exp.(logh))
    return sum(WS .* log.(y))
end

# Two draws on one pool with a share leaving it between them: the hazard
# draw at a differentiated exponent passes its value on to a floored draw.
# The parameters are offsets from `TWOD0`, so the scenario starts at zero.
const TWOD0 = _flat([1.2, 0.05], fill(log(5.0), L), 0.3 .+ LOGR[1, :])
function _two_draws(w, θ)
    x = TWOD0 .+ θ
    logh, logR = _unpack(view(x, 3:length(x)), (L,), (T,))
    CR = ComposableRecurrences
    d = CR.Depletion(
        60.0, CR.Hazard(x[1]), CR.Flow(:S => 0, x[2]; form = CR.Share()), CR.Floor();
        pools = (S = 50.0,)
    )
    y = w(Recurrence(G0; modifiers = (d,)))(exp.(logR); history = exp.(logh))
    return sum(W1 .* log.(y))
end

# Wards in each stratum: suspected patients (compartment 1) are confirmed
# at a rate or ruled out as a share; confirmed patients (compartment 2) are
# discharged at a rate and transferred out in counts. Admissions enter both.
function _ward(w, θ)
    adm, confirm, ruleout, discharge, transfer = _unpack(
        θ, (2S, T), (S,), (T,), (1,), (S, T)
    )
    ward = _ward(confirm, ruleout, only(discharge), transfer)
    r = Recurrence([1.0]; modifiers = (ward,))
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
    d = depletion(
        100.0; heterogeneity = 1 + θ[1], pool0 = 50 + θ[2], removals = 1000 + θ[3]
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
        _leaky(ComposableRecurrences.movement(K, ε)),
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
    beds = _beds(exp(x[n - 2]), x[n - 1], x[n])
    r = Recurrence(PerStratum(GCAP[1:2, :]); modifiers = (beds,))
    y = w(r)(exp.(logR); history = exp.(logh))
    return sum(WS[1:2, :] .* log.(y))
end

# The capacity pools are built behind a call: inline in the losses, whose
# unpacking does not infer, Enzyme rejects them when the code is compiled
# for coverage.
function _beds(C, δ, κ)
    CR = ComposableRecurrences
    return CR.Depletion(
        C, CR.Flow(:O => 0, δ; form = CR.Share()),
        CR.SoftTruncate(κ; into = :O, overflow = :stratum); pools = (:O,)
    )
end
function _budget(init, grants)
    CR = ComposableRecurrences
    return CR.Depletion(
        CR.Flow(0 => :B, TimeVarying(PerStratum(grants)); form = CR.Truncate()),
        CR.Truncate(; overflow = :queue); pools = (B = PerStratum(init),)
    )
end

# A weekly budget per stratum, carried over, with unserved demand queued for
# the next step: the grants are a flow into each allowance at each week's
# start.
const CAPB0 = _flat(
    fill(log(5.0), S, L), 0.5 .+ LOGR,
    [log(9.0 + p + 0.5 * sin(t)) for p in 1:S, t in 1:(L + T)], [1.0, 2.0, 0.5],
)
# A grant at each week's start, and a small one at every other step: a
# grant of exactly zero is the kink of a count from outside, where finite
# differences disagree with any derivative.
const WEEKS = [t > L && rem(t - L - 1, 4) == 0 ? 1.0 : 0.01 for p in 1:S, t in 1:(L + T)]
function _capacity_budget(w, θ)
    logh, logR, logb, init = _unpack(CAPB0 .+ θ, (S, L), (S, T), (S, L + T), (S,))
    CR = ComposableRecurrences
    grants = WEEKS .* exp.(logb)
    r = Recurrence(PerStratum(GCAP); modifiers = (_budget(collect(init), grants),))
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
    pool = depletion(exp(x[n - 4]); form = CR.SoftTruncate(x[n - 3]))
    beds = CR.Depletion(
        PerStratum(exp.(x[(n - 2):n])), CR.Flow(:O => 0, 0.3; form = CR.Share()),
        CR.SoftTruncate(0.2; into = :O); pools = (:O,)
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
    d = depletion(PerStratum(exp.(logpool)); form = ComposableRecurrences.Truncate())
    y = w(Recurrence(G0; coupling = K0, modifiers = (d,)))(exp.(logR); history = exp.(logh))
    return sum(WS .* y)
end
function _soft_truncate(w, θ)
    x = TRUNC0 .+ θ
    logh, logR, logpool = _unpack(x, (S, L), (S, T), (S,))
    form = ComposableRecurrences.SoftTruncate(x[length(x)])
    d = depletion(PerStratum(exp.(logpool)); form = form)
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
    r = Recurrence(Pairwise(K => g1, Ks => g2))
    return sum(WS .* log.(w(r)(exp.(logR); history = exp.(logh))))
end

# Routes on scaled identities, which fold into one summed kernel.
function _routes_folded(w, θ)
    λ, g1, g2, logh, logR = _unpack(θ, (2,), (L - 1,), (L,), (S, L), (S, T))
    r = Recurrence(Pairwise(λ[1] * I => g1, λ[2] * I => g2))
    return sum(WS .* log.(w(r)(exp.(logR); history = exp.(logh))))
end

# A pointwise modifier that passes the value through and asks for a buffer
# `w` steps deep, deeper than the kernel. Releases before `depth` have no
# such buffer, so the method is defined only where they do.
struct DeepBuffer
    w::Int
end
@pointwise DeepBuffer
if IN_PLACE
    function ComposableRecurrences.forward!(
            ::DeepBuffer, ::ComposableRecurrences.Step, v, s, t
        )
        return nothing
    end
else
    function ComposableRecurrences.forward(
            ::DeepBuffer, ::ComposableRecurrences.Step, v, s, t, k
        )
        return v, s
    end
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
# through the `Depletion` constructor.
function _recent_removals(w, θ)
    logh, logR = _unpack(view(θ, 2:length(θ)), (S, 7), (S, T))
    CR = ComposableRecurrences
    dep = CR.Depletion(
        PerStratum(10 .* POP), CR.Hazard(),
        CR.Flow(:S => 0, θ[1] * CR.Recent(7); form = CR.Truncate())
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
    r = Recurrence(Pairwise(K => g1, Ks => g2); modifiers = (DeepBuffer(2L),))
    return sum(WS .* log.(w(r)(exp.(logR); history = exp.(logh))))
end

# The traces, read by a loss downstream of the output. BVD's importation is
# the arrivals `Redistribute` keeps as its state, read with the patches'
# infections, as BVD's joint model reads them.
function _trace_importation(w, θ)
    logh, logR, ε = _unpack(θ, (S, L), (S, T), (S,))
    CR = ComposableRecurrences
    # The intensity per origin and step keeps the movement a kernel and
    # an intensity, whose columns sum to one under any perturbation.
    mods = (
        CR.Redistribute(CR.movement(K0, ε .* ones(1, T))),
        CR.Depletion(PerStratum(POP)),
    )
    y, tr = w(Recurrence(G0; modifiers = mods))(
        exp.(logR); history = exp.(logh), trace = true
    )
    return sum(WS .* log.(y)) + sum(WS .* first(tr.modifiers))
end

# A protected `Depletion`'s trace: its protected pool, the value drawn and the
# overflow, one row each per stratum after the susceptible pools.
function _trace_pool(w, θ)
    logh, logR, doses, σ = _unpack(θ, (S, L), (S, T), (S, T), (1,))
    d = _leaky(PerStratum(POP), TimeVarying(PerStratum(doses)), only(σ))
    r = Recurrence(G0; coupling = K0, modifiers = (d,))
    y, tr = w(r)(exp.(logR); history = exp.(logh), trace = true)
    M = only(tr.modifiers)
    return sum(WS .* log.(y)) + sum(WS .* M[(S + 1):(2S), :]) +
        sum(WS .* M[(3S + 1):(4S), :])
end

# Pointwise traces: a depletion's pool, drawn value and overflow, and a
# user modifier's own trace, written in place with its own pullback.
"A pointwise smoothing at rate `a`, whose trace is its smoothed value and what it leaves of the value."
struct TracedSmooth{A}
    a::A
end
if isdefined(ComposableRecurrences, :_trace_series)
    @pointwise TracedSmooth
    function ComposableRecurrences.forward!(
            m::TracedSmooth, ::ComposableRecurrences.Step, v, s, t
        )
        for k in eachindex(v, s)
            s[k] = m.a * s[k] + (1 - m.a) * v[k]
            v[k] = s[k]
        end
        return nothing
    end
    ComposableRecurrences.ntrace(::TracedSmooth, S) = 2S
    function ComposableRecurrences.forward!(
            m::TracedSmooth, ::ComposableRecurrences.Trace, r, v, s, v′, s′, t
        )
        smoothed, left = r
        for k in eachindex(v)
            smoothed[k], left[k] = s′[k], v[k] - s′[k]
        end
        return nothing
    end
    function ComposableRecurrences.pullback!(
            grads, m::TracedSmooth, ::ComposableRecurrences.Trace, v, s, t
        )
        s̄′, r̄ = grads.trace
        for k in eachindex(v)
            grads.v[k] += r̄[k]
            grads.s′[k] += s̄′[k] - r̄[k]
        end
        return nothing
    end
end
function _trace_pointwise(w, θ)
    logh, logR, a = _unpack(θ, (S, L), (S, T), (1,))
    mods = (TracedSmooth(only(a)), ComposableRecurrences.Depletion(PerStratum(POP)))
    r = Recurrence(G0; coupling = K0, modifiers = mods)
    y, tr = w(r)(exp.(logR); history = exp.(logh), trace = true)
    T1, T2 = tr.modifiers
    return sum(WS .* log.(y)) + sum([WS; WS] .* T1) + sum([WS; WS; WS] .* T2)
end

# The ward's flows, each flow's amount per stratum and step.
function _trace_ward(w, θ)
    adm, confirm, ruleout, discharge, transfer = _unpack(
        θ, (2S, T), (S,), (T,), (1,), (S, T)
    )
    ward = _ward(confirm, ruleout, only(discharge), transfer)
    r = Recurrence([1.0]; modifiers = (ward,))
    y, tr = w(r)(; history = zeros(2S, 1), add = adm, stop = T, trace = true)
    return sum([WS; WS] .* y) + sum([WS; WS; WS; WS] .* only(tr.modifiers))
end

# The ward, built behind a call as the capacity pools are.
function _ward(confirm, ruleout, discharge, transfer)
    CR = ComposableRecurrences
    return CR.Depletion(
        CR.Flow(:suspected => :confirmed, PerStratum(confirm)),
        CR.Flow(:suspected => 0, TimeVarying(ruleout); form = CR.Share()),
        CR.Flow(:confirmed => 0, discharge),
        CR.Flow(
            :confirmed => 0, TimeVarying(PerStratum(transfer)); form = CR.Truncate()
        ); pools = (:suspected, :confirmed)
    )
end

# A weekly budget with a queue: the allowance, the doses given and what
# joins the queue.
function _trace_budget(w, θ)
    logh, logR, logb, init = _unpack(CAPB0 .+ θ, (S, L), (S, T), (S, L + T), (S,))
    CR = ComposableRecurrences
    grants = WEEKS .* exp.(logb)
    doses = CR.Depletion(
        CR.Flow(0 => :B, TimeVarying(PerStratum(grants)); form = CR.Truncate()),
        CR.Truncate(; overflow = :queue); pools = (B = PerStratum(collect(init)),)
    )
    r = Recurrence(PerStratum(GCAP); modifiers = (doses,))
    y, tr = w(r)(exp.(logR); history = exp.(logh), trace = true)
    return sum(WS .* y) + sum([WS; WS; WS] .* only(tr.modifiers))
end

# The effective reproduction number of a depleted run: its outputs over
# the pressure each step drew against.
function _effective_reproduction(w, θ)
    logh, logR = _unpack(θ, (S, L), (S, T))
    h = exp.(logh)
    d = ComposableRecurrences.Depletion(PerStratum(POP))
    r = Recurrence(G0; coupling = K0, modifiers = (d,))
    y = w(r)(exp.(logR); history = h)
    return sum(WS .* y ./ ComposableRecurrences.pressure(r, y; history = h))
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
        "Recurrence waning protection (Depletion flows)", _waning,
        () -> _flat(
            zeros(S, L), 0.3 .+ LOGR, log.(1 .+ 0.5 .* abs.(LOGR)), [0.3],
            log.(0.05 .+ 0.02 .* abs.(LOGR)),
        ),
    ),
    (
        "Recurrence pool with twelve flows (over 32 leaves)", _many_flows,
        () -> _flat(zeros(S, L), 0.3 .+ LOGR, log.(0.02 .+ 0.01 .* (1:NFLOWS))),
    ),
    (
        "Recurrence two draws on one pool with a flow between", _two_draws,
        () -> zeros(length(TWOD0)),
    ),
    (
        "Recurrence ward with competing flows (Depletion without a draw)", _ward,
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
        "Recurrence grouped totals with empty groups (Allocate)",
        _allocate_empty,
        () -> _flat(
            G0, fill(log(5.0), S, L), LOGR,
            [log(8.0 + p + t) for p in 1:4, t in 1:T],
        ),
    ),
    (
        "Recurrence grouped totals with empty groups and imports (Allocate)",
        _allocate_empty_imports,
        () -> _flat(
            G0, fill(log(5.0), S, L), LOGR,
            [log(8.0 + p + t) for p in 1:4, t in 1:T],
            [0.1 + 0.05 * p + 0.01 * t for p in 1:4, t in 1:T],
            [0.0 0.0 0.6; 0.0 0.0 0.4; 0.3 0.7 0.0],
            [0.0 0.8 0.0; 0.9 0.0 0.0; 0.1 0.2 0.0], [0.1, 0.2, 0.3],
        ),
    ),
    (
        "Recurrence Redistribute of a time-varying movement",
        _movement_time_varying,
        () -> _flat(
            G0, [0.0 0.5 0.2; 0.6 0.0 0.3; 0.4 0.5 0.0],
            [0.1 + 0.01 * k + 0.005 * t for k in 1:S, t in 1:T],
            fill(log(5.0), S, L), LOGR,
        ),
    ),
    (
        "Recurrence Redistribute of a movement read from recent outputs",
        _movement_recent,
        () -> _flat(
            [0.0 0.5 0.2; 0.6 0.0 0.3; 0.4 0.5 0.0], [0.05],
            fill(log(5.0), S, L), LOGR,
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
        "Recurrence random walk and strata prepending a view history", _joined_view,
        () -> _flat([0.2], fill(0.2, S, 2), 0.1 .* LOGR[1, :], 0.1 .* LOGR),
    ),
    (
        "Recurrence returning its state after its seed", _with_state_joined,
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
        "Convolution transpose of a Primary kernel with a tail", _forward_sum,
        () -> _flat(fill(0.25, L, T), 1 .+ LOGR),
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
        "Recurrence trace of the importation (Redistribute)", _trace_importation,
        () -> _flat(fill(log(5.0), S, L), 0.3 .+ LOGR, [0.1, 0.2, 0.05]),
    ),
    (
        "Recurrence trace of a protected pool", _trace_pool,
        () -> _flat(zeros(S, L), 0.3 .+ LOGR, 1 .+ 0.5 .* abs.(LOGR), [0.3]),
    ),
    (
        "Recurrence trace of pointwise modifiers", _trace_pointwise,
        () -> _flat(zeros(S, L), 0.3 .+ LOGR, [0.6]),
    ),
    (
        "Recurrence trace of a ward's flows", _trace_ward,
        () -> _flat(
            [10 .+ 2 .* sin.(LOGR); 1 .+ cos.(LOGR)], [0.3, 0.4, 0.5],
            0.2 .+ 0.05 .* sin.(1:T), [0.1], 0.5 .+ 0.2 .* abs.(LOGR),
        ),
    ),
    (
        "Recurrence trace of a weekly budget with a queue", _trace_budget,
        () -> zero(CAPB0),
    ),
    (
        "Recurrence effective reproduction number from its pressure",
        _effective_reproduction, () -> _flat(fill(log(5.0), S, L), 0.3 .+ LOGR),
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

# The same delay on lags two units wide: each lag sums two whole units.
function _delay_distribution_step(w, θ)
    logλ, w0, ϵ = _unpack(θ, (1,), (L,), (T,))
    c = Convolution(Poisson(exp(only(logλ))); lags = L + 1, step = 2)
    return sum(W1 .* w(c)(ϵ; history = w0))
end

# A chain of two delays given as masses: the kernel is their full linear
# convolution, built with the operator, so the gradient reaches both.
function _chained_delay(w, θ)
    a, b, ϵ = _unpack(θ, (3,), (L,), (T,))
    c = Convolution((a, b); lags = L + 2)
    return sum(W1 .* w(c)(ϵ))
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
        "Convolution Poisson delay distribution on a step of two units",
        _delay_distribution_step,
        () -> _flat([log(1.5)], ones(L), 1 .+ LOGR[1, :]),
    ),
    (
        "Convolution chain of two delays as masses", _chained_delay,
        () -> _flat([0.5, 0.3, 0.2], G0, 1 .+ LOGR[1, :]),
    ),
    (
        "Recurrence negative binomial generation interval per stratum", _generation_distribution,
        () -> _flat([log(3.0)], [0.2], fill(log(5.0), S, L), LOGR),
    ),
)

# Kernels computed from their coefficients: a cohort's weight on each lag
# from a hazard over calendar time and a profile over the lags. One small
# scenario for each operator's rule; the unit tests check each pullback.
const CR_P = ComposableRecurrences.Primary()
# Read when called, so the fixtures load on releases without it.
_Survival(args...; kwargs...) = ComposableRecurrences.Survival(args...; kwargs...)
# The operator behind `kernel_weights`, so a scenario can wrap it.
_KernelWeights(kernel) = ComposableRecurrences._KernelWeights(kernel)
_logistic(x) = inv(1 + exp(-x))
_reported_hazard(a, g) = _logistic(a + g)

# Present with probability `p`, and confirmed against the calendar hazard
# `logistic(z)` from the day after entry.
function _computed_confirmed(w, θ)
    p, z, X = _unpack(θ, (L,), (T,), (S, T))
    confirmed = p * (1 - _Survival(TimeVarying(_logistic.(z)); from = 1))
    return sum(WS .* w(Convolution(TimeVarying(confirmed, CR_P)))(X))
end

# The probability each cohort is reported by each delay, against a hazard of
# the delay and the calendar time, as an array.
function _computed_table(w, θ)
    a, g = _unpack(θ, (L,), (T + L - 1,))
    η = Derived(_reported_hazard, a, TimeVarying(g))
    reported = TimeVarying(1 - _Survival(η), CR_P)
    K = w(_KernelWeights(reported))(T)
    return sum(WT[1, :, :] .* K)
end

# A generation interval that a cohort's survival shortens, in a recurrence.
function _computed_recurrence(w, θ)
    g, z, logh, logR = _unpack(θ, (L,), (T,), (S, L), (S, T))
    surv = _Survival(TimeVarying(_logistic.(z)))
    r = Recurrence(TimeVarying(g * surv, CR_P); coupling = K0)
    y = w(r)(exp.(logR); history = exp.(logh), start = L + 1)
    return sum(WS[:, (L + 1):end] .* log.(y))
end

push!(
    _SCENARIOS,
    (
        "Convolution kernel from a hazard and a survival", _computed_confirmed,
        () -> _flat(reverse(G0), -1 .+ 0.3 .* W1, 1 .+ LOGR),
    ),
    (
        "Kernel weights of a survival against a delay and calendar hazard",
        _computed_table,
        () -> _flat(-1 .+ 0.2 .* (1:L), 0.3 .* sin.(1:(T + L - 1))),
    ),
    (
        "Recurrence kernel shortened by a survival", _computed_recurrence,
        () -> _flat(G0, -2 .+ 0.3 .* W1, fill(log(5.0), S, L), LOGR),
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
        () -> ComposableRecurrences.Depletion(
            1.0, ComposableRecurrences.Hazard(),
            ComposableRecurrences.Flow(
                :S => 0, 1.0; form = ComposableRecurrences.Truncate()
            )
        )
    ),
    # A `Depletion` whose draw fills a pool up to a capacity.
    :pool_fill => () -> _accepts(
        () -> ComposableRecurrences.Depletion(
            1.0, ComposableRecurrences.Truncate(; into = :O); pools = (:O,)
        )
    ),
    # A `Depletion` built from its pieces, two draws among them.
    :depletion_pieces => () -> _accepts(
        () -> ComposableRecurrences.Depletion(
            1.0, ComposableRecurrences.Hazard(), ComposableRecurrences.Floor()
        )
    ),
    # An `Allocate` group with no strata.
    :allocate_empty_group => () -> _accepts(
        () -> ComposableRecurrences.Allocate([1:1, 2:1], PerStratum([1.0, 1.0]))
    ),
    # A `Depletion` holding its pools' names and starting values together.
    :depletion_pools => () -> _accepts(
        () -> ComposableRecurrences.Depletion(1.0; pools = (S = 1.0,))
    ),
    # A chain of delays as one delay.
    :chained_delays => () -> _accepts(
        () -> Convolution(([1.0], [1.0]); lags = 1)
    ),
    # Local derivatives whose dual numbers compare by value.
    :local_ties => function ()
        ext = Base.get_extension(
            ComposableRecurrences, :ComposableRecurrencesForwardDiffExt
        )
        return ext !== nothing && isdefined(ext, :_LocalTag)
    end,
    # A call resumed from a returned state also returns the next state.
    :resume_state => () -> _accepts(
        function ()
            r = Recurrence([0.5])
            _, st = returning_state(r, ones(2); history = [1.0], stop = 1)
            return _, _ = r(ones(2); state = st)
        end
    ),
    # Delays on lags of a width other than one unit.
    :delay_step => () -> _accepts(
        () -> Convolution(Poisson(1.0); lags = 2, step = 2)
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
    "Recurrence grouped totals with empty groups (Allocate)" =>
        (:Allocate, :allocate_empty_group),
    "Recurrence grouped totals with empty groups and imports (Allocate)" =>
        (:_AllocateImports, :allocate_empty_group),
    "Recurrence dense coupling, Redistribute and imports as Matrix" =>
        (:_AllocateImports,),
    "Recurrence Redistribute of a time-varying movement" => (:movement,),
    "Recurrence Redistribute, Add and Clamp" => (:movement,),
    # A movement read from a parameter at each step came with `_intensity`.
    "Recurrence Redistribute of a movement read from recent outputs" =>
        (:movement, :_intensity, :Recent),
    "Recurrence capacity, beds with overflow" => (:pool_fill,),
    "Recurrence capacity, weekly budget with a queue" => (:pool_fill,),
    "Recurrence trace of the importation (Redistribute)" => (:Trace,),
    "Recurrence trace of a protected pool" => (:Trace, :depletion_pools),
    # A trace written in place, with `forward!`.
    "Recurrence trace of pointwise modifiers" => (:_trace_series,),
    "Recurrence trace of a ward's flows" => (:Trace, :depletion_pools),
    "Recurrence trace of a weekly budget with a queue" => (:Trace, :pool_fill),
    "Recurrence capacity, dropped overflow after a truncated draw" => (:pool_fill,),
    "Recurrence depletion with truncated draws" => (:Truncate,),
    "Recurrence depletion with smoothly truncated draws" => (:SoftTruncate,),
    "Recurrence vaccination into a protected pool" => (:depletion_pools,),
    "Recurrence ward with competing flows (Depletion without a draw)" => (:depletion_pools,),
    "Recurrence waning protection (Depletion flows)" => (:depletion_pools,),
    "Recurrence protected pool in Float32" => (:depletion_pools,),
    "Recurrence pool with twelve flows (over 32 leaves)" => (:depletion_pools,),
    "Recurrence two draws on one pool with a flow between" => (:depletion_pieces,),
    "Recurrence empty pool with a differentiated heterogeneity" => (:removals,),
    "Recurrence Transform with per-stratum parameters" => (:Transform,),
    "Recurrence Derived modifier parameters" => (:Derived,),
    "Recurrence routes, dense and sparse" => (:_Routes,),
    "Recurrence routes folded on scaled identities" => (:_Routes,),
    "Recurrence with a buffer deeper than the kernel" => (:depth,),
    "Recurrence feedback from recent outputs" => (:Recent,),
    "Recurrence removals from recent outputs" => (:Recent,),
    "Recurrence routes in a buffer deeper than the kernels" => (:_Routes, :depth),
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
    "Recurrence seeded on a growth path" => (:exponential_history,),
    # Coefficients from change points came with `_Piecewise`.
    "Recurrence kernel from change points" => (:_Piecewise,),
    "Recurrence Primary per-stratum kernel from change points" => (:_Piecewise,),
    "Convolution kernel from change points with history" => (:_Piecewise,),
    "Convolution Primary kernel from change points" => (:_Piecewise,),
    "Recurrence coupling from change points" => (:_Piecewise,),
    "Recurrence parameters from change points" => (:_Piecewise,),
    "Convolution kernel from a hazard and a survival" => (:Survival,),
    "Kernel weights of a survival against a delay and calendar hazard" =>
        (:Survival, :_KernelWeights),
    "Recurrence kernel shortened by a survival" => (:Survival,),
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
@in_place function ComposableRecurrences.forward!(
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
@pointwise StrataCap
if IN_PLACE
    function ComposableRecurrences.forward!(
            m::StrataCap, ::ComposableRecurrences.Step, v, s, t
        )
        for k in eachindex(v, s)
            κ = ComposableRecurrences.param(m.κ, k, t)
            v[k] = ComposableRecurrences.param(m.β, k, t) * v[k] * κ / (κ + v[k])
        end
        return nothing
    end
else
    function ComposableRecurrences.forward(
            m::StrataCap, ::ComposableRecurrences.Step, v, s, t, k
        )
        κ = ComposableRecurrences.param(m.κ, k, t)
        return ComposableRecurrences.param(m.β, k, t) * v * κ / (κ + v), s
    end
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

# A modifier that indexes a vector field by time and a coupling that holds
# a matrix, neither with a `pullback!`: the local derivative seeds the
# entries a step reads, or every entry of the coupling's arrays.
"A scale `a[t]` on the new value, read by time."
struct ByTime{A}
    a::A
end
@pointwise ByTime
if IN_PLACE
    function ComposableRecurrences.forward!(
            m::ByTime, ::ComposableRecurrences.Step, v, s, t
        )
        for k in eachindex(v, s)
            v[k] = m.a[t] * v[k]
        end
        return nothing
    end
else
    function ComposableRecurrences.forward(
            m::ByTime, ::ComposableRecurrences.Step, v, s, t, k
        )
        return m.a[t] * v, s
    end
end

"Pressure `K * p`, scaled by `β` per stratum."
struct MatrixMix{M, B}
    K::M
    β::B
end
@in_place function ComposableRecurrences.forward!(
        C::MatrixMix, ::ComposableRecurrences.Pressure, q, p, t
    )
    q .= C.β .* (C.K * p)
    return nothing
end

function _modifier_by_time(w, θ)
    logh, logR, a = _unpack(θ, (S, L), (S, T), (T,))
    r = Recurrence(G0; coupling = K0, modifiers = (ByTime(a),))
    y = w(r)(exp.(logR); history = exp.(logh))
    return sum(WS .* log.(y))
end

# A coupling and a modifier without a pullback, in an operator built before
# the local step's check could run (as before `ForwardDiff` loads): the
# call checks its parts on their primal values, inside the backend's trace.
function _unchecked_parts(w, θ)
    logh, logR, a, logκ, β = _unpack(θ, (S, L), (S, T), (1,), (S,), (T,))
    m = StrataCap(PerStratum(exp.(logκ)), TimeVarying(β))
    r0 = Recurrence(G0; coupling = ShareFirst(only(a)), modifiers = (m,))
    r = Recurrence(
        ComposableRecurrences._Checked(), r0.kernel, r0.coupling, r0.modifiers,
        nothing
    )
    y = w(r)(exp.(logR); history = exp.(logh))
    return sum(WS .* log.(y))
end

# Whole-step modifiers without a pullback: the local derivative seeds the
# step's values, its state and its parameters.
"A share `b` of the values mixed evenly over the strata, and the mixed values' decaying total, at rate `a`, kept as the state."
struct ZoneMix{B, A}
    b::B
    a::A
end
@in_place function ComposableRecurrences.forward!(
        m::ZoneMix, ::ComposableRecurrences.Step, v, s, t
    )
    mean = sum(v) / length(v)
    for k in eachindex(v, s)
        v[k] = (1 - m.b) * v[k] + m.b * mean
        s[k] = m.a * s[k] + v[k]
    end
    return nothing
end
"A per-stratum scale held as a vector, applied to every stratum at once."
struct StrataScale{A}
    a::A
end
@in_place function ComposableRecurrences.forward!(
        m::StrataScale, ::ComposableRecurrences.Step, v, s, t
    )
    v .*= m.a
    return nothing
end

function _whole_step_scalars(w, θ)
    logh, logR, p = _unpack(θ, (S, L), (S, T), (2,))
    r = Recurrence(G0; coupling = K0, modifiers = (ZoneMix(p[1], p[2]),))
    y = w(r)(exp.(logR); history = exp.(logh))
    return sum(WS .* log.(y))
end
function _whole_step_array(w, θ)
    logh, logR, a = _unpack(θ, (S, L), (S, T), (S,))
    r = Recurrence(G0; modifiers = (StrataScale(a), ZoneMix(0.2, 0.5)))
    y = w(r)(exp.(logR); history = exp.(logh))
    return sum(WS .* log.(y))
end

# The coupling as one of two routes, the other a dense matrix with its
# own pullback: the rule differentiates the route coupling locally.
function _user_coupling_routes(w, θ)
    logh, logR, a, K, g = _unpack(θ, (S, L), (S, T), (1,), (S, S), (2,))
    r = Recurrence(Pairwise(ShareFirst(only(a)) => G0, K => g))
    y = w(r)(exp.(logR); history = exp.(logh))
    return sum(WS .* log.(y))
end

function _user_coupling_matrix(w, θ)
    logh, logR, K, β = _unpack(θ, (S, L), (S, T), (S, S), (S,))
    r = Recurrence(G0; coupling = MatrixMix(K, β))
    y = w(r)(exp.(logR); history = exp.(logh))
    return sum(WS .* log.(y))
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

# A whole-step modifier without a pullback that branches where a value is
# zero, run from an empty history, so the first step's values sit at the
# tie. The local derivative must take the branch the step takes: the other
# divides zero by zero.
"A bed occupancy balance over four pools, each field typed."
struct OccupancyBalance{A, B, D, R, O, K, H}
    A_bvd::A
    A_bg::B
    deaths::D
    recover::R
    ruleout::O
    κ::K
    conf_hazard::H
end
@in_place function ComposableRecurrences.forward!(
        m::OccupancyBalance, ::ComposableRecurrences.Step, v, s, t
    )
    z = zero(eltype(v))
    ε = eps(eltype(v))
    Obvd, Obg, Oconf, Osusp = v
    bvd_out = m.deaths[t] + m.recover[t]
    ab = m.κ * Osusp
    unconf = max(Obvd - Oconf, z)
    denom = max(Osusp, ε)
    Obvd_t = max(Obvd + m.A_bvd[t] - bvd_out - ab * (unconf / denom), z)
    Obg_t = max(Obg + m.A_bg[t] - m.ruleout[t] - ab * (Obg / denom), z)
    share = Obvd > z ? Oconf / Obvd : z
    x_conf = Oconf + m.conf_hazard[t] * unconf - bvd_out * share
    Oconf_t = clamp(x_conf, z, Obvd_t)
    v .= (Obvd_t, Obg_t, Oconf_t, max(Obvd_t + Obg_t - Oconf_t, z))
    return nothing
end
const TO = 10
const A_BVD = [3.0, 4.0, 5.0, 2.0, 1.0, 0.0, 2.0, 3.0, 1.0, 0.0]
const A_BG = [1.0, 2.0, 2.0, 1.0, 1.0, 1.0, 0.0, 1.0, 2.0, 1.0]
const DEATHS = fill(0.3, TO)
const RECOVER = [0.2, 0.4, 0.6, 0.8, 1.0, 1.2, 1.0, 0.8, 0.6, 0.4]
const RULEOUT = fill(0.8, TO)
const CONF_HAZARD = [0.2, 0.3, 0.4, 0.5, 0.5, 0.5, 0.4, 0.4, 0.3, 0.3]
const WO = collect(range(0.5, 2.0; length = TO))
# The parameters are offsets from `OCC0`, so the scenario starts at zero:
# compiled ReverseDiff tapes keep the branches taken where they are
# recorded, which the harness does at zero parameters. Its first step's
# values tie where the balance branches, so it stays out of the rule
# testers' list: finite differences there step onto either branch.
const OCC0 = _flat(A_BVD, [0.1], CONF_HAZARD)
function _occupancy(w, θ)
    A_bvd, κ, conf_hazard = _unpack(OCC0 .+ θ, (TO,), (1,), (TO,))
    m = OccupancyBalance(
        A_bvd, A_BG, DEATHS, RECOVER, RULEOUT, only(κ), conf_hazard
    )
    r = Recurrence([1.0]; modifiers = (m,))
    Y = w(r)(; history = zeros(4, 1), stop = TO)
    return sum(WO .* (view(Y, 1, :) .+ view(Y, 2, :) .+ view(Y, 3, :)))
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
    (
        "Recurrence modifier with a vector field read by time", _modifier_by_time,
        () -> _flat(zeros(S, L), LOGR, 1 .+ 0.2 .* W1),
    ),
    (
        "Recurrence routes with a user coupling without a pullback",
        _user_coupling_routes,
        () -> _flat(zeros(S, L), LOGR, [0.3], 0.5 .* K0, [0.2, 0.1]),
    ),
    (
        "Recurrence user coupling holding a matrix", _user_coupling_matrix,
        () -> _flat(zeros(S, L), LOGR, K0, [0.9, 1.0, 1.1]),
    ),
    (
        "Recurrence whole-step modifier without a pullback", _whole_step_scalars,
        () -> _flat(zeros(S, L), LOGR, [0.3, 0.5]),
    ),
    (
        "Recurrence whole-step modifier holding a vector", _whole_step_array,
        () -> _flat(zeros(S, L), LOGR, [0.9, 1.0, 1.1]),
    ),
    (
        "Recurrence checked at the call", _unchecked_parts,
        () -> _flat(zeros(S, L), LOGR, [0.3], [log(2.0), log(3.0), log(4.0)], 1 .+ 0.2 .* W1),
    ),
    (
        "Recurrence whole-step modifier branching at a tie (occupancy)",
        _occupancy, () -> zero(OCC0),
    ),
)
# The local derivatives of a coupling and of array parameters read one
# entry per step came together.
_REQUIRES["Recurrence user coupling without a pullback"] = (:_local_pressure!,)
_REQUIRES["Recurrence user coupling across 30 strata"] = (:_local_pressure!,)
_REQUIRES["Recurrence per-stratum modifier without a pullback"] = (:_EntryParam,)
# The rule took routes whose couplings have no pullback once they came with
# a local derivative.
let name = "Recurrence routes with a user coupling without a pullback"
    _REQUIRES[name] = (:_Routes, :_kernel_couplings)
end
let name = "Recurrence modifier without a pullback, parameter from change points"
    _REQUIRES[name] = (:_Piecewise,)
end
# The local derivatives of a modifier's float-array reads and of a
# coupling's arrays came together.
_REQUIRES["Recurrence modifier with a vector field read by time"] = (:_read_pullback,)
_REQUIRES["Recurrence user coupling holding a matrix"] = (:_read_pullback,)
# An operator built before the local step's check could run came with
# `ForwardDiff` as an extension.
_REQUIRES["Recurrence checked at the call"] = (:_check_now,)
# The local derivative of a whole-step modifier.
_REQUIRES["Recurrence whole-step modifier without a pullback"] = (:_StepDuals,)
_REQUIRES["Recurrence whole-step modifier holding a vector"] = (:_StepDuals,)
# The local derivatives took the step's branch at a tie later.
_REQUIRES["Recurrence whole-step modifier branching at a tie (occupancy)"] =
    (:_StepDuals, :local_ties)
_REQUIRES["Convolution Poisson delay distribution"] = (:delay_masses,)
# The pressure recomputed from given outputs.
_REQUIRES["Recurrence effective reproduction number from its pressure"] = (:pressure,)
_REQUIRES["Recurrence negative binomial generation interval per stratum"] = (:delay_masses,)
_REQUIRES["Convolution chain of two delays as masses"] = (:chained_delays,)
_REQUIRES["Convolution Poisson delay distribution on a step of two units"] =
    (:delay_masses, :delay_step)

_REQUIRES["Convolution transpose of a Primary kernel with a tail"] =
    (:_TransposedConvolution,)

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

# Each scenario is reached through one dynamic call, so Enzyme compiles a
# scenario once and reuses it across the operators a test runs, while the
# scenario itself, from its parameter blocks on, is inferred.
_dynamic(f) = θ -> Base.inferencebarrier(f)(θ)

const _TWINS = Tuple{String, Any, Any}[
    (prefix * name, _dynamic(Base.Fix1(f, wrap)), θ0)
        for (prefix, wrap, extra) in (
            ("", identity, ()), ("NoAdjoint ", NoAdjoint, _TWIN_REQUIRES),
        )
        for (name, f, θ0) in _SCENARIOS
        if supports(_requires(name)..., extra...)
]

# Each scenario runs once through its call, and a twin once more through
# `NoAdjoint`. Only a reverse-mode backend with its own rule tells the two
# apart: under ForwardDiff and ReverseDiff the dual or tracked fields fail
# `_gate`, and the forward modes have no rule, so both take the same plain
# path there and the twin repeats its scenario.
const _CATEGORIES = (:marginal, :rules)

"""
    scenarios(; with_reference = false, category = :marginal)

The AD gradient scenarios. Each is a `DIT.Scenario{:gradient, :out}` whose
`res1` carries a ForwardDiff reference when `with_reference = true`.
The category `:marginal` holds every scenario and its `NoAdjoint` twin,
which the benchmarks time and the reverse-mode backends with a rule test.
The category `:rules` holds every scenario without its twin, for the
backends where the twin takes the same path as its scenario.
Scenarios the loaded ComposableRecurrences cannot run are left out (see
`unsupported_scenarios`).
"""
function scenarios(; with_reference::Bool = false, category::Symbol = :marginal)
    category in _CATEGORIES || throw(
        ArgumentError(
            "unknown category $(repr(category)); choose one of $(join(_CATEGORIES, ", "))"
        )
    )
    twins = category === :marginal ? _TWINS :
        filter(t -> !startswith(first(t), "NoAdjoint "), _TWINS)
    return map(twins) do (name, f, θ0)
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
Per-backend broken scenario names (`Dict{String, Set{String}}`): the
scenarios expected to fail on a backend, by backend name.
"""
backend_broken_scenarios() = Dict{String, Set{String}}()

"""
Per-backend skipped scenario names (`Dict{String, Set{String}}`): the
scenarios too unstable to run at all on a backend, by backend name.
"""
backend_skip_scenarios() = Dict{String, Set{String}}()

"""
Per-backend scenario names whose call takes plain AD by design, so the
analytic reverse pass does not run: a coupling's local derivative in two
passes of dual numbers is a rule on Mooncake only, as is a whole-step
modifier's that takes more than one pass.
"""
function backend_plain_scenarios()
    return Dict(
        "Enzyme reverse" => Set(
            [
                "Recurrence user coupling across 30 strata",
                "Recurrence whole-step modifier branching at a tie (occupancy)",
            ]
        )
    )
end

# The benchmark matrix cases at realistic sizes (see benchmark/matrix.jl).
include("matrix_cases.jl")

end # module ADFixtures
