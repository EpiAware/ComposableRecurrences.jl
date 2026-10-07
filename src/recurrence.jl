# Marks the call that sets the fields once the arguments are checked.
struct _Checked end

@doc raw"""
A recurrence over strata whose kernel starts at lag 1, stepped from a window
of its own past values.

At absolute time ``t``, each stratum's kernel convolution of its last ``L``
values is mixed by the coupling, scaled by the gain (a multiplier on each
step's value, such as a reproduction number) and shifted by the add input,
then passed through the modifiers ``M_1, \dots, M_R`` in tuple order:

```math
\begin{aligned}
p_{t,i} &= \sum_{l=1}^{L} k_{i,l}(t)\, y_{t-l,i}, \\
v^{(0)}_t &= g_t \odot C_t\, p_t + a_t, \\
\big(v^{(n)}_t,\ s^{(n)}_t\big) &= M_n\big(v^{(n-1)}_t,\ s^{(n)}_{t-1},\ t\big),
\quad n = 1, \dots, R, \\
y_t &= v^{(R)}_t,
\end{aligned}
```

for ``t = t_0, \dots, t_1`` (`start`, `stop`), where

  - ``y_{t,i}`` is the output of stratum ``i`` at time ``t``, one of ``S``
    strata (parallel series such as places or age groups); for
    ``t < t_0`` it is the history;
  - ``k_{i,l}(t)`` is the kernel's weight on lag ``l``, `kernel[l]`, the
    same for every ``i`` and ``t`` unless the kernel is
    [`PerStratum`](@ref) or [`TimeVarying`](@ref);
  - ``p_t`` holds each stratum's kernel convolution and ``C_t`` is the
    ``S \times S`` coupling, ``C_{t,ij}`` weighting stratum ``j`` in
    stratum ``i``;
  - ``g_t`` is the gain and ``a_t`` the add input, and ``\odot`` is the
    element-wise product;
  - ``v^{(0)}_t`` is the value entering the modifiers, ``v^{(n)}_t`` the
    value after the ``n``-th and ``s^{(n)}_t`` that modifier's state after
    step ``t``; with no modifiers ``y_t = v^{(0)}_t``.

A [`Pairwise`](@ref) kernel replaces ``C_t p_t`` with
``\sum_{j} \sum_{l} k_{ij,l}(t)\, y_{t-l,j}``.
`kernel[l]` weights ``y_{t-l}``, as a generation interval or AR
coefficients are written: a recurrence has no lag 0.
The kernel is a length-`L` vector shared by every stratum, a
[`PerStratum`](@ref) `S × L` matrix, or a [`TimeVarying`](@ref) `L × T` or
`TimeVarying(PerStratum(G))` with `G` `S × L × T`.
A `TimeVarying` kernel with [`ComposableRecurrences.Primary`](@ref)
indexing reads the column of each output's own time, ``k_{i,l}(t - l)`` in
place of ``k_{i,l}(t)``, so each output keeps the kernel of the time it was
produced; its seed must sit at times from 1.
A [`Pairwise`](@ref) `S × S × L` kernel (or `TimeVarying(Pairwise(A))`)
weights every pair of strata and already mixes them, so its coupling is `I`.
The coupling is `I` (or a scaled `λ * I`), any `S × S` matrix (dense,
sparse, `Diagonal`), a [`TimeVarying`](@ref) `S × S × T` array, or any
struct with `forward` on [`ComposableRecurrences.Pressure`](@ref).
Modifiers are structs with `forward` on [`ComposableRecurrences.Step`](@ref)
and, for an initial state, [`ComposableRecurrences.Init`](@ref).

Called as `r(gain = 1; history, state, add, start, stop, prepend)`, the
call covers the absolute times `start:stop`:

  - `gain`: a scalar, a length-`T` vector shared by every stratum, or
    `S × T`, read at absolute time `t`; one when left out.
  - `history`: the outputs at times `start - m` to `start - 1`, oldest
    first, length `m` for a single series or `S × m`; zeros when left out.
    The recursion reads the last `L`, and a history shorter than `L` is
    zero-padded. A modifier's `Init` sees all of it.
  - `state`: a [`ComposableRecurrences.State`](@ref) from
    [`ComposableRecurrences.with_state`](@ref), to resume from it; not with
    `history`.
  - `add`: `nothing`, a scalar, length `T` or `S × T`, read at time `t`.
  - `start`: the first time; `1`, or `state.t` when resuming.
    With `start = m + 1` the seed sits at times `1:m`, and the
    time-indexed inputs cover it.
  - `stop`: the last time; by default the common length of the
    time-indexed inputs (`gain`, `add`), required without one.
  - `prepend`: `false`, or `true` to return `history` followed by the
    output, covering the times `start - m` to `stop`.

Every time-indexed array, kernels, couplings and modifier parameters
included, must cover `stop`.
The output is length `stop - start + 1` for a single series or `S` rows of
it; the history sets which, and the number of strata.
The buffer eltype promotes [`ComposableRecurrences.param_eltype`](@ref) of
every input and field, so Float32 inputs give a Float32 output and
dual numbers pass through any slot.
The constructor sets the field `rebuilds`, whether the local derivative
can rebuild the modifiers that use it (see
[`ComposableRecurrences.uses_adjoint`](@ref)).

# Arguments
- `kernel`: the kernel, lag 1 first.

# Keyword Arguments
- `coupling`: how the strata's kernel convolutions mix; `I` by default.
- `modifiers`: a tuple of modifiers applied after the core of each step.

# Examples
```jldoctest
using ComposableRecurrences
g = [0.6, 0.3, 0.1]                   # weights on lags 1, 2, 3
K = [0.9 0.1; 0.2 0.8]
R = fill(1.1, 2, 10)
r = Recurrence(g; coupling = K)
y = r(R; history = ones(2, 3))

# The seed followed by the run, with the seed at times 1 to 3.
r(hcat(ones(2, 3), R); history = ones(2, 3), start = 4, prepend = true)

# Resume from the returned state over the same inputs.
y1, state = ComposableRecurrences.with_state(r, R; history = ones(2, 3), stop = 5)
y2 = r(R; state)
y ≈ hcat(y1, y2)

# output

true
```
"""
struct Recurrence{K, C, M <: Tuple, B} <: AbstractOperator
    "The kernel, lag 1 first."
    kernel::K
    "How the strata's kernel convolutions mix."
    coupling::C
    "The modifiers, applied in order after the core of each step."
    modifiers::M
    "Whether the local derivative rebuilds the modifiers that use it."
    rebuilds::B
    function Recurrence(kernel::K, coupling::C, modifiers::M) where {
            K, C, M <: Tuple,
        }
        _check_kernel_shape(kernel)
        _check_coupling_shape(coupling)
        _check_pairwise_coupling(kernel, coupling)
        return Recurrence(_Checked(), kernel, coupling, modifiers, _rebuild_flag(modifiers))
    end
    function Recurrence(
            ::_Checked, kernel::K, coupling::C, modifiers::M, rebuilds::B
        ) where {K, C, M <: Tuple, B}
        return new{K, C, M, B}(kernel, coupling, modifiers, rebuilds)
    end
