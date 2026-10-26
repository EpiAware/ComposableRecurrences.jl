# Element types: the output eltype is promoted from every input, so Float32
# stays Float32 and ForwardDiff Duals flow through each slot.

@testitem "Eltypes: Float32 in, Float32 out" setup = [TestModifiers] begin
    using ComposableRecurrences, LinearAlgebra, SparseArrays
    S, L, T = 3, 4, 6
    g = Float32[0.1, 0.2, 0.3, 0.4]
    h = ones(Float32, S, L)
    R = fill(1.1f0, S, T)
    K = Float32[0.8 0.1 0.1; 0.1 0.8 0.1; 0.1 0.1 0.8]
    for coupling in (I, 0.5f0 * I, K, sparse(K), Diagonal(diag(K)))
        y = Recurrence(g; coupling)(R; history = h)
        @test eltype(y) == Float32
    end
    r = Recurrence(g; coupling = K, modifiers = (FlooredDepletion(fill(100.0f0, S)),))
    @test eltype(r(R; history = h)) == Float32
    @test eltype(Recurrence(PerStratum(ones(Float32, S, L)))(R; history = h)) ==
        Float32
    @test eltype(Convolution(g)(R)) == Float32
    @test eltype(Convolution(g)(R[1, :]; history = h[1, :])) == Float32

    # Mixed precision promotes, including a modifier state built from a
    # Float32 parameter with a Float64 history.
    y = Recurrence(g; modifiers = (FlooredDepletion(fill(100.0f0, S)),))(
        R; history = Float64.(h)
    )
    @test eltype(y) == Float64
    @test eltype(Recurrence(g)(fill(1.1, S, T); history = h)) == Float64
    @test eltype(Recurrence(g; coupling = 0.5 * I)(R; history = h)) == Float64
    @test eltype(Convolution(Float64.(g))(R)) == Float64
end

@testitem "Eltypes: ForwardDiff gradients through every slot" setup = [ReferenceAD, TestModifiers] begin
    using ComposableRecurrences, ForwardDiff, LinearAlgebra, Random,
        SparseArrays
    rng = Xoshiro(41)
    S, L, T = 3, 3, 8
    g0 = [0.2, 0.3, 0.5]
    K0 = [0.8 0.1 0.1; 0.2 0.7 0.1; 0.0 0.3 0.7]
    h0 = [1.0 2.0 3.0; 2.0 1.0 1.5; 0.5 1.0 2.0]
    R0 = [1.0 + 0.1 * sin(a + t) for a in 1:S, t in 1:T]
    pop0 = [40.0, 60.0, 50.0]
    W = [cos(a * t) for a in 1:S, t in 1:T]

    # Central differences on a scalar direction, checked against ForwardDiff.
    function check(f, x)
        gr = ReferenceAD.gradient(f, x)
        δ = 1.0e-6
        fd = map(eachindex(x)) do i
            e = zero(x)
            e[i] = δ
            (f(x + e) - f(x - e)) / (2δ)
        end
        return isapprox(vec(gr), fd; rtol = 1.0e-5, atol = 1.0e-7)
    end
    rec(g, K, h, R, pop; kw...) = sum(
        W .* Recurrence(g; coupling = K, modifiers = (FlooredDepletion(pop),))(
            R; history = h, kw...
        )
    )
    @test check(g -> rec(g, K0, h0, R0, pop0), g0)
    @test check(K -> rec(g0, K, h0, R0, pop0), K0)
    @test check(h -> rec(g0, K0, h, R0, pop0), h0)
    @test check(R -> rec(g0, K0, h0, R, pop0), R0)
    @test check(pop -> rec(g0, K0, h0, R0, pop), pop0)
    # A scalar modifier field receives its derivative.
    @test check(
        N -> sum(
            W .* Recurrence(g0; modifiers = (LooseScale(N[1], (; b = 0.0)),))(
                R0; history = h0
            )
        ), [0.9]
    )
    @test check(ϵ -> rec(g0, K0, h0, R0, pop0; add = ϵ), 0.1 .* R0)
    @test check(λ -> sum(W .* Recurrence(g0; coupling = λ[1] * I)(R0; history = h0)), [0.9])
    @test check(d -> sum(W .* Recurrence(g0; coupling = Diagonal(d))(R0; history = h0)), [0.9, 1.0, 1.1])
    @test check(
        v -> sum(
            W .* Recurrence(g0; coupling = sparse([1, 2, 3, 1], [1, 2, 3, 3], v, S, S))(
                R0; history = h0
            )
        ), [0.9, 1.0, 1.1, 0.2]
    )
    @test check(P -> sum(W .* Recurrence(Pairwise(P))(R0; history = h0)), rand(rng, S, S, L))
    @test check(G -> sum(W .* Recurrence(TimeVarying(G))(R0; history = h0)), rand(rng, L, T))
    @test check(
        θ -> sum(
            W .* Recurrence(g0; modifiers = (LooseScale(θ[1], (; b = θ[2])),))(
                R0; history = h0
            )
        ), [0.9, 0.1]
    )
    @test check(c -> sum(W .* Convolution(c)(R0; history = h0)), g0)
    @test check(x -> sum(W .* Convolution(g0)(x; history = h0)), R0)
    @test check(h -> sum(W .* Convolution(g0)(R0; history = h)), h0)
