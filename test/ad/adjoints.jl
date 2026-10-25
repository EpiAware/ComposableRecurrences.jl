# The native Mooncake and Enzyme rules: each backend's own rule tester via
# `test_adjoint` on the operator of every AD registry scenario and on shapes
# the registry lacks, proof that the rule fires, user-defined types with no
# AD code of their own, and the guard on plain Enzyme AD of a sparse
# coupling.

@testsnippet AdjointCases begin
    using ADFixtures
    import DifferentiationInterface
    using Test: Test
    using ComposableRecurrences
    using ComposableRecurrences: ComposableRecurrences as CR
    using LinearAlgebra, Random, SparseArrays

    # Pointwise hazard depletion with a scalar pool, a hand-written in-place
    # pullback and a pooled initial state.
    struct Hazard{T}
        N::T
    end
    CR.blocks(::Hazard) = (1, 1)
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

    # Floored depletion from a per-stratum pool, no pullback of its own.
    struct PoolDepletion{P}
        pop::P
    end
    CR.blocks(::PoolDepletion) = (1, 1)
    CR.forward!(m::PoolDepletion, ::CR.Init, s, history) = (s .= m.pop; nothing)
    function CR.forward!(m::PoolDepletion, ::CR.Step, v, s, t)
        for k in eachindex(v, s)
            v′ = max(s[k] / m.pop[k], 1.0e-6) * v[k]
            v[k], s[k] = v′, s[k] - v′
        end
        return nothing
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
    # The walk does not specialise on `x`: inferring it for each nested
    # type of a deep operator, such as a depletion's tuple of flows, took
    # minutes on Julia 1.13.
    function plain(@nospecialize x)
        T = typeof(x)
        isstructtype(T) && fieldcount(T) > 0 || return x
        fields = Any[plain(getfield(x, i)) for i in 1:fieldcount(T)]
        return CR.constructorof(T)(fields...)
    end

    # `(name, op, args, rtol)` for each AD registry scenario at its starting
    # parameters: the operator the scenario calls, its Run arguments and the
    # tolerance the entry gives Enzyme's rule tester.
    function registry_cases()
        return map(ADFixtures._SCENARIOS) do entry
            name, f, θ0 = entry
            seen = Ref{Any}(nothing)
            f(op -> Capture(op, seen), θ0())
            seen[] === nothing && error("scenario $(repr(name)) reached no rule through `Capture`")
            op, args = seen[]
            (name, plain(op), plain(args), ADFixtures.enzyme_rtol(entry))
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
    # imports, doses or a protected pool). Cases with single-precision
    # values carry the Float32 tolerance as a fourth element.
    function extra_cases()
        rng = Xoshiro(11)
        S, L, T = 3, 3, 6
        g = rand(rng, L) ./ 2
        K = rand(rng, S, S) ./ 2
        h = 1 .+ rand(rng, S, L)
        R = 0.5 .+ rand(rng, S, T)
        Ks = sparse([0.5 0.0 0.2; 0.1 0.6 0.0; 0.0 0.3 0.4])
        f32 = ADFixtures._F32
        cases = [
            (
                "renewal, one series, Float32",
                Recurrence(Float32.(g)), rec(Float32.(R[1, :]), nothing, Float32.(h[1, :])),
                f32,
            ),
            (
                "strata, mixed eltypes, Float32 history",
                Recurrence(Float32.(g); coupling = K), rec(R, nothing, Float32.(h)),
                f32,
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
            # A late start leaves the inputs no output reads out of the
            # buffer: all of the history, or all but its last times.
            (
                "delay from a start past the history",
                Convolution(rand(rng, 3)), (R, true, nothing, h, 5, nothing),
            ),
            (
                "delay with part of the history in reach",
                Convolution(rand(rng, 3)), (R[1, :], true, nothing, h[1, :], 2, nothing),
            ),
            (
                "time-varying delay indexed by input from a late start",
                Convolution(TimeVarying(rand(rng, 3, T), CR.Primary())),
                (R, true, nothing, nothing, 4, nothing),
            ),
            (
                "lag contributions from a late start",
                CR._Contributions(Convolution(rand(rng, 3))), (R, true, h, 5, nothing),
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
                    Recurrence(
                        g; modifiers = (CR.Depletion(60.0; pools = (S = pool(60.0, h[1, :]),)),)
                    ),
                    rec(R[1, :], nothing, h[1, :]),
                ),
                (
                    "patch model",
                    Recurrence(
                        g; modifiers = (
                            ADFixtures._leaky(CR.movement(K, 0.4)),
                            CR.Depletion(
                                PerStratum(fill(80.0, S)); pools = (S = pool(80.0, h),)
                            ),
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
                        g; modifiers = (
                            ADFixtures._leaky(sparse(CR.movement(K, [0.4, 0.3, 0.2]))),
                        )
                    ),
                    rec(R, nothing, h),
                ),
                (
                    "strata renewal with doses removed",
                    Recurrence(
                        g; modifiers = (
                            CR.Depletion(
                                PerStratum(fill(80.0, S)), CR.Hazard(),
                                CR.Flow(
                                    :S => 0, TimeVarying(PerStratum(0.5 .+ rand(rng, S, T)));
                                    form = CR.Truncate()
                                )
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
                                PerStratum(fill(80.0, S)),
                                CR.Hazard(;
                                    weights = (S = 1, V = PerStratum([0.2, 0.3, 0.4]))
                                ),
                                CR.Flow(
                                    1 => 2, TimeVarying(PerStratum(0.5 .+ rand(rng, S, T)));
                                    form = CR.Truncate()
                                ); pools = (S = pool(80.0, h), V = 1.0)
                            ),
                        )
                    ),
                    rec(R, nothing, h),
                ),
            ]
        )
    end

    # Every operator `test_adjoint` checks, as `(name, op, args, rtol)`: the
    # registry's, then the extras. An extra with single-precision values
    # carries the Float32 tolerance as a fourth element, as a registry entry
    # does (see `ADFixtures.enzyme_rtol`).
    function adjoint_cases()
        extras = map(extra_cases()) do case
            (case[1], case[2], case[3], ADFixtures.enzyme_rtol(case))
        end
        return [registry_cases(); extras]
    end

    # Runs `check()` in a testset named `label`, for the backend named
    # `name`. A registry scenario marked broken there runs in a testset that
    # only records whether every check passed, as one `@test_broken` while
    # it fails.
    function scenario_testset(check, name, label)
        broken = get(ADFixtures.backend_broken_scenarios(), name, Set{String}())
        if label in broken || label in ADFixtures.broken_scenario_names()
            probe = @testset Probe "$label" begin
                check()
            end
            probe.ok ? (@test probe.ok) : (@test_broken probe.ok)
        else
            @testset "$label" begin
                check()
            end
        end
        return nothing
    end

    # Runs `test_adjoint` on `case` for the backend named `name`.
    function test_adjoint_case(name, backend, case; kwargs...)
        label, op, args = case
        scenario_testset(name, label) do
            CR.test_adjoint(backend, op, CR.Run(), args...; kwargs...)
        end
        return nothing
    end

    # A testset that records whether every result in it passed or was
    # marked broken, and reports nothing to a parent of another type. A
    # testset nested in it without a type of its own is also a `Probe`, and
    # passes its result up.
    mutable struct Probe <: Test.AbstractTestSet
        description::String
        ok::Bool
    end
    Probe(description; kwargs...) = Probe(description, true)
    _passed(r::Test.Result) = r isa Union{Test.Pass, Test.Broken}
    _passed(ts::Test.DefaultTestSet) = all(_passed, ts.results)
    _passed(ts::Probe) = ts.ok
    Test.record(ts::Probe, r::Union{Test.Result, Test.AbstractTestSet}) =
        (ts.ok &= _passed(r); r)
    function Test.finish(ts::Probe)
        if Test.get_testset_depth() > 0
            parent = Test.get_testset()
            parent isa Probe && Test.record(parent, ts)
        end
        return ts
    end

    # Each registry scenario's gradient on `backend` runs the analytic
    # reverse pass, and no `NoAdjoint` twin's does, nor a scenario that
    # takes plain AD on the backend by design. The counter is reset per
    # scenario. In one CI job the gradients reuse the code the backend's
    # registry item compiled. A scenario marked broken on the backend is
    # recorded as broken while it fails, as in `test_adjoint_case`.
    function test_rules_fire(name, backend)
        skip = get(ADFixtures.backend_skip_scenarios(), name, Set{String}())
        plain = get(ADFixtures.backend_plain_scenarios(), name, Set{String}())
        for scen in ADFixtures.scenarios()
            scen.name in skip && continue
            rule = !startswith(scen.name, "NoAdjoint") && !(scen.name in plain)
            scenario_testset(name, scen.name) do
                CR._PULLBACK_CALLS[] = 0
                DifferentiationInterface.gradient(scen.f, backend, scen.x)
                @test (CR._PULLBACK_CALLS[] > 0) == rule
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
    function CR.forward!(m::Saturate, ::CR.Step, v, s, t)
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
    function CR.forward!(m::SaturateNoPB, ::CR.Step, v, s, t)
        return CR.forward!(Saturate(m.K), CR.Step(), v, s, t)
    end

    # q = β ⊙ (K p).
    struct Mix{M, V}
        K::M
        β::V
    end
    function CR.forward!(C::Mix, ::CR.Pressure, q, p, t)
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
    function CR.forward!(C::MixNoPB, ::CR.Pressure, q, p, t)
        return CR.forward!(Mix(C.K, C.β), CR.Pressure(), q, p, t)
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
    for case in adjoint_cases()
        test_adjoint_case("Mooncake reverse", AutoMooncake(; config = nothing), case)
    end
end

# Tagged `compat_floor`, so the Threads workflow runs it on Julia 1.11.
@testitem "Enzyme: test_adjoint on each operator" tags = [:ad, :enzyme, :enzyme_reverse, :compat_floor] setup = [AdjointCases] begin
    using ADTypes: AutoEnzyme
    import Enzyme, EnzymeTestUtils
    for case in adjoint_cases()
        rtol = last(case)
        test_adjoint_case("Enzyme reverse", AutoEnzyme(), case; rtol, atol = rtol)
    end
end

@testitem "Mooncake reverse: every AD scenario fires its rule and no twin does" tags = [:ad, :mooncake, :mooncake_reverse] setup = [AdjointCases] begin
    using ADTypes: AutoMooncake
    import Mooncake
    test_rules_fire("Mooncake reverse", AutoMooncake(; config = nothing))
end

# Tagged `compat_floor`, so the Threads workflow runs it on Julia 1.11.
@testitem "Enzyme reverse: every AD scenario fires its rule and no twin does" tags = [:ad, :enzyme, :enzyme_reverse, :compat_floor] setup = [AdjointCases] begin
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

@testitem "Rules fire through the public call" tags = [:ad, :mooncake, :mooncake_reverse, :enzyme, :enzyme_reverse] setup = [AdjointCases, JobBackends] begin
    using ADTypes: AutoMooncake, AutoEnzyme, AutoForwardDiff
    using DifferentiationInterface: gradient
    import Mooncake, Enzyme, ForwardDiff
    using ComposableRecurrences: NoAdjoint
    backends = job_backends(
        :mooncake_reverse => AutoMooncake(; config = nothing),
        :enzyme_reverse => AutoEnzyme(;
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

@testitem "Transform: the rule runs unless the map has float fields" tags = [:ad, :mooncake, :mooncake_reverse, :enzyme, :enzyme_reverse] setup = [AdjointCases, JobBackends] begin
    using ADTypes: AutoMooncake, AutoEnzyme, AutoForwardDiff
    using DifferentiationInterface: gradient
    import Mooncake, Enzyme, ForwardDiff
    using ComposableRecurrences: NoAdjoint
    backends = job_backends(
        :mooncake_reverse => AutoMooncake(; config = nothing),
        :enzyme_reverse => AutoEnzyme(;
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

@testitem "Derived: the rule runs unless the map has float fields" tags = [:ad, :mooncake, :mooncake_reverse, :enzyme, :enzyme_reverse] setup = [AdjointCases, JobBackends] begin
    using ADTypes: AutoMooncake, AutoEnzyme, AutoForwardDiff
    using DifferentiationInterface: gradient
    import Mooncake, Enzyme, ForwardDiff
    using ComposableRecurrences: NoAdjoint
    backends = job_backends(
        :mooncake_reverse => AutoMooncake(; config = nothing),
        :enzyme_reverse => AutoEnzyme(;
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

@testitem "User modifiers: functions, index ranges and constructors" tags = [:ad, :mooncake, :mooncake_reverse, :enzyme, :enzyme_reverse] setup = [JobBackends] begin
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
    CR.blocks(::MapBy) = (1, 1)
    function CR.forward!(m::MapBy, ::CR.Step, v, s, t)
        for k in eachindex(v, s)
            v[k] = m.a * m.f(v[k])
        end
        return nothing
    end
    # A closure's captured value is a parameter the local derivative does not
    # reach, so the operator takes plain AD; a plain function keeps the rule.
    scale(b) = x -> b * x
    # Pointwise modifiers that scale the strata in index ranges.
    struct Pick{I, T}
        idx::I
        a::T
    end
    CR.blocks(::Pick) = (1, 1)
    _in(k, idx) = k in idx
    _in(k, idx::AbstractVector{<:AbstractVector}) = any(i -> k in i, idx)
    function CR.forward!(m::Pick, ::CR.Step, v, s, t)
        for k in eachindex(v, s)
            v[k] = _in(k, m.idx) ? m.a * v[k] : v[k]
        end
        return nothing
    end
    backends = job_backends(
        :mooncake_reverse => AutoMooncake(; config = nothing),
        :enzyme_reverse => AutoEnzyme(;
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
        @eval CR.blocks(::$M) = (1, 1)
        @eval function CR.forward!(m::$M, ::CR.Step, v, s, t)
            for k in eachindex(v, s)
                v[k] = m.a * v[k]
            end
            return nothing
        end
    end
    # Depletion forms with no pullback: the local derivative covers them.
    struct Linear end
    function CR.forward!(::Linear, ::CR.Step, v, s, N)
        for i in eachindex(v, s)
            y = v[i] * max(s[i], 0) / N
            v[i], s[i] = y, s[i] - y
        end
        return nothing
    end
    struct LinearRate{T, A}
        c::T
        α::A
    end
    function CR.forward!(f::LinearRate, ::CR.Step, v, s, N)
        for i in eachindex(v, s)
            y = f.c * v[i] * max(s[i], 0)^f.α / N
            v[i], s[i] = y, s[i] - y
        end
        return nothing
    end
    struct DoubledRate{T}
        c::T
        DoubledRate(c::T) where {T} = new{T}(2c)
    end
    function CR.forward!(f::DoubledRate, ::CR.Step, v, s, N)
        return CR.forward!(LinearRate(f.c, 1.0), CR.Step(), v, s, N)
    end
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
        (θ -> CR.Depletion(100.0, LinearRate(θ, 1.1)), true, true),
        (
            θ -> CR.Depletion(100.0, Linear(), CR.Flow(:S => 0, θ; form = CR.Truncate())),
            true, true,
        ),
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

@testitem "User-defined operator, modifier and coupling" tags = [:ad, :mooncake, :mooncake_reverse, :enzyme, :enzyme_reverse] setup = [UserTypes, JobBackends] begin
    using ADTypes: AutoMooncake, AutoEnzyme, AutoForwardDiff
    using DifferentiationInterface: gradient
    import Mooncake, Enzyme, ForwardDiff
    backends = job_backends(
        :mooncake_reverse => AutoMooncake(; config = nothing),
        :enzyme_reverse => AutoEnzyme(;
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
            # A user operator's own pullback is not the package's. A coupling
            # or a whole-step modifier without one, whose arrays fit one pass
            # of dual numbers, takes the package's rule with a local
            # derivative.
            rule = own || name in ("coupling, no pullback", "modifier, no pullback")
            occursin("operator", name) ||
                @test (CR._PULLBACK_CALLS[] > n0) == rule
        end
    end
    @test Base.return_types(
        CR._route_val, (UserPkg.Decay{Float64}, Float64, Vector{Float64})
    ) == [Val{:rule}]
    @test Base.return_types(
        CR._route_val, (UserPkg.DecayNoPB{Float64}, Float64, Vector{Float64})
    ) == [Val{:plain}]
end

# Tagged `compat_floor`, so the Threads workflow runs it on Julia 1.11.
@testitem "User-defined types: test_adjoint" tags = [:ad, :mooncake, :mooncake_reverse, :enzyme, :enzyme_reverse, :compat_floor] setup = [UserTypes, JobBackends] begin
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
            backend in job_backends(
                :mooncake_reverse => AutoMooncake(; config = nothing),
                :enzyme_reverse => AutoEnzyme(),
            )
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

# Tagged `compat_floor`, so the Threads workflow runs it on Julia 1.11.
@testitem "Enzyme reverse: a scalar modifier field next to an array-field modifier" tags = [:ad, :enzyme, :enzyme_reverse, :compat_floor] begin
    using ComposableRecurrences
    using ComposableRecurrences: ComposableRecurrences as CR
    import Enzyme, ForwardDiff
    mode = Enzyme.set_runtime_activity(Enzyme.Reverse)
    # Local variables, so the losses are closures with typed fields.
    let W = [cos(a * t) for a in 1:3, t in 1:8], h = ones(3, 2),
            R = 1.0 .+ 0.05 .* [sin(a + t) for a in 1:3, t in 1:8],
            pool = PerStratum([60.0, 90.0, 70.0])

        mods(b) = (CR.Depletion(pool, CR.Floor()), CR.Add(b))
        op(b) = Recurrence([0.3, 0.2]; modifiers = mods(b))
        ws(r) = r(R; history = h, stop = 4, state = true)
        # The operator built from `b` inside the loss.
        for f in (
                b -> sum(W .* op(b[1])(R; history = h)),
                b -> sum(W[:, 1:4] .* ws(op(b[1]))[1]),
            )
            @test Enzyme.gradient(mode, Enzyme.Const(f), [0.5])[1] ≈
                ForwardDiff.gradient(f, [0.5])
        end
        # The operator as the differentiated argument.
        for f in (
                r -> sum(W .* r(R; history = h)),
                r -> sum(abs2, ws(r)[2].history),
                r -> sum(W[:, 1:4] .* first(r(R; state = ws(r)[2]))),
            )
            ḡ = Enzyme.gradient(mode, Enzyme.Const(f), op(0.5))[1]
            @test ḡ.modifiers[2].b ≈ ForwardDiff.derivative(b -> f(op(b)), 0.5)
        end
        # Fixed scalar fields with only the input active.
        g(Rx) = sum(W .* op(0.5)(Rx; history = h))
        @test Enzyme.gradient(mode, Enzyme.Const(g), R)[1] ≈ ForwardDiff.gradient(g, R)
    end
end

# Tagged `compat_floor`, so the Threads workflow runs it on Julia 1.11.
@testitem "Enzyme reverse on Julia 1.11 warns once per operator type of lost scalar gradients" tags = [:ad, :enzyme, :enzyme_reverse, :compat_floor] begin
    using ComposableRecurrences
    using ComposableRecurrences: ComposableRecurrences as CR, NoAdjoint
    using Logging: Warn
    import Enzyme
    ext = Base.get_extension(CR, :ComposableRecurrencesEnzymeExt)
    empty!(ext._SCALAR_LOSS_CHECKED)
    empty!(ext._SCALAR_LOSS_WARNED)
    mode = Enzyme.set_runtime_activity(Enzyme.Reverse)
    let R = fill(1.1, 4), h = ones(2)
        op(b) = Recurrence([0.3, 0.2]; modifiers = (CR.Add(b),))
        op2(b) = Recurrence([0.3, 0.2]; modifiers = (CR.Add(b), CR.Add(b)))
        msg = (:warn, r"On Julia 1\.11, Enzyme reverse mode can return a zero")
        grad(f, x) = Enzyme.gradient(mode, Enzyme.Const(f), x)[1]
        # The rule, plain AD of a `NoAdjoint`, a scalar field that is not
        # differentiated, and a second operator type after the first warned.
        for (f, x, warns) in (
                (b -> sum(op(b[1])(R; history = h)), [0.5], true),
                (b -> sum(NoAdjoint(op(b[1]))(R; history = h)), [0.5], true),
                (x -> sum(op(0.5)(x; history = h)), R, false),
                (b -> sum(op2(b[1])(R; history = h)), [0.5], true),
            )
            if warns && VERSION < v"1.12"
                @test_logs msg min_level = Warn grad(f, x)
            else
                @test_logs min_level = Warn grad(f, x)
            end
            @test_logs min_level = Warn grad(f, x)
        end
    end
end

# Enzyme reverse mode on Julia 1.11 loses the gradient of a scalar field of
# an operator built by a call it cannot infer, here a `NoAdjoint` called
# through a global that is not constant. The rules cannot see that call, so
# this pins the loss until Enzyme fixes it. Tagged `compat_floor`, so the
# Threads workflow runs it on Julia 1.11.
@testitem "Enzyme reverse on Julia 1.11 loses scalar gradients through uninferred construction" tags = [:ad, :enzyme, :enzyme_reverse, :compat_floor] begin
    using ComposableRecurrences
    using ComposableRecurrences: ComposableRecurrences as CR, NoAdjoint
    import Enzyme, ForwardDiff
    wrap = NoAdjoint
    W = [cos(a * t) for a in 1:3, t in 1:12]
    h = ones(3, 4)
    R = exp.(0.3 .+ [0.1 * sin(a + t) for a in 1:3, t in 1:12])
    g = exp.(-0.4 .* (1:4)) ./ sum(exp.(-0.4 .* (1:4)))
    f(θ) = sum(W .* log.(wrap(Recurrence(g; modifiers = (CR.Depletion(θ[1]),)))(R; history = h)))
    mode = Enzyme.set_runtime_activity(Enzyme.Reverse)
    ḡ = Enzyme.gradient(mode, Enzyme.Const(f), [80.0])[1]
    ref = ForwardDiff.gradient(f, [80.0])
    if VERSION < v"1.12"
        @test_broken ḡ ≈ ref
    else
        @test ḡ ≈ ref
    end
end

@testitem "A protected pool in Float32 keeps Float32 gradients" tags = [:ad, :forwarddiff, :mooncake, :mooncake_reverse, :mooncake_forward, :enzyme, :enzyme_reverse, :enzyme_forward] setup = [JobBackends] begin
    using ADFixtures
    using ADTypes: AutoForwardDiff, AutoMooncake, AutoMooncakeForward, AutoEnzyme
    using DifferentiationInterface: value_and_gradient
    using ComposableRecurrences: NoAdjoint
    import Enzyme, ForwardDiff, Mooncake
    _, loss, θ0, _ = only(
        filter(s -> first(s) == "Recurrence protected pool in Float32", ADFixtures._SCENARIOS)
    )
    θ = θ0()
    @test eltype(θ) == Float32
    backends = job_backends(
        :forwarddiff => AutoForwardDiff(),
        :mooncake_reverse => AutoMooncake(; config = nothing),
        :mooncake_forward => AutoMooncakeForward(; config = nothing),
        :enzyme_reverse => AutoEnzyme(;
            mode = Enzyme.set_runtime_activity(Enzyme.Reverse),
            function_annotation = Enzyme.Const
        ),
        :enzyme_forward => AutoEnzyme(;
            mode = Enzyme.set_runtime_activity(Enzyme.Forward),
            function_annotation = Enzyme.Const
        ),
    )
    for w in (identity, NoAdjoint)
        f = Base.Fix1(loss, w)
        _, ref = value_and_gradient(f, AutoForwardDiff(), Float64.(θ))
        for backend in backends
            y, ∇ = value_and_gradient(f, backend, θ)
            @test y isa Float32
            @test eltype(∇) == Float32
            @test ∇ ≈ ref rtol = 1.0e-3
        end
    end
end

@testitem "Conserving dense movement through both rules" tags = [:ad, :mooncake, :mooncake_reverse, :enzyme, :enzyme_reverse] setup = [JobBackends] begin
    using ComposableRecurrences
    using ComposableRecurrences: ComposableRecurrences as CR
    using ADTypes: AutoMooncake, AutoEnzyme, AutoForwardDiff
    using DifferentiationInterface: gradient
    import Enzyme, ForwardDiff, Mooncake
    # The kernel and the intensity are the parameters, so the dense
    # movement matrix's columns sum to one at every input and the
    # conserving (`leak = false`) path runs with its column check.
    h, R = ones(3, 2), 1 .+ 0.1 .* reshape(1:18, 3, 6)
    W = cos.(reshape(1:18, 3, 6))
    function f(θ)
        K, ε = reshape(θ[1:9], 3, 3), θ[10:12]
        r = Recurrence(
            [0.3, 0.2]; coupling = [0.5 0.1 0.0; 0.0 0.6 0.1; 0.1 0.0 0.5],
            modifiers = (
                CR.Redistribute(CR.movement(K, ε)),
                CR.Depletion(PerStratum(fill(40.0, 3))),
            )
        )
        return sum(W .* r(R; history = h))
    end
    θ = [0.0, 0.6, 0.4, 0.3, 0.0, 0.7, 0.5, 0.5, 0.0, 0.2, 0.3, 0.1]
    ref = gradient(f, AutoForwardDiff(), θ)
    for backend in job_backends(
            :mooncake_reverse => AutoMooncake(; config = nothing),
            :enzyme_reverse => AutoEnzyme(;
                mode = Enzyme.set_runtime_activity(Enzyme.Reverse),
                function_annotation = Enzyme.Const
            ),
        )
        n0 = CR._PULLBACK_CALLS[]
        @test gradient(f, backend, θ) ≈ ref
        @test CR._PULLBACK_CALLS[] > n0
    end
end

@testitem "Movement read from recent outputs with an active scale" tags = [:ad, :enzyme, :enzyme_reverse] begin
    using ComposableRecurrences
    using ComposableRecurrences: ComposableRecurrences as CR
    using ADTypes: AutoEnzyme, AutoForwardDiff
    using DifferentiationInterface: gradient
    import Enzyme, ForwardDiff
    # The scale of the intensity is a parameter, so its gradient flows
    # through the intensity held by the movement as well as through the
    # outputs the intensity reads. The data are bound in a `let` so `f`
    # is inferred; the next item builds the same model from uninferred code.
    f = let g = exp.(-0.4 .* (1:4)) ./ sum(exp.(-0.4 .* (1:4))),
            pop = [60.0, 90.0, 70.0], h = fill(5.0, 3, 4),
            R = exp.(0.1 .* sin.((1:3) .+ (1:12)')), W = cos.((1:3) .* (1:12)')
        function (θ)
            K, κ = reshape(θ[1:9], 3, 3), θ[10]
            ε = Derived(x -> 0.2 * tanh(x), κ * CR.Recent(3))
            mods = (
                CR.Redistribute(CR.movement(K, ε)),
                CR.Depletion(PerStratum(pop)),
            )
            y = Recurrence(g; modifiers = mods)(R; history = h)
            return sum(W .* log.(y))
        end
    end
    θ = [0.0, 0.6, 0.4, 0.5, 0.0, 0.5, 0.2, 0.3, 0.0, 0.05]
    ref = gradient(f, AutoForwardDiff(), θ)
    backend = AutoEnzyme(;
        mode = Enzyme.set_runtime_activity(Enzyme.Reverse),
        function_annotation = Enzyme.Const
    )
    n0 = CR._PULLBACK_CALLS[]
    @test gradient(f, backend, θ) ≈ ref
    @test CR._PULLBACK_CALLS[] > n0
    @test ref[10] != 0
end

@testitem "Movement read from recent outputs, built from uninferred code" tags = [:ad, :enzyme, :enzyme_reverse, :compat_floor] begin
    using ComposableRecurrences
    using ComposableRecurrences: ComposableRecurrences as CR
    using ADTypes: AutoEnzyme, AutoForwardDiff
    using DifferentiationInterface: gradient
    import Enzyme, ForwardDiff
    # The kernel is hidden from inference, so `movement` is called
    # dynamically with the intensity. Enzyme reverse finds no shadow for a
    # value that holds a scalar parameter beside an integer array when it
    # passes through a dynamic call, so `Recent(n)` holds no weight array.
    f = let g = exp.(-0.4 .* (1:4)) ./ sum(exp.(-0.4 .* (1:4))),
            pop = [60.0, 90.0, 70.0], h = fill(5.0, 3, 4),
            R = exp.(0.1 .* sin.((1:3) .+ (1:12)')), W = cos.((1:3) .* (1:12)')
        function (θ)
            K = Base.inferencebarrier(reshape(θ[1:9], 3, 3))
            ε = Derived(x -> 0.2 * tanh(x), θ[10] * CR.Recent(3))
            mods = (
                CR.Redistribute(CR.movement(K, ε)),
                CR.Depletion(PerStratum(pop)),
            )
            y = Recurrence(g; modifiers = mods)(R; history = h)
            return sum(W .* log.(y))
        end
    end
    θ = [0.0, 0.6, 0.4, 0.5, 0.0, 0.5, 0.2, 0.3, 0.0, 0.05]
    ref = gradient(f, AutoForwardDiff(), θ)
    backend = AutoEnzyme(;
        mode = Enzyme.set_runtime_activity(Enzyme.Reverse),
        function_annotation = Enzyme.Const
    )
    n0 = CR._PULLBACK_CALLS[]
    ḡ = gradient(f, backend, θ)
    if VERSION < v"1.12"
        # Enzyme reverse on Julia 1.11 loses the gradient of a scalar built
        # by a call it cannot infer, as the item above that pins it shows;
        # the kernel's gradient is right.
        @test ḡ[1:9] ≈ ref[1:9]
        @test_broken ḡ ≈ ref
    else
        @test ḡ ≈ ref
    end
    @test CR._PULLBACK_CALLS[] > n0
    @test ref[10] != 0
end

@testitem "Sparse Redistribute matrix through both rules" tags = [:ad, :mooncake, :mooncake_reverse, :enzyme, :enzyme_reverse] setup = [JobBackends] begin
    using ComposableRecurrences
    using ComposableRecurrences: ComposableRecurrences as CR
    using ADTypes: AutoMooncake, AutoEnzyme, AutoForwardDiff
    using DifferentiationInterface: gradient
    using SparseArrays
    import Enzyme, ForwardDiff, Mooncake
    # Columns summing to one, with the diagonal stored.
    M = sparse([0.8 0.2 0.0; 0.1 0.8 0.3; 0.1 0.0 0.7])
    h, R = ones(3, 2), 1 .+ 0.1 .* reshape(1:18, 3, 6)
    W = cos.(reshape(1:18, 3, 6))
    function f(θ)
        Mθ = SparseMatrixCSC(3, 3, M.colptr, M.rowval, θ)
        r = Recurrence(
            [0.3, 0.2]; coupling = [0.5 0.1 0.0; 0.0 0.6 0.1; 0.1 0.0 0.5],
            modifiers = (CR.Redistribute(Mθ), CR.Depletion(PerStratum(fill(40.0, 3))))
        )
        return sum(W .* r(R; history = h))
    end
    θ = copy(M.nzval)
    ref = gradient(f, AutoForwardDiff(), θ)
    for backend in job_backends(
            :mooncake_reverse => AutoMooncake(; config = nothing),
            :enzyme_reverse => AutoEnzyme(;
                mode = Enzyme.set_runtime_activity(Enzyme.Reverse),
                function_annotation = Enzyme.Const
            ),
        )
        n0 = CR._PULLBACK_CALLS[]
        @test gradient(f, backend, θ) ≈ ref
        @test CR._PULLBACK_CALLS[] > n0
    end
end

@testitem "Rule gradients survive inputs mutated after the call" tags = [:ad, :mooncake, :mooncake_reverse, :enzyme, :enzyme_reverse] setup = [JobBackends] begin
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
    for backend in job_backends(
            :mooncake_reverse => AutoMooncake(; config = nothing),
            :enzyme_reverse => AutoEnzyme(;
                mode = Enzyme.set_runtime_activity(Enzyme.Reverse),
                function_annotation = Enzyme.Const
            ),
        )
        @test gradient(f, backend, θ) ≈ ref
    end
end

@testitem "A pool held in a view gets its gradient" tags = [:ad, :mooncake, :mooncake_reverse, :enzyme, :enzyme_reverse] setup = [JobBackends] begin
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
    CR.forward!(m::PoolDep, ::CR.Init, s, history) = (s .= m.pop; nothing)
    CR.blocks(::PoolDep) = (1, 1)
    function CR.forward!(m::PoolDep, ::CR.Step, v, s, t)
        for k in eachindex(v, s)
            v′ = max(s[k] / m.pop[k], 1.0e-6) * v[k]
            v[k], s[k] = v′, s[k] - v′
        end
        return nothing
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
    for backend in job_backends(
            :mooncake_reverse => AutoMooncake(; config = nothing),
            :enzyme_reverse => AutoEnzyme(;
                mode = Enzyme.set_runtime_activity(Enzyme.Reverse),
                function_annotation = Enzyme.Const
            ),
        )
        @test gradient(f, backend, θ) ≈ ref
    end
end

@testitem "Empty protected pools: rules match ForwardDiff" tags = [:ad, :mooncake, :mooncake_reverse, :enzyme, :enzyme_reverse] setup = [JobBackends] begin
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
            100.0, CR.Hazard(; weights = (S = 1, V = θ[2])); pools = (S = θ[1], V = θ[3])
        )
        r = Recurrence([0.3, 0.5, 0.2]; modifiers = (d,))
        return sum(W .* r(fill(2.0, 6); history = [5.0]))
    end
    θ = [0.0, 0.3, 0.0]
    ref = gradient(f, AutoForwardDiff(), θ)
    @test all(isfinite, ref)
    for backend in job_backends(
            :mooncake_reverse => AutoMooncake(; config = nothing),
            :enzyme_reverse => AutoEnzyme(;
                mode = Enzyme.set_runtime_activity(Enzyme.Reverse),
                function_annotation = Enzyme.Const
            ),
        )
        @test gradient(f, backend, θ) ≈ ref
    end
end

@testitem "Empty pools with removals or a dual population: rules match ForwardDiff" tags = [:ad, :mooncake, :mooncake_reverse, :enzyme, :enzyme_reverse] setup = [JobBackends] begin
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
            100.0, CR.Hazard(; weights = (S = 1, V = θ[3])),
            CR.Flow(1 => 2, TimeVarying(fill(θ[2], 6)); form = CR.Truncate());
            pools = (S = θ[1], V = nothing)
        )
    )
    # An empty pool with a dual population and an integer heterogeneity,
    # alone and with a protected pool.
    by_population(θ) = total(CR.Depletion(θ[1], CR.Hazard(2); pools = (S = θ[2],)))
    by_protected(θ) = total(
        CR.Depletion(
            θ[1], CR.Hazard(; weights = (S = 1, V = θ[3]));
            pools = (S = θ[2], V = nothing)
        )
    )
    # A differentiated heterogeneity at an empty pool.
    by_heterogeneity(θ) = total(
        CR.Depletion(100.0, CR.Hazard(θ[1]); pools = (S = θ[2],))
    )
    cases = (
        (by_removals, [3.0, 4.0, 0.0]), (by_population, [100.0, 0.0]),
        (by_protected, [100.0, 0.0, 0.3]), (by_heterogeneity, [1.0, 0.0]),
    )
    for (f, θ) in cases
        ref = gradient(f, AutoForwardDiff(), θ)
        @test all(isfinite, ref)
        for backend in job_backends(
                :mooncake_reverse => AutoMooncake(; config = nothing),
                :enzyme_reverse => AutoEnzyme(;
                    mode = Enzyme.set_runtime_activity(Enzyme.Reverse),
                    function_annotation = Enzyme.Const
                ),
            )
            @test gradient(f, backend, θ) ≈ ref
        end
    end
end

@testitem "Empty and seeded pools: forward modes match ForwardDiff" tags = [:ad, :mooncake, :mooncake_forward, :enzyme, :enzyme_forward] setup = [JobBackends] begin
    using ComposableRecurrences
    using ComposableRecurrences: ComposableRecurrences as CR
    using ADTypes: AutoMooncakeForward, AutoEnzyme, AutoForwardDiff
    using DifferentiationInterface: gradient
    import Enzyme, ForwardDiff, Mooncake
    # Forward modes differentiate the step itself, so the pool power at an
    # empty pool must not give the exponent a `log(0)` tangent.
    W = collect(range(0.5, 1.5; length = 6))
    function f(θ)
        d = CR.Depletion(100.0, CR.Hazard(θ[1]); pools = (S = θ[2],))
        r = Recurrence([0.3, 0.5, 0.2]; modifiers = (d,))
        return sum(W .* r(fill(2.0, 6); history = [5.0]))
    end
    backends = job_backends(
        :mooncake_forward => AutoMooncakeForward(),
        :enzyme_forward => AutoEnzyme(;
            mode = Enzyme.set_runtime_activity(Enzyme.Forward),
            function_annotation = Enzyme.Const
        ),
    )
    for θ in ([1.0, 0.0], [2.0, 0.0], [1.0, 30.0], [1.5, 30.0])
        ref = gradient(f, AutoForwardDiff(), θ)
        @test all(isfinite, ref)
        for backend in backends
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

# Tagged `allocations` so the Threads workflow, which runs without coverage,
# runs the count.
@testitem "Mooncake rule route folds at compile time (allocation guard)" tags = [:ad, :mooncake, :mooncake_reverse, :allocations] begin
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
        W .* Recurrence(θ[1:5]; modifiers = (CR.Depletion(1.0e3; pools = (S = 995.0,)),))(
            θ[6:55]; history = ones(5)
        )
    )
    delay(θ) = sum(W .* Convolution(θ[1:5])(θ[6:55]))
    backend = AutoMooncake(; config = nothing)
    # Coverage instrumentation allocates, so the count is checked only
    # without it.
    coverage = Base.JLOptions().code_coverage != 0
    for f in (renewal, delay)
        θ = [fill(0.2, 5); ones(50)]
        prep = prepare_gradient(f, backend, θ)
        grad = similar(θ)
        gradient!(f, grad, prep, backend, θ)
        @test (@allocations gradient!(f, grad, prep, backend, θ)) < 300 skip = coverage
    end
end

@testitem "Plain-AD note logs once at construction under reverse-mode AD" tags = [:ad, :mooncake, :mooncake_reverse, :enzyme, :enzyme_reverse] setup = [JobBackends] begin
    using ComposableRecurrences
    using ComposableRecurrences: ComposableRecurrences as CR
    using ADTypes: AutoMooncake, AutoEnzyme
    using DifferentiationInterface: gradient
    import Enzyme, Mooncake
    # Pointwise modifiers whose float field is typed `Float64`, so the
    # local step cannot rebuild them and the operator takes plain AD; one
    # type per backend, as the note is logged once per operator type.
    struct ScaleM
        a::Float64
    end
    struct ScaleE
        a::Float64
    end
    for M in (ScaleM, ScaleE)
        @eval CR.blocks(::$M) = (1, 1)
        @eval function CR.forward!(m::$M, ::CR.Step, v, s, t)
            for k in eachindex(v, s)
                v[k] = m.a * v[k]
            end
            return nothing
        end
    end
    for (M, backend) in job_backends(
            :mooncake_reverse => (ScaleM, AutoMooncake(; config = nothing)),
            :enzyme_reverse => (
                ScaleE,
                AutoEnzyme(;
                    mode = Enzyme.set_runtime_activity(Enzyme.Reverse),
                    function_annotation = Enzyme.Const
                ),
            ),
        )
        f(θ) = sum(Recurrence([0.3, 0.2]; modifiers = (M(0.9),))(θ; history = ones(2)))
        θ = ones(4)
        # Built inside the differentiated loss, the operator notes the plain
        # path once.
        empty!(CR._PLAIN_NOTED)
        g = @test_logs (:info, r"plain AD of the whole operator") match_mode = :any gradient(f, backend, θ)
        @test all(isfinite, g)
        @test_logs gradient(f, backend, θ)
    end
end

@testitem "Local coupling and entry-parameter steps: the rule and its limits" tags = [:ad, :mooncake, :mooncake_reverse, :enzyme, :enzyme_reverse] setup = [JobBackends] begin
    using ComposableRecurrences
    using ComposableRecurrences: ComposableRecurrences as CR, NoAdjoint
    using ADTypes: AutoMooncake, AutoEnzyme, AutoForwardDiff
    using DifferentiationInterface: gradient
    import Enzyme, ForwardDiff, Mooncake
    # Each backend with its place in a case's `fires`.
    backends = job_backends(
        :mooncake_reverse => (1, AutoMooncake(; config = nothing)),
        :enzyme_reverse => (
            2,
            AutoEnzyme(;
                mode = Enzyme.set_runtime_activity(Enzyme.Reverse),
                function_annotation = Enzyme.Const
            ),
        ),
    )
    # A coupling without a pullback: the strata average, weighted by `a`.
    struct Blend{A}
        a::A
    end
    function CR.forward!(C::Blend, ::CR.Pressure, q, p, t)
        m = sum(p) / length(p)
        q .= (1 - C.a) .* p .+ C.a * m
        return nothing
    end
    # A modifier that reads its per-stratum parameter's array directly.
    struct Direct{K}
        κ::K
    end
    CR.blocks(::Direct) = (1, 1)
    function CR.forward!(m::Direct, ::CR.Step, v, s, t)
        for k in eachindex(v, s)
            v[k] = v[k] / (1 + v[k] / m.κ.x[k])
        end
        return nothing
    end
    function loss(w, θ, S)
        W = [cos(a * t) for a in 1:S, t in 1:6]
        r = Recurrence([0.3, 0.2]; coupling = Blend(θ[1]), modifiers = (Direct(PerStratum(θ[2:(S + 1)])),))
        return sum(W .* w(r)(fill(1.1, S, 6); history = ones(S, 2)))
    end
    # The same modifier reading its parameter through `param`.
    struct Plain{K}
        κ::K
    end
    CR.blocks(::Plain) = (1, 1)
    function CR.forward!(m::Plain, ::CR.Step, v, s, t)
        for k in eachindex(v, s)
            v[k] = v[k] / (1 + v[k] / CR.param(m.κ, k, t))
        end
        return nothing
    end
    function loss_param(w, θ, S)
        W = [cos(a * t) for a in 1:S, t in 1:6]
        r = Recurrence([0.3, 0.2]; coupling = Blend(θ[1]), modifiers = (Plain(PerStratum(θ[2:(S + 1)])),))
        return sum(W .* w(r)(fill(1.1, S, 6); history = ones(S, 2)))
    end
    # Blend's local step fires up to 23 strata (with its one scalar), and
    # on Mooncake up to 47; Direct sends the operator to plain AD at any
    # size. `fires` holds the Mooncake and the Enzyme outcome.
    cases = (
        (loss_param, 3, (true, true)), (loss_param, 23, (true, true)),
        (loss_param, 24, (true, false)), (loss_param, 47, (true, false)),
        (loss_param, 48, (false, false)), (loss, 3, (false, false)),
    )
    for (L, S, fires) in cases
        θ = [0.4; fill(5.0, S)]
        for w in (identity, NoAdjoint)
            f(θ) = L(w, θ, S)
            ref = gradient(f, AutoForwardDiff(), θ)
            for (i, backend) in backends
                n0 = CR._PULLBACK_CALLS[]
                @test gradient(f, backend, θ) ≈ ref
                @test (CR._PULLBACK_CALLS[] > n0) == (fires[i] && w === identity)
            end
        end
    end
end

# A loss whose parameter blocks infer lets Enzyme compile the operator's
# construction into the loss. A fixed exponent stored as a `Bool` field of
# `Depletion` then failed Enzyme's type analysis when the loss was compiled
# with coverage, as CI runs it. The loss and θ are the registry's
# vaccination scenario, unpacked without a closure.
@testitem "Enzyme: a type-stable loss through a protected pool" tags = [:ad, :enzyme, :enzyme_forward, :enzyme_reverse] setup = [JobBackends] begin
    using ComposableRecurrences, ADFixtures, ForwardDiff
    using ADFixtures: S, L, T, G0, K0, POP, WS
    import DifferentiationInterface as DI
    using Enzyme
    const CR = ComposableRecurrences
    scen = only(
        filter(s -> s.name == "Recurrence vaccination into a protected pool", ADFixtures.scenarios())
    )
    function loss(w, θ)
        n = S * L + 2 * S * T
        logh = reshape(view(θ, 1:(S * L)), S, L)
        logR = reshape(view(θ, (S * L + 1):(S * L + S * T)), S, T)
        doses = reshape(view(θ, (S * L + S * T + 1):n), S, T)
        d = CR.Depletion(
            PerStratum(POP), CR.Hazard(; weights = (S = 1, V = θ[n + 1])),
            CR.Flow(1 => 2, TimeVarying(PerStratum(doses)); form = CR.Truncate());
            pools = (:S, :V)
        )
        r = Recurrence(G0; coupling = K0, modifiers = (d,))
        return sum(WS .* log.(w(r)(exp.(logR); history = exp.(logh))))
    end
    θ = copy(scen.x)
    tag(e) = e.name == "Enzyme forward" ? :enzyme_forward : :enzyme_reverse
    enzyme = filter(
        e -> startswith(e.name, "Enzyme") && job_runs(tag(e)), ADFixtures.backends()
    )
    for w in (identity, CR.NoAdjoint)
        f(θ) = loss(w, θ)
        @test f(θ) ≈ scen.f(θ, map(c -> c.data, scen.contexts)...)
        ref = ForwardDiff.gradient(f, θ)
        for entry in enzyme
            @test DI.gradient(f, entry.backend, θ) ≈ ref
        end
    end
end

@testitem "Enzyme reverse: a constant ragged kernel takes no mirror" tags = [:ad, :enzyme, :enzyme_reverse] begin
    using ComposableRecurrences, ADTypes, Enzyme, ForwardDiff
    import DifferentiationInterface as DI
    CR = ComposableRecurrences
    # Columns held as given and closed over: under runtime activity their
    # shadow is the columns themselves, so the rule reads no kernel mirror
    # and only the input's gradient is formed.
    ks = [[0.5, 0.2], [0.3], [0.4, 0.1, 0.1], [0.6]]
    W = [0.5 + 0.1 * t for t in 1:4]
    x = [1.0, 2.0, 0.5, 1.5]
    b = AutoEnzyme(;
        mode = Enzyme.set_runtime_activity(Enzyme.Reverse), function_annotation = Enzyme.Const
    )
    for I in (CR.Secondary(), CR.Primary())
        f(x) = sum(W .* Convolution(TimeVarying(ks, I))(x))
        CR._PULLBACK_CALLS[] = 0
        @test DI.gradient(f, b, x) ≈ ForwardDiff.gradient(f, x)
        @test CR._PULLBACK_CALLS[] > 0
    end
end

@testitem "Enzyme reverse: an unused output gives each active argument a zero cotangent" tags = [:ad, :enzyme, :enzyme_reverse, :compat_floor] begin
    using ComposableRecurrences
    using ComposableRecurrences: ComposableRecurrences as CR
    import Enzyme
    mode = Enzyme.set_runtime_activity(Enzyme.Reverse)
    # Each call's output is dropped, so Enzyme calls the rule with a `Const`
    # return; the active scalar still takes a zero cotangent from it, and
    # the gradient is that of `ρ^2` alone.
    @noinline unused(y) = nothing
    let x = [0.1, 0.2, 0.3]
        losses = (
            (ρ, x) -> (
                unused(Recurrence([1.0])(ρ; history = [0.5], add = x, prepend = true));
                ρ^2 + sum(x)
            ),
            (ρ, x) -> (
                unused(Recurrence([0.5]; modifiers = (CR.Add(ρ),))(x; history = [0.5]));
                ρ^2 + sum(x)
            ),
            (ρ, x) -> (unused(Convolution([0.3, 0.2])(x; gain = ρ)); ρ^2 + sum(x)),
            (ρ, x) -> (
                unused(
                    Recurrence([0.5]; modifiers = (CR.Depletion(1000 * ρ),))(
                        x; history = [0.5]
                    )
                );
                ρ^2 + sum(x)
            ),
        )
        for f in losses
            dx = zero(x)
            ((dρ, _),) = Enzyme.autodiff(
                mode, Enzyme.Const(f), Enzyme.Active, Enzyme.Active(0.7),
                Enzyme.Duplicated(x, dx)
            )
            @test dρ ≈ 1.4
            @test dx == ones(3)
        end
    end
end

@testitem "Enzyme reverse: the rule returns a typed tuple past 32 leaves" tags = [:ad, :enzyme, :enzyme_reverse] begin
    using ComposableRecurrences, ADTypes, Enzyme, ForwardDiff
    using ComposableRecurrences: Flow, Depletion, Hazard
    import DifferentiationInterface as DI
    CR = ComposableRecurrences
    ext = Base.get_extension(CR, :ComposableRecurrencesEnzymeExt)
    # `map` over a tuple of 32 or more entries does not infer; the rule's
    # own map does at any length, with a mirror that may be a `Union`.
    xs = ntuple(i -> isodd(i) ? Float64(i) : i, Val(40))
    @test (@inferred ext._map_leaves(float, xs)) === map(float, xs)
    U = Tuple{ntuple(_ -> Union{Nothing, Float64}, 40)...}
    second(x, y) = y
    @test Base.return_types(ext._map_leaves, (typeof(second), typeof(xs), U)) == [U]
    # A pool with a scalar rate on each of eight flows has more than 32
    # leaves, and its gradient takes the rule.
    function op(θ)
        ring = (:A, :B, :C, :D)
        fs = ntuple(i -> Flow(ring[mod1(i, 4)] => ring[mod1(i + 1, 4)], θ[i]), Val(8))
        d = Depletion(
            1000.0, Hazard(), fs...; pools = NamedTuple{ring}((900.0, 50.0, 30.0, 20.0))
        )
        return Recurrence([0.3, 0.2, 0.1]; modifiers = (d,))
    end
    f(θ) = sum(log.(op(θ)(fill(2.0, 20); history = [1.0, 1.0, 1.0])))
    θ = [0.05 + 0.01 * i for i in 1:8]
    args = (fill(2.0, 20), nothing, [1.0, 1.0, 1.0], nothing, 1, nothing)
    @test length(CR._leaf_paths(Tuple{typeof(op(θ)), typeof.(args)...})) >= 32
    b = AutoEnzyme(;
        mode = Enzyme.set_runtime_activity(Enzyme.Reverse), function_annotation = Enzyme.Const
    )
    CR._PULLBACK_CALLS[] = 0
    @test DI.gradient(f, b, θ) ≈ ForwardDiff.gradient(f, θ)
    @test CR._PULLBACK_CALLS[] > 0
end

@testitem "Enzyme reverse: a field of 32 or more entries" tags = [:ad, :enzyme, :enzyme_reverse] begin
    using ComposableRecurrences, ADTypes, Enzyme, ForwardDiff
    using ComposableRecurrences: Flow, Depletion, Hazard
    import DifferentiationInterface as DI
    CR = ComposableRecurrences
    b = AutoEnzyme(;
        mode = Enzyme.set_runtime_activity(Enzyme.Reverse), function_annotation = Enzyme.Const
    )
    # The parts written out as the call's arguments. Under coverage a splat
    # of 33 or more arguments stays a call resolved at run time, whose boxed
    # result Enzyme's type analysis reads only to its first 512 bytes.
    @generated function pool_of(N, pools, fs::Tuple)
        args = [:(fs[$i]) for i in 1:fieldcount(fs)]
        return :(Depletion(N, Hazard(), $(args...); pools = pools))
    end
    # A pool with a scalar rate on each of `n` flows, built in the loss.
    function flows_loss(θ, ::Val{n}) where {n}
        ring = (:A, :B, :C, :D)
        fs = ntuple(i -> Flow(ring[mod1(i, 4)] => ring[mod1(i + 1, 4)], θ[i]), Val(n))
        d = pool_of(1000.0, NamedTuple{ring}((900.0, 50.0, 30.0, 20.0)), fs)
        r = Recurrence([0.3, 0.2, 0.1]; modifiers = (d,))
        return sum(log.(r(fill(2.0, 20); history = [1.0, 1.0, 1.0])))
    end
    # Each check takes the size as a type, so the loss it builds infers.
    function check(loss, θ, v)
        f = θ -> loss(θ, v)
        CR._PULLBACK_CALLS[] = 0
        @test DI.gradient(f, b, θ) ≈ ForwardDiff.gradient(f, θ)
        @test CR._PULLBACK_CALLS[] > 0
        return nothing
    end
    for v in (Val(32), Val(33), Val(64))
        n = typeof(v).parameters[1]
        check(flows_loss, [0.005 + 0.0005 * i for i in 1:n], v)
    end
    # A modifier holding one tuple of `n` active scalars.
    struct Weights{W}
        w::W
    end
    CR.blocks(::Weights) = (1, 1)
    function CR.forward!(m::Weights, ::CR.Step, v, s, t)
        for k in eachindex(v, s)
            v[k] *= m.w[mod1(t, length(m.w))]
        end
        return nothing
    end
    function weights_loss(θ, ::Val{n}) where {n}
        m = Weights(ntuple(i -> θ[i], Val(n)))
        r = Recurrence([0.3, 0.2]; modifiers = (m,))
        return sum(r(fill(1.5, 20); history = [1.0, 1.0]))
    end
    for v in (Val(35), Val(40))
        n = typeof(v).parameters[1]
        check(weights_loss, [1.0 + 0.01 * i for i in 1:n], v)
    end
end

@testitem "Blocks: blockwise, pointwise and vector modifiers under the rule" tags = [:ad, :mooncake, :mooncake_reverse] begin
    using ComposableRecurrences
    using ComposableRecurrences: ComposableRecurrences as CR
    using ADTypes: AutoMooncake
    using DifferentiationInterface: gradient
    import ForwardDiff, Mooncake
    # Two compartments per group: a share `a` of the first moves to the
    # second, and the state keeps what moved.
    struct Move{A}
        a::A
    end
    CR.blocks(::Move) = (2, 1)
    function CR.forward!(m::Move, ::CR.Step, v::Tuple, s::Tuple, t, g)
        v1, v2 = v[1][], v[2][]
        x = CR.param(m.a, g, t) * v1
        v[1][], v[2][], s[1][] = v1 - x, v2 + x, x
        return nothing
    end
    function CR.pullback!(grads, m::Move, ::CR.Step, v, s, t, g)
        v̄1, v̄2, s̄ = grads.v[1][], grads.v[2][], grads.s[1][]
        a = CR.param(m.a, g, t)
        c = v̄2 + s̄ - v̄1
        CR.add_param!(CR.cotangent(grads.piece, :a), m.a, c * v[1][], g, t)
        grads.v[1][], grads.v[2][], grads.s[1][] = v̄1 + a * c, v̄2, zero(s̄)
        return nothing
    end
    # Two values and two state entries per group, with a typed pullback.
    struct Keep{A}
        a::A
    end
    CR.blocks(::Keep) = (2, 2)
    function CR.forward!(m::Keep, ::CR.Step, v::Tuple, s::Tuple, t, g)
        v1, v2, s1, s2 = v[1][], v[2][], s[1][], s[2][]
        v[1][], v[2][] = v1 * m.a, v2 + s1
        s[1][], s[2][] = s1 + v1, s2 + 1
        return nothing
    end
    function CR.pullback!(grads, m::Keep, ::CR.Step, v::Tuple, s::Tuple, t, g)
        v̄1, v̄2 = grads.v[1][], grads.v[2][]
        s̄1, s̄2 = grads.s[1][], grads.s[2][]
        CR.add_cotangent!(CR.cotangent(grads.piece, :a), v̄1 * v[1][])
        grads.v[1][], grads.v[2][] = v̄1 * m.a + s̄1, v̄2
        grads.s[1][], grads.s[2][] = v̄2 + s̄1, s̄2
        return nothing
    end
    g = [0.5, 0.5]
    R = [1.0 + 0.1 * sin(k + t) for k in 1:4, t in 1:6]
    h = ones(4, 2)
    K = [0.0 0.1 0.0 0.0; 0.1 0.0 0.0 0.0; 0.0 0.0 0.0 0.1; 0.0 0.0 0.1 0.0]
    function loss(θ)
        ms = (
            CR.Clamp(0.0, 50.0), Move(PerStratum(θ[1:2])), Keep(θ[3]),
            CR.Redistribute(CR.movement(K, 0.5)),
        )
        return sum(abs2, Recurrence(g; modifiers = ms)(R; history = h))
    end
    θ = [0.2, 0.4, 0.8]
    n = CR._PULLBACK_CALLS[]
    @test gradient(loss, AutoMooncake(; config = nothing), θ) ≈ ForwardDiff.gradient(loss, θ)
    @test CR._PULLBACK_CALLS[] > n
end
