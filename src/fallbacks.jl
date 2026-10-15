# Default pullbacks for modifiers and couplings without a hand-written one:
# a local `ForwardDiff` Jacobian of that one step, including the parameters.
# A parameter is a float leaf of the object: a float scalar, the entries of a
# float array (a view or reshape is rebuilt as an `Array`), the nonzeros of a
# sparse matrix or the diagonal of a `Diagonal`, found by recursing through
# fields, tuples and named tuples.

const _Leafless = Union{
    Real, AbstractArray, Nothing, Symbol, AbstractString, Function, Type,
    Module,
}

# The number of parameters of `x`.
_nparams(::AbstractFloat) = 1
_nparams(x::AbstractArray{<:AbstractFloat}) = length(x)
_nparams(x::SparseMatrixCSC{<:AbstractFloat}) = length(nonzeros(x))
_nparams(x::Diagonal{<:AbstractFloat}) = _nparams(x.diag)
_nparams(::_Leafless) = 0
_nparams(x::Union{Tuple, NamedTuple}) = sum(_nparams, values(x); init = 0)
function _nparams(x)
    isstructtype(typeof(x)) || return 0
    return sum(i -> _nparams(getfield(x, i)), 1:fieldcount(typeof(x)); init = 0)
end

# The parameters of `x` as a vector.
function _params(x)
    θ = zeros(float(param_eltype(x)), _nparams(x))
    _getparams!(θ, x, 0)
    return θ
end

# Write the parameters of `x` into `θ` after offset `o`; return the new offset.
_getparams!(θ, x::AbstractFloat, o) = (θ[o + 1] = x; o + 1)
function _getparams!(θ, x::AbstractArray{<:AbstractFloat}, o)
    for (i, xi) in enumerate(x)
        θ[o + i] = xi
    end
    return o + length(x)
end
_getparams!(θ, x::SparseMatrixCSC{<:AbstractFloat}, o) = _getparams!(θ, nonzeros(x), o)
_getparams!(θ, x::Diagonal{<:AbstractFloat}, o) = _getparams!(θ, x.diag, o)
_getparams!(θ, ::_Leafless, o) = o
function _getparams!(θ, x::Union{Tuple, NamedTuple}, o)
    for xi in values(x)
        o = _getparams!(θ, xi, o)
    end
    return o
end
function _getparams!(θ, x, o)
    isstructtype(typeof(x)) || return o
    for i in 1:fieldcount(typeof(x))
        o = _getparams!(θ, getfield(x, i), o)
    end
    return o
end

# `x` with its parameters read from `θ` (possibly Duals) after offset `o`;
# returns the new object and offset. Structs are rebuilt through
# `ConstructionBase.constructorof`.
_rebuild(x, θ) = first(_rebuild(x, θ, 0))
_rebuild(::AbstractFloat, θ, o) = (θ[o + 1], o + 1)
function _rebuild(x::AbstractArray{<:AbstractFloat}, θ, o)
    n = length(x)
    return reshape(θ[(o + 1):(o + n)], size(x)), o + n
end
function _rebuild(x::SparseMatrixCSC{<:AbstractFloat}, θ, o)
    n = length(nonzeros(x))
    nz = θ[(o + 1):(o + n)]
    return SparseMatrixCSC(size(x)..., copy(x.colptr), copy(x.rowval), nz), o + n
end
function _rebuild(x::Diagonal{<:AbstractFloat}, θ, o)
    d, o = _rebuild(x.diag, θ, o)
    return Diagonal(d), o
end
_rebuild(x::_Leafless, θ, o) = (x, o)
_rebuild(::Tuple{}, θ, o) = ((), o)
function _rebuild(x::Tuple, θ, o)
    a, o = _rebuild(first(x), θ, o)
    b, o = _rebuild(Base.tail(x), θ, o)
    return (a, b...), o
end
function _rebuild(x::NamedTuple{N}, θ, o) where {N}
    y, o = _rebuild(Tuple(x), θ, o)
    return NamedTuple{N}(y), o
end
function _rebuild(x, θ, o)
    _holds_floats(x) || return x, o
    fs, o = _rebuild(ntuple(i -> getfield(x, i), Val(fieldcount(typeof(x)))), θ, o)
    return constructorof(typeof(x))(fs...), o
