# The pressure a recurrence's steps draw against, recomputed from given
# outputs: the step's own kernel convolution and coupling over a buffer
# holding the history and the outputs, without the gain, add input or
# modifiers.

@doc raw"""
The pressure each step of `r` draws against, given its outputs `y`: the
kernel convolution of the past values, mixed by the coupling, before the
gain, add input and modifiers,

```math
q_{t,i} = \sum_{j=1}^{S} K_{t,ij} \sum_{l=1}^{L} k_{j,l}(t)\, y_{t-l,j},
\qquad t = t_0, \dots, t_0 + T - 1,
```

with the symbols of [`Recurrence`](@ref).
``q_t`` is what the coupling's [`ComposableRecurrences.Pressure`](@ref)
role writes, computed as the step computes it, for any kernel and coupling
a `Recurrence` takes.
``y_\tau`` for ``\tau < t_0`` comes from `history`, as in the call.
For one series with kernel ``k`` and no coupling,
``q_t = \sum_{l=1}^{L} k_l\, y_{t-l}``, the convolution of ``y`` with
``k`` lagged by one step.

For the outputs of `r(gain; history)` without modifiers or an add input,
``y_t = \gamma_t \odot q_t``, so `y ./ pressure(r, y; history)` returns the
gain.
With modifiers or added values the ratio is the gain as realised on each
step, with their effect included.
Where ``q_{t,i}`` is zero the ratio is `NaN` or `Inf`.
For outputs from a traced call, `trace.pressure` is the same pressure.
It is differentiable in the outputs, the history, the kernel and the
coupling.
`pressure(NoAdjoint(r), y)` gives the same values with the rule turned off,
as [`ComposableRecurrences.NoAdjoint`](@ref) does for the call.

# Arguments
- `r`: the recurrence.
- `y`: its outputs at times `start` to `start + T - 1`, length `T` for a
  single series or `S × T`.

# Keyword Arguments
- `history`: the outputs before `start`, as passed to the call; zeros when
  left out.
- `start`: the first time, as passed to the call; `1` by default.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
r = Recurrence([0.6, 0.4]; coupling = [0.9 0.1; 0.2 0.8])
R = [1.2 1.1 1.0; 0.9 1.3 1.0]
h = [1.0 2.0; 3.0 1.0]
y = r(R; history = h)
y ./ CR.pressure(r, y; history = h) ≈ R

# output

true
```
"""
pressure(r::Recurrence, y; kwargs...) = _pressure(r, r, y; kwargs...)
function pressure(n::NoAdjoint{<:Recurrence}, y; kwargs...)
    return _pressure(n.op, n, y; kwargs...)
end
function _pressure(
        r::Recurrence, route, y; history = nothing, start::Integer = 1
    )
    h = history === nothing ? _empty_history(y) : history
    S = _nstrata(h)
    _nstrata(y) == S && ndims(y) == ndims(h) || throw(
        DimensionMismatch(
            "the outputs have $(_nstrata(y)) strata and the history $S; " *
                "pass both as vectors or both with a row per stratum"
        )
    )
    (; kernel, coupling) = r
    T = size(y, ndims(y))
    start >= 1 || throw(ArgumentError("start ($start) must be at least 1"))
    stop = start + T - 1
    _check_kernel_strata(kernel, S)
    _check_coupling(coupling, S)
    _check_primary_seed(kernel, history, start)
    _check_kernel_times(kernel, stop)
    _check_times(:coupling, coupling, stop)
    op = _Pressure(_pressure_kernel(r, stop))
    q = adjoint_call(_reroute(route, op), y, h, Int(start))
    return y isa AbstractVector ? vec(q) : q
end
# The recurrence whose kernel the pressure reads up to time `stop`.
_pressure_kernel(r::Recurrence, stop) = r

# `pressure` routes through the rules as an operator of its own. Its
# reverse pass is the recurrence's own at each step without the gain, add
# input and modifiers: the pressure's cotangent back through the coupling,
# then correlated with the kernel into the buffer's cotangent, which holds
# the outputs' and the history's.
struct _Pressure{R <: Recurrence} <: AbstractOperator
    r::R
end
function uses_adjoint(op::_Pressure, ::Run)
    r = op.r
    return _pressure_rule(r.kernel) &&
        _parts_adjoint(r.kernel, r.coupling, ()) && r.rebuilds !== false
end
# `pressure` gives the rule a computed kernel's weights as a dense kernel,
# with plain AD through the fill; on the computed kernel itself it is off.
_pressure_rule(kernel) = true

function _primal(op::_Pressure, y, h, τ0)
    return first(_pressure_forward(op.r, y, h, τ0, Val(false)))
end
function _run_forward(op::_Pressure, y, h, τ0)
    return _pressure_forward(op.r, y, h, τ0, Val(true))
