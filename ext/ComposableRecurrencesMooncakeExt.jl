# Mooncake reverse-mode rule for every operator with a `pullback!`: one
# primitive on the internal entry point `_ad(op, args...)`. Tangents are read
# into the mirrors `pullback!` accumulates into, and scalar cotangents are
# returned as rdata.
module ComposableRecurrencesMooncakeExt

using ADTypes: AutoMooncake
using ComposableRecurrences: ComposableRecurrences, Run, Serial, _Current, _ad,
    _ad_wide, _depletion, _check_form, _check_now, _check_parts,
    _check_secondary,
    _convolve_masses, _convolve_masses_back!, _current,
    _fft_convolve!, _fft_convolve_back!, _fit, _flat_groups, _hooked_plain,
    _movement, _movement_back!, _plain_hook, _route, _run_forward,
    _run_pullback!, _untraced
using ComposableRecurrences: Flow, Floor, Hazard, Truncate
using LinearAlgebra: axpy!
using Mooncake: Mooncake, CoDual, NoFData, NoRData, primal, tangent
using Random: Xoshiro

const _IEEEFloat = Union{Float16, Float32, Float64}
const _Inert = Union{
    Nothing, Integer, Symbol, AbstractArray{<:Integer},
    AbstractArray{<:AbstractArray{<:Integer}},
}

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
# A kernel's columns: each column's mirror from its own tangent. The fdata
# of an array of arrays holds each element's full tangent, which for a view
# is read as its fdata.
_mc(x::AbstractVector{<:AbstractVector{<:_IEEEFloat}}, dx::AbstractVector) = map(_mc, x, dx)
_mc(x::SubArray{<:_IEEEFloat}, dx::Mooncake.Tangent) = _mc(x, Mooncake.fdata(dx))
_mc(x::Union{Tuple, NamedTuple}, ::NoFData) = map(xi -> _mc(xi, NoFData()), x)
_mc(x, dx::Mooncake.FData) = _mc_struct(x, n -> getfield(dx.data, n))
_mc(x, ::NoFData) = _mc_struct(x, _ -> NoFData())
# Unrolled over the field names, so each field is read with a constant name
# and a struct whose fields differ in type builds its mirror without boxing.
@generated function _mc_struct(x, df)
    names = fieldnames(x)
    fs = [:(_mc(getfield(x, $(QuoteNode(n))), df($(QuoteNode(n))))) for n in names]
    return :(NamedTuple{$names}(($(fs...),)))
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
@generated function _rd_nz(x, m)
    names = fieldnames(x)
    fs = [
        :(_rd(getfield(x, $(QuoteNode(n))), getfield(m, $(QuoteNode(n)))))
            for n in names
    ]
    return :(Mooncake.RData(NamedTuple{$names}(($(fs...),))))
end

# Plain Mooncake AD of a convolution: BLAS `axpy!` per lag, which Mooncake
# differentiates with one rule, instead of tracing the native loop.
Mooncake.@mooncake_overlay function ComposableRecurrences._axpy!(
        α::T, x::StridedVector{T}, y::StridedVector{T}
    ) where {T <: Union{Float32, Float64}}
    return axpy!(α, x, y)
end
Mooncake.@mooncake_overlay function ComposableRecurrences._axpy4!(
        α₀::T, α₁::T, α₂::T, α₃::T, x₀::StridedVector{T}, x₁::StridedVector{T},
        x₂::StridedVector{T}, x₃::StridedVector{T}, y::StridedVector{T}
    ) where {T <: Union{Float32, Float64}}
    axpy!(α₀, x₀, y)
    axpy!(α₁, x₁, y)
    axpy!(α₂, x₂, y)
    return axpy!(α₃, x₃, y)
end

