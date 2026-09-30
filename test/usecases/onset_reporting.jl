# BVD's onset reporting delay: each onset date's reports arrive under a daily
# hazard that moves with the calendar. The delay CDF is a survival product
# over delay, and the ascertainment anchor averages a calendar series over
# each onset date's reporting window.

@testitem "Use case: BVD onset reporting delay CDF" tags = [:usecase] setup = [UseCaseReferences] begin
    using ComposableRecurrences, ForwardDiff
    B = UseCaseReferences.BVDReference

    logit_h0 = [-2.0, -1.2, -0.8, -1.0, -1.5]
    γ = [0.3 * sin(i / 2) for i in 1:14]
    grid_start, u_lo, u_hi = 2, 3, 9
    D, ng, nu = length(logit_h0), length(γ), u_hi - u_lo + 1
    ref = B.onset_report_cdf_table(logit_h0, γ, grid_start, u_lo, u_hi)
    W = reshape(range(0.5, 2.0; length = D * nu), D, nu)
    unpack(θ) = (θ[1:D], θ[(D + 1):end])
    θ0 = vcat(logit_h0, γ)
    ∇ref = ForwardDiff.gradient(
        θ -> sum(W .* B.onset_report_cdf_table(unpack(θ)..., grid_start, u_lo, u_hi)),
        θ0
    )

    # The onset dates are the strata and the delay is the time axis: each
    # survival steps by its own day's 1 - h, from one.
    function hazards(logit_h0, γ)
        return [
            B.logistic(logit_h0[j] + γ[clamp(u + j - grid_start, 1, ng)])
                for u in u_lo:u_hi, j in 1:D
        ]
    end
    function cdf_table(logit_h0, γ)
        survival = Recurrence([1.0])(1 .- hazards(logit_h0, γ); history = ones(nu, 1))
        return 1 .- permutedims(survival)
    end
    @test cdf_table(logit_h0, γ) ≈ ref
    @test ForwardDiff.gradient(θ -> sum(W .* cdf_table(unpack(θ)...)), θ0) ≈ ∇ref

    # anchor(u) = Σ_d g(u, d) a[min(u + d, na)] reads forward from u, so it is
    # a causal convolution in reversed time: onset date u is reversed time
    # na + 1 - u, and the days past the end repeat a[na] as history.
    a = [0.2, 0.25, 0.3, 0.3, 0.35, 0.4, 0.38, 0.36, 0.34, 0.3, 0.28]
    na = length(a)
    refa = B.onset_report_anchor_series(ref, u_lo, a)
    wa = range(0.5, 2.0; length = nu)
    θa = vcat(logit_h0, γ, a)
    unpacka(θ) = (θ[1:D], θ[(D + 1):(D + ng)], θ[(D + ng + 1):end])
    function ref_anchor(logit_h0, γ, a)
        table = B.onset_report_cdf_table(logit_h0, γ, grid_start, u_lo, u_hi)
        return B.onset_report_anchor_series(table, u_lo, a)
    end
    ∇refa = ForwardDiff.gradient(θ -> sum(wa .* ref_anchor(unpacka(θ)...)), θa)
    function anchor(logit_h0, γ, a)
        F = cdf_table(logit_h0, γ)
        G = F ./ F[end:end, :]
        g = vcat(G[1:1, :], diff(G; dims = 1))
        K = zeros(eltype(g), D, na)
        for (k, u) in enumerate(u_lo:u_hi)
            K[:, na + 1 - u] = g[:, k]
        end
        c = Convolution(TimeVarying(K))
        y = reverse(c(reverse(a); history = fill(a[end], D - 1)))
        return y[u_lo:u_hi]
    end
    @test anchor(logit_h0, γ, a) ≈ refa
    @test ForwardDiff.gradient(θ -> sum(wa .* anchor(unpacka(θ)...)), θa) ≈ ∇refa
end
