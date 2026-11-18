# The package's own rules on device arrays, run on JLArrays without a GPU:
# a fixed convolution and a recurrence of independent strata run their
# forward pass and their pullback on the device, without scalar indexing,
# and give the CPU's cotangents; calls whose reverse pass needs the host
# keep plain AD. AD backends cannot differentiate JLArrays themselves, so
# the rule passes run directly.

@testsnippet DeviceRules begin
    using ComposableRecurrences
    using Adapt: adapt
    using JLArrays
    using LinearAlgebra: Diagonal, I
    const CR = ComposableRecurrences

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
    function recurrence_case(coupling, S, dev)
        r = Recurrence(pmf; coupling)
        op = dev ? adapt(JLArray, r) : r
        x, h = inputs(S), fill(1.0, S, L)
        args = dev ? CR._run_args(op, JLArray(x), JLArray(h), nothing, nothing, 1) :
            CR._run_args(op, x, h, nothing, nothing, 1)
        return op, (args..., nothing)
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
    agree(a::NamedTuple, b::NamedTuple) = all(map(agree, values(a), values(b)))
end

@testitem "JLArrays: the rule passes of a fixed convolution and of independent strata match the CPU" setup = [DeviceRules] begin
    JLArrays.allowscalar(false)
    # 300 strata run in more blocks than one, so the blocks' copies of the
    # shared kernel cotangent are summed.
    for S in (4, 300)
        cases = [
            "vector kernel" => (
                dev -> convolution_case(pmf, S, dev),
                dev -> (; kernel = dev ? JLArray(zeros(L)) : zeros(L)),
            ),
            "per-stratum kernel" => (
                dev -> convolution_case(PerStratum(repeat(pmf', S)), S, dev),
                dev -> (; kernel = (; x = dev ? JLArray(zeros(S, L)) : zeros(S, L))),
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
            "recurrence, scalar coupling" => (
                dev -> recurrence_case(0.8I, S, dev),
                dev -> (;
                    kernel = dev ? JLArray(zeros(L)) : zeros(L),
                    coupling = (; λ = Ref(0.0)),
                ),
            ),
        ]
        @testset "$name, $S strata" for (name, (case, mirror)) in cases
            y0, x̄0, p̄0 = rule_cotangents(case(false)..., mirror(false), S, false)
            y1, x̄1, p̄1 = rule_cotangents(case(true)..., mirror(true), S, true)
            @test y1 ≈ y0
            @test x̄1 ≈ x̄0
            @test agree(p̄1, p̄0)
        end
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
    # A coupling that mixes strata reverses its steps on the host.
    C = Matrix(0.5I, S, S) .+ 0.5 / S
    op, args = recurrence_case(C, S, true)
    @test route(op, args) === Val(:plain)
    # So do modifiers.
    pool = CR.Depletion(PerStratum(fill(200.0, S)), CR.Hazard())
    r = Recurrence(pmf; modifiers = (pool,))
    rd = adapt(JLArray, r)
    x, h = JLArray(inputs(S)), JLArray(fill(1.0, S, L))
    @test route(rd, (CR._run_args(rd, x, h, nothing, nothing, 1)..., nothing)) === Val(:plain)
    # Numbers other than IEEE floats keep plain AD.
    xq, cq = JLArray(fill(1 // 2, S, T)), Convolution(JLArray(fill(1 // 5, L)))
    @test route(cq, (xq, true, nothing, nothing, 1, nothing)) === Val(:plain)
end
