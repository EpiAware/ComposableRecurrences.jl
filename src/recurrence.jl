@doc raw"
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
A [`Pairwise`](@ref) `S × S × L` kernel (or `TimeVarying(Pairwise(A))`)
weights every pair of strata and already mixes them, so its coupling is `I`.
The coupling is `I` (or a scaled `λ * I`), any `S × S` matrix (dense,
sparse, `Diagonal`), a [`TimeVarying`](@ref) `S × S × T` array, or any
struct with `forward` on [`ComposableRecurrences.Pressure`](@ref).
Modifiers are structs with `forward` on [`ComposableRecurrences.Step`](@ref)
and, for an initial state, [`ComposableRecurrences.Init`](@ref).

Called as `r(gain = 1; history, state, add = nothing, start, stop)`, the
call covers the absolute times `start:stop`:

  - `gain`: a scalar, a length-`T` vector shared by every stratum, or
    `S × T`, read at absolute time `t`; one when left out.
  - `history`: the outputs at times `start - m` to `start - 1`, oldest
    first, length `m` for a single series or `S × m`; zeros when left out.
    The recursion reads the last `L`, and a history shorter than `L` is
    zero-padded. A modifier's `Init` sees all of it.
  - `state`: a [`ComposableRecurrences.State`](@ref) from
    [`ComposableRecurrences.with_state`](@ref), to resume from it; not with
    `history` or `start`.
  - `add`: `nothing`, a scalar, length `T` or `S × T`, read at time `t`.
  - `start`: the first time; `1`, or `state.t` when resuming.
  - `stop`: the last time; by default the common length of the
    time-indexed inputs (`gain`, `add`), required without one.

Every time-indexed array, kernels, couplings and modifier parameters
included, must cover `stop`.
The output is length `stop - start + 1` for a single series or `S` rows of
it; the history sets which, and the number of strata.
The buffer eltype promotes [`ComposableRecurrences.param_eltype`](@ref) of
every input and field, so Float32 inputs give a Float32 output and
dual numbers pass through any slot.

# Arguments
- `kernel`: the kernel, lag 1 first.

# Keyword Arguments
- `coupling`: how the strata's kernel convolutions mix; `I` by default.
- `modifiers`: a tuple of modifiers applied after the core of each step.

# Examples
```@example
using ComposableRecurrences
g = [0.6, 0.3, 0.1]                   # weights on lags 1, 2, 3
K = [0.9 0.1; 0.2 0.8]
R = fill(1.1, 2, 10)
r = Recurrence(g; coupling = K)
y = r(R; history = ones(2, 3))

# Resume from the returned state over the same inputs.
y1, state = ComposableRecurrences.with_state(r, R; history = ones(2, 3), stop = 5)
y2 = r(R; state)
y ≈ hcat(y1, y2)
```
"
struct Recurrence{K, C, M <: Tuple} <: AbstractOperator
    "The kernel, lag 1 first."
    kernel::K
    "How the strata's kernel convolutions mix."
    coupling::C
    "The modifiers, applied in order after the core of each step."
    modifiers::M
    function Recurrence(kernel::K, coupling::C, modifiers::M) where {
            K, C, M <: Tuple,
        }
        _check_kernel_shape(kernel)
        kernel isa TimeVarying{Primary} && throw(
            ArgumentError(
                "a Primary() time-varying kernel is not yet supported by " *
                    "Recurrence"
            )
        )
        _check_coupling_shape(coupling)
        _check_pairwise_coupling(kernel, coupling)
        return new{K, C, M}(kernel, coupling, modifiers)
    end
end

function Recurrence(kernel; coupling = I, modifiers = ())
    return Recurrence(kernel, coupling, Tuple(modifiers))
end

@doc raw"
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
```@example
using ComposableRecurrences
CR = ComposableRecurrences
r = Recurrence([0.5, 0.5])
y, state = CR.with_state(r, fill(1.1, 6); history = ones(2), stop = 3)
state.t, r(fill(1.1, 6); state)
```
"
struct State{H, M, T}
    "The last `L` outputs, in the history's layout."
    history::H
    "Each modifier's state."
    states::M
    "The time of the next step."
    t::T
end

@doc raw"
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
```@example
using ComposableRecurrences
CR = ComposableRecurrences
r = Recurrence([0.6, 0.4])
R = fill(1.1, 8)
y1, state = CR.with_state(r, R; history = ones(2), stop = 4)
vcat(y1, r(R; state)) ≈ r(R; history = ones(2))
```
"
function with_state(op, args...; kwargs...)
    y, cache = forward(op, Run(), args...; kwargs...)
    hasproperty(cache, :state) || throw(
        ArgumentError("$(nameof(typeof(op))) has no state to return")
    )
    return y, cache.state
