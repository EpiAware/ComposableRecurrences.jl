# A call with its trace: the output of `op` (a `Recurrence` or its
# `_WithState`) and each modifier's trace, built after the run from the
# records the rule keeps.
struct _WithTrace{O <: AbstractOperator} <: AbstractOperator
    op::O
end

# Routed as its operator is.
uses_adjoint(w::_WithTrace, ::Run) = uses_adjoint(w.op, Run())
_type_adjoint(w::_WithTrace) = _type_adjoint(w.op)
_fit(w::_WithTrace, args...) = _fit(w.op, args...)

function _run_forward(w::_WithTrace, gain, add, h, s0, τ0, stop)
    y, cache = _run_forward(w.op, gain, add, h, s0, τ0, stop)
    return (y, _traces(_traced_recurrence(w.op), cache)), cache
end
# The modifiers are read from the operator, as the step reads them, not
# from the cache: plain reverse AD on Julia 1.11 can lose the cotangent of
# a scalar field read back from a value that also holds arrays.
_traced_recurrence(r::Recurrence) = r
_traced_recurrence(w::_WithState) = w.r
_primal(w::_WithTrace, args...) = first(_run_forward(w, args...))
function _prepend_output(w::_WithTrace, h, (y, tr), join = _join)
    return (_prepend_output(w.op, h, y, join), tr)
end

# The call's trace, `(; modifiers)`, one matrix per modifier with a
# column per step: each step's inputs are the modifier's records, its
# outputs the next modifier's inputs (or the buffer's row for the last)
# and its state entering the next step (or its final state).
function _traces(r, c)
    (; H, rec, D, S, T, τ0) = c
    ms = _bind(r.modifiers, H, nothing, D - τ0 + 1)
    return (; modifiers = _traces(ms, rec, c.state.states, H, D, S, T, τ0))
end
_traces(::Tuple{}, ::Tuple{}, ::Tuple{}, H, D, S, T, τ0) = ()
function _traces(ms::Tuple, rec::Tuple, finals::Tuple, H, D, S, T, τ0)
    m, R = first(ms), first(rec)
    out = _zeros(H, eltype(H), ntrace(m, S), T)
    # The last step's state after it is the final state, apart so that each
    # call sees one type.
    rest = Base.tail(rec)
    _stateless(m) || _trace_steps!(out, m, R, rest, first(finals), H, D, T, τ0)
    rest = _traces(Base.tail(ms), Base.tail(rec), Base.tail(finals), H, D, S, T, τ0)
    return (out, rest...)
end
function _trace_steps!(out, m, R, rest, final, H, D, T, τ0)
    for t in 1:(T - 1)
        _trace_at!(out, m, R, rest, _states_at(R.S, t + 1), H, D, t, τ0)
    end
    _trace_at!(out, m, R, rest, final, H, D, T, τ0)
    return nothing
end
function _trace_at!(out, m, R, rest, s′, H, D, t, τ0)
    v, s = view(R.V, :, t), _states_at(R.S, t)
    v′ = _outputs_at(rest, H, D, t)
    _trace!(view(out, :, t), m, v, s, v′, s′, τ0 + t - 1)
    return nothing
end
# A modifier's values after step `t`: the next modifier's inputs, or the
# buffer's row for the last.
_outputs_at(::Tuple{}, H, D, t) = view(H, D + t, :)
_outputs_at(rec::Tuple, H, D, t) = view(first(rec).V, :, t)

# The records with each modifier's trace cotangent `T̄` and, for a
# vector-level step, the buffers for the cotangents its trace sends to the
# step's inputs.
# A modifier's records with its trace cotangent and buffers, as
# `_traced_record` builds them; any other record has no trace cotangent.
const _TracedRecord = NamedTuple{(:V, :S, :A, :T̄, :V̄, :S̄)}
_traced_records(rec, ::Nothing, S) = rec
_traced_records(rec, T̄s::Tuple, S) = map((R, T̄) -> _traced_record(R, T̄, S), rec, T̄s)
_traced_record(R, ::Nothing, S) = R
function _traced_record(R, T̄, S)
    return (; R..., T̄, V̄ = _zeros(R.V, eltype(R.V), S), S̄ = zero(_states_at(R.S, 1)))
end

