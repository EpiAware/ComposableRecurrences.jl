# Mooncake reverse-mode rule for every operator with a `pullback!`: one
# primitive on the internal entry point `_ad(op, args...)`. Tangents are read
# into the mirrors `pullback!` accumulates into, and scalar cotangents are
# returned as rdata.
module ComposableRecurrencesMooncakeExt

using ADTypes: AutoMooncake
using ComposableRecurrences: ComposableRecurrences, Run, Serial, _Current, _ad,
    _current, _note_plain_type, _run_forward, _run_pullback!
using LinearAlgebra: axpy!
using Mooncake: Mooncake, CoDual, NoFData, NoRData, primal, tangent
using Random: Xoshiro

const _IEEEFloat = Union{Float16, Float32, Float64}
const _Inert = Union{Nothing, Integer, Symbol, AbstractArray{<:Integer}}

# The mirror of primal `x` from its fdata `dx`.
_mc(x::_IEEEFloat, dx) = Ref(zero(x))
_mc(x::_IEEEFloat, ::NoFData) = Ref(zero(x))
_mc(x::_IEEEFloat, ::Mooncake.FData) = Ref(zero(x))
_mc(::_Inert, dx) = nothing
_mc(::_Inert, ::NoFData) = nothing
_mc(::_Inert, ::Mooncake.FData) = nothing
_mc(x::Array{<:_IEEEFloat}, dx::Array) = dx
_mc(x::SubArray, dx::Mooncake.FData) = _view(_mc(parent(x), dx.data.parent), x)
function _mc(x::Base.ReshapedArray, dx::Mooncake.FData)
    return _reshape(_mc(parent(x), dx.data.parent), x)
end
_mc(x::Union{Tuple, NamedTuple}, dx::Union{Tuple, NamedTuple}) = map(_mc, x, dx)
_mc(x::Union{Tuple, NamedTuple}, ::NoFData) = map(xi -> _mc(xi, NoFData()), x)
_mc(x, dx::Mooncake.FData) = _mc_struct(x, n -> getfield(dx.data, n))
_mc(x, ::NoFData) = _mc_struct(x, _ -> NoFData())
function _mc_struct(x, df)
    names = fieldnames(typeof(x))
    return NamedTuple{names}(map(n -> _mc(getfield(x, n), df(n)), names))
end
_view(::Nothing, x) = nothing
_view(p, x) = view(p, x.indices...)
_reshape(::Nothing, x) = nothing
_reshape(p, x) = reshape(p, size(x))

# The rdata of primal `x` from its mirror: only scalar leaves carry any.
function _rd(x, m)
    R = Mooncake.rdata_type(Mooncake.tangent_type(typeof(x)))
    R === NoRData && return NoRData()
    return _rd_nz(x, m)
end
_rd_nz(x::_IEEEFloat, m::Base.RefValue) = m[]
_rd_nz(x::Union{Tuple, NamedTuple}, m) = map(_rd, x, m)
function _rd_nz(x, m)
    names = fieldnames(typeof(x))
    rd = map(n -> _rd(getfield(x, n), getfield(m, n)), names)
    return Mooncake.RData(NamedTuple{names}(rd))
end

# Plain Mooncake AD of a convolution: BLAS `axpy!` per lag, which Mooncake
# differentiates with one rule, instead of tracing the native loop.
Mooncake.@mooncake_overlay function ComposableRecurrences._axpy!(
        α::T, x::StridedVector{T}, y::StridedVector{T}
    ) where {T <: Union{Float32, Float64}}
    return axpy!(α, x, y)
end

Mooncake.@zero_derivative Mooncake.DefaultCtx Tuple{typeof(_note_plain_type), Any}

# Reading the `EXECUTOR` scoped value walks task-local state Mooncake cannot
# differentiate, and the executor carries no derivative. Forward mode and
# plain reverse mode (a `NoAdjoint` route) do not differentiate tasks, so a
# call they trace runs serially whatever executor is set. The native rule
# above runs its forward pass as primal code, so it uses the set executor.
Mooncake.@is_primitive Mooncake.DefaultCtx Tuple{typeof(_current)}
function Mooncake.frule!!(::Mooncake.Dual{typeof(_current)})
    return Mooncake.zero_dual(_Current(Serial()))
end
function Mooncake.rrule!!(f::CoDual{typeof(_current)})
    return Mooncake.zero_fcodual(_Current(Serial())), Mooncake.NoPullback(f)
end

Mooncake.@is_primitive(
    Mooncake.DefaultCtx, Mooncake.ReverseMode, Tuple{typeof(_ad), Vararg}
)

function Mooncake.rrule!!(::CoDual{typeof(_ad)}, args::Vararg{CoDual, N}) where {N}
    ps = map(primal, args)
    y, cache = _run_forward(ps...)
    # A scalar leaf in the output would carry rdata this rule drops.
    Mooncake.rdata_type(Mooncake.tangent_type(typeof(y))) === NoRData || throw(
        ArgumentError("an operator output with scalar float leaves is not supported")
    )
    ydual = Mooncake.zero_fcodual(y)
    function _ad_pullback(::NoRData)
        ms = map(a -> _mc(primal(a), tangent(a)), args)
        grads = (; piece = first(ms), y = _mc(y, tangent(ydual)), args = Base.tail(ms))
        _run_pullback!(grads, first(ps), cache)
        return (NoRData(), map((a, m) -> _rd(primal(a), m), args, ms)...)
    end
    return ydual, _ad_pullback
end

function ComposableRecurrences.test_adjoint(
        ::AutoMooncake, op, ::Run, args...; rng = Xoshiro(1), kwargs...
    )
    return Mooncake.TestUtils.test_rule(
        rng, _ad, op, args...; is_primitive = true, perf_flag = :none,
        unsafe_perturb = true, mode = Mooncake.ReverseMode, kwargs...
    )
end

end
