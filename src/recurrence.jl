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
    `m ≥ L` for a single series or `S × m`; the recursion reads the last
    `L` and [`ComposableRecurrences.init_state`](@ref) sees all of it.
    Or the state returned by an earlier call with `return_state = true`,
    to resume from it.
  - `add`: `nothing`, a scalar, length `T` or `S × T`.
  - `start`: the time index of the first output, at which time-varying
    slots and modifiers are read; `1`, or the next index when resuming.
  - `return_state`: also return `(; history, states, t)`: the last `L`
    values, each modifier's state and the last time index.

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
struct Recurrence{K, C, M <: Tuple}
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

# Fixed kernels are reversed once per call so each step is one `dot` of
# the kernel with a contiguous, oldest-first window.
_oldest_first(g::AbstractVector) = reverse(g)
_oldest_first(g::PerStratum) = PerStratum(reverse(g.x; dims = 2))
_oldest_first(g) = g

# Each stratum's kernel convolution of its window `H[t:(t + L - 1), k]`,
# for a kernel prepared by `_oldest_first`; `τ` is the absolute time.
function _kernel_pressure!(p, g::AbstractVector, H, t, τ, L)
    for k in eachindex(p)
        p[k] = dot(g, view(H, t:(t + L - 1), k))
    end
    return p
end
function _kernel_pressure!(p, g::PerStratum, H, t, τ, L)
    for k in eachindex(p)
        p[k] = dot(view(g.x, k, :), view(H, t:(t + L - 1), k))
    end
    return p
end
function _kernel_pressure!(p, g::TimeVarying, H, t, τ, L)
    for k in eachindex(p)
        acc = zero(eltype(p))
        for i in 1:L
            acc += _tv_weight(g.x, k, i, τ) * H[t + L - i, k]
        end
        p[k] = acc
    end
    return p
end
_kernel_pressure!(p, ::Nothing, H, t, τ, L) = p

# A time-varying kernel's weight on lag (or delay) index `j` at time `τ`.
_tv_weight(x::AbstractMatrix, k, j, τ) = x[j, τ]
_tv_weight(x::AbstractArray{<:Any, 3}, k, j, τ) = x[k, j, τ]

# Load the last `L` values of a public-layout history into the buffer.
function _load_history!(H, h::AbstractVector, L)
    H[1:L, 1] .= view(h, (length(h) - L + 1):length(h))
    return H
end
function _load_history!(H, h::AbstractMatrix, L)
    H[1:L, :] .= transpose(view(h, :, (size(h, 2) - L + 1):size(h, 2)))
    return H
end

# The buffer rows `rows`, back in the public layout of history `h`.
_public(H, rows, h::AbstractVector) = H[rows, 1]
_public(H, rows, h::AbstractMatrix) = permutedims(H[rows, :])

# A history given as the state of an earlier call carries modifier states
# and the time index reached.
_split_history(h::AbstractArray) = (h, nothing, 0)
function _split_history(s::NamedTuple{(:history, :states, :t)})
    return (s.history, s.states, s.t)
end

function (r::Recurrence)(
        gain = true; history, add = nothing, start = nothing,
        return_state = false
    )
    h, s0, t0 = _split_history(history)
    τ0 = start === nothing ? t0 + 1 : start
    Y, H, states = _recur(r, gain, add, h, s0, τ0)
    return_state || return Y
    T = size(Y, ndims(Y))
    L = size(H, 1) - T
    state = (;
        history = _public(H, (T + 1):(T + L), h), states, t = τ0 + T - 1,
    )
    return Y, state
end

# Checks the call, then runs the buffer loop at the promoted eltype.
function _recur(r::Recurrence, gain, add, h, s0, τ0)
    (; kernel, coupling, modifiers) = r
    L = _nlags(kernel, coupling)
    S = _nstrata(h)
    size(h, ndims(h)) >= L || throw(
        DimensionMismatch(
            "history has $(size(h, ndims(h))) values per stratum, " *
                "fewer than the $L lags"
        )
    )
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
    return _run(Tp, r, gain, add, h, s0, τ0, L, S, T)
end

# The buffer loop: returns the output, the buffer and the final states.
function _run(::Type{Tp}, r, gain, add, h, s0, τ0, L, S, T) where {Tp}
    (; coupling, modifiers) = r
    kernel = _oldest_first(r.kernel)
    H = _load_history!(zeros(Tp, L + T, S), h, L)
    p = zeros(Tp, S)
    q = zeros(Tp, S)
    v = zeros(Tp, S)
    states = if s0 === nothing
        map(m -> _state_vector(Tp, init_state(m, h)), modifiers)
    else
        map(s -> _state_vector(Tp, s), s0)
    end
    for t in 1:T
        τ = τ0 + t - 1
        _kernel_pressure!(p, kernel, H, t, τ, L)
        pressure!(q, coupling, p, view(H, t:(t + L - 1), :), τ)
        for k in eachindex(v)
            v[k] = _at(gain, k, t) * q[k] + _at(add, k, t)
        end
        _stages!(modifiers, states, v, τ)
        for k in eachindex(v)
            H[L + t, k] = v[k]
        end
    end
    return _public(H, (L + 1):(L + T), h), H, states
end
