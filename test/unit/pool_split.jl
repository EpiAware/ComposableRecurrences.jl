@testitem "Split flows: a pool short of its share passes the rest on" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    # The two count drains a split replaces, written out by hand as the reference.
    share_c(b, u, c) = u + c > 0 ? b * c / (u + c) : zero(b)
    left_u(u, A, h, κ, o) = u * (1 - κ - h) + A - o
    left_c(u, c, h, o) = c + h * u - o
    function drain_u(b, u, c, A, h, κ)
        oc = share_c(b, u, c)
        return (b - oc) + max(-left_c(u, c, h, oc), 0.0)
    end
    function drain_c(b, u, c, A, h, κ)
        oc = share_c(b, u, c)
        return oc + max(-left_u(u, A, h, κ, b - oc), 0.0)
    end
    cases = (
        (6.0, 2.0, 2.0, 1.0, 0.3, 0.02),
        (1.0, 8.0, 6.0, 0.0, 0.2, 0.1),
        (8.0, 0.5, 5.0, 0.0, 0.0, 0.0),
        (0.0, 0.0, 3.0, 2.0, 0.3, 0.02),
        (2.0, 1.0, 10.0, 0.5, 0.3, 0.02),
    )
    for (u, c, b, A, h, κ) in cases
        d = CR.Depletion(
            CR.Flow(:u => :c, h; form = CR.Share()),
            CR.Flow(:u => 0, κ; form = CR.Share()),
            CR.Flow(0 => :u, A; form = CR.Truncate()),
            CR.Flow((:u, :c) => 0, b; form = CR.Split());
            pools = (:u, :c)
        )
        y = Recurrence([true]; modifiers = (d,))(; history = [u; c;;], stop = 1)
        lu, lc = u * (1 - κ - h) + A, c + h * u
        mu = min(drain_u(b, u, c, A, h, κ), max(lu, 0.0))
        mc = min(drain_c(b, u, c, A, h, κ), max(lc, 0.0))
        @test y[:, 1] ≈ [lu - mu, lc - mc]
    end
end

@testitem "Split flows: three sources and a destination" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    step(x, flows...) = first(CR._flow_group(flows, x, 1, 1))
    # Source 1 keeps a tenth of what it held, so it cannot cover its share;
    # the rest passes to sources 2 and 3 in proportion to their pools.
    out = CR.Flow(1 => 0, 0.9; form = CR.Share())
    split(b, to = 0) = CR.Flow((1, 2, 3) => to, b; form = CR.Split())
    @test collect(step((4.0, 2.0, 2.0), out, split(4.0))) ≈ [0.0, 0.2, 0.2]
    @test collect(step((4.0, 1.0, 3.0), out, split(4.0))) ≈ [0.0, 0.1, 0.3]
    # Sources 2 and 3 start empty, so the first other source takes it all.
    into2 = CR.Flow(0 => 2, 5.0; form = CR.Truncate())
    @test collect(step((4.0, 0.0, 0.0), out, into2, split(4.0))) ≈ [0.0, 1.4, 0.0]
    # Into a fourth pool, which gains what the sources lose; a negative count
    # adds to the sources in proportion and moves nothing.
    y, a = CR._flow_group((split(3.0, 4),), (2.0, 4.0, 6.0, 1.0), 1, 1)
    @test collect(y) ≈ [1.5, 3.0, 4.5, 4.0]
    @test collect(a) ≈ [0.0, 0.0, 0.0, 3.0]
    y, a = CR._flow_group((split(-3.0, 4),), (2.0, 4.0, 6.0, 1.0), 1, 1)
    @test collect(y) ≈ [2.5, 5.0, 7.5, 1.0]
    @test collect(a) ≈ [0.0, 0.0, 0.0, 0.0]
end

