# A call with its trace: the output of `op` (a `Recurrence` or its
# `_WithState`) and each modifier's trace, built after the run from the
# records the rule keeps, or in each step of a run without records.

# == _WithTrace ==

# `sel` holds the parts of the trace it builds, a flag for each modifier, one
# for the pressure and one for the force (see `_selection`); a part it does
# not build is an empty array of the same type, so it costs nothing in the
# cotangent.
struct _WithTrace{O <: AbstractOperator, P} <: AbstractOperator
    op::O
    sel::P
end
# The whole trace, as `forward` records it.
_WithTrace(op) = _WithTrace(op, _all_parts(Val(_nmodifiers(op))))
_nmodifiers(r::Recurrence) = length(r.modifiers)
_nmodifiers(w::_WithState) = _nmodifiers(w.r)

# Routed as its operator is, on a device too.
uses_adjoint(w::_WithTrace, ::Run) = uses_adjoint(w.op, Run())
_type_adjoint(w::_WithTrace) = _type_adjoint(w.op)
_device_ready(w::_WithTrace) = _device_ready(w.op)
_fit(w::_WithTrace, args...) = _fit(w.op, args...)
_long_kernel(w::_WithTrace, args...) = _long_kernel(w.op, args...)

function _run_forward(w::_WithTrace, gain, add, h, s0, τ0, stop)
    y, cache = _run_forward(w.op, gain, add, h, s0, τ0, stop, Val(:traced))
    tr = _traces(_traced_recurrence(w.op), cache, w.sel)
    return (y, _with_force(tr, w.sel, gain, add, τ0)), cache
end
# The modifiers are read from the operator, not the cache: plain reverse AD
# on Julia 1.11 can lose a scalar field's cotangent read back from the cache.
_traced_recurrence(r::Recurrence) = r
_traced_recurrence(w::_WithState) = w.r
# On host arrays a call writes each modifier's trace in its step
# (`_TraceSink`); elsewhere it runs the traced rule's forward pass.
_primal(w::_WithTrace, args...) = first(_run_forward(w, args...))
function _primal(w::_WithTrace, gain, add, h::_CPUArray, s0, τ0, stop)
    y, tr = _traced_primal(w.op, gain, add, h, s0, τ0, stop)
    return y, _with_force(_selected_trace(tr, w.sel), w.sel, gain, add, τ0)
end
function _traced_primal(r::Recurrence, gain, add, h, s0, τ0, stop)
    Y, _, _, tr = _recur(r, gain, add, h, s0, τ0, stop, Val(:trace))
    return Y, tr
end
function _traced_primal(w::_WithState, gain, add, h, s0, τ0, stop)
    Y, H, states, tr = _recur(w.r, gain, add, h, s0, τ0, stop, Val(:trace))
    return (Y, _state(Y, H, states, h, τ0)), tr
end

# == Trace sinks ==

# A modifier's trace as the run writes it, with copies `v` and `s` of the
# step's inputs for a step on the whole vectors that is not pointwise.
# `out` starts unset, as each step writes its column.
struct _TraceSink{O, V, W}
    out::O
    v::V
    s::W
    S::Int
end
# A modifier whose state never changes writes no trace: its trace is zeros.
struct _NoTrace{O}
    out::O
end
_sinks(::Val{false}, h, ::Type{Tp}, ms, states, S, T) where {Tp} = nothing
function _sinks(::Val{:trace}, h, ::Type{Tp}, ms, states, S, T) where {Tp}
    return map(ms, states) do m, s
        n = ntrace(m, S)
        isstateless(m) && return _NoTrace(_zeros(h, Tp, n, T))
        out = _unset(h, Tp, n, T)
        _strata_loop(m) && return _TraceSink(out, nothing, nothing, S)
        return _TraceSink(out, _zeros(h, Tp, S), similar(s), S)
    end
end
_sink_traces(::Nothing) = nothing
_sink_traces(rec::Tuple) = map(R -> R.out, rec)

