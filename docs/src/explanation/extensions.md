# [Extensions](@id extensions)

Each extension loads when the packages named after it are loaded alongside ComposableRecurrences.
The Mooncake and Enzyme extensions register the rules that [Rules and plain AD](@ref adjoint-routing) describes.

## Mooncake

`ComposableRecurrencesMooncakeExt` (ADTypes, Mooncake, Random) registers the reverse-mode rule of every operator as a Mooncake `rrule!!`, and [`test_adjoint`](@ref ComposableRecurrences.test_adjoint) for `AutoMooncake`.
Plain Mooncake AD of a [`Convolution`](@ref) calls BLAS `axpy!` per lag, which Mooncake differentiates with one rule.

## Enzyme

`ComposableRecurrencesEnzymeExt` (Enzyme) registers the same rule as an Enzyme reverse rule.
It refuses [`NoAdjoint`](@ref ComposableRecurrences.NoAdjoint) on an active sparse coupling, where plain Enzyme reverse AD gives wrong gradients.

## EnzymeTestUtils

`ComposableRecurrencesEnzymeTestUtilsExt` (ADTypes, Enzyme, EnzymeTestUtils) adds [`test_adjoint`](@ref ComposableRecurrences.test_adjoint) for `AutoEnzyme`.

## KernelAbstractions

`ComposableRecurrencesKernelAbstractionsExt` (KernelAbstractions) adds the [`each!`](@ref ComposableRecurrences.each!) method for [`Device`](@ref ComposableRecurrences.Device), which runs each loop as one kernel.

## GPUArraysCore

`ComposableRecurrencesGPUArraysCoreExt` (GPUArraysCore, KernelAbstractions) makes calls on GPU arrays under the default [`Serial`](@ref ComposableRecurrences.Serial) executor run on their device.
[Executors](@ref executors) lists what runs there.

## Reactant

`ComposableRecurrencesReactantExt` (Reactant) lets operator calls on traced arrays compile with `Reactant.@compile`; see [Does it run under Reactant?](@ref faq-reactant).
