# Executors: a loop body `body(k, args...)` writes only the slots index `k`
# owns; shared cotangents go to per-block copies, reduced after the loop.

# == Executor ==

@doc raw"""
A strategy for how [`ComposableRecurrences.each!`](@ref) runs a loop over
independent indices.
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
An executor that runs every index in order on the calling task:

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

where each index `k` is one [stratum](@ref PerStratum) or one output time.

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

# == Threaded ==

@doc raw"""
An executor that runs the indices of a loop in contiguous chunks, one task
per chunk, the first on the calling task.
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
`min_work = 0` forces every loop of more than one index to split and is meant
for tests of the threaded paths.
The loops of strata that mix then split every step and start tasks every
step, so at small sizes it runs much slower than [`Serial`](@ref).
`work` counts multiply-adds.
Operators split three kinds of loop, and count the work of each kind so
that one `min_work` sets where each of them breaks even:

- strata that mix through a coupling, a pairwise kernel or a modifier with
  a vector step: one loop per step, counted in full;
- independent strata, each over the whole series: one loop per call,
  counted as an eighth, so it splits from eight times `min_work`;
- a convolution with a fixed kernel and its lag contributions: one loop per
  call of vector multiply-adds, counted as a sixteenth; a convolution that
  forms each output as one dot, such as one with a time-varying kernel,
  counts as independent strata do.

In the loops split once per call, a multiply-add counts once per 64-bit
word of the element type, so a dual number with 8 partials counts 9.
An element type that is not a bits type, such as `BigFloat` or a tracked
real, counts as one word, as do the floats of an AD backend that carries
its tangents or shadows beside the arrays rather than in them.
Loops split every step count each multiply-add once whatever the type.

The default `min_work` of 500 000 comes from whole-loss timings
(`benchmark/threshold.jl`).
Strata that mix split only with a pairwise kernel over a few hundred strata
or a coupling over tens of thousands.
Results are identical to [`Serial`](@ref) because each index writes only
its own slots.
A reverse pass sums per chunk the cotangents of parameters that chunks of
strata share, such as a scalar modifier parameter, so those agree with
[`Serial`](@ref) up to rounding.
Errors inside a split loop arrive wrapped in a `CompositeException`: an
error in a chunk on a new task as a `TaskFailedException`, and one in the
chunk the calling task runs as an exception that shows it with its
backtrace.
On arrays that live on a GPU, `Threaded` runs a call as [`Parallel`](@ref)
on the arrays' own backend, as [`Serial`](@ref) does: host threads cannot
index them.

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
    _each_split!(body, n, _nchunks(ex, n), args...)
    return nothing
end

# Behind its own function: an inline closure over `args` is copied field by
# field, and on Julia 1.12 a struct with a float ahead of its arrays is copied
# as raw bytes that an AD backend cannot type.
@noinline function _each_split!(body::F, n, m, args::Vararg{Any, N}) where {F, N}
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

# The work a loop of each kind passes for `w` multiply-adds on elements like
# those of `x`, scaled as the `Threaded` docstring sets out.
struct _StepLoop end
struct _RunLoop end
struct _ConvLoop end
_words(::Type{T}) where {T} = isbitstype(T) ? max(1, sizeof(T) ÷ 8) : 1
_work(::_StepLoop, x, w) = w
_work(::_RunLoop, x, w) = w * _words(eltype(x)) ÷ 8
_work(::_ConvLoop, x, w) = w * _words(eltype(x)) ÷ 16

# Chunk `c` of `m` contiguous chunks of `1:n`.
_chunk(c, n, m) = ((c - 1) * n ÷ m + 1):(c * n ÷ m)

# Run `run(ks)` on `m` contiguous chunks of `1:n`.
_spawn_chunks(run::R, n, m) where {R} = _run_chunks(c -> run(_chunk(c, n, m)), m)

