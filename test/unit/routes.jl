# The Routes coupling: a sum of (coupling, kernel) routes, against the
# naive reference loop and the equivalent Pairwise kernel.

@testsnippet RouteCases begin
    using ComposableRecurrences, LinearAlgebra, SparseArrays, Random
    CR = ComposableRecurrences

    # Route `r`'s weight on lag `i` of stratum `b` in stratum `a` at time
    # `t`, for the kernel shapes Routes accepts; zero past the kernel's end.
    lagw(g::AbstractVector, t, a, b, i) = i <= length(g) ? g[i] : 0.0
    lagw(g::PerStratum, t, a, b, i) = i <= size(g.x, 2) ? g.x[a, i] : 0.0
    function lagw(g::Pairwise, t, a, b, i)
        return i <= size(g.x, 3) ? g.x[a, b, i] : 0.0
    end
    function lagw(g::TimeVarying{CR.Secondary, <:AbstractMatrix}, t, a, b, i)
        return i <= size(g.x, 1) ? g.x[i, t] : 0.0
    end
    function lagw(g::TimeVarying{CR.Primary, <:AbstractMatrix}, t, a, b, i)
        return i <= size(g.x, 1) && t - i >= 1 ? g.x[i, t - i] : 0.0
    end
    mixes(g) = g isa Pairwise
    # A coupling's weight on stratum `b` in stratum `a` at time `t`.
    cw(K::AbstractMatrix, t, a, b) = K[a, b]
    cw(K::UniformScaling, t, a, b) = K.λ * (a == b)
    cw(K::TimeVarying, t, a, b) = K.x[a, b, t]

    # The routes' weight on stratum `b` at lag `i` in stratum `a`: a
    # Pairwise kernel mixes before its coupling.
    function routes_weight(routes, t, a, b, i)
        S = 3
        return sum(routes) do (K, g)
            if mixes(g)
                sum(cw(K, t, a, c) * lagw(g, t, c, b, i) for c in 1:S)
            else
                cw(K, t, a, b) * lagw(g, t, b, b, i)
            end
        end
    end
end

@testitem "Routes: equal the naive loop for each kernel" setup = [Reference, RouteCases] begin
    rng = Xoshiro(21)
    S, T = 3, 9
    h = rand(rng, S, 5)
    R = 0.5 .+ rand(rng, S, T)
    Ks = sparse([0.5 0.0 0.2; 0.1 0.6 0.0; 0.0 0.3 0.4])
    cases = [
        ((rand(rng, S, S), rand(rng, 3)), (Ks, rand(rng, 5))),
        ((I, PerStratum(rand(rng, S, 2))), (Diagonal(rand(rng, S)), rand(rng, 4))),
        ((0.5I, Pairwise(rand(rng, S, S, 3))), (Ks, rand(rng, 2))),
        (
            (TimeVarying(rand(rng, S, S, T)), TimeVarying(rand(rng, 3, T))),
            (Ks, rand(rng, 4)),
        ),
    ]
    for routes in cases
        r = Recurrence(Routes(routes...))
        ref = naive_recurrence(
            (t, a, b, i) -> routes_weight(routes, t, a, b, i), h, T;
            gain = (a, t) -> R[a, t]
        )
        @test r(R; history = h) ≈ ref
        @test @inferred(r(R; history = h)) isa Matrix{Float64}
    end
    # Primary route kernels read the column of each value's own time, so
    # the seed sits at times 1 to 5.
    routes = ((I, TimeVarying(rand(rng, 3, 5 + T), CR.Primary())), (Ks, rand(rng, 2)))
    r = Recurrence(Routes(routes...))
    Rp = hcat(ones(S, 5), R)
    y = r(Rp; history = h, start = 6)
    ref = naive_recurrence(
        (t, a, b, i) -> routes_weight(routes, t + 5, a, b, i), h, T;
        gain = (a, t) -> R[a, t]
    )
    @test y ≈ ref
    @test_throws "needs start > 5" r(Rp; history = h)
end

@testitem "Routes: equal the Pairwise kernel of their sum" begin
    using ComposableRecurrences, SparseArrays, Random
    rng = Xoshiro(22)
    S, L, T = 3, 4, 10
    K1, K2 = rand(rng, S, S), sparse([0.0 0.4 0.0; 0.0 0.0 0.3; 0.2 0.0 0.0])
    g1, g2 = rand(rng, L - 1), rand(rng, L)
    A = [K1[i, j] * get(g1, l, 0.0) + K2[i, j] * g2[l] for i in 1:S, j in 1:S, l in 1:L]
    h = rand(rng, S, L)
    R = rand(rng, S, T)
    routes = Recurrence(Routes((K1, g1), (K2, g2)))
    @test routes(R; history = h) ≈ Recurrence(Pairwise(A))(R; history = h)
end

