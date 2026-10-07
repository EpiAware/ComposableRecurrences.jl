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
    _nparams(x) == 0 && return x, o
    fs, o = _rebuild(ntuple(i -> getfield(x, i), fieldcount(typeof(x))), θ, o)
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
    return _call_pullback!(grads, m, Step(), v, s, t, k)
end

# Default scalar pullback of a pointwise modifier without its own: a local
# `ForwardDiff` derivative in the value, the state and the modifier's float
# parameters. Each case is its own method, so no variable is shared with a
# closure (which would box it and allocate on every step).
function _local_pullback(grads, m, v, s, t, k)
    m̄, v̄, s̄ = grads.piece, grads.v, grads.s
    m̄ === nothing || !_scalar_params(m) ||
        return _scalar_pullback(m, m̄, v̄, s̄, v, s, t, k)
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
# `[v; s; θ]`.
function _jacobian_pullback(m, m̄, v̄, s̄, v, s, t, k)
    P = _nparams(m)
    J = ForwardDiff.jacobian(x -> _step_vector(m, x, P, t, k), [v; s; _params(m)])
    g = transpose(J) * [v̄, s̄]
    _addparams!(m̄, m, g, 2)
    return g[1], g[2]
end
function _step_vector(m, x, P, t, k)
    v′, s′ = forward(_rebuild(m, view(x, 3:(P + 2))), Step(), x[1], x[2], t, k)
    return [v′, s′]
end

# The same derivative for a modifier whose parameters are all scalars: the
# value, the state and the parameters are seeded as one tuple of dual
# numbers, so a step allocates nothing (this runs once per stratum and step).
function _scalar_pullback(m, m̄, v̄, s̄, v, s, t, k)
    x = (v, s, _param_tuple(m)...)
    T = promote_type(map(typeof, x)...)
    xd = _seed(ForwardDiff.Tag(_scalar_pullback, T), map(T, x))
    md = first(_rebuild_scalar(m, Base.tail(Base.tail(xd))))
    v′, s′ = forward(md, Step(), xd[1], xd[2], t, k)
    g = _vjp(v′, s′, v̄, s̄, xd)
    _add_scalar!(m̄, m, Base.tail(Base.tail(g)))
    return g[1], g[2]
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
    return _call_pullback!(grads, form, Step(), v, s, N, α)
end
function _form_pullback(::Val{false}, grads, form, v, s, N, α)
    x = (v, s, N, α, _param_tuple(form)...)
    T = promote_type(map(typeof, x)...)
    xd = _seed(ForwardDiff.Tag(_form_pullback, T), map(T, x))
    θd = Base.tail(Base.tail(Base.tail(Base.tail(xd))))
    fd = first(_rebuild_scalar(form, θd))
    y, s′ = forward(fd, Step(), xd[1], xd[2], xd[3], xd[4])
    g = _vjp(y, s′, grads.v, grads.s, xd)
    _add_scalar!(grads.piece, form, Base.tail(Base.tail(Base.tail(Base.tail(g)))))
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

# The float scalars of `x` in the order `_getparams!` reads them, as a tuple.
_param_tuple(x::AbstractFloat) = (x,)
_param_tuple(::_Leafless) = ()
_param_tuple(x::Union{Tuple, NamedTuple}) = _param_tuples(values(x)...)
function _param_tuple(x)
    isstructtype(typeof(x)) || return ()
    return _param_tuples(ntuple(i -> getfield(x, i), Val(fieldcount(typeof(x))))...)
end
_param_tuples() = ()
_param_tuples(x, xs...) = (_param_tuple(x)..., _param_tuples(xs...)...)

# `_rebuild` and `_addparams!` for the tuple of scalars: each consumes the
# leading entries of `θ` or `g` and returns the rest, so the recursion over
# fields is resolved at compile time.
_rebuild_scalar(::AbstractFloat, θ) = (first(θ), Base.tail(θ))
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

# Whether the local derivative's rebuild of `m` from its float scalars gives
# them back: each is seeded as a dual number with its own partial, `m` is
# rebuilt by `constructorof` and its scalars must come back unchanged. A
# keyword-only constructor, a field typed `Float64` or a constructor that
# transforms its arguments fails, and the operator then takes plain AD.
# Checked once, when a `Recurrence` is built, which stores the outcome.
_round_trips(m) = _round_trips(m, _param_tuple(m))
_round_trips(m, ::Tuple{}) = true
function _round_trips(m, θ)
    T = promote_type(map(typeof, θ)...)
    θd = _seed(ForwardDiff.Tag(_round_trips, T), map(T, θ))
    return try
        _rebuilt_tuple(m, first(_rebuild_scalar(m, θd))) === θd
    catch
        false
    end
end
# The leaves of `y`, a rebuild of `x`, where `_param_tuple(x)` reads floats.
_rebuilt_tuple(::AbstractFloat, y) = (y,)
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

_add_scalar!(x̄, ::AbstractFloat, g) = (add_cotangent!(x̄, first(g)); Base.tail(g))
_add_scalar!(x̄, ::_Leafless, g) = g
_add_scalar!(x̄, ::Tuple{}, g) = g
function _add_scalar!(x̄, x::Tuple, g)
    g = _add_scalar!(x̄ === nothing ? nothing : first(x̄), first(x), g)
    return _add_scalar!(x̄ === nothing ? nothing : Base.tail(x̄), Base.tail(x), g)
end
function _add_scalar!(x̄, x::NamedTuple, g)
    return _add_scalar!(x̄ === nothing ? nothing : Tuple(x̄), Tuple(x), g)
end
function _add_scalar!(x̄, x, g)
    _param_tuple(x) === () && return g
    names = fieldnames(typeof(x))
    fs = ntuple(i -> getfield(x, i), Val(fieldcount(typeof(x))))
    m̄s = map(n -> _field_mirror(x̄, n), names)
    return _add_scalar!(m̄s, fs, g)
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
    x0 = [_params(m); vec(history)]
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
