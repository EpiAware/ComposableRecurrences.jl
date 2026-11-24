# Allocate: values and ForwardDiff gradients against a naive loop for every
# kind of total and import fraction, and its pullback against a local
# ForwardDiff Jacobian of the Step.

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

    # The same renewal with imports: each group's total is shared by the
    # spilled values `u` and, for a fraction of it, by the pattern `P v`.
    function naive_imports(g, R, h, groups, total, fraction, pattern, K, ε)
        S, T = size(R)
        L = length(g)
        Tp = promote_type(
            eltype(g), eltype(R), eltype(h), typeof(total(1, 1)),
            typeof(fraction(1, 1)), eltype(pattern(1)), eltype(K),
            typeof(ε(1, 1))
        )
        Y = zeros(Tp, S, L + T)
        Y[:, 1:L] .= h
        floor_ = eps(Tp)
        for t in 1:T
            v = [R[k, t] * sum(g[i] * Y[k, L + t - i] for i in 1:L) for k in 1:S]
            out = [sum(K[r, q] for r in 1:S if r != q; init = zero(Tp)) for q in 1:S]
            u = [
                (1 - ε(k, t) * out[k]) * v[k] +
                    sum(ε(j, t) * K[k, j] * v[j] for j in 1:S if j != k; init = zero(Tp))
                    for k in 1:S
            ]
            hh = pattern(t) * v
            for (p, zs) in enumerate(groups)
                su = max(sum(u[zs]), floor_)
                sh = sum(hh[zs])
                mh = max(sh, floor_)
                Tt, φ = total(p, t), fraction(p, t)
                v[zs] .= Tt .* ((1 - φ * sh / mh) .* u[zs] ./ su .+ φ .* hh[zs] ./ mh)
            end
            Y[:, L + t] .= v
        end
        return Y[:, (L + 1):end]
    end

    # An import pattern, zero within each group, and a within-group spill.
    const P0 = [
        0.0 0.0 0.3 0.2 0.1
        0.0 0.0 0.1 0.4 0.2
        0.5 0.2 0.0 0.3 0.0
        0.1 0.1 0.2 0.0 0.3
        0.4 0.3 0.0 0.1 0.0
    ]
    const K0 = [
        0.0 1.0 0.0 0.0 0.0
        1.0 0.0 0.0 0.0 0.0
        0.0 0.0 0.0 0.0 1.0
        0.0 0.0 0.0 0.0 0.0
        0.0 0.0 1.0 0.0 0.0
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
    const FF = [0.1 + 0.02 * p + 0.01 * t for p in 1:3, t in 1:8]
    # Each kind of import fraction, as the totals.
    const fractions = (
        scalar = (θ -> θ[1], (θ, p, t) -> θ[1], [0.2]),
        per_group = (θ -> PerStratum(θ), (θ, p, t) -> θ[p], [0.1, 0.3, 0.2]),
        over_time = (θ -> TimeVarying(θ), (θ, p, t) -> θ[t], FF[1, :]),
        groups_time = (
            θ -> TimeVarying(PerStratum(reshape(θ, 3, 8))),
            (θ, p, t) -> reshape(θ, 3, 8)[p, t], vec(FF),
        ),
    )
end

@testitem "Allocate: values and gradients against a naive loop" setup = [ReferenceAD, AllocateChecks] begin
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
        @test ReferenceAD.gradient(θ -> sum(W .* run(θ, R)), θ) ≈
            ReferenceAD.gradient(θ -> sum(W .* ref(θ, R)), θ)
        @test ReferenceAD.gradient(R -> sum(W .* run(θ, R)), R) ≈
            ReferenceAD.gradient(R -> sum(W .* ref(θ, R)), R)
        # The group sums equal the totals.
        Y = run(θ, R)
        @test [sum(Y[zs, t]) for (p, zs) in enumerate(groups), t in 1:8] ≈
            [at(θ, p, t) for p in 1:3, t in 1:8]
    end
end

@testitem "Allocate: imports against a naive loop" setup = [ReferenceAD, AllocateChecks] begin
    using ComposableRecurrences, ForwardDiff
    CR = ComposableRecurrences
    (; g, R, h, groups, TT, P0, K0, fractions, naive_imports) = AllocateChecks
    W = reshape(range(0.2, 1.4; length = 40), 5, 8)
    total = TimeVarying(PerStratum(TT))
    at_total(p, t) = TT[p, t]
    PT = cat((P0 .* (1 + 0.1 * t) for t in 1:8)...; dims = 3)
    εs = [0.1, 0.2, 0.15, 0.05, 0.3]
    # A fixed and a time-varying pattern, each with and without a spill.
    patterns = (
        (P0, t -> P0), (TimeVarying(PT), t -> PT[:, :, t]),
    )
    for (build, at, θ) in values(fractions), (P, Pt) in patterns,
            spilled in (false, true)
        function run(θ, R, ε)
            spill = spilled ? CR.Redistribute(K0, ε) : nothing
            m = CR.Allocate(groups, total; imports = (build(θ), P), spill)
            return Recurrence(g; modifiers = (m,))(R; history = h)
        end
        function ref(θ, R, ε)
            return naive_imports(
                g, R, h, groups, at_total, (p, t) -> at(θ, p, t), Pt,
                spilled ? K0 : zero(K0), (k, t) -> ε[k]
            )
        end
        @test run(θ, R, εs) ≈ ref(θ, R, εs)
        @test ReferenceAD.gradient(θ -> sum(W .* run(θ, R, εs)), θ) ≈
            ReferenceAD.gradient(θ -> sum(W .* ref(θ, R, εs)), θ)
        @test ReferenceAD.gradient(R -> sum(W .* run(θ, R, εs)), R) ≈
            ReferenceAD.gradient(R -> sum(W .* ref(θ, R, εs)), R)
        @test ReferenceAD.gradient(ε -> sum(W .* run(θ, R, ε)), εs) ≈
            ReferenceAD.gradient(ε -> sum(W .* ref(θ, R, ε)), εs)
        # The group sums still equal the totals.
        Y = run(θ, R, εs)
        @test [sum(Y[zs, t]) for (p, zs) in enumerate(groups), t in 1:8] ≈ TT
    end
    # Without a spill and with a zero fraction the split is the plain one.
    plain = Recurrence(g; modifiers = (CR.Allocate(groups, total),))
    zero_imports = Recurrence(
        g; modifiers = (CR.Allocate(groups, total; imports = (0.0, P0)),)
    )
    @test zero_imports(R; history = h) ≈ plain(R; history = h)
end

@testitem "Allocate: imports keep the plain split's type and state" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    P = [0.0 0.5 0.0; 0.5 0.0 0.0; 0.0 0.0 0.0]
    K = [0.0 1.0 0.0; 1.0 0.0 0.0; 0.0 0.0 0.0]
    plain = CR.Allocate([1:2, 3:3], 1.0)
    @test plain isa CR.Allocate{Float64, Nothing}
    @test CR.isstateless(plain)
    @test CR.nstate(plain, 3) == 3
    imported = CR.Allocate([1:2, 3:3], 1.0; imports = (0.1, P))
    @test !CR.isstateless(imported)
    @test CR.nstate(imported, 3) == 3
    spilled = CR.Allocate(
        [1:2, 3:3], 1.0; imports = (0.1, P), spill = CR.Redistribute(K, 0.2)
    )
    @test CR.nstate(spilled, 3) == 6
    @test CR.param_eltype(
        CR.Allocate([1:2, 3:3], 1.0; imports = (0.1f0, Float32.(P)))
    ) == Float64
    # The state holds the spilled values, then the pattern.
    v = [1.0, 3.0, 2.0]
    s = zeros(6)
    CR.forward!(spilled, CR.Step(), v, s, 1)
    @test s ≈ [1.4, 2.6, 2.0, 1.5, 0.5, 0.0]
    # The step and its pullback infer.
    m̄ = (;
        total = Ref(0.0),
        imports = (; fraction = Ref(0.0), pattern = zero(P), spill = (; K = zero(K), ε = Ref(0.0))),
    )
    @inferred CR.forward!(spilled, CR.Step(), copy(v), zeros(6), 1)
    grads = (; piece = m̄, v = ones(3), s = ones(6))
    @inferred CR.pullback!(grads, spilled, CR.Step(), v, zeros(6), 1)
    r = Recurrence([0.5, 0.5]; modifiers = (spilled,))
    @inferred r(ones(3, 4); history = ones(3, 2))
end

@testitem "Allocate: a group whose sum is below the floor" setup = [AllocateChecks] begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    m = CR.Allocate([1:2, 3:3], PerStratum([4.0, 2.0]))
    v = [1.0, 3.0, 0.0]
    CR.forward!(m, CR.Step(), v, zeros(3), 1)
    @test v ≈ [1.0, 3.0, 0.0]
    v = [1.0e-20, 3.0e-20, 1.0]
    CR.forward!(m, CR.Step(), v, zeros(3), 1)
    @test v ≈ [4.0e-20, 12.0e-20, 2.0] ./ [eps(), eps(), 1.0]
end

@testitem "Allocate: imports keep the totals near an empty pattern" setup = [ReferenceAD] begin
    using ComposableRecurrences, ForwardDiff
    CR = ComposableRecurrences
    K = [0.0 1.0 0.0; 1.0 0.0 0.0; 0.0 0.0 0.0]
    # The first group imports `c v_3` into each of its strata, so its pattern
    # sums to `2 c v_3`; the second group's pattern is empty.
    function step(x)
        tot, φ, v, c = x[1:2], x[3:4], x[5:7], x[8]
        P = zeros(eltype(x), 3, 3)
        P[1:2, 3] .= c
        m = CR.Allocate(
            [1:2, 3:3], PerStratum(tot); imports = (PerStratum(φ), P),
            spill = CR.Redistribute(K, 0.2)
        )
        y = copy(v)
        CR.forward!(m, CR.Step(), y, zeros(eltype(x), 6), 1)
        return y
    end
    tot, φ, v = [4.0, 2.0], [0.3, 0.5], [1.0, 3.0, 2.0]
    for sh in (0.0, eps() / 2, 2 * eps())
        y = step(vcat(tot, φ, v, sh / (2 * v[3])))
        @test sum(y[1:2]) ≈ tot[1]
        @test y[3] ≈ tot[2]
    end
    W = [1.0, -2.0, 0.5]
    g = ReferenceAD.gradient(x -> sum(W .* step(x)), vcat(tot, φ, v, 0.0))
    @test all(isfinite, g)
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

@testitem "Allocate: imports pullback against a local Jacobian" setup = [
    ModifierChecks, AllocateChecks,
] begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    (; groups, totals, fractions, P0, K0) = AllocateChecks
    # Consecutive blocks of `x` with the given shapes.
    function take(x, shapes...)
        o = 0
        return map(shapes) do sh
            n = prod(sh)
            o += n
            return reshape(x[(o - n + 1):o], sh...)
        end
    end
    v = [0.8, 1.3, 0.4, 2.0, 0.9]
    εs = [0.1, 0.2, 0.15, 0.05, 0.3]
    PT = cat((P0 .* (1 + 0.1 * t) for t in 1:8)...; dims = 3)
    θ0 = [4.0, 2.0, 1.0, 0.1, 0.3, 0.2]
    M0 = CR.Redistribute(K0, εs).M
    # θ is the total, the fraction, the pattern, then the spill's movement
    # matrix, the order of the mirror's fields.
    for spilled in (false, true), P in (P0, PT), t in (1, 5)
        function build(x)
            shapes = ((3,), (3,), size(P), (spilled ? ((5, 5),) : ())...)
            tot, fr, Px, spill... = take(x, shapes...)
            Px = ndims(Px) == 3 ? TimeVarying(Px) : Px
            return CR.Allocate(
                groups, PerStratum(tot); imports = (PerStratum(fr), Px),
                spill = spilled ? CR.Redistribute(only(spill)) : nothing
            )
        end
        θ = vcat(θ0, vec(P), spilled ? vec(M0) : Float64[])
        s = zeros(spilled ? 10 : 5)
        c = ModifierChecks.check_pullback(build, θ, v, s, t)
        @test c.v
        @test c.s
        @test c.θ
    end
    # Every kind of total and fraction, with a spill and a pattern held
    # fixed.
    function fixed_mirror(m)
        m̄ = ModifierChecks.mirror(m)
        return merge(
            m̄, (; imports = merge(m̄.imports, (; pattern = nothing, spill = nothing)))
        )
    end
    for (bt, _, θt) in values(totals), (bf, _, θf) in values(fractions),
            t in (1, 5)
        function build(x)
            tot, fr = take(x, size(θt), size(θf))
            return CR.Allocate(
                groups, bt(tot); imports = (bf(fr), P0),
                spill = CR.Redistribute(M0)
            )
        end
        c = ModifierChecks.check_pullback(
            build, vcat(θt, θf), v, zeros(10), t; mirror_of = fixed_mirror
        )
        @test c.v
        @test c.s
        @test c.θ
    end
    # A group with no imports from the pattern, and one whose values are
    # below the floor.
    P = copy(P0)
    P[[3, 5], :] .= 0.0
    tiny = [1.0e-18, 2.0e-18, 0.4, 2.0, 0.9]
    for v in (v, tiny)
        function build(x)
            tot, fr, Px = take(x, (3,), (3,), (5, 5))
            return CR.Allocate(
                groups, PerStratum(tot); imports = (PerStratum(fr), Px)
            )
        end
        c = ModifierChecks.check_pullback(build, vcat(θ0, vec(P)), v, zeros(5), 1)
        @test c.v
        @test c.s
        @test c.θ
    end
end

@testitem "Allocate: sparse imports match dense ones" setup = [AllocateChecks] begin
    using ComposableRecurrences, SparseArrays
    CR = ComposableRecurrences
    (; g, R, h, groups, TT, P0, K0) = AllocateChecks
    M0 = CR.Redistribute(K0, [0.1, 0.2, 0.15, 0.05, 0.3]).M
    split(P, M) = CR.Allocate(
        groups, TimeVarying(PerStratum(TT));
        imports = (0.2, P), spill = CR.Redistribute(M)
    )
    dense, sparse_ = split(P0, M0), split(sparse(P0), sparse(M0))
    run(m) = Recurrence(g; modifiers = (m,))(R; history = h)
    @test run(sparse_) ≈ run(dense)
    # The generic step and pullback against the dense ones.
    v = [0.8, 1.3, 0.4, 2.0, 0.9]
    s̄ = collect(range(-0.4, 0.9; length = 10))
    out = map((dense, sparse_)) do m
        vv, ss = copy(v), zeros(10)
        CR.forward!(m, CR.Step(), vv, ss, 3)
        grads = (; piece = nothing, v = collect(range(0.3, 1.7; length = 5)), s = copy(s̄))
        CR.pullback!(grads, m, CR.Step(), v, zeros(10), 3)
        return vv, ss, grads.v, grads.s
    end
    @test all(map(≈, out[1], out[2]))
end

@testitem "Allocate: checks its imports" begin
    using ComposableRecurrences
    using ComposableRecurrences: Recent
    CR = ComposableRecurrences
    P = [0.0 0.5 0.0; 0.5 0.0 0.0; 0.0 0.0 0.0]
    K = [0.0 1.0 0.0; 1.0 0.0 0.0; 0.0 0.0 0.0]
    gs = [1:2, 3:3]
    @test_throws "spill needs imports" CR.Allocate(
        gs, 1.0; spill = CR.Redistribute(K, 0.1)
    )
    @test_throws "imports is (fraction, pattern)" CR.Allocate(
        gs, 1.0; imports = P
    )
    @test_throws "spill is a Redistribute" CR.Allocate(
        gs, 1.0; imports = (0.1, P), spill = K
    )
    @test_throws DimensionMismatch CR.Allocate(
        gs, 1.0; imports = (PerStratum([0.1]), P)
    )
    @test_throws "per group" CR.Allocate(gs, 1.0; imports = (Recent(2), P))
    @test_throws "pattern is an S × S matrix" CR.Allocate(
        gs, 1.0; imports = (0.1, [0.1, 0.2])
    )
    @test_throws "expected a square matrix" CR.Allocate(
        gs, 1.0; imports = (0.1, ones(3, 2))
    )
    @test_throws ArgumentError CR.Allocate(
        gs, 1.0; imports = (0.1, TimeVarying(ones(3)))
    )
    # The pattern and the spill's movement, fixed or over time, against the strata.
    for split in (
            CR.Allocate(gs, 1.0; imports = (0.1, ones(2, 2))),
            CR.Allocate(
                gs, 1.0; imports = (0.1, P), spill = CR.Redistribute(fill(0.5, 2, 2))
            ),
            CR.Allocate(
                gs, 1.0; imports = (0.1, P),
                spill = CR.Redistribute(TimeVarying(fill(0.5, 2, 2, 4)))
            ),
        )
        r = Recurrence([0.5]; modifiers = (split,))
        @test_throws DimensionMismatch r(ones(3, 2); history = ones(3, 1))
    end
end

@testitem "Allocate: checks its groups and totals" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    @test_throws ArgumentError CR.Allocate([1:2, 2:3], 1.0)
    @test_throws "stratum 2 is in two groups" CR.Allocate([1:2, 2:3], 1.0)
    @test_throws "stratum 2 is in two groups" CR.Allocate([1:2, 3:2, 2:3], 1.0)
    @test_throws "got 2-element Vector{Float64}" CR.Allocate([[1.0, 2.0]], 1.0)
    @test_throws "got 0-element Vector{Any}" CR.Allocate([1:2, []], 1.0)
    @test_throws "got 0 in group 0:1" CR.Allocate([3:2, 0:1], 1.0)
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
    # Empty groups still have to leave the others to partition the strata.
    for (gs, msg) in (
            ([1:2, 3:2], "cover 2 strata with indices up to 2"),
            ([3:2], "cover 0 strata with indices up to 0"),
            ([1:2, 3:2, 4:4], "cover 3 strata with indices up to 4"),
        )
        uncovered = Recurrence([0.5]; modifiers = (CR.Allocate(gs, 1.0),))
        @test_throws msg uncovered(ones(3, 2); history = ones(3, 1))
    end
    @test_throws DimensionMismatch CR.Allocate(
        [1:2, 3:2, 3:3], PerStratum([1.0, 2.0])
    )
end

@testitem "Allocate: an empty group's total is unused" tags = [:threads] setup = [
    ReferenceAD, ModifierChecks, AllocateChecks,
] begin
    using ComposableRecurrences, ForwardDiff
    using Base.ScopedValues: with
    CR = ComposableRecurrences
    (; g, R, h, groups, TT, FF, P0, K0) = AllocateChecks
    W = reshape(range(0.2, 1.4; length = 40), 5, 8)
    # The groups with empty groups first, between them and last; the empty
    # groups take rows of the totals and fractions of their own.
    padded = [3:2, groups[1], Int[], groups[2], 6:5, groups[3], 1:0]
    kept, empty = [2, 4, 6], [1, 3, 5, 7]
    function pad(X)
        Y = [100.0 + p + t for p in 1:7, t in axes(X, 2)]
        Y[kept, :] .= X
        return Y
    end
    M0 = CR.Redistribute(K0, [0.1, 0.2, 0.15, 0.05, 0.3]).M
    # Without imports, with them, and with a spill too.
    function split(gs, tot, fr, case)
        total = TimeVarying(PerStratum(tot))
        case === :plain && return CR.Allocate(gs, total)
        spill = case === :spill ? CR.Redistribute(M0) : nothing
        fraction = TimeVarying(PerStratum(fr))
        return CR.Allocate(gs, total; imports = (fraction, P0), spill)
    end
    recurrence(gs, tot, fr, case) = Recurrence(
        g; modifiers = (split(gs, tot, fr, case),)
    )
    # The pattern and the spill are held fixed in the local pullback.
    function fixed_mirror(m)
        m̄ = ModifierChecks.mirror(m)
        m.imports === nothing && return m̄
        fixed = (; pattern = nothing, spill = nothing)
        return merge(m̄, (; imports = merge(m̄.imports, fixed)))
    end
    v = [0.8, 1.3, 0.4, 2.0, 0.9]
    ex = CR.Threaded(; min_work = 0, ntasks = 3)
    for case in (:plain, :imports, :spill)
        r = recurrence(padded, pad(TT), pad(FF), case)
        r0 = recurrence(groups, TT, FF, case)
        # The empty groups leave the split as it is without them.
        y = r0(R; history = h)
        @test r(R; history = h) ≈ y
        # Their totals and fractions get zero gradients, and the others the
        # gradients they get without them.
        loss(gs, tot, fr, R) = sum(
            W .* recurrence(gs, tot, fr, case)(R; history = h)
        )
        grad(f, x) = ReferenceAD.gradient(f, x)
        gT = grad(x -> loss(padded, x, pad(FF), R), pad(TT))
        @test all(iszero, gT[empty, :])
        @test gT[kept, :] ≈ grad(x -> loss(groups, x, FF, R), TT)
        gF = grad(x -> loss(padded, pad(TT), x, R), pad(FF))
        @test all(iszero, gF[empty, :])
        if case === :plain
            @test all(iszero, gF)
        else
            @test gF[kept, :] ≈ grad(x -> loss(groups, TT, x, R), FF)
        end
        @test grad(x -> loss(padded, pad(TT), pad(FF), x), R) ≈
            grad(x -> loss(groups, TT, FF, x), R)
        # A threaded executor and a trace see the same split.
        threaded = with(() -> r(R; history = h), CR.EXECUTOR => ex)
        @test threaded == r(R; history = h)
        yt, tr = r(R; history = h, record = (:trace,))
        _, tr0 = r0(R; history = h, record = (:trace,))
        @test yt ≈ y
        # With imports the trace's rows are named.
        a, a0 = only(tr.modifiers), only(tr0.modifiers)
        @test a isa NamedTuple ? all(map(≈, a, a0)) : a ≈ a0
        # The pullback of a step against a local Jacobian; the empty groups'
        # totals and fractions get zero cotangents.
        θ = case === :plain ? vec(pad(TT)) : vcat(vec(pad(TT)), vec(pad(FF)))
        function build(x)
            fr = case === :plain ? pad(FF) : reshape(x[57:end], 7, 8)
            return split(padded, reshape(x[1:56], 7, 8), fr, case)
        end
        c = ModifierChecks.check_pullback(
            build, θ, v, zeros(case === :spill ? 10 : 5), 5;
            mirror_of = fixed_mirror
        )
        @test c.v
        @test c.s
        @test c.θ
        θ̄ = reshape(c.θ̄, 7, :)
        @test all(iszero, θ̄[empty, :])
    end
end

@testitem "Allocate: Float32 stays Float32" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    r = Recurrence(Float32[0.5, 0.5]; modifiers = (CR.Allocate([1:2], 3.0f0),))
    y = r(ones(Float32, 2, 4); history = ones(Float32, 2, 2))
    @test eltype(y) == Float32
    @test vec(sum(y; dims = 1)) ≈ fill(3.0f0, 4)
    P = Float32[0.0 0.5; 0.5 0.0]
    m = CR.Allocate(
        [1:1, 2:2], 3.0f0; imports = (0.2f0, P),
        spill = CR.Redistribute(P, 0.1f0)
    )
    y = Recurrence(Float32[0.5, 0.5]; modifiers = (m,))(
        ones(Float32, 2, 4); history = ones(Float32, 2, 2)
    )
    @test eltype(y) == Float32
end

@testitem "Allocate: a trace's rows are named, with the imports" begin
    using ComposableRecurrences, ForwardDiff, LinearAlgebra, Mooncake, Test
    CR = ComposableRecurrences
    S, T = 5, 12
    P = [
        0.6 0.2 0.1 0.05 0.05; 0.1 0.5 0.2 0.1 0.1; 0.1 0.1 0.6 0.1 0.1;
        0.05 0.05 0.1 0.7 0.1; 0.1 0.1 0.1 0.1 0.6
    ]
    M = Matrix(0.9I, S, S) .+ 0.02
    M ./= sum(M; dims = 1)
    groups = [1:2, 3:5]
    tot = [10.0 + t for p in 1:2, t in 1:(T + 2)]
    fr = [0.2 + 0.01p for p in 1:2, t in 1:(T + 2)]
    R, h = fill(1.2, S, T + 2), ones(S, 2)
    # All of `φ T` placed by the import term: by the pattern `H`, and below
    # the floor partly by the spilled values `U`.
    function naive(U, H, tot, fr)
        out = similar(H)
        for t in axes(H, 2), (p, zs) in enumerate(groups)
            a = tot[p, t + 2] * fr[p, t + 2]
            sh, su = sum(H[zs, t]), sum(U[zs, t])
            r = sh / max(sh, eps())
            out[zs, t] .= a .* (
                H[zs, t] ./ max(sh, eps()) .+
                    (1 - r) .* U[zs, t] ./ max(su, eps())
            )
            @assert sum(out[zs, t]) ≈ a
        end
        return out
    end
    split(f, spill; trace_imports = Val(true)) = CR.Allocate(
        groups, TimeVarying(PerStratum(tot));
        imports = (TimeVarying(PerStratum(f)), P), spill, trace_imports
    )
    for spill in (nothing, CR.Redistribute(M, 0.3))
        names = spill === nothing ? (:pattern, :imports) :
            (:spilled, :pattern, :imports)
        @test keys(CR.trace_rows(split(fr, spill), S)) == names
        r = Recurrence([0.5, 0.3]; modifiers = (; split = split(fr, spill)))
        call = (r, R, h, stop) -> r(
            R; history = h, start = 3, stop, record = (:split, :pressure)
        )
        out = @inferred call(r, R, h, T + 2)
        a = out.trace.modifiers.split
        @test keys(a) == names
        # The rows are the trace's, in order; without a spill the values
        # the split reads are the gain times the pressure.
        whole = CR.forward(
            r, CR.Run(), R;
            history = h, start = 3, stop = T + 2, record = (:trace,)
        )
        @test vcat(values(a)...) == only(last(first(whole)).modifiers)
        U = spill === nothing ? R[:, 3:end] .* out.trace.pressure : a.spilled
        @test a.imports ≈ naive(U, a.pattern, tot, fr)
        # A part not built is empty, as are its named rows.
        empty = r(
            R; history = h, start = 3, stop = T + 2, record = (:pressure,)
        )
        @test all(x -> size(x) == (0, 0), empty.trace.modifiers.split)
        @test typeof(empty.trace) == typeof(out.trace)
        # Gradients through every row, against ForwardDiff of plain AD.
        W = [sin(k + t) for k in 1:S, t in 1:T]
        function loss(op, x)
            f, g = reshape(x[1:(2T + 4)], 2, T + 2), reshape(x[(2T + 5):end], S, T + 2)
            q = Recurrence([0.5, 0.3]; modifiers = (; split = split(f, spill)))
            o = op(q)(g; history = h, start = 3, stop = T + 2, record = (:split,))
            return sum(sum(W .* x) for x in o.trace.modifiers.split) + sum(o.y)
        end
        x = vcat(vec(fr), vec(R))
        expected = ForwardDiff.gradient(z -> loss(CR.NoAdjoint, z), x)
        f = z -> loss(identity, z)
        n0 = CR._PULLBACK_CALLS[]
        rule = Mooncake.build_rrule(f, x)
        @test Mooncake.value_and_gradient!!(rule, f, x)[2][2] ≈ expected
        @test CR._PULLBACK_CALLS[] > n0
    end
    # Below the floor the pattern places `φ r T` with `r = Σ h / ε` and the
    # spilled values the rest of `φ T`; with no pattern at all they place
    # all of it.
    for Pd in ([1.0e-17 0.0; 0.0 2.0e-17], zeros(2, 2))
        m = CR.Allocate(
            [1:2], 100.0; imports = (0.3, Pd), trace_imports = Val(true)
        )
        q = Recurrence(Float64[]; modifiers = (; m))
        o = q(
            zeros(2, 1); history = zeros(2, 0),
            add = reshape([4.0, 6.0], 2, 1), record = (:m,)
        )
        (; pattern, imports) = o.trace.modifiers.m
        r = sum(pattern) / eps()
        @test r < 1
        @test sum(imports) ≈ 30
        @test imports ≈ 30 .* (pattern ./ eps() .+ (1 - r) .* [0.4, 0.6])
        @test sum(o.y) ≈ 100
    end
    # Without imports, or without `trace_imports`, the trace stays one
    # matrix, the state after each step.
    @test CR.trace_rows(CR.Allocate(groups, 5.0), S) === nothing
    for spill in (nothing, CR.Redistribute(M, 0.3))
        plain = split(fr, spill; trace_imports = Val(false))
        @test CR.trace_rows(plain, S) === nothing
        r = Recurrence([0.5, 0.3]; modifiers = (; split = plain))
        out = r(R; history = h, start = 3, record = (:split, :state))
        n = CR.nstate(plain, S)
        @test size(out.trace.modifiers.split) == (n, T)
        @test out.trace.modifiers.split[:, end] == vec(only(out.state.states))
        # A rebuild keeps the choice.
        im = split(fr, spill).imports
        back = CR.constructorof(typeof(im))(im.fraction, im.pattern, im.spill)
        @test typeof(back) == typeof(im)
    end
    # The choice is part of the type, so a model built per draw infers.
    function on(gs, P)
        return ComposableRecurrences.Allocate(
            gs, 5.0; imports = (0.2, P), trace_imports = Val(true)
        )
    end
    off(gs, P) = ComposableRecurrences.Allocate(gs, 5.0; imports = (0.2, P))
    @test CR.trace_rows(@inferred(on(groups, P)), S) !== nothing
    @test CR.trace_rows(@inferred(off(groups, P)), S) === nothing
    @test_throws "trace_imports is Val(true) or Val(false)" CR.Allocate(
        groups, 5.0; imports = (0.2, P), trace_imports = true
    )
    @test_throws "trace_imports needs imports" CR.Allocate(
        groups, 5.0; trace_imports = Val(true)
    )
end