# A trace sink keeps no records.
_record!(::Union{_TraceSink, _NoTrace}, v, s, t, k) = nothing
@inline _trace_step!(::_NoTrace, m, v, s, v′, s′, τ, t, k) = nothing
_stage_rec!(::_NoTrace, m, v, s, τ, t) = _stage!(m, v, s, τ)
# Stratum `k`'s trace of a pointwise modifier at step `t`, on one-entry
# views as `_step` runs the step; inlined so the slots stay off the heap.
@inline function _trace_step!(R::_TraceSink, m, v, s, v′, s′, τ, t, k)
    at = x -> _At(x, k)
    r = map(at, _trace_series(view(R.out, :, t), Val(ntrace(m, 1)), R.S))
    foreach(x -> x[] = zero(eltype(x)), r)
    _written(
        m, @inline forward!(
            m, Trace(), r, at(Ref(v)), at(Ref(s)), at(Ref(v′)), at(Ref(s′)), τ
        )
    )
    return nothing
end
# A pointwise modifier's step runs and writes its trace stratum by stratum,
# as `_thread` does; any other keeps its inputs, then writes its trace.
function _stage_rec!(R::_TraceSink, m, v, s, τ, t)
    return _stage_trace!(Val(_strata_loop(m)), R, m, v, s, τ, t)
end
function _stage_trace!(::Val{true}, R, m, v, s, τ, t)
    for k in eachindex(v, s)
        vk, sk = v[k], s[k]
        v′, s′ = _step(m, vk, sk, τ, k)
        v[k], s[k] = v′, s′
        _trace_step!(R, m, vk, sk, v′, s′, τ, t, k)
    end
    return nothing
end
function _stage_trace!(::Val{false}, R, m, v, s, τ, t)
    _copy_trace!(R.v, v)
    _copy_trace!(R.s, s)
    _stage!(m, v, s, τ)
    _trace_column!(R, m, v, s, τ, t)
    return nothing
end
# Step `t`'s column of a whole-step trace, from the inputs kept in `R` and
# the outputs `v` and `s`.
function _trace_column!(R, m, v, s, τ, t)
    col = view(R.out, :, t)
    fill!(col, zero(eltype(col)))
    _trace!(col, m, R.v, R.s, v, s, τ)
    return nothing
end

# == Traces from the records ==

# Only the parts a selection names are built; the others are empty.
function _traces(r, c, sel)
    (; H, rec, D, S, T, τ0) = c
    ms = _bind(r.modifiers, H, nothing, D - τ0 + 1)
    modifiers = _traces(ms, rec, c.states, first(sel), H, D, S, T, τ0)
    pressure = _pressure_trace(_builds_pressure(sel), r, c)
    return (; modifiers, pressure)
end
# The force is built from the pressure, so either needs it.
_builds_pressure(sel) = sel[2] | sel[3]
# A pressure not built comes from records with no steps, so it has the type
# of one that is.
function _pressure_trace(keep, r, c)
    pr = keep ? c.pr : map(_no_times, c.pr)
    return _output_layout(_pressures(r.coupling, pr), c.h)
end
# An array like `x` with no columns, or with no rows or columns: the trace
# of a part not built.
_no_times(x::AbstractVector) = similar(x, 0)
_no_times(x::AbstractMatrix) = similar(x, size(x, 1), 0)
_no_times(::Nothing) = nothing
_no_parts(x::AbstractMatrix) = similar(x, 0, 0)
# A step's outputs are the next modifier's inputs, or the buffer's row for the
# last.
_traces(::Tuple{}, ::Tuple{}, ::Tuple{}, ::Tuple{}, H, D, S, T, τ0) = ()
function _traces(
        ms::Tuple, rec::Tuple, finals::Tuple, picks::Tuple, H, D, S, T, τ0
    )
    rest = Base.tail(rec)
    out = _trace_of(
        first(picks), first(ms), first(rec), rest, first(finals), H, D, S,
        T, τ0
    )
    others = _traces(
        Base.tail(ms), rest, Base.tail(finals), Base.tail(picks), H, D, S, T,
        τ0
    )
    return (out, others...)
