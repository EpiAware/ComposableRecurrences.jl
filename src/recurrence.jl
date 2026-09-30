@doc "
A recurrence over strata, stepped from a window of its own past values.

At step `t`, each stratum's kernel convolution of its last `L` values is
mixed by the coupling, scaled by the gain and shifted by the add input,
then passed through the modifiers in tuple order:

    x_t = coupling(kernel_t * y_{t-L..t-1})
    v_t = gain_t ⊙ x_t + add_t
    (y_t, s_t) = modifiers(v_t, s_{t-1})

A vector kernel is aligned with the window, oldest first: `kernel[j]`
weights `y_{t-L+j-1}`, as a reversed generation interval.
A [`PerStratum`](@ref) kernel is `S × L`, and a [`TimeVarying`](@ref) one is
`L × T` or `S × L × T`, both oldest first.
The coupling is `I` (or a scaled `λ * I`), any `S × S` matrix (dense,
sparse, `Diagonal`), a [`TimeVarying`](@ref) `S × S × T` array, or a
[`Pairwise`](@ref) kernel with `kernel = nothing`.
Modifiers implement [`ComposableRecurrences.apply!`](@ref) or the pointwise
[`ComposableRecurrences.apply`](@ref).

Called as `r(gain; history, add = nothing, return_state = false)`:

  - `gain`: a scalar, a length-`T` vector shared by every stratum, or
    `S × T`.
  - `history`: the last `L` values before the first step, oldest first,
    length `L` for a single series or `S × L`; or the state returned by
    an earlier call with `return_state = true`, to resume from it.
  - `add`: `nothing`, a scalar, length `T` or `S × T`.
  - `return_state`: also return `(; history, states)`, the last `L` values
    and each modifier's state, to resume from.

The output is length `T` for a single series (vector history) or `S × T`.
`T` is set by the gain, the add input or a time-varying kernel or coupling,
which must agree.
Every input's eltype is promoted into one buffer eltype, so Float32 inputs
give a Float32 output and ForwardDiff Duals pass through any slot.

# Arguments
- `kernel`: the kernel, or `nothing` with a [`Pairwise`](@ref) coupling.

# Keyword Arguments
- `coupling`: how the strata's kernel convolutions mix; `I` by default.
- `modifiers`: a tuple of modifiers applied after the core of each step.

# Examples
```@example
using ComposableRecurrences, LinearAlgebra
g = [0.1, 0.3, 0.6]                   # oldest first
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
    "The kernel, or `nothing` with a pairwise coupling."
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

# Each stratum's kernel convolution of its window `H[t:(t + L - 1), k]`.
function _kernel_pressure!(p, g::AbstractVector, H, t, L)
    for k in eachindex(p)
        p[k] = dot(g, view(H, t:(t + L - 1), k))
    end
    return p
end
function _kernel_pressure!(p, g::PerStratum, H, t, L)
    for k in eachindex(p)
        p[k] = dot(view(g.x, k, :), view(H, t:(t + L - 1), k))
    end
    return p
end
function _kernel_pressure!(p, g::TimeVarying{<:AbstractMatrix}, H, t, L)
    return _kernel_pressure!(p, view(g.x, :, t), H, t, L)
end
function _kernel_pressure!(p, g::TimeVarying{<:AbstractArray{<:Any, 3}}, H, t, L)
    for k in eachindex(p)
        p[k] = dot(view(g.x, k, :, t), view(H, t:(t + L - 1), k))
    end
    return p
end
_kernel_pressure!(p, ::Nothing, H, t, L) = p

# Load the public-layout history into the time-first buffer.
_load_history!(H, h::AbstractVector, L) = (H[1:L, 1] .= h; H)
_load_history!(H, h::AbstractMatrix, L) = (H[1:L, :] .= transpose(h); H)

# The buffer rows `rows`, back in the public layout of history `h`.
_public(H, rows, h::AbstractVector) = H[rows, 1]
_public(H, rows, h::AbstractMatrix) = permutedims(H[rows, :])

# A history given as the state of an earlier call carries modifier states.
_split_history(h::AbstractArray) = (h, nothing)
_split_history(s::NamedTuple{(:history, :states)}) = (s.history, s.states)

_states_eltype(::Nothing) = Bool
_states_eltype(s::Tuple) = promote_type(Bool, map(eltype, s)...)

function (r::Recurrence)(gain; history, add = nothing, return_state = false)
    h, s0 = _split_history(history)
    Y, H, states = _recur(r, gain, add, h, s0)
    return_state || return Y
    L = size(H, 1) - size(Y, ndims(Y))
    T = size(Y, ndims(Y))
    return Y, (; history = _public(H, (T + 1):(T + L), h), states)
end

# The buffer loop: returns the output, the buffer and the final states.
function _recur(r::Recurrence, gain, add, h, s0)
    (; kernel, coupling, modifiers) = r
    L = _nlags(kernel, coupling)
    S = _nstrata(h)
    size(h, ndims(h)) == L || throw(
        DimensionMismatch(
            "history has $(size(h, ndims(h))) values per stratum, " *
                "expected $L"
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
        :gain => _steps(gain), :add => _steps(add),
        :kernel => _tv_steps(kernel), :coupling => _tv_steps(coupling)
    )
    Tp = float(
        promote_type(
            _eltype(kernel), _eltype(coupling), _eltype(gain),
            _eltype(add), _eltype(h), _states_eltype(s0),
            map(_param_eltype, modifiers)...
        )
    )
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
        _kernel_pressure!(p, kernel, H, t, L)
        pressure!(q, coupling, p, view(H, t:(t + L - 1), :), t)
        for k in 1:S
            v[k] = _at(gain, k, t) * q[k] + _at(add, k, t)
        end
        _stages!(modifiers, states, v, t)
        for k in 1:S
            H[L + t, k] = v[k]
        end
    end
    return _public(H, (L + 1):(L + T), h), H, states
end
