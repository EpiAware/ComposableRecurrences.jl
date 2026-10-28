# The routes form of Pairwise: a sum of coupling => kernel routes, against the
# naive reference loop and the equivalent Pairwise kernel.

@testsnippet RouteCases begin
    using ComposableRecurrences, LinearAlgebra, SparseArrays, Random
    CR = ComposableRecurrences

    # Route `r`'s weight on lag `i` of stratum `b` in stratum `a` at time
    # `t`, for the kernel shapes a route accepts; zero past the kernel's end.
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

@testitem "Pairwise routes: equal the naive loop for each kernel" setup = [Reference, RouteCases] begin
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
        r = Recurrence(Pairwise((C => k for (C, k) in routes)...))
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
    r = Recurrence(Pairwise((C => k for (C, k) in routes)...))
    Rp = hcat(ones(S, 5), R)
    y = r(Rp; history = h, start = 6)
    ref = naive_recurrence(
        (t, a, b, i) -> routes_weight(routes, t + 5, a, b, i), h, T;
        gain = (a, t) -> R[a, t]
    )
    @test y ≈ ref
    @test_throws "needs start > 5" r(Rp; history = h)
end

@testitem "Pairwise routes: equal the Pairwise kernel of their sum" begin
    using ComposableRecurrences, SparseArrays, Random
    rng = Xoshiro(22)
    S, L, T = 3, 4, 10
    K1, K2 = rand(rng, S, S), sparse([0.0 0.4 0.0; 0.0 0.0 0.3; 0.2 0.0 0.0])
    g1, g2 = rand(rng, L - 1), rand(rng, L)
    A = [K1[i, j] * get(g1, l, 0.0) + K2[i, j] * g2[l] for i in 1:S, j in 1:S, l in 1:L]
    h = rand(rng, S, L)
    R = rand(rng, S, T)
    routes = Recurrence(Pairwise(K1 => g1, K2 => g2))
    @test routes(R; history = h) ≈ Recurrence(Pairwise(A))(R; history = h)
    # In a buffer deeper than the longest route, with the state it returns.
    struct Deep end
    ComposableRecurrences.blocks(::Deep) = (1, 1)
    ComposableRecurrences.forward!(::Deep, ::ComposableRecurrences.Step, v, s, t) = nothing
    ComposableRecurrences.depth(::Deep) = 2L
    hd = rand(rng, S, 2L)
    deep = Recurrence(Pairwise(K1 => g1, K2 => g2); modifiers = (Deep(),))
    ref = Recurrence(Pairwise(A); modifiers = (Deep(),))
    @test deep(R; history = hd) ≈ ref(R; history = hd)
    y, st = deep(R; history = hd, state = true)
    @test size(st.history) == (S, 2L)
    @test st.history ≈ hcat(hd, y)[:, (end - 2L + 1):end]
end

@testitem "Pairwise routes: fold into a cheaper form" begin
    using ComposableRecurrences, LinearAlgebra, SparseArrays, Random
    using ComposableRecurrences: _Routes
    rng = Xoshiro(23)
    S, L, T = 3, 4, 8
    g = rand(rng, L)
    h = rand(rng, S, L)
    R = rand(rng, S, T)
    # One route is its kernel with its coupling; unfolded, it gives the same.
    for K in (rand(rng, S, S), sparse([0.5 0.0 0.2; 0.1 0.6 0.0; 0.0 0.3 0.4]), 0.7I)
        one = Recurrence(Pairwise(K => g))
        @test one.kernel === g
        @test one.coupling === K
        ref = Recurrence(g; coupling = K)(R; history = h)
        @test one(R; history = h) ≈ ref
        @test Recurrence(Pairwise(K => g), I, ())(R; history = h) ≈ ref
    end
    # A pairwise route keeps its form, as it takes coupling I.
    P = Pairwise(rand(rng, S, S, L))
    @test Recurrence(Pairwise(0.5I => P)).kernel isa _Routes
    # Routes on scaled identities sum into one kernel.
    g2 = rand(rng, L + 2)
    folded = Recurrence(Pairwise(0.5I => g, I => g2))
    @test folded.kernel ≈ 0.5 .* vcat(g, 0.0, 0.0) .+ g2
    @test folded(R; history = h) ≈
        Recurrence(Pairwise(0.5I => g, I => g2), I, ())(R; history = h)
    # Other mixes keep their routes.
    @test Recurrence(Pairwise(0.5I => g, Diagonal(rand(rng, S)) => g2)).kernel isa _Routes
    @test Recurrence(Pairwise(0.5I => g, I => PerStratum(rand(rng, S, 2)))).kernel isa
        _Routes
end

