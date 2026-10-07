# Herd turnover over a long horizon, as in endemic BVD models: calves are
# born susceptible and animals are sold from the susceptible pool. The herd
# size changes with the births and sales, so the hazard divides by the
# population at each step's time. With births b_t and sales c_t,
#
#   N_t = N_{t-1} + b_t - c_t,
#   y_t = S (1 - exp(-v_t / N_t)),  S ← S exp(-v_t / N_t) - min(c_t - b_t, S)
#
# where a negative c_t - b_t adds the net births to the pool.

@testitem "Use case: herd turnover with births and sales" tags = [:usecase] begin
    using ComposableRecurrences, ForwardDiff
    CR = ComposableRecurrences

    g = [0.2, 0.4, 0.3, 0.1]
    T = 80
    seed = [2.0, 3.0, 4.0]
    t0 = length(seed) + 1
    R = [1.6 + 0.3 * sin(t / 6) for t in 1:T]
    births = [t < t0 ? 0.0 : 2.0 + sin(t / 4) for t in 1:T]
    sales = [t < t0 || isodd(t) ? 0.0 : 1.5 for t in 1:T]
    N0, pool0 = 200.0, 180.0

    function naive(R, births)
        y = zeros(promote_type(eltype(R), eltype(births)), T)
        y[1:length(seed)] .= seed
        S = pool0 + zero(eltype(y))
        N = N0 + sum(births[1:(t0 - 1)] .- sales[1:(t0 - 1)]) + zero(eltype(y))
        for t in t0:T
            N += births[t] - sales[t]
            v = R[t] * sum(g[i] * y[t - i] for i in eachindex(g) if t - i >= 1)
            x = v / N
            y[t] = S * (1 - exp(-x))
            S *= exp(-x)
            S -= min(sales[t] - births[t], max(S, 0))
        end
        return y
    end

    function model(R, births)
        N = TimeVarying(N0 .+ cumsum(births .- sales))
        herd = CR.Depletion(N; pool0, removals = TimeVarying(sales .- births))
        return Recurrence(g; modifiers = (herd,))(
            R; history = seed, start = t0, prepend = true
        )
    end

    @test model(R, births) ≈ naive(R, births)
    # Without births the herd shrinks and the epidemic is smaller.
    @test sum(model(R, zero(births))) < sum(model(R, births))
    W = [cos(t / 7) for t in 1:T]
    @test ForwardDiff.gradient(b -> sum(W .* model(R, b)), births) ≈
        ForwardDiff.gradient(b -> sum(W .* naive(R, b)), births)
    @test ForwardDiff.gradient(r -> sum(W .* model(r, births)), R) ≈
        ForwardDiff.gradient(r -> sum(W .* naive(r, births)), R)
end
