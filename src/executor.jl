# Executors: how a loop over independent slots runs.
#
# A parallelisable loop is written once as a top-level per-index body
# `body(k, args...)` that writes only the slots it owns for index `k`
# (a stratum, a series or an output time) and returns `nothing`. The loop
# is then `each!(body, ex, n, work, args...)`, and the executor `ex` decides
# how the `n` indices run. Shared cotangents stay out of the bodies: they
# go to per-slot storage and are reduced after the loop.

@doc raw"""
How [`ComposableRecurrences.each!`](@ref) runs a loop over independent
indices.
Every executor `e` calls the same bodies, so the result does not depend on
it:

```math
\operatorname{each!}_e(\operatorname{body}, n) =
\{\operatorname{body}(k) : k = 1, \ldots, n\}.
```

# Examples
```jldoctest
using ComposableRecurrences
ComposableRecurrences.Serial() isa ComposableRecurrences.Executor

# output

true
```
"""
abstract type Executor end

@doc raw"""
Runs every index in order on the calling task:

```math
\operatorname{body}(1), \operatorname{body}(2), \ldots, \operatorname{body}(n).
```

# Examples
```jldoctest
using ComposableRecurrences
const CR = ComposableRecurrences
y = zeros(3)
CR.each!((k, y) -> (y[k] = k^2; nothing), CR.Serial(), 3, 3, y)
y

# output

3-element Vector{Float64}:
 1.0
 4.0
 9.0
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
A new executor type adds a method of `each!`.
Returns `nothing`.

# Arguments
- `body`: the per-index function, called as `body(k, args...)`.
- `ex`: the executor that runs the loop.
- `n`: the number of indices.
- `work`: an estimate of the loop's total cost in inner operations, which
  an executor may use to run small loops in order; [`Serial`](@ref) ignores
  it.
- `args`: the arguments passed to every call of `body`.

# Examples
```jldoctest
using ComposableRecurrences
const CR = ComposableRecurrences
# Row sums of a matrix, one row per index.
rowsum!(k, y, A) = (y[k] = sum(view(A, k, :)); nothing)
A = [1.0 2.0; 3.0 4.0]
y = zeros(2)
CR.each!(rowsum!, CR.Serial(), 2, length(A), y, A)
y

# output

2-element Vector{Float64}:
 3.0
 7.0
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

@doc raw"""
Runs the indices of a loop in contiguous chunks, one task per chunk.
With `m` chunks, chunk `c` covers

```math
k = \lfloor (c - 1) n / m \rfloor + 1, \ldots, \lfloor c n / m \rfloor,
\qquad c = 1, \ldots, m.
```

There are `m = min(ntasks, n)` chunks, with `ntasks` the number of threads
unless it is set.
A loop whose `work` is below `min_work`, or with one chunk, runs in order on
the calling task, as [`Serial`](@ref) does.
The threshold applies to each loop.
Independent strata are one loop per call, but strata that mix through a
coupling, a pairwise kernel or a modifier with a vector step are one loop
per step, so such models gain only with many strata.
Results are identical to [`Serial`](@ref) because each index writes only
its own slots.
Errors inside a split loop arrive wrapped in a `CompositeException`.
On arrays that live on a GPU, `Threaded` spawns CPU tasks that index the
arrays from the host; use [`Device`](@ref) there.

# Examples
```jldoctest
using ComposableRecurrences
const CR = ComposableRecurrences
y = zeros(4)
ex = CR.Threaded(; min_work = 0, ntasks = 2)
CR.each!((k, y) -> (y[k] = k^2; nothing), ex, 4, 4, y)
y

# output

4-element Vector{Float64}:
  1.0
  4.0
  9.0
 16.0
```
"""
struct Threaded <: Executor
    "The smallest loop `work` that is split across threads."
    min_work::Int
    "The most chunks a loop is split into; `0` uses the number of threads."
    ntasks::Int
    function Threaded(min_work, ntasks)
        min_work >= 0 || throw(
            ArgumentError("min_work must be at least 0, got $(repr(min_work))")
        )
        ntasks >= 0 || throw(
            ArgumentError("ntasks must be at least 0, got $(repr(ntasks))")
        )
        return new(min_work, ntasks)
    end
end
Threaded(; min_work = 100_000, ntasks = 0) = Threaded(min_work, ntasks)

@inline function each!(
        body::F, ex::Threaded, n, work, args::Vararg{Any, N}
    ) where {F, N}
    _splits(ex, n, work) || return each!(body, Serial(), n, work, args...)
    m = _nchunks(ex, n)
    run = function (ks)
        for k in ks
            @inline body(k, args...)
        end
        return nothing
    end
    _spawn_chunks(run, n, m)
    return nothing
end

# The number of chunks `Threaded` splits a loop of `n` indices into, and
# whether it splits one of cost `work`.
_nchunks(ex::Threaded, n) = min(ex.ntasks > 0 ? ex.ntasks : Threads.nthreads(), n)
_splits(ex::Threaded, n, work) = _nchunks(ex, n) > 1 && work >= ex.min_work

# Run `run(ks)` on `m` contiguous chunks of `1:n`, one task each, and wait
# for every task, so a failing chunk cannot leave others writing after the
# loop returns; failures are rethrown together.
function _spawn_chunks(run::R, n, m) where {R}
    @sync for c in 1:m
        Threads.@spawn run(((c - 1) * n ÷ m + 1):(c * n ÷ m))
    end
    return nothing
end

@doc raw"""
The executor that operator calls use for their parallel loops, [`Serial`](@ref)
by default.

Set it for a block of code with `with`; operator types do not change.
An operator `op` gives the same output under any two executors `e_1` and
`e_2`:

