# == A one-lag recurrence as a scan ==

# A recurrence with one fixed lag, a pointwise scalar coupling and no
# modifiers is a first-order linear scan of each stratum,
#
#     y_t = c_t y_{t-1} + a_t,    c_t = λ k γ_t,
#
# so it runs with the running value in a register rather than read back from
# a buffer. Random walks, cumulative sums from a seed and AR(1) series all
# take it. Its reverse pass is the same scan run backwards.
struct _Scan{K, C} <: AbstractOperator
    kernel::K
    coupling::C
end
uses_adjoint(::_Scan, ::Run) = true

# Whether a call runs as a scan: read from the types, apart from the one
# lag, so a call that cannot take it folds the check away. Recorded calls
# and device arrays take the buffer run.
_scans(traced, stated, r, args) = false
function _scans(
        ::Val{false}, ::Val{false},
        r::Recurrence{<:AbstractVector{<:Real}, <:UniformScaling, Tuple{}}, args
    )
    gain, add, h, s0 = args
    return length(r.kernel) == 1 && s0 isa Union{Nothing, Tuple{}} &&
        _on_host(r.kernel) && _on_host(gain) && _on_host(add) && _on_host(h)
end

# The call through the scan, with the same checks and output as the buffer
# run. With `joined` the history fills the output's first `o` times.
@inline function _scan_call(route, r, (gain, add, h, s0, τ0), stop, joined)
    (; stop) = _checked_call(r, gain, add, h, s0, τ0, stop)
    o = joined ? size(h, ndims(h)) : 0
    return _scan_route(route, r.kernel, r.coupling, gain, add, h, τ0, stop, o)
end
# The Mooncake extension makes `_scan_rule` a rule primitive, which takes the
# pullback below; the Enzyme extension instead takes a rule for each
# stratum's scan, `_scan!`, which skips the rule's glue. At 30 to 300 steps
# the glue made Enzyme's whole-call rule 1.7 to 2.3 times `accumulate`.
# Elsewhere the scan takes its coefficient as a scalar, so a backend that
# differentiates it builds no shadow of the operator.
# Under `NoAdjoint` the backend differentiates the bare loop, without the
# Enzyme rule on `_scan!`.
function _scan_route(::NoAdjoint, kernel, C, args::Vararg{Any, N}) where {N}
    return _scan(_scan_coef(kernel, C), args..., _scan_steps!)
end
@inline function _scan_route(route, kernel, C, args::Vararg{Any, N}) where {N}
    _gate(kernel, C, args...) && return _scan_rule(kernel, C, args...)
    return _scan(_scan_coef(kernel, C), args...)
end
function _scan_rule(kernel, C, args::Vararg{Any, N}) where {N}
    return _scan(_scan_coef(kernel, C), args...)
end

function _run_forward(op::_Scan, gain, add, h, τ0, stop, o)
    y = _scan(_scan_coef(op), gain, add, h, τ0, stop, o)
    return y, (; y = copy(y), gain = _tape(gain), h, τ0, o)
end
function _primal(op::_Scan, args::Vararg{Any, N}) where {N}
    return _scan(_scan_coef(op), args...)
end

function _scan_eltype(c, gain, add, h)
    return _buffer_eltype(param_eltype((c, gain, add, h)), ())
end
_scan_coef(op::_Scan) = _scan_coef(op.kernel, op.coupling)
_scan_coef(kernel, C) = C.λ * only(kernel)
# The last history value of stratum `k`, or zero for an empty history. It
# is added to `+0.0`, as the buffer run's sum starts there, so a seed of
# `-0.0` gives `+0.0` as that run does.
function _scan_seed(h::AbstractVector, ::Type{Tp}, k) where {Tp}
    return isempty(h) ? zero(Tp) : zero(Tp) + Tp(h[end])
end
function _scan_seed(h::AbstractMatrix, ::Type{Tp}, k) where {Tp}
    return size(h, 2) == 0 ? zero(Tp) : zero(Tp) + Tp(h[k, end])
end

# The scan's output, with the history in its first `o` times when the call
# joins it (`o` is then the history's length, and zero otherwise).
function _scan(c, gain, add, h::AbstractVector, τ0, stop, o, step! = _scan!)
    Tp = _scan_eltype(c, gain, add, h)
    y = Vector{Tp}(undef, o + stop - τ0 + 1)
    o > 0 && _copy_times!(y, h, 0)
    step!(y, c, gain, add, _scan_seed(h, Tp, 1), τ0, 1, 1, o)
    return y
end
function _scan(c, gain, add, h::AbstractMatrix, τ0, stop, o, step! = _scan!)
    Tp = _scan_eltype(c, gain, add, h)
    S = size(h, 1)
    y = Matrix{Tp}(undef, S, o + stop - τ0 + 1)
    o > 0 && _copy_times!(y, h, 0)
    for k in 1:S
        step!(y, c, gain, add, _scan_seed(h, Tp, k), τ0, k, S, o)
    end
    return y
end

# Stratum `k` of `y` from seed `v`, its entry at step `j` in linear position
# `(j - 1) S + k`. Two steps at a time, as
# `y_{t+1} = d_{t+1} d_t y_{t-1} + (d_{t+1} a_t + a_{t+1})` with
# `d_t = c γ_t`, so the chain from one value to the next has one
# multiply-add per two steps and the rest runs beside it. The Enzyme
# extension's rule is on `_scan!`; `_scan_steps!` is the loop itself.
# Step `j` is at linear position `(o + j - 1) S + k`, after the `o` times
# of a joined history.
function _scan!(y, c, gain, add, v, τ0, k, S, o)
    return _scan_steps!(y, c, gain, add, v, τ0, k, S, o)
