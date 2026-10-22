# Interfaces.jl declarations: the package's own pieces pass, and pieces
# defined outside the package (a modifier, a coupling) declare and test
# their own.

@testitem "Interfaces: package pieces" begin
    using ComposableRecurrences, Interfaces, LinearAlgebra, SparseArrays
    CR = ComposableRecurrences
    @test Interfaces.test(ComposableRecurrences; show = false)
    for T in (
            Recurrence, Convolution, UniformScaling, Matrix{Float64},
            Diagonal{Float64, Vector{Float64}}, TimeVarying, CR.Depletion,
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

@testitem "Interfaces: one-entry views under bounds checks" begin
    # Base reads a view through its linear indices, which must be the
    # stratum's own; a run with bounds checks on catches any that are not.
    script = """
    using ComposableRecurrences
    const CR = ComposableRecurrences
    a, b = CR._At([1.0, 2.0, 3.0], 2), CR._At(Ref(0.0), 2)
    copyto!(b, a)
    c = b[2]
    b .= 2 .* a
    fill!(a, 4.0)
    struct Broadcasting end
    CR.ispointwise(::Broadcasting) = true
    function CR.forward!(::Broadcasting, ::CR.Step, v, s, t)
        w = 0.5 .* v
        s .+= w
        v .= w
        return nothing
    end
    struct Looping end
    CR.ispointwise(::Looping) = true
    function CR.forward!(::Looping, ::CR.Step, v, s, t)
        for k in eachindex(v, s)
            v[k] *= 0.5
            s[k] += v[k]
        end
        return nothing
    end
    run(m) = Recurrence([0.5, 0.5]; modifiers = (m,))(ones(3, 4); history = ones(3, 2))
    print(c, " ", b[2], " ", sum(a), " ", a.parent, " ", run(Broadcasting()) == run(Looping()))
    """
    cmd = `$(Base.julia_cmd()) --startup-file=no --check-bounds=yes --project=$(Base.active_project()) -e $script`
    @test readchomp(cmd) == "2.0 4.0 4.0 [1.0, 4.0, 3.0] true"
end

@testitem "Interfaces: eachindex of two one-entry views" begin
    const CR = ComposableRecurrences
    a, b = CR._At([1.0, 2.0, 3.0], 2), CR._At(Ref(0.0), 2)
    @test eachindex(a, b) == 2:2
    @test collect(eachindex(a, b)) == collect(eachindex(a))
    @test_throws DimensionMismatch eachindex(a, CR._At(Ref(0.0), 3))
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
    d = CR.Depletion(
        100.0, CR.Hazard(; weights = (S = 1, V = 0.3)),
        CR.Flow(1 => 2, 1.0; form = CR.Truncate()); pools = (:S, :V)
    )
    objs = (
        Interfaces.Arguments(; piece = d, role = CR.Init(), args = (zeros(4), ones(2, 3))),
        Interfaces.Arguments(;
            piece = d, role = CR.Step(), args = ([1.0, 2.0], [90.0, 80.0, 5.0, 6.0], 1)
        ),
    )
    @test Interfaces.test(CR.PieceInterface{(:nstate,)}, CR.Depletion, objs; show = false)
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
    # A tuple wider than a variadic `promote_type` infers.
    @test (@inferred CR.param_eltype(ntuple(i -> Float32(i), Val(40)))) == Float32
    @test (@inferred CR.param_eltype((ntuple(Float32, Val(39))..., 1.0))) == Float64
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

@testitem "Interfaces: the built-ins' steps behind forward!" begin
    using ComposableRecurrences, LinearAlgebra
    CR = ComposableRecurrences
    # The built-in pointwise modifiers and forms implement forward! and
    # pullback! as a user's pieces do, and the operators reach them through
    # the same step on one stratum's view.
    pool = CR.Depletion(
        100.0, CR.Hazard(), CR.Flow(0 => 1, 2.0; form = CR.Truncate()); pools = (:S,)
    )
    for m in (CR.Depletion(PerStratum([100.0, 80.0])), pool)
        v, s = [2.0, 3.0], [70.0, 60.0]
        CR.forward!(m, CR.Step(), v, s, 1)
        @test (v[2], s[2]) == CR._step(m, 3.0, 60.0, 1, 2)
        g = (; piece = nothing, v = [1.0, 1.0], s = [0.5, 0.5])
        CR.pullback!(g, m, CR.Step(), [2.0, 3.0], [70.0, 60.0], 1)
        @test (g.v[2], g.s[2]) == CR._step_back(
            (; piece = nothing, v = 1.0, s = 0.5), m, 3.0, 60.0, 1, 2
        )
    end
    grads = (; piece = (; b = Ref(0.0)), v = 1.0, s = 0.5)
    @test CR._step_back(grads, CR.Add(1.0), 2.0, 0.0, 1, 1) == (1.0, 0.5)
    @test grads.piece.b[] == 1.0
    grads = (; piece = (; lo = Ref(0.0), hi = Ref(0.0)), v = 1.0, s = 0.0)
    @test CR._step_back(grads, CR.Clamp(0.0, 1.0), 2.0, 0.0, 1, 1) == (0.0, 0.0)
    @test grads.piece.hi[] == 1.0
    # A form's public in-place step and pullback match its kernels; the
    # exponent's cotangent, summed over the entries, goes to the form's
    # mirror.
    for form in (CR.Hazard(1.0), CR.Floor(1.0), CR.Truncate(), CR.SoftTruncate(0.1))
        v, s = [2.0, 3.0], [80.0, 1.5]
        CR.forward!(form, CR.Step(), v, s, 100.0)
        @test (v[2], s[2]) == CR._draw(form, 3.0, 1.5, 100.0)
        ᾱ = (; α = Ref(0.0))
        g = (; piece = ᾱ, v = [1.0, 1.0], s = [0.5, 0.5], N = zeros(2))
        CR.pullback!(g, form, CR.Step(), [2.0, 3.0], [80.0, 1.5], 100.0)
        ᾱ1, ᾱ2 = (; α = Ref(0.0)), (; α = Ref(0.0))
        CR._draw_back((; piece = ᾱ1, v = 1.0, s = 0.5), form, 2.0, 80.0, 100.0)
        v̄, s̄, N̄ = CR._draw_back(
            (; piece = ᾱ2, v = 1.0, s = 0.5), form, 3.0, 1.5, 100.0
        )
        @test (g.v[2], g.s[2], g.N[2], ᾱ.α[]) == (v̄, s̄, N̄, ᾱ1.α[] + ᾱ2.α[])
    end
    # A diagonal coupling scales each stratum's pressure.
    q = zeros(2)
    CR.forward!(Diagonal([0.5, 2.0]), CR.Pressure(), q, [2.0, 3.0], 1)
    @test q == [1.0, 6.0]
end

@testitem "Interfaces: the generic steps on a user type's views" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    # A pointwise modifier, a blockwise one and a depletion form, each with
    # an in-place step and pullback, run through the generic kernels.
    struct Halve end
    CR.ispointwise(::Halve) = true
    function CR.forward!(::Halve, ::CR.Step, v, s, t)
        for k in eachindex(v, s)
            v[k], s[k] = v[k] / 2, s[k] + v[k] / 2
        end
        return nothing
    end
    function CR.pullback!(grads, ::Halve, ::CR.Step, v, s, t)
        for k in eachindex(v, s)
            grads.v[k] = (grads.v[k] + grads.s[k]) / 2
        end
        return nothing
    end
    @test CR.uses_adjoint(Halve(), CR.Step())
    @test CR._step(Halve(), 2.0, 1.0, 1, 3) == (1.0, 2.0)
    pointwise = (; piece = nothing, v = 1.0, s = 1.0)
    @test CR._step_back(pointwise, Halve(), 2.0, 1.0, 1, 3) == (1.0, 1.0)
    struct Swap end
    CR.blocks(::Swap) = Val((2, 0))
    function CR.forward!(::Swap, ::CR.Step, v::Tuple, s::Tuple, t, g)
        v[1][], v[2][] = v[2][], v[1][]
        return nothing
    end
    function CR.pullback!(grads, ::Swap, ::CR.Step, v::Tuple, s::Tuple, t, g)
        grads.v[1][], grads.v[2][] = grads.v[2][], grads.v[1][]
        return nothing
    end
    @test CR._block_step(Swap(), (1.0, 2.0), (), 1, 2) == ((2.0, 1.0), ())
    blockwise = (; piece = nothing, v = (3.0, 4.0), s = ())
    @test CR._block_back(blockwise, Swap(), (1.0, 2.0), (), 1, 2) == ((4.0, 3.0), ())
    struct Half end
    function CR.forward!(::Half, ::CR.Step, v, s, N)
        for i in eachindex(v, s)
            v[i], s[i] = v[i] / 2, s[i] - v[i] / 2
        end
        return nothing
    end
    function CR.pullback!(grads, ::Half, ::CR.Step, v, s, N)
        for i in eachindex(v, s)
            grads.v[i] = (grads.v[i] - grads.s[i]) / 2
        end
        return nothing
    end
    @test CR._draw(Half(), 2.0, 5.0, 100.0) == (1.0, 4.0)
    form = (; piece = nothing, v = 1.0, s = 0.5)
    @test CR._draw_back(form, Half(), 2.0, 5.0, 100.0) == (0.25, 0.5, 0.0)
    # Copies, maps and broadcasts of a one-entry view are views of the same
    # entry.
    a = CR._At(Ref(2.0), 3)
    @test copy(a)[3] == 2.0
    @test map(x -> 3x, a)[3] == 6.0
    @test (2 .* a)[3] == 4.0
    err = try
        a[1]
    catch e
        e
    end
    @test err isa ArgumentError
    @test occursin("eachindex(v)", err.msg)
end

@testitem "Interfaces: a pointwise step that loops over 1:length(v) says why it fails" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    # A step on one stratum's view sees the index `k`, not `1`, so a loop
    # over `1:length(v)` reaches outside it for every stratum but the first.
    struct OneBased end
    CR.ispointwise(::OneBased) = true
    function CR.forward!(::OneBased, ::CR.Step, v, s, t)
        for i in 1:length(v)
            v[i] *= 2
        end
        return nothing
    end
    r = Recurrence([0.5, 0.5]; modifiers = (OneBased(),))
    err = try
        r(ones(2, 3); history = ones(2, 2))
    catch e
        e
    end
    @test err isa ArgumentError
    @test occursin("eachindex(v)", err.msg)
end

@testitem "Interfaces: a modifier with no step says it needs forward!" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    # A type made a modifier without a `forward!` for `Step()`, and not
    # blockwise, has no step to run.
    struct NoStep end
    @test_throws "has no forward!(m, Step(), v, s, t)" CR.forward!(
        NoStep(), CR.Step(), [1.0, 2.0], [0.0, 0.0], 1
    )
end
