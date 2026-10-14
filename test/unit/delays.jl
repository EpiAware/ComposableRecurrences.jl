# Delays as kernels: `delay_masses` and the operators the Distributions
# extension lets take delay distributions, against the same operators built
# from the masses.

@testsnippet DelayCases begin
    using ComposableRecurrences, Distributions, LinearAlgebra
    CR = ComposableRecurrences
    masses(d, lags) = [pdf(d, l) for l in 0:(lags - 1)]
    # The masses from lag 1, as a Recurrence reads them.
    tail(d, lags) = masses(d, lags)[2:end]
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
        @test_throws ArgumentError Recurrence(PerStratum([d, d]); lags = 4)
        @test_throws ArgumentError Convolution(TimeVarying([d, d]); lags = 4)
        @test_throws ArgumentError Recurrence(Pairwise(fill(d, 2, 2)); lags = 4)
        @test_throws ArgumentError Recurrence(Routes((I, d)); lags = 4)
    end
    err = try
        CR.delay_masses(Gamma(2.0, 1.5), 4)
    catch e
        e
    end
    @test occursin("discretise", sprint(showerror, err))
    @test occursin("Gamma", sprint(showerror, err))
end

@testitem "Convolution: a delay distribution from lag 0" setup = [DelayCases] begin
    d = Poisson(1.5)
    x = [1.0, 3.0, 2.0, 5.0, 4.0, 1.0]
    c = @inferred Convolution(d; lags = 4)
    @test c.kernel ≈ masses(d, 4)
    @test c(x) ≈ Convolution(masses(d, 4))(x)
    c2 = Convolution(d; lags = 4, method = CR.Direct())
    @test c2(x) ≈ c(x)
    @test Convolution(d; lags = 1).kernel ≈ masses(d, 1)
    @test_throws UndefKeywordError Convolution(d)
end

@testitem "Recurrence: a delay distribution from lag 1" setup = [DelayCases] begin
    d = NegativeBinomial(4, 0.6)
    # `lags` counts from lag 0, so 5 lags give 4 kernel entries.
    r = @inferred Recurrence(d; lags = 5)
    @test length(r.kernel) == 4
    @test r.kernel ≈ tail(d, 5)
    R = fill(1.3, 8)
    h = ones(4)
    @test r(R; history = h) ≈ Recurrence(tail(d, 5))(R; history = h)
    C = [0.9 0.1; 0.2 0.8]
    rc = Recurrence(d; lags = 5, coupling = C)
    @test rc.coupling == C
    @test_throws UndefKeywordError Recurrence(d)
end

@testitem "Delay distributions: lags is checked" setup = [DelayCases] begin
    d = Poisson(1.0)
    @test_throws ArgumentError Recurrence(d; lags = 1)
    @test_throws ArgumentError Recurrence(d; lags = 0)
    @test_throws ArgumentError Convolution(d; lags = 0)
    @test_throws ArgumentError Convolution(d; lags = 2.0)
    @test_throws ArgumentError Recurrence(PerStratum([d, d]); lags = 1)
    err = try
        Recurrence(d; lags = 1)
    catch e
        e
    end
    @test occursin("lag 1", sprint(showerror, err))
end

@testitem "Delay distributions: a bare array needs a wrapper" setup = [DelayCases] begin
    ds = [Poisson(1.0), Poisson(2.0)]
    @test_throws ArgumentError Recurrence(ds; lags = 3)
    @test_throws ArgumentError Convolution(ds; lags = 3)
    @test_throws ArgumentError Recurrence(fill(Poisson(1.0), 2, 2); lags = 3)
    err = try
        Recurrence(fill(Poisson(1.0), 2, 2); lags = 3)
    catch e
        e
    end
    @test occursin("PerStratum, Pairwise or TimeVarying", sprint(showerror, err))
end

@testitem "delay_masses: a method of the wrong length is caught" setup = [DelayCases] begin
    struct ShortDelay <: DiscreteUnivariateDistribution end
    CR.delay_masses(::ShortDelay, lags) = [1.0]
    @test_throws ArgumentError Convolution(ShortDelay(); lags = 3)
end

@testitem "PerStratum: a delay distribution per stratum" setup = [DelayCases] begin
    ds = [Poisson(1.0), Poisson(2.0), Geometric(0.5)]
    # A vector of one distribution type infers; a mixed one cannot.
    @inferred Recurrence(PerStratum([Poisson(1.0), Poisson(2.0)]); lags = 4)
    c = Convolution(PerStratum(ds); lags = 4)
    @test size(c.kernel.x) == (3, 4)
    r = Recurrence(PerStratum(ds); lags = 4)
    @test size(r.kernel.x) == (3, 3)
    for (i, d) in enumerate(ds)
        @test c.kernel.x[i, :] ≈ masses(d, 4)
        @test r.kernel.x[i, :] ≈ tail(d, 4)
    end
    x = [1.0 2.0 3.0 4.0; 2.0 1.0 0.5 1.0; 3.0 3.0 1.0 2.0]
    @test c(x) ≈ Convolution(PerStratum(c.kernel.x))(x)
    h = ones(3, 3)
    @test r(ones(3, 5); history = h) ≈
        Recurrence(PerStratum(r.kernel.x))(ones(3, 5); history = h)
end