# Every task is waited for, so a failing chunk cannot leave others writing
# after the loop returns; failures are rethrown together.
function _run_chunks(f::F, m) where {F}
    tasks = Vector{Task}(undef, m - 1)
    for c in 2:m
        tasks[c - 1] = _spawn(_Chunk(f, c))
    end
    err = _caught(_Chunk(f, 1))
    failed = _wait_all(tasks)
    err === nothing && failed === nothing && return nothing
    ce = failed === nothing ? CompositeException() : failed
    err === nothing || pushfirst!(ce.exceptions, err)
    throw(ce)
end

# The failures of `tasks` once every one has ended, or `nothing`. `@sync`
# keeps tasks in an untyped channel, which a trimmed build cannot resolve.
function _wait_all(tasks::Vector{Task})
    failed = nothing
    for t in tasks
        try
            wait(t)
        catch e
            failed === nothing && (failed = CompositeException())
            push!(failed, e)
        end
    end
    return failed
end

# Chunk `c` of the loop `f`, as a task runs it. The call is not inlined, so
# its compiled method exists for the runtime to start a task with.
struct _Chunk{F}
    f::F
    c::Int
end
@noinline (t::_Chunk)() = (t.f(t.c); nothing)

# The runtime starts a task with a dynamic call, which a trimmed build
# resolves only to a method also called directly, so the calling task runs
# its own chunk through `_Chunk` too.
function _spawn(t::_Chunk)
    task = Task(t)
    task.sticky = false
    Threads._spawn_set_thrpool(task, :default)
    schedule(task)
    return task
end

# `t()`, returning `nothing` or the exception it threw with its backtrace.
function _caught(t::_Chunk)
    try
        t()
    catch e
        return _ChunkFailed(e, catch_backtrace())
    end
    return nothing
end

# An exception from the calling task's chunk. Its backtrace stays as raw
# frames until it is shown, so the loop compiles no stack-trace code.
struct _ChunkFailed <: Exception
    error::Any
    backtrace::Vector{Union{Ptr{Nothing}, Base.InterpreterIP}}
end
function Base.showerror(io::IO, e::_ChunkFailed)
    println(io, "a chunk on the calling task failed:")
    showerror(io, e.error, e.backtrace)
    return nothing
end

# == The set executor ==

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
Some AD backends do not differentiate tasks, so code they trace runs
serially; a rule's [forward and reverse passes](@ref executors) use the set
executor.

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
    TRACED_MIN_STRATA

The fewest strata at which a loop of a traced call runs as one kernel.

A traced call runs each step's loop over `S` strata as one kernel when `S`
is at least this, so its program does not grow with the strata.
A shorter loop is written out, one block a stratum.
Its program grows with `S`, but on the CPU its forward pass runs faster
than a kernel launch each step.
The default, 32, is measured on the CPU.
From there a kernel runs gradients faster and compiles them faster, while
a written-out loop still runs the forward pass faster.
A model that mostly runs forward can raise it.
On a GPU, where a launch costs less, a lower value may run faster.
Set it with `with`, as for [`EXECUTOR`](@ref ComposableRecurrences.EXECUTOR).

# Examples
```jldoctest
using ComposableRecurrences
using Base.ScopedValues: with
const CR = ComposableRecurrences
with(CR.TRACED_MIN_STRATA => 8) do
    CR.TRACED_MIN_STRATA[]
end

# output

8
```
"""
const TRACED_MIN_STRATA = ScopedValue{Int}(32)

# == Parallel ==

@doc raw"""
An executor that runs every index of a loop as one thread of a kernel on a
KernelAbstractions backend, such as a GPU's: thread `k` computes

```math
\operatorname{body}(k), \qquad k = 1, \ldots, n.
```

`backend` is a `KernelAbstractions` backend, such as `CUDABackend()`, and
the arrays the loop reads and writes must live on it.
Kernel launches on one device run in order, so a loop reads the writes of
the loop before it; reading the result on the host waits for them.
A loop whose `work` is below `min_work` runs in order on the calling task,
as [`Serial`](@ref) does.
Set it only for a backend whose arrays live in host memory, such as the
KernelAbstractions CPU backend: on a GPU that loop would read the device
arrays one entry at a time from the host.
The default `0` launches every loop.
Needs `KernelAbstractions` to be loaded.
Under the default [`Serial`](@ref) executor, or [`Threaded`](@ref),
operator calls on arrays that live on a GPU (with GPUArrays loaded)
run their strata loops with it without being asked.
Every array a call reads must live on the device.
Independent strata run as [one kernel per call](@ref gpu-arrays), and
strata that mix as one kernel per step with the time loop on the host.

