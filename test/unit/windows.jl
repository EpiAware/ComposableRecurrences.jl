@testitem "window_sums: values against a direct sum" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    # A direct sum over each window, as BVD's `bin_increments` takes it.
    function direct(x, ends)
        n = length(x)
        out = zeros(eltype(x), length(ends))
        prev = 0
        for (v, e) in enumerate(ends)
            hi, lo = clamp(e, 0, n), clamp(prev, 0, n)
            out[v] = hi > lo ? sum(x[(lo + 1):hi]) : zero(eltype(x))
            prev = hi
        end
        return out
    end
    x = [0.5 + 0.1 * t for t in 1:12]
    # Ascending ends; a repeated end (an empty window); an end at 0 and past
    # the series; one that goes back, which empties its window and starts the
    # next after it; and no windows.
    for ends in (
            [3, 7, 12], [3, 7, 7, 10], [0, 4, 20], [6, 4, 9], [12], Int[],
            collect(1:12),
        )
        @test CR.window_sums(x, ends) ≈ direct(x, ends)
    end
    @test CR.window_sums(x, Int[]) == Float64[]
    # Literal sums, independent of `direct`: an end at 0 and past the series,
    # and an end that goes back.
    @test CR.window_sums(x, [2, 5, 5, 8]) ≈ [1.3, 2.7, 0.0, 3.6]
    @test CR.window_sums(x, [0, 4, 20]) ≈ [0.0, 3.0, 10.8]
    @test CR.window_sums(x, [6, 4, 9]) ≈ [5.1, 0.0, 6.0]
    # A matrix sums each series: along the rows by default, down the columns
    # with `dims = 1`.
    X = [sin(p + t) + 2.0 for p in 1:3, t in 1:12]
    ends = [3, 7, 7, 10, 15]
    rows = CR.window_sums(X, ends)
    @test size(rows) == (3, length(ends))
    @test all(rows[p, :] ≈ direct(X[p, :], ends) for p in 1:3)
    @test CR.window_sums(permutedims(X), ends; dims = 1) ≈ permutedims(rows)
    @test CR.window_sums(X, ends; dims = 2) == rows
    # Integer series stay integer.
    @test CR.window_sums(1:6, [2, 6]) == [3, 18]
    @test_throws ArgumentError CR.window_sums(x, ends; dims = 2)
    @test_throws ArgumentError CR.window_sums(X, ends; dims = 3)
    @inferred CR.window_sums(x, ends)
    @inferred CR.window_sums(X, ends)
    @inferred CR.window_sums(X, ends; dims = 1)
end

@testitem "window_sums: the rule's pullback against a Jacobian" setup = [
    PullbackChecks, ReferenceAD,
] begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    (; rule_vjp, reference_vjp) = PullbackChecks
    X = [sin(p + t) + 2.0 for p in 1:3, t in 1:12]
    ends = [0, 3, 7, 7, 10, 15]
    for (x, dims) in ((X, 2), (permutedims(X), 1), (X[1, :], 1))
        op = CR._WindowSums(ends, size(x, dims), dims)
        @test CR.uses_adjoint(op, CR.Run())
        ȳ = reshape(sin.(1:length(op(x))) .+ 0.0, size(op(x)))
        ref = reference_vjp(ReferenceAD.jacobian, op, (x,), ȳ)
        @test rule_vjp(op, (x,), ȳ) ≈ ref
    end
end

@testitem "window_sums: windows by first and last time against a direct sum" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    # A direct sum over each window's times within the series.
    function direct(x, starts, stops)
        n = length(x)
        return [
            sum(x[max(a, 1):min(b, n)]; init = zero(eltype(x)))
                for (a, b) in zip(starts, stops)
        ]
    end
    x = [0.5 + 0.1 * t for t in 1:12]
    # A gap; two windows that share times; one that starts before the series
    # and one past it; a stop before its start (an empty window); a single
    # time; and no windows.
    for (starts, stops) in (
            ([1, 4, 9], [2, 7, 12]), ([1, 3, 5], [6, 8, 12]),
            ([0, 10], [3, 20]), ([5, 2], [4, 2]), ([7], [7]), (Int[], Int[]),
        )
        @test CR.window_sums(x, starts, stops) ≈ direct(x, starts, stops)
    end
    # Literal sums, independent of `direct`.
    @test CR.window_sums(x, [1, 4, 5], [2, 5, 7]) ≈ [1.3, 1.9, 3.3]
    # Consecutive windows give the sums of the form with ends only.
    @test CR.window_sums(x, [1, 4, 8], [3, 7, 12]) ≈
        CR.window_sums(x, [3, 7, 12])
    # A matrix sums each series: along the rows by default, down the columns
    # with `dims = 1`.
    X = [sin(p + t) + 2.0 for p in 1:3, t in 1:12]
    starts, stops = [1, 3, 9, 0, 11], [4, 6, 8, 2, 15]
    rows = CR.window_sums(X, starts, stops)
    @test size(rows) == (3, length(starts))
    @test all(rows[p, :] ≈ direct(X[p, :], starts, stops) for p in 1:3)
    @test CR.window_sums(permutedims(X), starts, stops; dims = 1) ≈
        permutedims(rows)
    @test CR.window_sums(1:6, [1, 3], [4, 6]) == [10, 18]
    @test_throws ArgumentError CR.window_sums(x, [1, 2], [3])
    @test_throws ArgumentError CR.window_sums(X, starts, stops; dims = 3)
    @inferred CR.window_sums(x, starts, stops)
    @inferred CR.window_sums(X, starts, stops; dims = 1)
end

@testitem "window_sums: the rule's pullback over overlapping windows against a Jacobian" setup = [
    PullbackChecks, ReferenceAD,
] begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    (; rule_vjp, reference_vjp) = PullbackChecks
    X = [sin(p + t) + 2.0 for p in 1:3, t in 1:12]
    starts, stops = [1, 3, 9, 0, 11, 6], [4, 6, 8, 2, 15, 6]
    for (x, dims) in ((X, 2), (permutedims(X), 1), (X[1, :], 1))
        op = CR._WindowSums(stops, size(x, dims), dims, starts)
        @test CR.uses_adjoint(op, CR.Run())
        ȳ = reshape(sin.(1:length(op(x))) .+ 0.0, size(op(x)))
        ref = reference_vjp(ReferenceAD.jacobian, op, (x,), ȳ)
        @test rule_vjp(op, (x,), ȳ) ≈ ref
    end
end

@testitem "JLArrays: the rule passes of window sums by first and last time match the CPU" setup = [DeviceRules] begin
    # A gap, windows that share times, one before the series, an empty one
    # and one past the series.
    starts, stops = [1, 3, 9, 0, 11, 6], [4, 6, 8, 2, 40, 6]
    X = inputs(4)
    @testset "$name" for (name, (x, dims)) in (
            "a vector" => (X[2, :], 1), "a matrix, time last" => (X, 2),
            "a matrix, time first" => (permutedims(X), 1),
        )
        op = CR._WindowSums(stops, size(x, dims), dims, starts)
        x1 = JLArray(x)
        @test (@inferred CR._route_val(op, x1)) === Val(:rule)
        y0, c0 = CR._run_forward(op, x)
        y1, c1 = CR._run_forward(op, x1)
        @test y1 isa JLArray
        @test Array(y1) ≈ y0
        @test Array(CR.window_sums(x1, starts, stops; dims)) ≈ y0
        # The pullback adds into the inputs' cotangent, each time once for
        # every window it falls in.
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
