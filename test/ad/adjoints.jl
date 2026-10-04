# The native Mooncake and Enzyme rules: each backend's own rule tester via
# `test_adjoint`, proof that the rule fires, user-defined types with no AD
# code of their own, and the guard on plain Enzyme AD of a sparse coupling.

@testsnippet AdjointCases begin
    using ComposableRecurrences
    using ComposableRecurrences: ComposableRecurrences as CR
    using LinearAlgebra, Random, SparseArrays

    # Pointwise hazard depletion with a scalar pool, a hand-written scalar
    # pullback and a pooled initial state.
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

    # Floored depletion from a per-stratum pool, no pullback of its own.
    struct PoolDepletion{P}
        pop::P
    end
    CR.ispointwise(::PoolDepletion) = true
    CR.forward(m::PoolDepletion, ::CR.Init, s, history) = (s .= m.pop; nothing)
    function CR.forward(m::PoolDepletion, ::CR.Step, v, s, t, k)
        v′ = max(s / m.pop[k], 1.0e-6) * v
        return v′, s - v′
    end

    # The positional arguments of a Recurrence's Run.
    function rec(gain, add, h; start = 1, states = nothing, stop = nothing)
        return (gain, add, h, states, start, stop)
    end

    # `(name, op, args)` for `test_adjoint`: `args` are the positional
    # arguments of the operator's Run.
    function adjoint_cases()
        rng = Xoshiro(11)
        S, L, T = 3, 3, 6
        g = rand(rng, L) ./ 2
        K = rand(rng, S, S) ./ 2
        h = 1 .+ rand(rng, S, L)
        R = 0.5 .+ rand(rng, S, T)
        f32(x) = Float32.(x)
        Ks = sparse([0.5 0.0 0.2; 0.1 0.6 0.0; 0.0 0.3 0.4])
        return [
            ("renewal", Recurrence(g), rec(R[1, :], nothing, h[1, :])),
            (
                "renewal, Float32",
                Recurrence(f32(g)), rec(f32(R[1, :]), nothing, f32(h[1, :])),
            ),
            (
                "strata, mixed eltypes",
                Recurrence(f32(g); coupling = K), rec(R, nothing, f32(h)),
            ),
            ("sparse coupling", Recurrence(g; coupling = Ks), rec(R, copy(R), h)),
            (
                "Diagonal coupling, per-stratum kernel",
                Recurrence(PerStratum(rand(rng, S, L)); coupling = Diagonal(rand(rng, S))),
                rec(R, nothing, h),
            ),
            ("scalar gain and λ I", Recurrence(g; coupling = 0.7I), rec(0.9, R, h)),
            ("pairwise", Recurrence(Pairwise(rand(rng, S, S, L) ./ 3)), rec(R, nothing, h)),
            (
                "time-varying kernel and coupling",
                Recurrence(
                    TimeVarying(rand(rng, L, T));
                    coupling = TimeVarying(rand(rng, S, S, T) ./ 2)
                ),
                rec(R, nothing, h; start = 3),
            ),
            (
                "modifiers",
                Recurrence(
                    g; coupling = K,
                    modifiers = (PoolDepletion([30.0, 40.0, 50.0]), Hazard(60.0))
                ),
                rec(R, nothing, h),
            ),
            (
                "with state",
                CR._WithState(Recurrence(g; coupling = K, modifiers = (Hazard(60.0),))),
                rec(R, nothing, h),
            ),
            ("delay", Convolution(rand(rng, 4)), (R[1, :], h[1, :], 1, nothing)),
            (
                "time-varying delay",
                Convolution(TimeVarying(PerStratum(rand(rng, S, 4, T)))), (R, h, 4, nothing),
            ),
        ]
    end
end

