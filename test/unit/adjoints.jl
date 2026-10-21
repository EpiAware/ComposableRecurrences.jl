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

    # One tag and a fixed chunk for every reference gradient, so the dual
    # code compiled for one check is reused by the others, in this item and
    # in the other items of the same worker, whatever their operator or
    # number of parameters. The tag is a package function, as a type defined
    # here would be new in each item.
    function _gradient_config(f, θ)
        chunk = ForwardDiff.Chunk{min(8, length(θ))}()
        tag = ForwardDiff.Tag(CR._run_forward, eltype(θ))
        return ForwardDiff.GradientConfig(f, θ, chunk, tag)
    end
    # `pullback!` of `op` at `args` against ForwardDiff, over every float
    # leaf of `(op, args...)`.
    function pullback_matches(op, args...; rng = Xoshiro(1), rtol = 1.0e-8)
        xs = (op, args...)
        y, cache = CR._run_forward(xs...)
        ȳ = randlike(rng, y)
        θ = CR._params(xs)
        f = θ -> dotall(ȳ, first(CR._run_forward(CR._rebuild(xs, θ)...)))
        ref = ForwardDiff.gradient(f, θ, _gradient_config(f, θ), Val(false))
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
    CR.forward!(m::PoolDepletion, ::CR.Init, s, history) = (s .= m.pop; nothing)
    function CR.forward!(m::PoolDepletion, ::CR.Step, v, s, t)
        for k in eachindex(v, s)
            v′ = max(s[k] / m.pop[k], 1.0e-6) * v[k]
            v[k], s[k] = v′, s[k] - v′
        end
        return nothing
    end

    # Hazard depletion with a scalar pool and hand-written pullbacks.
    struct Hazard{T}
        N::T
    end
    CR.ispointwise(::Hazard) = true
    CR.uses_adjoint(::Hazard, ::CR.Step) = true
    CR.forward!(m::Hazard, ::CR.Init, s, history) = (fill!(s, m.N); nothing)
    function CR.forward!(m::Hazard, ::CR.Step, v, s, t)
        for k in eachindex(v, s)
            x = v[k] / m.N
            v[k], s[k] = -s[k] * expm1(-x), s[k] * exp(-x)
        end
        return nothing
    end
    function CR.pullback!(grads, m::Hazard, ::CR.Step, v, s, t)
        for k in eachindex(v, s)
            v̄, s̄ = grads.v[k], grads.s[k]
            x = v[k] / m.N
            e = exp(-x)
            x̄ = s[k] * e * (v̄ - s̄)
            CR.add_cotangent!(CR.cotangent(grads.piece, :N), -x̄ * x / m.N)
            grads.v[k], grads.s[k] = x̄ / m.N, -v̄ * expm1(-x) + s̄ * e
        end
        return nothing
    end
    function CR.pullback!(grads, m::Hazard, ::CR.Init, s, history)
        CR.add_cotangent!(CR.cotangent(grads.piece, :N), sum(grads.s))
        return nothing
    end

    # Vector-level with a scalar parameter and no pullback.
    struct Scale{A}
        a::A
    end
    function CR.forward!(m::Scale, ::CR.Step, v, s, t)
        v .*= m.a
        s .+= v
        return nothing
    end

    # Vector-level, mapping each value through a function held in a field.
    # A closure that captures a float hides it from the local derivative.
    struct Mapped{F}
        f::F
    end
    function CR.forward!(m::Mapped, ::CR.Step, v, s, t)
        v .= m.f.(v)
        return nothing
    end
    halved = let c = 0.5
        x -> c * x
    end

    # Pointwise and time-varying: add `b[t]` (absolute time).
    struct Shift{B}
        b::B
    end
    CR.ispointwise(::Shift) = true
    function CR.forward!(m::Shift, ::CR.Step, v, s, t)
        for k in eachindex(v, s)
            v[k] += m.b[t]
        end
        return nothing
    end

    # Adds a tenth of each stratum's history total, set once by its Init.
    struct HistoryTotal end
    CR.ispointwise(::HistoryTotal) = true
    function CR.forward!(::HistoryTotal, ::CR.Init, s, history)
        s .= vec(sum(history; dims = ndims(history)))
        return nothing
    end
    function CR.forward!(::HistoryTotal, ::CR.Step, v, s, t)
        for k in eachindex(v, s)
            v[k] += 0.1 * s[k]
        end
        return nothing
    end

    # Pointwise, calling ForwardDiff itself: `v′ = d/dx (a x²) at v`.
    struct Slope{A}
        a::A
    end
    CR.ispointwise(::Slope) = true
    function CR.forward!(m::Slope, ::CR.Step, v, s, t)
        for k in eachindex(v, s)
            v[k] = ForwardDiff.derivative(x -> m.a * x^2, v[k])
        end
        return nothing
    end

    # A coupling with no pullback: `q = β ⊙ (K p)`.
    struct Mix{M, V}
        K::M
        β::V
    end
    CR.forward!(C::Mix, ::CR.Pressure, q, p, t) = (q .= C.β .* (C.K * p); nothing)
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
    # Import patterns: dense and sparse, and one that varies over time. The
    # spill kernel has a nonzero diagonal, which the movement leaves out.
    prng = Xoshiro(7)
    P = rand(prng, S, S)
    PT = 0.5 .+ rand(prng, S, S, T)
    Ks = rand(prng, S, S) ./ 2 + 0.3I
    Ms = CR.movement(Ks, [0.3, 0.2, 0.1])
    spill = CR.Redistribute(Ms)
    sparse_spill = CR.Redistribute(sparse(Ms))
    for mods in (
            (PoolDepletion([30.0, 40.0, 50.0]),),
            (Hazard(45.0),),
            (Shift(randn(rng, T)), HistoryTotal()),
            (Shift(randn(rng, T)), Hazard(60.0)),
            (Slope(0.3),),
            (CR.Depletion(PerStratum([40.0, 50.0, 60.0])),),
            (CR.Depletion(50.0; form = CR.Floor(), heterogeneity = 1.5),),
            (CR.Redistribute(CR.movement(K, [0.3, 0.2, 0.1])), CR.Add(PerStratum([0.1, 0.2, 0.3]))),
            (CR.Clamp(0.0, 3.0),),
            (CR.Allocate([[1, 3], [2]], TimeVarying(PerStratum(4 .+ rand(rng, 2, T)))),),
            (CR.Allocate([1:3], 5.0), CR.Add(0.2)),
            (CR.Allocate([[1, 3], [2]], 4.0; imports = (0.3, P), spill),),
            (
                CR.Allocate(
                    [[1, 3], [2]], 4.0; imports = (0.3, P), spill = sparse_spill
                ),
            ),
            (
                CR.Allocate(
                    [[1, 3], [2]], PerStratum([4.0, 2.0]);
                    imports = (PerStratum([0.2, 0.4]), sparse(P)), spill
                ),
            ),
            (
                CR.Allocate([[1, 3], [2]], 4.0; imports = (0.3, TimeVarying(PT))),
                CR.Add(0.2),
            ),
            (
                CR.Depletion(
                    1.5; pools = (:O,), form = CR.SoftTruncate(0.1), fill = :O,
                    flows_first = true, flows = CR.Flow(:O => 0, 0.3; form = CR.Share()),
                    overflow = :queue
                ),
            ),
            (
                CR.Depletion(;
                    pools = (B = PerStratum([0.5, 0.0, 1.0]),), form = CR.Truncate(),
                    flows_first = true, overflow = :queue,
                    flows = CR.Flow(
                        0 => :B, TimeVarying(repeat([1.2, 0.0, 0.0], T));
                        form = CR.Truncate()
                    )
                ),
                CR.Add(0.2),
            ),
            (
                CR.Depletion(30.0; form = CR.Truncate()),
                CR.Depletion(;
                    pools = (:B,), form = CR.Truncate(), flows_first = true,
                    flows = CR.Flow(
                        0 => :B, TimeVarying(repeat([1.2, 0.0], T)); form = CR.Truncate()
                    )
                ),
            ),
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
    # Beds with the overflow in a second stratum, resumed.
    beds = CR.Depletion(
        2.0; pools = (:O,), form = CR.Truncate(), fill = :O, flows_first = true,
        flows = CR.Flow(:O => 0, 0.2; form = CR.Share()), overflow = :stratum
    )
    r = Recurrence(g; coupling = K[1:2, 1:2], modifiers = (beds,))
    @test pullback_matches(r, recargs(R[1:2, :], nothing, h[1:2, :]; states = ([1.0],))...)
end

@testitem "Adjoint: Allocate imports read the record and batch the same" setup = [
    AdjointCheck,
] begin
    using ComposableRecurrences
    using Base.ScopedValues: with
    rng = Xoshiro(21)
    S, L, T = 5, 3, 9
    groups = [1:2, 3:5]
    P = rand(rng, S, S)
    K = rand(rng, S, S) ./ 2 + 0.2I
    M = CR.movement(K, fill(0.2, S))
    imports = (PerStratum([0.3, 0.5]), P)
    m = CR.Allocate(groups, PerStratum([6.0, 4.0]); imports, spill = CR.Redistribute(M))
    # One step: the pullback given the state after the step, and given a
    # per-pass buffer finished by `_finish_pass!`, matches the one that
    # computes everything again.
    v = 0.5 .+ rand(rng, S)
    s = zeros(2S)
    after = copy(s)
    CR.forward!(m, CR.Step(), copy(v), after, 3)
    v̄0, s̄0 = randn(rng, S), randn(rng, 2S)
    function step_back(extra)
        m̄ = zero_mirror(m)
        grads = (; piece = m̄, v = copy(v̄0), s = copy(s̄0), extra(m̄)...)
        CR.pullback!(grads, m, CR.Step(), v, s, 3)
        b = get(grads, :buffer, nothing)
        b === nothing || CR._finish_pass!(m̄, m, (; V = reshape(v, :, 1)), b, 3)
        return vcat(grads.v, grads.s, mirror_vec(m̄, m))
    end
    plain = step_back(m̄ -> (;))
    @test step_back(m̄ -> (; after, pass = nothing)) ≈ plain rtol = 1.0e-12
    batched = step_back() do m̄
        b = @inferred CR._pass_buffer(v, Float64, m, m̄, S, 1)
        @test b.hb isa Matrix && b.vc isa Matrix
        return (; after, pass = CR._column(b, 1), buffer = b)
    end
    @test batched ≈ plain rtol = 1.0e-12
    # A pattern mirror of the wrong size throws.
    m̄ = zero_mirror(m)
    bad = merge(m̄, (; imports = merge(m̄.imports, (; pattern = zeros(S, S + 1)))))
    @test_throws DimensionMismatch CR._pass_buffer(v, Float64, m, bad, S, 1)
    # Over a whole pass, threaded blocks give the same cotangents as serial.
    g = rand(rng, L) ./ 2
    h = 1 .+ rand(rng, S, L)
    R = 0.5 .+ rand(rng, S, T)
    for spill in (CR.Redistribute(M), nothing)
        r = Recurrence(
            g; coupling = rand(rng, S, S) ./ 4,
            modifiers = (CR.Allocate(groups, 6.0; imports, spill), CR.Add(0.1))
        )
        xs = (r, recargs(R, nothing, h)...)
        function cotangents()
            y, cache = CR._run_forward(xs...)
            ms = zero_mirror(xs)
            ȳ = randlike(Xoshiro(3), y)
            CR._run_pullback!((; piece = first(ms), y = ȳ, args = Base.tail(ms)), r, cache)
            return mirror_vec(ms, xs)
        end
        serial = with(cotangents, CR.EXECUTOR => CR.Serial())
        for ex in (CR.Threaded(; min_work = 0, ntasks = 2), CR.Threaded(; min_work = 0))
            @test with(cotangents, CR.EXECUTOR => ex) == serial
        end
        @test pullback_matches(r, recargs(R, nothing, h)...)
    end
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
    mods = (CR.Depletion(PerStratum(fill(60.0, S)); form = CR.Floor()), CR.Add(0.2))
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

@testitem "Adjoint: threaded reverse pass with outputs read and routes" setup = [AdjointCheck] begin
    using ComposableRecurrences
    using Base.ScopedValues: with
    rng = Xoshiro(18)
    S, L, T, W = 4, 3, 9, 5
    g = rand(rng, L) ./ 2
    K = rand(rng, S, S) ./ 4
    h = 1 .+ rand(rng, S, W)
    R = 0.5 .+ rand(rng, S, T)
    w = rand(rng, W)
    # Each stratum reads its own outputs, so the strata split; a coupled
    # read mixes the strata, so its reverse pass runs serially.
    own = (CR.Add(-0.01 * Recent(w)), CR.Clamp(0.0, 10.0 - Recent(3)))
    across = (CR.Transform(*, Derived(exp, -0.05 * Recent(w; coupling = K))),)
    ops = (
        (Recurrence(g; modifiers = own), true),
        (Recurrence(g; coupling = K, modifiers = own), true),
        (Recurrence(g; modifiers = across), false),
        (Recurrence(Routes((K, g), (0.5I, rand(rng, 2)))), true),
    )
    ex = CR.Threaded(; min_work = 0, ntasks = 2)
    with(CR.EXECUTOR => ex) do
        for (r, splits) in ops
            n = CR._SPLIT_BLOCKS[]
            @test pullback_matches(r, recargs(R, nothing, h)...)
            @test (CR._SPLIT_BLOCKS[] > n) == splits
        end
    end
end

@testitem "Adjoint: Convolution reverse pass in threaded blocks" setup = [AdjointCheck] begin
    using ComposableRecurrences
    using Base.ScopedValues: with
    rng = Xoshiro(17)
    S, D, T = 5, 4, 9
    X = rand(rng, S, T)
    ex = CR.Threaded(; min_work = 0, ntasks = 2)
    with(CR.EXECUTOR => ex) do
        for c in (
                Convolution(rand(rng, D)), Convolution(PerStratum(rand(rng, S, D))),
                Convolution(TimeVarying(rand(rng, D, T))),
            )
            splits = CR._SPLIT_BLOCKS[]
            @test pullback_matches(c, X, true, nothing, rand(rng, S, 2), 1, nothing)
            @test CR._SPLIT_BLOCKS[] > splits
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
    @test all(CR._stateless, (CR.Add(0.1), CR.Clamp(0.0, 1.0), CR.Allocate([1:3], 1.0)))
    @test CR._stateless(CR.Transform(exp))
    @test !CR._stateless(CR.Depletion(50.0))
    # A resumed stateless modifier reads the state it was given.
    r = Recurrence([0.4, 0.3]; modifiers = (CR.Add(0.1),))
    @test pullback_matches(r, recargs(R, nothing, h; states = ([0.5, 1.0, 2.0],))...)
end

@testitem "Adjoint: a Depletion's group step and draw against ForwardDiff" setup = [
    ReferenceAD,
    AdjointCheck,
] begin
    using ComposableRecurrences
    using LinearAlgebra: dot
    # Each kind's group step and draw, with their pullbacks called
    # directly, against forward mode: flows only, a draw out of one pool or
    # several, and a draw into a pool with each overflow. `v` and `s` are a
    # group's values and state, `t` a step and `g` the group.
    rng = Xoshiro(5)
    t, g = 3, 1
    ward = CR.Depletion(; pools = (:A, :B), form = nothing, flows = CR.Flow(1 => 2, 0.3))
    out_of(form) = CR.Depletion(
        5.0; pools = (:S, :V), form = form, weights = (S = 1, V = 0.4),
        flows = CR.Flow(:S => :V, 0.1)
    )
    into(overflow) = CR.Depletion(
        2.0; pools = (:O,), form = CR.Truncate(), fill = :O, flows_first = true,
        flows = CR.Flow(:O => 0, 0.2; form = CR.Share()), overflow
    )
    cases = (
        (ward, (1.5, 0.5), (0.0, 0.0)),
        (CR.Depletion(5.0; form = CR.Floor()), (1.3,), (4.0,)),
        (out_of(CR.Hazard()), (1.3,), (3.0, 1.0)),
        (into(nothing), (1.3,), (0.5,)),
        (into(:stratum), (1.3, 0.2), (0.5,)),
        (into(:queue), (1.3,), (0.5, 0.4)),
    )
    for (m, v, s) in cases
        n = CR._npools(m)
        θ = CR._params((m,))
        nv, ns = length(v), length(s)
        out, s′ = CR._block_step(m, v, s, t, g)
        # The public in-place step, on one-entry vectors, writes the same.
        vr, sr = map(x -> [x], v), map(x -> [x], s)
        @test CR.forward!(m, CR.Step(), vr, sr, t, g) === nothing
        @test map(only, vr) == out && map(only, sr) == s′
        v̄, s̄ = Tuple(randn(rng, length(out))), Tuple(randn(rng, length(s′)))
        function step(z)
            p = only(CR._rebuild((m,), z[(nv + ns + 1):end]))
            o, q = CR._block_step(
                p, Tuple(z[1:nv]), Tuple(z[(nv + 1):(nv + ns)]), t, g
            )
            return dot(collect(v̄), collect(o)) + dot(collect(s̄), collect(q))
        end
        ref = ReferenceAD.gradient(step, [v..., s..., θ...])
        # The step's in-place pullback on one-entry vectors, its kernel, and
        # the dispatch on the draw the kernel goes through.
        function inplace(m̄, grads)
            gv, gs = map(x -> [x], grads.v), map(x -> [x], grads.s)
            vr, sr = map(x -> [x], v), map(x -> [x], s)
            gg = (; piece = m̄, v = gv, s = gs)
            @test CR.pullback!(gg, m, CR.Step(), vr, sr, t, g) === nothing
            return map(only, gv), map(only, gs)
        end
        for back in (
                inplace,
                (m̄, grads) -> CR._block_back(grads, m, v, s, t, g),
                (m̄, grads) -> CR._group_pullback(m.draw, grads, m, v, s, t, g),
            )
            m̄ = zero_mirror(m)
            v̄in, s̄in = back(m̄, (; piece = m̄, v = v̄, s = s̄))
            @test [v̄in..., s̄in..., mirror_vec(m̄, m)...] ≈ ref rtol = 1.0e-10
        end
        CR._draws(m) || continue
        # The draw alone, from the demand `d` and the pools `x`.
        d, x = first(v), Tuple(s[1:n])
        y, x′ = CR._take(m.draw, m, d, x, t, g)
        ȳ, x̄′ = randn(rng), Tuple(randn(rng, n))
        function draw(z)
            p = only(CR._rebuild((m,), z[(n + 2):end]))
            a, b = CR._take(p.draw, p, z[1], Tuple(z[2:(n + 1)]), t, g)
            return ȳ * a + dot(collect(x̄′), collect(b))
        end
        ref = ReferenceAD.gradient(draw, [d, x..., θ...])
        m̄ = zero_mirror(m)
        d̄, x̄ = CR._take_back(m.draw, m̄, m, d, x, y, ȳ, x̄′, t, g)
        @test [d̄, x̄..., mirror_vec(m̄, m)...] ≈ ref rtol = 1.0e-10
    end
    # The queue's cotangent is the state's last entry; the pools' are the
    # rest.
    @test CR._left_back(CR._Queue(), (1.0,), (2.0, 3.0, 4.0), Val(2)) ==
        (4.0, (2.0, 3.0))
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
            CR.Depletion(TimeVarying(N[1, :]); form = CR.Floor(), pools = (S = 30.0,)),
            CR.Depletion(TimeVarying(PerStratum(N)); removals = births),
            CR.Depletion(Derived(+, PerStratum([30.0, 40.0]), TimeVarying(N[1, :]))),
            CR.Depletion(
                TimeVarying(PerStratum(N)); pools = (S = nothing, V = 5.0),
                weights = (S = 1, V = 0.3),
                flows = (CR.Flow(1 => 2, births; form = CR.Truncate()),)
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

@testitem "Adjoint: a prepended call" setup = [AdjointCheck] begin
    using ComposableRecurrences
    rng = Xoshiro(8)
    S, L, T = 2, 3, 6
    g = rand(rng, L) ./ 2
    # A single series and strata, seeded at times 1 to `L` or before time 1,
    # with the output, its state and its trace in turn.
    pop = PerStratum([40.0, 60.0])
    for (h, R, d) in (
                (1 .+ rand(rng, L), 0.5 .+ rand(rng, L + T), CR.Depletion(50.0)),
                (1 .+ rand(rng, S, L), 0.5 .+ rand(rng, S, L + T), CR.Depletion(pop)),
            ), start in (1, L + 1)
        r = Recurrence(g; modifiers = (d,))
        for op in (r, CR._WithState(r), CR._WithTrace(r), CR._WithTrace(CR._WithState(r)))
            @test pullback_matches(CR._Prepended(op), recargs(R, nothing, h; start)...)
        end
    end
    # A history of counts takes no cotangent.
    r = Recurrence(g; modifiers = (CR.Depletion(50.0),))
    args = recargs(0.5 .+ rand(rng, L + T), nothing, [2, 1, 3]; start = L + 1)
    @test pullback_matches(CR._Prepended(CR._WithTrace(r)), args...)
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

@testitem "Adjoint: routing by uses_adjoint" setup = [ReferenceAD, AdjointCheck, AdjointModifiers] begin
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
    # A coupling, a pointwise modifier or a vector-level modifier without a
    # pullback, whose floats sit in scalars or arrays, takes the rule with a
    # local derivative.
    for op in (
            Recurrence(g; coupling = Mix(K, [1.0, 1.0])),
            Recurrence(g; modifiers = (PoolDepletion([30.0, 40.0]),)),
            Recurrence(g; modifiers = (Scale(0.9),)),
        )
        @test CR.uses_adjoint(op, CR.Run())
        @test pullback_matches(op, recargs(ones(2, 4), nothing, ones(2, 2))...)
    end
    # A modifier whose floats sit in a closure, or a part whose floats sit
    # in arrays of arrays, sends the whole operator to plain AD.
    struct NestedPool
        pop::Vector{Vector{Float64}}
    end
    CR.ispointwise(::NestedPool) = true
    function CR.forward!(m::NestedPool, ::CR.Step, v, s, t)
        for k in eachindex(v, s)
            v[k] *= m.pop[k][1]
        end
        return nothing
    end
    struct NestedMix
        K::Vector{Vector{Float64}}
    end
    function CR.forward!(C::NestedMix, ::CR.Pressure, q, p, t)
        for i in eachindex(q)
            q[i] = sum(C.K[i] .* p)
        end
        return nothing
    end
    nested = [[0.5, 0.1], [0.2, 0.4]]
    for op in (
            Recurrence(g; modifiers = (Mapped(halved),)),
            Recurrence(g; coupling = NestedMix(nested)),
            Recurrence(g; modifiers = (NestedPool([[30.0], [40.0]]),)),
        )
        @test !CR.uses_adjoint(op, CR.Run())
        @test val(op) == [Val{:plain}]
    end
    # The constructor notes, once per message, the part that sends the
    # operator there.
    note(; kwargs...) = (empty!(CR._PLAIN_NOTED); Recurrence(g; kwargs...))
    @test_logs (:info, r"Mapped has no pullback!") note(modifiers = (Mapped(halved),))
    @test_logs Recurrence(g; modifiers = (Mapped(halved),))
    # The note is once per message, so other number types log nothing more.
    dual_halved = let c = ForwardDiff.Dual(0.5, 1.0)
        x -> c * x
    end
    @test_logs Recurrence(g; modifiers = (Mapped(dual_halved),))
    @test_logs (:info, r"NestedMix has no pullback!") note(
        coupling = NestedMix(nested)
    )
    @test_logs (:info, r"NestedPool has no pullback!") note(
        modifiers = (CR.Clamp(0.0, 9.0), NestedPool([[30.0], [40.0]]))
    )
    @test_logs note(coupling = Mix(K, [1.0, 1.0]))
    @test_logs note(modifiers = (CR.Clamp(0.0, 9.0),))
    # A `Derived` map that holds floats is named as the cause.
    scaled = let c = 2.0
        x -> c * x
    end
    @test_logs (:info, r"Add has a Derived map that holds floats") note(
        modifiers = (CR.Add(Derived(scaled, 0.5)),)
    )
    @test_logs (:info, r"Depletion has a Derived map that holds floats") note(
        modifiers = (CR.Depletion(Derived(scaled, 25.0)),)
    )
    # A depletion is named by its form when the form has no adjoint.
    struct VecForm
        w::Vector{Float64}
    end
    function CR.forward!(f::VecForm, ::CR.Step, v, s, N, α)
        for i in eachindex(v, s)
            y = min(v[i] * f.w[1], s[i])
            v[i], s[i] = y, s[i] - y
        end
        return nothing
    end
    @test CR._part_why(CR.Depletion(50.0; form = VecForm([1.0]))) ==
        "VecForm has no pullback! the rule can use"
    # Roles the rule does not call pass the adjoint check.
    @test CR._adjoint_found(CR.Clamp(0.0, 1.0), CR.Init())
    # A `pullback!` method opts a modifier in, and declaring `uses_adjoint`
    # overrides it.
    struct Scaled{A}
        a::A
    end
    CR.forward!(m::Scaled, ::CR.Step, v, s, t) = (v .*= m.a; nothing)
    rs = Recurrence(g; modifiers = (Scaled(0.5),))
    @test CR._modifier_adjoint(Scaled(0.5)) === :local
    CR.pullback!(grads, m::Scaled, ::CR.Step, v, s, t) = (grads.v .*= m.a; nothing)
    @test CR.uses_adjoint(Scaled(0.5), CR.Step())
    # Only the roles an operator's rule calls are derived.
    @test !CR._has_pullback(Scaled(0.5), CR.Init())
    @test CR.uses_adjoint(rs, CR.Run())
    @test val(rs) == [Val{:rule}]
    # Declared without, the step takes the local derivative again.
    CR.uses_adjoint(::Scaled, ::CR.Step) = false
    @test CR._modifier_adjoint(Scaled(0.5)) === :local
    # A pointwise step's `pullback!` whose value is typed as a vector is not
    # found by the method lookup, so the step takes the local derivative;
    # declaring it opts in.
    struct Typed{A}
        a::A
    end
    CR.ispointwise(::Typed) = true
    function CR.forward!(m::Typed, ::CR.Step, v, s, t)
        for k in eachindex(v, s)
            v[k] *= m.a
        end
        return nothing
    end
    function CR.pullback!(grads, m::Typed, ::CR.Step, v::AbstractVector, s, t)
        for k in eachindex(v, s)
            CR.add_cotangent!(CR.cotangent(grads.piece, :a), grads.v[k] * v[k])
            grads.v[k] *= m.a
        end
        return nothing
    end
    rt = Recurrence(g; modifiers = (Typed(0.5),))
    @test CR._modifier_adjoint(Typed(0.5)) === :local
    CR.uses_adjoint(::Typed, ::CR.Step) = true
    @test CR._modifier_adjoint(Typed(0.5)) === :pullback
    @test pullback_matches(rt, recargs(ones(2, 4), nothing, ones(2, 2))...)
    # The same for a step that is not pointwise: the declared adjoint calls
    # the typed `pullback!`.
    struct TypedVec{A}
        a::A
    end
    CR.forward!(m::TypedVec, ::CR.Step, v, s, t) = (v .*= m.a; nothing)
    function CR.pullback!(grads, m::TypedVec, ::CR.Step, v::AbstractVector, s, t)
        CR.add_cotangent!(CR.cotangent(grads.piece, :a), sum(grads.v .* v))
        grads.v .*= m.a
        return nothing
    end
    @test CR._modifier_adjoint(TypedVec(0.5)) === :local
    CR.uses_adjoint(::TypedVec, ::CR.Step) = true
    @test CR._modifier_adjoint(TypedVec(0.5)) === :pullback
    rv = Recurrence(g; modifiers = (TypedVec(0.5),))
    @test pullback_matches(rv, recargs(ones(2, 4), nothing, ones(2, 2))...)

    # A function stored in a pointwise modifier with no pullback: a plain
    # function or a callable singleton keeps the rule, a closure that
    # captures a float takes plain AD, as the local derivative does not reach
    # its captured value.
    struct MapBy{F, T}
        f::F
        a::T
    end
    CR.ispointwise(::MapBy) = true
    function CR.forward!(m::MapBy, ::CR.Step, v, s, t)
        for k in eachindex(v, s)
            v[k] = m.a * m.f(v[k])
        end
        return nothing
    end
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
    function CR.forward!(m::Pick, ::CR.Step, v, s, t)
        for k in eachindex(v, s)
            v[k] = k in m.idx ? m.a * v[k] : v[k]
        end
        return nothing
    end
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
        @eval function CR.forward!(m::$M, ::CR.Step, v, s, t)
            for k in eachindex(v, s)
                v[k] = m.a * v[k]
            end
            return nothing
        end
    end
    for (m, rule) in (
            (ScaleKw(; a = 0.5), false), (ScaleF(0.5), false),
            (Doubled(0.5), false), (Kept(0.5), true),
        )
        empty!(CR._PLAIN_NOTED)
        op = rule ? Recurrence(g; modifiers = (m,)) :
            @test_logs (:info, Regex(string(nameof(typeof(m))))) Recurrence(g; modifiers = (m,))
        @test CR._modifier_adjoint(m) === :local
        @test CR._check_rebuild(m) == rule
        @test op.rebuilds === rule
        @test CR.uses_adjoint(op, CR.Run()) == rule
        @test val(op) == [Val{:rule}]
        @test CR._fit(op, args...) === (rule ? :one : :none)
        # The check runs at construction, which stays type stable.
        @inferred Recurrence(g, I, (m,))
    end
    # A modifier that does not rebuild is sent to plain AD, and the call
    # logs nothing.
    op = Recurrence(g; modifiers = (Doubled(0.5),))
    y = @test_logs CR.adjoint_call(op, args...)
    @test y == CR._plain(op, args...)
    # Without the check the local derivative of `Doubled` would be wrong,
    # not missing: its rebuild doubles the dual number it is given, so the
    # cotangent of its field `a` comes back twice the true `v`.
    m̄ = (; a = Ref(0.0))
    CR._step_pullback((; piece = m̄, v = 1.0, s = 0.0), Doubled(0.5), 2.0, 0.0, 1, 1)
    @test m̄.a[] ≈ 4.0
    # Without a part to check, the outcome is read off the types.
    for ms in ((), (CR.Depletion(50.0), CR.Clamp(0.0, 9.0)), (CR.Add(1.0),))
        @test (@inferred Recurrence(g, I, ms)).rebuilds === Val(true)
    end
    # A rebuild through `constructorof` checks again.
    op = ConstructionBase.setproperties(op; modifiers = (Kept(0.5),))
    @test op.rebuilds === true
    op = ConstructionBase.setproperties(op; modifiers = (CR.Add(1.0),))
    @test op.rebuilds === Val(true)
    @test pullback_matches(
        Recurrence(g; modifiers = (Kept(0.5),)),
        recargs(ones(2, 4), nothing, ones(2, 2))...
    )
    # A field of abstract type is not differentiated locally.
    struct Loose
        a::Any
    end
    CR.ispointwise(::Loose) = true
    @test CR._modifier_adjoint(Loose(0.5)) === :none
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
    @test CR._check_rebuild(Strict(0.5)) === false
    @test_throws InterruptException CR._check_rebuild(Halt(0.5))

    # A depletion form without a pullback takes the rule through the local
    # derivative of its step in `(v, s, N, α)` and its own float scalars.
    struct LinearRate{T}
        c::T
    end
    function CR.forward!(f::LinearRate, ::CR.Step, v, s, N, α)
        for i in eachindex(v, s)
            y = f.c * v[i] * max(s[i], 0)^α / N
            v[i], s[i] = y, s[i] - y
        end
        return nothing
    end
    f = LinearRate(0.7)
    grads = (; piece = (; c = Ref(0.0)), v = 0.3, s = 0.6)
    got = CR._form_pullback(grads, f, 2.0, 40.0, 50.0, 1.2)
    ref = ReferenceAD.gradient(collect((2.0, 40.0, 50.0, 1.2, 0.7))) do x
        y, s′ = CR._draw(LinearRate(x[5]), x[1], x[2], x[3], x[4])
        return 0.3 * y + 0.6 * s′
    end
    @test [got..., grads.piece.c[]] ≈ ref
    for op in (
            Recurrence(g; modifiers = (CR.Depletion(50.0; form = f, heterogeneity = 1.2),)),
            Recurrence(g; modifiers = (CR.Depletion(50.0; form = f, removals = 0.5),)),
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
    function CR.forward!(f::DoubledRate, ::CR.Step, v, s, N, α)
        return CR.forward!(LinearRate(f.c), CR.Step(), v, s, N, α)
    end
    empty!(CR._PLAIN_NOTED)
    op = @test_logs (:info, r"DoubledRate cannot be rebuilt") Recurrence(
        g; modifiers = (CR.Depletion(50.0; form = DoubledRate(0.7)),)
    )
    @test !CR.uses_adjoint(op, CR.Run())
    @test op.rebuilds === false
    @test CR.uses_adjoint(
        Recurrence(g; modifiers = (CR.Depletion(50.0; form = f),)), CR.Run()
    )

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
    # Declared for a role with no `pullback!` method: the reverse pass
    # throws the `MethodError` of the missing method.
    struct Halved end
    CR.ispointwise(::Halved) = true
    function CR.forward!(::Halved, ::CR.Step, v, s, t)
        for k in eachindex(v, s)
            v[k] /= 2
        end
        return nothing
    end
    CR.uses_adjoint(::Halved, ::CR.Step) = true
    args = recargs(ones(2, 4), nothing, ones(2, 2))
    r = Recurrence([0.3, 0.2]; modifiers = (Halved(),))
    @test Base.return_types(CR._route_val, typeof.((r, args...))) == [Val{:rule}]
    @test_throws MethodError pullback_matches(r, args...)
    struct Thrice <: CR.AbstractOperator end
    CR.forward(::Thrice, ::CR.Run, x) = (3 .* x, nothing)
    CR.uses_adjoint(::Thrice, ::CR.Run) = true
    grads = (; piece = nothing, y = ones(2), args = (zeros(2),))
    @test_throws MethodError CR._run_pullback!(grads, Thrice(), nothing)
end

@testitem "Adjoint: the local step without `ForwardDiff` says to load it" setup = [
    AdjointCheck, AdjointModifiers,
] begin
    using ComposableRecurrences
    # The src methods run when the `ForwardDiff` extension is not loaded:
    # each names the piece and says to load it.
    msg(name) = Regex("^ArgumentError: $name has no `pullback!`.*add `using ForwardDiff`\$")
    m, C = PoolDepletion([40.0, 50.0]), Mix([0.5 0.1; 0.2 0.4], [1.0, 0.9])
    one_arg = Tuple{Any, Vararg{Any}}
    two_args = Tuple{Any, Any, Vararg{Any}}
    @test_throws msg("PoolDepletion") invoke(CR._value_pullback, one_arg, m, 1.0)
    @test_throws msg("PoolDepletion") invoke(CR._jacobian_pullback, two_args, m, nothing)
    @test_throws msg("PoolDepletion") invoke(CR._scalar_pullback, two_args, m, nothing)
    @test_throws msg("PoolDepletion") invoke(CR._read_pullback, two_args, m, nothing)
    @test_throws msg("PoolDepletion") invoke(CR._init_jacobian, one_arg, m, 1.0)
    @test_throws msg("Mix") invoke(CR._array_pressure, one_arg, C, 1.0)
    @test_throws msg("Mix") invoke(
        CR._local_pressure!, Tuple{Any, Any, Any, Vararg{Any}}, nothing, nothing, C
    )
    struct Rate{T}
        c::T
    end
    @test_throws msg("Rate") invoke(CR._local_form_pullback, two_args, nothing, Rate(0.7))
    @test_throws r"^ArgumentError: `Transform` without a `derivative` needs `ForwardDiff`" invoke(
        CR._transform_seeds, Tuple{Vararg{Any}}, 1.0, 2.0
    )
    # The checks and buffers that need dual numbers say nothing, so the
    # constructor stores `nothing` and each call checks.
    @test invoke(CR._check_scalars, one_arg, m, (1.0,)) === nothing
    @test invoke(CR._check_views, one_arg, C) === nothing
    @test invoke(CR._probe_reads, one_arg, m) === nothing
    @test invoke(CR._dual_pressure_buffers, two_args, nothing, C, Float64) === nothing
    @test CR._reads_within(nothing) === nothing
    @test CR._check_rebuilds((m, C)) isa Bool
end

@testitem "Adjoint: an operator built without `ForwardDiff` checks its parts per call" setup = [
    AdjointCheck, AdjointModifiers,
] begin
    using ComposableRecurrences
    # Built before the extension loads, the constructor stores `nothing`;
    # with it loaded, each call checks the parts and takes the same route as
    # an operator checked at construction.
    unchecked(r) = CR.Recurrence(CR._Checked(), r.kernel, r.coupling, r.modifiers, nothing)
    struct Rate{T}
        c::T
    end
    function CR.forward!(f::Rate, ::CR.Step, v, s, N, α)
        for i in eachindex(v, s)
            y = f.c * v[i] * max(s[i], 0)^α / N
            v[i], s[i] = y, s[i] - y
        end
        return nothing
    end
    args = recargs(ones(2, 6), nothing, ones(2, 2))
    for parts in (
            (; modifiers = (PoolDepletion([40.0, 50.0]),)),
            (; coupling = Mix([0.5 0.1; 0.2 0.4], [1.0, 0.9])),
            (; modifiers = (CR.Depletion(50.0; form = Rate(0.7)),)),
        )
        r0 = Recurrence([0.3, 0.2]; parts...)
        r = unchecked(r0)
        @test r0.rebuilds === true
        @test r.rebuilds === nothing
        @test CR.uses_adjoint(r, CR.Run())
        @test Base.return_types(CR._route_val, typeof.((r, args...))) == [Val{:rule}]
        @test Base.return_types(CR._fit, typeof.((r, args...))) == [Symbol]
        @test (@inferred CR._fit(r, args...)) === (@inferred CR._fit(r0, args...))
        @test pullback_matches(r, args...)
        @test r(ones(2, 6); history = ones(2, 2)) == r0(ones(2, 6); history = ones(2, 2))
    end
    # A part the local step cannot rebuild takes plain AD from that call,
    # with the construction's note.
    struct Doubled{T}
        c::T
        Doubled(c::T) where {T} = new{T}(2c)
    end
    CR.ispointwise(::Doubled) = true
    function CR.forward!(m::Doubled, ::CR.Step, v, s, t)
        v .*= m.c
        return nothing
    end
    empty!(CR._PLAIN_NOTED)
    r0 = @test_logs (:info, r"Doubled cannot be rebuilt") Recurrence(
        [0.3, 0.2]; modifiers = (Doubled(0.4),)
    )
    @test r0.rebuilds === false
    r = unchecked(r0)
    empty!(CR._PLAIN_NOTED)
    @test (@test_logs (:info, r"Doubled cannot be rebuilt") CR._fit(r, args...)) === :none
    @test (@inferred CR._fit(r, args...)) === :none
end

@testitem "Adjoint: the plain-AD note logs at construction only" setup = [AdjointModifiers] begin
    using ComposableRecurrences
    # A modifier without an adjoint: the constructor notes the plain path
    # once per type, and calls log nothing.
    empty!(CR._PLAIN_NOTED)
    r = @test_logs (:info, r"Mapped") Recurrence([0.2, 0.3]; modifiers = (Mapped(halved),))
    quartered = let c = 0.25
        x -> c * x
    end
    @test_logs Recurrence([0.2, 0.3]; modifiers = (Mapped(quartered),))
    @test_logs r(ones(4); history = ones(2))
    @test_logs CR.with_state(r, ones(4); history = ones(2))
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

@testitem "Adjoint: scalar-parameter local pullback" setup = [ReferenceAD, AdjointCheck] begin
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
    function CR.forward!(m::Outer, ::CR.Step, v, s, t)
        for k in eachindex(v, s)
            v′ = m.a * max(s[k] / m.inner.N, 1.0e-6) * v[k] * m.inner.k
            v[k], s[k] = v′, s[k] - v′
        end
        return nothing
    end
    m = Outer(0.7f0, Inner(50.0, 2))
    @test CR._scalar_params(m)
    @test CR._param_tuple(m) == (0.7f0, 50.0)
    for (v, s) in ((2.0, 30.0), (1.5, 0.2))
        # Reference: the Jacobian of the step in the value, state and
        # parameters.
        J = ReferenceAD.jacobian([v; s; CR._params(m)]) do x
            v′, s′ = CR._step(CR._rebuild(m, view(x, 3:4)), x[1], x[2], 1, 1)
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
    # Coverage instrumentation allocates, so the count is checked only
    # without it.
    coverage = Base.JLOptions().code_coverage != 0
    steps(m, m̄, 2)
    @test (@allocated steps(m, m̄, 1000)) < 1000 skip = coverage
    steps(m, nothing, 2)
    @test (@allocated steps(m, nothing, 1000)) < 1000 skip = coverage
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
    function CR.forward!(::Capped, ::CR.Init, s, history)
        eltype(history) <: ForwardDiff.Dual && (DUAL_INITS[] += 1)
        s .= sum(history)
        return nothing
    end
    function CR.forward!(m::Capped, ::CR.Step, v, s, t)
        for k in eachindex(v, s)
            v[k] = v[k] * m.κ / (m.κ + v[k])
        end
        return nothing
    end
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

@testitem "Adjoint: coupling pullbacks called directly" setup = [ReferenceAD, AdjointCheck] begin
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
            CR.forward!(rebuild(θ), CR.Pressure(), q, p, 1)
            return sum(q̄ .* q)
        end
        p̄ = zeros(3)
        CR.pullback!((; piece = m̄, q = q̄, p = p̄), C, CR.Pressure(), nothing, p, 1)
        @test p̄ ≈ ReferenceAD.gradient(x -> pressure(θ, x), p)
        @test mirror_vec(m̄, C isa UniformScaling ? (; λ = 2.5) : C) ≈
            ReferenceAD.gradient(x -> pressure(x, p), θ)
    end
end

@testitem "Adjoint: dense coupling pullback with every mirror" setup = [AdjointCheck] begin
    # A dense matrix takes its fast loop for a matrix mirror, a wrapped one
    # or none, and the generic loop for any other mirror; all agree.
    rng = Xoshiro(4)
    C, p, q̄ = randn(rng, 3, 3), randn(rng, 3), randn(rng, 3)
    p̄ref = transpose(C) * q̄
    C̄ref = q̄ * transpose(p)
    for (m̄, read) in (
            (zeros(3, 3), identity), ((; x = zeros(3, 3)), m -> m.x),
            (view(zeros(3, 3), :, :), identity), (nothing, nothing),
        )
        p̄ = zeros(3)
        CR.pullback!((; piece = m̄, q = q̄, p = p̄), C, CR.Pressure(), nothing, p, 1)
        @test p̄ ≈ p̄ref
        read === nothing || @test read(m̄) ≈ C̄ref
    end
    # Mismatched sizes are an error, not a read past the end.
    @test_throws DimensionMismatch CR.pullback!(
        (; piece = zeros(2, 2), q = q̄, p = zeros(3)), C, CR.Pressure(), nothing, p, 1
    )
    @test_throws DimensionMismatch CR.pullback!(
        (; piece = nothing, q = q̄, p = zeros(2)), C, CR.Pressure(), nothing, p, 1
    )
end

@testitem "Adjoint: time-varying dense coupling pullback with every mirror" setup = [AdjointCheck] begin
    # A dense 3-array read at time `t` takes its fast loop for a 3-array
    # mirror, a wrapped one or none, and the generic loop for any other
    # mirror; all agree with the slice's transposed product.
    rng = Xoshiro(5)
    X, p, q̄ = randn(rng, 3, 3, 4), randn(rng, 3), randn(rng, 3)
    C, t = TimeVarying(X), 2
    p̄ref = transpose(X[:, :, t]) * q̄
    X̄ref = q̄ * transpose(p)
    for (m̄, read) in (
            ((; x = zeros(3, 3, 4)), m -> m.x),
            ((; x = (; x = zeros(3, 3, 4))), m -> m.x.x),
            ((; x = view(zeros(3, 3, 4), :, :, :)), m -> m.x),
            ((; x = nothing), nothing), (nothing, nothing),
        )
        p̄ = zeros(3)
        CR.pullback!((; piece = m̄, q = q̄, p = p̄), C, CR.Pressure(), nothing, p, t)
        @test p̄ ≈ p̄ref
        read === nothing || @test read(m̄)[:, :, t] ≈ X̄ref
        read === nothing || @test iszero(read(m̄)[:, :, 1])
    end
    # Mismatched sizes are an error, not a read past the end.
    @test_throws DimensionMismatch CR.pullback!(
        (; piece = (; x = zeros(2, 2, 4)), q = q̄, p = zeros(3)), C, CR.Pressure(),
        nothing, p, t
    )
    @test_throws DimensionMismatch CR.pullback!(
        (; piece = nothing, q = q̄, p = zeros(2)), C, CR.Pressure(), nothing, p, t
    )
    @test_throws BoundsError CR.pullback!(
        (; piece = nothing, q = q̄, p = zeros(3)), C, CR.Pressure(), nothing, p, 5
    )
end

@testitem "Adjoint: local pullback over structured and nested parameters" setup = [ReferenceAD, AdjointCheck] begin
    # The local Jacobian of a pointwise modifier with array parameters: a
    # Diagonal, a sparse matrix, a named tuple and a tuple holding an array,
    # read back in the order the parameters are collected. A step may read
    # the fields of a Diagonal or a sparse matrix, so the operator takes
    # plain AD.
    struct Mixed{D, M, N, P}
        D::D
        K::M
        nt::N
        tp::P
    end
    CR.ispointwise(::Mixed) = true
    function CR.forward!(m::Mixed, ::CR.Step, v, s, t)
        for k in eachindex(v, s)
            w = m.D.diag[k] + m.K[k, k] + m.nt.a + m.tp[1] + m.tp[2][k]
            v[k], s[k] = v[k] * w, s[k] + 0.1 * v[k]
        end
        return nothing
    end
    m = Mixed(
        Diagonal([0.2, 0.3]), sparse([0.1 0.0; 0.0 0.2]), (; a = 0.05),
        (0.1, [0.01, 0.02])
    )
    @test !CR._scalar_params(m)
    @test CR._modifier_adjoint(m) === :none
    r = CR.Recurrence([0.3, 0.2]; coupling = [0.9 0.1; 0.1 0.9], modifiers = (m,))
    @test pullback_matches(r, recargs(1.1, nothing, ones(2, 2); stop = 6)...)
    # Without a mirror only the value and state cotangents come back.
    grads = (; piece = nothing, v = 0.3, s = 0.7)
    J = ReferenceAD.jacobian(x -> collect(CR._step(m, x[1], x[2], 1, 2)), [2.0, 1.0])
    @test collect(CR._step_pullback(grads, m, 2.0, 1.0, 1, 2)) ≈ transpose(J) * [0.3, 0.7]

    # Scalar parameters inside a named tuple and a tuple take the dual-number
    # path.
    struct Nested{N, P}
        nt::N
        tp::P
    end
    CR.ispointwise(::Nested) = true
    function CR.forward!(m::Nested, ::CR.Step, v, s, t)
        for k in eachindex(v, s)
            v[k], s[k] = v[k] * (m.nt.a + m.nt.b * m.tp[2]), s[k] + m.tp[1] * v[k]
        end
        return nothing
    end
    n = Nested((; a = 0.5, b = 0.25), (0.1, 2))
    @test CR._scalar_params(n)
    @test CR._param_tuple(n) == (0.5, 0.25, 0.1)
    r = CR.Recurrence([0.3, 0.2]; modifiers = (n,))
    @test pullback_matches(r, recargs(1.1, nothing, [1.0, 2.0]; stop = 6)...)
end

@testitem "Adjoint: the local step rebuilds floats in fields of abstract type" setup = [AdjointCheck] begin
    using ComposableRecurrences
    # A field without a type parameter may hold a float; the rebuild then
    # reads it by value, so its cotangent is not lost.
    struct Start
        s0
    end
    CR.ispointwise(::Start) = true
    CR.forward!(m::Start, ::CR.Init, s, h) = (s .= m.s0; nothing)
    @test CR._rebuild(Start(1.5), [9.0]) == Start(9.0)
    grads = (; piece = (; s0 = Ref(0.0)), s = [1.0, 1.0], history = nothing)
    CR.pullback!(grads, Start(2.0), CR.Init(), zeros(2), ones(2, 2))
    @test grads.piece.s0[] == 2.0
    # The same for a field typed `Real`. A field typed `Union{Nothing,
    # Float64}` cannot hold the dual number, so the rebuild throws rather
    # than dropping the cotangent.
    struct StartReal
        s0::Real
    end
    struct StartUnion
        s0::Union{Nothing, Float64}
    end
    for M in (StartReal, StartUnion)
        @eval CR.ispointwise(::$M) = true
        @eval CR.forward!(m::$M, ::CR.Init, s, h) = (s .= m.s0; nothing)
    end
    grads = (; piece = (; s0 = Ref(0.0)), s = [1.0, 1.0], history = nothing)
    CR.pullback!(grads, StartReal(2.0), CR.Init(), zeros(2), ones(2, 2))
    @test grads.piece.s0[] == 2.0
    grads = (; piece = (; s0 = Ref(0.0)), s = [1.0, 1.0], history = nothing)
    @test_throws MethodError CR.pullback!(
        grads, StartUnion(2.0), CR.Init(), zeros(2), ones(2, 2)
    )
end

@testitem "Adjoint: local pullback over entry parameters" setup = [ReferenceAD, AdjointCheck] begin
    using ComposableRecurrences
    # A pointwise modifier whose array parameters a step reads one entry of
    # through `param`: the default `Step` pullback seeds that entry alone.
    struct Cap{K, B}
        κ::K
        b::B
    end
    CR.ispointwise(::Cap) = true
    function CR.forward!(m::Cap, ::CR.Step, v, s, t)
        for k in eachindex(v, s)
            κ = CR.param(m.κ, k, t)
            v′ = CR.param(m.b, k, t) * v[k] * κ / (κ + v[k])
            v[k], s[k] = v′, s[k] + v′
        end
        return nothing
    end
    S, n = 2, 8
    rng = Xoshiro(4)
    for m in (
            Cap(PerStratum([5.0, 6.0]), 1.1),
            Cap(TimeVarying(4 .+ rand(rng, n)), PerStratum([0.9, 1.2])),
            Cap(TimeVarying(PerStratum(4 .+ rand(rng, S, n))), 0.8),
            Cap(2.0 * Derived(exp, TimeVarying(PerStratum(rand(rng, S, n)))), 1.0),
        )
        @test CR._modifier_adjoint(m) === :local
        @test !CR._scalar_params(m)
        @test CR.uses_adjoint(@inferred(Recurrence([0.3, 0.2], I, (m,))), CR.Run())
        # Against ForwardDiff over every parameter entry at (k, t) = (2, 3).
        x0 = [2.0; 1.5; CR._params(m)]
        J = ReferenceAD.jacobian(x0) do x
            md = CR._rebuild(m, view(x, 3:length(x)))
            return collect(CR._step(md, x[1], x[2], 3, 2))
        end
        ref = transpose(J) * [0.3, 0.7]
        m̄ = zero_mirror(m)
        got = CR._step_pullback((; piece = m̄, v = 0.3, s = 0.7), m, 2.0, 1.5, 3, 2)
        @test collect(got) ≈ ref[1:2]
        @test mirror_vec(m̄, m) ≈ ref[3:end]
        r = Recurrence([0.3, 0.2]; coupling = [0.9 0.1; 0.2 0.8], modifiers = (m,))
        @test pullback_matches(r, recargs(ones(S, 6), nothing, ones(S, 2))...)
    end
    # A step allocates nothing.
    m = Cap(TimeVarying(PerStratum(4 .+ rand(rng, S, n))), PerStratum([0.9, 1.2]))
    m̄ = zero_mirror(m)
    function steps(m, m̄, k)
        acc = 0.0
        for i in 1:1000
            v̄, s̄ = CR._step_pullback((; piece = m̄, v = 0.3, s = 0.7), m, 2.0 + i, 1.0, 3, k)
            acc += v̄ + s̄
        end
        return acc
    end
    steps(m, m̄, 1)
    @test (@allocated steps(m, m̄, 2)) < 1000
    # A step that reads an array parameter's field directly cannot take the
    # scalar the local derivative passes, so the operator takes plain AD.
    struct Direct{K}
        κ::K
    end
    CR.ispointwise(::Direct) = true
    function CR.forward!(m::Direct, ::CR.Step, v, s, t)
        for k in eachindex(v, s)
            v[k] = v[k] / (1 + v[k] / m.κ.x[k])
        end
        return nothing
    end
    d = Direct(PerStratum([5.0, 6.0]))
    @test CR._modifier_adjoint(d) === :local
    op = Recurrence([0.3, 0.2]; modifiers = (d,))
    @test op.rebuilds === false
    @test !CR.uses_adjoint(op, CR.Run())
    # The check runs the step on the parameters' own entries, so a step
    # that would throw at a zero entry keeps the local derivative.
    struct Root{K}
        κ::K
    end
    CR.ispointwise(::Root) = true
    function CR.forward!(m::Root, ::CR.Step, v, s, t)
        for k in eachindex(v, s)
            v[k] = v[k] * sqrt(CR.param(m.κ, k, t) - 1)
        end
        return nothing
    end
    op = Recurrence([0.3, 0.2]; modifiers = (Root(PerStratum([5.0, 6.0])),))
    @test op.rebuilds === true
    @test CR.uses_adjoint(op, CR.Run())
    @test pullback_matches(op, recargs(ones(S, 6), nothing, ones(S, 2))...)
    # An array parameter of another form, or a raw array, takes the read
    # step (`_read_pullback`) instead.
    struct Raw{K}
        κ::K
    end
    CR.ispointwise(::Raw) = true
    function CR.forward!(m::Raw, ::CR.Step, v, s, t)
        for k in eachindex(v, s)
            v[k] = v[k] / (1 + v[k] / m.κ[k])
        end
        return nothing
    end
    for m in (Cap(PerStratum([5.0 6.0; 7.0 8.0]), 1.0), Raw([5.0, 6.0, 7.0]))
        @test CR._modifier_adjoint(m) === :local
        ro = Recurrence([0.3, 0.2]; modifiers = (m,))
        @test ro.rebuilds === true
        @test pullback_matches(ro, recargs(ones(S, 2), nothing, ones(S, 2))...)
    end
end

@testitem "Adjoint: local pullback over float arrays read entry by entry" setup = [ReferenceAD, AdjointCheck] begin
    using ComposableRecurrences
    using LinearAlgebra: I
    # Pointwise modifiers that read their float arrays directly: the local
    # step records each entry read and seeds it alone, up to four a step.
    abstract type Reader end
    CR.ispointwise(::Reader) = true
    struct ByT{A} <: Reader
        a::A
    end
    function CR.forward!(m::ByT, ::CR.Step, v, s, t)
        for k in eachindex(v, s)
            v[k], s[k] = v[k] * m.a[t], s[k] + v[k]
        end
        return nothing
    end
    struct ByKT{A} <: Reader
        a::A
    end
    function CR.forward!(m::ByKT, ::CR.Step, v, s, t)
        for k in eachindex(v, s)
            v[k] = v[k] * m.a[k, t]
        end
        return nothing
    end
    struct Two{A} <: Reader
        a::A
    end
    function CR.forward!(m::Two, ::CR.Step, v, s, t)
        for k in eachindex(v, s)
            v[k] = v[k] * m.a[t] + 0.1 * m.a[max(t - 1, 1)]
        end
        return nothing
    end
    struct Every{A} <: Reader
        a::A
    end
    function CR.forward!(m::Every, ::CR.Step, v, s, t)
        for k in eachindex(v, s)
            v[k] = v[k] * sum(m.a) / length(m.a)
        end
        return nothing
    end
    struct Scaled{A, B} <: Reader
        a::A
        b::B
    end
    function CR.forward!(m::Scaled, ::CR.Step, v, s, t)
        for k in eachindex(v, s)
            v[k] = m.b * v[k] * m.a[t]
        end
        return nothing
    end
    struct Entry{A, B} <: Reader
        a::A
        b::B
    end
    function CR.forward!(m::Entry, ::CR.Step, v, s, t)
        for k in eachindex(v, s)
            v[k] = CR.param(m.b, k, t) * v[k] * m.a[t]
        end
        return nothing
    end
    # The first `n` entries, so each width of the read step and the
    # Jacobian beyond them are reached.
    struct Firsts{A} <: Reader
        a::A
        n::Int
    end
    function CR.forward!(m::Firsts, ::CR.Step, v, s, t)
        for k in eachindex(v, s)
            acc = zero(v[k])
            for i in 1:m.n
                acc += m.a[i]
            end
            v[k] = v[k] * acc / m.n
        end
        return nothing
    end
    # Two arrays, and arrays inside a named tuple and an inner struct.
    struct Pair2{A, B} <: Reader
        a::A
        b::B
    end
    function CR.forward!(m::Pair2, ::CR.Step, v, s, t)
        for k in eachindex(v, s)
            v[k] = v[k] * m.a[t] + m.b[k]
        end
        return nothing
    end
    struct Inner{C}
        c::C
    end
    struct Nest{N} <: Reader
        nt::N
    end
    function CR.forward!(m::Nest, ::CR.Step, v, s, t)
        for k in eachindex(v, s)
            v[k] = v[k] * m.nt.w[t] * m.nt.inner.c[k]
        end
        return nothing
    end
    S, T = 2, 6
    rng = Xoshiro(6)
    a = 0.8 .+ 0.2 .* rand(rng, T)
    along = 0.5 .+ rand(rng, 30)
    args = recargs(ones(S, T), nothing, ones(S, 2))
    for m in (
            ByT(a), ByKT(0.8 .+ 0.2 .* rand(rng, S, T)), Two(a), Every(a),
            Scaled(a, 1.3), Entry(a, PerStratum([0.9, 1.1])),
            (Firsts(along, n) for n in (4, 5, 8, 9, 12, 13, 24))...,
            Pair2(a, [1.1, 0.9]), Nest((; w = a, inner = Inner([1.1, 0.9]))),
            ByT(Float32.(a)),
        )
        @test CR._modifier_adjoint(m) === :local
        @test !CR._local_params(m)
        r = Recurrence([0.3, 0.2]; coupling = [0.9 0.1; 0.2 0.8], modifiers = (m,))
        @test r.rebuilds === true
        @test CR.uses_adjoint(r, CR.Run())
        # The rule on Mooncake only (`_ad_wide`).
        @test CR._fit(r, args...) === :wide
        @test pullback_matches(r, args...)
        # One step against ForwardDiff over every entry at (k, t) = (2, 3).
        x0 = [2.0; 1.5; CR._params(m)]
        J = ReferenceAD.jacobian(x0) do x
            md = CR._rebuild(m, view(x, 3:length(x)))
            return collect(CR._step(md, x[1], x[2], 3, 2))
        end
        ref = transpose(J) * [0.3, 0.7]
        m̄ = zero_mirror(m)
        got = CR._step_pullback((; piece = m̄, v = 0.3, s = 0.7), m, 2.0, 1.5, 3, 2)
        @test collect(got) ≈ ref[1:2]
        # A Float32 array keeps Float32 cotangents.
        @test mirror_vec(m̄, m) ≈ ref[3:end] rtol = 1.0e-6
    end
    # The step infers and allocates only its record of the reads.
    m = ByT(a)
    m̄ = zero_mirror(m)
    @inferred CR._step_pullback((; piece = m̄, v = 0.3, s = 0.7), m, 2.0, 1.5, 3, 2)
    @test (@allocated CR._step_pullback((; piece = m̄, v = 0.3, s = 0.7), m, 2.0, 1.5, 3, 2)) < 400
    # A step that reads more than four entries runs once more with room for
    # 8 or 12, and past 12 in passes of 12, rather than taking the Jacobian
    # in every entry.
    function step_bytes(m)
        m̄ = zero_mirror(m)
        CR._step_pullback((; piece = m̄, v = 0.3, s = 0.7), m, 2.0, 1.5, 3, 2)
        return @allocated CR._step_pullback((; piece = m̄, v = 0.3, s = 0.7), m, 2.0, 1.5, 3, 2)
    end
    for n in (5, 9, 13, 24)
        @test step_bytes(Firsts(along, n)) < 2000
    end
    # A modifier whose step reads more than 24 entries takes plain AD, as
    # it is faster there, and the constructor says why. A step of it run
    # directly still matches ForwardDiff.
    for n in (25, 30)
        m = Firsts(along, n)
        @test CR._modifier_adjoint(m) === :local
        op = (empty!(CR._PLAIN_NOTED); @test_logs (:info, r"reads more than 24") Recurrence([0.3, 0.2]; modifiers = (m,)))
        @test op.rebuilds === false
        @test !CR.uses_adjoint(op, CR.Run())
        x0 = [2.0; 1.5; CR._params(m)]
        J = ReferenceAD.jacobian(x0) do x
            md = CR._rebuild(m, view(x, 3:length(x)))
            return collect(CR._step(md, x[1], x[2], 3, 2))
        end
        ref = transpose(J) * [0.3, 0.7]
        m̄ = zero_mirror(m)
        got = CR._step_pullback((; piece = m̄, v = 0.3, s = 0.7), m, 2.0, 1.5, 3, 2)
        @test collect(got) ≈ ref[1:2]
        @test mirror_vec(m̄, m) ≈ ref[3:end]
    end
    # A constructor that changes its array, a step that needs the array's
    # own type, and an array of arrays keep plain AD.
    struct Halved{A} <: Reader
        a::A
        Halved(a::A) where {A} = new{A}(a ./ 2)
    end
    function CR.forward!(m::Halved, ::CR.Step, v, s, t)
        for k in eachindex(v, s)
            v[k] = v[k] * m.a[t]
        end
        return nothing
    end
    struct Strict{A} <: Reader
        a::A
    end
    function CR.forward!(m::Strict, ::CR.Step, v, s, t)
        for k in eachindex(v, s)
            v[k] = v[k] * (m.a::Vector{Float64})[t]
        end
        return nothing
    end
    for m in (Halved(a), Strict(a))
        op = Recurrence([0.3, 0.2]; modifiers = (m,))
        @test op.rebuilds === false
        @test !CR.uses_adjoint(op, CR.Run())
    end
    @test CR._modifier_adjoint(ByT([a, a])) === :none
end

@testitem "Adjoint: the read and array steps' helpers, called directly" setup = [AdjointCheck] begin
    using ComposableRecurrences
    using LinearAlgebra: mul!
    # Each helper's contract on its own: the read step against ForwardDiff,
    # the rebuilds of named tuples, the cotangent of one read, the check
    # that each array stays read, and the coupling step with its buffers.
    struct ByTime{A}
        a::A
    end
    CR.ispointwise(::ByTime) = true
    function CR.forward!(m::ByTime, ::CR.Step, v, s, t)
        for k in eachindex(v, s)
            v[k], s[k] = v[k] * m.a[t], s[k] + v[k]
        end
        return nothing
    end
    a = [0.9, 1.1, 1.3]
    m̄ = (; a = zeros(3))
    @test collect(CR._read_pullback(ByTime(a), m̄, 0.3, 0.7, 2.0, 1.0, 2, 1)) ≈
        [0.3 * a[2] + 0.7, 0.7]
    @test m̄.a ≈ [0.0, 0.6, 0.0]
    @test CR._rebuild_reads((; b = 1.0, n = 2), (5.0,), nothing, 1) ==
        ((; b = 5.0, n = 2), (), 1)
    y, o = CR._rebuild_views((; b = 1.0, x = [1.0, 2.0]), [5.0, 6.0, 7.0], 0)
    @test y.b == 5.0
    @test y.x == [6.0, 7.0]
    @test o == 3
    x̄ = zeros(2)
    @test CR._add_read!(x̄, [1.0, 2.0], 1, 2, 0.5, 1) == 2
    @test x̄ == [0.0, 0.5]
    @test CR._add_read!((x̄,), ([1.0, 2.0],), 2, 1, 0.5, 1) == 2
    @test x̄ == [0.0, 0.5]
    @test CR._reads_kept(1.0, 2.0)
    @test CR._reads_kept(:a, :a)
    @test CR._reads_kept((1.0, :a), (2.0, :a))
    @test !CR._array_params(CR.Transform(exp))
    struct Mix{M}
        M::M
    end
    CR.forward!(C::Mix, ::CR.Pressure, q, p, t) = (mul!(q, C.M, p); nothing)
    C, p, q̄ = Mix([0.5 0.1; 0.2 0.4]), [1.0, 2.0], [0.3, 0.7]
    p̄, C̄ = zeros(2), (; M = zeros(2, 2))
    CR._local_pressure!(p̄, C̄, C, q̄, p, 1, CR._array_pressure(C, Float64))
    @test p̄ ≈ transpose(C.M) * q̄
    @test C̄.M ≈ q̄ * transpose(p)
end

@testitem "Adjoint: local pullback of a coupling holding arrays" setup = [ReferenceAD, AdjointCheck] begin
    using ComposableRecurrences
    using LinearAlgebra: Diagonal, mul!
    using SparseArrays: sparse
    # A user coupling holding a matrix, and one with a scalar beside it,
    # without a pullback: the local step seeds every entry.
    struct Mix{M}
        M::M
    end
    CR.forward!(C::Mix, ::CR.Pressure, q, p, t) = (mul!(q, C.M, p); nothing)
    struct ScaledMix{M, A}
        M::M
        a::A
    end
    CR.forward!(C::ScaledMix, ::CR.Pressure, q, p, t) = (q .= C.a .* (C.M * p); nothing)
    rng = Xoshiro(7)
    for S in (2, 3, 7)
        M = 0.5 .* rand(rng, S, S)
        for C in (Mix(M), ScaledMix(M, 0.7))
            @test CR._coupling_adjoint(C) === :local
            @test CR._ninputs(C) == S^2 + (C isa ScaledMix)
            p, q̄ = rand(rng, S), randn(rng, S)
            θ0 = [p; CR._params(C)]
            function pressure(x)
                q = zeros(eltype(x), S)
                CR.forward!(CR._rebuild(C, x[(S + 1):end]), CR.Pressure(), q, x[1:S], 1)
                return sum(q̄ .* q)
            end
            ref = ReferenceAD.gradient(pressure, θ0)
            C̄ = zero_mirror(C)
            p̄ = zeros(S)
            bufs = CR._pressure_buffers(C̄, C, Float64)
            CR._pressure_back!(p̄, C̄, C, q̄, p, 1, bufs)
            @test p̄ ≈ ref[1:S]
            @test mirror_vec(C̄, C) ≈ ref[(S + 1):end]
            # Without the reverse pass's buffers the step makes its own.
            C̄ = zero_mirror(C)
            p̄ = zeros(S)
            CR._pressure_back!(p̄, C̄, C, q̄, p, 1)
            @test p̄ ≈ ref[1:S]
            @test mirror_vec(C̄, C) ≈ ref[(S + 1):end]
        end
    end
    # Through a recurrence; with 3 strata the 12 inputs fit one pass.
    r = Recurrence([0.3, 0.2]; coupling = Mix(0.5 .* rand(rng, 3, 3)))
    @test r.rebuilds === true
    args(S) = recargs(ones(S, 4), nothing, ones(S, 2))
    @test CR._fit(r, args(3)...) === :one
    @test pullback_matches(r, args(3)...)
    @test CR._fit(Recurrence([0.3]; coupling = Mix(rand(5, 5))), args(5)...) === :wide
    @test CR._fit(Recurrence([0.3]; coupling = Mix(rand(7, 7))), args(7)...) === :none
    # A call with its trace is routed as the call without it.
    for (S, fit) in ((3, :one), (5, :wide), (7, :none))
        rS = Recurrence([0.3]; coupling = Mix(0.5 .* rand(rng, S, S)))
        for op in (CR._WithTrace(rS), CR._WithTrace(CR._WithState(rS)))
            @test CR.uses_adjoint(op, CR.Run()) === CR.uses_adjoint(rS, CR.Run())
            @test CR._type_adjoint(op) === CR._type_adjoint(rS)
            @test CR._fit(op, args(S)...) === fit
        end
    end
    # A coupling whose arrays sit in a named tuple and a tuple, beside a
    # scalar and an integer.
    struct NTMix{N, P}
        nt::N
        tp::P
    end
    function CR.forward!(C::NTMix, ::CR.Pressure, q, p, t)
        mul!(q, C.nt.M, p)
        q .= C.nt.a .* q .+ C.tp[1] .* p ./ C.nt.n
        return nothing
    end
    C = NTMix((; M = 0.5 .* rand(rng, 3, 3), a = 0.9, n = 2), ([0.1, 0.2, 0.3], 1))
    @test CR._coupling_adjoint(C) === :local
    r = Recurrence([0.3, 0.2]; coupling = C)
    @test r.rebuilds === true
    @test CR._fit(r, args(3)...) === :one
    @test pullback_matches(r, args(3)...)
    # At the limits: 24 inputs in one pass, 48 in two.
    struct WMix{W}
        w::W
    end
    CR.forward!(C::WMix, ::CR.Pressure, q, p, t) = (q .= (sum(C.w) / length(C.w)) .* p; nothing)
    for (P, fit) in ((22, :one), (23, :wide), (46, :wide), (47, :none))
        @test CR._fit(Recurrence([0.3]; coupling = WMix(rand(P))), args(2)...) === fit
    end
    # A constructor that changes its matrix keeps plain AD.
    struct HalvedMix{M}
        M::M
        HalvedMix(M::A) where {A} = new{A}(M ./ 2)
    end
    CR.forward!(C::HalvedMix, ::CR.Pressure, q, p, t) = (mul!(q, C.M, p); nothing)
    @test Recurrence([0.3]; coupling = HalvedMix(rand(3, 3))).rebuilds === false
    # A Diagonal or a sparse matrix, whose fields a step may read, keeps
    # plain AD, as do views and reshapes of an array the step seeds.
    @test CR._coupling_adjoint(Mix(Diagonal(rand(3)))) === :none
    @test CR._coupling_adjoint(Mix(sparse(rand(3, 3)))) === :none
    @test CR._coupling_adjoint(Mix(view(rand(4, 3), 1:3, :))) === :local
    @test CR._coupling_adjoint(Mix(reshape(view(rand(9), 1:9), 3, 3))) === :local
end

@testitem "Adjoint: local pullback of a whole-step modifier" setup = [
    ReferenceAD,
    AdjointCheck,
] begin
    using ComposableRecurrences
    # Vector-level modifiers without a pullback: the local derivative seeds
    # the step's values, its state and its parameters as dual numbers.
    # Scales the values by `a`, moves a share `b` of their total to the
    # first stratum, and keeps a decaying total of them as its state.
    struct Mixer{A, B}
        a::A
        b::B
    end
    function CR.forward!(m::Mixer, ::CR.Step, v, s, t)
        v .*= m.a
        tot = sum(v)
        v[1] += m.b * tot
        s .= 0.5 .* s .+ v
        return nothing
    end
    # A per-stratum scale held as an array, or read through `param`.
    struct VecScale{A}
        a::A
    end
    scale_at(a::AbstractVector, k, t) = a[k]
    scale_at(a, k, t) = CR.param(a, k, t)
    function CR.forward!(m::VecScale, ::CR.Step, v, s, t)
        for k in eachindex(v)
            v[k] *= scale_at(m.a, k, t)
        end
        return nothing
    end
    # No parameters: each value takes the mean of its neighbours.
    struct Smear end
    function CR.forward!(::Smear, ::CR.Step, v, s, t)
        S = length(v)
        S == 1 && return nothing
        w = copy(v)
        for k in eachindex(v)
            v[k] = (w[k] + w[mod1(k + 1, S)]) / 2
        end
        return nothing
    end
    CR.nstate(::Mixer, S) = S
    # The step's Jacobian in `[v; s; θ]`, the reference for a direct call.
    function reference(m, v, s, t)
        θ = CR._params(m)
        S, R = length(v), length(s)
        J = ReferenceAD.jacobian([v; s; θ]) do x
            vv, ss = x[1:S], x[(S + 1):(S + R)]
            mm = isempty(θ) ? m : CR._rebuild(m, x[(S + R + 1):end])
            vv, ss = collect(vv), collect(ss)
            CR.forward!(mm, CR.Step(), vv, ss, t)
            return [vv; ss]
        end
        return J
    end
    rng = Xoshiro(3)
    for (m, S) in (
            (Mixer(0.9, 0.1), 1), (Mixer(0.9, 0.1), 3), (Mixer(0.9, 0.1), 11),
            (VecScale([0.9, 1.1, 1.0]), 3), (VecScale(PerStratum([0.9, 1.1])), 2),
            (VecScale(rand(rng, 30)), 30), (Smear(), 4),
        )
        @test CR._modifier_adjoint(m) === :local
        @test CR._whole_local(m)
        R = CR.nstate(m, S)
        v, s = rand(rng, S), rand(rng, R)
        v̄, s̄ = rand(rng, S), rand(rng, R)
        ref = transpose(reference(m, v, s, 2)) * [v̄; s̄]
        m̄ = zero_mirror(m)
        grads = (; piece = m̄, v = copy(v̄), s = copy(s̄))
        CR._local_step_back!(grads, m, v, s, 2)
        @test [grads.v; grads.s] ≈ ref[1:(S + R)]
        @test mirror_vec(m̄, m) ≈ ref[(S + R + 1):end]
        # Held constant, only the values' and the state's cotangents.
        grads = (; piece = nothing, v = copy(v̄), s = copy(s̄))
        CR._local_step_back!(grads, m, v, s, 2)
        @test [grads.v; grads.s] ≈ ref[1:(S + R)]
    end
    # With the buffers made once, as the reverse pass does, a step
    # allocates nothing.
    m, S = Mixer(0.9, 0.1), 3
    v, s, v̄, s̄ = ones(S), ones(S), ones(S), ones(S)
    m̄ = zero_mirror(m)
    b = CR._step_duals(m̄, m, Float64)
    grads = (; piece = m̄, v = v̄, s = s̄, pass = b)
    CR._local_step_back!(grads, m, v, s, 2)
    coverage = Base.JLOptions().code_coverage != 0
    @test (@allocated CR._local_step_back!(grads, m, v, s, 2)) == 0 skip = coverage
    @inferred CR._local_step_back!(grads, m, v, s, 2)
    # Through a recurrence the rule matches ForwardDiff over every leaf.
    for (ms, S) in (
            ((Mixer(0.9, 0.1),), 3), ((VecScale([0.9, 1.1]),), 2),
            ((Smear(), CR.Clamp(0.0, 9.0)), 3), ((Mixer(0.95, 0.05), Smear()), 2),
        )
        op = Recurrence([0.3, 0.2]; modifiers = ms)
        @test CR.uses_adjoint(op, CR.Run())
        @test op.rebuilds === true || op.rebuilds === Val(true)
        @test pullback_matches(op, recargs(fill(1.1, S, 6), nothing, ones(S, 2))...)
    end
    # One pass of 24 holds the values, the state and the parameters; past
    # it the call takes the wider route, at any size.
    args(S) = recargs(ones(S, 4), nothing, ones(S, 2))
    @test CR._fit(Recurrence([0.3]; modifiers = (Mixer(0.9, 0.1),)), args(11)...) === :one
    @test CR._fit(Recurrence([0.3]; modifiers = (Mixer(0.9, 0.1),)), args(12)...) === :wide
    @test CR._fit(Recurrence([0.3]; modifiers = (Mixer(0.9, 0.1),)), args(23)...) === :wide
    @test CR._fit(Recurrence([0.3]; modifiers = (Mixer(0.9, 0.1),)), args(60)...) === :wide
    @test CR._fit(Recurrence([0.3]; modifiers = (Smear(),)), args(12)...) === :one
    # A constructor that changes its arguments takes plain AD with the note.
    struct Doubling{A}
        a::A
        Doubling(a::A) where {A} = new{A}(2a)
    end
    CR.forward!(m::Doubling, ::CR.Step, v, s, t) = (v .*= m.a; nothing)
    empty!(CR._PLAIN_NOTED)
    op = @test_logs (:info, r"Doubling cannot be rebuilt") Recurrence(
        [0.3, 0.2]; modifiers = (Doubling(0.4),)
    )
    @test op.rebuilds === false
    # Without the dual-number extension, the step says to load it.
    @test_throws r"^ArgumentError: Mixer has no `pullback!`.*add `using ForwardDiff`$" invoke(
        CR._local_step!, Tuple{Any, Any, Vararg{Any}}, nothing, Mixer(0.9, 0.1)
    )
    @test invoke(CR._step_duals, Tuple{Any, Any, Vararg{Any}}, nothing, Mixer(0.9, 0.1)) ===
        nothing
end

@testitem "Adjoint: local coupling pullback" setup = [ReferenceAD, AdjointCheck] begin
    using ComposableRecurrences
    # A coupling without a pullback: a share `a` of every other stratum's
    # pressure goes to the first, scaled by `c`.
    struct ToFirst{A, C}
        a::A
        c::C
        n::Int
    end
    function CR.forward!(C::ToFirst, ::CR.Pressure, q, p, t)
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
    function step_allocations(p̄, C̄, C, q̄, p, bufs)
        CR._pressure_back!(p̄, C̄, C, q̄, p, 4, bufs)
        return @allocated CR._pressure_back!(p̄, C̄, C, q̄, p, 4, bufs)
    end
    # One pass of 4, 8, 12 or 24 partials, and more than one when called
    # directly with more inputs, the last pass partly filled.
    rng = Xoshiro(5)
    for S in (2, 6, 10, 20, 23, 60)
        p, q̄ = randn(rng, S), randn(rng, S)
        function pressure(x)
            q = zeros(eltype(x), S)
            CR.forward!(ToFirst(x[S + 1], x[S + 2], 2), CR.Pressure(), q, x[1:S], 4)
            return sum(q̄ .* q)
        end
        ref = ReferenceAD.gradient(pressure, [p; 0.3; Float64(0.9f0)])
        p̄, C̄ = fill(1.0, S), (; a = Ref(0.0), c = Ref(0.0f0), n = nothing)
        CR._pressure_back!(p̄, C̄, C, q̄, p, 4)
        @test p̄ ≈ 1 .+ ref[1:S]
        @test [C̄.a[], C̄.c[]] ≈ ref[(S + 1):end] rtol = 1.0e-6
        # Without a mirror only `p̄` comes back.
        p̄ = zeros(S)
        CR._pressure_back!(p̄, nothing, C, q̄, p, 4)
        @test p̄ ≈ ref[1:S]
        # With the reverse pass's buffers the step gives the same and,
        # once they are sized, allocates nothing.
        bufs = CR._pressure_buffers(C̄, C, Float64)
        p̄ = fill(1.0, S)
        C̄ = (; a = Ref(0.0), c = Ref(0.0f0), n = nothing)
        CR._pressure_back!(p̄, C̄, C, q̄, p, 4, bufs)
        @test p̄ ≈ 1 .+ ref[1:S]
        @test [C̄.a[], C̄.c[]] ≈ ref[(S + 1):end] rtol = 1.0e-6
        @test step_allocations(p̄, C̄, C, q̄, p, bufs) == 0
    end
    @test CR._pressure_buffers(nothing, [0.9 0.1; 0.2 0.8], Float64) === nothing
    # Through a recurrence the rule matches ForwardDiff.
    r = Recurrence([0.3, 0.2]; coupling = C)
    @test pullback_matches(r, recargs(ones(3, 6), nothing, ones(3, 2))...; rtol = 1.0e-6)
    # The route: the rule from the types, the wide route once the strata
    # and the coupling's scalars outgrow one pass, and plain AD once they
    # outgrow two.
    @test (@inferred Recurrence([0.3], C, ())).rebuilds === true
    args(S) = recargs(ones(S, 4), nothing, ones(S, 2))
    val(op, S) = Base.return_types(CR._route_val, typeof.((op, args(S)...)))
    @test val(r, 3) == [Val{:rule}]
    @test CR._fit(r, args(22)...) === :one
    @test CR._fit(r, args(23)...) === :wide
    @test CR._fit(r, args(46)...) === :wide
    @test CR._fit(r, args(47)...) === :none
    # Without a local step the route is the rule, as for any other operator.
    @test CR._fit(Recurrence([0.3]), args(50)...) === :one
    @test CR._fit(Convolution([0.5, 0.5]), ones(4)) === :one
    for S in (23, 46, 47)
        y = @test_logs CR.adjoint_call(r, args(S)...)
        @test y ≈ CR._plain(r, args(S)...)
    end
    # A coupling with no float parameters keeps the rule at any size.
    struct Swap end
    CR.forward!(::Swap, ::CR.Pressure, q, p, t) = (q .= reverse(p); nothing)
    @test Recurrence([0.3], Swap(), ()).rebuilds === Val(true)
    @test pullback_matches(
        Recurrence([0.3, 0.2]; coupling = Swap()), args(3)...
    )
    # A coupling whose constructor changes its argument takes plain AD.
    struct Halved{A}
        a::A
        Halved(a::A) where {A} = new{A}(a / 2)
    end
    CR.forward!(C::Halved, ::CR.Pressure, q, p, t) = (q .= C.a .* p; nothing)
    op = Recurrence([0.3]; coupling = Halved(0.5))
    @test op.rebuilds === false
    @test CR._fit(op, args(3)...) === :none
end

@testitem "Adjoint: local route coupling pullback" setup = [AdjointCheck] begin
    using ComposableRecurrences
    # A dense coupling without a pullback, as one route of two.
    struct Spread{A}
        a::A
    end
    function CR.forward!(C::Spread, ::CR.Pressure, q, p, t)
        for i in eachindex(q)
            q[i] = zero(eltype(q))
            for j in eachindex(p)
                q[i] += exp(-C.a * abs(i - j)) * p[j] / length(p)
            end
        end
        return nothing
    end
    function step_allocations(kbuf, ḡ, k, p̄, H, H̄, L)
        CR._kernel_back!(kbuf, ḡ, k, p̄, H, H̄, 1, 4, L)
        return @allocated CR._kernel_back!(kbuf, ḡ, k, p̄, H, H̄, 1, 4, L)
    end
    rng = Xoshiro(7)
    for S in (3, 6, 20)
        R = Routes((Spread(0.5), rand(rng, 4)), (rand(rng, S, S) ./ S, rand(rng, 2)))
        # Through a recurrence the rule matches ForwardDiff.
        @test pullback_matches(
            Recurrence(R), recargs(ones(S, 6), nothing, ones(S, 4))...;
            rtol = 1.0e-6
        )
        # The reverse pass makes each route coupling's buffers once, and
        # with them a route step allocates nothing.
        H = rand(rng, 6, S)
        k = CR._run_kernel(Float64, R, H, S)
        ḡ = zero_mirror(R)
        kbuf = @inferred CR._kernel_buffer(ḡ, k, H, S, 4)
        @test first(kbuf.pressures) !== nothing
        @test last(kbuf.pressures) === nothing
        @test step_allocations(kbuf, ḡ, k, randn(rng, S), H, zero(H), 4) == 0
    end
    # The rule takes the routes, and the widest route coupling's local
    # step sets the call's route, as for the coupling of a `Recurrence`.
    routes(Cs...) = Recurrence(Routes(map(C -> (C, [0.3, 0.2]), Cs)...))
    args(S) = recargs(ones(S, 4), nothing, ones(S, 2))
    r = routes(Spread(0.5), I)
    @test CR.uses_adjoint(r, CR.Run())
    @test CR._fit(r, args(23)...) === :one
    @test CR._fit(r, args(24)...) === :wide
    @test CR._fit(r, args(47)...) === :wide
    @test CR._fit(r, args(48)...) === :none
    @test CR._fit(routes(fill(0.01, 60, 60), I), args(60)...) === :one
    # A rebuild that fails sends every call to plain AD.
    struct Halved{A}
        a::A
        Halved(a::A) where {A} = new{A}(a / 2)
    end
    CR.forward!(C::Halved, ::CR.Pressure, q, p, t) = (q .= C.a .* p; nothing)
    op = routes(Spread(0.5), Halved(0.5))
    @test op.rebuilds === false
    @test CR._fit(op, args(3)...) === :none
end

@testitem "Recurrence: a Pairwise kernel must be strata × strata × lags" begin
    using ComposableRecurrences
    @test_throws ArgumentError Recurrence(Pairwise(ones(2, 2)))
end

@testitem "Adjoint: a call with its trace against ForwardDiff" setup = [AdjointCheck] begin
    using ComposableRecurrences
    # The trace's cotangent through the records, for each modifier's own
    # trace and the default, with `with_state` too.
    # A pointwise modifier whose state decays and gathers what passes it.
    struct Decay{A}
        a::A
    end
    CR.ispointwise(::Decay) = true
    CR.uses_adjoint(::Decay, ::CR.Step) = true
    CR.forward!(::Decay, ::CR.Init, s, history) = (fill!(s, 0); nothing)
    function CR.forward!(m::Decay, ::CR.Step, v, s, t)
        for k in eachindex(v, s)
            s[k] = m.a * s[k] + v[k]
        end
        return nothing
    end
    function CR.pullback!(grads, m::Decay, ::CR.Step, v, s, t)
        v̄, s̄ = grads.v, grads.s
        for k in eachindex(v, s)
            CR.add_cotangent!(CR.cotangent(grads.piece, :a), s̄[k] * s[k])
            v̄[k], s̄[k] = v̄[k] + s̄[k], m.a * s̄[k]
        end
        return nothing
    end
    # Two values and two state entries per group.
    struct Keep{A}
        a::A
    end
    CR.blocks(::Keep) = Val((2, 2))
    function CR.forward!(m::Keep, ::CR.Step, v::Tuple, s::Tuple, t, g)
        v1, v2, s1, s2 = v[1][], v[2][], s[1][], s[2][]
        v[1][], v[2][] = v1 * m.a, v2 + s1
        s[1][], s[2][] = s1 + v1, s2 + v2
        return nothing
    end
    function CR.pullback!(grads, m::Keep, ::CR.Step, v::Tuple, s::Tuple, t, g)
        v̄1, v̄2 = grads.v[1][], grads.v[2][]
        s̄1, s̄2 = grads.s[1][], grads.s[2][]
        CR.add_cotangent!(CR.cotangent(grads.piece, :a), v̄1 * v[1][])
        grads.v[1][], grads.v[2][] = v̄1 * m.a + s̄1, v̄2 + s̄2
        grads.s[1][], grads.s[2][] = v̄2 + s̄1, s̄2
        return nothing
    end
    g, R, h = [0.5, 0.3], [1.0 + 0.1 * sin(k + t) for k in 1:4, t in 1:6], ones(4, 2)
    K = [0.0 0.2 0.1 0.0; 0.1 0.0 0.0 0.2; 0.2 0.1 0.0 0.1; 0.0 0.1 0.2 0.0]
    leaky = CR.Depletion(
        PerStratum([80.0, 120.0, 90.0, 100.0]); pools = (:S, :V),
        form = CR.Hazard(), weights = (S = 1, V = 0.3),
        flows = (CR.Flow(:S => :V, 2.0; form = CR.Truncate()), CR.Flow(:V => :S, 0.1))
    )
    cases = (
        Recurrence(g; modifiers = (Decay(0.6), CR.Add(0.1), CR.Depletion(80.0))),
        Recurrence(g; modifiers = (Keep(0.8), leaky)),
        Recurrence(
            g; modifiers = (
                CR.Redistribute(CR.movement(K, fill(0.2, 4, 6))),
                CR.Depletion(PerStratum([60.0, 70.0, 80.0, 90.0])),
            )
        ),
    )
    for r in cases, op in (CR._WithTrace(r), CR._WithTrace(CR._WithState(r)))
        @test pullback_matches(op, recargs(R, nothing, h)...)
    end
    # A trace without a cotangent, whole or for one modifier, leaves the
    # pullback of the call without it.
    r = first(cases)
    args = recargs(R, nothing, h)
    y, cache = CR._run_forward(r, args...)
    ȳ = randn(Xoshiro(3), size(y))
    plain = zero_mirror((r, args...))
    CR._run_pullback!((; piece = first(plain), y = ȳ, args = Base.tail(plain)), r, cache)
    w = CR._WithTrace(r)
    (_, tr), _ = CR._run_forward(w, args...)
    for tr̄ in (nothing, (; modifiers = (nothing, nothing, zero(last(tr.modifiers)))))
        ms = zero_mirror((w, args...))
        _, cache = CR._run_forward(w, args...)
        grads = (; piece = first(ms), y = (ȳ, tr̄), args = Base.tail(ms))
        CR._run_pullback!(grads, w, cache)
        @test mirror_vec(ms, (w, args...)) ≈ mirror_vec(plain, (r, args...))
    end
    # A ward without a draw: each flow's amount, with every form.
    ward = CR.Depletion(;
        pools = (:A, :B), form = nothing, flows = (
            CR.Flow(1 => 2, 0.3), CR.Flow(1 => 0, 0.2; form = CR.Share()),
            CR.Flow(2 => 0, 1.5; form = CR.SoftTruncate(0.2)),
            CR.Flow(2 => 1, 0.4; form = CR.Truncate()),
            CR.Flow(0 => 2, 0.6; form = CR.Truncate()),
        )
    )
    r = Recurrence([1.0]; modifiers = (ward,))
    adm = [4.0 6.0 2.0 0.0 3.0 1.0; 0.0 0.0 0.0 0.0 0.0 0.0]
    for op in (CR._WithTrace(r), CR._WithTrace(CR._WithState(r)))
        @test pullback_matches(op, recargs(true, adm, zeros(2, 1); stop = 6)...)
    end
end
