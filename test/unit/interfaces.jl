# Interfaces.jl declarations: the package's own pieces pass, and pieces
# defined outside the package (a modifier, a coupling) declare and test
# their own.

@testitem "Interfaces: package pieces" begin
    using ComposableRecurrences, Interfaces, LinearAlgebra, SparseArrays
    CR = ComposableRecurrences
    @test Interfaces.test(ComposableRecurrences; show = false)
    for T in (
            Recurrence, Convolution, UniformScaling, Matrix{Float64},
            Diagonal{Float64, Vector{Float64}}, TimeVarying, CR.Pool,
            CR.Hazard, CR.Floor, CR.Add, CR.Redistribute, CR.Clamp,
            CR.Truncate, CR.SoftTruncate,
        )
        @test Interfaces.implements(CR.PieceInterface, T)
    end
    # A sparse coupling is an AbstractMatrix; test it explicitly.
    K = sparse([1, 2, 3], [1, 3, 2], [0.5, 0.2, 0.9], 3, 3)
    obj = Interfaces.Arguments(;
        piece = K, role = CR.Pressure(), args = (zeros(3), [1.0, 2.0, 3.0], 1)
    )
    @test Interfaces.test(CR.PieceInterface, typeof(K), (obj,); show = false)
end

@testitem "Interfaces: user pieces" setup = [TestModifiers] begin
    using ComposableRecurrences, Interfaces
    CR = ComposableRecurrences
    objs = (
        Interfaces.Arguments(;
            piece = FlooredDepletion([10.0, 20.0]), role = CR.Init(),
            args = (zeros(2), ones(2, 3))
        ),
        Interfaces.Arguments(;
            piece = FlooredDepletion([10.0, 20.0]), role = CR.Step(),
            args = ([1.0, 2.0], [10.0, 20.0], 1)
        ),
    )
    @test Interfaces.test(CR.PieceInterface{(:pointwise,)}, FlooredDepletion, objs; show = false)
    objs = (
        Interfaces.Arguments(;
            piece = Scale(2.0), role = CR.Step(), args = ([1.0, 2.0], [0.0, 0.0], 1)
        ),
    )
    @test Interfaces.test(CR.PieceInterface, Scale, objs; show = false)
    # A coupling is any struct with forward! on Pressure().
    struct Twice end
    function CR.forward!(::Twice, ::CR.Pressure, q, p, t)
        q .= 2 .* p
        return nothing
    end
    objs = (
        Interfaces.Arguments(;
            piece = Twice(), role = CR.Pressure(), args = (zeros(2), [1.0, 2.0], 1)
        ),
    )
    @test Interfaces.test(CR.PieceInterface, Twice, objs; show = false)
    g = [0.5, 0.5]
    @test Recurrence(g; coupling = Twice())(ones(2, 4); history = ones(2, 2)) ≈
        Recurrence(g; coupling = [2.0 0.0; 0.0 2.0])(ones(2, 4); history = ones(2, 2))
end

@testitem "Interfaces: a pullback! the rule cannot find fails" begin
    using ComposableRecurrences, Interfaces
    CR = ComposableRecurrences
    struct Halving end
    CR.ispointwise(::Halving) = true
    function CR.forward!(::Halving, ::CR.Step, v, s, t)
        for k in eachindex(v, s)
            v[k], s[k] = v[k] / 2, s[k]
        end
        return nothing
    end
    obj = Interfaces.Arguments(; piece = Halving(), role = CR.Step(), args = ([2.0], [0.0], 1))
    @test Interfaces.test(CR.PieceInterface, Halving, (obj,); show = false)
    # A typed method is missed by `uses_adjoint`, so the rule would drop it.
    function CR.pullback!(
            grads, ::Halving, ::CR.Step, v::AbstractVector, s::AbstractVector, t
        )
        for k in eachindex(v, s)
            grads.v[k], grads.s[k] = grads.v[k] / 2, grads.s[k]
        end
        return nothing
    end
    @test !CR.uses_adjoint(Halving(), CR.Step())
    @test !Interfaces.test(CR.PieceInterface, Halving, (obj,); show = false)
    # Declaring it, or writing the method with untyped arguments, passes.
    CR.uses_adjoint(::Halving, ::CR.Step) = true
    @test Interfaces.test(CR.PieceInterface, Halving, (obj,); show = false)
    struct Third end
    CR.ispointwise(::Third) = true
    function CR.forward!(::Third, ::CR.Step, v, s, t)
        for k in eachindex(v, s)
            v[k], s[k] = v[k] / 3, s[k]
        end
        return nothing
    end
    function CR.pullback!(grads, ::Third, ::CR.Step, v, s, t)
        for k in eachindex(v, s)
            grads.v[k], grads.s[k] = grads.v[k] / 3, grads.s[k]
        end
        return nothing
    end
    obj = Interfaces.Arguments(; piece = Third(), role = CR.Step(), args = ([3.0], [0.0], 1))
    @test CR.uses_adjoint(Third(), CR.Step())
    @test Interfaces.test(CR.PieceInterface, Third, (obj,); show = false)
end

@testitem "Interfaces: a step that returns instead of writing fails" begin
    using ComposableRecurrences, Interfaces
    CR = ComposableRecurrences
    # A step that returns its new value and state instead of writing them.
    struct Returning end
    CR.ispointwise(::Returning) = true
    CR.forward!(::Returning, ::CR.Step, v, s, t) = (2 * first(v), first(s))
    r = Recurrence([0.5, 0.5]; modifiers = (Returning(),))
    @test_throws ArgumentError r(ones(4); history = ones(2))
    err = try
        r(ones(4); history = ones(2))
    catch e
        e
    end
    @test occursin("return nothing", err.msg)
    obj = Interfaces.Arguments(; piece = Returning(), role = CR.Step(), args = ([2.0], [0.0], 1))
    @test !Interfaces.test(CR.PieceInterface, Returning, (obj,); show = false)
