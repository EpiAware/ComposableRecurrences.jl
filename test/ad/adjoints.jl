# The native Mooncake and Enzyme rules: each backend's own rule tester via
# `test_adjoint` on the operator of every AD registry scenario and on shapes
# the registry lacks, proof that the rule fires, user-defined types with no
# AD code of their own, and the guard on plain Enzyme AD of a sparse
# coupling.

@testsnippet AdjointCases begin
    using ADFixtures
    import DifferentiationInterface
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

    # A negative binomial probability generating function for `Transform`.
    nb_pgf(q, θ) = (θ.p / (1 - (1 - θ.p) * q))^θ.r

    # A route that records the operator it reaches and the positional
    # arguments of its Run, then runs it as the operator itself would.
    struct Capture{O}
        op::O
        seen::Base.RefValue{Any}
    end
    (c::Capture)(args...; kwargs...) = CR._invoke(c.op, c, args...; kwargs...)
    function CR.with_state(c::Capture, args...; kwargs...)
        return CR._with_state(c.op, c, args...; kwargs...)
    end
    function CR.contributions(c::Capture, args...; kwargs...)
        return CR._contributions(c.op, c, args...; kwargs...)
    end
    CR._reroute(c::Capture, op) = Capture(op, c.seen)
    function CR.adjoint_call(c::Capture, args...)
        c.seen[] = (c.op, args)
        return CR.adjoint_call(c.op, args...)
    end

    # `x` with each view copied to an array of its own. The scenarios cut
    # their slots as views of one parameter vector, and the finite
    # differences EnzymeTestUtils takes read a view's parent.
    plain(x::Union{SubArray, Base.ReshapedArray}) = collect(x)
    plain(x::Diagonal) = Diagonal(plain(x.diag))
    plain(x::AbstractArray) = x
    plain(x::Union{Tuple, NamedTuple}) = map(plain, x)
    function plain(x)
        T = typeof(x)
        isstructtype(T) && fieldcount(T) > 0 || return x
        return CR.constructorof(T)(ntuple(i -> plain(getfield(x, i)), fieldcount(T))...)
    end

    # `(name, op, args)` for each AD registry scenario at its starting
    # parameters: the operator the scenario calls and its Run arguments.
    function registry_cases()
        return map(ADFixtures._SCENARIOS) do (name, f, θ0)
            seen = Ref{Any}(nothing)
            f(op -> Capture(op, seen), θ0())
            seen[] === nothing && error("scenario $(repr(name)) reached no rule through `Capture`")
            op, args = seen[]
            (name, plain(op), plain(args))
        end
    end

    # The positional arguments of a Recurrence's Run.
    function rec(gain, add, h; start = 1, states = nothing, stop = nothing)
        return (gain, add, h, states, start, stop)
    end

    # `(name, op, args)` for shapes no registry scenario has: user modifiers
    # with and without pullbacks, scalar gains, short seeds, `Transform`
    # forms, and the shapes of the use cases (random walk, AR(2),
    # time-varying AR, seeded renewal, patch models and strata renewals with
    # imports, doses or a protected pool).
    function extra_cases()
        rng = Xoshiro(11)
        S, L, T = 3, 3, 6
        g = rand(rng, L) ./ 2
        K = rand(rng, S, S) ./ 2
        h = 1 .+ rand(rng, S, L)
        R = 0.5 .+ rand(rng, S, T)
        Ks = sparse([0.5 0.0 0.2; 0.1 0.6 0.0; 0.0 0.3 0.4])
        cases = [
            (
                "renewal, one series, Float32",
                Recurrence(Float32.(g)), rec(Float32.(R[1, :]), nothing, Float32.(h[1, :])),
            ),
            (
                "strata, mixed eltypes, Float32 history",
                Recurrence(Float32.(g); coupling = K), rec(R, nothing, Float32.(h)),
            ),
            ("sparse coupling with an add input", Recurrence(g; coupling = Ks), rec(R, copy(R), h)),
            ("scalar gain and λ I", Recurrence(g; coupling = 0.7I), rec(0.9, R, h)),
            (
                "time-varying kernel and coupling from a later start",
                Recurrence(
                    TimeVarying(rand(rng, L, T));
                    coupling = TimeVarying(rand(rng, S, S, T) ./ 2)
                ),
                rec(R, nothing, h; start = 3),
            ),
            (
                "Primary time-varying kernel, one series",
                Recurrence(TimeVarying(rand(rng, L, T), CR.Primary())),
                rec(R[1, :], nothing, h[1, :]; start = L + 1),
            ),
            (
                "Primary pairwise kernel, short seed",
                Recurrence(TimeVarying(Pairwise(rand(rng, S, S, L, T) ./ 3), CR.Primary())),
                rec(R, nothing, h[:, 1:2]; start = 3),
            ),
            (
                "routes: per-stratum, pairwise and Primary kernels",
                Recurrence(
                    Routes(
                        (0.7I, PerStratum(rand(rng, S, 2) ./ 2)),
                        (Diagonal(rand(rng, S)), Pairwise(rand(rng, S, S, L) ./ 3)),
                        (
                            TimeVarying(rand(rng, S, S, T) ./ 2),
                            TimeVarying(rand(rng, L, T), CR.Primary()),
                        ),
                    ); modifiers = (Hazard(60.0),)
                ),
                rec(R, nothing, h; start = L + 1),
            ),
            (
                "routes with state, sparse coupling",
                CR._WithState(Recurrence(Routes((Ks, g), (K, g[1:2])))),
                rec(R, nothing, h),
            ),
            (
                "user modifiers",
                Recurrence(
                    g; coupling = K,
                    modifiers = (PoolDepletion([30.0, 40.0, 50.0]), Hazard(60.0))
                ),
                rec(R, nothing, h),
            ),
            (
                "with state, user modifier",
                CR._WithState(Recurrence(g; coupling = K, modifiers = (Hazard(60.0),))),
                rec(R, nothing, h),
            ),
            (
                "Transform, scalar parameters",
                Recurrence([1.0]; modifiers = (CR.Transform(nb_pgf, (; r = 0.5, p = 0.4)),)),
                rec(true, nothing, [0.1]; stop = T),
            ),
            (
                "Transform, per-stratum and time-varying parameters",
                Recurrence(
                    g; coupling = K, modifiers = (
                        CR.Transform(
                            nb_pgf, (;
                                r = PerStratum([0.5, 0.7, 0.9]),
                                p = TimeVarying(0.2 .+ 0.5 .* rand(rng, T)),
                            )
                        ),
                    )
                ),
                rec(R ./ 4, nothing, h ./ 4),
            ),
            (
                "Transform, no parameter and a supplied derivative",
                Recurrence(
                    g; coupling = K, modifiers = (
                        CR.Transform(log1p), CR.Transform(sqrt; derivative = v -> 1 / (2sqrt(v))),
                    )
                ),
                rec(R, nothing, h),
            ),
            (
                "time-varying per-stratum delay from a later start",
                Convolution(TimeVarying(PerStratum(rand(rng, S, 4, T)))),
                (R, true, nothing, h, 4, nothing),
            ),
            (
                "delay with gain and add",
                Convolution(rand(rng, 4)), (R, rand(rng, T), rand(rng, S, T), h, 2, nothing),
            ),
            (
                "lag contributions, ragged",
                CR._Contributions(Convolution(TimeVarying([rand(rng, mod(τ, 4)) for τ in 1:T]))),
                (R[1, :], rand(rng, T), h[1, :], 2, nothing),
            ),
        ]
        rng = Xoshiro(21)
        S, L, T = 3, 4, 8
        g = rand(rng, L) ./ 2
        K = [0.0 0.2 0.1; 0.1 0.0 0.3; 0.2 0.1 0.0]
        h = 1 .+ rand(rng, S, L)
        R = 0.5 .+ rand(rng, S, T)
        ϵ = randn(rng, T)
        pool(N, h::AbstractVector) = N - sum(h)
        pool(N, h::AbstractMatrix) = PerStratum(N .- vec(sum(h; dims = 2)))
        return vcat(
            cases, [
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
        )
    end

    # Every operator `test_adjoint` checks: the registry's, then the extras.
    adjoint_cases() = [registry_cases(); extra_cases()]

    # EnzymeTestUtils checks the rule against finite differences taken in
    # the arguments' precision. In single precision these differ from the
    # rule by up to about 5e-4 relative (on a Float32 history with Float64
    # gains), so cases with Float32 values compare at 1e-3.
    const FLOAT32_RTOL = 1.0e-3

    # Each registry scenario's gradient on `backend` runs the analytic
    # reverse pass, and no `NoAdjoint` twin's does. The counter is reset per
    # scenario. In one CI job the gradients reuse the code the backend's
    # registry item compiled.
    function test_rules_fire(name, backend)
        skip = get(ADFixtures.backend_skip_scenarios(), name, Set{String}())
        for scen in ADFixtures.scenarios()
            scen.name in skip && continue
            @testset "$(scen.name)" begin
                CR._PULLBACK_CALLS[] = 0
                DifferentiationInterface.gradient(scen.f, backend, scen.x)
                @test (CR._PULLBACK_CALLS[] > 0) == !startswith(scen.name, "NoAdjoint")
            end
        end
        return nothing
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
            rtol = occursin(r"Float32|mixed", name) ? FLOAT32_RTOL : 1.0e-7
            CR.test_adjoint(AutoEnzyme(), op, CR.Run(), args...; rtol, atol = rtol)
        end
    end
end

@testitem "Mooncake reverse: every AD scenario fires its rule and no twin does" tags = [:ad, :mooncake, :mooncake_reverse] setup = [AdjointCases] begin
    using ADTypes: AutoMooncake
    import Mooncake
    test_rules_fire("Mooncake reverse", AutoMooncake(; config = nothing))
end

@testitem "Enzyme reverse: every AD scenario fires its rule and no twin does" tags = [:ad, :enzyme, :enzyme_reverse] setup = [AdjointCases] begin
    using ADTypes: AutoEnzyme
    import Enzyme
    test_rules_fire(
        "Enzyme reverse",
        AutoEnzyme(;
            mode = Enzyme.set_runtime_activity(Enzyme.Reverse),
            function_annotation = Enzyme.Const
        )
    )
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
    # Two groups of strata with totals over time: the totals and the gains
    # get cotangents.
    W2, h2 = randn(rng, 3, 4), 1 .+ rand(rng, 3, 3)
    split(θ) = CR.Allocate([[1, 3], [2]], TimeVarying(PerStratum(reshape(θ[1:8], 2, 4))))
    allocate(θ) = sum(
        W2 .* Recurrence(g; modifiers = (split(θ),))(reshape(θ[9:end], 3, 4); history = h2)
    )
    allocate_na(θ) = sum(
        W2 .* NoAdjoint(Recurrence(g; modifiers = (split(θ),)))(
            reshape(θ[9:end], 3, 4); history = h2
        )
    )
    for (f, θ, fires) in (
                (renewal, [50.0; 1 .+ rand(rng, 8)], true),
                (renewal_na, [50.0; 1 .+ rand(rng, 8)], false),
                (delay, rand(rng, 11), true), (delay_na, rand(rng, 11), false),
                (allocate, 1 .+ rand(rng, 20), true),
                (allocate_na, 1 .+ rand(rng, 20), false),
            ),
            backend in backends
        ref = gradient(f, AutoForwardDiff(), θ)
        n0 = CR._PULLBACK_CALLS[]
        @test gradient(f, backend, θ) ≈ ref
        @test (CR._PULLBACK_CALLS[] > n0) == fires
    end
end

@testitem "Transform: the rule runs unless the map has float fields" tags = [:ad, :mooncake, :mooncake_reverse, :enzyme, :enzyme_reverse] setup = [AdjointCases] begin
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
    W = [cos(a * t) for a in 1:2, t in 1:8]
    K = [0.8 0.2; 0.3 0.7]
    function run(w, m)
        r = Recurrence([0.6, 0.3]; coupling = K, modifiers = (m,))
        return sum(W .* w(r)(fill(1.1, 2, 8); history = fill(0.2, 2, 2)))
    end
    # Parameters in θ: per stratum, time-varying and scalar.
    θm(θ) = CR.Transform(
        nb_pgf, (; r = PerStratum(θ[1:2]), p = TimeVarying(θ[3:10]))
    )
    # A closure's captured value is not in θ, so plain AD takes it.
    shift(b) = (v, a) -> a * v + b
    cm(θ) = CR.Transform(shift(θ[1]), θ[2])
    θ0 = [0.5, 0.8, collect(range(0.2, 0.6; length = 8))...]
    for (m, θ, fires) in ((θm, θ0, true), (cm, [0.1, 0.9], false)), w in (identity, NoAdjoint)
        f(θ) = run(w, m(θ))
        ref = gradient(f, AutoForwardDiff(), θ)
        for backend in backends
            n0 = CR._PULLBACK_CALLS[]
            @test gradient(f, backend, θ) ≈ ref
            @test (CR._PULLBACK_CALLS[] > n0) == (fires && w === identity)
        end
    end
end

@testitem "Derived: the rule runs unless the map has float fields" tags = [:ad, :mooncake, :mooncake_reverse, :enzyme, :enzyme_reverse] setup = [AdjointCases] begin
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
    W = [cos(a * t) for a in 1:2, t in 1:8]
    K = [0.8 0.2; 0.3 0.7]
    function run(w, m)
        r = Recurrence([0.6, 0.3]; coupling = K, modifiers = (m,))
        return sum(W .* w(r)(fill(1.1, 2, 8); history = fill(0.2, 2, 2)))
    end
    # A scalar times a function of a time-varying parameter.
    θm(θ) = CR.Add(θ[1] * Derived(exp, TimeVarying(θ[2:9])))
    # A closure's captured value is not an argument, so plain AD takes it.
    scaled(c) = x -> c * exp(x)
    cm(θ) = CR.Add(Derived(scaled(θ[1]), TimeVarying(θ[2:9])))
    θ0 = [0.5, collect(range(-0.2, 0.6; length = 8))...]
    for (m, fires) in ((θm, true), (cm, false)), w in (identity, NoAdjoint)
        f(θ) = run(w, m(θ))
        ref = gradient(f, AutoForwardDiff(), θ0)
        for backend in backends
            n0 = CR._PULLBACK_CALLS[]
            @test gradient(f, backend, θ0) ≈ ref
            @test (CR._PULLBACK_CALLS[] > n0) == (fires && w === identity)
        end
    end
end

@testitem "User modifiers: functions, index ranges and constructors" tags = [:ad, :mooncake, :mooncake_reverse, :enzyme, :enzyme_reverse] begin
    using ComposableRecurrences
    using ComposableRecurrences: ComposableRecurrences as CR
    using ADTypes: AutoMooncake, AutoEnzyme
    using DifferentiationInterface: gradient
    import Enzyme, Mooncake
    using ComposableRecurrences: NoAdjoint
    # A pointwise modifier with no pullback that maps the value through a
    # stored function and scales it by `a`.
    struct MapBy{F, T}
        f::F
        a::T
    end
    CR.ispointwise(::MapBy) = true
    CR.forward(m::MapBy, ::CR.Step, v, s, t, k) = (m.a * m.f(v), s)
    # A closure's captured value is a parameter the local derivative does not
    # reach, so the operator takes plain AD; a plain function keeps the rule.
    scale(b) = x -> b * x
    # Pointwise modifiers that scale the strata in index ranges.
    struct Pick{I, T}
        idx::I
        a::T
    end
    CR.ispointwise(::Pick) = true
    _in(k, idx) = k in idx
    _in(k, idx::AbstractVector{<:AbstractVector}) = any(i -> k in i, idx)
    CR.forward(m::Pick, ::CR.Step, v, s, t, k) = (_in(k, m.idx) ? m.a * v : v, s)
    backends = (
        AutoMooncake(; config = nothing),
        AutoEnzyme(;
            mode = Enzyme.set_runtime_activity(Enzyme.Reverse),
            function_annotation = Enzyme.Const
        ),
    )
    W = cos.(reshape(1:18, 3, 6))
    function run(w, m, θ)
        r = Recurrence([0.3, 0.2]; modifiers = (m,))
        return sum(W .* w(r)(θ .* ones(3, 6); history = ones(3, 2)))
    end
    # Scalar modifiers the default pullback cannot rebuild with dual numbers
    # by `constructorof`: a keyword-only constructor, a field typed
    # `Float64`, and a constructor that transforms its argument. The
    # `Recurrence` constructor finds each by value, so `uses_adjoint` is
    # false for them.
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
    for M in (ScaleKw, ScaleF, Doubled)
        @eval CR.ispointwise(::$M) = true
        @eval CR.forward(m::$M, ::CR.Step, v, s, t, k) = (m.a * v, s)
    end
    # Depletion forms with no pullback: the local derivative covers them.
    struct Linear end
    CR.forward(::Linear, ::CR.Step, v, s, N, α) = (y = v * max(s, 0) / N; (y, s - y))
    struct LinearRate{T}
        c::T
    end
    function CR.forward(f::LinearRate, ::CR.Step, v, s, N, α)
        y = f.c * v * max(s, 0)^α / N
        return y, s - y
    end
    struct DoubledRate{T}
        c::T
        DoubledRate(c::T) where {T} = new{T}(2c)
    end
    CR.forward(f::DoubledRate, ::CR.Step, v, s, N, α) = CR.forward(LinearRate(f.c), CR.Step(), v, s, N, α)
    # `(modifier, uses_adjoint, rule fires)`.
    cases = (
        (θ -> MapBy(scale(θ), 0.9), false, false),
        (θ -> MapBy(sqrt, θ), true, true),
        (θ -> Pick(2:3, θ), true, true),
        (θ -> Pick(1:2:3, θ), true, true),
        (θ -> Pick([1:1, 3:3], θ), true, true),
        (θ -> Pick([1, 3], θ), true, true),
        (θ -> ScaleKw(; a = θ), false, false),
        (θ -> ScaleF(θ), false, false),
        (θ -> Doubled(θ), false, false),
        (θ -> CR.Depletion(100 * θ, Linear()), true, true),
        (θ -> CR.Depletion(100.0, LinearRate(θ); heterogeneity = 1.1), true, true),
        (θ -> CR.Depletion(100.0, Linear(); removals = θ), true, true),
        (θ -> CR.Depletion(100.0, DoubledRate(θ)), false, false),
    )
    for (m, adj, fires) in cases, w in (identity, NoAdjoint)
        @test CR.uses_adjoint(Recurrence([0.3]; modifiers = (m(0.8),)), CR.Run()) == adj
        f(θ) = run(w, m(θ[1]), θ[2])
        θ = [0.8, 1.1]
        # Central differences: a field typed `Float64` cannot hold the
        # dual numbers of ForwardDiff.
        e(i) = 1.0e-6 .* (1:2 .== i)
        ref = [(f(θ + e(i)) - f(θ - e(i))) / 2.0e-6 for i in 1:2]
        @test all(!iszero, ref)
        for backend in backends
            n0 = CR._PULLBACK_CALLS[]
            @test gradient(f, backend, θ) ≈ ref rtol = 1.0e-6
            @test (CR._PULLBACK_CALLS[] > n0) == (fires && w === identity)
        end
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
    ) == [Val{:rule}]
    @test Base.return_types(
        CR._route_val, (UserPkg.DecayNoPB{Float64}, Float64, Vector{Float64})
    ) == [Val{:plain}]
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
    # A sparse route coupling, after a dense route, is refused too.
    rr = Recurrence(Routes((fill(0.2, 3, 3), [0.1]), (K, [0.3, 0.2])))
    @test_throws "plain Enzyme reverse AD of a sparse coupling" Enzyme.gradient(
        mode, Enzyme.Const(f), rr
    )
    froutes(nz) = g(
        Recurrence(
            Routes(
                (fill(0.2, 3, 3), [0.1]),
                (SparseMatrixCSC(3, 3, K.colptr, K.rowval, nz), [0.3, 0.2])
            )
        )
    )
    @test Enzyme.gradient(mode, Enzyme.Const(g), rr)[1].kernel.couplings[2].nzval ≈
        ForwardDiff.gradient(froutes, copy(K.nzval))
    # In any route, here the ninth.
    r9 = Recurrence(Routes(ntuple(_ -> (fill(0.02, 3, 3), [0.1]), 8)..., (K, [0.3, 0.2])))
    @test_throws "plain Enzyme reverse AD of a sparse coupling" Enzyme.gradient(
        mode, Enzyme.Const(f), r9
    )
    # A constant sparse route coupling is differentiated by plain AD.
    fk(gk) = sum(NoAdjoint(Recurrence(Routes((fill(0.2, 3, 3), [0.1]), (K, gk))))(R; history = h))
    @test Enzyme.gradient(mode, Enzyme.Const(fk), [0.3, 0.2])[1] ≈
        ForwardDiff.gradient(fk, [0.3, 0.2])
    # The same as the ninth route, with the gain and history active too, so
    # the cotangent reaches the buffer through the constant coupling.
    dense8 = ntuple(_ -> (fill(0.02, 3, 3), [0.1]), 8)
    function f9(θ)
        gk, Rθ, hθ = θ[1:2], reshape(θ[3:17], 3, 5), reshape(θ[18:23], 3, 2)
        r = NoAdjoint(Recurrence(Routes(dense8..., (K, gk))))
        return sum(abs2, r(Rθ; history = hθ))
    end
    θ9 = [0.3; 0.2; vec(0.5 .+ 0.1 .* R); vec(h)]
    @test Enzyme.gradient(mode, Enzyme.Const(f9), θ9)[1] ≈ ForwardDiff.gradient(f9, θ9)
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

