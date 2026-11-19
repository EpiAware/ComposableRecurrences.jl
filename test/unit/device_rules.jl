# The package's own rules on device arrays, run on JLArrays without a GPU:
# a fixed convolution and a recurrence of independent strata, or of strata
# mixed by a dense coupling, with or without built-in pointwise modifiers,
# run their forward pass and their pullback on the device, without scalar
# indexing, and give the CPU's cotangents; calls whose reverse pass needs the
# host keep plain AD. AD backends cannot differentiate JLArrays themselves,
# so the rule passes run directly.

@testsnippet DeviceRules begin
    using ComposableRecurrences
    using Adapt: adapt
    using JLArrays
    using LinearAlgebra: Diagonal, I
    const CR = ComposableRecurrences
    JLArrays.allowscalar(false)

    T, L = 30, 5
    pmf = collect(range(1.0, 2.0; length = L)) ./ (1.5L)
    inputs(S) = 1 .+ 0.5 .* abs.(sin.((1:S) .+ (1:T)'))
    weights(S) = cos.((1:S) .* 0.3 .+ (1:T)' .* 0.1)

    # The operator, its rule arguments and a zero mirror for its parameters,
    # for `S` strata, on the host or on JLArrays.
    function convolution_case(kernel, S, dev)
        op = dev ? adapt(JLArray, Convolution(kernel)) : Convolution(kernel)
        x = dev ? JLArray(inputs(S)) : inputs(S)
        return op, (x, true, nothing, nothing, 1, nothing)
    end
    # A coupling that mixes every pair of strata.
    dense(S) = Matrix(0.5I, S, S) .+ 0.5 / S
    function recurrence_case(coupling, S, dev; kernel = pmf, start = 1)
        r = Recurrence(kernel; coupling)
        op = dev ? adapt(JLArray, r) : r
        x, h = inputs(S), fill(1.0, S, L)
        x, h = dev ? (JLArray(x), JLArray(h)) : (x, h)
        args = CR._run_args(op, x, h, nothing, nothing, start)
        return op, (args..., nothing)
    end

    # Time-varying kernels, one for every stratum or one per stratum.
    tv_kernel() = TimeVarying(pmf .* (1 .+ 0.1 .* sin.((1:L) .+ (1:T)')))
    by_output(k::TimeVarying) = TimeVarying(k.x, CR.Primary())
    function tv_per_stratum(S)
        G = [
            pmf[i] * (1 + 0.1 * sin(a + i + t)) for a in 1:S, i in 1:L, t in 1:T
        ]
        return TimeVarying(PerStratum(G))
    end

    # A recurrence with modifiers `ms`, as `recurrence_case` builds one.
    function modified_case(ms, S, dev)
        r = Recurrence(pmf; modifiers = ms)
        op = dev ? adapt(JLArray, r) : r
        x, h = inputs(S), fill(1.0, S, L)
        x, h = dev ? (JLArray(x), JLArray(h)) : (x, h)
        args = CR._run_args(op, x, h, nothing, nothing, 1)
        return op, (args..., nothing)
    end
    # A pool every stratum shares, with a flow out, and one per stratum.
    function pools(S)
        flow = CR.Flow(:S => 0, 0.1; form = CR.Share())
        return (
            CR.Depletion(200.0, CR.Hazard(), flow),
            CR.Depletion(PerStratum(fill(150.0, S)), CR.Floor()),
        )
    end

    # Modifiers whose steps run per group.
    function two_pools(S)
        hazard = CR.Hazard(; weights = (S = 1, V = 0.5))
        rate = PerStratum(fill(0.5, S))
        doses = CR.Flow(:S => :V, rate; form = CR.Truncate())
        return CR.Depletion(
            PerStratum(fill(60.0, S)), hazard, doses; pools = (:S, :V)
        )
    end
    function two_draws()
        flow = CR.Flow(:S => 0, 0.1; form = CR.Share())
        return CR.Depletion(
            60.0, CR.Hazard(), flow, CR.Floor(); pools = (S = 50.0,)
        )
    end
    function queued()
        flow = CR.Flow(0 => :B, 2.0; form = CR.Truncate())
        return CR.Depletion(
            flow, CR.Truncate(; overflow = :queue); pools = (B = 50.0,)
        )
    end
    function totals(S)
        h = S ÷ 2
        return CR.Allocate([1:h, (h + 1):S], PerStratum(fill(1.0, 2)))
    end

    # A cotangent with the shape of `y`, the same on the host and the
    # device for outputs of one shape.
    cotangent_like(y) = cos.(0.37 .* reshape(1:length(y), size(y)))
    # The input's cotangent and the parameter mirror after the rule's
    # forward pass and pullback with output cotangent `weights(S)`, or for a
    # run from a later start, which `shorter` says to expect, one of its
    # shape.
    function rule_cotangents(op, args, piece, S, dev; shorter = false)
        y, cache = CR._run_forward(op, args...)
        @test size(y) == (S, shorter ? T - L : T)
        W = shorter ? cotangent_like(y) : weights(S)
        Ȳ = dev ? JLArray(W) : W
        x̄ = zero(args[1])
        rest = map(_ -> nothing, Base.tail(args))
        CR._run_pullback!((; piece, y = Ȳ, args = (x̄, rest...)), op, cache)
        return Array(y), Array(x̄), piece
    end
    # Whether the mirrors `a` (device) and `b` (host) hold the same values.
    agree(a::AbstractArray, b::AbstractArray) = Array(a) ≈ b
    agree(a::Base.RefValue, b::Base.RefValue) = a[] ≈ b[]
    agree(a::Union{Tuple, NamedTuple}, b::Union{Tuple, NamedTuple}) =
        all(map(agree, values(a), values(b)))
    agree(::Nothing, ::Nothing) = true
end

@testitem "JLArrays: the rule passes of a fixed convolution and of a recurrence match the CPU" setup = [DeviceRules] begin
    # More strata than blocks, so the blocks' copies of the shared kernel
    # cotangent are summed.
    for S in (4, CR._KERNEL_BLOCKS + 1)
        cases = [
            "vector kernel" => (
                dev -> convolution_case(pmf, S, dev),
                dev -> (; kernel = dev ? JLArray(zeros(L)) : zeros(L)),
            ),
            "per-stratum kernel" => (
                dev -> convolution_case(PerStratum(repeat(pmf', S)), S, dev),
                dev -> (;
                    kernel = (; x = dev ? JLArray(zeros(S, L)) : zeros(S, L)),
                ),
            ),
            "recurrence, per-stratum kernel" => (
                dev -> recurrence_case(
                    I, S, dev; kernel = PerStratum(repeat(pmf', S))
                ),
                dev -> (;
                    kernel = (; x = dev ? JLArray(zeros(S, L)) : zeros(S, L)),
                ),
            ),
            "recurrence, identity coupling" => (
                dev -> recurrence_case(I, S, dev),
                dev -> (; kernel = dev ? JLArray(zeros(L)) : zeros(L)),
            ),
            "recurrence, diagonal coupling" => (
                dev -> recurrence_case(Diagonal(fill(0.8, S)), S, dev),
                dev -> (;
                    kernel = dev ? JLArray(zeros(L)) : zeros(L),
                    coupling = (; diag = dev ? JLArray(zeros(S)) : zeros(S)),
                ),
            ),
            "recurrence, dense coupling" => (
                dev -> recurrence_case(dense(S), S, dev),
                dev -> (;
                    kernel = dev ? JLArray(zeros(L)) : zeros(L),
                    coupling = dev ? JLArray(zeros(S, S)) : zeros(S, S),
                ),
            ),
            "recurrence, scalar coupling" => (
                dev -> recurrence_case(0.8I, S, dev),
                dev -> (;
                    kernel = dev ? JLArray(zeros(L)) : zeros(L),
                    coupling = (; λ = Ref(0.0)),
                ),
            ),
        ]
        @testset "$name, $S strata" for (name, (case, mirror)) in cases
            host = rule_cotangents(case(false)..., mirror(false), S, false)
            y0, x̄0, p̄0 = host
            y1, x̄1, p̄1 = rule_cotangents(case(true)..., mirror(true), S, true)
            @test y1 ≈ y0
            @test x̄1 ≈ x̄0
            @test agree(p̄1, p̄0)
        end
    end
end

@testitem "JLArrays: the rule passes of a convolution with gain and add match the CPU" setup = [DeviceRules] begin
    # The output, and the cotangents of the input, gain, add input and
    # history, after the rule's passes with output cotangent `Ȳ`. A scalar
    # gain's cotangent is a `Ref`.
    function scaled_passes(x, gain, add, h, start, stop, Ȳ, dev)
        move(a) = dev && a isa AbstractArray ? JLArray(a) : a
        op = dev ? adapt(JLArray, Convolution(pmf)) : Convolution(pmf)
        args = map(move, (x, gain, add, h))
        y, cache = CR._run_forward(op, args..., start, stop)
        mirror(a) = a isa Real ? Ref(zero(a)) : zero(a)
        x̄, ḡ, ā, h̄ = map(mirror, args)
        piece = (; kernel = move(zeros(L)))
        grads = (; piece, y = move(Ȳ), args = (x̄, ḡ, ā, h̄, nothing, nothing))
        CR._run_pullback!(grads, op, cache)
        return Array(y), map(a -> a isa Ref ? a[] : Array(a), (x̄, ḡ, ā, h̄)),
            Array(piece.kernel)
    end
    # More strata than blocks, so the blocks' copies of a gain or add
    # input shared by the strata are summed.
    for S in (4, CR._KERNEL_BLOCKS + 1)
        x, h = inputs(S), fill(1.0, S, 2)
        gain, add = 0.5 .* inputs(S), collect(range(0.1, 1.0; length = T))
        short = x[:, 1:(T ÷ 2)]
        cases = [
            # The registry's gain and add cases: a gain per stratum and
            # time, an add input per time, and a history.
            "a gain per stratum and time and an add per time" =>
                (x, gain, add, h, 1, T),
            "a short series from the second time" =>
                (short, gain, add, h, 2, T),
            "a scalar gain and an add per stratum and time" =>
                (x, 0.7, gain, h, 1, T),
        ]
        @testset "$name, $S strata" for (name, (xi, g, a, hi, t0, t1)) in cases
            Ȳ = weights(S)[:, t0:t1]
            y0, c0, k̄0 = scaled_passes(xi, g, a, hi, t0, t1, Ȳ, false)
            y1, c1, k̄1 = scaled_passes(xi, g, a, hi, t0, t1, Ȳ, true)
            @test y1 ≈ y0
            @test all(map(≈, c1, c0))
            @test k̄1 ≈ k̄0
        end
    end
end

@testitem "JLArrays: the rule passes of time-varying kernels match the CPU" setup = [DeviceRules] begin
    # More strata than blocks, so the blocks' copies of a shared kernel's
    # cotangent are summed.
    for S in (4, CR._KERNEL_BLOCKS + 1)
        cases = [
            "recurrence, one kernel" =>
                dev -> recurrence_case(I, S, dev; kernel = tv_kernel()),
            "recurrence, a kernel per stratum" =>
                dev -> recurrence_case(I, S, dev; kernel = tv_per_stratum(S)),
            "convolution, one kernel" =>
                dev -> convolution_case(tv_kernel(), S, dev),
            "convolution, a kernel per stratum" =>
                dev -> convolution_case(tv_per_stratum(S), S, dev),
            "convolution, a kernel per stratum, by output" =>
                dev -> convolution_case(by_output(tv_per_stratum(S)), S, dev),
        ]
        @testset "$name, $S strata" for (name, case) in cases
            op0, args0 = case(false)
            op1, args1 = case(true)
            p̄0, p̄1 = CR._zero_mirror(op0), CR._zero_mirror(op1)
            y0, x̄0, p̄0 = rule_cotangents(op0, args0, p̄0, S, false)
            y1, x̄1, p̄1 = rule_cotangents(op1, args1, p̄1, S, true)
            @test y1 ≈ y0
            @test x̄1 ≈ x̄0
            @test agree(p̄1, p̄0)
        end
    end
    # The values above cannot show memory: blocks share a per-stratum
    # kernel's cotangent rather than each copying it (S × L × T). The
    # pullback allocates about 100 times that cotangent's size when shared
    # and over 16000 times when copied, so the bound sits between.
    S = CR._KERNEL_BLOCKS + 1
    bound = 1000 * sizeof(Float64) * S * L * T
    function pullback_bytes(op, args)
        y, cache = CR._run_forward(op, args...)
        rest = map(_ -> nothing, Base.tail(args))
        x̄, Ȳ = zero(args[1]), JLArray(weights(S))
        grads = (; piece = CR._zero_mirror(op), y = Ȳ, args = (x̄, rest...))
        return @allocated CR._run_pullback!(grads, op, cache)
    end
    k = tv_per_stratum(S)
    cases = [
        "recurrence" => recurrence_case(I, S, true; kernel = k),
        "convolution" => convolution_case(k, S, true),
        "convolution by output" => convolution_case(by_output(k), S, true),
    ]
    @testset "$name shares its cotangent" for (name, case) in cases
        pullback_bytes(case...)
        @test pullback_bytes(case...) < bound
    end
end

@testitem "JLArrays: the rule passes of built-in modifiers match the CPU" setup = [DeviceRules] begin
    # A `Transform` without a `derivative` takes its derivative with dual
    # numbers, which needs ForwardDiff.
    using ForwardDiff
    # More strata than blocks, so the blocks' copies of a shared pool's
    # cotangent are summed.
    for S in (4, CR._KERNEL_BLOCKS + 1)
        cases = [
            "a shared pool and one per stratum" => pools(S),
            "a scale and a shift" => (
                CR.Transform(*, PerStratum(fill(0.9, S))),
                CR.Transform(+, 0.5),
            ),
            "a clamp and a pool" => (
                CR.Transform(clamp, 0.0, 5.0), first(pools(S)),
            ),
            "a function of its own" => (
                CR.Transform((v, a) -> v * exp(-a), 0.1),
            ),
            # A scale read from the last three outputs, each stratum its own.
            "feedback from recent outputs" => (
                CR.Transform(*, CR.Derived(exp, -0.05 * CR.Recent(pmf[1:3]))),
            ),
            # Group steps: several pools, two draws on one pool, a queue
            # and grouped totals, which reverse group by group.
            "two pools with a flow between them" => (two_pools(S),),
            "two draws on one pool" => (two_draws(),),
            "an overflow that joins a queue" => (queued(),),
            "grouped totals" => (totals(S),),
            # Per-stratum modifiers with their own vector pullbacks beside
            # a vector step, which on a device reverse per stratum instead.
            "a pool per stratum and a scale beside two draws" => (
                two_draws(), last(pools(S)),
                CR.Transform(*, PerStratum(fill(0.9, S))),
            ),
        ]
        @testset "$name, $S strata" for (name, ms) in cases
            op0, args0 = modified_case(ms, S, false)
            op1, args1 = modified_case(ms, S, true)
            p̄0, p̄1 = CR._zero_mirror(op0), CR._zero_mirror(op1)
            y0, x̄0, p̄0 = rule_cotangents(op0, args0, p̄0, S, false)
            y1, x̄1, p̄1 = rule_cotangents(op1, args1, p̄1, S, true)
            @test y1 ≈ y0
            @test x̄1 ≈ x̄0
            @test agree(p̄1, p̄0)
        end
    end
    # The values above cannot show memory: per-stratum parameters' cotangents
    # are shared by a step's blocks, not copied per block at every step. The
    # pullback of two pools allocates about 1600 times S × T floats on
    # JLArrays when shared and over 27000 times when copied.
    S = CR._KERNEL_BLOCKS + 1
    op, args = modified_case((two_pools(S),), S, true)
    function pullback_bytes()
        y, cache = CR._run_forward(op, args...)
        rest = map(_ -> nothing, Base.tail(args))
        x̄, Ȳ = zero(args[1]), JLArray(weights(S))
        grads = (; piece = CR._zero_mirror(op), y = Ȳ, args = (x̄, rest...))
        return @allocated CR._run_pullback!(grads, op, cache)
    end
    pullback_bytes()
    @test pullback_bytes() < 5000 * sizeof(Float64) * S * T
end

@testitem "JLArrays: a dense coupling's pullback with and without its own mirror" setup = [DeviceRules] begin
    S = 4
    C, p, q̄ = dense(S), collect(1.0:S), collect(0.5:0.5:(S / 2))
    for C̄ in (nothing, zeros(S, S))
        p̄ = zeros(S)
        grads = (; piece = C̄, q = q̄, p = p̄)
        CR.pullback!(grads, C, CR.Pressure(), zeros(S), p, 1)
        d̄ = C̄ === nothing ? nothing : JLArray(C̄ .* 0)
        dgrads = (; piece = d̄, q = JLArray(q̄), p = JLArray(zeros(S)))
        Cd, pd = JLArray(C), JLArray(p)
        CR.pullback!(dgrads, Cd, CR.Pressure(), JLArray(zeros(S)), pd, 1)
        @test Array(dgrads.p) ≈ p̄
        C̄ === nothing || @test Array(d̄) ≈ C̄
    end
    # Pressures of the wrong length are an error, not a wrong result.
    bad = (; piece = nothing, q = JLArray(q̄), p = JLArray(zeros(S + 1)))
    @test_throws DimensionMismatch CR.pullback!(
        bad, JLArray(C), CR.Pressure(), JLArray(zeros(S)), bad.p, 1
    )
end

@testitem "JLArrays: the rule passes of computed kernels match the CPU" setup = [DeviceRules] begin
    # A mapped hazard's partials come from a local forward-mode derivative.
    using ForwardDiff: ForwardDiff
    logistic(z) = inv(1 + exp(-z))
    hz = 0.1 .+ 0.05 .* sin.(1:T)
    # A hazard per stratum and time. With 10 strata there are more walks
    # than blocks, so blocks walk several cohorts in turn.
    HZ(S) = [0.1 + 0.05 * sin(k + t) for k in 1:S, t in 1:T]
    @test 10 * T > CR._KERNEL_BLOCKS
    confirmed() = pmf * (1 - CR.Survival(TimeVarying(hz); from = 1))
    stratified(S) = pmf * CR.Survival(TimeVarying(PerStratum(HZ(S))))
    z = TimeVarying(3 .* hz .- 2)
    mapped() = pmf * CR.Survival(CR.Derived(logistic, z))
    computed(w) = TimeVarying(w, CR.Primary())
    # A cohort-indexed kernel starts after its history, so its output is
    # shorter.
    by_cohort(k, C, S) = recurrence_case(C, S, false; kernel = k, start = L + 1)
    # Each case is built on the host, and moved to the device once.
    cases = [
        ("convolution, a confirmed survival", 4, false) =>
            convolution_case(computed(confirmed()), 4, false),
        ("convolution, a survival per stratum", 10, false) =>
            convolution_case(computed(stratified(10)), 10, false),
        ("convolution, a mapped hazard", 4, false) =>
            convolution_case(computed(mapped()), 4, false),
        ("recurrence, a confirmed survival", 4, true) =>
            by_cohort(computed(confirmed()), I, 4),
        ("recurrence, a survival per stratum", 10, true) =>
            by_cohort(computed(stratified(10)), dense(10), 10),
    ]
    @testset "$name" for ((name, S, shorter), (op0, args0)) in cases
        op1, args1 = adapt(JLArray, op0), adapt(JLArray, args0)
        @test CR._route_val(op1, args1...) === Val(:rule)
        # On the host the call does not take the device route.
        @test !CR._device_gate(op0, args0...)
        p̄0, p̄1 = CR._zero_mirror(op0), CR._zero_mirror(op1)
        y0, x̄0, p̄0 = rule_cotangents(op0, args0, p̄0, S, false; shorter)
        y1, x̄1, p̄1 = rule_cotangents(op1, args1, p̄1, S, true; shorter)
        @test y1 ≈ y0
        @test x̄1 ≈ x̄0
        @test agree(p̄1, p̄0)
    end
    # `kernel_weights` reads every weight of its cohorts, so its hazard
    # covers `n + L - 1` times.
    n = T - L + 1
    @testset "kernel_weights, $name" for (name, w) in (
            "a confirmed survival" => confirmed, "a mapped hazard" => mapped,
            "a survival per stratum" => () -> stratified(10),
        )
        op0 = CR._KernelWeights(computed(w()))
        op1 = adapt(JLArray, op0)
        @test CR._route_val(op1, n) === Val(:rule)
        @test !CR._device_gate(op0, n)
        K0, c0 = CR._run_forward(op0, n)
        K1, c1 = CR._run_forward(op1, n)
        @test K1 isa JLArray
        @test Array(K1) ≈ K0
        K̄ = cotangent_like(K0)
        p̄0, p̄1 = CR._zero_mirror(op0), CR._zero_mirror(op1)
        g0 = (; piece = p̄0, y = K̄, args = (nothing,))
        g1 = (; piece = p̄1, y = JLArray(K̄), args = (nothing,))
        CR._run_pullback!(g0, op0, c0)
        CR._run_pullback!(g1, op1, c1)
        @test agree(p̄1, p̄0)
        @test Array(CR.kernel_weights(op1.kernel, n)) ≈ K0
    end
end

@testitem "JLArrays: calls whose reverse pass runs on a device take the rule" setup = [DeviceRules] begin
    S = 4
    route(op, args) = CR._route_val(op, args...)
    op, args = convolution_case(pmf, S, true)
    @test route(op, args) === Val(:rule)
    @test (@inferred route(op, args)) === Val(:rule)
    op, args = recurrence_case(I, S, true)
    @test route(op, args) === Val(:rule)
    @test (@inferred route(op, args)) === Val(:rule)
    # So does a dense coupling on the device.
    op, args = recurrence_case(dense(S), S, true)
    @test (@inferred route(op, args)) === Val(:rule)
    # A time-varying coupling reverses its steps on the host.
    X = JLArray(repeat(dense(S), 1, 1, T))
    op, args = recurrence_case(TimeVarying(X), S, true)
    @test route(op, args) === Val(:plain)
    # Built-in modifiers that reverse per stratum take the rule.
    op, args = modified_case((pools(S)...,), S, true)
    @test (@inferred route(op, args)) === Val(:rule)
    # So do built-in modifiers whose steps run per group.
    for m in (two_pools(S), two_draws(), queued(), totals(S))
        op, args = modified_case((m,), S, true)
        @test (@inferred route(op, args)) === Val(:rule)
    end
    # A modifier that moves values between strata reverses on the host.
    moves = CR.Redistribute(0.9 .* dense(S); leak = true)
    op, args = modified_case((moves,), S, true)
    @test (@inferred route(op, args)) === Val(:plain)
    # The gate's defaults, called directly: inference folds them into the
    # routes above, so those calls never run them.
    @test !CR._on_gpu(zeros(2))
    @test !CR._any_on_gpu()
    @test !CR._device_ready(sum)
    @test CR._device_ready(first(convolution_case(pmf, S, false)))
    @test CR._device_ready(first(recurrence_case(I, S, false)))
    @test CR._device_coupling(I) && CR._device_coupling(Diagonal(ones(S)))
    @test !CR._device_coupling(TimeVarying(X))
    @test CR._device_modifiers(())
    @test !CR._device_modifier(moves)
    @test CR._device_modifier(totals(S))
    # These have their own vector pullbacks, which a device skips.
    for m in (last(pools(S)), CR.Transform(*, PerStratum(fill(0.9, S))))
        @test CR._has_vector_pullback(m)
        @test CR._strata_loop(m)
    end
    # So do time-varying kernels, but not one given by change points.
    op, args = recurrence_case(I, S, true; kernel = tv_kernel())
    @test (@inferred route(op, args)) === Val(:rule)
    op, args = convolution_case(tv_per_stratum(S), S, true)
    @test (@inferred route(op, args)) === Val(:rule)
    steps = TimeVarying([1 => pmf, 15 => reverse(pmf)])
    @test !CR._device_ready(Convolution(steps))
    # Numbers other than IEEE floats keep plain AD.
    xq, cq = JLArray(fill(1 // 2, S, T)), Convolution(JLArray(fill(1 // 5, L)))
    @test route(cq, (xq, true, nothing, nothing, 1, nothing)) === Val(:plain)
end

@testitem "JLArrays: the reverse pass stacks shared cotangents with an inferred choice" tags = [:threads] setup = [DeviceRules] begin
    S = 6
    x = JLArray(inputs(S))
    acc = (; ḡ = JLArray(zeros(L)), λ = Ref(0.0))
    # Under a set executor the choice follows the arrays' type.
    c = CR._Current(CR.Threaded())
    accs = @inferred CR._accumulators(c, x, S, S, acc)
    @test last(accs) isa CR._Stacked
    accs = @inferred CR._accumulators(CR.Serial(), x, S, S, acc)
    @test last(accs) isa CR._Stacked
    # Host arrays keep their copies per thread.
    accs = CR._accumulators(c, inputs(S), S, S, (; ḡ = zeros(L)))
    @test !(last(accs) isa CR._Stacked)
    # A block's slot of a stacked scalar adds into its own entry.
    v = zeros(3)
    CR._add_slot!(CR._Slot(v, 2), 1.5, 1, 1)
    @test v == [0.0, 1.5, 0.0]
    # A cotangent that cannot be stacked is an error, not a wrong result.
    @test_throws ArgumentError CR._stack(:x, 2, x)
end

@testitem "JLArrays: Threaded runs device arrays on their own backend" tags = [:threads] setup = [DeviceRules] begin
    using Base.ScopedValues: with
    # The default `min_work` runs small loops without splitting them, and
    # `min_work = 0` splits every loop.
    S = 6
    cases = [
        "independent strata" => recurrence_case(I, S, true),
        "dense coupling" => recurrence_case(dense(S), S, true),
        "a vector step" => modified_case((totals(S),), S, true),
        "a convolution" => convolution_case(pmf, S, true),
    ]
    @testset "$name" for (name, (op, args)) in cases
        y0, x̄0, p̄0 = rule_cotangents(op, args, CR._zero_mirror(op), S, true)
        for ex in (CR.Threaded(), CR.Threaded(; min_work = 0))
            y, x̄, p̄ = with(CR.EXECUTOR => ex) do
                rule_cotangents(op, args, CR._zero_mirror(op), S, true)
            end
            @test y ≈ y0
            @test x̄ ≈ x̄0
            @test agree(p̄, p̄0)
        end
    end
end
