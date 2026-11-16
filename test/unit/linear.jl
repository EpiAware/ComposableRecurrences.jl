# Couplings and whole-step modifiers declared linear with `islinear`: a call
# runs the matrix their `forward!` gives on the basis vectors, and
# `PieceInterface` checks the declaration.

@testitem "Linear parts: a declared coupling runs as its matrix" begin
    using ComposableRecurrences, LinearAlgebra, SparseArrays
    CR = ComposableRecurrences
    struct SparseMix{M}
        K::M
    end
    function CR.forward!(C::SparseMix, ::CR.Pressure, q, p, t)
        mul!(q, C.K, p)
        return nothing
    end
    CR.islinear(::SparseMix) = true
    K = sparse([1, 2, 3, 1], [1, 2, 3, 3], [0.8, 0.9, 0.7, 0.2], 3, 3)
    g, h = [0.5, 0.3], ones(3, 2)
    R = [1.0 + 0.1 * sin(a + t) for a in 1:3, t in 1:6]
    r = Recurrence(g; coupling = SparseMix(K))
    # A sparse field alone would send the whole operator to plain AD.
    @test CR.uses_adjoint(r, CR.Run())
    run = CR._linear_parts(r, r, h)
    @test run.coupling isa Matrix{Float64}
    @test run.coupling == Matrix(K)
    @test CR._linear_parts(CR.NoAdjoint(r), r, h) === r
    dense = Recurrence(g; coupling = Matrix(K))
    @test r(R; history = h) ≈ dense(R; history = h)
    @test r(R; history = h) ≈ CR.NoAdjoint(r)(R; history = h)
    # The strata come from the history, or a resumed state's.
    fit = r(R; history = h, stop = 3, record = (:state,))
    @test hcat(fit.y, r(R; state = fit.state)) ≈ r(R; history = h)
    # A coupling with its own pullback! keeps it.
    struct Doubled end
    CR.forward!(::Doubled, ::CR.Pressure, q, p, t) = (q .= 2 .* p; nothing)
    CR.pullback!(grads, ::Doubled, ::CR.Pressure, q, p, t) =
        (grads.p .+= 2 .* grads.q; nothing)
    CR.islinear(::Doubled) = true
    r2 = Recurrence(g; coupling = Doubled())
    @test CR._linear_parts(r2, r2, h) === r2
end

@testitem "Linear parts: a declared modifier runs as its matrix" begin
    using ComposableRecurrences, LinearAlgebra
    CR = ComposableRecurrences
    struct EvenMix{B}
        b::B
    end
    function CR.forward!(m::EvenMix, ::CR.Step, v, s, t)
        mean = sum(v) / length(v)
        for k in eachindex(v)
            v[k] = (1 - m.b) * v[k] + m.b * mean
        end
        return nothing
    end
    CR.islinear(::EvenMix) = true
    g, h = [0.5, 0.3], ones(3, 2)
    R = [1.0 + 0.1 * sin(a + t) for a in 1:3, t in 1:6]
    r = Recurrence(g; modifiers = (EvenMix(0.3),))
    run = CR._linear_parts(r, r, h)
    @test only(run.modifiers) isa CR._LinearStep
    @test only(run.modifiers).A ≈ 0.7 * I + fill(0.1, 3, 3)
    plain = CR.NoAdjoint(r)
    @test r(R; history = h) ≈ plain(R; history = h)
    # The state stays at zeros, as the modifier's own step leaves it.
    out = r(R; history = h, record = (:state, :trace))
    ref = plain(R; history = h, record = (:state, :trace))
    @test out.state.states == ref.state.states
    @test only(out.trace.modifiers) == only(ref.trace.modifiers)
    @test out.trace.pressure ≈ ref.trace.pressure
    # A declared modifier keeps no state of its own.
    struct Stateless end
    CR.forward!(::Stateless, ::CR.Step, v, s, t) = nothing
    CR.nstate(::Stateless, S) = 0
    CR.islinear(::Stateless) = true
    @test_throws ArgumentError Recurrence(g; modifiers = (Stateless(),))(
        R; history = h
    )
end

@testitem "Interfaces: a declared linear type is its matrix" begin
    using ComposableRecurrences, Interfaces
    # Loaded so the pullback component compares with a Jacobian.
    using ForwardDiff
    CR = ComposableRecurrences
    pressure(piece) = (
        Interfaces.Arguments(;
            piece, role = CR.Pressure(), args = (zeros(3), [1.0, 2.0, 3.0], 1)
        ),
    )
    step(piece) = (
        Interfaces.Arguments(;
            piece, role = CR.Step(), args = ([1.0, 2.0, 3.0], zeros(3), 1)
        ),
    )
    check(P, objs) = Interfaces.test(CR.PieceInterface, P, objs; show = false)
    struct Mix{M}
        K::M
    end
    CR.forward!(C::Mix, ::CR.Pressure, q, p, t) = (q .= C.K * p; nothing)
    struct Squared end
    CR.forward!(::Squared, ::CR.Pressure, q, p, t) = (q .= p .^ 2; nothing)
    struct Shifted end
    CR.forward!(::Shifted, ::CR.Pressure, q, p, t) = (q .= p .+ 1; nothing)
    struct Timed end
    CR.forward!(::Timed, ::CR.Pressure, q, p, t) = (q .= t .* p; nothing)
    struct Halve end
    CR.forward!(::Halve, ::CR.Step, v, s, t) = (v .*= 0.5; nothing)
    struct Keeps end
    CR.forward!(::Keeps, ::CR.Step, v, s, t) = (s .+= v; nothing)
    struct Each end
    CR.blocks(::Each) = (1, 1)
    CR.forward!(::Each, ::CR.Step, v, s, t) = (v .*= 0.5; nothing)
    CR.islinear(::Union{Mix, Squared, Shifted, Timed, Halve, Keeps, Each}) =
        true
    @test check(Mix, pressure(Mix([0.9 0.1 0.0; 0.2 0.8 0.0; 0.0 0.3 0.7])))
    @test check(Halve, step(Halve()))
    A = [0.9 0.3 0.0; 0.1 0.7 0.2; 0.0 0.0 1.0]
    @test check(CR._LinearStep, step(CR._LinearStep(A)))
    @test !check(Squared, pressure(Squared()))
    @test !check(Shifted, pressure(Shifted()))
    @test !check(Timed, pressure(Timed()))
    @test !check(Keeps, step(Keeps()))
    @test !check(Each, step(Each()))
end
