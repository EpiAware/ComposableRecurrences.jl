# Checks that need an AD backend by definition, moved from the unit and
# package suites, which load none.

@testitem "Chained delays: the Mooncake rule's pullback" tags = [:ad, :mooncake, :mooncake_reverse] begin
    using ComposableRecurrences, ForwardDiff, Mooncake
    using Random: Xoshiro
    CR = ComposableRecurrences
    a, b = [0.5, 0.3, 0.2], [0.6, 0.3, 0.1, 0.05]
    for lags in (3, 6, 8)
        c̄ = collect(1.0:lags) ./ lags
        Ja = ForwardDiff.jacobian(a -> CR._convolve_masses(a, b, lags), a)
        Jb = ForwardDiff.jacobian(b -> CR._convolve_masses(a, b, lags), b)
        f = CR._convolve_masses
        cache = Mooncake.prepare_pullback_cache(f, a, b, lags)
        _, (_, ā, b̄, _) = Mooncake.value_and_pullback!!(cache, c̄, f, a, b, lags)
        @test ā ≈ Ja' * c̄
        @test b̄ ≈ Jb' * c̄
    end
    # The same vector as both links, in traced code, takes both cotangents.
    c̄ = collect(1.0:5.0)
    square(a) = CR._convolve_masses(a, a, 5)
    J = ForwardDiff.jacobian(square, a)
    cache = Mooncake.prepare_pullback_cache(square, a)
    _, (_, ā) = Mooncake.value_and_pullback!!(cache, c̄, square, a)
    @test ā ≈ J' * c̄
    for lags in (4, 6)
        Mooncake.TestUtils.test_rule(
            Xoshiro(1), CR._convolve_masses, a, b, lags;
            is_primitive = true, perf_flag = :none, mode = Mooncake.ReverseMode
        )
    end
    # Views of one parameter vector, as a model hands them over.
    θ = [a; b]
    split(θ) = CR._convolve_masses(view(θ, 1:3), view(θ, 4:7), 6)
    c̄ = collect(1.0:6.0)
    J = ForwardDiff.jacobian(split, θ)
    cache = Mooncake.prepare_pullback_cache(split, θ)
    _, (_, θ̄) = Mooncake.value_and_pullback!!(cache, c̄, split, θ)
    @test θ̄ ≈ J' * c̄
    Mooncake.TestUtils.test_rule(
        Xoshiro(1), CR._convolve_masses, view(θ, 1:3), view(θ, 4:7), 6;
        is_primitive = true, perf_flag = :none, mode = Mooncake.ReverseMode
    )
end