end


# Add the gradient `g` (after offset `o`) into the mirror `x̄` of `x`;
# returns the new offset.
_addparams!(x̄, x::AbstractFloat, g, o) = (add_cotangent!(x̄, g[o + 1]); o + 1)
function _addparams!(x̄, x::AbstractArray{<:AbstractFloat}, g, o)
    n = length(x)
    x̄ === nothing || (x̄ .+= reshape(view(g, (o + 1):(o + n)), size(x)))
    return o + n
end
function _addparams!(x̄, x::SparseMatrixCSC{<:AbstractFloat}, g, o)
    return _addparams!(cotangent(x̄, :nzval), nonzeros(x), g, o)
end
_addparams!(x̄, x::Diagonal{<:AbstractFloat}, g, o) = _addparams!(cotangent(x̄, :diag), x.diag, g, o)
_addparams!(x̄, ::_Leafless, g, o) = o
function _addparams!(x̄, x::Union{Tuple, NamedTuple}, g, o)
    for i in 1:length(x)
        o = _addparams!(x̄ === nothing ? nothing : x̄[i], x[i], g, o)
    end
    return o
end
function _addparams!(x̄, x, g, o)
    isstructtype(typeof(x)) || return o
    for n in fieldnames(typeof(x))
        o = _addparams!(_field_mirror(x̄, n), getfield(x, n), g, o)
    end
    return o
end
_field_mirror(x̄, n::Symbol) = cotangent(x̄, n)
_field_mirror(x̄, n::Integer) = x̄ === nothing ? nothing : x̄[n]

# The number of parameters to differentiate: none without a mirror.
_nactive(x̄, x) = x̄ === nothing ? 0 : _nparams(x)

# A pointwise modifier's scalar step pullback: its own when it uses one,
# else the local derivative.
function _step_pullback(grads, m, v, s, t, k)
    uses_adjoint(m, Step()) || return _local_pullback(grads, m, v, s, t, k)
    return pullback!(grads, m, Step(), v, s, t, k)
end

# Default scalar pullback of a pointwise modifier without its own: a local
# `ForwardDiff` derivative in the value, the state and the modifier's float
# parameters, of which an array parameter read by `param` gives the one
# entry the step reads. Each case is its own method, so no variable is
# shared with a closure (which would box it and allocate on every step).
function _local_pullback(grads, m, v, s, t, k)
    m̄, v̄, s̄ = grads.piece, grads.v, grads.s
    if m̄ !== nothing
        _local_params(m) && return _scalar_pullback(m, m̄, v̄, s̄, v, s, t, k)
        _array_params(m) && return _read_pullback(m, m̄, v̄, s̄, v, s, t, k)
    end
    _nactive(m̄, m) == 0 && return _value_pullback(m, v̄, s̄, v, s, t, k)
    return _jacobian_pullback(m, m̄, v̄, s̄, v, s, t, k)
end

# The derivative in the value and the state only.
function _value_pullback(m, v̄, s̄, v, s, t, k)
    T = promote_type(typeof(v), typeof(s))
    xd = _seed(ForwardDiff.Tag(_value_pullback, T), (T(v), T(s)))
    v′, s′ = forward(m, Step(), xd[1], xd[2], t, k)
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
    v′, s′ = forward(_rebuild(m, view(x, 3:(P + 2))), Step(), x[1], x[2], t, k)
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
    v′, s′ = forward(md, Step(), xd[1], xd[2], t, k)
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
# for all of them, up to the last width, and above that takes the Jacobian.
function _read_pullback(m, m̄, v̄, s̄, v, s, t, k)
    x = (v, s, _param_tuple(m, (k, t))...)
    T = float(promote_type(map(typeof, x)..., param_eltype(m)))
    return _read_pullback(m, m̄, v̄, s̄, map(T, x), t, k)
end
# `x` holds the value and the state, then the scalars.
function _read_pullback(m, m̄, v̄, s̄, x::Tuple{T, T, Vararg{T}}, t, k) where {T}
    R = first(_READ_WIDTHS)
    v′, s′, reads = _read_step(m, x, t, k, Val(R))
    reads.n > R && return _read_wider(m, m̄, v̄, s̄, x, t, k, reads.n)
    return _read_grads(m, m̄, v̄, s̄, x, t, k, v′, s′, reads)
