# Recurrence values against the naive reference loop, one test item per slot
# shape. Kernels are lag first: `g[i]` weights lag `i`.

@testitem "Recurrence: fixed kernel, single series" setup = [Reference] begin
    using ComposableRecurrences, Random
    rng = Xoshiro(1)
    L, T = 4, 12
    g = rand(rng, L)
    h = rand(rng, L)
    R = 0.5 .+ rand(rng, T)
    w = (t, a, b, i) -> g[i]
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
        (t, a, b, i) -> K[a, b] * g[i], h, T;
        gain = (a, t) -> R[a, t], add = (a, t) -> ϵ[a, t]
    )
    @test size(y) == (S, T)
    @test y ≈ ref

    # A length-T gain is shared by every stratum.
    r = rand(rng, T)
    y = Recurrence(g; coupling = K)(r; history = h)
    ref = naive_recurrence(
        (t, a, b, i) -> K[a, b] * g[i], h, T; gain = (a, t) -> r[t]
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
        (t, a, b, i) -> (a == b) * λ * g[i], h, T;
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
        (t, a, b, i) -> (a == b) * d[a] * G[b, i], h, T;
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
        (t, a, b, i) -> K[a, b] * G[i, t], h, T;
        gain = (a, t) -> R[a, t]
    )
    @test y ≈ ref

    # Per stratum: S × L × T.
    G3 = rand(rng, S, L, T)
    y = Recurrence(TimeVarying(PerStratum(G3)); coupling = K)(R; history = h)
    ref = naive_recurrence(
        (t, a, b, i) -> K[a, b] * G3[b, i, t], h, T;
        gain = (a, t) -> R[a, t]
    )
    @test y ≈ ref

    # A time-varying kernel is not a call input, so `stop` sets the times.
    y = Recurrence(TimeVarying(G))(1.0; history = h[1, :], stop = T)
    ref = naive_recurrence(
        (t, a, b, i) -> G[i, t], h[1:1, :], T
    )
    @test y ≈ vec(ref)
    @test_throws ArgumentError Recurrence(TimeVarying(G))(1.0; history = h[1, :])
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
        (t, a, b, i) -> K[a, b] * g[i], h, T; gain = (a, t) -> R[a, t]
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
        (t, a, b, i) -> C[a, b, t] * g[i], h, T;
        gain = (a, t) -> R[a, t]
    )
    @test y ≈ ref
end

@testitem "Recurrence: pairwise kernel" setup = [Reference] begin
    using ComposableRecurrences, LinearAlgebra, Random
    rng = Xoshiro(8)
    S, L, T = 3, 4, 8
    P = rand(rng, S, S, L)
    h = rand(rng, S, L)
    R = rand(rng, S, T)
    y = Recurrence(Pairwise(P))(R; history = h)
    ref = naive_recurrence(
        (t, a, b, i) -> P[a, b, i], h, T; gain = (a, t) -> R[a, t]
    )
    @test y ≈ ref
    @test Recurrence(Pairwise(P); coupling = I)(R; history = h) ≈ ref
    # Time-varying, with either nesting order.
    P4 = rand(rng, S, S, L, T)
    ref = naive_recurrence(
        (t, a, b, i) -> P4[a, b, i, t], h, T; gain = (a, t) -> R[a, t]
    )
    @test Recurrence(TimeVarying(Pairwise(P4)))(R; history = h) ≈ ref
    @test Recurrence(Pairwise(TimeVarying(P4)))(R; history = h) ≈ ref
    # With a modifier, as any kernel.
    y = Recurrence(Pairwise(P); modifiers = (ComposableRecurrences.Add(0.5),))(
        R; history = h
    )
    @test y ≈ naive_recurrence(
        (t, a, b, i) -> P[a, b, i], h, T; gain = (a, t) -> R[a, t],
        add = (a, t) -> 0.5
    )
end

@testitem "Recurrence: modifiers thread in tuple order" setup = [Reference, TestModifiers] begin
    using ComposableRecurrences, Random
    rng = Xoshiro(9)
    S, L, T = 2, 3, 6
    g = rand(rng, L)
    h = rand(rng, S, L)
    R = rand(rng, S, T)
    b = rand(rng, T)
    w = (t, a, c, i) -> (a == c) * g[i]
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
        (t, a, b, i) -> K[a, b] * g[i], h, T;
        gain = (a, t) -> R[a, t], post! = deplete!
    )
    @test y ≈ ref
    # The third stratum's pool is nearly used up, so depletion matters.
    @test susceptible[3] < 0.1 * pop[3]
end

