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
    msg = try
        gradient(h, backend, x)
        ""
    catch err
        sprint(showerror, err)
    end
    println(occursin("Cap has no `pullback!`", msg), " ",
        occursin("add `using ForwardDiff`", msg))
    using Interfaces
    unchecked = Interfaces.test(CR.PieceInterface{(:pullback,)}, CR.Transform; show = false)
    using ForwardDiff
    n0 = CR._PULLBACK_CALLS[]
    g = gradient(h, backend, x)
    println(CR._PULLBACK_CALLS[] > n0, " ", isapprox(g, fd(h, x); rtol = 1.0e-5))
    println(Recurrence([0.3, 0.2]; modifiers = (Cap(5.0),)).rebuilds)
    println(unchecked)
    """
    project = Base.active_project()
    cmd = `$(Base.julia_cmd()) --startup-file=no --project=$project -e $script`
    lines = split(read(cmd, String), '\n'; keepempty = false)
    @test lines[1] == "false"
    @test lines[2] == "true true"
    @test lines[3] == "true true"
    @test parse(Float64, lines[4]) > 0
    @test lines[5] == "true true"
    @test lines[6] == "true true"
    @test lines[7] == "true"
    @test lines[8] == "true"
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
