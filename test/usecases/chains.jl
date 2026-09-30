# Chained operators: a latent AR process mapped to R_t driving a renewal
# whose infections are then delayed, and BVD's renewal into its delay.

@testitem "Use case: AR → exp → renewal → delay" tags = [:usecase] setup = [UseCaseReferences] begin
    using ComposableRecurrences, ForwardDiff
    C = UseCaseReferences.CTIDMReference

    ρ = [0.6, 0.2]
    init = [0.1, 0.2]
    ϵ = [0.05, -0.1, 0.1, 0.02, -0.05, 0.08, 0.0, -0.1, 0.05, 0.03]
    g = [0.2, 0.5, 0.3]
    I₀, r, N = 5.0, 0.1, 1000.0
    pmf = [0.3, 0.4, 0.3]
    d = length(pmf)
    step = C.RenewalStep(
        C.ConstantRenewalStep(reverse(g)), (C.SusceptibleDepletion(N),)
    )
    function ref_chain(ρ, ϵ)
        log_Rt = C.ar(ρ, init, ϵ)
        infections = C.renewal(step, g, I₀, r, exp.(log_Rt))
        return C.latent_delay(pmf, infections)
    end
    ref = ref_chain(ρ, ϵ)
    w = range(0.5, 2.0; length = length(ref))
    θ0 = vcat(ρ, ϵ)
    ∇ref = ForwardDiff.gradient(θ -> sum(w .* ref_chain(θ[1:2], θ[3:end])), θ0)

    window = C.renewal_window(step, g, I₀, r)
    function chain(ρ, ϵ)
        ar = Recurrence(ρ)
        log_Rt = vcat(init, ar(1.0; history = init, add = ϵ))
        depletion = ComposableRecurrences.Depletion(N; form = :floor)
        renewal = Recurrence(g; modifiers = (depletion,))
        infections = renewal(exp.(log_Rt); history = window)
        return Convolution(pmf)(infections)[d:end]
    end
    @test chain(ρ, ϵ) ≈ ref
    ∇ = ForwardDiff.gradient(θ -> sum(w .* chain(θ[1:2], θ[3:end])), θ0)
    @test ∇ ≈ ∇ref
end

@testitem "Use case: BVD renewal → delay" tags = [:usecase] setup = [UseCaseReferences] begin
    using ComposableRecurrences, ForwardDiff
    B = UseCaseReferences.BVDReference

    g = [0.3, 0.5, 0.2]
    seed = [2.0, 3.0, 4.0]
    L = length(seed)
    N = 500.0
    delay = [0.1, 0.4, 0.3, 0.2]
    Rt = [0.0, 0.0, 0.0, 2.5, 2.4, 2.2, 2.0, 1.8, 1.5, 1.2, 1.0, 0.9]
    ref_chain(Rt) = B.convolve_delay(B.renewal_infections(Rt, g, seed, N), delay)
    ref = ref_chain(Rt)
    w = range(0.5, 2.0; length = length(ref))
    ∇ref = ForwardDiff.gradient(θ -> sum(w .* ref_chain(θ)), Rt)

    function chain(Rt)
        depletion = ComposableRecurrences.Depletion(
            N; form = :hazard, seeded = true
        )
        renewal = Recurrence(g; modifiers = (depletion,))
        infections = vcat(seed, renewal(Rt[(L + 1):end]; history = seed))
        return Convolution(delay)(infections)
    end
    @test chain(Rt) ≈ ref
    @test ForwardDiff.gradient(θ -> sum(w .* chain(θ)), Rt) ≈ ∇ref
end