@testitem "Recurrence: argument validation" begin
    using ComposableRecurrences, LinearAlgebra
    g = [0.2, 0.3, 0.5]
    # Pairwise is a kernel, and it already mixes strata.
    @test_throws ArgumentError Recurrence(g; coupling = Pairwise(ones(2, 2, 3)))
    @test_throws ArgumentError Recurrence(Pairwise(ones(2, 2, 3)); coupling = ones(2, 2))
    @test_throws ArgumentError Recurrence(Pairwise(ones(2, 2, 3)); coupling = 0.5I)
    @test_throws ArgumentError Recurrence(nothing)
    # No time-indexed input: stop is required.
    @test_throws ArgumentError Recurrence(g)(1.0; history = ones(3))
    # Inputs of different lengths need stop, and must cover it.
    @test_throws DimensionMismatch Recurrence(g)(ones(5); history = ones(3), add = ones(4))
    @test Recurrence(g)(ones(5); history = ones(3), add = ones(4), stop = 4) ≈
        Recurrence(g)(ones(4); history = ones(3), add = ones(4))
    @test_throws DimensionMismatch Recurrence(g)(ones(5); history = ones(3), stop = 6)
    @test_throws DimensionMismatch Recurrence(TimeVarying(ones(3, 4)))(
        ones(5); history = ones(3)
    )
    # A bare array keeps its plain meaning: lags only.
    @test_throws ArgumentError Recurrence(ones(2, 3))
    @test_throws ArgumentError Recurrence(TimeVarying(ones(2, 3, 4)))
    @test_throws ArgumentError Recurrence(PerStratum(ones(2, 3, 4)))
    # Primary indexing is a convolution kernel's, not a recurrence's or a coupling's.
    @test_throws ArgumentError(
        "Recurrence takes a Secondary() time-varying kernel, " *
            "not Primary(), which is for Convolution"
    ) Recurrence(TimeVarying(ones(3, 4), ComposableRecurrences.Primary()))
    @test_throws ArgumentError Recurrence(
        g; coupling = TimeVarying(ones(2, 2, 4), ComposableRecurrences.Primary())
    )
    @test_throws ArgumentError Recurrence(g; coupling = TimeVarying(ones(2, 4)))
    # Call inputs are data, never wrapped.
    @test_throws ArgumentError Recurrence(g)(TimeVarying(ones(5)); history = ones(3))
    # A seed or a state, and a resumed call starts where it left off.
    y, state = ComposableRecurrences.with_state(
        Recurrence(g), ones(5); history = ones(3), stop = 2
    )
    @test_throws ArgumentError Recurrence(g)(ones(5); history = ones(3), state)
    @test_throws ArgumentError Recurrence(g)(ones(5); state, start = 3)
    @test_throws ArgumentError Recurrence(g)(ones(5); history = ones(3), start = 0)
    @test_throws DimensionMismatch Recurrence(g; coupling = ones(3, 3))(
        ones(2, 5); history = ones(2, 3)
    )
    @test_throws DimensionMismatch Recurrence(g)(ones(3, 5); history = ones(2, 3))
    # A 2-D time-varying coupling is refused even when T equals S.
    @test_throws ArgumentError Recurrence(g; coupling = TimeVarying(ones(2, 2)))(
        ones(2, 2); history = ones(2, 3)
    )
end

@testitem "Recurrence: resume from the returned state" setup = [TestModifiers] begin
    using ComposableRecurrences, Random
    CR = ComposableRecurrences
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
    y1, state = CR.with_state(r, R; history = h, add = ϵ, stop = 4)
    @test state isa ComposableRecurrences.State
    @test y1 ≈ full[:, 1:4]
    @test state.history ≈ full[:, 1:4]
    @test length(state.states) == 2
    @test state.t == 5
    # The resumed call reads the same full-length inputs from `state.t`.
    y2 = r(R; state, add = ϵ)
    @test y2 ≈ full[:, 5:end]

    # Resuming twice matches as well, and a single series keeps its shape.
    y2a, state2 = CR.with_state(r, R; state, add = ϵ, stop = 7)
    y2b = r(R; state = state2, add = ϵ)
    @test hcat(y2a, y2b) ≈ full[:, 5:end]

    r1 = Recurrence([0.1, 0.2, 0.3, 0.4])
    h1 = rand(rng, 4)
    full1 = r1(R[1, :]; history = h1)
    y, st = CR.with_state(r1, R[1, :]; history = h1, stop = 6)
    @test st.history isa Vector
    @test st.history ≈ full1[3:6]
    @test r1(R[1, :]; state = st) ≈ full1[7:end]
end

@testitem "Recurrence: absolute time and start" setup = [Reference, TestModifiers] begin
    using ComposableRecurrences, Random
    rng = Xoshiro(12)
    L, T = 4, 12
    G = rand(rng, L, T)
    b = rand(rng, T)
    h = rand(rng, L)
    R = 1 .+ rand(rng, T)
    r = Recurrence(TimeVarying(G); modifiers = (Shift(b),))
    full = r(R; history = h)
    ref = naive_recurrence(
        (t, a, c, i) -> G[i, t], reshape(h, 1, L), T;
        gain = (a, t) -> R[t], post! = (v, t) -> (v .+= b[t])
    )
    @test full ≈ vec(ref)

    # A resumed call continues at the state's next time.
    y1, state = ComposableRecurrences.with_state(r, R; history = h, stop = 5)
    @test state.t == 6
    @test r(R; state) ≈ full[6:end]

    # An explicit start reads the gain and time-varying slots from that
    # time, with the history holding the outputs just before it.
    @test r(R; history = [h; full][6:9], start = 6) ≈ full[6:end]
    @test r(R; history = [h; full][6:9], start = 6, stop = 8) ≈ full[6:8]

    # The output covers start:stop.
    y = Recurrence(TimeVarying(G))(; history = h, start = 9, stop = T)
    @test length(y) == T - 8
    @test isempty(Recurrence(TimeVarying(G))(; history = h, start = 9, stop = 8))

    # Without a history the run starts from zeros, with the strata of the
    # input.
    @test Recurrence([0.5])(; add = ones(3)) ≈ [1.0, 1.5, 1.75]
    @test Recurrence([0.5])(ones(2, 3); add = ones(2, 3)) ≈
        Recurrence([0.5])(ones(2, 3); history = zeros(2, 1), add = ones(2, 3))
