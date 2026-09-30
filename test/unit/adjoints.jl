# Analytic adjoints called directly, with no AD backend: `pullback!` against
# a ForwardDiff gradient over every float leaf of the operator and its
# arguments. The backend rules in ext/ are tested in test/ad.

@testsnippet AdjointCheck begin
    using ComposableRecurrences: ComposableRecurrences as CR
    using ForwardDiff, LinearAlgebra, Random, SparseArrays

    # A zero cotangent mirror: arrays for float arrays, a `Ref` for a float
    # scalar, NamedTuples for structs, `nothing` where there is none.
    zero_mirror(x::AbstractFloat) = Ref(zero(x))
    zero_mirror(x::Array{<:AbstractFloat}) = zero(x)
    zero_mirror(x::SparseMatrixCSC{<:AbstractFloat}) = (; nzval = zero(nonzeros(x)))
    zero_mirror(x::Diagonal) = (; diag = zero_mirror(x.diag))
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
    randlike(rng, y) = y
    dotall(a::AbstractArray{<:Real}, b::AbstractArray) = sum(a .* b)
    dotall(a::Union{Tuple, NamedTuple}, b) = sum(map(dotall, values(a), values(b)))
    dotall(a, b) = 0.0

    # `pullback!` of `op` at `args` against ForwardDiff, over every float
    # leaf of `(op, args...)`.
    function pullback_matches(op, args...; rng = Xoshiro(1), rtol = 1.0e-8)
        xs = (op, args...)
        y, cache = CR.forward(xs...)
        ȳ = randlike(rng, y)
        θ = CR._params(xs)
        f = θ -> dotall(ȳ, first(CR.forward(CR._rebuild(xs, θ)...)))
        ref = ForwardDiff.gradient(f, θ)
        ms = zero_mirror(xs)
        CR.pullback!(op, cache, ȳ, ms...)
        got = mirror_vec(ms, xs)
        ok = isapprox(got, ref; rtol, atol = 1.0e-10)
        ok || @info "pullback mismatch" op maximum(abs.(got .- ref))
        return ok
    end
    # The positional arguments of `r(gain; history, add, start)`.
    recargs(gain, add, h; start = 1, states = nothing) = (gain, add, h, states, start)
end

@testsnippet AdjointModifiers begin
    using ComposableRecurrences: ComposableRecurrences as CR

    # Floored depletion from a per-stratum pool that is also the initial
    # state, so the pool's cotangent comes from both `apply` and
    # `init_state`. No hand-written pullback: the pointwise fallback runs.
    struct PoolDepletion{P}
        pop::P
    end
    CR.init_state(m::PoolDepletion, history) = collect(m.pop)
    CR.ispointwise(::PoolDepletion) = true
    function CR.apply(m::PoolDepletion, v, s, t, k)
        v′ = max(s / m.pop[k], 1.0e-6) * v
        return v′, s - v′
    end

    # Hazard depletion with a scalar pool and a hand-written scalar pullback.
    struct Hazard{T}
        N::T
    end
    CR.init_state(m::Hazard, history) = fill(m.N, CR._nstrata(history))
    CR.ispointwise(::Hazard) = true
    function CR.apply(m::Hazard, v, s, t, k)
        x = v / m.N
        return -s * expm1(-x), s * exp(-x)
    end
    function CR.apply_pullback(m̄, m::Hazard, v, s, t, k, v̄, s̄)
        x = v / m.N
        e = exp(-x)
        x̄ = s * e * (v̄ - s̄)
        CR.add_cotangent!(CR.cotangent(m̄, :N), -x̄ * x / m.N)
        return x̄ / m.N, -v̄ * expm1(-x) + s̄ * e
    end
    function CR.init_state_pullback!(m̄, h̄, m::Hazard, history, s̄)
        CR.add_cotangent!(CR.cotangent(m̄, :N), sum(s̄))
        return nothing
    end

    # Vector-level with a scalar parameter and a running total in the state,
    # no pullback: the local Jacobian fallback runs.
    struct Scale{A}
        a::A
    end
    function CR.apply!(m::Scale, v, s, t)
        v .*= m.a
        s .+= v
        return nothing
    end

    # Pointwise and time-varying: add `b[t]` (absolute time).
    struct Shift{B}
        b::B
    end
    CR.ispointwise(::Shift) = true
    CR.apply(m::Shift, v, s, t, k) = (v + m.b[t], s)

    # Adds each stratum's history total, set once by `init_state`.
    struct HistoryTotal end
    function CR.init_state(::HistoryTotal, history)
        return vec(sum(history; dims = ndims(history)))
    end
    CR.ispointwise(::HistoryTotal) = true
    CR.apply(::HistoryTotal, v, s, t, k) = (v + 0.1 * s, s)

    # A coupling with no pullback: `q = β ⊙ (K p)`.
    struct Mix{M, V}
        K::M
        β::V
    end
    function CR.pressure!(q, C::Mix, p, window, t)
        q .= C.β .* (C.K * p)
        return q
    end
