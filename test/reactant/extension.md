## The Reactant extension

`ext/ComposableRecurrencesReactantExt.jl` loads with Reactant.
Each method below was found by tracing the cases here one failure at a time, first as a shim in this folder and now in the extension.

1. `param_eltype` for traced arrays.
   A traced array's eltype is `TracedRNumber{T}`, which is not a `Real`, so the generic array method runs `mapreduce(param_eltype, promote_type, x; init = Bool)`.
   Reactant overlays that `mapreduce` as a traced reduction over types, and it fails with a `MethodError` in `unwrapped_eltype`.
   Without it every case fails before any loop runs.
   The method returns `eltype(x)`, which also covers reshapes and views of traced arrays.
2. Scalar indexing.
   The step loops read and write one entry at a time, which Reactant refuses outside `@allowscalar`.
   The extension adds a `_run` method for a traced eltype that runs the serial loop under `@allowscalar`, and a `_conv_buffers` method that does the same for `Convolution`, so a caller does not wrap the call.
   The executors are not used for a traced run: the traced program is compiled as a whole.
3. The kernel window product (`_kdot`).
   With a traced buffer the window product of a vector kernel is one broadcast product and sum, rather than `L` scalar reads.
4. Traced `reverse` mutates its argument (`_oldest_first`).
   Reactant's traced `reverse(g)` also reverses `g` in place.
   One call is right, but a second call with the same kernel, as when resuming from a returned state, would read it the wrong way round.
   The extension reverses a copy, for vector and `PerStratum` kernels.

A fifth shim, allocating buffers with `zeros` when the history is a plain `Array`, is no longer needed: the package allocates CPU buffers that way.

Two things to keep in mind when reading compile times.
The package's plain `for` loops are unrolled when traced, so compile time and program size grow with `T × S`; moving the step loop to `@trace for` would stop that.
Custom adjoints through the `pullback!` seam are not used under Reactant: Enzyme-MLIR differentiates the traced primal.