end
function _trace_of(keep::Bool, m, R, rest, final, H, D, S, T, τ0)
    out = _zeros(H, eltype(H), keep ? ntrace(m, S) : 0, keep ? T : 0)
    if keep && !isstateless(m)
        for t in 1:(T - 1)
            _trace_at!(out, m, R, rest, _states_at(R.S, t + 1), H, D, t, τ0)
        end
        # The final state on its own, so each call sees one type.
        _trace_at!(out, m, R, rest, final, H, D, T, τ0)
    end
    return out
end
# A trace written in the run's steps, with the parts a selection does not
# name dropped.
function _selected_trace(tr, sel)
    modifiers = map(tr.modifiers, first(sel)) do x, keep
        keep ? x : _no_parts(x)
    end
    pressure = _builds_pressure(sel) ? tr.pressure : _no_times(tr.pressure)
    return (; modifiers, pressure)
end

# == The force ==

# The trace with its force, the value `γ_t ⊙ q_t + a_t` of each step before
# the modifiers, from the pressure `q_t` the run built. It is a broadcast
# over the steps, so the run's loops do not change, and its cotangent joins
# each step's value cotangent in the reverse pass (`_traced_force`). A
# pressure the selection does not name was built only for the force, so it
# is dropped here.
function _with_force(tr, sel, gain, add, τ0)
    Q = tr.pressure
    force = sel[3] ? _force(Q, gain, add, τ0) : _no_times(Q)
    pressure = sel[2] ? Q : _no_times(Q)
    return (; tr.modifiers, pressure, force)
end
function _force(Q, gain, add, τ0)
    F = similar(Q)
    q = _strata_rows(Q)
    T = size(q, 2)
    _strata_rows(F) .=
        muladd.(_over_steps(gain, τ0, T), q, _over_steps(add, τ0, T))
    return F
end
# A gain or add input over the steps from absolute time `τ0`, shaped to
# broadcast against strata × steps.
_over_steps(x::Real, τ0, T) = x
_over_steps(::Nothing, τ0, T) = false
_over_steps(x::AbstractVector, τ0, T) = reshape(view(x, τ0:(τ0 + T - 1)), 1, T)
_over_steps(x::AbstractMatrix, τ0, T) = view(x, :, τ0:(τ0 + T - 1))
function _trace_at!(out, m, R, rest, s′, H, D, t, τ0)
    v, s = view(R.V, :, t), _states_at(R.S, t)
    v′ = _outputs_at(rest, H, D, t)
    _trace!(view(out, :, t), m, v, s, v′, s′, τ0 + t - 1)
    return nothing
end
_outputs_at(::Tuple{}, H, D, t) = view(H, D + t, :)
_outputs_at(rec::Tuple, H, D, t) = view(first(rec).V, :, t)

# == Reverse pass ==

# A modifier's records with its trace cotangent `T̄` and the buffers for the
# cotangents its trace sends to the step's inputs. `live` is false for an
# all-zero `T̄`, as a loss that reads another modifier's trace gives.
const _TracedRecord = NamedTuple{(:V, :S, :A, :T̄, :V̄, :S̄, :live)}
_traced_records(rec, ::Nothing, S) = rec
function _traced_records(rec, T̄s::Tuple, S)
    return map((R, T̄) -> _traced_record(R, T̄, S), rec, T̄s)
end
_traced_record(R, ::Nothing, S) = R
function _traced_record(R, T̄, S)
    return (;
        R..., T̄, V̄ = _zeros(R.V, eltype(R.V), S),
        S̄ = zero(_states_at(R.S, 1)), live = !iszero(T̄),
    )
end

# `_trace_out` adds the trace's share of the step's output cotangents and
# returns its share of the inputs', which `_trace_in` adds after the pullback.
_trace_out(R, m, m̄, v̄, s̄, v, s, τ, t, k) = v̄, s̄, nothing, nothing
function _trace_out(R::_TracedRecord, m, args...)
    return _trace_out(Val(isstateless(m)), R, m, args...)
end
# A modifier whose state never changes has no trace, so no cotangent.
function _trace_out(::Val{true}, R, m, m̄, v̄, s̄, v, s, τ, t, k)
    return v̄, s̄, nothing, nothing
