# The built-in couplings: `forward!(C, Pressure(), q, p, t)` mixes the
# per-stratum kernel convolutions `p` into the pressure `q` on each stratum.

function forward!(J::UniformScaling, ::Pressure, q, p, t)
    λ = J.λ
    for a in eachindex(q, p)
        q[a] = λ * p[a]
    end
    return nothing
end

# The shapes are checked once, so the loops read without bounds checks.
function forward!(C::AbstractMatrix, ::Pressure, q, p, t)
    _check_pressure(C, q, p)
    _mix!(q, C, p)
    return nothing
end

# Floats: four columns per pass, in storage order, so each row's update
# vectorises across rows and `q` is read and written once per four columns.
function _mix!(q::AbstractVector{<:AbstractFloat}, C, p)
    fill!(q, zero(eltype(q)))
    b, last_b = first(axes(C, 2)), last(axes(C, 2))
    @inbounds while b + 3 <= last_b
        p1, p2, p3, p4 = p[b], p[b + 1], p[b + 2], p[b + 3]
        for a in axes(C, 1)
            qa = muladd(C[a, b], p1, q[a])
            qa = muladd(C[a, b + 1], p2, qa)
            qa = muladd(C[a, b + 2], p3, qa)
            q[a] = muladd(C[a, b + 3], p4, qa)
        end
        b += 4
    end
    @inbounds for c in b:last_b
        pc = p[c]
        for a in axes(C, 1)
            q[a] = muladd(C[a, c], pc, q[a])
        end
    end
    return nothing
end

# Other numbers, such as dual numbers: four rows per pass, summed in locals
# and stored once, since loading and storing a wide number on every column
# costs more than the column-major reads it saves.
function _mix!(q, C, p)
    a, last_a = first(axes(C, 1)), last(axes(C, 1))
    @inbounds while a + 3 <= last_a
        q1 = q2 = q3 = q4 = zero(eltype(q))
        for b in axes(C, 2)
            pb = p[b]
            q1 = muladd(C[a, b], pb, q1)
            q2 = muladd(C[a + 1, b], pb, q2)
            q3 = muladd(C[a + 2, b], pb, q3)
            q4 = muladd(C[a + 3, b], pb, q4)
        end
        q[a], q[a + 1], q[a + 2], q[a + 3] = q1, q2, q3, q4
        a += 4
    end
    @inbounds for r in a:last_a
        qr = zero(eltype(q))
        for b in axes(C, 2)
            qr = muladd(C[r, b], p[b], qr)
        end
        q[r] = qr
    end
    return nothing
end

# A dense or time-varying coupling's rows and columns against the pressures.
function _check_pressure(C, q, p)
    axes(C, 1) == axes(q, 1) && axes(C, 2) == axes(p, 1) || throw(
        DimensionMismatch(
            "coupling is $(size(C)), pressures are $(length(q)) and $(length(p))"
        )
    )
    return nothing
end

function forward!(C::Diagonal, ::Pressure, q, p, t)
    d = C.diag
    for a in eachindex(q, p)
        q[a] = d[a] * p[a]
    end
    return nothing
end

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

# The reverse pass of the built-in couplings: `grads.q` is the pressure's
# cotangent, `grads.p` accumulates the kernel convolutions' and
# `grads.piece` the coupling's own. A sparse coupling's cotangent keeps its
# sparsity pattern. Each method makes `uses_adjoint` true for its type.
function pullback!(grads, J::UniformScaling, ::Pressure, q, p, t)
    q̄, p̄ = grads.q, grads.p
    λ̄ = cotangent(grads.piece, :λ)
    for a in eachindex(q̄, p)
        p̄[a] += J.λ * q̄[a]
        add_cotangent!(λ̄, q̄[a] * p[a])
    end
    return nothing
end

function pullback!(grads, C::AbstractMatrix, ::Pressure, q, p, t)
    q̄, p̄, C̄ = grads.q, grads.p, grads.piece
    for b in axes(C, 2)
        acc = zero(eltype(p̄))
        for a in axes(C, 1)
            acc += C[a, b] * q̄[a]
            add_cotangent!(C̄, q̄[a] * p[b], a, b)
        end
        p̄[b] += acc
    end
    return nothing
end
# A dense matrix with a dense or absent mirror: the same fused loop, its
# sizes checked once so it runs without bounds checks. Any other mirror
# takes the method above.
function pullback!(grads, C::Matrix, ::Pressure, q, p, t)
    q̄, p̄ = grads.q, grads.p
    C̄ = _array_mirror(grads.piece)
    C̄ isa _DenseMirror || return invoke(
        pullback!, Tuple{Any, AbstractMatrix, Pressure, Any, Any, Any},
        grads, C, Pressure(), q, p, t
    )
    _check_dense(C̄, C)
    axes(q̄, 1) == axes(C, 1) && axes(p̄, 1) == axes(p, 1) == axes(C, 2) || throw(
        DimensionMismatch("coupling is $(size(C)), pressures are $(length(p))")
    )
    _dense_coupling_back!(p̄, C̄, C, q̄, p)
    return nothing
