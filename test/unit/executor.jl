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
    @test allocs(p, g, H, S, L) == 0
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
    for ex in (CR.Threaded(), CR.Threaded(; min_work = 0))
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
        Recurrence(g; modifiers = (CR.Redistribute(K, 0.1),)),
    )
    convolutions = (
        Convolution(g),
        Convolution(PerStratum(rand(rng, S, L))),
        Convolution(TimeVarying(rand(rng, L, T))),
        Convolution(TimeVarying(rand(rng, L, T), CR.Primary())),
    )
    for ex in (CR.Threaded(; min_work = 0), CR.Threaded())
        for r in recurrences
            y = r(R; history = seed)
            @test with(() -> r(R; history = seed), CR.EXECUTOR => ex) == y
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
    @test blocks(y) == 0
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
    for r in (
            Recurrence(g), Recurrence(PerStratum(repeat(g', S))),
            Recurrence(g; modifiers = (CR.Add(0.1), CR.Clamp(0.0, 50.0))),
        )
        @test Array(r(JLArray(R); history = JLArray(seed))) ≈
            r(R; history = seed)
    end
    for c in (Convolution(g), Convolution(PerStratum(repeat(g', S))))
        @test Array(c(JLArray(R))) ≈ c(R)
    end
end