end
# On one-entry views of stratum `k`; inlined so the slots stay off the heap.
@inline function _trace_out(::Val{false}, R, m, m̄, v̄, s̄, v, s, τ, t, k)
    z = zero(v̄)
    R.live || return v̄ + z, s̄ + z, z, z
    S = length(R.V̄)
    r̄ = _trace_series(view(R.T̄, :, t), Val(ntrace(m, 1)), S)
    a, b, c, d = Ref(z), Ref(z), Ref(z), Ref(z)
    at = x -> _At(x, k)
    grads = (;
        piece = m̄, trace = map(at, r̄), v = at(a), s = at(b), v′ = at(c),
        s′ = at(d),
    )
    _written(
        m, @inline pullback!(grads, m, Trace(), at(Ref(v)), at(Ref(s)), τ)
    )
    return v̄ + c[], s̄ + d[], a[], b[]
end
_trace_in(::Nothing, x̄) = x̄
_trace_in(a, x̄) = x̄ + a

# The same for a vector-level step, with the inputs' share in the record's
# buffers. A trace that is the state after the step (`_trace_is_state`, true
# only for the default `Trace()` methods) is added into `s̄` alone.
_trace_out!(R, m, m̄, v̄, s̄, v, s, τ, t) = nothing
_trace_is_state(m) = false
function _trace_out!(R::_TracedRecord, m, m̄, v̄, s̄, v, s, τ, t)
    (isstateless(m) || !R.live) && return nothing
    _trace_is_state(m) && return _add_trace_column!(s̄, R.T̄, t)
    _trace_back!(_blocks(m), R, m, m̄, v̄, s̄, view(R.T̄, :, t), v, s, τ)
    return nothing
end
_trace_in!(R, m, v̄, s̄) = nothing
function _trace_in!(R::_TracedRecord, m, v̄, s̄)
    (_trace_is_state(m) || !R.live) && return nothing
    v̄ .+= R.V̄
    s̄ .+= R.S̄
    return nothing
end
# Column `t` of a trace's cotangent, added into the cotangent of the state
# after the step.
function _add_trace_column!(s̄, T̄, t)
    n = length(s̄)
    length(T̄) == n * size(T̄, ndims(T̄)) ||
        throw(DimensionMismatch("a trace column is not the state's length"))
    o = (t - 1) * n
    checkbounds(T̄, (o + 1):(o + n))
    _on_gpu(s̄) && return (s̄ .+= view(vec(T̄), (o + 1):(o + n)); nothing)
    @inbounds for k in 1:n
        s̄[k] += T̄[o + k]
    end
    return nothing
end

function _trace_back!(::Nothing, R, m, m̄, v̄, s̄, r̄, v, s, τ)
    R.V̄ .= zero(eltype(R.V̄))
    R.S̄ .= zero(eltype(R.S̄))
    _on_gpu(v) && _strata_loop(m) &&
        return _device_trace_back!(nothing, R, m, m̄, v̄, s̄, r̄, v, s, τ)
    r = _strata_loop(m) ? _trace_series(r̄, Val(ntrace(m, 1)), length(v)) : r̄
    grads = (; piece = m̄, trace = r, v = R.V̄, s = R.S̄, v′ = v̄, s′ = s̄)
    _written(m, pullback!(grads, m, Trace(), v, s, τ))
    return nothing
end
function _trace_back!(::Val{B}, R, m, m̄, v̄, s̄, r̄, v, s, τ) where {B}
    G = _ngroups(Val(B), length(v))
    R.V̄ .= zero(eltype(R.V̄))
    R.S̄ .= zero(eltype(R.S̄))
    _on_gpu(v) && return _device_trace_back!(Val(B), R, m, m̄, v̄, s̄, r̄, v, s, τ)
    for g in 1:G
        _group_trace_back!(m, Val(B), R, m̄, v̄, s̄, r̄, v, s, τ, G, g)
    end
    return nothing
end
# Group `g`'s trace pullback on one-entry views; a built-in may take the
# gathered values instead.
function _group_trace_back!(
        m, ::Val{B}, R, m̄, v̄, s̄, r̄, v, s, τ, G, g
    ) where {B}
    nv, ns = B
    V, Σ = Val(nv), Val(ns)
    grads = (;
        piece = m̄, trace = _group_views(r̄, Val(ntrace(m, nv)), G, g),
        v = _group_views(R.V̄, V, G, g), s = _group_views(R.S̄, Σ, G, g),
        v′ = _group_views(v̄, V, G, g), s′ = _group_views(s̄, Σ, G, g),
    )
    vg, sg = _group_views(v, V, G, g), _group_views(s, Σ, G, g)
    _written(m, pullback!(grads, m, Trace(), vg, sg, τ, g))
    return nothing
