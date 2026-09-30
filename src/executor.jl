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

@doc raw"""
    each!(body, ex::Executor, n, work, args...)

Call `body(k, args...)` for every `k` in `1:n` with executor `ex`:

```math
\operatorname{body}(k, \ldots) \quad \text{for } k = 1, \ldots, n,
```

where each index `k` is one stratum (one of `S` series computed together,
such as a place or age group), one series or one output time.

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

"""
$(TYPEDEF)

Runs the indices of a loop in contiguous chunks, one task per thread.
With `m` threads, chunk `c` covers

```math
k = \\lfloor (c - 1) n / m \\rfloor + 1, \\ldots, \\lfloor c n / m \\rfloor,
\\qquad c = 1, \\ldots, m.
```

A loop whose `work` is below `min_work`, or a session with one thread,
runs in order on the calling task, as [`Serial`](@ref) does.
Results are identical to [`Serial`](@ref) because each index writes only
its own slots.

# Fields
$(TYPEDFIELDS)

# Examples
```@example
using ComposableRecurrences
const CR = ComposableRecurrences
y = zeros(4)
CR.each!((k, y) -> (y[k] = k^2; nothing), CR.Threaded(; min_work = 0), 4, 4, y)
y
```
"""
struct Threaded <: Executor
    "The smallest loop `work` that is split across threads."
    min_work::Int
end
Threaded(; min_work = 10_000) = Threaded(min_work)

@inline function each!(
        body::F, ex::Threaded, n, work, args::Vararg{Any, N}
    ) where {F, N}
    m = min(Threads.nthreads(), n)
    (m <= 1 || work < ex.min_work) &&
        return each!(body, Serial(), n, work, args...)
    run = function (ks)
        for k in ks
            @inline body(k, args...)
        end
        return nothing
    end
    _spawn_chunks(run, n, m)
    return nothing
end

# Run `run(ks)` on `m` contiguous chunks of `1:n`, one task each, and wait.
function _spawn_chunks(run::R, n, m) where {R}
    tasks = map(1:m) do c
        Threads.@spawn run(((c - 1) * n ÷ m + 1):(c * n ÷ m))
    end
    foreach(wait, tasks)
    return nothing
end

"""
The executor that operator calls use for their parallel loops, [`Serial`](@ref)
by default.

Set it for a block of code with `with`; operator types do not change.
Calls traced by an automatic differentiation backend, rather than
differentiated through the package's own adjoints, always run serially.

# Examples
```@example
using ComposableRecurrences
using Base.ScopedValues: with
const CR = ComposableRecurrences
with(CR.EXECUTOR => CR.Threaded()) do
    CR.EXECUTOR[]
end
```
"""
const EXECUTOR = ScopedValue{Executor}(Serial())
