# Enzyme reverse-mode rule for every operator with a `pullback!`: one
# varargs `augmented_primal`/`reverse` pair on the internal entry point
# `_ADLeaves{X}()(leaves...)`, which takes each leaf of the operator and its
# arguments as its own annotated argument. The leaves' shadows are read into
# the mirrors `pullback!` accumulates into, assembled along the leaves' field
# paths; scalar cotangents are returned for `Active` leaves.
module ComposableRecurrencesEnzymeExt

using ComposableRecurrences: PerStratum, Recurrence, Serial, _ADLeaves,
    _Current, _WithState, _check_secondary, _current, _fft_convolve!,
    _fft_convolve_back!, _is_leaf, _leaf_paths, _log_plain, _note_plain_type,
    _plain, _rebuild_flag, _rebuild_leaves, _route_forward!, _run_forward,
    _run_pullback!, _untraced
using Enzyme: Enzyme, EnzymeRules, Annotation, Const, Active, BatchDuplicated,
    BatchDuplicatedNoNeed, Duplicated, DuplicatedNoNeed, MixedDuplicated
using LinearAlgebra: Diagonal
using SparseArrays: SparseMatrixCSC, nonzeros, nzrange, rowvals

const _IEEEFloat = Union{Float16, Float32, Float64}
const _Inert = Union{
    Nothing, Integer, Symbol, AbstractArray{<:Integer},
    AbstractArray{<:AbstractArray{<:Integer}},
}

# The mirror of an annotated argument.
_ez(::Const) = nothing
_ez(a::Active) = _ezs(a.val, Enzyme.make_zero(a.val))
_ez(a::Union{Duplicated, DuplicatedNoNeed}) = _ezs(a.val, a.dval)
_ez(a::MixedDuplicated) = _ezs(a.val, a.dval[])

# The mirror of primal `x` from its shadow `dx`.
_ezs(x::_IEEEFloat, dx) = Ref(zero(x))
_ezs(::_Inert, dx) = nothing
_ezs(::Union{AbstractString, Char, Type, Module, Ptr}, dx) = nothing
# Under runtime activity a constant array's shadow is the primal itself.
_ezs(x::AbstractArray{<:_IEEEFloat}, dx::AbstractArray) = dx === x ? nothing : dx
# A kernel's columns: each column's mirror from its own shadow.
function _ezs(x::AbstractVector{<:AbstractVector{<:_IEEEFloat}}, dx::AbstractVector)
    return dx === x ? nothing : map(_ezs, x, dx)
end
function _ezs(x::SparseMatrixCSC, dx::SparseMatrixCSC)
    return (; nzval = _ezs(nonzeros(x), nonzeros(dx)))
end
_ezs(x::Diagonal, dx::Diagonal) = (; diag = _ezs(x.diag, dx.diag))
_ezs(x::Union{Tuple, NamedTuple}, dx) = map(_ezs, x, dx)
function _ezs(x, dx)
    names = fieldnames(typeof(x))
    return NamedTuple{names}(map(n -> _ezs(getfield(x, n), getfield(dx, n)), names))
end

# Whether a mirror holds a nonzero scalar cotangent.
_hasscalar(m::Base.RefValue) = !iszero(m[])
_hasscalar(m::Union{Tuple, NamedTuple}) = any(_hasscalar, values(m))
_hasscalar(m) = false

# The returned cotangent of an `Active` argument: its scalar leaves rebuilt.
_ez_ret(a::Active, m) = _addback(Enzyme.make_zero(a.val), m)
_ez_ret(a, m) = nothing

# Scalar cotangents of a `MixedDuplicated` argument are written back into its
# shadow. A `Duplicated` immutable shadow cannot take them, so refuse rather
# than drop them.
_ez_writeback!(a, m) = nothing
function _ez_writeback!(a::MixedDuplicated, m)
    a.dval[] = _addback(a.dval[], m)
    return nothing
end
function _ez_writeback!(a::Union{Duplicated, DuplicatedNoNeed}, m)
    _hasscalar(m) && throw(
        ArgumentError(
            "a Duplicated $(typeof(a.val)) has scalar float fields whose " *
                "cotangents Enzyme cannot receive; annotate it Active or " *
                "MixedDuplicated, or Const"
        )
    )
    return nothing
end