end
function _dense_coupling_back!(p̄, C̄::Matrix, C::Matrix, q̄, p)
    @inbounds for b in axes(C, 2)
        acc = zero(eltype(p̄))
        pb = p[b]
        @simd for a in axes(C, 1)
            acc += C[a, b] * q̄[a]
            C̄[a, b] += q̄[a] * pb
        end
        p̄[b] += acc
    end
    return nothing
end
function _dense_coupling_back!(p̄, ::Union{Nothing, NamedTuple{()}}, C::Matrix, q̄, p)
    @inbounds for b in axes(C, 2)
        acc = zero(eltype(p̄))
        @simd for a in axes(C, 1)
            acc += C[a, b] * q̄[a]
        end
        p̄[b] += acc
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

function pullback!(
        grads, C::TimeVarying{Secondary, <:AbstractArray{<:Any, 3}}, ::Pressure,
        q, p, t
    )
    q̄, p̄ = grads.q, grads.p
    X = C.x
    X̄ = cotangent(grads.piece, :x)
    for b in axes(X, 2)
        acc = zero(eltype(p̄))
        for a in axes(X, 1)
            acc += X[a, b, t] * q̄[a]
            add_cotangent!(X̄, q̄[a] * p[b], a, b, t)
        end
        p̄[b] += acc
    end
    return nothing
end

# A time-varying dense array with a dense or absent mirror: the same fused
# loop over its slice at `t`, without bounds checks.
function pullback!(
        grads, C::TimeVarying{Secondary, <:Array{<:Any, 3}}, ::Pressure, q, p, t
    )
    q̄, p̄ = grads.q, grads.p
    X = C.x
    X̄ = _array_mirror(cotangent(grads.piece, :x))
    X̄ isa Union{Array{<:Any, 3}, Nothing, NamedTuple{()}} ||
        return _tv_coupling_back!(p̄, X̄, X, q̄, p, t)
    X̄ isa Array && size(X̄) != size(X) && throw(
        DimensionMismatch("mirror is $(size(X̄)), coupling is $(size(X))")
    )
    checkbounds(X, :, :, t)
    axes(q̄, 1) == axes(X, 1) && axes(p̄, 1) == axes(p, 1) == axes(X, 2) || throw(
        DimensionMismatch("coupling is $(size(X)), pressures are $(length(p))")
    )
    _tv_coupling_back!(p̄, X̄, X, q̄, p, t)
    return nothing
end
function _tv_coupling_back!(p̄, X̄, X, q̄, p, t)
    for b in axes(X, 2)
        acc = zero(eltype(p̄))
        for a in axes(X, 1)
            acc += X[a, b, t] * q̄[a]
            add_cotangent!(X̄, q̄[a] * p[b], a, b, t)
        end
        p̄[b] += acc
    end
    return nothing
end
function _tv_coupling_back!(p̄, X̄::Array{<:Any, 3}, X::Array{<:Any, 3}, q̄, p, t)
    @inbounds for b in axes(X, 2)
        acc = zero(eltype(p̄))
        pb = p[b]
        @simd for a in axes(X, 1)
            acc += X[a, b, t] * q̄[a]
            X̄[a, b, t] += q̄[a] * pb
        end
        p̄[b] += acc
    end
    return nothing
end
function _tv_coupling_back!(
        p̄, ::Union{Nothing, NamedTuple{()}}, X::Array{<:Any, 3}, q̄, p, t
    )
    @inbounds for b in axes(X, 2)
        acc = zero(eltype(p̄))
        @simd for a in axes(X, 1)
            acc += X[a, b, t] * q̄[a]
        end
        p̄[b] += acc
    end
    return nothing
end

# Coupling shape checks against `S` strata.
_check_coupling(C, S) = nothing
function _check_coupling(C::AbstractMatrix, S)
    size(C) == (S, S) || throw(
        DimensionMismatch("coupling is $(size(C)), expected ($S, $S)")
    )
    return nothing
end
function _check_coupling(C::TimeVarying, S)
    size(C.x)[1:2] == (S, S) || throw(
        DimensionMismatch(
            "coupling is $(size(C.x)), expected ($S, $S, ...)"
        )
    )
    return nothing
end

# The coupling slot: a time-varying coupling is `S × S × T`, read at time
# `t`. Lags belong to the kernel, so a Pairwise is not a coupling.
_check_coupling_shape(C) = nothing
function _check_coupling_shape(
        ::TimeVarying{Secondary, <:AbstractArray{<:Any, 3}}
    )
    return nothing
end
function _check_coupling_shape(C::TimeVarying)
    throw(
        ArgumentError(
            "a TimeVarying coupling is a strata × strata × time array with " *
                "Secondary() indexing, got $(_describe(C))"
        )
    )
end
_check_coupling_shape(C::Pairwise) = _kernel_as_coupling_error(C, "Pairwise(A)")

# An object on the same `pullback!` route as another of its type skips the
# pullback check (`pullback = false`): its branches have their own tests
# against a local Jacobian.
@implements PieceInterface{(:pullback,)} UniformScaling [
    Arguments(;
        piece = I, role = Pressure(), args = (zeros(2), [1.0, 2.0], 1),
        pullback = false
    ),
    Arguments(; piece = 0.5I, role = Pressure(), args = (zeros(2), [1.0, 2.0], 1)),
]

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
