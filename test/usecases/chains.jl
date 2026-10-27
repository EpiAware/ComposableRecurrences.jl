# Chained operators: a latent AR process mapped to R_t driving a renewal
# whose infections are then delayed, and BVD's renewal into its delay.

@testitem "Use case: AR → exp → renewal → delay" tags = [:usecase] setup = [ReferenceAD, UseCaseReferences] begin
    using ComposableRecurrences, ForwardDiff
    C = UseCaseReferences.CTIDMReference

    ρ = [0.6, 0.2]
    init = [0.1, 0.2]
    ϵ = [0.05, -0.1, 0.1, 0.02, -0.05, 0.08, 0.0, -0.1, 0.05, 0.03]
    g = [0.2, 0.5, 0.3]
    I₀, r, N = 5.0, 0.1, 1000.0
    pmf = [0.3, 0.4, 0.3]
    d = length(pmf)
    step = UseCaseReferences.depleting_renewal_step(g, N)
    function ref_chain(ρ, ϵ)
        log_Rt = C.ar(ρ, init, ϵ)
        infections = C.renewal(step, g, I₀, r, exp.(log_Rt))
        return C.latent_delay(pmf, infections)
    end
    ref = ref_chain(ρ, ϵ)
    w = range(0.5, 2.0; length = length(ref))
    θ0 = vcat(ρ, ϵ)
    ∇ref = ReferenceAD.gradient(θ -> sum(w .* ref_chain(θ[1:2], θ[3:end])), θ0)

    window = ComposableRecurrences.exponential_history(I₀, r, length(g))
    function chain(ρ, ϵ)
        log_Rt = cat(init, Recurrence(ρ)(1.0; history = init, add = ϵ); dims = 1)
        depletion = ComposableRecurrences.Depletion(
            N, ComposableRecurrences.Floor()
        )
        renewal = Recurrence(g; modifiers = (depletion,))
        infections = renewal(exp.(log_Rt); history = window)
        return Convolution(pmf)(infections)[d:end]
    end
    @test chain(ρ, ϵ) ≈ ref
    ∇ = ReferenceAD.gradient(θ -> sum(w .* chain(θ[1:2], θ[3:end])), θ0)
    @test ∇ ≈ ∇ref
end

@testitem "Use case: BVD renewal → delay" tags = [:usecase] setup = [ReferenceAD, UseCaseReferences] begin
    using ComposableRecurrences, ForwardDiff
    B = UseCaseReferences.BVDReference

    g = [0.3, 0.5, 0.2]
    seed = [2.0, 3.0, 4.0]
    N = 500.0
    delay = [0.1, 0.4, 0.3, 0.2]
    Rt = [0.0, 0.0, 0.0, 2.5, 2.4, 2.2, 2.0, 1.8, 1.5, 1.2, 1.0, 0.9]
    ref_chain(Rt) = B.convolve_delay(B.renewal_infections(Rt, g, seed, N), delay)
    ref = ref_chain(Rt)
    w = range(0.5, 2.0; length = length(ref))
    ∇ref = ReferenceAD.gradient(θ -> sum(w .* ref_chain(θ)), Rt)

    function chain(Rt)
        # The seed is drawn from the pool, so it starts at N − Σ seed.
        depletion = ComposableRecurrences.Depletion(
            N; pools = (S = max(N - sum(seed), 0),)
        )
        renewal = Recurrence(g; modifiers = (depletion,))
        run = renewal(Rt; history = seed, start = length(seed) + 1)
        infections = cat(seed, run; dims = 1)
        return Convolution(delay)(infections)
    end
    @test chain(Rt) ≈ ref
    @test ReferenceAD.gradient(θ -> sum(w .* chain(θ)), Rt) ≈ ∇ref
end
