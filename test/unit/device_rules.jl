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
    using LinearAlgebra: Diagonal, I, UpperTriangular
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
    # A matrix as AD passes it: a `ReshapedArray` of a `SubArray` of a
    # parameter vector, not a `Matrix`.
    param_view(M) = reshape(view(vec(copy(M)), 1:length(M)), size(M))
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
    # A kernel as ragged columns, of lengths `ns`, held as one flat vector and
    # its offsets, as a device holds one. `by_output` columns are read by
    # output time, so a recurrence's may be empty.
    function ragged(ns; by_output = false)
        ks = [pmf[1:n] .* (1 + 0.1 * sin(τ)) for (τ, n) in enumerate(ns)]
        g = CR._Ragged(ks)
        return by_output ? TimeVarying(g, CR.Primary()) : TimeVarying(g)
    end
    by_input_lengths() = [min(L, T - τ + 1) for τ in 1:T]
    by_output_lengths() = [mod(τ, L + 1) for τ in 1:T]

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
    # Movement between every pair of strata from a kernel whose columns sum
    # to `c` and an intensity per origin and time, or a matrix of moves.
    move_kernel(S, c = 0.6) = c .* (ones(S, S) .- I(S)) ./ max(S - 1, 1)
    intensity(S) = [0.1 + 0.01 * k + 0.005 * t for k in 1:S, t in 1:T]
    movement(S; kw...) = CR.Redistribute(move_kernel(S), intensity(S); kw...)
    moves(S) = Matrix(0.8I, S, S) .+ 0.2 .* (ones(S, S) .- I(S)) ./ (S - 1)
    function totals(S)
        h = S ÷ 2
        return CR.Allocate([1:h, (h + 1):S], PerStratum(fill(1.0, 2)))
    end
    # Grouped totals that import by a pattern, fixed or over time, with a
    # fraction the groups share or one per group, and a spill within the
    # first group.
    function imported(S; fraction = 0.2, spill = true, over_time = false)
        h = S ÷ 2
        P = zeros(S, S)
        P[1, S], P[2, S], P[S, 1] = 0.6, 0.4, 1.0
        if over_time
            P = TimeVarying(P .* reshape(1 .+ 0.1 .* sin.(1:T), 1, 1, T))
        end
        M = Matrix(1.0I, S, S)
        M[1:2, 1:2] .= [0.9 0.1; 0.1 0.9]
        spills = spill ? (; spill = CR.Redistribute(M)) : (;)
        return CR.Allocate(
            [1:h, (h + 1):S], PerStratum(fill(6.0, 2));
            imports = (fraction, P), spills...
        )
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

