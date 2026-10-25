module ComposableRecurrencesForwardDiffExt

# The local forward-mode derivatives of pieces without a `pullback!`, the
# checks that their rebuild gives their parameters back, `Transform`'s
# derivative, and the dual-number methods of the primal helpers.

using ComposableRecurrences: ComposableRecurrences, Init, Pressure, Step, forward!,
    param_eltype
import ComposableRecurrences: _array_pressure, _check_jacobian, _local_step!, _step_duals, _check_scalars, _check_views,
    _dual_pressure_buffers, _exp_neg, _init_jacobian, _jacobian_pullback,
    _local_form_pullback, _local_pressure!, _pool_power, _primal_type, _primal_value,
    _probe_reads, _read_pullback, _scalar_pullback, _transform_partials,
    _transform_seeds, _value_pullback
using ComposableRecurrences: _ArrayPressure, _StepDuals, _written, _LOCAL_PRESSURE, _READ_WIDTHS,
    _ReadArray, _ReadSeed, _Reads, _TransformTag, _add_read!, _add_scalar!,
    _addparams!, _array_seeds, _exp_neg_branch, _nparams, _param_tuple, _params,
    _pressure_scalars, _rebuild, _rebuild_reads, _rebuild_scalar, _rebuild_views,
    _rebuilt_params!, _rebuilt_tuple, _reads_kept, _steps, _step, _draw, _scalar_params
using ForwardDiff: ForwardDiff

# The derivative in the value and the state only.
function _value_pullback(m, v̄, s̄, v, s, t, k)
    T = promote_type(typeof(v), typeof(s))
    xd = _seed(ForwardDiff.Tag(_value_pullback, T), (T(v), T(s)))
    v′, s′ = _step(m, xd[1], xd[2], t, k)
    g = _vjp(v′, s′, v̄, s̄, xd)
    return g[1], g[2]
end

# The derivative for a modifier with array parameters: a Jacobian in
# `[v; s; θ]`. Its chunk size depends on the parameters' count, so the
# Jacobian's type is asserted for what follows to infer.
function _jacobian_pullback(m, m̄, v̄, s̄, v, s, t, k)
    P = _nparams(m)
    x0 = [v; s; _params(m)]
    J = ForwardDiff.jacobian(x -> _step_vector(m, x, P, t, k), x0)::Matrix{eltype(x0)}
    g = transpose(J) * [v̄, s̄]
    _addparams!(m̄, m, g, 2)
    return g[1], g[2]
end
function _step_vector(m, x, P, t, k)
    v′, s′ = _step(_rebuild(m, view(x, 3:(P + 2))), x[1], x[2], t, k)
    return [v′, s′]
end

# The same derivative for a modifier whose parameters are scalars or read
# one entry per step: the value, the state and the parameters are seeded as
# one tuple of dual numbers, so a step allocates nothing (this runs once per
# stratum and step).
function _scalar_pullback(m, m̄, v̄, s̄, v, s, t, k)
    x = (v, s, _param_tuple(m, (k, t))...)
    T = promote_type(map(typeof, x)...)
    xd = _seed(ForwardDiff.Tag(_scalar_pullback, T), map(T, x))
    md = first(_rebuild_scalar(m, Base.tail(Base.tail(xd))))
    v′, s′ = _step(md, xd[1], xd[2], t, k)
    g = _vjp(v′, s′, v̄, s̄, xd)
    _add_scalar!(m̄, m, Base.tail(Base.tail(g)), (k, t))
    return g[1], g[2]
end

# The same derivative for a modifier with other float arrays, read entry by
# entry (`m.a[t]`): the value, the state and the scalars are seeded as
# before, and each array is wrapped so that each entry the step reads is a
# dual number with a partial of its own. The reads are recorded, and each
# one's cotangent goes to its entry. The first pass has room for
# `_READ_WIDTHS[1]` reads; a step that reads more runs once more with room
# for all of them, and one that reads more than the last width runs once
# per that many reads.
function _read_pullback(m, m̄, v̄, s̄, v, s, t, k)
    x = (v, s, _param_tuple(m, (k, t))...)
    T = float(promote_type(map(typeof, x)..., param_eltype(m)))
    return _read_pullback(m, m̄, v̄, s̄, map(T, x), t, k)
