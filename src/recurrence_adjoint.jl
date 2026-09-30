# The analytic reverse pass of a `Recurrence`. Each step's core is
# `v = gain ⊙ x + add` with `x` the coupled kernel convolutions of the
# window, so its pullback is local; the work is sending the pressure's
# cotangent back through the coupling and correlating it with the kernel into
# the buffer's cotangent `H̄`, which carries it to earlier steps and the
# history. Modifier and coupling pullbacks run per step.

function pullback!(r::Recurrence, c, Ȳ, r̄, ḡain, ādd, h̄, s̄0, τ̄0)
    _reverse!(c, Ȳ, r̄, ḡain, ādd, h̄, s̄0, nothing)
    return nothing
end

function pullback!(w::_WithState, c, ȳ, w̄, ḡain, ādd, h̄, s̄0, τ̄0)
    Ȳ, st̄ = ȳ
    _reverse!(c, Ȳ, cotangent(w̄, :r), ḡain, ādd, h̄, s̄0, st̄)
    return nothing
end

function _reverse!(c, Ȳ, r̄, ḡain, ādd, h̄, s̄0, st̄)
    _PULLBACK_CALLS[] += 1
    (; r, kernel, gain, add, h, s0, τ0, L, S, T, H, P, X, rec) = c
    (; coupling, modifiers) = r
    Tp = eltype(H)
    H̄ = zeros(Tp, L + T, S)
    _seed_rows!(H̄, Ȳ, L)
    h̄end = cotangent(st̄, :history)
    h̄end === nothing || _seed_rows!(H̄, h̄end, T)
    ḡ = cotangent(r̄, :kernel)
    C̄ = cotangent(r̄, :coupling)
    m̄s = _mirrors(cotangent(r̄, :modifiers), modifiers)
    s̄s = map(_ -> zeros(Tp, S), modifiers)
    _seed_states!(s̄s, cotangent(st̄, :states))
    kbuf = _kernel_buffer(ḡ, kernel, Tp, S, L)
    v̄ = zeros(Tp, S)
    p̄ = zeros(Tp, S)
    q̄ = zeros(Tp, S)
    for t in T:-1:1
        τ = τ0 + t - 1
        for k in 1:S
            v̄[k] = H̄[L + t, k]
        end
        _stages_back!(modifiers, m̄s, rec, s̄s, v̄, τ, t)
        for k in 1:S
            _add_slot!(ādd, v̄[k], k, t)
            _add_slot!(ḡain, v̄[k] * X[k, t], k, t)
            q̄[k] = _at(gain, k, t) * v̄[k]
        end
        _coupling_back!(p̄, C̄, coupling, q̄, P, H, H̄, t, τ, L)
        _kernel_back!(kbuf, ḡ, kernel, p̄, H, H̄, t, τ, L)
    end
    _kernel_finish!(ḡ, kbuf)
    _scatter_history!(h̄, H̄, h, L)
    if s0 === nothing
        foreach(
            (m̄, m, s̄) -> init_state_pullback!(m̄, h̄, m, h, s̄), m̄s, modifiers, s̄s
        )
    elseif s̄0 !== nothing
        foreach((a, b) -> a === nothing || (a .+= b), s̄0, s̄s)
    end
    return nothing
end

# Add the public-layout cotangent `x̄` (length n, or S × n) into buffer rows
# `o + 1` to `o + n`.
function _seed_rows!(H̄, x̄::AbstractVector, o)
    view(H̄, (o + 1):(o + length(x̄)), 1) .+= x̄
    return H̄
end
function _seed_rows!(H̄, x̄::AbstractMatrix, o)
    view(H̄, (o + 1):(o + size(x̄, 2)), :) .+= transpose(x̄)
    return H̄
end

_seed_states!(s̄s, ::Nothing) = s̄s
function _seed_states!(s̄s, s̄end)
    foreach((a, b) -> b === nothing || (a .+= b), s̄s, s̄end)
    return s̄s
end

# One mirror per modifier.
_mirrors(::Nothing, ms) = map(_ -> nothing, ms)
_mirrors(m̄s, ms) = m̄s

# A gain or add slot's cotangent at stratum `k`, step `t`.
_add_slot!(::Nothing, v, k, t) = nothing
_add_slot!(x̄::Base.RefValue, v, k, t) = (x̄[] += v; nothing)
_add_slot!(x̄::AbstractVector, v, k, t) = (x̄[t] += v; nothing)
_add_slot!(x̄::AbstractMatrix, v, k, t) = (x̄[k, t] += v; nothing)

# Walk the step's value cotangent back through the modifiers, last first.
_stages_back!(::Tuple{}, m̄s, rec, s̄s, v̄, τ, t) = nothing
function _stages_back!(ms::Tuple, m̄s, rec, s̄s, v̄, τ, t)
    _stages_back!(
        Base.tail(ms), Base.tail(m̄s), Base.tail(rec), Base.tail(s̄s), v̄, τ, t
    )
    R = first(rec)
    apply_pullback!(
        first(m̄s), first(ms), view(R.V, :, t), view(R.S, :, t), τ, v̄,
        first(s̄s)
    )
    return nothing
