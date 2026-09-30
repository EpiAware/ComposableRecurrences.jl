# Latent processes from ComposableTuringIDModels: random walk, AR(p),
# time-varying AR(1), MA(q) and MA(1) with a coefficient path, ARIMA and the
# exponential growth rate. Each is a recurrence (or, for MA, a convolution)
# driven by innovations passed as `add`.
#
# Kernels are lag first: `kernel[i]` weights the value `i` steps back.
# `history` holds past values in time order, oldest first.

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
    function ar(ρ, init, ϵ)
        r = Recurrence(ρ)
        return vcat(init, r(1.0; history = init, add = ϵ))
    end
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
    # is the convolution from day `q + 1`, reading the earlier innovations
    # from the input itself.
    ma(θ, ϵ) = vcat(ϵ[1:q], Convolution(vcat(1, θ))(ϵ)[(q + 1):end])
    function ma_history(θ, ϵ)
        c = Convolution(vcat(1, θ))
        return vcat(ϵ[1:q], c(ϵ; start = q + 1))
    end
    @test ma(θ, ϵ) ≈ ref
    @test ma_history(θ, ϵ) ≈ ref
    @test ForwardDiff.gradient(p -> sum(w .* ma(p[1:2], p[3:end])), θ0) ≈ ∇ref
    @test ForwardDiff.gradient(
        p -> sum(w .* ma_history(p[1:2], p[3:end])), θ0
    ) ≈ ∇ref
end

@testitem "Use case: MA(1) with a coefficient path" tags = [:usecase] setup = [UseCaseReferences] begin
    using ComposableRecurrences, ForwardDiff
    C = UseCaseReferences.CTIDMReference

    ϵ = [0.1, -0.2, 0.3, 0.05, -0.1, 0.2, 0.0, -0.3]
    n = length(ϵ)
    θ = [0.4, 0.35, 0.3, 0.2, 0.25, 0.1, 0.15]
    ref = C.ma1(θ, ϵ)
    w = range(0.5, 2.0; length = n)
    θ0 = vcat(θ, ϵ)
    unpack(p) = (p[1:(n - 1)], p[n:end])
    ∇ref = ForwardDiff.gradient(p -> sum(w .* C.ma1(unpack(p)...)), θ0)

    # z_t = ϵ_t + θ_{t-1} ϵ_{t-1}: a `2 × T` kernel from lag 0, column `t`
    # holding `[1, θ_{t-1}]`. The first column's lag-1 weight reads no input.
    function ma1(θ, ϵ)
        K = vcat(ones(eltype(θ), 1, n), hcat(zero(eltype(θ)), θ'))
        return Convolution(TimeVarying(K))(ϵ)
    end
    @test ma1(θ, ϵ) ≈ ref
    @test ForwardDiff.gradient(p -> sum(w .* ma1(unpack(p)...)), θ0) ≈ ∇ref
end

@testitem "Use case: ARIMA (differenced ARMA)" tags = [:usecase] setup = [UseCaseReferences] begin
    using ComposableRecurrences, ForwardDiff
    C = UseCaseReferences.CTIDMReference

    ρ, init = [0.5, 0.2], [0.1, 0.3]
    θ = [0.4, 0.2]
    diff_init = [0.2, -0.1]
    ϵ = [0.1, -0.2, 0.3, 0.05, -0.1, 0.2, 0.0, -0.3]
    p, q, d = length(ρ), length(θ), length(diff_init)
    ref = C.arima(ρ, init, θ, ϵ, diff_init)
    w = range(0.5, 2.0; length = length(ref))
    θ0 = vcat(ρ, init, θ, ϵ, diff_init)
    unpack(x) = (x[1:2], x[3:4], x[5:6], x[7:14], x[15:16])
    ∇ref = ForwardDiff.gradient(x -> sum(w .* C.arima(unpack(x)...)), θ0)

    # ARMA: the MA(q) convolution is the AR(p) recurrence's `add`.
    function arma(ρ, init, θ, ϵ)
        ma = vcat(ϵ[1:q], Convolution(vcat(1, θ))(ϵ; start = q + 1))
        return vcat(init, Recurrence(ρ)(1.0; history = init, add = ma))
    end
    # Each integration is a cumulative sum, a unit lag-1 recurrence from zero
    # driven by the series below it.
    cumulative(x) = Recurrence([1.0])(1.0; history = [0.0], add = x)
    function arima(ρ, init, θ, ϵ, diff_init)
        x = vcat(diff_init, arma(ρ, init, θ, ϵ))
        for _ in 1:d
            x = cumulative(x)
        end
        return x
    end
    # The `d` integrations are also one recurrence of order `d` with the
    # binomial kernel: z_t = 2 z_{t-1} - z_{t-2} + x_t for `d = 2`.
    function arima_order_d(ρ, init, θ, ϵ, diff_init)
        x = vcat(diff_init, arma(ρ, init, θ, ϵ))
        return Recurrence([2.0, -1.0])(1.0; history = [0.0, 0.0], add = x)
    end
    @test arima(ρ, init, θ, ϵ, diff_init) ≈ ref
    @test arima_order_d(ρ, init, θ, ϵ, diff_init) ≈ ref
    @test ForwardDiff.gradient(x -> sum(w .* arima(unpack(x)...)), θ0) ≈ ∇ref
    @test ForwardDiff.gradient(
        x -> sum(w .* arima_order_d(unpack(x)...)), θ0
    ) ≈ ∇ref
end

@testitem "Use case: exponential growth rate" tags = [:usecase] setup = [UseCaseReferences] begin
    using ComposableRecurrences, ForwardDiff
    C = UseCaseReferences.CTIDMReference

    # log I_t = log I_0 + Σ_{s ≤ t} r_s, for one series and per stratum.
    I₀ = 1.5
    r = [0.1, 0.12, 0.08, 0.05, 0.0, -0.02, -0.05, -0.1]
    I₀s = [1.5, 0.5, 2.0]
    R = [r'; 0.5 .* r'; reverse(r)']
    S, T = size(R)
    w = range(0.5, 2.0; length = T)
    W = reshape(range(0.5, 2.0; length = S * T), S, T)
    ∇ref = ForwardDiff.gradient(
        x -> sum(w .* C.exp_growth(x[1], x[2:end])), vcat(I₀, r)
    )
    unpackS(x) = (x[1:S], reshape(x[(S + 1):end], S, T))
    ∇refS = ForwardDiff.gradient(
        x -> sum(W .* C.exp_growth(unpackS(x)...)), vcat(I₀s, vec(R))
    )

    # A unit lag-1 recurrence seeded at the initial level, the growth rate
    # added each step. The history sets the strata.
    growth(I₀, r) = Recurrence([1.0])(1.0; history = [I₀], add = r)
    growthS(I₀, R) = Recurrence([1.0])(1.0; history = reshape(I₀, :, 1), add = R)
    @test growth(I₀, r) ≈ C.exp_growth(I₀, r)
    @test growthS(I₀s, R) ≈ C.exp_growth(I₀s, R)
    @test ForwardDiff.gradient(x -> sum(w .* growth(x[1], x[2:end])), vcat(I₀, r)) ≈
        ∇ref
    @test ForwardDiff.gradient(
        x -> sum(W .* growthS(unpackS(x)...)), vcat(I₀s, vec(R))
    ) ≈ ∇refS
end
