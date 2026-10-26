@doc raw"""
    transpose(c::Convolution)
    c'

The transpose of the convolution `c`: a sum that reads the series forward
from each time rather than back from it,

```math
z_{\sigma,i} = \sum_{l=0}^{L-1} k_{i,l}(\sigma)\, x_{\sigma+l,i},
\qquad \sigma = t_0, \dots, t_1,
```

for a [`ComposableRecurrences.Primary`](@ref) or fixed kernel, in the
notation of [`Convolution`](@ref).
If `c` without a gain or add input computes ``y = A u`` from its inputs
``u``, the transpose computes ``z = A^\top x``.
So column ``\sigma`` of a `Primary()` kernel weights the series from
time ``\sigma`` on: with the delay pmf of a cohort in that column, ``z``
is the expectation of the series at the end of each cohort's delay.
A [`ComposableRecurrences.Secondary`](@ref) kernel (the default for a
[`TimeVarying`](@ref) kernel) weights ``x_{\sigma+l,i}`` by
``k_{i,l}(\sigma + l)``, the column of the time it reads.
`c'` is the same operator, and the transpose of the transpose is `c`.

Called as `transpose(c)(x; tail = nothing, start = 1, stop)`, it covers
the absolute times `start:stop`:

  - `x`: the series, length `n` or `S × n`, read at absolute time `t`.
  - `tail`: the series after `t = n`, oldest first (any length `m`, or
    `S × m`); later values are zero. A series extended by its last value
    is `tail = fill(x[end], L - 1)`.
  - `start`: the first time; `1` by default.
  - `stop`: the last time, at most `n + m`; `n` by default.

The output has the layout of `x` and length `stop - start + 1`.
A `Primary()` kernel covers times up to `stop`, and any other
`TimeVarying` kernel the last time it reads, `min(stop + L - 1, n + m)`.

Its forward pass is the reverse pass of `c` and its reverse pass the
forward pass of `c`, so it costs what `c` costs, and its rules are those
of `c`.
It takes the direct method whatever the method of `c`.

# Examples
```jldoctest
using ComposableRecurrences
c = Convolution([0.5, 0.25, 0.25])
c'([1.0, 2.0, 4.0, 8.0])

# output

4-element Vector{Float64}:
 2.0
 4.0
 4.0
 4.0
```
"""
Base.transpose(c::Convolution) = _TransposedConvolution(c)
Base.adjoint(c::Convolution) = transpose(c)

# The transpose of a convolution, which runs the convolution's bodies with
# the roles of their inputs and outputs swapped.
struct _TransposedConvolution{C <: Convolution} <: AbstractOperator
    c::C
end
Base.transpose(t::_TransposedConvolution) = t.c
Base.adjoint(t::_TransposedConvolution) = t.c

function _invoke(
        t::_TransposedConvolution, route, x; tail = nothing, start = 1,
        stop = nothing
    )
    return adjoint_call(route, x, tail, start, stop)
end

function forward(
        t::_TransposedConvolution, ::Run, x; tail = nothing, start = 1,
        stop = nothing
    )
    return _run_forward(t, x, tail, start, stop)
end

# The series times `start:last` go in the time-first buffer `A`, row `j`
# holding time `start + j - 1`, as the output cotangent of the convolution.
# Its input cotangent is the output `Z`, whose row `o + σ` holds time `σ`
# from `σ = 1 - o`. The convolution's reverse body reads its inputs only
# for the kernel's cotangent, which is not taken here, so `Z` stands in for
# them.
function _run_forward(t::_TransposedConvolution, x, tail, start, stop)
    kernel = t.c.kernel
    Tp, S, n, stop, last = _check_transpose(kernel, x, tail, start, stop)
    A = _zeros(x, Tp, last - start + 1, S)
    _load_input!(A, x, 1 - start, min(n, last), start)
    tail === nothing ||
        _load_input!(A, tail, n + 1 - start, last - n, start - n)
    o = 1 - clamp(start - _nlags(kernel) + 1, 1, last + 1)
    Z = _zeros(x, Tp, o + last, S)
    _transpose_back!(Z, nothing, kernel, Z, A, o, start)
    out = _public(Z, (o + start):(o + stop), x)
    return out, (; A, n, o, start, stop, last)
end

# A call without a rule takes the path `_conv_path` picks. For numbers that
# do not vectorise, a fixed kernel's transpose is the gather body of the
# convolution with the kernel reversed, `z_σ = Σ_l k_{L-1-l} x_{σ+L-1-l}`,
# read `L - 1` times later, over the series and tail padded with zeros.
function _primal(t::_TransposedConvolution, x, tail, start, stop)
    kernel = t.c.kernel
    Tp, S, n, stop, last = _check_transpose(kernel, x, tail, start, stop)
    return _transpose_public(
        _conv_path(Tp, kernel, x), t, Tp, x, tail, S, n, start, stop
    )
