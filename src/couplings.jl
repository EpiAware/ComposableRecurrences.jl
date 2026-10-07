# The built-in couplings: `forward(C, Pressure(), q, p, t)` mixes the
# per-stratum kernel convolutions `p` into the pressure `q` on each stratum.

function forward(J::UniformScaling, ::Pressure, q, p, t)
    λ = J.λ
    for a in eachindex(q, p)
        q[a] = λ * p[a]
    end
    return nothing
end

# Column by column, the order a column-major matrix is stored in.
function forward(C::AbstractMatrix, ::Pressure, q, p, t)
    fill!(q, zero(eltype(q)))
    for b in axes(C, 2)
        pb = p[b]
        for a in axes(C, 1)
            q[a] += C[a, b] * pb
        end
    end
    return nothing
end

function forward(C::Diagonal, ::Pressure, q, p, t)
    d = C.diag
    for a in eachindex(q, p)
        q[a] = d[a] * p[a]
    end
    return nothing
end

function forward(C::SparseMatrixCSC, ::Pressure, q, p, t)
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

function forward(
        C::TimeVarying{Secondary, <:AbstractArray{<:Any, 3}}, ::Pressure, q, p, t
    )
    X = C.x
    fill!(q, zero(eltype(q)))
    for b in axes(X, 2)
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
function _check_coupling_shape(C::Pairwise)
    throw(
        ArgumentError(
            "Pairwise is a kernel: use Recurrence(Pairwise(A)) with " *
                "coupling I, not coupling = $(_describe(C))"
        )
    )
end