# Without `ForwardDiff` loaded, built-in pieces keep their rules, a piece
# without a `pullback!` runs forward but its gradient says to load
# `ForwardDiff`, `PieceInterface`'s pullback check passes with a note, and
# once loaded the operator built before it checks its parts at the call.
@testitem "Loading: gradients without ForwardDiff" tags = [:ad, :mooncake, :mooncake_reverse] begin
    script = raw"""
    using ComposableRecurrences, Mooncake, DifferentiationInterface
    CR = ComposableRecurrences
    loaded(name) = any(k -> k.name == name, keys(Base.loaded_modules))
    println(loaded("ForwardDiff"))
    backend = AutoMooncake(; config = nothing)
    function fd(f, x; h = 1.0e-6)
        return map(eachindex(x)) do i
            e = zero(x)
            e[i] = h
            (f(x + e) - f(x - e)) / 2h
        end
    end
    builtin(θ) = Recurrence(θ[1:2]; modifiers = (CR.Depletion(50.0),))
    f(θ) = sum(builtin(θ)(fill(1.5, 6); history = [1.0, 2.0]))
    n0 = CR._PULLBACK_CALLS[]
    g = gradient(f, backend, [0.3, 0.2])
    println(CR._PULLBACK_CALLS[] > n0, " ", isapprox(g, fd(f, [0.3, 0.2]); rtol = 1.0e-5))
    struct Cap{T}
        c::T
    end
    CR.blocks(::Cap) = (1, 1)
    function CR.forward!(m::Cap, ::CR.Step, v, s, t)
        for k in eachindex(v)
            v[k] = m.c * v[k] / (m.c + v[k])
        end
        return nothing
    end
    r = Recurrence([0.3, 0.2]; modifiers = (Cap(5.0),))
    println(r.rebuilds === nothing, " ", CR.uses_adjoint(r, CR.Run()))
    h(x) = sum(r(x; history = [1.0, 2.0]))
    x = fill(1.5, 6)
    println(round(h(x); digits = 6))
    # A primal call logs nothing, as it takes no gradient.
    using Test: @test_logs
    @test_logs h(x)
    # Without the dual-number extension the call takes plain AD, says so
    # once, and gives the right gradient.
    n0 = CR._PULLBACK_CALLS[]
    g0 = gradient(h, backend, x)
    noted = any(CR._PLAIN_NOTED) do m
        occursin("Cap has no `pullback!`", m) &&
            occursin("add `using ForwardDiff`", m)
    end
    println(CR._PULLBACK_CALLS[] == n0, " ", isapprox(g0, fd(h, x); rtol = 1.0e-5), " ", noted)
    # So does a `Transform` without a `derivative`.
    tr = Recurrence(
        [0.3, 0.2];
        modifiers = (CR.Transform((v, p) -> p.a * v / (p.a + v), (; a = 5.0)),)
    )
    th(x) = sum(tr(x; history = [1.0, 2.0]))
    @test_logs th(x)
    transform_ok = isapprox(gradient(th, backend, x), fd(th, x); rtol = 1.0e-5)
    transform_noted = any(m -> occursin("`Transform` without a `derivative`", m), CR._PLAIN_NOTED)
    # A traced call reaches the hook as a wrapper, and still says why.
    empty!(CR._PLAIN_NOTED)
    traced(x) = sum(r(x; history = [1.0, 2.0], record = (:trace,)).y)
    gradient(traced, backend, x)
    traced_noted = any(m -> occursin("Cap has no `pullback!`", m), CR._PLAIN_NOTED)
    using Interfaces
    unchecked = Interfaces.test(CR.PieceInterface{(:pullback,)}, CR.Transform; show = false)
    using ForwardDiff
    n0 = CR._PULLBACK_CALLS[]
    g = gradient(h, backend, x)
    println(CR._PULLBACK_CALLS[] > n0, " ", isapprox(g, fd(h, x); rtol = 1.0e-5))
    println(Recurrence([0.3, 0.2]; modifiers = (Cap(5.0),)).rebuilds)
    println(unchecked)
    println("transform ", transform_ok, " ", transform_noted)
    println("traced ", traced_noted)
    # Reached only if both `@test_logs` above saw no log.
    println("primal silent")
    """
    project = Base.active_project()
    cmd = `$(Base.julia_cmd()) --startup-file=no --project=$project -e $script`
    lines = split(read(cmd, String), '\n'; keepempty = false)
    @test lines[1] == "false"
    @test lines[2] == "true true"
    @test lines[3] == "true true"
    @test parse(Float64, lines[4]) > 0
    @test lines[5] == "true true true"
    @test lines[6] == "true true"
    @test lines[7] == "true"
    @test lines[8] == "true"
    @test "transform true true" in lines
    @test "primal silent" in lines
    @test "traced true" in lines
end

