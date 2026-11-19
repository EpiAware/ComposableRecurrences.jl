# The README model's shapes, so their first call does not compile; the AD
# extensions get no workload. Left out of coverage: precompile time only.
# COV_EXCL_START
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
# COV_EXCL_STOP
