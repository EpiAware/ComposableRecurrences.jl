# The executor loop `each!`: every index runs once with its own arguments,
# the serial loop allocates nothing, threads and devices match the serial
# loop, and one per-index body runs unchanged as a kernel on an array type
# without scalar indexing.

@testsnippet ExecutorBodies begin
    # Stratum `k`'s kernel convolution of its window `H[t:(t + L - 1), k]`.
    function window_dot!(k, p, g, H, t, L)
        acc = zero(eltype(p))
        for i in 1:L
            acc += g[i] * H[t + i - 1, k]
        end
        p[k] = acc
        return nothing
    end
end

@testitem "each!: serial runs every index in order" setup = [ExecutorBodies] begin
    using ComposableRecurrences
    const CR = ComposableRecurrences
    seen = Int[]
    CR.each!((k, seen) -> (push!(seen, k); nothing), CR.Serial(), 5, 5, seen)
    @test seen == 1:5
    CR.each!((k, seen) -> (push!(seen, k); nothing), CR.Serial(), 0, 0, seen)
    @test seen == 1:5

    S, L, T = 4, 3, 6
    g = [0.2, 0.3, 0.5]
    H = reshape(collect(1.0:((L + T) * S)), L + T, S)
    p = zeros(S)
    t = 2
    CR.each!(window_dot!, CR.Serial(), S, S * L, p, g, H, t, L)
    @test p ≈ [sum(g[i] * H[t + i - 1, k] for i in 1:L) for k in 1:S]
end

@testitem "each!: serial allocates nothing" setup = [ExecutorBodies] begin
    using ComposableRecurrences
    const CR = ComposableRecurrences
    S, L = 50, 20
    g = rand(L)
    H = rand(L + 10, S)
    p = zeros(S)
    function allocs(p, g, H, S, L)
        CR.each!(window_dot!, CR.Serial(), S, S * L, p, g, H, 3, L)
        return @allocated CR.each!(window_dot!, CR.Serial(), S, S * L, p, g, H, 3, L)
    end
    allocs(p, g, H, S, L)
    # Coverage instrumentation allocates, so the count is checked only
    # without it.
    coverage = Base.JLOptions().code_coverage != 0
    @test allocs(p, g, H, S, L) == 0 skip = coverage
end

@testitem "each!: Device runs a body as a kernel on JLArrays" setup = [ExecutorBodies] begin
    using ComposableRecurrences, JLArrays, KernelAbstractions
    const CR = ComposableRecurrences
    JLArrays.allowscalar(false)
    S, L, T = 5, 3, 8
    for Tp in (Float64, Float32)
        g = rand(Tp, L)
        H = rand(Tp, L + T, S)
        p = zeros(Tp, S)
        CR.each!(window_dot!, CR.Serial(), S, S * L, p, g, H, 2, L)
        pd, gd, Hd = JLArray(zeros(Tp, S)), JLArray(g), JLArray(H)
        ex = CR.Device(KernelAbstractions.get_backend(pd))
        CR.each!(window_dot!, ex, S, S * L, pd, gd, Hd, 2, L)
        @test Array(pd) == p
        # A strata-first buffer seen through a time-first permuted view.
        Hp = PermutedDimsArray(JLArray(permutedims(H)), (2, 1))
        fill!(pd, 0)
        CR.each!(window_dot!, ex, S, S * L, pd, gd, Hp, 2, L)
        @test Array(pd) == p
    end
    @test CR.each!(window_dot!, CR.Device(nothing), 0, 0) === nothing
end

@testitem "Device: arrays on a device select it" begin
    using ComposableRecurrences, JLArrays, KernelAbstractions
    const CR = ComposableRecurrences
    x = JLArray(rand(3))
    @test CR._resolve(CR.Serial(), x) == CR.Device(KernelAbstractions.get_backend(x))
    @test CR._resolve(CR.Serial(), rand(3)) === CR.Serial()
    ex = CR.Threaded()
    @test CR._resolve(ex, x) === ex
