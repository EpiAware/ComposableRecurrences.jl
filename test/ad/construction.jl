# The Mooncake rules for building a `Depletion` and a `Flow`, which map the
# tangents by structure rather than through a derived rule. Each
# configuration the rules take is checked against ForwardDiff and against
# Mooncake's forward mode, which differentiates the build without them.

@testsnippet ConstructionChecks begin
    using ComposableRecurrences, ForwardDiff, Mooncake
    CR = ComposableRecurrences
    # The reverse gradient against ForwardDiff's, and a directional
    # derivative against Mooncake's forward mode.
    function check_build(f, θ)
        g = ForwardDiff.gradient(f, θ)
        cache = Mooncake.prepare_gradient_cache(f, θ)
        _, (_, gr) = Mooncake.value_and_gradient!!(cache, f, θ)
        dθ = [sin(i / 7) for i in eachindex(θ)]
        dcache = Mooncake.prepare_derivative_cache(f, θ)
        _, d = Mooncake.value_and_derivative!!(
            dcache, (f, Mooncake.NoTangent()), (θ, dθ)
        )
        return isapprox(gr, g; rtol = 1.0e-10) &&
            isapprox(d, g' * dθ; rtol = 1.0e-10)
    end
    run(dep, R, h) = Recurrence([0.3, 0.4, 0.3]; modifiers = (dep,))(
        R; history = h, start = size(h, ndims(h)) + 1
    )
    const T = 30
    series(k) = [0.1 + 0.05 * sin(t / k) for t in 1:T]
end

@testitem "Construction rules: primitives" tags = [:ad, :mooncake, :mooncake_reverse] setup = [ConstructionChecks] begin
    world = Base.get_world_counter()
    for sig in (
            Tuple{
                typeof(CR._depletion), Nothing,
                Tuple{CR.Flow{Float64, CR.Share, Symbol, (:S, 0)}},
                NamedTuple{(:S,), Tuple{Float64}},
            },
            Tuple{Type{CR.Flow}, Symbol, Int, Float64, CR.Share},
        )
        @test Mooncake.is_primitive(
            Mooncake.DefaultCtx, Mooncake.ReverseMode, sig, world
        )
        @test !Mooncake.is_primitive(
            Mooncake.DefaultCtx, Mooncake.ForwardMode, sig, world
        )
    end
end

@testitem "Construction rules: flows of every demand kind" tags = [:ad, :mooncake, :mooncake_reverse] setup = [ConstructionChecks] begin
    C = [0.0 1.0; 0.0 0.0]
    function flows(θ)
        a, o, h, κ = θ[1:T], θ[(T + 1):(2T)], θ[(2T + 1):(3T)], θ[end]
        hz = TimeVarying(h)
        args = (TimeVarying(o), CR.Recent(1), CR.Recent(1; coupling = C), κ)
        drain = CR.Derived((o, u, c, k) -> 0.1 * o * (1 + k), args...)
        dep = CR.Depletion(
            CR.Flow(:u => :c, CR.Derived(identity, hz); form = CR.Share()),
            CR.Flow(:u => 0, κ; form = CR.Share()),
            CR.Flow(:c => 0, CR.Derived(identity, κ); form = CR.Share()),
            CR.Flow(0 => :u, TimeVarying(a); form = CR.Truncate()),
            CR.Flow(:c => 0, drain; form = CR.Truncate(0.5)),
            CR.Flow(:u => :c, hz);
            pools = (:u, :c)
        )
        r = Recurrence([true]; modifiers = (dep,))
        return sum(abs2, r(; history = zeros(2, 1), stop = T))
    end
    θ = [
        [2.0 + sin(t) for t in 1:T]; [0.5 + 0.2 * cos(t) for t in 1:T];
        series(3); 0.03
    ]
    @test check_build(flows, θ)
end

@testitem "Construction rules: draws, populations and pools" tags = [:ad, :mooncake, :mooncake_reverse] setup = [ConstructionChecks] begin
    S = 3
    R0 = [1.0 + 0.2 * sin(k + t) for k in 1:S, t in 1:T]
    # The default hazard, a population and pools per stratum.
    function strata(θ)
        R = reshape(θ[1:(S * T)], S, T)
        N, p0 = θ[(S * T + 1):(S * T + S)], θ[(S * T + S + 1):end]
        dep = CR.Depletion(PerStratum(N); pools = (S = PerStratum(p0),))
        return sum(abs2, run(dep, R, ones(S, 3)))
    end
    θ = [vec(R0); [1.0e3, 2.0e3, 3.0e3]; [990.0, 1990.0, 2990.0]]
    @test check_build(strata, θ)
    # No pieces, a number population.
    nopieces(θ) = sum(abs2, run(CR.Depletion(θ[end]), θ[1:T], ones(3)))
    @test check_build(nopieces, [vec(R0[1, :]); 500.0])
    # Weighted hazard and floor draws with float exponents, number pools, a
    # flow between them, and a draw into a pool.
    for Form in (CR.Hazard, CR.Floor)
        function weighted(θ)
            R, α, σ = θ[1:T], θ[T + 1], θ[T + 2]
            N, h = θ[T + 3], θ[(T + 4):end]
            dep = CR.Depletion(
                N, Form(α; weights = (S = 1, V = σ)),
                CR.Flow(:S => :V, TimeVarying(h); form = CR.Share());
                pools = (S = 0.9 * N, V = 0.1 * N)
            )
            return sum(abs2, run(dep, R, ones(3)))
        end
        @test check_build(weighted, [vec(R0[1, :]); 1.5; 0.4; 500.0; series(5)])
    end
    # A truncated draw into a pool, which fills it up to the population.
    function into(θ)
        R, κ, N = θ[1:T], θ[T + 1], θ[T + 2]
        dep = CR.Depletion(
            N, CR.Truncate(κ; into = :V),
            CR.Flow(:S => :V, 0.05; form = CR.Share());
            pools = (S = 0.5 * N, V = 0.1 * N)
        )
        return sum(abs2, run(dep, R, ones(3)))
    end
    @test check_build(into, [vec(R0[1, :]); 0.4; 400.0])
    # A truncated draw with a softness, between two runs of flows.
    function truncated(θ)
        R, κ, a = θ[1:T], θ[T + 1], θ[(T + 2):end]
        dep = CR.Depletion(
            CR.Flow(0 => :S, TimeVarying(a); form = CR.Truncate()),
            CR.Truncate(κ),
            CR.Flow(:S => 0, 0.02; form = CR.Share());
            pools = (S = 50.0,)
        )
        return sum(abs2, run(dep, R, ones(3)))
    end
    @test check_build(truncated, [vec(R0[1, :]); 0.5; 0.3 .* series(2)])
end
