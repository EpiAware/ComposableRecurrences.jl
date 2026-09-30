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

# Column by column, the order a column-major matrix is stored in.
function pressure!(q, C::AbstractMatrix, p, window, t)
    fill!(q, zero(eltype(q)))
    for b in axes(C, 2)
        pb = p[b]
        for a in axes(C, 1)
            q[a] += C[a, b] * pb
        end
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
    fill!(q, zero(eltype(q)))
    for b in axes(X, 2)
        pb = p[b]
        for a in axes(X, 1)
            q[a] += X[a, b, t] * pb
        end
    end
    return q
end

function pressure!(q, C::Pairwise, p, window, t)
    X = C.x
    L = size(X, 3)
    fill!(q, zero(eltype(q)))
    for i in 1:L, b in axes(X, 2)
        w = window[L + 1 - i, b]
        for a in axes(X, 1)
            q[a] += X[a, b, i] * w
        end
    end
    return q
end

@doc "
Accumulate the reverse pass of [`pressure!`](@ref) for `coupling` at step `t`.

Given the cotangent `q̄` of the pressure, add the cotangents of `p` into `p̄`,
of the window into `window̄`, and of the coupling's parameters into the mirror
`couplinḡ` (see [`ComposableRecurrences.pullback!`](@ref) for mirrors).
A time-varying coupling adds its cotangent at time `t`.
The default is a local ForwardDiff Jacobian of `pressure!` in `p`, the window
and the coupling's parameters.

# Arguments
- `p̄`: the cotangent of the kernel convolutions.
- `window̄`: the cotangent of the window, or `nothing`.
- `couplinḡ`: the mirror of the coupling, or `nothing`.
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

# The built-in couplings carry their adjoints.
uses_adjoint(::Union{UniformScaling, AbstractMatrix, TimeVarying, Pairwise}) = true

# Coupling shape checks against `S` strata.
_check_coupling(C, S) = nothing
function _check_coupling(C::AbstractMatrix, S)
    size(C) == (S, S) || throw(
        DimensionMismatch("coupling is $(size(C)), expected ($S, $S)")
    )
    return nothing
end
function _check_coupling(C::TimeVarying, S)
    ndims(C.x) == 3 || throw(
        ArgumentError(
            "a TimeVarying coupling is S × S × T, got a " *
                "$(ndims(C.x))-dimensional array of size $(size(C.x))"
        )
    )
    return _check_pair_dims(C, S)
end
_check_coupling(C::Pairwise, S) = _check_pair_dims(C, S)
function _check_pair_dims(C, S)
    size(C.x)[1:2] == (S, S) || throw(
        DimensionMismatch(
            "coupling is $(size(C.x)), expected ($S, $S, ...)"
        )
    )
    return nothing
end

function pressure_pullback!(p̄, window̄, J̄, J::UniformScaling, q̄, p, window, t)
    λ̄ = cotangent(J̄, :λ)
    for a in eachindex(q̄, p)
        p̄[a] += J.λ * q̄[a]
        add_cotangent!(λ̄, q̄[a] * p[a])
    end
    return nothing
end

function pressure_pullback!(p̄, window̄, C̄, C::AbstractMatrix, q̄, p, window, t)
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

function pressure_pullback!(p̄, window̄, C̄, C::Diagonal, q̄, p, window, t)
    d̄ = cotangent(C̄, :diag)
    for a in eachindex(q̄, p)
        p̄[a] += C.diag[a] * q̄[a]
        add_cotangent!(d̄, q̄[a] * p[a], a)
    end
    return nothing
end

# The cotangent keeps the sparsity pattern: only the nonzeros get one.
function pressure_pullback!(p̄, window̄, C̄, C::SparseMatrixCSC, q̄, p, window, t)
    rows = rowvals(C)
    vals = nonzeros(C)
    nz̄ = cotangent(C̄, :nzval)
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

function pressure_pullback!(
        p̄, window̄, C̄, C::TimeVarying{<:AbstractArray{<:Any, 3}}, q̄, p, window, t
    )
    X = C.x
    X̄ = cotangent(C̄, :x)
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

function pressure_pullback!(p̄, window̄, C̄, C::Pairwise, q̄, p, window, t)
    X = C.x
    X̄ = cotangent(C̄, :x)
    L = size(X, 3)
    for i in 1:L, b in axes(X, 2)
        w = window[L + 1 - i, b]
        acc = zero(eltype(q̄))
        for a in axes(X, 1)
            acc += X[a, b, i] * q̄[a]
            add_cotangent!(X̄, q̄[a] * w, a, b, i)
        end
        window̄ === nothing || (window̄[L + 1 - i, b] += acc)
    end
    return nothing
end
