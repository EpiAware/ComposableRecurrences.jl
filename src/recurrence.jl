@doc "
A recurrence over strata, stepped from a window of its own past values.

At time `t`, each stratum's kernel convolution of its last `L` values is
mixed by the coupling, scaled by the gain and shifted by the add input,
then passed through the modifiers in tuple order:

    x_t = coupling_t(Σ_i kernel_t[i] y_{t-i})
    v_t = gain_t ⊙ x_t + add_t
    (y_t, s_t) = modifiers(v_t, s_{t-1})

Every kernel is lag first: `kernel[i]` weights `y_{t-i}`, as a generation
interval or AR coefficients are written.
A [`PerStratum`](@ref) kernel is `S × L`, and a [`TimeVarying`](@ref) one is
`L × T` or `S × L × T`, lag on the second to last axis.
The coupling is `I` (or a scaled `λ * I`), any `S × S` matrix (dense,
sparse, `Diagonal`), a [`TimeVarying`](@ref) `S × S × T` array, or a
[`Pairwise`](@ref) kernel with `kernel = nothing`.
Modifiers implement [`ComposableRecurrences.apply!`](@ref) or the pointwise
[`ComposableRecurrences.apply`](@ref).

Called as `r(gain = 1; history, add = nothing, start, return_state = false)`:

  - `gain`: a scalar, a length-`T` vector shared by every stratum, or
    `S × T`; one when left out.
  - `history`: the values before the first step, oldest first, length
    `m` for a single series or `S × m`; the recursion reads the last `L`,
    with no earlier values (zeros) when `m < L`, and
    [`ComposableRecurrences.init_state`](@ref) sees all of it.
    Or the state returned by an earlier call with `return_state = true`,
    to resume from it.
  - `add`: `nothing`, a scalar, length `T` or `S × T`.
  - `start`: the time index of the first output, at which time-varying
    slots and modifiers are read; `1`, or the next index when resuming.
  - `return_state`: also return `(; history, states, t)`: the last `L`
    values, each modifier's state and the time index of the next step.

The gain and add inputs are indexed by the call's own steps.
The output is length `T` for a single series (vector history) or `S × T`.
`T` is set by the gain or add input, or else by a time-varying kernel or
coupling from `start` on.
The buffer eltype promotes [`ComposableRecurrences.param_eltype`](@ref) of
every input and field, so Float32 inputs give a Float32 output and
ForwardDiff Duals pass through any slot.

# Arguments
- `kernel`: the kernel, or `nothing` with a [`Pairwise`](@ref) coupling.

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