# The `Recurrence` constructor's checks of its parts, which rebuild them
# with dual numbers and may log, are not differentiated.
Mooncake.@zero_derivative Mooncake.DefaultCtx Tuple{
    typeof(_check_parts), Any, Any, Tuple,
}
# Nor is the same check run by the call of an operator built before
# ForwardDiff was loaded.
Mooncake.@zero_derivative Mooncake.DefaultCtx Tuple{typeof(_check_now), Any}
# Nor is its check that only the kernel takes `Primary()` indexing.
Mooncake.@zero_derivative Mooncake.DefaultCtx Tuple{
    typeof(_check_secondary), Any, Tuple,
}
# Nor is the `Depletion` constructor's check that its form has a step: its
# method lookups carry no derivative, and traced they cost more than the
# rest of a short run's gradient.
Mooncake.@zero_derivative Mooncake.DefaultCtx Tuple{typeof(_check_form), Any}
# Nor is the `Allocate` constructor's check and flattening of its groups,
# which handles only integers.
Mooncake.@zero_derivative Mooncake.DefaultCtx Tuple{typeof(_flat_groups), Any}
# The route a call takes, read from the sizes of its parts, carries no
# derivative either. Traced, its walk over a part's fields dispatches on
# each field's type, and for a field that is a view Julia 1.13 crashed
# compiling the derived rule.
Mooncake.@zero_derivative Mooncake.DefaultCtx Tuple{typeof(_fit), Vararg}
# The plain-AD hook carries no derivative.
Mooncake.@is_primitive Mooncake.DefaultCtx Tuple{typeof(_plain_hook), Vararg}
function Mooncake.frule!!(
        ::Mooncake.Dual{typeof(_plain_hook)}, args::Vararg{Mooncake.Dual, N}
    ) where {N}
    return Mooncake.zero_dual(nothing)
end
function Mooncake.rrule!!(
        f::CoDual{typeof(_plain_hook)}, args::Vararg{CoDual, N}
    ) where {N}
    return Mooncake.zero_fcodual(nothing), Mooncake.NoPullback(f, args...)
end

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

# Code Mooncake traces is not run as primal code, so a convolution it traces
# takes the direct method, which it can differentiate.
Mooncake.@is_primitive Mooncake.DefaultCtx Tuple{typeof(_untraced)}
function Mooncake.frule!!(::Mooncake.Dual{typeof(_untraced)})
    return Mooncake.zero_dual(false)
end
function Mooncake.rrule!!(f::CoDual{typeof(_untraced)})
    return Mooncake.zero_fcodual(false), Mooncake.NoPullback(f)
end
# The transforms are never reached from traced code, which `_untraced`
# sends to the direct method; as primitives, Mooncake does not derive rules
# through their FFTW calls.
const _FFTCall = Union{typeof(_fft_convolve!), typeof(_fft_convolve_back!)}
const _FFT_TRACED = "an FFT convolution was reached from AD-traced code"
Mooncake.@is_primitive Mooncake.DefaultCtx Tuple{_FFTCall, Vararg}
function Mooncake.frule!!(::Mooncake.Dual{<:_FFTCall}, args::Vararg{Any, N}) where {N}
    throw(ErrorException(_FFT_TRACED))
end
function Mooncake.rrule!!(::CoDual{<:_FFTCall}, args::Vararg{Any, N}) where {N}
    throw(ErrorException(_FFT_TRACED))
end

# Primitive so a chain of delays' convolution is not traced loop by loop.
# It takes vectors and views of them, whose mirrors `_mc` reads.
const _MassVector{P} = Union{
    Vector{P}, SubArray{P, 1, <:Array{P}},
    Base.ReshapedArray{P, 1, <:Union{Array{P}, SubArray{P, 1, <:Array{P}}}},
}
Mooncake.@is_primitive(
    Mooncake.DefaultCtx, Mooncake.ReverseMode,
    Tuple{typeof(_convolve_masses), A, B, Int} where {
        P <: _IEEEFloat, A <: _MassVector{P}, B <: _MassVector{P},
    }
)
function Mooncake.rrule!!(
        ::CoDual{typeof(_convolve_masses)}, a::CoDual{<:_MassVector{P}},
        b::CoDual{<:_MassVector{P}}, lags::CoDual{Int}
    ) where {P <: _IEEEFloat}
    pa, pb = primal(a), primal(b)
    c = _convolve_masses(pa, pb, primal(lags))
    c̄ = zero(c)
    function _convolve_masses_pullback(::NoRData)
        ā, b̄ = _mc(pa, tangent(a)), _mc(pb, tangent(b))
        _convolve_masses_back!(ā, b̄, c̄, pa, pb)
        return NoRData(), NoRData(), NoRData(), NoRData()
    end
    return CoDual(c, c̄), _convolve_masses_pullback
