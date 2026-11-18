# Convolution values against the naive reference. Kernels are indexed from
# lag 0: `c[d + 1]` weights `x_{t-d}`.

@testitem "Convolution: fixed kernel" setup = [Reference] begin
    using ComposableRecurrences, Random
    rng = Xoshiro(21)
    D, T = 5, 12
    c = rand(rng, D)
    x = rand(rng, T)
    y = Convolution(c)(x)
    @test y isa Vector{Float64}
    @test y ≈ vec(naive_convolution((t, k, d) -> c[d + 1], reshape(x, 1, T), D))

    S = 3
    X = rand(rng, S, T)
    Y = Convolution(c)(X)
    @test size(Y) == (S, T)
    @test Y ≈ naive_convolution((t, k, d) -> c[d + 1], X, D)

    # A kernel longer than the series.
    c = rand(rng, T + 3)
    @test Convolution(c)(x) ≈
        vec(naive_convolution((t, k, d) -> c[d + 1], reshape(x, 1, T), T + 3))
end

@testitem "Convolution: a zero weight meeting an Inf gives NaN" begin
    using ComposableRecurrences
    # A zero weight multiplies rather than skips, as `sum(k .* x)` does.
    k = [0.5, 0.0, 0.5]
    x = [1.0, Inf, 2.0, 3.0]
    ref = [sum(k[1:min(t, 3)] .* x[t:-1:max(t - 2, 1)]) for t in 1:4]
    @test isnan(ref[3])
    for method in (ComposableRecurrences.Auto(), ComposableRecurrences.Direct())
        y = Convolution(k; method)(x)
        @test isequal(y, ref)
        @test isnan(y[3])
    end
end

@testitem "Convolution: history" setup = [Reference] begin
    using ComposableRecurrences, Random
    rng = Xoshiro(22)
    D, T, S = 4, 9, 2
    c = rand(rng, D)
    x = rand(rng, T)
    for m in (1, 3, 6)
        h = rand(rng, m)
        ref = naive_convolution(
            (t, k, d) -> c[d + 1], reshape(x, 1, T), D; hist = reshape(h, 1, m)
        )
        @test Convolution(c)(x; history = h) ≈ vec(ref)
    end
    X = rand(rng, S, T)
    H = rand(rng, S, 3)
    @test Convolution(c)(X; history = H) ≈
        naive_convolution((t, k, d) -> c[d + 1], X, D; hist = H)
end

@testitem "Convolution: per-stratum kernel" setup = [Reference] begin
    using ComposableRecurrences, Random
    rng = Xoshiro(23)
    S, D, T = 3, 4, 8
    X = rand(rng, S, T)
    H = rand(rng, S, 2)
    C = rand(rng, S, D)
    @test Convolution(PerStratum(C))(X; history = H) ≈
        naive_convolution((t, k, d) -> C[k, d + 1], X, D; hist = H)
end

@testitem "Convolution: other number types take the gather body" tags = [:threads] begin
    using ComposableRecurrences, Random
    rng = Xoshiro(26)
    S, D, T = 3, 4, 9
    c, C = rand(rng, D), rand(rng, S, D)
    x, X = rand(rng, T), rand(rng, S, T)
    h, H = rand(rng, 2), rand(rng, S, 2)
    big = v -> BigFloat.(v)
    for (k, u, hu) in ((c, x, h), (c, X, H), (PerStratum(C), X, H))
        conv = Convolution(k)
        @test conv(big(u)) isa AbstractArray{BigFloat}
        @test conv(big(u)) ≈ conv(u)
        @test conv(big(u); history = big(hu)) ≈ conv(u; history = hu)
        @test conv(big(u); history = big(hu), start = 3, stop = 7) ≈
            conv(u; history = hu, start = 3, stop = 7)
    end
    # A kernel longer than the series and its history.
    long = rand(rng, T + 3)
    @test Convolution(long)(big(x); history = big(h)) ≈ Convolution(long)(x; history = h)
    # Gain and add, from a view of the input, scaled in the same pass.
    g, a = rand(rng, S, T), rand(rng, S, T)
    conv = Convolution(PerStratum(C))
    @test conv(view(big(X), :, 1:T); gain = g, add = a, history = big(H)) ≈
        conv(X; gain = g, add = a, history = H)
    b = rand(rng, T)
    @test Convolution(c)(big(x); gain = 2.0, add = b) ≈
        Convolution(c)(x; gain = 2.0, add = b)
    # A history longer than the kernel, an empty one, vector gain and add on
    # strata, a 1 × T gain on one series, and an early stop.
    conv = Convolution(c)
    @test conv(big(X); history = big(rand(rng, S, 6))) isa AbstractMatrix{BigFloat}
    H6 = rand(rng, S, 6)
    @test conv(big(X); history = big(H6)) ≈ conv(X; history = H6)
    @test conv(big(X); history = zeros(BigFloat, S, 0)) ≈ conv(X)
    @test conv(big(X); gain = b, add = b) ≈ conv(X; gain = b, add = b)
    @test conv(big(x); gain = reshape(b, 1, T)) ≈ conv(x; gain = reshape(b, 1, T))
    @test conv(big(X); stop = 5) ≈ conv(X; stop = 5)
    # A threaded run gives the serial values.
    threaded = Base.ScopedValues.with(
        () -> conv(big(X); history = big(H)),
        ComposableRecurrences.EXECUTOR => ComposableRecurrences.Threaded(;
            min_work = 0, ntasks = 2
        )
    )
    @test threaded == conv(big(X); history = big(H))
    # Offset axes are refused rather than read out of place.
    shifted = view(big(vcat(0.0, x)), Base.IdentityUnitRange(2:(T + 1)))
    @test_throws ArgumentError conv(shifted)