@testitem "Split flows: the step's pullback against forward mode" setup = [ReferenceAD] begin
    using ComposableRecurrences, ForwardDiff, LinearAlgebra
    CR = ComposableRecurrences
    # Two and three sources after a share, a hazard and a count have moved
    # the pools, into a destination pool or out of the system.
    two(θ) = (
        CR.Flow(1 => 2, θ[1]; form = CR.Share()),
        CR.Flow(1 => 0, θ[2]),
        CR.Flow(0 => 1, θ[3]; form = CR.Truncate()),
        CR.Flow((1, 2) => 3, θ[4]; form = CR.Split()),
    )
    three(θ) = (
        CR.Flow(1 => 0, θ[1]; form = CR.Share()),
        CR.Flow(0 => 2, θ[2]; form = CR.Truncate()),
        CR.Flow(3 => 0, θ[3]),
        CR.Flow((1, 2, 3) => 0, θ[4]; form = CR.Split()),
    )
    ȳ, ā = (0.7, -0.4, 1.1), (0.3, 0.5, -0.8)
    # Covered, a source short of its share, every source short, empty
    # starting pools, and a negative count.
    cases = (
        ((6.0, 2.0, 1.0), [0.3, 0.1, 1.0, 2.0], [0.9, 0.5, 0.2, 2.0]),
        ((1.0, 8.0, 1.0), [0.3, 0.1, 0.0, 6.0], [0.9, 0.0, 0.2, 6.0]),
        ((2.0, 1.0, 1.0), [0.3, 0.1, 0.5, 9.0], [0.5, 0.5, 0.2, 9.0]),
        ((0.0, 0.0, 1.0), [0.3, 0.1, 2.0, 1.5], [0.9, 2.0, 0.2, 1.5]),
        ((6.0, 2.0, 1.0), [0.3, 0.1, 1.0, -2.0], [0.9, 0.5, 0.2, -2.0]),
    )
    for (x, θ2, θ3) in cases, (build, θ) in ((two, θ2), (three, θ3))
        f(z) = begin
            y, a = CR._flow_group(build(z[4:end]), (z[1], z[2], z[3]), 1, 1)
            dot(collect(ȳ), collect(y)) + dot(collect(ā), collect(a))
        end
        ref = ReferenceAD.gradient(f, [x..., θ...])
        fs = build(θ)
        f̄s = map(_ -> (; demand = Ref(0.0), form = (; κ = Ref(0.0))), fs)
        x̄ = CR._flows_pullback(fs, f̄s, x, ȳ, ā, 1, 1)
        d̄ = map(f̄ -> f̄.demand[], f̄s)
        @test [x̄..., d̄...] ≈ ref atol = 1.0e-12
    end
    # A trace's amounts: what the sources lose together.
    fs = two([0.3, 0.1, 0.0, 6.0])
    r̄ = (0.2, -0.5, 0.4, 0.9)
    g(z) = sum(map(*, r̄, CR._amounts(two(z[4:end]), (z[1], z[2], z[3]), 1, 1)))
    ref = ReferenceAD.gradient(g, [1.0, 8.0, 1.0, 0.3, 0.1, 0.0, 6.0])
    f̄s = map(_ -> (; demand = Ref(0.0), form = (; κ = Ref(0.0))), fs)
    x̄ = CR._amounts_pullback(fs, f̄s, r̄, (1.0, 8.0, 1.0), 1, 1)
    @test [x̄..., map(f̄ -> f̄.demand[], f̄s)...] ≈ ref atol = 1.0e-12
end