end
# `x` holds the value and the state, then the scalars.
function _read_pullback(m, m̄, v̄, s̄, x::Tuple{T, T, Vararg{T}}, t, k) where {T}
    R = first(_READ_WIDTHS)
    v′, s′, reads = _read_step(m, x, t, k, Val(R), 0)
    reads.n > R && return _read_wider(m, m̄, v̄, s̄, x, t, k, reads.n)
    return _read_grads(m, m̄, v̄, s̄, x, t, k, v′, s′, reads, true)
end
# A step that read `n` entries, more than the first pass holds: once more
# with the smallest room that holds them, else in passes of the widest.
function _read_wider(m, m̄, v̄, s̄, x, t, k, n)
    _, R2, R = _READ_WIDTHS
    n <= R2 && return _read_pass(m, m̄, v̄, s̄, x, t, k, Val(R2), 0)
    a, b = _read_pass(m, m̄, v̄, s̄, x, t, k, Val(R), 0)
    for lo in R:R:(n - 1)
        _read_pass(m, m̄, v̄, s̄, x, t, k, Val(R), lo)
    end
    return a, b
end
# One pass seeding reads `lo + 1` to `lo + R`. The first pass also gives
# the value's, the state's and the scalars' cotangents.
function _read_pass(m, m̄, v̄, s̄, x, t, k, ::Val{R}, lo) where {R}
    v′, s′, reads = _read_step(m, x, t, k, Val(R), lo)
    return _read_grads(m, m̄, v̄, s̄, x, t, k, v′, s′, reads, lo == 0)
end
# One dual step with room for `R` reads after the first `lo`: the value,
# the state and the scalars take the first partials, the reads the next
# `R`.
function _read_step(m, x::Tuple{T, T, Vararg{T, N}}, t, k, ::Val{R}, lo) where {T, N, R}
    return _read_step(m, x, t, k, Val(R), Val(N + 2 + R), lo)
end
function _read_step(
        m, x::Tuple{T, T, Vararg{T, N}}, t, k, ::Val{R}, ::Val{W}, lo
    ) where {T, N, R, W}
    D = ForwardDiff.Dual{typeof(ForwardDiff.Tag(_read_pullback, T)), T, W}
    xd = ntuple(i -> D(x[i], _unit(T, i, Val(W))), Val(N + 2))
    reads = _Reads{R}(lo)
    md = first(_rebuild_reads(m, Base.tail(Base.tail(xd)), _ReadSeed{D}(reads, N + 2), 1))
    v′, s′ = _step(md, xd[1], xd[2], t, k)
    return v′, s′, reads
end
# The cotangents of one dual step: the reads' are added to the mirror and,
# when `first`, the scalars' too; the value's and the state's are
# returned.
function _read_grads(
        m, m̄, v̄, s̄, x::Tuple{T, T, Vararg{T, N}}, t, k, v′::D, s′, reads, first
    ) where {T, N, D}
    M, R = N + 2, length(reads.leaf)
    g = _vjp(v′, s′, v̄, s̄, ntuple(_ -> nothing, Val(ForwardDiff.npartials(D))))
    first && _add_scalar!(m̄, m, ntuple(i -> g[2 + i], Val(N)), (k, t))
    for j in 1:min(reads.n - reads.lo, R)
        _add_read!(m̄, m, reads.leaf[j], reads.index[j], g[M + j], 1)
    end
    return g[1], g[2]
end

Base.@propagate_inbounds function Base.getindex(
        a::_ReadArray{D, N, A, R}, i::Int
    ) where {D, N, A, R}
    T = ForwardDiff.valtype(D)
    v = T(a.x[i])
    r = a.seed.reads
    r.n += 1
    j = r.n - r.lo
    (j < 1 || j > R) && return D(v)
    r.leaf = Base.setindex(r.leaf, a.leaf, j)
    r.index = Base.setindex(r.index, i, j)
    return D(v, _unit(T, a.seed.slot0 + j, Val(ForwardDiff.npartials(D))))
end

function _pressure_dual(T, ::Val{N}) where {N}
    return ForwardDiff.Dual{typeof(ForwardDiff.Tag(_local_pressure!, T)), T, N}
end
_dual_buffers(::Tuple{}, ::Type{D}, S) where {D} = (Vector{D}(undef, S), Vector{D}(undef, S))
_dual_buffers(::Nothing, ::Type{D}, S) where {D} = _dual_buffers((), D, S)
function _dual_buffers(
        bufs::Tuple{Tuple{Vector{D}, Vector{D}}, Vararg}, ::Type{D}, S
    ) where {D}
    pd, qd = first(bufs)
    return resize!(pd, S), resize!(qd, S)
