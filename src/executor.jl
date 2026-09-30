# Executors: how a loop over independent slots runs.
#
# A parallelisable loop is written once as a top-level per-index body
# `body(k, args...)` that writes only the slots it owns for index `k`
# (a stratum, a series or an output time) and returns `nothing`. The loop
# is then `each!(body, ex, n, work, args...)`, and the executor `ex` decides
# how the `n` indices run. Shared cotangents stay out of the bodies: they
# go to per-slot storage and are reduced after the loop.

"""
How [`ComposableRecurrences.each!`](@ref) runs a loop over independent
indices.

# Examples
```@example
using ComposableRecurrences
ComposableRecurrences.Serial() isa ComposableRecurrences.Executor
```
"""
abstract type Executor end

"""
$(TYPEDEF)

Runs every index in order on the calling task.

# Examples
```@example
using ComposableRecurrences
const CR = ComposableRecurrences
y = zeros(3)
CR.each!((k, y) -> (y[k] = k^2; nothing), CR.Serial(), 3, 3, y)
y
```
"""
struct Serial <: Executor end

"""
    each!(body, ex::Executor, n, work, args...)

Call `body(k, args...)` for every `k` in `1:n` with executor `ex`.

`body` must write only the slots it owns for index `k`, so the indices
can run in any order or at the same time.
`work` is an estimate of the loop's total cost in inner operations, which
an executor may use to run small loops in order; [`Serial`](@ref) ignores
it.
Returns `nothing`.

# Examples
```@example
using ComposableRecurrences
const CR = ComposableRecurrences
# Row sums of a matrix, one row per index.
rowsum!(k, y, A) = (y[k] = sum(view(A, k, :)); nothing)
A = [1.0 2.0; 3.0 4.0]
y = zeros(2)
CR.each!(rowsum!, CR.Serial(), 2, length(A), y, A)
y
```
"""
@inline function each!(
        body::F, ::Serial, n, work, args::Vararg{Any, N}
    ) where {F, N}
    for k in 1:n
        @inline body(k, args...)
    end
    return nothing
end
