#!/usr/bin/env julia
# Time the `Direct()` and `FFTMethod()` lag sums of a `Convolution` over a
# grid of series lengths `T`, kernel lengths `L` and strata counts `S`, for
# the forward pass and its Mooncake reverse gradient, and summarise where
# FFT wins.
#
#   julia --project=benchmark benchmark/methods.jl [options]
#   task -t benchmark/Taskfile.yml benchmark-methods -- [options]
#
# Options:
#   --T=a,b        series lengths (default 100 to 20000)
#   --L=a,b        kernel lengths (default 10 to 500)
#   --S=a,b        strata counts (default 1,50)
#   --targets=a,b  forward, gradient or both (default both)
#   --seconds=S    BenchmarkTools budget per cell (default 0.5)
#   --out=DIR      result directory (default methods-results)
#
# Kernels longer than the series are skipped. The loss is a weighted sum of
# the convolved series, and the gradient is with respect to the kernel and
# the inputs. Each run writes `methods.tsv`, one row per cell and method
# with the minimum and median time, and `SUMMARY.md`, the FFT speed-up per
# cell, the smallest kernel from which FFT wins at every longer kernel in
# the grid, and the threshold rule (FFT when `L ≥ L₀` and `T ≥ T₀`) with
# the smallest worst-case slowdown against the faster method.

using ADTypes: AutoMooncake
using BenchmarkTools: @benchmark
import DifferentiationInterface as DI
import FFTW
import Mooncake
using Printf: @printf, @sprintf
using Statistics: median

using ComposableRecurrences: Convolution, Direct, FFTMethod

const METHODS = ["Direct" => Direct(), "FFT" => FFTMethod()]

_noise(a, b) = sin(12.9898 * a + 78.233 * b)

# A weighted sum of `S` series convolved with one pmf of `L` lags, as a
# function of the pmf and the series stacked in one vector.
function convolution_loss(method, S, T, L)
    shape = S == 1 ? (T,) : (S, T)
    W = S == 1 ? [_noise(t, 1) for t in 1:T] :
        [_noise(t, k + 1) for k in 1:S, t in 1:T]
    f = function (θ)
        X = reshape(view(θ, (L + 1):length(θ)), shape)
        return sum(W .* Convolution(θ[1:L]; method)(X))
    end
    g = exp.(-0.2 .* (1:L))
    X0 = S == 1 ? [50.0 + 40.0 * _noise(t, 2) for t in 1:T] :
        [50.0 + 40.0 * _noise(t, k + 2) for k in 1:S, t in 1:T]
    return f, vcat(g ./ sum(g), vec(X0))
end

function timer(f, θ, target, seconds)
    if target == "forward"
        f(θ)
        return @benchmark $f($θ) samples = 1000 evals = 1 seconds = seconds
    end
    backend = AutoMooncake(; config = nothing)
    prep = DI.prepare_gradient(f, backend, copy(θ))
    g = similar(θ)
    DI.gradient!(f, g, prep, backend, θ)
    return @benchmark(
        $(DI.gradient!)($f, $g, $prep, $backend, $θ);
        samples = 1000, evals = 1, seconds = seconds
    )
end

_ints(s) = parse.(Int, split(s, ','))

function parse_args(args)
    opts = Dict(
        "T" => "100,200,500,1000,2000,5000,10000,20000",
        "L" => "10,20,40,60,100,200,500", "S" => "1,50",
        "targets" => "forward,gradient", "seconds" => "0.5",
        "out" => "methods-results",
    )
    for a in args
        m = match(r"^--([A-Za-z]+)=(.*)$", a)
        (m === nothing || !haskey(opts, m.captures[1])) &&
            error("unknown argument $a")
        opts[m.captures[1]] = m.captures[2]
    end
    targets = split(opts["targets"], ',')
    all(in(("forward", "gradient")), targets) ||
        error("--targets takes forward and/or gradient, not $(opts["targets"])")
    return (;
        Ts = _ints(opts["T"]), Ls = _ints(opts["L"]), Ss = _ints(opts["S"]),
        targets, seconds = parse(Float64, opts["seconds"]), out = opts["out"],
    )
end

