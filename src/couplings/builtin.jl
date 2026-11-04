# The built-in couplings. `forward!(C, Pressure(), q, p, t)` mixes the
# per-stratum kernel convolutions `p` into the pressures `q`; `pullback!` adds
# `q̄`'s share to `grads.p` and to the coupling's own `grads.piece`.

# == Shared ==

# A dense or time-varying coupling's rows and columns against the pressures.
function _check_pressure(C, q, p)
    axes(C, 1) == axes(q, 1) && axes(C, 2) == axes(p, 1) || throw(
        DimensionMismatch(
            "coupling is $(size(C)), pressures are $(length(q)) and $(length(p))"
        )
    )
    return nothing
end

# The reverse pass of `q = C[:, :, idx...] * p` for any mirror `C̄`.
function _coupling_back!(p̄, C̄, C, q̄, p, idx...)
    for b in axes(C, 2)
        acc = zero(eltype(p̄))
        for a in axes(C, 1)
            acc += C[a, b, idx...] * q̄[a]
            add_cotangent!(C̄, q̄[a] * p[b], a, b, idx...)
        end
        p̄[b] += acc
    end
    return nothing
end

# The same for a dense matrix and a dense or absent mirror, whose sizes the
# caller has checked, so the loop runs without bounds checks and vectorises.
function _dense_coupling_back!(p̄, C̄, C, q̄, p)
    @inbounds for b in axes(C, 2)
        acc = zero(eltype(p̄))
        pb = p[b]
        @simd for a in axes(C, 1)
            acc += C[a, b] * q̄[a]
            C̄ isa AbstractArray && (C̄[a, b] += q̄[a] * pb)
        end
        p̄[b] += acc
    end
    return nothing
end

# A coupling's size against `S` strata.
_check_coupling(C, S) = nothing
function _check_coupling(C::AbstractMatrix, S)
    size(C) == (S, S) || throw(
        DimensionMismatch("coupling is $(size(C)), expected ($S, $S)")
    )
    return nothing
end
function _check_coupling(C::TimeVarying, S)
    size(C.x)[1:2] == (S, S) || throw(
        DimensionMismatch("coupling is $(size(C.x)), expected ($S, $S, ...)")
    )
    return nothing
end

# Which shapes the coupling slot takes. Lags belong to the kernel, so a
# `Pairwise` is not a coupling.
_check_coupling_shape(C) = nothing
_check_coupling_shape(::TimeVarying{Secondary, <:AbstractArray{<:Any, 3}}) = nothing
function _check_coupling_shape(C::TimeVarying)
    throw(
        ArgumentError(
            "a TimeVarying coupling is a strata × strata × time array with " *
                "Secondary() indexing, got $(_describe(C))"
        )
    )
end
_check_coupling_shape(C::Pairwise) = _kernel_as_coupling_error(C, "Pairwise(A)")

# == UniformScaling ==

function forward!(J::UniformScaling, ::Pressure, q, p, t)
    λ = J.λ
    for a in eachindex(q, p)
        q[a] = λ * p[a]
    end
    return nothing
end

function pullback!(grads, J::UniformScaling, ::Pressure, q, p, t)
    q̄, p̄ = grads.q, grads.p
    λ̄ = cotangent(grads.piece, :λ)
    for a in eachindex(q̄, p)
        p̄[a] += J.λ * q̄[a]
        add_cotangent!(λ̄, q̄[a] * p[a])
    end
    return nothing
end

# `pullback = false` skips the pullback check for an object on the same
# `pullback!` method as another one here; each branch has its own test
# against a local Jacobian.
@implements PieceInterface{(:pullback,)} UniformScaling [
    Arguments(;
        piece = I, role = Pressure(), args = (zeros(2), [1.0, 2.0], 1),
        pullback = false
    ),
    Arguments(; piece = 0.5I, role = Pressure(), args = (zeros(2), [1.0, 2.0], 1)),
]

# == Diagonal ==

function forward!(C::Diagonal, ::Pressure, q, p, t)
    d = C.diag
    for a in eachindex(q, p)
        q[a] = d[a] * p[a]
    end
    return nothing
end

function pullback!(grads, C::Diagonal, ::Pressure, q, p, t)
    q̄, p̄ = grads.q, grads.p
    d̄ = cotangent(grads.piece, :diag)
    for a in eachindex(q̄, p)
        p̄[a] += C.diag[a] * q̄[a]
        add_cotangent!(d̄, q̄[a] * p[a], a)
    end
    return nothing
end

# == SparseMatrixCSC ==

function forward!(C::SparseMatrixCSC, ::Pressure, q, p, t)
    fill!(q, zero(eltype(q)))
    rows = rowvals(C)
    vals = nonzeros(C)
    for b in axes(C, 2)
        pb = p[b]
        for idx in nzrange(C, b)
            q[rows[idx]] += vals[idx] * pb
        end
    end
    return nothing