@testitem "TimeVarying: a delay distribution per time" setup = [DelayCases] begin
    ds = [Poisson(0.5 + t / 4) for t in 1:5]
    c = @inferred Convolution(TimeVarying(ds); lags = 3)
    @test c.kernel isa TimeVarying{CR.Secondary}
    @test size(c.kernel.x) == (3, 5)
    for (t, d) in enumerate(ds)
        @test c.kernel.x[:, t] ≈ masses(d, 3)
    end
    cp = Convolution(TimeVarying(ds, CR.Primary()); lags = 3)
    @test cp.kernel isa TimeVarying{CR.Primary}
    x = [1.0, 2.0, 4.0, 3.0, 1.0]
    @test cp(x) ≈ Convolution(TimeVarying(c.kernel.x, CR.Primary()))(x)
    r = @inferred Recurrence(TimeVarying(ds); lags = 3)
    @test r.kernel.x ≈ c.kernel.x[2:end, :]
    @test r(ones(5); history = ones(2)) ≈
        Recurrence(TimeVarying(c.kernel.x[2:end, :]))(ones(5); history = ones(2))
end

@testitem "TimeVarying: a delay distribution per stratum and time" setup = [DelayCases] begin
    D = [Poisson(0.5 + s + t / 4) for s in 1:2, t in 1:4]
    c = @inferred Convolution(TimeVarying(PerStratum(D)); lags = 3)
    @test size(c.kernel.x.x) == (2, 3, 4)
    r = Recurrence(TimeVarying(PerStratum(D), CR.Primary()); lags = 3)
    @test r.kernel isa TimeVarying{CR.Primary}
    for s in 1:2, t in 1:4
        @test c.kernel.x.x[s, :, t] ≈ masses(D[s, t], 3)
        @test r.kernel.x.x[s, :, t] ≈ tail(D[s, t], 3)
    end
    P = [Poisson(0.5 + i + j + t / 4) for i in 1:2, j in 1:2, t in 1:4]
    rp = @inferred Recurrence(TimeVarying(Pairwise(P)); lags = 3)
    @test size(rp.kernel.x.x) == (2, 2, 2, 4)
    @test rp.kernel.x.x[1, 2, :, 3] ≈ tail(P[1, 2, 3], 3)
end

@testitem "Pairwise: a delay distribution per pair" setup = [DelayCases] begin
    D = [Poisson(1.0) Poisson(2.0); Geometric(0.4) Poisson(3.0)]
    @inferred Recurrence(Pairwise(fill(Poisson(1.0), 2, 2)); lags = 4)
    r = Recurrence(Pairwise(D); lags = 4)
    @test size(r.kernel.x) == (2, 2, 3)
    for i in 1:2, j in 1:2
        @test r.kernel.x[i, j, :] ≈ tail(D[i, j], 4)
    end
    h = ones(2, 3)
    @test r(ones(2, 6); history = h) ≈
        Recurrence(Pairwise(r.kernel.x))(ones(2, 6); history = h)
end

@testitem "Routes: delay distributions on routes" setup = [DelayCases] begin
    C1 = [0.9 0.1; 0.1 0.9]
    C2 = [0.0 0.4; 0.4 0.0]
    d1, d2 = Poisson(1.0), NegativeBinomial(2, 0.5)
    r = Recurrence(Routes((C1, d1), (C2, d2)); lags = 5)
    @test r.kernel.couplings == (C1, C2)
    @test r.kernel.kernels[1] ≈ tail(d1, 5)
    @test r.kernel.kernels[2] ≈ tail(d2, 5)
    ref = Recurrence(Routes((C1, tail(d1, 5)), (C2, tail(d2, 5))))
    R = fill(1.2, 2, 6)
    h = ones(2, 4)
    @test r(R; history = h) ≈ ref(R; history = h)
    # A route of masses beside a route of a distribution.
    g = [0.5, 0.3]
    mixed = Recurrence(Routes((C1, g), (C2, d2)); lags = 5)
    @test mixed.kernel.kernels[1] == g
    @test mixed.kernel.kernels[2] ≈ tail(d2, 5)
    # A route kernel per stratum.
    ps = Recurrence(Routes((C1, PerStratum([d1, d2]))); lags = 3)
    @test ps.kernel.x[2, :] ≈ tail(d2, 3)
    @test_throws ArgumentError Recurrence(Routes((C1, d1), (C2, d2)))
    @test_throws ArgumentError Recurrence(Routes((C1, d1)); lags = 1)
    # Routes of arrays alone are unchanged.
    arrays = Routes((C1, [0.5, 0.3]), (C2, [0.1, 0.1, 0.2]))
    @test Recurrence(arrays)(R; history = h) ≈
        Recurrence(arrays; lags = 4)(R; history = h)
end

@testitem "Delay distributions: gradients reach the parameters" setup = [DelayCases] begin
    using ForwardDiff
    x = [1.0, 3.0, 2.0, 5.0, 4.0, 1.0]
    conv(λ) = sum(Convolution(Poisson(λ); lags = 4)(x))
    rec(λ) = sum(Recurrence(Poisson(λ); lags = 4)(fill(1.1, 6); history = ones(3)))
    strata(λ) = sum(
        Recurrence(PerStratum([Poisson(λ), Poisson(2λ)]); lags = 4)(
            fill(1.1, 2, 6); history = ones(2, 3)
        )
    )
    for f in (conv, rec, strata)
        g = ForwardDiff.derivative(f, 1.5)
        ϵ = 1.0e-6
        @test g ≈ (f(1.5 + ϵ) - f(1.5 - ϵ)) / 2ϵ rtol = 1.0e-6
        @test g != 0
    end
end