end
# A step that read `n` entries, more than the first pass holds: once more
# with the smallest room that holds them, else the Jacobian.
function _read_wider(m, m̄, v̄, s̄, x, t, k, n)
    n <= _READ_WIDTHS[2] && return _read_once(m, m̄, v̄, s̄, x, t, k, Val(_READ_WIDTHS[2]))
    n <= _READ_WIDTHS[3] && return _read_once(m, m̄, v̄, s̄, x, t, k, Val(_READ_WIDTHS[3]))
    n <= _READ_WIDTHS[4] && return _read_once(m, m̄, v̄, s̄, x, t, k, Val(_READ_WIDTHS[4]))
    return _read_jacobian(m, m̄, v̄, s̄, x, t, k)
end
function _read_once(m, m̄, v̄, s̄, x, t, k, ::Val{R}) where {R}
    v′, s′, reads = _read_step(m, x, t, k, Val(R))
    reads.n > R && return _read_jacobian(m, m̄, v̄, s̄, x, t, k)
    return _read_grads(m, m̄, v̄, s̄, x, t, k, v′, s′, reads)
end
function _read_jacobian(m, m̄, v̄, s̄, x::Tuple{T, Vararg{T}}, t, k) where {T}
    Rt = typeof(v̄ * one(T) + s̄ * one(T))
    a, b = _jacobian_pullback(m, m̄, v̄, s̄, x[1], x[2], t, k)
    return convert(Rt, a)::Rt, convert(Rt, b)::Rt
end
# One dual step with room for `R` reads: the value, the state and the
# scalars take the first partials, the reads the next `R`.
function _read_step(m, x::Tuple{T, T, Vararg{T, N}}, t, k, ::Val{R}) where {T, N, R}
    return _read_step(m, x, t, k, Val(R), Val(N + 2 + R))
end
function _read_step(
        m, x::Tuple{T, T, Vararg{T, N}}, t, k, ::Val{R}, ::Val{W}
    ) where {T, N, R, W}
    D = ForwardDiff.Dual{typeof(ForwardDiff.Tag(_read_pullback, T)), T, W}
    xd = ntuple(i -> D(x[i], _unit(T, i, Val(W))), Val(N + 2))
    reads = _Reads{R}()
    md = first(_rebuild_reads(m, Base.tail(Base.tail(xd)), _ReadSeed{D}(reads, N + 2), 1))
    v′, s′ = forward(md, Step(), xd[1], xd[2], t, k)
    return v′, s′, reads
end
# The cotangents of one dual step: the value's and the state's are
# returned, the scalars' and the reads' added to the mirror.
function _read_grads(
        m, m̄, v̄, s̄, x::Tuple{T, T, Vararg{T, N}}, t, k, v′::D, s′, reads
    ) where {T, N, D}
    M = N + 2
    g = _vjp(v′, s′, v̄, s̄, ntuple(_ -> nothing, Val(ForwardDiff.npartials(D))))
    _add_scalar!(m̄, m, ntuple(i -> g[2 + i], Val(N)), (k, t))
    for j in 1:reads.n
        _add_read!(m̄, m, reads.leaf[j], reads.index[j], g[M + j], 1)
    end
    return g[1], g[2]
end

# The reads of a modifier's float arrays in one dual step, with room for
# `R`: for each, the array (its position among them, `_rebuild_reads`'s
# leaf) and the linear index read. `n` counts every read, so `n > R` marks
# a step that read more than the partials hold.
const _READ_WIDTHS = (4, 8, 12, 24)
mutable struct _Reads{R}
    n::Int
    leaf::NTuple{R, Int}
    index::NTuple{R, Int}
end
_Reads{R}() where {R} = _Reads{R}(0, ntuple(_ -> 0, Val(R)), ntuple(_ -> 0, Val(R)))

# The dual type of a read step, its record and the partials before the
# reads' (the value's, the state's and the scalars').
struct _ReadSeed{D, R}
    reads::_Reads{R}
    slot0::Int
end
_ReadSeed{D}(reads::_Reads{R}, slot0) where {D, R} = _ReadSeed{D, R}(reads, slot0)

