# Latent processes from ComposableTuringIDModels: random walk, AR(p),
# time-varying AR(1) and MA(q). Each is a recurrence (or, for MA, a
# convolution) driven by innovations passed as `add`.
#
# Kernels are indexed by lag: `kernel[i]` weights the value `i` steps back.
# `history` holds the last `L` values, oldest first.

@testitem "Use case: random walk" tags = [:usecase] setup = [UseCaseReferences] begin
    using ComposableRecurrences, ForwardDiff
    C = UseCaseReferences.CTIDMReference

    z0 = 0.3
    ϵ = [0.1, -0.2, 0.3, 0.05, -0.1, 0.2, 0.0, -0.3]
    ref = C.random_walk(z0, ϵ)
    w = range(0.5, 2.0; length = length(ref))
    θ0 = vcat(z0, ϵ)
    ∇ref = ForwardDiff.gradient(θ -> sum(w .* C.random_walk(θ[1], θ[2:end])), θ0)

    # z_t = z_{t-1} + ϵ_t: a unit lag-1 kernel, unit gain, innovations added.
    # CTIDM returns the initial value first.
    random_walk(z0, ϵ) = vcat(z0, Recurrence([1.0])(1.0; history = [z0], add = ϵ))
    @test random_walk(z0, ϵ) ≈ ref
    ∇ = ForwardDiff.gradient(θ -> sum(w .* random_walk(θ[1], θ[2:end])), θ0)
    @test ∇ ≈ ∇ref
end

@testitem "Use case: AR(p)" tags = [:usecase] setup = [UseCaseReferences] begin
    using ComposableRecurrences, ForwardDiff
    C = UseCaseReferences.CTIDMReference

    ρ = [0.5, 0.2]
    init = [0.1, 0.3]
    ϵ = [0.1, -0.2, 0.3, 0.05, -0.1, 0.2, 0.0, -0.3]
    ref = C.ar(ρ, init, ϵ)
    w = range(0.5, 2.0; length = length(ref))
    θ0 = vcat(ρ, init, ϵ)
    unpack(θ) = (θ[1:2], θ[3:4], θ[5:end])
    ∇ref = ForwardDiff.gradient(θ -> sum(w .* C.ar(unpack(θ)...)), θ0)

    # z_t = Σ_i ρ_i z_{t-i} + ϵ_t: the AR coefficients are the kernel.
    ar(ρ, init, ϵ) = vcat(init, Recurrence(ρ)(1.0; history = init, add = ϵ))
    @test ar(ρ, init, ϵ) ≈ ref
    ∇ = ForwardDiff.gradient(θ -> sum(w .* ar(unpack(θ)...)), θ0)
    @test ∇ ≈ ∇ref
end

@testitem "Use case: time-varying AR(1)" tags = [:usecase] setup = [UseCaseReferences] begin
    using ComposableRecurrences, ForwardDiff
    C = UseCaseReferences.CTIDMReference

    ρ = [0.9, 0.8, 0.7, 0.75, 0.6, 0.65, 0.5, 0.55]
    z1 = 0.4
    ϵ = [0.1, -0.2, 0.3, 0.05, -0.1, 0.2, 0.0, -0.3]
    ref = C.tvar(ρ, z1, ϵ)
    w = range(0.5, 2.0; length = length(ref))
    θ0 = vcat(ρ, z1, ϵ)
    unpack(θ) = (θ[1:8], θ[9], θ[10:end])
    ∇ref = ForwardDiff.gradient(θ -> sum(w .* C.tvar(unpack(θ)...)), θ0)

    # z_t = ρ_t z_{t-1} + ϵ_t. The coefficient path can be the gain on a
    # unit lag-1 kernel ...
    tvar_gain(ρ, z1, ϵ) = vcat(z1, Recurrence([1.0])(ρ; history = [z1], add = ϵ))
    # ... or a time-varying kernel, `L × T`.
    function tvar_kernel(ρ, z1, ϵ)
        r = Recurrence(TimeVarying(reshape(ρ, 1, :)))
        return vcat(z1, r(1.0; history = [z1], add = ϵ))
    end
    @test tvar_gain(ρ, z1, ϵ) ≈ ref
    @test tvar_kernel(ρ, z1, ϵ) ≈ ref
    @test ForwardDiff.gradient(θ -> sum(w .* tvar_gain(unpack(θ)...)), θ0) ≈ ∇ref
    @test ForwardDiff.gradient(θ -> sum(w .* tvar_kernel(unpack(θ)...)), θ0) ≈
        ∇ref
end

@testitem "Use case: MA(q)" tags = [:usecase] setup = [UseCaseReferences] begin
    using ComposableRecurrences, ForwardDiff
    C = UseCaseReferences.CTIDMReference

    θ = [0.4, 0.2]
    q = length(θ)
    ϵ = [0.1, -0.2, 0.3, 0.05, -0.1, 0.2, 0.0, -0.3]
    ref = C.ma(θ, ϵ)
    w = range(0.5, 2.0; length = length(ref))
    θ0 = vcat(θ, ϵ)
    ∇ref = ForwardDiff.gradient(p -> sum(w .* C.ma(p[1:2], p[3:end])), θ0)

    # z_t = ϵ_t + Σ_i θ_i ϵ_{t-i}: a convolution with kernel `[1; θ]` from
    # lag 0. CTIDM passes the first `q` innovations through unchanged, which
    # is the convolution of the rest given those `q` as history.
    ma(θ, ϵ) = vcat(ϵ[1:q], Convolution(vcat(1, θ))(ϵ)[(q + 1):end])
    function ma_history(θ, ϵ)
        c = Convolution(vcat(1, θ))
        return vcat(ϵ[1:q], c(ϵ[(q + 1):end]; history = ϵ[1:q]))
    end
    @test ma(θ, ϵ) ≈ ref
    @test ma_history(θ, ϵ) ≈ ref
    @test ForwardDiff.gradient(p -> sum(w .* ma(p[1:2], p[3:end])), θ0) ≈ ∇ref
    @test ForwardDiff.gradient(
        p -> sum(w .* ma_history(p[1:2], p[3:end])), θ0
    ) ≈ ∇ref
end