@testsnippet UserTypes begin
    # A stand-in for a user package: an operator, a modifier and a coupling
    # with pullbacks written against the public API, and twins without, and
    # no Mooncake or Enzyme code.
    module UserPkg
    using ComposableRecurrences: ComposableRecurrences as CR
    using LinearAlgebra: mul!

    const CALLS = Ref(0)

    # y_t = ρ y_{t-1} + x_t from y_0.
    struct Decay{T} <: CR.AbstractOperator
        ρ::T
    end
    function CR.forward(op::Decay, ::CR.Run, y0, x)
        y = similar(x, promote_type(typeof(op.ρ), typeof(y0), eltype(x)))
        prev = y0
        for t in eachindex(x)
            prev = op.ρ * prev + x[t]
            y[t] = prev
        end
        return y, (; y0, y)
    end
    function CR.pullback!(grads, op::Decay, ::CR.Run, c)
        CALLS[] += 1
        ȳ = grads.y
        y0̄, x̄ = grads.args
        λ = zero(eltype(ȳ))
        ρ̄ = zero(λ)
        for t in reverse(eachindex(ȳ))
            λ = ȳ[t] + op.ρ * λ
            CR.add_cotangent!(x̄, λ, t)
            ρ̄ += λ * (t == 1 ? c.y0 : c.y[t - 1])
        end
        CR.add_cotangent!(CR.cotangent(grads.piece, :ρ), ρ̄)
        CR.add_cotangent!(y0̄, op.ρ * λ)
        return nothing
    end
    CR.uses_adjoint(::Decay, ::CR.Run) = true

    struct DecayNoPB{T} <: CR.AbstractOperator
        ρ::T
    end
    CR.forward(op::DecayNoPB, ::CR.Run, y0, x) = CR.forward(Decay(op.ρ), CR.Run(), y0, x)

    # v′ = v / (1 + v / K), vector-level.
    struct Saturate{V}
        K::V
    end
    function CR.forward(m::Saturate, ::CR.Step, v, s, t)
        v ./= 1 .+ v ./ m.K
        return nothing
    end
    function CR.pullback!(grads, m::Saturate, ::CR.Step, v, s, t)
        CALLS[] += 1
        K̄, v̄ = CR.cotangent(grads.piece, :K), grads.v
        for k in eachindex(v)
            d = 1 + v[k] / m.K[k]
            CR.add_cotangent!(K̄, v̄[k] * v[k]^2 / (m.K[k]^2 * d^2), k)
            v̄[k] /= d^2
        end
        return nothing
    end
    CR.uses_adjoint(::Saturate, ::CR.Step) = true
    struct SaturateNoPB{V}
        K::V
    end
    function CR.forward(m::SaturateNoPB, ::CR.Step, v, s, t)
        return CR.forward(Saturate(m.K), CR.Step(), v, s, t)
    end

    # q = β ⊙ (K p).
    struct Mix{M, V}
        K::M
        β::V
    end
    function CR.forward(C::Mix, ::CR.Pressure, q, p, t)
        mul!(q, C.K, p)
        q .*= C.β
        return nothing
    end
    function CR.pullback!(grads, C::Mix, ::CR.Pressure, q, p, t)
        CALLS[] += 1
        z = grads.q .* C.β
        K̄, β̄ = CR.cotangent(grads.piece, :K), CR.cotangent(grads.piece, :β)
        β̄ === nothing || (β̄ .+= grads.q .* (C.K * p))
        K̄ === nothing || (K̄ .+= z .* transpose(p))
        grads.p .+= transpose(C.K) * z
        return nothing
    end
    CR.uses_adjoint(::Mix, ::CR.Pressure) = true
    struct MixNoPB{M, V}
        K::M
        β::V
    end
    function CR.forward(C::MixNoPB, ::CR.Pressure, q, p, t)
        return CR.forward(Mix(C.K, C.β), CR.Pressure(), q, p, t)
    end
    end

    using .UserPkg
    using ComposableRecurrences
    using ComposableRecurrences: ComposableRecurrences as CR
    using Random

    # `(name, has own pullback, θ -> loss, θ)`: θ builds the user types'
    # fields, so the gradient checks their cotangents.
    function user_cases()
        rng = Xoshiro(5)
        S, L, T = 3, 3, 6
        K0 = [0.5 0.1 0.1; 0.2 0.4 0.1; 0.0 0.3 0.5]
        g = rand(rng, L) ./ 2
        h = 1 .+ rand(rng, S, L)
        R = 1 .+ rand(rng, S, T)
        W = randn(rng, S, T)
        x = rand(rng, T)
        rec(r) = sum(W .* r(R; history = h))
        return [
            ("operator", true, θ -> sum(UserPkg.Decay(θ[1])(θ[2], θ[3:end])), [0.7; 1.0; x]),
            (
                "operator, no pullback", false,
                θ -> sum(UserPkg.DecayNoPB(θ[1])(θ[2], θ[3:end])), [0.7; 1.0; x],
            ),
            (
                "modifier", true,
                θ -> rec(Recurrence(g; coupling = K0, modifiers = (UserPkg.Saturate(θ),))),
                5 .+ rand(rng, S),
            ),
            (
                "modifier, no pullback", false,
                θ -> rec(Recurrence(g; coupling = K0, modifiers = (UserPkg.SaturateNoPB(θ),))),
                5 .+ rand(rng, S),
            ),
            (
                "coupling", true,
                θ -> rec(
                    Recurrence(
                        g; coupling = UserPkg.Mix(reshape(θ[1:9], 3, 3), θ[10:12])
                    )
                ),
                [vec(K0); 1 .+ rand(rng, S)],
            ),
            (
                "coupling, no pullback", false,
                θ -> rec(
                    Recurrence(
                        g; coupling = UserPkg.MixNoPB(reshape(θ[1:9], 3, 3), θ[10:12])
                    )
                ),
                [vec(K0); 1 .+ rand(rng, S)],
            ),
        ]
    end
