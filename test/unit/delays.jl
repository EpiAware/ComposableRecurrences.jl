# Delays as kernels: `delay_masses` and the constructors the Distributions
# extension adds, against the same operators built from the masses.

@testsnippet DelayCases begin
    using ComposableRecurrences, Distributions, LinearAlgebra
    CR = ComposableRecurrences
    masses(d, lags) = [pdf(d, l) for l in 0:(lags - 1)]
end

@testitem "delay_masses: a vector is returned as it is" begin
    using ComposableRecurrences
    k = [0.2, 0.5, 0.3]
    @test ComposableRecurrences.delay_masses(k, 3) === k
    @test ComposableRecurrences.delay_masses(k, 5) === k
end

@testitem "delay_masses: a discrete distribution, lag 0 first" setup = [DelayCases] begin
    for d in (Poisson(2.5), NegativeBinomial(3, 0.4), Geometric(0.3))
        m = CR.delay_masses(d, 6)
        @test m isa Vector{Float64}
        @test length(m) == 6
        @test m ≈ masses(d, 6)
    end
    @test (@inferred CR.delay_masses(Poisson(2.0), 4)) ≈ masses(Poisson(2.0), 4)
end

@testitem "delay_masses: a continuous distribution must be discretised" setup = [DelayCases] begin
    for d in (Gamma(2.0, 1.5), LogNormal(1.0, 0.5))
        @test_throws ArgumentError CR.delay_masses(d, 4)
        @test_throws ArgumentError Convolution(d; lags = 4)
        @test_throws ArgumentError Recurrence(d; lags = 4)
        @test_throws ArgumentError PerStratum([d, d]; lags = 4)
        @test_throws ArgumentError TimeVarying([d, d]; lags = 4)
        @test_throws ArgumentError Pairwise(fill(d, 2, 2); lags = 4)
        @test_throws ArgumentError Routes((I, d); lags = 4)
    end
    err = try
        CR.delay_masses(Gamma(2.0, 1.5), 4)
    catch e
        e
    end
    @test occursin("discretise", sprint(showerror, err))
    @test occursin("Gamma", sprint(showerror, err))
end

@testitem "Convolution: a delay distribution" setup = [DelayCases] begin
    d = Poisson(1.5)
    x = [1.0, 3.0, 2.0, 5.0, 4.0, 1.0]
    c = Convolution(d; lags = 4)
    @test c.kernel ≈ masses(d, 4)
    @test c(x) ≈ Convolution(masses(d, 4))(x)
    c2 = Convolution(d; lags = 4, method = CR.Direct())
    @test c2(x) ≈ c(x)
    @test_throws UndefKeywordError Convolution(d)
end

@testitem "Recurrence: a delay distribution drops lag 0" setup = [DelayCases] begin
    d = NegativeBinomial(4, 0.6)
    r = Recurrence(d; lags = 5)
    @test length(r.kernel) == 4
    @test r.kernel ≈ masses(d, 5)[2:end]
    R = fill(1.3, 8)
    h = ones(4)
    @test r(R; history = h) ≈ Recurrence(masses(d, 5)[2:end])(R; history = h)
    C = [0.9 0.1; 0.2 0.8]
    rc = Recurrence(d; lags = 5, coupling = C)
    @test rc.coupling == C
    @test_throws UndefKeywordError Recurrence(d)
end

@testitem "PerStratum: a delay distribution per stratum" setup = [DelayCases] begin
    ds = [Poisson(1.0), Poisson(2.0), Geometric(0.5)]
    p = PerStratum(ds; lags = 4)
    @test size(p.x) == (3, 4)
    for (i, d) in enumerate(ds)
        @test p.x[i, :] ≈ masses(d, 4)
    end
    q = PerStratum(ds; lags = 4, lag0 = false)
    @test size(q.x) == (3, 3)
    @test q.x ≈ p.x[:, 2:end]
    x = [1.0 2.0 3.0 4.0; 2.0 1.0 0.5 1.0; 3.0 3.0 1.0 2.0]
    @test Convolution(p)(x) ≈ Convolution(PerStratum(p.x))(x)
    h = ones(3, 3)
    @test Recurrence(q)(ones(3, 5); history = h) ≈
        Recurrence(PerStratum(q.x))(ones(3, 5); history = h)
