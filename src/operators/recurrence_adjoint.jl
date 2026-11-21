# The rule of a `Recurrence`. Each step's core `v = gain ⊙ x + add` has a
# local pullback; the work is sending the pressure's cotangent back through
# the coupling and kernel into the buffer's cotangent `H̄`.

# `grads` is `(; piece, y, args)`, with `args` mirroring
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
# A zero trace cotangent adds nothing, so the steps skip the traces' and the
# pressure's pullbacks; when both are zero the cache passes on unchanged, as
# rebuilding it costs a runtime `merge` under some AD backends.
function pullback!(grads, w::_WithTrace, ::Run, c)
    ȳ, tr̄ = grads.y
    T̄s = cotangent(tr̄, :modifiers)
    Q̄ = cotangent(tr̄, :pressure)
    inner = (; piece = cotangent(grads.piece, :op), y = ȳ, args = grads.args)
    _zero_trace(T̄s) && _zero_trace(Q̄) && return pullback!(inner, w.op, Run(), c)
    rec = _zero_trace(T̄s) ? c.rec : _traced_records(c.rec, T̄s, c.S)
    pr = _zero_trace(Q̄) ? c.pr : merge(c.pr, (; Q̄ = _strata_rows(Q̄)))
    return pullback!(inner, w.op, Run(), _with_fields(c, (; rec, pr)))
end
# `merge(c, x)` for a named tuple `x` whose names are all in `c`, with the
# names and order of `c`, so its type is inferred from the argument types.
@generated function _with_fields(
        c::NamedTuple{N}, x::NamedTuple{M}
    ) where {N, M}
    @assert issubset(M, N)
    vals = map(N) do n
        src = n in M ? :x : :c
        :(getfield($src, $(QuoteNode(n))))
    end
    return :(NamedTuple{$N}(($(vals...),)))
end
# The pressure's cotangent as strata × steps, a row for one series.
_strata_rows(Q̄::AbstractVector) = reshape(Q̄, 1, length(Q̄))
_strata_rows(Q̄::AbstractMatrix) = Q̄
_zero_trace(::Nothing) = true
_zero_trace(T̄s::Tuple) = all(_zero_trace, T̄s)
_zero_trace(T̄::AbstractArray) = iszero(T̄)

# The default executor is passed as the singleton `Serial()`, so the loops
# hold no abstractly typed executor. Parameters that read across strata share
# one window cache per step, so their reverse pass runs serially.
function _reverse!(c, Ȳ, r̄, ḡain, ādd, h̄, s̄0, st̄)
    return _reverse_computed!(_computed(c), c, Ȳ, r̄, ḡain, ādd, h̄, s̄0, st̄)
end
function _reverse_run!(c, Ȳ, r̄, ḡain, ādd, h̄, s̄0, st̄)
    _count_pullback()
    (; r, H, D, S, T, τ0) = c
    H̄ = _seeded(c, H, Ȳ, D)
    # Parameters that read the outputs send their cotangents into `H̄`. The
    # bound modifiers enter the step loop through a function barrier.
    modifiers = _bind(r.modifiers, H, H̄, D - τ0 + 1)
    if _reads_across(modifiers)
        _reverse!(Serial(), c, modifiers, H̄, Ȳ, r̄, ḡain, ādd, h̄, s̄0, st̄)
    else
        _with_executor(_reverse!, c, modifiers, H̄, Ȳ, r̄, ḡain, ādd, h̄, s̄0, st̄)
    end
    return nothing
end

