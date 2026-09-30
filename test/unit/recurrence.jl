# Recurrence values against the naive reference loop, one test item per slot
# shape. Kernel vectors are oldest first: `g[L + 1 - i]` weights lag `i`.

@testitem "Recurrence: fixed kernel, single series" setup = [Reference] begin
    using ComposableRecurrences, Random
    rng = Xoshiro(1)
    L, T = 4, 12
    g = rand(rng, L)
    h = rand(rng, L)
    R = 0.5 .+ rand(rng, T)
    w = (t, a, b, i) -> g[L + 1 - i]
    y = Recurrence(g)(R; history = h)
    @test y isa Vector{Float64}
    @test length(y) == T
    @test y ≈ vec(naive_recurrence(w, reshape(h, 1, L), T; gain = (a, t) -> R[t]))

    ϵ = randn(rng, T)
    y = Recurrence(g)(0.7; history = h, add = ϵ)
    ref = naive_recurrence(
        w, reshape(h, 1, L), T; gain = (a, t) -> 0.7, add = (a, t) -> ϵ[t]
    )
    @test y ≈ vec(ref)

    y = Recurrence(g)(R; history = h, add = 0.3)
    ref = naive_recurrence(
        w, reshape(h, 1, L), T; gain = (a, t) -> R[t], add = (a, t) -> 0.3
    )
    @test y ≈ vec(ref)
end

@testitem "Recurrence: strata with dense coupling" setup = [Reference] begin
    using ComposableRecurrences, Random
    rng = Xoshiro(2)
    S, L, T = 3, 4, 10
    g = rand(rng, L)
    K = rand(rng, S, S)
    h = rand(rng, S, L)
    R = rand(rng, S, T)
    ϵ = rand(rng, S, T)
    y = Recurrence(g; coupling = K)(R; history = h, add = ϵ)
    ref = naive_recurrence(
        (t, a, b, i) -> K[a, b] * g[L + 1 - i], h, T;
        gain = (a, t) -> R[a, t], add = (a, t) -> ϵ[a, t]
    )
    @test size(y) == (S, T)
    @test y ≈ ref

    # A length-T gain is shared by every stratum.
    r = rand(rng, T)
    y = Recurrence(g; coupling = K)(r; history = h)
    ref = naive_recurrence(
        (t, a, b, i) -> K[a, b] * g[L + 1 - i], h, T; gain = (a, t) -> r[t]
    )
    @test y ≈ ref
end

@testitem "Recurrence: identity, scaled identity and no coupling" setup = [Reference] begin
    using ComposableRecurrences, LinearAlgebra, Random
    rng = Xoshiro(3)
    S, L, T = 3, 3, 8
    g = rand(rng, L)
    h = rand(rng, S, L)
    R = rand(rng, S, T)
    ref(λ) = naive_recurrence(
        (t, a, b, i) -> (a == b) * λ * g[L + 1 - i], h, T;
        gain = (a, t) -> R[a, t]
    )
    @test Recurrence(g)(R; history = h) ≈ ref(1)
    @test Recurrence(g; coupling = I)(R; history = h) ≈ ref(1)
    @test Recurrence(g; coupling = 0.5I)(R; history = h) ≈ ref(0.5)
end

@testitem "Recurrence: per-stratum kernel with Diagonal coupling" setup = [Reference] begin
    using ComposableRecurrences, LinearAlgebra, Random
    rng = Xoshiro(4)
    S, L, T = 3, 5, 9
    G = rand(rng, S, L)
    d = rand(rng, S)
    h = rand(rng, S, L)
    R = rand(rng, S, T)
    y = Recurrence(PerStratum(G); coupling = Diagonal(d))(R; history = h)
    ref = naive_recurrence(
        (t, a, b, i) -> (a == b) * d[a] * G[b, L + 1 - i], h, T;
        gain = (a, t) -> R[a, t]
    )
    @test y ≈ ref
end

