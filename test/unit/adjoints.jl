# Analytic adjoints called directly, with no AD backend: `pullback!` against
# a ForwardDiff gradient over every float leaf of the operator and its
# arguments. The backend rules in ext/ are tested in test/ad.

@testsnippet AdjointCheck begin
    using ComposableRecurrences: ComposableRecurrences as CR
    using ForwardDiff, LinearAlgebra, Random, SparseArrays

    # A zero cotangent mirror: arrays for float arrays, a `Ref` for a float
    # scalar, NamedTuples for structs, `nothing` where there is none.
    zero_mirror(x::AbstractFloat) = Ref(zero(x))
    zero_mirror(x::AbstractArray{<:AbstractFloat}) = zero(x)
    zero_mirror(x::SparseMatrixCSC{<:AbstractFloat}) = (; nzval = zero(nonzeros(x)))
    zero_mirror(x::Diagonal{<:AbstractFloat}) = (; diag = zero_mirror(x.diag))
    zero_mirror(x::Union{Tuple, NamedTuple}) = map(zero_mirror, x)
    zero_mirror(::Union{Real, AbstractArray, Nothing, Symbol}) = nothing
    function zero_mirror(x)
        n = fieldnames(typeof(x))
        return NamedTuple{n}(map(k -> zero_mirror(getfield(x, k)), n))
    end

    # The mirror's float leaves in the order `CR._params` gives the primal's.
    mirror_vec(x̄::Base.RefValue, x) = [x̄[]]
    mirror_vec(x̄::AbstractArray, x) = vec(copy(x̄))
    mirror_vec(x̄::Nothing, x) = zeros(CR._nparams(x))
    mirror_vec(x̄, x::SparseMatrixCSC) = copy(x̄.nzval)
    mirror_vec(x̄, x::Diagonal) = mirror_vec(x̄.diag, x.diag)
    function mirror_vec(x̄, x::Union{Tuple, NamedTuple})
        return reduce(vcat, map(mirror_vec, values(x̄), values(x)); init = Float64[])
    end
    function mirror_vec(x̄, x)
        n = fieldnames(typeof(x))
        return reduce(
            vcat, map(k -> mirror_vec(getfield(x̄, k), getfield(x, k)), n);
            init = Float64[]
        )
    end

    randlike(rng, y::AbstractArray{<:AbstractFloat}) = randn(rng, size(y))
    randlike(rng, y::Union{Tuple, NamedTuple}) = map(z -> randlike(rng, z), y)
    function randlike(rng, y::CR.State)
        return (; history = randlike(rng, y.history), states = randlike(rng, y.states))
    end
    randlike(rng, y) = y
    dotall(a::AbstractArray{<:Real}, b::AbstractArray) = sum(a .* b)
    dotall(a::NamedTuple, b::CR.State) = dotall(a.history, b.history) + dotall(a.states, b.states)
    dotall(a::Union{Tuple, NamedTuple}, b) = sum(map(dotall, values(a), values(b)); init = 0.0)
    dotall(a, b) = 0.0

    # `pullback!` of `op` at `args` against ForwardDiff, over every float
    # leaf of `(op, args...)`.
    function pullback_matches(op, args...; rng = Xoshiro(1), rtol = 1.0e-8)
        xs = (op, args...)
        y, cache = CR._run_forward(xs...)
        ȳ = randlike(rng, y)
        θ = CR._params(xs)
        f = θ -> dotall(ȳ, first(CR._run_forward(CR._rebuild(xs, θ)...)))
        ref = ForwardDiff.gradient(f, θ)
        ms = zero_mirror(xs)
        grads = (; piece = first(ms), y = ȳ, args = Base.tail(ms))
        CR._run_pullback!(grads, op, cache)
        got = mirror_vec(ms, xs)
        ok = isapprox(got, ref; rtol, atol = 1.0e-10)
        ok || @info "pullback mismatch" op maximum(abs.(got .- ref))
        return ok
    end
    # With the kernel held constant (no kernel mirror), the argument
    # cotangents match those of the full pullback.
    function constant_kernel_matches(
            op, args...; rng = Xoshiro(2),
            constant = p -> merge(p, (; kernel = nothing))
        )
        xs = (op, args...)
        y, cache = CR._run_forward(xs...)
        ȳ = randlike(rng, y)
        full = zero_mirror(xs)
        CR._run_pullback!((; piece = first(full), y = ȳ, args = Base.tail(full)), op, cache)
        part = zero_mirror(xs)
        piece = constant(first(part))
        _, cache = CR._run_forward(xs...)
        CR._run_pullback!((; piece, y = ȳ, args = Base.tail(part)), op, cache)
        return mirror_vec(Base.tail(part), args) ≈ mirror_vec(Base.tail(full), args)
    end
    # The positional arguments of `r(gain; history, add, start, stop)`.
    function recargs(gain, add, h; start = 1, states = nothing, stop = nothing)
        return (gain, add, h, states, start, stop)
    end
end

@testsnippet AdjointModifiers begin
    using ComposableRecurrences: ComposableRecurrences as CR
    using ForwardDiff

    # Floored depletion from a per-stratum pool that is also the initial
    # state. No pullback: the local derivative runs when called directly.
    struct PoolDepletion{P}
        pop::P
    end
    CR.ispointwise(::PoolDepletion) = true
    CR.forward(m::PoolDepletion, ::CR.Init, s, history) = (s .= m.pop; nothing)
    function CR.forward(m::PoolDepletion, ::CR.Step, v, s, t, k)
        v′ = max(s / m.pop[k], 1.0e-6) * v
        return v′, s - v′
    end

    # Hazard depletion with a scalar pool and hand-written pullbacks.
    struct Hazard{T}
        N::T
    end
    CR.ispointwise(::Hazard) = true
    CR.uses_adjoint(::Hazard, ::CR.Step) = true
    CR.forward(m::Hazard, ::CR.Init, s, history) = (fill!(s, m.N); nothing)
    function CR.forward(m::Hazard, ::CR.Step, v, s, t, k)
        x = v / m.N
        return -s * expm1(-x), s * exp(-x)
    end
    function CR.pullback!(grads, m::Hazard, ::CR.Step, v, s, t, k)
        v̄, s̄ = grads.v, grads.s
        x = v / m.N
        e = exp(-x)
        x̄ = s * e * (v̄ - s̄)
        CR.add_cotangent!(CR.cotangent(grads.piece, :N), -x̄ * x / m.N)
        return x̄ / m.N, -v̄ * expm1(-x) + s̄ * e
    end
    function CR.pullback!(grads, m::Hazard, ::CR.Init, s, history)
        CR.add_cotangent!(CR.cotangent(grads.piece, :N), sum(grads.s))
        return nothing
    end

    # Vector-level with a scalar parameter and no pullback.
    struct Scale{A}
        a::A
    end
    function CR.forward(m::Scale, ::CR.Step, v, s, t)
        v .*= m.a
        s .+= v
        return nothing
    end

    # Pointwise and time-varying: add `b[t]` (absolute time).
    struct Shift{B}
        b::B
    end
    CR.ispointwise(::Shift) = true
    CR.forward(m::Shift, ::CR.Step, v, s, t, k) = (v + m.b[t], s)

    # Adds a tenth of each stratum's history total, set once by its Init.
    struct HistoryTotal end
    CR.ispointwise(::HistoryTotal) = true
    function CR.forward(::HistoryTotal, ::CR.Init, s, history)
        s .= vec(sum(history; dims = ndims(history)))
        return nothing
    end
    CR.forward(::HistoryTotal, ::CR.Step, v, s, t, k) = (v + 0.1 * s, s)

    # Pointwise, calling ForwardDiff itself: `v′ = d/dx (a x²) at v`.
    struct Slope{A}
        a::A
    end
    CR.ispointwise(::Slope) = true
    function CR.forward(m::Slope, ::CR.Step, v, s, t, k)
        return ForwardDiff.derivative(x -> m.a * x^2, v), s
    end

    # A coupling with no pullback: `q = β ⊙ (K p)`.
    struct Mix{M, V}
        K::M
        β::V
    end
    CR.forward(C::Mix, ::CR.Pressure, q, p, t) = (q .= C.β .* (C.K * p); nothing)
