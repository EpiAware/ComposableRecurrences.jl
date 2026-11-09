# Float precision of a whole model: `f32`, `f64` and `f16` convert every
# float a model holds, scalars included, so its output keeps that type.

@testitem "Precision: f32 converts every float a model holds" begin
    using ComposableRecurrences, LinearAlgebra
    using ComposableRecurrences: Depletion, Hazard, Transform, f16, f32, f64
    g = [0.4, 0.3, 0.2, 0.1]
    R = fill(1.05, 3, 12)
    h = ones(3, 4)
    r = Recurrence(
        g; coupling = 0.5I,
        modifiers = (Depletion(60.0, Hazard(2.0)), Transform(+, 0.1))
    )
    # The scalar fields promote a Float32 call to Float64 as written.
    @test eltype(r(Float32.(R); history = Float32.(h))) == Float64
    r32 = f32(r)
    y32 = r32(f32(R); history = f32(h))
    @test eltype(y32) == Float32
    @test y32 ≈ r(R; history = h) rtol = 1.0e-4
    @test eltype(f64(r32)(R; history = h)) == Float64
    @test eltype(f16(r)(f16(R); history = f16(h))) == Float16
    @test typeof(f64(r32)) == typeof(r)
end

@testitem "Precision: f32 keeps integers, numbers that are not floats and structure" begin
    using ComposableRecurrences, ForwardDiff, SparseArrays, LinearAlgebra
    using ComposableRecurrences: f32
    x = (
        a = 1.5, n = 3, b = true, s = :S, v = [1.0, 2.0], i = [1, 2],
        r = 1:3, sp = sparse([1.0 0.0; 0.0 2.0]), dg = Diagonal([1.0, 2.0]),
        nested = [[1.0], [2.0, 3.0]], d = ForwardDiff.Dual(1.0, 2.0),
        p = :a => 0.5, f = sin,
    )
    y = f32(x)
    @test y.a === 1.5f0
    @test y.n === 3 && y.b === true && y.s === :S && y.f === sin
    @test y.v isa Vector{Float32} && y.i === x.i && y.r === x.r
    @test y.sp isa SparseMatrixCSC{Float32} && y.dg isa Diagonal{Float32}
    @test y.nested isa Vector{Vector{Float32}}
    @test y.d === x.d
    @test y.p === (:a => 0.5f0)
end

@testitem "Precision: f32 keeps device arrays on the device" begin
    using ComposableRecurrences, Adapt, JLArrays
    using ComposableRecurrences: f32
    r = adapt(JLArray, Recurrence(PerStratum(ones(3, 4) ./ 8)))
    y = f32(r)(JLArray(fill(1.1f0, 3, 10)); history = JLArray(ones(Float32, 3, 4)))
    @test y isa JLArray{Float32}
end