@testitem "Loading: an Init without a pullback! takes plain AD without ForwardDiff" tags = [:ad, :mooncake, :mooncake_reverse] begin
    script = raw"""
    using ComposableRecurrences, Mooncake, DifferentiationInterface
    CR = ComposableRecurrences
    loaded(name) = any(k -> k.name == name, keys(Base.loaded_modules))
    println(loaded("ForwardDiff"))
    backend = AutoMooncake(; config = nothing)
    function fd(f, x; h = 1.0e-6)
        return map(eachindex(x)) do i
            e = zero(x)
            e[i] = h
            (f(x + e) - f(x - e)) / 2h
        end
    end
    # A pool that sets its own initial state, with a `pullback!` for its
    # step, its methods typed on a supertype. `Pool` has no `pullback!` for
    # its `Init`; `PoolInit` has one, typed on its own supertype.
    abstract type AbstractPool end
    abstract type InitPool <: AbstractPool end
    struct Pool{T} <: AbstractPool
        N::T
    end
    struct PoolInit{T} <: InitPool
        N::T
    end
    CR.blocks(::AbstractPool) = (1, 1)
    CR.uses_adjoint(::AbstractPool, ::CR.Step) = true
    CR.forward!(m::AbstractPool, ::CR.Init, s, history) = (fill!(s, m.N); nothing)
    function CR.forward!(m::AbstractPool, ::CR.Step, v, s, t)
        for k in eachindex(v, s)
            x = v[k] / m.N
            v[k], s[k] = -s[k] * expm1(-x), s[k] * exp(-x)
        end
        return nothing
    end
    function CR.pullback!(grads, m::AbstractPool, ::CR.Step, v, s, t)
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
    function CR.pullback!(grads, m::InitPool, ::CR.Init, s, history)
        CR.add_cotangent!(CR.cotangent(grads.piece, :N), sum(grads.s))
        return nothing
    end
    run(P) = θ -> sum(
        Recurrence([0.3, 0.2]; modifiers = (P(θ[1]),))(
            fill(1.5, 6); history = [1.0, 2.0]
        )
    )
    θ = [50.0]
    # Without the dual-number extension, `Pool` takes plain AD, says why
    # once, and gives the right gradient.
    f = run(Pool)
    n0 = CR._PULLBACK_CALLS[]
    g = gradient(f, backend, θ)
    noted = any(CR._PLAIN_NOTED) do m
        occursin("Pool sets its own initial state", m) &&
            occursin("add `using ForwardDiff`", m)
    end
    println("plain rule skipped ", CR._PULLBACK_CALLS[] == n0)
    println("plain gradient ", isapprox(g, fd(f, θ); rtol = 1.0e-5))
    println("plain noted ", noted)
    # With a `pullback!` for its `Init`, the rule.
    fi = run(PoolInit)
    n0 = CR._PULLBACK_CALLS[]
    g = gradient(fi, backend, θ)
    println("rule taken ", CR._PULLBACK_CALLS[] > n0)
    println("rule gradient ", isapprox(g, fd(fi, θ); rtol = 1.0e-5))
    # With the dual-number extension, `Pool` takes the rule too.
    using ForwardDiff
    n0 = CR._PULLBACK_CALLS[]
    g = gradient(f, backend, θ)
    println("duals rule taken ", CR._PULLBACK_CALLS[] > n0)
    println("duals gradient ", isapprox(g, fd(f, θ); rtol = 1.0e-5))
    """
    project = Base.active_project()
    cmd = `$(Base.julia_cmd()) --startup-file=no --project=$project -e $script`
    lines = split(read(cmd, String), '\n'; keepempty = false)
    @test lines[1] == "false"
    @test "plain rule skipped true" in lines
    @test "plain gradient true" in lines
    @test "plain noted true" in lines
    @test "rule taken true" in lines
    @test "rule gradient true" in lines
    @test "duals rule taken true" in lines
    @test "duals gradient true" in lines
end

