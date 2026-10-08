# A buffer deeper than the kernel: `depth` sets how many past outputs the
# recurrence keeps. A piece that reads nothing from the deeper rows leaves
# the output unchanged; the state holds the deeper rows.

@testsnippet DeepBuffer begin
    using ComposableRecurrences: ComposableRecurrences as CR

    # Passes the value through and asks for a buffer `w` steps deep.
    struct Deep
        w::Int
    end
    CR.ispointwise(::Deep) = true
    CR.forward(::Deep, ::CR.Step, v, s, t, k) = (v, s)
    CR.depth(m::Deep) = m.w

    # The same, as a vector step, so the step collects every stratum.
    struct DeepVector
        w::Int
    end
    CR.forward(::DeepVector, ::CR.Step, v, s, t) = nothing
    CR.pullback!(grads, ::DeepVector, ::CR.Step, v, s, t) = nothing
    CR.depth(m::DeepVector) = m.w
end

@testitem "depth: default walk and recursion" setup = [DeepBuffer] begin
    using LinearAlgebra
    @test CR.depth(1.0) == 0
    @test CR.depth([1.0, 2.0]) == 0
    @test CR.depth(I) == 0
    @test CR.depth(CR.Clamp(0.0, 1.0)) == 0
    @test CR.depth((Deep(3), (; a = Deep(7), b = 2.0))) == 7
    @test CR.depth(()) == 0
    @test @inferred(CR.depth((CR.Clamp(0.0, 1.0), Deep(3)))) == 3
end

@testitem "depth: a deeper buffer leaves the output unchanged" setup = [DeepBuffer] begin
    using ComposableRecurrences, LinearAlgebra, Random
    rng = Xoshiro(11)
    S, L, T = 3, 3, 10
    g = rand(rng, L)
    K = rand(rng, S, S) ./ S
    h = rand(rng, S, 2L)
    R = 0.5 .+ rand(rng, S, T)
    gt = 0.3 .* rand(rng, L, T)
    kernels = (
        g, PerStratum(rand(rng, S, L)), Pairwise(0.2 .* rand(rng, S, S, L)),
        TimeVarying(gt), TimeVarying(gt, CR.Primary()),
    )
    for kernel in kernels, C in (I, Diagonal(rand(rng, S)), K)
        kernel isa Pairwise && C !== I && continue
        # A Primary() kernel reads columns from time 1, so runs unseeded.
        hk = kernel isa TimeVarying{CR.Primary} ? nothing : h
        base = Recurrence(kernel; coupling = C)(R; history = hk)
        for m in (Deep(2L + 1), DeepVector(2L + 1), Deep(1))
            deep = Recurrence(kernel; coupling = C, modifiers = (m,))
            @test deep(R; history = hk) ≈ base
        end
    end
    # A single series, with the history shorter than the buffer.
    y = Recurrence(g)(R[1, :]; history = h[1, 1:2])
    @test Recurrence(g; modifiers = (Deep(8),))(R[1, :]; history = h[1, 1:2]) ≈ y
end

@testitem "depth: the state holds the deeper buffer and resumes" setup = [DeepBuffer] begin
    using ComposableRecurrences, Random
    rng = Xoshiro(12)
    S, L, T, D = 2, 3, 9, 7
    g = rand(rng, L)
    h = rand(rng, S, D + 2)
    R = 0.5 .+ rand(rng, S, T)
    r = Recurrence(g; modifiers = (Deep(D),))
    y = r(R; history = h)
    y1, st = CR.with_state(r, R; history = h, stop = 4)
    @test size(st.history) == (S, D)
    @test st.history ≈ hcat(h, y1)[:, (end - D + 1):end]
    @test hcat(y1, r(R; state = st)) ≈ y
    # Without a deeper piece the state holds the kernel length.
    _, st = CR.with_state(Recurrence(g), R; history = h, stop = 4)
    @test size(st.history) == (S, L)
end

@testitem "depth: an invalid depth names the value" setup = [DeepBuffer] begin
    using ComposableRecurrences
    struct BadDepth end
    CR.ispointwise(::BadDepth) = true
    CR.forward(::BadDepth, ::CR.Step, v, s, t, k) = (v, s)
    CR.depth(::BadDepth) = -2
    r = Recurrence([0.5, 0.5]; modifiers = (BadDepth(),))
    err = try
        r(ones(4); history = ones(2))
    catch e
        e
    end
    @test err isa ArgumentError
    @test occursin("-2", err.msg)
    @test occursin("BadDepth", err.msg)
end

@testitem "depth: the reverse pass reads the deeper buffer" setup = [AdjointCheck, DeepBuffer] begin
    using ComposableRecurrences, LinearAlgebra, Random
    rng = Xoshiro(13)
    S, L, T, D = 3, 3, 8, 6
    g = rand(rng, L)
    K = rand(rng, S, S) ./ S
    h = rand(rng, S, D + 1)
    R = 0.5 .+ rand(rng, S, T)
    gt = 0.3 .* rand(rng, L, T)
    for kernel in (g, PerStratum(rand(rng, S, L)), TimeVarying(gt))
        for C in (I, K), m in (Deep(D), DeepVector(D))
            r = Recurrence(kernel; coupling = C, modifiers = (m,))
            @test pullback_matches(r, recargs(R, nothing, h)...)
            @test pullback_matches(CR._WithState(r), recargs(R, nothing, h)...)
        end
    end
end
