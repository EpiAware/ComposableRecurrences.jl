# The benchmark matrix's `handrule` arms for the tutorials: each hand-written
# Mooncake rule is a primitive Mooncake calls, and the arm's Mooncake
# gradient matches ForwardDiff on the same case's plain hand loop.
@testitem "The tutorials' hand-written Mooncake rules match ForwardDiff on their hand loops" tags = [:ad, :mooncake_reverse] begin
    using ADFixtures: MatrixCases as MC
    using ADTypes: AutoMooncake
    import DifferentiationInterface as DI
    import ForwardDiff, Mooncake

    TH = MC.TH
    V, M = Vector{Float64}, Matrix{Float64}
    sigs = Dict(
        "ar" => Tuple{typeof(TH.ar2_handrule), V, V, V},
        "renewal_depletion" =>
            Tuple{typeof(TH.depletion_handrule), V, V, V, Float64},
        "renewal_imports" =>
            Tuple{typeof(TH.imports_handrule), V, V, V, V, V, Float64},
        "transform" => Tuple{typeof(TH.transform_handrule), V, M, V, V, Int},
        "delay_primary" =>
            Tuple{typeof(TH.delay_primary_handrule), V, Int, Int, Int},
        "outcome_chain" => Tuple{typeof(TH.outcomes_handrule), V, V, V, V, V},
        "renewal_forecast" => Tuple{typeof(TH.forecast_handrule), V, V, V},
        "reproduction" =>
            Tuple{typeof(TH.reproduction_handrule), V, M, M, M, V},
        "reproduction_pressure" =>
            Tuple{typeof(TH.reproduction_handrule), V, M, M, M, V},
    )
    @test Set(keys(sigs)) == Set(MC.TUTORIAL_HANDRULE_CASES)
    # The report runs without the fixtures, so it keeps its own list of
    # these cases; it must name the same ones.
    report = read(
        joinpath(pkgdir(MC.CR), "benchmark", "matrix_report.jl"), String
    )
    block = match(r"const HAND_RULE_CASES = Set\(\s*\[(.*?)\]"s, report)
    @test block !== nothing
    listed = Set(m.captures[1] for m in eachmatch(r"\"(\w+)\"", block[1]))
    @test listed == Set(MC.TUTORIAL_HANDRULE_CASES)
    world = Base.get_world_counter()
    backend = AutoMooncake(; config = nothing)
    for name in MC.TUTORIAL_HANDRULE_CASES
        @test Mooncake.is_primitive(
            Mooncake.DefaultCtx, Mooncake.ReverseMode, sigs[name], world
        )
        c = only(x for x in MC.CASES if x.name == name)
        larger = MC.Size(; T = 60, L = 7, S = c.strata[end])
        for z in (first(MC.sizes(c, "smoke")), larger)
            f, θ = MC.build(c, z, "handrule")
            loop, θloop = MC.build(c, z, "loop")
            @test θ == θloop
            @test f(θ) ≈ loop(θ)
            prep = DI.prepare_gradient(f, backend, copy(θ))
            g = DI.gradient(f, prep, backend, θ)
            @test g ≈ ForwardDiff.gradient(loop, θ) rtol = 1.0e-10
        end
    end
end

# The transform case's package arm passes the closed-form derivative of its
# map to the `Transform`, as the tutorial does; that derivative matches
# ForwardDiff's, and the arm's Mooncake gradient matches ForwardDiff on the
# plain hand loop.
@testitem "The transform case's closed-form derivative matches ForwardDiff" tags = [:ad, :mooncake_reverse] begin
    using ADFixtures: MatrixCases as MC
    using ADTypes: AutoMooncake
    import DifferentiationInterface as DI
    import ForwardDiff

    for (q, r, p) in ((0.0, 0.5, 0.3), (0.4, 1.7, 0.6), (0.9, 0.2, 0.8))
        ∂q, ∂θ = MC._nb_pgf_derivative(q, (; r, p))
        ref = ForwardDiff.gradient(x -> MC._nb_pgf(x[1], (; r = x[2], p = x[3])), [q, r, p])
        @test [∂q, ∂θ.r, ∂θ.p] ≈ ref rtol = 1.0e-12
    end
    c = only(x for x in MC.CASES if x.name == "transform")
    backend = AutoMooncake(; config = nothing)
    for z in (first(MC.sizes(c, "smoke")), MC.Size(; T = 60, L = 7, S = 5))
        f, θ = MC.build(c, z, "rule")
        loop, θloop = MC.build(c, z, "loop")
        @test θ == θloop
        @test f(θ) ≈ loop(θ)
        prep = DI.prepare_gradient(f, backend, copy(θ))
        @test DI.gradient(f, prep, backend, θ) ≈ ForwardDiff.gradient(loop, θ) rtol = 1.0e-10
    end
end