end

@testitem "each!: threaded matches serial" setup = [ExecutorBodies] begin
    using ComposableRecurrences
    const CR = ComposableRecurrences
    S, L, T = 37, 4, 6
    g = rand(L)
    H = rand(L + T, S)
    p, pt = zeros(S), zeros(S)
    CR.each!(window_dot!, CR.Serial(), S, S * L, p, g, H, 2, L)
    for ex in (
            CR.Threaded(), CR.Threaded(; min_work = 0),
            CR.Threaded(; min_work = 0, ntasks = 4),
        )
        fill!(pt, 0)
        CR.each!(window_dot!, ex, S, S * L, pt, g, H, 2, L)
        @test pt == p
    end
end

@testitem "each!: chunks cover every index once" begin
    using ComposableRecurrences
    const CR = ComposableRecurrences
    for n in (1, 5, 16, 101), m in (1, 2, 3, 8)
        m > n && continue
        hits = zeros(Int, n)
        CR._spawn_chunks(ks -> (hits[ks] .+= 1; nothing), n, m)
        @test all(==(1), hits)
    end
end

@testitem "Block accumulators: one per chunk, summed afterwards" begin
    using ComposableRecurrences
    const CR = ComposableRecurrences
    # Each index adds its own value into a shared scalar and vector and
    # writes its own slot of an owned vector.
    function body!(ks, acc, y)
        for k in ks
            acc.r[] += k
            acc.v .+= k
            acc.o.x[k] = k
            y[k] = 2k
        end
        return nothing
    end
    n = 10
    for ex in (CR.Serial(), CR.Threaded(; min_work = 0, ntasks = 3))
        acc = (; r = Ref(0.0), v = zeros(2), o = CR._Owned(zeros(n)), z = nothing)
        c = ex isa CR.Serial ? ex : CR._Current(ex)
        accs = CR._accumulators(c, nothing, n, n, acc)
        @test length(accs[2]) == (ex isa CR.Serial ? 0 : 2)
        @test first(accs) === acc
        splits = CR._SPLIT_BLOCKS[]
        y = zeros(n)
        CR._reduce_blocks!(body!, accs, n, y)
        CR._reduce!(accs)
        @test CR._SPLIT_BLOCKS[] - splits == (ex isa CR.Serial ? 0 : 1)
        @test acc.r[] == sum(1:n)
        @test acc.v == fill(sum(1:n), 2)
        @test acc.o.x == 1:n
        @test y == 2 .* (1:n)
    end
    # A view's copy is an array of its own.
    v = view(zeros(4), 2:3)
    acc, copies = CR._accumulators(
        CR._Current(CR.Threaded(; min_work = 0, ntasks = 2)), nothing, 2, 2, (; v)
    )
    CR._reduce_blocks!((ks, a) -> (a.v[ks] .+= 1.0; nothing), (acc, copies), 2)
    @test copies[1].v isa Vector
    CR._reduce!((acc, copies))
    @test parent(v) == [0.0, 1.0, 1.0, 0.0]
    # Other executors run the loop as one block, as does a mirror with a
    # leaf that has no copy rule, which `_private` refuses by name.
    @test CR._nblocks(CR.Serial(), 10, 10) == 1
    @test_throws "cannot copy a cotangent of type Int64" CR._private(1)
    cur = CR._Current(CR.Threaded(; min_work = 0, ntasks = 2))
    for leaf in (1, Ref{Any}(0.0), [[0.0]], (; a = Ref(0.0), b = :b))
        @test !CR._copyable((; r = Ref(0.0), leaf))
        @test isempty(CR._accumulators(cur, nothing, 4, 4, (; leaf))[2])
    end
    @test CR._copyable((; r = Ref(0.0), v = zeros(2), o = CR._Owned(1), z = nothing))
    # A loop too small to split runs as one block on the shared mirrors.
    small = CR._accumulators(CR._Current(CR.Threaded()), nothing, 4, 4, (; r = Ref(0.0)))
    @test isempty(small[2])