function _reverse!(ex, c, modifiers, H̄, Ȳ, r̄, ḡain, ādd, h̄, s̄0, st̄)
    (; r, kernel, gain, h, s0, τ0, L, D, S, T, H, pr, rec, init) = c
    coupling = r.coupling
    h̄end = cotangent(st̄, :history)
    h̄end === nothing || _seed_rows!(H̄, h̄end, T)
    ḡ = cotangent(r̄, :kernel)
    C̄ = cotangent(r̄, :coupling)
    m̄s = _mirrors(cotangent(r̄, :modifiers), modifiers)
    _on_gpu(H) && _keep_mirrors!(modifiers, m̄s)
    # `eltype(H)`, not a type bound to a local: a closure that captures a
    # type as a value does not infer it on Julia 1.11.
    s̄s = map(m -> _zeros(H, eltype(H), nstate(m, S)), modifiers)
    _seed_states!(s̄s, cotangent(st̄, :states))
    kbuf = _kernel_buffer(ḡ, kernel, H, S, L)
    # Matrix gain and add inputs have a slot per stratum and step, a fixed
    # kernel's goes through `kbuf`, and steps on the calling task
    # (`_steps_back!`) are not copied.
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
        m̄v = _all_pointwise(modifiers) ? _step_slots(m̄s, modifiers, H) :
            _Owned(m̄s)
        C̄s = _coupling_slots(C̄, coupling)
        acc = (; ādd, ḡain, C̄ = C̄s, ḡ = kslots, m̄s = m̄v)
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
# Takes the rule on device arrays (`_device_gate`): a fixed or dense
# time-varying kernel, a pointwise or on-device dense coupling and
# built-in modifiers whose steps run per stratum or per group.
function _device_ready(r::Recurrence{<:_DeviceKernel})
    return _device_coupling(r.coupling) && _device_modifiers(r.modifiers)
end
# A pairwise kernel reverses one sender per kernel index
# (`_device_pairwise_back!`).
function _device_ready(r::Recurrence{<:Union{Pairwise, TimeVarying{<:Any, <:Pairwise}}})
    return _device_coupling(r.coupling) && _device_modifiers(r.modifiers)
end
_device_coupling(C) = false
_device_coupling(::Union{UniformScaling, Diagonal}) = true
_device_coupling(C::AbstractMatrix) = _on_gpu(C)
# A coupling over time: see `_device_tv_coupling_back!`.
_device_coupling(C::_TVCoupling) = _on_gpu(C.x)
_device_modifiers(::Tuple{}) = true
function _device_modifiers(ms::Tuple)
    return _device_modifier(first(ms)) && _device_modifiers(Base.tail(ms))
end
# A user modifier takes the rule when it runs per stratum or on fixed groups
# with scalar parameters; an `Init` of its own reverses on host copies (see
# `_init_strata_back!` in the GPUArraysCore extension).
_device_modifier(m) = (_strata_loop(m) || _blocks(m) isa Val) && _scalar_params(m)
_device_modifier(m::Transform) = _strata_loop(m)
# Built-in group steps reverse in blocks, as their forward steps run.
_device_modifier(m::Union{Depletion, Allocate{<:Any, Nothing}}) = true
# With imports its groups reverse in blocks too; its pattern and spill
# reverse as a coupling and a `Redistribute` do.
function _device_modifier(m::Allocate{<:Any, <:_AllocateImports})
    (; pattern, spill) = m.imports
    return _device_coupling(pattern) && _device_spill(spill)
end
_device_spill(::Nothing) = true
_device_spill(r::Redistribute) = _device_modifier(r)
# A whole step on the calling task, whose loops run as kernels. Each origin
# or stratum writes only its own entries of the moves' cotangent, so the
# step reverses without per-block copies; an intensity read from a
# parameter stacks only the cotangents origins share. The kernels index
# every entry, which a dense array holds, as does a reshape or view of one,
# such as of a parameter vector as AD passes it; a `Diagonal`, triangular or
# sparse matrix does not, so any other matrix keeps plain AD.
const _DeviceMovement = TimeVarying{Secondary, <:_Movement}
_device_modifier(m::Redistribute{<:Any, <:AbstractMatrix}) = _dense_moves(m.M)
function _device_modifier(m::Redistribute{<:Any, <:_DeviceMovement})
    return _dense_moves(m.M.x.K) && _device_intensity(m.M.x.E)
end
# An intensity that is not a matrix is a parameter, read through `param` and
# reversed through `add_param!`, such as a `PerStratum`, a `TimeVarying`, a
# `Derived` or a `Recent`. `_param_slots` stacks every cotangent leaf of one
# it does not know to be written per origin, so any parameter is safe.
_device_intensity(E) = true
_device_intensity(E::AbstractMatrix) = _dense_moves(E)
_dense_moves(M) = false
_dense_moves(::DenseArray) = true
_dense_moves(M::Union{Base.ReshapedArray, SubArray}) = _dense_moves(parent(M))

