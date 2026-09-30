# Reporting delays: CTIDM's LatentDelay (fixed and time-varying pmf) and
# BVD's `convolve_delay`. Each is a causal convolution whose kernel is
# indexed from lag 0.

@testitem "Use case: fixed reporting delay (LatentDelay)" tags = [:usecase, :usecase_pending] setup = [UseCaseReferences] begin
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

@testitem "Use case: time-varying reporting delay" tags = [:usecase, :usecase_pending] setup = [UseCaseReferences] begin
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
    tv_delay(P, Y) = Convolution(TimeVarying(P); indexed_by = :secondary)(
        Y
    )[d:end]
    @test tv_delay(P, Y) ≈ ref
    @test ForwardDiff.gradient(θ -> sum(w .* tv_delay(unpack(θ)...)), θ0) ≈ ∇ref
end

@testitem "Use case: BVD convolve_delay" tags = [:usecase, :usecase_pending] setup = [UseCaseReferences] begin
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
