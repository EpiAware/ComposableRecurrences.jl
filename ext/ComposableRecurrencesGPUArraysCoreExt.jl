module ComposableRecurrencesGPUArraysCoreExt

using ComposableRecurrences: ComposableRecurrences, Device, Serial
using GPUArraysCore: AbstractGPUArray
using KernelAbstractions: get_backend

ComposableRecurrences._resolve(::Serial, x::AbstractGPUArray) = Device(get_backend(x))

end