end

# A rebuild of a `Recurrence` from its fields recomputes `rebuilds`.
_recurrence_flat(kernel, coupling, modifiers, rebuilds) = Recurrence(kernel, coupling, modifiers)
ConstructionBase.constructorof(::Type{<:Recurrence}) = _recurrence_flat

function Recurrence(kernel; coupling = I, modifiers = ())
    return Recurrence(kernel, coupling, Tuple(modifiers))
end

@doc raw"""
The state [`ComposableRecurrences.with_state`](@ref) returns with an
operator's output, passed back as `state` to resume.

After a call that ended at absolute time ``t_1`` it carries

```math
\big(\, (y_{t_1 - L + 1}, \dots, y_{t_1}),\ \
(s^{(1)}_{t_1}, \dots, s^{(R)}_{t_1}),\ \ t_1 + 1 \,\big),
```

where ``y_t`` is the output at time ``t`` (one entry per stratum),
``L`` the number of kernel weights and ``s^{(n)}_{t_1}`` the state of the
``n``-th of ``R`` modifiers after the last step.
`history` holds the last ``L`` outputs, `states` each modifier's state and
`t` the time of the next step, ``t_1 + 1``.
A call with `state` continues exactly as one call over both ranges would.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
r = Recurrence([0.5, 0.5])
y, state = CR.with_state(r, fill(1.1, 6); history = ones(2), stop = 3)
state.t, round.(r(fill(1.1, 6); state); digits = 3)

# output

(4, [1.317, 1.407, 1.498])
```
"""
struct State{H, M, T}
    "The last `L` outputs, in the history's layout."
    history::H
    "Each modifier's state."
    states::M
    "The time of the next step."
    t::T
end

@doc raw"""
Call operator `op` and return its output with the
[`ComposableRecurrences.State`](@ref) to resume from, `(y, state)`.

For a call over absolute times ``t_0, \dots, t_1`` it returns

```math
\big((y_{t_0}, \dots, y_{t_1}),\ \ \sigma_{t_1}\big),
```

where ``y_t`` is the output at time ``t`` and ``\sigma_{t_1}`` the state
after the last step (the last ``L`` outputs, each modifier's state and
``t_1 + 1``).

Takes the same arguments as calling `op`; resume with `op(...; state)`.

# Arguments
- `op`: the operator.
- `args`, `kwargs`: the call's arguments.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
r = Recurrence([0.6, 0.4])
R = fill(1.1, 8)
y1, state = CR.with_state(r, R; history = ones(2), stop = 4)
vcat(y1, r(R; state)) ≈ r(R; history = ones(2))

# output

true
```
"""
function with_state(op, args...; kwargs...)
    y, cache = forward(op, Run(), args...; kwargs...)
    hasproperty(cache, :state) || throw(
        ArgumentError("$(nameof(typeof(op))) has no state to return")
    )
    return y, cache.state
end

# A Primary() kernel reads the column of each value's own time, so a seed
# must sit at times from 1: `start > m` for a seed of length `m`. The check
# runs once per call, so it stays out of line.
_check_primary_seed(kernel, history, start) = nothing
_check_primary_seed(::TimeVarying{Primary}, ::Nothing, start) = nothing
@noinline function _check_primary_seed(::TimeVarying{Primary}, history, start)
    m = size(history, ndims(history))
    start > m || throw(
        ArgumentError(
            "a Primary() kernel reads the column of each value's own time, " *
                "so a seed of length $m needs start > $m, not start = $(repr(start))"
        )
    )
    return nothing