end

# Primitive so the movement `Redistribute(K, ε)` builds from a kernel is not
# traced as its `S × S` broadcasts, which cost a sizeable share of a
# gradient whose movement is built in the differentiated code. It takes a
# matrix kernel, or a reshape or view of one, and one intensity or a row of
# them over origins, which is a reshape when the intensities are a view.
const _KernelMatrix{P} = Union{
    Matrix{P}, SubArray{P, 2, <:Array{P}},
    Base.ReshapedArray{P, 2, <:Union{Array{P}, SubArray{P, 1, <:Array{P}}}},
}
Mooncake.@is_primitive(
    Mooncake.DefaultCtx, Mooncake.ReverseMode,
    Tuple{typeof(_movement), K, E} where {
        P <: _IEEEFloat, K <: _KernelMatrix{P}, E <: Union{P, _KernelMatrix{P}},
    }
)
function Mooncake.rrule!!(
        ::CoDual{typeof(_movement)}, K::CoDual{<:_KernelMatrix{P}},
        E::CoDual{<:Union{P, _KernelMatrix{P}}}
    ) where {P <: _IEEEFloat}
    pK, pE = primal(K), primal(E)
    M = _movement(pK, pE)
    M̄ = zero(M)
    function _movement_pullback(::NoRData)
        Ē = pE isa Real ? nothing : _mc(pE, tangent(E))
        e = _movement_back!(_mc(pK, tangent(K)), Ē, M̄, pK, pE)
        return NoRData(), NoRData(), pE isa Real ? e : NoRData()
    end
    return CoDual(M, M̄), _movement_pullback
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
    ydual = _zero_output(y)
    return ydual, _ad_closure(args, ps, y, ydual, cache)
end
# The pullback, built behind a call that the cache's concrete type picks, so
# the closure holds a concrete cache rather than the union the forward run
# returns.
@noinline function _ad_closure(args, ps, y, ydual, cache)
    function _ad_pullback(::NoRData)
        ms = map(a -> _mc(primal(a), tangent(a)), args)
        grads = (; piece = first(ms), y = _mc(y, tangent(ydual)), args = Base.tail(ms))
        _run_pullback!(grads, first(ps), cache)
        return (NoRData(), map((a, m) -> _rd(primal(a), m), args, ms)...)
    end
    return _ad_pullback
end

# The output with a zero cotangent. A float array holds no other arrays, so
# `zero_fcodual`'s alias tracking has nothing to find, and on a short run
# it costs more than the zeroing.
_zero_output(y::Array{<:_IEEEFloat}) = CoDual(y, zero(y))
_zero_output(y) = Mooncake.zero_fcodual(y)

# The rule also covers a call whose local coupling derivative needs a
# second pass of dual numbers (25 to 48 strata and scalars). It beats plain
# AD there on Mooncake, at most 0.81 of its time for a dense coupling, but
# not on Enzyme, 1.58 at 26 strata, so only this extension makes `_ad_wide`
# a rule primitive.
Mooncake.@is_primitive(
    Mooncake.DefaultCtx, Mooncake.ReverseMode, Tuple{typeof(_ad_wide), Vararg}
)
function Mooncake.rrule!!(::CoDual{typeof(_ad_wide)}, args::Vararg{CoDual, N}) where {N}
    return Mooncake.rrule!!(Mooncake.zero_fcodual(_ad), args...)
end

