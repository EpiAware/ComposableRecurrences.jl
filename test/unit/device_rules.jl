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
    function recurrence_case(coupling, S, dev; kernel = pmf)
        r = Recurrence(kernel; coupling)
        op = dev ? adapt(JLArray, r) : r
        x, h = inputs(S), fill(1.0, S, L)
        x, h = dev ? (JLArray(x), JLArray(h)) : (x, h)
        args = CR._run_args(op, x, h, nothing, nothing, 1)
        return op, (args..., nothing)
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

    # The input's cotangent and the parameter mirror after the rule's
    # forward pass and pullback with output cotangent `weights(S)`.
    function rule_cotangents(op, args, piece, S, dev)
        y, cache = CR._run_forward(op, args...)
        Ȳ = dev ? JLArray(weights(S)) : weights(S)
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
    # A modifier that reads a group of strata reverses on the host.
    groups = CR.Allocate([1:2, 3:4], PerStratum(fill(1.0, 2)))
    op, args = modified_case((groups,), S, true)
    @test (@inferred route(op, args)) === Val(:plain)
    # So does a pool whose overflow joins a queue.
    flow = CR.Flow(0 => :B, 2.0; form = CR.Truncate())
    queued = CR.Depletion(
        flow, CR.Truncate(; overflow = :queue); pools = (B = 50.0,)
    )
    op, args = modified_case((queued,), S, true)
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
    @test !CR._device_modifier(groups)
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
