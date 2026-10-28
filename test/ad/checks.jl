# The registry gradient checks: each backend's gradient against the
# ForwardDiff reference entry by entry, at the tolerance of the scenario's
# precision, and the reference against central differences.

@testsnippet GradientChecks begin
    using ADFixtures
    import DifferentiationInterface as DI
    using EpiAwarePackageTools: EpiAwarePackageTools
    using Test

    # An entry that is zero in exact arithmetic comes out as rounding, so
    # the absolute tolerance is this share of the largest reference entry.
    const ATOL_SHARE = 1.0e-12

    # Whether `g` matches `ref` entry by entry to `rtol`.
    function entrywise(g, ref; rtol, atol_share = ATOL_SHARE)
        atol = atol_share * maximum(abs, ref)
        return size(g) == size(ref) && all(isapprox.(g, ref; rtol, atol))
    end

    # Runs the kit's working-backend check on the registry scenarios of
    # `category` for the backend named `name`, once per precision at its
    # tolerance, then checks each gradient against its reference entry by
    # entry; the kit compares whole gradients by norm.
    function test_gradients(name; category::Symbol)
        backend = only(b.backend for b in ADFixtures.backends() if b.name == name)
        skip = get(ADFixtures.backend_skip_scenarios(), name, Set{String}())
        broken = union(
            Set(ADFixtures.broken_scenario_names()),
            get(ADFixtures.backend_broken_scenarios(), name, Set{String}())
        )
        for precision in (:double, :single)
            rtol = ADFixtures.gradient_rtol(precision)
            scenario_kwargs = (; category, precision)
            EpiAwarePackageTools.test_working_backend(
                ADFixtures, name; rtol, atol = 0.0, scenario_kwargs
            )
            scens = filter(
                s -> !(s.name in skip || s.name in broken),
                ADFixtures.scenarios(; with_reference = true, scenario_kwargs...)
            )
            @testset "$(s.name), entry by entry" for s in scens
                @test entrywise(DI.gradient(s.f, backend, s.x), s.res1; rtol)
            end
        end
        return nothing
    end

    # The central difference of `f` at `x` in entry `i` with step `h`, or
    # `NaN` where the step leaves the domain of `f`.
    function central_difference(f, x, i, h)
        xp, xm = copy(x), copy(x)
        xp[i] += h
        xm[i] -= h
        return try
            (f(xp) - f(xm)) / (xp[i] - xm[i])
        catch err
            err isa DomainError || rethrow()
            NaN
        end
    end

    # Steps relative to an entry, for entries far below one under a log, and
    # of at least `cbrt(eps())`, for small entries that enter linearly,
    # where a relative step drowns in rounding.
    steps(x) = cbrt(eps()) .* unique((iszero(x) ? 1.0 : abs(x), max(abs(x), 1.0)))

    # The entries where the gradient `ref` of `f` at `θ` matches central
    # differences in double precision at none of the entry's `steps`.
    function differing_entries(f, θ, ref; rtol, atol_share)
        x = Float64.(θ)
        atol = atol_share * maximum(abs, ref)
        return filter(eachindex(x)) do i
            !any(steps(x[i])) do h
                isapprox(central_difference(f, x, i, h), ref[i]; rtol, atol)
            end
        end
    end
end