_kernel_slots(ḡ, kernel) = _Owned(ḡ)
_kernel_slots(ḡ, kernel::TimeVarying) = ḡ
_kernel_slots(ḡ, kernel::TimeVarying{<:Any, <:Pairwise}) = _Owned(ḡ)
# Each stratum writes only its own rows of a per-stratum kernel's cotangent,
# so blocks share it rather than each holding a copy of every stratum's.
_kernel_slots(ḡ, kernel::TimeVarying{<:Any, <:PerStratum}) = _Owned(ḡ)
# The pairwise kernels as the reverse pass reads them, fixed ones oldest first.
const _ReversedPairwise = Union{_OldestFirstPairwise, TimeVarying{<:Any, <:Pairwise}}
# A mirror as the calling task writes it.
_own(x̄) = x̄
_own(x̄::_Owned) = x̄.x
# On the host it runs on the calling task, as tasks spawned every step cost
# more than the loop; on device arrays it is one kernel.
_step_accs(accs) = (first(accs), ())
_step_accs(accs::Tuple{Any, _Stacked}) = accs
# A scale every stratum shares is copied once per block for the whole pass;
# a `Diagonal`'s entries are each written by one stratum, and other
# couplings reverse on the calling task.
_coupling_slots(C̄, C) = _Owned(C̄)
_coupling_slots(C̄, C::UniformScaling) = C̄
# A `PerStratum` parameter is written at one stratum or group per entry, so
# blocks share it; any other leaf is copied per block.
_param_slots(m̄, x) = _param_leaves(m̄, x)
_param_slots(m̄, ::Union{PerStratum, TimeVarying{<:Any, <:PerStratum}}) =
    _own_leaf(m̄)
_own_leaf(::Nothing) = nothing
_own_leaf(m̄) = _Owned(m̄)
# Unrolled field by field: a loop, recursion or `map` widens the field types,
# and `map` over more than 32 allocates. A mirror not shaped like its object,
# such as a bound wrapper's, keeps its leaves shared.
_param_leaves(m̄, x) = m̄
@generated function _param_leaves(m̄::Tuple, x::Tuple)
    n = fieldcount(m̄)
    n == fieldcount(x) || return :m̄
    leaves = [:(_param_slots(getfield(m̄, $i), getfield(x, $i))) for i in 1:n]
    return :(($(leaves...),))
end
@generated function _param_leaves(m̄::NamedTuple{K}, x) where {K}
    leaves = map(K) do k
        name = QuoteNode(k)
        hasfield(x, k) || return :(getfield(m̄, $name))
        :(_param_slots(getfield(m̄, $name), getfield(x, $name)))
    end
    return :(NamedTuple{$K}(($(leaves...),)))
end
# A coupled `Recent`'s mirror: each stratum adds to its own row of the
# coupling's cotangent, and the weights' cotangent is added once per step at
# the flush, so neither is copied per block. An uncoupled read adds its
# weights' cotangent from every stratum, so it is shared.
_param_slots(m̄, b::_BoundRecent) = _recent_slots(m̄, b.x.coupling)
_recent_slots(m̄, ::Nothing) = m̄
_recent_slots(m̄, C) = _owned_leaves(m̄)
_owned_leaves(::Nothing) = nothing
function _owned_leaves(m̄::NamedTuple{K}) where {K}
    return NamedTuple{K}(map(_own_leaf, values(m̄)))
end
# The pointwise modifiers' mirrors as a step's blocks write them: on a
# device each block's copy holds only the cotangents strata share, so a
# per-stratum parameter's and a coupled read's are shared; the host keeps
# its copies whole.
_step_slots(m̄s, ms, H) = _on_gpu(H) ? _param_slots(m̄s, ms) : m̄s

# The mirror itself, from slots `_param_slots` made.
_unown(x) = x
_unown(x::_Owned) = x.x
@generated function _unown(x::Tuple)
    return :(($((:(_unown(getfield(x, $i))) for i in 1:fieldcount(x))...),))
end
@generated function _unown(x::NamedTuple{K}) where {K}
    leaves = (:(_unown(getfield(x, $i))) for i in 1:length(K))
    return :(NamedTuple{$K}(($(leaves...),)))
end