end

@testitem "Adjoint: Recurrence, single series" setup = [AdjointCheck] begin
    using ComposableRecurrences
    rng = Xoshiro(3)
    L, T = 4, 9
    g = rand(rng, L)
    r = Recurrence(g)
    R = 0.5 .+ rand(rng, T)
    @test pullback_matches(r, recargs(R, nothing, rand(rng, L))...)
    @test pullback_matches(r, recargs(0.8, randn(rng, T), rand(rng, L))...)
    @test pullback_matches(r, recargs(R, 0.3, rand(rng, L))...)
    # Shorter and longer histories.
    @test pullback_matches(r, recargs(R, nothing, rand(rng, 2))...)
    @test pullback_matches(r, recargs(R, nothing, rand(rng, 7))...)
    @test pullback_matches(r, recargs(true, randn(rng, T), rand(rng, L))...)
end

@testitem "Adjoint: Recurrence couplings" setup = [AdjointCheck] begin
    using ComposableRecurrences
    rng = Xoshiro(4)
    S, L, T = 3, 3, 8
    g = rand(rng, L)
    K = rand(rng, S, S)
    h = rand(rng, S, L)
    R = 0.5 .+ rand(rng, S, T)
    ϵ = randn(rng, S, T)
    for C in (
            I, 0.7I, K, sparse([0.5 0.0 0.2; 0.1 0.6 0.0; 0.0 0.3 0.9]),
            Diagonal(rand(rng, S)),
        )
        @test pullback_matches(Recurrence(g; coupling = C), recargs(R, ϵ, h)...)
    end
    @test pullback_matches(
        Recurrence(PerStratum(rand(rng, S, L)); coupling = K),
        recargs(R, nothing, h)...
    )
    P = rand(rng, S, S, L) ./ 3
    @test pullback_matches(
        Recurrence(nothing; coupling = Pairwise(P)), recargs(R, ϵ, h)...
    )
end

@testitem "Adjoint: Recurrence time-varying slots at absolute time" setup = [AdjointCheck] begin
    using ComposableRecurrences
    rng = Xoshiro(5)
    S, L, T, start = 2, 3, 5, 3
    Tall = start + T - 1
    h = rand(rng, S, L)
    R = 0.5 .+ rand(rng, S, T)
    r = Recurrence(
        TimeVarying(rand(rng, L, Tall)); coupling = TimeVarying(rand(rng, S, S, Tall))
    )
    @test pullback_matches(r, recargs(R, nothing, h; start)...)
    r = Recurrence(TimeVarying(rand(rng, S, L, Tall)))
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
            (Scale(0.9),),
            (Shift(randn(rng, T)), HistoryTotal()),
            (Shift(randn(rng, T)), Scale(0.8), Hazard(60.0)),
        )
        r = Recurrence(g; coupling = K, modifiers = mods)
        @test pullback_matches(r, recargs(R, nothing, h)...)
    end
    # A coupling with no pullback falls back to its local Jacobian.
    r = Recurrence(g; coupling = Mix(K, rand(rng, S)))
    @test pullback_matches(r, recargs(R, nothing, h)...)
    # Resumed from given states.
    r = Recurrence(g; coupling = K, modifiers = (PoolDepletion([30.0, 40.0, 50.0]),))
    @test pullback_matches(r, recargs(R, nothing, h; states = ([20.0, 25.0, 30.0],))...)