end

# A Pairwise kernel already mixes strata, so its coupling is `I`.
_check_pairwise_coupling(kernel, coupling) = nothing
function _check_pairwise_coupling(::_PairwiseKernel, coupling)
    coupling isa UniformScaling && isone(coupling.λ) || throw(
        ArgumentError(
            "a Pairwise kernel already mixes strata, so its coupling must " *
                "be I, got $(_describe(coupling))"
        )
    )
    return nothing
end

# The kernel shapes: a bare array is lags only, strata and time are added
# by wrappers.
_check_kernel_shape(k::AbstractVector) = nothing
_check_kernel_shape(k::PerStratum{<:AbstractMatrix}) = nothing
_check_kernel_shape(k::Pairwise{<:AbstractArray{<:Any, 3}}) = nothing
_check_kernel_shape(k::TimeVarying{<:Any, <:AbstractMatrix}) = nothing
function _check_kernel_shape(
        k::TimeVarying{<:Any, <:PerStratum{<:AbstractArray{<:Any, 3}}}
    )
    return nothing
end
function _check_kernel_shape(
        k::TimeVarying{<:Any, <:Pairwise{<:AbstractArray{<:Any, 4}}}
    )
    return nothing
end
function _check_kernel_shape(k)
    throw(
        ArgumentError(
            "a kernel is a vector of lag weights, PerStratum, Pairwise or " *
                "TimeVarying, got $(_describe(k))"
        )
    )
end
function _check_kernel_shape(k::AbstractArray)
    throw(
        ArgumentError(
            "a kernel array is a vector of lag weights; wrap a strata × " *
                "lags matrix as PerStratum(G) and a strata × strata × lags " *
                "array as Pairwise(A); got $(_describe(k))"
        )
    )
end
function _check_kernel_shape(k::PerStratum)
    throw(
        ArgumentError(
            "a PerStratum kernel is a strata × lags matrix, got $(_describe(k))"
        )
    )
end
function _check_kernel_shape(k::Pairwise)
    throw(
        ArgumentError(
            "a Pairwise kernel is a strata × strata × lags array, got " *
                _describe(k)
        )
    )
end
function _check_kernel_shape(k::TimeVarying)
    throw(
        ArgumentError(
            "a TimeVarying kernel is lags × time, TimeVarying(PerStratum(G)) " *
                "with G strata × lags × time, or TimeVarying(Pairwise(A)) " *
                "with A strata × strata × lags × time; got $(_describe(k))"
        )
    )
end

_nlags(k::AbstractVector) = length(k)
_nlags(k::Union{PerStratum, Pairwise}) = size(k.x, ndims(k.x))
_nlags(k::TimeVarying) = (A = _array(k); size(A, ndims(A) - 1))

# Kernel strata checks against `S` strata.
_check_kernel_strata(k, S) = nothing
_check_kernel_strata(k::TimeVarying, S) = _check_kernel_strata(k.x, S)
function _check_kernel_strata(k::PerStratum, S)
    size(k.x, 1) == S || throw(
        DimensionMismatch("kernel has $(size(k.x, 1)) strata, expected $S")
    )
    return nothing
end
function _check_kernel_strata(k::Pairwise, S)
    size(k.x)[1:2] == (S, S) || throw(
        DimensionMismatch(
            "kernel is $(size(k.x)), expected ($S, $S, ...)"
        )
    )
    return nothing
end

# Fixed kernels are reversed once per call so each step is one `dot` of
# the kernel with a contiguous, oldest-first window.
_oldest_first(g::AbstractVector) = reverse(g)
_oldest_first(g::PerStratum) = PerStratum(reverse(g.x; dims = 2))
_oldest_first(g) = g

# A kernel's weight on stratum `b`'s value at lag (or delay) index `i` in
# stratum `a`, read in column `τ`. Kernels that do not mix strata read only
# `b = a`.
_weight(g::TimeVarying{<:Any, <:AbstractMatrix}, a, b, i, τ) = g.x[i, τ]
_weight(g::TimeVarying{<:Any, <:PerStratum}, a, b, i, τ) = g.x.x[a, i, τ]
_weight(g::Pairwise, a, b, i, τ) = g.x[a, b, i]
_weight(g::TimeVarying{<:Any, <:Pairwise}, a, b, i, τ) = g.x.x[a, b, i, τ]

# Stratum `a`'s kernel convolution of the window `H[t:(t + L - 1), :]`,
# for a kernel prepared by `_oldest_first`; `τ` is the absolute time.
# A native loop: at these lengths a BLAS call costs more than the arithmetic.
_kdot(g::AbstractVector, H, t, τ, L, a) = _window_dot(g, H, t, L, a)
_kdot(g::PerStratum, H, t, τ, L, a) = _window_dot(view(g.x, a, :), H, t, L, a)
function _window_dot(g, H, t, L, a)
    acc = zero(promote_type(eltype(g), eltype(H)))
    @inbounds @simd for i in 1:L
        acc += g[i] * H[t + i - 1, a]
    end
    return acc
end
function _kdot(g::TimeVarying, H, t, τ, L, a)
    acc = zero(eltype(H))
    for i in _lags(g, τ, L)
        acc += _weight(g, a, a, i, _column(g, τ, i)) * H[t + L - i, a]
    end
    return acc