end

@testitem "Recurrence: history longer than the kernel" setup = [Reference, TestModifiers] begin
    using ComposableRecurrences, Random
    rng = Xoshiro(13)
    S, L, T = 2, 3, 7
    g = rand(rng, L)
    h = rand(rng, S, L + 4)
    R = rand(rng, S, T)
    r = Recurrence(g)
    @test r(R; history = h) ≈ r(R; history = h[:, 5:end])

    # Init sees the whole history.
    y = Recurrence(g; modifiers = (HistoryTotal(),))(R; history = h)
    total = vec(sum(h; dims = 2))
    ref = naive_recurrence(
        (t, a, c, i) -> (a == c) * g[i], h[:, 5:end], T;
        gain = (a, t) -> R[a, t], post! = (v, t) -> (v .+= total)
    )
    @test y ≈ ref
end

@testitem "Recurrence: gain defaults to one" begin
    using ComposableRecurrences, Random
    rng = Xoshiro(14)
    g = rand(rng, 3)
    h = rand(rng, 3)
    ϵ = randn(rng, 10)
    @test Recurrence(g)(; history = h, add = ϵ) ≈
        Recurrence(g)(1.0; history = h, add = ϵ)
end

@testitem "Recurrence: history shorter than the kernel is zero-padded" setup = [Reference] begin
    using ComposableRecurrences, Random
    rng = Xoshiro(15)
    L, T = 5, 8
    g = rand(rng, L)
    R = 1 .+ rand(rng, T)
    h = rand(rng, 2)
    r = Recurrence(g)
    @test r(R; history = h) ≈ r(R; history = [zeros(L - 2); h])
    y = r(R; history = Float64[], add = 1.0)
    @test y ≈ r(R; history = zeros(L), add = 1.0)
    H = rand(rng, 3, 2)
    @test Recurrence(g)(ones(3, T); history = H) ≈
        Recurrence(g)(ones(3, T); history = [zeros(3, L - 2) H])
end

@testitem "seeded matches its expansion" begin
    using ComposableRecurrences, ForwardDiff
    CR = ComposableRecurrences
    g = [0.3, 0.5, 0.2]
    d = CR.Depletion(80.0; pool0 = 71.0)
    r = Recurrence(g; modifiers = (d,))
    # A single series, and strata with a seed shorter than the kernel.
    for (h, R) in (
            ([2.0, 3.0, 4.0], [0.0, 0.0, 0.0, 2.5, 2.2, 1.8, 1.5, 1.2]),
            ([1.0 2.0; 0.5 1.0], fill(1.8, 2, 7)),
        )
        m = size(h, ndims(h))
        expansion(h, R) = cat(h, r(R; history = h, start = m + 1); dims = ndims(h))
        @test CR.seeded(r, R; history = h) == expansion(h, R)
        @test size(CR.seeded(r, R; history = h)) == size(R)
        loss(f) = θ -> sum(abs2, f(reshape(θ[1:length(h)], size(h)), reshape(θ[(length(h) + 1):end], size(R))))
        θ = vcat(vec(h), vec(R))
        @test ForwardDiff.gradient(loss((h, R) -> CR.seeded(r, R; history = h)), θ) ≈
            ForwardDiff.gradient(loss(expansion), θ)
    end
    # Keywords pass through to the call.
    ϵ = collect(0.1:0.1:0.8)
    @test CR.seeded(Recurrence([0.5]), 1.0; history = [1.0], add = ϵ) ==
        vcat(1.0, Recurrence([0.5])(1.0; history = [1.0], add = ϵ, start = 2))
end

@testitem "Recurrence: history loads the same into any buffer" begin
    import ComposableRecurrences as CR
    using Random
    rng = Xoshiro(16)
    L, S = 4, 3
    # Histories shorter and longer than the buffer's `L` rows.
    for m in (2, 6)
        h = rand(rng, m)
        H = rand(rng, S, m)
        for (buf, src) in ((zeros(L + 2, 1), h), (zeros(L + 2, S), H))
            # `Array` buffers load by loop; a view takes the broadcast fallback.
            alt = view(zeros(size(buf)), :, :)
            @test !(alt isa Array)
            @test CR._load_history!(alt, src, L) == CR._load_history!(buf, src, L)
        end
    end
end