end

@testitem "Adjoint: Recurrence, single series" setup = [AdjointCheck] begin
    using ComposableRecurrences
    rng = Xoshiro(3)
    L, T = 4, 9
    r = Recurrence(rand(rng, L))
    R = 0.5 .+ rand(rng, T)
    @test pullback_matches(r, recargs(R, nothing, rand(rng, L))...)
    @test pullback_matches(r, recargs(0.8, randn(rng, T), rand(rng, L))...)
    @test pullback_matches(r, recargs(R, 0.3, rand(rng, L))...)
    # Shorter and longer histories, and a later start.
    @test pullback_matches(r, recargs(R, nothing, rand(rng, 2))...)
    @test pullback_matches(r, recargs(R, nothing, rand(rng, 7))...)
    @test pullback_matches(r, recargs(true, randn(rng, T), rand(rng, L))...)
    @test pullback_matches(r, recargs(R, nothing, rand(rng, L); start = 4)...)
end

@testitem "Adjoint: Recurrence couplings and kernels" setup = [AdjointCheck] begin
    using ComposableRecurrences
    rng = Xoshiro(4)
    S, L, T = 3, 3, 8
    g = rand(rng, L)
    h = rand(rng, S, L)
    R = 0.5 .+ rand(rng, S, T)
    ϵ = randn(rng, S, T)
    for C in (
            I, 0.7I, rand(rng, S, S), sparse([0.5 0.0 0.2; 0.1 0.6 0.0; 0.0 0.3 0.9]),
            Diagonal(rand(rng, S)),
        )
        @test pullback_matches(Recurrence(g; coupling = C), recargs(R, ϵ, h)...)
    end
    @test pullback_matches(
        Recurrence(PerStratum(rand(rng, S, L)); coupling = rand(rng, S, S)),
        recargs(R, nothing, h)...
    )
    @test pullback_matches(Recurrence(Pairwise(rand(rng, S, S, L) ./ 3)), recargs(R, ϵ, h)...)
    @test pullback_matches(
        Recurrence(TimeVarying(Pairwise(rand(rng, S, S, L, T) ./ 3))), recargs(R, ϵ, h)...
    )
    # A fixed pairwise kernel with a short history and a later start, and
    # held constant.
    pw = Recurrence(Pairwise(rand(rng, S, S, L) ./ 3))
    @test pullback_matches(pw, recargs(R, nothing, h[:, 1:2]; start = 3)...)
    @test constant_kernel_matches(pw, recargs(R, ϵ, h)...)
end

@testitem "Adjoint: Recurrence time-varying slots at absolute time" setup = [AdjointCheck] begin
    using ComposableRecurrences
    rng = Xoshiro(5)
    S, L, T, start = 2, 3, 7, 3
    h = rand(rng, S, L)
    R = 0.5 .+ rand(rng, S, T)
    r = Recurrence(
        TimeVarying(rand(rng, L, T)); coupling = TimeVarying(rand(rng, S, S, T))
    )
    @test pullback_matches(r, recargs(R, nothing, h; start)...)
    r = Recurrence(TimeVarying(PerStratum(rand(rng, S, L, T))))
    @test pullback_matches(r, recargs(R, nothing, h; start)...)
end

@testitem "Adjoint: Recurrence modifiers" setup = [AdjointCheck, AdjointModifiers] begin
    using ComposableRecurrences
    rng = Xoshiro(6)
    S, L, T = 3, 3, 7
    g = rand(rng, L) ./ 2
    K = rand(rng, S, S) ./ 2
    h = 1 .+ rand(rng, S, L)
    R = 0.5 .+ rand(rng, S, T)
    for mods in (
            (PoolDepletion([30.0, 40.0, 50.0]),),
            (Hazard(45.0),),
            (Shift(randn(rng, T)), HistoryTotal()),
            (Shift(randn(rng, T)), Hazard(60.0)),
            (Slope(0.3),),
            (CR.Depletion(PerStratum([40.0, 50.0, 60.0])),),
            (CR.Depletion(50.0, CR.Floor(); heterogeneity = 1.5),),
            (CR.Redistribute(K, PerStratum([0.3, 0.2, 0.1])), CR.Add(PerStratum([0.1, 0.2, 0.3]))),
            (CR.Clamp(0.0, 3.0),),
            (CR.Allocate([[1, 3], [2]], TimeVarying(PerStratum(4 .+ rand(rng, 2, T)))),),
            (CR.Allocate([1:3], 5.0), CR.Add(0.2)),
        )
        r = Recurrence(g; coupling = K, modifiers = mods)
        @test pullback_matches(r, recargs(R, nothing, h)...)
    end
    # A pool held in a view gets its cotangent.
    pool = view([0.0, 30.0, 40.0, 50.0], 2:4)
    r = Recurrence(g; coupling = K, modifiers = (PoolDepletion(pool),))
    @test pullback_matches(r, recargs(R, nothing, h)...)
    # Resumed from given states.
    r = Recurrence(g; coupling = K, modifiers = (PoolDepletion([30.0, 40.0, 50.0]),))
    @test pullback_matches(r, recargs(R, nothing, h; states = ([20.0, 25.0, 30.0],))...)
end

