# The blockwise modifier role: the default vector step and pullback loop a
# group step, `nstate` follows the blocks, and a depletion with a protected
# pool is blockwise.

@testmodule BlockChecks begin
    using ComposableRecurrences
    const CR = ComposableRecurrences

    # Two compartments per group: a share `a` of the first moves to the
    # second, and the state keeps what moved.
    struct Move{A}
        a::A
    end
    CR.blocks(::Move) = (2, 1)
    function CR.forward!(m::Move, ::CR.Step, v::Tuple, s::Tuple, t, g)
        v1, v2 = v[1][], v[2][]
        x = CR.param(m.a, g, t) * v1
        v[1][], v[2][] = v1 - x, v2 + x
        s[1][] = x
        return nothing
    end
    function CR.pullback!(grads, m::Move, ::CR.Step, v, s, t, g)
        v̄1, v̄2, s̄ = grads.v[1][], grads.v[2][], grads.s[1][]
        a = CR.param(m.a, g, t)
        c = v̄2 + s̄ - v̄1
        CR.add_param!(CR.cotangent(grads.piece, :a), m.a, c * v[1][], g, t)
        grads.v[1][], grads.v[2][] = v̄1 + a * c, v̄2
        grads.s[1][] = zero(s̄)
        return nothing
    end

    # The same step without a pullback.
    struct MovePlain{A}
        a::A
    end
    CR.blocks(::MovePlain) = (2, 1)
    function CR.forward!(m::MovePlain, ::CR.Step, v::Tuple, s::Tuple, t, g)
        return CR.forward!(Move(m.a), CR.Step(), v, s, t, g)
    end

    # A renewal over `G` groups of two compartments with the move written
    # out.
    function naive(g, R, h, a)
        S, T = size(R)
        G = S ÷ 2
        L = length(g)
        Tp = promote_type(eltype(R), eltype(h), typeof(a(1, 1)))
        Y = zeros(Tp, S, L + T)
        Y[:, 1:L] .= h
        for t in 1:T
            v = [R[k, t] * sum(g[i] * Y[k, L + t - i] for i in 1:L) for k in 1:S]
            for j in 1:G
                x = a(j, t) * v[j]
                v[j] -= x
                v[G + j] += x
            end
            Y[:, L + t] .= v
        end
        return Y[:, (L + 1):end]
    end
end

@testitem "Blocks: a user modifier against a naive loop" setup = [ReferenceAD, BlockChecks] begin
    using ComposableRecurrences, ForwardDiff
    CR = ComposableRecurrences
    (; Move, MovePlain, naive) = BlockChecks
    g = [0.5, 0.3, 0.2]
    R = [1.0 + 0.1 * sin(k + t) for k in 1:6, t in 1:8]
    h = [1.0 + 0.2 * k * l for k in 1:6, l in 1:3]
    W = reshape(range(0.2, 1.4; length = 48), 6, 8)
    for M in (Move, MovePlain)
        run(θ, R) = Recurrence(g; modifiers = (M(PerStratum(θ)),))(R; history = h)
        ref(θ, R) = naive(g, R, h, (j, t) -> θ[j])
        θ = [0.1, 0.3, 0.5]
        @test run(θ, R) ≈ ref(θ, R)
        @test ReferenceAD.gradient(θ -> sum(W .* run(θ, R)), θ) ≈
            ReferenceAD.gradient(θ -> sum(W .* ref(θ, R)), θ)
        @test ReferenceAD.gradient(R -> sum(W .* run(θ, R)), R) ≈
            ReferenceAD.gradient(R -> sum(W .* ref(θ, R)), R)
        @test CR.nstate(M(0.1), 6) == 3
        @test !CR.ispointwise(M(0.1))
    end
    @test CR.uses_adjoint(Recurrence(g; modifiers = (Move(0.1),)), CR.Run())
    @test !CR.uses_adjoint(Recurrence(g; modifiers = (MovePlain(0.1),)), CR.Run())
    # The state keeps what moved at the last step.
    moved = Recurrence([1.0]; modifiers = (Move(0.25),))
    _, st = moved(; history = [4.0, 0.0][:, :], stop = 1, state = true)
    @test only(st.states) == [1.0]
    r = Recurrence(g; modifiers = (Move(0.1),))
    @test_throws "needs a multiple of 2 strata, got 3" r(ones(3, 4); history = ones(3, 3))