# Each stratum's step writes only its own slots and the block's accumulator.
function _series_back!(
        ks, acc, H̄, kbuf, s̄s, rec, pr, gain, coupling, kernel, ms, H, τ0, L, D, T
    )
    for (ts, g, j) in Iterators.reverse(_kernel_runs(kernel, τ0, T))
        kb = _run_buffer(kbuf, kernel, j)
        c = _chain(g, ms, eltype(H))
        if c isa _Chained && size(H, 2) == 1
            _carried_back!(
                c, _run_steps(ts, T), first(ks), acc, kb, pr, gain, coupling, H,
                H̄, τ0, L, D
            )
            continue
        end
        if size(H, 2) == 1 && _carries(g, H)
            _carried_back!(
                g, _run_steps(ts, T), first(ks), acc, kb, s̄s, rec, pr, gain,
                coupling, ms, H, H̄, τ0, L, D
            )
            continue
        end
        for t in reverse(_run_steps(ts, T))
            τ = τ0 + t - 1
            for k in ks
                v̄k = _thread_back(
                    ms, acc.m̄s, rec, s̄s, @inbounds(H̄[D + t, k]), τ, t, k
                )
                p̄k = _core_back!(acc, v̄k, pr, gain, coupling, t, τ, k)
                _kernel_back_at!(kb, acc.ḡ, g, p̄k, H, H̄, t + D - L, τ, L, k)
            end
        end
    end
    return nothing
end

# The carried cotangent avoids adding into `H̄` and reading it back; it is the
# step's times the gain, coefficient and newest weight together, so each step
# waits on one fused multiply-add.
function _carried_back!(
        c, steps, k, acc, kb, pr, gain, coupling, H, H̄, τ0, L, D
    )
    carry = zero(eltype(H̄))
    w = _stratum_weights(c.g, k)
    newest = L >= 1 ? @inbounds(w[L]) : zero(eltype(w))
    kw = _stratum_buffer(kb, c.g, k)
    for t in reverse(steps)
        carry = _chained_back!(
            w, newest, kw, acc, pr, gain, coupling, H, H̄, carry, t,
            τ0 + t - 1, L, D, k
        )
    end
    row = D + first(steps) - 1
    row >= 1 && @inbounds(H̄[row, k] += carry)
    return nothing
end
@inline function _chained_back!(
        w, newest, kw, acc, pr, gain, C, H, H̄, carry, t, τ, L, D, k
    )
    h̄ = @inbounds H̄[D + t, k]
    p̄ = _core_back!(acc, h̄ + carry, pr, gain, C, t, τ, k)
    L >= 1 || return zero(carry)
    _older_back!(kw, w, p̄, H, H̄, t + D - L - 1, L, k)
    β = @inbounds _at(gain, k, τ) * _coef(C, k) * newest
    return muladd(β, carry, β * h̄)
end
# A one-stratum run through pointwise modifiers carries its cotangent too:
# each step sends its last value its pressure's times the newest weight.
function _carried_back!(
        g, steps, k, acc, kb, s̄s, rec, pr, gain, coupling, ms, H, H̄, τ0, L, D
    )
    w = _stratum_weights(g, k)
    b = _stratum_buffer(kb, g, k)
    carry = zero(eltype(H̄))
    for t in reverse(steps)
        τ = τ0 + t - 1
        v̄k = _thread_back(
            ms, acc.m̄s, rec, s̄s, @inbounds(H̄[D + t, k]) + carry, τ, t, k
        )
        p̄ = _core_back!(acc, v̄k, pr, gain, coupling, t, τ, k)
        L >= 1 || (carry = zero(carry); continue)
        _older_back!(b, w, p̄, H, H̄, t + D - L - 1, L, k)
        carry = p̄ * @inbounds(w[L])
    end
    row = D + first(steps) - 1
    row >= 1 && @inbounds(H̄[row, k] += carry)
    return nothing
end
_stratum_buffer(kb::AbstractMatrix, ::AbstractVector, k) = view(kb, :, k)
_stratum_buffer(kb::AbstractMatrix, ::PerStratum, k) = view(kb, k, :)
_stratum_buffer(::Nothing, g, k) = nothing

# Stratum `k`'s output cotangent at step `t` back through the pointwise
# modifiers, then `_gain_add_back!`.
@inline function _value_back!(acc, s̄s, rec, pr, gain, C, ms, H̄, t, τ, D, k)
    m̄s = _unown(acc.m̄s)
    v̄k = _thread_back(ms, m̄s, rec, s̄s, @inbounds(H̄[D + t, k]), τ, t, k)
    return _gain_add_back!(acc, v̄k, pr, gain, C, t, τ, k)
end

