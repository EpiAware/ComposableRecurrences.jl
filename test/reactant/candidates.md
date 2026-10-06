## Candidates for the Reactant extension

Changes 1 to 4 live in `shims.jl` and are loaded only in the `shims` configuration; 5 and 6 are in the package.
They were found one at a time: add a shim, rerun, read the next failure.
The shims do not change `src/`; they are the starting list for the Reactant extension step.

1. `param_eltype` for traced arrays (`src/utils.jl`).
   A traced array's eltype is `TracedRNumber{T}`, which is not a `Real`, so the generic array method runs `mapreduce(param_eltype, promote_type, x; init = Bool)`.
   Reactant overlays that `mapreduce` as a traced reduction over types, and it fails with a `MethodError` in `unwrapped_eltype`.
   Every case fails here in `baseline`, forward and reverse, before any loop runs.
   Fix: `param_eltype(x::AbstractArray{<:TracedRNumber}) = eltype(x)`, which also covers reshapes and views of traced arrays.
2. Scalar indexing (`_at`, `_convolve_series!` and the buffer writes).
   The step loops read and write one element at a time, which Reactant refuses outside `@allowscalar`.
   Fix without a package change: the caller wraps the call in `Reactant.@allowscalar`, as `probe.jl` does in `shims`.
   The extension could do the same around its own entry point.
3. `dot` of a constant kernel with a traced view (`_kdot`, `src/recurrence.jl`).
   With a plain `Vector` kernel (a fixed generation interval) and any path other than a pointwise `I` coupling, `dot` calls `conj` on the plain vector with a traced-op keyword and fails.
   Hits dense `K`, `TimeVarying` couplings and modifiers that act on all strata at once.
   Fix: `_kdot(g::AbstractVector, H::AnyTracedRArray, ...) = sum(g .* view(H, ...))`.
4. Traced `reverse` mutates its argument (`_oldest_first`, `src/recurrence.jl`).
   Reactant's traced `reverse(g)` also reverses `g` in place.
   One call is right, but a second call with the same kernel, as when resuming from a returned state, reads it the wrong way round and gives wrong values (forward and reverse).
   Fix: `_oldest_first(g::AnyTracedRVector) = reverse(copy(g))`, and the same for `PerStratum`.
5. Buffers allocated like a constant history (`_zeros`, `src/utils.jl`).
   `_zeros(x, T, dims...)` calls `similar(x, T, dims)`, so a plain `Array` history, as a fixed seed is, gives an `Array` of traced numbers, and `fill!` on it fails.
   The package now allocates CPU buffers with `zeros(T, dims...)`, which is what the shim did, so the shim is gone: kept, it was ambiguous with that method and every `Recurrence` case failed with a `MethodError` in `_run`.
6. Value-dependent `if` in a step (`_protected_step`, `src/depletion_pools.jl`).
   A traced comparison gives a traced `Bool`, which `if` refuses with a `TypeError`.
   The protected pool's step now picks between its two arms with `ifelse`, with the division guarded so the unused arm stays finite; this is a package change, not a shim.

Two things to keep in mind when reading compile times.
The package's plain `for` loops are unrolled when traced, so compile time and program size grow with `T × S`; a production extension would move the step loop to `@trace for`.
Custom adjoints through the `pullback!` seam would not be used under Reactant: Enzyme-MLIR differentiates the traced primal.