@testitem "Adjoint: Recurrence reverse pass in threaded blocks" setup = [AdjointCheck, AdjointModifiers] begin
    using ComposableRecurrences
    using Base.ScopedValues: with
    rng = Xoshiro(16)
    S, L, T = 5, 3, 9
    g = rand(rng, L) ./ 2
    K = rand(rng, S, S) ./ 4
    h = 1 .+ rand(rng, S, L)
    R = 0.5 .+ rand(rng, S, T)
    ϵ = randn(rng, S, T)
    mods = (CR.Depletion(PerStratum(fill(60.0, S)), CR.Floor()), CR.Add(0.2))
    ops = (
        Recurrence(g; modifiers = mods),
        Recurrence(g; coupling = 0.8I, modifiers = (CR.Clamp(0.0, 4.0),)),
        Recurrence(PerStratum(rand(rng, S, L)); coupling = Diagonal(rand(rng, S))),
        Recurrence(TimeVarying(rand(rng, L, T)); modifiers = (PoolDepletion(fill(40.0, S)),)),
        Recurrence(g; coupling = K, modifiers = mods),
        Recurrence(Pairwise(rand(rng, S, S, L) ./ S); modifiers = mods),
        Recurrence(g; modifiers = (CR.Allocate([1:2, 3:5], 6.0), CR.Add(0.1))),
    )
    for ex in (CR.Threaded(; min_work = 0, ntasks = 2), CR.Threaded(; min_work = 0))
        with(CR.EXECUTOR => ex) do
            for r in ops
                @test pullback_matches(r, recargs(R, ϵ, h)...)
                @test pullback_matches(r, recargs(R[1, :], nothing, h)...)
            end
        end
    end
end

@testitem "Adjoint: Recurrence cache keeps only what the reverse pass reads" setup = [AdjointCheck] begin
    using ComposableRecurrences
    S, L, T = 3, 2, 5
    h = ones(S, L)
    R = fill(1.2, S, T)
    mods = (CR.Add(0.1), CR.Depletion(50.0), CR.Clamp(0.0, 9.0))
    for C in (I, rand(S, S))
        r = Recurrence([0.4, 0.3]; coupling = C, modifiers = mods)
        _, c = CR._run_forward(r, recargs(R, nothing, h)...)
        @test size(c.pr.P) == (S, T)
        # A pointwise coupling's pressures follow from the convolutions.
        if C === I
            @test c.pr.X === nothing
        else
            @test size(c.pr.X) == (S, T)
        end
        # A modifier whose state never changes keeps the state it started
        # from rather than a record per step.
        @test c.rec[1].S == zeros(S)
        @test size(c.rec[2].S) == (S, T)
        @test c.rec[3].S == zeros(S)
    end
    # A resumed stateless modifier reads the state it was given.
    r = Recurrence([0.4, 0.3]; modifiers = (CR.Add(0.1),))
    @test pullback_matches(r, recargs(R, nothing, h; states = ([0.5, 1.0, 2.0],))...)
end

@testitem "Adjoint: Depletion with a population that varies over time" setup = [AdjointCheck] begin
    using ComposableRecurrences
    rng = Xoshiro(8)
    S, L, T, start = 2, 3, 6, 4
    g = rand(rng, L) ./ 2
    K = rand(rng, S, S) ./ 2
    h = 1 .+ rand(rng, S, L)
    R = 0.5 .+ rand(rng, S, T)
    stop = start + T - 1
    N = 40 .+ 10 .* rand(rng, S, stop)
    births = TimeVarying(PerStratum(-rand(rng, S, stop)))
    for d in (
            CR.Depletion(TimeVarying(PerStratum(N))),
            CR.Depletion(TimeVarying(N[1, :]), CR.Floor(); pool0 = 30.0),
            CR.Depletion(TimeVarying(PerStratum(N)); removals = births),
            CR.Depletion(Derived(+, PerStratum([30.0, 40.0]), TimeVarying(N[1, :]))),
            CR.Depletion(
                TimeVarying(PerStratum(N)); removals = births,
                protected = CR.Protected(0.3; pool0 = 5.0)
            ),
        )
        r = Recurrence(g; coupling = K, modifiers = (d,))
        @test pullback_matches(r, recargs(R, nothing, h; start)...)
    end
end

@testitem "Adjoint: Recurrence returning its state" setup = [AdjointCheck, AdjointModifiers] begin
    using ComposableRecurrences
    rng = Xoshiro(7)
    S, L = 2, 3
    r = Recurrence(rand(rng, L) ./ 2; coupling = rand(rng, S, S), modifiers = (Hazard(50.0),))
    for (T, m) in ((6, 3), (2, 3), (6, 5), (2, 1))
        args = recargs(0.5 .+ rand(rng, S, T), nothing, 1 .+ rand(rng, S, m))
        @test pullback_matches(CR._WithState(r), args...)
    end
end

@testitem "Adjoint: Recurrence with mixed eltypes" setup = [AdjointCheck] begin
    using ComposableRecurrences
    rng = Xoshiro(8)
    S, L, T = 2, 3, 6
    r = Recurrence(Float32.(rand(rng, L)); coupling = Float32.(rand(rng, S, S)))
    @test pullback_matches(
        r, recargs(0.5 .+ rand(rng, S, T), nothing, rand(Float32, S, L))...;
        rtol = 1.0e-5
    )
end

@testitem "Adjoint: Convolution" setup = [AdjointCheck] begin
    using ComposableRecurrences
    rng = Xoshiro(9)
    S, D, T = 2, 4, 7
    g = rand(rng, D)
    x = rand(rng, T)
    X = rand(rng, S, T)
    @test pullback_matches(Convolution(g), x, true, nothing, nothing, 1, nothing)
    @test pullback_matches(Convolution(g), x, true, nothing, rand(rng, 2), 1, nothing)
    @test pullback_matches(Convolution(g), X, true, nothing, rand(rng, S, 5), 3, nothing)
    @test pullback_matches(Convolution(g), X, true, nothing, nothing, 2, 5)
    @test pullback_matches(Convolution(PerStratum(rand(rng, S, D))), X, true, nothing, nothing, 1, nothing)
    for start in (1, 4)
        c = Convolution(TimeVarying(PerStratum(rand(rng, S, D, T))))
        @test pullback_matches(c, X, true, nothing, rand(rng, S, 3), start, nothing)
        c = Convolution(TimeVarying(rand(rng, D, T), CR.Primary()))
        @test pullback_matches(c, x, true, nothing, nothing, start, nothing)
        c = Convolution(TimeVarying(rand(rng, D, T)))
        @test pullback_matches(c, X, true, nothing, rand(rng, S, 2), start, nothing)
        @test constant_kernel_matches(c, X, true, nothing, rand(rng, S, 2), start, nothing)
        c = Convolution(TimeVarying(PerStratum(rand(rng, S, D, T)), CR.Primary()))
        @test pullback_matches(c, X, true, nothing, nothing, start, nothing)
        c = Convolution(TimeVarying(rand(rng, D, T), CR.Primary()))
        @test constant_kernel_matches(c, X, true, nothing, nothing, start, nothing)
    end
end

@testitem "Adjoint: Convolution gain and add" setup = [AdjointCheck] begin
    using ComposableRecurrences
    rng = Xoshiro(11)
    S, D, T = 2, 4, 7
    x, X = rand(rng, T), rand(rng, S, T)
    h = rand(rng, S, 3)
    c = Convolution(rand(rng, D))
    @test pullback_matches(c, x, 0.4, nothing, nothing, 1, nothing)
    @test pullback_matches(c, x, rand(rng, T), 0.3, rand(rng, 2), 2, nothing)
    @test pullback_matches(c, X, rand(rng, T), rand(rng, S, T), h, 3, nothing)
    @test pullback_matches(c, X, true, rand(rng, T), nothing, 1, 5)
    @test constant_kernel_matches(c, X, rand(rng, S, T), 0.5, h, 2, nothing)
    c = Convolution(TimeVarying(rand(rng, D, T), CR.Primary()))
    @test pullback_matches(c, X, rand(rng, S, T), rand(rng, T), nothing, 3, nothing)