# The mirrors have their inputs' shapes and the records the call's, so the
# slots skip bounds checks.
@inline function _gain_add_back!(acc, v̄k, pr, gain, C, t, τ, k)
    @inbounds _add_slot!(acc.ādd, v̄k, k, τ)
    @inbounds _add_slot!(acc.ḡain, v̄k * _pressure(C, pr, k, t), k, τ)
    return @inbounds _at(gain, k, τ) * v̄k + _traced_pressure(pr, k, t)
end
# The pressure records with the cotangent `Q̄` of the trace's pressure,
# which joins each step's pressure cotangent.
const _TracedPressure = NamedTuple{(:P, :X, :Q̄)}
_traced_pressure(pr, k, t) = false
_traced_pressure(pr::_TracedPressure, k, t) = @inbounds pr.Q̄[k, t]

# Without records the gain has no cotangent.
@inline function _gain_add_back!(acc, v̄k, ::Nothing, gain, C::_PointwiseCoupling, t, τ, k)
    @inbounds _add_slot!(acc.ādd, v̄k, k, τ)
    return @inbounds _at(gain, k, τ) * v̄k
end

# As in the forward step, the coefficient joins the gain, so the cotangent
# passed back waits on one product.
@inline function _core_back!(acc, v̄k, pr, gain, C::_PointwiseCoupling, t, τ, k)
    Pk = @inbounds pr.P[k, t]
    gk = @inbounds _at(gain, k, τ)
    @inbounds _add_slot!(acc.ādd, v̄k, k, τ)
    @inbounds _add_slot!(acc.ḡain, v̄k * (_coef(C, k) * Pk), k, τ)
    _coef_back!(acc.C̄, C, gk * v̄k * Pk, k)
    return (gk * _coef(C, k)) * v̄k
end
# Without records the gain and the coefficient carry no cotangent.
@inline function _core_back!(acc, v̄k, ::Nothing, gain, C::_PointwiseCoupling, t, τ, k)
    @inbounds _add_slot!(acc.ādd, v̄k, k, τ)
    return (@inbounds(_at(gain, k, τ)) * _coef(C, k)) * v̄k
end
@inline function _core_back!(
        acc, v̄k, pr::_TracedPressure, gain, C::_PointwiseCoupling, t, τ, k
    )
    Pk = @inbounds pr.P[k, t]
    @inbounds _add_slot!(acc.ādd, v̄k, k, τ)
    @inbounds _add_slot!(acc.ḡain, v̄k * (_coef(C, k) * Pk), k, τ)
    q̄k = @inbounds _at(gain, k, τ) * v̄k + pr.Q̄[k, t]
    _coef_back!(acc.C̄, C, q̄k * Pk, k)
    return _coef(C, k) * q̄k
end
_coef_back!(C̄, C::UniformScaling, v, k) = add_cotangent!(cotangent(C̄, :λ), v)
_coef_back!(C̄, C::Diagonal, v, k) = @inbounds add_cotangent!(cotangent(C̄, :diag), v, k)

# Each stratum writes only its own slots for the pointwise modifiers, and for
# the kernel unless it is pairwise, so those loops run in executor blocks.
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
                copyto!(v̄, view(H̄, D + t, :))
                _stages_back!(ms, _own(acc.m̄s), rec, s̄s, bufs, v̄, τ, t)
                _reduce_blocks!(
                    _gain_adds_back!, _step_accs(accs), S,
                    q̄, v̄, pr, gain, coupling, t, τ
                )
            end
            _step_coupling_back!(accs, p̄, coupling, q̄, pr, t, τ, pbufs)
            _kernels_back!(accs, kb, g, p̄, H, H̄, t + D - L, τ, L)
            _flush!(ms)
        end
    end
    return nothing
end

function _gain_adds_back!(ks, acc, q̄, v̄, pr, gain, C, t, τ)
    for k in ks
        q̄[k] = _gain_add_back!(acc, @inbounds(v̄[k]), pr, gain, C, t, τ, k)
    end
    return nothing
end

function _values_back!(ks, acc, q̄, s̄s, rec, pr, gain, C, ms, H̄, t, τ, D)
    for k in ks
        q̄[k] = _value_back!(acc, s̄s, rec, pr, gain, C, ms, H̄, t, τ, D, k)
    end
    return nothing
end

# Pairwise kernels and routes read every stratum's window, so run on one block.
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

