# Truncate and SoftTruncate: draws up to what the pool holds, against a
# naive loop, with the pullback against a local ForwardDiff Jacobian and the
# smooth minimum's bounds.

@testitem "Truncate: values and gradients against a naive loop" begin
    using ComposableRecurrences, ForwardDiff
    CR = ComposableRecurrences
    g = [0.3, 0.5, 0.2]
    R = [2.5 + 0.3 * sin(t) for t in 1:12]
    h = [2.0, 3.0, 4.0]
    w = range(0.5, 1.5; length = 12)
    # A renewal whose draws stop when a pool of `b` runs out.
    function naive(R, b, κ)
        L = length(g)
        y = zeros(promote_type(eltype(R), typeof(b), typeof(κ)), L + 12)
        y[1:L] .= h
        s = b
        for t in 1:12
            v = R[t] * sum(g[i] * y[L + t - i] for i in 1:L)
            c = max(s, 0)
            lo, hi = minmax(v, c)
            # (v^(-1/κ) + c^(-1/κ))^(-κ), written to stay finite.
            y[L + t] = κ == 0 ? min(v, c) :
                (lo > 0 ? lo * (1 + (lo / hi)^(1 / κ))^(-κ) : lo)
            s -= y[L + t]
        end
        return y[(L + 1):end]
    end
    form(κ) = κ == 0 ? CR.Truncate() : CR.SoftTruncate(κ)
    run(R, b, κ) = Recurrence(g; modifiers = (CR.Depletion(b, form(κ)),))(R; history = h)
    for κ in (0.0, 0.1), b in (40.0, 300.0)
        y = run(R, b, κ)
        @test y ≈ naive(R, b, κ)
        @test sum(y) <= b + 1.0e-9
        @test ForwardDiff.gradient(R -> sum(w .* run(R, b, κ)), R) ≈
            ForwardDiff.gradient(R -> sum(w .* naive(R, b, κ)), R)
        @test ForwardDiff.derivative(b -> sum(w .* run(R, b, κ)), b) ≈
            ForwardDiff.derivative(b -> sum(w .* naive(R, b, κ)), b)
    end
    # The pool of 40 runs out, so the draws stop at its size.
    @test sum(run(R, 40.0, 0.0)) ≈ 40.0
    @test run(R, 40.0, 0.0)[end] == 0.0
    # A pool that never runs out leaves the renewal as it is.
    @test run(R, 1.0e6, 0.0) ≈ Recurrence(g)(R; history = h)
end

@testitem "Truncate: pullback against a local Jacobian" begin
    using ComposableRecurrences, ForwardDiff
    CR = ComposableRecurrences
    points = (
        (2.0, 80.0), (2.0, 1.5), (3.0, -1.0), (0.0, 4.0), (-0.5, 2.0),
        (1.0, 0.0), (4.0, 4.5), (2.0, 2.0), (2.0, Inf),
    )
    for κ in (nothing, 0.1, 0.4), (v, s) in points
        form(κ) = κ === nothing ? CR.Truncate() : CR.SoftTruncate(κ)
        θ = κ === nothing ? Float64[] : [κ]
        J = ForwardDiff.jacobian([v, s, 100.0, 1.0, θ...]) do x
            f = κ === nothing ? CR.Truncate() : CR.SoftTruncate(x[5])
            collect(CR.forward(f, CR.Step(), x[1], x[2], x[3], x[4]))
        end
        ȳ, s̄ = 0.7, -0.3
        κ̄ = Ref(0.0)
        grads = (; piece = (; κ = κ̄), v = ȳ, s = s̄)
        back = CR.pullback!(grads, form(κ), CR.Step(), v, s, 100.0, 1.0)
        expected = transpose(J) * [ȳ, s̄]
        @test collect(back) ≈ expected[1:4]
        κ === nothing || @test κ̄[] ≈ expected[5] atol = 1.0e-12
    end
end

