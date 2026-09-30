# Default pullbacks for modifiers and couplings without a hand-written one:
# a local ForwardDiff Jacobian of that one step, including the parameters.
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
# returns the new object and offset. Structs are rebuilt through the
# constructor of their type's name.
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
    return _constructorof(typeof(x))(fs...), o
end

# The constructor that rebuilds a struct of type `T` from its fields, with
# new field types. A struct whose only constructor is parametric adds a
# method.
_constructorof(::Type{T}) where {T} = Base.typename(T).wrapper

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

# Default scalar pullback of a pointwise modifier: a local ForwardDiff
# derivative in the value, the state and the modifier's parameters.
function apply_pullback(m̄, m, v, s, t, k, v̄, s̄)
    P = _nactive(m̄, m)
    if P == 0
        D = ForwardDiff.Dual{typeof(ForwardDiff.Tag(apply_pullback, typeof(v)))}
        v′, s′ = apply(m, D(v, one(v), zero(v)), D(s, zero(s), one(s)), t, k)
        ∂v, ∂s = _partials2(v′), _partials2(s′)
        return v̄ * ∂v[1] + s̄ * ∂s[1], v̄ * ∂v[2] + s̄ * ∂s[2]
    end
    J = ForwardDiff.jacobian([v; s; _params(m)]) do x
        v′, s′ = apply(_rebuild(m, view(x, 3:(P + 2))), x[1], x[2], t, k)
        return [v′, s′]
    end
    g = transpose(J) * [v̄, s̄]
    _addparams!(m̄, m, g, 2)
    return g[1], g[2]
end
_partials2(x::ForwardDiff.Dual) = ForwardDiff.partials(x)
_partials2(x::Real) = (zero(x), zero(x))

# Default `apply_pullback!`: the pointwise loop, or the local Jacobian of
# `apply!` in the step's values, state and the modifier's parameters.
function apply_pullback!(m̄, m, v, s, t, v̄, s̄)
    if ispointwise(m)
        for k in eachindex(v, s, v̄, s̄)
            v̄[k], s̄[k] = apply_pullback(m̄, m, v[k], s[k], t, k, v̄[k], s̄[k])
        end
        return nothing
    end
    S = length(v)
    P = _nactive(m̄, m)
    J = ForwardDiff.jacobian([v; s; _params(m)]) do x
        vv, ss = x[1:S], x[(S + 1):(2S)]
        mm = P == 0 ? m : _rebuild(m, view(x, (2S + 1):(2S + P)))
        apply!(mm, vv, ss, t)
        return [vv; ss]
    end
    g = transpose(J) * [v̄; s̄]
    copyto!(v̄, 1, g, 1, S)
    copyto!(s̄, 1, g, S + 1, S)
    P == 0 || _addparams!(m̄, m, g, 2S)
    return nothing
end

# Default initial-state pullback: a local ForwardDiff Jacobian of
# `init_state`, skipped for the default zero state.
function init_state_pullback!(m̄, h̄, m, history, s̄)
    _default_init(m, history) && return nothing
    P = _nactive(m̄, m)
    nh = h̄ === nothing ? 0 : length(history)
    P + nh == 0 && return nothing
    x0 = [_params(m); vec(history)]
    J = ForwardDiff.jacobian(x0) do x
        mm = P == 0 ? m : _rebuild(m, view(x, 1:P))
        hh = nh == 0 ? history : reshape(x[(P + 1):end], size(history))
        return collect(init_state(mm, hh))
    end
    g = transpose(J) * s̄
    P == 0 || _addparams!(m̄, m, g, 0)
    nh == 0 || (h̄ .+= reshape(view(g, (P + 1):(P + nh)), size(history)))
    return nothing
end

# Whether modifier `m` uses the default zero initial state.
function _default_init(m, history)
    return which(init_state, Tuple{typeof(m), typeof(history)}) ===
        which(init_state, Tuple{Any, Any})
end

# Default `pressure_pullback!`: the local Jacobian of `pressure!` in the
# kernel convolutions, the window and the coupling's parameters.
function pressure_pullback!(p̄, window̄, C̄, C, q̄, p, window, t)
    S = length(p)
    nw = window̄ === nothing ? 0 : length(window)
    P = _nactive(C̄, C)
    J = ForwardDiff.jacobian([p; vec(window); _params(C)]) do x
        pp = x[1:S]
        ww = nw == 0 ? window : reshape(x[(S + 1):(S + length(window))], size(window))
        CC = P == 0 ? C : _rebuild(C, view(x, (S + length(window) + 1):length(x)))
        return pressure!(similar(x, length(q̄)), CC, pp, ww, t)
    end
    g = transpose(J) * q̄
    p̄ .+= view(g, 1:S)
    nw == 0 || (window̄ .+= reshape(view(g, (S + 1):(S + nw)), size(window)))
    P == 0 || _addparams!(C̄, C, g, S + length(window))
    return nothing
end
