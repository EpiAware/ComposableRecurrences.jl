# Run cases under Reactant, each forward then reverse, and append one result
# line for each case and mode as it finishes, so the runner can tell which
# case hung or crashed and restart after it.
#
#   julia --project=test/reactant probe.jl <suite> <names> <cpu|gpu> <outfile>
#
# `suite` is `cases` (the hand-written cases in `cases.jl`) or `registry`
# (scenarios of the shared AD registry, `test/ADFixtures`), and `names` a
# file with one case name a line.
# `forward` compiles the call with `Reactant.@compile` and compares it with
# plain Julia. `reverse` compiles `Enzyme.gradient` of the loss and compares
# it with ForwardDiff: a weighted sum of a case's output, or the scenario's
# own loss against the registry's ForwardDiff reference, entry by entry.
# Loading Reactant loads the package's Reactant extension.
# `gpu` writes `skipped` when Reactant finds no GPU.
using ComposableRecurrences, Reactant, Enzyme, ForwardDiff
using Printf: @sprintf

const SUITE, BACKEND, OUT = ARGS[1], ARGS[3], ARGS[4]
const NAMES = readlines(ARGS[2])
const MODES = ("forward", "reverse")

# What a probe runs: `fwd(θ)` is the traced call, `loss(y)` the scalar the
# gradient is taken of, `ref` the reference gradient (or `nothing` to take
# ForwardDiff's), and `rtol` the tolerance of both modes. `entrywise` checks
# the gradient entry by entry, as the AD tests do, rather than by the
# largest error relative to the largest entry.
struct Problem{F, L, R}
    fwd::F
    loss::L
    θ::Vector
    ref::R
    rtol::Float64
    entrywise::Bool
end

if SUITE == "cases"
    include(joinpath(@__DIR__, "cases.jl"))
    using .ReactantCases
elseif SUITE == "registry"
    using ADFixtures: ADFixtures
    const SCENARIOS = ADFixtures.scenarios(; category = :rules)
end

function problem(suite, name)
    if suite == "cases"
        c = ReactantCases.case_by_name(name)
        W = c.weights
        return Problem(c.fwd, y -> sum(W .* y), c.θ, nothing, 1.0e-8, false)
    elseif suite == "registry"
        # The reference is ForwardDiff's, as the registry's is, taken for
        # this scenario only.
        s = only(filter(s -> s.name == name, SCENARIOS))
        precision = eltype(s.x) == Float32 ? :single : :double
        rtol = ADFixtures.gradient_rtol(precision)
        return Problem(s.f, identity, s.x, nothing, rtol, true)
    end
    throw(ArgumentError("unknown suite $suite"))
end

function write_results(name, rows)
    open(OUT, "a") do io
        for (mode, r) in rows
            println(
                io, join(
                    (
                        name, mode, r.status, @sprintf("%.1e", r.relerr),
                        @sprintf("%.1f", r.compile_s), @sprintf("%.1f", r.run_us),
                        @sprintf("%.1f", r.plain_us), r.error, r.frame, r.message,
                    ), '\t'
                )
            )
        end
    end
    return nothing
end

function failed(status; error = "", frame = "", message = "")
    return (;
        status, relerr = NaN, compile_s = NaN, run_us = NaN, plain_us = NaN,
        error, frame, message,
    )
end

has_backend = try
    Reactant.set_default_backend(BACKEND)
    true
catch
    false
end
if !has_backend
    r = failed("skipped"; message = "no $BACKEND backend")
    for name in NAMES
        write_results(name, [(m, r) for m in MODES])
    end
    exit()
end

# A compiled call's result on the host: an array, or a registry scenario's
# scalar loss.
host(y::AbstractArray) = Array(y)
host(y) = Reactant.to_number(y)

relerr(a, b) = maximum(abs.(a .- b)) / max(1.0, maximum(abs.(b)))
# The largest error of an entry relative to the entry, with the AD tests'
# absolute tolerance for entries that are zero in exact arithmetic.
entry_relerr(a, b) = maximum(abs.(a .- b) ./ max.(abs.(b), 1.0e-12))

# The innermost package function on the stack, to say where it failed.
function package_frame(bt)
    for fr in stacktrace(bt)
        m = match(r"typeof\(ComposableRecurrences\.([^)]+)\)", string(fr))
        m === nothing || return m[1]
    end
    return "-"
end

clean(s) = replace(s, r"[\t\n\r|]+" => " ")

# Median wall time of `n` calls, in microseconds.
function median_us(f, n)
    ts = map(1:n) do _
        t0 = time_ns()
        f()
        (time_ns() - t0) / 1.0e3
    end
    return sort(ts)[cld(n, 2)]
end

function probe(p::Problem, mode)
    θ0 = p.θ
    θr = Reactant.to_rarray(θ0)
    # A scenario may index its parameters as scalars, as a user's model
    # does; the package's own loops allow it already.
    traced(θ) = Reactant.@allowscalar p.fwd(θ)
    traced_loss(θ) = p.loss(traced(θ))
    plain_loss(θ) = p.loss(p.fwd(θ))
    if mode == "forward"
        ref = p.fwd(θ0)
        f = traced
        plain = () -> p.fwd(θ0)
    else
        ref = p.ref === nothing ? ForwardDiff.gradient(plain_loss, θ0) : p.ref
        f = θ -> Enzyme.gradient(Enzyme.Reverse, traced_loss, θ)[1]
        plain = () -> ForwardDiff.gradient(plain_loss, θ0)
    end
    plain()
    plain_us = median_us(plain, 20)
    compile_s = @elapsed (c = Reactant.@compile f(θr))
    y = host(c(θr))
    err = p.entrywise ? entry_relerr(y, ref) : relerr(y, ref)
    run_us = median_us(() -> Reactant.synchronize(c(θr)), 20)
    ok = p.entrywise ? all(isapprox.(y, ref; rtol = p.rtol, atol = 1.0e-12)) :
        err < p.rtol
    return (;
        status = ok ? "works" : "wrong", relerr = err, compile_s, run_us,
        plain_us, error = "", frame = "", message = "",
    )
end

function attempt(f)
    return try
        f()
    catch e
        failed(
            "error"; error = first(string(nameof(typeof(e))), 60),
            frame = package_frame(catch_backtrace()),
            message = first(clean(sprint(showerror, e)), 300),
        )
    end
end

for name in NAMES
    p = attempt(() -> problem(SUITE, name))
    if p isa Problem
        for m in MODES
            write_results(name, [(m, attempt(() -> probe(p, m)))])
        end
    else
        write_results(name, [(m, p) for m in MODES])
    end
end