end
_dual_buffers(bufs::Tuple, ::Type{D}, S) where {D} = _dual_buffers(Base.tail(bufs), D, S)

# Default pullback of a coupling without its own: the local `ForwardDiff`
# derivative of `q = C(p)` in `p` and the coupling's float scalars `θ`.
# The `n = S + P` inputs are seeded `N` at a time, and each pass adds
# `q̄ ⋅ ∂q/∂x` for its inputs, so no Jacobian is stored; `N` is the smallest
# of 4, 8, 12 and 24 that covers them. The rule takes this route while one
# pass covers every input (`_LOCAL_PRESSURE`), and through `_ad_wide` while
# two do (`_LOCAL_PRESSURE_WIDE`).
function _local_pressure!(p̄, C̄, C, q̄, p, t, θ::Tuple, bufs = nothing)
    n = length(p) + length(θ)
    n <= 4 && return _local_pressure!(Val(4), p̄, C̄, C, q̄, p, t, θ, bufs)
    n <= 8 && return _local_pressure!(Val(8), p̄, C̄, C, q̄, p, t, θ, bufs)
    n <= 12 && return _local_pressure!(Val(12), p̄, C̄, C, q̄, p, t, θ, bufs)
    return _local_pressure!(Val(_LOCAL_PRESSURE), p̄, C̄, C, q̄, p, t, θ, bufs)
end
function _local_pressure!(
        ::Val{N}, p̄, C̄, C, q̄, p, t, θ::NTuple{P, Any}, bufs
    ) where {N, P}
    T = float(promote_type(eltype(p), map(typeof, θ)...))
    D = _pressure_dual(T, Val(N))
    S = length(p)
    pd, qd = _dual_buffers(bufs, D, S)
    for o in 0:N:(S + P - 1)
        for i in 1:S
            @inbounds pd[i] = D(T(p[i]), _unit(T, i - o, Val(N)))
        end
        θd = ntuple(j -> D(T(θ[j]), _unit(T, S + j - o, Val(N))), Val(P))
        forward!(_with_scalars(C, θd), Pressure(), qd, pd, t)
        ā = zero(ForwardDiff.Partials{N, T})
        for i in 1:S
            @inbounds ā += q̄[i] * ForwardDiff.partials(qd[i])
        end
        for j in 1:min(N, S - o)
            p̄[o + j] += ā[j]
        end
        P == 0 || o + N <= S ||
            _add_scalar!(C̄, C, _picks(ā, S - o, Val(P)), nothing)
    end
    return nothing
end
# Partials with a one at `i`, and entries `o + 1` to `o + P` of partials
# `ā`, zero outside `1:N`.
function _unit(T, i, ::Val{N}) where {N}
    return ForwardDiff.Partials(ntuple(j -> T(j == i), Val(N)))
end
_picks(ā, o, ::Val{P}) where {P} = ntuple(j -> _pick(ā, o + j), Val(P))
_pick(ā, i) = 1 <= i <= length(ā) ? ā[i] : zero(eltype(ā))
_with_scalars(C, ::Tuple{}) = C
_with_scalars(C, θ) = first(_rebuild_scalar(C, θ))

function _array_pressure(C, Tp)
    T = float(promote_type(Tp, param_eltype(C)))
    θ = Vector{T}(_params(C))
    lane(N) = (D -> (D[], D[], Vector{D}(undef, length(θ))))(_pressure_dual(T, N))
    lanes = (lane(Val(4)), lane(Val(8)), lane(Val(12)), lane(Val(_LOCAL_PRESSURE)))
    return _ArrayPressure(θ, zero(θ), lanes)
end
function _local_pressure!(p̄, C̄, C, q̄, p, t, b::_ArrayPressure)
    n = length(p) + length(b.θ)
    n <= 4 && return _array_pressure!(Val(4), b.lanes[1], b, p̄, C̄, C, q̄, p, t)
    n <= 8 && return _array_pressure!(Val(8), b.lanes[2], b, p̄, C̄, C, q̄, p, t)
    n <= 12 && return _array_pressure!(Val(12), b.lanes[3], b, p̄, C̄, C, q̄, p, t)
    return _array_pressure!(Val(_LOCAL_PRESSURE), b.lanes[4], b, p̄, C̄, C, q̄, p, t)
