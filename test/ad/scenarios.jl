# PACKAGE-OWNED — scaffold writes this once and never overwrites it.
#
# Per-backend AD gradient test items. Each backend is its own `@testitem`,
# tagged so the per-backend CI can select it with a tag filter (e.g. `julia
# test/ad/runtests.jl enzyme_reverse`). Harness wiring lives in the managed
# `setup.jl`; the SCENARIOS come from the package's own `ADFixtures`
# registry. This starter seed covers every backend the kit knows about; add
# or trim backends and categories to match the package afterwards.

@testitem "ForwardDiff gradients" tags = [:ad, :forwarddiff] setup = [ADHelpers] begin
    test_working_backend("ForwardDiff"; category = :tests)
end

@testitem "ReverseDiff (tape) gradients" tags = [:ad, :reversediff] setup = [ADHelpers] begin
    test_working_backend("ReverseDiff (tape)"; category = :tests)
end

@testitem "ReverseDiff (compiled) gradients" tags = [:ad, :reversediff_compiled] setup = [ADHelpers] begin
    test_working_backend("ReverseDiff (compiled)"; category = :tests)
end

@testitem "Enzyme forward gradients" tags = [:ad, :enzyme, :enzyme_forward] setup = [ADHelpers] begin
    test_working_backend("Enzyme forward"; category = :tests)
end

# Tagged `compat_floor`, so the Threads workflow runs it on Julia 1.11.
@testitem "Enzyme reverse gradients" tags = [:ad, :enzyme, :enzyme_reverse, :compat_floor] setup = [ADHelpers] begin
    test_working_backend("Enzyme reverse"; category = :reverse_tests)
end

@testitem "Mooncake reverse gradients" tags = [:ad, :mooncake, :mooncake_reverse] setup = [ADHelpers] begin
    test_working_backend("Mooncake reverse"; category = :reverse_tests)
end

@testitem "Mooncake forward gradients" tags = [:ad, :mooncake, :mooncake_forward] setup = [ADHelpers] begin
    test_working_backend("Mooncake forward"; category = :tests)
end

# Each registry scenario's gradient on a reverse-mode backend runs the
# analytic reverse pass, and no `NoAdjoint` twin's does. Test items run in
# file order, so these follow the registry items and reuse the gradients
# they compiled.
@testitem "Mooncake reverse: every AD scenario fires its rule and no twin does" tags = [:ad, :mooncake, :mooncake_reverse] setup = [AdjointCases] begin
    using ADTypes: AutoMooncake
    import Mooncake
    test_rules_fire("Mooncake reverse", AutoMooncake(; config = nothing))
end

# Tagged `compat_floor`, so the Threads workflow runs it on Julia 1.11.
@testitem "Enzyme reverse: every AD scenario fires its rule and no twin does" tags = [:ad, :enzyme, :enzyme_reverse, :compat_floor] setup = [AdjointCases] begin
    using ADTypes: AutoEnzyme
    import Enzyme
    test_rules_fire(
        "Enzyme reverse",
        AutoEnzyme(;
            mode = Enzyme.set_runtime_activity(Enzyme.Reverse),
            function_annotation = Enzyme.Const
        )
    )
end

# Add latent (or other) scenario groups as the package needs, e.g.:
# @testitem "ForwardDiff gradients (latent)" tags = [:ad, :forwarddiff] setup = [ADHelpers] begin
#     test_working_backend("ForwardDiff"; category = :latent)
# end

# The registry leaves out scenarios and matrix cases whose features the loaded
# version lacks, for the benchmark history on older releases. On the current
# version nothing may be left out, so a misspelt requirement fails here.
@testitem "AD fixtures need only features this version has" tags = [:ad, :forwarddiff] begin
    using ADFixtures
    using ADFixtures: MatrixCases
    @test isempty(ADFixtures.unsupported_scenarios())
    @test all(MatrixCases.available(c, arm) for c in MatrixCases.CASES for arm in MatrixCases.arms(c))
    @test MatrixCases.LOCAL_CASES ⊆ Set(c.name for c in MatrixCases.CASES)
    @test length(ADFixtures.scenarios()) == 2 * length(ADFixtures._SCENARIOS)
    # Each twin the gradient tests run names a scenario, once.
    names = Set(first.(ADFixtures._SCENARIOS))
    tested, rev = ADFixtures._TESTED_TWINS, ADFixtures._REVERSE_TWINS
    @test all(in(names), tested)
    @test all(in(names), rev)
    @test isempty(intersect(tested, rev))
    @test length(ADFixtures.scenarios(; category = :tests)) ==
        length(ADFixtures._SCENARIOS) + length(tested)
    @test length(ADFixtures.scenarios(; category = :reverse_tests)) ==
        length(ADFixtures._SCENARIOS) + length(tested) + length(rev)
end
