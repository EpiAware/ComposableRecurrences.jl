# Default pullbacks without a hand-written one: a local forward-mode
# derivative of one step. The dual-number code is in an extension; this file
# holds the parameter walks and methods that say to load it.

# == Parameter walks ==

# A parameter is a float leaf: a float scalar, a float array's entries (a
# view or reshape is rebuilt as an `Array`), a sparse matrix's nonzeros or a
# `Diagonal`'s diagonal.

# A walker defines `_fold_*`, `_mfold_*`, `_map_*` or `_collect_*` for its
# leaves; `_descends` picks the structs it enters and `_into_stored` whether
# it reads a sparse or `Diagonal` matrix's stored entries.
_descends(f, x) = _holds_floats(x)
_into_stored(f) = true
_fields(x) = ntuple(i -> getfield(x, i), Val(fieldcount(typeof(x))))
const _FloatArray = AbstractArray{<:AbstractFloat}
const _Stored = Union{
    SparseMatrixCSC{<:AbstractFloat}, Diagonal{<:AbstractFloat},
}
_stored(x::SparseMatrixCSC) = nonzeros(x)
_stored(x::Diagonal) = x.diag
_stored_name(::SparseMatrixCSC) = :nzval
_stored_name(::Diagonal) = :diag

# A fold of the state `s` over the leaves.
_lfold(f, x::AbstractFloat, s) = _fold_scalar(f, x, s)
_lfold(f, x::_FloatArray, s) = _fold_array(f, x, s)
_lfold(f, x::_Stored, s) = _lfold(f, _stored(x), s)
_lfold(f, x::_EntryParam, s) = _fold_entry(f, x, s)
_lfold(f, ::_Leafless, s) = s
_lfold(f, x::Union{Tuple, NamedTuple}, s) = _lfold_all(f, values(x), s)
_lfold(f, x, s) = _descends(f, x) ? _lfold_all(f, _fields(x), s) : s
_lfold_all(f, ::Tuple{}, s) = s
function _lfold_all(f, xs::Tuple, s)
    return _lfold_all(f, Base.tail(xs), _lfold(f, first(xs), s))
end
_fold_scalar(f, x, s) = s
_fold_array(f, x, s) = s
_fold_entry(f, x, s) = _lfold_all(f, _fields(x), s)

# The walks beside a mirror `x̄`: an element's mirror is the mirror's element,
# or `nothing`, and a field's is `_field_mirror`.
_mfold(f, x̄, x::AbstractFloat, s) = _mfold_scalar(f, x̄, x, s)
_mfold(f, x̄, x::_FloatArray, s) = _mfold_array(f, x̄, x, s)
function _mfold(f, x̄, x::_Stored, s)
    _into_stored(f) || return _mfold_array(f, x̄, x, s)
    return _mfold(f, cotangent(x̄, _stored_name(x)), _stored(x), s)
end
_mfold(f, x̄, x::_EntryParam, s) = _mfold_entry(f, x̄, x, s)
_mfold(f, x̄, ::_Leafless, s) = s
function _mfold(f, x̄, x::Union{Tuple, NamedTuple}, s)
    return _mfold_all(f, _element_mirrors(x̄, Val(length(x))), values(x), s)
end
_mfold(f, x̄, x, s) = _descends(f, x) ? _mfold_fields(f, x̄, x, s) : s
function _mfold_fields(f, x̄, x, s)
    m̄s = map(n -> _field_mirror(x̄, n), fieldnames(typeof(x)))
    return _mfold_all(f, m̄s, _fields(x), s)
end
_mfold_all(f, ::Tuple{}, ::Tuple{}, s) = s
function _mfold_all(f, x̄s::Tuple, xs::Tuple, s)
    s = _mfold(f, first(x̄s), first(xs), s)
    return _mfold_all(f, Base.tail(x̄s), Base.tail(xs), s)
end
_element_mirrors(::Nothing, ::Val{n}) where {n} = ntuple(_ -> nothing, Val(n))
_element_mirrors(x̄, ::Val{n}) where {n} = ntuple(i -> x̄[i], Val(n))
_mfold_scalar(f, x̄, x, s) = s
_mfold_array(f, x̄, x, s) = s
_mfold_entry(f, x̄, x, s) = _mfold_fields(f, x̄, x, s)

