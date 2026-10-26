# Delays as kernels: `delay_masses`, and the operators built from delays,
# from Distributions or from a type of their own, against the same operators
# built from the masses.

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

@testitem "delay_masses: a continuous distribution names the censoring package" setup = [DelayCases] begin
    # Whether the censoring extension is loaded depends on which items ran
    # first in this process, so the error is checked directly here and end
    # to end in a fresh process below.
    err = try
        CR._no_censoring(Gamma(2.0, 1.5))
    catch e
        e
    end
    @test err isa ArgumentError
    @test occursin("CensoredDistributions", sprint(showerror, err))
    @test occursin("Gamma", sprint(showerror, err))
    # Anything else reaching the continuous fallback gets an error that
    # names no package.
    err = try
        CR._continuous_masses(:not_a_delay, 3)
    catch e
        e
    end
    @test err isa ArgumentError
    @test occursin("Symbol", sprint(showerror, err))
    @test !occursin("CensoredDistributions", sprint(showerror, err))
end

@testitem "Continuous delays: an error naming CensoredDistributions without it" begin
    script = raw"""
    using ComposableRecurrences, Distributions, LinearAlgebra
    loaded(name) = any(k -> k.name == name, keys(Base.loaded_modules))
    println(loaded("CensoredDistributions"))
    names_it(f) = try
        f()
        false
    catch err
        err isa ArgumentError &&
            occursin("CensoredDistributions", sprint(showerror, err))
    end
    d = LogNormal(1.5, 0.75)
    g = Gamma(2.0, 1.0)
    println(
        all(
            names_it, (
                () -> ComposableRecurrences.delay_masses(d, 4),
                () -> Convolution(d; lags = 4),
                () -> Recurrence(g; lags = 4),
                () -> Recurrence(PerStratum([g, g]); lags = 4),
                () -> Convolution(TimeVarying([g, g]); lags = 4),
                () -> Recurrence(Pairwise(fill(g, 2, 2)); lags = 4),
                () -> Recurrence(Routes(([1.0 0.0; 0.0 1.0], g)); lags = 4),
            )
        )
    )
    """
    project = Base.active_project()
    cmd = `$(Base.julia_cmd()) --startup-file=no --project=$project -e $script`
    lines = split(read(cmd, String), '\n'; keepempty = false)
    @test lines[1] == "false"
    @test lines[2] == "true"
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
    @test_throws ArgumentError Convolution(d)
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
    @test_throws ArgumentError Recurrence(d)
end

@testitem "Delay distributions: lags is checked" setup = [DelayCases] begin
    d = Poisson(1.0)
    @test_throws ArgumentError Recurrence(d; lags = 1)
    @test_throws ArgumentError Recurrence(d; lags = 0)
    @test_throws ArgumentError Convolution(d; lags = 0)
    @test_throws ArgumentError Convolution(d; lags = 2.0)
    @test_throws ArgumentError Recurrence(PerStratum([d, d]); lags = 1)
    # A kernel of masses alone takes no `lags`.
    @test_throws ArgumentError Recurrence([0.3, 0.2]; lags = 5)
    @test_throws ArgumentError Convolution([0.3, 0.2]; lags = 5)
    @test_throws ArgumentError Recurrence(PerStratum(ones(2, 3)); lags = 4)
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
    # Routes of arrays alone take no `lags`.
    arrays = Routes((C1, [0.5, 0.3]), (C2, [0.1, 0.1, 0.2]))
    @test_throws ArgumentError Recurrence(arrays; lags = 4)
end

@testitem "Discrete delays: a step sums whole lags" setup = [DelayCases] begin
    for (d, n) in ((Poisson(6.0), 7), (NegativeBinomial(3, 0.4), 2))
        by_hand = [sum(pdf(d, n * l + j) for j in 0:(n - 1)) for l in 0:4]
        m = @inferred CR.delay_masses(d, 5; step = n)
        @test m ≈ by_hand
        @test CR.delay_masses(d, 5; step = float(n)) ≈ by_hand
        @test Convolution(d; lags = 5, step = n).kernel ≈ by_hand
        @test Recurrence(d; lags = 5, step = n).kernel ≈ by_hand[2:end]
    end
    @test CR.delay_masses(Poisson(2.0), 4; step = 1) == masses(Poisson(2.0), 4)
    for step in (0.25, 1.5, 0, -2)
        @test_throws ArgumentError CR.delay_masses(Poisson(2.0), 4; step)
    end
    err = try
        Convolution(Poisson(2.0); lags = 4, step = 0.25)
    catch e
        e
    end
    @test occursin("whole number", sprint(showerror, err))