```math
\operatorname{op}_{e_1}(x) = \operatorname{op}_{e_2}(x).
```

Each operator call reads it once.
`Threaded` needs every modifier the loops run, including user-defined ones,
to write only its own stratum's slots.
[Executors](@ref executors) says which passes use it under each AD backend.

# Examples
```jldoctest
using ComposableRecurrences
using Base.ScopedValues: with
const CR = ComposableRecurrences
with(CR.EXECUTOR => CR.Threaded()) do
    CR.EXECUTOR[]
end

# output

ComposableRecurrences.Threaded(100000, 0)
```
"""
const EXECUTOR = ScopedValue{Executor}(Serial())

@doc raw"""
Runs every index of a loop as one thread of a kernel on a device, such as a
GPU: thread `k` computes

```math
\operatorname{body}(k), \qquad k = 1, \ldots, n.
```

`backend` is a `KernelAbstractions` backend, such as `CUDABackend()`, and
the arrays the loop reads and writes must live on it.
Kernel launches on one device run in order, so a loop reads the writes of
the loop before it; reading the result on the host waits for them.
Needs `KernelAbstractions` to be loaded.
Under the default [`Serial`](@ref) executor, operator calls on arrays that
live on a GPU (with `GPUArraysCore` loaded) run their strata loops with it
without being asked.
Parts that index arrays on the host, such as dense and sparse couplings,
`Depletion` and modifiers with a vector step, do not run on a device yet.

# Examples
```jldoctest; setup = :(using JLArrays, KernelAbstractions)
using ComposableRecurrences, JLArrays, KernelAbstractions
const CR = ComposableRecurrences
y = JLArray(zeros(4))
ex = CR.Device(KernelAbstractions.get_backend(y))
CR.each!((k, y) -> (y[k] = k^2; nothing), ex, 4, 4, y)
Array(y)

# output

4-element Vector{Float64}:
  1.0
  4.0
  9.0
 16.0
```
"""
struct Device{B} <: Executor
    "The backend the loop's kernel runs on."
    backend::B
end

# The executor a call on arrays like `x` uses under executor `ex`; a
# device array selects its device.
_resolve(ex::Executor, x) = ex

# The executor an operator call read from `EXECUTOR`. Its field is typed
# only as `Executor`; holding it in a concrete wrapper keeps the call's own
# arguments concretely typed, so passing it down boxes nothing.
struct _Current
    ex::Executor
end
_current() = _Current(EXECUTOR[])

# The loop `each!(body, ex, n, work, args...)` as operators run it, for the
# executor `c.ex` of a call and arrays like `x`. Operators pass the default
# executor as the singleton `Serial()` (the method below), so here a
# `Threaded` loop too small to split runs inline with no dynamic dispatch.
# A loop that does split is reached by a dynamic call, so the inline path
# holds no task code: reverse-mode AD backends that compile the whole call
# never see tasks unless a loop is split.
@inline function _each!(
        body::F, c::_Current, x, n, work, args::Vararg{Any, N}
    ) where {F, N}
    ex = c.ex
    if ex isa Threaded && !_splits(ex, n, work)
        each!(body, Serial(), n, work, args...)
    else
        _each_dynamic!(body, c, x, n, work, args...)
    end
    return nothing
end

# The default executor, known at compile time; on device arrays it runs on
# their device.
@inline function _each!(
        body::F, ex::Serial, x, n, work, args::Vararg{Any, N}
    ) where {F, N}
    each!(body, _resolve(ex, x), n, work, args...)
    return nothing
end

@noinline function _each_dynamic!(
        body::F, c::_Current, x, n, work, args...
    ) where {F}
    each!(body, _resolve(c.ex, x), n, work, args...)
    return nothing
end

# `body(ks, args...)` over blocks `ks` of `1:n` that together cover it once:
# one block for `Serial`, one per chunk for `Threaded` and one per index
# otherwise. A body that loops over time inside its block keeps the serial
# loop order, so serial runs match a loop written by hand.
@inline function _blocks!(
        body::F, c::_Current, x, n, work, args::Vararg{Any, N}
    ) where {F, N}
    ex = c.ex
    if (ex isa Serial && _resolve(ex, x) isa Serial) ||
            (ex isa Threaded && !_splits(ex, n, work))
        n == 0 || @inline body(1:n, args...)
    else
        _blocks_dynamic!(body, c, x, n, work, args...)
    end
    return nothing
end

@inline function _blocks!(
        body::F, ex::Serial, x, n, work, args::Vararg{Any, N}
    ) where {F, N}
    if _resolve(ex, x) isa Serial
        n == 0 || @inline body(1:n, args...)
    else
        _blocks_on!(body, _resolve(ex, x), n, work, args...)
    end
    return nothing
end

@noinline function _blocks_dynamic!(
        body::F, c::_Current, x, n, work, args...
    ) where {F}
    _blocks_on!(body, _resolve(c.ex, x), n, work, args...)
    return nothing
end

function _blocks_on!(body::F, ex::Threaded, n, work, args...) where {F}
    if _splits(ex, n, work)
        _spawn_chunks(ks -> body(ks, args...), n, _nchunks(ex, n))
    else
        n == 0 || body(1:n, args...)
    end
    return nothing
end
function _blocks_on!(body::F, ex::Executor, n, work, args...) where {F}
    each!(_Single(body), ex, n, work, args...)
    return nothing
end

# A block body called on the one-index block `k:k`.
struct _Single{F}
    body::F
end
@inline (s::_Single)(k, args::Vararg{Any, N}) where {N} = s.body(k:k, args...)