@testitem "Trace, Mooncake reverse: gradients through the traces of built-in modifiers and flows, the rule against ForwardDiff" tags = [:ad, :mooncake, :mooncake_reverse] begin
    using ComposableRecurrences, ForwardDiff, Mooncake
    using DifferentiationInterface: gradient, AutoMooncake
    CR = ComposableRecurrences
    # The default traces of user modifiers, pointwise and on groups, are the
    # registry's "Recurrence default traces of user modifiers".
    @testset "built-in modifiers and flows" begin
        W = reshape(range(0.2, 1.8; length = 48), 6, 8)
        g, R, h = [0.3, 0.5, 0.2], fill(2.0, 2, 8), [5.0 4.0; 3.0 2.0]
        K = [0.0 0.3; 0.2 0.0]
        function loss(θ)
            leaky = CR.Depletion(
                PerStratum(θ[1:2]), CR.Hazard(; weights = (S = 1, V = θ[3])),
                CR.Flow(:S => :V, θ[4]; form = CR.Truncate()), CR.Flow(:V => :S, θ[5]);
                pools = (:S, :V)
            )
            # `Transform(+, b)` keeps no state, so its trace is empty and takes no
            # cotangent.
            mods = (CR.Redistribute(K, θ[6]), CR.Transform(+, θ[7]), leaky)
            _, tr = Recurrence(g; modifiers = mods)(R; history = h, record = (:trace,))
            T1, T0, T2 = tr.modifiers
            return sum(W[1:2, :] .* T1) + sum(T0) + sum(W .* T2[3:8, :])
        end
        θ = [80.0, 120.0, 0.3, 2.0, 0.1, 0.2, 0.4]
        n = CR._PULLBACK_CALLS[]
        @test gradient(loss, AutoMooncake(), θ) ≈ ForwardDiff.gradient(loss, θ)
        @test CR._PULLBACK_CALLS[] > n
        # The flows' amounts, with a smooth count whose softness is a
        # parameter.
        function ward(θ)
            flows = CR.Depletion(
                CR.Flow(1 => 2, θ[1]), CR.Flow(1 => 0, θ[2]; form = CR.Share()),
                CR.Flow(2 => 0, θ[3]; form = CR.Truncate(θ[4])),
                CR.Flow(2 => 1, θ[5]; form = CR.Truncate()),
                CR.Flow(0 => 2, θ[6]; form = CR.Truncate()); pools = (:A, :B)
            )
            r = Recurrence([1.0]; modifiers = (flows,))
            adm = [4.0 6.0 2.0 0.0 3.0 1.0; 0.0 0.0 0.0 0.0 0.0 0.0]
            y, tr = r(; history = zeros(2, 1), add = adm, record = (:trace,))
            return sum(W[1:5, 1:6] .* only(tr.modifiers)) + sum(y)
        end
        θw = [0.3, 0.2, 1.5, 0.2, 0.4, 0.6]
        @test gradient(ward, AutoMooncake(), θw) ≈ ForwardDiff.gradient(ward, θw)
    end
end