end

@testitem "Mooncake: test_adjoint on each operator" tags = [:ad, :mooncake, :mooncake_reverse] setup = [AdjointCases] begin
    using ADTypes: AutoMooncake
    import Mooncake
    for (name, op, args) in adjoint_cases()
        @testset "$name" begin
            CR.test_adjoint(AutoMooncake(; config = nothing), op, CR.Run(), args...)
        end
    end
end

@testitem "Enzyme: test_adjoint on each operator" tags = [:ad, :enzyme, :enzyme_reverse] setup = [AdjointCases] begin
    using ADTypes: AutoEnzyme
    import Enzyme, EnzymeTestUtils
    for (name, op, args) in adjoint_cases()
        @testset "$name" begin
            rtol = occursin("Float32", name) || occursin("mixed", name) ? 1.0e-3 : 1.0e-7
            CR.test_adjoint(AutoEnzyme(), op, CR.Run(), args...; rtol, atol = rtol)
        end
    end
end

@testitem "Rules fire through the public call" tags = [:ad, :mooncake, :mooncake_reverse, :enzyme, :enzyme_reverse] setup = [AdjointCases] begin
    using ADTypes: AutoMooncake, AutoEnzyme, AutoForwardDiff
    using DifferentiationInterface: gradient
    import Mooncake, Enzyme, ForwardDiff
    using ComposableRecurrences: NoAdjoint
    backends = (
        AutoMooncake(; config = nothing),
        AutoEnzyme(;
            mode = Enzyme.set_runtime_activity(Enzyme.Reverse),
            function_annotation = Enzyme.Const
        ),
    )
    rng = Xoshiro(3)
    g, h, W = rand(rng, 3) ./ 2, 1 .+ rand(rng, 3), randn(rng, 8)
    renewal(θ) = sum(W .* Recurrence(g; modifiers = (Hazard(θ[1]),))(θ[2:end]; history = h))
    renewal_na(θ) = sum(W .* NoAdjoint(Recurrence(g; modifiers = (Hazard(θ[1]),)))(θ[2:end]; history = h))
    delay(θ) = sum(W .* Convolution(θ[1:3])(θ[4:end]))
    delay_na(θ) = sum(W .* NoAdjoint(Convolution(θ[1:3]))(θ[4:end]))
    for (f, θ, fires) in (
                (renewal, [50.0; 1 .+ rand(rng, 8)], true),
                (renewal_na, [50.0; 1 .+ rand(rng, 8)], false),
                (delay, rand(rng, 11), true), (delay_na, rand(rng, 11), false),
            ),
            backend in backends
        ref = gradient(f, AutoForwardDiff(), θ)
        n0 = CR._PULLBACK_CALLS[]
        @test gradient(f, backend, θ) ≈ ref
        @test (CR._PULLBACK_CALLS[] > n0) == fires
    end
end

