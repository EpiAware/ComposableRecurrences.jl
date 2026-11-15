# Operators with a computed kernel (see `weights.jl`). A convolution fills
# a block of cohorts at a time inside its own loops; a recurrence and
# `kernel_weights` fill the weights as a dense `Primary()` kernel and take
# its cotangent back to the coefficients.

const _ComputedConvolution = Convolution{<:_ComputedKernel}
uses_adjoint(c::_ComputedConvolution, ::Run) = _derived_local(c.kernel)

# The input at time `σ`, buffer row `m + σ`, spreads forward through its
# cohort's weights, as a `Primary()` kernel's does, filled a block of
# cohorts at a time and shared by the strata. The strata share each block,
# so they run in one loop; another executor takes the dense kernel of the
# same weights, whose loops it splits by stratum.
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
    stop = start + size(Y, 1) - 1
    sc = _walk_scratch(x, eltype(Y), L)
    ks = axes(Y, 2)
    for k0 in _walk_groups(x, ks), τ in max(1, start - L + 1):stop
        for i in 1:_imax(τ, L, 0, stop)
            l = i - 1
            _walk!(x, sc, k0, i, τ, l)
            t = τ + l - start + 1
            t < 1 && continue
            for k in _walk_strata(x, ks, k0)
                @inbounds Y[t, k] += _value(x, sc, k, i, τ, l, 1) * X[m + τ, k]
            end
        end
    end
    return Y
end

# Its reverse pass recomputes each block, adds each input's cotangent and
# the weights', and takes the weights' back to the coefficients.
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
    stop = start + size(Ȳ, 1) - 1
    sc = _walk_scratch(x, eltype(X̄), L)
    ks = axes(Ȳ, 2)
    for k0 in _walk_groups(x, ks), τ in max(1, start - L + 1):stop
        imax = _imax(τ, L, 0, stop)
        for i in 1:imax
            _walk!(x, sc, k0, i, τ, i - 1)
        end
        _walk_clear!(sc)
        for i in imax:-1:1
            l = i - 1
            t = τ + l - start + 1
            if t >= 1
                for k in _walk_strata(x, ks, k0)
                    @inbounds begin
                        ȳ = Ȳ[t, k]
                        X̄[m + τ, k] += _value(x, sc, k, i, τ, l, 1) * ȳ
                        v = ȳ * X[m + τ, k]
                        x̄ === nothing || iszero(v) ||
                            _add_value!(x̄, x, sc, v, k, i, τ, l, 1)
                    end
                end
            end
            x̄ === nothing || _walk_back!(x̄, x, sc, k0, i, τ, l)
        end
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
_run_forward(op::_KernelWeights, n) = _primal(op, n), (; n)
function _primal(op::_KernelWeights, n)
    x = op.kernel.x
    n = max(n, 0)
    last = _last_time(op, n)
    _check_coef_times(x, n, last)
    Tp = float(param_eltype(x))
    K = _weights_array(
        Val(_has_strata(x)), Tp, max(_coef_strata(x), 1), _coef_lags(x), n
    )
    return _walk_fill!(K, op.kernel, 0, last)
end
function pullback!(grads, op::_KernelWeights, ::Run, cache)
    _count_pullback()
    x̄ = cotangent(cotangent(grads.piece, :kernel), :x)
    x̄ === nothing && return nothing
    _walk_weights_back!(x̄, op.kernel, grads.y, 0, _last_time(op, cache.n))
    return nothing
end
