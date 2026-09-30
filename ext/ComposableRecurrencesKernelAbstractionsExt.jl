module ComposableRecurrencesKernelAbstractionsExt

using ComposableRecurrences: ComposableRecurrences, Device
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
    _each_kernel!(ex.backend)(body, args; ndrange = n)
    return nothing
end

end