@testitem "JLArrays: the rule passes of routes match the CPU" setup = [DeviceRules] begin
    using SparseArrays: sparse
    # Two routes of different lengths, each a coupling and its own kernel.
    # A sparse route coupling becomes a dense matrix on the device, so the
    # host runs its dense copy, whose cotangent the device's matches.
    near(S) = Matrix(0.3I, S, S) .+ 0.1 .* (ones(S, S) .- I(S)) ./ S
    short = pmf[1:(L - 1)]
    for S in (4, CR._KERNEL_BLOCKS + 1)
        sp = sparse(near(S))
        cases = [
            "dense routes" => (
                Pairwise(dense(S) => short, near(S) => pmf),
                Pairwise(dense(S) => short, near(S) => pmf),
            ),
            "a sparse route" => (
                Pairwise(dense(S) => short, Matrix(sp) => pmf),
                Pairwise(dense(S) => short, sp => pmf),
            ),
            "a per-stratum route kernel" => (
                Pairwise(dense(S) => PerStratum(repeat(short', S)), near(S) => pmf),
                Pairwise(dense(S) => PerStratum(repeat(short', S)), near(S) => pmf),
            ),
        ]
        @testset "$name, $S strata" for (name, (host, device)) in cases
            op0, args0 = recurrence_case(I, S, false; kernel = host)
            op1, args1 = recurrence_case(I, S, true; kernel = device)
            @test (@inferred CR._route_val(op1, args1...)) === Val(:rule)
            p̄0, p̄1 = CR._zero_mirror(op0), CR._zero_mirror(op1)
            y0, x̄0, p̄0 = rule_cotangents(op0, args0, p̄0, S, false)
            y1, x̄1, p̄1 = rule_cotangents(op1, args1, p̄1, S, true)
            @test y1 ≈ y0
            @test x̄1 ≈ x̄0
            @test agree(p̄1, p̄0)
        end
    end
    # A route coupling that is not a matrix on the device keeps plain AD.
    # Routes that are all scaled identities fold into one kernel, so one
    # route here is a matrix.
    mixed = Pairwise(dense(4) => short, 0.5I => pmf)
    op, args = recurrence_case(I, 4, true; kernel = mixed)
    @test (@inferred CR._route_val(op, args...)) === Val(:plain)
    # A route whose kernel varies over time keeps plain AD too.
    over_time = Pairwise(dense(4) => short, dense(4) => tv_kernel())
    op, args = recurrence_case(I, 4, true; kernel = over_time)
    @test (@inferred CR._route_val(op, args...)) === Val(:plain)
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

@testitem "JLArrays: the rule passes of ragged kernels match the CPU" setup = [DeviceRules] begin
    # More strata than blocks, so the blocks' copies of the kernel's
    # cotangent are summed.
    for S in (4, CR._KERNEL_BLOCKS + 1)
        cases = [
            ("convolution", false) =>
                dev -> convolution_case(ragged(by_input_lengths()), S, dev),
            ("convolution by output", false) => dev -> convolution_case(
                ragged(by_input_lengths(); by_output = true), S, dev
            ),
            # Columns by output time may be empty.
            ("convolution by output, empty columns", false) => dev -> convolution_case(
                ragged(by_output_lengths(); by_output = true), S, dev
            ),
            # Read by output time, it starts after its history, so its
            # output is shorter.
            ("recurrence by output", true) => dev -> recurrence_case(
                I, S, dev; start = L + 1,
                kernel = ragged(by_output_lengths(); by_output = true)
            ),
        ]
        @testset "$name, $S strata" for ((name, shorter), case) in cases
            op0, args0 = case(false)
            op1, args1 = case(true)
            p̄0, p̄1 = CR._zero_mirror(op0), CR._zero_mirror(op1)
            y0, x̄0, p̄0 = rule_cotangents(op0, args0, p̄0, S, false; shorter)
            y1, x̄1, p̄1 = rule_cotangents(op1, args1, p̄1, S, true; shorter)
            @test y1 ≈ y0
            @test x̄1 ≈ x̄0
            @test agree(p̄1, p̄0)
        end
    end
    # Columns given as a list adapt to the flat form and take the rule.
    S = 4
    ks = [pmf[1:n] for n in by_input_lengths()]
    op = adapt(JLArray, Convolution(TimeVarying(ks)))
    @test op.kernel.x isa CR._Ragged
    args = (JLArray(inputs(S)), true, nothing, nothing, 1, nothing)
    @test CR._route_val(op, args...) === Val(:rule)
end

@testitem "JLArrays: the rule passes of pairwise kernels match the CPU" setup = [DeviceRules] begin
    # A kernel per pair of strata, fixed or over time, read by input or by
    # output time. More strata than blocks covers the sender loop at size.
    function fixed(S)
        P = [pmf[i] * (1 + 0.1 * sin(a + 2b)) / S for a in 1:S, b in 1:S, i in 1:L]
        return Pairwise(P)
    end
    function over_time(S; by_output = false)
        P = [
            pmf[i] * (1 + 0.1 * sin(a + 2b + t)) / S
                for a in 1:S, b in 1:S, i in 1:L, t in 1:T
        ]
        return by_output ? TimeVarying(Pairwise(P), CR.Primary()) :
            TimeVarying(Pairwise(P))
    end
    for S in (4, CR._KERNEL_BLOCKS + 1)
        cases = [
            ("fixed", false) => dev -> recurrence_case(I, S, dev; kernel = fixed(S)),
            ("over time", false) =>
                dev -> recurrence_case(I, S, dev; kernel = over_time(S)),
            ("over time, by output", true) => dev -> recurrence_case(
                I, S, dev; start = L + 1, kernel = over_time(S; by_output = true)
            ),
        ]
        @testset "$name, $S strata" for ((name, shorter), case) in cases
            (op0, args0), (op1, args1) = case(false), case(true)
            @test (@inferred CR._route_val(op1, args1...)) === Val(:rule)
            p̄0, p̄1 = CR._zero_mirror(op0), CR._zero_mirror(op1)
            y0, x̄0, p̄0 = rule_cotangents(op0, args0, p̄0, S, false; shorter)
            y1, x̄1, p̄1 = rule_cotangents(op1, args1, p̄1, S, true; shorter)
            @test y1 ≈ y0
            @test x̄1 ≈ x̄0
            @test agree(p̄1, p̄0)
        end
    end
end

@testitem "JLArrays: the rule passes of a coupling over time match the CPU" setup = [DeviceRules] begin
    # Each step's slice reverses as a dense coupling does. More strata than
    # blocks covers the products at size.
    function over_time(S)
        C = [
            (a == b ? 0.5 : 0.5 / S) * (1 + 0.1 * sin(a + b + t))
                for a in 1:S, b in 1:S, t in 1:T
        ]
        return TimeVarying(C)
    end
    for S in (4, CR._KERNEL_BLOCKS + 1)
        cases = [
            "a fixed kernel" => dev -> recurrence_case(over_time(S), S, dev),
            "a kernel over time" =>
                dev -> recurrence_case(over_time(S), S, dev; kernel = tv_kernel()),
        ]
        @testset "$name, $S strata" for (name, case) in cases
            (op0, args0), (op1, args1) = case(false), case(true)
            @test (@inferred CR._route_val(op1, args1...)) === Val(:rule)
            p̄0, p̄1 = CR._zero_mirror(op0), CR._zero_mirror(op1)
            y0, x̄0, p̄0 = rule_cotangents(op0, args0, p̄0, S, false)
            y1, x̄1, p̄1 = rule_cotangents(op1, args1, p̄1, S, true)
            @test y1 ≈ y0
            @test x̄1 ≈ x̄0
            @test agree(p̄1, p̄0)
        end
    end
end

@testitem "JLArrays: the rule passes of a convolution's transpose match the CPU" setup = [DeviceRules] begin
    # The transpose runs the convolution's bodies, so it takes the rule when
    # the convolution does. A series extended past its end (`tail`) has its
    # own cotangent; a kernel over time read by input time covers only the
    # series, so it takes no tail.
    function transposed_case(kernel, S, dev; start = 1, tail = true)
        x = inputs(S)
        t = tail ? repeat(x[:, end], 1, L - 1) : nothing
        op = transpose(Convolution(kernel))
        move(a) = dev && a !== nothing ? JLArray(a) : a
        op = dev ? adapt(JLArray, op) : op
        return op, (move(x), move(t), start, nothing)
    end
    _zero(a) = a === nothing ? nothing : zero(a)
    _host(a) = a === nothing ? nothing : Array(a)
    function passes(op, args)
        y, cache = CR._run_forward(op, args...)
        W = reshape(cos.(1:length(y)), size(y))
        Ȳ = y isa JLArray ? JLArray(W) : W
        x̄, t̄ = zero(args[1]), _zero(args[2])
        piece = CR._zero_mirror(op)
        grads = (; piece, y = Ȳ, args = (x̄, t̄, nothing, nothing))
        CR._run_pullback!(grads, op, cache)
        return Array(y), Array(x̄), _host(t̄), piece
    end
    for S in (4, CR._KERNEL_BLOCKS + 1)
        cases = [
            "a fixed kernel" => dev -> transposed_case(pmf, S, dev),
            "a kernel per stratum" =>
                dev -> transposed_case(PerStratum(repeat(pmf', S)), S, dev),
            "a kernel over time" =>
                dev -> transposed_case(tv_kernel(), S, dev; tail = false),
            "a kernel over time by output" =>
                dev -> transposed_case(by_output(tv_kernel()), S, dev; start = 2),
        ]
        @testset "$name, $S strata" for (name, case) in cases
            (op0, args0), (op1, args1) = case(false), case(true)
            @test (@inferred CR._route_val(op1, args1...)) === Val(:rule)
            y0, x̄0, t̄0, p̄0 = passes(op0, args0)
            y1, x̄1, t̄1, p̄1 = passes(op1, args1)
            @test y1 ≈ y0
            @test x̄1 ≈ x̄0
            @test t̄1 == t̄0 || t̄1 ≈ t̄0
            @test agree(p̄1, p̄0)
        end
    end
end

@testitem "JLArrays: the rule passes of built-in modifiers match the CPU" setup = [DeviceRules] begin
    # A `Transform` without a `derivative` takes its derivative with dual
    # numbers, which needs ForwardDiff.
    using ForwardDiff
    # A read of the outputs through a coupling.
    coupled(w, C) = CR.Recent(w; coupling = C)
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
            # The same read across strata, through a coupling, and two
            # reads of the last three outputs that share their windows.
            "feedback from recent outputs across strata" => (
                CR.Transform(
                    *, CR.Derived(exp, -0.05 * coupled(pmf[1:3], dense(S)))
                ),
            ),
            "two coupled reads that share their windows" => (
                CR.Transform(*, CR.Derived(exp, -0.02 * coupled(3, dense(S)))),
                CR.Transform(+, 0.01 * coupled(3, fill(1 / S, S, S))),
            ),
            # Group steps: several pools, two draws on one pool, a queue
            # and grouped totals, which reverse group by group.
            "two pools with a flow between them" => (two_pools(S),),
            "two draws on one pool" => (two_draws(),),
            "an overflow that joins a queue" => (queued(),),
            "grouped totals" => (totals(S),),
            "grouped totals with imports and a spill" => (imported(S),),
            "grouped totals importing with a fraction per group" => (
                imported(S; fraction = PerStratum([0.2, 0.1]), spill = false),
            ),
            "grouped totals importing by a pattern over time" =>
                (imported(S; over_time = true),),
            # Whole steps that move between strata, as kernels.
            "movement of a kernel and an intensity" => (movement(S),),
            "movement that leaks, and a pool" => (
                movement(S; leak = true), first(pools(S)),
            ),
            "a matrix of moves" => (CR.Redistribute(moves(S)),),
            # The same moves as reshaped views of a parameter vector.
            "a matrix of moves viewed from a parameter vector" =>
                (CR.Redistribute(param_view(moves(S))),),
            "movement viewed from a parameter vector" => (
                CR.Redistribute(
                    param_view(move_kernel(S)), param_view(intensity(S))
                ),
            ),
            # An intensity read from the last three outputs, per stratum or
            # across strata: every origin adds into the scale's cotangent.
            "movement read from recent outputs" => (
                CR.Redistribute(
                    move_kernel(S),
                    CR.Derived(x -> 0.2 * tanh(x), 0.05 * CR.Recent(pmf[1:3])),
                ),
                first(pools(S)),
            ),
            "movement read from recent outputs across strata" => (
                CR.Redistribute(
                    move_kernel(S),
                    CR.Derived(
                        x -> 0.2 * tanh(x), 0.05 * coupled(pmf[1:3], dense(S))
                    ),
                ),
            ),
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
    # A coupled read's coupling cotangent (S × S) is written by each stratum
    # at its own row, so a step's blocks share it rather than each copying
    # it. JLArrays allocate on every element a kernel reads, so the copies
    # are counted from the blocks' stacked cotangents.
    C = JLArray(dense(S))
    read = CR.Recent(JLArray(pmf[1:3]); coupling = C)
    ms = (CR.Transform(*, CR.Derived(exp, -0.05 * read)),)
    H = JLArray(ones(T, S))
    bound = CR._bind(ms, H, zero(H), 1)
    m̄s = CR._mirrors(CR._zero_mirror(ms), bound)
    stacked = CR._stack(CR._step_slots(m̄s, bound, H), CR._KERNEL_BLOCKS, H)
    bytes(x::CR._ArrayStack) = sizeof(eltype(x.a)) * length(x.a)
    bytes(x::CR._ScalarStack) = sizeof(eltype(x.v)) * length(x.v)
    bytes(x::Union{Tuple, NamedTuple}) = sum(bytes, values(x); init = 0)
    bytes(::Union{Nothing, CR._Owned}) = 0
    @test bytes(stacked) < sizeof(Float64) * S * S
    # A movement's whole step runs on the calling task, so its kernel's
    # cotangent (S × S) is shared by a step's blocks rather than copied per
    # block, as its mirror passes through the stacking unchanged.
    moved = adapt(JLArray, (movement(S),))
    @test !CR._all_pointwise(moved)
    m̄v = CR._Owned(CR._mirrors(CR._zero_mirror(moved), moved))
    @test CR._stack(m̄v, CR._KERNEL_BLOCKS, H) === m̄v
    # A movement reads each origin's intensity once per step on a device.
    # Read through a coupling, at a pass over the strata per read, its
    # forward pass allocates about 1.4 times as much as with a matrix
    # intensity on JLArrays at 64 strata, and 28 times with a read for
    # every pair of strata.
    function forward_bytes(E, S)
        moved = (CR.Redistribute(move_kernel(S), E),)
        op, args = modified_case(moved, S, true)
        CR._run_forward(op, args...)
        return @allocated CR._run_forward(op, args...)
    end
    across = CR.Derived(
        x -> 0.2 * tanh(x), 0.05 * CR.Recent(pmf[1:3]; coupling = dense(64))
    )
    @test forward_bytes(across, 64) < 4 * forward_bytes(intensity(64), 64)
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
    # The values above cannot show memory: with strata the reverse pass runs
    # in blocks of strata, which share a per-stratum hazard's cotangent
    # rather than each copying it. On JLArrays the pullback allocates about
    # 230 times the weights' cotangent (S × L × n) when shared and over 3000
    # times when copied, so the bound sits between, with room to spare.
    S = CR._KERNEL_BLOCKS + 1
    op = adapt(JLArray, CR._KernelWeights(computed(stratified(S))))
    K, c = CR._run_forward(op, n)
    K̄ = JLArray(cotangent_like(Array(K)))
    function pullback_bytes()
        grads = (; piece = CR._zero_mirror(op), y = K̄, args = (nothing,))
        return @allocated CR._run_pullback!(grads, op, c)
    end
    pullback_bytes()
    @test pullback_bytes() < 500 * sizeof(eltype(K̄)) * length(K̄)
end

@testitem "JLArrays: the rule passes of user pointwise modifiers match the CPU" setup = [DeviceRules] begin
    # The local derivative of a step without a `pullback!` uses dual numbers.
    using ForwardDiff
    # A user modifier per stratum that passes the value through and asks for
    # a buffer deeper than the kernel, one that shrinks the value by a
    # scalar, and one that starts its state from its own `Init`, read from
    # the history.
    struct DevDeep
        w::Int
    end
    struct DevShrink{A}
        a::A
    end
    struct DevStart{A}
        N::A
    end
    for P in (DevDeep, DevShrink, DevStart)
        @eval CR.blocks(::$P) = (1, 1)
    end
    CR.depth(m::DevDeep) = m.w
    CR.forward!(::DevDeep, ::CR.Step, v, s, t) = nothing
    function CR.forward!(m::DevShrink, ::CR.Step, v, s, t)
        for k in eachindex(v, s)
            v[k] = v[k] / (1 + m.a * v[k])
        end
        return nothing
    end
    function CR.forward!(m::DevStart, ::CR.Init, s, history)
        s .= m.N .* (1 .+ 0.1 .* view(history, :, size(history, 2)))
        return nothing
    end
    function CR.forward!(m::DevStart, ::CR.Step, v, s, t)
        for k in eachindex(v, s)
            v[k], s[k] = min(v[k], s[k]), s[k] - min(v[k], s[k])
        end
        return nothing
    end
    function deep_case(m, S, dev)
        r = Recurrence(pmf; coupling = dense(S), modifiers = (m,))
        op = dev ? adapt(JLArray, r) : r
        x, h = inputs(S), fill(1.0, S, 2L)
        x, h = dev ? (JLArray(x), JLArray(h)) : (x, h)
        return op, (CR._run_args(op, x, h, nothing, nothing, 1)..., nothing)
    end
    for S in (4, CR._KERNEL_BLOCKS + 1)
        cases = [
            "a buffer deeper than the kernel" =>
                dev -> deep_case(DevDeep(2L), S, dev),
            "a scalar parameter" =>
                dev -> modified_case((DevShrink(0.1),), S, dev),
        ]
        @testset "$name, $S strata" for (name, case) in cases
            (op0, args0), (op1, args1) = case(false), case(true)
            @test (@inferred CR._route_val(op1, args1...)) === Val(:rule)
            @test CR._fit(op1, args1...) === :one
            p̄0, p̄1 = CR._zero_mirror(op0), CR._zero_mirror(op1)
            y0, x̄0, p̄0 = rule_cotangents(op0, args0, p̄0, S, false)
            y1, x̄1, p̄1 = rule_cotangents(op1, args1, p̄1, S, true)
            @test y1 ≈ y0
            @test x̄1 ≈ x̄0
            @test agree(p̄1, p̄0)
        end
    end
    # An `Init` of its own, here reading the history, reverses on host
    # copies and takes the rule; every cotangent, the history's too, is the
    # host's.
    function all_cotangents(op, args)
        y, cache = CR._run_forward(op, args...)
        W = cos.(0.1 .* reshape(1:length(y), size(y)))
        Ȳ = y isa JLArray ? JLArray(W) : W
        rest = map(a -> a isa AbstractArray ? zero(a) : nothing, Base.tail(args))
        piece = CR._zero_mirror(op)
        grads = (; piece, y = Ȳ, args = (zero(args[1]), rest...))
        CR._run_pullback!(grads, op, cache)
        host(a) = a isa AbstractArray ? Array(a) : a
        return Array(y), map(host, grads.args), piece
    end
    for S in (4, CR._KERNEL_BLOCKS + 1)
        (op0, args0) = modified_case((DevStart(50.0),), S, false)
        (op1, args1) = modified_case((DevStart(50.0),), S, true)
        @test (@inferred CR._route_val(op1, args1...)) === Val(:rule)
        @test CR._fit(op1, args1...) === :one
        y0, ḡ0, p̄0 = all_cotangents(op0, args0)
        y1, ḡ1, p̄1 = all_cotangents(op1, args1)
        @test y1 ≈ y0
        @test all(map((a, b) -> a === b || a ≈ b, ḡ1, ḡ0))
        @test agree(p̄1, p̄0)
    end
    # One whose `Init` is defined only for device states would not run on
    # the host copies, so it keeps plain AD, also with a history that is a
    # view.
    struct DevStartOn{A}
        N::A
    end
    CR.blocks(::DevStartOn) = (1, 1)
    function CR.forward!(m::DevStartOn, ::CR.Init, s::JLArray, history)
        fill!(s, m.N)
        return nothing
    end
    CR.forward!(::DevStartOn, ::CR.Step, v, s, t) = nothing
    r = Recurrence(pmf; modifiers = (DevStartOn(50.0),))
    op, h = adapt(JLArray, r), JLArray(fill(1.0, 4, L + 1))
    x, hv = JLArray(inputs(4)), view(h, :, 1:L)
    args = (CR._run_args(op, x, hv, nothing, nothing, 1)..., nothing)
    @test CR._fit(op, args...) === :none
    # A modifier holding an array keeps plain AD on a device, as its
    # step may read the array from the host.
    op, args = modified_case((DevShrink(fill(0.1, 4)),), 4, true)
    @test (@inferred CR._route_val(op, args...)) === Val(:plain)
end

@testitem "JLArrays: the rule passes of traced runs match the CPU" setup = [DeviceRules] begin
    # A user modifier on pairs of strata, with its own trace (the pair's
    # total after the step) or the default one (its state after the step).
    struct DevPairs{A}
        a::A
    end
    struct DevTracedPairs{A}
        a::A
    end
    for P in (DevPairs, DevTracedPairs)
        @eval begin
            CR.blocks(::$P) = (2, 2)
            function CR.forward!(m::$P, ::CR.Step, v::Tuple, s::Tuple, t, g)
                v1, v2, s1, s2 = v[1][], v[2][], s[1][], s[2][]
                v[1][], v[2][] = v1 * m.a, v2 + 0.1 * s1
                s[1][], s[2][] = 0.5 * s1 + v1, 0.5 * s2 + v2
                return nothing
            end
            function CR.pullback!(
                    grads, m::$P, ::CR.Step, v::Tuple, s::Tuple, t, g
                )
                v̄1, v̄2 = grads.v[1][], grads.v[2][]
                s̄1, s̄2 = grads.s[1][], grads.s[2][]
                CR.add_cotangent!(CR.cotangent(grads.piece, :a), v̄1 * v[1][])
                grads.v[1][], grads.v[2][] = v̄1 * m.a + s̄1, v̄2 + s̄2
                grads.s[1][], grads.s[2][] = 0.1 * v̄2 + 0.5 * s̄1, 0.5 * s̄2
                return nothing
            end
        end
    end
    # One step reverses through its `pullback!`, the other through its local
    # derivative.
    CR.uses_adjoint(::DevTracedPairs, ::CR.Step) = true
    CR.ntrace(::DevTracedPairs, S) = S ÷ 2
    function CR.forward!(
            m::DevTracedPairs, ::CR.Trace, r::Tuple, v::Tuple, s::Tuple,
            v′::Tuple, s′::Tuple, t, g
        )
        only(r)[] = v′[1][] + v′[2][]
        return nothing
    end
    function CR.pullback!(
            grads, m::DevTracedPairs, ::CR.Trace, v::Tuple, s::Tuple, t, g
        )
        r̄ = only(grads.trace)[]
        grads.v′[1][] += r̄
        grads.v′[2][] += r̄
        return nothing
    end
    # The traces of pointwise, grouped and user modifiers, written and
    # reversed per stratum or group on the device, at a few strata and at
    # more strata or groups than kernel blocks.
    function traced_passes(ms, S, dev)
        op, args = modified_case(ms, S, dev)
        w = CR._WithTrace(op)
        (y, tr), c = CR._run_forward(w, args...)
        Ts = tr.modifiers
        T̄s = map(T -> (dev ? JLArray : identity)(cotangent_like(Array(T))), Ts)
        Ȳ = dev ? JLArray(weights(S)) : weights(S)
        x̄ = zero(args[1])
        rest = map(_ -> nothing, Base.tail(args))
        piece = CR._zero_mirror(w)
        tr̄ = (; modifiers = T̄s, pressure = nothing)
        CR._run_pullback!((; piece, y = (Ȳ, tr̄), args = (x̄, rest...)), w, c)
        return Array(y), map(Array, Ts), Array(x̄), piece
    end
    # A user modifier on fixed groups takes the rule on a device, through
    # its own `pullback!` or, without one, its local derivative.
    many = 2 * (CR._KERNEL_BLOCKS + 1)
    cases = (
        "pools per stratum" => (pools, :rule),
        "two pools" => (S -> (two_pools(S),), :rule),
        "two draws on one pool" => (S -> (two_draws(),), :rule),
        "a queue" => (S -> (queued(),), :rule),
        # Beside a whole-step modifier the pools' traces reverse at vector
        # level, one kernel index per stratum.
        "pools and a matrix of moves" => (
            S -> (pools(S)..., CR.Redistribute(moves(S))), :rule,
        ),
        "a user modifier's own trace" => (S -> (DevTracedPairs(0.9),), :rule),
        "a user modifier's default trace" => (S -> (DevPairs(0.9),), :rule),
    )
    @testset "$name, $S strata" for (name, (ms, how)) in cases, S in (4, many)
        op, args = modified_case(ms(S), S, true)
        @test CR._route_val(CR._WithTrace(op), args...) === Val(how)
        y0, T0, x̄0, p̄0 = traced_passes(ms(S), S, false)
        y1, T1, x̄1, p̄1 = traced_passes(ms(S), S, true)
        @test y1 ≈ y0
        @test all(map(≈, T1, T0))
        @test x̄1 ≈ x̄0
        @test agree(p̄1, p̄0)
    end
    # Scalar indexing is off, so a host loop on these arrays would throw:
    # matching runs took the device branches. The trace's cotangent adds
    # into the state's on a device as on the host.
    n = 5
    r̄, T̄ = collect(1.0:n), reshape(collect(1.0:(3n)), n, 3)
    adds = (
        (s̄, to) -> CR._add_trace!(s̄, to(r̄)),
        (s̄, to) -> CR._add_trace_column!(s̄, to(T̄), 2),
    )
    for add! in adds
        s̄0, s̄1 = fill(0.5, n), JLArray(fill(0.5, n))
        add!(s̄0, identity)
        add!(s̄1, JLArray)
        @test Array(s̄1) == s̄0
    end
end

@testitem "JLArrays: the rule passes of window sums match the CPU" setup = [DeviceRules] begin
    # Ends past the series and ends that go back, so a window is empty and a
    # time falls in two windows.
    ends = [2, 5, 5, 9, 4, 12, 40]
    X = inputs(4)
    @testset "$name" for (name, (x, dims)) in (
            "a vector" => (X[2, :], 1), "a matrix, time last" => (X, 2),
            "a matrix, time first" => (permutedims(X), 1),
        )
        op = CR._WindowSums(ends, size(x, dims), dims)
        x1 = JLArray(x)
        @test CR._route_val(op, x1) === Val(:rule)
        @test (@inferred CR._route_val(op, x1)) === Val(:rule)
        y0, c0 = CR._run_forward(op, x)
        y1, c1 = CR._run_forward(op, x1)
        @test y1 isa JLArray
        @test Array(y1) ≈ y0
        @test Array(CR.window_sums(x1, ends; dims)) ≈ y0
        # The pullback adds into the inputs' cotangent.
        Ȳ = cotangent_like(y0)
        x̄0 = ones(size(x))
        x̄1 = JLArray(x̄0)
        CR._run_pullback!((; piece = nothing, y = Ȳ, args = (x̄0,)), op, c0)
        CR._run_pullback!(
            (; piece = nothing, y = JLArray(Ȳ), args = (x̄1,)), op, c1
        )
        @test Array(x̄1) ≈ x̄0
    end
end

@testitem "JLArrays: calls whose reverse pass runs on a device take the rule" setup = [DeviceRules] begin
    using JLArrays: JLSparseMatrixCSR
    using SparseArrays: sparse
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
    # So does a coupling over time on the device.
    X = JLArray(repeat(dense(S), 1, 1, T))
    op, args = recurrence_case(TimeVarying(X), S, true)
    @test (@inferred route(op, args)) === Val(:rule)
    # Built-in modifiers that reverse per stratum take the rule.
    op, args = modified_case((pools(S)...,), S, true)
    @test (@inferred route(op, args)) === Val(:rule)
    # So do built-in modifiers whose steps run per group.
    for m in (two_pools(S), two_draws(), queued(), totals(S), imported(S))
        op, args = modified_case((m,), S, true)
        @test (@inferred route(op, args)) === Val(:rule)
    end
    # So do modifiers that move values between strata, whose whole step runs
    # as kernels: a matrix of moves, or a movement of a kernel and an
    # intensity.
    by_matrix = CR.Redistribute(0.9 .* dense(S); leak = true)
    # So do moves given as a reshaped view of a parameter vector, as AD
    # passes them.
    by_view = CR.Redistribute(param_view(0.9 .* dense(S)); leak = true)
    moved_view = CR.Redistribute(
        param_view(move_kernel(S)), param_view(intensity(S))
    )
    # And a movement whose intensity is read from recent outputs.
    recent_read = CR.Derived(x -> 0.2 * tanh(x), 0.05 * CR.Recent(pmf[1:3]))
    from_recent = CR.Redistribute(param_view(move_kernel(S)), recent_read)
    for m in (by_matrix, movement(S), by_view, moved_view, from_recent)
        @test (@inferred route(modified_case((m,), S, true)...)) === Val(:rule)
    end
    # Moves over time given as an array reverse on the host.
    tv_moves = CR.Redistribute(TimeVarying(repeat(dense(S), 1, 1, T)))
    op, args = modified_case((tv_moves,), S, true)
    @test (@inferred route(op, args)) === Val(:plain)
    # The gate's defaults, called directly: inference folds them into the
    # routes above, so those calls never run them.
    @test !CR._on_gpu(zeros(2))
    @test !CR._any_on_gpu()
    @test !CR._device_ready(sum)
    @test CR._device_ready(first(convolution_case(pmf, S, false)))
    @test CR._device_ready(first(recurrence_case(I, S, false)))
    @test CR._device_coupling(I) && CR._device_coupling(Diagonal(ones(S)))
    @test CR._device_coupling(TimeVarying(X))
    @test !CR._device_coupling(TimeVarying(Array(X)))
    @test CR._device_modifiers(())
    @test CR._device_modifier(by_matrix) && CR._device_modifier(movement(S))
    @test !CR._device_modifier(tv_moves)
    # Moves as a `Diagonal`, triangular or sparse device matrix keep plain
    # AD, and so does a movement whose kernel is one.
    xd, hd = JLArray(inputs(S)), JLArray(fill(1.0, S, L))
    diagonal = Diagonal(JLArray(fill(0.9, S)))
    triangular = UpperTriangular(JLArray(dense(S)))
    for M in (diagonal, triangular, JLSparseMatrixCSR(sparse(dense(S))))
        r = Recurrence(JLArray(pmf); modifiers = (CR.Redistribute(M),))
        a = CR._run_args(r, xd, hd, nothing, nothing, 1)
        @test (@inferred route(r, (a..., nothing))) === Val(:plain)
    end
    @test !CR._device_modifier(
        CR.Redistribute(Diagonal(fill(0.1, S)), intensity(S))
    )
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

@testitem "JLArrays: Redistribute by a Diagonal, wrapped or sparse matrix" setup = [DeviceRules] begin
    using JLArrays: JLSparseMatrixCSR
    using SparseArrays: sparse
    S = 4
    h = fill(1.0, S, L)
    by(M, to) = Recurrence(
        to(pmf); modifiers = (CR.Redistribute(M; leak = true),)
    )(to(inputs(S)); history = to(h))
    # A `Diagonal` or a wrapped dense matrix runs forward as on the host.
    d, shares = fill(0.9, S), 0.8 .* dense(S)
    @test Array(by(Diagonal(JLArray(d)), JLArray)) ≈ by(Diagonal(d), identity)
    @test Array(by(transpose(JLArray(shares)), JLArray)) ≈
        by(transpose(shares), identity)
    # Sparse moves fail with a clear error, on a fresh or a resumed run, and
    # so does a movement's sparse kernel.
    sp = JLSparseMatrixCSR(sparse(shares))
    @test_throws "cannot read a sparse matrix" by(sp, JLArray)
    moved(M) = Recurrence(
        JLArray(pmf); modifiers = (CR.Redistribute(M; leak = true),)
    )
    x = JLArray(inputs(S))
    _, st = moved(JLArray(shares))(
        x; history = JLArray(h), stop = 2, record = (:state,)
    )
    @test_throws "cannot read a sparse matrix" moved(sp)(x; state = st)
    E = JLArray(fill(0.1, S, size(inputs(S), 2)))
    flows = CR.Redistribute(TimeVarying(CR._Movement(sp, E)))
    r = Recurrence(JLArray(pmf); modifiers = (flows,))
    @test_throws "cannot read a sparse matrix" r(
        JLArray(inputs(S)); history = JLArray(h)
    )
    # An `Allocate`'s spill is checked as a `Redistribute` is.
    within = [0.9 0.1 0.0; 0.1 0.9 0.0; 0.0 0.0 1.0]
    split = CR.Allocate(
        [1:2, 3:3], PerStratum([10.0, 2.0]);
        imports = (PerStratum([0.2, 0.0]), zeros(3, 3)),
        spill = CR.Redistribute(JLSparseMatrixCSR(sparse(within))),
    )
    @test_throws "cannot read a sparse matrix" CR._check_device_moves(
        JLArray(zeros(3, 2)), (split,)
    )
    @test CR._check_device_moves(zeros(3, 2), (split,)) === nothing
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
