# A buffer deeper than the kernel: `depth` sets how many past outputs the
# recurrence keeps. A modifier that reads nothing from the deeper rows leaves
# the output unchanged; the state holds the deeper rows.

@testsnippet DeepBuffer begin
    using ComposableRecurrences: ComposableRecurrences as CR

    # Passes the value through and asks for a buffer `w` steps deep.
    struct Deep
        w::Int
    end
    CR.blocks(::Deep) = (1, 1)
    CR.forward!(::Deep, ::CR.Step, v, s, t) = nothing
    CR.depth(m::Deep) = m.w

    # The same, as a vector step, so the step collects every stratum.
    struct DeepVector
        w::Int
    end
    CR.forward!(::DeepVector, ::CR.Step, v, s, t) = nothing
    CR.pullback!(grads, ::DeepVector, ::CR.Step, v, s, t) = nothing
    CR.depth(m::DeepVector) = m.w

    # Checks the reverse pass of each kernel in `which` against ForwardDiff,
    # with a buffer deeper than the kernel. The kernels are split across
    # test items so they run in parallel; each item draws the same inputs.
    function deep_reverse_matches(which)
        rng = Xoshiro(13)
        S, L, T, D = 3, 3, 8, 6
        g = rand(rng, L)
        K = rand(rng, S, S) ./ S
        h = rand(rng, S, D + 1)
        R = 0.5 .+ rand(rng, S, T)
        gt = 0.3 .* rand(rng, L, T)
        ragged = [0.3 .* rand(rng, 1 + mod(t, L)) for t in 1:T]
        kernels = (
            g, PerStratum(rand(rng, S, L)), Pairwise(0.2 .* rand(rng, S, S, L)),
            TimeVarying(gt), TimeVarying(PerStratum(0.3 .* rand(rng, S, L, T))),
            TimeVarying(Pairwise(0.1 .* rand(rng, S, S, L, T))), TimeVarying(ragged),
            TimeVarying(gt, CR.Primary()), TimeVarying(ragged, CR.Primary()),
        )
        for (i, kernel) in enumerate(kernels)
            couplings = (I, Diagonal(rand(rng, S)), K)
            i in which || continue
            for C in couplings
                kernel isa Union{Pairwise, TimeVarying{<:Any, <:Pairwise}} &&
                    C !== I && continue
                primary = kernel isa TimeVarying{CR.Primary}
                # Histories longer than the buffer, between the kernel and
                # the buffer, and shorter than the kernel; a Primary() kernel
                # runs unseeded.
                hs = primary ? (zeros(S, 0),) : (h, h[:, 1:(L + 1)], h[:, 1:1])
                for m in (Deep(D), DeepVector(D)), hk in hs
                    r = Recurrence(kernel; coupling = C, modifiers = (m,))
                    @test pullback_matches(r, recargs(R, nothing, hk)...)
                    @test pullback_matches(CR._WithState(r), recargs(R, nothing, hk)...)
                end
            end
        end
        return nothing
    end
end

@testitem "depth: default walk and recursion" setup = [DeepBuffer] begin
    using LinearAlgebra
    # Each kind of leaf reads nothing.
    for x in (1.0, 2, [1.0], nothing, :a, "a", Float64, Base, sin)
        @test CR.depth(x) === 0
    end
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
    y1, st = r(R; history = h, stop = 4, state = true)
    @test size(st.history) == (S, D)
    @test st.history ≈ hcat(h, y1)[:, (end - D + 1):end]
    @test hcat(y1, first(r(R; state = st))) ≈ y
    # Without a deeper modifier the state holds the kernel length.
    _, st = Recurrence(g)(R; history = h, stop = 4, state = true)
    @test size(st.history) == (S, L)
end

@testitem "depth: an invalid depth names the value" setup = [DeepBuffer] begin
    using ComposableRecurrences
    struct BadDepth end
    CR.blocks(::BadDepth) = (1, 1)
    CR.forward!(::BadDepth, ::CR.Step, v, s, t) = nothing
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