end

@testitem "Delay distributions: step is checked" setup = [DelayCases] begin
    k = [0.2, 0.5, 0.3]
    @test CR.delay_masses(k, 3; step = 7) === k
    d = Poisson(1.0)
    for step in (0, -1, :week, nothing)
        @test_throws ArgumentError Convolution(d; lags = 3, step)
        @test_throws ArgumentError Recurrence(d; lags = 3, step)
    end
    # A step needs a kernel of delays and `lags`.
    @test_throws ArgumentError Convolution(k; step = 7)
    @test_throws ArgumentError Recurrence(k; step = 7)
    @test_throws ArgumentError Recurrence(d; step = 7)
    @test_throws ArgumentError Recurrence(k; lags = 3, step = 7)
    err = try
        Recurrence(k; step = 7)
    catch e
        e
    end
    @test occursin("lags", sprint(showerror, err))
    @test Convolution(k; step = 1).kernel === k
end

@testitem "Discrete delays: gradients reach the parameters on a step" setup = [ReferenceAD, DelayCases] begin
    x = [1.0, 3.0, 2.0, 5.0, 4.0, 1.0]
    conv(λ) = sum(Convolution(Poisson(λ); lags = 4, step = 2)(x))
    g = ReferenceAD.derivative(conv, 1.5)
    ϵ = 1.0e-6
    @test g ≈ (conv(1.5 + ϵ) - conv(1.5 - ϵ)) / 2ϵ rtol = 1.0e-6
    @test g != 0
end

@testitem "Delay distributions: gradients reach the parameters" setup = [ReferenceAD, DelayCases] begin
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
        g = ReferenceAD.derivative(f, 1.5)
        ϵ = 1.0e-6
        @test g ≈ (f(1.5 + ϵ) - f(1.5 - ϵ)) / 2ϵ rtol = 1.0e-6
        @test g != 0
    end
end

@testitem "Routes: arrays alone hold no delays" setup = [DelayCases] begin
    using SparseArrays
    routes = Routes(
        ([0.9 0.1; 0.1 0.9], [0.5, 0.3]), (sparse([0.0 0.4; 0.4 0.0]), [0.1, 0.2, 0.3])
    )
    folded = Routes((0.5I, [0.5, 0.3]), (0.2I, [0.1, 0.2]))
    R = fill(1.2, 2, 6)
    h = ones(2, 3)
    for rs in (routes, folded)
        r = @inferred Recurrence(rs)
        @test_throws ArgumentError Recurrence(rs; lags = 4)
        @test typeof(@inferred Recurrence(rs; coupling = I)) == typeof(r)
    end
    @test !(@inferred CR._has_delays(typeof(routes)))
    @test @inferred CR._has_delays(typeof(Routes((I, Poisson(1.0)), (I, [0.1]))))
end

@testsnippet ChainedDelays begin
    using ComposableRecurrences, Distributions, LinearAlgebra
    CR = ComposableRecurrences
    # The full linear convolution of `a` and `b`, by the definition.
    function full(a, b)
        c = zeros(promote_type(eltype(a), eltype(b)), length(a) + length(b) - 1)
        for i in eachindex(a), j in eachindex(b)
            c[i + j - 1] += a[i] * b[j]
        end
        return c
    end
    cut(c, lags) = [l < length(c) ? c[l + 1] : zero(eltype(c)) for l in 0:(lags - 1)]
end

