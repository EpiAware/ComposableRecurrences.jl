# A call with its trace: the output of `op` (a `Recurrence` or its
# `_WithState`) and each modifier's trace, built after the run from the
# records the rule keeps, or in each step of a run without records.

# == _WithTrace ==

struct _WithTrace{O <: AbstractOperator} <: AbstractOperator
    op::O
end

# Routed as its operator is.
uses_adjoint(w::_WithTrace, ::Run) = uses_adjoint(w.op, Run())
_type_adjoint(w::_WithTrace) = _type_adjoint(w.op)
_fit(w::_WithTrace, args...) = _fit(w.op, args...)

function _run_forward(w::_WithTrace, gain, add, h, s0, τ0, stop)
    y, cache = _run_forward(w.op, gain, add, h, s0, τ0, stop, Val(:traced))
    return (y, _traces(_traced_recurrence(w.op), cache)), cache
end
# The modifiers are read from the operator, not the cache: plain reverse AD
# on Julia 1.11 can lose a scalar field's cotangent read back from the cache.
_traced_recurrence(r::Recurrence) = r
_traced_recurrence(w::_WithState) = w.r
# On host arrays a call writes each modifier's trace in its step
# (`_TraceSink`); elsewhere it runs the traced rule's forward pass.
_primal(w::_WithTrace, args...) = first(_run_forward(w, args...))
function _primal(w::_WithTrace, gain, add, h::_CPUArray, s0, τ0, stop)
    return _traced_primal(w.op, gain, add, h, s0, τ0, stop)
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
        out = similar(h, Tp, n, T)
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
    col = view(R.out, :, t)
    fill!(col, zero(eltype(col)))
    _trace!(col, m, R.v, R.s, v, s, τ)
    return nothing
end

# == Traces from the records ==

# The call's trace, `(; modifiers, pressure)`: one matrix per modifier with
# a column per step, and each step's pressure. A step's outputs are the next
# modifier's inputs, or the buffer's row for the last.
function _traces(r, c)
    (; H, rec, D, S, T, τ0) = c
    ms = _bind(r.modifiers, H, nothing, D - τ0 + 1)
    modifiers = _traces(ms, rec, c.states, H, D, S, T, τ0)
    pressure = _output_layout(_pressures(r.coupling, c.pr), c.h)
    return (; modifiers, pressure)
end
_traces(::Tuple{}, ::Tuple{}, ::Tuple{}, H, D, S, T, τ0) = ()
function _traces(ms::Tuple, rec::Tuple, finals::Tuple, H, D, S, T, τ0)
    m, R = first(ms), first(rec)
    out = _zeros(H, eltype(H), ntrace(m, S), T)
    rest = Base.tail(rec)
    if !isstateless(m)
        for t in 1:(T - 1)
            _trace_at!(out, m, R, rest, _states_at(R.S, t + 1), H, D, t, τ0)
        end
        # The final state on its own, so each call sees one type.
        _trace_at!(out, m, R, rest, first(finals), H, D, T, τ0)
    end
    others = _traces(
        Base.tail(ms), rest, Base.tail(finals), H, D, S, T, τ0
    )
    return (out, others...)
end
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

# One stratum's trace pullback at step `t`: `_trace_out` adds the trace's
# share into the step's output cotangents `v̄` and `s̄` and returns its share
# of the inputs', which `_trace_in` adds after the step's pullback.
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
    @inbounds for k in 1:n
        s̄[k] += T̄[o + k]
    end
    return nothing
end

# A trace's pullback on the whole step, or per group for a blockwise
# modifier: the outputs' cotangents gather into `v̄` and `s̄`, the inputs'
# into the record's buffers.
function _trace_back!(::Nothing, R, m, m̄, v̄, s̄, r̄, v, s, τ)
    R.V̄ .= zero(eltype(R.V̄))
    R.S̄ .= zero(eltype(R.S̄))
    r = _strata_loop(m) ? _trace_series(r̄, Val(ntrace(m, 1)), length(v)) : r̄
    grads = (; piece = m̄, trace = r, v = R.V̄, s = R.S̄, v′ = v̄, s′ = s̄)
    _written(m, pullback!(grads, m, Trace(), v, s, τ))
    return nothing
end
function _trace_back!(::Val{B}, R, m, m̄, v̄, s̄, r̄, v, s, τ) where {B}
    G = _ngroups(Val(B), length(v))
    R.V̄ .= zero(eltype(R.V̄))
    R.S̄ .= zero(eltype(R.S̄))
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