_remap(f, x::AbstractFloat, s) = _map_scalar(f, x, s)
_remap(f, x::_FloatArray, s) = _map_array(f, x, s)
# A stored matrix's entries reach `_map_array` as a `Vector`.
function _remap(f, x::SparseMatrixCSC{<:AbstractFloat}, s)
    _into_stored(f) || return _map_array(f, x, s)
    nz, s = _remap(f, nonzeros(x), s)
    return SparseMatrixCSC(size(x)..., copy(x.colptr), copy(x.rowval), nz), s
end
function _remap(f, x::Diagonal{<:AbstractFloat}, s)
    _into_stored(f) || return _map_array(f, x, s)
    d, s = _remap(f, x.diag, s)
    return Diagonal(d), s
end
_remap(f, x::_EntryParam, s) = _map_entry(f, x, s)
_remap(f, x::_Leafless, s) = (x, s)
_remap(f, ::Tuple{}, s) = ((), s)
function _remap(f, x::Tuple, s)
    a, s = _remap(f, first(x), s)
    b, s = _remap(f, Base.tail(x), s)
    return (a, b...), s
end
function _remap(f, x::NamedTuple{N}, s) where {N}
    y, s = _remap(f, Tuple(x), s)
    return NamedTuple{N}(y), s
end
_remap(f, x, s) = _remap_fields(f, x, s)
function _remap_fields(f, x, s)
    _descends(f, x) || return x, s
    ys, s = _remap(f, _fields(x), s)
    return constructorof(typeof(x))(ys...), s
end
_map_scalar(f, x, s) = (x, s)
_map_array(f, x, s) = (x, s)
_map_entry(f, x, s) = _remap_fields(f, x, s)

# A tuple of what the leaves give, a float array giving nothing.
_lcollect(f, x::AbstractFloat) = _collect_scalar(f, x)
_lcollect(f, x::_EntryParam) = _collect_entry(f, x)
_lcollect(f, ::_Leafless) = ()
_lcollect(f, x::Union{Tuple, NamedTuple}) = _collect_all(f, values(x)...)
_lcollect(f, x) = _descends(f, x) ? _collect_all(f, _fields(x)...) : ()
_collect_all(f) = ()
_collect_all(f, x, xs...) = (_lcollect(f, x)..., _collect_all(f, xs...)...)
_collect_scalar(f, x) = ()
_collect_entry(f, x) = _collect_all(f, _fields(x)...)

# The number of parameters of `x`.
struct _CountLeaves end
_nparams(x) = _lfold(_CountLeaves(), x, 0)
_fold_scalar(::_CountLeaves, x, n) = n + 1
_fold_array(::_CountLeaves, x, n) = n + length(x)

# The parameters of `x` as a vector.
function _params(x)
    θ = zeros(float(param_eltype(x)), _nparams(x))
    _getparams!(θ, x, 0)
    return θ
end

# Write the parameters of `x` into `θ` after offset `o`; return the new offset.
struct _ReadLeaves{V}
    θ::V
end
_getparams!(θ, x, o) = _lfold(_ReadLeaves(θ), x, o)
_fold_scalar(f::_ReadLeaves, x, o) = (f.θ[o + 1] = x; o + 1)
function _fold_array(f::_ReadLeaves, x, o)
    for (i, xi) in enumerate(x)
        f.θ[o + i] = xi
    end
    return o + length(x)
end

# `x` with its parameters read from `θ` (possibly Duals) after offset `o`;
# returns the new object and offset.
struct _CopyLeaves{V}
    θ::V
end
_rebuild(x, θ) = first(_rebuild(x, θ, 0))
_rebuild(x, θ, o) = _remap(_CopyLeaves(θ), x, o)
_map_scalar(f::_CopyLeaves, x, o) = (f.θ[o + 1], o + 1)
function _map_array(f::_CopyLeaves, x, o)
    n = length(x)
    return reshape(f.θ[(o + 1):(o + n)], size(x)), o + n
end

# `leaf!(x̄, x, g, o)` returns the new offset.
struct _WalkLeaves{F, G}
    leaf!::F
    g::G