@testitem "User-defined operator, modifier and coupling" tags = [:ad, :mooncake, :mooncake_reverse, :enzyme, :enzyme_reverse] setup = [UserTypes] begin
    using ADTypes: AutoMooncake, AutoEnzyme, AutoForwardDiff
    using DifferentiationInterface: gradient
    import Mooncake, Enzyme, ForwardDiff
    backends = (
        AutoMooncake(; config = nothing),
        AutoEnzyme(;
            mode = Enzyme.set_runtime_activity(Enzyme.Reverse),
            function_annotation = Enzyme.Const
        ),
    )
    for (name, own, f, θ) in user_cases(), backend in backends
        @testset "$name $(nameof(typeof(backend)))" begin
            ref = gradient(f, AutoForwardDiff(), θ)
            n0, u0 = CR._PULLBACK_CALLS[], UserPkg.CALLS[]
            @test gradient(f, backend, θ) ≈ ref
            @test (UserPkg.CALLS[] > u0) == own
            # A user operator's own pullback is not the package's.
            occursin("operator", name) ||
                @test (CR._PULLBACK_CALLS[] > n0) == own
        end
    end
    @test Base.return_types(
        CR._route_val, (UserPkg.Decay{Float64}, Float64, Vector{Float64})
    ) == [Val{true}]
    @test Base.return_types(
        CR._route_val, (UserPkg.DecayNoPB{Float64}, Float64, Vector{Float64})
    ) == [Val{false}]
end

@testitem "User-defined types: test_adjoint" tags = [:ad, :mooncake, :mooncake_reverse, :enzyme, :enzyme_reverse] setup = [UserTypes] begin
    using ADTypes: AutoMooncake, AutoEnzyme
    import Mooncake, Enzyme, EnzymeTestUtils
    using LinearAlgebra
    S, L, T = 3, 3, 5
    K0 = [0.5 0.1 0.1; 0.2 0.4 0.1; 0.0 0.3 0.5]
    args = (1 .+ rand(S, T), nothing, 1 .+ rand(S, L), nothing, 1, nothing)
    cases = (
        (UserPkg.Decay(0.7), (1.0, rand(T))),
        (Recurrence(rand(L); coupling = K0, modifiers = (UserPkg.Saturate(5 .+ rand(S)),)), args),
        (Recurrence(rand(L); coupling = UserPkg.Mix(K0, 1 .+ rand(S))), args),
    )
    for (op, xs) in cases,
            backend in (AutoMooncake(; config = nothing), AutoEnzyme())
        @testset "$(typeof(op).name.name) $(nameof(typeof(backend)))" begin
            CR.test_adjoint(backend, op, CR.Run(), xs...)
        end
    end
end

@testitem "Enzyme: NoAdjoint on an active sparse coupling throws" tags = [:ad, :enzyme, :enzyme_reverse] begin
    using ComposableRecurrences
    using ComposableRecurrences: NoAdjoint
    using SparseArrays
    import Enzyme
    K = sparse([0.5 0.0 0.2; 0.1 0.6 0.0; 0.0 0.3 0.4])
    r = Recurrence([0.3, 0.2]; coupling = K)
    h, R = ones(3, 2), ones(3, 5)
    mode = Enzyme.set_runtime_activity(Enzyme.Reverse)
    f(r) = sum(NoAdjoint(r)(R; history = h))
    @test_throws ArgumentError Enzyme.gradient(mode, Enzyme.Const(f), r)
    # The rule path is correct.
    import ForwardDiff
    g(r) = sum(r(R; history = h))
    fnz(nz) = g(
        Recurrence(
            [0.3, 0.2];
            coupling = SparseMatrixCSC(3, 3, K.colptr, K.rowval, nz)
        )
    )
    @test Enzyme.gradient(mode, Enzyme.Const(g), r)[1].coupling.nzval ≈
        ForwardDiff.gradient(fnz, copy(K.nzval))
end

@testitem "Enzyme: a scalar operator field gets its cotangent" tags = [:ad, :enzyme, :enzyme_reverse] begin
    using ComposableRecurrences
    using LinearAlgebra
    import Enzyme
    h, R = ones(3, 2), ones(3, 5)
    f(r) = sum(r(R; history = h))
    fλ(λ) = f(Recurrence([0.3, 0.2]; coupling = λ * I))
    ḡ = Enzyme.gradient(
        Enzyme.set_runtime_activity(Enzyme.Reverse), Enzyme.Const(f),
        Recurrence([0.3, 0.2]; coupling = 0.7I)
    )[1]
    @test ḡ.coupling.λ ≈ (fλ(0.7001) - fλ(0.6999)) / 0.0002 rtol = 1.0e-6
