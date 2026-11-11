# The registry gradient checks: each backend's gradient against the
# ForwardDiff reference entry by entry, at the tolerance of the scenario's
# precision, and the reference against central differences.

@testsnippet GradientChecks begin
    using ADFixtures
    using ComposableRecurrences: ComposableRecurrences
    import DifferentiationInterface as DI
    using EpiAwarePackageTools: EpiAwarePackageTools
    using Test

    # An entry that is zero in exact arithmetic comes out as rounding, up to
    # about 4e-16 in the registry, so it passes this absolute tolerance. It
    # does not grow with the gradient, so a large entry cannot cover a small
    # one.
    const ATOL = 1.0e-12

    # Whether `g` matches `ref` entry by entry to `rtol`.
    function entrywise(g, ref; rtol, atol = ATOL)
        return size(g) == size(ref) && all(isapprox.(g, ref; rtol, atol))
    end

    # Runs the kit's working-backend check on the registry scenarios of
    # `category` for the backend named `name`, once per precision at its
    # tolerance, then checks each gradient against its reference entry by
    # entry: the plain call, and the prepared, value-and-gradient and
    # in-place calls the kit compares only by norm. A scenario broken on
    # the backend is `@test_broken`, so it fails once it passes.
    # With `rules_fire`, for a backend with a rule of its own, it also
    # checks that at least one of those calls ran the analytic reverse pass
    # for each scenario, and none did for a `NoAdjoint` twin
    # (`test_rule_fires`). A gradient that throws is recorded as broken or
    # failed first, and then fails the count too.
    function test_gradients(name; category::Symbol, rules_fire::Bool = false)
        backend = only(b.backend for b in ADFixtures.backends() if b.name == name)
        skip = get(ADFixtures.backend_skip_scenarios(), name, Set{String}())
        plain = get(ADFixtures.backend_plain_scenarios(), name, Set{String}())
        broken = union(
            Set(ADFixtures.broken_scenario_names()),
            get(ADFixtures.backend_broken_scenarios(), name, Set{String}())
        )
        for precision in (:double, :single)
            rtol = ADFixtures.gradient_rtol(precision)
            scenario_kwargs = (; category, precision, backend = name)
            EpiAwarePackageTools.test_working_backend(
                ADFixtures, name; rtol, atol = 0.0, scenario_kwargs
            )
            scens = filter(
                s -> !(s.name in skip),
                ADFixtures.scenarios(; with_reference = true, scenario_kwargs...)
            )
            @testset "$(s.name), entry by entry" for s in scens
                calls = ComposableRecurrences._PULLBACK_CALLS[]
                if s.name in broken
                    @test_broken all(g -> entrywise(g, s.res1; rtol), gradients(s, backend))
                else
                    @test all(g -> entrywise(g, s.res1; rtol), gradients(s, backend))
                end
                fired = ComposableRecurrences._PULLBACK_CALLS[] > calls
                rules_fire && test_rule_fires(s.name, fired, plain, s.name in broken)
            end
        end
        return nothing
    end

    # Whether the gradients of the scenario named `name` ran the analytic
    # reverse pass (`fired`), as they must on a backend with a rule of its
    # own, unless the scenario is a `NoAdjoint` twin or takes plain AD there
    # by design (`plain`). A rule that stops firing fails here.
    function test_rule_fires(name, fired, plain, broken)
        rule = !startswith(name, "NoAdjoint") && !(name in plain)
        @testset "$name: $(rule ? "the rule fires" : "no rule fires")" begin
            if broken
                @test_broken fired == rule
            else
                @test fired == rule
            end
        end
        return nothing
    end

    # The gradients of scenario `s` on `backend` from the plain call, and
    # from the prepared out-of-place, value-and-gradient and in-place calls,
    # prepared at zero as the kit's check prepares them.
    function gradients(s, backend)
        prep = DI.prepare_gradient(s.f, backend, zero(s.x))
        g! = DI.gradient!(s.f, similar(s.x), prep, backend, s.x)
        return (
            DI.gradient(s.f, backend, s.x), DI.gradient(s.f, prep, backend, s.x),
            last(DI.value_and_gradient(s.f, prep, backend, s.x)), g!,
        )
    end

    # The central difference of `f` at `x` in entry `i` with step `h`, and
    # the rounding it carries, `100 eps |f| / h`; `NaN`s where the step leaves
    # the domain of `f`.
    function central_difference(f, x, i, h)
        xp, xm = copy(x), copy(x)
        xp[i] += h
        xm[i] -= h
        return try
            fp, fm = f(xp), f(xm)
            Δ = xp[i] - xm[i]
            (fp - fm) / Δ, 200 * eps() * max(abs(fp), abs(fm)) / Δ
        catch err
            err isa DomainError || rethrow()
            NaN, NaN
        end
    end

    # Steps relative to an entry, for entries far below one under a log, and
    # of at least `cbrt(eps())`, for small entries that enter linearly,
    # where a relative step drowns in rounding.
    steps(x) = cbrt(eps()) .* unique((iszero(x) ? 1.0 : abs(x), max(abs(x), 1.0)))

    # The entries where the gradient `ref` of `f` at `θ` matches central
    # differences in double precision, to `rtol` or to their rounding, at
    # none of the entry's `steps`.
    function differing_entries(f, θ, ref; rtol)
        x = Float64.(θ)
        return filter(eachindex(x)) do i
            !any(steps(x[i])) do h
                d, rounding = central_difference(f, x, i, h)
                isapprox(d, ref[i]; rtol, atol = rounding)
            end
        end
    end
end