end

@testitem "Adjoint: contributions" setup = [AdjointCheck] begin
    using ComposableRecurrences
    rng = Xoshiro(12)
    S, D, T = 2, 4, 7
    x, X = rand(rng, T), rand(rng, S, T)
    ks = [rand(rng, n) for n in (2, 0, 4, 1, 3, 4, 2)]
    kernels = (
        rand(rng, D), PerStratum(rand(rng, S, D)), TimeVarying(rand(rng, D, T)),
        TimeVarying(PerStratum(rand(rng, S, D, T))), TimeVarying(ks),
    )
    for k in kernels, start in (1, 3)
        op = CR._Contributions(Convolution(k))
        @test pullback_matches(op, X, rand(rng, S, T), rand(rng, S, 2), start, nothing)
        @test constant_kernel_matches(
            op, X, 0.5, nothing, start, nothing; constant = p -> (; c = (; kernel = nothing))
        )
        k isa PerStratum || k isa TimeVarying && k.x isa PerStratum ||
            @test pullback_matches(op, x, rand(rng, T), nothing, start, 6)
    end
    for k in (TimeVarying(rand(rng, D, T), CR.Primary()), TimeVarying(ks, CR.Primary()))
        op = CR._Contributions(Convolution(k))
        @test pullback_matches(op, X, rand(rng, T), nothing, 2, nothing)
        @test pullback_matches(op, x, 0.7, nothing, 1, nothing)
    end
end

@testitem "Adjoint: ragged time-varying kernels" setup = [AdjointCheck] begin
    using ComposableRecurrences
    rng = Xoshiro(10)
    S, T = 2, 9
    # An empty column, and columns shorter and longer than the window reaches.
    ks = [rand(rng, n) ./ 3 for n in (2, 0, 4, 1, 3, 4, 0, 2, 1)]
    X = rand(rng, S, T)
    R = 0.5 .+ rand(rng, S, T)
    h = rand(rng, S, 4)
    for start in (1, 4)
        c = Convolution(TimeVarying(ks))
        @test pullback_matches(c, X, true, nothing, rand(rng, S, 2), start, nothing)
        @test constant_kernel_matches(c, X, true, nothing, rand(rng, S, 2), start, nothing)
        c = Convolution(TimeVarying(ks, CR.Primary()))
        @test pullback_matches(c, X, true, nothing, nothing, start, 7)
        @test constant_kernel_matches(c, X, true, nothing, nothing, start, nothing)
    end
    r = Recurrence(TimeVarying(ks); coupling = rand(rng, S, S))
    @test pullback_matches(r, recargs(R, nothing, h; start = 2)...)
    r = Recurrence(TimeVarying(ks, CR.Primary()))
    @test pullback_matches(r, recargs(R, randn(rng, S, T), h; start = 5)...)
    @test constant_kernel_matches(r, recargs(R, nothing, h; start = 5)...)
end

