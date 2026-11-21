# [Adapt + KernelAbstractions extension](@id extension-kernel-abstractions)

Loading Adapt and KernelAbstractions with ComposableRecurrences loads `ComposableRecurrencesKernelAbstractionsExt`.
KernelAbstractions loads Adapt itself, so loading KernelAbstractions is enough.

It runs each loop of the [`Parallel`](@ref ComposableRecurrences.Parallel) executor as one kernel.
Each kernel thread runs its loop body serially, so the kernel receives plain data only, whichever executor the call was made under.
It also adds the Adapt.jl rules that carry the coefficient wrappers and built-in modifiers into a kernel, so a launch on any backend adapts the arrays they hold.
Every operator, coupling and built-in modifier runs forward on a [device](@ref executors).