end

@testitem "Threaded: options are checked when it is built" begin
    using ComposableRecurrences
    const CR = ComposableRecurrences
    @test_throws "ntasks must be at least 0, got -1" CR.Threaded(; ntasks = -1)
    @test_throws "min_work must be at least 0, got -5" CR.Threaded(; min_work = -5)
    @test CR.Threaded(0, 0) === CR.Threaded(; min_work = 0)
    # Loops below the default threshold run in order, whatever the threads.
    @test CR.Threaded() === CR.Threaded(500_000, 0)
    @test !CR._splits(CR.Threaded(; ntasks = 4), 8, 499_999)
    @test CR._splits(CR.Threaded(; ntasks = 4), 8, 500_000)
end

@testitem "Threaded: loop work is counted per kind and element type" begin
    using ComposableRecurrences, ForwardDiff
    const CR = ComposableRecurrences
    x = zeros(2)
    # Loops split every step count in full, loops split once per call as
    # an eighth and convolutions with a fixed kernel as a sixteenth.
    @test CR._work(CR._StepLoop(), x, 1600) == 1600
    @test CR._work(CR._RunLoop(), x, 1600) == 200
    @test CR._work(CR._ConvLoop(), x, 1600) == 100
    # Loops split once per call count each 64-bit word of the element
    # type; loops split every step do not.
    d = ForwardDiff.Dual(1.0, ntuple(_ -> 0.0, 8)...)
    @test CR._work(CR._RunLoop(), zeros(Float32, 2), 1600) == 200
    @test CR._work(CR._RunLoop(), [d], 1600) == 9 * 200
    @test CR._work(CR._ConvLoop(), [d], 1600) == 9 * 100
    @test CR._work(CR._StepLoop(), [d], 1600) == 1600
    @test CR._work(CR._RunLoop(), Any[1.0], 1600) == 200
    @test CR._work(CR._RunLoop(), [big(1.0)], 1600) == 200
    @inferred CR._work(CR._RunLoop(), [d], 1600)
    # One threshold sets where each kind splits.
    ex = CR.Threaded(; ntasks = 4)
    @test !CR._splits(ex, 8, CR._work(CR._StepLoop(), [d], 499_999))
    @test CR._splits(ex, 8, CR._work(CR._StepLoop(), x, 500_000))
    @test !CR._splits(ex, 8, CR._work(CR._RunLoop(), x, 3_999_999))
    @test CR._splits(ex, 8, CR._work(CR._RunLoop(), x, 4_000_000))
    @test !CR._splits(ex, 8, CR._work(CR._ConvLoop(), x, 7_999_999))
    @test CR._splits(ex, 8, CR._work(CR._ConvLoop(), x, 8_000_000))
end

@testitem "EXECUTOR: serial by default, set per block" begin
    using ComposableRecurrences
    using Base.ScopedValues: with
    const CR = ComposableRecurrences
    @test CR.EXECUTOR[] === CR.Serial()
    ex = CR.Threaded(; min_work = 0)
    @test with(() -> CR.EXECUTOR[], CR.EXECUTOR => ex) === ex
    @test CR.EXECUTOR[] === CR.Serial()
end