# A modifier's float array inside its read step: each entry read is a dual
# number of type `D` with the next read partial set, and is recorded.
struct _ReadArray{D, N, A <: AbstractArray, R} <: AbstractArray{D, N}
    x::A
    leaf::Int
    seed::_ReadSeed{D, R}
end
function _ReadArray(
        x::AbstractArray{<:Any, N}, leaf, seed::_ReadSeed{D, R}
    ) where {D, N, R}
    return _ReadArray{D, N, typeof(x), R}(x, leaf, seed)
end
Base.size(a::_ReadArray) = size(a.x)
Base.IndexStyle(::Type{<:_ReadArray}) = IndexLinear()
Base.@propagate_inbounds function Base.getindex(
        a::_ReadArray{D, N, A, R}, i::Int
    ) where {D, N, A, R}
    T = ForwardDiff.valtype(D)
    v = T(a.x[i])
    r = a.seed.reads
    j = r.n + 1
    r.n = j
    j > R && return D(v)
    r.leaf = Base.setindex(r.leaf, a.leaf, j)
    r.index = Base.setindex(r.index, i, j)
    return D(v, _unit(T, a.seed.slot0 + j, Val(ForwardDiff.npartials(D))))
end

# `x` with its float scalars, entry parameters included, taken from `θ` and
# each other float array wrapped as a `_ReadArray`, numbered from leaf `l`
# in field order; returns the object, the rest of `θ` and the next leaf.
_rebuild_reads(::Union{AbstractFloat, _EntryParam}, θ, w, l) = (first(θ), Base.tail(θ), l)
function _rebuild_reads(x::AbstractArray{<:AbstractFloat}, θ, w, l)
    return _ReadArray(x, l, w), θ, l + 1
end
_rebuild_reads(x::_Leafless, θ, w, l) = (x, θ, l)
_rebuild_reads(::Tuple{}, θ, w, l) = ((), θ, l)
function _rebuild_reads(x::Tuple, θ, w, l)
    a, θ, l = _rebuild_reads(first(x), θ, w, l)
    b, θ, l = _rebuild_reads(Base.tail(x), θ, w, l)
    return (a, b...), θ, l
end
function _rebuild_reads(x::NamedTuple{N}, θ, w, l) where {N}
    y, θ, l = _rebuild_reads(Tuple(x), θ, w, l)
    return NamedTuple{N}(y), θ, l
end
function _rebuild_reads(x, θ, w, l)
    _holds_floats(x) || return x, θ, l
    fs = ntuple(i -> getfield(x, i), Val(fieldcount(typeof(x))))
    ys, θ, l = _rebuild_reads(fs, θ, w, l)
    return constructorof(typeof(x))(ys...), θ, l
end

# Whether a struct may hold a float scalar or float array anywhere in its
# fields, from its type alone, so a rebuild that skips one infers.
function _floats_in(::Type{T}) where {T}
    T <: AbstractFloat && return true
    T <: AbstractArray && return eltype(T) <: AbstractFloat || !isconcretetype(eltype(T))
    T <: Union{Real, Nothing, Symbol, AbstractString, Function, Type, Module} && return false
    # A field of abstract type may hold a float; the rebuild then goes by
    # value.
    isconcretetype(T) || return true
    isstructtype(T) || return false
    return any(_floats_in, fieldtypes(T))
end
@generated _holds_floats(x) = _floats_in(x)

# Add `g` at linear index `i` of the mirror of float array `leaf` of `x`, in
# `_rebuild_reads`'s numbering from `l`; returns the next leaf.
_add_read!(x̄, ::Union{AbstractFloat, _EntryParam}, leaf, i, g, l) = l
function _add_read!(x̄, ::AbstractArray{<:AbstractFloat}, leaf, i, g, l)
    l == leaf && add_cotangent!(x̄, g, i)
    return l + 1
end
_add_read!(x̄, ::_Leafless, leaf, i, g, l) = l
function _add_read!(x̄, x::Union{Tuple, NamedTuple}, leaf, i, g, l)
    for j in 1:length(x)
        l = _add_read!(x̄ === nothing ? nothing : x̄[j], x[j], leaf, i, g, l)
    end
    return l
end
function _add_read!(x̄, x, leaf, i, g, l)
    _holds_floats(x) || return l
    for n in fieldnames(typeof(x))
        l = _add_read!(_field_mirror(x̄, n), getfield(x, n), leaf, i, g, l)
    end
    return l
