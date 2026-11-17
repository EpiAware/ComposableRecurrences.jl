# Small `Float64` calls of the shapes most models start from, run at
# precompile time, so that their first call in a session does not compile
# them: a single series, and strata with a dense coupling and a depletion,
# each followed by a convolution. The backends' extensions are left out, as
# their compile time dwarfs any gain here.
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