end

@testitem "Every AD scenario fires its rule and no twin does" tags = [:ad, :mooncake, :mooncake_reverse, :enzyme, :enzyme_reverse] begin
    using ADFixtures
    using ADTypes: AutoMooncake, AutoEnzyme
    using DifferentiationInterface: gradient
    import Enzyme, Mooncake
    using ComposableRecurrences: ComposableRecurrences as CR
    skip = ADFixtures.backend_skip_scenarios()
    backends = (
        ("Mooncake reverse", AutoMooncake(; config = nothing)),
        (
            "Enzyme reverse",
            AutoEnzyme(;
                mode = Enzyme.set_runtime_activity(Enzyme.Reverse),
                function_annotation = Enzyme.Const
            ),
        ),
    )
    for (name, backend) in backends, scen in ADFixtures.scenarios()
        scen.name in get(skip, name, Set{String}()) && continue
        @testset "$(scen.name) $name" begin
            n0 = CR._PULLBACK_CALLS[]
            gradient(scen.f, backend, scen.x)
            @test (CR._PULLBACK_CALLS[] > n0) == !startswith(scen.name, "NoAdjoint")
        end
    end
end

@testsnippet UseCaseShapes begin
    using ComposableRecurrences
    using ComposableRecurrences: ComposableRecurrences as CR
    using LinearAlgebra, Random, SparseArrays

    # `(name, op, args)` in the shapes of the use cases: random walk, AR(2),
    # time-varying AR, seeded renewal, the patch model and a strata renewal
    # with imports. `args` are the positional arguments of the Run.
    function use_case_shapes()
        rng = Xoshiro(21)
        S, L, T = 3, 4, 8
        g = rand(rng, L) ./ 2
        K = [0.0 0.2 0.1; 0.1 0.0 0.3; 0.2 0.1 0.0]
        h = 1 .+ rand(rng, S, L)
        R = 0.5 .+ rand(rng, S, T)
        ϵ = randn(rng, T)
        rec(gain, add, h) = (gain, add, h, nothing, 1, nothing)
        pool(N, h::AbstractVector) = N - sum(h)
        pool(N, h::AbstractMatrix) = PerStratum(N .- vec(sum(h; dims = 2)))
        return [
            ("random walk", Recurrence([1.0]), rec(true, ϵ, [0.3])),
            ("AR(2)", Recurrence([0.5, -0.2]), rec(true, ϵ, [0.1, 0.2])),
            (
                "time-varying AR",
                Recurrence(TimeVarying(0.3 .* rand(rng, 2, T))), rec(true, ϵ, [0.1, 0.2]),
            ),
            (
                "seeded renewal",
                Recurrence(g; modifiers = (CR.Depletion(60.0; pool0 = pool(60.0, h[1, :])),)),
                rec(R[1, :], nothing, h[1, :]),
            ),
            (
                "patch model",
                Recurrence(
                    g; modifiers = (
                        CR.Redistribute(K, 0.4),
                        CR.Depletion(PerStratum(fill(80.0, S)); pool0 = pool(80.0, h)),
                    )
                ),
                rec(R, nothing, h),
            ),
            (
                "strata renewal with imports",
                Recurrence(
                    g; coupling = 0.3 .* rand(rng, S, S),
                    modifiers = (
                        CR.Depletion(PerStratum(fill(80.0, S))),
                        CR.Add(TimeVarying(PerStratum(0.2 .* rand(rng, S, T)))),
                    )
                ),
                rec(R, nothing, h),
            ),
            (
                "patch model, sparse kernel",
                Recurrence(
                    g; modifiers = (CR.Redistribute(sparse(K), PerStratum([0.4, 0.3, 0.2])),)
                ),
                rec(R, nothing, h),
            ),
            (
                "strata renewal with doses removed",
                Recurrence(
                    g; modifiers = (
                        CR.Depletion(
                            PerStratum(fill(80.0, S));
                            removals = TimeVarying(PerStratum(0.5 .+ rand(rng, S, T)))
                        ),
                    )
                ),
                rec(R, nothing, h),
            ),
            (
                "leaky vaccination into a protected pool",
                Recurrence(
                    g; coupling = 0.3 .* rand(rng, S, S),
                    modifiers = (
                        CR.Depletion(
                            PerStratum(fill(80.0, S)); pool0 = pool(80.0, h),
                            removals = TimeVarying(PerStratum(0.5 .+ rand(rng, S, T))),
                            protected = CR.Protected(PerStratum([0.2, 0.3, 0.4]); pool0 = 1.0)
                        ),
                    )
                ),
                rec(R, nothing, h),
            ),
        ]
    end