end
function _transpose_public(
        ::_Buffered, t, ::Type{Tp}, x, tail, S, n, start, stop
    ) where {Tp}
    return first(_run_forward(t, x, tail, start, stop))
end
function _transpose_public(
        ::_Gathered, t, ::Type{Tp}, x, tail, S, n, start, stop
    ) where {Tp}
    kernel = t.c.kernel
    L = _nlags(kernel)
    series = _padded(x, tail, stop + L - 1)
    return _convolve_public(
        _Gathered(), Tp, _oldest_first(kernel), series, true, nothing,
        nothing, 0, S, start + L - 1, stop + L - 1
    )
end

# The series and tail joined, with zeros after them up to time `N`.
function _padded(x, tail, N)
    E = promote_type(eltype(x), tail === nothing ? Bool : eltype(tail))
    X = x isa AbstractVector ? zeros(E, N) : zeros(E, size(x, 1), N)
    n = _extent(x)
    m = tail === nothing ? 0 : min(_extent(tail), N - n)
    selectdim(X, ndims(X), 1:min(n, N)) .= selectdim(x, ndims(x), 1:min(n, N))
    m > 0 && (
        selectdim(X, ndims(X), (n + 1):(n + m)) .=
            selectdim(tail, ndims(tail), 1:m)
    )
    return X
end

# The forward pass of the convolution takes the output cotangent back to
# the series, and its reverse pass, with the series as its output
# cotangent, gives the kernel's.
function pullback!(grads, t::_TransposedConvolution, ::Run, cache)
    _count_pullback()
    (; A, n, o, start, stop, last) = cache
    x̄, t̄ = grads.args
    kernel = t.c.kernel
    Z̄ = _zeros(A, eltype(A), o + last, size(A, 2))
    _load_input!(Z̄, grads.y, o + start - 1, stop - start + 1)
    Ā = zero(A)
    cur = _current()
    if cur.ex isa Serial
        _convolve!(Serial(), Ā, kernel, Z̄, o, start)
    else
        _convolve!(cur, Ā, kernel, Z̄, o, start)
    end
    k̄ = cotangent(cotangent(grads.piece, :c), :kernel)
    k̄ === nothing ||
        _transpose_back!(zero(Z̄), k̄, kernel, Z̄, A, o, start)
    _add_rows!(x̄, Ā, 1 - start, start, min(n, last))
    _add_rows!(t̄, Ā, n + 1 - start, max(start - n, 1), last - n)
    return nothing
end

function _transpose_back!(X̄, k̄, kernel, X, Ȳ, o, start)
    cur = _current()
    if cur.ex isa Serial
        _convolve_back!(Serial(), X̄, k̄, kernel, X, Ȳ, o, start)
    else
        _convolve_back!(cur, X̄, k̄, kernel, X, Ȳ, o, start)
    end
    return nothing
end

# Checks a call of the transpose; returns the buffer eltype, the strata,
# the series length, the last output time and the last series time read.
function _check_transpose(kernel, x, tail, start, stop)
    _check_unwrapped(:x, x)
    _check_unwrapped(:tail, tail)
    S = _nstrata(x)
    n = _extent(x)
    _check_tail(tail, x)
    _check_kernel_strata(kernel, S)
    m = tail === nothing ? 0 : size(tail, ndims(tail))
    stop = stop === nothing ? n : stop
    start >= 1 || throw(ArgumentError("start ($start) must be at least 1"))
    stop >= start - 1 || throw(
        ArgumentError("stop ($stop) is before start ($start)")
    )
    stop <= n + m || throw(
        DimensionMismatch(
            "x and tail cover $(n + m) times, fewer than stop = $stop"
        )
    )
    last = min(stop + _nlags(kernel) - 1, n + m)
    _check_kernel_times(kernel, _transpose_reach(kernel, stop, last))
    _check_device(x, (kernel, tail))
    Tp = float(param_eltype((kernel, x, tail)))
    return Tp, S, n, stop, last
end

# The last kernel column the transpose reads: a `Primary()` kernel's
# column is the time of the output, any other's the time it reads.
_transpose_reach(kernel, stop, last) = last
_transpose_reach(::TimeVarying{Primary}, stop, last) = stop

_check_tail(::Nothing, x) = nothing
function _check_tail(tail, x)
    ndims(tail) == ndims(x) && _nstrata(tail) == _nstrata(x) || throw(
        DimensionMismatch(
            "tail is $(summary(tail)) but x is $(summary(x)): tail must " *
                "have the strata of x"
        )
    )
    Base.require_one_based_indexing(tail)
    return nothing
end