end

# A coupling's pullback at one step: its own when it uses one, else the
# local derivative, which takes its dual numbers from `bufs`
# (`_pressure_buffers`). Adds into `p̄`.
function _pressure_back!(p̄, C̄, C, q̄, p, t, bufs = nothing)
    return _pressure_back!(Val(uses_adjoint(C, Pressure())), p̄, C̄, C, q̄, p, t, bufs)
end
function _pressure_back!(::Val{true}, p̄, C̄, C, q̄, p, t, bufs)
    pullback!((; piece = C̄, q = q̄, p = p̄), C, Pressure(), nothing, p, t)
    return nothing
end
function _pressure_back!(::Val{false}, p̄, C̄, C, q̄, p, t, bufs)
    if _array_seeds(C̄, C)
        b = bufs isa _ArrayPressure ? bufs : _array_pressure(C, eltype(p))
        return _local_pressure!(p̄, C̄, C, q̄, p, t, b)
    end
    return _local_pressure!(p̄, C̄, C, q̄, p, t, _pressure_scalars(C̄, C), bufs)
end
_pressure_scalars(C̄, C) = C̄ === nothing ? () : _param_tuple(C)
# Whether the local step seeds a coupling's float arrays as well as its
# scalars: only when the coupling is differentiated and holds any.
_array_seeds(C̄, C) = C̄ !== nothing && !_scalar_params(C)

# The dual-number buffers of a coupling's local derivative, made once per
# reverse pass so a step allocates nothing: a pair of vectors for each
# number of partials, sized on first use; `nothing` for a coupling with its
# own pullback. A step whose dual type is not among them allocates its own.
function _pressure_buffers(C̄, C, Tp)
    return _pressure_buffers(Val(uses_adjoint(C, Pressure())), C̄, C, Tp)
end
_pressure_buffers(::Val{true}, C̄, C, Tp) = nothing
function _pressure_buffers(::Val{false}, C̄, C, Tp)
    _array_seeds(C̄, C) && return _array_pressure(C, Tp)
    T = float(promote_type(Tp, map(typeof, _pressure_scalars(C̄, C))...))
    pair(N) = (D -> (D[], D[]))(_pressure_dual(T, N))
    return (pair(Val(4)), pair(Val(8)), pair(Val(12)), pair(Val(_LOCAL_PRESSURE)))
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
const _LOCAL_PRESSURE = 24
const _LOCAL_PRESSURE_WIDE = 2 * _LOCAL_PRESSURE
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
        forward(_with_scalars(C, θd), Pressure(), qd, pd, t)
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

# The local derivative of a coupling with float arrays among its parameters:
# every scalar and array entry is seeded alongside the strata, in the order
# `_params` reads them, through a rebuild whose arrays are views of one
# vector of dual numbers, so each pass reseeds them in place. The buffers
# hold the parameters, their cotangent for one step, and the dual vectors
# of the strata, the pressures and the parameters for each width.
struct _ArrayPressure{T, L}
    θ::Vector{T}
    ḡ::Vector{T}
    lanes::L
end
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
        forward(_rebuild_views(C, θd), Pressure(), qd, pd, t)
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

# `_rebuild` with each float array a view of `θ` rather than a copy, so a
# change to `θ` reaches the rebuilt object.
_rebuild_views(x, θ) = first(_rebuild_views(x, θ, 0))
_rebuild_views(::AbstractFloat, θ, o) = (θ[o + 1], o + 1)
function _rebuild_views(x::AbstractArray{<:AbstractFloat}, θ, o)
    n = length(x)
    return reshape(view(θ, (o + 1):(o + n)), size(x)), o + n
end
_rebuild_views(x::_Leafless, θ, o) = (x, o)
_rebuild_views(::Tuple{}, θ, o) = ((), o)
function _rebuild_views(x::Tuple, θ, o)
    a, o = _rebuild_views(first(x), θ, o)
    b, o = _rebuild_views(Base.tail(x), θ, o)
    return (a, b...), o
end
function _rebuild_views(x::NamedTuple{N}, θ, o) where {N}
    y, o = _rebuild_views(Tuple(x), θ, o)
    return NamedTuple{N}(y), o
