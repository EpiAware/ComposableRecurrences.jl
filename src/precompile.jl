# The README model's shapes, a single series and strata with a coupling and
# a depletion, on small `Float64` inputs, so that their first call in a
# session does not compile. The AD extensions get no workload.
@setup_workload begin
    g = [0.5, 0.3, 0.2]
    K = [0.9 0.1; 0.2 0.8]
    R = fill(1.1, 2, 8)
    h = ones(2, 3)
    @compile_workload begin
        y1 = Recurrence(g)(fill(1.1, 8); history = ones(3))
        Convolution(g)(y1; gain = 0.4, history = ones(3))
        N = PerStratum([100.0, 50.0])
        r = Recurrence(g; coupling = K, modifiers = (Depletion(N),))
        y = r(R; history = h)
        Convolution(g)(y; gain = 0.4, history = h)
    end
end