# `_fit` picks the route per call, so a rule Mooncake derived for `_route`
# would infer plain AD through the whole run even when no call takes it. As
# a primitive the route compiles the rule (`_ad_wide` is the rule here) and
# builds plain AD's rule the first time a call takes it.
Mooncake.@is_primitive(
    Mooncake.DefaultCtx, Mooncake.ReverseMode,
    Tuple{typeof(_route), Val{:rule}, Vararg}
)
function Mooncake.rrule!!(
        ::CoDual{typeof(_route)}, ::CoDual{Val{:rule}}, args::Vararg{CoDual, N}
    ) where {N}
    _fit(map(primal, args)...) === :none && return _plain_route(args...)
    y, pb = Mooncake.rrule!!(Mooncake.zero_fcodual(_ad), args...)
    return y, _RoutePullback(pb)
end
# The route's pullback: the rule's cotangents after one for the `Val`.
struct _RoutePullback{P}
    pb::P
end
function (r::_RoutePullback)(ȳ)
    r̄ = r.pb(ȳ)
    return (first(r̄), NoRData(), Base.tail(r̄)...)
end
# The output is typed as the rule route's, which inference folds, so the
# primitive's return type does not widen for the calls that take the rule.
function _plain_route(args::Vararg{CoDual, N}) where {N}
    rule = _plain_rule(map(primal, args)...)
    y, pb = rule(Mooncake.zero_fcodual(_hooked_plain), args...)
    return _as_rule_output(y, args...), _RoutePullback{Any}(pb)
end
function _as_rule_output(y, args::Vararg{CoDual, N}) where {N}
    R = Base.promote_op(_rule_route, map(typeof, args)...)
    return R isa DataType && R <: Tuple && isconcretetype(fieldtype(R, 1)) ?
        y::fieldtype(R, 1) : y
end
_rule_route(args...) = Mooncake.rrule!!(Mooncake.zero_fcodual(_ad), args...)
# Plain AD's rules, one per argument types, built at the world of the call
# that needs it, as Mooncake builds its lazy rules, and rebuilt when a call
# runs in a newer world. Like Mooncake's own rule caches it keeps an entry
# for each argument types that has taken this route.
const _PLAIN_RULES = Dict{Type, Tuple{UInt, Any}}()
const _PLAIN_RULES_LOCK = ReentrantLock()
function _plain_rule(ps::Vararg{Any, N}) where {N}
    world = Base.tls_world_age()
    return lock(_PLAIN_RULES_LOCK) do
        built = get(_PLAIN_RULES, typeof(ps), nothing)
        built !== nothing && first(built) == world && return last(built)
        interp = Mooncake.get_interpreter(Mooncake.ReverseMode, world)
        sig = Tuple{typeof(_hooked_plain), map(typeof, ps)...}
        rule = Mooncake.build_rrule(interp, sig; skip_world_age_check = true)
        _PLAIN_RULES[typeof(ps)] = (world, rule)
        return rule
    end
end

function ComposableRecurrences.test_adjoint(
        ::AutoMooncake, op, ::Run, args...; rng = Xoshiro(1), kwargs...
    )
    return Mooncake.TestUtils.test_rule(
        rng, _ad, op, args...; is_primitive = true, perf_flag = :none,
        unsafe_perturb = true, mode = Mooncake.ReverseMode, kwargs...
    )
end


# ---- building a `Depletion` -------------------------------------------------

# Building a `Depletion` only repackages its parts: each flow is placed among
# the pools with its demand and form as given, and each draw holds its form's
# parameter, its weights and the population as given. Mooncake would derive a
# rule through the grouping and placing of every flow type, which takes
# longer to compile than the run's own rule, so these two rules map the
# tangents by structure instead. A piece of another type takes the derived
# rule, as the signatures leave it out.
const _DrawForm = Union{
    Hazard, Floor,
    Truncate,
}
const _BuiltPiece = Union{Flow, _DrawForm}

Mooncake.@is_primitive Mooncake.DefaultCtx Mooncake.ReverseMode Tuple{
    typeof(_depletion), Any, Tuple{Vararg{_BuiltPiece}}, Any,
}

_fd_type(y) = Mooncake.fdata_type(Mooncake.tangent_type(typeof(y)))