@testitem "Operators: threaded calls match serial calls exactly" begin
    using ComposableRecurrences, Random
    using Base.ScopedValues: with
    using LinearAlgebra: Diagonal
    const CR = ComposableRecurrences
    rng = Xoshiro(17)
    S, T, L = 7, 25, 4
    g = rand(rng, L) ./ 2L
    R = 1.0 .+ rand(rng, S, T)
    seed = rand(rng, S, L)
    K = fill(1 / S, S, S)
    recurrences = (
        Recurrence(g),
        Recurrence(PerStratum(rand(rng, S, L) ./ 2L)),
        Recurrence(g; coupling = Diagonal(fill(0.9, S))),
        Recurrence(g; modifiers = (CR.Depletion(1.0e3; pool0 = 1.0e3),)),
        Recurrence(g; coupling = K),
        Recurrence(Pairwise(rand(rng, S, S, L) ./ (2 * S * L))),
        Recurrence(g; modifiers = (CR.Redistribute(CR.movement(K, 0.1)),)),
        # Vector steps that read every stratum run serially between the
        # threaded strata loops.
        Recurrence(
            g; modifiers = (
                CR.Depletion(
                    1.0e3; removals = TimeVarying(fill(2.0, T)),
                    protected = CR.Protected(0.3),
                ),
            )
        ),
        Recurrence(
            g; modifiers = (
                CR.Allocate([1:3, 4:7], TimeVarying(PerStratum(fill(5.0, 2, T)))),
            )
        ),
        # Both in one call: a protected pool, then grouped totals.
        Recurrence(
            g; modifiers = (
                CR.Depletion(
                    1.0e3; removals = TimeVarying(fill(2.0, T)),
                    protected = CR.Protected(0.3),
                ),
                CR.Allocate([1:3, 4:7], TimeVarying(PerStratum(fill(5.0, 2, T)))),
            )
        ),
        Recurrence(g; modifiers = (CR.Transform((v, c) -> c * v / (c + v), 20.0),)),
    )
    convolutions = (
        Convolution(g),
        Convolution(PerStratum(rand(rng, S, L))),
        Convolution(TimeVarying(rand(rng, L, T))),
        Convolution(TimeVarying(rand(rng, L, T), CR.Primary())),
    )
    # `ntasks` forces the split path even on one thread.
    for ex in (
            CR.Threaded(; min_work = 0), CR.Threaded(),
            CR.Threaded(; min_work = 0, ntasks = 3),
        )
        for r in recurrences
            y = r(R; history = seed)
            @test with(() -> r(R; history = seed), CR.EXECUTOR => ex) == y
            # The forward pass of the reverse rule records the same cache.
            yr, cache = CR.forward(r, CR.Run(), R; history = seed)
            yt, cachet = with(CR.EXECUTOR => ex) do
                CR.forward(r, CR.Run(), R; history = seed)
            end
            @test yt == yr == y
            @test cachet.pr == cache.pr
            @test map(x -> (x.V, x.S), cachet.rec) == map(x -> (x.V, x.S), cache.rec)
            @test cachet.state.states == cache.state.states
        end
        for c in convolutions
            @test with(() -> c(R), CR.EXECUTOR => ex) == c(R)
        end
    end
end

@testitem "Operators: the default executor keeps calls type stable" begin
    using ComposableRecurrences
    const CR = ComposableRecurrences
    g = [0.2, 0.3, 0.5]
    R = fill(1.1, 2, 10)
    seed = ones(2, 3)
    for r in (Recurrence(g), Recurrence(g; coupling = fill(0.5, 2, 2)))
        @test (@inferred r(R; history = seed)) isa Matrix{Float64}
    end
    @test (@inferred Convolution(g)(R)) isa Matrix{Float64}
    # Serial blocks run inline, with nothing allocated by the loop.
    body!(ks, y) = (y[ks] .= 1.0; nothing)
    y = zeros(4)
    blocks(y) = @allocated CR._blocks!(body!, CR._current(), y, 4, 4, y)
    blocks(y)
    # Coverage instrumentation allocates, so the count is checked only
    # without it.
    coverage = Base.JLOptions().code_coverage != 0
    @test blocks(y) == 0 skip = coverage
    @test y == ones(4)
end