_addback(dx, m) = m === nothing ? dx : _addback1(dx, m)
_addback1(dx::Real, m::Base.RefValue) = dx + m[]
_addback1(dx::AbstractArray, m) = dx
_addback1(dx::Union{Tuple, NamedTuple}, m) = map(_addback, dx, m)
# The shadow rebuilt with the same type and new scalar fields, bypassing
# constructors (which may check or convert their arguments).
function _addback1(dx::T, m) where {T}
    fs = Any[_addback(getfield(dx, n), getfield(m, n)) for n in fieldnames(T)]
    return ccall(:jl_new_structv, Any, (Any, Ptr{Any}, UInt32), T, fs, length(fs))::T
end

# The plain-AD note logs only while Enzyme differentiates the call in
# reverse mode.
function EnzymeRules.forward(
        ::EnzymeRules.FwdConfig, ::Const{typeof(_note_plain_type)}, ::Type,
        args::Vararg{Annotation, N}
    ) where {N}
    return nothing
end
function EnzymeRules.augmented_primal(
        ::EnzymeRules.RevConfig, ::Const{typeof(_note_plain_type)}, ::Type,
        op::Annotation, args::Vararg{Annotation, N}
    ) where {N}
    _log_plain(op.val)
    return EnzymeRules.AugmentedReturn(nothing, nothing, nothing)
end
function EnzymeRules.reverse(
        ::EnzymeRules.RevConfig, ::Const{typeof(_note_plain_type)}, ::Type,
        tape, op::Annotation, args::Vararg{Annotation, N}
    ) where {N}
    return map(a -> a isa Active ? Enzyme.make_zero(a.val) : nothing, (op, args...))
end
# The `Recurrence` constructor's rebuild check returns a flag, and its
# rebuild with dual numbers (which may throw) is not differentiated.
EnzymeRules.inactive(::typeof(_rebuild_flag), args...) = nothing
# Nor is its check that only the kernel takes `Primary()` indexing.
EnzymeRules.inactive(::typeof(_check_secondary), args...) = nothing

# The executor carries no derivative. Forward mode and plain reverse mode
# (a `NoAdjoint` route) do not differentiate tasks or the scoped value
# lookup, so a call they trace runs serially whatever executor is set. The
# reverse rule below runs its forward pass as primal code, so it uses the
# set executor.
EnzymeRules.inactive_type(::Type{_Current}) = true
function EnzymeRules.forward(
        config::EnzymeRules.FwdConfig, ::Const{typeof(_current)}, ::Type{<:Const}
    )
    return EnzymeRules.needs_primal(config) ? _Current(Serial()) : nothing
end
function EnzymeRules.augmented_primal(
        config::EnzymeRules.RevConfig, ::Const{typeof(_current)}, ::Type{<:Const}
    )
    primal = EnzymeRules.needs_primal(config) ? _Current(Serial()) : nothing
    return EnzymeRules.AugmentedReturn(primal, nothing, nothing)
end
function EnzymeRules.reverse(
        ::EnzymeRules.RevConfig, ::Const{typeof(_current)}, ::Type{<:Const}, tape
    )
    return ()
end

# Code Enzyme traces is not run as primal code, so a convolution it traces
# takes the direct method, which it can differentiate.
# The routes differ by Julia version. On 1.12 Enzyme calls these rules, so
# traced code takes the direct method, the faster one for short kernels. On
# 1.11 it runs a call that returns a `Bool` as it is, without its rule, so
# traced code takes the transform through the rules of `_fft_convolve!`
# below. 1.12 also skips these rules once the call has a constant argument,
# so they are kept as they are, with no arguments.
function EnzymeRules.forward(
        config::EnzymeRules.FwdConfig, ::Const{typeof(_untraced)}, ::Type{<:Const}
    )
    return EnzymeRules.needs_primal(config) ? false : nothing
end
function EnzymeRules.augmented_primal(
        config::EnzymeRules.RevConfig, ::Const{typeof(_untraced)}, ::Type{<:Const}
    )
    primal = EnzymeRules.needs_primal(config) ? false : nothing
    return EnzymeRules.AugmentedReturn(primal, nothing, nothing)
end
function EnzymeRules.reverse(
        ::EnzymeRules.RevConfig, ::Const{typeof(_untraced)}, ::Type{<:Const}, tape
    )
    return ()