# Minimum time in ns of each method, keyed by `(target, S, T, L)`.
function run_grid(opts, io)
    times = Dict{Tuple{String, Int, Int, Int}, Dict{String, Float64}}()
    for target in opts.targets, S in opts.Ss, T in opts.Ts, L in opts.Ls
        L > T && continue
        cell = Dict{String, Float64}()
        for (name, method) in METHODS
            f, θ = convolution_loss(method, S, T, L)
            b = timer(f, θ, target, opts.seconds)
            tmin, tmed = minimum(b.times), median(b.times)
            cell[name] = tmin
            println(io, join((target, S, T, L, name, tmin, tmed), '\t'))
            flush(io)
            @printf(
                "%-8s S %2d T %5d L %3d %-6s %12.1f µs\n",
                target, S, T, L, name, tmin / 1.0e3
            )
        end
        times[(target, S, T, L)] = cell
    end
    return times
end

speedup(c) = c["Direct"] / c["FFT"]

# The smallest `L` from which FFT is faster at every longer `L` in the grid,
# or `nothing` if it is not faster at the longest.
function crossover(times, target, S, T, Ls)
    Lc = nothing
    for L in reverse(Ls)
        c = get(times, (target, S, T, L), nothing)
        c === nothing && continue
        speedup(c) > 1 || break
        Lc = L
    end
    return Lc
end

# The slowdown of picking FFT when `pick_fft` else Direct, against the
# faster of the two, worst over the cells, and where it happens.
function worst(times, keys, pick_fft)
    w, at = 1.0, first(keys)
    for k in keys
        c = times[k]
        t = pick_fft(k) ? c["FFT"] : c["Direct"]
        r = t / min(c["FFT"], c["Direct"])
        r > w && ((w, at) = (r, k))
    end
    return w, at
end

_cell(k) = "$(k[1]) S $(k[2]) T $(k[3]) L $(k[4])"

function summary(io, times, opts)
    println(io, "# Direct against FFTMethod\n")
    println(io, "Julia ", VERSION, ", ", Threads.nthreads(), " thread(s), ", Sys.cpu_info()[1].model, ".")
    println(io, "Each value is the Direct time over the FFT time, from minimum times.")
    println(io, "Above 1 FFT is faster.")
    println(io, "The crossover is the smallest L from which FFT wins at every longer L in the grid.")
    for target in opts.targets, S in opts.Ss
        println(io, "\n## ", target, ", S = ", S, "\n")
        println(io, "| T | ", join(("L $L" for L in opts.Ls), " | "), " | crossover L |")
        println(io, "|---|", repeat("---|", length(opts.Ls) + 1))
        for T in opts.Ts
            cells = map(opts.Ls) do L
                c = get(times, (target, S, T, L), nothing)
                c === nothing ? "" : @sprintf("%.2f", speedup(c))
            end
            Lc = crossover(times, target, S, T, opts.Ls)
            println(io, "| $T | ", join(cells, " | "), " | ", something(Lc, "none"), " |")
        end
    end
    allkeys = collect(keys(times))
    println(io, "\n## Threshold rule\n")
    println(io, "FFT when L ≥ L₀ and T ≥ T₀, else Direct, fitted over every cell above.")
    println(io, "The slowdown is against the faster method in the same cell.\n")
    w, at = worst(times, allkeys, k -> false)
    best = (w, at, "never FFT")
    for L0 in opts.Ls, T0 in opts.Ts
        w, at = worst(times, allkeys, k -> k[4] >= L0 && k[3] >= T0)
        w < best[1] && (best = (w, at, "L₀ = $L0, T₀ = $T0"))
    end
    w, at, rule = best
    @printf(io, "- Best rule: %s; worst slowdown %.2fx at %s.\n", rule, w, _cell(at))
    for (name, pick) in (
            "Always Direct" => (k -> false), "Always FFT" => (k -> true),
        )
        w, at = worst(times, allkeys, pick)
        @printf(io, "- %s: worst slowdown %.2fx at %s.\n", name, w, _cell(at))
    end
    return nothing
end

function main(opts)
    mkpath(opts.out)
    tsv = joinpath(opts.out, "methods.tsv")
    times = open(tsv, "w") do io
        println(io, "# julia=", VERSION, " threads=", Threads.nthreads(), " fftw_threads=", FFTW.get_num_threads())
        println(io, "# cpu=", Sys.cpu_info()[1].model)
        println(io, join(("target", "S", "T", "L", "method", "min_ns", "median_ns"), '\t'))
        run_grid(opts, io)
    end
    md = joinpath(opts.out, "SUMMARY.md")
    open(io -> summary(io, times, opts), md, "w")
    print(read(md, String))
    println("\nwrote ", tsv, " and ", md)
    return nothing
end

FFTW.set_num_threads(1)
main(parse_args(ARGS))