@testitem "Empty protected pools: rules match ForwardDiff" tags = [:ad, :mooncake, :mooncake_reverse, :enzyme, :enzyme_reverse] begin
    using ComposableRecurrences
    using ComposableRecurrences: ComposableRecurrences as CR
    using ADTypes: AutoMooncake, AutoEnzyme, AutoForwardDiff
    using DifferentiationInterface: gradient
    import Enzyme, ForwardDiff, Mooncake
    # Both pools start empty with sizes set by parameters, so the combined
    # pool is zero with a non-zero ForwardDiff tangent at every step.
    W = collect(range(0.5, 1.5; length = 6))
    function f(θ)
        d = CR.Depletion(
            100.0; pool0 = θ[1], protected = CR.Protected(θ[2]; pool0 = θ[3])
        )
        r = Recurrence([0.3, 0.5, 0.2]; modifiers = (d,))
        return sum(W .* r(fill(2.0, 6); history = [5.0]))
    end
    θ = [0.0, 0.3, 0.0]
    ref = gradient(f, AutoForwardDiff(), θ)
    @test all(isfinite, ref)
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

@testitem "Empty pools with removals or a dual population: rules match ForwardDiff" tags = [:ad, :mooncake, :mooncake_reverse, :enzyme, :enzyme_reverse] begin
    using ComposableRecurrences
    using ComposableRecurrences: ComposableRecurrences as CR
    using ADTypes: AutoMooncake, AutoEnzyme, AutoForwardDiff
    using DifferentiationInterface: gradient
    import Enzyme, ForwardDiff, Mooncake
    W = collect(range(0.5, 1.5; length = 6))
    function total(d)
        r = Recurrence([0.3, 0.5, 0.2]; modifiers = (d,))
        return sum(W .* r(fill(2.0, 6); history = [5.0]))
    end
    # A seeded pool emptied by removals: with all-or-nothing protection the
    # pool stays at zero with a tangent from `σ`, a tie in the removal.
    by_removals(θ) = total(
        CR.Depletion(
            100.0; pool0 = θ[1], removals = TimeVarying(fill(θ[2], 6)),
            protected = CR.Protected(θ[3])
        )
    )
    # An empty pool with a dual population and an integer heterogeneity,
    # alone and with a protected pool.
    by_population(θ) = total(CR.Depletion(θ[1]; heterogeneity = 2, pool0 = θ[2]))
    by_protected(θ) = total(
        CR.Depletion(θ[1]; pool0 = θ[2], protected = CR.Protected(θ[3]))
    )
    # A differentiated heterogeneity at an empty pool.
    by_heterogeneity(θ) = total(CR.Depletion(100.0; heterogeneity = θ[1], pool0 = θ[2]))
    cases = (
        (by_removals, [3.0, 4.0, 0.0]), (by_population, [100.0, 0.0]),
        (by_protected, [100.0, 0.0, 0.3]), (by_heterogeneity, [1.0, 0.0]),
    )
    for (f, θ) in cases
        ref = gradient(f, AutoForwardDiff(), θ)
        @test all(isfinite, ref)
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

