# The analytic reverse pass of a `Recurrence`. Each step's core is
# `v = gain ⊙ x + add` with `x` the coupled kernel convolutions of the
# window, so its pullback is local; the work is sending the pressure's
# cotangent back through the coupling and correlating it with the kernel into
# the buffer's cotangent `H̄`, which carries it to earlier steps and the
# history. Modifier and coupling pullbacks run per step.

# `grads` is `(; piece, y, args)`: the mirror of the recurrence, the output
# cotangent and the mirrors of the positional arguments
# `(gain, add, history, states, start, stop)`.
function pullback!(grads, r::Recurrence, ::Run, c)
    ḡain, ādd, h̄, s̄0 = grads.args
    _reverse!(c, grads.y, grads.piece, ḡain, ādd, h̄, s̄0, nothing)
    return nothing
end
function pullback!(grads, w::_WithState, ::Run, c)
    Ȳ, st̄ = grads.y
    ḡain, ādd, h̄, s̄0 = grads.args
    _reverse!(c, Ȳ, cotangent(grads.piece, :r), ḡain, ādd, h̄, s̄0, st̄)
    return nothing
end

# The reverse pass runs under the executor set when it runs. The default
# is passed as the singleton `Serial()`, so the loops below hold no
# abstractly typed executor. Parameters that read across strata share one
# window cache per step, so their reverse pass runs serially.
function _reverse!(c, Ȳ, r̄, ḡain, ādd, h̄, s̄0, st̄)
    _count_pullback()
    (; r, H, D, S, T, τ0) = c
    H̄ = _zeros(H, eltype(H), D + T, S)
    # Parameters that read the outputs send their cotangents into `H̄`. The
    # bound modifiers enter the step loop through a function barrier.
    modifiers = _bind(r.modifiers, H, H̄, D - τ0 + 1)
    cur = _current()
    if cur.ex isa Serial || _reads_across(modifiers)
        _reverse!(Serial(), c, modifiers, H̄, Ȳ, r̄, ḡain, ādd, h̄, s̄0, st̄)
    else
        _reverse!(cur, c, modifiers, H̄, Ȳ, r̄, ḡain, ādd, h̄, s̄0, st̄)
    end
    return nothing
end

function _reverse!(ex, c, modifiers, H̄, Ȳ, r̄, ḡain, ādd, h̄, s̄0, st̄)
    (; r, kernel, gain, h, s0, τ0, L, D, S, T, H, pr, rec, init) = c
    coupling = r.coupling
    _seed_rows!(H̄, Ȳ, D)
    h̄end = cotangent(st̄, :history)
    h̄end === nothing || _seed_rows!(H̄, h̄end, T)
    ḡ = cotangent(r̄, :kernel)
    C̄ = cotangent(r̄, :coupling)
    m̄s = _mirrors(cotangent(r̄, :modifiers), modifiers)
    # `eltype(H)`, not a type bound to a local: a closure that captures a
    # type as a value does not infer it on Julia 1.11.
    s̄s = map(m -> _zeros(H, eltype(H), nstate(m, S)), modifiers)
    _seed_states!(s̄s, cotangent(st̄, :states))
    kbuf = _kernel_buffer(ḡ, kernel, H, S, L)
    # The cotangents the strata add into. The matrix gain and add inputs
    # have a slot per stratum and step, a fixed kernel's goes through
    # `kbuf`, and the parts that run on the calling task (`_steps_back!`)
    # are not copied.
    ādd, ḡain = _slots(ādd), _slots(ḡain)
    kslots = _kernel_slots(ḡ, kernel)
    work = S * _kwork(kernel, S, L)
    if _independent(coupling, kernel, modifiers)
        acc = (; ādd, ḡain, C̄, ḡ = kslots, m̄s)
        accs = _accumulators(ex, H, S, _work(_RunLoop(), H, T * work), acc)
        _reduce_blocks!(
            _series_back!, accs, S,
            H̄, kbuf, s̄s, rec, pr, gain, coupling, kernel, modifiers, H, τ0, L,
            D, T
        )
    else
        m̄v = _all_pointwise(modifiers) ? m̄s : _Owned(m̄s)
        acc = (; ādd, ḡain, C̄ = _Owned(C̄), ḡ = kslots, m̄s = m̄v)
        accs = _accumulators(ex, H, S, _work(_StepLoop(), H, work), acc)
        # The per-pass buffers of vector modifiers that ask for one, which
        # their step pullbacks fill a column of and `_finish_pass!` reads.
        bufs = map((m, m̄) -> _pass_buffer(H, eltype(H), m, m̄, S, T), modifiers, m̄s)
        _steps_back!(
            accs, H̄, kbuf, s̄s, rec, bufs, pr, gain, coupling, kernel, modifiers,
            H, τ0, L, D, S, T
        )
        foreach(modifiers, m̄s, rec, bufs) do m, m̄, R, b
            _finish_pass!(m̄, m, R, b, τ0)
        end
    end
    _reduce!(accs)
    _kernel_finish!(ḡ, kbuf)
    # An `Init` that reads the outputs adds into the history rows of `H̄`,
    # so the history is scattered after it.
    if s0 === nothing
        foreach(modifiers, m̄s, s̄s, init) do m, m̄, s̄, s
            pullback!((; piece = m̄, s = s̄, history = h̄), m, Init(), s, h)
        end
    elseif s̄0 !== nothing
        foreach((a, b) -> a === nothing || (a .+= b), s̄0, s̄s)
    end
    _flush!(modifiers)
    _scatter_history!(h̄, H̄, h, D)
    return nothing