end
function _walkparams!(leaf!::F, x̄, x, g, o) where {F}
    return _mfold(_WalkLeaves(leaf!, g), x̄, x, o)
end
_mfold_scalar(f::_WalkLeaves, x̄, x, o) = f.leaf!(x̄, x, f.g, o)
_mfold_array(f::_WalkLeaves, x̄, x, o) = f.leaf!(x̄, x, f.g, o)

# Add the gradient `g` (after offset `o`) into the mirror `x̄` of `x`;
# returns the new offset.
_addparams!(x̄, x, g, o) = _walkparams!(_add_leaf!, x̄, x, g, o)
_add_leaf!(x̄, ::AbstractFloat, g, o) = (add_cotangent!(x̄, g[o + 1]); o + 1)
function _add_leaf!(x̄, x::AbstractArray, g, o)
    n = length(x)
    x̄ === nothing || (x̄ .+= reshape(view(g, (o + 1):(o + n)), size(x)))
    return o + n
end
_field_mirror(x̄, n::Symbol) = cotangent(x̄, n)
_field_mirror(x̄, n::Integer) = x̄ === nothing ? nothing : x̄[n]

# The number of parameters to differentiate: none without a mirror.
_nactive(x̄, x) = x̄ === nothing ? 0 : _nparams(x)

# == Pointwise local pullback ==

# A pointwise modifier's scalar step pullback: its own when it uses one,
# else the local derivative.
function _step_pullback(grads, m, v, s, t, k)
    uses_adjoint(m, Step()) || return _local_pullback(grads, m, v, s, t, k)
    return _step_back(grads, m, v, s, t, k)
end

# Each case is its own method, so no variable is shared with a closure, which
# would box it and allocate on every step.
function _local_pullback(grads, m, v, s, t, k)
    m̄, v̄, s̄ = grads.piece, grads.v, grads.s
    if m̄ !== nothing
        _local_params(m) && return _scalar_pullback(m, m̄, v̄, s̄, v, s, t, k)
        _array_params(m) && return _read_pullback(m, m̄, v̄, s̄, v, s, t, k)
    end
    _nactive(m̄, m) == 0 && return _value_pullback(m, v̄, s̄, v, s, t, k)
    return _jacobian_pullback(m, m̄, v̄, s̄, v, s, t, k)
end

# The local derivatives, with their methods in the dual-number extension.
# Without it a call names the modifier or coupling and says to load it.
_value_pullback(m, args...) = _need_forwarddiff(m)
_jacobian_pullback(m, m̄, args...) = _need_forwarddiff(m)
_scalar_pullback(m, m̄, args...) = _need_forwarddiff(m)
_read_pullback(m, m̄, args...) = _need_forwarddiff(m)
_block_local_back(grads, m, args...) = _need_forwarddiff(m)
_local_pressure!(p̄, C̄, C, args...) = _need_forwarddiff(C)
_array_pressure(C, args...) = _need_forwarddiff(C)
_local_form_pullback(grads, form, args...) = _need_forwarddiff(form)
_init_jacobian(m, args...) = _need_forwarddiff(m)
_init_strata_back!(m̄, h̄, m, args...) = _need_forwarddiff(m)
_dual_pressure_buffers(C̄, C, args...) = nothing
function _need_forwarddiff(piece)
    name = nameof(typeof(piece))
    return _need_forwarddiff(
        "$name has no `pullback!`, and its local derivative"
    )
end
function _need_forwarddiff(what::AbstractString)
    throw(ArgumentError("$what needs `ForwardDiff`: add `using ForwardDiff`"))
end

# == Read steps ==

# `n` counts every read, so `n > lo + R` marks a step that read more than the
# partials hold.
const _READ_WIDTHS = (4, 8, 12)
const _READ_CAP = 2 * last(_READ_WIDTHS)
mutable struct _Reads{R}
    n::Int
    lo::Int
    leaf::NTuple{R, Int}
    index::NTuple{R, Int}
end
function _Reads{R}(lo = 0) where {R}
    return _Reads{R}(0, lo, ntuple(_ -> 0, Val(R)), ntuple(_ -> 0, Val(R)))
end

# The dual type of a read step, its record and the partials before the
# reads' (the value's, the state's and the scalars').
struct _ReadSeed{D, R}
    reads::_Reads{R}
    slot0::Int