@testitem "Recurrence: time-varying kernels" setup = [Reference] begin
    using ComposableRecurrences, Random
    rng = Xoshiro(5)
    S, L, T = 3, 4, 7
    h = rand(rng, S, L)
    R = rand(rng, S, T)
    K = rand(rng, S, S)

    # Shared across strata: L × T.
    G = rand(rng, L, T)
    y = Recurrence(TimeVarying(G); coupling = K)(R; history = h)
    ref = naive_recurrence(
        (t, a, b, i) -> K[a, b] * G[L + 1 - i, t], h, T;
        gain = (a, t) -> R[a, t]
    )
    @test y ≈ ref

    # Per stratum: S × L × T.
    G3 = rand(rng, S, L, T)
    y = Recurrence(TimeVarying(G3); coupling = K)(R; history = h)
    ref = naive_recurrence(
        (t, a, b, i) -> K[a, b] * G3[b, L + 1 - i, t], h, T;
        gain = (a, t) -> R[a, t]
    )
    @test y ≈ ref

    # A time-varying kernel alone fixes the number of steps.
    y = Recurrence(TimeVarying(G))(1.0; history = h[1, :])
    ref = naive_recurrence(
        (t, a, b, i) -> G[L + 1 - i, t], h[1:1, :], T
    )
    @test y ≈ vec(ref)
end

@testitem "Recurrence: sparse coupling" setup = [Reference] begin
    using ComposableRecurrences, SparseArrays, Random
    rng = Xoshiro(6)
    S, L, T = 4, 3, 9
    K = sparse([1, 2, 2, 3, 4, 4], [1, 1, 2, 3, 2, 4], rand(rng, 6), S, S)
    g = rand(rng, L)
    h = rand(rng, S, L)
    R = rand(rng, S, T)
    y = Recurrence(g; coupling = K)(R; history = h)
    ref = naive_recurrence(
        (t, a, b, i) -> K[a, b] * g[L + 1 - i], h, T; gain = (a, t) -> R[a, t]
    )
    @test y ≈ ref
end

@testitem "Recurrence: time-varying coupling" setup = [Reference] begin
    using ComposableRecurrences, Random
    rng = Xoshiro(7)
    S, L, T = 3, 4, 6
    C = rand(rng, S, S, T)
    g = rand(rng, L)
    h = rand(rng, S, L)
    R = rand(rng, S, T)
    y = Recurrence(g; coupling = TimeVarying(C))(R; history = h)
    ref = naive_recurrence(
        (t, a, b, i) -> C[a, b, t] * g[L + 1 - i], h, T;
        gain = (a, t) -> R[a, t]
    )
    @test y ≈ ref
end

@testitem "Recurrence: pairwise kernel" setup = [Reference] begin
    using ComposableRecurrences, Random
    rng = Xoshiro(8)
    S, L, T = 3, 4, 8
    P = rand(rng, S, S, L)
    h = rand(rng, S, L)
    R = rand(rng, S, T)
    y = Recurrence(nothing; coupling = Pairwise(P))(R; history = h)
    ref = naive_recurrence(
        (t, a, b, i) -> P[a, b, i], h, T; gain = (a, t) -> R[a, t]
    )
    @test y ≈ ref
end

@testitem "Recurrence: modifiers thread in tuple order" setup = [Reference, TestModifiers] begin
    using ComposableRecurrences, Random
    rng = Xoshiro(9)
    S, L, T = 2, 3, 6
    g = rand(rng, L)
    h = rand(rng, S, L)
    R = rand(rng, S, T)
    b = rand(rng, T)
    w = (t, a, c, i) -> (a == c) * g[L + 1 - i]
    scale_then_shift = Recurrence(g; modifiers = (Scale(2.0), Shift(b)))
    shift_then_scale = Recurrence(g; modifiers = (Shift(b), Scale(2.0)))
    ref1 = naive_recurrence(
        w, h, T; gain = (a, t) -> R[a, t], post! = (v, t) -> (v .= 2 .* v .+ b[t])
    )
    ref2 = naive_recurrence(
        w, h, T; gain = (a, t) -> R[a, t],
        post! = (v, t) -> (v .= 2 .* (v .+ b[t]))
    )
    @test scale_then_shift(R; history = h) ≈ ref1
    @test shift_then_scale(R; history = h) ≈ ref2
    @test !(ref1 ≈ ref2)
