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
    _splits(ex, n, work) || return each!(body, Serial(), n, work, args...)
    m = min(Threads.nthreads(), n)
    run = function (ks)
        for k in ks
            @inline body(k, args...)
        end
        return nothing
    end
    _spawn_chunks(run, n, m)
    return nothing
end

# Whether `Threaded` splits a loop of `n` indices and cost `work`.
function _splits(ex::Threaded, n, work)
    return min(Threads.nthreads(), n) > 1 && work >= ex.min_work
end

# Run `run(ks)` on `m` contiguous chunks of `1:n`, one task each, and wait
# for every task, so a failing chunk cannot leave others writing after the
# loop returns; failures are rethrown together.
function _spawn_chunks(run::R, n, m) where {R}
    @sync for c in 1:m
        Threads.@spawn run(((c - 1) * n ÷ m + 1):(c * n ÷ m))
    end
    return nothing
end

"""
The executor that operator calls use for their parallel loops, [`Serial`](@ref)
by default.

Set it for a block of code with `with`; operator types do not change.
Each operator call reads it once.
`Threaded` needs every modifier the loops run, including user-defined ones,
to write only its own stratum's slots.
Enzyme and Mooncake reverse mode do not differentiate tasks, so calls they
differentiate run serially whatever executor is set; ForwardDiff runs the
set executor.

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

"""
$(TYPEDEF)

Runs every index of a loop as one thread of a kernel on a device, such as a
GPU.

`backend` is a `KernelAbstractions` backend, such as `CUDABackend()`, and
the arrays the loop reads and writes must live on it.
Kernel launches on one device run in order, so a loop reads the writes of
the loop before it; reading the result on the host waits for them.
Needs `KernelAbstractions` to be loaded.
Under the default [`Serial`](@ref) executor, operator calls on arrays that
live on a GPU (with `GPUArraysCore` loaded) run their strata loops with it
without being asked.
Pieces that index arrays on the host, such as dense and sparse couplings,
`Depletion` and modifiers with a vector step, do not run on a device yet.

# Fields
$(TYPEDFIELDS)

# Examples
```@example
using ComposableRecurrences, JLArrays, KernelAbstractions
const CR = ComposableRecurrences
y = JLArray(zeros(4))
ex = CR.Device(KernelAbstractions.get_backend(y))
CR.each!((k, y) -> (y[k] = k^2; nothing), ex, 4, 4, y)
Array(y)
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
# executor `c.ex` of a call and arrays like `x`. `Serial`, and a `Threaded`
# loop too small to split, run inline with no dynamic dispatch; on device
# arrays `Serial` runs on their device. A loop that does split is reached by
# a dynamic call, so the inline path holds no task code: automatic
# differentiation backends that compile the whole call (Enzyme, Mooncake)
# never see tasks unless a loop is split.
@inline function _each!(
        body::F, c::_Current, x, n, work, args::Vararg{Any, N}
    ) where {F, N}
    ex = c.ex
    if ex isa Serial
        each!(body, _resolve(ex, x), n, work, args...)
    elseif ex isa Threaded && !_splits(ex, n, work)
        each!(body, Serial(), n, work, args...)
    else
        _each_dynamic!(body, c, n, work, args...)
    end
    return nothing
end

@noinline function _each_dynamic!(body::F, c::_Current, n, work, args...) where {F}
    each!(body, c.ex, n, work, args...)
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

@noinline function _blocks_dynamic!(
        body::F, c::_Current, x, n, work, args...
    ) where {F}
    _blocks_on!(body, _resolve(c.ex, x), n, work, args...)
    return nothing
end

function _blocks_on!(body::F, ex::Threaded, n, work, args...) where {F}
    if _splits(ex, n, work)
        _spawn_chunks(ks -> body(ks, args...), n, min(Threads.nthreads(), n))
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
