@doc "
A recurrence over strata whose kernel starts at lag 1, stepped from a window
of its own past values.

At time `t`, each stratum's kernel convolution of its last `L` values is
mixed by the coupling, scaled by the gain and shifted by the add input,
then passed through the modifiers in tuple order:

    x_t = coupling_t(Σ_i kernel_t[i] y_{t-i})
    v_t = gain_t ⊙ x_t + add_t
    (y_t, s_t) = modifiers(v_t, s_{t-1})

`kernel[i]` weights `y_{t-i}`, as a generation interval or AR coefficients
are written: a recurrence has no lag 0.
The kernel is a length-`L` vector shared by every stratum, a
[`PerStratum`](@ref) `S × L` matrix, or a [`TimeVarying`](@ref) `L × T` or
`TimeVarying(PerStratum(G))` with `G` `S × L × T`.
The coupling is `I` (or a scaled `λ * I`), any `S × S` matrix (dense,
sparse, `Diagonal`), a [`TimeVarying`](@ref) `S × S × T` array, or a
[`Pairwise`](@ref) kernel with `kernel = nothing`.
Modifiers implement [`ComposableRecurrences.apply!`](@ref) or the pointwise
[`ComposableRecurrences.apply`](@ref).

Called as
`r(gain = 1; history, state, add = nothing, start, stop, return_state = false)`,
the call covers the absolute times `start:stop`:

  - `gain`: a scalar, a length-`T` vector shared by every stratum, or
    `S × T`, read at absolute time `t`; one when left out.
  - `history`: the outputs at times `start - m` to `start - 1`, oldest
    first, length `m` for a single series or `S × m`; zeros when left out.
    The recursion reads the last `L`, and a history shorter than `L` is
    zero-padded. [`ComposableRecurrences.init_state`](@ref) sees all of it.
  - `state`: a [`ComposableRecurrences.State`](@ref) returned by an earlier
    call, to resume from it; not with `history` or `start`.
  - `add`: `nothing`, a scalar, length `T` or `S × T`, read at time `t`.
  - `start`: the first time; `1`, or `state.t` when resuming.
  - `stop`: the last time; by default the common length of the
    time-indexed inputs (`gain`, `add`), required without one.
  - `return_state`: also return the [`ComposableRecurrences.State`](@ref)
    to resume from.

Every time-indexed array, kernels, couplings and modifier parameters
included, must cover `stop`.
The output is length `stop - start + 1` for a single series or `S` rows of
it; the history sets which, and the number of strata.
The buffer eltype promotes [`ComposableRecurrences.param_eltype`](@ref) of
every input and field, so Float32 inputs give a Float32 output and
dual numbers pass through any slot.

# Arguments
- `kernel`: the kernel, lag 1 first, or `nothing` with a
  [`Pairwise`](@ref) coupling.

# Keyword Arguments
- `coupling`: how the strata's kernel convolutions mix; `I` by default.
- `modifiers`: a tuple of modifiers applied after the core of each step.

# Examples
```@example
using ComposableRecurrences, LinearAlgebra
g = [0.6, 0.3, 0.1]                   # weights on lags 1, 2, 3
K = [0.9 0.1; 0.2 0.8]
R = fill(1.1, 2, 10)
r = Recurrence(g; coupling = K)
y = r(R; history = ones(2, 3))

# Resume from the returned state over the same inputs.
y1, state = r(R; history = ones(2, 3), stop = 5, return_state = true)
y2 = r(R; state)
y ≈ hcat(y1, y2)
```
"
struct Recurrence{K, C, M <: Tuple}
    "The kernel, lag 1 first, or `nothing` with a pairwise coupling."
    kernel::K
    "How the strata's kernel convolutions mix."
    coupling::C
    "The modifiers, applied in order after the core of each step."
    modifiers::M
    function Recurrence(kernel::K, coupling::C, modifiers::M) where {
            K, C, M <: Tuple,
        }
        _check_kernel_shape(kernel)
        kernel isa TimeVarying{_Primary} && throw(
            ArgumentError(
                "a :primary time-varying kernel is not yet supported by " *
                    "Recurrence"
            )
        )
        _check_coupling_shape(coupling)
        _check_kernel(kernel, coupling)
        return new{K, C, M}(kernel, coupling, modifiers)
    end
end