end

@testitem "Adjoint: Recurrence returning its state" setup = [AdjointCheck, AdjointModifiers] begin
    using ComposableRecurrences
    rng = Xoshiro(7)
    S, L = 2, 3
    g = rand(rng, L) ./ 2
    r = Recurrence(g; coupling = rand(rng, S, S), modifiers = (Hazard(50.0),))
    for (T, m) in ((6, 3), (2, 3), (6, 5), (2, 1))
        args = recargs(0.5 .+ rand(rng, S, T), nothing, 1 .+ rand(rng, S, m))
        @test pullback_matches(CR._WithState(r), args...)
    end
end

@testitem "Adjoint: Recurrence with mixed eltypes" setup = [AdjointCheck, AdjointModifiers] begin
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
    @test pullback_matches(Convolution(g), x, nothing, 1)
    @test pullback_matches(Convolution(g), x, rand(rng, 2), 1)
    @test pullback_matches(Convolution(g), X, rand(rng, S, 5), 1)
    @test pullback_matches(Convolution(PerStratum(rand(rng, S, D))), X, nothing, 1)
    for indexed_by in (:primary, :secondary), start in (4, 6)
        m = 3
        c = Convolution(TimeVarying(rand(rng, S, D, start + T)); indexed_by)
        @test pullback_matches(c, X, rand(rng, S, m), start)
        c = Convolution(TimeVarying(rand(rng, D, start + T)); indexed_by)
        @test pullback_matches(c, x, rand(rng, m), start)
    end
end

@testitem "Adjoint: routing and cotangent helpers" setup = [AdjointCheck] begin
    using ComposableRecurrences, ForwardDiff
    r = Recurrence([0.2, 0.3])
    args = recargs(ones(4), nothing, ones(2))
    @test CR.has_adjoint(r, args...)
    @test CR._gate(r, args...)
    @test !CR._gate(r, ForwardDiff.Dual(1.0, 1.0), nothing, ones(2), nothing, 1)
    @test !CR._gate(r, big.(ones(4)), nothing, ones(2), nothing, 1)
    @test Base.return_types(CR._route_val, typeof.((r, args...))) == [Val{true}]

    struct NoPullback <: CR.AbstractOperator end
    CR.forward(::NoPullback, x) = (2 .* x, nothing)
    @test !CR.has_adjoint(NoPullback(), ones(2))
    @test NoPullback()(ones(2)) == [2.0, 2.0]

    @test CR.cotangent(nothing, :a) === nothing
    @test CR.cotangent((; a = [1.0]), :a) == [1.0]
    x̄ = Ref(1.0)
    CR.add_cotangent!(x̄, 2.0, 3)
    @test x̄[] == 3.0
    x̄ = zeros(2, 2)
    CR.add_cotangent!(x̄, 2.0, 1, 2)
    @test x̄[1, 2] == 2.0
    @test CR.add_cotangent!(nothing, 1.0, 1) === nothing
end

@testitem "Adjoint: NoAdjoint takes the plain path" begin
    using ComposableRecurrences
    using ComposableRecurrences: NoAdjoint
    r = Recurrence([0.2, 0.3])
    n0 = ComposableRecurrences._PULLBACK_CALLS[]
    @test NoAdjoint(r)(ones(4); history = ones(2)) == r(ones(4); history = ones(2))
    y, st = NoAdjoint(r)(ones(4); history = ones(2), return_state = true)
    @test (y, st) == r(ones(4); history = ones(2), return_state = true)
    c = Convolution([0.5, 0.5])
    @test NoAdjoint(c)(ones(3)) == c(ones(3))
    @test ComposableRecurrences._PULLBACK_CALLS[] == n0
end
