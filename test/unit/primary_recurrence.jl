# Recurrence with a Primary() time-varying kernel: column `c` is the kernel
# of the output at time `c`, x_t = Σ_i K[i, t - i] y_{t-i}. Checked against
# the Secondary() kernel built by reindexing, K_sec[i, t] = K[i, t - i].

@testmodule PrimaryChecks begin
    using ComposableRecurrences
    using LinearAlgebra: I
    const CR = ComposableRecurrences

    # The Secondary kernel that reads what the Primary kernel `K` does at
    # every output time: lag `i` of time `t` reads column `t - i`, and there
    # is no column before time 1.
    function reindex(K)
        L, T = size(K, ndims(K) - 1), size(K, ndims(K))
        pre = ntuple(_ -> Colon(), ndims(K) - 2)
        out = similar(K)
        for t in 1:T, i in 1:L
            out[pre..., i, t] = t - i >= 1 ? K[pre..., i, t - i] : zero(eltype(K))
        end
        return out
    end

    const T = 12
    const m = 3
    const S = 2
    const Kv = [0.6 / i * (1 + 0.05 * c) for i in 1:3, c in 1:T]
    const Ks = [0.5 / i * (1 + 0.04 * c + 0.1 * a) for a in 1:S, i in 1:3, c in 1:T]
    const Kp = [
        (a == b ? 0.4 : 0.1) / i * (1 + 0.03 * c)
            for a in 1:S, b in 1:S, i in 1:3, c in 1:T
    ]
    const R1 = [1.2 + 0.1 * sin(t) for t in 1:T]
    const RS = [1.1 + 0.1 * cos(k + t) for k in 1:S, t in 1:T]
    const h1 = [1.0, 2.0, 1.5]
    const hS = [1.0 2.0 1.5; 0.5 0.4 0.8]
    const C = [0.9 0.1; 0.2 0.8]

    # Each kernel shape as (kernel from its array, gain, seed, coupling).
    const shapes = (
        vector = (A -> A, Kv, R1, h1, I),
        per_stratum = (PerStratum, Ks, RS, hS, C),
        pairwise = (Pairwise, Kp, RS, hS, I),
    )
end

@testitem "Primary Recurrence: equals the reindexed Secondary kernel" setup = [PrimaryChecks] begin
    using ComposableRecurrences, ForwardDiff
    CR = ComposableRecurrences
    (; reindex, shapes, m) = PrimaryChecks
    for (wrap, K, R, h, C) in values(shapes)
        prim(K, R, h) = CR.seeded(
            Recurrence(TimeVarying(wrap(K), CR.Primary()); coupling = C), R;
            history = h
        )
        sec(K, R, h) = CR.seeded(
            Recurrence(TimeVarying(wrap(reindex(K))); coupling = C), R;
            history = h
        )
        @test prim(K, R, h) ≈ sec(K, R, h)
        W = reshape(range(0.3, 1.2; length = length(R)), size(R))
        f(g) = (K, R, h) -> sum(W .* g(K, R, h))
        @test ForwardDiff.gradient(K -> f(prim)(K, R, h), K) ≈
            ForwardDiff.gradient(K -> f(sec)(K, R, h), K)
        @test ForwardDiff.gradient(R -> f(prim)(K, R, h), R) ≈
            ForwardDiff.gradient(R -> f(sec)(K, R, h), R)
        @test ForwardDiff.gradient(h -> f(prim)(K, R, h), h) ≈
            ForwardDiff.gradient(h -> f(sec)(K, R, h), h)
    end
end

@testitem "Primary Recurrence: a fixed kernel reads the same either way" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    g = [0.5, 0.3, 0.2]
    K = repeat(g, 1, 10)
    R = fill(1.3, 10)
    @test CR.seeded(Recurrence(TimeVarying(K, CR.Primary())), R; history = [1.0, 2.0]) ≈
        CR.seeded(Recurrence(g), R; history = [1.0, 2.0])
end

@testitem "Primary Recurrence: a cohort's onward weight is its column sum" setup = [PrimaryChecks] begin
    using ComposableRecurrences, ForwardDiff
    CR = ComposableRecurrences
    K = PrimaryChecks.Kv
    L = size(K, 1)
    # With the gain at zero, the derivative of each output in its own gain is
    # the force from the seed alone. A unit seed at time c is cohort c, and
    # with c the last seed time every lag falls in the run.
    for c in 1:3
        seed = [i == c ? 1.0 : 0.0 for i in 1:c]
        r = Recurrence(TimeVarying(K, CR.Primary()))
        force = ForwardDiff.gradient(
            R -> sum(r(R; history = seed, start = c + 1)), zeros(size(K, 2))
        )
        @test sum(force) ≈ sum(K[:, c])
        @test force[(c + 1):(c + L)] ≈ K[:, c]
    end
end

@testitem "Primary Recurrence: a resumed call equals one long call" setup = [PrimaryChecks] begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    (; shapes, m) = PrimaryChecks
    for (wrap, K, R, h, C) in values(shapes)
        r = Recurrence(TimeVarying(wrap(K), CR.Primary()); coupling = C)
        long = r(R; history = h, start = m + 1)
        y1, st = CR.with_state(r, R; history = h, start = m + 1, stop = 7)
        y2 = r(R; state = st)
        @test cat(y1, y2; dims = ndims(h)) ≈ long
    end
end

@testitem "Primary Recurrence: a seed sits at times from 1" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    r = Recurrence(TimeVarying(ones(2, 6), CR.Primary()))
    @test_throws ArgumentError r(ones(6); history = ones(2))
    @test_throws ArgumentError r(ones(6); history = ones(2), start = 2)
    @test length(r(ones(6); history = ones(2), start = 3)) == 4
    # Without a seed there is nothing earlier to read.
    @test r(ones(6)) == zeros(6)
    # A short seed is zero-padded; the padding has no column and is skipped.
    @test r(ones(6); history = [1.0], start = 2) ≈ [1.0, 2.0, 3.0, 5.0, 8.0]
end
