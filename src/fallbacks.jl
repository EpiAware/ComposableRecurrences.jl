# Default pullbacks for modifiers and couplings without a hand-written one:
# a local forward-mode derivative of that one step, including the
# parameters. The dual-number code is in the dual-number extension; here
# are the parameter walks it uses, and for each local derivative a method
# that says to load the extension when it is not.
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
    return _step_back(grads, m, v, s, t, k)
end

# Default scalar pullback of a pointwise modifier without its own: a local
# forward-mode derivative in the value, the state and the modifier's float
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

# The local derivatives, with their methods in the dual-number extension.
# Without it a call names the modifier or coupling and says to load it.
_value_pullback(m, args...) = _need_forwarddiff(m)
_jacobian_pullback(m, m̄, args...) = _need_forwarddiff(m)
_scalar_pullback(m, m̄, args...) = _need_forwarddiff(m)
_read_pullback(m, m̄, args...) = _need_forwarddiff(m)
_local_pressure!(p̄, C̄, C, args...) = _need_forwarddiff(C)
_array_pressure(C, args...) = _need_forwarddiff(C)
_local_form_pullback(grads, form, args...) = _need_forwarddiff(form)
_init_jacobian(m, args...) = _need_forwarddiff(m)
_dual_pressure_buffers(C̄, C, args...) = nothing
function _need_forwarddiff(piece)
    name = nameof(typeof(piece))
    return _need_forwarddiff("$name has no `pullback!`, and its local derivative")
end
function _need_forwarddiff(what::AbstractString)
    throw(ArgumentError("$what needs `ForwardDiff`: add `using ForwardDiff`"))
end

# The reads of a modifier's float arrays in one dual step, with room for
# `R` after the first `lo`: for each, the array (its position among them,
# `_rebuild_reads`'s leaf) and the linear index read. `n` counts every
# read, so `n > lo + R` marks a step that read more than the partials hold.
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
_ReadSeed{D}(reads::_Reads{R}, slot0) where {D, R} = _ReadSeed{D, R}(reads, slot0)

# A modifier's float array inside its read step: each entry read is a dual
# number of type `D`, with the next read partial set when the read is
# among those the pass seeds, and is recorded.
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
    # A field of abstract type (`Real`, a `Union`, or none) may hold a
    # float; the rebuild then goes by value.
    isconcretetype(T) || return true
    T <: Union{Real, Nothing, Symbol, AbstractString, Function, Type, Module} && return false
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
    return _add_reads!(x̄, x, Val(fieldnames(typeof(x))), leaf, i, g, l)
end
# Field by field, unrolled over the names so each field's type is known.
_add_reads!(x̄, x, ::Val{()}, leaf, i, g, l) = l
function _add_reads!(x̄, x, ::Val{N}, leaf, i, g, l) where {N}
    n = first(N)
    l = _add_read!(_field_mirror(x̄, n), getfield(x, n), leaf, i, g, l)
    return _add_reads!(x̄, x, Val(Base.tail(N)), leaf, i, g, l)
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

# The dual-number buffers of a coupling's local derivative, made once per
# reverse pass so a step allocates nothing: a pair of vectors for each
# number of partials, sized on first use; `nothing` for a coupling with its
# own pullback. A step whose dual type is not among them allocates its own.
function _pressure_buffers(C̄, C, Tp)
    return _pressure_buffers(Val(uses_adjoint(C, Pressure())), C̄, C, Tp)
end
_pressure_buffers(::Val{true}, C̄, C, Tp) = nothing
_pressure_buffers(::Val{false}, C̄, C, Tp) = _dual_pressure_buffers(C̄, C, Tp)
# The local step seeds the strata and the scalars `N` at a time, `N` the
# smallest of 4, 8, 12 and 24 that covers them. The rule takes this route
# while one pass covers every input (`_LOCAL_PRESSURE`), and through
# `_ad_wide` while two do (`_LOCAL_PRESSURE_WIDE`).
const _LOCAL_PRESSURE = 24
const _LOCAL_PRESSURE_WIDE = 2 * _LOCAL_PRESSURE
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
# The draw of a depletion form, `(v, s, N, α) -> (y, s′)`, and its pullback,
# which returns the cotangents of `(v, s, N, α)`: a built-in's kernel, or
# the form's `forward!` and `pullback!` on one-entry views of local slots,
# with `grads.N` and `grads.α` the views its pullback adds into.
@inline function _draw(form, v, s, N, α)
    T = promote_type(typeof(v), typeof(s), typeof(N), typeof(α), param_eltype(form))
    vr, sr = Ref{T}(v), Ref{T}(s)
    _written(form, @inline forward!(form, Step(), _At(vr, 1), _At(sr, 1), N, α))
    return vr[], sr[]
