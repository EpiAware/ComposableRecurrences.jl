# [Enzyme extension](@id extension-enzyme)

Loading Enzyme with ComposableRecurrences loads `ComposableRecurrencesEnzymeExt`.

It registers the [rule](@ref adjoint-routing) of every operator as an Enzyme reverse-mode rule.

On Julia 1.11, an operator built in code that Julia cannot infer can get a zero Enzyme reverse gradient for its scalar float fields.
Examples are `b` in [`Transform(+, b)`](@ref ComposableRecurrences.Transform) and the population of a [`Depletion`](@ref ComposableRecurrences.Depletion).
Uninferred code includes a closure that captures a variable it reassigns, or a call through a global that is not constant.
Enzyme loses the gradient in that code, before any rule runs, so the extension cannot detect or refuse it.
Instead it warns once per operator type, the first time Enzyme reverse mode differentiates an operator with an active scalar field on 1.11.
Use Julia 1.12 or later, where Enzyme keeps these gradients, or build operators in type-stable code (check it with `@code_warntype`).

Under Enzyme reverse mode, a modifier whose type depends on a run-time branch, such as `m = flag ? Depletion(N) : Depletion(N, Floor())`, makes the call fail with `TypeError: in new, expected Tuple{...}, got a value of type Tuple{Base.RefValue{...}}`.
A keyword chosen at run time does the same when it changes the modifier's type, such as [`Allocate`](@ref ComposableRecurrences.Allocate)'s `spill = flag ? Redistribute(P, 0.2) : nothing`.
The error comes from Enzyme when it differentiates the caller's keyword call `Recurrence(g; modifiers = (m,))`, before any package code runs.
Choose the loss before differentiating instead, so that the differentiated function builds each modifier with one type.
For example, take the gradient of the loss chosen by `flag`:
`loss = flag ? (θ -> model(Depletion(N), θ)) : (θ -> model(Depletion(N, Floor()), θ))`.
Branching inside the loss to one call per concrete modifier also avoids the error on Julia 1.11 and 1.12, but on Julia 1.13.3 and 1.13.4 Enzyme can crash while it compiles such a loss ([issue #314](https://github.com/EpiAware/ComposableRecurrences.jl/issues/314)).

Without runtime activity (`AutoEnzyme()`, or `Enzyme.Reverse` as given), Enzyme raises `EnzymeRuntimeActivityError` when an operator with an active component holds a constant array that lives outside the loss, such as a global population in `Depletion(PerStratum(N))`.
Use `AutoEnzyme(; mode = Enzyme.set_runtime_activity(Enzyme.Reverse))`, as the tutorials do, or build every such array inside the loss, the kernel included.

Under Enzyme reverse mode, joining a view to a matrix with `hcat`, or with `[a b]`, fails with `IllegalTypeAnalysisException` ([issue #672](https://github.com/EpiAware/ComposableRecurrences.jl/issues/672)).
This happens when a caller puts a run's history in front of its output, `hcat(h, r(; history = reshape(h, :, 1), add = A))`, and `h` is a view, as a parameter read from a flat vector is.
The error comes from Enzyme's type analysis of Base's `hcat`, with no package code involved; `vcat` fails the same way ([issue #299](https://github.com/EpiAware/ComposableRecurrences.jl/issues/299)).
Pass `include_history = true` instead, `r(; history = reshape(h, :, 1), add = A, include_history = true)`, which joins the history in front without `hcat`.
`cat(h, r(; history = reshape(h, :, 1), add = A); dims = 2)` also compiles, as does `collect`ing the view first.
Calling `Enzyme.API.strictAliasing!(false)` at the start of the session, before the first Enzyme gradient, also avoids the error.
It changes Enzyme's analysis for every later gradient, and turning it off after the error, in the same session, can crash on Julia 1.12 and 1.13.

On Julia 1.12 and later, repeated Enzyme forward-mode gradients can corrupt memory and crash the process in the garbage collector, after seconds or minutes of calls ([issue #321](https://github.com/EpiAware/ComposableRecurrences.jl/issues/321)).
The fault is in Enzyme's batch mode, which takes several tangents per pass, and needs no package code: a `copyto!` into a view is enough.
Take one tangent per pass instead, with `Enzyme.gradient(Enzyme.Forward, f, θ; chunk = Val(1))`.
This costs one pass per input, so Enzyme reverse mode is usually the better choice for a gradient.
