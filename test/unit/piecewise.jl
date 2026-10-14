# Coefficients given by change points, checked against the dense
# `TimeVarying` array that repeats each value over its segment.

@testmodule PiecewiseChecks begin
    using ComposableRecurrences
    const CR = ComposableRecurrences

    # The segment of time `t` and the dense array of the change points `ps`
    # over `T` times, kernels padded with zeros to the longest.
    segment(starts, t) = findlast(<=(t), starts)
    pad(v, n) = [v; zeros(n - length(v))]
    function dense(ps, T)
        starts, vs = first.(ps), last.(ps)
        at(t) = vs[segment(starts, t)]
        v = first(vs)
        v isa Real && return [at(t) for t in 1:T]
        v isa PerStratum && return PerStratum(dense(starts .=> map(x -> x.x, vs), T))
        if v isa AbstractVector
            n = maximum(length, vs)
            return reduce(hcat, [pad(at(t), n) for t in 1:T])
        end
        return cat([at(t) for t in 1:T]...; dims = ndims(v) + 1)
    end
    both(ps, T, I = CR.Secondary()) = (TimeVarying(ps, I), TimeVarying(dense(ps, T), I))

    const T = 24
    const G = [[0.5, 0.3, 0.2], [0.2, 0.6, 0.1, 0.05], [0.1, 0.1, 0.4]]
    # Change points closer together than the kernel and far apart.
    const KS = [1 => G[1], 7 => G[2], 9 => G[3]]
    const GS = [
        1 => PerStratum([0.5 0.3 0.2; 0.4 0.4 0.1]),
        10 => PerStratum([0.1 0.2 0.3; 0.3 0.3 0.3]),
    ]
    const X = [1.0 + 0.3 * sin(k + t) for k in 1:2, t in 1:T]
    const R = [1.1 + 0.2 * cos(k * t) for k in 1:2, t in 1:T]
    const H = [1.0 2.0 1.5 0.5; 0.4 0.9 1.1 0.7]
end

@testitem "Change points: construction and checks" setup = [PiecewiseChecks] begin
    using ComposableRecurrences
    using ComposableRecurrences: Primary, Secondary
    CR = ComposableRecurrences
    (; KS, GS, dense) = PiecewiseChecks
    k = @inferred TimeVarying(KS)
    @test k isa TimeVarying{Secondary, <:CR._Piecewise{Matrix{Float64}}}
    @test k.x.starts == [1, 7, 9]
    # Shorter kernels are padded with zero weights.
    @test k.x.x == [0.5 0.2 0.1; 0.3 0.6 0.1; 0.2 0.1 0.4; 0.0 0.05 0.0]
    @test TimeVarying(KS, Primary()) isa TimeVarying{Primary, <:CR._Piecewise}
    # Numbers are stored as floats; couplings and per-stratum values stack.
    @test (@inferred TimeVarying([1 => 1, 5 => 2])).x.x == [1.0, 2.0]
    C = TimeVarying([1 => [1.0 0.0; 0.0 1.0], 4 => [0.5 0.5; 0.5 0.5]])
    @test size(C.x.x) == (2, 2, 2)
    @test TimeVarying(GS).x.x isa PerStratum{<:AbstractArray{Float64, 3}}
    # `TimeVarying` stays the outer wrapper.
    p = PerStratum(TimeVarying([1 => [1.0, 2.0], 3 => [3.0, 4.0]]))
    @test p.x.x.x == [1.0 3.0; 2.0 4.0]
    # Starts begin at 1 and rise; each is an integer; values share a form.
    @test_throws ArgumentError TimeVarying([2 => 1.0, 5 => 2.0])
    @test_throws ArgumentError TimeVarying([1 => 1.0, 5 => 2.0, 5 => 3.0])
    @test_throws ArgumentError TimeVarying([1 => 1.0, 4 => 2.0, 3 => 3.0])
    @test_throws ArgumentError TimeVarying([1.0 => 1.0])
    @test_throws ArgumentError TimeVarying(Pair{Int, Float64}[])
    @test_throws DimensionMismatch TimeVarying([1 => ones(2, 2), 3 => ones(3, 3)])
    @test_throws ArgumentError TimeVarying([1 => 1.0, 3 => [1.0]])
    # The slots check their shapes and indexing as for a dense array.
    @test_throws ArgumentError Recurrence(TimeVarying([1 => 0.5, 3 => 0.2]))
    @test_throws ArgumentError Recurrence(TimeVarying([1 => Pairwise(ones(2, 2, 2))]))
    @test_throws ArgumentError Recurrence([0.5]; coupling = TimeVarying(KS))
    @test_throws ArgumentError CR.Add(TimeVarying([1 => 1.0, 3 => 2.0], Primary()))
    @test_throws DimensionMismatch Recurrence(TimeVarying(GS))(
        ones(3, 4); history = ones(3, 3)
    )
    @test occursin("change points [1, 7, 9]", CR._describe(TimeVarying(KS)))