end

@testitem "TimeVarying: a delay distribution per time" setup = [DelayCases] begin
    ds = [Poisson(0.5 + t / 4) for t in 1:5]
    k = TimeVarying(ds; lags = 3)
    @test k isa TimeVarying{CR.Secondary}
    @test size(k.x) == (3, 5)
    for (t, d) in enumerate(ds)
        @test k.x[:, t] ≈ masses(d, 3)
    end
    kp = TimeVarying(ds, CR.Primary(); lags = 3)
    @test kp isa TimeVarying{CR.Primary}
    @test kp.x ≈ k.x
    x = [1.0, 2.0, 4.0, 3.0, 1.0]
    @test Convolution(kp)(x) ≈ Convolution(TimeVarying(kp.x, CR.Primary()))(x)
    g = TimeVarying(ds; lags = 3, lag0 = false)
    @test g.x ≈ k.x[2:end, :]
    @test Recurrence(g)(ones(5); history = ones(2)) ≈
        Recurrence(TimeVarying(k.x[2:end, :]))(ones(5); history = ones(2))
    @test_throws MethodError TimeVarying(ds, :primary; lags = 3)
end

@testitem "Pairwise: a delay distribution per pair drops lag 0" setup = [DelayCases] begin
    D = [Poisson(1.0) Poisson(2.0); Geometric(0.4) Poisson(3.0)]
    P = Pairwise(D; lags = 4)
    @test size(P.x) == (2, 2, 3)
    for i in 1:2, j in 1:2
        @test P.x[i, j, :] ≈ masses(D[i, j], 4)[2:end]
    end
    h = ones(2, 3)
    @test Recurrence(P)(ones(2, 6); history = h) ≈
        Recurrence(Pairwise(P.x))(ones(2, 6); history = h)
end

@testitem "Routes: a delay distribution per route drops lag 0" setup = [DelayCases] begin
    C1 = [0.9 0.1; 0.1 0.9]
    C2 = [0.0 0.4; 0.4 0.0]
    d1, d2 = Poisson(1.0), NegativeBinomial(2, 0.5)
    routes = Routes((C1, d1), (C2, d2); lags = 5)
    @test routes.couplings == (C1, C2)
    @test routes.kernels[1] ≈ masses(d1, 5)[2:end]
    @test routes.kernels[2] ≈ masses(d2, 5)[2:end]
    ref = Routes((C1, masses(d1, 5)[2:end]), (C2, masses(d2, 5)[2:end]))
    R = fill(1.2, 2, 6)
    h = ones(2, 4)
    @test Recurrence(routes)(R; history = h) ≈ Recurrence(ref)(R; history = h)
    one_route = Routes((C1, d1); lags = 3)
    @test one_route.kernels[1] ≈ masses(d1, 3)[2:end]
    @test_throws UndefKeywordError Routes((C1, d1))
end

@testitem "Delay distributions: gradients reach the parameters" setup = [DelayCases] begin
    using ForwardDiff
    x = [1.0, 3.0, 2.0, 5.0, 4.0, 1.0]
    conv(λ) = sum(Convolution(Poisson(λ); lags = 4)(x))
    rec(λ) = sum(Recurrence(Poisson(λ); lags = 4)(fill(1.1, 6); history = ones(3)))
    for f in (conv, rec)
        g = ForwardDiff.derivative(f, 1.5)
        ϵ = 1.0e-6
        @test g ≈ (f(1.5 + ϵ) - f(1.5 - ϵ)) / 2ϵ rtol = 1.0e-6
        @test g != 0
    end
end
