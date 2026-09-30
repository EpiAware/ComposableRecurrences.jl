# The built-in couplings: `forward(C, Pressure(), q, p, t)` mixes the
# per-stratum kernel convolutions `p` into the pressure `q` on each stratum.

function forward(J::UniformScaling, ::Pressure, q, p, t)
    λ = J.λ
    for a in eachindex(q, p)
        q[a] = λ * p[a]
    end
    return nothing
end

function forward(C::AbstractMatrix, ::Pressure, q, p, t)
    for a in axes(C, 1)
        acc = zero(eltype(q))
        for b in axes(C, 2)
            acc += C[a, b] * p[b]
        end
        q[a] = acc
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
    for a in axes(X, 1)
        acc = zero(eltype(q))
        for b in axes(X, 2)
            acc += X[a, b, t] * p[b]
        end
        q[a] = acc
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
function _check_coupling_shape(::TimeVarying)
    throw(
        ArgumentError(
            "a TimeVarying coupling is a strata × strata × time array with " *
                "Secondary() indexing"
        )
    )
end
function _check_coupling_shape(::Pairwise)
    throw(
        ArgumentError(
            "Pairwise is a kernel: use Recurrence(Pairwise(A)) with coupling I"
        )
    )
end