A loop body takes device data only, on every backend.

# Examples
```jldoctest; setup = :(using JLArrays, KernelAbstractions)
using ComposableRecurrences, JLArrays, KernelAbstractions
const CR = ComposableRecurrences
y = JLArray(zeros(4))
ex = CR.Parallel(KernelAbstractions.get_backend(y))
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
struct Parallel{B} <: Executor
    "The backend the loop's kernel runs on."
    backend::B
    "The smallest loop `work` that runs as a kernel."
    min_work::Int
    function Parallel{B}(backend::B, min_work::Int) where {B}
        min_work >= 0 || throw(
            ArgumentError("min_work must be at least 0, got $(repr(min_work))")
        )
        return new{B}(backend, min_work)
    end
end
function Parallel(backend::B; min_work = 0) where {B}
    return Parallel{B}(backend, Int(min_work))
end

@doc raw"""
    Device(backend)

Another name for the type [`Parallel`](@ref).

# Arguments
- `backend`: a `KernelAbstractions` backend, such as `CUDABackend()`.
- `min_work`: the smallest loop `work` that runs as a kernel, as for
  [`Parallel`](@ref); `0` by default.

# Examples
```jldoctest; setup = :(using KernelAbstractions)
using ComposableRecurrences, KernelAbstractions
const CR = ComposableRecurrences
CR.Device(KernelAbstractions.CPU()) isa CR.Parallel

# output