end
function _kdot(g::_PairwiseKernel, H, t, τ, L, a)
    acc = zero(eltype(H))
    for i in _lags(g, τ, L), b in axes(H, 2)
        acc += _weight(g, a, b, i, _column(g, τ, i)) * H[t + L - i, b]
    end
    return acc
end

# The kernel column lag `i` reads at time `τ`: the output's own column, or
# with `Primary()` the column of the value's own time `τ - i`, which exists
# only back to time 1.
_column(g, τ, i) = τ
_column(::TimeVarying{Primary}, τ, i) = τ - i
_lags(g, τ, L) = 1:L
_lags(::TimeVarying{Primary}, τ, L) = 1:min(L, τ - 1)

# Stratum `k`'s kernel convolution at step `t`, written to `p[k]`.
function _pressure_body!(k, p, g, H, t, τ, L)
    p[k] = _kdot(g, H, t, τ, L, k)
    return nothing
end

function _kernel_pressure!(ex, p, g, H, t, τ, L)
    S = length(p)
    _each!(_pressure_body!, ex, H, S, S * _kwork(g, S, L), p, g, H, t, τ, L)
    return p
end

# The inner operations of one stratum's kernel convolution.
_kwork(g, S, L) = L
_kwork(g::_PairwiseKernel, S, L) = S * L

# Load the last `L` values of a public-layout history into the buffer,
# right aligned; a shorter history leaves the earlier rows zero.
function _load_history!(H, h::AbstractVector, L)
    m = length(h)
    n = min(m, L)
    H[(L - n + 1):L, 1] .= view(h, (m - n + 1):m)
    return H
end
function _load_history!(H, h::AbstractMatrix, L)
    m = size(h, 2)
    n = min(m, L)
    H[(L - n + 1):L, :] .= transpose(view(h, :, (m - n + 1):m))
    return H
end

# CPU buffers load by loop: a broadcast copy may alias its source, and
# reverse-mode AD cannot give that branch one activity when the history is
# constant.
function _load_history!(H::Array, h::AbstractVector, L)
    m = length(h)
    n = min(m, L)
    for i in 1:n
        H[L - n + i, 1] = h[m - n + i]
    end
    return H
end
function _load_history!(H::Array, h::AbstractMatrix, L)
    m = size(h, 2)
    n = min(m, L)
    for i in 1:n, k in axes(H, 2)
        H[L - n + i, k] = h[k, m - n + i]
    end
    return H
end

# The buffer rows `rows`, back in the public layout of history `h`.
_public(H, rows, h::AbstractVector) = H[rows, 1]
_public(H, rows, h::AbstractMatrix) = permutedims(H[rows, :])

# Without a history the run starts from zeros, with the strata of a
# strata × time input.
function _empty_history(gain, add)
    return _empty_history(gain isa AbstractMatrix ? gain : add)
end
_empty_history(x::AbstractMatrix) = similar(x, Bool, size(x, 1), 0)
_empty_history(x) = zeros(Bool, 0)

# The first time of a call: the step after the history or the state.
_start(::Nothing) = 1
_start(state::State) = state.t

_check_start(start) = nothing
function _check_start(::Nothing)
    throw(
        ArgumentError(
            "start = nothing is not a start time; leave start out for the " *
                "default (1, or state.t when resuming) or pass an integer"
        )
    )
end

# The history, modifier states and first time of a call: seeded from
# `history`, or resumed from `state`.
function _resume(history, state::Nothing, start, gain, add)
    h = history === nothing ? _empty_history(gain, add) : history
    return h, nothing, start
end
function _resume(history, state::State, start, gain, add)
    history === nothing || throw(
        ArgumentError(
            "pass history (a seed) or state (to resume), not both; got " *
                "history = $(_describe(history)) and a state at t = $(state.t)"
        )
    )
    start == state.t || throw(
        ArgumentError(
            "a resumed call starts at state.t = $(state.t), not " *
                "start = $(repr(start))"
        )
    )
    return state.history, state.states, state.t
end

# `prepend = true` joins the history and the output along time.
_prepend(prepend::Bool, history, y) = prepend ? _join(history, y) : y
_join(history::AbstractVector, y) = vcat(history, y)
# `cat` rather than `hcat`, which is ambiguous for some tracked array types.
_join(history::AbstractMatrix, y) = cat(history, y; dims = 2)
_join(::Nothing, y) = throw(ArgumentError("prepend = true needs a history, not nothing"))

# The call builds the positional arguments `(gain, add, h, s0, τ0, stop)`
# and routes them through the native rules; `route` is `r` or `NoAdjoint(r)`.
Base.@constprop :aggressive function _invoke(
        r::Recurrence, route, gain = true; history = nothing, state = nothing,
        add = nothing, start = _start(state), stop = nothing, prepend::Bool = false
    )
    args = _run_args(r, gain, history, state, add, start)
    return _prepend(prepend, history, adjoint_call(route, args..., stop))
end

function _run_args(r, gain, history, state, add, start)
    _check_start(start)
    _check_unwrapped(:gain, gain)
    _check_unwrapped(:add, add)
    h, s0, τ0 = _resume(history, state, start, gain, add)
    _check_primary_seed(r.kernel, history, start)
    return gain, add, h, s0, τ0
