# `pressure` on a recurrence with a computed kernel: plain AD through the
# fill of its weights hands the dense kernel's cotangent to the rule.
@testitem "Pressure, Mooncake reverse: a computed kernel, the rule against central differences" tags = [:ad, :mooncake, :mooncake_reverse] begin
    using ComposableRecurrences, Mooncake
    using DifferentiationInterface: gradient, AutoMooncake
    CR = ComposableRecurrences
    T, g = 12, [0.4, 0.3, 0.2, 0.1]
    L = length(g)
    start, hh = 5, [1.0, 1.2, 0.9, 1.1]
    stop = start + T - 1
    function computed(hz)
        surv = CR.Survival(TimeVarying(hz); from = 1)
        return TimeVarying(g * (1 - surv), CR.Primary())
    end
    hz = [0.05 + 0.02 * sin(t) for t in 1:(stop + L)]
    R = [1.0 + 0.2 * sin(t) for t in 1:T]
    y = Recurrence(computed(hz))(R; history = hh, start)
    W = [cos(t) for t in eachindex(y)]
    function f(h)
        p = CR.pressure(Recurrence(computed(h)), y; history = hh, start)
        return sum(W .* p)
    end
    ε = 1.0e-6
    bump(i) = [j == i ? ε : 0.0 for j in eachindex(hz)]
    fd = [(f(hz + bump(i)) - f(hz - bump(i))) / (2ε) for i in eachindex(hz)]
    n = CR._PULLBACK_CALLS[]
    @test gradient(f, AutoMooncake(), hz) ≈ fd rtol = 1.0e-6
    @test CR._PULLBACK_CALLS[] > n
end