end

# The cotangent keeps the sparsity pattern: it is indexed by stored entry.
function pullback!(grads, C::SparseMatrixCSC, ::Pressure, q, p, t)
    q̄, p̄ = grads.q, grads.p
    rows = rowvals(C)
    vals = nonzeros(C)
    nz̄ = cotangent(grads.piece, :nzval)
    for b in axes(C, 2)
        acc = zero(eltype(p̄))
        for idx in nzrange(C, b)
            acc += vals[idx] * q̄[rows[idx]]
            add_cotangent!(nz̄, q̄[rows[idx]] * p[b], idx)
        end
        p̄[b] += acc
    end
    return nothing
end

# == AbstractMatrix ==

function forward!(C::AbstractMatrix, ::Pressure, q, p, t)
    _check_pressure(C, q, p)
    fill!(q, zero(eltype(q)))
    @inbounds for b in axes(C, 2)
        pb = p[b]
        for a in axes(C, 1)
            q[a] += C[a, b] * pb
        end
    end
    return nothing
end

function pullback!(grads, C::AbstractMatrix, ::Pressure, q, p, t)
    _coupling_back!(grads.p, grads.piece, C, grads.q, p)
    return nothing
end

function pullback!(grads, C::Matrix, ::Pressure, q, p, t)
    q̄, p̄ = grads.q, grads.p
    C̄ = _array_mirror(grads.piece)
    C̄ isa _DenseMirror || return _coupling_back!(p̄, C̄, C, q̄, p)
    _check_dense(C̄, C)
    axes(q̄, 1) == axes(C, 1) && axes(p̄, 1) == axes(p, 1) == axes(C, 2) || throw(
        DimensionMismatch("coupling is $(size(C)), pressures are $(length(p))")
    )
    _dense_coupling_back!(p̄, C̄, C, q̄, p)
    return nothing
end

@implements PieceInterface{(:pullback,)} AbstractMatrix [
    Arguments(;
        piece = [0.9 0.1; 0.2 0.8], role = Pressure(),
        args = (zeros(2), [1.0, 2.0], 1)
    ),
    Arguments(;
        piece = Diagonal([0.5, 2.0]), role = Pressure(),
        args = (zeros(2), [1.0, 2.0], 1)
    ),
]

# == TimeVarying ==

# A strata × strata × time array, read at time `t`.
function forward!(
        C::TimeVarying{Secondary, <:AbstractArray{<:Any, 3}}, ::Pressure, q, p, t
    )
    X = C.x
    checkbounds(X, :, :, t)
    _check_pressure(X, q, p)
    fill!(q, zero(eltype(q)))
    @inbounds for b in axes(X, 2)
        pb = p[b]
        for a in axes(X, 1)
            q[a] += X[a, b, t] * pb
        end
    end
    return nothing
end

function pullback!(
        grads, C::TimeVarying{Secondary, <:AbstractArray{<:Any, 3}}, ::Pressure,
        q, p, t
    )
    _coupling_back!(grads.p, cotangent(grads.piece, :x), C.x, grads.q, p, t)
    return nothing
end

function pullback!(
        grads, C::TimeVarying{Secondary, <:Array{<:Any, 3}}, ::Pressure, q, p, t
    )
    q̄, p̄ = grads.q, grads.p
    X = C.x
    X̄ = _array_mirror(cotangent(grads.piece, :x))
    X̄ isa Union{Array{<:Any, 3}, Nothing, NamedTuple{()}} ||
        return _coupling_back!(p̄, X̄, X, q̄, p, t)
    X̄ isa Array && size(X̄) != size(X) && throw(
        DimensionMismatch("mirror is $(size(X̄)), coupling is $(size(X))")
    )
    checkbounds(X, :, :, t)
    axes(q̄, 1) == axes(X, 1) && axes(p̄, 1) == axes(p, 1) == axes(X, 2) || throw(
        DimensionMismatch("coupling is $(size(X)), pressures are $(length(p))")
    )
    X̄t = X̄ isa Array ? view(X̄, :, :, t) : X̄
    _dense_coupling_back!(p̄, X̄t, view(X, :, :, t), q̄, p)
    return nothing
end

@implements PieceInterface{(:pullback,)} TimeVarying [
    Arguments(;
        piece = TimeVarying(reshape(collect(1.0:8.0), 2, 2, 2)),
        role = Pressure(), args = (zeros(2), [1.0, 2.0], 2)
    ),
    Arguments(;
        piece = TimeVarying([1 => [1.0 3.0; 2.0 4.0], 2 => [5.0 7.0; 6.0 8.0]]),
        role = Pressure(), args = (zeros(2), [1.0, 2.0], 5)
    ),
]