end

function forward(
        r::Recurrence, ::Run, gain = true; history = nothing, state = nothing,
        add = nothing, start = _start(state), stop = nothing
    )
    return _run_forward(r, _run_args(r, gain, history, state, add, start)..., stop)
end

# `with_state` routes through the rules too: a recurrence whose output is
# `(y, state)`.
struct _WithState{R <: Recurrence} <: AbstractOperator
    r::R
end
with_state(r::Recurrence, args...; kwargs...) = _with_state(r, r, args...; kwargs...)
function with_state(n::NoAdjoint{<:Recurrence}, args...; kwargs...)
    return _with_state(n.op, n, args...; kwargs...)
end
Base.@constprop :aggressive function _with_state(
        r::Recurrence, route, gain = true; history = nothing, state = nothing,
        add = nothing, start = _start(state), stop = nothing, prepend::Bool = false
    )
    args = _run_args(r, gain, history, state, add, start)
    y, st = adjoint_call(_reroute(route, _WithState(r)), args..., stop)
    return _prepend(prepend, history, y), st
end

# The rule applies when the coupling carries its adjoint and each modifier
# does or is differentiated locally (`_type_adjoint`, read off the types,
# which routes the call), and the local derivative rebuilds each modifier
# that uses it (`rebuilds`, found at construction).
function uses_adjoint(r::Recurrence, ::Run)
    return _type_adjoint(r, Run()) && _istrue(r.rebuilds)
end
uses_adjoint(w::_WithState, ::Run) = uses_adjoint(w.r, Run())
function _type_adjoint(r::Recurrence, ::Run)
    return uses_adjoint(r.coupling, Pressure()) &&
        _all_modifiers_adjoint(r.modifiers)
end
_type_adjoint(w::_WithState, ::Run) = _type_adjoint(w.r, Run())
_all_modifiers_adjoint(::Tuple{}) = true
function _all_modifiers_adjoint(ms::Tuple)
    return _modifier_adjoint(first(ms)) !== :none &&
        _all_modifiers_adjoint(Base.tail(ms))
end

# How the rule differentiates modifier `m`'s step: `:pullback` with its own
# `pullback!`, `:local` with a local derivative (a pointwise modifier with
# only scalar float parameters outside functions, rebuilt with dual numbers
# by `constructorof`), or `:none` when it cannot, which includes a
# `Derived` parameter whose map holds float fields of its own. Decided from
# the type; whether the rebuild works is checked by value at construction.
function _modifier_adjoint(m)
    _derived_local(m) || return :none
    uses_adjoint(m, Step()) && return :pullback
    ispointwise(m) && _scalar_params(m) && return :local
    return :none
end

# The `rebuilds` field: `Val(true)` when no modifier is rebuilt by the local
# derivative, which the types show, so the route folds; otherwise the
# outcome of the value check (`_round_trips`) for each one that is, and
# for the form of a depletion without its own pullback.
function _rebuild_flag(ms::Tuple)
    _any_rebuilt(ms) || return Val(true)
    return _all_rebuild(ms)
end
_any_rebuilt(::Tuple{}) = false
_any_rebuilt(ms::Tuple) = _rebuilt(first(ms)) || _any_rebuilt(Base.tail(ms))
_rebuilt(m) = _modifier_adjoint(m) === :local && _param_tuple(m) !== ()
function _rebuilt(m::Depletion)
    return !uses_adjoint(m.form, Step()) && _scalar_params(m.form) &&
        _param_tuple(m.form) !== ()
end
_all_rebuild(::Tuple{}) = true
_all_rebuild(ms::Tuple) = _rebuilds_modifier(first(ms)) && _all_rebuild(Base.tail(ms))
_rebuilds_modifier(m) = !_rebuilt(m) || _round_trips(m)
_rebuilds_modifier(m::Depletion) = !_rebuilt(m) || _round_trips(m.form)

_istrue(::Val{true}) = true
_istrue(b::Bool) = b

# Whether the local derivative rebuilds the operator's modifiers.
_rebuilds(op) = Val(true)
_rebuilds(r::Recurrence) = r.rebuilds
_rebuilds(w::_WithState) = _rebuilds(w.r)

# The plain-AD note names the modifiers and depletion forms that do not
# rebuild.
function _plain_why(r::Recurrence)
    _istrue(r.rebuilds) && return _ADJOINT_NOTE
    names = join(unique(_not_rebuilt(r.modifiers...)), ", ")
    return "has a modifier or depletion form ($names) whose constructor " *
        "does not give it back from its own parameters"
end
_plain_why(w::_WithState) = _plain_why(w.r)
_not_rebuilt() = ()
function _not_rebuilt(m, ms...)
    rest = _not_rebuilt(ms...)
    _rebuilds_modifier(m) && return rest
    return (nameof(typeof(m isa Depletion ? m.form : m)), rest...)
end

# Whether a type holds a float array (or a field of unknown type) that a
# local per-value derivative would have to carry, or a function with float
# fields of its own (a closure's captured values), which the local
# derivative does not reach. A closed function of the type, evaluated once
# per type by a generated function so the route folds.
@generated _scalar_params(m) = !_has_array_params(m)
function _has_array_params(::Type{T}) where {T}
    T <: AbstractArray && return eltype(T) <: AbstractFloat || !isconcretetype(eltype(T))
    T <: Function && return _has_float(T)
    T <: Union{Real, Nothing, Symbol, AbstractString} && return false
    isconcretetype(T) || return true
    for F in fieldtypes(T)
        _has_array_params(F) && return true
    end
    return false
