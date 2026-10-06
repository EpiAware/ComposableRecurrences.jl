# Allocate: values and ForwardDiff gradients against a naive loop for every
# kind of total, and its pullback against a local ForwardDiff Jacobian of the
# Step.

@testmodule AllocateChecks begin
    using ComposableRecurrences
    const CR = ComposableRecurrences

    # A renewal whose strata are rescaled per group each step, written out.
    function naive(g, R, h, groups, total)
        S, T = size(R)
        L = length(g)
        Tp = promote_type(eltype(g), eltype(R), eltype(h), eltype(total(1, 1)))
        Y = zeros(Tp, S, L + T)
        Y[:, 1:L] .= h
        for t in 1:T
            v = [R[k, t] * sum(g[i] * Y[k, L + t - i] for i in 1:L) for k in 1:S]
            for (p, zs) in enumerate(groups)
                sp = max(sum(v[zs]), eps(Tp))
                v[zs] .= total(p, t) .* v[zs] ./ sp
            end
            Y[:, L + t] .= v
        end
        return Y[:, (L + 1):end]
    end

    const g = [0.5, 0.3, 0.2]
    const R = [1.0 + 0.1 * sin(k + t) for k in 1:5, t in 1:8]
    const h = [1.0 2.0 1.0; 0.5 0.5 1.0; 1.0 1.0 1.0; 2.0 1.0 3.0; 0.3 0.2 0.1]
    const groups = [1:2, [3, 5], 4:4]
    const TT = [
        4.0 5.0 6.0 7.0 8.0 9.0 10.0 11.0
        2.0 2.0 3.0 3.0 4.0 4.0 5.0 5.0
        1.0 1.5 2.0 2.5 3.0 3.5 4.0 4.5
    ]

    # Each kind of total, built from a flat parameter vector, with its value
    # at group `p` and time `t`.
    const totals = (
        scalar = (θ -> θ[1], (θ, p, t) -> θ[1], [6.0]),
        per_group = (θ -> PerStratum(θ), (θ, p, t) -> θ[p], [4.0, 2.0, 1.0]),
        over_time = (θ -> TimeVarying(θ), (θ, p, t) -> θ[t], TT[1, :]),
        groups_time = (
            θ -> TimeVarying(PerStratum(reshape(θ, 3, 8))),
            (θ, p, t) -> reshape(θ, 3, 8)[p, t], vec(TT),
        ),
    )
end

@testitem "Allocate: values and gradients against a naive loop" setup = [AllocateChecks] begin
    using ComposableRecurrences, ForwardDiff
    CR = ComposableRecurrences
    (; g, R, h, groups, totals, naive) = AllocateChecks
    W = reshape(range(0.2, 1.4; length = 40), 5, 8)
    for (build, at, θ) in values(totals)
        run(θ, R) = Recurrence(g; modifiers = (CR.Allocate(groups, build(θ)),))(
            R; history = h
        )
        ref(θ, R) = naive(g, R, h, groups, (p, t) -> at(θ, p, t))
        @test run(θ, R) ≈ ref(θ, R)
        @test ForwardDiff.gradient(θ -> sum(W .* run(θ, R)), θ) ≈
            ForwardDiff.gradient(θ -> sum(W .* ref(θ, R)), θ)
        @test ForwardDiff.gradient(R -> sum(W .* run(θ, R)), R) ≈
            ForwardDiff.gradient(R -> sum(W .* ref(θ, R)), R)
        # The group sums equal the totals.
        Y = run(θ, R)
        @test [sum(Y[zs, t]) for (p, zs) in enumerate(groups), t in 1:8] ≈
            [at(θ, p, t) for p in 1:3, t in 1:8]
    end
end

@testitem "Allocate: a group whose sum is below the floor" setup = [AllocateChecks] begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    m = CR.Allocate([1:2, 3:3], PerStratum([4.0, 2.0]))
    v = [1.0, 3.0, 0.0]
    CR.forward(m, CR.Step(), v, zeros(3), 1)
    @test v ≈ [1.0, 3.0, 0.0]
    v = [1.0e-20, 3.0e-20, 1.0]
    CR.forward(m, CR.Step(), v, zeros(3), 1)
    @test v ≈ [4.0e-20, 12.0e-20, 2.0] ./ [eps(), eps(), 1.0]
end

@testitem "Allocate: pullback against a local Jacobian" setup = [ModifierChecks, AllocateChecks] begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    (; groups, totals) = AllocateChecks
    v = [0.8, 1.3, 0.4, 2.0, 0.9]
    for (build, at, θ) in values(totals), t in (1, 5)
        c = ModifierChecks.check_pullback(
            x -> CR.Allocate(groups, build(x)), θ, v, zeros(5), t
        )
        @test c.v
        @test c.s
        @test c.θ
    end
    # On the floor the sum term drops.
    tiny = [1.0e-18, 2.0e-18, 0.4, 2.0, 0.9]
    c = ModifierChecks.check_pullback(
        x -> CR.Allocate(groups, PerStratum(x)), [4.0, 2.0, 1.0], tiny,
        zeros(5), 1
    )
    @test c.v && c.s && c.θ
end

@testitem "Allocate: checks its groups and totals" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    @test_throws ArgumentError CR.Allocate([1:2, 2:3], 1.0)
    @test_throws "stratum 2 is in two groups" CR.Allocate([1:2, 2:3], 1.0)
    @test_throws ArgumentError CR.Allocate([1:2, Int[]], 1.0)
    @test_throws "got 0-element Vector{Int64}" CR.Allocate([1:2, Int[]], 1.0)
    @test_throws "got 2-element Vector{Float64}" CR.Allocate([[1.0, 2.0]], 1.0)
    @test_throws ArgumentError CR.Allocate([0:1], 1.0)
    @test_throws "got 0 in group 0:1" CR.Allocate([0:1], 1.0)
    @test_throws ArgumentError CR.Allocate(UnitRange{Int}[], 1.0)
    @test_throws "at least one group, got 0-element" CR.Allocate(
        UnitRange{Int}[], 1.0
    )
    @test_throws ArgumentError CR.Allocate([1:2], [1.0, 2.0])
    @test_throws DimensionMismatch CR.Allocate([1:2, 3:3], PerStratum([1.0]))
    @test_throws ArgumentError CR.Allocate(
        [1:2], TimeVarying([1.0, 2.0], CR.Primary())
    )
    r = Recurrence([0.5]; modifiers = (CR.Allocate([1:2, 4:4], 1.0),))
    @test_throws ArgumentError r(ones(3, 2); history = ones(3, 1))
    @test_throws "cover 3 strata with indices up to 4" r(
        ones(3, 2); history = ones(3, 1)
    )
    r = Recurrence([0.5]; modifiers = (CR.Allocate([1:2], TimeVarying([1.0, 2.0])),))
    @test_throws DimensionMismatch r(ones(2, 3); history = ones(2, 1))
end

@testitem "Allocate: Float32 stays Float32" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    r = Recurrence(Float32[0.5, 0.5]; modifiers = (CR.Allocate([1:2], 3.0f0),))
    y = r(ones(Float32, 2, 4); history = ones(Float32, 2, 2))
    @test eltype(y) == Float32
    @test vec(sum(y; dims = 1)) ≈ fill(3.0f0, 4)
end
