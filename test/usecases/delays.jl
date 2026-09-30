# Reporting delays: CTIDM's LatentDelay (fixed and time-varying pmf) and
# Aggregate, and BVD's `convolve_delay`, `convolve_pmf` and
# `bin_increments`. Each is a causal convolution whose kernel is indexed from
# lag 0, or a running total.

@testitem "Use case: fixed reporting delay (LatentDelay)" tags = [:usecase] setup = [UseCaseReferences] begin
    using ComposableRecurrences, ForwardDiff
    C = UseCaseReferences.CTIDMReference

    pmf = [0.2, 0.5, 0.3]
    d = length(pmf)
    Y = [5.0, 8.0, 12.0, 15.0, 14.0, 11.0, 9.0, 7.0, 6.0, 4.0]
    ref = C.latent_delay(pmf, Y)
    w = range(0.5, 2.0; length = length(ref))
    θ0 = vcat(pmf, Y)
    ∇ref = ForwardDiff.gradient(
        θ -> sum(w .* C.latent_delay(θ[1:d], θ[(d + 1):end])), θ0
    )

    # CTIDM reports the times with a full delay window, `d:n`.
    latent_delay(pmf, Y) = Convolution(pmf)(Y)[d:end]
    @test latent_delay(pmf, Y) ≈ ref
    ∇ = ForwardDiff.gradient(
        θ -> sum(w .* latent_delay(θ[1:d], θ[(d + 1):end])), θ0
    )
    @test ∇ ≈ ∇ref
end

@testitem "Use case: time-varying reporting delay" tags = [:usecase] setup = [UseCaseReferences] begin
    using ComposableRecurrences, ForwardDiff
    C = UseCaseReferences.CTIDMReference

    Y = [5.0, 8.0, 12.0, 15.0, 14.0, 11.0, 9.0, 7.0, 6.0, 4.0]
    n = length(Y)
    d = 3
    # One pmf per time, lengthening as reporting slows.
    early, late = [0.6, 0.3, 0.1], [0.1, 0.3, 0.6]
    P = reduce(
        hcat, [early .* (1 - s) .+ late .* s for s in range(0, 1; length = n)]
    )
    ref = C.time_varying_latent_delay(collect(eachcol(P)), Y)
    w = range(0.5, 2.0; length = length(ref))
    θ0 = vcat(vec(P), Y)
    unpack(θ) = (reshape(θ[1:(d * n)], d, n), θ[(d * n + 1):end])
    function ref_loss(θ)
        P, Y = unpack(θ)
        return sum(w .* C.time_varying_latent_delay(collect(eachcol(P)), Y))
    end
    ∇ref = ForwardDiff.gradient(ref_loss, θ0)

    # The kernel is `L × T`: column `t` weights the inputs reaching time `t`.
    tv_delay(P, Y) = Convolution(TimeVarying(P))(Y)[d:end]
    @test tv_delay(P, Y) ≈ ref
    @test ForwardDiff.gradient(θ -> sum(w .* tv_delay(unpack(θ)...)), θ0) ≈ ∇ref
end

@testitem "Use case: BVD convolve_delay" tags = [:usecase] setup = [UseCaseReferences] begin
    using ComposableRecurrences, ForwardDiff
    B = UseCaseReferences.BVDReference

    delay = [0.1, 0.4, 0.3, 0.2]
    x = [5.0, 8.0, 12.0, 15.0, 14.0, 11.0, 9.0, 7.0, 6.0, 4.0]
    X = vcat(x', 2 .* x', reverse(x)')
    ref = B.convolve_delay(x, delay)
    refX = reduce(vcat, [B.convolve_delay(r, delay)' for r in eachrow(X)])
    w = range(0.5, 2.0; length = length(x))
    ∇ref = ForwardDiff.gradient(
        θ -> sum(w .* B.convolve_delay(θ[5:end], θ[1:4])), vcat(delay, x)
    )

    # Same length as the input: early times see a truncated kernel.
    @test Convolution(delay)(x) ≈ ref
    # A strata × time input convolves each row.
    @test Convolution(delay)(X) ≈ refX
    ∇ = ForwardDiff.gradient(
        θ -> sum(w .* Convolution(θ[1:4])(θ[5:end])), vcat(delay, x)
    )
    @test ∇ ≈ ∇ref
end

@testitem "Use case: BVD convolve_pmf" tags = [:usecase] setup = [UseCaseReferences] begin
    using ComposableRecurrences, ForwardDiff
    B = UseCaseReferences.BVDReference

    # Onset to report, then report to confirmation: the pmf of the sum of the
    # two delays, length na + nb - 1.
    a = [0.1, 0.4, 0.3, 0.2]
    b = [0.5, 0.3, 0.2]
    na, nb = length(a), length(b)
    ref = B.convolve_pmf(a, b)
    w = range(0.5, 2.0; length = length(ref))
    ∇ref = ForwardDiff.gradient(
        θ -> sum(w .* B.convolve_pmf(θ[1:na], θ[(na + 1):end])), vcat(a, b)
    )

    # A full convolution is a causal one over `b` padded to the output length.
    compose(a, b) = Convolution(a)(vcat(b, zeros(eltype(b), na - 1)))
    @test compose(a, b) ≈ ref
    @test sum(compose(a, b)) ≈ 1
    @test ForwardDiff.gradient(
        θ -> sum(w .* compose(θ[1:na], θ[(na + 1):end])), vcat(a, b)
    ) ≈ ∇ref
end

@testitem "Use case: window aggregation" tags = [:usecase] setup = [UseCaseReferences] begin
    using ComposableRecurrences, ForwardDiff
    C = UseCaseReferences.CTIDMReference
    B = UseCaseReferences.BVDReference

    Y = [5.0, 8.0, 12.0, 15.0, 14.0, 11.0, 9.0, 7.0, 6.0, 4.0, 3.0, 2.0]
    n = length(Y)
    # CTIDM's `Aggregate`: the window lengths per time, `0` where nothing is
    # reported; a window may be clipped at the start.
    aggregation = [0, 3, 0, 0, 3, 0, 0, 0, 4, 0, 1, 2]
    idx = findall(!=(0), aggregation)
    ref = C.aggregate(aggregation, Y)
    wa = range(0.5, 2.0; length = length(ref))
    ∇ref = ForwardDiff.gradient(y -> sum(wa .* C.aggregate(aggregation, y)), Y)

    # A box kernel from lag 0 whose width is the window reported at `t`.
    box = [d < aggregation[t] ? 1.0 : 0.0 for d in 0:(maximum(aggregation) - 1), t in 1:n]
    aggregate(Y) = Convolution(TimeVarying(box))(Y)[idx]
    @test aggregate(Y) ≈ ref
    @test ForwardDiff.gradient(y -> sum(wa .* aggregate(y)), Y) ≈ ∇ref

    # BVD's `bin_increments`: sums over the windows between report days, an
    # empty window giving zero. The difference of a running total at the
    # window ends.
    days = [3, 7, 7, 10, 12]
    refb = B.bin_increments(Y, days)
    wb = range(0.5, 2.0; length = length(days))
    ∇refb = ForwardDiff.gradient(y -> sum(wb .* B.bin_increments(y, days)), Y)
    function bins(Y)
        total = vcat(zero(eltype(Y)), Recurrence([1.0])(1.0; history = [0.0], add = Y))
        return total[days .+ 1] .- total[vcat(0, days[1:(end - 1)]) .+ 1]
    end
    @test bins(Y) ≈ refb
    @test ForwardDiff.gradient(y -> sum(wb .* bins(y)), Y) ≈ ∇refb
end