end

# Traced code that reaches the transform (see the `_untraced` rules above)
# is differentiated by these rules, without tracing its FFTW calls. The lag
# sum `Y += c ⋆ X` is linear in the kernel `c` and in the input `X`, so its
# tangent is `Ẏ += ċ ⋆ X + c ⋆ Ẋ` and its reverse pass is the transform's
# own.

# The `i`th shadow of an argument, or `nothing` when it has none. Under
# runtime activity an inactive argument can come as its own shadow, which
# must neither carry a tangent nor take a cotangent. An `Active` kernel (an
# immutable vector) has no shadow: its cotangent is returned instead.
_lane(::Union{Const, Active}, i) = nothing
_lane(a::Union{Duplicated, DuplicatedNoNeed}, i) = _live(a.dval, a.val)
function _lane(a::Union{BatchDuplicated, BatchDuplicatedNoNeed}, i)
    return _live(a.dval[i], a.val)
end
function _lane(a::Annotation, i)
    throw(
        ArgumentError(
            "the FFT convolution rules take a Const, Active, Duplicated or " *
                "BatchDuplicated argument; got $(nameof(typeof(a)))"
        )
    )
end
_live(dv, v) = _aliases(dv, v) ? nothing : dv
_aliases(dv, v) = dv === v
_aliases(dv::PerStratum, v::PerStratum) = dv.x === v.x

# The shadow returned for the output buffer `Y`: zero if it is constant.
_out_shadow(Y::Const, w) = w == 1 ? zero(Y.val) : ntuple(_ -> zero(Y.val), w)
_out_shadow(Y, w) = Y.dval

# A mutable mirror of the kernel for its cotangent, and the cotangent of an
# `Active` kernel rebuilt from it in the kernel's own type.
_kernel_mirror(c::AbstractVector) = zeros(eltype(c), length(c))
_kernel_mirror(c::PerStratum) = PerStratum(zeros(eltype(c.x), size(c.x)))
_kernel_cotangent(c::AbstractVector, k̄) = convert(typeof(c), k̄)
_kernel_cotangent(c::PerStratum, k̄) = PerStratum(convert(typeof(c.x), k̄.x))

function EnzymeRules.forward(
        config::EnzymeRules.FwdConfig, ::Const{typeof(_fft_convolve!)},
        ::Type, Y::Annotation, kernel::Annotation, X::Annotation,
        m::Const, start::Const
    )
    w = EnzymeRules.width(config)
    for i in 1:w
        dY, dk, dX = _lane(Y, i), _lane(kernel, i), _lane(X, i)
        dY === nothing && continue
        dX === nothing || _fft_convolve!(dY, kernel.val, dX, m.val, start.val)
        dk === nothing || _fft_convolve!(dY, dk, X.val, m.val, start.val)
    end
    _fft_convolve!(Y.val, kernel.val, X.val, m.val, start.val)
    p, s = EnzymeRules.needs_primal(config), EnzymeRules.needs_shadow(config)
    s || return p ? Y.val : nothing
    dY = _out_shadow(Y, w)
    p || return dY
    return w == 1 ? Duplicated(Y.val, dY) : BatchDuplicated(Y.val, dY)
end

function EnzymeRules.augmented_primal(
        config::EnzymeRules.RevConfig, ::Const{typeof(_fft_convolve!)},
        ::Type, Y::Annotation, kernel::Annotation, X::Annotation,
        m::Const, start::Const
    )
    _fft_convolve!(Y.val, kernel.val, X.val, m.val, start.val)
    # The reverse pass reads the kernel and the input: keep copies if later
    # code overwrites them.
    ow = EnzymeRules.overwritten(config)
    c = ow[3] ? deepcopy(kernel.val) : nothing
    tape = (c, ow[4] ? copy(X.val) : nothing)
    p = EnzymeRules.needs_primal(config) ? Y.val : nothing
    s = EnzymeRules.needs_shadow(config) ?
        _out_shadow(Y, EnzymeRules.width(config)) : nothing
    return EnzymeRules.AugmentedReturn(p, s, tape)
end

