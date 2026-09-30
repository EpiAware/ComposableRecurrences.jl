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

@testitem "Eltypes: ForwardDiff gradients through every slot" setup = [TestModifiers] begin
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
        gr = ForwardDiff.gradient(f, x)
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
    @test check(P -> sum(W .* Recurrence(nothing; coupling = Pairwise(P))(R0; history = h0)), rand(rng, S, S, L))
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