end

# On a device each stratum's, or group's, trace pullback is one index of a
# kernel, on gathered values in local slots, and writes only its own entries
# of the cotangents. Groups that share a parameter add into stacked copies of
# its cotangent, as their step pullbacks do.
function _device_trace_back!(B, R, m, m̄, v̄, s̄, r̄, v, s, τ)
    G = _trace_groups(B, length(v))
    accs = _accumulators(Serial(), v, G, G, _param_slots(m̄, m))
    R̄ = (; V̄ = R.V̄, S̄ = R.S̄)
    _reduce_blocks!(
        _trace_back_blocks!, accs, G, R̄, v̄, s̄, r̄, v, s, τ, m, B, G
    )
    _reduce!(accs)
    return nothing
end
function _trace_back_blocks!(gs, acc, R̄, v̄, s̄, r̄, v, s, τ, m, B, G)
    m̄ = _unown(acc)
    for g in gs
        _slot_trace_back!(m, B, R̄, m̄, v̄, s̄, r̄, v, s, τ, G, g)
    end
    return nothing
end
# A group's trace pullback on one-entry views of local slots, added into the
# group's entries; a built-in may take the gathered values instead.
@inline function _slot_trace_back!(m, B, R̄, m̄, v̄, s̄, r̄, v, s, τ, G, g)
    nv, ns = _trace_shape(B)
    V, Σ = Val(nv), Val(ns)
    z = zero(eltype(v̄))
    at = x -> _At(x, g)
    zeros_of(n) = ntuple(_ -> Ref(z), n)
    a, b, c, d = zeros_of(V), zeros_of(Σ), zeros_of(V), zeros_of(Σ)
    slots(x, n) = _group_slots(Ref, x, n, G, g)
    grads = (;
        piece = m̄, trace = slots(r̄, Val(ntrace(m, nv))),
        v = _slot_args(B, map(at, a)), s = _slot_args(B, map(at, b)),
        v′ = _slot_args(B, map(at, c)), s′ = _slot_args(B, map(at, d)),
    )
    args = (_slot_args(B, slots(v, V)), _slot_args(B, slots(s, Σ)))
    _written(m, @inline _slot_pullback!(B, grads, m, args, τ, g))
    _add_group!(R̄.V̄, a, G, g)
    _add_group!(R̄.S̄, b, G, g)
    _add_group!(v̄, c, G, g)
    _add_group!(s̄, d, G, g)
    return nothing
end
# A blockwise `Depletion` reverses its trace through one-entry views of the
# arrays themselves, as its host loop does: each group writes only its own
# entries, so it needs no local slots. Two pools, two draws on one pool and
# a queue take this path in the device tests.
@inline function _slot_trace_back!(
        m::Depletion, ::Val{B}, R̄, m̄, v̄, s̄, r̄, v, s, τ, G, g
    ) where {B}
    return _group_trace_back!(m, Val(B), R̄, m̄, v̄, s̄, r̄, v, s, τ, G, g)
end
# A pointwise modifier's step takes one view per argument and no group; a
# blockwise one takes a tuple per argument and its group.
_slot_args(::Nothing, x) = only(x)
_slot_args(::Val, x) = x
@inline function _slot_pullback!(::Nothing, grads, m, args, τ, g)
    return @inline pullback!(grads, m, Trace(), args..., τ)
end
@inline function _slot_pullback!(::Val, grads, m, args, τ, g)
    return @inline pullback!(grads, m, Trace(), args..., τ, g)
end
@inline function _add_group!(x, slots, G, g)
    n = Val(length(slots))
    _scatter!(x, map(+, _gather(x, n, G, g), map(getindex, slots)), G, g)
    return nothing
end

_note_missing_duals(w::_WithTrace) = _note_missing_duals(w.op)