end
function _array_pressure!(::Val{N}, lane, b, p̄, C̄, C, q̄, p, t) where {N}
    pd, qd, θd = lane
    D = eltype(θd)
    T = eltype(b.θ)
    S, P = length(p), length(b.θ)
    resize!(pd, S)
    resize!(qd, S)
    fill!(b.ḡ, zero(T))
    for o in 0:N:(S + P - 1)
        for i in 1:S
            @inbounds pd[i] = D(T(p[i]), _unit(T, i - o, Val(N)))
        end
        for j in 1:P
            @inbounds θd[j] = D(b.θ[j], _unit(T, S + j - o, Val(N)))
        end
        forward!(_rebuild_views(C, θd), Pressure(), qd, pd, t)
        ā = zero(ForwardDiff.Partials{N, T})
        for i in 1:S
            @inbounds ā += q̄[i] * ForwardDiff.partials(qd[i])
        end
        for j in 1:min(N, S - o)
            p̄[o + j] += ā[j]
        end
        for j in max(1, o + 1 - S):min(P, o + N - S)
            @inbounds b.ḡ[j] += ā[S + j - o]
        end
    end
    _addparams!(C̄, C, b.ḡ, 0)
    return nothing
end

# Default pullback of a whole-step modifier without its own: the local
# `ForwardDiff` derivative of `forward!(m, Step(), v, s, t)` in the
# values, the state and the parameters, seeded `N` at a time, as a
# coupling's. Each pass adds `v̄′ ⋅ ∂v′/∂x + s̄′ ⋅ ∂s′/∂x` for its inputs.
function _step_dual(T, ::Val{N}) where {N}
    return ForwardDiff.Dual{typeof(ForwardDiff.Tag(_local_step!, T)), T, N}
end
function _step_duals(m̄, m, ::Type{Tp}) where {Tp}
    T = float(promote_type(Tp, param_eltype(m)))
    θ = _array_seeds(m̄, m) ? Vector{T}(_params(m)) : T[]
    lane(N) = (D -> (D[], D[], Vector{D}(undef, length(θ))))(_step_dual(T, N))
    lanes = (lane(Val(4)), lane(Val(8)), lane(Val(12)), lane(Val(_LOCAL_PRESSURE)))
    return _StepDuals(T[], T[], θ, zero(θ), lanes)
end
# The float scalars a pass seeds: those of a differentiated modifier whose
# parameters are all scalars, as a tuple, so its rebuild allocates nothing;
# a modifier with float arrays seeds them through `b.θ` instead.
_step_scalars(::Nothing, m) = ()
_step_scalars(m̄, m) = _scalar_params(m) ? _param_tuple(m) : ()
function _local_step!(m̄, m, v̄, s̄, v, s, t, b::_StepDuals)
    θs = _step_scalars(m̄, m)
    n = length(v) + length(s) + length(b.θ) + length(θs)
    n <= 4 && return _local_step!(Val(4), b.lanes[1], b, θs, m̄, m, v̄, s̄, v, s, t)
    n <= 8 && return _local_step!(Val(8), b.lanes[2], b, θs, m̄, m, v̄, s̄, v, s, t)
    n <= 12 && return _local_step!(Val(12), b.lanes[3], b, θs, m̄, m, v̄, s̄, v, s, t)
    return _local_step!(Val(_LOCAL_PRESSURE), b.lanes[4], b, θs, m̄, m, v̄, s̄, v, s, t)
