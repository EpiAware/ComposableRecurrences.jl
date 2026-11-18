# Checks that loading Reactant and KernelAbstractions loads the package's
# Reactant extension, that the extension adds no method ambiguities, and
# that it still checks a traced coefficient's shape, says CUDA.jl is needed
# when it is not loaded, compiles a program that does not grow with the
# number of strata, and launches kernels from `TRACED_MIN_STRATA` strata. Run by `runtests.jl` in
# its own process, as the probes are, so the runner does not load Reactant.
using ComposableRecurrences, Reactant, KernelAbstractions, CUDA, Enzyme, Test
using Base.ScopedValues: with

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

# Reactant compiles the kernels through CUDA.jl, so a traced call without it
# says to load it.
@testset "Reactant traced call needs CUDA.jl" begin
    err = try
        EXT._require_cuda(nothing)
    catch e
        e
    end
    @test err isa ArgumentError
    @test occursin("using CUDA", sprint(showerror, err))
    @test EXT._require_cuda(Base.get_extension(Reactant, :ReactantCUDAExt)) === nothing
end

# Strata that read one another, through a dense coupling and a depletion,
# compile to much the same program at 4 and at 32 strata, forward and
# reverse, when every loop runs as a kernel: XLA's choices vary a few
# operations with the sizes, where written-out strata loops added some 30 a
# stratum.
@testset "Reactant program size does not grow with the strata" begin
    function nops(S, reverse)
        R = [0.9 + 0.2 * k / S + 0.01 * t for k in 1:S, t in 1:6]
        h = [1.0 + k / S + 0.1 * i for k in 1:S, i in 1:4]
        K = [i == j ? 0.8 : 0.2 / S for i in 1:S, j in 1:S]
        d = ComposableRecurrences.Depletion(PerStratum(fill(1.0e3, S)))
        f(g) = sum(Recurrence(g; coupling = K, modifiers = (d,))(R; history = h))
        g = Reactant.to_rarray([0.4, 0.3, 0.2, 0.1])
        grad(g) = Enzyme.gradient(Enzyme.Reverse, f, g)
        m = if reverse
            Reactant.@code_hlo raise = true raise_first = true grad(g)
        else
            Reactant.@code_hlo f(g)
        end
        return count(l -> occursin("stablehlo.", l), split(string(m), '\n'))
    end
    with(ComposableRecurrences.TRACED_MIN_STRATA => 1) do
        @test nops(32, false) <= 1.1 * nops(4, false)
        @test nops(32, true) <= 1.1 * nops(4, true)
    end
end

# A loop over fewer strata than `TRACED_MIN_STRATA` is written out, and one
# over as many runs as a kernel.
@testset "Reactant kernel from TRACED_MIN_STRATA strata" begin
    function kernels(S)
        R = fill(1.0, S, 6)
        h = fill(1.0, S, 4)
        K = [i == j ? 0.8 : 0.2 / S for i in 1:S, j in 1:S]
        f(g) = Recurrence(g; coupling = K)(R; history = h)
        g = Reactant.to_rarray([0.4, 0.3, 0.2, 0.1])
        m = Reactant.@code_hlo optimize = false f(g)
        return count(l -> occursin("kernel_call", l), split(string(m), '\n'))
    end
    with(ComposableRecurrences.TRACED_MIN_STRATA => 4) do
        @test kernels(3) == 0
        @test kernels(4) > 0
    end
end
