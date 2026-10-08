# The blockwise modifier role: the default vector step and pullback loop a
# group step, `nstate` follows the blocks, and a depletion with a protected
# pool is blockwise.

@testmodule BlockChecks begin
    using ComposableRecurrences, ForwardDiff
    const CR = ComposableRecurrences

    # Two compartments per group: a share `a` of the first moves to the
    # second, and the state keeps what moved.
    struct Move{A}
        a::A
    end
    CR.blocks(::Move) = Val((2, 1))
    function CR.forward(m::Move, ::CR.Step, v::Tuple, s::Tuple, t, g)
        x = CR.param(m.a, g, t) * v[1]
        return (v[1] - x, v[2] + x), (x,)
    end
    function CR.pullback!(grads, m::Move, ::CR.Step, v, s, t, g)
        (v̄1, v̄2), (s̄,) = grads.v, grads.s
        a = CR.param(m.a, g, t)
        c = v̄2 + s̄ - v̄1
        CR.add_param!(CR.cotangent(grads.piece, :a), m.a, c * v[1], g, t)
        return (v̄1 + a * c, v̄2), (zero(s̄),)
    end

    # The same step without a pullback.
    struct MovePlain{A}
        a::A
    end
    CR.blocks(::MovePlain) = Val((2, 1))
    function CR.forward(m::MovePlain, ::CR.Step, v::Tuple, s::Tuple, t, g)
        return CR.forward(Move(m.a), CR.Step(), v, s, t, g)
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

    # Compare the vector pullback with the transposed Jacobian of the vector
    # step in `[v; s; θ]`, for a modifier `build(θ)` whose only parameter
    # mirror is the array `x̄`.
    function check_pullback(build, θ, v, s, t, mirror, flat)
        S, n = length(v), length(s)
        v̄′ = collect(range(0.3, 1.7; length = S))
        s̄′ = collect(range(-0.4, 0.9; length = n))
        J = ForwardDiff.jacobian(vcat(v, s, θ)) do x
            vv, ss = x[1:S], x[(S + 1):(S + n)]
            CR.forward(build(x[(S + n + 1):end]), CR.Step(), vv, ss, t)
            return vcat(vv, ss)
        end
        expected = transpose(J) * vcat(v̄′, s̄′)
        m = build(θ)
        m̄ = mirror(m)
        gv, gs = copy(v̄′), copy(s̄′)
        CR._vector_pullback!((; piece = m̄, v = gv, s = gs), m, copy(v), copy(s), t)
        return gv ≈ expected[1:S] && gs ≈ expected[(S + 1):(S + n)] &&
            flat(m̄) ≈ expected[(S + n + 1):end]
    end
end

@testitem "Blocks: a user modifier against a naive loop" setup = [BlockChecks] begin
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
        @test ForwardDiff.gradient(θ -> sum(W .* run(θ, R)), θ) ≈
            ForwardDiff.gradient(θ -> sum(W .* ref(θ, R)), θ)
        @test ForwardDiff.gradient(R -> sum(W .* run(θ, R)), R) ≈
            ForwardDiff.gradient(R -> sum(W .* ref(θ, R)), R)
        @test CR.nstate(M(0.1), 6) == 3
        @test !CR.ispointwise(M(0.1))
    end
    @test CR.uses_adjoint(Recurrence(g; modifiers = (Move(0.1),)), CR.Run())
    @test !CR.uses_adjoint(Recurrence(g; modifiers = (MovePlain(0.1),)), CR.Run())
    # The state keeps what moved at the last step.
    moved = Recurrence([1.0]; modifiers = (Move(0.25),))
    _, st = CR.with_state(moved; history = [4.0, 0.0][:, :], stop = 1)
    @test only(st.states) == [1.0]
    r = Recurrence(g; modifiers = (Move(0.1),))
    @test_throws "needs a multiple of 2 strata, got 3" r(ones(3, 4); history = ones(3, 3))
end