end
function _ReadSeed{D}(reads::_Reads{R}, slot0) where {D, R}
    return _ReadSeed{D, R}(reads, slot0)
end

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
struct _ReadingLeaves{W}
    w::W
end
function _rebuild_reads(x, θ, w, l)
    y, (θ, l) = _remap(_ReadingLeaves(w), x, (θ, l))
    return y, θ, l
end
_map_scalar(::_ReadingLeaves, x, (θ, l)) = (first(θ), (Base.tail(θ), l))
_map_entry(::_ReadingLeaves, x, (θ, l)) = (first(θ), (Base.tail(θ), l))
function _map_array(f::_ReadingLeaves, x, (θ, l))
    return _ReadArray(x, l, f.w), (θ, l + 1)
end

# Whether a struct may hold a float scalar or float array anywhere in its
# fields, from its type alone, so a rebuild that skips one infers.
function _floats_in(::Type{T}) where {T}
    T <: AbstractFloat && return true
    if T <: AbstractArray
        return eltype(T) <: AbstractFloat || !isconcretetype(eltype(T))
    end
    # A field of abstract type (`Real`, a `Union`, or none) may hold a
    # float; the rebuild then goes by value.
    isconcretetype(T) || return true
    plain = Union{
        Real, Nothing, Symbol, AbstractString, Function, Type, Module,
    }
    T <: plain && return false
    isstructtype(T) || return false
    return any(_floats_in, fieldtypes(T))
end
@generated _holds_floats(x) = _floats_in(x)

# Add `g` at linear index `i` of the mirror of float array `leaf` of `x`, in
# `_rebuild_reads`'s numbering from `l`; returns the next leaf.
struct _AddReadLeaf{G}
    leaf::Int
    i::Int
    g::G
end
# The read step wraps a sparse or `Diagonal` matrix whole, as any other
# float array.
_into_stored(::Union{_ReadingLeaves, _AddReadLeaf}) = false
_add_read!(x̄, x, leaf, i, g, l) = _mfold(_AddReadLeaf(leaf, i, g), x̄, x, l)
_mfold_entry(::_AddReadLeaf, x̄, x, l) = l
function _mfold_array(f::_AddReadLeaf, x̄, x, l)
    l == f.leaf && add_cotangent!(x̄, f.g, f.i)
    return l + 1
end

# == Coupling pullback ==

function _pressure_back!(p̄, C̄, C, q̄, p, t, bufs = nothing)
    own = Val(uses_adjoint(C, Pressure()))
    return _pressure_back!(own, p̄, C̄, C, q̄, p, t, bufs)
end
function _pressure_back!(::Val{true}, p̄, C̄, C, q̄, p, t, bufs)
    pullback!((; piece = C̄, q = q̄, p = p̄), C, Pressure(), nothing, p, t)
    return nothing
end
function _pressure_back!(::Val{false}, p̄, C̄, C, q̄, p, t, bufs)
    if _array_seeds(C̄, C)
        # The reverse pass makes the buffers once (`_pressure_buffers`); a
        # direct call without them makes its own.
        b = bufs isa _ArrayPressure ? bufs : _array_pressure(C, eltype(p))
        return _local_pressure!(p̄, C̄, C, q̄, p, t, b)
    end
    return _local_pressure!(p̄, C̄, C, q̄, p, t, _pressure_scalars(C̄, C), bufs)
end
_pressure_scalars(C̄, C) = C̄ === nothing ? () : _param_tuple(C)
# Whether the local step seeds a coupling's float arrays as well as its
# scalars: only when the coupling is differentiated and holds any.
_array_seeds(C̄, C) = C̄ !== nothing && !_scalar_params(C)

# Made once per reverse pass so a step allocates nothing; `nothing` for a
# coupling with its own pullback. A step whose dual type is not among them
# allocates its own.
function _pressure_buffers(C̄, C, Tp)
    return _pressure_buffers(Val(uses_adjoint(C, Pressure())), C̄, C, Tp)