@testitem "Trace, Mooncake reverse: user traces written in place, for each kind of step" tags = [:ad, :mooncake, :mooncake_reverse] begin
    using ComposableRecurrences, ForwardDiff, Mooncake
    using DifferentiationInterface: gradient, AutoMooncake
    CR = ComposableRecurrences
    # Pointwise: the smoothed value and what it leaves of the value, as
    # a tuple of series over the strata.
    struct Smoothing{A}
        a::A
    end
    CR.blocks(::Smoothing) = (1, 1)
    function CR.forward!(m::Smoothing, ::CR.Step, v, s, t)
        for k in eachindex(v, s)
            s[k] = m.a * s[k] + (1 - m.a) * v[k]
            v[k] = s[k]
        end
        return nothing
    end
    CR.ntrace(::Smoothing, S) = 2S
    function CR.forward!(m::Smoothing, ::CR.Trace, r, v, s, v′, s′, t)
        smoothed, left = r
        for k in eachindex(v)
            smoothed[k], left[k] = s′[k], v[k] - s′[k]
        end
        return nothing
    end
    function CR.pullback!(grads, m::Smoothing, ::CR.Trace, v, s, t)
        s̄′, r̄ = grads.trace
        for k in eachindex(v)
            grads.v[k] += r̄[k]
            grads.s′[k] += s̄′[k] - r̄[k]
        end
        return nothing
    end
    # Blockwise: two values and two state entries per group; its trace is
    # the group's total after the step.
    struct Pairs{A}
        a::A
    end
    CR.blocks(::Pairs) = (2, 2)
    function CR.forward!(m::Pairs, ::CR.Step, v::Tuple, s::Tuple, t, g)
        v1, v2, s1, s2 = v[1][], v[2][], s[1][], s[2][]
        v[1][], v[2][] = v1 * m.a, v2 + s1
        s[1][], s[2][] = s1 + v1, s2 + v2
        return nothing
    end
    function CR.pullback!(grads, m::Pairs, ::CR.Step, v::Tuple, s::Tuple, t, g)
        v̄1, v̄2 = grads.v[1][], grads.v[2][]
        s̄1, s̄2 = grads.s[1][], grads.s[2][]
        CR.add_cotangent!(CR.cotangent(grads.piece, :a), v̄1 * v[1][])
        grads.v[1][], grads.v[2][] = v̄1 * m.a + s̄1, v̄2 + s̄2
        grads.s[1][], grads.s[2][] = v̄2 + s̄1, s̄2
        return nothing
    end
    CR.ntrace(::Pairs, S) = S ÷ 2
    function CR.forward!(m::Pairs, ::CR.Trace, r::Tuple, v::Tuple, s::Tuple, v′::Tuple, s′::Tuple, t, g)
        only(r)[] = v′[1][] + v′[2][]
        return nothing
    end
    function CR.pullback!(grads, m::Pairs, ::CR.Trace, v::Tuple, s::Tuple, t, g)
        r̄ = only(grads.trace)[]
        grads.v′[1][] += r̄
        grads.v′[2][] += r̄
        return nothing
    end
    # Whole step: each value mixed with the mean, its trace the mean.
    struct Mean{B}
        b::B
    end
    function CR.forward!(m::Mean, ::CR.Step, v, s, t)
        μ = sum(v) / length(v)
        v .= (1 - m.b) .* v .+ m.b * μ
        return nothing
    end
    function CR.pullback!(grads, m::Mean, ::CR.Step, v, s, t)
        v̄ = grads.v
        μ, μ̄ = sum(v) / length(v), sum(v̄) / length(v)
        CR.add_cotangent!(CR.cotangent(grads.piece, :b), sum(v̄ .* (μ .- v)))
        v̄ .= (1 - m.b) .* v̄ .+ m.b * μ̄
        fill!(grads.s, zero(eltype(grads.s)))
        return nothing
    end
    CR.ntrace(::Mean, S) = 1
    function CR.forward!(m::Mean, ::CR.Trace, r, v, s, v′, s′, t)
        r[1] = sum(v) / length(v)
        return nothing
    end
    function CR.pullback!(grads, m::Mean, ::CR.Trace, v, s, t)
        grads.v .+= grads.trace[1] / length(v)
        return nothing
    end
    g, h = [0.5, 0.3], [1.0 2.0; 2.0 1.0; 1.5 0.5; 0.5 1.5]
    R = [1.0 + 0.1 * sin(k + t) for k in 1:4, t in 1:6]
    # The trace rows against the step run by hand.
    # The trace rows: the smoothed value is the output, and the two rows
    # sum to the value the step received.
    y, tr = Recurrence(g; modifiers = (Smoothing(0.6),))(R; history = h, record = (:trace,))
    M = only(tr.modifiers)
    @test size(M) == (8, 6)
    @test M[1:4, :] ≈ y
    _, trm = Recurrence(g; modifiers = (Mean(0.3),))(R; history = h, record = (:trace,))
    @test size(only(trm.modifiers)) == (1, 6)
    _, trp = Recurrence(g; modifiers = (Pairs(0.8),))(R; history = h, record = (:trace,))
    @test size(only(trp.modifiers)) == (2, 6)
    # The gradients through the pointwise and grouped traces are the
    # registry's "Recurrence trace of pointwise modifiers" and "Recurrence
    # user traces on groups and over the whole step"; the whole-step trace
    # followed by a clamp is not.
    function f(θ)
        mods = (Mean(θ[1]), CR.Transform(clamp, 0.0, 9.0))
        y, tr = Recurrence(g; modifiers = mods)(R; history = h, record = (:trace,))
        return sum(y) + sum(x -> sum(abs2, x), tr.modifiers)
    end
    θ = [0.6]
    n = CR._PULLBACK_CALLS[]
    @test gradient(f, AutoMooncake(), θ) ≈ ForwardDiff.gradient(f, θ)
    @test CR._PULLBACK_CALLS[] > n
    # A trace that returns its values rather than writing them is an error.
    struct Returns end
    CR.blocks(::Returns) = (1, 1)
    CR.forward!(::Returns, ::CR.Step, v, s, t) = nothing
    CR.nstate(::Returns, S) = S
    CR.forward!(::Returns, ::CR.Trace, r, v, s, v′, s′, t) = (s′,)
    r = Recurrence(g; modifiers = (Returns(),))
    @test_throws r"returned a Tuple" r(R; history = h, record = (:trace,))
