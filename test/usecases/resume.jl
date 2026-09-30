# Resuming from a returned state, as a forecast does: running a horizon in
# two pieces must match one run over the whole horizon.

@testitem "Use case: resume a depleting renewal" tags = [:usecase] setup = [UseCaseReferences] begin
    using ComposableRecurrences, ForwardDiff
    C = UseCaseReferences.CTIDMReference

    g = [0.2, 0.5, 0.3]
    I₀, r, N = 5.0, 0.1, 300.0
    Rt = [2.4, 2.3, 2.5, 2.2, 2.1, 2.0, 1.9, 2.2, 2.3, 2.1]
    T₁ = 6
    ref_step(N) = C.RenewalStep(
        C.ConstantRenewalStep(reverse(g)), (C.SusceptibleDepletion(N),)
    )
    ref = C.renewal(ref_step(N), g, I₀, r, Rt)
    w = range(0.5, 2.0; length = length(Rt))
    θ0 = vcat(N, Rt)
    ∇ref = ForwardDiff.gradient(
        θ -> sum(w .* C.renewal(ref_step(θ[1]), g, I₀, r, θ[2:end])), θ0
    )

    window = C.renewal_window(ref_step(N), g, I₀, r)
    function renewal(N)
        depletion = ComposableRecurrences.Depletion(N; form = :floor)
        return Recurrence(g; modifiers = (depletion,))
    end
    # The state carries the last `L` values and the susceptible pool.
    function split_run(N, Rt)
        fitted, state = renewal(N)(
            Rt[1:T₁]; history = window, return_state = true
        )
        forecast = renewal(N)(Rt[(T₁ + 1):end]; history = state)
        return vcat(fitted, forecast)
    end
    @test renewal(N)(Rt; history = window) ≈ ref
    @test split_run(N, Rt) ≈ ref
    ∇ = ForwardDiff.gradient(θ -> sum(w .* split_run(θ[1], θ[2:end])), θ0)
    @test ∇ ≈ ∇ref
end

@testitem "Use case: resume an AR(p) forecast" tags = [:usecase, :usecase_pending] setup = [UseCaseReferences] begin
    using ComposableRecurrences, ForwardDiff
    C = UseCaseReferences.CTIDMReference

    ρ = [0.5, 0.2]
    init = [0.1, 0.3]
    ϵ = [0.1, -0.2, 0.3, 0.05, -0.1, 0.2, 0.0, -0.3]
    T₁ = 5
    ref = C.ar(ρ, init, ϵ)
    w = range(0.5, 2.0; length = length(ref))
    θ0 = vcat(ρ, ϵ)
    ∇ref = ForwardDiff.gradient(θ -> sum(w .* C.ar(θ[1:2], init, θ[3:end])), θ0)

    function split_run(ρ, ϵ)
        ar = Recurrence(ρ)
        fitted, state = ar(1.0; history = init, add = ϵ[1:T₁], return_state = true)
        forecast = ar(1.0; history = state, add = ϵ[(T₁ + 1):end])
        return vcat(init, fitted, forecast)
    end
    @test split_run(ρ, ϵ) ≈ ref
    ∇ = ForwardDiff.gradient(θ -> sum(w .* split_run(θ[1:2], θ[3:end])), θ0)
    @test ∇ ≈ ∇ref
end

@testitem "Use case: resume the BVD patch model" tags = [:usecase] setup = [UseCaseReferences] begin
    using ComposableRecurrences, ForwardDiff
    B = UseCaseReferences.BVDReference

    g = [0.3, 0.5, 0.2]
    np, n, L = 3, 10, 3
    T₁ = 7
    Rt = hcat(fill(0.0, np, L), repeat([2.0, 1.4, 0.9], 1, n - L))
    seeds = [1.0 2.0 3.0; 0.5 1.0 1.0; 0.0 0.0 1.0]
    K = [0.0 0.2 0.1; 0.3 0.0 0.2; 0.1 0.4 0.0]
    ε = [0.05 .+ 0.01 .* (1:n)'; fill(0.1, 1, n); fill(0.02, 1, n)]
    N = [300.0, 200.0, 150.0]
    ref = B.patch_infections(Rt, g, seeds, K, ε, N).infections
    w = reshape(range(0.5, 2.0; length = np * n), np, n)
    function ref_loss(θ)
        Rt = reshape(θ, np, n)
        return sum(w .* B.patch_infections(Rt, g, seeds, K, ε, N).infections)
    end
    ∇ref = ForwardDiff.gradient(ref_loss, vec(Rt))

    # One operator over the whole horizon. The state carries the day
    # reached, so the forecast reads ε from the next day without a slice.
    depletion = ComposableRecurrences.Depletion(
        N; form = :hazard, seeded = true
    )
    importation = ComposableRecurrences.Redistribute(K, TimeVarying(ε))
    patch = Recurrence(g; modifiers = (importation, depletion))
    function split_run(Rt)
        first_days, rest = (L + 1):T₁, (T₁ + 1):n
        fitted, state = patch(
            Rt[:, first_days]; history = seeds, start = L + 1,
            return_state = true
        )
        forecast = patch(Rt[:, rest]; history = state)
        return hcat(seeds, fitted, forecast)
    end
    @test split_run(Rt) ≈ ref
    ∇ = ForwardDiff.gradient(θ -> sum(w .* split_run(reshape(θ, np, n))), vec(Rt))
    @test ∇ ≈ ∇ref
end