# Only an integer output has no cotangent, and then nothing else does. A
# method, not an early return: where `Ȳ` may be `nothing` by type (`Enzyme`
# under runtime activity), that branch slowed the reverse pass by about 8%.
_seeded(H, ::Nothing, D) = _zeros(H, eltype(H), size(H)...)
# A cotangent `Ȳ` that `_shared_shadow` gave the rule already sits in the
# buffer's cotangent, below zero rows.
function _seeded(c::NamedTuple{N}, H, Ȳ, D) where {N}
    :ȳ in N && Ȳ === c.ȳ && return c.H̄
    return _seeded(H, Ȳ, D)
end
function _seeded(H, Ȳ, D)
    H̄ = similar(H)
    fill!(view(H̄, 1:D, :), zero(eltype(H̄)))
    return _set_rows!(H̄, Ȳ, D)
end
_set_rows!(H̄, x̄::AbstractVector, o) = (view(H̄, (o + 1):size(H̄, 1), 1) .= x̄; H̄)
function _set_rows!(H̄, x̄::AbstractMatrix, o)
    view(H̄, (o + 1):size(H̄, 1), :) .= transpose(x̄)
    return H̄
end
# A CPU buffer is written down its columns: the broadcast above is a plain
# copy, which `Base` hands to the slower blocked transpose. The loop skips
# bounds checks, so it checks the shapes the broadcast would have.
function _set_rows!(H̄::Matrix, x̄::Matrix, o)
    size(H̄) == (o + size(x̄, 2), size(x̄, 1)) || throw(
        DimensionMismatch(
            "cotangent $(size(x̄)) against buffer $(size(H̄)) after row $o"
        )
    )
    @inbounds for k in axes(x̄, 1), j in axes(x̄, 2)
        H̄[o + j, k] = x̄[k, j]
    end
    return H̄
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
_add_slot!(x̄::_Slot, v, k, t) = (x̄[] += v; nothing)
Base.@propagate_inbounds _add_slot!(x̄::AbstractVector, v, k, t) = (x̄[t] += v; nothing)
Base.@propagate_inbounds _add_slot!(x̄::AbstractMatrix, v, k, t) = (x̄[k, t] += v; nothing)
Base.@propagate_inbounds _add_slot!(x̄::_Owned, v, k, t) = _add_slot!(x̄.x, v, k, t)

_thread_back(::Tuple{}, m̄s, rec, s̄s, v̄, τ, t, k) = v̄
function _thread_back(ms::Tuple, m̄s, rec, s̄s, v̄, τ, t, k)
    v̄ = _thread_back(
        Base.tail(ms), Base.tail(m̄s), Base.tail(rec), Base.tail(s̄s), v̄, τ, t, k
    )
    R, s̄ = first(rec), first(s̄s)
    m, m̄, vk, sk = first(ms), first(m̄s), R.V[k, t], _state_at(R.S, k, t)
    v̄, s̄k, a, b = _trace_out(R, m, m̄, v̄, s̄[k], vk, sk, τ, t, k)
    v̄, s̄k = _step_pullback((; piece = m̄, v = v̄, s = s̄k), m, vk, sk, τ, k)
    s̄[k] = _trace_in(b, s̄k)
    return _trace_in(a, v̄)
end

# `grads.after` and `grads.pass` go to a modifier that asks (`_pass_buffer`).
_stages_back!(::Tuple{}, m̄s, rec, s̄s, bufs, v̄, τ, t) = nothing
function _stages_back!(ms::Tuple, m̄s, rec, s̄s, bufs, v̄, τ, t)
    _stages_back!(
        Base.tail(ms), Base.tail(m̄s), Base.tail(rec), Base.tail(s̄s),
        Base.tail(bufs), v̄, τ, t
    )
    R, m, m̄, s̄ = first(rec), first(ms), first(m̄s), first(s̄s)
    v, s = view(R.V, :, t), _states_at(R.S, t)
    _trace_out!(R, m, m̄, v̄, s̄, v, s, τ, t)
    _vector_pullback!(_step_grads(m̄, v̄, s̄, R.A, first(bufs), t), m, v, s, τ)
    _trace_in!(R, m, v̄, s̄)
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

# `grads` carries `after` (`_keeps_after`) and `pass` only when a modifier
# asks; without them its per-step pullback must give the same cotangents. A
# blockwise modifier split into groups gets neither, so needs its own.
_pass_buffer(H, ::Type, m, m̄, S, T) = _local_step_duals(Val(_whole_local(m)), m̄, m, H, S)
_local_step_duals(::Val{false}, m̄, m, H, S) = nothing
_local_step_duals(::Val{true}, m̄, m, H, S) = _step_duals(m̄, m, eltype(H), S)
_finish_pass!(m̄, m, R, ::Nothing, τ0) = nothing

