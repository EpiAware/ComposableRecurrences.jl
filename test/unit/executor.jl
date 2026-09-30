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
