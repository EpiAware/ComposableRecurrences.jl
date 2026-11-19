module ComposableRecurrencesKernelAbstractionsExt

using ComposableRecurrences: ComposableRecurrences, Allocate,
    Convolution, Depletion, Derived, Flow, Pairwise, Parallel, PerStratum,
    Recent, Recurrence, Redistribute, TimeVarying, Transform,
    _AllocateImports, _BoundRecent, _Columns, _DrawFrom, _DrawInto, _Flat,
    _InKernel, _Movement, _OldestFirstPairwise, _PIECEWISE_DEVICE,
    _Piecewise, _Ragged, _RouteBuffers, _RouteKernels, _Routes,
    _TransposedConvolution, Serial, _kernel_args, _Owned, _ArrayStack,
    _ScalarStack
using Adapt: Adapt, adapt
using ConstructionBase: constructorof, getfields
using KernelAbstractions: @index, @kernel

# One kernel for every per-index body: thread `k` runs `body(k, args...)`.
# A number argument is read as its value, as a traced one reaches a kernel
# as a reference to it.
@kernel function _each_kernel!(body, args)
    k = @index(Global, Linear)
    body(k, map(_kernel_value, args)...)
end
_kernel_value(x) = x
_kernel_value(x::Number) = x[]

function ComposableRecurrences.each!(
        body::F, ex::Parallel, n, work, args::Vararg{Any, N}
    ) where {F, N}
    n == 0 && return nothing
    work < ex.min_work &&
        return ComposableRecurrences.each!(body, Serial(), n, work, args...)
    _launch!(ex.backend, body, _kernel_args(args), n)
    return nothing
end

# Launches the kernel on `backend` with `n` threads.
function _launch!(backend, body::F, args, n) where {F}
    _each_kernel!(backend)(body, args; ndrange = n)
    return nothing
end

# A kernel launch adapts its arguments to the backend, so every array they
# hold must be reachable by Adapt.jl. Coefficient wrappers and built-in
# modifiers are rebuilt from their adapted fields, as `constructorof`
# rebuilds them elsewhere. The operators adapt the same way, so
# `adapt(CuArray, r)` moves every parameter of `r` to a device.
const _Adapted = Union{
    PerStratum, Pairwise, TimeVarying, _OldestFirstPairwise, Depletion,
    Redistribute, Transform, Derived, Recurrence, _AllocateImports,
    _Movement, Convolution, Flow, _DrawFrom, _DrawInto, _Routes,
    _RouteKernels, _RouteBuffers, _TransposedConvolution, Recent,
}
function Adapt.adapt_structure(to, x::_Adapted)
    return constructorof(typeof(x))(map(f -> adapt(to, f), Tuple(getfields(x)))...)
end

# A `Recent` bound to a call's buffer, as the strata's kernels read it: its
# buffer, cotangent and windows move with it; its row and weights' mirror
# slots are not arrays. It is marked as in a kernel, where an error cannot
# build its message.
function Adapt.adapt_structure(to, b::_BoundRecent)
    return _BoundRecent(
        adapt(to, b.x), adapt(to, b.H), adapt(to, b.H̄), b.o, adapt(to, b.u),
        b.row, adapt(to, b.z), b.w̄, _InKernel()
    )
end

# The wrappers a reverse pass hands its kernels: mirrors each stratum
# writes at its own slots, and the stacked copies of shared ones.
Adapt.adapt_structure(to, x::_Owned) = _Owned(adapt(to, x.x))
Adapt.adapt_structure(to, x::_ArrayStack) = _ArrayStack(adapt(to, x.a))
Adapt.adapt_structure(to, x::_ScalarStack) = _ScalarStack(adapt(to, x.v))

# A ragged kernel moves its offsets with its values, rebuilt without the
# host check, as a kernel launch adapts it.
function Adapt.adapt_structure(to, g::_Ragged)
    return _Ragged(_Flat(), adapt(to, g.values), adapt(to, g.offsets))
end
# Columns held as given are stacked first: a device loop reads one array.
Adapt.adapt_structure(to, g::_Columns) = adapt(to, _Ragged(g.columns))
Adapt.adapt_structure(to, ::_Piecewise) = throw(ArgumentError(_PIECEWISE_DEVICE))

# `Allocate` keeps its groups, host index arrays that each step copies where
# it needs them, and adapts its totals and imports.
function Adapt.adapt_structure(to, m::Allocate)
    return constructorof(typeof(m))(
        m.strata, m.offsets, adapt(to, m.total), adapt(to, m.imports)
    )
end

end
