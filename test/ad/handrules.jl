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
        "strata_waning" =>
            Tuple{typeof(TH.waning_handrule), V, M, M, M, Float64, M, V},
        "strata_routes" => Tuple{
            typeof(TH.routes_handrule), M, V, V, V, M, M, Vector{Int},
            Vector{Int}, V,
        },
        "ward_flows" =>
            Tuple{typeof(TH.ward_handrule), M, V, V, Float64, M},
        "overview" => Tuple{typeof(TH.overview_handrule), M, M, V, M, V, V},
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

# The caps on the doses and the transfers and the floor on the share left
# are branches the matrix's smooth inputs may not reach; each rule is
# checked on inputs that take both sides of its branch.
@testitem "The tutorials' hand-written Mooncake rules take both sides of their caps and floor" tags = [:ad, :mooncake_reverse] begin
    using ADFixtures: MatrixCases as MC
    using Random: Xoshiro
    import Mooncake

    TH = MC.TH
    check(f, args...) = Mooncake.TestUtils.test_rule(
        Xoshiro(1), f, args...;
        is_primitive = true, perf_flag = :none, mode = Mooncake.ReverseMode
    )
    S, L, T = 3, 4, 12
    g = [0.4, 0.3, 0.2, 0.1]
    wave = [sin(a + 0.7t) for a in 1:S, t in 1:T]
    # Large doses on alternate days empty the susceptible pool.
    h, R = fill(20.0, S, L), 1.2 .+ 0.2 .* wave
    doses = [isodd(t) ? 1.0e4 : 5.0 + a for a in 1:S, t in 1:T]
    ω, N = 0.05 .+ 0.01 .* wave, fill(1.0e3, S)
    st = TH._waning_state(g, h, R, doses, 0.3, ω, N)
    @test any(iszero, st.sus0) && any(>(0), st.sus0[:, 2:end])
    check(TH.waning_handrule, g, h, R, doses, 0.3, ω, N)
    # A high reproduction number draws the pool below the floor.
    K2 = MC._ring(S)
    K1 = [a == b ? 0.6 : 0.2 for a in 1:S, b in 1:S]
    v, g2 = fill(0.1, length(K2.nzval)), [0.6, 0.4]
    pop = [300.0, 400.0, 500.0]
    R2 = 3.0 .+ 0.5 .* wave
    args = (K1, g, v, g2, h, R2, K2.colptr, K2.rowval, pop)
    pools = TH._routes_state(args...).pools
    @test any(pools ./ pop .< 1.0e-6) && any(pools ./ pop .> 1.0e-6)
    check(TH.routes_handrule, args...)
    # Large transfers on alternate days empty the confirmed beds.
    adm = 10.0 .+ 2.0 .* vcat(wave, wave)
    transfer = [isodd(t) ? 1.0e3 : 0.5 for a in 1:S, t in 1:T]
    ward = (adm, [0.5, 0.7, 0.9], fill(0.05, T), 0.2, transfer)
    con = TH.ward_handrule(ward...)[(S + 1):end, :]
    @test any(iszero, con) && any(>(0), con)
    check(TH.ward_handrule, ward...)
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