end

@testitem "Change points: Convolution equals the dense kernel" setup = [PiecewiseChecks] begin
    using ComposableRecurrences
    using Base.ScopedValues: with
    CR = ComposableRecurrences
    (; KS, GS, X, T, both) = PiecewiseChecks
    for I in (CR.Secondary(), CR.Primary()), ps in (KS, GS), start in (1, 6, 9, 15)
        p, d = both(ps, T, I)
        h = I isa CR.Primary ? nothing : X[:, 1:3]
        for stop in (start - 1, start + 2, T)
            @test Convolution(p)(X; history = h, start, stop) ≈
                Convolution(d)(X; history = h, start, stop)
        end
        ps === KS && @test Convolution(p)(X[1, :]; start) ≈ Convolution(d)(X[1, :]; start)
        @test Convolution(p)(X; history = h, gain = 0.5, add = 1.0) ≈
            Convolution(d)(X; history = h, gain = 0.5, add = 1.0)
        @test CR.contributions(Convolution(p), X; history = h, start) ≈
            CR.contributions(Convolution(d), X; history = h, start)
        with(CR.EXECUTOR => CR.Threaded(; min_work = 0, ntasks = 2)) do
            @test Convolution(p)(X; history = h) ≈ Convolution(d)(X; history = h)
        end
    end
    # Dual numbers take the same loops.
    using ForwardDiff
    f(form) = θ -> sum(Convolution(form([1 => θ[1:3], 5 => θ[4:6]], T))(X))
    pw(ps, T) = TimeVarying(ps, CR.Primary())
    dn(ps, T) = TimeVarying(PiecewiseChecks.dense(ps, T), CR.Primary())
    θ = [0.5, 0.3, 0.2, 0.1, 0.6, 0.3]
    @test ForwardDiff.gradient(f(pw), θ) ≈ ForwardDiff.gradient(f(dn), θ)
end

@testitem "Change points: Recurrence equals the dense kernel" setup = [PiecewiseChecks] begin
    using ComposableRecurrences
    using LinearAlgebra: I, Diagonal
    using Base.ScopedValues: with
    CR = ComposableRecurrences
    (; KS, GS, R, H, T, both) = PiecewiseChecks
    for ix in (CR.Secondary(), CR.Primary()), ps in (KS, GS)
        p, d = both(ps, T, ix)
        for C in (I, 0.8I, Diagonal([0.9, 1.1]), [0.9 0.1; 0.2 0.8])
            seed = (; history = H, start = ix isa CR.Primary ? 5 : 1)
            rp, rd = Recurrence(p; coupling = C), Recurrence(d; coupling = C)
            @test rp(R; seed...) ≈ rd(R; seed...)
            # A resumed call carries on through the change points.
            for stop in (6, 8, 12)
                y1, st = CR.with_state(rp, R; seed..., stop)
                @test hcat(y1, rp(R; state = st)) ≈ rd(R; seed...)
            end
            with(CR.EXECUTOR => CR.Threaded(; min_work = 0, ntasks = 2)) do
                @test rp(R; seed...) ≈ rd(R; seed...)
            end
        end
        ps === KS && @test Recurrence(p)(R[1, :]; history = H[1, :], start = 5) ≈
            Recurrence(d)(R[1, :]; history = H[1, :], start = 5)
    end
    # A kernel from change points as a route.
    p, d = both(KS, T)
    K = [0.9 0.1; 0.2 0.8]
    rp = Recurrence(Routes((K, [0.3, 0.2]), (0.5I, p)))
    rd = Recurrence(Routes((K, [0.3, 0.2]), (0.5I, d)))
    @test rp(R; history = H) ≈ rd(R; history = H)
    # The last value holds past the dense array's end.
    long = vcat(R[1, :], R[1, :])
    d2 = TimeVarying(PiecewiseChecks.dense(KS, 2T))
    @test Recurrence(p)(long; history = H[1, :]) ≈ Recurrence(d2)(long; history = H[1, :])