end

@testitem "Trace, Mooncake reverse: gradients through the pressure, the rule against ForwardDiff" tags = [:ad, :mooncake, :mooncake_reverse] begin
    using ComposableRecurrences, ForwardDiff, Mooncake
    using DifferentiationInterface: gradient, AutoMooncake
    CR = ComposableRecurrences
    S, T = 2, 8
    W = reshape(range(0.2, 1.8; length = S * T), S, T)
    h = [5.0 4.0 3.0; 3.0 2.0 1.0]
    R = [1.4 + 0.2 * sin(k + t) for k in 1:S, t in 1:T]
    # A pointwise and a dense coupling, each with a modifier; the loss reads
    # the output and the pressure, and the effective reproduction number.
    # A scalar, a diagonal and a dense coupling, and one series, whose
    # pressure is a vector.
    function coupling_of(θ, coupling)
        coupling === :dense && return [θ[4] 0.2; 0.1 θ[4]]
        coupling === :diagonal && return CR.Diagonal([θ[4], 0.8])
        return θ[4] * CR.I
    end
    function recurrence(θ, coupling)
        mods = (CR.Depletion(PerStratum(θ[5:6])),)
        coupling === :series && return Recurrence(θ[1:3]; modifiers = (CR.Depletion(θ[5]),))
        return Recurrence(θ[1:3]; coupling = coupling_of(θ, coupling), modifiers = mods)
    end
    inputs(θ, coupling) = coupling === :series ? (R[1, :] .* θ[7], h[1, :]) : (R .* θ[7], h)
    function run(θ, coupling)
        x, hx = inputs(θ, coupling)
        y, tr = recurrence(θ, coupling)(x; history = hx, record = (:trace,))
        return y, tr.pressure
    end
    # The same pressures from `pressure` on the same recurrence's outputs.
    function second_pass(θ, coupling)
        r = recurrence(θ, coupling)
        x, hx = inputs(θ, coupling)
        y = r(x; history = hx)
        return y, CR.pressure(r, y; history = hx)
    end
    # A loss on the output and the pressure, and one on the pressure alone,
    # whose only cotangent is the pressure's.
    weights(q) = q isa AbstractVector ? W[1, :] : W
    both(y, q) = sum(weights(q) .* q) + sum(y ./ q) + sum(y)
    alone(y, q) = sum(weights(q) .* q)
    θ = [0.3, 0.5, 0.2, 0.9, 80.0, 120.0, 1.1]
    # The rule through the output and the pressure is the registry's
    # "Recurrence pressure from its trace, by coupling and with no input" and
    # "Recurrence effective reproduction number from its trace"; the rule
    # with the pressure's cotangent alone, and with the populations
    # differentiated, is not.
    for coupling in (:pointwise, :diagonal, :dense, :series), l in (both, alone)
        f = θ -> l(run(θ, coupling)...)
        ∇ = ForwardDiff.gradient(θ -> l(second_pass(θ, coupling)...), θ)
        @test ForwardDiff.gradient(f, θ) ≈ ∇
        l === alone || continue
        n = CR._PULLBACK_CALLS[]
        @test gradient(f, AutoMooncake(), θ) ≈ ∇
        @test CR._PULLBACK_CALLS[] > n
    end
end

