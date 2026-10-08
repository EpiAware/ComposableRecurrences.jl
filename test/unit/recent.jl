# `Recent`: a modifier parameter read from the recurrence's own outputs.
# Values against naive loops and against the same run with the source
# replaced by the series it read; gradients through the outputs against
# ForwardDiff.

@testitem "Recent: construction, depth and errors" begin
    using ComposableRecurrences
    const CR = ComposableRecurrences
    @test Recent(3).w == [true, true, true]
    @test Recent([0.5, 0.2]).w == [0.5, 0.2]
    @test CR.depth(Recent(7)) == 7
    @test CR.depth(CR.Transform(*, Derived(exp, -0.1 * Recent(9)))) == 9
    @test_throws "n >= 1" Recent(0)
    @test_throws "at least one weight" Recent(Float64[])
    err = try
        CR.param(Recent(2), 1, 1)
    catch e
        e
    end
    @test err isa ArgumentError
    @test occursin("inside a Recurrence", err.msg)
    @test_throws "does not vary over time" CR.Depletion(
        100.0; pool0 = Recent(2)
    )
end

@testitem "Recent: arithmetic builds Derived" begin
    using ComposableRecurrences
    x = Recent(3)
    for y in (2.0 * x, x * 2.0, x + 1.0, 1.0 - x, x / 4.0, x^2, -x, x + x)
        @test y isa Derived
    end
    @test (0.5 * Derived(identity, 2.0) + x) isa Derived
    @test (x + Derived(identity, 2.0)) isa Derived
    @test (x * PerStratum([1.0, 2.0])) isa Derived
    @test (TimeVarying([1.0, 2.0]) * x) isa Derived
end

@testitem "Recent: behaviour feedback against a naive loop" begin
    using ComposableRecurrences, Random
    const CR = ComposableRecurrences
    rng = Xoshiro(21)
    S, L, T, W = 3, 3, 15, 7
    g = rand(rng, L) ./ 2
    h = rand(rng, S, W + 2)
    R = 1.0 .+ rand(rng, S, T)
    κ = 0.05
    w = rand(rng, W)
    naive = function (src)
        y = hcat(h, zeros(S, T))
        m = size(h, 2)
        for t in 1:T, k in 1:S
            i = m + t
            p = sum(g[l] * y[k, i - l] for l in 1:L)
            u = sum(src[l] * y[k, i - l] for l in eachindex(src))
            y[k, i] = R[k, t] * p * exp(-κ * u)
        end
        return y[:, (m + 1):end]
    end
    for src in (ones(W), w)
        x = src == ones(W) ? Recent(W) : Recent(src)
        β = Derived(exp, -κ * x)
        r = Recurrence(g; modifiers = (CR.Transform(*, β),))
        @test r(R; history = h) ≈ naive(src)
        # A single series.
        @test Recurrence(g; modifiers = (CR.Transform(*, β),))(
            R[1, :]; history = h[1, :]
        ) ≈ vec(naive(src)[1, :])
    end
    # A history shorter than the window reads zeros before it.
    r = Recurrence(g; modifiers = (CR.Transform(*, Derived(exp, -κ * Recent(W))),))
    h2 = h[:, (end - 1):end]
    y = hcat(zeros(S, W - 2), h2, zeros(S, T))
    for t in 1:T, k in 1:S
        i = W + t
        p = sum(g[l] * y[k, i - l] for l in 1:L)
        y[k, i] = R[k, t] * p * exp(-κ * sum(y[k, (i - W):(i - 1)]))
    end
    @test r(R; history = h2) ≈ y[:, (W + 1):end]
end

@testitem "Recent: any modifier parameter reads the outputs it would see" begin
    using ComposableRecurrences, LinearAlgebra, Random
    const CR = ComposableRecurrences
    rng = Xoshiro(22)
    S, L, T, W = 2, 3, 12, 5
    g = rand(rng, L)
    K = [0.8 0.2; 0.3 0.7]
    h = 5 .* rand(rng, S, W)
    R = 1.0 .+ rand(rng, S, T)
    # The source's value at each time, from the outputs `y` of a run.
    function read_back(f, y, w)
        Y = hcat(h, y)
        return [f(sum(w[l] * Y[k, W + t - l] for l in eachindex(w))) for k in 1:S, t in 1:T]
    end
    cases = (
        # Ring vaccination: removals scale with recent cases.
        (
            u -> CR.Depletion(PerStratum([200.0, 300.0]); removals = u),
            x -> 0.3 * x, u -> 0.3 * u,
        ),
        (u -> CR.Add(u), x -> -0.05 * x, u -> -0.05 * u),
        (u -> CR.Clamp(0.0, u), x -> 2.0 + x, u -> 2.0 + u),
        (u -> CR.Redistribute(K, u), x -> Derived(tanh, 0.01 * x), u -> tanh(0.01 * u)),
    )
    for (build, src, f) in cases, C in (I, K)
        w = rand(rng, W)
        r = Recurrence(g; coupling = C, modifiers = (build(src(Recent(w))),))
        y = r(R; history = h)
        u = TimeVarying(PerStratum(read_back(f, y, w)))
        ref = Recurrence(g; coupling = C, modifiers = (build(u),))(R; history = h)
        @test y ≈ ref
    end
