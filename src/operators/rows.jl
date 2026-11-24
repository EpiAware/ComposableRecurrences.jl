# A Convolution of one input series per stratum: the series are stacked as
# the rows of the strata × time input and the output split back into one
# series per stratum, each step an operator of its own so every backend
# takes its rule rather than differentiating the copies.

# == The call ==

# A tuple of series, one per stratum, returns a tuple of outputs.
function _invoke(
        c::Convolution, route, x::Tuple{AbstractVector, Vararg{AbstractVector}};
        gain = true, add = nothing, history = nothing, start = 1, stop = nothing
    )
    X = _row_route(route, _StackRows())(x)
    Y = adjoint_call(route, X, gain, add, history, start, stop)
    return _row_route(route, _SplitRows{length(x)}())(Y)
end
# Under `NoAdjoint` the backend differentiates the copies too.
_row_route(route, op) = op
_row_route(::NoAdjoint, op) = NoAdjoint(op)

# == Stacking ==

# Series `k` of the tuple `xs` as row `k` of an `S × T` matrix. The tuple is
# one argument, so a backend that differentiates the call specialises on it.
struct _StackRows <: AbstractOperator end
uses_adjoint(::_StackRows, ::Run) = true
_run_forward(op::_StackRows, xs::Tuple) = _stack_rows(xs), nothing
_primal(op::_StackRows, xs::Tuple) = _stack_rows(xs)
function _stack_rows(xs::Tuple)
    n = length(first(xs))
    all(x -> length(x) == n, xs) || throw(
        DimensionMismatch(
            "the series of a Convolution are one per stratum and of one " *
                "length, got lengths $(map(length, xs))"
        )
    )
    T = promote_type(map(eltype, xs)...)
    X = _zeros(first(xs), T, length(xs), n)
    for (k, x) in enumerate(xs)
        X[k, :] .= x
    end
    return X
end
function pullback!(grads, op::_StackRows, ::Run, cache)
    _count_pullback()
    x̄s = grads.args[1]
    x̄s === nothing && return nothing
    for (k, x̄) in enumerate(x̄s)
        x̄ === nothing || (x̄ .+= view(grads.y, k, :))
    end
    return nothing
end

# == Splitting ==

# Row `k` of an `S × T` matrix as series `k`, for `S` known from the type.
struct _SplitRows{S} <: AbstractOperator end
uses_adjoint(::_SplitRows, ::Run) = true
_run_forward(op::_SplitRows, Y::AbstractMatrix) = _split_rows(op, Y), nothing
_primal(op::_SplitRows, Y::AbstractMatrix) = _split_rows(op, Y)
function _split_rows(::_SplitRows{S}, Y) where {S}
    return ntuple(k -> Y[k, :], Val(S))
end
function pullback!(grads, op::_SplitRows{S}, ::Run, cache) where {S}
    _count_pullback()
    Ȳ = grads.args[1]
    Ȳ === nothing && return nothing
    for k in 1:S
        ȳ = grads.y[k]
        ȳ === nothing || (view(Ȳ, k, :) .+= ȳ)
    end
    return nothing
end