end

_slots(x̄) = x̄
_slots(x̄::AbstractMatrix) = _Owned(x̄)
_kernel_slots(ḡ, kernel) = _Owned(ḡ)
_kernel_slots(ḡ, kernel::TimeVarying) = ḡ
_kernel_slots(ḡ, kernel::TimeVarying{<:Any, <:Pairwise}) = _Owned(ḡ)
# The pairwise kernels as the reverse pass reads them, fixed ones oldest first.
const _ReversedPairwise = Union{_OldestFirstPairwise, TimeVarying{<:Any, <:Pairwise}}
# A mirror as the calling task writes it.
_own(x̄::_Owned) = x̄.x

# The reverse run of the independent strata `ks`, time outermost as in
# `_series_body!`: each stratum's step reads and writes only its own slots
# and the block's accumulator `acc`.
function _series_back!(
        ks, acc, H̄, kbuf, s̄s, rec, pr, gain, coupling, kernel, ms, H, τ0, L, D, T
    )
    for (ts, g, j) in Iterators.reverse(_kernel_runs(kernel, τ0, T))
        kb = _run_buffer(kbuf, kernel, j)
        for t in reverse(_run_steps(ts, T))
            τ = τ0 + t - 1
            for k in ks
                q̄k = _value_back!(acc, s̄s, rec, pr, gain, coupling, ms, H̄, t, τ, D, k)
                p̄k = _coupling_back_at(acc.C̄, coupling, q̄k, pr, t, k)
                _kernel_back_at!(kb, acc.ḡ, g, p̄k, H, H̄, t + D - L, τ, L, k)
            end
        end
    end
    return nothing
end

# Stratum `k`'s output cotangent at step `t` back through the pointwise
# modifiers, then `_gain_add_back!`.
@inline function _value_back!(acc, s̄s, rec, pr, gain, C, ms, H̄, t, τ, D, k)
    v̄k = _thread_back(ms, acc.m̄s, rec, s̄s, H̄[D + t, k], τ, t, k)
    return _gain_add_back!(acc, v̄k, pr, gain, C, t, τ, k)
end

# The value's cotangent `v̄k` back through the add input and the gain;
# returns the pressure's cotangent.
@inline function _gain_add_back!(acc, v̄k, pr, gain, C, t, τ, k)
    _add_slot!(acc.ādd, v̄k, k, τ)
    _add_slot!(acc.ḡain, v̄k * _pressure(C, pr, k, t), k, τ)
    return _at(gain, k, τ) * v̄k
end

# The reverse steps of strata that mix, last first. Each step's loops over
# strata run in blocks of the executor where each stratum writes only its
# own slots: the pointwise modifiers and the kernel unless it is pairwise.
function _steps_back!(
        accs, H̄, kbuf, s̄s, rec, bufs, pr, gain, coupling, kernel, ms, H, τ0, L,
        D, S, T
    )
    acc = first(accs)
    Tp = eltype(H)
    v̄ = _zeros(H, Tp, S)
    p̄ = _zeros(H, Tp, S)
    q̄ = _zeros(H, Tp, S)
    pbufs = _pressure_buffers(_own(acc.C̄), coupling, Tp)
    for (ts, g, j) in Iterators.reverse(_kernel_runs(kernel, τ0, T))
        kb = _run_buffer(kbuf, kernel, j)
        for t in reverse(_run_steps(ts, T))
            τ = τ0 + t - 1
            _refresh!(ms, D + t)
            if _all_pointwise(ms)
                _reduce_blocks!(
                    _values_back!, accs, S, q̄, s̄s, rec, pr, gain, coupling, ms, H̄,
                    t, τ, D
                )
            else
                for k in 1:S
                    v̄[k] = H̄[D + t, k]
                end
                _stages_back!(ms, _own(acc.m̄s), rec, s̄s, bufs, v̄, τ, t)
                for k in 1:S
                    q̄[k] = _gain_add_back!(acc, v̄[k], pr, gain, coupling, t, τ, k)
                end
            end
            _coupling_back!(p̄, _own(acc.C̄), coupling, q̄, pr, t, τ, pbufs)
            _kernels_back!(accs, kb, g, p̄, H, H̄, t + D - L, τ, L)
            _flush!(ms)
        end
    end
    return nothing
