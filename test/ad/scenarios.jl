# PACKAGE-OWNED — scaffold writes this once and never overwrites it.
#
# Per-backend AD gradient test items. Each backend is its own `@testitem`,
# tagged so the per-backend CI can select it with a tag filter (e.g. `julia
# test/ad/runtests.jl enzyme_reverse`). Harness wiring lives in the managed
# `setup.jl`; the SCENARIOS come from the package's own `ADFixtures`
# registry, and the entrywise checks from `checks.jl`. This starter seed
# covers every backend the kit knows about; add or trim backends and
# categories to match the package afterwards.

@testitem "ForwardDiff gradients" tags = [:ad, :forwarddiff] setup = [ADHelpers, GradientChecks] begin
    test_gradients("ForwardDiff"; category = :rules)
end

@testitem "ReverseDiff (tape) gradients" tags = [:ad, :reversediff] setup = [ADHelpers, GradientChecks] begin
    test_gradients("ReverseDiff (tape)"; category = :rules)
end

@testitem "ReverseDiff (compiled) gradients" tags = [:ad, :reversediff_compiled] setup = [ADHelpers, GradientChecks] begin
    test_gradients("ReverseDiff (compiled)"; category = :rules)
end

@testitem "Enzyme forward gradients" tags = [:ad, :enzyme, :enzyme_forward] setup = [ADHelpers, GradientChecks] begin
    test_gradients("Enzyme forward"; category = :rules)
end

# Tagged `compat_floor`, so the Threads workflow runs it on Julia 1.11.
@testitem "Enzyme reverse gradients" tags = [:ad, :enzyme, :enzyme_reverse, :compat_floor] setup = [ADHelpers, GradientChecks] begin
    test_gradients("Enzyme reverse"; category = :marginal)
end

@testitem "Mooncake reverse gradients" tags = [:ad, :mooncake, :mooncake_reverse] setup = [ADHelpers, GradientChecks] begin
    test_gradients("Mooncake reverse"; category = :marginal)
end

@testitem "Mooncake forward gradients" tags = [:ad, :mooncake, :mooncake_forward] setup = [ADHelpers, GradientChecks] begin
    test_gradients("Mooncake forward"; category = :rules)
end

# The ForwardDiff reference every backend is checked against matches
# central differences, so a wrong reference cannot pass every backend. Each
# entry is checked to the differences' precision.
@testitem "ForwardDiff reference against central differences" tags = [:ad, :forwarddiff] setup = [ADHelpers, GradientChecks] begin
    scens = ADFixtures.scenarios(; with_reference = true, category = :rules)
    @testset "$(s.name)" for s in scens
        @test matches_differences(s.f, s.x, s.res1; rtol = 1.0e-5, atol_share = 1.0e-5)
    end
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

# The backends without a rule of their own run the scenarios without their
# twins, so these two twins run the `NoAdjoint` wrapper's own call and its
# `contributions` method there.
@testitem "Without a rule: the NoAdjoint wrapper's own calls" tags = [:ad, :forwarddiff, :reversediff, :reversediff_compiled, :enzyme, :enzyme_forward, :mooncake, :mooncake_forward] setup = [ADHelpers, GradientChecks, JobBackends] begin
    twins = ("NoAdjoint Recurrence renewal", "NoAdjoint Convolution lag contributions")
    scens = filter(s -> s.name in twins, ADFixtures.scenarios(; with_reference = true))
    @test length(scens) == length(twins)
    names = job_backends(
        :forwarddiff => "ForwardDiff",
        :reversediff => "ReverseDiff (tape)",
        :reversediff_compiled => "ReverseDiff (compiled)",
        :enzyme_forward => "Enzyme forward",
        :mooncake_forward => "Mooncake forward",
    )
    backends = [b.backend for b in ADFixtures.backends() if b.name in names]
    rtol = ADFixtures.GRADIENT_RTOL
    DIT.test_differentiation(
        backends, scens; correctness = true, type_stability = :none,
        logging = false, rtol, atol = 0.0
    )
    @testset "$(s.name) on $(nameof(typeof(b))), entry by entry" for s in scens, b in backends
        @test entrywise(DI.gradient(s.f, b, s.x), s.res1; rtol)
    end
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
    # The forward modes, ForwardDiff and ReverseDiff test the scenarios
    # without their twins.
    rules = ADFixtures.scenarios(; category = :rules)
    @test length(rules) == length(ADFixtures._SCENARIOS)
    @test all(s -> !startswith(s.name, "NoAdjoint"), rules)
end