end
function _local_step!(
        ::Val{N}, lane, b, θs::NTuple{Q, Any}, m̄, m, v̄, s̄, v, s, t
    ) where {N, Q}
    vd, sd, θd = lane
    D = eltype(vd)
    T = eltype(b.θ)
    S, R, P = length(v), length(s), length(b.θ)
    resize!(vd, S)
    resize!(sd, R)
    copyto!(resize!(b.v̄, S), v̄)
    copyto!(resize!(b.s̄, R), s̄)
    fill!(v̄, zero(eltype(v̄)))
    fill!(s̄, zero(eltype(s̄)))
    fill!(b.ḡ, zero(T))
    for o in 0:N:(S + R + P + Q - 1)
        for i in 1:S
            @inbounds vd[i] = D(T(v[i]), _unit(T, i - o, Val(N)))
        end
        for j in 1:R
            @inbounds sd[j] = D(T(s[j]), _unit(T, S + j - o, Val(N)))
        end
        for j in 1:P
            @inbounds θd[j] = D(b.θ[j], _unit(T, S + R + j - o, Val(N)))
        end
        θsd = ntuple(j -> D(T(θs[j]), _unit(T, S + R + j - o, Val(N))), Val(Q))
        _written(m, forward!(_dual_modifier(m̄, m, θd, θsd), Step(), vd, sd, t))
        ā = zero(ForwardDiff.Partials{N, T})
        for i in 1:S
            @inbounds ā += b.v̄[i] * ForwardDiff.partials(vd[i])
        end
        for j in 1:R
            @inbounds ā += b.s̄[j] * ForwardDiff.partials(sd[j])
        end
        for j in max(1, o + 1):min(S, o + N)
            @inbounds v̄[j] += ā[j - o]
        end
        for j in max(1, o + 1 - S):min(R, o + N - S)
            @inbounds s̄[j] += ā[S + j - o]
        end
        for j in max(1, o + 1 - S - R):min(P, o + N - S - R)
            @inbounds b.ḡ[j] += ā[S + R + j - o]
        end
        Q == 0 || o + N <= S + R ||
            _add_scalar!(m̄, m, _picks(ā, S + R - o, Val(Q)), nothing)
    end
    P == 0 || _addparams!(m̄, m, b.ḡ, 0)
    return nothing
end
# The modifier the dual step runs: rebuilt from the seeded scalars, or from
# the seeded parameters (each pass, as scalars are copied), when it is
# differentiated; as itself when it is held constant.
_dual_modifier(m̄, m, θd, θsd::Tuple{Any, Vararg}) = first(_rebuild_scalar(m, θsd))
_dual_modifier(m̄, m, θd, ::Tuple{}) = _rebuild_views(m, θd)
_dual_modifier(::Nothing, m, θd, ::Tuple{}) = m

function _local_form_pullback(grads, form, v, s, N)
    x = (v, s, N, _param_tuple(form)...)
    T = promote_type(map(typeof, x)...)
    xd = _seed(ForwardDiff.Tag(_local_form_pullback, T), map(T, x))
    θd = Base.tail(Base.tail(Base.tail(xd)))
    fd = first(_rebuild_scalar(form, θd))
    y, s′ = _draw(fd, xd[1], xd[2], xd[3])
    g = _vjp(y, s′, grads.v, grads.s, xd)
    _add_scalar!(grads.piece, form, Base.tail(Base.tail(Base.tail(g))), nothing)
    return g[1], g[2], g[3]
end

# Dual numbers with one unit partial each, for the values in `x` (the value
# and the state come first, so there is at least one).
function _seed(tag::G, x::Tuple{T, Vararg{T, M}}) where {G, T, M}
    return ntuple(Val(M + 1)) do i
        ForwardDiff.Dual{G}(x[i], ForwardDiff.Partials(ntuple(j -> T(i == j), Val(M + 1))))
    end
end

# `v̄ ∂v′/∂x + s̄ ∂s′/∂x` for each of the `N` seeded values.
function _vjp(v′, s′, v̄, s̄, x::NTuple{N}) where {N}
    ∂v, ∂s = _partialsN(v′, Val(N)), _partialsN(s′, Val(N))
    return ntuple(i -> v̄ * ∂v[i] + s̄ * ∂s[i], Val(N))
end
_partialsN(x::ForwardDiff.Dual, ::Val) = ForwardDiff.partials(x).values
_partialsN(x::Real, ::Val{N}) where {N} = ntuple(_ -> zero(x), Val(N))

function _check_scalars(x, θ)
    T = promote_type(map(typeof, θ)...)
    θd = _seed(ForwardDiff.Tag(_check_scalars, T), map(T, θ))
    return try
        xd = first(_rebuild_scalar(x, θd))
        _rebuilt_tuple(x, xd) === θd && _steps(x, xd, one(first(θd)))
    catch e
        e isa InterruptException && rethrow()
        false
    end
end

function _check_views(x)
    θ = _params(x)
    T = eltype(θ)
    D = ForwardDiff.Dual{typeof(ForwardDiff.Tag(_check_views, T)), T, 1}
    θd = [D(θ[j], ForwardDiff.Partials((T(j),))) for j in eachindex(θ)]
    return try
        back = similar(θd)
        _rebuilt_params!(back, x, _rebuild_views(x, θd), 0) == length(θd) &&
            all(j -> back[j] === θd[j], eachindex(θd))
    catch e
        e isa InterruptException && rethrow()
        false
    end