@testitem "delay_masses: a chain of mass vectors is their full convolution" setup = [ChainedDelays] begin
    a = [0.1 * l for l in 1:6] ./ 2.1
    b = [0.4, 0.3, 0.2, 0.1]
    @test (@inferred CR.delay_masses((a, b), 9)) ≈ full(a, b)
    # Cut before the end, and zeros past it.
    @test CR.delay_masses((a, b), 4) ≈ full(a, b)[1:4]
    @test CR.delay_masses((a, b), 12) ≈ cut(full(a, b), 12)
    @test CR.delay_masses((b, a), 9) ≈ CR.delay_masses((a, b), 9)
    # Three links, and one.
    c = [0.7, 0.3]
    @test (@inferred CR.delay_masses((a, b, c), 10)) ≈ full(full(a, b), c)
    @test CR.delay_masses((a,), 8) == cut(a, 8)
    @test CR.delay_masses((a, (b, c)), 10) ≈ full(full(a, b), c)
    # The convolution of `b` padded with zeros, as a series.
    padded = Convolution(a)(vcat(b, zeros(length(a) - 1)))
    @test CR.delay_masses((a, b), 9) ≈ padded
    # Integer masses keep their type.
    @test CR.delay_masses(([1, 2], [3, 4]), 3) == [3, 10, 8]
    @test !CR._isdelay(Tuple{})
    @test CR._isdelay(Tuple{Vector{Float64}, Vector{Float64}})
    @test CR._isdelay(Tuple{Vector{Float64}, Tuple{Vector{Float64}}})
    @test !CR._isdelay(Tuple{Float64, Float64})
    @test !CR._isdelay(Tuple{Vector{Float64}, Symbol})
    @test !CR._isdelay(Tuple{Vararg{Vector{Float64}}})
    # A union of tuple types is a delay when each member is.
    @test CR._isdelay(Union{Tuple{Vector{Float64}}, Tuple{Vector{Float64}, Vector{Float64}}})
    @test !CR._isdelay(Union{Tuple{Vector{Float64}}, Tuple{Float64}})
    @test !CR._isdelay(Tuple{Vector{Poisson{Float64}}, Vector{Float64}})
    @test_throws ArgumentError Convolution(
        (Poisson.([1.0, 2.0]), [0.5, 0.5]); lags = 3
    )
end

@testitem "Chained delays: as kernels" setup = [ChainedDelays] begin
    a, b = [0.5, 0.3, 0.2], [0.6, 0.4]
    c = @inferred Convolution((a, b); lags = 4)
    @test c.kernel ≈ full(a, b)
    r = @inferred Recurrence((a, b); lags = 4, coupling = [0.9 0.1; 0.2 0.8])
    @test r.kernel ≈ full(a, b)[2:end]
    x = [1.0, 3.0, 2.0, 5.0, 4.0]
    @test c(x) ≈ Convolution(full(a, b))(x)
    # Delays chain through their own masses.
    d, e = Poisson(1.5), Geometric(0.4)
    m(d) = pdf.(d, 0:5)
    @test Convolution((d, e); lags = 6).kernel ≈ cut(full(m(d), m(e)), 6)
    @test Convolution((d, b); lags = 6).kernel ≈ cut(full(m(d), b), 6)
    # On a step, each delay's masses are on lags of that width.
    @test Convolution((d, e); lags = 3, step = 2).kernel ≈ cut(
        full(CR.delay_masses(d, 3; step = 2), CR.delay_masses(e, 3; step = 2)), 3
    )
    # A chain per stratum.
    d2, e2 = Poisson(2.5), Geometric(0.6)
    ps = @inferred Recurrence(PerStratum([(d, e), (d2, e2)]); lags = 4)
    @test ps.kernel.x[2, :] ≈ cut(full(m(d2), m(e2)), 4)[2:end]
    @test_throws ArgumentError Convolution((a, b))
    @test_throws ArgumentError Recurrence((a, b))
    # A tuple of anything else is no delay, so it keeps the kernel errors.
    @test_throws ArgumentError Convolution((a, :not_a_delay); lags = 3)
    @test_throws ArgumentError Convolution((0.5, 0.5))
end

@testitem "Chained delays: the Jacobian is the convolution transposed" setup = [ReferenceAD, ChainedDelays] begin
    a = [0.5, 0.3, 0.2]
    b = [0.6, 0.3, 0.1, 0.05]
    function toeplitz(v, lags, n)
        return [0 <= l - j < length(v) ? v[l - j + 1] : 0.0 for l in 0:(lags - 1), j in 0:(n - 1)]
    end
    for lags in (3, 6, 8)
        Ja = ReferenceAD.jacobian(a -> CR.delay_masses((a, b), lags), a)
        Jb = ReferenceAD.jacobian(b -> CR.delay_masses((a, b), lags), b)
        # Entry `(l, j)` of the Jacobian in `a` is `b[l - j]`, and in `b` it
        # is `a[l - j]`.
        @test Ja == toeplitz(b, lags, length(a))
        @test Jb == toeplitz(a, lags, length(b))
    end
    # Through a distribution's parameter, and the operator built from it.
    x = [1.0, 3.0, 2.0, 5.0, 4.0, 1.0]
    conv(λ) = sum(Convolution((Poisson(λ), b); lags = 5)(x))
    g = ReferenceAD.derivative(conv, 1.5)
    ϵ = 1.0e-6
    @test g ≈ (conv(1.5 + ϵ) - conv(1.5 - ϵ)) / 2ϵ rtol = 1.0e-6
    @test g != 0
