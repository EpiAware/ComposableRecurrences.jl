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