end

@testitem "Use-case shapes: test_adjoint on Mooncake" tags = [:ad, :mooncake, :mooncake_reverse] setup = [UseCaseShapes] begin
    using ADTypes: AutoMooncake
    import Mooncake
    for (name, op, args) in use_case_shapes()
        @testset "$name" begin
            CR.test_adjoint(AutoMooncake(; config = nothing), op, CR.Run(), args...)
        end
    end
end

@testitem "Use-case shapes: test_adjoint on Enzyme" tags = [:ad, :enzyme, :enzyme_reverse] setup = [UseCaseShapes] begin
    using ADTypes: AutoEnzyme
    import Enzyme, EnzymeTestUtils
    for (name, op, args) in use_case_shapes()
        @testset "$name" begin
            CR.test_adjoint(AutoEnzyme(), op, CR.Run(), args...)
        end
    end
end

@testitem "Sparse Redistribute kernel through both rules" tags = [:ad, :mooncake, :mooncake_reverse, :enzyme, :enzyme_reverse] begin
    using ComposableRecurrences
    using ComposableRecurrences: ComposableRecurrences as CR
    using ADTypes: AutoMooncake, AutoEnzyme, AutoForwardDiff
    using DifferentiationInterface: gradient
    using SparseArrays
    import Enzyme, ForwardDiff, Mooncake
    K = sparse([0.0 0.2 0.0; 0.1 0.0 0.3; 0.2 0.0 0.0])
    h, R = ones(3, 2), 1 .+ 0.1 .* reshape(1:18, 3, 6)
    W = cos.(reshape(1:18, 3, 6))
    function f(θ)
        Kθ = SparseMatrixCSC(3, 3, K.colptr, K.rowval, θ[1:4])
        r = Recurrence(
            [0.3, 0.2]; coupling = [0.5 0.1 0.0; 0.0 0.6 0.1; 0.1 0.0 0.5],
            modifiers = (CR.Redistribute(Kθ, θ[5]), CR.Depletion(PerStratum(fill(40.0, 3))))
        )
        return sum(W .* r(R; history = h))
    end
    θ = [K.nzval; 0.4]
    ref = gradient(f, AutoForwardDiff(), θ)
    for backend in (
            AutoMooncake(; config = nothing),
            AutoEnzyme(;
                mode = Enzyme.set_runtime_activity(Enzyme.Reverse),
                function_annotation = Enzyme.Const
            ),
        )
        n0 = CR._PULLBACK_CALLS[]
        @test gradient(f, backend, θ) ≈ ref
        @test CR._PULLBACK_CALLS[] > n0
    end
end

@testitem "Rule gradients survive inputs mutated after the call" tags = [:ad, :mooncake, :mooncake_reverse, :enzyme, :enzyme_reverse] begin
    using ComposableRecurrences
    using ADTypes: AutoMooncake, AutoEnzyme, AutoForwardDiff
    using DifferentiationInterface: gradient
    import Enzyme, ForwardDiff, Mooncake
    g, W = [0.3, 0.2], sin.(1:6)
    # The gain and history are overwritten after the operator has run.
    function f(θ)
        R, h = θ[1:6] .* 1, θ[7:8] .* 1
        y = Recurrence(g)(R; history = h)
        R .= 2 .* R
        h .= 0
        return sum(W .* y)
    end
    θ = [1.1, 0.9, 1.2, 1.0, 0.8, 1.3, 1.0, 2.0]
    ref = gradient(f, AutoForwardDiff(), θ)
    for backend in (
            AutoMooncake(; config = nothing),
            AutoEnzyme(;
                mode = Enzyme.set_runtime_activity(Enzyme.Reverse),
                function_annotation = Enzyme.Const
            ),
        )
        @test gradient(f, backend, θ) ≈ ref
    end
end