end

@testitem "Eltypes: built-in modifiers keep Float32" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    g = Float32[0.2, 0.3, 0.5]
    h = ones(Float32, 2, 3)
    R = fill(1.1f0, 2, 5)
    K = Float32[0.0 0.3; 0.2 0.0]
    for m in (
            CR.Depletion(100.0f0),
            CR.Depletion(PerStratum(Float32[100, 50]); form = CR.Floor()),
            CR.Depletion(100.0f0; pools = (S = 97.0f0,), heterogeneity = 1.5f0),
            CR.Add(0.5f0), CR.Add(TimeVarying(PerStratum(fill(0.5f0, 2, 5)))),
            CR.Redistribute(CR.movement(K, 0.1f0)),
            CR.Redistribute(CR.movement(K, fill(0.1f0, 2, 5))),
            CR.Clamp(0.0f0, 5.0f0),
            CR.Depletion(
                0.8f0; pools = (:O,), form = CR.SoftTruncate(0.1f0), fill = :O,
                flows_first = true, overflow = :stratum,
                flows = CR.Flow(:O => 0, 0.1f0; form = CR.Share())
            ),
            CR.Depletion(;
                pools = (:B,), form = CR.Truncate(), flows_first = true,
                flows = CR.Flow(
                    0 => :B, TimeVarying(repeat(Float32[0.8, 0.0], 5)); form = CR.Truncate()
                ),
                overflow = :queue
            ),
            CR.Depletion(0.8f0; pools = (:O,), form = CR.Truncate(), fill = :O),
            CR.Depletion(5.0f0; form = CR.SoftTruncate(0.1f0)),
        )
        @test eltype(Recurrence(g; modifiers = (m,))(R; history = h)) == Float32
    end
    # The movement of a Float32 kernel stays Float32.
    @test eltype(CR.movement(K, 0.1f0)) == Float32
    @test CR.param_eltype(CR.movement(K, fill(0.1f0, 2, 5))) == Float32
    # The constructor infers with a form struct.
    floor_depletion() = ComposableRecurrences.Depletion(
        1.0; form = ComposableRecurrences.Floor()
    )
    @test (@inferred floor_depletion()) isa CR.Depletion
    beds() = ComposableRecurrences.Depletion(
        1.0; pools = (:O,), form = ComposableRecurrences.Truncate(), fill = :O,
        flows_first = true, overflow = :stratum,
        flows = ComposableRecurrences.Flow(
            :O => 0, 0.1; form = ComposableRecurrences.Share()
        )
    )
    @test (@inferred beds()) isa CR.Depletion
end

@testitem "Eltypes: integer inputs keep an integer output, as cumsum does" begin
    using ComposableRecurrences, Test
    CR = ComposableRecurrences
    # A running total of integers is Base's `cumsum`, type and values.
    x = [1, 2, 3, 4]
    total(x) = Recurrence([true])(true; history = [0], add = x)
    @test (@inferred total(x)) == cumsum(x)
    @test eltype(total(x)) == eltype(cumsum(x)) == Int
    # `Bool` and narrow integers promote with `Int`, as Base's sums do.
    @test eltype(Recurrence([true])(true; history = [false], add = [true])) == Int
    @test eltype(Recurrence([true])(true; history = Int8[0], add = Int8[1])) == Int
    @test Recurrence([1, 2])(2; history = [1, 1], stop = 3) == [6, 16, 56]
    # Strata through an integer coupling, prepended, traced and resumed.
    y = Recurrence([1]; coupling = [1 0; 1 1])(1; history = ones(Int, 2, 1), stop = 2)
    @test y == [1 1; 2 3]
    r = Recurrence([true])
    @test eltype(r(true; history = [0], add = x, prepend = true)) == Int
    @test eltype(first(r(true; history = [0], add = x, trace = true))) == Int
    y, st = r(true; history = [0], add = x, stop = 2, state = true)
    @test eltype(y) == eltype(st.history) == Int
    @test first(r(true; add = x, state = st)) == cumsum(x)[3:4]
    # A float anywhere, a rational, or a modifier, whose step may divide,
    # gives the float type.
    @test eltype(r(true; history = [0.0], add = x)) == Float64
    @test eltype(r(0.5f0; history = [0], add = x)) == Float32
    @test eltype(Recurrence([1 // 2])(1; history = [1], stop = 2)) == Float64
    d = Recurrence([1]; modifiers = (CR.Depletion(100),))
    @test eltype(d(1; history = [1], stop = 2)) == Float64
    @test CR._buffer_eltype(Int, ()) == Int
    @test CR._buffer_eltype(Bool, (CR.Add(1),)) == Float64
end