@testitem "Adjoint: routing by uses_adjoint" setup = [AdjointCheck, AdjointModifiers] begin
    using ComposableRecurrences, ConstructionBase, ForwardDiff
    g, K = [0.2, 0.3], [0.5 0.1; 0.2 0.4]
    args = recargs(ones(2, 4), nothing, ones(2, 2))
    val(op) = Base.return_types(CR._route_val, typeof.((op, args...)))
    # Built-in parts and pointwise modifiers with scalar parameters take the
    # rule; the route is decided from the types.
    for (op, route) in (
            (Recurrence(g), :rule), (Recurrence(g; coupling = K), :rule),
            (Recurrence(g; modifiers = (CR.Depletion(50.0),)), :rule),
            (Recurrence(g; modifiers = (Slope(0.3),)), :rule),
            (Recurrence(g; modifiers = (Slope(0.3), CR.Clamp(0.0, 9.0))), :rule),
            (
                Recurrence(g; modifiers = (CR.Allocate([1:1, 2:2], PerStratum([1.0, 2.0])),)),
                :rule,
            ),
        )
        @test CR.uses_adjoint(op, CR.Run())
        @test val(op) == [Val{route}]
        @test val(CR._WithState(op)) == [Val{route}]
    end
    # A vector-level modifier or a coupling without a pullback, or a
    # pointwise modifier without one and with array parameters, sends the
    # whole operator to plain AD.
    for op in (
            Recurrence(g; modifiers = (Scale(0.9),)),
            Recurrence(g; coupling = Mix(K, [1.0, 1.0])),
            Recurrence(g; modifiers = (PoolDepletion([30.0, 40.0]),)),
        )
        @test !CR.uses_adjoint(op, CR.Run())
        @test val(op) == [Val{:plain}]
    end
    # A `pullback!` method opts a modifier in, and declaring `uses_adjoint`
    # overrides it.
    struct Scaled{A}
        a::A
    end
    CR.forward(m::Scaled, ::CR.Step, v, s, t) = (v .*= m.a; nothing)
    rs = Recurrence(g; modifiers = (Scaled(0.5),))
    @test !CR.uses_adjoint(rs, CR.Run())
    CR.pullback!(grads, m::Scaled, ::CR.Step, v, s, t) = (grads.v .*= m.a; nothing)
    @test CR.uses_adjoint(Scaled(0.5), CR.Step())
    # Only the roles an operator's rule calls are derived.
    @test !CR._has_pullback(Scaled(0.5), CR.Init())
    @test CR.uses_adjoint(rs, CR.Run())
    @test val(rs) == [Val{:rule}]
    CR.uses_adjoint(::Scaled, ::CR.Step) = false
    @test !CR.uses_adjoint(rs, CR.Run())
    # A method with typed arguments is not found; declaring it opts in.
    struct Typed{A}
        a::A
    end
    CR.ispointwise(::Typed) = true
    CR.forward(m::Typed, ::CR.Step, v, s, t, k) = (m.a * v, s)
    function CR.pullback!(grads, m::Typed, ::CR.Step, v::Real, s::Real, t, k)
        CR.add_cotangent!(CR.cotangent(grads.piece, :a), grads.v * v)
        return m.a * grads.v, grads.s
    end
    rt = Recurrence(g; modifiers = (Typed(0.5),))
    @test CR._modifier_adjoint(Typed(0.5)) === :local
    CR.uses_adjoint(::Typed, ::CR.Step) = true
    @test CR._modifier_adjoint(Typed(0.5)) === :pullback
    @test pullback_matches(rt, recargs(ones(2, 4), nothing, ones(2, 2))...)

    # A function stored in a pointwise modifier with no pullback: a plain
    # function or a callable singleton keeps the rule, a closure that
    # captures a float takes plain AD, as the local derivative does not reach
    # its captured value.
    struct MapBy{F, T}
        f::F
        a::T
    end
    CR.ispointwise(::MapBy) = true
    CR.forward(m::MapBy, ::CR.Step, v, s, t, k) = (m.a * m.f(v), s)
    struct Halve end
    (::Halve)(x) = x / 2
    shift(b) = x -> x + b
    count_up(n::Int) = x -> x + n
    for (f, rule) in (
            (sqrt, true), (Halve(), true), (count_up(2), true),
            (shift(0.5), false), (shift([0.5]), false), (Base.Fix1(*, 2.0), false),
        )
        op = Recurrence(g; modifiers = (MapBy(f, 0.9),))
        @test CR._scalar_params(MapBy(f, 0.9)) == rule
        @test CR.uses_adjoint(op, CR.Run()) == rule
        @test val(op) == [Val{rule ? :rule : :plain}]
    end
    # Integer ranges and arrays are structure, not parameters, for the gate.
    struct Pick{I, T}
        idx::I
        a::T
    end
    CR.ispointwise(::Pick) = true
    CR.forward(m::Pick, ::CR.Step, v, s, t, k) = (k in m.idx ? m.a * v : v, s)
    for idx in (1:2, 1:2:3, Base.OneTo(2), [1, 2], [1:1, 2:2], [[1], [2]], (1:1, 2:2))
        op = Recurrence(g; modifiers = (Pick(idx, 0.5),))
        @test CR._ok(typeof(idx))
        @test val(op) == [Val{:rule}]
    end
    @test pullback_matches(
        Recurrence(g; modifiers = (Pick(2:2, 0.5),)),
        recargs(ones(2, 4), nothing, ones(2, 2))...
    )
    # The default pullback rebuilds a scalar modifier with dual numbers by
    # `constructorof`. A keyword-only constructor or a field typed `Float64`
    # cannot take them, and a constructor that transforms its argument does
    # not give it back. The `Recurrence` constructor checks this once, by
    # value, and stores the outcome; the route from the types is the rule.
    struct ScaleKw
        a::Float64
        ScaleKw(; a) = new(a)
    end
    struct ScaleF
        a::Float64
    end
    struct Doubled{T}
        a::T
        Doubled(a::T) where {T} = new{T}(2a)
    end
    struct Kept{T}
        a::T
        Kept(a::T) where {T} = new{T}(abs(a))
    end
    for M in (ScaleKw, ScaleF, Doubled, Kept)
        @eval CR.ispointwise(::$M) = true
        @eval CR.forward(m::$M, ::CR.Step, v, s, t, k) = (m.a * v, s)
    end
    for (m, rule) in (
            (ScaleKw(; a = 0.5), false), (ScaleF(0.5), false),
            (Doubled(0.5), false), (Kept(0.5), true),
        )
        op = Recurrence(g; modifiers = (m,))
        @test CR._modifier_adjoint(m) === :local
        @test CR._round_trips(m) == rule
        @test CR._rebuilds(op) === rule
        @test CR.uses_adjoint(op, CR.Run()) == rule
        @test val(op) == [Val{:rule}]
        rule || @test occursin(string(nameof(typeof(m))), CR._plain_why(op))
        # The check runs at construction, which stays type stable.
        @inferred Recurrence(g, I, (m,))
    end
    # A modifier that does not rebuild is sent to plain AD, and the primal
    # call logs nothing.
    op = Recurrence(g; modifiers = (Doubled(0.5),))
    y = @test_logs CR.adjoint_call(op, args...)
    @test y == CR._plain(op, args...)
    # A field of abstract type is not differentiated locally.
    struct Loose
        a::Any
    end
    CR.ispointwise(::Loose) = true
    @test CR._modifier_adjoint(Loose(0.5)) === :none
    # Without a modifier to check, the outcome is read off the types.
    for ms in ((), (CR.Depletion(50.0), CR.Clamp(0.0, 9.0)), (CR.Add(1.0),))
        @test CR._rebuilds(@inferred Recurrence(g, I, ms)) === Val(true)
    end
    @test CR._rebuilds(Convolution([0.5, 0.5])) === Val(true)
    @test CR._round_trips(Loose(1))
    @test CR._plain_why(Recurrence(g)) == CR._ADJOINT_NOTE
    @test occursin("Doubled", CR._plain_why(CR._WithState(op)))
    # A rebuild through `constructorof` recomputes the check.
    op = ConstructionBase.setproperties(op; modifiers = (Kept(0.5),))
    @test CR._rebuilds(op) === true
    op = ConstructionBase.setproperties(op; modifiers = (CR.Add(1.0),))
    @test CR._rebuilds(op) === Val(true)
    # A constructor that throws is taken as not rebuilding, but an interrupt
    # is not swallowed.
    struct Strict{T}
        a::T
        Strict(a::T) where {T} = a isa AbstractFloat ? new{T}(a) : throw(ArgumentError("no"))
    end
    struct Halt{T}
        a::T
        Halt(a::T) where {T} = a isa AbstractFloat ? new{T}(a) : throw(InterruptException())
    end
    @test CR._round_trips(Strict(0.5)) === false
    @test_throws InterruptException CR._round_trips(Halt(0.5))
    @test pullback_matches(
        Recurrence(g; modifiers = (Kept(0.5),)),
        recargs(ones(2, 4), nothing, ones(2, 2))...
    )

    # A depletion form without a pullback takes the rule through the local
    # derivative of its step in `(v, s, N, α)` and its own float scalars.
    struct LinearRate{T}
        c::T
    end
    function CR.forward(f::LinearRate, ::CR.Step, v, s, N, α)
        y = f.c * v * max(s, 0)^α / N
        return y, s - y
    end
    f = LinearRate(0.7)
    grads = (; piece = (; c = Ref(0.0)), v = 0.3, s = 0.6)
    got = CR._form_pullback(grads, f, 2.0, 40.0, 50.0, 1.2)
    ref = ForwardDiff.gradient(collect((2.0, 40.0, 50.0, 1.2, 0.7))) do x
        y, s′ = CR.forward(LinearRate(x[5]), CR.Step(), x[1], x[2], x[3], x[4])
        return 0.3 * y + 0.6 * s′
    end
    @test [got..., grads.piece.c[]] ≈ ref
    for op in (
            Recurrence(g; modifiers = (CR.Depletion(50.0, f; heterogeneity = 1.2),)),
            Recurrence(g; modifiers = (CR.Depletion(50.0, f; removals = 0.5),)),
        )
        @test CR.uses_adjoint(op, CR.Run())
        @test val(op) == [Val{:rule}]
        @test pullback_matches(op, recargs(ones(2, 4), nothing, ones(2, 2))...)
    end
    # A form whose constructor transforms its argument is found by value.
    struct DoubledRate{T}
        c::T
        DoubledRate(c::T) where {T} = new{T}(2c)
    end
    CR.forward(f::DoubledRate, ::CR.Step, v, s, N, α) = CR.forward(LinearRate(f.c), CR.Step(), v, s, N, α)
    op = Recurrence(g; modifiers = (CR.Depletion(50.0, DoubledRate(0.7)),))
    @test !CR.uses_adjoint(op, CR.Run())
    @test CR._rebuilds(op) === false
    @test occursin("DoubledRate", CR._plain_why(op))
    @test CR.uses_adjoint(Recurrence(g; modifiers = (CR.Depletion(50.0, f),)), CR.Run())

    # Dual numbers and BigFloat take the plain path.
    r = Recurrence(g)
    @test CR._gate(r, ones(4), nothing, ones(2), nothing, 1, nothing)
    @test !CR._gate(r, ForwardDiff.Dual(1.0, 1.0), nothing, ones(2), nothing, 1, nothing)
    @test !CR._gate(r, big.(ones(4)), nothing, ones(2), nothing, 1, nothing)