@testitem "Split flows: a run's pullback, inference and allocations" setup = [AdjointCheck] begin
    using ComposableRecurrences, Test
    # Discharges that some steps' pools cannot cover, over `n` steps.
    b = [0.5, 1.0, 4.0, 0.2, 2.5, 6.0, 0.1, 1.0]
    function build(n)
        d = CR.Depletion(
            CR.Flow(:u => :c, 0.3; form = CR.Share()),
            CR.Flow(0 => :u, TimeVarying(fill(1.0, n)); form = CR.Truncate()),
            CR.Flow((:u, :c) => 0, TimeVarying(repeat(b, n ÷ 8)); form = CR.Split());
            pools = (:u, :c)
        )
        return Recurrence([0.6, 0.3]; modifiers = (d,))
    end
    r = build(8)
    R = [1.0 + 0.1 * sin(k + t) for k in 1:2, t in 1:8]
    h = [2.0 1.0; 3.0 1.5]
    y = @inferred r(R; history = h)
    @test all(>=(0), y)
    @test pullback_matches(r, recargs(R, nothing, h)...)
    # A call over four times the steps allocates as often.
    rl, long = build(32), repeat(R, 1, 4)
    rl(long; history = h)
    @test (@allocations r(R; history = h)) == (@allocations rl(long; history = h))
end

@testitem "Split flows: check their options" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    f = CR.Flow((:u, :c) => 0, 1.0; form = CR.Split())
    @test_throws "has form Split()" CR.Flow((:u, :c) => 0, 1.0; form = CR.Truncate())
    @test_throws "a tuple of pools" CR.Flow(:u => 0, 1.0; form = CR.Split())
    @test_throws "two or more" CR.Flow((:u,) => 0, 1.0; form = CR.Split())
    @test_throws "not 0" CR.Flow((0, 1) => 2, 1.0; form = CR.Split())
    @test_throws "different pools" CR.Flow((1, 1) => 0, 1.0; form = CR.Split())
    @test_throws "does not draw from" CR.Flow((1, 2) => 2, 1.0; form = CR.Split())
    @test_throws "enters one pool" CR.Flow((1, 2) => (3, 4), 1.0; form = CR.Split())
    # A name and a position for one pool are found once the pools are known.
    @test_throws "names one pool twice" CR.Depletion(
        CR.Flow((:u, 1) => 0, 1.0; form = CR.Split()); pools = (:u, :c)
    )
    @test_throws "names one pool twice" CR.Depletion(
        CR.Flow((:u, :c) => 1, 1.0; form = CR.Split()); pools = (:u, :c, :d)
    )
    @test_throws "names pool :x" CR.Depletion(
        CR.Flow((:u, :x) => 0, 1.0; form = CR.Split()); pools = (:u, :c)
    )
    @test_throws "names pool 3" CR.Depletion(
        CR.Flow((1, 3) => 0, 1.0; form = CR.Split()); pools = (:u, :c)
    )
    d = CR.Depletion(f; pools = (:u, :c, :d))
    @test occursin("(u, c) => 0", sprint(show, MIME"text/plain"(), d))
end

@testitem "Split flows: the step's pullback infers and allocates nothing" begin
    using ComposableRecurrences, Test
    CR = ComposableRecurrences
    # Two, three and four sources, after a share and a count.
    function flows(I)
        return (
            CR.Flow(1 => 2, 0.3; form = CR.Share()),
            CR.Flow(0 => 1, 1.0; form = CR.Truncate()),
            CR.Flow(I => 0, 6.0; form = CR.Split()),
        )
    end
    # The module by name: a function reading the global `CR` does not infer.
    function back(fs, f̄s, x, ȳ, ā)
        return ComposableRecurrences._flows_pullback(fs, f̄s, x, ȳ, ā, 1, 1)
    end
    x, ȳ, ā = (1.0, 8.0, 1.0, 2.0), (0.7, -0.4, 1.1, 0.2), (0.3, 0.5, -0.8, 0.1)
    for I in ((1, 2), (1, 2, 3), (1, 2, 3, 4))
        fs = flows(I)
        f̄s = map(_ -> (; demand = Ref(0.0), form = (; κ = Ref(0.0))), fs)
        @test (@inferred back(fs, f̄s, x, ȳ, ā)) isa NTuple{4, Float64}
        @test (@allocations back(fs, f̄s, x, ȳ, ā)) == 0
    end
end