end
function _pressure_forward(r, y, h, τ0, keep::Val)
    S = _nstrata(h)
    L = _nlags(r.kernel)
    D = _buffer_depth(r, L)
    T = size(y, ndims(y))
    Tp = float(param_eltype((r, y, h)))
    return _pressure_run(Tp, r, y, h, τ0, L, D, S, T, keep)
end

# The buffer holds the history then the outputs, and each step reads the
# window before its row as the run does, so the kernel, coupling and their
# runs over time are the run's own. The reverse pass keeps the buffer and
# each step's kernel convolutions `P` (strata × steps).
function _pressure_run(
        ::Type{Tp}, r, y, h, τ0, L, D, S, T, keep::Val
    ) where {Tp}
    coupling = r.coupling
    kernel = _run_kernel(Tp, r.kernel, h, S)
    H = _load_history!(_buffer(h, Tp, D, T, S), h, D)
    _load_outputs!(H, y, D)
    out = _zeros(h, Tp, S, T)
    P = keep isa Val{true} ? _zeros(h, Tp, S, T) : nothing
    p = _zeros(h, Tp, S)
    q = _zeros(h, Tp, S)
    for (ts, g, _) in _kernel_runs(kernel, τ0, T)
        _steps_in!(
            _pressure_step!, Serial(), ts, T, out, P, coupling, g, p, q, H,
            τ0, L, D, S
        )
    end
    keep isa Val{true} || return out, nothing
    return out, (; H, P, kernel, h, τ0, L, D, S, T)
end

# The steps in turn, each its coupling's pullback and then its kernel's,
# as `_steps_back!` runs them for a recurrence. No step reads another's
# output, so they need no order.
function pullback!(grads, op::_Pressure, ::Run, c)
    _count_pullback()
    (; H, P, kernel, h, τ0, L, D, S, T) = c
    coupling = op.r.coupling
    r̄ = cotangent(grads.piece, :r)
    ḡ = cotangent(r̄, :kernel)
    C̄ = cotangent(r̄, :coupling)
    ȳ, h̄ = grads.args[1], grads.args[2]
    Q̄ = grads.y
    Tp = eltype(H)
    H̄ = _zeros(H, Tp, size(H)...)
    kbuf = _kernel_buffer(ḡ, kernel, H, S, L)
    pbufs = _pressure_buffers(C̄, coupling, Tp)
    pr = (; P)
    p̄ = _zeros(H, Tp, S)
    q̄ = _zeros(H, Tp, S)
    for (ts, g, j) in _kernel_runs(kernel, τ0, T)
        kb = _run_buffer(kbuf, kernel, j)
        for t in _run_steps(ts, T)
            τ = τ0 + t - 1
            for k in 1:S
                @inbounds q̄[k] = Q̄[k, t]
            end
            _coupling_back!(p̄, C̄, coupling, q̄, pr, t, τ, pbufs)
            _kernel_back!(kb, ḡ, g, p̄, H, H̄, t + D - L, τ, L)
        end
    end
    _kernel_finish!(ḡ, kbuf)
    _gather_outputs!(ȳ, H̄, D)
    _scatter_history!(h̄, H̄, h, D)
    return nothing
end

# Buffer rows after the history into the outputs' cotangent.
_gather_outputs!(::Nothing, H̄, D) = nothing
function _gather_outputs!(ȳ::AbstractVector, H̄, D)
    for t in eachindex(ȳ)
        @inbounds ȳ[t] += H̄[D + t, 1]
    end
    return nothing
end
function _gather_outputs!(ȳ::AbstractMatrix, H̄, D)
    for t in axes(ȳ, 2), k in axes(ȳ, 1)
        @inbounds ȳ[k, t] += H̄[D + t, k]
    end
    return nothing
end

# Step `t`'s pressure on every stratum, read as the run's step reads it,
# and its kernel convolutions into `P` when the reverse pass keeps them.
@inline function _pressure_step!(t, out, P, coupling, g, p, q, H, τ0, L, D, S)
    τ = τ0 + t - 1
    _step_prepare!(Serial(), p, q, coupling, g, H, t, τ, L, D)
    for k in 1:S
        pk, qk = _step_pressure(coupling, g, p, q, H, t, τ, L, D, k)
        out[k, t] = qk
        P === nothing || (P[k, t] = pk)
    end
    return nothing
end

# The outputs into the buffer rows after the history, by loop as the
# history loads.
function _load_outputs!(H, y::AbstractVector, D)
    for t in eachindex(y)
        H[D + t, 1] = y[t]
    end
    return H
end
function _load_outputs!(H, y::AbstractMatrix, D)
    for t in axes(y, 2), k in axes(y, 1)
        H[D + t, k] = y[k, t]
    end
    return H
end