end

@testitem "Adjoint: user operators declare their adjoint" setup = [AdjointCheck] begin
    using ComposableRecurrences
    struct Twice <: CR.AbstractOperator end
    CR.forward(::Twice, ::CR.Run, x) = (2 .* x, nothing)
    @test !CR.uses_adjoint(Twice(), CR.Run())
    @test Base.return_types(CR._route_val, (Twice, Vector{Float64})) == [Val{:plain}]
    function CR.pullback!(grads, ::Twice, ::CR.Run, cache)
        only(grads.args) .+= 2 .* grads.y
        return nothing
    end
    @test CR.uses_adjoint(Twice(), CR.Run())
    @test Base.return_types(CR._route_val, (Twice, Vector{Float64})) == [Val{:rule}]
    @test Twice()(ones(2)) == [2.0, 2.0]
end

@testitem "Adjoint: a declared adjoint without a pullback! throws" setup = [AdjointCheck] begin
    using ComposableRecurrences
    # Declared for a role with no `pullback!` method: the reverse pass names
    # the piece and the role.
    struct Halved end
    CR.ispointwise(::Halved) = true
    CR.forward(::Halved, ::CR.Step, v, s, t, k) = (v / 2, s)
    CR.uses_adjoint(::Halved, ::CR.Step) = true
    args = recargs(ones(2, 4), nothing, ones(2, 2))
    r = Recurrence([0.3, 0.2]; modifiers = (Halved(),))
    @test Base.return_types(CR._route_val, typeof.((r, args...))) == [Val{:rule}]
    @test_throws "Halved uses its adjoint in Step()" pullback_matches(r, args...)
    struct Thrice <: CR.AbstractOperator end
    CR.forward(::Thrice, ::CR.Run, x) = (3 .* x, nothing)
    CR.uses_adjoint(::Thrice, ::CR.Run) = true
    grads = (; piece = nothing, y = ones(2), args = (zeros(2),))
    @test_throws "Thrice uses its adjoint in Run()" CR._run_pullback!(grads, Thrice(), nothing)
end

@testitem "Adjoint: a plain primal call logs nothing" setup = [AdjointModifiers] begin
    using ComposableRecurrences
    # A modifier without an adjoint, and one whose float field is typed
    # `Float64`: the plain path is taken, but only differentiation logs it.
    struct ScaleF
        a::Float64
    end
    CR.ispointwise(::ScaleF) = true
    CR.forward(m::ScaleF, ::CR.Step, v, s, t, k) = (m.a * v, s)
    for m in (Scale(0.9), ScaleF(0.9))
        r = Recurrence([0.2, 0.3]; modifiers = (m,))
        @test_logs r(ones(4); history = ones(2))
        @test_logs CR.with_state(r, ones(4); history = ones(2))
    end
end

@testitem "Adjoint: cotangent helpers" setup = [AdjointCheck] begin
    using ComposableRecurrences
    @test CR.cotangent(nothing, :a) === nothing
    @test CR.cotangent((; a = [1.0]), :a) == [1.0]
    x̄ = Ref(1.0)
    CR.add_cotangent!(x̄, 2.0, 3)
    @test x̄[] == 3.0
    x̄ = zeros(2, 2)
    CR.add_cotangent!(x̄, 2.0, 1, 2)
    @test x̄[1, 2] == 2.0
    CR.add_cotangent!((; x = x̄), 1.0, 1, 2)
    @test x̄[1, 2] == 3.0
    @test CR.add_cotangent!(nothing, 1.0, 1) === nothing
    # A structured matrix's mirror keeps its structure: only stored entries
    # take a cotangent.
    d̄ = (; diag = zeros(2))
    CR._add_entry!(d̄, Diagonal(ones(2)), 1.5, 2, 2)
    CR._add_entry!(d̄, Diagonal(ones(2)), 1.0, 1, 2)
    @test d̄.diag == [0.0, 1.5]
    K = sparse([1.0 0.0; 0.5 1.0])
    K̄ = (; nzval = zeros(3))
    CR._add_entry!(K̄, K, 2.0, 2, 1)
    CR._add_entry!(K̄, K, 1.0, 1, 2)
    @test K̄.nzval == [0.0, 2.0, 0.0]
end

@testitem "Adjoint: NoAdjoint takes the plain path" begin
    using ComposableRecurrences
    using ComposableRecurrences: NoAdjoint
    CR = ComposableRecurrences
    r = Recurrence([0.2, 0.3])
    n0 = CR._PULLBACK_CALLS[]
    @test NoAdjoint(r)(ones(4); history = ones(2)) == r(ones(4); history = ones(2))
    y, st = CR.with_state(NoAdjoint(r), ones(4); history = ones(2))
    y2, st2 = CR.with_state(r, ones(4); history = ones(2))
    @test y == y2 && st.history == st2.history && st.t == st2.t
    c = Convolution([0.5, 0.5])
    @test NoAdjoint(c)(ones(3)) == c(ones(3))
    @test CR._PULLBACK_CALLS[] == n0
end

@testitem "Adjoint: buffers follow the input's array type" setup = [AdjointCheck] begin
    using ComposableRecurrences
    # An array type whose `similar` keeps the wrapper, standing in for a
    # device array: every buffer and cotangent must be allocated like it.
    struct Wrapped{T, N} <: AbstractArray{T, N}
        a::Array{T, N}
    end
    Base.size(w::Wrapped) = size(w.a)
    Base.getindex(w::Wrapped, i::Int...) = w.a[i...]
    Base.setindex!(w::Wrapped, v, i::Int...) = (w.a[i...] = v)
    Base.similar(w::Wrapped, ::Type{T}, dims::Dims) where {T} = Wrapped(similar(w.a, T, dims))
    unwrap(x::Wrapped) = x.a
    unwrap(x) = x

    rng = Xoshiro(2)
    S, L, T = 2, 3, 5
    r = Recurrence(rand(rng, L); coupling = rand(rng, S, S), modifiers = (CR.Depletion(40.0),))
    R, h = 0.5 .+ rand(rng, S, T), 1 .+ rand(rng, S, L)
    y, c = CR._run_forward(r, R, nothing, Wrapped(h), nothing, 1, nothing)
    @test c.H isa Wrapped && c.pr.P isa Wrapped && c.pr.X isa Wrapped
    @test only(c.rec).V isa Wrapped
    yref, cref = CR._run_forward(r, R, nothing, h, nothing, 1, nothing)
    @test unwrap(y) ≈ yref
    ȳ = randn(rng, S, T)
    h̄, h̄ref = zeros(S, L), zeros(S, L)
    args(h̄) = (nothing, nothing, h̄, nothing, nothing, nothing)
    CR._run_pullback!((; piece = nothing, y = ȳ, args = args(h̄)), r, c)
    CR._run_pullback!((; piece = nothing, y = ȳ, args = args(h̄ref)), r, cref)
    @test h̄ ≈ h̄ref

    c = Convolution(rand(rng, 3))
    x = rand(rng, S, T)
    y, cache = CR._run_forward(c, Wrapped(x), true, nothing, nothing, 1, nothing)
    @test cache.X isa Wrapped
    @test unwrap(y) ≈ first(CR._run_forward(c, x, true, nothing, nothing, 1, nothing))