end

# Whether a type holds a float, or a field of unknown type that may. A
# plain function or a callable singleton has no fields, so holds none.
function _has_float(::Type{T}) where {T}
    T <: Union{Integer, Nothing, Symbol, AbstractString, Type, Module} && return false
    T <: Real && return true
    T <: AbstractArray && return _has_float(eltype(T))
    isconcretetype(T) || return true
    for F in fieldtypes(T)
        _has_float(F) && return true
    end
    return false
end

# The positional Run: the output and the cache the reverse pass reads,
# including the state to resume from.
function _run_forward(r::Recurrence, gain, add, h, s0, τ0, stop)
    Y, _, _, cache = _recur(r, gain, add, h, s0, τ0, stop, Val(true))
    return Y, cache
end
_primal(r::Recurrence, args...) = first(_recur(r, args..., Val(false)))

function _run_forward(w::_WithState, gain, add, h, s0, τ0, stop)
    Y, _, _, cache = _recur(w.r, gain, add, h, s0, τ0, stop, Val(true))
    return (Y, cache.state), cache
end
function _primal(w::_WithState, gain, add, h, s0, τ0, stop)
    Y, H, states = _recur(w.r, gain, add, h, s0, τ0, stop, Val(false))
    return Y, _state(Y, H, states, h, τ0)
end

function _state(Y, H, states, h, τ0)
    T = size(Y, ndims(Y))
    L = size(H, 1) - T
    return State(_public(H, (T + 1):(T + L), h), states, τ0 + T)
end

_tape(x::AbstractArray) = copy(x)
_tape(x) = x

# A resumed state must have each modifier's `nstate` entries, as an
# `Init` would have written.
_check_states(modifiers, s0, S) = foreach(eachindex(modifiers), modifiers, s0) do i, m, s
    n = nstate(m, S)
    length(s) == n || throw(
        ArgumentError(
            "modifier $i ($(nameof(typeof(m)))) has a state of length " *
                "$(length(s)); expected nstate(m, $S) = $n"
        )
    )
end

# Checks the call, then runs the buffer loop at the promoted eltype.
function _recur(r::Recurrence, gain, add, h, s0, τ0, stop, record::Val)
    (; kernel, coupling, modifiers) = r
    L = _nlags(kernel)
    S = _nstrata(h)
    _check_kernel_strata(kernel, S)
    _check_coupling(coupling, S)
    _check_strata(:gain, gain, S)
    _check_strata(:add, add, S)
    s0 === nothing || length(s0) == length(modifiers) || throw(
        ArgumentError(
            "$(length(s0)) modifier states given for " *
                "$(length(modifiers)) modifiers"
        )
    )
    s0 === nothing || _check_states(modifiers, s0, S)
    stop = _stop(stop, (:gain => _extent(gain), :add => _extent(add)))
    τ0 >= 1 || throw(ArgumentError("start ($τ0) must be at least 1"))
    stop >= τ0 - 1 || throw(
        ArgumentError("stop ($stop) is before start ($τ0)")
    )
    _check_kernel_times(kernel, stop)
    _check_times(:coupling, coupling, stop)
    _check_times(:modifiers, modifiers, stop)
    T = stop - τ0 + 1
    Tp = float(param_eltype((r, gain, add, h, s0)))
    return _run(Tp, r, gain, add, h, s0, τ0, L, S, T, record)
end

# `I` and `Diagonal` scale each stratum's own convolution, so their steps
# skip the pressure vectors.
const _PointwiseCoupling = Union{UniformScaling, Diagonal}
_coef(J::UniformScaling, k) = J.λ
_coef(C::Diagonal, k) = C.diag[k]

# Fill the pressure vectors for step `t`; pointwise couplings need none.
_prepare!(ex, p, q, C::_PointwiseCoupling, kernel, H, t, τ, L) = nothing
function _prepare!(ex, p, q, C, kernel, H, t, τ, L)
    _kernel_pressure!(ex, p, kernel, H, t, τ, L)
    forward(C, Pressure(), q, p, τ)
    return nothing
end

# Stratum `k`'s kernel convolution and coupled pressure at step `t`.
function _pressure_at(C::_PointwiseCoupling, kernel, p, q, H, t, τ, L, k)
    pk = _kdot(kernel, H, t, τ, L, k)
    return pk, _coef(C, k) * pk
end
_pressure_at(C, kernel, p, q, H, t, τ, L, k) = (p[k], q[k])

_all_pointwise(::Tuple{}) = true
_all_pointwise(ms::Tuple) = ispointwise(first(ms)) && _all_pointwise(Base.tail(ms))

# Thread one stratum's value through pointwise modifiers in tuple order,
# recording each modifier's input value and state when `rec` holds records.
_thread(::Tuple{}, ::Tuple{}, rec, v, τ, t, k) = v
function _thread(ms::Tuple, states::Tuple, rec, v, τ, t, k)
    s = first(states)
    rec === nothing || _record!(first(rec), v, s[k], t, k)
    v′, s[k] = forward(first(ms), Step(), v, s[k], τ, k)
    return _thread(Base.tail(ms), Base.tail(states), _tail(rec), v′, τ, t, k)