end

@testitem "Interfaces: a pointwise step may broadcast" begin
    using ComposableRecurrences, Interfaces
    CR = ComposableRecurrences
    # The same step written with an out-of-place broadcast and with a loop.
    struct Broadcasting{A}
        a::A
    end
    struct Looping{A}
        a::A
    end
    CR.ispointwise(::Union{Broadcasting, Looping}) = true
    function CR.forward!(m::Broadcasting, ::CR.Step, v, s, t)
        w = m.a .* v
        s .+= w
        v .= w
        return nothing
    end
    function CR.forward!(m::Looping, ::CR.Step, v, s, t)
        for k in eachindex(v, s)
            v[k] *= m.a
            s[k] += v[k]
        end
        return nothing
    end
    R, h = fill(1.1, 2, 6), [1.0 2.0; 3.0 1.0]
    run(m) = Recurrence([0.5, 0.5]; modifiers = (m,))(R; history = h)
    @test run(Broadcasting(0.9)) == run(Looping(0.9))
    obj = Interfaces.Arguments(;
        piece = Broadcasting(0.9), role = CR.Step(), args = ([2.0, 1.0], [0.0, 1.0], 1)
    )
    @test Interfaces.test(CR.PieceInterface{(:pointwise,)}, Broadcasting, (obj,); show = false)
end

@testitem "Interfaces: a pointwise step that broadcasts a per-stratum field fails" begin
    using ComposableRecurrences, Interfaces
    CR = ComposableRecurrences
    # A field with one entry per stratum, broadcast against the values: it
    # cannot run on one stratum's view, so the check fails and the call
    # throws, rather than either reading the wrong entries.
    struct Weights{W}
        w::W
    end
    CR.ispointwise(::Weights) = true
    function CR.forward!(m::Weights, ::CR.Step, v, s, t)
        v .*= m.w
        return nothing
    end
    obj = Interfaces.Arguments(;
        piece = Weights([0.5, 2.0]), role = CR.Step(), args = ([1.0, 1.0], [0.0, 0.0], 1)
    )
    @test !Interfaces.test(CR.PieceInterface{(:pointwise,)}, Weights, (obj,); show = false)
    r = Recurrence([0.5, 0.5]; modifiers = (Weights([0.5, 2.0]),))
    @test_throws DimensionMismatch r(ones(2, 3); history = ones(2, 2))
end

@testitem "Interfaces: state length" begin
    using ComposableRecurrences, Interfaces, LinearAlgebra
    CR = ComposableRecurrences
    # A protected pool keeps two entries per stratum.
    d = CR.Pool(
        100.0; pools = (:S, :V), draw = (:S => 1, :V => 0.3) => CR.Hazard(),
        flows = (CR.Flow(1 => 2, 1.0; form = CR.Truncate()),)
    )
    objs = (
        Interfaces.Arguments(; piece = d, role = CR.Init(), args = (zeros(4), ones(2, 3))),
        Interfaces.Arguments(;
            piece = d, role = CR.Step(), args = ([1.0, 2.0], [90.0, 80.0, 5.0, 6.0], 1)
        ),
    )
    @test Interfaces.test(CR.PieceInterface{(:nstate,)}, CR.Pool, objs; show = false)
    # A pointwise modifier that claims more than one entry per stratum fails.
    struct DoubleState end
    CR.ispointwise(::DoubleState) = true
    CR.nstate(::DoubleState, S) = 2S
    function CR.forward!(m::DoubleState, ::CR.Step, v, s, t)
        for k in eachindex(v)
            v[k], s[k] = v[k], s[k]
        end
        return nothing
    end
    obj = Interfaces.Arguments(;
        piece = DoubleState(), role = CR.Step(), args = ([1.0, 2.0], zeros(4), 1)
    )
    @test !Interfaces.test(
        CR.PieceInterface{(:nstate,)}, DoubleState, (obj,); show = false
    )
    # A state that does not match nstate fails.
    obj = Interfaces.Arguments(;
        piece = CR.Clamp(0.0, 1.0), role = CR.Step(), args = ([1.0, 2.0], zeros(3), 1)
    )
    @test !Interfaces.test(
        CR.PieceInterface{(:nstate,)}, CR.Clamp, (obj,); show = false
    )
    # Roles other than Init and Step have no state to check.
    obj = Interfaces.Arguments(;
        piece = 0.5I, role = CR.Pressure(), args = (zeros(2), [1.0, 2.0], 1)
    )
    @test Interfaces.test(
        CR.PieceInterface{(:nstate,)}, UniformScaling, (obj,); show = false
    )
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

@testitem "param_eltype infers through nested structs" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    struct Outer{T}
        x::T
    end
    struct Inner{A, B, C}
        a::A
        b::B
        c::C
    end
    struct Leaf end
    # An inner struct or tuple with more fields than the outer one.
    x = (Outer((Inner(Leaf(), 1.0f0, (Leaf(), 2.0, (; c = 3.0f0))),)),)
    @test (@inferred CR.param_eltype(x)) == Float64
    @test (@inferred CR.param_eltype(Outer(Leaf()))) == Bool
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