end
@inline function _draw_back(grads, form, v, s, N, α)
    z = zero(grads.v)
    v̄r, s̄r, N̄r, ᾱr = Ref(grads.v), Ref(grads.s), Ref(z), Ref(z)
    g = (;
        piece = grads.piece, v = _At(v̄r, 1), s = _At(s̄r, 1), N = _At(N̄r, 1),
        α = _At(ᾱr, 1),
    )
    _written(form, @inline pullback!(g, form, Step(), _At(Ref(v), 1), _At(Ref(s), 1), N, α))
    return v̄r[], s̄r[], N̄r[], ᾱr[]
end
# A depletion form's in-place step and pullback on views of a stratum's
# values and pools, with `N` and `α` shared, from its scalar kernel.
function _form_forward!(form, v, s, N, α)
    for i in eachindex(v, s)
        v[i], s[i] = _draw(form, v[i], s[i], N, α)
    end
    return nothing
end
function _form_pullback!(grads, form, v, s, N, α)
    for i in eachindex(v, s)
        g = (; piece = grads.piece, v = grads.v[i], s = grads.s[i])
        v̄, s̄, N̄, ᾱ = _draw_back(g, form, v[i], s[i], N, α)
        grads.v[i], grads.s[i] = v̄, s̄
        grads.N[i] += N̄
        grads.α[i] += ᾱ
    end
    return nothing
end
_form_adjoint(form) = uses_adjoint(form, Step()) || _scalar_params(form)
_form_adjoint(::Nothing) = true
function _form_pullback(grads, form, v, s, N, α)
    return _form_pullback(Val(uses_adjoint(form, Step())), grads, form, v, s, N, α)
end
function _form_pullback(::Val{true}, grads, form, v, s, N, α)
    return _draw_back(grads, form, v, s, N, α)
end
function _form_pullback(::Val{false}, grads, form, v, s, N, α)
    return _local_form_pullback(grads, form, v, s, N, α)
end
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
_check_rebuild(::Val{true}, x) = _check_scalars(x, _param_tuple(x, (1, 1)))
# A part with float arrays among its parameters, rebuilt as the local step
# does (`_rebuild_views`) from a vector of dual numbers, each with its own
# partial: the parameters read back must be those dual numbers.
_check_rebuild(::Val{false}, x) = _check_views(x)
# The checks rebuild with dual numbers, so are in the dual-number extension.
# Without it they return `nothing`: the part is unchecked, and the call
# checks it (`_fit`).
_check_scalars(x, args...) = nothing
_check_views(x, args...) = nothing
_probe_reads(x, args...) = nothing
_steps(m, md, x) = _scalar_params(m) || (_any_step(md, x); true)
# One step of a part rebuilt with dual numbers, a pointwise modifier's or a
# depletion form's.
_any_step(m, x) = _is_form(m) ? _draw(m, x, x, 1, 1) : _step(m, x, x, 1, 1)
# A pointwise modifier with other float arrays, rebuilt as its read step
# does: the scalars must come back unchanged, each array must stay its
# `_ReadArray`, and one step must run on the rebuild, reading at most
# `_READ_CAP` entries; above that plain AD is faster.
_check_reads(x) = _reads_within(_probe_reads(x))
_reads_within(::Nothing) = nothing
_reads_within(n::Int) = 0 <= n <= _READ_CAP
# Whether a part's read step reads more than `_READ_CAP` entries, as the
# reason it takes plain AD.
function _reads_too_many(x)
    (_scalar_params(x) || !ispointwise(x) || _local_params(x)) && return false
    n = _probe_reads(x)
    return n !== nothing && n > _READ_CAP
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

# Default initial-state pullback: a local forward-mode Jacobian of the Init,
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
    g = transpose(_init_jacobian(m, s, history, P, nh)) * s̄
    P == 0 || _addparams!(m̄, m, g, 0)
    nh == 0 || (h̄ .+= reshape(view(g, (P + 1):(P + nh)), size(history)))
    return nothing
end

# Whether modifier `m` uses the default zero initial state.
function _default_init(m, s, history)
    sig = Tuple{typeof(m), Init, typeof(s), typeof(history)}
    return which(forward!, sig) === which(forward!, Tuple{Any, Init, Any, Any})
end
