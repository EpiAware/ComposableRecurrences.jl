# Run one case in one mode under Reactant and write one result line.
#
#   julia --project=test/reactant probe.jl <case> <forward|reverse> \
#       <baseline|shims> <cpu|gpu> <outfile>
#
# `forward` compiles the operator call with `Reactant.@compile` and compares
# it with plain Julia. `reverse` compiles `Enzyme.gradient` of a weighted sum
# of the output and compares it with ForwardDiff.
# `baseline` measures the package as it is. `shims` first loads the
# candidate changes in `shims.jl`, to show what they would unlock.
# `gpu` writes `skipped` when Reactant finds no GPU.
using ComposableRecurrences, Reactant, Enzyme, ForwardDiff
using Printf: @sprintf

include(joinpath(@__DIR__, "cases.jl"))
using .ReactantCases

const CASE = case_by_name(ARGS[1])
const MODE = ARGS[2]
const CONFIG = ARGS[3]
const BACKEND = ARGS[4]
const OUT = ARGS[5]
const FWD = CASE.fwd
const Wt = CASE.weights
const θ0 = CASE.θ

function write_result(r)
    open(OUT, "w") do io
        println(
            io, join(
                (
                    r.status, @sprintf("%.1e", r.relerr),
                    @sprintf("%.1f", r.compile_s), @sprintf("%.1f", r.run_us),
                    @sprintf("%.1f", r.plain_us), r.error, r.frame, r.message,
                ), '\t'
            )
        )
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
    write_result(failed("skipped"; message = "no $BACKEND backend"))
    exit()
end

if CONFIG == "shims"
    include(joinpath(@__DIR__, "shims.jl"))
    traced_fwd(θ) = Reactant.@allowscalar FWD(θ)
else
    traced_fwd(θ) = FWD(θ)
end
traced_loss(θ) = sum(Wt .* traced_fwd(θ))
traced_grad(θ) = Enzyme.gradient(Enzyme.Reverse, traced_loss, θ)[1]
plain_loss(θ) = sum(Wt .* FWD(θ))

relerr(a, b) = maximum(abs.(a .- b)) / max(1.0, maximum(abs.(b)))

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

function probe()
    θr = Reactant.to_rarray(θ0)
    if MODE == "forward"
        ref = FWD(θ0)
        f = traced_fwd
        plain = () -> FWD(θ0)
    else
        ref = ForwardDiff.gradient(plain_loss, θ0)
        f = traced_grad
        plain = () -> ForwardDiff.gradient(plain_loss, θ0)
    end
    plain()
    plain_us = median_us(plain, 20)
    compile_s = @elapsed (c = Reactant.@compile f(θr))
    y = Array(c(θr))
    err = relerr(y, ref)
    run_us = median_us(() -> Reactant.synchronize(c(θr)), 20)
    status = err < 1.0e-8 ? "works" : "wrong"
    return (;
        status, relerr = err, compile_s, run_us, plain_us, error = "",
        frame = "", message = "",
    )
end

result = try
    probe()
catch e
    failed(
        "error"; error = first(string(nameof(typeof(e))), 60),
        frame = package_frame(catch_backtrace()),
        message = first(clean(sprint(showerror, e)), 300),
    )
end
write_result(result)