end

@testitem "Change points: couplings and parameters equal the dense form" setup = [PiecewiseChecks] begin
    using ComposableRecurrences
    using ComposableRecurrences: Add, Depletion, Transform, Clamp
    CR = ComposableRecurrences
    (; R, H, T, both) = PiecewiseChecks
    g = [0.5, 0.3, 0.2]
    Cp, Cd = both([1 => [0.9 0.1; 0.2 0.8], 8 => [0.6 0.0; 0.1 0.5]], T)
    @test Recurrence(g; coupling = Cp)(R; history = H) ≈
        Recurrence(g; coupling = Cd)(R; history = H)
    ap, ad = both([1 => 0.3, 9 => -0.1], T)
    bp, bd = both([1 => PerStratum([0.1, 0.2]), 5 => PerStratum([0.3, 0.0])], T)
    np, nd = both([1 => 60.0, 12 => 80.0], T)
    for (mp, md) in (
            ((Add(ap),), (Add(ad),)),
            ((Add(bp),), (Add(bd),)),
            ((Depletion(np; pool0 = 50.0),), (Depletion(nd; pool0 = 50.0),)),
            ((Transform(*, bp),), (Transform(*, bd),)),
            ((Clamp(ap, 2.0),), (Clamp(ad, 2.0),)),
        )
        @test Recurrence(g; modifiers = mp)(R; history = H) ≈
            Recurrence(g; modifiers = md)(R; history = H)
    end
    @test CR.param(ap, 1, 8) == 0.3 && CR.param(ap, 1, 9) == -0.1
    @test CR.param(bp, 2, 30) == 0.0
    x̄ = (; x = (; x = zeros(2), starts = nothing))
    CR.add_param!(x̄, ap, 1.5, 1, 10)
    @test x̄.x.x == [0.0, 1.5]
    @test_throws ArgumentError CR.Beds(TimeVarying([1 => 0.2, 3 => 1.5]))
    @test CR.Beds(TimeVarying([1 => 0.2, 3 => 0.5])).exit isa TimeVarying
end

@testitem "Adjoint: coefficients from change points" setup = [AdjointCheck, PiecewiseChecks] begin
    using ComposableRecurrences
    using Base.ScopedValues: with
    (; KS, GS, X, R, H, T) = PiecewiseChecks
    for ix in (CR.Secondary(), CR.Primary()), ps in (KS, GS), start in (1, 8)
        c = Convolution(TimeVarying(ps, ix))
        h = ix isa CR.Primary ? nothing : X[:, 1:2]
        @test pullback_matches(c, X, true, nothing, h, start, nothing)
        @test pullback_matches(c, X, 0.5, 1.0, h, start, 15)
        @test constant_kernel_matches(c, X, true, nothing, h, start, nothing)
        seed = ix isa CR.Primary ? 5 : start
        for C in (I, [0.9 0.1; 0.2 0.8])
            r = Recurrence(TimeVarying(ps, ix); coupling = C)
            @test pullback_matches(r, recargs(R, nothing, H; start = seed)...)
            @test constant_kernel_matches(r, recargs(R, nothing, H; start = seed)...)
        end
    end
    g = [0.5, 0.3, 0.2]
    C = TimeVarying([1 => [0.9 0.1; 0.2 0.8], 8 => [0.6 0.0; 0.1 0.5]])
    @test pullback_matches(Recurrence(g; coupling = C), recargs(R, nothing, H)...)
    a = TimeVarying([1 => 0.3, 9 => -0.1])
    b = TimeVarying([1 => PerStratum([0.1, 0.2]), 5 => PerStratum([0.3, 0.0])])
    mods = (CR.Add(a), CR.Add(b), CR.Transform(*, Derived(exp, a)))
    @test pullback_matches(Recurrence(g; modifiers = mods), recargs(R, nothing, H)...)
    ex = CR.Threaded(; min_work = 0, ntasks = 2)
    with(CR.EXECUTOR => ex) do
        @test pullback_matches(Recurrence(TimeVarying(KS)), recargs(R, nothing, H)...)
        c = Convolution(TimeVarying(GS))
        @test pullback_matches(c, X, true, nothing, X[:, 1:2], 1, nothing)
    end
end