end
function _rebuild_views(x, θ, o)
    isstructtype(typeof(x)) || return x, o
    fs, o = _rebuild_views(ntuple(i -> getfield(x, i), Val(fieldcount(typeof(x)))), θ, o)
    return constructorof(typeof(x))(fs...), o
end

# The pullback of a depletion form's step `(v, s, N, α) -> (y, s′)`: its own
# when it declares one, else a local derivative that seeds the value, the
# pool, the population, the exponent and the form's float scalars as one
# tuple of dual numbers. Returns the cotangents of `(v, s, N, α)`.
_form_adjoint(form) = uses_adjoint(form, Step()) || _scalar_params(form)
function _form_pullback(grads, form, v, s, N, α)
    return _form_pullback(Val(uses_adjoint(form, Step())), grads, form, v, s, N, α)
end
function _form_pullback(::Val{true}, grads, form, v, s, N, α)
    return pullback!(grads, form, Step(), v, s, N, α)
end
function _form_pullback(::Val{false}, grads, form, v, s, N, α)
    x = (v, s, N, α, _param_tuple(form)...)
    T = promote_type(map(typeof, x)...)
    xd = _seed(ForwardDiff.Tag(_form_pullback, T), map(T, x))
    θd = Base.tail(Base.tail(Base.tail(Base.tail(xd))))
    fd = first(_rebuild_scalar(form, θd))
    y, s′ = forward(fd, Step(), xd[1], xd[2], xd[3], xd[4])
    g = _vjp(y, s′, grads.v, grads.s, xd)
    _add_scalar!(grads.piece, form, Base.tail(Base.tail(Base.tail(Base.tail(g)))), nothing)
    return g[1], g[2], g[3], g[4]
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

# The float scalars of `x` in the order `_getparams!` reads them, as a tuple,
# with the entry of each `_EntryParam` read at `at = (k, t)` (a zero for
# `at = nothing`, where only the types matter).
_param_tuple(x) = _param_tuple(x, nothing)
_param_tuple(x::AbstractFloat, at) = (x,)
_param_tuple(x::_EntryParam, at) = (_entry(x, at),)
_param_tuple(::_Leafless, at) = ()
_param_tuple(x::Union{Tuple, NamedTuple}, at) = _param_tuples(at, values(x)...)
function _param_tuple(x, at)
    isstructtype(typeof(x)) || return ()
    return _param_tuples(at, ntuple(i -> getfield(x, i), Val(fieldcount(typeof(x))))...)
end
_param_tuples(at) = ()
_param_tuples(at, x, xs...) = (_param_tuple(x, at)..., _param_tuples(at, xs...)...)
_entry(x, at::Tuple) = param(x, at...)
_entry(x::PerStratum, ::Nothing) = zero(eltype(x.x))
_entry(x::TimeVarying{<:Any, <:AbstractVector}, ::Nothing) = zero(eltype(x.x))
_entry(x::TimeVarying{<:Any, <:PerStratum}, ::Nothing) = zero(eltype(x.x.x))
_entry(x::TimeVarying{<:Any, <:_Piecewise}, ::Nothing) = zero(eltype(_array(x)))

# `_rebuild` and `_addparams!` for the tuple of scalars: each consumes the
# leading entries of `θ` or `g` and returns the rest, so the recursion over
# fields is resolved at compile time.
_rebuild_scalar(::Union{AbstractFloat, _EntryParam}, θ) = (first(θ), Base.tail(θ))
_rebuild_scalar(x::_Leafless, θ) = (x, θ)
_rebuild_scalar(::Tuple{}, θ) = ((), θ)
function _rebuild_scalar(x::Tuple, θ)
    a, θ = _rebuild_scalar(first(x), θ)
    b, θ = _rebuild_scalar(Base.tail(x), θ)
    return (a, b...), θ
end
function _rebuild_scalar(x::NamedTuple{N}, θ) where {N}
    y, θ = _rebuild_scalar(Tuple(x), θ)
    return NamedTuple{N}(y), θ
end
function _rebuild_scalar(x, θ)
    _param_tuple(x) === () && return x, θ
    fs = ntuple(i -> getfield(x, i), Val(fieldcount(typeof(x))))
    ys, θ = _rebuild_scalar(fs, θ)
    return constructorof(typeof(x))(ys...), θ
end