end

# A Pairwise kernel already mixes strata, so its coupling is `I`.
_check_pairwise_coupling(kernel, coupling) = nothing
function _check_pairwise_coupling(::_PairwiseKernel, coupling)
    coupling isa UniformScaling && isone(coupling.λ) || throw(
        ArgumentError(
            "a Pairwise kernel already mixes strata, so its coupling must " *
                "be I"
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
                "TimeVarying, not a $(typeof(k))"
        )
    )
end
function _check_kernel_shape(k::AbstractArray)
    throw(
        ArgumentError(
            "a kernel array is a vector of lag weights; wrap a strata × " *
                "lags matrix as PerStratum(G) and a strata × strata × lags " *
                "array as Pairwise(A)"
        )
    )
end
function _check_kernel_shape(k::PerStratum)
    throw(ArgumentError("a PerStratum kernel is a strata × lags matrix"))
end
function _check_kernel_shape(k::Pairwise)
    throw(ArgumentError("a Pairwise kernel is a strata × strata × lags array"))
end
function _check_kernel_shape(k::TimeVarying)
    throw(
        ArgumentError(
            "a TimeVarying kernel is lags × time, TimeVarying(PerStratum(G)) " *
                "with G strata × lags × time, or TimeVarying(Pairwise(A)) " *
                "with A strata × strata × lags × time"
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
    for i in 1:L
        acc += _weight(g, a, a, i, τ) * H[t + L - i, a]
    end
    return acc
end
function _kdot(g::_PairwiseKernel, H, t, τ, L, a)
    acc = zero(eltype(H))
    for i in 1:L, b in axes(H, 2)
        acc += _weight(g, a, b, i, τ) * H[t + L - i, b]
    end
    return acc
end

function _kernel_pressure!(p, g, H, t, τ, L)
    for k in eachindex(p)
        p[k] = _kdot(g, H, t, τ, L, k)
    end
    return p
end

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

# CPU buffers load by loop: a broadcast copy may alias its source, and Enzyme
# cannot give that branch one activity when the history is constant.
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

# The history, modifier states and first time of a call: seeded from
# `history`, or resumed from `state`.
function _resume(history, state::Nothing, start, gain, add)
    h = history === nothing ? _empty_history(gain, add) : history
    return h, nothing, start === nothing ? 1 : start
end
function _resume(history, state::State, start, gain, add)
    history === nothing || throw(
        ArgumentError(
            "pass history (a seed) or state (to resume), not both"
        )
    )
    start === nothing || throw(
        ArgumentError("a resumed call starts at state.t; do not pass start")
    )
    return state.history, state.states, state.t
end

# The call builds the positional arguments `(gain, add, h, s0, τ0, stop)`
# and routes them through the native rules; `route` is `r` or `NoAdjoint(r)`.
Base.@constprop :aggressive function _invoke(
        r::Recurrence, route, gain = true; history = nothing, state = nothing,
        add = nothing, start = nothing, stop = nothing
    )
    return adjoint_call(route, _run_args(gain, history, state, add, start)..., stop)
end

function _run_args(gain, history, state, add, start)
    _check_unwrapped(:gain, gain)
    _check_unwrapped(:add, add)
    h, s0, τ0 = _resume(history, state, start, gain, add)
    return gain, add, h, s0, τ0
end

function forward(
        r::Recurrence, ::Run, gain = true; history = nothing, state = nothing,
        add = nothing, start = nothing, stop = nothing
    )
    return _run_forward(r, _run_args(gain, history, state, add, start)..., stop)
end

# `with_state` routes through the rules too: a recurrence whose output is
# `(y, state)`.
struct _WithState{R <: Recurrence} <: AbstractOperator
    r::R
end
Base.@constprop :aggressive function with_state(
        r::Recurrence, gain = true; history = nothing, state = nothing,
        add = nothing, start = nothing, stop = nothing
    )
    args = _run_args(gain, history, state, add, start)
    return adjoint_call(_WithState(r), args..., stop)
end

# The rule applies when the coupling carries its adjoint and each modifier
# does or is pointwise with only scalar float parameters.
function uses_adjoint(r::Recurrence, ::Run)
    return uses_adjoint(r.coupling, Pressure()) &&
        _all_modifiers_adjoint(r.modifiers)
end
uses_adjoint(w::_WithState, ::Run) = uses_adjoint(w.r, Run())
_all_modifiers_adjoint(::Tuple{}) = true
function _all_modifiers_adjoint(ms::Tuple)
    return _modifier_adjoint(first(ms)) && _all_modifiers_adjoint(Base.tail(ms))
end
function _modifier_adjoint(m)
    return uses_adjoint(m, Step()) || (ispointwise(m) && _scalar_params(m))
end

# Whether a type holds a float array (or a field of unknown type) that a
# local per-value derivative would have to carry. A closed function of the
# type, evaluated once per type by a generated function so the route folds.
@generated _scalar_params(m) = !_has_array_params(m)
function _has_array_params(::Type{T}) where {T}
    T <: AbstractArray && return eltype(T) <: AbstractFloat || !isconcretetype(eltype(T))
    T <: Union{Real, Nothing, Symbol, AbstractString, Function} && return false
    isconcretetype(T) || return true
    for F in fieldtypes(T)
        _has_array_params(F) && return true
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
_prepare!(p, q, C::_PointwiseCoupling, kernel, H, t, τ, L) = nothing
function _prepare!(p, q, C, kernel, H, t, τ, L)
    _kernel_pressure!(p, kernel, H, t, τ, L)
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
    s = _zeros(h, Tp, S)
    forward(m, Init(), s, h)
    return s
end

# The buffer loop: returns the output, the buffer, the final states and,
# when recording, the cache the reverse pass reads. Buffer row `L + t`
# holds absolute time `τ0 + t - 1`. The records are the kernel convolutions
# `P` and pressures `X` of every step (strata × steps), and each modifier's
# input values and states. With pointwise modifiers each stratum's value
# goes straight to the buffer; otherwise the step's values are collected
# for the vector Step.
function _run(
        ::Type{Tp}, r, gain, add, h, s0, τ0, L, S, T, ::Val{record}
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
        map(_ -> (; V = _zeros(h, Tp, S, T), S = _zeros(h, Tp, S, T)), modifiers) :
        nothing
    for t in 1:T
        τ = τ0 + t - 1
        _prepare!(p, q, coupling, kernel, H, t, τ, L)
        if _all_pointwise(modifiers)
            for k in eachindex(v)
                pk, xk = _pressure_at(coupling, kernel, p, q, H, t, τ, L, k)
                if record
                    P[k, t] = pk
                    X[k, t] = xk
                end
                x = _at(gain, k, τ) * xk + _at(add, k, τ)
                H[L + t, k] = _thread(modifiers, states, rec, x, τ, t, k)
            end
        else
            for k in eachindex(v)
                pk, xk = _pressure_at(coupling, kernel, p, q, H, t, τ, L, k)
                if record
                    P[k, t] = pk
                    X[k, t] = xk
                end
                v[k] = _at(gain, k, τ) * xk + _at(add, k, τ)
            end
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

@doc raw"
Run `r` from a seed and return the seed followed by the run.

With a seed ``h = (h_1, \dots, h_m)`` placed at times ``1, \dots, m`` it
returns

```math
(h_1, \dots, h_m,\ y_{m+1}, \dots, y_{t_1}),
```

where ``y_t`` for ``t > m`` is the output of `r` started at ``t_0 = m + 1``
from history ``h``, and ``t_1`` is the last time.
Equivalent to
`cat(history, r(gain; history, start = m + 1, kwargs...); dims = ndims(history))`:
the time-indexed inputs are full length, their first ``m`` times covering
the seed.
A seed shorter than the kernel is zero-padded.

# Arguments
- `r`: the [`Recurrence`](@ref).
- `gain`: the gain, as in a call of `r`.

# Keyword Arguments
- `history`: the seed, length `m` or `S × m`.
- `kwargs`: passed to the call of `r`, such as `add` or `stop`.

# Examples
```@example
using ComposableRecurrences
CR = ComposableRecurrences
seed = [2.0, 3.0, 4.0]
r = Recurrence([0.3, 0.5, 0.2]; modifiers = (CR.Depletion(80.0; pool0 = 80.0 - sum(seed)),))
CR.seeded(r, [0.0, 0.0, 0.0, 2.5, 2.2, 1.8]; history = seed)
```
"
function seeded(r::Recurrence, gain = true; history, kwargs...)
    m = size(history, ndims(history))
    y = r(gain; history, start = m + 1, kwargs...)
    return cat(history, y; dims = ndims(history))
end
