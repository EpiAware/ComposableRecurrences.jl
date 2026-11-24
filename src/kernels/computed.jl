# Operators with a computed kernel (see `weights.jl`). A convolution and
# `kernel_weights` walk each cohort's weights in turn (see `walk.jl`); a
# recurrence fills the weights as a dense `Primary()` kernel.

# == Convolution ==

const _ComputedConvolution = Convolution{<:_ComputedKernel}
uses_adjoint(c::_ComputedConvolution, ::Run) = _derived_local(c.kernel)
# Its weights fill and pull back on a device (see `walk.jl`), and the dense
# kernel of them convolves there, so a call on device arrays takes the rule.
_device_ready(::Convolution{<:_ComputedKernel, <:Union{Direct, Auto}}) = true

# On another executor the dense kernel of the same weights is used.
function _convolve!(ex, Y, c::_ComputedKernel, X, m, start)
    return _convolve_dense!(ex, Y, c, X, m, start)
end
function _convolve_dense!(ex, Y, c::_ComputedKernel, X, m, start)
    stop = start + size(Y, 1) - 1
    K, _ = _fill_kernel(c, 0, _cohorts(X, m, stop), stop, Val(false))
    return _convolve!(ex, Y, _dense_kernel(K), X, m, start)
end
function _convolve!(ex::Serial, Y, c::_ComputedKernel, X, m, start)
    _on_gpu(Y) && return _convolve_dense!(ex, Y, c, X, m, start)
    x = c.x
    L = _nlags(c)
    T = eltype(Y)
    stop = start + size(Y, 1) - 1
    sc = _walk_scratch(x, T, (L,), Val(false))
    last = stop
    stop = _cohorts(X, m, stop)
    xr = _lags_contiguous(x)
    ks = axes(Y, 2)
    for k0 in _walk_groups(x, ks), τ in max(1, start - L + 1):stop
        imax = _imax(τ, L, 0, last)
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
            # its chain of products, so each reads the walk after it, its
            # lags contiguous.
            _walk_cohort!(x, sc, k0, τ, 0, imax, T)
            _add_strata!(Y, xr, sc, X, kw, τ, i0, imax, m, start)
        end
    end
    return Y
end
# Cohort `τ`'s weights for each stratum in `kw`, read from its walk, times
# its input. Kept out of line, so the one-stratum loop compiles without it.
@noinline function _add_strata!(Y, xr, sc, X, kw, τ, i0, imax, m, start)
    for k in kw
        xk = @inbounds X[m + τ, k]
        @inbounds @simd for i in i0:imax
            w = _value(xr, sc, k, i, τ, i - 1, 1)
            Y[τ + i - start, k] += w * xk
        end
    end
    return nothing
end

# The cohorts up to `stop` whose rows the input or its cotangent `X` holds,
# lags from `m`: all of them in a call, and in a transposed call those of
# the outputs it keeps, so no coefficient is read past them.
_cohorts(X, m, stop) = min(stop, size(X, 1) - m)

# A transposed call keeps the outputs up to `stop` and reads the times up to
# `last`: a computed kernel's cohorts to `stop` and its times to `last`.
_transposed_rows(::_ComputedKernel, last, stop) = stop
function _check_transposed_times(k::_ComputedKernel, stop, last)
    return _check_coef_times(k.x, stop, last)
end

# Contiguous lags let a loop over one stratum's lags vectorise; decided from
# the type, so other coefficients cost nothing.
_lags_contiguous(x) = x
function _lags_contiguous(x::PerStratum{<:Matrix})
    return PerStratum(transpose(permutedims(x.x)))
end
function _lags_contiguous(x::Derived)
    _has_strata_lags(x) || return x
    return Derived(x.f, map(_lags_contiguous, x.args))
end
_strata_lags_type(::Type) = false
_strata_lags_type(::Type{<:PerStratum{<:Matrix}}) = true
function _strata_lags_type(::Type{<:Derived{F, A}}) where {F, A}
    return any(_strata_lags_type, fieldtypes(A))
end
# After its helpers: a generator sees only the methods defined before it.
@generated _has_strata_lags(x) = _strata_lags_type(x)

# Another executor takes the dense kernel's reverse pass.
function _convolve_back!(ex, X̄, c̄, c::_ComputedKernel, X, Ȳ, m, start)
    return _convolve_back_dense!(ex, X̄, c̄, c, X, Ȳ, m, start)
end
function _convolve_back_dense!(
        ex, X̄, c̄, c::_ComputedKernel, X, Ȳ, m, start
    )
    stop = start + size(Ȳ, 1) - 1
    K, sc = _fill_kernel(c, 0, _cohorts(X̄, m, stop), stop)
    x̄ = cotangent(c̄, :x)
    K̄ = _dense_convolve_back!(ex, X̄, x̄, K, X, Ȳ, m, start)
    _weights_back!(x̄, c, K̄, 0, stop, sc)
    return nothing
end

