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

# The occupancy case's `handrule` arm is the backend's own Mooncake rule, a
# primitive Mooncake calls. At both realistic sizes every pool stays off its
# floor after the first day, so the arms meet no tie, and the package,
# `NoAdjoint` and `handrule` gradients match ForwardDiff on the hand loop.
@testitem "The occupancy case's arms agree off the pools' floors" tags = [:ad, :mooncake_reverse] begin
    using ADFixtures: MatrixCases as MC
    using ADTypes: AutoMooncake
    import DifferentiationInterface as DI
    import ForwardDiff, Mooncake

    R = MC.BVDRef
    V = Vector{Float64}
    sig = Tuple{typeof(R.accumulate_occupancy), V, V, V, V, V, Float64, V}
    @test Mooncake.is_primitive(
        Mooncake.DefaultCtx, Mooncake.ReverseMode, sig, Base.get_world_counter()
    )
    inside = R._OCC_UNCONF | R._OCC_DENOM | R._OCC_BVD | R._OCC_BG |
        R._OCC_CONF_X | R._OCC_SUSP
    c = only(x for x in MC.CASES if x.name == "bvd_occupancy")
    backend = AutoMooncake(; config = nothing)
    for T in (200, 400)
        z = MC.Size(; T, L = 1)
        loop, θ = MC.build(c, z, "loop")
        args = MC._unpack(θ, (T,), (T,), (T,), (T,), (T,), (1,), (T,))
        _, _, flags = R._accumulate_occupancy(
            Val(true), map(collect, args[1:5])..., args[6][1], collect(args[7])
        )
        @test all(==(inside), flags[2:end])
        ref = ForwardDiff.gradient(loop, θ)
        for arm in ("rule", "NoAdjoint", "handrule")
            f, θarm = MC.build(c, z, arm)
            @test θarm == θ
            @test f(θ) ≈ loop(θ)
            prep = DI.prepare_gradient(f, backend, copy(θ))
            @test DI.gradient(f, prep, backend, θ) ≈ ref rtol = 1.0e-8
        end
    end
end