# Each array of `x` with its forward data `fx`, by identity.
_shadows!(d, x::Array, fx::Array) = (d[x] = fx; nothing)
_shadows!(d, x, ::NoFData) = nothing
function _shadows!(d, x::Union{Tuple, NamedTuple}, fx::Union{Tuple, NamedTuple})
    foreach((a, b) -> _shadows!(d, a, b), values(x), values(fx))
    return nothing
end
function _shadows!(d, x, fx::Mooncake.FData)
    for f in fieldnames(typeof(x))
        _shadows!(d, getfield(x, f), getfield(fx.data, f))
    end
    return nothing
end

# The forward data of `y`, each of its arrays' shadows found by identity: an
# array made in the build, such as integers made floats, takes a new shadow,
# as nothing upstream of it has a derivative.
function _fdata_of(y::Array, d)
    _fd_type(y) === NoFData && return NoFData()
    return haskey(d, y) ? d[y] : zero(y)
end
function _fdata_of(y::Tuple, d)
    _fd_type(y) === NoFData && return NoFData()
    return map(a -> _fdata_of(a, d), y)
end
function _fdata_of(y::NamedTuple{K}, d) where {K}
    _fd_type(y) === NoFData && return NoFData()
    return NamedTuple{K}(map(a -> _fdata_of(a, d), values(y)))
end
function _fdata_of(y, d)
    F = _fd_type(y)
    F === NoFData && return NoFData()
    names = fieldnames(typeof(y))
    return F(NamedTuple{names}(map(f -> _fdata_of(getfield(y, f), d), names)))
end

_pieces_fdata(fd::NoFData, ps) = map(_ -> NoFData(), ps)
_pieces_fdata(fd::Tuple, ps) = fd
_or_no_fdata(t::Tuple) = all(x -> x isa NoFData, t) ? NoFData() : t

# Each run's forward data: a placed flow's tangent type is its given flow's,
# so a run of flows takes theirs as it is; a draw's is found by identity.
_runs_fdata(::Tuple{}, gfd, i, d) = ()
function _runs_fdata(runs::Tuple, gfd, i, d)
    r = first(runs)
    if r isa Tuple
        n = length(r)
        run = _or_no_fdata(ntuple(j -> gfd[i + j], n))
        return (run, _runs_fdata(Base.tail(runs), gfd, i + n, d)...)
    end
    return (_fdata_of(r, d), _runs_fdata(Base.tail(runs), gfd, i + 1, d)...)
end

_rfield(r::NoRData, f) = NoRData()
_rfield(r::Mooncake.RData, f) = getfield(r.data, f)
_rfield(r::Union{Tuple, NamedTuple}, f) = getfield(r, f)
_rset(z::NoRData, f, v) = z
function _rset(z::Mooncake.RData, f, v)
    return typeof(z)(merge(z.data, NamedTuple{(f,)}((v,))))
end
_rset(z::NamedTuple, f, v) = merge(z, NamedTuple{(f,)}((v,)))
_rset(z::Tuple, i::Int, v) = Base.setindex(z, v, i)
# The reverse data `v` an input of zero reverse data `z` takes: nothing for
# an input without a derivative, such as an integer made a float, and none
# for an output without one; any other mismatch is a bug in the map.
_rtake(z::NoRData, v) = z
_rtake(z::NoRData, v::NoRData) = z
_rtake(z, v::NoRData) = z
_rtake(z::T, v::T) where {T} = v
function _rtake(z, v)
    return error(
        "building a Depletion: reverse data $(typeof(v)) where " *
            "$(typeof(z)) was expected"
    )
end
_radd(a::NoRData, b) = a
_radd(a::NoRData, b::NoRData) = a
_radd(a, b::NoRData) = a
_radd(a, b) = Mooncake.increment!!(a, b)

_form_param(::Truncate) = :κ
_form_param(::Union{Hazard, Floor}) = :α