@testitem "A pool held in a view gets its gradient" tags = [:ad, :mooncake, :mooncake_reverse, :enzyme, :enzyme_reverse] begin
    using ComposableRecurrences
    using ComposableRecurrences: ComposableRecurrences as CR
    using ADTypes: AutoMooncake, AutoEnzyme, AutoForwardDiff
    using DifferentiationInterface: gradient
    import Enzyme, ForwardDiff, Mooncake
    # No pullback and a float-array field: routed to plain AD, which must
    # still give the pool its gradient.
    struct PoolDep{P}
        pop::P
    end
    CR.forward(m::PoolDep, ::CR.Init, s, history) = (s .= m.pop; nothing)
    CR.ispointwise(::PoolDep) = true
    function CR.forward(m::PoolDep, ::CR.Step, v, s, t, k)
        v′ = max(s / m.pop[k], 1.0e-6) * v
        return v′, s - v′
    end
    W = cos.(reshape(1:18, 3, 6))
    function f(θ)
        pop = view(exp.(θ) .* 50, 1:3)
        r = Recurrence([0.3, 0.2]; modifiers = (PoolDep(pop),))
        s = r(ones(3, 6); history = ones(3, 2))
        r2 = Recurrence([0.3, 0.2]; modifiers = (CR.Depletion(PerStratum(pop)),))
        return sum(W .* s) + sum(W .* r2(ones(3, 6); history = ones(3, 2)))
    end
    θ = [0.1, 0.2, 0.3]
    ref = gradient(f, AutoForwardDiff(), θ)
    @test all(!iszero, ref)
    for backend in (
            AutoMooncake(; config = nothing),
            AutoEnzyme(;
                mode = Enzyme.set_runtime_activity(Enzyme.Reverse),
                function_annotation = Enzyme.Const
            ),
        )
        @test gradient(f, backend, θ) ≈ ref
    end
end

@testitem "Mooncake tangent layout the rule reads (canary)" tags = [:ad, :mooncake, :mooncake_reverse] begin
    import Mooncake
    using SparseArrays, LinearAlgebra
    # The Mooncake rule reads struct fdata through `.data`, a view's parent
    # tangent through `.data.parent` and scalar fields as rdata. A Mooncake
    # release that changes these breaks the rule; this fails first.
    fd(x) = Mooncake.fdata(Mooncake.zero_tangent(x))
    @test fd(view(ones(4), 1:2)).data.parent isa Vector{Float64}
    @test fd(reshape(view(ones(4), 1:4), 2, 2)).data.parent.data.parent isa
        Vector{Float64}
    @test fd(sparse([1.0 0.0; 0.0 1.0])).data.nzval isa Vector{Float64}
    @test fd(Diagonal(ones(2))).data.diag isa Vector{Float64}
    @test fd((; a = ones(2), b = 1.0)) isa NamedTuple
    @test Mooncake.rdata_type(Mooncake.tangent_type(typeof(0.5I))) !== Mooncake.NoRData
    @test Mooncake.rdata_type(Mooncake.tangent_type(Vector{Float64})) === Mooncake.NoRData
end

@testitem "Mooncake rule route folds at compile time (allocation guard)" tags = [:ad, :mooncake, :mooncake_reverse] begin
    using ComposableRecurrences
    using ComposableRecurrences: ComposableRecurrences as CR
    using ADTypes: AutoMooncake
    using DifferentiationInterface: gradient!, prepare_gradient
    import Mooncake
    # A route that is not decided at compile time costs a dynamic dispatch
    # under Mooncake, which added about 330 allocations per gradient when it
    # regressed; folded, these cases allocate about 160 and 95.
    W = sin.(1:50)
    renewal(θ) = sum(
        W .* Recurrence(θ[1:5]; modifiers = (CR.Depletion(1.0e3; pool0 = 995.0),))(
            θ[6:55]; history = ones(5)
        )
    )
    delay(θ) = sum(W .* Convolution(θ[1:5])(θ[6:55]))
    backend = AutoMooncake(; config = nothing)
    for f in (renewal, delay)
        θ = [fill(0.2, 5); ones(50)]
        prep = prepare_gradient(f, backend, θ)
        grad = similar(θ)
        gradient!(f, grad, prep, backend, θ)
        @test (@allocations gradient!(f, grad, prep, backend, θ)) < 300
    end
end