end

function _values_back!(ks, acc, q̄, s̄s, rec, pr, gain, C, ms, H̄, t, τ, D)
    for k in ks
        q̄[k] = _value_back!(acc, s̄s, rec, pr, gain, C, ms, H̄, t, τ, D, k)
    end
    return nothing
end

# The kernel's pullback at step `t`: per stratum in blocks, or for a
# pairwise kernel or routes (`routes.jl`), whose strata read every
# stratum's window, on one block.
function _kernels_back!(accs, kbuf, kernel, p̄, H, H̄, t, τ, L)
    _reduce_blocks!(
        _kernels_body!, accs, length(p̄), kbuf, kernel, p̄, H, H̄, t, τ, L
    )
    return nothing
end
function _kernels_back!(accs, kbuf, kernel::_ReversedPairwise, p̄, H, H̄, t, τ, L)
    _kernel_back!(kbuf, _own(first(accs).ḡ), kernel, p̄, H, H̄, t, τ, L)
    return nothing
end
function _kernels_body!(ks, acc, kbuf, kernel, p̄, H, H̄, t, τ, L)
    for k in ks
        _kernel_back_at!(kbuf, acc.ḡ, kernel, p̄[k], H, H̄, t, τ, L, k)
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
_add_slot!(x̄::_Owned, v, k, t) = _add_slot!(x̄.x, v, k, t)

# One stratum's value cotangent back through pointwise modifiers, last
# first, with each one's scalar step pullback; returns the cotangent of the
# step's core value.
_thread_back(::Tuple{}, m̄s, rec, s̄s, v̄, τ, t, k) = v̄
function _thread_back(ms::Tuple, m̄s, rec, s̄s, v̄, τ, t, k)
    v̄ = _thread_back(
        Base.tail(ms), Base.tail(m̄s), Base.tail(rec), Base.tail(s̄s), v̄, τ, t, k
    )
    R, s̄ = first(rec), first(s̄s)
    v̄, s̄[k] = _step_pullback(
        (; piece = first(m̄s), v = v̄, s = s̄[k]), first(ms), R.V[k, t],
        _state_at(R.S, k, t), τ, k
    )
    return v̄
end

# Walk the step's value cotangent back through the modifiers, last first,
# with `grads.after` and `grads.pass` for a modifier that asks for them (see
# `_pass_buffer`).
_stages_back!(::Tuple{}, m̄s, rec, s̄s, bufs, v̄, τ, t) = nothing
function _stages_back!(ms::Tuple, m̄s, rec, s̄s, bufs, v̄, τ, t)
    _stages_back!(
        Base.tail(ms), Base.tail(m̄s), Base.tail(rec), Base.tail(s̄s),
        Base.tail(bufs), v̄, τ, t
    )
    R = first(rec)
    _vector_pullback!(
        _step_grads(first(m̄s), v̄, first(s̄s), R.A, first(bufs), t), first(ms),
        view(R.V, :, t), _states_at(R.S, t), τ
    )
    return nothing
end
_step_grads(m̄, v̄, s̄, ::Nothing, ::Nothing, t) = (; piece = m̄, v = v̄, s = s̄)
function _step_grads(m̄, v̄, s̄, A, b, t)
    return (; piece = m̄, v = v̄, s = s̄, after = _column(A, t), pass = _column(b, t))
end
_column(::Nothing, t) = nothing
_column(A::AbstractMatrix, t) = view(A, :, t)
_column(b::NamedTuple, t) = map(B -> _column(B, t), b)
_column(x::AbstractVector, t) = x