@testitem "Truncate: the smooth minimum" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    draw(κ, v, s) = first(CR.forward(CR.SoftTruncate(κ), CR.Step(), v, s, 1.0, 1.0))
    for κ in (0.05, 0.3)
        @test draw(κ, 3.0, 3.0) ≈ 3.0 * 2.0^(-κ)
        @test draw(κ, 0.0, 3.0) == 0.0
        @test draw(κ, 3.0, 0.0) == 0.0
        @test draw(κ, 3.0, -2.0) == 0.0
        @test draw(κ, -1.0, 3.0) == -1.0
        for (v, s) in ((1.0, 4.0), (4.0, 1.0), (2.0, 2.5))
            @test 0 <= draw(κ, v, s) <= min(v, s)
            @test draw(κ, s, v) ≈ draw(κ, v, s)
        end
    end
    @test draw(0.01, 1.0, 2.0) ≈ 1.0
    # The exact form takes the value asked for on a tie and returns a NaN
    # pool's NaN, as a depletion's removals do.
    y, s = CR.forward(CR.Truncate(), CR.Step(), 2.0, 2.0, 1.0, 1.0)
    @test (y, s) == (2.0, 0.0)
    @test isnan(first(CR.forward(CR.Truncate(), CR.Step(), 2.0, NaN, 1.0, 1.0)))
    @test isnan(first(CR.forward(CR.Truncate(), CR.Step(), NaN, 2.0, 1.0, 1.0)))
    # Smooth through the tie: the derivatives match on either side.
    lo = CR._soft_min_back(0.2, 3.0 - 1.0e-9, 3.0, 1.0)
    hi = CR._soft_min_back(0.2, 3.0 + 1.0e-9, 3.0, 1.0)
    @test collect(lo) ≈ collect(hi) atol = 1.0e-6
end

@testitem "Truncate: checks and the rule" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    @test_throws "between 0 and 1, got 0" CR.SoftTruncate(0)
    @test_throws "between 0 and 1, got 1.5" CR.SoftTruncate(1.5)
    @test CR.SoftTruncate(0.1f0).κ isa Float32
    # Mixed argument types promote, so the step infers one type.
    for form in (CR.Truncate(), CR.SoftTruncate(0.1), CR.SoftTruncate(0.1f0))
        @inferred CR.forward(form, CR.Step(), 2.0, 1.5f0, 1.0, 1.0)
        @inferred CR.forward(form, CR.Step(), 2.0f0, 1.5f0, 1.0, 1.0)
        @inferred CR.forward(form, CR.Step(), 0.0f0, 1.5, 1.0, 1.0)
    end
    for form in (CR.Truncate(), CR.SoftTruncate(0.2))
        d = CR.Depletion(50.0, form)
        @test CR.uses_adjoint(d, CR.Step())
        @test CR.uses_adjoint(Recurrence([0.5, 0.5]; modifiers = (d,)), CR.Run())
    end
    # A protected pool draws through the form too.
    d = CR.Depletion(
        20.0, CR.Truncate(); removals = TimeVarying(fill(2.0, 6)),
        protected = CR.Protected(0.5)
    )
    y = Recurrence([1.0]; modifiers = (d,))(fill(3.0, 6); history = [2.0])
    @test sum(y) <= 20.0 + 1.0e-9
end

@testitem "Truncate: the shared minimum matches each form" begin
    using ComposableRecurrences, ForwardDiff
    CR = ComposableRecurrences
    # `_softness` and `_soft_min` give each form's draw, so a modifier that
    # admits up to a free capacity can reuse the forms' minimum.
    for form in (CR.Truncate(), CR.SoftTruncate(0.2)), (v, s) in ((2.0, 3.0), (3.0, 2.0), (2.0, 2.0))
        κ = CR._softness(form)
        y = CR._soft_min(κ, v, s)
        @test y == first(CR.forward(form, CR.Step(), v, s, 1.0, 1.0))
        back = CR._soft_min_back(κ, v, s, 0.7)
        @test collect(back[1:2]) ≈ 0.7 .* ForwardDiff.gradient(x -> CR._soft_min(κ, x[1], x[2]), [v, s])
    end
    @test CR._softness(CR.Truncate()) === nothing
    @test CR._softness(CR.SoftTruncate(0.3)) == 0.3
end
