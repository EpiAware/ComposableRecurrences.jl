# Checks that loading Reactant loads the package's Reactant extension, that
# the extension adds no method ambiguities, and that it still checks a traced
# coefficient's shape. Run by `runtests.jl` in its own process, as the
# probes are, so the runner does not load Reactant.
using ComposableRecurrences, Reactant, Test

const EXT = Base.get_extension(
    ComposableRecurrences, :ComposableRecurrencesReactantExt
)
@testset "Reactant extension" begin
    @test EXT !== nothing
    @test isempty(Test.detect_ambiguities(ComposableRecurrences, EXT))
end

# A traced coefficient skips only the check that its entries are `Real`: a
# traced PerStratum is still a vector or a matrix.
@testset "Reactant traced coefficient shapes" begin
    check(x) = (ComposableRecurrences._check_coefficient(PerStratum(x)); sum(x))
    x3 = Reactant.to_rarray(zeros(2, 2, 2))
    @test_throws ArgumentError Reactant.@compile check(x3)
    # A matrix compiles: the test is only that the call does not throw.
    x2 = Reactant.to_rarray(zeros(2, 3))
    @test Reactant.@compile(check(x2)) isa Any
end