# Whether the local step's rebuild of `x` from its float scalars gives them
# back: each is seeded as a dual number with its own partial, `x` is
# rebuilt by `constructorof` and its scalars must come back unchanged. A
# keyword-only constructor, a field typed `Float64` or a constructor that
# transforms its arguments fails; the last would give a wrong gradient. A
# modifier with `_EntryParam`s gets a scalar in their place, so one step of
# the rebuild must also run, on the entries at stratum 1 and time 1: a step
# that indexes such a parameter's array fails. Checked once, when a
# `Recurrence` is built, for each part with float scalars.
function _check_rebuild(x)
    _scalar_params(x) || (ispointwise(x) && _local_params(x)) ||
        return ispointwise(x) ? _check_reads(x) : _check_rebuild(Val(false), x)
    return _check_rebuild(Val(true), x)
end
_check_rebuild(::Val{true}, x) = _check_rebuild(x, _param_tuple(x, (1, 1)))
function _check_rebuild(x, θ)
    T = promote_type(map(typeof, θ)...)
    θd = _seed(ForwardDiff.Tag(_check_rebuild, T), map(T, θ))
    return try
        xd = first(_rebuild_scalar(x, θd))
        _rebuilt_tuple(x, xd) === θd && _steps(x, xd, one(first(θd)))
    catch e
        e isa InterruptException && rethrow()
        false
    end
end
_steps(m, md, x) = _scalar_params(m) || (forward(md, Step(), x, x, 1, 1); true)
# A part with float arrays among its parameters, rebuilt as the local step
# does (`_rebuild_views`) from a vector of dual numbers, each with its own
# partial: the parameters read back must be those dual numbers.
function _check_rebuild(::Val{false}, x)
    θ = _params(x)
    T = eltype(θ)
    D = ForwardDiff.Dual{typeof(ForwardDiff.Tag(_check_rebuild, T)), T, 1}
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
# A pointwise modifier with other float arrays, rebuilt as its read step
# does: the scalars must come back unchanged, each array must stay its
# `_ReadArray`, and one step must run on the rebuild.
function _check_reads(x)
    θ = _param_tuple(x, (1, 1))
    T = float(promote_type(map(typeof, θ)..., param_eltype(x)))
    M = length(θ) + 2
    R = first(_READ_WIDTHS)
    D = ForwardDiff.Dual{typeof(ForwardDiff.Tag(_check_reads, T)), T, M + R}
    θd = ntuple(i -> D(T(θ[i]), _unit(T, i + 2, Val(M + R))), length(θ))
    return try
        xd = first(_rebuild_reads(x, θd, _ReadSeed{D}(_Reads{R}(), M), 1))
        _rebuilt_tuple(x, xd) === θd && _reads_kept(x, xd) &&
            (forward(xd, Step(), one(D), one(D), 1, 1); true)
    catch e
        e isa InterruptException && rethrow()
        false
    end
end
# Whether each float array of `x` (outside entry parameters) is a
# `_ReadArray` of itself in `y`.
_reads_kept(::Union{AbstractFloat, _EntryParam}, y) = true
_reads_kept(x::AbstractArray{<:AbstractFloat}, y) = y isa _ReadArray && y.x === x
_reads_kept(::_Leafless, y) = true
function _reads_kept(x::Union{Tuple, NamedTuple}, y)
    return all(map(_reads_kept, values(x), values(y)))
end
function _reads_kept(x, y)
    isstructtype(typeof(x)) || return true
    return all(i -> _reads_kept(getfield(x, i), getfield(y, i)), 1:fieldcount(typeof(x)))
end

# Write the leaves of `y`, a rebuild of `x`, where `_getparams!` reads `x`'s
# parameters, into `θ` after offset `o`; return the new offset.
_rebuilt_params!(θ, ::AbstractFloat, y, o) = (θ[o + 1] = y; o + 1)
function _rebuilt_params!(θ, x::AbstractArray{<:AbstractFloat}, y, o)
    size(y) == size(x) || return -1
    for (i, yi) in enumerate(y)
        θ[o + i] = yi
    end
    return o + length(x)
end
_rebuilt_params!(θ, ::_Leafless, y, o) = o
function _rebuilt_params!(θ, x::Union{Tuple, NamedTuple}, y, o)
    for (xi, yi) in zip(values(x), values(y))
        o < 0 && return o
        o = _rebuilt_params!(θ, xi, yi, o)
    end
    return o