end
_tail(::Nothing) = nothing
_tail(rec::Tuple) = Base.tail(rec)
function _record!(rec, v, s, t, k)
    rec.V[k, t] = v
    rec.S[k, t] = s
    return nothing
end

# Run vector-level modifiers in tuple order, recording their inputs.
_stages_rec!(::Tuple{}, ::Tuple{}, ::Tuple{}, v, τ, t) = nothing
function _stages_rec!(ms::Tuple, states::Tuple, rec::Tuple, v, τ, t)
    copyto!(view(first(rec).V, :, t), v)
    copyto!(view(first(rec).S, :, t), first(states))
    forward(first(ms), Step(), v, first(states), τ)
    return _stages_rec!(Base.tail(ms), Base.tail(states), Base.tail(rec), v, τ, t)
end

# Each modifier's initial state, written by its Init into a vector at the
# buffer eltype.
function _init_state(::Type{Tp}, m, h, S) where {Tp}
    s = _zeros(h, Tp, nstate(m, S))
    forward(m, Init(), s, h)
    return s
end

# Strata run on their own when the coupling is pointwise, the kernel does
# not mix strata and every modifier is pointwise: no step reads another
# stratum.
_independent(coupling, kernel, modifiers) = false
function _independent(
        ::_PointwiseCoupling, kernel, modifiers::Tuple
    )
    return !(kernel isa _PairwiseKernel) && _all_pointwise(modifiers)
end

# Stratum `k`'s value at step `t` before the modifiers, recording its kernel
# convolution and pressure in `P` and `X` when they are not `nothing`.
@inline function _value!(P, X, gain, add, coupling, kernel, p, q, H, t, τ, L, k)
    pk, xk = _pressure_at(coupling, kernel, p, q, H, t, τ, L, k)
    _record_pressure!(P, X, pk, xk, t, k)
    return _at(gain, k, τ) * xk + _at(add, k, τ)
end
_record_pressure!(::Nothing, ::Nothing, pk, xk, t, k) = nothing
@inline function _record_pressure!(P, X, pk, xk, t, k)
    P[k, t] = pk
    X[k, t] = xk
    return nothing
end

# The whole run of the independent strata `ks`, time outermost.
function _series_body!(
        ks, H, P, X, gain, add, coupling, kernel, p, q, ms, states, rec, τ0, L, T
    )
    for t in 1:T
        τ = τ0 + t - 1
        for k in ks
            x = _value!(P, X, gain, add, coupling, kernel, p, q, H, t, τ, L, k)
            H[L + t, k] = _thread(ms, states, rec, x, τ, t, k)
        end
    end
    return nothing
end

# Stratum `k` at step `t`, through pointwise modifiers to the buffer.
function _step_body!(
        k, H, P, X, gain, add, coupling, kernel, p, q, ms, states, rec, t, τ, L
    )
    x = _value!(P, X, gain, add, coupling, kernel, p, q, H, t, τ, L, k)
    H[L + t, k] = _thread(ms, states, rec, x, τ, t, k)
    return nothing
end

# Stratum `k` at step `t`, collected for the modifiers' vector Step.
function _value_body!(k, v, P, X, gain, add, coupling, kernel, p, q, H, t, τ, L)
    v[k] = _value!(P, X, gain, add, coupling, kernel, p, q, H, t, τ, L, k)
    return nothing
end

# The buffer loop: returns the output, the buffer, the final states and,
# when recording, the cache the reverse pass reads. Buffer row `L + t`
# holds absolute time `τ0 + t - 1`. The records are the kernel convolutions
# `P` and pressures `X` of every step (strata × steps), and each modifier's
# input values and states.
#
# Independent strata run in blocks, each block over the whole series, so a
# threaded run splits the strata once per call rather than once per step.
# Otherwise each step is a loop over strata: with pointwise modifiers each
# stratum's value goes straight to the buffer, else the step's values are
# collected for the vector Step. Vector Steps (such as `Allocate`,
# `Redistribute` and `Protected`) read every stratum, so they run on the
# calling task whatever the executor.
function _run(::Type{Tp}, r, gain, add, h, s0, τ0, L, S, T, record::Val) where {Tp}
    c = _current()
    # The default executor is passed as the singleton `Serial()`, so the loop
    # below holds no abstractly typed executor.
    if c.ex isa Serial
        return _run(Tp, Serial(), r, gain, add, h, s0, τ0, L, S, T, record)
    end
    return _run(Tp, c, r, gain, add, h, s0, τ0, L, S, T, record)
end