# What the reverse pass of a `Recurrence` keeps for a vector modifier:
#
# - `_keeps_after(m)` true: the forward pass records the modifier's state
#   after each step (`R.A`, entries × steps), and its step pullback finds
#   that step's column in `grads.after`.
# - `_pass_buffer(H, Tp, m, m̄, S, T)`: `nothing`, or a named tuple of arrays
#   whose matrices (entries × steps) the step pullback writes a column of,
#   found in `grads.pass`; vectors are scratch shared by every step.
#   `_finish_pass!(m̄, m, R, b, τ0)` then reads it once, after the last step,
#   to add the cotangents the steps left for it.
#
# `grads` carries `after` and `pass` only when the modifier asks for one of
# them, so other pullbacks see the usual fields. Without them a pullback
# must give the same cotangents by its per-step path. They reach only a modifier's own vector
# `pullback!`: a blockwise modifier split into groups gets neither, so one
# that asks must have its own vector pullback.
_pass_buffer(H, ::Type, m, m̄, S, T) = nothing
_finish_pass!(m̄, m, R, ::Nothing, τ0) = nothing

# The coupling's pullback at step `t`: overwrite `p̄` with the cotangent of
# the kernel convolutions and add the coupling's own cotangent into `C̄`.
function _coupling_back!(p̄, C̄, C::_PointwiseCoupling, q̄, pr, t, τ, pbufs)
    for k in eachindex(p̄)
        p̄[k] = _coupling_back_at(C̄, C, q̄[k], pr, t, k)
    end
    return p̄
end
function _coupling_back!(p̄, C̄, C, q̄, pr, t, τ, pbufs)
    fill!(p̄, zero(eltype(p̄)))
    _pressure_back!(p̄, C̄, C, q̄, view(pr.P, :, t), τ, pbufs)
    return p̄
end

function _coupling_back_at(C̄, C::UniformScaling, q̄k, pr, t, k)
    add_cotangent!(cotangent(C̄, :λ), q̄k * pr.P[k, t])
    return C.λ * q̄k
end
function _coupling_back_at(C̄, C::Diagonal, q̄k, pr, t, k)
    add_cotangent!(cotangent(C̄, :diag), q̄k * pr.P[k, t], k)
    return C.diag[k] * q̄k
end

# A buffer for the kernel cotangent in the oldest-first order the forward
# pass reads a reversed fixed kernel in, or `nothing`.
_kernel_buffer(ḡ, kernel, H, S, L) = nothing
# One column per stratum, reduced after the loop, so each stratum writes only
# its own slots.
function _kernel_buffer(ḡ::AbstractVector, kernel::AbstractVector, H, S, L)
    return _zeros(H, eltype(H), L, S)
end
function _kernel_buffer(ḡ, kernel::PerStratum, H, S, L)
    return cotangent(ḡ, :x) === nothing ? nothing : _zeros(H, eltype(H), S, L)
end
function _kernel_buffer(ḡ, kernel::_OldestFirstPairwise, H, S, L)
    return cotangent(ḡ, :x) === nothing ? nothing : _zeros(H, eltype(H), L, S, S)
end

# Correlate stratum `k`'s `a` with the kernel into the window's cotangent,
# and the window with `a` into the kernel's, in one native loop; a pairwise
# kernel's strata read every stratum's window, so it runs over all of them.
function _kernel_back_at!(kbuf, ḡ, g::AbstractVector, a, H, H̄, t, τ, L, k)
    kb = kbuf === nothing ? nothing : view(kbuf, :, k)
    _window_back!(kb, g, a, H, H̄, t, L, k)
    return nothing
end
function _kernel_back_at!(kbuf, ḡ, g::PerStratum, a, H, H̄, t, τ, L, k)
    kb = kbuf === nothing ? nothing : view(kbuf, k, :)
    _window_back!(kb, view(g.x, k, :), a, H, H̄, t, L, k)
    return nothing
end
# Every stratum's pullback, as a route's kernel runs it.
function _kernel_back!(kbuf, ḡ, g, p̄, H, H̄, t, τ, L)
    for k in eachindex(p̄)
        _kernel_back_at!(kbuf, ḡ, g, p̄[k], H, H̄, t, τ, L, k)
    end
    return nothing
end
function _kernel_back!(kbuf, ḡ, g::_OldestFirstPairwise, p̄, H, H̄, t, τ, L)
    for a in eachindex(p̄), b in axes(H, 2)
        kb = kbuf === nothing ? nothing : view(kbuf, :, b, a)
        _window_back!(kb, view(g.x, :, b, a), p̄[a], H, H̄, t, L, b)
    end
    return nothing
end
# `kbuf`, `g`, `H` and `H̄` are distinct arrays, so the updates are
# independent (`ivdep`).
function _window_back!(kbuf, g, a, H, H̄, t, L, k)
    @inbounds @simd ivdep for i in 1:L
        kbuf[i] += a * H[t + i - 1, k]
        H̄[t + i - 1, k] += a * g[i]
    end
    return nothing