end
function _rebuilt_params!(θ, x, y, o)
    isstructtype(typeof(x)) || return o
    for i in 1:fieldcount(typeof(x))
        o < 0 && return o
        o = _rebuilt_params!(θ, getfield(x, i), getfield(y, i), o)
    end
    return o
end
# The leaves of `y`, a rebuild of `x`, where `_param_tuple(x)` reads floats.
_rebuilt_tuple(::Union{AbstractFloat, _EntryParam}, y) = (y,)
_rebuilt_tuple(::_Leafless, y) = ()
_rebuilt_tuple(x::Union{Tuple, NamedTuple}, y) = _rebuilt_tuples(values(x), values(y))
function _rebuilt_tuple(x, y)
    isstructtype(typeof(x)) || return ()
    n = Val(fieldcount(typeof(x)))
    return _rebuilt_tuples(ntuple(i -> getfield(x, i), n), ntuple(i -> getfield(y, i), n))
end
_rebuilt_tuples(::Tuple{}, ys) = ()
function _rebuilt_tuples(xs::Tuple, ys)
    a = _rebuilt_tuple(first(xs), first(ys))
    return (a..., _rebuilt_tuples(Base.tail(xs), Base.tail(ys))...)
end

# Add the scalar gradients `g` into the mirror `x̄` of `x`, an entry
# parameter's at `at = (k, t)` through `add_param!`; returns the rest of `g`.
_add_scalar!(x̄, ::AbstractFloat, g, at) = (add_cotangent!(x̄, first(g)); Base.tail(g))
_add_scalar!(x̄, x::_EntryParam, g, at) = (add_param!(x̄, x, first(g), at...); Base.tail(g))
_add_scalar!(x̄, ::_Leafless, g, at) = g
_add_scalar!(x̄, ::Tuple{}, g, at) = g
function _add_scalar!(x̄, x::Tuple, g, at)
    g = _add_scalar!(x̄ === nothing ? nothing : first(x̄), first(x), g, at)
    return _add_scalar!(x̄ === nothing ? nothing : Base.tail(x̄), Base.tail(x), g, at)
end
function _add_scalar!(x̄, x::NamedTuple, g, at)
    return _add_scalar!(x̄ === nothing ? nothing : Tuple(x̄), Tuple(x), g, at)
end
function _add_scalar!(x̄, x, g, at)
    _param_tuple(x) === () && return g
    names = fieldnames(typeof(x))
    fs = ntuple(i -> getfield(x, i), Val(fieldcount(typeof(x))))
    m̄s = map(n -> _field_mirror(x̄, n), names)
    return _add_scalar!(m̄s, fs, g, at)
end

# Default initial-state pullback: a local `ForwardDiff` Jacobian of the Init,
# skipped for the default zero state and for a zero state cotangent (a
# modifier whose state never reaches the output), where the Jacobian over
# the whole history would cost more than the rest of the reverse pass.
function pullback!(grads, m, ::Init, s, history)
    _default_init(m, s, history) && return nothing
    m̄, s̄, h̄ = grads.piece, grads.s, grads.history
    all(iszero, s̄) && return nothing
    P = _nactive(m̄, m)
    nh = h̄ === nothing ? 0 : length(history)
    P + nh == 0 && return nothing
    x0 = P == 0 ? vec(history) : [_params(m); vec(history)]
    J = ForwardDiff.jacobian(x0) do x
        mm = P == 0 ? m : _rebuild(m, view(x, 1:P))
        hh = nh == 0 ? history : reshape(x[(P + 1):end], size(history))
        ss = similar(x, length(s))
        forward(mm, Init(), ss, hh)
        return ss
    end
    g = transpose(J) * s̄
    P == 0 || _addparams!(m̄, m, g, 0)
    nh == 0 || (h̄ .+= reshape(view(g, (P + 1):(P + nh)), size(history)))
    return nothing
end

# Whether modifier `m` uses the default zero initial state.
function _default_init(m, s, history)
    sig = Tuple{typeof(m), Init, typeof(s), typeof(history)}
    return which(forward, sig) === which(forward, Tuple{Any, Init, Any, Any})
end
