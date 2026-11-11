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
    )
    @test Set(keys(sigs)) == Set(MC.TUTORIAL_HANDRULE_CASES)
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