end

@testitem "Chained delays: the Mooncake rule's pullback" setup = [ReferenceAD] begin
    using ComposableRecurrences, ForwardDiff, Mooncake
    using Random: Xoshiro
    CR = ComposableRecurrences
    a, b = [0.5, 0.3, 0.2], [0.6, 0.3, 0.1, 0.05]
    for lags in (3, 6, 8)
        c̄ = collect(1.0:lags) ./ lags
        Ja = ReferenceAD.jacobian(a -> CR._convolve_masses(a, b, lags), a)
        Jb = ReferenceAD.jacobian(b -> CR._convolve_masses(a, b, lags), b)
        f = CR._convolve_masses
        cache = Mooncake.prepare_pullback_cache(f, a, b, lags)
        _, (_, ā, b̄, _) = Mooncake.value_and_pullback!!(cache, c̄, f, a, b, lags)
        @test ā ≈ Ja' * c̄
        @test b̄ ≈ Jb' * c̄
    end
    # The same vector as both links, in traced code, takes both cotangents.
    c̄ = collect(1.0:5.0)
    square(a) = CR._convolve_masses(a, a, 5)
    J = ReferenceAD.jacobian(square, a)
    cache = Mooncake.prepare_pullback_cache(square, a)
    _, (_, ā) = Mooncake.value_and_pullback!!(cache, c̄, square, a)
    @test ā ≈ J' * c̄
    for lags in (4, 6)
        Mooncake.TestUtils.test_rule(
            Xoshiro(1), CR._convolve_masses, a, b, lags;
            is_primitive = true, perf_flag = :none, mode = Mooncake.ReverseMode
        )
    end
    # Views of one parameter vector, as a model hands them over.
    θ = [a; b]
    split(θ) = CR._convolve_masses(view(θ, 1:3), view(θ, 4:7), 6)
    c̄ = collect(1.0:6.0)
    J = ReferenceAD.jacobian(split, θ)
    cache = Mooncake.prepare_pullback_cache(split, θ)
    _, (_, θ̄) = Mooncake.value_and_pullback!!(cache, c̄, split, θ)
    @test θ̄ ≈ J' * c̄
    Mooncake.TestUtils.test_rule(
        Xoshiro(1), CR._convolve_masses, view(θ, 1:3), view(θ, 4:7), 6;
        is_primitive = true, perf_flag = :none, mode = Mooncake.ReverseMode
    )
end

@testsnippet OwnDelay begin
    using ComposableRecurrences, LinearAlgebra
    CR = ComposableRecurrences
    # A delay type that is not a Distributions type, with its own method.
    struct GeometricDelay{T}
        p::T
    end
    function CR.delay_masses(d::GeometricDelay, lags)
        return map(l -> d.p * (1 - d.p)^l, 0:(lags - 1))
    end
    masses(d, lags) = CR.delay_masses(d, lags)
    tail(d, lags) = masses(d, lags)[2:end]
end

@testitem "A delay type of its own: one delay" setup = [OwnDelay] begin
    d = GeometricDelay(0.4)
    @test CR._isdelay(GeometricDelay{Float64})
    @test !CR._isdelay(Vector{Float64})
    @test !CR._isdelay(Float64)
    c = @inferred Convolution(d; lags = 4)
    @test c.kernel ≈ masses(d, 4)
    r = @inferred Recurrence(d; lags = 4, coupling = [0.9 0.1; 0.2 0.8])
    @test r.kernel ≈ tail(d, 4)
    x = [1.0, 3.0, 2.0, 5.0, 4.0]
    @test c(x) ≈ Convolution(masses(d, 4))(x)
    @test_throws ArgumentError Convolution(d)
    @test_throws ArgumentError Recurrence(d)
    @test_throws ArgumentError Recurrence(d; lags = 1)
    err = try
        Convolution(d)
    catch e
        e
    end
    @test occursin("lags", sprint(showerror, err))
