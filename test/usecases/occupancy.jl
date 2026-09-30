# BVD's bed occupancy balance. Four coupled stocks carry forward one day:
# case and non-case occupancy, confirmed cases in care and suspects. The
# balance has clamps and ratio splits that are not `gain ⊙ x + add`, so it
# is a user modifier on a lag-1 identity recurrence: the core carries the
# previous stocks forward and the modifier applies the day's flows.

@testitem "Use case: BVD accumulate_occupancy (user modifier)" tags = [:usecase, :param_eltype] setup = [UseCaseReferences] begin
    using ComposableRecurrences, ForwardDiff
    B = UseCaseReferences.BVDReference

    A_bvd = [3.0, 4.0, 5.0, 2.0, 1.0, 0.0, 2.0, 3.0, 1.0, 0.0]
    A_bg = [1.0, 2.0, 2.0, 1.0, 1.0, 1.0, 0.0, 1.0, 2.0, 1.0]
    deaths = fill(0.3, 10)
    recover = [0.2, 0.4, 0.6, 0.8, 1.0, 1.2, 1.0, 0.8, 0.6, 0.4]
    ruleout = fill(0.8, 10)
    κ = 0.1
    conf_hazard = [0.2, 0.3, 0.4, 0.5, 0.5, 0.5, 0.4, 0.4, 0.3, 0.3]
    T = length(A_bvd)
    wts = range(0.5, 2.0; length = T)
    loss(y) = sum(wts .* y.demand) + sum(wts .* y.O_conf) + sum(y.abscond)
    unpack(θ) = (θ[1:T], θ[T + 1], θ[(T + 2):end])
    θ0 = vcat(A_bvd, κ, conf_hazard)
    ref = B.accumulate_occupancy(A_bvd, A_bg, deaths, recover, ruleout, κ, conf_hazard)
    function ref_loss(θ)
        A_bvd, κ, conf_hazard = unpack(θ)
        return loss(
            B.accumulate_occupancy(
                A_bvd, A_bg, deaths, recover, ruleout, κ, conf_hazard
            )
        )
    end
    ∇ref = ForwardDiff.gradient(ref_loss, θ0)

    # The stocks are the strata: (O_bvd, O_bg, O_conf, O_susp). The
    # modifier receives the previous day's stocks in `v` and overwrites them
    # with today's.
    #
    # The fields are untyped on purpose: this is the regression test for
    # `param_eltype`, which must find a Dual stored in an untyped field and
    # promote the recurrence's buffer to it.
    struct OccupancyBalance
        A_bvd
        A_bg
        deaths
        recover
        ruleout
        κ
        conf_hazard
    end
    function ComposableRecurrences.forward(
            m::OccupancyBalance, ::ComposableRecurrences.Step, v, s, t
        )
        z = zero(eltype(v))
        ε = eps(eltype(v))
        Obvd, Obg, Oconf, Osusp = v
        bvd_out = m.deaths[t] + m.recover[t]
        ab = m.κ * Osusp
        unconf = max(Obvd - Oconf, z)
        denom = max(Osusp, ε)
        Obvd_t = max(Obvd + m.A_bvd[t] - bvd_out - ab * (unconf / denom), z)
        Obg_t = max(Obg + m.A_bg[t] - m.ruleout[t] - ab * (Obg / denom), z)
        share = Obvd > z ? Oconf / Obvd : z
        x_conf = Oconf + m.conf_hazard[t] * unconf - bvd_out * share
        Oconf_t = clamp(x_conf, z, Obvd_t)
        v .= (Obvd_t, Obg_t, Oconf_t, max(Obvd_t + Obg_t - Oconf_t, z))
        return nothing
    end

    function occupancy(A_bvd, κ, conf_hazard)
        balance = OccupancyBalance(
            A_bvd, A_bg, deaths, recover, ruleout, κ, conf_hazard
        )
        r = Recurrence([1.0]; modifiers = (balance,))
        # No gain: the flows live in the modifier, so `stop` sets the number
        # of days; the stocks start empty.
        Y = r(; history = zeros(4, 1), stop = T)
        O_bvd, O_bg, O_conf, O_susp = eachrow(Y)
        return (;
            demand = O_bvd .+ O_bg, O_bvd, O_conf, O_susp,
            abscond = κ .* vcat(0, O_susp[1:(end - 1)]),
        )
    end
    y = occupancy(A_bvd, κ, conf_hazard)
    for k in keys(ref)
        @test getproperty(y, k) ≈ getproperty(ref, k)
    end
    ∇ = ForwardDiff.gradient(θ -> loss(occupancy(unpack(θ)...)), θ0)
    @test ∇ ≈ ∇ref
end