@testitem "The window-weights and window-reports cases' arms agree at the backend's sizes" tags = [:ad, :mooncake_reverse] begin
    using ADFixtures: MatrixCases as MC
    using ADTypes: AutoMooncake
    import DifferentiationInterface as DI
    import ForwardDiff, Mooncake

    B = MC.BVD
    V = Vector{Int}
    sig = Tuple{typeof(B.zone_window_weights), Vector{Float64}, V, V, Int}
    @test Mooncake.is_primitive(
        Mooncake.MinimalCtx, Mooncake.ReverseMode, sig, Base.get_world_counter()
    )
    backend = AutoMooncake(; config = nothing)
    for (name, S) in (
                ("bvd_window_weights", 1), ("bvd_window_reports", 5),
                ("bvd_window_reports", 11),
            ), (T, L) in ((161, 45), (202, 50), (60, 10))
        c = only(x for x in MC.CASES if x.name == name)
        z = MC.Size(; T, L, S)
        loop, θ = MC.build(c, z, "loop")
        ref = ForwardDiff.gradient(loop, θ)
        for arm in ("rule", "NoAdjoint", "handrule")
            f, θarm = MC.build(c, z, arm)
            @test θarm == θ
            @test f(θ) ≈ loop(θ)
            prep = DI.prepare_gradient(f, backend, copy(θ))
            @test DI.gradient(f, prep, backend, θ) ≈ ref rtol = 1.0e-10
        end
    end
    # Both of the helper's paths, against a plain sum over the days in range:
    # windows that close before day 1, empty windows, windows past the last
    # day, and windows that leave gaps.
    y = [Float64(10k + t) for k in 1:2, t in 1:9]
    plain(a, b) = [sum(y[k, max(a, 1):min(b, 9)]; init = 0.0) for k in 1:2]
    for (starts, stops) in (
            ([1, 3], [2, 9]), ([1, 1, 1, 4], [-2, 0, 3, 9]),
            ([1, 4, 4, 10, 12], [3, 3, 9, 9, 9]), ([2, 4, 8], [3, 7, 7]),
            ([5], [9]),
        )
        @test MC._window_sums(y, starts, stops) ==
            reduce(hcat, [plain(a, b) for (a, b) in zip(starts, stops)])
    end
end

@testitem "The abscond-flow, two-clock, patch and onset port cases' arms agree with the backend's rules" tags = [:ad, :mooncake_reverse] begin
    using ADFixtures: MatrixCases as MC
    using ADTypes: AutoMooncake
    import DifferentiationInterface as DI
    import ForwardDiff, Mooncake

    R = MC.BVDRef
    P = MC.BVDPort
    V = Vector{Float64}
    M = Matrix{Float64}
    world = Base.get_world_counter()
    for sig in (
            Tuple{typeof(R.abscond_thinned_flows), V, V, V, V, Float64, V},
            Tuple{typeof(R.two_clock_confirmed), V, V, V},
            Tuple{typeof(R.patch_infections), M, V, M, M, M, V},
            Tuple{typeof(R.onset_report_cdf_table), V, V, Int, Int, Int},
            # The port's own helpers, so a rule arm times the code it names.
            Tuple{typeof(P.occupancy_outputs), M, Float64},
            Tuple{typeof(P.abscond_inputs), V, V, V, V, V},
            Tuple{typeof(P.hold_last), V, Int},
            Tuple{typeof(P.split_rows), M},
            Tuple{typeof(P.patch_outputs), M, M, M},
            Tuple{typeof(P.onset_offsets), V, Int, Int},
        )
        @test Mooncake.is_primitive(
            Mooncake.MinimalCtx, Mooncake.ReverseMode, sig, world
        )
    end
    backend = AutoMooncake(; config = nothing)
    for (name, S) in (
                ("bvd_abscond_port", 1), ("bvd_two_clock_port", 1),
                ("bvd_patches_port", 3), ("bvd_patches_port", 11),
                ("bvd_onset_port", 1),
            ), (T, L) in ((268, 60), (200, 20), (40, 10))
        c = only(x for x in MC.CASES if x.name == name)
        z = MC.Size(; T, L, S)
        hand, θ = MC.build(c, z, "handrule")
        ref = ForwardDiff.gradient(hand, θ)
        for arm in ("rule", "NoAdjoint", "handrule")
            f, θarm = MC.build(c, z, arm)
            @test θarm == θ
            @test f(θ) ≈ hand(θ)
            prep = DI.prepare_gradient(f, backend, copy(θ))
            @test DI.gradient(f, prep, backend, θ) ≈ ref rtol = 1.0e-10
        end
    end
end
