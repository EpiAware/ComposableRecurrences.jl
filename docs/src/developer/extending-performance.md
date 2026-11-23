# [Performance and trimming](@id extending-performance)

A new type can run as fast as the built-in ones, specialise one combination of types, and compile into a trimmed executable.
It builds on the types of the pages that start at [Writing new types](@ref extending).

```@setup extending-performance
using ComposableRecurrences
const CR = ComposableRecurrences
```

## [Fast methods](@id extending-fast)

- Keep `forward!` and `pullback!` free of allocations: loop over `eachindex(v)` and write in place.
- Use concrete field types through type parameters, so every call is type stable.
- Loop with `eachindex` over the arrays you index, and add `@inbounds` only to such loops.

The [benchmark matrix](@ref testing) times the gradient of a renewal with a stateless pointwise modifier, the saturation ``v \kappa / (\kappa + v)`` in `benchmark/docs_modifier.jl`, under Mooncake and Enzyme in reverse mode.
It times plain AD of the whole operator, the rule with `forward!` only, and the rule with the `pullback!`.

```@example extending-performance
using Markdown # hide
results = joinpath(pkgdir(ComposableRecurrences), "benchmark", "results", "docs.csv") # hide
rows = isfile(results) ? split.(readlines(results)[2:end], ',') : [] # hide
custom = filter(r -> r[1] == "custom modifier" && r[5] == "ok", rows) # hide
time_of(m, sz, tg) = parse(Float64, only(r[6] for r in custom if (r[3], r[2], r[4]) == (m, sz, tg))) # hide
cases = unique((r[2], r[4]) for r in custom) # hide
pct(a, b) = extrema(round(Int, 100 * time_of(b, c...) / time_of(a, c...)) for c in cases) # hide
if isempty(cases) # hide
    md"The benchmark results are not available in this build." # hide
else # hide
    (lo, hi), (plo, phi) = pct("plain AD", "forward only"), pct("forward only", "with pullback!") # hide
    ratio(tg) = round(Int, 100 * time_of("forward only", "T200_L20_S1", tg) / time_of("plain AD", "T200_L20_S1", tg)) # hide
    Markdown.parse( # hide
        "With `forward!` only, the gradient takes $lo% to $hi% of the time of plain AD. " * # hide
            "At `T` 200 and `L` 20 that is $(ratio("Mooncake reverse"))% on Mooncake " * # hide
            "and $(ratio("Enzyme reverse"))% on Enzyme. " * # hide
            "The `pullback!` then takes it to $plo% to $phi% of the time with `forward!` only. " * # hide
            "These are median times at revision `$(first(custom)[12])`." # hide
    ) # hide
end # hide
```

The local step evaluates `forward!` once per step with dual numbers, so its cost follows the cost of `forward!`.
For a map as cheap as the saturation there is little for a `pullback!` to save.
Write `forward!` first, and add a `pullback!` when timing shows the modifier's local step matters.

## [Trimmed executables](@id trimming)

On Julia 1.12 and later, `juliac --trim=safe` compiles an app into an executable that holds only the code the app can reach.
The build fails on any call the compiler cannot resolve from the argument types.
A build can pass and still fail when run, for example on a call the runtime makes, so the app is run as well as built.

The app in `test/trim`:

- runs the forward path of a renewal, a convolution, a depletion with flows, a transform with a derived parameter and a coupled renewal over several strata, and checks the outputs;
- runs a loop split into tasks by [`Threaded`](@ref ComposableRecurrences.Threaded);
- runs its operator calls serially, as a trimmed app cannot set [`EXECUTOR`](@ref ComposableRecurrences.EXECUTOR) with `with` on Julia 1.12;
- is built and run by the Trim workflow when `src` or the app changes.

Gradients and the extensions are not trim-tested.
A new type used in a trimmed app needs concrete field types, and methods whose calls resolve from the argument types.

To run the check locally, with JuliaC installed in a shared environment:

```bash
julia --project=@juliac -e 'using Pkg; Pkg.add("JuliaC")'
cd test/trim
julia --project=. -e 'using Pkg; Pkg.instantiate()'
julia --project=@juliac -e 'using JuliaC; JuliaC.main(ARGS)' -- \
    --output-exe trimapp --bundle build --trim=safe --experimental .
build/bin/trimapp
```

## [Specialising for speed](@id specialising)

Every call of an operator has one form, and the work behind it is chosen by dispatch on the types of its kernel, coupling, modifiers and numbers.
A method for a narrower type replaces the general one for that type alone, so a faster path for one combination needs no new interface and no change to any call.

| To speed up | Add a method |
|---|---|
| a coupling with structure, such as low rank or banded | `forward!(C::MyCoupling, Pressure(), q, p, t)`, and its `pullback!` |
| a modifier at one parameter form | `forward!(m::MyModifier{<:PerStratum}, Step(), v, s, t)` |
| a depletion form at one number type | `forward!(form::MyForm, Step(), v::AbstractVector{Float32}, s::AbstractVector{Float32}, N::Float32)` |

A rank-one coupling ``K = u w^\top`` mixes the strata in ``2S`` operations, where a dense matrix takes ``S^2``:

```math
q_a = u_a \sum_{b=1}^{S} w_b \, p_b,
```

where ``p_b`` is stratum ``b``'s kernel-weighted past and ``q_a`` the mixed value of stratum ``a``.

```@example extending-performance
struct RankOne{V}
    u::V
    w::V
end
function CR.forward!(C::RankOne, ::CR.Pressure, q, p, t)
    c = zero(eltype(q))
    for b in eachindex(p)
        c += C.w[b] * p[b]
    end
    for a in eachindex(q)
        q[a] = C.u[a] * c
    end
    return nothing
end

u, w = [0.9, 0.1, 0.4], [0.5, 0.3, 0.2]
R = fill(1.2, 3, 6)
h = ones(3, 2)
low = Recurrence([0.5, 0.5]; coupling = RankOne(u, w))(R; history = h)
dense = Recurrence([0.5, 0.5]; coupling = u * w')(R; history = h)
low ≈ dense
```

The package specialises its own code the same way.
These methods are internal and may change without notice; the list says where a contributor would add one:

- one stratum's kernel convolution, `_kdot`, by the kernel's form (shared, per stratum, time varying with either indexing, pairwise) and by the buffer's array type;
- independent strata, where the coupling is `I` or `Diagonal`, the kernel is not pairwise and every modifier is pointwise, run each block of strata over the whole series (`_independent` decides, `_series_body!` runs);
- a fixed convolution's body, `_convolve_series!`, by the buffer's number type: one vectorised `axpy` per lag for IEEE floats, one dot per output for other numbers;
- the output's copy into the public layout, `_public`, by the buffer's array type;
- the route of a call, the rule or plain AD, by [`uses_adjoint`](@ref ComposableRecurrences.uses_adjoint) and the number types.
