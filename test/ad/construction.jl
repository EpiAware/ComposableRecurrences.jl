# The Mooncake rules for building a `Depletion` and a `Flow`, which map the
# tangents by structure rather than through a derived rule. Each
# configuration the rules take is checked against ForwardDiff and against
# Mooncake's forward mode, which differentiates the build without them, and
# each check asserts the rule applies to the parts it builds from.

@testsnippet ConstructionChecks begin
    using ComposableRecurrences, ForwardDiff, Mooncake
    CR = ComposableRecurrences
    # That the reverse rule applies to a `Depletion` built from these parts,
    # as its constructor passes them on.
    function built_by_rule(N, pieces, pools)
        sig = Tuple{
            typeof(CR._depletion), typeof(N), typeof(pieces), typeof(pools),
        }
        return Mooncake.is_primitive(
            Mooncake.DefaultCtx, Mooncake.ReverseMode, sig,
            Base.get_world_counter()
        )
    end
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
    R1 = [1.0 + 0.2 * sin(1 + t) for t in 1:T]
end

@testitem "Construction rules: primitives" tags = [:ad, :mooncake, :mooncake_reverse] setup = [ConstructionChecks] begin
    world = Base.get_world_counter()
    share = CR.Flow(:S => 0, 0.1; form = CR.Share())
    for sig in (
            Tuple{
                typeof(CR._depletion), Nothing, Tuple{typeof(share)},
                Tuple{Symbol},
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
    function pieces(θ)
        a, o, h, κ = θ[1:T], θ[(T + 1):(2T)], θ[(2T + 1):(3T)], θ[end]
        hz = TimeVarying(h)
        args = (TimeVarying(o), CR.Recent(1), CR.Recent(1; coupling = C), κ)
        drain = CR.Derived((o, u, c, k) -> 0.1 * o * (1 + k), args...)
        return (
            CR.Flow(:u => :c, CR.Derived(identity, hz); form = CR.Share()),
            CR.Flow(:u => 0, κ; form = CR.Share()),
            CR.Flow(:c => 0, CR.Derived(identity, κ); form = CR.Share()),
            CR.Flow(0 => :u, TimeVarying(a); form = CR.Truncate()),
            CR.Flow(:c => 0, drain; form = CR.Truncate(0.5)),
            CR.Flow(:u => :c, hz),
        )
    end
    function flows(θ)
        dep = CR.Depletion(pieces(θ)...; pools = (:u, :c))
        r = Recurrence([true]; modifiers = (dep,))
        return sum(abs2, r(; history = zeros(2, 1), stop = T))
    end
    θ = [
        [2.0 + sin(t) for t in 1:T]; [0.5 + 0.2 * cos(t) for t in 1:T];
        series(3); 0.03
    ]
    @test built_by_rule(nothing, pieces(θ), (:u, :c))
    @test check_build(flows, θ)
end

@testitem "Construction rules: draws, populations and pools" tags = [:ad, :mooncake, :mooncake_reverse] setup = [ConstructionChecks] begin
    S = 3
    R0 = [1.0 + 0.2 * sin(k + t) for k in 1:S, t in 1:T]
    # The default hazard, a population and pools per stratum.
    strata_parts(N, p0) = (PerStratum(N), (S = PerStratum(p0),))
    function strata(θ)
        R = reshape(θ[1:(S * T)], S, T)
        N, pools = strata_parts(
            θ[(S * T + 1):(S * T + S)], θ[(S * T + S + 1):end]
        )
        return sum(abs2, run(CR.Depletion(N; pools), R, ones(S, 3)))
    end
    θ = [vec(R0); [1.0e3, 2.0e3, 3.0e3]; [990.0, 1990.0, 2990.0]]
    N, pools = strata_parts([1.0e3, 2.0e3, 3.0e3], [990.0, 1990.0, 2990.0])
    @test built_by_rule(N, (), pools)
    @test check_build(strata, θ)
    # No pieces, a number population.
    nopieces(θ) = sum(abs2, run(CR.Depletion(θ[end]), θ[1:T], ones(3)))
    @test built_by_rule(500.0, (), nothing)
    @test check_build(nopieces, [R1; 500.0])
    # Weighted hazard and floor draws with float exponents, number pools and
    # a flow between them.
    for Form in (CR.Hazard, CR.Floor)
        draw(α, σ, h) = (
            Form(α; weights = (S = 1, V = σ)),
            CR.Flow(:S => :V, TimeVarying(h); form = CR.Share()),
        )
        function weighted(θ)
            R, α, σ = θ[1:T], θ[T + 1], θ[T + 2]
            N, h = θ[T + 3], θ[(T + 4):end]
            dep = CR.Depletion(
                N, draw(α, σ, h)...; pools = (S = 0.9 * N, V = 0.1 * N)
            )
            return sum(abs2, run(dep, R, ones(3)))
        end
        @test built_by_rule(500.0, draw(1.5, 0.4, series(5)), (S = 1.0, V = 1.0))
        @test check_build(weighted, [R1; 1.5; 0.4; 500.0; series(5)])
    end
    # A truncated draw into a pool, which fills it up to the population.
    fill_parts(κ) = (
        CR.Truncate(κ; into = :V), CR.Flow(:S => :V, 0.05; form = CR.Share()),
    )
    function into(θ)
        R, κ, N = θ[1:T], θ[T + 1], θ[T + 2]
        dep = CR.Depletion(
            N, fill_parts(κ)...; pools = (S = 0.5 * N, V = 0.1 * N)
        )
        return sum(abs2, run(dep, R, ones(3)))
    end
    @test built_by_rule(400.0, fill_parts(0.4), (S = 1.0, V = 1.0))
    @test check_build(into, [R1; 0.4; 400.0])
    # A truncated draw with a softness, between two runs of flows.
    trunc_parts(κ, a) = (
        CR.Flow(0 => :S, TimeVarying(a); form = CR.Truncate()),
        CR.Truncate(κ),
        CR.Flow(:S => 0, 0.02; form = CR.Share()),
    )
    function truncated(θ)
        R, κ, a = θ[1:T], θ[T + 1], θ[(T + 2):end]
        dep = CR.Depletion(trunc_parts(κ, a)...; pools = (S = 50.0,))
        return sum(abs2, run(dep, R, ones(3)))
    end
    @test built_by_rule(nothing, trunc_parts(0.5, series(2)), (S = 50.0,))
    @test check_build(truncated, [R1; 0.5; 0.3 .* series(2)])
end