# One stratum's trace pullback at step `t`, around its step's pullback:
# `_trace_out` adds the trace's share into the cotangents of the step's
# outputs `v̄` and `s̄` and returns its share of the inputs', which
# `_trace_in` adds after the step's pullback. Without a trace cotangent
# both pass their arguments through.
_trace_out(R, m, m̄, v̄, s̄, v, s, τ, t, k) = v̄, s̄, nothing, nothing
function _trace_out(R::_TracedRecord, m, args...)
    return _trace_out(Val(_stateless(m)), R, m, args...)
end
# A modifier whose state never changes has no trace, so no cotangent.
_trace_out(::Val{true}, R, m, m̄, v̄, s̄, v, s, τ, t, k) = v̄, s̄, nothing, nothing
# The trace's pullback runs on one-entry views of stratum `k`: of the
# trace's cotangent series, and of slots the pullback adds the cotangents
# of the step's inputs and outputs into. Inlined, so the slots stay off
# the heap.
@inline function _trace_out(::Val{false}, R, m, m̄, v̄, s̄, v, s, τ, t, k)
    S = length(R.V̄)
    r̄ = _trace_series(view(R.T̄, :, t), Val(ntrace(m, 1)), S)
    z = zero(v̄)
    a, b, c, d = Ref(z), Ref(z), Ref(z), Ref(z)
    at = x -> _At(x, k)
    grads = (; piece = m̄, trace = map(at, r̄), v = at(a), s = at(b), v′ = at(c), s′ = at(d))
    _written(m, @inline pullback!(grads, m, Trace(), at(Ref(v)), at(Ref(s)), τ))
    return v̄ + c[], s̄ + d[], a[], b[]
end
_trace_in(::Nothing, x̄) = x̄
_trace_in(a, x̄) = x̄ + a

# The same for a vector-level step: the trace's share of the inputs' goes
# into the record's buffers, added after the step's pullback.
_trace_out!(R, m, m̄, v̄, s̄, v, s, τ, t) = nothing
function _trace_out!(R::_TracedRecord, m, m̄, v̄, s̄, v, s, τ, t)
    _stateless(m) && return nothing
    _trace_back!(_blocks(m), R, m, m̄, v̄, s̄, view(R.T̄, :, t), v, s, τ)
    return nothing
end
_trace_in!(R, v̄, s̄) = nothing
function _trace_in!(R::_TracedRecord, v̄, s̄)
    v̄ .+= R.V̄
    s̄ .+= R.S̄
    return nothing
end

# A pointwise modifier's trace pullback on the strata's vectors, a
# blockwise one's per group, or another's on the whole step. The
# cotangents of the step's outputs gather into `v̄` and `s̄`, and those of
# its inputs into the record's buffers, added after the step's pullback.
function _trace_back!(::Nothing, R, m, m̄, v̄, s̄, r̄, v, s, τ)
    R.V̄ .= zero(eltype(R.V̄))
    R.S̄ .= zero(eltype(R.S̄))
    r = _pointwise(m) ? _trace_series(r̄, Val(ntrace(m, 1)), length(v)) : r̄
    grads = (; piece = m̄, trace = r, v = R.V̄, s = R.S̄, v′ = v̄, s′ = s̄)
    _written(m, pullback!(grads, m, Trace(), v, s, τ))
    return nothing
end
function _trace_back!(::Val{B}, R, m, m̄, v̄, s̄, r̄, v, s, τ) where {B}
    nv, ns = B
    G = _ngroups(Val(B), length(v))
    R.V̄ .= zero(eltype(R.V̄))
    R.S̄ .= zero(eltype(R.S̄))
    for g in 1:G
        _group_trace_back!(m, Val(B), R, m̄, v̄, s̄, r̄, v, s, τ, G, g)
    end
    return nothing
end
# Group `g`'s trace pullback, adding into the cotangents of the step's
# outputs and the record's buffers: the modifier's `pullback!` on one-entry
# views, or a built-in's on the gathered values.
function _group_trace_back!(m, ::Val{B}, R, m̄, v̄, s̄, r̄, v, s, τ, G, g) where {B}
    nv, ns = B
    grads = (;
        piece = m̄, trace = _group_views(r̄, Val(ntrace(m, nv)), G, g),
        v = _group_views(R.V̄, Val(nv), G, g), s = _group_views(R.S̄, Val(ns), G, g),
        v′ = _group_views(v̄, Val(nv), G, g), s′ = _group_views(s̄, Val(ns), G, g),
    )
    vg, sg = _group_views(v, Val(nv), G, g), _group_views(s, Val(ns), G, g)
    _written(m, pullback!(grads, m, Trace(), vg, sg, τ, g))
    return nothing
end