@testitem "Plain-AD note logs once under reverse-mode AD" tags = [:ad, :mooncake, :mooncake_reverse, :enzyme, :enzyme_reverse] begin
    using ComposableRecurrences
    using ComposableRecurrences: ComposableRecurrences as CR
    using ADTypes: AutoMooncake, AutoEnzyme
    using DifferentiationInterface: gradient
    import Enzyme, Mooncake
    # Pointwise modifiers whose float field is typed `Float64`, so the
    # operator takes plain AD; one type per backend, as the note is logged
    # once per operator type.
    struct ScaleM
        a::Float64
    end
    struct ScaleE
        a::Float64
    end
    for M in (ScaleM, ScaleE)
        @eval CR.ispointwise(::$M) = true
        @eval CR.forward(m::$M, ::CR.Step, v, s, t, k) = (m.a * v, s)
    end
    for (M, backend) in (
            (ScaleM, AutoMooncake(; config = nothing)),
            (
                ScaleE,
                AutoEnzyme(;
                    mode = Enzyme.set_runtime_activity(Enzyme.Reverse),
                    function_annotation = Enzyme.Const
                ),
            ),
        )
        f(θ) = sum(Recurrence([0.3, 0.2]; modifiers = (M(0.9),))(θ; history = ones(2)))
        θ = ones(4)
        # The primal call logs nothing; the first gradient logs once.
        @test_logs f(θ)
        empty!(CR._PLAIN_NOTED)
        g = @test_logs (:info, r"plain AD of the whole operator") match_mode = :any gradient(f, backend, θ)
        @test all(isfinite, g)
        @test_logs gradient(f, backend, θ)
    end