end
function _scan_steps!(y, c, gain, add, v, τ0, k, S, o)
    n = length(y) ÷ S - o
    j = 1
    @inbounds while j < n
        t = τ0 + j - 1
        d₁, d₂ = c * _at(gain, k, t), c * _at(gain, k, t + 1)
        a₁ = _at(add, k, t)
        y[(o + j - 1) * S + k] = muladd(d₁, v, a₁)
        v = muladd(d₂ * d₁, v, muladd(d₂, a₁, _at(add, k, t + 1)))
        y[(o + j) * S + k] = v
        j += 2
    end
    @inbounds if j == n
        t = τ0 + j - 1
        y[(o + j - 1) * S + k] =
            muladd(c * _at(gain, k, t), v, _at(add, k, t))
    end
    return nothing
end

# == Reverse pass ==

# With `u_t` the cotangent of `y_t`, `u_t = ȳ_t + d_{t+1} u_{t+1}`; it is the
# add input's, `e_t = u_t y_{t-1}` is the step coefficient's, and `d_1 u_1`
# the seed's. The kernel and the coupling scale share `Σ_t γ_t e_t`.
function pullback!(grads, op::_Scan, ::Run, cache)
    _count_pullback()
    (; y, gain, h, τ0, o) = cache
    ḡain, ādd, h̄ = grads.args
    k̄ = cotangent(grads.piece, :kernel)
    λ̄ = cotangent(cotangent(grads.piece, :coupling), :λ)
    λ, g = op.coupling.λ, only(op.kernel)
    Tp = eltype(y)
    S = _nstrata(h)
    c̄ = ḡ = ā = zero(Tp)
    for k in 1:S
        sums = _scan_back!(
            _array_slots(ḡain), _array_slots(ādd), grads.y, y, λ * g, gain,
            _scan_seed(h, Tp, k), τ0, k, S, o
        )
        c̄, ḡ, ā = c̄ + sums.c̄, ḡ + sums.ḡ, ā + sums.ā
        _scan_seed_back!(h̄, sums.v̄, k)
    end
    # A joined history's times pass their cotangents straight back.
    o > 0 && h̄ !== nothing && _add_times!(h̄, grads.y)
    k̄ === nothing || (k̄[1] += λ * c̄)
    λ̄ === nothing || (λ̄[] += g * c̄)
    ḡain isa Base.RefValue && (ḡain[] += ḡ)
    ādd isa Base.RefValue && (ādd[] += ā)
    return nothing
end

# Stratum `k`'s reverse scan, two steps at a time as the forward one, so the
# carry `w = d_t u_t` has one multiply-add per two steps on its chain. It
# adds into the array cotangents of the gain and add input (or skips
# `nothing`), and returns the sums a scalar of each takes, `Σ_t γ_t e_t` and
# the seed's cotangent.
function _scan_back!(ḡain, ādd, ȳ, y, c, gain, v, τ0, k, S, o)
    Tp = eltype(y)
    n = length(y) ÷ S - o
    c̄ = ḡ = ā = w = zero(Tp)
    j = n
    @inbounds while j > 1
        t = τ0 + j - 1
        γ₁, γ₂ = _at(gain, k, t - 1), _at(gain, k, t)
        d₁, d₂ = c * γ₁, c * γ₂
        ȳ₁, ȳ₂ = ȳ[(o + j - 2) * S + k], ȳ[(o + j - 1) * S + k]
        u₂ = w + ȳ₂
        u₁ = muladd(d₂, u₂, ȳ₁)
        e₂ = u₂ * y[(o + j - 2) * S + k]
        e₁ = u₁ * (j == 2 ? v : y[(o + j - 3) * S + k])
        _add_slot!(ādd, u₂, k, t)
        _add_slot!(ādd, u₁, k, t - 1)
        _add_slot!(ḡain, c * e₂, k, t)
        _add_slot!(ḡain, c * e₁, k, t - 1)
        # Each sum takes one add per pair, so its chain is no longer than
        # the carry's.
        c̄ += muladd(γ₂, e₂, γ₁ * e₁)
        ḡ += e₁ + e₂
        ā += u₁ + u₂
        w = muladd(d₁ * d₂, w, muladd(d₁, ȳ₁, d₁ * d₂ * ȳ₂))
        j -= 2
    end
    @inbounds if j == 1
        γ = _at(gain, k, τ0)
        u = w + ȳ[o * S + k]
        e = u * v
        _add_slot!(ādd, u, k, τ0)
        _add_slot!(ḡain, c * e, k, τ0)
        c̄ += γ * e
        ḡ += e
        ā += u
        w = c * γ * u
    end
    return (; c̄, ḡ = c * ḡ, ā, v̄ = w)
end
# A scalar's cotangent takes the returned sum, not a slot per step.
_array_slots(x̄::Base.RefValue) = nothing
_array_slots(x̄) = _slots(x̄)
# The first times of `ȳ`, a joined history's, added into `h̄`.
function _add_times!(h̄, ȳ)
    for i in 1:length(h̄)
        h̄[i] += ȳ[i]
    end
    return h̄
end
_scan_seed_back!(::Nothing, u, k) = nothing
function _scan_seed_back!(h̄::AbstractVector, u, k)
    isempty(h̄) || (h̄[end] += u)
    return nothing
end
function _scan_seed_back!(h̄::AbstractMatrix, u, k)
    size(h̄, 2) == 0 || (h̄[k, end] += u)
    return nothing
end