end
_pressure_buffers(::Val{true}, C̄, C, Tp) = nothing
_pressure_buffers(::Val{false}, C̄, C, Tp) = _dual_pressure_buffers(C̄, C, Tp)
# The rule takes this route while one pass covers every input, and
# `_ad_wide` while two do.
const _LOCAL_PRESSURE = 24
const _LOCAL_PRESSURE_WIDE = 2 * _LOCAL_PRESSURE
# Parameter arrays are views of one vector of dual numbers, so each pass
# reseeds them in place.
struct _ArrayPressure{T, L}
    θ::Vector{T}
    ḡ::Vector{T}
    lanes::L
end

# == Whole-step local derivative ==

# Seeded `N` at a time as a coupling's are, with float arrays as views of one
# vector of dual numbers. Without the dual-number extension there are none,
# and the step says to load it.
struct _StepDuals{T, L}
    v̄::Vector{T}
    s̄::Vector{T}
    θ::Vector{T}
    ḡ::Vector{T}
    lanes::L
    # Whether the step seeds only the entries it reads (`_reads_fewer`),
    # and how many the last step read: the next step's width.
    readstep::Bool
    reads::Base.RefValue{Int}
end
_step_duals(m̄, m, args...) = nothing
_local_step!(m̄, m, args...) = _need_forwarddiff(m)
# The reverse pass of a `Recurrence` passes its buffers in `grads.pass`; a
# direct call makes them.
function _local_step_back!(grads, m, v, s, t)
    pass = get(grads, :pass, nothing)
    b = _given_duals(pass, grads.piece, m, eltype(v), length(v))
    _local_step!(grads.piece, m, grads.v, grads.s, v, s, t, b)
    return nothing
end
_given_duals(b::_StepDuals, m̄, m, Tp, S) = b
_given_duals(::Any, m̄, m, Tp, S) = _step_duals(m̄, m, Tp, S)
# The buffers are shared by every step, and read nothing after the last.
_column(b::_StepDuals, t) = b
_finish_pass!(m̄, m, R, ::_StepDuals, τ0) = nothing

# Views rather than copies, so a change to `θ` reaches the rebuilt object. A
# sparse constructor takes only a `Vector`, so parts holding one keep to plain
# AD (`_has_structured_floats`).
struct _ViewLeaves{V}
    θ::V
end
_rebuild_views(x, θ) = first(_rebuild_views(x, θ, 0))
_rebuild_views(x, θ, o) = _remap(_ViewLeaves(θ), x, o)
_map_scalar(f::_ViewLeaves, x, o) = (f.θ[o + 1], o + 1)
function _map_array(f::_ViewLeaves, x, o)
    n = length(x)
    return reshape(view(f.θ, (o + 1):(o + n)), size(x)), o + n
end

# == Depletion form draws ==

# A form's own `pullback!` runs on one-entry views of local slots, with
# `grads.N` the view it adds into and `grads.piece` the form's mirror.
@inline function _draw(form, v, s, N)
    T = promote_type(typeof(v), typeof(s), typeof(N), param_eltype(form))
    vr, sr = Base.RefValue{T}(v), Base.RefValue{T}(s)
    _written(form, @inline forward!(form, Step(), _At(vr, 1), _At(sr, 1), N))
    return vr[], sr[]
end
@inline function _draw_back(grads, form, v, s, N)
    T = promote_type(
        typeof(grads.v), typeof(grads.s), typeof(v), typeof(s), typeof(N),
        param_eltype(form)
    )
    v̄r, s̄r = Base.RefValue{T}(grads.v), Base.RefValue{T}(grads.s)
    N̄r = Base.RefValue{T}(zero(T))
    g = (;
        piece = grads.piece, v = _At(v̄r, 1), s = _At(s̄r, 1), N = _At(N̄r, 1),
    )
    vv, sv = _At(Ref(v), 1), _At(Ref(s), 1)
    _written(form, @inline pullback!(g, form, Step(), vv, sv, N))
    return v̄r[], s̄r[], N̄r[]
end
_form_adjoint(form) = uses_adjoint(form, Step()) || _scalar_params(form)
function _form_pullback(grads, form, v, s, N)
    return _form_pullback(Val(uses_adjoint(form, Step())), grads, form, v, s, N)
end
function _form_pullback(::Val{true}, grads, form, v, s, N)
    return _draw_back(grads, form, v, s, N)