# Behind a function barrier, so inference never pairs a mirror and a kernel
# of different shapes.
@noinline function _dense_convolve_back!(ex, X̄, x̄, K, X, Ȳ, m, start)
    K̄ = _weights_cotangent(x̄, K)
    K̄d, Kd = _dense_mirror(K̄), _dense_kernel(K)
    _convolve_back!(ex, X̄, K̄d, Kd, X, Ȳ, m, start)
    return K̄
end
function _convolve_back!(
        ex::Serial, X̄, c̄, c::_ComputedKernel, X, Ȳ, m, start
    )
    _on_gpu(Ȳ) &&
        return _convolve_back_dense!(ex, X̄, c̄, c, X, Ȳ, m, start)
    x = c.x
    x̄ = cotangent(c̄, :x)
    L = _nlags(c)
    T = eltype(X̄)
    stop = start + size(Ȳ, 1) - 1
    sc = _walk_scratch(x, T, (L,), Val(false))
    last = stop
    stop = _cohorts(X̄, m, stop)
    ks = axes(Ȳ, 2)
    for k0 in _walk_groups(x, ks), τ in max(1, start - L + 1):stop
        imax = _imax(τ, L, 0, last)
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

# == Recurrence ==

_pressure_rule(::_ComputedKernel) = false
# The dense kernel of its weights runs on a device, as a dense time-varying
# kernel does.
function _device_ready(r::Recurrence{<:_ComputedKernel})
    return _device_coupling(r.coupling) && _device_modifiers(r.modifiers)
end
function _pressure_kernel(r::Recurrence{<:_ComputedKernel}, stop)
    K, _ = _fill_kernel(r.kernel, 1, stop, stop, Val(false))
    return _with_kernel(r, K)
end

function _with_kernel(r::Recurrence, K)
    return Recurrence(
        _Checked(), _dense_kernel(K), r.coupling, r.modifiers, r.rebuilds,
        _names(r)
    )
end

# A recurrence fills the weights of cohorts up to its last time, then runs
# with them as its kernel; its cache keeps the computed kernel.
function _recur(
        r::Recurrence{<:_ComputedKernel}, gain, add, h, s0, τ0, stop,
        cache::Val;
        picks = nothing
    )
    n = _stop(stop, (:gain => _extent(gain), :add => _extent(add)))
    K, sc = _fill_kernel(r.kernel, 1, n, n, cache)
    rk = _with_kernel(r, K)
    Y, H, states, inner = _recur(rk, gain, add, h, s0, τ0, stop, cache; picks)
    return Y, H, states, _with_computed(inner, r.kernel, n, sc)
end
# A plain call keeps nothing: the weights are filled in blocks and the run
# returns only its output, or with `:trace` the trace its steps write.
function _recur(
        r::Recurrence{<:_ComputedKernel}, gain, add, h, s0, τ0, stop,
        cache::Union{Val{:primal}, Val{:trace}}; picks = nothing
    )
    n = _stop(stop, (:gain => _extent(gain), :add => _extent(add)))
    K, _ = _fill_kernel(r.kernel, 1, n, n, Val(false))
    return _recur(_with_kernel(r, K), gain, add, h, s0, τ0, stop, cache; picks)
end
_with_computed(::Nothing, kernel, n, sc) = nothing
function _with_computed(cache, kernel, n, sc)
    return merge(cache, (; computed = (; kernel, n, sc)))
end
function _computed(c::NamedTuple)
    return hasfield(typeof(c), :computed) ? c.computed : nothing
end

# The reverse pass of a recurrence with a computed kernel: the dense
# kernel's cotangent, then the coefficients'.
function _reverse_computed!(
        ::Nothing, c, Ȳ, r̄, args::Vararg{Any, N}
    ) where {N}
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

# == kernel_weights ==

@doc raw"""
Return the weights of the computed kernel `TimeVarying(w, Primary())`,
with `w` a [`Derived`](@ref) or [`ComposableRecurrences.Survival`](@ref).
They cover the cohorts at times `1` to `n`, as an array: `L × n`, or
`S × L × n` with strata, lag 0 first,

```math
K_{l + 1, \tau} = w_l(\tau),
\qquad l = 0, \dots, L - 1, \quad \tau = 1, \dots, n,
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
# Its only argument is the number of cohorts, so whether it runs on a device
# follows its coefficients.
_device_ready(::_KernelWeights) = true
function _device_gate(op::_KernelWeights, n)
    return _on_gpu(_coef_array(op.kernel.x)) &&
        param_eltype(op) <: _IEEEFloat
end
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
    like = _coef_array(x)
    if _on_gpu(like)
        ns = max(_coef_strata(x), 1)
        return _device_fill(x, like, Tp, ns, L, n, 0, last)
    end
    # Every weight of cohorts `1:n` lands by `last`, so the walk writes each.
    K = _stratified(x) ? _alloc(Tp, _coef_strata(x), L, n) : _alloc(Tp, L, n)
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