end

@testitem "A delay type of its own: in each wrapper" setup = [OwnDelay] begin
    ds = [GeometricDelay(0.2), GeometricDelay(0.5), GeometricDelay(0.7)]
    ps = @inferred Recurrence(PerStratum(ds); lags = 4)
    @test size(ps.kernel.x) == (3, 3)
    @test ps.kernel.x[2, :] ≈ tail(ds[2], 4)
    tv = @inferred Convolution(TimeVarying(ds); lags = 3)
    @test tv.kernel.x[:, 3] ≈ masses(ds[3], 3)
    D = [GeometricDelay(0.1 * (i + j)) for i in 1:2, j in 1:2]
    pw = @inferred Recurrence(Pairwise(D); lags = 4)
    @test pw.kernel.x[2, 1, :] ≈ tail(D[2, 1], 4)
    G = [GeometricDelay(0.1 * (s + t)) for s in 1:2, t in 1:3]
    tvs = @inferred Recurrence(TimeVarying(PerStratum(G)); lags = 3)
    @test tvs.kernel.x.x[2, :, 3] ≈ tail(G[2, 3], 3)
    C1 = [0.9 0.1; 0.1 0.9]
    rt = Recurrence(Routes((C1, ds[1]), (0.5I, [0.2, 0.1])); lags = 4)
    @test rt.kernel.kernels[1] ≈ tail(ds[1], 4)
    @test rt.kernel.kernels[2] == [0.2, 0.1]
    @test_throws ArgumentError Recurrence(Routes((C1, ds[1])))
    @test_throws ArgumentError Recurrence(ds; lags = 3)
end

@testitem "A delay type of its own: a step" setup = [OwnDelay] begin
    # A method with `step`: the masses of `step` units summed for a lag.
    struct SteppedDelay
        p::Float64
    end
    function CR.delay_masses(d::SteppedDelay, lags; step = 1)
        q = (1 - d.p)^step
        return map(l -> (1 - q) * q^l, 0:(lags - 1))
    end
    units = CR.delay_masses(SteppedDelay(0.3), 12)
    c = @inferred Convolution(SteppedDelay(0.3); lags = 4, step = 3)
    @test c.kernel ≈ vec(sum(reshape(units, 3, :); dims = 1))
    r = Recurrence(SteppedDelay(0.3); lags = 4, step = 3)
    @test r.kernel ≈ c.kernel[2:end]
    # A method without `step` serves a step of 1 only.
    @test Convolution(GeometricDelay(0.4); lags = 4, step = 1).kernel ≈
        masses(GeometricDelay(0.4), 4)
    @test_throws MethodError Convolution(
        GeometricDelay(0.4); lags = 4, step = 2
    )
end

@testitem "A delay type of its own: gradients reach the parameter" setup = [ReferenceAD, OwnDelay] begin
    x = [1.0, 3.0, 2.0, 5.0, 4.0, 1.0]
    conv(p) = sum(Convolution(GeometricDelay(p); lags = 4)(x))
    rec(p) = sum(
        Recurrence(GeometricDelay(p); lags = 4)(fill(1.1, 6); history = ones(3))
    )
    for f in (conv, rec)
        g = ReferenceAD.derivative(f, 0.4)
        ϵ = 1.0e-6
        @test g ≈ (f(0.4 + ϵ) - f(0.4 - ϵ)) / 2ϵ rtol = 1.0e-6
        @test g != 0
    end
end

@testsnippet CensoredDelays begin
    using ComposableRecurrences, Distributions, CensoredDistributions
    CR = ComposableRecurrences
    censored(d, lags) =
        [pdf(double_interval_censored(d; interval = 1), l) for l in 0:(lags - 1)]
    # The double interval censored mass on lag `l`, by hand: the primary
    # event uniform on `[0, Δ)`, the delay read on `[lΔ, (l + 1)Δ)`, the
    # average over the primary event by the midpoint rule.
    function by_hand(d, l, Δ; n = 4000)
        us = ((1:n) .- 0.5) .* (Δ / n)
        return sum(u -> cdf(d, (l + 1) * Δ - u) - cdf(d, l * Δ - u), us) / n
    end
end