@testitem "Blocks: group pullbacks against a local Jacobian" setup = [BlockChecks] begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    (; Move, check_pullback) = BlockChecks
    mirror(m) = (; a = (; x = zero(m.a.x)))
    flat(m̄) = m̄.a.x
    @test check_pullback(
        θ -> Move(PerStratum(θ)), [0.1, 0.3, 0.5], [2.0, 1.0, 3.0, 0.5, 0.2, 0.1],
        [0.3, 0.2, 0.1], 1, mirror, flat
    )
    # A depletion with a protected pool steps each stratum's value and two
    # pools; its group pullback runs through the default loop.
    pmirror(m) = (;
        N = (; x = zero(m.N.x)), heterogeneity = Ref(0.0),
        flows = ((; kind = (; a = Ref(0.0))),),
        protected = (; σ = (; x = zero(m.protected.σ.x)), pool0 = Ref(0.0)),
    )
    pflat(m̄) = vcat(m̄.N.x, m̄.heterogeneity[], only(m̄.flows).kind.a[], m̄.protected.σ.x)
    build(θ) = CR.Depletion(
        PerStratum(θ[1:2]); heterogeneity = θ[3], removals = θ[4],
        protected = CR.Protected(PerStratum(θ[5:6]))
    )
    for removals in (2.0, 70.0, -1.0), heterogeneity in (1.0, 1.4)
        @test check_pullback(
            build, [100.0, 80.0, heterogeneity, removals, 0.3, 0.5], [3.0, 1.5],
            [60.0, 50.0, 20.0, 10.0], 1, pmirror, pflat
        )
    end
end

@testitem "Blocks: a protected pool is blockwise" begin
    using ComposableRecurrences, Interfaces
    CR = ComposableRecurrences
    d = CR.Depletion(100.0; removals = 1.0, protected = CR.Protected(0.3))
    @test CR.blocks(d) == Val((1, 2))
    @test CR.blocks(CR.Depletion(100.0)) === nothing
    @test CR.nstate(d, 3) == 6
    @test !CR.ispointwise(d)
    obj = Interfaces.Arguments(;
        piece = d, role = CR.Step(), args = ([2.0, 3.0], [80.0, 60.0, 10.0, 5.0], 2)
    )
    blockwise = CR.PieceInterface{(:blocks, :nstate)}
    @test Interfaces.test(blockwise, typeof(d), (obj,); show = false)
end

@testitem "Blocks: shapes, resume and mixed modifiers" setup = [BlockChecks] begin
    using ComposableRecurrences, ForwardDiff, Mooncake
    using DifferentiationInterface: gradient, AutoMooncake
    CR = ComposableRecurrences
    (; Move) = BlockChecks
    # No state: two compartments swap a share each step.
    struct Swap{A}
        a::A
    end
    CR.blocks(::Swap) = Val((2, 0))
    function CR.forward(m::Swap, ::CR.Step, v::Tuple, s::Tuple, t, g)
        x = m.a * (v[1] - v[2])
        return (v[1] - x, v[2] + x), ()
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
    CR.blocks(::Keep) = Val((2, 2))
    function CR.forward(m::Keep, ::CR.Step, v::Tuple, s::Tuple, t, g)
        return (v[1] * m.a, v[2] + s[1]), (s[1] + v[1], s[2] + 1)
    end
    function CR.pullback!(grads, m::Keep, ::CR.Step, v::Tuple, s::Tuple, t, g)
        (v̄1, v̄2), (s̄1, s̄2) = grads.v, grads.s
        CR.add_cotangent!(CR.cotangent(grads.piece, :a), v̄1 * v[1])
        return (v̄1 * m.a + s̄1, v̄2), (v̄2 + s̄1, s̄2)
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
    y1, st = CR.with_state(r, R[:, 1:3]; history = h)
    @test hcat(y1, r(R; state = st)) ≈ y
    bad = CR.State(st.history, (zeros(3),), st.t)
    @test_throws "expected nstate" r(R; state = bad)
    # Blockwise, pointwise and vector modifiers together under the rule.
    K = [0.0 0.1 0.0 0.0; 0.1 0.0 0.0 0.0; 0.0 0.0 0.0 0.1; 0.0 0.0 0.1 0.0]
    function loss(θ)
        ms = (
            CR.Clamp(0.0, 50.0), Move(PerStratum(θ[1:2])), Keep(θ[3]),
            CR.Redistribute(K, 0.5),
        )
        return sum(abs2, Recurrence(g; modifiers = ms)(R; history = h))
    end
    θ = [0.2, 0.4, 0.8]
    @test CR.uses_adjoint(
        Recurrence(g; modifiers = (Move(0.1), Keep(0.5), CR.Clamp(0.0, 1.0))), CR.Run()
    )
    @test gradient(loss, AutoMooncake(), θ) ≈ ForwardDiff.gradient(loss, θ)
    # A malformed shape is named.
    struct Odd end
    CR.blocks(::Odd) = Val((0, 1))
    @test_throws "got Val((0, 1))" CR.nstate(Odd(), 2)
end