# Resume from the returned state.
y1, state = r(R[:, 1:5]; history = ones(2, 3), return_state = true)
y2 = r(R[:, 6:end]; history = state)
y ≈ hcat(y1, y2)
```
"
struct Recurrence{K, C, M <: Tuple} <: AbstractOperator
    "The kernel, lag first, or `nothing` with a pairwise coupling."
    kernel::K
    "How the strata's kernel convolutions mix."
    coupling::C
    "The modifiers, applied in order after the core of each step."
    modifiers::M
    function Recurrence(kernel::K, coupling::C, modifiers::M) where {
            K, C, M <: Tuple,
        }
        _check_kernel(kernel, coupling)
        return new{K, C, M}(kernel, coupling, modifiers)
    end
end

function Recurrence(kernel; coupling = I, modifiers = ())
    return Recurrence(kernel, coupling, Tuple(modifiers))
end

_check_kernel(kernel, coupling) = nothing
function _check_kernel(::Nothing, coupling)
    throw(ArgumentError("kernel = nothing needs a Pairwise coupling"))
end
function _check_kernel(kernel, ::Pairwise)
    throw(ArgumentError("a Pairwise coupling needs kernel = nothing"))
end
_check_kernel(::Nothing, ::Pairwise) = nothing

_nlags(k::AbstractVector, c) = length(k)
_nlags(k::PerStratum, c) = size(k.x, 2)
_nlags(k::TimeVarying, c) = size(k.x, ndims(k.x) - 1)
_nlags(::Nothing, c::Pairwise) = size(c.x, 3)

# Kernel strata checks against `S` strata.
_check_kernel_strata(k, S) = nothing
function _check_kernel_strata(k::Union{PerStratum, TimeVarying}, S)
    ndims(k.x) == 2 && k isa TimeVarying && return nothing
    size(k.x, 1) == S || throw(
        DimensionMismatch("kernel has $(size(k.x, 1)) strata, expected $S")
    )
    return nothing
end

# Fixed kernels are reversed once per call so each step is one dot product
# of the kernel with a contiguous, oldest-first window.
_oldest_first(g::AbstractVector) = reverse(g)
_oldest_first(g::PerStratum) = PerStratum(reverse(g.x; dims = 2))
_oldest_first(g) = g

# Stratum `k`'s kernel convolution of its window `H[t:(t + L - 1), k]`,
# for a kernel prepared by `_oldest_first`; `τ` is the absolute time. A
# native loop: at these lengths a BLAS call costs more than the arithmetic.
_kdot(g::AbstractVector, H, t, τ, L, k) = _window_dot(g, H, t, L, k)
_kdot(g::PerStratum, H, t, τ, L, k) = _window_dot(view(g.x, k, :), H, t, L, k)
function _window_dot(g, H, t, L, k)
    acc = zero(promote_type(eltype(g), eltype(H)))
    @inbounds @simd for i in 1:L
        acc += g[i] * H[t + i - 1, k]
    end
    return acc
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

# A time-varying kernel's weight on lag (or delay) index `j` at time `τ`.
_tv_weight(x::AbstractMatrix, k, j, τ) = x[j, τ]
_tv_weight(x::AbstractArray{<:Any, 3}, k, j, τ) = x[k, j, τ]

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

# A history given as the state of an earlier call carries modifier states
# and the time index of the next step.
_split_history(h::AbstractArray) = (h, nothing, 1)
function _split_history(s::NamedTuple{(:history, :states, :t)})
    return (s.history, s.states, s.t)
end


Base.@constprop :aggressive function _invoke(
        r::Recurrence, route, gain = true; history, add = nothing,
        start = nothing, return_state = false
    )
    h, s0, t0 = _split_history(history)
    τ0 = start === nothing ? t0 : start
    return_state && return adjoint_call(_reroute(route, _WithState(r)), gain, add, h, s0, τ0)
    return adjoint_call(route, gain, add, h, s0, τ0)
end

# A recurrence that also returns its state `(; history, states, t)`.
struct _WithState{R <: Recurrence} <: AbstractOperator
    r::R
end

# The rule applies when the coupling carries its adjoint and each modifier
# does or is pointwise with only scalar float parameters.
function uses_adjoint(r::Recurrence)
    return uses_adjoint(r.coupling) && _all_modifiers_adjoint(r.modifiers)
end
uses_adjoint(w::_WithState) = uses_adjoint(w.r)
_all_modifiers_adjoint(::Tuple{}) = true
function _all_modifiers_adjoint(ms::Tuple)
    return _modifier_adjoint(first(ms)) && _all_modifiers_adjoint(Base.tail(ms))
end
function _modifier_adjoint(m)
    return uses_adjoint(m) || (ispointwise(m) && !_has_array_params(typeof(m)))
end

# Whether a type holds a float array (or a field of unknown type) that a
# local per-value derivative would have to carry.
Base.@assume_effects :foldable function _has_array_params(::Type{T}) where {T}
    T <: AbstractArray && return eltype(T) <: AbstractFloat || !isconcretetype(eltype(T))
    T <: Union{Real, Nothing, Symbol, AbstractString, Function} && return false
    isconcretetype(T) || return true
    for F in fieldtypes(T)
        _has_array_params(F) && return true
    end
    return false
end

# `forward(r, gain, add, h, s0, τ0)`: `h` is the history array and `s0` the
# modifier states to resume from, or `nothing`.
function forward(r::Recurrence, gain, add, h, s0, τ0)
    Y, _, _, cache = _recur(r, gain, add, h, s0, τ0, Val(true))
    return Y, cache
end
_primal(r::Recurrence, args...) = first(_recur(r, args..., Val(false)))

function forward(w::_WithState, gain, add, h, s0, τ0)
    Y, H, states, cache = _recur(w.r, gain, add, h, s0, τ0, Val(true))
    return (Y, _state(Y, H, states, h, τ0)), cache
end
function _primal(w::_WithState, gain, add, h, s0, τ0)
    Y, H, states = _recur(w.r, gain, add, h, s0, τ0, Val(false))
    return Y, _state(Y, H, states, h, τ0)
end

function _state(Y, H, states, h, τ0)
    T = size(Y, ndims(Y))
    L = size(H, 1) - T
    return (; history = _public(H, (T + 1):(T + L), h), states, t = τ0 + T)
end

_tape(x::AbstractArray) = copy(x)
_tape(x) = x

# Checks the call, then runs the buffer loop at the promoted eltype.
function _recur(r::Recurrence, gain, add, h, s0, τ0, record::Val)
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
    T = _nsteps(
        τ0, (:gain => _steps(gain), :add => _steps(add)),
        (:kernel => _tv_steps(kernel), :coupling => _tv_steps(coupling))
    )
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
    pressure!(q, C, p, view(H, t:(t + L - 1), :), τ)
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
    v′, s[k] = apply(first(ms), v, s[k], τ, k)
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
    apply!(first(ms), v, first(states), τ)
    return _stages_rec!(Base.tail(ms), Base.tail(states), Base.tail(rec), v, τ, t)
end

# The buffer loop: returns the output, the buffer, the final states and,
# when recording, the cache the reverse pass reads. The records are the
# kernel convolutions `P` and pressures `X` of every step (S × T), and each
# modifier's input values and states. With pointwise modifiers each
# stratum's value goes straight to the buffer; otherwise the step's values
# are collected for `apply!`.
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
        map(m -> _state_vector(Tp, init_state(m, h)), modifiers)
    else
        map(s -> _state_vector(Tp, s), s0)
    end
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
                x = _at(gain, k, t) * xk + _at(add, k, t)
                H[L + t, k] = _thread(modifiers, states, rec, x, τ, t, k)
            end
        else
            for k in eachindex(v)
                pk, xk = _pressure_at(coupling, kernel, p, q, H, t, τ, L, k)
                if record
                    P[k, t] = pk
                    X[k, t] = xk
                end
                v[k] = _at(gain, k, t) * xk + _at(add, k, t)
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
    # The cache holds copies of the inputs the reverse pass reads, so a caller
    # overwriting them after the call cannot change the gradient.
    cache = record ?
        (; r, kernel, gain = _tape(gain), add, h = _tape(h), s0, τ0, L, S, T, H, P, X, rec) :
        nothing
    return Y, H, states, cache
end