end

@testitem "Recent: the state resumes with the deeper past" begin
    using ComposableRecurrences
    const CR = ComposableRecurrences
    g = [0.3, 0.4]
    r = Recurrence(g; modifiers = (CR.Transform(*, Derived(exp, -0.02 * Recent(6))),))
    R = fill(1.4, 2, 12)
    h = ones(2, 6)
    y = r(R; history = h)
    y1, st = CR.with_state(r, R; history = h, stop = 5)
    @test size(st.history) == (2, 6)
    @test hcat(y1, r(R; state = st)) ≈ y
end

@testitem "Recent: reverse pass through the outputs" setup = [AdjointCheck] begin
    using ComposableRecurrences, LinearAlgebra, Random
    rng = Xoshiro(23)
    S, L, T, W = 2, 3, 10, 5
    g = rand(rng, L) ./ 2
    K = [0.8 0.2; 0.3 0.7]
    h = rand(rng, S, W)
    R = 1.0 .+ rand(rng, S, T)
    w = rand(rng, W)
    mods = (
        (CR.Transform(*, Derived(exp, -0.05 * Recent(w))),),
        (CR.Transform(*, Derived(exp, -0.05 * Recent(W))),),
        (CR.Depletion(PerStratum([50.0, 80.0]); removals = 0.2 * Recent(w)),),
        (CR.Add(-0.01 * Recent(w)), CR.Clamp(0.0, 10.0 - Recent(3))),
        (CR.Redistribute(K, Derived(tanh, 0.1 * Recent(w))),),
    )
    for ms in mods, C in (I, K)
        r = Recurrence(g; coupling = C, modifiers = ms)
        @test CR.uses_adjoint(r, CR.Run())
        @test pullback_matches(r, recargs(R, nothing, h)...)
        @test pullback_matches(CR._WithState(r), recargs(R, nothing, h)...)
    end
end

@testitem "Recent: a modifier without its own pullback takes plain AD" begin
    using ComposableRecurrences
    const CR = ComposableRecurrences
    struct Scale{U}
        u::U
    end
    CR.ispointwise(::Scale) = true
    CR.forward(m::Scale, ::CR.Step, v, s, t, k) = (v * CR.param(m.u, k, t), s)
    r = Recurrence([0.5, 0.3]; modifiers = (Scale(Derived(exp, -0.1 * Recent(4))),))
    @test !CR.uses_adjoint(r, CR.Run())
    r0 = Recurrence([0.5, 0.3]; modifiers = (Scale(1.0),))
    @test CR.uses_adjoint(r0, CR.Run())
    y = r(fill(1.5, 6); history = ones(4))
    @test y ≈ Recurrence(
        [0.5, 0.3]; modifiers = (CR.Transform(*, Derived(exp, -0.1 * Recent(4))),)
    )(fill(1.5, 6); history = ones(4))
end

@testitem "Depletion: Derived removals are removed" begin
    using ComposableRecurrences
    const CR = ComposableRecurrences
    r(u) = Recurrence([0.5, 0.4]; modifiers = (CR.Depletion(100.0; removals = u),))
    R = fill(1.5, 10)
    @test r(Derived(identity, 2.0))(R; history = ones(2)) ≈ r(2.0)(R; history = ones(2))
    @test !(r(2.0)(R; history = ones(2)) ≈ r(0.0)(R; history = ones(2)))
end

@testitem "Recent: a read before the window is an error" begin
    using ComposableRecurrences
    const CR = ComposableRecurrences
    # Depletion's Init reads N at time 1, before a run that starts at 5.
    r = Recurrence([0.5, 0.3]; modifiers = (CR.Depletion(100.0 + Recent(3)),))
    @test_throws "read at time 1" r(fill(1.2, 8); history = ones(4), start = 5)
end

@testitem "Recent: an Init that reads the outputs sends its cotangent to the history" setup = [AdjointCheck] begin
    using ComposableRecurrences, LinearAlgebra, Random
    rng = Xoshiro(24)
    S, L, T = 2, 3, 8
    g = rand(rng, L) ./ 2
    K = [0.8 0.2; 0.3 0.7]
    h = 5 .+ rand(rng, S, 4)
    R = 1.0 .+ rand(rng, S, T)
    mods = (
        (CR.Depletion(100.0 + 10 * Recent(3)),),
        (
            CR.Depletion(
                100.0 + 10 * Recent(3); removals = 0.1 * Recent(2),
                protected = CR.Protected(0.3)
            ),
        ),
    )
    for ms in mods, C in (I, K)
        r = Recurrence(g; coupling = C, modifiers = ms)
        @test pullback_matches(r, recargs(R, nothing, h)...)
    end