@testitem "depth: the reverse pass reads the deeper buffer, fixed kernels" setup = [AdjointCheck, DeepBuffer] begin
    using ComposableRecurrences, LinearAlgebra, Random
    deep_reverse_matches(1:3)
end

@testitem "depth: the reverse pass reads the deeper buffer, time-varying kernels" setup = [AdjointCheck, DeepBuffer] begin
    using ComposableRecurrences, LinearAlgebra, Random
    deep_reverse_matches(4:6)
end

@testitem "depth: the reverse pass reads the deeper buffer, ragged and Primary kernels" setup = [AdjointCheck, DeepBuffer] begin
    using ComposableRecurrences, LinearAlgebra, Random
    deep_reverse_matches(7:9)
end

@testitem "depth: the threaded reverse pass reads the deeper buffer" setup = [AdjointCheck, DeepBuffer] begin
    using ComposableRecurrences, LinearAlgebra, Random
    using Base.ScopedValues: with
    rng = Xoshiro(14)
    S, L, T, D = 4, 3, 8, 6
    K = rand(rng, S, S) ./ S
    h = rand(rng, S, D + 1)
    R = 0.5 .+ rand(rng, S, T)
    kernels = (
        rand(rng, L), PerStratum(rand(rng, S, L)), TimeVarying(0.3 .* rand(rng, L, T)),
        Pairwise(0.2 .* rand(rng, S, S, L)),
    )
    # Pointwise modifiers with `I` take the independent path; a dense
    # coupling or a vector step takes the per-step one.
    with(CR.EXECUTOR => CR.Threaded(; min_work = 0, ntasks = 2)) do
        for kernel in kernels, C in (I, K), m in (Deep(D), DeepVector(D))
            kernel isa Pairwise && C !== I && continue
            r = Recurrence(kernel; coupling = C, modifiers = (m,))
            splits = CR._SPLIT_BLOCKS[]
            @test pullback_matches(r, recargs(R, nothing, h)...)
            @test pullback_matches(r, recargs(R, nothing, h[:, 1:1])...)
            # A pairwise kernel with a vector step runs every reverse step on
            # the calling task.
            serial = kernel isa Pairwise && m isa DeepVector
            @test (CR._SPLIT_BLOCKS[] > splits) == !serial
        end
    end
end

@testitem "depth: a coupling or kernel can deepen the buffer" setup = [DeepBuffer] begin
    using ComposableRecurrences, LinearAlgebra
    struct DeepCoupling
        C::Matrix{Float64}
    end
    function CR.forward!(c::DeepCoupling, ::CR.Pressure, q, p, t)
        q .= c.C * p
        return nothing
    end
    CR.depth(::DeepCoupling) = 6
    K = [0.9 0.1; 0.2 0.8]
    R = fill(1.1, 2, 8)
    h = ones(2, 7)
    y, st = Recurrence([0.5, 0.3]; coupling = DeepCoupling(K))(R; history = h, state = true)
    @test size(st.history) == (2, 6)
    @test y ≈ Recurrence([0.5, 0.3]; coupling = K)(R; history = h)
end

@testitem "depth: the walk skips mutable and undefined fields" setup = [DeepBuffer] begin
    mutable struct Node
        next::Any
        w::Deep
        Node() = new()
    end
    n = Node()
    @test CR.depth(n) == 0
    n.next = n
    n.w = Deep(4)
    @test CR.depth(n) == 0
    struct Holder{T}
        x::T
    end
    @test CR.depth(Holder(Deep(5))) == 5
    @test CR.depth(Holder{Any}(Deep(5))) == 5
end

@testitem "depth: a deep call infers" setup = [DeepBuffer] begin
    using ComposableRecurrences
    r = Recurrence([0.5, 0.3]; modifiers = (Deep(6),))
    @test @inferred(r(fill(1.1, 2, 8); history = ones(2, 7))) isa Matrix{Float64}
    @test @inferred(CR._buffer_depth(r, 2)) == 6
end