@testitem "Trace, Mooncake reverse: the pressure of a run with an integer gain and coefficient" tags = [:ad, :mooncake, :mooncake_reverse] begin
    # Such a run records no convolutions for the reverse pass, but its trace
    # returns its pressures, so a traced run records them all the same.
    using ComposableRecurrences, ForwardDiff, Mooncake
    using DifferentiationInterface: gradient, AutoMooncake
    using LinearAlgebra: Diagonal, I
    CR = ComposableRecurrences
    S, T = 2, 8
    h = [5.0 4.0 3.0; 3.0 2.0 1.0]
    W = reshape(range(0.2, 1.8; length = S * T), S, T)
    for C in (I, Diagonal([1, 2]))
        r = Recurrence([0.3, 0.5, 0.2]; coupling = C)
        ϵ = fill(0.5, S, T)
        args = CR._run_args(r, true, h, nothing, ϵ, 1)
        (y, tr), c = CR._run_forward(CR._WithTrace(r), args..., nothing)
        @test c.pr !== nothing
        @test tr.pressure ≈ CR.pressure(r, y; history = h)
        function f(θ)
            y, tr = Recurrence(θ[1:3]; coupling = C)(;
                history = h, add = reshape(θ[4:end], S, T), record = (:trace,)
            )
            return sum(W .* tr.pressure) + sum(y)
        end
        # The rule under the diagonal coefficient is the registry's
        # "Recurrence pressure from its trace, by coupling and with no input".
        C isa Diagonal && continue
        θ = vcat([0.3, 0.5, 0.2], vec(ϵ))
        n = CR._PULLBACK_CALLS[]
        @test gradient(f, AutoMooncake(), θ) ≈ ForwardDiff.gradient(f, θ)
        @test CR._PULLBACK_CALLS[] > n
    end
end

@testitem "Depletion without a draw, Mooncake reverse: the time checks infer and allocate nothing, after a gradient too" tags = [:ad, :mooncake, :mooncake_reverse] begin
    using ComposableRecurrences, ForwardDiff, Mooncake
    using DifferentiationInterface: gradient, AutoMooncake
    CR = ComposableRecurrences
    function flows(θ)
        return CR.Depletion(
            CR.Flow(:U => :C, PerStratum(θ[1:2])),
            CR.Flow(:U => 0, TimeVarying(θ[3:8]); form = CR.Share()),
            CR.Flow(:C => 0, θ[9]),
            CR.Flow(
                :C => 0, TimeVarying(PerStratum(reshape(θ[10:21], 2, 6)));
                form = CR.Truncate()
            ); pools = (:U, :C)
        )
    end
    θ = vcat([0.3, 0.2], fill(0.1, 6), 0.1, fill(0.5, 12))
    mods = (flows(θ), CR.Transform(clamp, 0.0, 1.0e6))
    checked(m) = ComposableRecurrences._check_times(:modifiers, m, 6)
    check_allocs(m) = (checked(m); @allocated checked(m))
    @test (@inferred checked(mods)) === nothing
    # Coverage instrumentation allocates, so counts are checked only
    # without it.
    coverage = Base.JLOptions().code_coverage != 0
    @test check_allocs(mods) == 0 skip = coverage
    adm = [fill(10.0, 2, 6); zeros(2, 6)]
    call(m) = Recurrence([1.0]; modifiers = m)(; history = zeros(4, 1), add = adm)
    call_allocs(m) = (call(m); @allocated call(m))
    before = call_allocs(mods)
    loss(θ) = sum(call((flows(θ), CR.Transform(clamp, 0.0, 1.0e6))))
    @test gradient(loss, AutoMooncake(), θ) ≈ ForwardDiff.gradient(loss, θ)
    # A gradient does not leave the checks to run inference on each call.
    @test check_allocs(mods) == 0 skip = coverage
    @test call_allocs(mods) <= before skip = coverage
end

