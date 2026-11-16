# Operators with a computed kernel (see `weights.jl`). A convolution and
# `kernel_weights` walk each cohort's weights in turn (see `walk.jl`); a
# recurrence fills the weights as a dense `Primary()` kernel and takes its
# cotangent back to the coefficients.

const _ComputedConvolution = Convolution{<:_ComputedKernel}
uses_adjoint(c::_ComputedConvolution, ::Run) = _derived_local(c.kernel)

# The input at time `σ`, buffer row `m + σ`, spreads forward through its
# cohort's weights, as a `Primary()` kernel's does; serially each cohort's
# weights come from its walk, shared by the strata unless a `Survival` has
# strata of its own. Another executor takes the dense kernel of the same
# weights, whose loops it splits by stratum.
function _convolve!(ex, Y, c::_ComputedKernel, X, m, start)
    return _convolve_dense!(ex, Y, c, X, m, start)
end
function _convolve_dense!(ex, Y, c::_ComputedKernel, X, m, start)
    stop = start + size(Y, 1) - 1
    K, _ = _fill_kernel(c, 0, stop, stop, Val(false))
    return _convolve!(ex, Y, _dense_kernel(K), X, m, start)
end
function _convolve!(ex::Serial, Y, c::_ComputedKernel, X, m, start)
    x = c.x
    L = _nlags(c)
    T = eltype(Y)
    stop = start + size(Y, 1) - 1
    sc = _walk_scratch(x, T, (L,), Val(false))
    ks = axes(Y, 2)
    for k0 in _walk_groups(x, ks), τ in max(1, start - L + 1):stop
        imax = _imax(τ, L, 0, stop)
        # Lag index `i` of cohort `τ` lands in row `τ + i - start`.
        i0 = max(1, start - τ + 1)
        kw = _walk_strata(x, ks, k0)
        if length(kw) == 1
            # One stratum: each weight is added as its lag is walked.
            k1 = first(kw)
            x1 = @inbounds X[m + τ, k1]
            _walk_cohort!(x, _no_record(sc), k0, τ, 0, imax, T) do i, l, st
                i < i0 && return nothing
                w1 = _walk_value(x, st, k1, i, τ, l)
                @inbounds Y[τ + i - start, k1] += w1 * x1
                return nothing
            end
        else
            # Several: a loop over the strata inside the walk would hold up
            # its chain of products, so each reads the walk after it.
            _walk_cohort!(x, sc, k0, τ, 0, imax, T)
            for k in kw
                xk = @inbounds X[m + τ, k]
                for i in i0:imax
                    w = @inbounds _value(x, sc, k, i, τ, i - 1, 1)
                    @inbounds Y[τ + i - start, k] += w * xk
                end
            end
        end
    end
    return Y
end

# Its reverse pass walks each cohort again, adds each input's cotangent and
# the weights', and takes the weights' back to the coefficients along the
# same walk; another executor takes the dense kernel's reverse pass.
function _convolve_back!(ex, X̄, c̄, c::_ComputedKernel, X, Ȳ, m, start)
    stop = start + size(Ȳ, 1) - 1
    K, sc = _fill_kernel(c, 0, stop, stop)
    x̄ = cotangent(c̄, :x)
    K̄ = _dense_convolve_back!(ex, X̄, x̄, K, X, Ȳ, m, start)
    _weights_back!(x̄, c, K̄, 0, stop, sc)
    return nothing
end

# The dense kernel's reverse pass, which returns the weights' cotangent. The
# kernel and its mirror are built from `K` behind one function boundary, so
# where the shape of `K` does not infer (an abstract kernel), inference
# cannot pair a mirror and a kernel of different shapes.
@noinline function _dense_convolve_back!(ex, X̄, x̄, K, X, Ȳ, m, start)
    K̄ = _weights_cotangent(x̄, K)
    _convolve_back!(ex, X̄, _dense_mirror(K̄), _dense_kernel(K), X, Ȳ, m, start)
    return K̄
end
function _convolve_back!(ex::Serial, X̄, c̄, c::_ComputedKernel, X, Ȳ, m, start)
    x = c.x
    x̄ = cotangent(c̄, :x)
    L = _nlags(c)
    T = eltype(X̄)
    stop = start + size(Ȳ, 1) - 1
    sc = _walk_scratch(x, T, (L,), Val(false))
    ks = axes(Ȳ, 2)
    for k0 in _walk_groups(x, ks), τ in max(1, start - L + 1):stop
        imax = _imax(τ, L, 0, stop)
        _walk_cohort!(x, sc, k0, τ, 0, imax, T)
        for k in _walk_strata(x, ks, k0)
            xk = @inbounds X[m + τ, k]
            acc = zero(T)
            for i in max(1, start - τ + 1):imax
                @inbounds begin
                    ȳ = Ȳ[τ + i - start, k]
                    acc += _value(x, sc, k, i, τ, i - 1, 1) * ȳ
                    x̄ === nothing ||
                        _add_value!(x̄, x, sc, ȳ * xk, k, i, τ, i - 1, 1)
                end
            end
            @inbounds X̄[m + τ, k] += acc
        end
        x̄ === nothing || _walk_cohort_back!(x̄, x, sc, k0, τ, 0, imax, T)
    end
    return nothing
end

# The terms of a convolution read its weights one at a time, which a
# computed kernel holds only inside a call.
function _contributions(c::_ComputedConvolution, route, x; kwargs...)
    throw(
        ArgumentError(
            "contributions reads a kernel's weights lag by lag, and a " *
                "computed kernel has none outside a call; pass the dense " *
                "kernel of its weights, TimeVarying(K, Primary())"
        )
    )
end