end

@testitem "Adjoint: scalar-parameter local pullback" setup = [AdjointCheck] begin
    # A pointwise modifier with only scalar parameters, nested in a struct,
    # mixed float types and an integer field: the default `Step` pullback
    # seeds them as one tuple of dual numbers.
    struct Inner{T}
        N::T
        k::Int
    end
    struct Outer{A, B}
        a::A
        inner::B
    end
    CR.ispointwise(::Outer) = true
    function CR.forward(m::Outer, ::CR.Step, v, s, t, k)
        v′ = m.a * max(s / m.inner.N, 1.0e-6) * v * m.inner.k
        return v′, s - v′
    end
    m = Outer(0.7f0, Inner(50.0, 2))
    @test CR._scalar_params(m)
    @test CR._param_tuple(m) == (0.7f0, 50.0)
    for (v, s) in ((2.0, 30.0), (1.5, 0.2))
        # Reference: the Jacobian of the step in the value, state and
        # parameters.
        J = ForwardDiff.jacobian([v; s; CR._params(m)]) do x
            v′, s′ = CR.forward(
                CR._rebuild(m, view(x, 3:4)), CR.Step(), x[1], x[2], 1, 1
            )
            return [v′, s′]
        end
        ref = transpose(J) * [0.3, 0.7]
        m̄ = zero_mirror(m)
        got = CR._step_pullback((; piece = m̄, v = 0.3, s = 0.7), m, v, s, 1, 1)
        @test collect(got) ≈ ref[1:2]
        @test mirror_vec(m̄, m) ≈ ref[3:4] rtol = 1.0e-6
        # Without a mirror only the value and state cotangents come back.
        @test collect(CR._step_pullback((; piece = nothing, v = 0.3, s = 0.7), m, v, s, 1, 1)) ≈
            ref[1:2]
    end
    # A step allocates nothing: a thousand cost less than one kilobyte.
    function steps(m, m̄, n)
        acc = 0.0
        for i in 1:n
            v̄, s̄ = CR._step_pullback(
                (; piece = m̄, v = 0.3, s = 0.7), m, 2.0 + i, 30.0, 1, 1
            )
            acc += v̄ + s̄
        end
        return acc
    end
    m̄ = zero_mirror(m)
    steps(m, m̄, 2)
    @test (@allocated steps(m, m̄, 1000)) < 1000
    steps(m, nothing, 2)
    @test (@allocated steps(m, nothing, 1000)) < 1000
    # Through a recurrence the rule matches ForwardDiff.
    r = CR.Recurrence([0.3, 0.2]; modifiers = (m,))
    @test pullback_matches(r, recargs(1.1, nothing, [1.0, 2.0]; stop = 6)...)
end

@testitem "Adjoint: the default Init pullback skips a zero state cotangent" setup = [AdjointCheck] begin
    # A modifier with its own Init whose state never reaches the output: the
    # state cotangent is zero, so the Jacobian over the history is skipped.
    struct Capped{K}
        κ::K
    end
    CR.ispointwise(::Capped) = true
    # Counts the Init calls on dual numbers, which only the Jacobian makes.
    const DUAL_INITS = Ref(0)
    function CR.forward(::Capped, ::CR.Init, s, history)
        eltype(history) <: ForwardDiff.Dual && (DUAL_INITS[] += 1)
        s .= sum(history)
        return nothing
    end
    CR.forward(m::Capped, ::CR.Step, v, s, t, k) = (v * m.κ / (m.κ + v), s)
    m, h = Capped(5.0), ones(3, 4)
    init_back(s̄) = (; piece = (; κ = Ref(0.0)), s = s̄, history = zeros(3, 4))
    zero_grads, one_grads = init_back(zeros(3)), init_back(ones(3))
    CR.pullback!(zero_grads, m, CR.Init(), zeros(3), h)
    @test DUAL_INITS[] == 0
    @test all(iszero, zero_grads.history)
    # A nonzero one takes the Jacobian.
    CR.pullback!(one_grads, m, CR.Init(), zeros(3), h)
    @test DUAL_INITS[] > 0
    @test one_grads.history ≈ fill(3.0, 3, 4)
    r = Recurrence([0.3, 0.2, 0.1]; modifiers = (m,))
    @test pullback_matches(r, recargs(ones(3, 5), nothing, h)...)
end

@testitem "Adjoint: coupling pullbacks called directly" setup = [AdjointCheck] begin
    # `I` and `Diagonal` couplings have fused paths inside the recurrence
    # rule; their `Pressure` pullbacks are public and checked here.
    rng = Xoshiro(3)
    p, q̄ = randn(rng, 3), randn(rng, 3)
    for (C, m̄, θ) in (
            (2.5I, (; λ = Ref(0.0)), [2.5]),
            (Diagonal([0.5, 1.5, 2.0]), (; diag = zeros(3)), [0.5, 1.5, 2.0]),
        )
        rebuild(θ) = C isa UniformScaling ? θ[1] * I : Diagonal(θ)
        function pressure(θ, p)
            q = zeros(promote_type(eltype(θ), eltype(p)), 3)
            CR.forward(rebuild(θ), CR.Pressure(), q, p, 1)
            return sum(q̄ .* q)
        end
        p̄ = zeros(3)
        CR.pullback!((; piece = m̄, q = q̄, p = p̄), C, CR.Pressure(), nothing, p, 1)
        @test p̄ ≈ ForwardDiff.gradient(x -> pressure(θ, x), p)
        @test mirror_vec(m̄, C isa UniformScaling ? (; λ = 2.5) : C) ≈
            ForwardDiff.gradient(x -> pressure(x, p), θ)
    end
end

