# `Recent`: a modifier parameter read from the recurrence's own outputs.
# Values against naive loops and against the same run with the source
# replaced by the series it read; gradients through the outputs against
# ForwardDiff.

@testmodule RecentSpill begin
    using ComposableRecurrences
    const CR = ComposableRecurrences
    # A share `ε` of each stratum's value moves to the others through `K`:
    # a vector step whose parameter `ε` may read the outputs.
    struct Spill{K, E}
        K::K
        ε::E
    end
    CR.forward(::Spill, ::CR.Init, s, history) = (fill!(s, zero(eltype(s))); nothing)
    CR.pullback!(grads, ::Spill, ::CR.Init, s, history) = nothing
    function CR.forward(m::Spill, ::CR.Step, v, s, t)
        u = copy(v)
        for p in eachindex(v)
            acc = (1 - CR.param(m.ε, p, t)) * u[p]
            for q in eachindex(u)
                q == p || (acc += CR.param(m.ε, q, t) * m.K[p, q] * u[q])
            end
            v[p] = acc
        end
        return nothing
    end
    # `ū_q = (1 − ε_q) v̄_q + ε_q c_q` and `ε̄_q += u_q (c_q − v̄_q)`, with
    # `c_q = Σ_{p ≠ q} K[p, q] v̄_p`.
    function CR.pullback!(grads, m::Spill, ::CR.Step, v, s, t)
        v̄′ = copy(grads.v)
        ε̄ = CR.cotangent(grads.piece, :ε)
        for q in eachindex(v)
            c = zero(eltype(v̄′))
            for p in eachindex(v)
                p == q || (c += m.K[p, q] * v̄′[p])
            end
            εq = CR.param(m.ε, q, t)
            CR.add_param!(ε̄, m.ε, v[q] * (c - v̄′[q]), q, t)
            grads.v[q] = (1 - εq) * v̄′[q] + εq * c
        end
        return nothing
    end
end

@testitem "Recent: construction, depth and errors" begin
    using ComposableRecurrences
    const CR = ComposableRecurrences
    @test Recent(3).w == [true, true, true]
    @test Recent([0.5, 0.2]).w == [0.5, 0.2]
    @test CR.depth(Recent(7)) == 7
    @test CR.depth(CR.Transform(*, Derived(exp, -0.1 * Recent(9)))) == 9
    # A nested operator keeps its own buffer.
    inner = Recurrence([0.5]; modifiers = (CR.Add(Recent(12)),))
    @test CR.depth(inner) == 0
    @test CR.depth((inner, Recent(3))) == 3
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

@testitem "Recent: any modifier parameter reads the outputs it would see" setup = [RecentSpill] begin
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
        (
            u -> RecentSpill.Spill(K, u), x -> Derived(tanh, 0.01 * x),
            u -> tanh(0.01 * u),
        ),
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

@testitem "Recent: reverse pass through the outputs" setup = [AdjointCheck, RecentSpill] begin
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
        (RecentSpill.Spill(K, Derived(tanh, 0.1 * Recent(w))),),
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
    # Every parameter form takes the removal path.
    u = collect(range(0.5, 3.0; length = 10))
    @test r(2.0 * Derived(identity, TimeVarying(u)))(R; history = ones(2)) ≈
        r(TimeVarying(2.0 .* u))(R; history = ones(2))
    h = ones(2, 2)
    R2 = fill(1.5, 2, 10)
    rs(u) = Recurrence([0.5, 0.4]; modifiers = (CR.Depletion(PerStratum([80.0, 120.0]); removals = u),))
    @test rs(Derived(sqrt, PerStratum([4.0, 9.0])))(R2; history = h) ≈
        rs(PerStratum([2.0, 3.0]))(R2; history = h)
end

@testitem "Recent: unbound reverse, rebinding and plain fields" begin
    using ComposableRecurrences
    const CR = ComposableRecurrences
    @test_throws "inside a Recurrence" CR.add_param!(nothing, Recent(2), 1.0, 1, 1)
    b = CR._bind(Recent(2), zeros(4, 1), nothing, 1)
    @test CR._bind(b, ones(4, 1), nothing, 2).H == ones(4, 1)
    @test !CR._reads_outputs((Float64, Base))
    @test CR._float_param(Recent(2)) isa Recent
    @test CR.depth(CR.Depletion(Recent(3))) == 3
    # A function is a leaf, as for `depth`: a closure's captured values are
    # not bound.
    f = let x = Recent(2)
        v -> v + 0 * length(x.w)
    end
    @test !CR._reads_outputs(f)
    @test CR.depth(f) == 0
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
            # Init reads the population at time 1, the first step's row.
            (CR.Depletion(100.0 + 5 * Recent(W; coupling = C)),),
        )
        for ms in mods
            r = Recurrence(g; modifiers = ms)
            @test pullback_matches(r, recargs(R, nothing, h)...)
            @test pullback_matches(CR._WithState(r), recargs(R, nothing, h)...)
        end
    end
end

@testitem "Recent: binding, rebinding and mirrors" begin
    using ComposableRecurrences
    const CR = ComposableRecurrences
    H, H2, H̄ = rand(10, 2), rand(10, 2), zeros(10, 2)
    # An unbound source has no cotangent to take either.
    @test_throws "inside a Recurrence" CR.add_param!(nothing, Recent(2), 1.0, 1, 1)
    # Binding a bound source moves it to the new buffer.
    b = CR._bind(CR._bind(Recent(2), H, nothing, 3), H2, H̄, 3)
    @test b.H === H2
    @test b.H̄ === H̄
    @test CR.param(b, 1, 4) ≈ H2[6, 1] + H2[5, 1]
    # Without a mirror, arguments that read the outputs still get one
    # `nothing` mirror each, so their cotangents reach the buffer.
    @test CR._arg_mirrors(nothing, (1.0, Recent(2))) === (nothing, nothing)
    @test CR._arg_mirrors(nothing, (1.0, 2.0)) === nothing
    θ = (; a = 1.0, b = CR._bind(Recent(2), H, H̄, 3))
    @test CR._arg_mirrors(nothing, θ) === (nothing, nothing)
end

@testitem "Recent: a coupled read back at a row other than the cached one" begin
    using ComposableRecurrences, Random
    const CR = ComposableRecurrences
    rng = Xoshiro(41)
    S, W, n = 3, 2, 8
    H, w, C = rand(rng, n, S), rand(rng, W), rand(rng, S, S)
    # Reads at the cached row `i = 5` and, without a refresh, at row 7.
    reads = ((1.5, 2, 5), (-0.7, 3, 7), (0.4, 1, 5))
    H̄e, w̄e, C̄e = zeros(n, S), zeros(W), zeros(S, S)
    for (v, k, i) in reads, j in 1:S, l in 1:W
        H̄e[i - l, j] += v * C[k, j] * w[l]
        w̄e[l] += v * C[k, j] * H[i - l, j]
        C̄e[k, j] += v * w[l] * H[i - l, j]
    end
    H̄, x̄ = zeros(n, S), (; w = zeros(W), coupling = zeros(S, S))
    b = CR._bind(Recent(w; coupling = C), H, H̄, 0)
    CR._refresh!((b,), 5)
    for (v, k, i) in reads
        CR.add_param!(x̄, b, v, k, i)
    end
    CR._flush!((b,))
    @test H̄ ≈ H̄e
    @test x̄.w ≈ w̄e
    @test x̄.coupling ≈ C̄e
end
