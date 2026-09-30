# Interfaces.jl declarations: the package's own implementations pass, and a
# modifier defined outside the package can declare and test its own.

@testitem "Interfaces: package implementations" begin
    using ComposableRecurrences, Interfaces, LinearAlgebra, SparseArrays
    CR = ComposableRecurrences
    @test Interfaces.test(ComposableRecurrences; show = false)
    @test Interfaces.implements(CR.OperatorInterface, Recurrence)
    @test Interfaces.implements(CR.OperatorInterface, Convolution)
    @test Interfaces.implements(CR.CouplingInterface, UniformScaling)
    @test Interfaces.implements(CR.CouplingInterface, Matrix{Float64})
    @test Interfaces.implements(CR.CouplingInterface, Diagonal{Float64, Vector{Float64}})
    @test Interfaces.implements(CR.CouplingInterface, Pairwise)
    @test Interfaces.implements(CR.CouplingInterface, TimeVarying)
    # A sparse coupling is an AbstractMatrix; test it explicitly.
    K = sparse([1, 2, 3], [1, 3, 2], [0.5, 0.2, 0.9], 3, 3)
    obj = Interfaces.Arguments(; coupling = K, p = [1.0, 2.0, 3.0], window = ones(2, 3), t = 1)
    @test Interfaces.test(CR.CouplingInterface, typeof(K), (obj,); show = false)
end

@testitem "Interfaces: a user-defined modifier" setup = [TestModifiers] begin
    using ComposableRecurrences, Interfaces
    CR = ComposableRecurrences
    objs = (
        Interfaces.Arguments(;
            modifier = FlooredDepletion([10.0, 20.0]), history = ones(2, 3),
            v = [1.0, 2.0], t = 1
        ),
    )
    @test Interfaces.test(CR.ModifierInterface{(:pointwise,)}, FlooredDepletion, objs; show = false)
    objs = (
        Interfaces.Arguments(;
            modifier = Scale(2.0), history = ones(2, 3), v = [1.0, 2.0], t = 1
        ),
    )
    @test Interfaces.test(CR.ModifierInterface, Scale, objs; show = false)
end

@testitem "param_eltype recurses through fields" setup = [TestModifiers] begin
    using ComposableRecurrences, ForwardDiff, LinearAlgebra
    CR = ComposableRecurrences
    D = ForwardDiff.Dual{Nothing, Float64, 1}
    d = ForwardDiff.Dual{Nothing}(1.0, 1.0)
    @test CR.param_eltype(LooseScale(1.0f0, (; b = 2))) == Float32
    @test CR.param_eltype(LooseScale(1.0, (; b = d))) == D
    @test CR.param_eltype((1.0f0, [d])) == D
    @test CR.param_eltype(Recurrence([1.0f0]; coupling = 2.0I)) == Float64
    @test CR.param_eltype(nothing) == Bool
    @test CR.param_eltype(HistoryTotal()) == Bool
end

@testitem "NoAdjoint forwards to the operator" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    r = Recurrence([0.2, 0.3, 0.5])
    R = fill(1.1, 8)
    @test CR.NoAdjoint(r)(R; history = ones(3)) == r(R; history = ones(3))
    c = Convolution([0.5, 0.5])
    @test CR.NoAdjoint(c)(R) == c(R)
end