@testitem "Operators: GPU arrays run their strata loops on the device" begin
    using ComposableRecurrences, JLArrays, KernelAbstractions
    using Base.ScopedValues: with
    const CR = ComposableRecurrences
    JLArrays.allowscalar(false)
    S, T, L = 5, 20, 4
    g = [0.1, 0.2, 0.3, 0.2]
    R = [1.0 + 0.05 * sin(i + t) for i in 1:S, t in 1:T]
    seed = ones(S, L)
    G = repeat(g', S)
    gd, Gd = JLArray(g), JLArray(G)
    for (r, rd) in (
            (Recurrence(g), Recurrence(gd)),
            (Recurrence(PerStratum(G)), Recurrence(PerStratum(Gd))),
            (
                Recurrence(g; modifiers = (CR.Add(0.1), CR.Clamp(0.0, 50.0))),
                Recurrence(gd; modifiers = (CR.Add(0.1), CR.Clamp(0.0, 50.0))),
            ),
        )
        @test Array(rd(JLArray(R); history = JLArray(seed))) ≈
            r(R; history = seed)
    end
    for (c, cd) in (
            (Convolution(g), Convolution(gd)),
            (Convolution(PerStratum(G)), Convolution(PerStratum(Gd))),
        )
        @test Array(cd(JLArray(R))) ≈ c(R)
    end
    # The device executor set explicitly, through the dynamic loop path.
    Rd, seedd = JLArray(R), JLArray(seed)
    ex = CR.Device(KernelAbstractions.get_backend(Rd))
    rd = Recurrence(gd)
    @test Array(with(() -> rd(Rd; history = seedd), CR.EXECUTOR => ex)) ≈
        Recurrence(g)(R; history = seed)
    cd = Convolution(gd)
    @test Array(with(() -> cd(Rd), CR.EXECUTOR => ex)) ≈ Convolution(g)(R)
end

@testitem "Threaded: a failing chunk fails the loop after every chunk ends" begin
    using ComposableRecurrences
    using Base.ScopedValues: with
    const CR = ComposableRecurrences
    ex = CR.Threaded(; min_work = 0, ntasks = 4)
    done = zeros(Int, 8)
    function body!(k, done)
        k == 2 && error("chunk failed")
        done[k] = 1
        return nothing
    end
    @test_throws CompositeException CR.each!(body!, ex, 8, 8, done)
    # Every other chunk ran to the end before the error was raised.
    @test done[3:8] == ones(Int, 6)
    @test CR._nchunks(ex, 2) == 2
    @test CR._nchunks(CR.Threaded(), 100) == min(Threads.nthreads(), 100)
    # Blocks through the executor read from `EXECUTOR`.
    y = zeros(6)
    blk!(ks, y) = (y[ks] .+= 1; nothing)
    with(CR.EXECUTOR => ex) do
        CR._blocks!(blk!, CR._current(), y, 6, 6, y)
    end
    @test y == ones(6)
end

@testitem "Threaded: chunks run in parallel on several threads" begin
    using ComposableRecurrences
    const CR = ComposableRecurrences
    nt = Threads.nthreads()
    # Without `ntasks` a loop splits only when there is more than one thread.
    @test CR._splits(CR.Threaded(; min_work = 0), 8, 1) == (nt > 1)
    if nt > 1
        # One index per chunk; each chunk spins, without yielding, until every
        # chunk has started, so they can only meet on distinct threads.
        # The spin reaches a GC safepoint, so a collection started while the
        # other chunks are spawned does not wait out the timeout.
        m = min(nt, 4)
        arrived = Threads.Atomic{Int}(0)
        ids = zeros(Int, m)
        met = zeros(Bool, m)
        function wait_all!(k, arrived, ids, met, m)
            ids[k] = Threads.threadid()
            Threads.atomic_add!(arrived, 1)
            t0 = time()
            while arrived[] < m && time() - t0 < 60
                GC.safepoint()
            end
            met[k] = arrived[] == m
            return nothing
        end
        CR.each!(wait_all!, CR.Threaded(; min_work = 0), m, m, arrived, ids, met, m)
        @test all(met)
        @test length(unique(ids)) == m
    else
        # Run the suite with `--threads` above 1 to exercise this.
        @test_skip nt > 1
    end
end
