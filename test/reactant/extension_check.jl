# Checks that loading Reactant loads the package's Reactant extension and
# that the extension adds no method ambiguities. Run by `runtests.jl` in its
# own process, as the probes are, so the runner does not load Reactant.
using ComposableRecurrences, Reactant, Test

const EXT = Base.get_extension(
    ComposableRecurrences, :ComposableRecurrencesReactantExt
)
@testset "Reactant extension" begin
    @test EXT !== nothing
    @test isempty(Test.detect_ambiguities(ComposableRecurrences, EXT))
end
