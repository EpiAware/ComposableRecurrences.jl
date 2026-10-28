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
function pressure(r::Recurrence, y; history = nothing, start::Integer = 1)
    h = history === nothing ? _empty_history(y) : history
    S = _nstrata(h)
    _nstrata(y) == S && ndims(y) == ndims(h) || throw(
        DimensionMismatch(
            "the outputs have $(_nstrata(y)) strata and the history $S; " *
                "pass both as vectors or both with a row per stratum"
        )
    )
    (; kernel, coupling) = r
    L = _nlags(kernel)
    D = _buffer_depth(r, L)
    T = size(y, ndims(y))
    start >= 1 || throw(ArgumentError("start ($start) must be at least 1"))
    stop = start + T - 1
    _check_kernel_strata(kernel, S)
    _check_coupling(coupling, S)
    _check_primary_seed(kernel, history, start)
    _check_kernel_times(kernel, stop)
    _check_times(:coupling, coupling, stop)
    Tp = float(param_eltype((r, y, h)))
    q = _pressure_run(Tp, r, y, h, start, L, D, S, T)
    return y isa AbstractVector ? vec(q) : q
end

# The buffer holds the history then the outputs, and each step reads the
# window before its row as the run does, so the kernel, coupling and their
# runs over time are the run's own.
function _pressure_run(::Type{Tp}, r, y, h, τ0, L, D, S, T) where {Tp}
    coupling = r.coupling
    kernel = _run_kernel(Tp, r.kernel, h, S)
    H = _load_history!(_buffer(h, Tp, D, T, S), h, D)
    _load_outputs!(H, y, D)
    out = _zeros(h, Tp, S, T)
    p = _zeros(h, Tp, S)
    q = _zeros(h, Tp, S)
    for (ts, g, _) in _kernel_runs(kernel, τ0, T)
        _steps_in!(_pressure_step!, Serial(), ts, T, out, coupling, g, p, q, H, τ0, L, D, S)
    end
    return out
end

# Step `t`'s pressure on every stratum, read as the run's step reads it.
@inline function _pressure_step!(t, out, coupling, g, p, q, H, τ0, L, D, S)
    τ = τ0 + t - 1
    _step_prepare!(Serial(), p, q, coupling, g, H, t, τ, L, D)
    for k in 1:S
        out[k, t] = last(_step_pressure(coupling, g, p, q, H, t, τ, L, D, k))
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