# A draw's reverse data back to its form, by its parameter and its weights,
# and to the population.
function _draw_back(form, rdraw, rN)
    rf = Mooncake.zero_rdata(form)
    p = _form_param(form)
    rf = _rset(rf, p, _rtake(_rfield(rf, p), _rfield(_rfield(rdraw, :form), p)))
    w = form.weights
    if w isa NamedTuple && !(rf isa NoRData)
        rw, rws = _rfield(rf, :weights), _rfield(rdraw, :weights)
        for k in keys(w)
            rw = _rset(rw, k, _rtake(_rfield(rw, k), _rfield(rws, k)))
        end
        rf = _rset(rf, :weights, rw)
    end
    return rf, _radd(rN, _rfield(rdraw, :N))
end

# The given pieces' reverse data from each run's, in order.
_runs_back(::Tuple{}, rruns, ps, rps, i, rN, k) = (rps, rN)
function _runs_back(runs::Tuple, rruns, ps, rps, i, rN, k)
    r, rr = first(runs), _rfield(rruns, k)
    if r isa Tuple
        for j in 1:length(r)
            rps = _rset(rps, i + j, _rtake(_rfield(rps, i + j), _rfield(rr, j)))
        end
        i += length(r)
    elseif i < length(ps)
        rf, rN = _draw_back(ps[i + 1], rr, rN)
        rps = _rset(rps, i + 1, rf)
        i += 1
    else
        # The default hazard of a `Depletion` given no pieces, which reads
        # the population alone.
        rN = _radd(rN, _rfield(rr, :N))
    end
    return _runs_back(Base.tail(runs), rruns, ps, rps, i, rN, k + 1)
end

_pools_back(pools, rp) = Mooncake.zero_rdata(pools)
function _pools_back(pools::NamedTuple{K}, rp) where {K}
    z = Mooncake.zero_rdata(pools)
    z isa NoRData && return z
    return NamedTuple{K}(map(k -> _rtake(z[k], _rfield(rp, k)), K))
end

function Mooncake.rrule!!(
        ::CoDual{typeof(_depletion)}, N::CoDual, pieces::CoDual, pools::CoDual
    )
    Np, ps, pl = primal(N), primal(pieces), primal(pools)
    D = _depletion(Np, ps, pl)
    F = _fd_type(D)
    fd = if F === NoFData
        NoFData()
    else
        d = IdDict{Any, Any}()
        _shadows!(d, Np, tangent(N))
        _shadows!(d, pl, tangent(pools))
        gfd = _pieces_fdata(tangent(pieces), ps)
        foreach((p, f) -> p isa Flow || _shadows!(d, p, f), ps, gfd)
        runs = _or_no_fdata(_runs_fdata(D.pieces, gfd, 0, d))
        F((pools = _fdata_of(D.pools, d), pieces = runs))
    end
    runs = D.pieces
    function depletion_pullback!!(rD)
        rps, rN = _runs_back(
            runs, _rfield(rD, :pieces), ps, Mooncake.zero_rdata(ps), 0,
            Mooncake.zero_rdata(Np), 1
        )
        return NoRData(), rN, rps, _pools_back(pl, _rfield(rD, :pools))
    end
    return CoDual(D, fd), depletion_pullback!!
end

# A `Flow` holds its demand and form as given, and its ends carry no
# derivative.
Mooncake.@is_primitive Mooncake.DefaultCtx Mooncake.ReverseMode Tuple{
    Type{Flow}, Any, Any, Any, Any,
}
function Mooncake.rrule!!(
        ::CoDual{Type{Flow}}, from::CoDual, to::CoDual,
        demand::CoDual, form::CoDual
    )
    f = Flow(primal(from), primal(to), primal(demand), primal(form))
    F = _fd_type(f)
    fd = F === NoFData ? NoFData() : F(
            (
                from = NoFData(), to = NoFData(), demand = tangent(demand),
                form = tangent(form),
            )
        )
    function flow_pullback!!(rf)
        return NoRData(), NoRData(), NoRData(), _rtake(
                Mooncake.zero_rdata(primal(demand)), _rfield(rf, :demand)
            ), _rtake(Mooncake.zero_rdata(primal(form)), _rfield(rf, :form))
    end
    return CoDual(f, fd), flow_pullback!!
end

end