function EnzymeRules.reverse(
        config::EnzymeRules.RevConfig, ::Const{typeof(_fft_convolve!)},
        ::Type, tape, Y::Annotation, kernel::Annotation, X::Annotation,
        m::Const, start::Const
    )
    c = something(tape[1], kernel.val)
    Xv = something(tape[2], X.val)
    w = EnzymeRules.width(config)
    k̄s = kernel isa Active ? ntuple(_ -> _kernel_mirror(c), w) : nothing
    # The input cotangent of a constant input is not needed: one buffer
    # takes it for every lane.
    sink = nothing
    for i in 1:w
        Ȳ, X̄ = _lane(Y, i), _lane(X, i)
        k̄ = k̄s === nothing ? _lane(kernel, i) : k̄s[i]
        (Ȳ === nothing || (k̄ === nothing && X̄ === nothing)) && continue
        if X̄ === nothing
            sink === nothing && (sink = zero(Xv))
            X̄ = sink
        end
        _fft_convolve_back!(X̄, k̄, c, Xv, Ȳ, m.val, start.val)
    end
    k̄ = k̄s === nothing ? nothing :
        w == 1 ? _kernel_cotangent(c, only(k̄s)) :
        map(b -> _kernel_cotangent(c, b), k̄s)
    return (nothing, k̄, nothing, nothing, nothing)
end

# The reverse pass of the transform runs inside the rules, as primal code.
# Its rules keep Enzyme from differentiating its FFTW calls if traced code
# ever reaches it.
const _FFT_TRACED = "the reverse pass of an FFT convolution was reached " *
    "from AD-traced code"
function EnzymeRules.forward(
        ::EnzymeRules.FwdConfig, ::Const{typeof(_fft_convolve_back!)}, ::Type,
        args::Vararg{Annotation, N}
    ) where {N}
    throw(ErrorException(_FFT_TRACED))
end
function EnzymeRules.augmented_primal(
        ::EnzymeRules.RevConfig, ::Const{typeof(_fft_convolve_back!)}, ::Type,
        args::Vararg{Annotation, N}
    ) where {N}
    throw(ErrorException(_FFT_TRACED))
end
function EnzymeRules.reverse(
        ::EnzymeRules.RevConfig, ::Const{typeof(_fft_convolve_back!)}, ::Type,
        tape, args::Vararg{Annotation, N}
    ) where {N}
    throw(ErrorException(_FFT_TRACED))
end

# The mirrors of the operator and its arguments, assembled from the leaves'
# mirrors `ms` along the leaf paths of `X`, as `_ezs` builds them. An
# operator or argument whose leaves are all `Const` mirrors as `nothing`.
@generated function _assemble(::Type{X}, ::Type{A}, ms::Tuple) where {X, A}
    k = Ref(0)
    function build(T)
        _is_leaf(T) && return :(ms[$(k[] += 1)])
        T === Nothing && return :nothing
        parts = [build(fieldtype(T, i)) for i in 1:fieldcount(T)]
        T <: Tuple && return :(($(parts...),))
        return :(NamedTuple{$(fieldnames(T))}(($(parts...),)))
    end
    tops = map(fieldtypes(X)) do T
        n = length(_leaf_paths(T))
        consts = all(i -> fieldtype(A, k[] + i) <: Const, 1:n)
        consts ? (k[] += n; :nothing) : build(T)
    end
    return :(($(tops...),))
end

# The primal and shadow are typed by the return annotation, which is the
# inferred return type of `_ADLeaves` and may be abstract.
function EnzymeRules.augmented_primal(
        config::EnzymeRules.RevConfig, ::Const{_ADLeaves{X}},
        ::Type{RA}, leaves::Vararg{Annotation, N}
    ) where {X, RA <: Annotation, N}
    EnzymeRules.width(config) == 1 ||
        throw(ArgumentError("batched Enzyme reverse mode is not supported"))
    y, cache = _run_forward(_rebuild_leaves(X, map(a -> a.val, leaves))...)
    dy = EnzymeRules.needs_shadow(config) ? Enzyme.make_zero(y) : nothing
    ret = EnzymeRules.needs_primal(config) ? y : nothing
    R = eltype(RA)
    P = EnzymeRules.needs_primal(config) ? R : Nothing
    D = EnzymeRules.needs_shadow(config) ? R : Nothing
    tape = (cache, y, dy)
    return EnzymeRules.AugmentedReturn{P, D, typeof(tape)}(ret, dy, tape)
