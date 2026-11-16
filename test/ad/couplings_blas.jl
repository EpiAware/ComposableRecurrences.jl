# A dense float coupling of `_BLAS_MIX` strata or more takes BLAS's
# product in the step, and the loop below it: gradients on both sides of
# the threshold, through the rule and through plain AD, against ForwardDiff.

@testmodule BLASCoupling begin
    using ComposableRecurrences, ForwardDiff
    const CR = ComposableRecurrences
    const N = CR._BLAS_MIX
    const T, L = 30, 4
    const g = [0.4, 0.3, 0.2, 0.1]

    # A loss of a dense coupling and the inputs, with the operator wrapped
    # by `wrap` (`identity` or `NoAdjoint`).
    function case(S, wrap)
        K0 = [0.6 * (a == b) + 0.4 / S for a in 1:S, b in 1:S]
        R0 = [1.0 + 0.1 * sin(k + t) for k in 1:S, t in 1:T]
        W = [cos(2k + t) for k in 1:S, t in 1:T]
        h = [1.0 + 0.05 * (k + l) for k in 1:S, l in 1:L]
        f = function (θ)
            K = reshape(θ[1:(S * S)], S, S)
            R = reshape(θ[(S * S + 1):end], S, T)
            r = Recurrence(g; coupling = K)
            return sum(W .* wrap(r)(R; history = h))
        end
        return f, vcat(vec(K0), vec(R0))
    end
    reference(f, θ) = ForwardDiff.gradient(f, θ)
end

@testitem "Coupling pressure: BLAS's product under Mooncake reverse" tags = [
    :ad, :mooncake, :mooncake_reverse,
] setup = [BLASCoupling] begin
    using ComposableRecurrences, Mooncake
    using ComposableRecurrences: NoAdjoint
    (; N, case, reference) = BLASCoupling
    for S in (N - 1, N), wrap in (identity, NoAdjoint)
        f, θ = case(S, wrap)
        cache = Mooncake.prepare_gradient_cache(f, θ)
        _, (_, θ̄) = Mooncake.value_and_gradient!!(cache, f, θ)
        @test θ̄ ≈ reference(f, θ)
    end
end

@testitem "Coupling pressure: BLAS's product under Enzyme reverse" tags = [
    :ad, :enzyme, :enzyme_reverse,
] setup = [BLASCoupling] begin
    using ComposableRecurrences, Enzyme
    using ComposableRecurrences: NoAdjoint
    (; N, case, reference) = BLASCoupling
    mode = Enzyme.set_runtime_activity(Enzyme.Reverse)
    for S in (N - 1, N), wrap in (identity, NoAdjoint)
        f, θ = case(S, wrap)
        θ̄ = Enzyme.gradient(mode, Enzyme.Const(f), θ)[1]
        @test θ̄ ≈ reference(f, θ)
    end
end