end

@testitem "Convolution: calls without a rule gather on CPU arrays of other numbers" setup = [ReferenceAD] begin
    using ComposableRecurrences, ForwardDiff, Random
    CR = ComposableRecurrences
    rng = Xoshiro(3)
    S, D, T = 3, 4, 9
    x, h = rand(rng, S, T), rand(rng, S, 2)
    g, a = rand(rng, S, T), rand(rng, S, T)
    Dual = ForwardDiff.Dual
    @test CR._conv_path(Float64, rand(D), x) === CR._Buffered()
    @test CR._conv_path(Dual{Nothing, Float64, 1}, rand(D), x) === CR._Gathered()
    @test CR._conv_path(BigFloat, PerStratum(rand(S, D)), view(x, :, 1:2)) ===
        CR._Gathered()
    # A dense time-varying kernel gathers on BigFloat and dual numbers, and
    # keeps the buffer on IEEE floats.
    @test CR._conv_path(BigFloat, TimeVarying(rand(D, T), CR.Secondary()), x) ===
        CR._Gathered()
    @test CR._conv_path(
        Dual{Nothing, Float64, 1}, TimeVarying(PerStratum(rand(S, D, T)), CR.Primary()), x
    ) === CR._Gathered()
    @test CR._conv_path(Float64, TimeVarying(rand(D, T), CR.Primary()), x) ===
        CR._Buffered()
    # The gather matches the buffered values, and its derivatives match a
    # hand-written convolution's.
    function naive(K, u)
        w = hcat(h, u)
        return [
            g[k, t] * sum(K[k, d + 1] * w[k, 2 + t - d] for d in 0:min(D - 1, t + 1)) +
                a[k, t] for k in 1:S, t in 1:T
        ]
    end
    K = rand(rng, S, D)
    for (k, Kk) in ((K[1, :], repeat(K[1, :]', S)), (PerStratum(K), K))
        conv = Convolution(k)
        f(θ) = sum(abs2, conv(reshape(θ, S, T); gain = g, add = a, history = h))
        @test ReferenceAD.gradient(f, vec(x)) ≈
            ReferenceAD.gradient(θ -> sum(abs2, naive(Kk, reshape(θ, S, T))), vec(x))
        y = conv(Dual.(x, 1.0); gain = g, add = a, history = h, start = 2, stop = 8)
        @test ForwardDiff.value.(y) ≈
            conv(x; gain = g, add = a, history = h, start = 2, stop = 8)
    end
end

@testitem "Convolution: a time-varying kernel gathers on dual and BigFloat numbers" begin
    using ComposableRecurrences, ForwardDiff, Random
    CR = ComposableRecurrences
    Dual = ForwardDiff.Dual
    rng = Xoshiro(41)
    S, D, T = 3, 4, 9
    x, h, g = rand(rng, S, T), rand(rng, S, 2), rand(rng, S, T)
    G = rand(rng, S, D, T)
    # Stratum `k`'s weight on lag `d` read at output time `t` (secondary) or
    # at input time `t - d` (primary), the history only for secondary.
    function naive(G, u, primary)
        w = primary ? hcat(zeros(eltype(u), S, 2), u) : hcat(h, u)
        return [
            g[k, t] * sum(
                G[k, d + 1, primary ? t - d : t] * w[k, 2 + t - d]
                    for d in 0:min(D - 1, primary ? t - 1 : t + 1)
            ) for k in 1:S, t in 1:T
        ]
    end
    for primary in (false, true)
        ix = primary ? CR.Primary() : CR.Secondary()
        hist = primary ? nothing : h
        conv = Convolution(TimeVarying(PerStratum(G), ix))
        @test CR._conv_path(eltype(Dual.(x, 1.0)), conv.kernel, x) === CR._Gathered()
        f(θ) = sum(abs2, conv(reshape(θ, S, T); gain = g, history = hist))
        @test ForwardDiff.gradient(f, vec(x)) ≈
            ForwardDiff.gradient(θ -> sum(abs2, naive(G, reshape(θ, S, T), primary)), vec(x))
        y = conv(Dual.(x, 1.0); gain = g, history = hist, start = 2, stop = 8)
        @test ForwardDiff.value.(y) ≈ conv(x; gain = g, history = hist, start = 2, stop = 8)
        # The same gathered body on BigFloat, against the naive sum.
        @test CR._conv_path(BigFloat, conv.kernel, x) === CR._Gathered()
        yb = conv(BigFloat.(x); gain = g, history = hist)
        @test yb isa Matrix{BigFloat}
        @test yb ≈ naive(G, x, primary)
        yb_part = conv(BigFloat.(x); gain = g, history = hist, start = 2, stop = 8)
        @test yb_part ≈ naive(G, x, primary)[:, 2:8]
        # One series with a lags × times kernel.
        c1 = Convolution(TimeVarying(G[1, :, :], ix))
        f1(θ) = sum(abs2, c1(θ; history = primary ? nothing : h[1, :]))
        @test ForwardDiff.gradient(f1, x[1, :]) ≈ ForwardDiff.gradient(
            θ -> sum(abs2, naive(G, repeat(θ', S), primary)[1, :] ./ g[1, :]), x[1, :]
        )
    end
end

@testitem "Convolution: lag blocks match the gather body at every edge" begin
    using ComposableRecurrences, Random
    # The float body adds lags in blocks of four, or gathers four outputs at
    # a time for a short slice; each kernel length, history length and start
    # puts the block edges on different rows. A late start leaves the
    # earlier inputs and history out of the buffer.
    rng = Xoshiro(27)
    S, T = 2, 11
    tobig = v -> BigFloat.(v)
    f32(v) = v === nothing ? nothing : Float32.(v)
    f32(k::PerStratum) = PerStratum(Float32.(k.x))
    for L in 1:13, m in 0:5, start in (1, 2, 5, 8, 11, 12)
        c, C = rand(rng, L), rand(rng, S, L)
        x, X = rand(rng, T), rand(rng, S, T)
        h, H = rand(rng, m), rand(rng, S, m)
        hist = m == 0 ? (nothing, nothing) : (h, H)
        for (k, u, hu) in ((c, x, hist[1]), (c, X, hist[2]), (PerStratum(C), X, hist[2]))
            conv = Convolution(k)
            bh = hu === nothing ? nothing : tobig(hu)
            ref = conv(tobig(u); history = bh, start)
            @test conv(u; history = hu, start) ≈ ref
            y32 = Convolution(f32(k))(f32(u); history = f32(hu), start)
            @test eltype(y32) == Float32
            @test y32 ≈ ref rtol = 1.0e-5
        end
    end
end

@testitem "Convolution: a plain call convolves in the layout of its input" tags = [:threads] begin
    using ComposableRecurrences, Random
    using Base.ScopedValues: with
    import ComposableRecurrences as CR
    # A fixed kernel over a plain array with no history from the first time
    # convolves in the layout of the input; a zero history takes the
    # time-first buffer and gives the same output.
    rng = Xoshiro(41)
    for S in (0, 1, 3), T in (1, 4, 11), L in (1, 4, 7, 13),
            vec_in in (false, true)
        vec_in && S != 1 && continue
        x = vec_in ? rand(rng, T) : rand(rng, S, T)
        c = rand(rng, L)
        h0 = vec_in ? zeros(1) : zeros(S, 1)
        gs = (true, 0.4, vec_in ? rand(rng, T) : rand(rng, S, T))
        as = (nothing, vec_in ? rand(rng, T) : rand(rng, S, T))
        for g in gs, a in as, stop in (T, T - 1)
            gg = g isa AbstractArray ? (vec_in ? g[1:stop] : g[:, 1:stop]) : g
            aa = a isa AbstractArray ? (vec_in ? a[1:stop] : a[:, 1:stop]) : a
            ref = Convolution(c)(x; history = h0, gain = gg, add = aa, stop)
            @test Convolution(c)(x; gain = gg, add = aa, stop) ≈ ref
        end
    end
    # The call takes the in-layout path and allocates only its output.
    X, c = rand(rng, 8, 260), rand(rng, 42)
    conv = Convolution(c)
    _, cache = CR._run_forward(conv, X, true, nothing, nothing, 1, nothing)
    @test cache isa CR._LayoutCache
    conv(X)
    coverage = Base.JLOptions().code_coverage != 0
    # Forced bounds checks (`--check-bounds=yes`, as the test runner sets)
    # keep the lag loops' views on the heap, 3.7 KB on x86-64 and 7.6 KB on
    # Apple silicon here; the check then rules out a second output-sized
    # array only.
    bound = if Base.JLOptions().check_bounds == 1
        2 * sizeof(X) - 1
    else
        sizeof(X) + 256
    end
    @test (@allocated conv(X)) <= bound skip = coverage
    # Loops split across tasks keep the buffer, and agree.
    @test with(CR.EXECUTOR => CR.Threaded(; min_work = 0)) do
        conv(X)
    end ≈ conv(X)
    # A Float32 call stays Float32.
    @test eltype(Convolution(Float32.(c))(Float32.(X))) == Float32
end

@testitem "Convolution: the in-layout rule's reverse pass matches the buffer's" begin
    using ComposableRecurrences, Random
    const CR = ComposableRecurrences
    # The rule's forward and reverse passes, driven without an AD backend: a
    # call in the layout of its input gives the cotangents of the same call
    # through the time-first buffer, which a zero history forces.
    rng = Xoshiro(45)
    mirror(::Bool) = nothing
    mirror(::Nothing) = nothing
    mirror(v::Real) = Ref(zero(v))
    mirror(v::AbstractArray) = zero(v)
    value(m::Base.RefValue) = m[]
    value(m) = m
    for S in (1, 3), (T, L) in ((9, 4), (5, 9), (12, 7)),
            vec_in in (false, true), scaled in (false, true),
            stop in (T, T - 2), wx in (true, false), wk in (true, false)
        vec_in && S != 1 && continue
        x = vec_in ? rand(rng, T) : rand(rng, S, T)
        k = rand(rng, L)
        shape = vec_in ? (stop,) : (S, stop)
        gain = scaled ? rand(rng, shape...) : true
        add = scaled ? rand(rng, shape...) : nothing
        ȳ = rand(rng, shape...)
        h0 = vec_in ? zeros(1) : zeros(S, 1)
        function grads(history)
            c = Convolution(k)
            y, cache = CR._run_forward(c, x, gain, add, history, 1, stop)
            g = (;
                piece = (; kernel = wk ? zero(k) : nothing), y = ȳ,
                args = (
                    wx ? zero(x) : nothing, mirror(gain), mirror(add),
                    mirror(history),
                ),
            )
            CR.pullback!(g, c, CR.Run(), cache)
            return y, cache, g
        end
        yl, cl, gl = grads(nothing)
        yb, cb, gb = grads(h0)
        @test cl isa CR._LayoutCache
        @test !(cb isa CR._LayoutCache)
        @test yl ≈ yb
        wk && @test gl.piece.kernel ≈ gb.piece.kernel
        wx && @test gl.args[1] ≈ gb.args[1]
        for i in 2:3
            gl.args[i] === nothing && continue
            @test value(gl.args[i]) ≈ value(gb.args[i])
        end
    end
    # A cache that holds its input keeps a copy only when the inputs may be
    # overwritten; any other cache is returned as it is.
    x = rand(rng, 2, 6)
    _, cache = CR._run_forward(
        Convolution(rand(rng, 3)), x, true, nothing, nothing, 1, nothing
    )
    @test CR._keep_inputs(cache, false) === cache
    kept = CR._keep_inputs(cache, true)
    @test kept.x == x && kept.x !== x
    other = (; X = x)
    @test CR._keep_inputs(other, true) === other
end

@testitem "Convolution: time-varying kernel indexed by output" setup = [Reference] begin
    using ComposableRecurrences, Random
    rng = Xoshiro(24)
    S, D, T = 3, 4, 8
    X = rand(rng, S, T)
    H = rand(rng, S, 2)
    # Column `t` weights the inputs reaching output `t`.
    Ct = rand(rng, D, T)
    c = Convolution(TimeVarying(Ct))
    @test c(X; history = H) ≈
        naive_convolution((t, k, d) -> Ct[d + 1, t], X, D; hist = H)
    @test Convolution(TimeVarying(Ct, ComposableRecurrences.Secondary()))(X) ≈ c(X)
    C3 = rand(rng, S, D, T)
    @test Convolution(TimeVarying(PerStratum(C3)))(X) ≈
        naive_convolution((t, k, d) -> C3[k, d + 1, t], X, D)
    # The inputs before `start` come from `x`.
    full = c(X; history = H)
    @test c(X; history = H, start = 4) ≈ full[:, 4:end]
    @test c(X; history = H, start = 4, stop = 6) ≈ full[:, 4:6]
    @test c(X[1, :]) ≈
        vec(naive_convolution((t, k, d) -> Ct[d + 1, t], X[1:1, :], D))
    # A kernel with more lags than the history and series hold.
    Cl = rand(rng, T + 3, T)
    @test Convolution(TimeVarying(Cl))(X; history = H) ≈
        naive_convolution((t, k, d) -> Cl[d + 1, t], X, T + 3; hist = H)
end

@testitem "Convolution: time-varying kernel indexed by input" setup = [Reference] begin
    using ComposableRecurrences, Random
    rng = Xoshiro(25)
    S, D, T = 3, 4, 8
    X = rand(rng, S, T)
    # Column `s` is the delay pmf of the input at time `s`: output `t`
    # reads the input at `t - d` through that input's column.
    Ct = rand(rng, D, T)
    c = Convolution(TimeVarying(Ct, ComposableRecurrences.Primary()))
    ref = naive_convolution((t, k, d) -> t - d >= 1 ? Ct[d + 1, t - d] : 0.0, X, D)
    @test c(X) ≈ ref
    C3 = rand(rng, S, D, T)
    @test Convolution(TimeVarying(PerStratum(C3), ComposableRecurrences.Primary()))(X) ≈
        naive_convolution(
        (t, k, d) -> t - d >= 1 ? C3[k, d + 1, t - d] : 0.0, X, D
    )

    # Inputs before `start` spread through their own columns; there is no
    # column for an input before t = 1.
    @test c(X; start = 4) ≈ ref[:, 4:end]
    @test c(X; start = 4, stop = 6) ≈ ref[:, 4:6]
    cp = Convolution(TimeVarying(PerStratum(C3), ComposableRecurrences.Primary()))
    @test cp(X; start = 4, stop = 6) ≈ cp(X)[:, 4:6]
    @test_throws ArgumentError c(X; history = X[:, 1:2])
    @test_throws "not as history (" c(X; history = X[:, 1:2])

    # Every input's mass lands somewhere when the window is long enough.
    P = rand(rng, D, T)
    P ./= sum(P; dims = 1)
    x = [rand(rng, T - D); zeros(D)]
    @test sum(Convolution(TimeVarying(P, ComposableRecurrences.Primary()))(x)) ≈ sum(x)

    # A constant kernel is the same under either indexing.
    g = rand(rng, D)
    G = repeat(g, 1, T)
    @test Convolution(TimeVarying(G, ComposableRecurrences.Primary()))(X) ≈
        Convolution(g)(X)
    @test Convolution(TimeVarying(G))(X) ≈ Convolution(g)(X)
end

@testitem "Convolution: a per-stratum time-varying kernel runs strata in blocks" tags = [:threads] setup = [Reference] begin
    using ComposableRecurrences, Random
    using Base.ScopedValues: with
    CR = ComposableRecurrences
    rng = Xoshiro(26)
    S, D, T = 5, 4, 12
    X = rand(rng, S, T)
    C3 = rand(rng, S, D, T)
    refs = (
        naive_convolution((t, k, d) -> t - d >= 1 ? C3[k, d + 1, t - d] : 0.0, X, D),
        naive_convolution((t, k, d) -> C3[k, d + 1, t], X, D),
    )
    for (ix, ref) in zip((CR.Primary(), CR.Secondary()), refs)
        c = Convolution(TimeVarying(PerStratum(C3), ix))
        serial = c(X)
        @test serial ≈ ref
        # One block per task gives the serial values, with more tasks than
        # strata too.
        for ntasks in (2, 3, 8)
            ex = CR.Threaded(; min_work = 0, ntasks)
            @test with(() -> c(X), CR.EXECUTOR => ex) == serial
        end
    end
end

@testitem "Convolution: output indexing matches CTIDM's time-varying delay" setup = [UseCaseReferences] begin
    using ComposableRecurrences
    C = UseCaseReferences.CTIDMReference
    Y = [5.0, 8.0, 12.0, 15.0, 14.0, 11.0, 9.0, 7.0, 6.0, 4.0]
    n, d = length(Y), 3
    early, late = [0.6, 0.3, 0.1], [0.1, 0.3, 0.6]
    P = reduce(hcat, [early .* (1 - s) .+ late .* s for s in range(0, 1; length = n)])
    ref = C.time_varying_latent_delay(collect(eachcol(P)), Y)
    c = Convolution(TimeVarying(P))
    @test c(Y)[d:end] ≈ ref
end

@testitem "Convolution: a kernel with offset axes is refused" begin
    using ComposableRecurrences
    # Offset axes would be read from index 1 on both the float and the
    # gather path, so the constructor refuses them and names the kernel.
    shifted(a) = view(a, Base.IdentityUnitRange(2:length(a)))
    for T in (Float64, BigFloat)
        k = shifted(T[0.0, 0.5, 0.3, 0.2])
        @test Base.has_offset_axes(k)
        err = try
            Convolution(k)
        catch e
            e
        end
        @test err isa ArgumentError
        @test occursin("kernel", sprint(showerror, err))
        @test occursin("2:4", sprint(showerror, err))
        G = view(ones(T, 2, 4), :, Base.IdentityUnitRange(2:4))
        @test_throws ArgumentError Convolution(PerStratum(G))
        M = view(ones(T, 3, 5), Base.IdentityUnitRange(2:3), :)
        @test_throws ArgumentError Convolution(TimeVarying(M))
        # A one-based view of the same kernel is accepted.
        c = T[0.5, 0.3, 0.2]
        @test Convolution(view(c, 1:3))(ones(T, 4)) == Convolution(c)(ones(T, 4))
    end
end

@testitem "Convolution: argument validation" begin
    using ComposableRecurrences
    err = try
        TimeVarying(ones(2, 2), :primary)
        nothing
    catch e
        e
    end
    @test err isa ArgumentError
    @test occursin("Secondary()", err.msg) && occursin("Primary()", err.msg)
    # Indexing lives on TimeVarying only.
    @test_throws MethodError Convolution([1.0]; indexed_by = :secondary)
    @test_throws ArgumentError Convolution(Pairwise(ones(2, 2, 3)))
    @test_throws "not a Convolution; got Pairwise(" Convolution(Pairwise(ones(2, 2, 3)))
    @test_throws ArgumentError Convolution(ones(2, 3))
    @test_throws ArgumentError Convolution(TimeVarying(ones(2, 3, 4)))
    @test_throws ArgumentError Convolution(nothing)
    @test_throws ArgumentError Convolution(ones(3))(TimeVarying(ones(5)))
    # `stop` may pass the end of `x`, but not of the gain or add input.
    @test_throws DimensionMismatch Convolution(ones(3))(ones(5); add = ones(5), stop = 6)
    @test_throws "add covers 5 times, fewer than stop = 6" Convolution(ones(3))(
        ones(5); add = ones(5), stop = 6
    )
    @test_throws DimensionMismatch Convolution(ones(3))(ones(5); gain = ones(5), stop = 6)
    @test_throws DimensionMismatch Convolution(ones(3))(ones(2, 5); history = ones(3, 2))
    @test_throws "history is 3×2 Matrix{Float64} but x is 2×5" Convolution(ones(3))(
        ones(2, 5); history = ones(3, 2)
    )
    @test_throws DimensionMismatch Convolution(PerStratum(ones(2, 3)))(ones(3, 5))
    @test_throws DimensionMismatch Convolution(TimeVarying(ones(3, 4)))(ones(5))
end

@testitem "Convolution: input loads the same into any buffer" begin
    import ComposableRecurrences as CR
    using Random
    rng = Xoshiro(23)
    m, stop, S = 2, 6, 3
    x = rand(rng, stop + 1)
    X = rand(rng, S, stop + 1)
    # `Array` buffers load by loop; a view takes the broadcast fallback.
    for (buf, src) in ((zeros(m + stop, 1), x), (zeros(m + stop, S), X))
        alt = view(zeros(size(buf)), :, :)
        @test !(alt isa Array)
        @test CR._load_input!(alt, src, m, stop) == CR._load_input!(buf, src, m, stop)
        # From time `lo`, the rows before it stay as they were.
        alt, buf = zero(alt), zero(buf)
        @test CR._load_input!(alt, src, m, stop, 4) ==
            CR._load_input!(buf, src, m, stop, 4)
        @test iszero(buf[1:(m + 3), :])
    end
end

@testitem "Convolution: gain and add" setup = [Reference] begin
    using ComposableRecurrences, Random
    import ComposableRecurrences as CR
    rng = Xoshiro(27)
    S, D, T = 3, 4, 9
    c = rand(rng, D)
    X, H = rand(rng, S, T), rand(rng, S, 2)
    ref = naive_convolution((t, k, d) -> c[d + 1], X, D; hist = H)
    conv = Convolution(c)
    slot(v::Real, k, t) = v
    slot(::Nothing, k, t) = 0.0
    slot(v::AbstractVector, k, t) = v[t]
    slot(v::AbstractMatrix, k, t) = v[k, t]
    hand(g, a) = [slot(g, k, t) * ref[k, t] + slot(a, k, t) for k in 1:S, t in 1:T]
    for g in (true, 0.4, rand(rng, T), rand(rng, S, T)),
            a in (nothing, 1.5, rand(rng, T), rand(rng, S, T))
        @test conv(X; history = H, gain = g, add = a) ≈ hand(g, a)
        @test conv(X; history = H, gain = g, add = a, start = 3, stop = 7) ≈
            hand(g, a)[:, 3:7]
        @test conv(big.(X); history = H, gain = g, add = a) ≈ hand(g, a)
    end
    g, a = rand(rng, T), rand(rng, T)
    @test conv(X[1, :]; history = H[1, :], gain = g, add = a) ≈ hand(g, a)[1, :]
    # A gain or add matrix covers the strata of a single series too.
    @test conv(X[1, :]; history = H[1, :], gain = g', add = a') ≈ hand(g, a)[1, :]
    # Other arrays take the broadcast fallback.
    Y = rand(rng, T, S)
    for (u, gg, aa) in (
            (X, g, rand(rng, S, T)), (X[1, :], 0.5, a),
            (X[1, :], rand(rng, 1, T), nothing),
        )
        Yu = u isa AbstractVector ? Y[:, 1:1] : Y
        @test CR._scaled_public(view(Yu, :, :), u, gg, aa, 1) ≈
            CR._scaled_public(Yu, u, gg, aa, 1)
    end
    @test (@inferred conv(X; gain = rand(rng, S, T), add = 0.1)) isa Matrix{Float64}
    # The default stop, read from a mix of arrays and absent inputs, does
    # not allocate.
    stop_of(u, g, a) = CR._stop(
        nothing, (:x => CR._extent(u), :gain => CR._extent(g), :add => CR._extent(a))
    )
    stop_allocs(u) = (stop_of(u, true, nothing); @allocated stop_of(u, true, nothing))
    # Coverage instrumentation allocates, so the count is checked only
    # without it.
    coverage = Base.JLOptions().code_coverage != 0
    @test stop_allocs(X) == 0 skip = coverage
    @test Convolution(Float32.(c))(Float32.(X); gain = 0.5f0) isa Matrix{Float32}
    @test_throws DimensionMismatch conv(X; gain = rand(rng, 2, T))
    @test_throws "gain has 2 strata, expected 3" conv(X; gain = rand(rng, 2, T))
    @test_throws DimensionMismatch conv(X; add = rand(rng, T + 1))
    @test_throws DimensionMismatch conv(X; gain = rand(rng, T - 1), stop = T)
    @test_throws ArgumentError conv(X; gain = TimeVarying(rand(rng, T)))
end

@testitem "Convolution: contributions" setup = [Reference] begin
    using ComposableRecurrences, Random
    import ComposableRecurrences as CR
    rng = Xoshiro(28)
    S, D, T = 2, 4, 8
    X, H = rand(rng, S, T), rand(rng, S, 3)
    G = rand(rng, S, T)
    ks = [rand(rng, n) for n in (2, 0, 4, 1, 3, 4, 2, 1)]
    Ct, C3 = rand(rng, D, T), rand(rng, S, D, T)
    P = CR.Primary()
    # Each kernel with its weight on lag `d` at output time `t` for stratum
    # `k`, zero where it has none.
    rag(τ, d) = τ >= 1 && d < length(ks[τ]) ? ks[τ][d + 1] : 0.0
    c = rand(rng, D)
    C = rand(rng, S, D)
    cases = [
        (c, (t, k, d) -> c[d + 1], true),
        (PerStratum(C), (t, k, d) -> C[k, d + 1], true),
        (TimeVarying(Ct), (t, k, d) -> Ct[d + 1, t], true),
        (TimeVarying(PerStratum(C3)), (t, k, d) -> C3[k, d + 1, t], true),
        (TimeVarying(ks), (t, k, d) -> rag(t, d), true),
        (TimeVarying(Ct, P), (t, k, d) -> t - d >= 1 ? Ct[d + 1, t - d] : 0.0, false),
        (TimeVarying(PerStratum(C3), P), (t, k, d) -> t - d >= 1 ? C3[k, d + 1, t - d] : 0.0, false),
        (TimeVarying(ks, P), (t, k, d) -> rag(t - d, d), false),
    ]
    for (kernel, w, history) in cases
        conv = Convolution(kernel)
        L = CR._nlags(kernel)
        h = history ? H : nothing
        m = history ? size(H, 2) : 0
        at(k, τ) = τ >= 1 ? X[k, τ] : (τ >= 1 - m ? H[k, τ + m] : 0.0)
        hand = [G[k, t] * w(t, k, d) * at(k, t - d) for k in 1:S, d in 0:(L - 1), t in 1:T]
        Y = CR.contributions(conv, X; gain = G, history = h)
        @test size(Y) == (S, L, T)
        @test Y ≈ hand
        @test dropdims(sum(Y; dims = 2); dims = 2) ≈ conv(X; gain = G, history = h)
        @test CR.contributions(conv, X; gain = G, history = h, start = 3, stop = 6) ≈
            hand[:, :, 3:6]
        @test CR.contributions(CR.NoAdjoint(conv), X; history = h) ≈
            CR.contributions(conv, X; history = h)
        if !(kernel isa PerStratum || kernel isa TimeVarying && kernel.x isa PerStratum)
            hist1 = history ? H[1, :] : nothing
            Y1 = CR.contributions(conv, X[1, :]; gain = 0.5, history = hist1)
            @test size(Y1) == (L, T)
            @test Y1 ≈ 0.5 .* hand[1, :, :] ./ G[1:1, :]
        end
    end
    conv = Convolution(c)
    @test (@inferred CR.contributions(conv, X; gain = G)) isa Array{Float64, 3}
    @test (@inferred CR.contributions(conv, X[1, :])) isa Matrix{Float64}
    @test_throws MethodError CR.contributions(conv, X; add = 1.0)
    @test_throws ArgumentError CR.contributions(Convolution(TimeVarying(Ct, P)), X; history = H)
    @test_throws DimensionMismatch CR.contributions(conv, X; gain = rand(rng, 3, T))
end

@testitem "Convolution: inputs after the end of x are zero" setup = [Reference] begin
    using ComposableRecurrences, Random
    using ForwardDiff: Dual
    const CR = ComposableRecurrences
    rng = Xoshiro(73)
    S, T = 3, 20
    padded(x, n) = x isa AbstractVector ? vcat(x, zeros(eltype(x), n - length(x))) :
        hcat(x, zeros(eltype(x), size(x, 1), n - size(x, 2)))
    # Every path against the same call on the series padded with zeros:
    # equal to the bit, since each output takes the same sums.
    kernels = (
        rand(rng, 4), rand(rng, 9), PerStratum(rand(rng, S, 4)),
        TimeVarying(rand(rng, 4, T)), TimeVarying(rand(rng, 4, T), CR.Primary()),
    )
    for k in kernels, e in (0, 1, 3, 15), vec in (true, false)
        vec && k isa PerStratum && continue
        c = Convolution(k)
        x = vec ? rand(rng, e) : rand(rng, S, e)
        h = vec ? rand(rng, 2) : rand(rng, S, 2)
        calls = [
            (;), (; gain = 0.7, add = 1.5),
            (; gain = rand(rng, T), add = rand(rng, T)), (; start = 3),
        ]
        k isa TimeVarying{CR.Primary} ||
            push!(calls, (; history = h), (; history = h, start = 2, gain = 0.3))
        for kw in calls
            @test c(x; stop = T, kw...) == c(padded(x, T); stop = T, kw...)
            @test CR.NoAdjoint(c)(x; stop = T, kw...) ==
                c(padded(x, T); stop = T, kw...)
            # Numbers that gather rather than fill a buffer.
            xd = Dual.(x, 1.0)
            @test c(xd; stop = T, kw...) == c(padded(xd, T); stop = T, kw...)
            @test c(big.(x); stop = T, kw...) == c(padded(big.(x), T); stop = T, kw...)
        end
    end
    # Series short enough to gather their outputs in fours, where the
    # grouping follows the series length.
    rng2 = Xoshiro(2)
    g, x = rand(rng2, 4), rand(rng2, 7)
    @test Convolution(g)(x; stop = 11) == Convolution(g)(padded(x, 11))
    for L in (3, 4, 5), e in 0:(3L), n in (e + 1):(3L + 2), vec in (true, false)
        c = Convolution(rand(rng, L))
        x = vec ? rand(rng, e) : rand(rng, S, e)
        @test c(x; stop = n) == c(padded(x, n))
    end
    # Outputs no lag of `x` reaches are the add input alone.
    x = rand(rng, S, 3)
    y = Convolution(rand(rng, 4))(x; add = 2.0, stop = T)
    @test all(==(2.0), y[:, 7:end])
    @test Convolution(rand(rng, 4))(zeros(S, 0); stop = 5) == zeros(S, 5)
    # The lag contributions read the same zeros.
    c = Convolution(rand(rng, 4))
    @test CR.contributions(c, x; stop = T) == CR.contributions(c, padded(x, T); stop = T)
    # A series zero after day `t0`, passed up to that day.
    I_bar, t0 = rand(rng, S, T), 8
    masked = copy(I_bar)
    masked[:, t0:end] .= 0
    @test c(I_bar[:, 1:(t0 - 1)]; stop = T) == c(masked)
end

@testitem "Convolution: an offset gain or add is refused" begin
    using ComposableRecurrences
    shifted(v) = view(vcat(1000.0, v), Base.IdentityUnitRange(2:(length(v) + 1)))
    conv = Convolution([0.5, 0.5])
    for x in (collect(1.0:6), big.(collect(1.0:6)))
        @test_throws ArgumentError conv(x; gain = shifted(fill(2.0, 6)))
        @test_throws ArgumentError conv(x; add = shifted(fill(2.0, 6)))
    end
end

@testitem "Convolution: axpy loops check their axes" begin
    using ComposableRecurrences
    const CR = ComposableRecurrences
    X = reshape(collect(1.0:24), 8, 3)
    xs = ntuple(k -> view(X, 2:6, k), 3)
    y = view(zeros(8), 3:7)
    CR._axpy!(2.0, xs[1], y)
    @test y == 2 .* xs[1]
    CR._axpy4!(1.0, 2.0, 3.0, 4.0, xs[1], xs[2], xs[3], xs[1], y)
    @test y == 7 .* xs[1] .+ 2 .* xs[2] .+ 3 .* xs[3]

    # Each read vector is checked against the written one, and the message
    # is a constant a device kernel can raise.
    short = view(X, 2:5, 1)
    @test_throws DimensionMismatch CR._axpy!(1.0, short, y)
    for k in 1:4
        x4 = ntuple(i -> i == k ? short : xs[1], 4)
        @test_throws DimensionMismatch CR._axpy4!(1.0, 1.0, 1.0, 1.0, x4..., y)
    end
    err = try
        CR._axpy!(1.0, short, y)
    catch e
        e
    end
    @test err.msg == "axpy vectors have different axes"

    # The loops never reach the mismatch error of `eachindex` over several
    # arrays, which formats the axes into a string.
    V = typeof(y)
    for (f, types) in (
            (CR._axpy!, Tuple{Float64, V, V}),
            (CR._axpy4!, Tuple{ntuple(_ -> Float64, 4)..., ntuple(_ -> V, 5)...}),
        )
        ir = string(only(code_typed(f, types)))
        @test !occursin("eachindex_mismatch", ir)
    end
end
