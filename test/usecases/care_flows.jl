# BVD's treatment-centre flows that follow each admission cohort: the
# confirmed stock and the abscond-thinned discharges. A cohort's kernel
# depends on its admission day through the confirmation hazard, so it is a
# convolution with a cohort-indexed (`Primary()`) time-varying kernel.
#
# Column `u` of the kernel is the delay profile of the cohort admitted on
# day `u`; its entries past the last day are never read.

@testitem "Use case: BVD two-clock confirmed stock" tags = [:usecase] setup = [UseCaseReferences] begin
    using ComposableRecurrences, ForwardDiff
    B = UseCaseReferences.BVDReference

    A = [3.0, 4.0, 5.0, 2.0, 1.0, 0.0, 2.0, 3.0, 1.0, 0.0]
    h = [0.2, 0.3, 0.4, 0.5, 0.5, 0.5, 0.4, 0.4, 0.3, 0.3]
    S_clin = [0.95, 0.85, 0.7, 0.5, 0.3, 0.1]
    n, L = length(A), length(S_clin)
    ref = B.two_clock_confirmed(A, h, S_clin)
    w = range(0.5, 2.0; length = n)
    unpack(θ) = (θ[1:n], θ[(n + 1):(2n)], θ[(2n + 1):end])
    θ0 = vcat(A, h, S_clin)
    ∇ref = ForwardDiff.gradient(
        θ -> sum(w .* B.two_clock_confirmed(unpack(θ)...)), θ0
    )

    # O_conf(t) = Σ_u A(u) (1 - Π_{j=u+1}^{t} (1 - h_j)) S_clin(t - u): the
    # cohort admitted on day u is confirmed with probability 1 minus its
    # survival against the hazard since admission.
    function confirmed(A, h, S_clin)
        unconfirmed(u) = vcat(1, cumprod(1 .- h[min.((u + 1):(u + L - 1), n)]))
        K = reduce(hcat, [(1 .- unconfirmed(u)) .* S_clin for u in 1:n])
        return Convolution(TimeVarying(K, ComposableRecurrences.Primary()))(A)
    end
    @test confirmed(A, h, S_clin) ≈ ref
    @test ForwardDiff.gradient(θ -> sum(w .* confirmed(unpack(θ)...)), θ0) ≈ ∇ref
end

@testitem "Use case: BVD abscond-thinned discharge flows" tags = [:usecase] setup = [UseCaseReferences] begin
    using ComposableRecurrences, ForwardDiff
    B = UseCaseReferences.BVDReference

    adm1 = [3.0, 4.0, 5.0, 2.0, 1.0, 0.0, 2.0, 3.0, 1.0, 0.0]
    adm2 = [1.0, 2.0, 2.0, 1.0, 1.0, 1.0, 0.0, 1.0, 2.0, 1.0]
    pmf1 = [0.1, 0.2, 0.3, 0.2, 0.1, 0.1]
    pmf2 = [0.3, 0.4, 0.3]
    κ = 0.1
    h = [0.2, 0.3, 0.4, 0.5, 0.5, 0.5, 0.4, 0.4, 0.3, 0.3]
    n, D = length(adm1), length(pmf1)
    ref = B.abscond_thinned_flows(adm1, pmf1, adm2, pmf2, κ, h)
    w = range(0.5, 2.0; length = n)
    unpack(θ) = (θ[1:n], θ[(n + 1):(2n)], θ[2n + 1], θ[(2n + 2):end])
    θ0 = vcat(adm1, adm2, κ, h)
    function ref_loss(θ)
        adm1, adm2, κ, h = unpack(θ)
        out1, out2 = B.abscond_thinned_flows(adm1, pmf1, adm2, pmf2, κ, h)
        return sum(w .* out1) + sum(w .* reverse(out2))
    end
    ∇ref = ForwardDiff.gradient(ref_loss, θ0)

    # Cohort u survives absconding at d days with
    # Π_{j ≤ d} (1 - κ Π_{i ≤ j} (1 - h_{u+i-1})); both schedules share it,
    # so they are two strata of one kernel, the shorter pmf padded.
    function flows(adm1, adm2, κ, h)
        pmfs = [pmf1'; vcat(pmf2, zeros(D - length(pmf2)))']
        survival(u) = vcat(1, cumprod(1 .- κ .* cumprod(1 .- h[min.(u:(u + D - 2), n)])))
        G = cat([pmfs .* survival(u)' for u in 1:n]...; dims = 3)
        c = Convolution(TimeVarying(PerStratum(G), ComposableRecurrences.Primary()))
        return c([adm1'; adm2'])
    end
    out = flows(adm1, adm2, κ, h)
    @test out[1, :] ≈ ref[1]
    @test out[2, :] ≈ ref[2]
    function loss(θ)
        out = flows(unpack(θ)...)
        return sum(w .* out[1, :]) + sum(w .* reverse(out[2, :]))
    end
    @test ForwardDiff.gradient(loss, θ0) ≈ ∇ref
end