end
function _form_pullback(::Val{false}, grads, form, v, s, N)
    return _local_form_pullback(grads, form, v, s, N)
end
# An `_EntryParam` reads its entry at `at = (k, t)`, or a zero for
# `at = nothing`, where only the types matter.
struct _ScalarLeaves{A}
    at::A
end
_param_tuple(x, at = nothing) = _lcollect(_ScalarLeaves(at), x)
_collect_scalar(::_ScalarLeaves, x) = (x,)
_collect_entry(f::_ScalarLeaves, x) = (_entry(x, f.at),)
_entry(x, at::Tuple) = param(x, at...)
_entry(x::PerStratum, ::Nothing) = zero(eltype(x.x))
_entry(x::TimeVarying{<:Any, <:AbstractVector}, ::Nothing) = zero(eltype(x.x))
_entry(x::TimeVarying{<:Any, <:PerStratum}, ::Nothing) = zero(eltype(x.x.x))
_entry(x::TimeVarying{<:Any, <:_Piecewise}, ::Nothing) = zero(eltype(_array(x)))

# `x` with its float scalars, entry parameters included, taken from the
# tuple `θ`; returns the object and the rest of `θ`.
struct _CopyScalars end
_rebuild_scalar(x, θ) = _remap(_CopyScalars(), x, θ)
_map_scalar(::_CopyScalars, x, θ) = (first(θ), Base.tail(θ))
_map_entry(::_CopyScalars, x, θ) = (first(θ), Base.tail(θ))

# == Rebuild checks ==

# Seeded scalars must come back unchanged from `constructorof`: a keyword-only
# constructor, a `Float64` field or one that transforms its arguments fails
# (the last silently). A step on `_EntryParam` scalars must also run.
function _check_rebuild(x)
    _scalar_params(x) || (_entry_step(x) && _local_params(x)) ||
        return _strata_loop(x) ? _check_reads(x) :
        _whole_step(x) && _reads_step(x) ? _check_read_rebuild(x) :
        _check_rebuild(Val(false), x)
    return _check_rebuild(Val(true), x)
end
_check_rebuild(::Val{true}, x) = _check_scalars(x, _param_tuple(x, (1, 1)))
# A pointwise or blockwise modifier passes an `_EntryParam` as its entry at
# the stratum or group, and the step's time.
_entry_step(x) = _strata_loop(x) || _blocks(x) !== nothing
# The parameters read back must be the seeded dual numbers.
_check_rebuild(::Val{false}, x) = _check_views(x)
# The checks rebuild with dual numbers, so are in the dual-number extension.
# Without it they return `nothing`: the part is unchecked, and the call
# checks it (`_fit`).
_check_scalars(x, args...) = nothing
_check_views(x, args...) = nothing
_probe_reads(x, args...) = nothing
_check_read_rebuild(x, args...) = nothing
_probe_step_reads(m, S, args...) = 0
_steps(m, md, x) = _scalar_params(m) || (_any_step(md, x); true)
# One step of a part rebuilt with dual numbers: a pointwise modifier's, a
# blockwise modifier's first group or a depletion form's.
_any_step(m, x) = _any_step(_blocks(m), m, x)
_any_step(::Nothing, m, x) = _step(m, x, x, 1, 1)
function _any_step(::Val{B}, m, x) where {B}
    vs, ss = ntuple(_ -> x, Val(B[1])), ntuple(_ -> x, Val(B[2]))
    return _block_step(m, vs, ss, 1, 1)
end
_any_step(m::_FormPart, x) = _draw(m.form, x, x, 1)
# The scalars must come back unchanged, each array must stay its
# `_ReadArray`, and one step must read at most `_READ_CAP` entries; above that
# plain AD is faster.
_check_reads(x) = _reads_within(_probe_reads(x))
_reads_within(::Nothing) = nothing
_reads_within(n::Int) = 0 <= n <= _READ_CAP
# Whether a part's read step reads more than `_READ_CAP` entries, as the
# reason it takes plain AD.
function _reads_too_many(x)
    (_scalar_params(x) || !_strata_loop(x) || _local_params(x)) && return false
    n = _probe_reads(x)
    return n !== nothing && n > _READ_CAP
