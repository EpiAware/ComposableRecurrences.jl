# The one-line summaries of the public types, and the constructor form
# that `repr` keeps.

@testitem "Show: one-line summaries" begin
    using ComposableRecurrences: ComposableRecurrences as CR
    plain(x) = sprint(show, MIME"text/plain"(), x)
    pop = [6.0e4, 2.5e4, 1.0e4]
    K = [0.9 0.05 0.05; 0.1 0.8 0.1; 0.0 0.1 0.9]

    @test plain(Recurrence(ones(6))) == "Recurrence(6 lags)"
    @test plain(Recurrence([1.0])) == "Recurrence(1 lag)"
    @test plain(
        Recurrence(
            ones(6); coupling = K, modifiers = (CR.Depletion(PerStratum(pop)),)
        )
    ) == "Recurrence(6 lags, coupling 3×3 Matrix{Float64}, modifiers (Depletion))"
    @test plain(Recurrence(PerStratum(ones(3, 6)))) ==
        "Recurrence(6 lags, kernel PerStratum(3 strata, 3×6 Matrix{Float64}))"
    @test plain(Recurrence(Pairwise(ones(3, 3, 6)))) ==
        "Recurrence(6 lags, kernel Pairwise(3×3 strata, 6 lags))"
    @test plain(Recurrence(TimeVarying(ones(6, 50)))) ==
        "Recurrence(6 lags, kernel TimeVarying(50 times, 6×50 Matrix{Float64}))"

    @test plain(Convolution(ones(7))) == "Convolution(7 lags)"
    @test plain(Convolution(ones(7); method = CR.FFTMethod())) ==
        "Convolution(7 lags, method FFTMethod)"

    @test plain(PerStratum(pop)) == "PerStratum(3 strata)"
    @test plain(PerStratum([1.0])) == "PerStratum(1 stratum)"
    @test plain(PerStratum(ones(3, 4))) ==
        "PerStratum(3 strata, 3×4 Matrix{Float64})"
    @test plain(Pairwise(ones(3, 3, 5))) == "Pairwise(3×3 strata, 5 lags)"
    @test plain(TimeVarying(ones(20))) == "TimeVarying(20 times)"
    @test plain(TimeVarying(ones(3, 20))) ==
        "TimeVarying(20 times, 3×20 Matrix{Float64})"
    @test plain(TimeVarying{CR.Primary}(ones(6, 20))) ==
        "TimeVarying(20 times, 6×20 Matrix{Float64}, Primary())"

    @test plain(TimeVarying([1 => [0.5, 0.5], 5 => [0.2, 0.8]])) ==
        "TimeVarying(2×2 Matrix{Float64} from the change points [1, 5])"

    @test plain(CR.Depletion(PerStratum(pop))) ==
        "Depletion(pools (:S,), draw Hazard(), population PerStratum(3 strata))"
    @test plain(CR.Depletion(10.0, CR.Floor(0.5))) ==
        "Depletion(pools (:S,), draw Floor(0.5), population 10.0)"
    @test plain(CR.Depletion(10.0, CR.Truncate(; overflow = :queue))) ==
        "Depletion(pools (:S,), draw Truncate() with overflow = :queue, " *
        "population 10.0)"
    @test plain(
        CR.Depletion(
            100.0, CR.Hazard(), CR.Flow(:S, :V, 0.1, CR.Share());
            pools = (S = 100.0, V = 0.0)
        )
    ) == "Depletion(pools (:S, :V), draw Hazard(), population 100.0, " *
        "flows (S => V))"
    @test plain(
        CR.Depletion(
            100.0, CR.Hazard(2.0; weights = (S = 1, V = 0.3));
            pools = (S = 100.0, V = 0.0)
        )
    ) == "Depletion(pools (:S, :V), draw Hazard(2.0) with weights = " *
        "(S = 1, V = 0.3), population 100.0)"
    @test plain(CR.Flow(:S, :R, 0.1, CR.Hazard())) ==
        "Flow(:S => :R, Hazard(), 0.1)"

    @test plain(CR.Transform(clamp, 0.0, 1.0)) == "Transform(clamp, 0.0, 1.0)"
    @test plain(CR.Transform(+, 1.0)) == "Transform(+, 1.0)"
    @test plain(CR.Transform(exp)) == "Transform(exp)"
    @test plain(CR.Redistribute(K)) ==
        "Redistribute(movement 3×3 Matrix{Float64})"
    @test plain(CR.Redistribute(K; leak = true)) ==
        "Redistribute(movement 3×3 Matrix{Float64}, leak)"
    @test plain(CR.Recent(ones(3))) == "Recent(3 weights)"
    @test plain(CR.Allocate([[1, 2], [3]], PerStratum([10.0, 5.0]))) ==
        "Allocate(2 groups, 3 strata)"

    w = ones(3)
    @test plain(CR.Transform(min, (60.0 - CR.Recent(w)) / 0.9)) ==
        "Transform(min, (60.0 - Recent(3 weights)) / 0.9)"
    @test plain(CR.Derived(exp, -0.5 * CR.Recent(w))) ==
        "Derived(exp(-0.5 * Recent(3 weights)))"
    testing = fill(0.1, 40)
    @test plain(CR.Survival(TimeVarying(testing); from = 1)) ==
        "Survival(TimeVarying(40 times); from = 1)"
    stay = [exp(-l / 8) for l in 0:14]
    @test plain(
        Convolution(
            TimeVarying(
                stay * (1 - CR.Survival(TimeVarying(testing); from = 1)),
                CR.Primary()
            )
        )
    ) == "Convolution(15 lags, kernel TimeVarying(15-element " *
        "Vector{Float64} * (1 - Survival(TimeVarying(40 times); from = 1)), " *
        "Primary()))"
    @test plain(CR.Depletion(10.0, CR.Truncate(; overflow = :stratum))) ==
        "Depletion(pools (:S,), draw Truncate() with overflow = :stratum, " *
        "population 10.0)"
    @test plain(
        CR.Depletion(10.0, CR.Truncate(; into = :B); pools = (A = 10.0, B = 0.0))
    ) == "Depletion(pools (:A, :B), draw Truncate() with into = :B, " *
        "population 10.0)"
    @test plain(CR.Derived(max, CR.Recent(w), 1.0)) ==
        "Derived(max(Recent(3 weights), 1.0))"
    @test plain(CR.Derived(-, CR.Recent(w))) == "Derived(-Recent(3 weights))"
    @test plain(CR.Derived(*, TimeVarying(ones(5)), ones(3))) ==
        "Derived(TimeVarying(5 times) * 3-element Vector{Float64})"
    @test plain(CR.Transform(exp; derivative = exp)) ==
        "Transform(exp, derivative exp)"
    @test plain(CR.NoAdjoint(Recurrence(ones(3)))) ==
        "NoAdjoint(Recurrence(3 lags))"
    @test plain(Recurrence(ones(3); coupling = 2.0 * CR.I)) ==
        "Recurrence(3 lags, coupling 2.0I)"

    r = Recurrence(ones(3) / 3; modifiers = (CR.Depletion(10.0),))
    (; state) = r(fill(1.1, 6); history = ones(3), stop = 3, record = (:state,))
    @test plain(state) ==
        "State(t = 4, history 3-element Vector{Float64}, 1 modifier state)"
end

@testitem "Show: each summary is inferred as a String" begin
    using ComposableRecurrences: ComposableRecurrences as CR
    r = Recurrence(ones(3) / 3; modifiers = (CR.Depletion(10.0),))
    (; state) = r(fill(1.1, 6); history = ones(3), stop = 3, record = (:state,))
    xs = (
        Recurrence(ones(6); coupling = ones(3, 3) / 3), r,
        Convolution(ones(7)), PerStratum(ones(3)), Pairwise(ones(3, 3, 5)),
        TimeVarying(ones(20)), CR.Depletion(10.0), CR.Flow(:S, :R, 0.1, CR.Hazard()),
        CR.Transform(clamp, 0.0, 1.0), CR.Redistribute(ones(3, 3) / 3),
        CR.Recent(ones(3)), CR.Allocate([[1, 2], [3]], PerStratum([10.0, 5.0])),
        state, CR.Derived(exp, -0.5 * CR.Recent(ones(3))),
        CR.Survival(TimeVarying(fill(0.1, 40)); from = 1),
        CR.NoAdjoint(Recurrence(ones(3))),
    )
    for x in xs
        @test (@inferred CR._summary(x)) == sprint(show, MIME"text/plain"(), x)
    end
end