true
```
"""
const Device = Parallel

# == Running operator loops ==

# The executor a call on arrays like `x` uses under `ex`; the GPU extension
# makes a device array select its device.
_resolve(ex::Executor, x) = ex
# Whether a loop of cost `work` over arrays like `x` runs as a kernel.
function _launches(ex, x, work)
    r = _resolve(ex, x)
    return r isa Parallel && work >= r.min_work
end

# The executor a call read from `EXECUTOR`, in a concrete wrapper so that
# passing it down boxes nothing.
struct _Current
    ex::Executor
end
_current() = _Current(EXECUTOR[])
_launches(c::_Current, x, work) = _launches(c.ex, x, work)

# Callers never hold an abstractly typed executor.
@inline function _with_executor(f::F, args::Vararg{Any, N}) where {F, N}
    cur = _current()
    cur.ex isa Serial && return f(Serial(), args...)
    return f(cur, args...)
end

# A kernel thread runs its body serially, and `_Current` is not plain data,
# so a kernel receives the call's executor as `Serial()`.
_kernel_args(args::Tuple) = map(_kernel_arg, args)
_kernel_arg(::_Current) = Serial()
_kernel_arg(x) = x

# A loop that splits is reached by a dynamic call, so AD backends that compile
# the whole call see no task code unless a loop splits.
@inline function _each!(
        body::F, c::_Current, x, n, work, args::Vararg{Any, N}
    ) where {F, N}
    ex = c.ex
    if ex isa Threaded && !_splits(ex, n, work) && !_on_gpu(x)
        each!(body, Serial(), n, work, args...)
    else
        _dynamic!(each!, body, c, x, n, work, args...)
    end
    return nothing
end
@inline function _each!(
        body::F, ex::Serial, x, n, work, args::Vararg{Any, N}
    ) where {F, N}
    each!(body, _resolve(ex, x), n, work, args...)
    return nothing
end

# The loop `loop!` with the call's executor, behind a function barrier. The
# executor is one of the three built-in kinds, so each branch is a static call.
@noinline function _dynamic!(
        loop!::L, body::F, c::_Current, x, n, work, args::Vararg{Any, N}
    ) where {L, F, N}
    ex = _resolve(c.ex, x)
    if ex isa Threaded
        loop!(body, ex, n, work, args...)
    elseif ex isa Serial
        loop!(body, ex, n, work, args...)
    elseif ex isa Parallel
        loop!(body, ex, n, work, args...)
    else
        _unknown_executor()
    end
    return nothing
end
@noinline function _unknown_executor()
    throw(
        ArgumentError("`EXECUTOR` must be `Serial`, `Threaded` or `Parallel`")
    )
end

# The time loop, in order, each step reading the steps before it. A traced
# executor may compile it as one loop whose body is the step.
@inline function _steps!(body::F, ex, n, args::Vararg{Any, N}) where {F, N}
    for t in 1:n
        @inline body(t, args...)
    end
    return nothing
end

# `body(ks, args...)` over blocks `ks` that cover `1:n` once: one block for
# `Serial`, one per chunk for `Threaded` and one per index otherwise.
@inline function _blocks!(
        body::F, c::_Current, x, n, work, args::Vararg{Any, N}
    ) where {F, N}
    ex = c.ex
    if (ex isa Serial && _resolve(ex, x) isa Serial) ||
            (ex isa Threaded && !_splits(ex, n, work) && !_on_gpu(x))
        n == 0 || @inline body(1:n, args...)
    else
        _dynamic!(_blocks_on!, body, c, x, n, work, args...)
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

# == Shared cotangents ==

# The first block writes `acc`; others allocate copies on their own tasks, so
# copies do not share cache lines, and `_reduce!` adds them in block order. A
# mirror `_private` cannot copy runs as one block.
function _accumulators(ex::Serial, x, n, work, acc)
    r = _resolve(ex, x)
    r isa Parallel && return _stacked_accumulators(r, x, n, acc)
    return (acc, ())
end
# On device arrays the copies are stacked on the arrays' own backend,
# whatever executor is set: a kernel can only read them there. The choice
# follows the arrays' type, so it is a constant.
function _accumulators(c::_Current, x, n, work, acc)
    _on_gpu(x) && return _stacked_accumulators(_resolve(Serial(), x), x, n, acc)
    m = _copyable(acc) ? _nblocks(c.ex, n, work) : 1
    P = Base.promote_op(_private, typeof(acc))
    return acc, Vector{Union{Nothing, P}}(nothing, m - 1)
end
_nblocks(ex::Threaded, n, work) = _splits(ex, n, work) ? _nchunks(ex, n) : 1
_nblocks(ex, n, work) = 1
_nblocks(c::_Current, n, work) = _nblocks(c.ex, n, work)

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

# Counts the loops `_reduce_blocks!` splits, so tests can prove one did.
const _SPLIT_BLOCKS = Threads.Atomic{Int}(0)

@noinline function _spawn_blocks(body::F, acc, copies, n, args...) where {F}
    Threads.atomic_add!(_SPLIT_BLOCKS, 1)
    m = length(copies) + 1
    _run_chunks(m) do b
        ks = _chunk(b, n, m)
        if b == 1
            body(ks, acc, args...)
        else
            _copy_block!(body, ks, acc, copies, b - 1, args...)
        end
        return nothing
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

# A zeroed copy of a mirror, and the sum of two mirrors into the first. An
# `_Owned` mirror, which each index writes only at its own slots, is shared.
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
# Whether `_private` copies every leaf of a mirror of type `T`.
function _copyable_type(::Type{T}) where {T}
    T <: Union{Nothing, _Owned} && return true
    T <: Union{Base.RefValue{<:Number}, AbstractArray{<:Number}} && return true
    T <: Union{Tuple, NamedTuple} && isconcretetype(T) || return false
    return all(_copyable_type, fieldtypes(T))
end
# After its helpers: a generator sees only the methods defined before it.
@generated _copyable(x) = _copyable_type(x)
_add_into!(::Nothing, ::Nothing) = nothing
_add_into!(x::Base.RefValue, y::Base.RefValue) = (x[] += y[]; nothing)
_add_into!(x::AbstractArray, y::AbstractArray) = (x .+= y; nothing)
function _add_into!(x::Union{Tuple, NamedTuple}, y::Union{Tuple, NamedTuple})
    foreach(_add_into!, x, y)
    return nothing
end
_add_into!(::_Owned, ::_Owned) = nothing

# == Shared cotangents on a kernel backend ==

# Each shared cotangent has `m` zeroed copies stacked along a new last
# dimension and block `b` writes slice `b`, so the sum after the loop does not
# depend on block order. Mirrors written only at own slots are shared.
struct _Stacked{E, C}
    ex::E
    m::Int
    copies::C
end
const _KERNEL_BLOCKS = 256

function _stacked_accumulators(ex::Parallel, x, n, acc)
    m = max(min(n, _KERNEL_BLOCKS), 1)
    return acc, _Stacked(ex, m, _stack(acc, m, x))
end

struct _ArrayStack{A}
    a::A
end
struct _ScalarStack{V}
    v::V
end
_stack(::Nothing, m, x) = nothing
_stack(a::_Owned, m, x) = a
function _stack(a::AbstractArray{T}, m, x) where {T <: Number}
    return _ArrayStack(fill!(similar(a, T, size(a)..., m), zero(T)))
end
function _stack(r::Base.RefValue{T}, m, x) where {T <: Number}
    return _ScalarStack(fill!(similar(x, T, m), zero(T)))
end
_stack(a::Union{Tuple, NamedTuple}, m, x) = map(y -> _stack(y, m, x), a)
function _stack(a, m, x)
    throw(
        ArgumentError(
            "a reverse pass on a kernel backend cannot copy a cotangent " *
                "of type $(typeof(a)); use the Serial() executor"
        )
    )
end

_block(::Nothing, b) = nothing
_block(a::_Owned, b) = a
_block(s::_ArrayStack, b) = _last_slice(s.a, b)
# No checks: a kernel cannot build their error strings.
@inline function _last_slice(a::AbstractArray{T, N}, b) where {T, N}
    return @inbounds view(a, ntuple(_ -> Colon(), Val(N - 1))..., b)
end
_block(s::_ScalarStack, b) = _Slot(s.v, b)
_block(a::Union{Tuple, NamedTuple}, b) = map(y -> _block(y, b), a)

# A scalar mirror's slot, read and written with `x[]`.
struct _Slot{V}
    v::V
    b::Int
end
Base.@propagate_inbounds Base.getindex(s::_Slot) = s.v[s.b]
Base.@propagate_inbounds Base.setindex!(s::_Slot, x) = (s.v[s.b] = x; s)
add_cotangent!(x̄::_Slot, v, idx...) = (x̄[] += v; nothing)

struct _StackedBlock{F}
    body::F
    n::Int
    m::Int
end
@inline function (s::_StackedBlock)(b, copies, args::Vararg{Any, N}) where {N}
    s.body(_chunk(b, s.n, s.m), _block(copies, b), args...)
    return nothing
end

@inline function _reduce_blocks!(
        body::F, accs::Tuple{Any, _Stacked}, n, args::Vararg{Any, N}
    ) where {F, N}
    st = last(accs)
    n == 0 && return nothing
    block = _StackedBlock(body, n, st.m)
    each!(block, st.ex, st.m, typemax(Int), st.copies, args...)
    return nothing
end

function _reduce!(accs::Tuple{Any, _Stacked})
    acc, st = accs
    _add_stack!(acc, st.copies)
    return nothing
end
_add_stack!(::Nothing, ::Nothing) = nothing
_add_stack!(::_Owned, ::_Owned) = nothing
function _add_stack!(x::AbstractArray, s::_ArrayStack)
    d = ndims(s.a)
    x .+= dropdims(sum(s.a; dims = d); dims = d)
    return nothing
end
_add_stack!(x::Base.RefValue, s::_ScalarStack) = (x[] += sum(s.v); nothing)
function _add_stack!(x::Union{Tuple, NamedTuple}, s::Union{Tuple, NamedTuple})
    foreach(_add_stack!, x, s)
    return nothing
end