@testitem "Pairwise routes: modifiers, add, resume and Float32" setup = [TestModifiers] begin
    using ComposableRecurrences, SparseArrays, Random
    CR = ComposableRecurrences
    rng = Xoshiro(24)
    S, T = 3, 10
    routes = Pairwise(
        rand(rng, S, S) => rand(rng, 3),
        sparse([0.0 0.4 0.0; 0.0 0.0 0.3; 0.2 0.0 0.0]) => [0.0, 0.0, 0.5, 0.5]
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
    y1, st = r(R; history = h, stop = 4, state = true)
    @test hcat(y1, first(r(R; state = st))) ≈ r(R; history = h)
    # A history shorter than the longest route is zero-padded.
    @test r(R; history = h[:, 3:4]) ≈ ref(R; history = h[:, 3:4])
    # Float32 throughout gives a Float32 output.
    r32 = Recurrence(
        Pairwise(
            Float32.(routes.couplings[1]) => Float32.(routes.kernels[1]),
            Float32.(routes.couplings[2]) => Float32.(routes.kernels[2])
        )
    )
    @test r32(Float32.(R); history = Float32.(h)) isa Matrix{Float32}
end

@testitem "Pairwise routes: argument validation" begin
    using ComposableRecurrences, LinearAlgebra
    g = [0.5, 0.5]
    K = ones(2, 2)
    R2 = Pairwise(K => g, 2K => g)
    # Printed as written; a test module qualifies the name.
    want = "Pairwise([1.0 1.0; 1.0 1.0] => [0.5, 0.5], [2.0 2.0; 2.0 2.0] => [0.5, 0.5])"
    @test endswith(repr(R2), want)
    @test_throws "coupling must be I, got" Recurrence(R2; coupling = K)
    @test_throws "coupling must be I, got" Recurrence(R2; coupling = 0.5I)
    @test_throws "coupling must be I, got" Recurrence(R2, K, ())
    @test_throws "Pairwise is a kernel" Recurrence(g; coupling = R2)
    @test_throws "coupling => kernel pairs" Pairwise(K => g, K)
    @test_throws "coupling => kernel pairs" Pairwise((K, g))
    @test_throws r"Pairwise with 1 route$" Pairwise(K => g, Pairwise(K => g))
    @test_throws "Pairwise with 2 routes" Pairwise(K => g, R2)
    @test_throws "cannot itself be routes" Pairwise(K => Pairwise(K => g))
    @test_throws "Pairwise is a kernel" Pairwise(Pairwise(K => g) => g)
    @test_throws "not a Convolution" Convolution(Pairwise(K => g, 2K => g))
    # A coupling holding a Primary() coefficient is refused when built.
    struct Holds{X}
        x::X
    end
    primary = TimeVarying(ones(2, 2, 3), ComposableRecurrences.Primary())
    @test_throws "only meaningful for a kernel" Pairwise(Holds(primary) => g)
    @test_throws "Pairwise is a kernel" Pairwise(Pairwise(ones(2, 2, 2)) => g)
    @test_throws "a kernel array is a vector" Pairwise(K => ones(2, 2))
    r = Recurrence(Pairwise(K => g, ones(3, 3) => g))
    @test_throws DimensionMismatch r(ones(2, 4); history = ones(2, 2))
    r = Recurrence(Pairwise(I => PerStratum(ones(3, 2))))
    @test_throws DimensionMismatch r(ones(2, 4); history = ones(2, 2))
    r = Recurrence(Pairwise(I => TimeVarying(ones(2, 3))))
    @test_throws "kernel covers 3 times" r(ones(2, 4); history = ones(2, 2))
    r = Recurrence(Pairwise(TimeVarying(ones(2, 2, 3)) => g))
    @test_throws "coupling covers 3 times" r(ones(2, 4); history = ones(2, 2))
end

@testitem "Pairwise routes: the rule needs each route coupling's adjoint" begin
    using ComposableRecurrences, ConstructionBase, LinearAlgebra, SparseArrays
    CR = ComposableRecurrences
    # Couplings with `forward!` only, no `pullback!`: one the rule
    # differentiates locally, and one holding a sparse matrix, which it
    # cannot.
    struct Halve end
    CR.forward!(::Halve, ::CR.Pressure, q, p, t) = (q .= p ./ 2; nothing)
    struct SparseMix{M}
        K::M
    end
    CR.forward!(C::SparseMix, ::CR.Pressure, q, p, t) = (q .= C.K * p; nothing)
    g = [0.5, 0.3]
    K = sparse([0.5 0.0 0.2; 0.1 0.6 0.0; 0.0 0.3 0.4])
    with = Recurrence(Pairwise(fill(0.2, 3, 3) => g, K => g))
    halves = Recurrence(Pairwise(fill(0.2, 3, 3) => g, Halve() => g, Halve() => g))
    without = Recurrence(Pairwise(fill(0.2, 3, 3) => g, SparseMix(K) => g))
    @test CR.uses_adjoint(with, CR.Run())
    @test CR.uses_adjoint(halves, CR.Run())
    @test !CR.uses_adjoint(without, CR.Run())
    empty!(CR._PLAIN_NOTED)
    @test_logs (:info, r"SparseMix has no pullback!") Recurrence(
        Pairwise(fill(0.2, 3, 3) => g, SparseMix(K) => g)
    )
    @test halves(ones(3, 4); history = ones(3, 2)) ≈
        Recurrence(Pairwise(fill(0.2, 3, 3) => g, I => g))(ones(3, 4); history = ones(3, 2))
    # A rebuild from the fields skips the pairing.
    R = with.kernel
    R2 = ConstructionBase.constructorof(typeof(R))(R.couplings, R.kernels)
    @test R2 isa ComposableRecurrences._Routes
    @test R2.couplings === R.couplings
    @test R2.kernels === R.kernels
end