end

@testitem "Blocks: group pullbacks against a local Jacobian" setup = [BlockChecks, ModifierChecks] begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    (; Move) = BlockChecks
    (; check_pullback) = ModifierChecks
    mirror(m) = (; a = (; x = zero(m.a.x)))
    flat(m̄) = m̄.a.x
    c = check_pullback(
        θ -> Move(PerStratum(θ)), [0.1, 0.3, 0.5], [2.0, 1.0, 3.0, 0.5, 0.2, 0.1],
        [0.3, 0.2, 0.1], 1; mirror_of = mirror, flatten = flat
    )
    @test c.v
    @test c.s
    @test c.θ
    # A depletion with a protected pool steps each stratum's value and two
    # pools; its group pullback runs through the default loop.
    pmirror(m) = (;
        pools = nothing,
        pieces = (
            (;
                form = (; α = Ref(0.0)), N = (; x = zero(m.pieces[1].N.x)),
                weights = (nothing, (; x = zero(m.pieces[1].weights[2].x))),
                first = nothing, overflow = nothing,
            ),
            ((; demand = Ref(0.0), form = nothing),),
        ),
    )
    pflat(m̄) = vcat(
        m̄.pieces[1].N.x, m̄.pieces[1].form.α[], only(m̄.pieces[2]).demand[],
        m̄.pieces[1].weights[2].x
    )
    build(θ) = CR.Depletion(
        PerStratum(θ[1:2]),
        CR.Hazard(θ[3]; weights = (S = 1, V = PerStratum(θ[5:6]))),
        CR.Flow(1 => 2, θ[4]; form = CR.Truncate()); pools = (:S, :V)
    )
    for removals in (2.0, 70.0, -1.0), heterogeneity in (1.0, 1.4)
        pc = check_pullback(
            build, [100.0, 80.0, heterogeneity, removals, 0.3, 0.5], [3.0, 1.5],
            [60.0, 50.0, 20.0, 10.0], 1; mirror_of = pmirror, flatten = pflat
        )
        @test pc.v
        @test pc.s
        @test pc.θ
    end
end

@testitem "Blocks: a protected pool is blockwise" begin
    using ComposableRecurrences, Interfaces
    CR = ComposableRecurrences
    d = CR.Depletion(
        100.0, CR.Hazard(; weights = (S = 1, V = 0.3)),
        CR.Flow(1 => 2, 1.0; form = CR.Truncate()); pools = (:S, :V)
    )
    @test CR.blocks(d) == (1, 2)
    @test CR.blocks(CR.Depletion(100.0)) === (1, 1)
    @test CR._blocks(CR.Depletion(100.0)) === nothing
    @test CR.nstate(d, 3) == 6
    @test !CR.ispointwise(d)
    obj = Interfaces.Arguments(;
        piece = d, role = CR.Step(), args = ([2.0, 3.0], [80.0, 60.0, 10.0, 5.0], 2)
    )
    init = Interfaces.Arguments(;
        piece = d, role = CR.Init(), args = (zeros(4), ones(2, 3))
    )
    blockwise = CR.PieceInterface{(:blocks, :nstate)}
    @test Interfaces.test(blockwise, typeof(d), (obj, init); show = false)
    # A modifier that is not blockwise passes the blocks check, so one
    # declaration covers a type with both kinds.
    @test CR._blocks_ok(CR.Clamp(0.0, 1.0), CR.Step(), ([1.0], [0.0], 1))
    # A depletion is pointwise unless its pools make it blockwise.
    @test CR.ispointwise(
        CR.Depletion(100.0, CR.Hazard(), CR.Flow(:S => 0, 1.0; form = CR.Truncate()))
    )
end