end

@testitem "Recurrence: modifier state carries across steps" setup = [Reference, TestModifiers] begin
    using ComposableRecurrences, Random
    rng = Xoshiro(10)
    S, L, T = 3, 4, 12
    g = rand(rng, L)
    K = rand(rng, S, S)
    h = 5 .* rand(rng, S, L)
    R = 1.5 .+ rand(rng, S, T)
    pop = [200.0, 300.0, 40.0]
    y = Recurrence(g; coupling = K, modifiers = (FlooredDepletion(pop),))(
        R; history = h
    )
    susceptible = copy(pop)
    function deplete!(v, t)
        for a in eachindex(v)
            v[a] *= max(susceptible[a] / pop[a], 1.0e-6)
            susceptible[a] -= v[a]
        end
        return v
    end
    ref = naive_recurrence(
        (t, a, b, i) -> K[a, b] * g[L + 1 - i], h, T;
        gain = (a, t) -> R[a, t], post! = deplete!
    )
    @test y ≈ ref
    # The third stratum's pool is nearly used up, so depletion matters.
    @test susceptible[3] < 0.1 * pop[3]
end

@testitem "Recurrence: argument validation" begin
    using ComposableRecurrences
    g = [0.2, 0.3, 0.5]
    @test_throws ArgumentError Recurrence(g; coupling = Pairwise(ones(2, 2, 3)))
    @test_throws ArgumentError Recurrence(nothing)
    @test_throws ArgumentError Recurrence(g)(1.0; history = ones(3))
    @test_throws DimensionMismatch Recurrence(g)(ones(5); history = ones(2))
    @test_throws DimensionMismatch Recurrence(g)(ones(5); history = ones(3), add = ones(4))
    @test_throws DimensionMismatch Recurrence(g; coupling = ones(3, 3))(
        ones(2, 5); history = ones(2, 3)
    )
    @test_throws DimensionMismatch Recurrence(g)(ones(3, 5); history = ones(2, 3))
end

@testitem "Recurrence: resume from the returned state" setup = [TestModifiers] begin
    using ComposableRecurrences, Random
    rng = Xoshiro(11)
    S, L, T = 3, 4, 10
    r = Recurrence(
        rand(rng, L); coupling = rand(rng, S, S),
        modifiers = (FlooredDepletion([50.0, 80.0, 60.0]), Scale(0.9))
    )
    h = rand(rng, S, L)
    R = 1 .+ rand(rng, S, T)
    ϵ = rand(rng, S, T)
    full = r(R; history = h, add = ϵ)
    y1, state = r(R[:, 1:4]; history = h, add = ϵ[:, 1:4], return_state = true)
    @test y1 ≈ full[:, 1:4]
    @test state.history ≈ full[:, 1:4]
    @test length(state.states) == 2
    y2 = r(R[:, 5:end]; history = state, add = ϵ[:, 5:end])
    @test y2 ≈ full[:, 5:end]

    # Resuming twice matches as well, and a single series keeps its shape.
    y2a, state2 = r(
        R[:, 5:7]; history = state, add = ϵ[:, 5:7], return_state = true
    )
    y2b = r(R[:, 8:end]; history = state2, add = ϵ[:, 8:end])
    @test hcat(y2a, y2b) ≈ full[:, 5:end]

    r1 = Recurrence([0.1, 0.2, 0.3, 0.4])
    h1 = rand(rng, 4)
    full1 = r1(R[1, :]; history = h1)
    y, st = r1(R[1, 1:6]; history = h1, return_state = true)
    @test st.history isa Vector
    @test st.history ≈ full1[3:6]
    @test r1(R[1, 7:end]; history = st) ≈ full1[7:end]
end