_pressure_rule(::_ComputedKernel) = false
# `pressure` fills a computed kernel's weights as a dense `Primary()` kernel
# up to its last time, as the run does, and reads that.
function _pressure(
        r::Recurrence{<:_ComputedKernel}, route, y; start::Integer = 1,
        kwargs...
    )
    start >= 1 || throw(ArgumentError("start ($start) must be at least 1"))
    stop = start + size(y, ndims(y)) - 1
    K, _ = _fill_kernel(r.kernel, 1, stop, stop, Val(false))
    return _pressure(_with_kernel(r, K), route, y; start, kwargs...)
end

function _with_kernel(r::Recurrence, K)
    return Recurrence(_Checked(), _dense_kernel(K), r.coupling, r.modifiers, r.rebuilds)
end

# A recurrence fills the weights of cohorts up to its last time, then runs
# with them as its kernel; its cache keeps the computed kernel.
function _recur(
        r::Recurrence{<:_ComputedKernel}, gain, add, h, s0, τ0, stop, cache::Val
    )
    n = _stop(stop, (:gain => _extent(gain), :add => _extent(add)))
    K, sc = _fill_kernel(r.kernel, 1, n, n, cache)
    Y, H, states, inner = _recur(_with_kernel(r, K), gain, add, h, s0, τ0, stop, cache)
    return Y, H, states, _with_computed(inner, r.kernel, n, sc)
end
_with_computed(::Nothing, kernel, n, sc) = nothing
_with_computed(cache, kernel, n, sc) = merge(cache, (; computed = (; kernel, n, sc)))
_computed(c::NamedTuple) = hasfield(typeof(c), :computed) ? c.computed : nothing

# The reverse pass of a recurrence with a computed kernel: the dense
# kernel's cotangent, then the coefficients'.
function _reverse_computed!(::Nothing, c, Ȳ, r̄, args::Vararg{Any, N}) where {N}
    return _reverse_run!(c, Ȳ, r̄, args...)
end
function _reverse_computed!(comp, c, Ȳ, r̄, args::Vararg{Any, N}) where {N}
    x̄ = cotangent(cotangent(r̄, :kernel), :x)
    K̄ = _weights_cotangent(x̄, _array(c.r.kernel))
    r̄d = r̄ === nothing ? nothing : merge(r̄, (; kernel = _dense_mirror(K̄)))
    _reverse_run!(c, Ȳ, r̄d, args...)
    _weights_back!(x̄, comp.kernel, K̄, 1, comp.n, comp.sc)
    return nothing
end

# ---- the weights as an array -------------------------------------------------

@doc raw"""
    kernel_weights(kernel, n)

The weights of a computed kernel `TimeVarying(w, Primary())` for the
cohorts at times `1` to `n`, as an array: `L × n`, or `S × L × n` with
strata, lag 0 first,

```math
K_{l + 1, \tau} = w_l(\tau), \qquad l = 0, \dots, L - 1, \quad \tau = 1, \dots, n,
```

where ``w_l(\tau)`` is the weight on lag ``l`` of cohort ``\tau`` and ``L``
the kernel's number of lags.

Every entry is computed, so a `TimeVarying(h)` argument read at the time
``\tau + l`` a weight lands covers the times up to `n + L - 1`, and a
`TimeVarying(c, Primary())` one the times up to `n`.
It is differentiable, with the reverse pass of
[`Derived`](@ref) and
[`ComposableRecurrences.Survival`](@ref).

# Arguments
- `kernel`: the kernel, `TimeVarying(w, Primary())` with `w` a `Derived` or
  a `Survival`.
- `n`: the number of cohorts.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
# The probability each cohort has been reported by each delay, against a
# hazard that falls with the delay and rises with the calendar time.
base = [0.2, 0.3, 0.4]
level = TimeVarying([1.0, 1.0, 1.2, 1.2])
reported = 1 - CR.Survival(CR.Derived(*, base, level))
round.(CR.kernel_weights(TimeVarying(reported, CR.Primary()), 2); digits = 3)

# output

3×2 Matrix{Float64}:
 0.2    0.2
 0.44   0.488
 0.709  0.734
```
"""
function kernel_weights(kernel::_ComputedKernel, n::Integer)
    return adjoint_call(_KernelWeights(kernel), Int(n))
end

# `kernel_weights` routes through the rules as an operator of its own.
struct _KernelWeights{K <: _ComputedKernel} <: AbstractOperator
    kernel::K
end
uses_adjoint(op::_KernelWeights, ::Run) = _derived_local(op.kernel)
# Every weight of the cohorts `1:n` lands by this time.
_last_time(op::_KernelWeights, n) = n + _nlags(op.kernel) - 1
function _run_forward(op::_KernelWeights, n)
    K, sc = _weights_walk(op, n, Val(true))
    return K, (; n, sc)
end
_primal(op::_KernelWeights, n) = first(_weights_walk(op, n, Val(false)))
function _weights_walk(op::_KernelWeights, n, keep)
    x = op.kernel.x
    n = max(n, 0)
    last = _last_time(op, n)
    _check_coef_times(x, n, last)
    Tp = float(param_eltype(x))
    L = _coef_lags(x)
    # Every weight of cohorts `1:n` lands by `last`, so the walk writes each.
    K = _has_strata(x) ? _alloc(Tp, _coef_strata(x), L, n) : _alloc(Tp, L, n)
    return _walk_fill!(K, op.kernel, 0, last, keep)
end
function pullback!(grads, op::_KernelWeights, ::Run, cache)
    _count_pullback()
    x̄ = cotangent(cotangent(grads.piece, :kernel), :x)
    x̄ === nothing && return nothing
    last = _last_time(op, cache.n)
    _walk_weights_back!(x̄, op.kernel, grads.y, 0, last, cache.sc)
    return nothing
end