@testitem "Routes: fold into a cheaper form" begin
    using ComposableRecurrences, LinearAlgebra, SparseArrays, Random
    rng = Xoshiro(23)
    S, L, T = 3, 4, 8
    g = rand(rng, L)
    h = rand(rng, S, L)
    R = rand(rng, S, T)
    # One route is its kernel with its coupling; unfolded, it gives the same.
    for K in (rand(rng, S, S), sparse([0.5 0.0 0.2; 0.1 0.6 0.0; 0.0 0.3 0.4]), 0.7I)
        one = Recurrence(Routes((K, g)))
        @test one.kernel === g
        @test one.coupling === K
        ref = Recurrence(g; coupling = K)(R; history = h)
        @test one(R; history = h) ≈ ref
        @test Recurrence(Routes((K, g)), I, ())(R; history = h) ≈ ref
    end
    # A pairwise route keeps its form, as it takes coupling I.
    P = Pairwise(rand(rng, S, S, L))
    @test Recurrence(Routes((0.5I, P))).kernel isa Routes
    # Routes on scaled identities sum into one kernel.
    g2 = rand(rng, L + 2)
    folded = Recurrence(Routes((0.5I, g), (I, g2)))
    @test folded.kernel ≈ 0.5 .* vcat(g, 0.0, 0.0) .+ g2
    @test folded(R; history = h) ≈
        Recurrence(Routes((0.5I, g), (I, g2)), I, ())(R; history = h)
    # Other mixes keep their routes.
    @test Recurrence(Routes((0.5I, g), (Diagonal(rand(rng, S)), g2))).kernel isa Routes
    @test Recurrence(Routes((0.5I, g), (I, PerStratum(rand(rng, S, 2))))).kernel isa
        Routes
end

@testitem "Routes: modifiers, add, resume and Float32" setup = [TestModifiers] begin
    using ComposableRecurrences, SparseArrays, Random
    CR = ComposableRecurrences
    rng = Xoshiro(24)
    S, T = 3, 10
    routes = Routes(
        (rand(rng, S, S), rand(rng, 3)),
        (sparse([0.0 0.4 0.0; 0.0 0.0 0.3; 0.2 0.0 0.0]), [0.0, 0.0, 0.5, 0.5])
    )
    A = zeros(S, S, 4)
    for (K, g) in zip(routes.couplings, routes.kernels), l in eachindex(g)
        A[:, :, l] .+= Matrix(K) .* g[l]
    end
    pop = FlooredDepletion([50.0, 60.0, 70.0])
    r = Recurrence(routes; modifiers = (pop,))
    ref = Recurrence(Pairwise(A); modifiers = (pop,))
    h = rand(rng, S, 4)
    R = 1 .+ rand(rng, S, T)
    ϵ = rand(rng, S, T)
    @test r(R; history = h, add = ϵ) ≈ ref(R; history = h, add = ϵ)
    # Resuming from the state continues the run.
    y1, st = CR.with_state(r, R; history = h, stop = 4)
    @test hcat(y1, r(R; state = st)) ≈ r(R; history = h)
    # A history shorter than the longest route is zero-padded.
    @test r(R; history = h[:, 3:4]) ≈ ref(R; history = h[:, 3:4])
    # Float32 throughout gives a Float32 output.
    r32 = Recurrence(
        Routes(
            (Float32.(routes.couplings[1]), Float32.(routes.kernels[1])),
            (Float32.(routes.couplings[2]), Float32.(routes.kernels[2]))
        )
    )
    @test r32(Float32.(R); history = Float32.(h)) isa Matrix{Float32}
end

@testitem "Routes: argument validation" begin
    using ComposableRecurrences, LinearAlgebra
    g = [0.5, 0.5]
    K = ones(2, 2)
    R2 = Routes((K, g), (2K, g))
    @test_throws "coupling must be I, got" Recurrence(R2; coupling = K)
    @test_throws "coupling must be I, got" Recurrence(R2; coupling = 0.5I)
    @test_throws "coupling must be I, got" Recurrence(R2, K, ())
    @test_throws "Routes is a kernel" Recurrence(g; coupling = R2)
    @test_throws "at least one route" Routes()
    @test_throws "(coupling, kernel) tuple" Routes((K, g), K)
    @test_throws "(coupling, kernel) tuple" Routes((K, g, g))
    @test_throws "cannot itself be Routes" Routes((K, Routes((K, g))))
    @test_throws "Routes is a kernel" Routes((Routes((K, g)), g))
    @test_throws "Pairwise is a kernel" Routes((Pairwise(ones(2, 2, 2)), g))
    @test_throws "a kernel array is a vector" Routes((K, ones(2, 2)))
    r = Recurrence(Routes((K, g), (ones(3, 3), g)))
    @test_throws DimensionMismatch r(ones(2, 4); history = ones(2, 2))
    r = Recurrence(Routes((I, PerStratum(ones(3, 2)))))
    @test_throws DimensionMismatch r(ones(2, 4); history = ones(2, 2))
    r = Recurrence(Routes((I, TimeVarying(ones(2, 3)))))
    @test_throws "kernel covers 3 times" r(ones(2, 4); history = ones(2, 2))
    r = Recurrence(Routes((TimeVarying(ones(2, 2, 3)), g)))
    @test_throws "coupling covers 3 times" r(ones(2, 4); history = ones(2, 2))
end