# The coupling's pullback at step `t`: overwrite `p̄` with the cotangent of
# the kernel convolutions and add the coupling's own cotangent into `C̄`.
function _coupling_back!(p̄, C̄, C::_PointwiseCoupling, q̄, pr, t, τ, pbufs)
    _couplings_back!(eachindex(p̄), C̄, p̄, C, q̄, pr, t)
    return p̄
end
function _couplings_back!(ks, C̄, p̄, C, q̄, pr, t)
    for k in ks
        @inbounds p̄[k] = _coupling_back_at(C̄, C, q̄[k], pr, t, k)
    end
    return nothing
end
# The same within a reverse pass: a pointwise coupling runs per stratum in
# the pass's blocks (`accs`), one kernel on device arrays.
function _step_coupling_back!(
        accs, p̄, C::_PointwiseCoupling, q̄, pr, t, τ, pbufs
    )
    n = length(p̄)
    blocks = _step_accs(accs)
    _reduce_blocks!(_step_couplings_back!, blocks, n, p̄, C, q̄, pr, t)
    return p̄
end
function _step_coupling_back!(accs, p̄, C, q̄, pr, t, τ, pbufs)
    C̄ = _own(first(accs).C̄)
    return _coupling_back!(p̄, C̄, C, q̄, pr, t, τ, pbufs)
end
function _step_couplings_back!(ks, acc, p̄, C, q̄, pr, t)
    return _couplings_back!(ks, _own(acc.C̄), p̄, C, q̄, pr, t)
end
function _coupling_back!(p̄, C̄, C, q̄, pr, t, τ, pbufs)
    fill!(p̄, zero(eltype(p̄)))
    _pressure_back!(p̄, C̄, C, q̄, view(pr.P, :, t), τ, pbufs)
    return p̄
end

function _coupling_back_at(C̄, C::UniformScaling, q̄k, pr, t, k)
    add_cotangent!(cotangent(C̄, :λ), q̄k * @inbounds(pr.P[k, t]))
    return C.λ * q̄k
end
_coupling_back_at(C̄, C::UniformScaling, q̄k, ::Nothing, t, k) = C.λ * q̄k
_coupling_back_at(C̄, C::Diagonal, q̄k, ::Nothing, t, k) = @inbounds C.diag[k] * q̄k
function _coupling_back_at(C̄, C::Diagonal, q̄k, pr, t, k)
    @inbounds add_cotangent!(cotangent(C̄, :diag), q̄k * pr.P[k, t], k)
    return @inbounds C.diag[k] * q̄k
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

# A pairwise kernel's strata read every stratum's window, so it runs over all.
@inline function _kernel_back_at!(kbuf, ḡ, g::AbstractVector, a, H, H̄, t, τ, L, k)
    kb = kbuf === nothing ? nothing : view(kbuf, :, k)
    _window_back!(kb, g, a, H, H̄, t, L, k)
    return nothing
end
@inline function _kernel_back_at!(kbuf, ḡ, g::PerStratum, a, H, H̄, t, τ, L, k)
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
# One stratum per kernel index; a fixed kernel's stratum writes only its own
# column of the buffer, of `H̄` and of `kbuf`.
function _device_kernel_back!(kbuf, ḡ, g, p̄, H, H̄, t, τ, L)
    S = length(p̄)
    _each!(
        _route_kernel_back!, Serial(), p̄, S, typemax(Int),
        kbuf, ḡ, g, p̄, H, H̄, t, τ, L
    )
    return nothing
end
function _route_kernel_back!(k, kbuf, ḡ, g, p̄, H, H̄, t, τ, L)
    @inbounds _kernel_back_at!(kbuf, ḡ, g, p̄[k], H, H̄, t, τ, L, k)
    return nothing
end
function _kernel_back!(kbuf, ḡ, g::_OldestFirstPairwise, p̄, H, H̄, t, τ, L)
    for a in eachindex(p̄), b in axes(H, 2)
        kb = kbuf === nothing ? nothing : view(kbuf, :, b, a)
        _window_back!(kb, view(g.x, :, b, a), p̄[a], H, H̄, t, L, b)
    end
    return nothing
