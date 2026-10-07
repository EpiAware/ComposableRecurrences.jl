# [KernelAbstractions extension](@id extension-kernel-abstractions)

`ComposableRecurrencesKernelAbstractionsExt` is loaded automatically when KernelAbstractions is available alongside ComposableRecurrences.

It adds the [`each!`](@ref ComposableRecurrences.each!) method for [`Device`](@ref ComposableRecurrences.Device), which runs each loop as one kernel.
[Executors](@ref executors) lists what runs on a device.