# The `Flow` and `Depletion` constructors' checks carry no derivative: each
# is a primitive, and a gradient through building flows of every demand kind
# (a number, a series, a `Derived` of both) matches ForwardDiff's.
@testitem "Depletion construction: checks carry no derivative" tags = [:ad, :mooncake, :mooncake_reverse] begin
    using ComposableRecurrences, ForwardDiff, Mooncake
    CR = ComposableRecurrences
    for sig in (
            Tuple{typeof(CR._check_flow_parts), Int, Int, Float64, CR.Share},
            Tuple{typeof(CR._check_unit), Symbol, Float64},
            Tuple{typeof(CR._check_nonnegative), Symbol, Float64},
            Tuple{typeof(CR._check_pieces), Tuple, Int},
            Tuple{typeof(CR._check_given), Tuple},
        )
        for mode in (Mooncake.ReverseMode, Mooncake.ForwardMode)
            @test Mooncake.is_primitive(
                Mooncake.DefaultCtx, mode, sig, Base.get_world_counter()
            )
        end
    end
    T = 30
    function model(θ)
        adm, out, h = θ[1:T], θ[(T + 1):(2T)], θ[(2T + 1):(3T)]
        κ = θ[end]
        hz = TimeVarying(h)
        drains = CR.Derived((o, k) -> 0.5 * o * (1 + k), TimeVarying(out), κ)
        flows = CR.Depletion(
            CR.Flow(:u => :c, CR.Derived(identity, hz); form = CR.Share()),
            CR.Flow(:u => 0, κ; form = CR.Share()),
            CR.Flow(0 => :u, TimeVarying(adm); form = CR.Truncate()),
            CR.Flow(:c => 0, drains; form = CR.Truncate());
            pools = (:u, :c)
        )
        r = Recurrence([true]; modifiers = (flows,))
        return sum(abs2, r(; history = zeros(2, 1), stop = T))
    end
    θ = [
        [2.0 + sin(t) for t in 1:T]; [0.5 + 0.2 * cos(t) for t in 1:T];
        [0.1 + 0.05 * sin(t / 3) for t in 1:T]; 0.03
    ]
    g = ForwardDiff.gradient(model, θ)
    cache = Mooncake.prepare_gradient_cache(model, θ)
    _, (_, gr) = Mooncake.value_and_gradient!!(cache, model, θ)
    @test gr ≈ g rtol = 1.0e-10
    dθ = [sin(i / 7) for i in eachindex(θ)]
    dcache = Mooncake.prepare_derivative_cache(model, θ)
    _, d = Mooncake.value_and_derivative!!(
        dcache, (model, Mooncake.NoTangent()), (θ, dθ)
    )
    @test d ≈ g' * dθ rtol = 1.0e-10
    # The checks still throw inside a gradient: a share above one.
    function bad(θ)
        dep = CR.Depletion(
            CR.Flow(:u => :c, 1.5 * θ[1]; form = CR.Share()); pools = (:u, :c)
        )
        r = Recurrence([true]; modifiers = (dep,))
        return sum(r(; history = ones(2, 1), stop = 3))
    end
    @test_throws ArgumentError Mooncake.value_and_gradient!!(
        Mooncake.prepare_gradient_cache(bad, [1.0]), bad, [1.0]
    )
end

@testitem "Loading: Enzyme gradients without ForwardDiff" tags = [:ad, :enzyme, :enzyme_reverse] begin
    script = raw"""
    using ComposableRecurrences, Enzyme
    CR = ComposableRecurrences
    println(any(k -> k.name == "ForwardDiff", keys(Base.loaded_modules)))
    struct Scale{T}
        a::T
    end
    CR.ispointwise(::Scale) = true
    CR.forward!(m::Scale, ::CR.Step, v, s, t) = (v .*= m.a; nothing)
    r(a) = Recurrence([0.5, 0.3]; modifiers = (Scale(a),))
    f(θ) = sum(r(θ[1])(ones(10); history = [1.0, 2.0]))
    # `Scale` has no `pullback!`, so its step takes the local derivative:
    # the call takes plain AD and says so.
    println(length(CR._dual_whys([0.5, 0.3], CR.I, (Scale(0.9),))))
    g = Enzyme.gradient(Enzyme.Reverse, Enzyme.Const(f), [0.9])[1]
    fd = (f([0.9 + 1.0e-6]) - f([0.9 - 1.0e-6])) / 2.0e-6
    noted = any(m -> occursin("Scale has no `pullback!`", m), CR._PLAIN_NOTED)
    println(isapprox(g[1], fd; rtol = 1.0e-5), " ", noted)
    """
    project = Base.active_project()
    cmd = `$(Base.julia_cmd()) --startup-file=no --project=$project -e $script`
    lines = split(read(cmd, String), '\n'; keepempty = false)
    @test lines[1] == "false"
    @test lines[2] == "1"
    @test lines[3] == "true true"
end
