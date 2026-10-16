module ComposableRecurrencesKernelAbstractionsExt

using ComposableRecurrences: ComposableRecurrences, Add, Allocate, Clamp,
    Convolution, Derived, Device, Flow, Pairwise, PerStratum, Pool, Recurrence,
    Redistribute, TimeVarying, Transform, _AllocateImports, _Columns, _Flat,
    _OldestFirstPairwise, _PIECEWISE_DEVICE, _Piecewise, _Ragged, _kernel_args
using Adapt: Adapt, adapt
using ConstructionBase: constructorof, getfields
using KernelAbstractions: @index, @kernel

# One kernel for every per-index body: thread `k` runs `body(k, args...)`.
@kernel function _each_kernel!(body, args)
    k = @index(Global, Linear)
    body(k, args...)
end

function ComposableRecurrences.each!(
        body::F, ex::Device, n, work, args::Vararg{Any, N}
    ) where {F, N}
    n == 0 && return nothing
    _each_kernel!(ex.backend)(body, _kernel_args(args); ndrange = n)
    return nothing
end

# A kernel launch adapts its arguments to the backend, so every array they
# hold must be reachable by Adapt.jl. Coefficient wrappers and built-in
# modifiers are rebuilt from their adapted fields, as `constructorof`
# rebuilds them elsewhere. The operators adapt the same way, so
# `adapt(CuArray, r)` moves every parameter of `r` to a device.
const _Adapted = Union{
    PerStratum, Pairwise, TimeVarying, _OldestFirstPairwise, Pool, Add,
    Clamp, Redistribute, Transform, Derived, Recurrence, _AllocateImports,
    Convolution, Flow,
}
function Adapt.adapt_structure(to, x::_Adapted)
    return constructorof(typeof(x))(map(f -> adapt(to, f), Tuple(getfields(x)))...)
end

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