end
# One sender per kernel index: each writes only its own `H̄` column and
# kernel pairs, so the strata add in host order.
function _device_pairwise_back!(kbuf, ḡ, g, p̄, H, H̄, t, τ, L)
    _each!(
        _pairwise_sender_back!, Serial(), p̄, size(H, 2), typemax(Int),
        kbuf, ḡ, g, p̄, H, H̄, t, τ, L
    )
    return nothing
end
function _pairwise_sender_back!(
        b, kbuf, ḡ, g::_OldestFirstPairwise, p̄, H, H̄, t, τ, L
    )
    for a in eachindex(p̄)
        kb = kbuf === nothing ? nothing : view(kbuf, :, b, a)
        @inbounds _window_back!(kb, view(g.x, :, b, a), p̄[a], H, H̄, t, L, b)
    end
    return nothing
end
function _pairwise_sender_back!(
        b, kbuf, ḡ, g::TimeVarying{<:Any, <:Pairwise}, p̄, H, H̄, t, τ, L
    )
    for a in eachindex(p̄)
        @inbounds _tv_back!(ḡ, g, p̄[a], H, H̄, t, τ, L, a, b:b)
    end
    return nothing
end
# The arrays are distinct, so the updates are independent (`ivdep`). The
# newest lag's row is the next step's cotangent, so it is updated first, as
# the forward pass adds it last.
@inline function _window_back!(kbuf, g, a, H, H̄, t, L, k)
    L >= 1 || return nothing
    @inbounds H̄[t + L - 1, k] = muladd(a, g[L], H̄[t + L - 1, k])
    _older_back!(kbuf, g, a, H, H̄, t - 1, L, k)
    return nothing
end
# The rest of `_window_back!` for the window after row `o`: the kernel's
# cotangent, and the older lags' rows of `H̄`.
@inline function _older_back!(kbuf, g, a, H, H̄, o, L, k)
    @inbounds kbuf[L] = muladd(a, H[o + L, k], kbuf[L])
    _span_back!(kbuf, g, a, H, H̄, o + 1, 1, L - 1, k)
    return nothing
end
@inline function _older_back!(::Nothing, g, a, H, H̄, o, L, k)
    _span_back!(nothing, g, a, H, H̄, o + 1, 1, L - 1, k)
    return nothing
end
# Lag `i` reads column `τ`, or `τ - i` for a `Primary()` kernel, whose lags
# before time 1 have no column. Lag runs innermost, so each sender's window is
# read in order.
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
# Host arrays add in loops, which allocate nothing, whatever their wrapper;
# device arrays add in one array operation each, which runs where they live.
function _kernel_finish!(ḡ::AbstractVector, kbuf::AbstractMatrix)
    L = size(kbuf, 1)
    _on_gpu(kbuf) &&
        return (ḡ .+= vec(sum(view(kbuf, L:-1:1, :); dims = 2)); nothing)
    for k in axes(kbuf, 2), i in 1:L
        ḡ[i] += kbuf[L + 1 - i, k]
    end
    return nothing
end
function _kernel_finish!(ḡ::NamedTuple, kbuf::AbstractMatrix)
    Ḡ = cotangent(ḡ, :x)
    L = size(kbuf, 2)
    _on_gpu(kbuf) && return (Ḡ .+= view(kbuf, :, L:-1:1); nothing)
    for i in 1:L, k in axes(kbuf, 1)
        Ḡ[k, i] += kbuf[k, L + 1 - i]
    end
    return nothing
end
function _kernel_finish!(ḡ::NamedTuple, kbuf::Array{<:Any, 3})
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

# `nothing` where the rule makes its own. A single series' output cotangent
# can be rows of the buffer's cotangent, which `_seeded` then need not fill.
_shared_shadow(op, y, c) = (nothing, c)
_shared_shadow(op::Recurrence, y, c) = _shared_shadow(y, c, c.H, c.D)
_shared_shadow(y, c, H, D) = (nothing, c)
function _shared_shadow(y::Vector{E}, c, H::Matrix{E}, D) where {E <: _IEEEFloat}
    m = Memory{E}(undef, length(H))
    fill!(m, zero(E))
    H̄ = Base.wrap(Array, m, size(H))
    ȳ = Base.wrap(Array, memoryref(m, D + 1), (length(y),))
    return ȳ, merge(c, (; H̄, ȳ))
end