function _run(
        ::Type{Tp}, ex::Union{Serial, _Current}, r, gain, add, h, s0, τ0, L, S, T,
        ::Val{record}
    ) where {Tp, record}
    (; coupling, modifiers) = r
    kernel = _oldest_first(r.kernel)
    H = _load_history!(_zeros(h, Tp, L + T, S), h, L)
    p = _zeros(h, Tp, S)
    q = _zeros(h, Tp, S)
    v = _zeros(h, Tp, S)
    states = if s0 === nothing
        map(m -> _init_state(Tp, m, h, S), modifiers)
    else
        map(s -> _state_vector(Tp, s), s0)
    end
    init = record ? map(copy, states) : nothing
    P = record ? _zeros(h, Tp, S, T) : nothing
    X = record ? _zeros(h, Tp, S, T) : nothing
    rec = record ?
        map(
            m -> (; V = _zeros(h, Tp, S, T), S = _zeros(h, Tp, nstate(m, S), T)),
            modifiers
        ) :
        nothing
    work = S * _kwork(kernel, S, L)
    if _independent(coupling, kernel, modifiers)
        _blocks!(
            _series_body!, ex, H, S, T * work,
            H, P, X, gain, add, coupling, kernel, p, q, modifiers, states, rec,
            τ0, L, T
        )
    else
        for t in 1:T
            τ = τ0 + t - 1
            _prepare!(ex, p, q, coupling, kernel, H, t, τ, L)
            if _all_pointwise(modifiers)
                _each!(
                    _step_body!, ex, H, S, work,
                    H, P, X, gain, add, coupling, kernel, p, q, modifiers, states,
                    rec, t, τ, L
                )
            else
                _each!(
                    _value_body!, ex, H, S, work,
                    v, P, X, gain, add, coupling, kernel, p, q, H, t, τ, L
                )
                if record
                    _stages_rec!(modifiers, states, rec, v, τ, t)
                else
                    _stages!(modifiers, states, v, τ)
                end
                for k in eachindex(v)
                    H[L + t, k] = v[k]
                end
            end
        end
    end
    Y = _public(H, (L + 1):(L + T), h)
    # The cache holds copies of the inputs the reverse pass reads, so a
    # caller overwriting them after the call cannot change the gradient.
    cache = record ?
        (;
            r, kernel, gain = _tape(gain), add, h = _tape(h), s0, τ0, L, S, T, H,
            P, X, rec, init, state = State(_public(H, (T + 1):(T + L), h), states, τ0 + T),
        ) : nothing
    return Y, H, states, cache
end

@doc raw"""
Run `r` from a seed and return the seed followed by the run.

Deprecated: `seeded(r, gain; history)` is
`r(gain; history, start = m + 1, prepend = true)`, see [`Recurrence`](@ref).

With a seed ``h = (h_1, \dots, h_m)`` placed at times ``1, \dots, m`` it
returns

```math
(h_1, \dots, h_m,\ y_{m+1}, \dots, y_{t_1}),
```

where ``y_t`` for ``t > m`` is the output of `r` started at ``t_0 = m + 1``
from history ``h``, and ``t_1`` is the last time.

# Arguments
- `r`: the [`Recurrence`](@ref).
- `gain`: the gain, as in a call of `r`.

# Keyword Arguments
- `history`: the seed, length `m` or `S × m`.
- `kwargs`: passed to the call of `r`, such as `add` or `stop`.

# Examples
```jldoctest
using ComposableRecurrences
seed = [2.0, 3.0, 4.0]
r = Recurrence([0.3, 0.5, 0.2])
y = r([0.0, 0.0, 0.0, 2.5, 2.2, 1.8]; history = seed, start = 4, prepend = true)
round.(y; digits = 3)

# output

6-element Vector{Float64}:
  2.0
  3.0
  4.0
  7.75
 10.835
 14.266
```
"""
function seeded(r::Recurrence, gain = true; history, kwargs...)
    Base.depwarn(
        "seeded(r, gain; history) is deprecated, use " *
            "r(gain; history, start = m + 1, prepend = true)", :seeded
    )
    return r(gain; history, start = size(history, ndims(history)) + 1, prepend = true, kwargs...)
end

@doc raw"""
A history growing exponentially at rate `r` and reaching `I0` at its last
time, to seed a [`Recurrence`](@ref) on a growth path.

For one series, and for stratum ``i`` of ``S``, it is

```math
h_l = I_0\, e^{r (l - L)}
\qquad \text{and} \qquad
h_{i,l} = I_{0,i}\, e^{r_i (l - L)},
\qquad l = 1, \dots, L,
```

oldest first, so ``h_L = I_0``.
For a renewal with generation interval ``g`` (lag 1 first) and constant
reproduction number ``R``, the growth rate that keeps the seed on the
renewal's own path solves

```math
1 = R \sum_{l \ge 1} g_l\, e^{-r l}.
```

# Arguments
- `I0`: the value at the last time; a vector gives one per stratum.
- `r`: the growth rate per step; with a vector `I0`, a scalar or one per
  stratum.
- `L`: the number of time steps, at least 1, usually the kernel length.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
g = [0.2, 0.5, 0.3]
h = CR.exponential_history(5.0, 0.1, length(g))
round.(Recurrence(g)(fill(1.2, 6); history = h, prepend = true); digits = 3)

# output

9-element Vector{Float64}:
 4.094
 4.524
 5.0
 5.388
 5.922
 6.454
 7.042
 7.694
 8.395
```
"""
exponential_history(I0::Real, r::Real, L::Integer) = I0 .* exp.(r .* _steps_to_last(L))
function exponential_history(I0::AbstractVector, r, L::Integer)
    return I0 .* exp.(r .* transpose(_steps_to_last(L)))
end

# The times of an `L`-step history counted back from its last, `1 - L` to 0.
function _steps_to_last(L)
    L >= 1 || throw(ArgumentError("a history needs L >= 1 steps, not L = $L"))
    return collect((1 - L):0)
end