end

function EnzymeRules.reverse(
        ::EnzymeRules.RevConfig, ::Const{_ADLeaves{X}}, ::Type{<:Annotation},
        tape, leaves::Vararg{Annotation, N}
    ) where {X, N}
    cache, y, dy = tape
    dy === nothing && return map(_ -> nothing, leaves)
    lms = map(_ez, leaves)
    ms = _assemble(X, typeof(leaves), lms)
    grads = (; piece = first(ms), y = _ezs(y, dy), args = Base.tail(ms))
    _run_pullback!(grads, _rebuild_leaves(X, map(a -> a.val, leaves))[1], cache)
    foreach(_ez_writeback!, leaves, lms)
    return map(_ez_ret, leaves, lms)
end

# Plain Enzyme reverse AD of a sparse coupling's products in a loop gives
# wrong gradients, so `NoAdjoint` on an active sparse coupling is refused:
# the recurrence's coupling here, and a route coupling at its own step
# below.
const _SparseRec = Recurrence{<:Any, <:SparseMatrixCSC}
const _SparseOp = Union{_SparseRec, _WithState{<:_SparseRec}}
const _ActiveSparse = Union{
    Duplicated{<:_SparseOp}, DuplicatedNoNeed{<:_SparseOp},
    MixedDuplicated{<:_SparseOp},
}
const _SPARSE_MSG = "plain Enzyme reverse AD of a sparse coupling gives " *
    "wrong gradients; drop NoAdjoint so the analytic rule runs"

function EnzymeRules.augmented_primal(
        ::EnzymeRules.RevConfig, ::Const{typeof(_plain)}, ::Type{<:Annotation},
        op::_ActiveSparse, args::Vararg{Annotation, N}
    ) where {N}
    throw(ArgumentError(_SPARSE_MSG))
end
function EnzymeRules.reverse(
        ::EnzymeRules.RevConfig, ::Const{typeof(_plain)}, ::Type{<:Annotation},
        tape, op::_ActiveSparse, args::Vararg{Annotation, N}
    ) where {N}
    throw(ArgumentError(_SPARSE_MSG))
end

# A route's coupled pressure `w = C z`, which only plain AD differentiates.
# Under runtime activity a constant coupling arrives with its primal as
# its shadow; its reverse pass is `z̄ += Cᵀ w̄`, and `w̄` is cleared because
# the step overwrites `w`. An active one is refused.
const _ActiveSparseMatrix = Union{
    Duplicated{<:SparseMatrixCSC}, DuplicatedNoNeed{<:SparseMatrixCSC},
    MixedDuplicated{<:SparseMatrixCSC},
}
_shadow(C::MixedDuplicated) = C.dval[]
_shadow(C) = C.dval
_check_constant(C) = _shadow(C) === C.val || throw(ArgumentError(_SPARSE_MSG))
function EnzymeRules.augmented_primal(
        ::EnzymeRules.RevConfig, ::Const{typeof(_route_forward!)}, ::Type{<:Annotation},
        C::_ActiveSparseMatrix, w::Annotation, z::Annotation, τ::Annotation
    )
    _check_constant(C)
    _route_forward!(C.val, w.val, z.val, τ.val)
    return EnzymeRules.AugmentedReturn(nothing, nothing, nothing)
end
function EnzymeRules.reverse(
        ::EnzymeRules.RevConfig, ::Const{typeof(_route_forward!)}, ::Type{<:Annotation},
        tape, C::_ActiveSparseMatrix, w::Annotation, z::Annotation, τ::Annotation
    )
    _check_constant(C)
    _sparse_transpose_back!(C.val, w, z)
    return (nothing, nothing, nothing, nothing)
end
# A buffer whose shadow is its primal is constant under runtime activity.
_active(x::Const) = false
_active(x) = x.dval !== x.val
function _sparse_transpose_back!(K, w, z)
    _active(w) || return nothing
    w̄ = w.dval
    if _active(z)
        z̄ = z.dval
        rows, vals = rowvals(K), nonzeros(K)
        for b in axes(K, 2), idx in nzrange(K, b)
            z̄[b] += vals[idx] * w̄[rows[idx]]
        end
    end
    fill!(w̄, zero(eltype(w̄)))
    return nothing
end

end