end
# Whether each float array of `x` (outside entry parameters) is a
# `_ReadArray` of itself in `y`.
_reads_kept(::Union{AbstractFloat, _EntryParam}, y) = true
function _reads_kept(x::AbstractArray{<:AbstractFloat}, y)
    return y isa _ReadArray && y.x === x
end
_reads_kept(::_Leafless, y) = true
function _reads_kept(x::Union{Tuple, NamedTuple}, y)
    return all(map(_reads_kept, values(x), values(y)))
end
function _reads_kept(x, y)
    isstructtype(typeof(x)) || return true
    kept(i) = _reads_kept(getfield(x, i), getfield(y, i))
    return all(kept, 1:fieldcount(typeof(x)))
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
function _rebuilt_tuple(x::Union{Tuple, NamedTuple}, y)
    return _rebuilt_tuples(values(x), values(y))
end
function _rebuilt_tuple(x, y)
    isstructtype(typeof(x)) || return ()
    n = Val(fieldcount(typeof(x)))
    xs, ys = ntuple(i -> getfield(x, i), n), ntuple(i -> getfield(y, i), n)
    return _rebuilt_tuples(xs, ys)
end
_rebuilt_tuples(::Tuple{}, ys) = ()
function _rebuilt_tuples(xs::Tuple, ys)
    a = _rebuilt_tuple(first(xs), first(ys))
    return (a..., _rebuilt_tuples(Base.tail(xs), Base.tail(ys))...)
end

# Add the scalar gradients `g` into the mirror `x̄` of `x`, an entry
# parameter's at `at = (k, t)` through `add_param!`; returns the rest of `g`.
struct _AddScalars{A}
    at::A
end
_add_scalar!(x̄, x, g, at) = _mfold(_AddScalars(at), x̄, x, g)
function _mfold_scalar(::_AddScalars, x̄, x, g)
    add_cotangent!(x̄, first(g))
    return Base.tail(g)
end
function _mfold_entry(f::_AddScalars, x̄, x, g)
    add_param!(x̄, x, first(g), f.at...)
    return Base.tail(g)
end
# Both scalar walks descend only into structs that hold float scalars.
_descends(::Union{_CopyScalars, _AddScalars}, x) = _param_tuple(x) !== ()

# == Init pullback ==

# Skipped for the default zero state and a zero cotangent, where the
# derivative in the whole history costs more than the rest of the pass. A
# pointwise modifier with per-stratum reads is differentiated per stratum.
function pullback!(grads, m, ::Init, s, history)
    _default_init(m, s, history) && return nothing
    m̄, s̄, h̄ = grads.piece, grads.s, grads.history
    all(iszero, s̄) && return nothing
    P = _nactive(m̄, m)
    nh = h̄ === nothing ? 0 : length(history)
    P + nh == 0 && return nothing
    if _strata_init(m, s, nh)
        return _init_strata_back!(m̄, h̄, m, s̄, s, history)
    end
    g = transpose(_init_jacobian(m, s, history, P, nh)) * s̄
    P == 0 || _addparams!(m̄, m, g, 0)
    nh == 0 || (h̄ .+= reshape(view(g, (P + 1):(P + nh)), size(history)))
    return nothing
end

# Per stratum needs a history of one row per stratum (`nh % length(s)`).
function _strata_init(m, s, nh)
    _strata_loop(m) && _local_params(m) || return false
    return nh % max(length(s), 1) == 0
end

# Cached per signature with its world age, so a method defined later is still
# seen; a lookup on every reverse pass cost more than a short run's gradient
# on Julia 1.13.
const _DEFAULT_INIT = Dict{Type, Tuple{UInt, Bool}}()
const _DEFAULT_INIT_LOCK = ReentrantLock()
function _default_init(m, s, history)
    sig = Tuple{typeof(m), Init, typeof(s), typeof(history)}
    world = Base.get_world_counter()
    hit = @lock _DEFAULT_INIT_LOCK get(_DEFAULT_INIT, sig, nothing)
    hit !== nothing && first(hit) == world && return last(hit)
    d = which(forward!, sig) === which(forward!, Tuple{Any, Init, Any, Any})
    @lock _DEFAULT_INIT_LOCK _DEFAULT_INIT[sig] = (world, d)
    return d
end