@testitem "Continuous delays: double interval censored with the defaults" setup = [CensoredDelays] begin
    for d in (LogNormal(1.5, 0.75), Gamma(2.0, 3.0))
        m = @inferred CR.delay_masses(d, 30)
        @test m isa Vector{Float64}
        @test m ≈ censored(d, 30)
        @test CR.delay_masses(d, 30; step = 1) ≈ m
        @test m ≈ [by_hand(d, l, 1) for l in 0:29] atol = 1.0e-8
    end
    @test CR._isdelay(LogNormal{Float64})
end

@testitem "Continuous delays: as kernels" setup = [CensoredDelays] begin
    d = LogNormal(1.5, 0.75)
    c = @inferred Convolution(d; lags = 30)
    @test c.kernel ≈ censored(d, 30)
    g = Gamma(2.0, 3.0)
    r = @inferred Recurrence(g; lags = 20)
    @test r.kernel ≈ censored(g, 20)[2:end]
    ps = Recurrence(PerStratum([g, Gamma(3.0, 2.0)]); lags = 6)
    @test ps.kernel.x[2, :] ≈ censored(Gamma(3.0, 2.0), 6)[2:end]
    # A discrete and a continuous delay on separate routes.
    mixed = Routes(([0.9 0.1; 0.1 0.9], Poisson(2.0)), ([0.0 0.4; 0.4 0.0], g))
    rt = Recurrence(mixed; lags = 6)
    @test rt.kernel.kernels[2] ≈ censored(g, 6)[2:end]
end

@testitem "Continuous delays: gradients reach the parameters" setup = [ReferenceAD, CensoredDelays] begin
    x = [1.0, 3.0, 2.0, 5.0, 4.0, 1.0, 2.0, 3.0]
    conv(μ) = sum(Convolution(LogNormal(μ, 0.75); lags = 8)(x))
    g = ReferenceAD.derivative(conv, 1.2)
    ϵ = 1.0e-6
    @test g ≈ (conv(1.2 + ϵ) - conv(1.2 - ϵ)) / 2ϵ rtol = 1.0e-5
    @test g != 0
end

@testitem "Continuous delays: a weekly step on a daily delay" setup = [CensoredDelays] begin
    d = Gamma(2.0, 3.0)
    m = @inferred CR.delay_masses(d, 5; step = 7)
    @test m ≈ [by_hand(d, l, 7) for l in 0:4] atol = 1.0e-8
    # Censoring on weeks by hand with CensoredDistributions.
    weeks = double_interval_censored(d; primary_event = Uniform(0, 7), interval = 7)
    @test m ≈ [pdf(weeks, 7l) for l in 0:4]
    @test CR.delay_masses(d, 5; step = 7.0) ≈ m
    c = @inferred Convolution(d; lags = 5, step = 7)
    @test c.kernel ≈ m
    r = @inferred Recurrence(d; lags = 5, step = 7)
    @test r.kernel ≈ m[2:end]
    ps = Recurrence(PerStratum([d, Gamma(3.0, 2.0)]); lags = 5, step = 7)
    @test ps.kernel.x[1, :] ≈ m[2:end]
end

@testitem "Continuous delays: a quarter-day step on a daily delay" setup = [CensoredDelays] begin
    d = LogNormal(1.5, 0.75)
    m = CR.delay_masses(d, 80; step = 0.25)
    @test m ≈ [by_hand(d, l, 0.25) for l in 0:79] atol = 1.0e-8
    @test Convolution(d; lags = 80, step = 0.25).kernel ≈ m
    # Lags count steps, so 80 quarter days cover the 20 days of 20 daily
    # lags. The primary event spans one step, a quarter day here, so the
    # sums of four quarter days are not the daily masses, whose primary
    # event spans a day.
    daily = CR.delay_masses(d, 20)
    @test sum(m) ≈ sum(daily) atol = 0.01
    @test !(vec(sum(reshape(m, 4, :); dims = 1)) ≈ daily)
end

@testitem "Continuous delays: gradients reach the parameters on a step" setup = [ReferenceAD, CensoredDelays] begin
    x = [1.0, 3.0, 2.0, 5.0, 4.0, 1.0, 2.0, 3.0]
    conv(μ) = sum(Convolution(LogNormal(μ, 0.75); lags = 4, step = 7)(x))
    g = ReferenceAD.derivative(conv, 1.2)
    ϵ = 1.0e-6
    @test g ≈ (conv(1.2 + ϵ) - conv(1.2 - ϵ)) / 2ϵ rtol = 1.0e-5
    @test g != 0
end
