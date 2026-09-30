# The coupling interface: `pressure!` mixes the per-stratum kernel
# convolutions `p` into the pressure `q` on each stratum.

@doc "
Write the coupled pressure of step `t` into `q` and return it.

`p[b]` is stratum `b`'s kernel convolution at this step and `window` is the
`L × S` block of past values the step reads, oldest first.
Most couplings read `p` only: `I` scales it, a matrix `C` gives `q = C p`, and
a [`TimeVarying`](@ref) coupling uses its `t`-th slice.
A [`Pairwise`](@ref) coupling reads `window` directly.
Implement this method for a new coupling type.

# Arguments
- `q`: the output, one entry per stratum.
- `coupling`: the coupling.
- `p`: the per-stratum kernel convolutions.
- `window`: the past values, `L × S`, oldest first.
- `t`: the time index of the step.

# Examples
```@example
using ComposableRecurrences
q = zeros(2)
ComposableRecurrences.pressure!(q, [0.9 0.1; 0.2 0.8], [1.0, 2.0], ones(3, 2), 1)
```
"
function pressure! end

function pressure!(q, J::UniformScaling, p, window, t)
    λ = J.λ
    for a in eachindex(q, p)
        q[a] = λ * p[a]
    end
    return q
end

function pressure!(q, C::AbstractMatrix, p, window, t)
    for a in axes(C, 1)
        acc = zero(eltype(q))
        for b in axes(C, 2)
            acc += C[a, b] * p[b]
        end
        q[a] = acc
    end
    return q
end

function pressure!(q, C::Diagonal, p, window, t)
    d = C.diag
    for a in eachindex(q, p)
        q[a] = d[a] * p[a]
    end
    return q
end

function pressure!(q, C::SparseMatrixCSC, p, window, t)
    fill!(q, zero(eltype(q)))
    rows = rowvals(C)
    vals = nonzeros(C)
    for b in axes(C, 2)
        pb = p[b]
        for idx in nzrange(C, b)
            q[rows[idx]] += vals[idx] * pb
        end
    end
    return q
end

function pressure!(q, C::TimeVarying{<:AbstractArray{<:Any, 3}}, p, window, t)
    X = C.x
    for a in axes(X, 1)
        acc = zero(eltype(q))
        for b in axes(X, 2)
            acc += X[a, b, t] * p[b]
        end
        q[a] = acc
    end
    return q
end

function pressure!(q, C::Pairwise, p, window, t)
    X = C.x
    L = size(X, 3)
    for a in axes(X, 1)
        acc = zero(eltype(q))
        for i in 1:L, b in axes(X, 2)
            acc += X[a, b, i] * window[L + 1 - i, b]
        end
        q[a] = acc
    end
    return q
end

@doc "
Accumulate the reverse pass of [`pressure!`](@ref) for `coupling` at step `t`.

Given the cotangent `q̄` of the pressure, add the cotangents of `p` into `p̄`,
of the window into `window̄`, and of the coupling's parameters into
`couplinḡ`.
The package defines no methods; an operator is differentiated by the AD
backend.

# Arguments
- `p̄`: the cotangent of the kernel convolutions.
- `window̄`: the cotangent of the window.
- `couplinḡ`: the cotangent of the coupling's parameters.
- `coupling`: the coupling.
- `q̄`: the cotangent of the pressure.
- `p`: the kernel convolutions.
- `window`: the past values, `L × S`, oldest first.
- `t`: the step.

# Examples
```@example
using ComposableRecurrences
methods(ComposableRecurrences.pressure_pullback!)
```
"
function pressure_pullback! end

# Coupling shape checks against `S` strata.
_check_coupling(C, S) = nothing
function _check_coupling(C::AbstractMatrix, S)
    size(C) == (S, S) || throw(
        DimensionMismatch("coupling is $(size(C)), expected ($S, $S)")
    )
    return nothing
end
function _check_coupling(C::Union{TimeVarying, Pairwise}, S)
    size(C.x)[1:2] == (S, S) || throw(
        DimensionMismatch(
            "coupling is $(size(C.x)), expected ($S, $S, ...)"
        )
    )
    return nothing
end