function Recurrence(kernel; coupling = I, modifiers = ())
    return Recurrence(kernel, coupling, Tuple(modifiers))
end

@doc "
The state a [`Recurrence`](@ref) call returns with `return_state = true`,
passed back as `state` to resume.

`history` holds the last `L` outputs, `states` each modifier's state and
`t` the time of the next step.

# Examples
```@example
using ComposableRecurrences
r = Recurrence([0.5, 0.5])
y, state = r(fill(1.1, 6); history = ones(2), stop = 3, return_state = true)
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

_check_kernel(kernel, coupling) = nothing
function _check_kernel(::Nothing, coupling)
    throw(ArgumentError("kernel = nothing needs a Pairwise coupling"))
end
function _check_kernel(kernel, ::Pairwise)
    throw(ArgumentError("a Pairwise coupling needs kernel = nothing"))
end
_check_kernel(::Nothing, ::Pairwise) = nothing

# The kernel shapes: a bare array is lags only, strata and time are added
# by wrappers.
_check_kernel_shape(k) = nothing
_check_kernel_shape(k::AbstractVector) = nothing
_check_kernel_shape(k::PerStratum{<:AbstractMatrix}) = nothing
_check_kernel_shape(k::TimeVarying{<:Any, <:AbstractMatrix}) = nothing
function _check_kernel_shape(
        k::TimeVarying{<:Any, <:PerStratum{<:AbstractArray{<:Any, 3}}}
    )
    return nothing
end
function _check_kernel_shape(k::AbstractArray)
    throw(
        ArgumentError(
            "a kernel array is a vector of lag weights; wrap a strata × " *
                "lags matrix as PerStratum(G)"
        )
    )
end
function _check_kernel_shape(k::PerStratum)
    throw(ArgumentError("a PerStratum kernel is a strata × lags matrix"))
end
function _check_kernel_shape(k::TimeVarying)
    throw(
        ArgumentError(
            "a TimeVarying kernel is lags × time, or " *
                "TimeVarying(PerStratum(G)) with G strata × lags × time"
        )
    )
end

_nlags(k::AbstractVector, c) = length(k)
_nlags(k::PerStratum, c) = size(k.x, 2)
_nlags(k::TimeVarying, c) = (A = _array(k); size(A, ndims(A) - 1))
_nlags(::Nothing, c::Pairwise) = size(c.x, 3)

# Kernel strata checks against `S` strata.
_check_kernel_strata(k, S) = nothing
_check_kernel_strata(k::TimeVarying, S) = _check_kernel_strata(k.x, S)
function _check_kernel_strata(k::PerStratum, S)
    size(k.x, 1) == S || throw(
        DimensionMismatch("kernel has $(size(k.x, 1)) strata, expected $S")
    )
    return nothing
end

# Fixed kernels are reversed once per call so each step is one `dot` of
# the kernel with a contiguous, oldest-first window.
_oldest_first(g::AbstractVector) = reverse(g)
_oldest_first(g::PerStratum) = PerStratum(reverse(g.x; dims = 2))
_oldest_first(g) = g

# Stratum `k`'s kernel convolution of its window `H[t:(t + L - 1), k]`,
# for a kernel prepared by `_oldest_first`; `τ` is the absolute time.
_kdot(g::AbstractVector, H, t, τ, L, k) = dot(g, view(H, t:(t + L - 1), k))
function _kdot(g::PerStratum, H, t, τ, L, k)
    return dot(view(g.x, k, :), view(H, t:(t + L - 1), k))
end
function _kdot(g::TimeVarying, H, t, τ, L, k)
    acc = zero(eltype(H))
    for i in 1:L
        acc += _tv_weight(g.x, k, i, τ) * H[t + L - i, k]
    end
    return acc
end

function _kernel_pressure!(p, g, H, t, τ, L)
    for k in eachindex(p)
        p[k] = _kdot(g, H, t, τ, L, k)
    end
    return p
end
_kernel_pressure!(p, ::Nothing, H, t, τ, L) = p

# A time-varying kernel's weight on lag (or delay) index `j` in column `τ`.
_tv_weight(x::AbstractMatrix, k, j, τ) = x[j, τ]
_tv_weight(x::PerStratum, k, j, τ) = x.x[k, j, τ]

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

Base.@constprop :aggressive function (r::Recurrence)(
        gain = true; history = nothing, state = nothing, add = nothing,
        start = nothing, stop = nothing, return_state = false
    )
    _check_unwrapped(:gain, gain)
    _check_unwrapped(:add, add)
    h, s0, τ0 = _resume(history, state, start, gain, add)
    Y, H, states = _recur(r, gain, add, h, s0, τ0, stop)
    return_state || return Y
    T = size(Y, ndims(Y))
    L = size(H, 1) - T
    return Y, State(_public(H, (T + 1):(T + L), h), states, τ0 + T)
end

# Checks the call, then runs the buffer loop at the promoted eltype.
function _recur(r::Recurrence, gain, add, h, s0, τ0, stop)
    (; kernel, coupling, modifiers) = r
    L = _nlags(kernel, coupling)
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
    return _run(Tp, r, gain, add, h, s0, τ0, L, S, T)
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
    pressure!(q, C, p, view(H, t:(t + L - 1), :), τ)
    return nothing
end

# Stratum `k`'s coupled pressure at step `t`.
function _pressure_at(C::_PointwiseCoupling, kernel, q, H, t, τ, L, k)
    return _coef(C, k) * _kdot(kernel, H, t, τ, L, k)
end
_pressure_at(C, kernel, q, H, t, τ, L, k) = q[k]

_all_pointwise(::Tuple{}) = true
_all_pointwise(ms::Tuple) = ispointwise(first(ms)) && _all_pointwise(Base.tail(ms))

# Thread one stratum's value through pointwise modifiers in tuple order.
_thread(::Tuple{}, ::Tuple{}, v, τ, k) = v
function _thread(ms::Tuple, states::Tuple, v, τ, k)
    s = first(states)
    v′, s[k] = apply(first(ms), v, s[k], τ, k)
    return _thread(Base.tail(ms), Base.tail(states), v′, τ, k)
end

# The buffer loop: returns the output, the buffer and the final states.
# Buffer row `L + t` holds absolute time `τ0 + t - 1`. With pointwise
# modifiers each stratum's value goes straight to the buffer; otherwise the
# step's values are collected for `apply!`.
function _run(::Type{Tp}, r, gain, add, h, s0, τ0, L, S, T) where {Tp}
    (; coupling, modifiers) = r
    kernel = _oldest_first(r.kernel)
    H = _load_history!(_zeros(h, Tp, L + T, S), h, L)
    p = _zeros(h, Tp, S)
    q = _zeros(h, Tp, S)
    v = _zeros(h, Tp, S)
    states = if s0 === nothing
        map(m -> _state_vector(Tp, init_state(m, h)), modifiers)
    else
        map(s -> _state_vector(Tp, s), s0)
    end
    for t in 1:T
        τ = τ0 + t - 1
        _prepare!(p, q, coupling, kernel, H, t, τ, L)
        if _all_pointwise(modifiers)
            for k in eachindex(v)
                x = _at(gain, k, τ) *
                    _pressure_at(coupling, kernel, q, H, t, τ, L, k) +
                    _at(add, k, τ)
                H[L + t, k] = _thread(modifiers, states, x, τ, k)
            end
        else
            for k in eachindex(v)
                v[k] = _at(gain, k, τ) *
                    _pressure_at(coupling, kernel, q, H, t, τ, L, k) +
                    _at(add, k, τ)
            end
            _stages!(modifiers, states, v, τ)
            for k in eachindex(v)
                H[L + t, k] = v[k]
            end
        end
    end
    return _public(H, (L + 1):(L + T), h), H, states
end

@doc "
Run `r` from a seed and return the seed followed by the run.

Equivalent to
`cat(history, r(gain; history, start = m + 1, kwargs...); dims = ndims(history))`
with `m` the seed's length: the time-indexed inputs are full length, their
first `m` times covering the seed.
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
r = Recurrence([0.3, 0.5, 0.2]; modifiers = (CR.Depletion(80.0; seeded = true),))
CR.seeded(r, [0.0, 0.0, 0.0, 2.5, 2.2, 1.8]; history = [2.0, 3.0, 4.0])
```
"
function seeded(r::Recurrence, gain = true; history, kwargs...)
    m = size(history, ndims(history))
    y = r(gain; history, start = m + 1, kwargs...)
    return cat(history, y; dims = ndims(history))
end
