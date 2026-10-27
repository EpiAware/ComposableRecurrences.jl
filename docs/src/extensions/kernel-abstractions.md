# [KernelAbstractions extension](@id extension-kernel-abstractions)

`ComposableRecurrencesKernelAbstractionsExt` is loaded automatically when KernelAbstractions is available alongside ComposableRecurrences; KernelAbstractions loads Adapt, its second trigger.

It runs each loop of the [`Device`](@ref ComposableRecurrences.Device) executor as one kernel.
Each kernel thread runs its loop body serially, so the kernel receives plain data only, whichever executor the call was made under.
It also adds the Adapt.jl rules that carry the coefficient wrappers and built-in modifiers into a kernel, so a launch on any backend adapts the arrays they hold.
Every operator, coupling and built-in modifier runs forward on a [device](@ref executors).