end

# The entries one read step of `x` reads at stratum 1 and time 1, or -1 if
# the rebuild fails.
function _probe_reads(x)
    θ = _param_tuple(x, (1, 1))
    T = float(promote_type(map(typeof, θ)..., param_eltype(x)))
    M = length(θ) + 2
    R = first(_READ_WIDTHS)
    D = ForwardDiff.Dual{typeof(ForwardDiff.Tag(_probe_reads, T)), T, M + R}
    θd = ntuple(i -> D(T(θ[i]), _unit(T, i + 2, Val(M + R))), length(θ))
    reads = _Reads{R}()
    return try
        xd = first(_rebuild_reads(x, θd, _ReadSeed{D}(reads, M), 1))
        _rebuilt_tuple(x, xd) === θd && _reads_kept(x, xd) || return -1
        _step(xd, one(D), one(D), 1, 1)
        reads.n
    catch e
        e isa InterruptException && rethrow()
        -1
    end
end

# The Jacobian `PieceInterface`'s pullback check compares with. One tag and
# chunk for every piece, so the dual type is compiled once.
function _check_jacobian(f, x::AbstractVector{<:Real})
    tag = ForwardDiff.Tag(_check_jacobian, eltype(x))
    cfg = ForwardDiff.JacobianConfig(nothing, x, ForwardDiff.Chunk{1}(), tag)
    return ForwardDiff.jacobian(f, x, cfg, Val(false))
end

# The Jacobian of the Init in the modifier's `P` active parameters and the
# history's `nh` entries.
function _init_jacobian(m, s, history, P, nh)
    x0 = P == 0 ? vec(history) : [_params(m); vec(history)]
    J = ForwardDiff.jacobian(x0) do x
        mm = P == 0 ? m : _rebuild(m, view(x, 1:P))
        hh = nh == 0 ? history : reshape(x[(P + 1):end], size(history))
        ss = similar(x, length(s))
        forward!(mm, Init(), ss, hh)
        return ss
    end
    return J
end

# The dual-number buffers of a coupling's local derivative, made once per
# reverse pass so a step allocates nothing: a pair of vectors for each
# number of partials, sized on first use. A step whose dual type is not
# among them allocates its own.
function _dual_pressure_buffers(C̄, C, Tp)
    _array_seeds(C̄, C) && return _array_pressure(C, Tp)
    T = float(promote_type(Tp, map(typeof, _pressure_scalars(C̄, C))...))
    pair(N) = (D -> (D[], D[]))(_pressure_dual(T, N))
    return (pair(Val(4)), pair(Val(8)), pair(Val(12)), pair(Val(_LOCAL_PRESSURE)))
end

# `Transform`'s seeds: a `ForwardDiff.Tag` orders this dual against any
# outer one, so the derivative also runs on dual inputs. The tag reaches
# the seeds as a static parameter: a closure that captures a type as a
# value does not infer it on Julia 1.11.
function _transform_seeds(xs::Tuple{T, Vararg{T}}) where {T}
    return _transform_seeds(typeof(ForwardDiff.Tag(_TransformTag(), T)), xs)
end
function _transform_seeds(::Type{G}, xs::Tuple{T, Vararg{T, M}}) where {G, T, M}
    N = Val(M + 1)
    return ntuple(N) do i
        ForwardDiff.Dual{G}(xs[i], ntuple(j -> T(i == j), N))
    end
end
# The partials of the map's output.
function _transform_partials(
        y::ForwardDiff.Dual{<:ForwardDiff.Tag{_TransformTag}}, ::Val{N}
    ) where {N}
    return ntuple(i -> ForwardDiff.partials(y, i), Val(N))
end

# The primal value of a dual number, through any nesting, and its type.
_primal_value(x::ForwardDiff.Dual) = _primal_value(ForwardDiff.value(x))
_primal_type(::Type{<:ForwardDiff.Dual{<:Any, V}}) where {V} = _primal_type(V)

# Dual numbers branch on their value, as plain floats do.
_exp_neg(x::ForwardDiff.Dual) = _exp_neg_branch(x)
# With a dual exponent the power at an empty pool takes the primal
# exponent. A dual exponent is never traced, so a branch computes only one
# power.
function _pool_power(r, e::ForwardDiff.Dual)
    _primal_value(r) <= 0 || return r^e
    return convert(promote_type(typeof(r), typeof(e)), r^_primal_value(e))
end

end