end

@testitem "Local coupling step: the rule and its limits" tags = [:ad, :mooncake, :mooncake_reverse, :enzyme, :enzyme_reverse] begin
    using ComposableRecurrences
    using ComposableRecurrences: ComposableRecurrences as CR, NoAdjoint
    using ADTypes: AutoMooncake, AutoEnzyme, AutoForwardDiff
    using DifferentiationInterface: gradient
    import Enzyme, ForwardDiff, Mooncake
    backends = (
        AutoMooncake(; config = nothing),
        AutoEnzyme(;
            mode = Enzyme.set_runtime_activity(Enzyme.Reverse),
            function_annotation = Enzyme.Const
        ),
    )
    # A coupling without a pullback: the strata average, weighted by `a`.
    struct Blend{A}
        a::A
    end
    function CR.forward(C::Blend, ::CR.Pressure, q, p, t)
        m = sum(p) / length(p)
        q .= (1 - C.a) .* p .+ C.a * m
        return nothing
    end
    # A pointwise modifier with a per-stratum parameter and no pullback.
    struct Cap{K}
        κ::K
    end
    CR.ispointwise(::Cap) = true
    CR.forward(m::Cap, ::CR.Step, v, s, t, k) = (v / (1 + v / CR.param(m.κ, k, t)), s)
    function loss(w, θ, S)
        W = [cos(a * t) for a in 1:S, t in 1:6]
        r = Recurrence([0.3, 0.2]; coupling = Blend(θ[1]), modifiers = (Cap(θ[2]),))
        return sum(W .* w(r)(fill(1.1, S, 6); history = ones(S, 2)))
    end
    function loss_strata(w, θ, S)
        W = [cos(a * t) for a in 1:S, t in 1:6]
        r = Recurrence([0.3, 0.2]; coupling = Blend(θ[1]), modifiers = (Cap(PerStratum(θ[2:(S + 1)])),))
        return sum(W .* w(r)(fill(1.1, S, 6); history = ones(S, 2)))
    end
    # Blend's local step fires up to 11 strata (with its one scalar); the
    # per-stratum parameter sends the operator to plain AD at any size.
    for (L, S, fires) in ((loss, 3, true), (loss, 11, true), (loss, 12, false), (loss_strata, 3, false))
        θ = L === loss ? [0.4, 5.0] : [0.4; fill(5.0, S)]
        for w in (identity, NoAdjoint)
            f(θ) = L(w, θ, S)
            ref = gradient(f, AutoForwardDiff(), θ)
            for backend in backends
                n0 = CR._PULLBACK_CALLS[]
                @test gradient(f, backend, θ) ≈ ref
                @test (CR._PULLBACK_CALLS[] > n0) == (fires && w === identity)
            end
        end
    end
end