end

@testitem "Recent: binding infers" begin
    using ComposableRecurrences
    const CR = ComposableRecurrences
    H = zeros(10, 2)
    mods = (
        CR.Transform(*, Derived(exp, -0.05 * Recent(7))),
        CR.Depletion(PerStratum([1.0, 2.0]); removals = 0.2 * Recent(3)),
        CR.Transform((v, θ) -> v * θ.a, (; a = Recent(2))),
    )
    @test @inferred(CR._bind(mods, H, nothing, 1)) isa Tuple
    @test @inferred(CR._bind(mods, H, H, 1)) isa Tuple
    @test_throws "per group" CR.Allocate([[1], [2]], Recent(2))
end

@testitem "Recent: a coupling against a naive loop" begin
    using ComposableRecurrences, LinearAlgebra, Random, SparseArrays
    const CR = ComposableRecurrences
    rng = Xoshiro(31)
    S, L, T, W = 3, 3, 12, 5
    g = rand(rng, L) ./ 2
    h = rand(rng, S, W)
    R = 1.0 .+ rand(rng, S, T)
    w = rand(rng, W)
    κ = 0.04
    naive = function (C)
        y = hcat(h, zeros(S, T))
        for t in 1:T, k in 1:S
            i = W + t
            p = sum(g[l] * y[k, i - l] for l in 1:L)
            u = sum(C[k, j] * w[l] * y[j, i - l] for j in 1:S, l in 1:W)
            y[k, i] = R[k, t] * p * exp(-κ * u)
        end
        return y[:, (W + 1):end]
    end
    for C in (rand(rng, S, S), ones(S, S), sparse([1.0 0.0 0.5; 0.0 1.0 0.0; 0.2 0.0 1.0]))
        r = Recurrence(
            g; modifiers = (CR.Transform(*, Derived(exp, -κ * Recent(w; coupling = C))),)
        )
        @test r(R; history = h) ≈ naive(C)
        # Threaded, the strata no longer run on their own.
        @test CR._reads_across(r.modifiers)
        @test !CR._independent(I, g, r.modifiers)
        # Split into one task per stratum, so a stratum run on its own
        # would read the others' outputs before they are written.
        y = Base.ScopedValues.with(CR.EXECUTOR => CR.Threaded(; min_work = 0, ntasks = S)) do
            r(R; history = h)
        end
        @test y ≈ naive(C)
    end
    @test !CR._reads_across((CR.Transform(*, Derived(exp, Recent(3))),))
    # The identity coupling reads each stratum's own outputs.
    rI = Recurrence(g; modifiers = (CR.Transform(*, Derived(exp, -κ * Recent(w; coupling = Matrix(1.0I, S, S)))),))
    r0 = Recurrence(g; modifiers = (CR.Transform(*, Derived(exp, -κ * Recent(w))),))
    @test rI(R; history = h) ≈ r0(R; history = h)
end

@testitem "Recent: coupling errors name the value" begin
    using ComposableRecurrences
    const CR = ComposableRecurrences
    @test_throws "S × S matrix" Recent(3; coupling = 2.0)
    @test Recent(3, ones(2, 2)).w == Recent(3; coupling = ones(2, 2)).w
    # Errors describe a Recent by its sizes, not its contents.
    @test_throws "Recent(2 weights; coupling 40 × 40)" CR.Depletion(
        100.0; pool0 = Recent(2; coupling = ones(40, 40))
    )
    r = Recurrence(
        [0.5]; modifiers = (CR.Add(Recent(2; coupling = ones(3, 3))),)
    )
    @test_throws "expected 2 × 2" r(ones(2, 4); history = ones(2, 2))
end

@testitem "Recent: reverse pass through a coupling" setup = [AdjointCheck] begin
    using ComposableRecurrences, LinearAlgebra, Random, SparseArrays
    rng = Xoshiro(32)
    S, L, T, W = 3, 3, 9, 4
    g = rand(rng, L) ./ 2
    h = rand(rng, S, W)
    R = 1.0 .+ rand(rng, S, T)
    w = rand(rng, W)
    for C in (rand(rng, S, S), sparse([1.0 0.0 0.5; 0.0 1.0 0.0; 0.2 0.0 1.0]))
        mods = (
            (CR.Transform(*, Derived(exp, -0.05 * Recent(w; coupling = C))),),
            (CR.Depletion(PerStratum([50.0, 80.0, 60.0]); removals = 0.1 * Recent(W; coupling = C)),),
        )
        for ms in mods
            r = Recurrence(g; modifiers = ms)
            @test pullback_matches(r, recargs(R, nothing, h)...)
            @test pullback_matches(CR._WithState(r), recargs(R, nothing, h)...)
        end
    end
end