end

# The coupling's pullback at step `t`: overwrite `p̄` with the cotangent of
# the kernel convolutions and add the coupling's own cotangent into `C̄`.
function _coupling_back!(p̄, C̄, C::UniformScaling, q̄, P, H, H̄, t, τ, L)
    λ̄ = cotangent(C̄, :λ)
    for k in eachindex(p̄)
        p̄[k] = C.λ * q̄[k]
        add_cotangent!(λ̄, q̄[k] * P[k, t])
    end
    return p̄
end
function _coupling_back!(p̄, C̄, C::Diagonal, q̄, P, H, H̄, t, τ, L)
    d̄ = cotangent(C̄, :diag)
    for k in eachindex(p̄)
        p̄[k] = C.diag[k] * q̄[k]
        add_cotangent!(d̄, q̄[k] * P[k, t], k)
    end
    return p̄
end
function _coupling_back!(p̄, C̄, C, q̄, P, H, H̄, t, τ, L)
    fill!(p̄, zero(eltype(p̄)))
    rows = t:(t + L - 1)
    pressure_pullback!(
        p̄, view(H̄, rows, :), C̄, C, q̄, view(P, :, t), view(H, rows, :), τ
    )
    return p̄
end

# A buffer for the kernel cotangent in the oldest-first order the forward
# pass reads a reversed fixed kernel in, or `nothing`.
_kernel_buffer(ḡ, kernel, Tp, S, L) = nothing
_kernel_buffer(ḡ::AbstractVector, kernel::AbstractVector, Tp, S, L) = zeros(Tp, L)
function _kernel_buffer(ḡ, kernel::PerStratum, Tp, S, L)
    return cotangent(ḡ, :x) === nothing ? nothing : zeros(Tp, S, L)
end

# Correlate `p̄` with the kernel into the window's cotangent, and the window
# with `p̄` into the kernel's.
function _kernel_back!(kbuf, ḡ, g::AbstractVector, p̄, H, H̄, t, τ, L)
    rows = t:(t + L - 1)
    for k in eachindex(p̄)
        kbuf === nothing || _axpy!(p̄[k], view(H, rows, k), kbuf)
        _axpy!(p̄[k], g, view(H̄, rows, k))
    end
    return nothing
end
function _kernel_back!(kbuf, ḡ, g::PerStratum, p̄, H, H̄, t, τ, L)
    rows = t:(t + L - 1)
    for k in eachindex(p̄)
        kbuf === nothing || _axpy!(p̄[k], view(H, rows, k), view(kbuf, k, :))
        _axpy!(p̄[k], view(g.x, k, :), view(H̄, rows, k))
    end
    return nothing
end
function _kernel_back!(kbuf, ḡ, g::TimeVarying, p̄, H, H̄, t, τ, L)
    Ḡ = cotangent(ḡ, :x)
    for k in eachindex(p̄), i in 1:L
        j = t + L - i
        _add_tv!(Ḡ, p̄[k] * H[j, k], k, i, τ)
        H̄[j, k] += p̄[k] * _tv_weight(g.x, k, i, τ)
    end
    return nothing
end
_kernel_back!(kbuf, ḡ, ::Nothing, p̄, H, H̄, t, τ, L) = nothing

# A time-varying weight's cotangent, as `_tv_weight` indexes it.
_add_tv!(::Nothing, v, k, j, τ) = nothing
_add_tv!(x̄::AbstractMatrix, v, k, j, τ) = (x̄[j, τ] += v; nothing)
_add_tv!(x̄::AbstractArray{<:Any, 3}, v, k, j, τ) = (x̄[k, j, τ] += v; nothing)

# Add the oldest-first buffer into the lag-first kernel cotangent.
_kernel_finish!(ḡ, ::Nothing) = nothing
function _kernel_finish!(ḡ::AbstractVector, kbuf::AbstractVector)
    L = length(kbuf)
    for i in 1:L
        ḡ[i] += kbuf[L + 1 - i]
    end
    return nothing
end
function _kernel_finish!(ḡ, kbuf::AbstractMatrix)
    Ḡ = cotangent(ḡ, :x)
    L = size(kbuf, 2)
    for i in 1:L, k in axes(kbuf, 1)
        Ḡ[k, i] += kbuf[k, L + 1 - i]
    end
    return nothing
end

# The buffer's first `L` rows back into the last `L` history columns; the
# zero-padded rows of a short history have no cotangent.
_scatter_history!(::Nothing, H̄, h, L) = nothing
function _scatter_history!(h̄::AbstractVector, H̄, h, L)
    m = length(h)
    n = min(m, L)
    view(h̄, (m - n + 1):m) .+= view(H̄, (L - n + 1):L, 1)
    return nothing
end
function _scatter_history!(h̄::AbstractMatrix, H̄, h, L)
    m = size(h, 2)
    n = min(m, L)
    view(h̄, :, (m - n + 1):m) .+= transpose(view(H̄, (L - n + 1):L, :))
    return nothing
end