@testitem "Blocks: shapes, resume and mixed modifiers" setup = [AdjointCheck, BlockChecks] begin
    using ComposableRecurrences
    (; Move) = BlockChecks
    # No state: two compartments swap a share each step.
    struct Swap{A}
        a::A
    end
    CR.blocks(::Swap) = (2, 0)
    function CR.forward!(m::Swap, ::CR.Step, v::Tuple, s::Tuple, t, g)
        v1, v2 = v[1][], v[2][]
        x = m.a * (v1 - v2)
        v[1][], v[2][] = v1 - x, v2 + x
        return nothing
    end
    @test CR.nstate(Swap(0.1), 4) == 0
    swap = Recurrence([1.0]; modifiers = (Swap(0.25),))
    y = swap(; history = [4.0, 1.0, 0.0, 2.0][:, :], stop = 1)
    # Group 1 is entries 1 and 3, group 2 entries 2 and 4.
    @test vec(y) ≈ [4.0 - 1.0, 1.0 + 0.25, 1.0, 2.0 - 0.25]
    # Two values and two state entries per group, with a typed pullback.
    struct Keep{A}
        a::A
    end
    CR.blocks(::Keep) = (2, 2)
    function CR.forward!(m::Keep, ::CR.Step, v::Tuple, s::Tuple, t, g)
        v1, v2, s1, s2 = v[1][], v[2][], s[1][], s[2][]
        v[1][], v[2][] = v1 * m.a, v2 + s1
        s[1][], s[2][] = s1 + v1, s2 + 1
        return nothing
    end
    function CR.pullback!(grads, m::Keep, ::CR.Step, v::Tuple, s::Tuple, t, g)
        v̄1, v̄2 = grads.v[1][], grads.v[2][]
        s̄1, s̄2 = grads.s[1][], grads.s[2][]
        CR.add_cotangent!(CR.cotangent(grads.piece, :a), v̄1 * v[1][])
        grads.v[1][], grads.v[2][] = v̄1 * m.a + s̄1, v̄2
        grads.s[1][], grads.s[2][] = v̄2 + s̄1, s̄2
        return nothing
    end
    @test CR.uses_adjoint(Keep(0.5), CR.Step())
    @test CR.nstate(Keep(0.5), 6) == 6
    # Resume: a run split in two matches one run, and a wrong state length
    # is named.
    g = [0.5, 0.5]
    R = [1.0 + 0.1 * sin(k + t) for k in 1:4, t in 1:6]
    h = ones(4, 2)
    r = Recurrence(g; modifiers = (Keep(0.9),))
    y = r(R; history = h)
    y1, st = r(R[:, 1:3]; history = h, state = true)
    @test hcat(y1, first(r(R; state = st))) ≈ y
    bad = CR.State(st.history, (zeros(3),), st.t)
    @test_throws "expected nstate" r(R; state = bad)
    # Blockwise, pointwise and vector modifiers together: the pullback
    # matches ForwardDiff. The AD workflow checks that the Mooncake rule
    # runs it ("Blocks: blockwise, pointwise and vector modifiers under the
    # rule" in test/ad/adjoints.jl).
    K = [0.0 0.1 0.0 0.0; 0.1 0.0 0.0 0.0; 0.0 0.0 0.0 0.1; 0.0 0.0 0.1 0.0]
    ms = (
        CR.Clamp(0.0, 50.0), Move(PerStratum([0.2, 0.4])), Keep(0.8),
        CR.Redistribute(K, 0.5),
    )
    @test CR.uses_adjoint(
        Recurrence(g; modifiers = (Move(0.1), Keep(0.5), CR.Clamp(0.0, 1.0))), CR.Run()
    )
    @test pullback_matches(Recurrence(g; modifiers = ms), recargs(R, nothing, h)...)
    # A malformed shape is named.
    struct Odd end
    CR.blocks(::Odd) = (0, 1)
    @test_throws "got (0, 1)" CR.nstate(Odd(), 2)
    # A shape that is not a tuple, such as a `Val`, is named too.
    struct ValShape end
    CR.blocks(::ValShape) = Val((2, 1))
    @test_throws "blocks(m) is nothing or a tuple (nv, ns), got Val{(2, 1)}()" CR.nstate(
        ValShape(), 2
    )
    @test !CR.ispointwise(ValShape())
    # A `(1, 1)` shape is pointwise, so a group step alone is not called.
    struct GroupOnly end
    CR.blocks(::GroupOnly) = (1, 1)
    CR.forward!(::GroupOnly, ::CR.Step, v::Tuple, s::Tuple, t, g) = nothing
    @test_throws "has blocks (1, 1), so it is pointwise" CR.forward!(
        GroupOnly(), CR.Step(), [1.0], [0.0], 1
    )
end
