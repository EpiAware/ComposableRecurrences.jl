# The executor loop `each!`: every index runs once with its own arguments,
# the serial loop allocates nothing, and one per-index body runs unchanged
# as a kernel on an array type without scalar indexing.

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

@testitem "each!: a body runs as a kernel on JLArrays" setup = [ExecutorBodies] begin
    using ComposableRecurrences, JLArrays, KernelAbstractions
    const CR = ComposableRecurrences
    const KA = KernelAbstractions

    @kernel function each_kernel!(body, args)
        k = @index(Global, Linear)
        body(k, args...)
    end

    S, L, T = 5, 3, 8
    g = rand(L)
    H = rand(L + T, S)
    p = zeros(S)
    CR.each!(window_dot!, CR.Serial(), S, S * L, p, g, H, 2, L)

    JLArrays.allowscalar(false)
    pd, gd, Hd = JLArray(zeros(S)), JLArray(g), JLArray(H)
    each_kernel!(KA.get_backend(pd))(window_dot!, (pd, gd, Hd, 2, L); ndrange = S)
    @test Array(pd) == p
end
