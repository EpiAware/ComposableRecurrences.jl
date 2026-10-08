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
`work` counts multiply-adds.
The default `min_work` of 500 000 is where, on a 4-core machine, four
threads began to beat one for independent strata and pairwise kernels
(`benchmark/threshold.jl`).
Independent strata are one loop per call, but strata that mix through a
coupling, a pairwise kernel or a modifier with a vector step are one loop
per step, so such models gain only with many strata.
Results are identical to [`Serial`](@ref) because each index writes only
its own slots.
A reverse pass sums some parameter cotangents per chunk, so those agree
with [`Serial`](@ref) up to rounding; [Executors](@ref executors) says
which.
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
Threaded(; min_work = 500_000, ntasks = 0) = Threaded(min_work, ntasks)

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

# Chunk `c` of `m` contiguous chunks of `1:n`.
_chunk(c, n, m) = ((c - 1) * n ÷ m + 1):(c * n ÷ m)

# Run `run(ks)` on `m` contiguous chunks of `1:n`, one task each, and wait
# for every task, so a failing chunk cannot leave others writing after the
# loop returns; failures are rethrown together.
function _spawn_chunks(run::R, n, m) where {R}
    @sync for c in 1:m
        Threads.@spawn run(_chunk(c, n, m))
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

ComposableRecurrences.Threaded(500000, 0)
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

# A loop whose indices also add into shared cotangents: `acc` holds those
# cotangents, a tuple of mirrors. `_accumulators` gives `(acc, copies)`
# with a slot in `copies` for each block after the first that the loop runs
# in. `_reduce_blocks!` calls `body(ks, acc, args...)` on the first block
# and `body(ks, copies[b - 1], args...)` on block `b`, where the copy is a
# zeroed `acc` that block `b` allocates on its own task the first time, so
# copies of small cotangents written by different tasks do not share cache
# lines. `_reduce!` adds the copies into `acc` in block order afterwards.
# Serial runs are one block on `acc`, so they add in the order of a loop
# written by hand; split runs agree with them up to rounding. A `Device` or
# another executor runs the loop as one block on the calling task.
_accumulators(::Serial, x, n, work, acc) = (acc, ())
function _accumulators(c::_Current, x, n, work, acc)
    m = _nblocks(c.ex, n, work)
    P = Base.promote_op(_private, typeof(acc))
    return acc, Vector{Union{Nothing, P}}(nothing, m - 1)
end
_nblocks(ex::Threaded, n, work) = _splits(ex, n, work) ? _nchunks(ex, n) : 1
_nblocks(ex, n, work) = 1

@inline function _reduce_blocks!(
        body::F, accs, n, args::Vararg{Any, N}
    ) where {F, N}
    acc, copies = accs
    if isempty(copies)
        n == 0 || @inline body(1:n, acc, args...)
    else
        _spawn_blocks(body, acc, copies, n, args...)
    end
    return nothing
end

# Incremented by every loop that `_reduce_blocks!` splits, so tests can
# prove a reverse pass ran on more than one task.
const _SPLIT_BLOCKS = Threads.Atomic{Int}(0)

@noinline function _spawn_blocks(body::F, acc, copies, n, args...) where {F}
    Threads.atomic_add!(_SPLIT_BLOCKS, 1)
    m = length(copies) + 1
    @sync for b in 1:m
        ks = _chunk(b, n, m)
        if b == 1
            Threads.@spawn body(ks, acc, args...)
        else
            Threads.@spawn _copy_block!(body, ks, acc, copies, b - 1, args...)
        end
    end
    return nothing
end
function _copy_block!(body::F, ks, acc, copies, i, args...) where {F}
    a = copies[i]
    if a === nothing
        a = _private(acc)
        copies[i] = a
    end
    body(ks, a, args...)
    return nothing
end

function _reduce!(accs)
    acc, copies = accs
    for c in copies
        c === nothing || _add_into!(acc, c)
    end
    return nothing
end

# A zeroed copy of a mirror, and the sum of two mirrors into the first.
# Mirrors that every index writes only at its own slots are `_Owned` and
# shared by every block.
struct _Owned{X}
    x::X
end
_private(::Nothing) = nothing
_private(x::Base.RefValue) = Ref(zero(x[]))
_private(x::AbstractArray) = fill!(similar(x), zero(eltype(x)))
_private(x::Union{Tuple, NamedTuple}) = map(_private, x)
_private(x::_Owned) = x
function _private(x)
    throw(
        ArgumentError(
            "a reverse pass split across tasks cannot copy a cotangent of " *
                "type $(typeof(x)); use the Serial() executor"
        )
    )
end
_add_into!(::Nothing, ::Nothing) = nothing
_add_into!(x::Base.RefValue, y::Base.RefValue) = (x[] += y[]; nothing)
_add_into!(x::AbstractArray, y::AbstractArray) = (x .+= y; nothing)
function _add_into!(x::Union{Tuple, NamedTuple}, y::Union{Tuple, NamedTuple})
    foreach(_add_into!, x, y)
    return nothing
end
_add_into!(::_Owned, ::_Owned) = nothing