@testitem "Adjoint: local pullback over structured and nested parameters" setup = [AdjointCheck] begin
    # A pointwise modifier with array parameters takes the local Jacobian:
    # a Diagonal, a sparse matrix, a named tuple and a tuple holding an
    # array, read back in the order the parameters are collected.
    struct Mixed{D, M, N, P}
        D::D
        K::M
        nt::N
        tp::P
    end
    CR.ispointwise(::Mixed) = true
    function CR.forward(m::Mixed, ::CR.Step, v, s, t, k)
        w = m.D.diag[k] + m.K[k, k] + m.nt.a + m.tp[1] + m.tp[2][k]
        return v * w, s + 0.1 * v
    end
    m = Mixed(
        Diagonal([0.2, 0.3]), sparse([0.1 0.0; 0.0 0.2]), (; a = 0.05),
        (0.1, [0.01, 0.02])
    )
    @test !CR._scalar_params(m)
    r = CR.Recurrence([0.3, 0.2]; coupling = [0.9 0.1; 0.1 0.9], modifiers = (m,))
    @test pullback_matches(r, recargs(1.1, nothing, ones(2, 2); stop = 6)...)
    # Without a mirror only the value and state cotangents come back.
    grads = (; piece = nothing, v = 0.3, s = 0.7)
    J = ForwardDiff.jacobian(x -> collect(CR.forward(m, CR.Step(), x[1], x[2], 1, 2)), [2.0, 1.0])
    @test collect(CR._step_pullback(grads, m, 2.0, 1.0, 1, 2)) ≈ transpose(J) * [0.3, 0.7]

    # Scalar parameters inside a named tuple and a tuple take the dual-number
    # path.
    struct Nested{N, P}
        nt::N
        tp::P
    end
    CR.ispointwise(::Nested) = true
    function CR.forward(m::Nested, ::CR.Step, v, s, t, k)
        return v * (m.nt.a + m.nt.b * m.tp[2]), s + m.tp[1] * v
    end
    n = Nested((; a = 0.5, b = 0.25), (0.1, 2))
    @test CR._scalar_params(n)
    @test CR._param_tuple(n) == (0.5, 0.25, 0.1)
    r = CR.Recurrence([0.3, 0.2]; modifiers = (n,))
    @test pullback_matches(r, recargs(1.1, nothing, [1.0, 2.0]; stop = 6)...)
end

@testitem "Adjoint: a modifier with array parameters and no pullback takes plain AD" setup = [AdjointCheck] begin
    using ComposableRecurrences
    # Its local step was slower than plain AD on one reverse backend, so a
    # pointwise modifier whose parameter is a `PerStratum` or `TimeVarying`
    # sends the operator to plain AD.
    struct Cap{K}
        κ::K
    end
    CR.ispointwise(::Cap) = true
    function CR.forward(m::Cap, ::CR.Step, v, s, t, k)
        κ = CR.param(m.κ, k, t)
        return v * κ / (κ + v), s
    end
    for m in (Cap(PerStratum([5.0, 6.0])), Cap(TimeVarying(fill(4.0, 8))))
        @test CR._modifier_adjoint(m) === :none
        r = Recurrence([0.3, 0.2]; modifiers = (m,))
        @test !CR.uses_adjoint(r, CR.Run())
        @test CR._rebuilds(@inferred Recurrence([0.3, 0.2], I, (m,))) === Val(true)
    end
    @test CR._modifier_adjoint(Cap(5.0)) === :local
end

@testitem "Adjoint: local coupling pullback" setup = [AdjointCheck] begin
    using ComposableRecurrences
    # A coupling without a pullback: a share `a` of every other stratum's
    # pressure goes to the first, scaled by `c`.
    struct ToFirst{A, C}
        a::A
        c::C
        n::Int
    end
    function CR.forward(C::ToFirst, ::CR.Pressure, q, p, t)
        tot = sum(view(p, 2:length(p)))
        q[1] = C.c * (p[1] + C.a * tot)
        for k in 2:length(p)
            q[k] = C.c * (1 - C.a) * p[k] + C.n * t * 1.0e-3
        end
        return nothing
    end
    C = ToFirst(0.3, 0.9f0, 2)
    @test CR._coupling_adjoint(C) === :local
    @test CR._param_tuple(C) == (0.3, 0.9f0)
    # One pass of 4, 8 or 12 partials, and more than one when called
    # directly with more inputs.
    rng = Xoshiro(5)
    for S in (2, 6, 10, 30)
        p, q̄ = randn(rng, S), randn(rng, S)
        function pressure(x)
            q = zeros(eltype(x), S)
            CR.forward(ToFirst(x[S + 1], x[S + 2], 2), CR.Pressure(), q, x[1:S], 4)
            return sum(q̄ .* q)
        end
        ref = ForwardDiff.gradient(pressure, [p; 0.3; Float64(0.9f0)])
        p̄, C̄ = fill(1.0, S), (; a = Ref(0.0), c = Ref(0.0f0), n = nothing)
        CR._pressure_back!(p̄, C̄, C, q̄, p, 4)
        @test p̄ ≈ 1 .+ ref[1:S]
        @test [C̄.a[], C̄.c[]] ≈ ref[(S + 1):end] rtol = 1.0e-6
        # Without a mirror only `p̄` comes back.
        p̄ = zeros(S)
        CR._pressure_back!(p̄, nothing, C, q̄, p, 4)
        @test p̄ ≈ ref[1:S]
    end
    # Through a recurrence the rule matches ForwardDiff.
    r = Recurrence([0.3, 0.2]; coupling = C)
    @test pullback_matches(r, recargs(ones(3, 6), nothing, ones(3, 2))...; rtol = 1.0e-6)
    # The route: the rule from the types, and plain AD once the strata and
    # the coupling's scalars outgrow one pass.
    @test CR.uses_adjoint(r, CR.Run())
    @test CR._rebuilds(@inferred Recurrence([0.3], C, ())) === true
    args(S) = recargs(ones(S, 4), nothing, ones(S, 2))
    val(op, S) = Base.return_types(CR._route_val, typeof.((op, args(S)...)))
    @test val(r, 3) == [Val{:rule}]
    @test CR._fits(r, args(10)...) === true
    @test CR._fits(r, args(11)...) === false
    @test CR._fits(Recurrence([0.3]), args(50)...) === Val(true)
    @test occursin("ToFirst", CR._plain_why(r))
    @test CR._plain_why(Recurrence([0.3])) == CR._ADJOINT_NOTE
    y = @test_logs CR.adjoint_call(r, args(11)...)
    @test y ≈ CR._plain(r, args(11)...)
    # A coupling with no float parameters keeps the rule at any size.
    struct Swap end
    CR.forward(::Swap, ::CR.Pressure, q, p, t) = (q .= reverse(p); nothing)
    @test CR._rebuilds(Recurrence([0.3], Swap(), ())) === Val(true)
    @test pullback_matches(
        Recurrence([0.3, 0.2]; coupling = Swap()), args(3)...
    )
    # A coupling whose constructor changes its argument takes plain AD.
    struct Halved{A}
        a::A
        Halved(a::A) where {A} = new{A}(a / 2)
    end
    CR.forward(C::Halved, ::CR.Pressure, q, p, t) = (q .= C.a .* p; nothing)
    op = Recurrence([0.3]; coupling = Halved(0.5))
    @test op.rebuilds === false
    @test occursin("Halved", CR._plain_why(op))
end

@testitem "Recurrence: a Pairwise kernel must be strata × strata × lags" begin
    using ComposableRecurrences
    @test_throws ArgumentError Recurrence(Pairwise(ones(2, 2)))
end
