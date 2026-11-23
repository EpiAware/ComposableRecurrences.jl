# [Rules for every type](@id extending-rules)

Every `forward!` and `pullback!` keeps these rules, whichever page of [Writing new types](@ref extending) it follows.

## [Number types](@id extending-number-types)

`forward!` must be generic in the element type of its arguments.
A dual number, a `Float32` or a tracked value can arrive in `v`, `s` or a field.
So do not annotate `Float64` or build `0.0`; use `zero(v)`, `oftype` and fields with type parameters.

## [Arguments of a pullback](@id extending-pullback-arguments)

In `pullback!`, `v`, `s`, `p` and `history` are the values `forward!` was given, so the values before the step.
Read them, but do not write to them.
Leave `grads` and the arguments after the role in `pullback!` untyped, so that the rule finds the method.
A type without a `pullback!` still takes the rule when the [local step](@ref adjoint-local-step) can rebuild it.

## [Pointwise steps](@id extending-pointwise-rules)

A pointwise modifier sets [`blocks`](@ref ComposableRecurrences.blocks) to `(1, 1)`, and writes entry `k` of `v` and `s` from entry `k` only, for each `k` in `eachindex(v)`.

- Loop over `eachindex(v)` and read parameters with [`param`](@ref ComposableRecurrences.param), rather than broadcast; the `:pointwise` check of `PieceInterface` reports a broadcast.
- Its `Init` writes `s[k]` from the parameters read at stratum `k` and time 1 and from row `k` of the history only.
  Without an `Init` `pullback!`, its derivative is then taken stratum by stratum, and the `:pointwise` check tests it.
- Such a step runs under [`Parallel`](@ref ComposableRecurrences.Parallel) when it reads and writes only `eachindex(v)` entries, and allocates nothing.

## [Threads](@id extending-threads)

Under [`Threaded`](@ref ComposableRecurrences.Threaded) the steps of different strata can run at once.
So a step writes only its own stratum's slots, and never to the type's fields.
A mirror with an entry that is not a float array or a `Ref` of a number runs the reverse loop on one task; [Executors](@ref executors) says how the others are split.
