## The Reactant extension

`ext/ComposableRecurrencesReactantExt.jl` loads with Reactant.
Each method below was found by tracing the cases here one failure at a time, first as a shim in this folder and now in the extension.

1. `param_eltype` for traced arrays.
   A traced array's eltype is `TracedRNumber{T}`, which is not a `Real`, so the generic array method runs `mapreduce(param_eltype, promote_type, x; init = Bool)`.
   Reactant overlays that `mapreduce` as a traced reduction over types, and it fails with a `MethodError` in `unwrapped_eltype`.
   Without it every case fails before any loop runs.
   The method returns `eltype(x)`, which also covers reshapes and views of traced arrays.
2. A traced executor and a traced time loop.
   A call whose buffer eltype is traced runs `_run` (and `_conv_buffers` for `Convolution`) with the extension's `Traced` executor, under `@allowscalar`, so a caller does not wrap the call.
   The package writes its time loop once, as `_steps!(body, ex, T, args...)`.
   For `Traced` it is `@trace track_numbers = false for t in 1:T`, which compiles to one `stablehlo.while` whose body is the step.
   `track_numbers = false` keeps the integers the step closes over, such as the number of lags, as constants rather than loop-carried values.
   The strata loops inside a step are written out in order, so the program grows with the strata but not with the steps.
3. Traced buffers.
   `_zeros` at a traced eltype gives a traced array, which the loop carries and updates in place, rather than a Julia array of traced numbers.
4. Windows at a traced step.
   Reactant does not slice with a range whose start is traced, so the kernel window (`_kdot`), a `Recent` window (`_recent_window`) and the column of a lags × time kernel (`_wcolumn`) are each one `dynamic_slice`.
   The buffer is already `D` rows deep before the first step, so every window has a fixed length.
   A kernel or parameter that is not traced is read at the traced step as a constant of the program.
5. Lags that depend on the step (`_lags`, `_column`, `_weight`).
   A `Primary()` kernel reads lags up to `τ - 1` and a ragged column has its own length, but a traced step needs a fixed number of lags.
   At a traced step every lag runs: a `Primary()` lag before time 1 reads the first column and meets a zero in the buffer, as a seed sits at times from 1, and a ragged weight past its column's end is zero.
6. `Recent` at a traced step (`_recent_row`, `_cached`, `_cache_row!`).
   Inside the traced loop `Recent` is read only at the step's own buffer row, which the buffer depth covers, so the read skips its bounds check.
   With a coupling the loop fills that row's windows before the strata read them, so the read takes them without comparing rows.
7. A traced convolution (`_convolve!`).
   Each output time is a step of the traced loop.
   The input buffer gains `D - 1` zero rows on top, so every lag reads inside it, and a `Primary()` kernel's column before time 1 is read clamped to the first, where it meets a zero input.
8. Traced `reverse` mutates its argument (`_oldest_first`).
   Reactant's traced `reverse(g)` also reverses `g` in place.
   One call is right, but a second call with the same kernel, as when resuming from a returned state, would read it the wrong way round.
   The extension reverses a copy, for vector and `PerStratum` kernels.

Steps whose arm depends on the time or a value pick it with `ifelse` rather than `if`, since `if` refuses a traced `Bool`.
This lives in the package for the draw of a `Pool` with several pools (`_draw_pools`, `src/pool.jl`).
The soft minimum of `SoftTruncate` (`_soft_min`) keeps its early returns in the package, which plain Julia and ForwardDiff run faster, and the extension adds a branch-free method for traced values.

Things to keep in mind when reading the tables.
The control row's compile time is Reactant's fixed first-compile cost; the rest of a cell's compile time does not grow with `T`.
Custom adjoints through the `pullback!` seam are not used under Reactant: Enzyme-MLIR differentiates the traced primal.
A `Recent` read without a coupling, with a window longer than the kernel, runs about ten times slower than plain Julia per step on CPU.
