# Operators with a computed kernel (see `weights.jl`). A convolution fills
# a block of cohorts at a time inside its own loops; a recurrence, the
# terms of a convolution and `kernel_weights` fill the weights as a dense
# `Primary()` kernel and take its cotangent back to the coefficients.

const _ComputedConvolution = Convolution{<:_ComputedKernel}
uses_adjoint(c::_ComputedConvolution, ::Run) = _derived_local(c.kernel)

# The input at time `σ`, buffer row `m + σ`, spreads forward through its
# cohort's weights, as a `Primary()` kernel's does, filled a block of
# cohorts at a time and shared by the strata. The strata share each block,
# so they run in one loop on the calling task.
function _convolve!(ex, Y, c::_ComputedKernel, X, m, start)
    x = c.x
    L = _nlags(c)
    stop = start + size(Y, 1) - 1
    sc = _scratch(x, eltype(Y), L)
    W = _block_weights(eltype(Y), L, max(_coef_strata(x), 1))
    shared = size(W, 3) == 1
    for τ0 in max(1, start - L + 1):_BLOCK:stop
        nb = min(_BLOCK, stop - τ0 + 1)
        _fill_block!(W, x, sc, τ0, nb, 0, stop)
        for k in axes(Y, 2), i in 1:L
            r = shared ? 1 : k
            o = τ0 + i - 1 - start
            @inbounds for b in max(1, 1 - o):_bmax(τ0, nb, i, 0, stop)
                Y[o + b, k] += W[b, i, r] * X[m + τ0 + b - 1, k]
            end
        end
    end
    return Y
end

# Its reverse pass recomputes each block, adds each input's cotangent and
# the weights', and takes the weights' back to the coefficients.
function _convolve_back!(ex, X̄, c̄, c::_ComputedKernel, X, Ȳ, m, start)
    x = c.x
    x̄ = cotangent(c̄, :x)
    L = _nlags(c)
    stop = start + size(Ȳ, 1) - 1
    T = eltype(X̄)
    sc = _scratch(x, T, L)
    W = _block_weights(T, L, max(_coef_strata(x), 1))
    W̄ = zero(W)
    shared = size(W, 3) == 1
    for τ0 in max(1, start - L + 1):_BLOCK:stop
        nb = min(_BLOCK, stop - τ0 + 1)
        _fill_block!(W, x, sc, τ0, nb, 0, stop)
        for k in axes(Ȳ, 2), i in 1:L
            r = shared ? 1 : k
            o = τ0 + i - 1 - start
            @inbounds for b in max(1, 1 - o):_bmax(τ0, nb, i, 0, stop)
                ȳ = Ȳ[o + b, k]
                W̄[b, i, r] += ȳ * X[m + τ0 + b - 1, k]
                X̄[m + τ0 + b - 1, k] += W[b, i, r] * ȳ
            end
        end
        x̄ === nothing && continue
        _back_block!(x̄, x, sc, W̄, τ0, nb, 0, stop)
        fill!(W̄, zero(T))
    end
    return nothing
end

# The terms of a convolution read its weights through `_lagweight`, so they
# run with the dense kernel.
const _ComputedContributions = _Contributions{<:_ComputedConvolution}
uses_adjoint(op::_ComputedContributions, ::Run) = _derived_local(op.c.kernel)
function _dense_contributions(op, x, gain, history, start, stop, keep)
    kernel = op.c.kernel
    n = last(_check_conv(kernel, x, gain, nothing, history, start, stop))
    K, sc = _fill_kernel(kernel, 0, n, n, keep)
    return _Contributions(_with_kernel(op.c, K)), n, sc
end
function _run_forward(op::_ComputedContributions, x, gain, history, start, stop)
    d, n, sc = _dense_contributions(op, x, gain, history, start, stop, Val(true))
    y, cache = _run_forward(d, x, gain, history, start, stop)
    return y, (; d, inner = cache, n, sc)
end
function _primal(op::_ComputedContributions, x, gain, history, start, stop)
    d, _, _ = _dense_contributions(op, x, gain, history, start, stop, Val(false))
    return _primal(d, x, gain, history, start, stop)
end
function pullback!(grads, op::_ComputedContributions, ::Run, cache)
    x̄ = cotangent(cotangent(cotangent(grads.piece, :c), :kernel), :x)
    K̄ = _weights_cotangent(x̄, _array(cache.d.c.kernel))
    piece = (; c = (; kernel = _dense_mirror(K̄)))
    pullback!((; piece, y = grads.y, args = grads.args), cache.d, Run(), cache.inner)
    _weights_back!(x̄, op.c.kernel, K̄, 0, cache.n, cache.sc)
    return nothing
end

_with_kernel(c::Convolution, K) = Convolution(_dense_kernel(K); method = _method(c))
function _with_kernel(r::Recurrence, K)
    return Recurrence(_Checked(), _dense_kernel(K), r.coupling, r.modifiers, r.rebuilds)
end

# A recurrence fills the weights of cohorts up to its last time, then runs
# with them as its kernel; its cache keeps the computed kernel.
function _recur(r::Recurrence{<:_ComputedKernel}, gain, add, h, s0, τ0, stop, record::Val)
    n = _stop(stop, (:gain => _extent(gain), :add => _extent(add)))
    K, sc = _fill_kernel(r.kernel, 1, n, n, record)
    Y, H, states, cache = _recur(_with_kernel(r, K), gain, add, h, s0, τ0, stop, record)
    return Y, H, states, _with_computed(cache, r.kernel, n, sc)
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
strata, lag 0 first, so entry `[l + 1, τ]` is the weight on lag ``l`` of
cohort ``\tau``.

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
reported = 1 - CR.Survival(Derived(*, base, level))
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
    K, sc = _fill_kernel(op.kernel, 0, n, _last_time(op, n))
    return K, (; n, sc)
end
function _primal(op::_KernelWeights, n)
    return first(_fill_kernel(op.kernel, 0, n, _last_time(op, n), Val(false)))
end
function pullback!(grads, op::_KernelWeights, ::Run, cache)
    _count_pullback()
    x̄ = cotangent(cotangent(grads.piece, :kernel), :x)
    _weights_back!(x̄, op.kernel, grads.y, 0, _last_time(op, cache.n), cache.sc)
    return nothing
end