end
function _window_back!(::Nothing, g, a, H, H̄, t, L, k)
    @inbounds @simd ivdep for i in 1:L
        H̄[t + i - 1, k] += a * g[i]
    end
    return nothing
end
# Time-varying kernels read their weights through `_weight` and add their
# cotangents through `_add_weight!`; a pairwise kernel mixes strata, so
# stratum `a`'s convolution reads every stratum `b`. Lag `i` reads column
# `_column(g, τ, i)`: `τ`, or `τ - i` for a `Primary()` kernel, whose lags
# before time 1 have no column (`_lags`). Lag runs innermost, so each
# sender's window is read in order.
function _kernel_back!(
        kbuf, ḡ, g::TimeVarying{<:Any, <:Pairwise}, p̄, H, H̄, t, τ, L
    )
    for a in eachindex(p̄)
        @inbounds _tv_back!(ḡ, g, p̄[a], H, H̄, t, τ, L, a, axes(H, 2))
    end
    return nothing
end
function _kernel_back_at!(kbuf, ḡ, g::TimeVarying, a, H, H̄, t, τ, L, k)
    _tv_back!(ḡ, g, a, H, H̄, t, τ, L, k, k:k)
    return nothing
end
function _tv_back!(ḡ, g, pa, H, H̄, t, τ, L, a, senders)
    for b in senders, i in _lags(g, τ, L)
        j = t + L - i
        c = _column(g, τ, i)
        @inbounds _add_weight!(ḡ, g, pa * H[j, b], a, b, i, c)
        @inbounds H̄[j, b] += pa * _weight(g, a, b, i, c)
    end
    return nothing
end

# A weight's cotangent, as `_weight` reads it.
Base.@propagate_inbounds function _add_weight!(
        ḡ, g::TimeVarying{<:Any, <:AbstractMatrix}, v, a, b, i, τ
    )
    return add_cotangent!(cotangent(ḡ, :x), v, i, τ)
end
Base.@propagate_inbounds function _add_weight!(
        ḡ, g::TimeVarying{<:Any, <:PerStratum}, v, a, b, i, τ
    )
    return add_cotangent!(cotangent(cotangent(ḡ, :x), :x), v, a, i, τ)
end
Base.@propagate_inbounds function _add_weight!(
        ḡ, g::TimeVarying{<:Any, <:Pairwise}, v, a, b, i, τ
    )
    return add_cotangent!(cotangent(cotangent(ḡ, :x), :x), v, a, b, i, τ)
end
Base.@propagate_inbounds function _add_weight!(
        ḡ, g::TimeVarying{<:Any, <:_AnyRagged}, v, a, b, i, τ
    )
    i <= length(_colview(g.x, τ)) || return nothing
    return add_cotangent!(_column_mirror(cotangent(ḡ, :x), g.x, τ), v, i)
end

# Add the oldest-first buffer into the lag-first kernel cotangent.
_kernel_finish!(ḡ, ::Nothing) = nothing
function _kernel_finish!(ḡ::AbstractVector, kbuf::AbstractMatrix)
    L = size(kbuf, 1)
    for k in axes(kbuf, 2), i in 1:L
        ḡ[i] += kbuf[L + 1 - i, k]
    end
    return nothing
end
function _kernel_finish!(ḡ::NamedTuple, kbuf::AbstractMatrix)
    Ḡ = cotangent(ḡ, :x)
    L = size(kbuf, 2)
    for i in 1:L, k in axes(kbuf, 1)
        Ḡ[k, i] += kbuf[k, L + 1 - i]
    end
    return nothing
end
function _kernel_finish!(ḡ::NamedTuple, kbuf::AbstractArray{<:Any, 3})
    Ḡ = cotangent(ḡ, :x)
    L = size(kbuf, 1)
    for i in 1:L, b in axes(kbuf, 2), a in axes(kbuf, 3)
        Ḡ[a, b, i] += kbuf[L + 1 - i, b, a]
    end
    return nothing
end

# The buffer's first `D` rows back into the last `D` history columns; the
# zero-padded rows of a short history have no cotangent.
_scatter_history!(::Nothing, H̄, h, D) = nothing
function _scatter_history!(h̄::AbstractVector, H̄, h, D)
    m = length(h)
    n = min(m, D)
    view(h̄, (m - n + 1):m) .+= view(H̄, (D - n + 1):D, 1)
    return nothing
end
function _scatter_history!(h̄::AbstractMatrix, H̄, h, D)
    m = size(h, 2)
    n = min(m, D)
    view(h̄, :, (m - n + 1):m) .+= transpose(view(H̄, (D - n + 1):D, :))
    return nothing
end
