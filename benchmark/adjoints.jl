#!/usr/bin/env julia
# Gradient timings of the analytic adjoints against plain AD of the same
# call (`NoAdjoint`), at the scale of the design prototypes (N = 200 steps,
# L = 20 lags, NS = 5 strata), with the losses of the benchmarks that set the
# performance bars.
#
#   julia --project=benchmark benchmark/adjoints.jl [case ...]
#
# Cases:
#   Renewal1   single renewal, log loss (prototype harness)
#   RenewalS   five strata, dense mixing, floored depletion (bar: A5)
#   LD         delay convolution with history
#   BVDRenewal BVD `renewal_infections`: seeded hazard depletion (bar)
#   BVDPatch   BVD `patch_infections`: importation redistribution and
#              hazard depletion over five patches (bar); the loss reads the
#              infections only, as the operator does not return arrivals
# Every gradient is checked against ForwardDiff before it is timed; the
# median of prepared `gradient!` calls is reported.

using ComposableRecurrences
using ComposableRecurrences: ComposableRecurrences as CR, NoAdjoint
using ADTypes: AutoEnzyme, AutoMooncake
using BenchmarkTools: @benchmark
using DifferentiationInterface: gradient!, prepare_gradient
import Enzyme, ForwardDiff, Mooncake
using LinearAlgebra: I, normalize
using Printf: @printf
using Random: Random
using Statistics: median

const N, L, NS = 200, 20, 5
const NL = N + L
const BACKENDS = [
    ("Mooncake", AutoMooncake(; config = nothing)),
    (
        "Enzyme",
        AutoEnzyme(;
            mode = Enzyme.set_runtime_activity(Enzyme.Reverse),
            function_annotation = Enzyme.Const
        ),
    ),
]

Random.seed!(1)
const W_N = randn(N)
const W_SN = randn(NS, N)
const POP = fill(1.0e5, NS)

# The harness kernels are lag first after the prototypes' reversal.
const G = normalize(exp.(-0.2 .* (1:L)), 1)

function renewal1(w, θ)
    g, logw, logR = view(θ, 1:L), view(θ, (L + 1):(2L)), view(θ, (2L + 1):length(θ))
    y = w(Recurrence(g))(exp.(logR); history = exp.(logw))
    return sum(W_N .* log.(y))
end

function renewals(w, θ)
    o = L + NS^2
    g = view(θ, 1:L)
    K = reshape(view(θ, (L + 1):o), NS, NS)
    w0 = exp.(reshape(view(θ, (o + 1):(o + NS * L)), NS, L))
    R = exp.(reshape(view(θ, (o + NS * L + 1):length(θ)), NS, N))
    r = Recurrence(g; coupling = K, modifiers = (CR.Depletion(POP; form = :floor),))
    return sum(W_SN .* log.(w(r)(R; history = w0)))
end

function ld(w, θ)
    g, w0, ϵ = view(θ, 1:L), view(θ, (L + 1):(2L)), view(θ, (2L + 1):length(θ))
    kernel = [zero(eltype(θ)); g]
    return sum(W_N .* w(Convolution(kernel))(ϵ; history = w0))
end

# BVD renewal: `N + L` days after an `L`-day seed; the loss reads the last N.
const POP1 = 1.0e5
function bvd_renewal(w, θ)
    g = θ[1:L]
    seed = exp.(θ[(L + 1):(2L)])
    R = exp.(θ[(2L + 1):end])
    r = Recurrence(g; modifiers = (CR.Depletion(POP1; seeded = true),))
    y = w(r)(view(R, (L + 1):NL); history = seed)
    return sum(W_N .* log.(y))
end

function bvd_patch(w, θ)
    o = 0
    g = θ[(o + 1):(o + L)]; o += L
    K = reshape(θ[(o + 1):(o + NS^2)], NS, NS); o += NS^2
    seeds = reshape(exp.(θ[(o + 1):(o + NS * L)]), NS, L); o += NS * L
    R = reshape(exp.(θ[(o + 1):(o + NS * NL)]), NS, NL); o += NS * NL
    mods = (CR.Redistribute(K, θ[end]), CR.Depletion(POP; seeded = true))
    r = Recurrence(g; modifiers = mods)
    y = w(r)(R[:, (L + 1):end]; history = seeds)
    return sum(W_SN .* log.(y))
end

const CASES = [
    ("Renewal1", renewal1, () -> [G; log.(fill(10.0, L)); 0.05 .* randn(N)]),
    (
        "RenewalS", renewals,
        () -> [
            G; vec(Matrix(0.8I(NS) .+ 0.2 / NS .* ones(NS, NS)));
            fill(log(5.0), NS * L); 0.1 .+ 0.05 .* randn(NS * N)
        ],
    ),
    ("LD", ld, () -> [normalize(rand(L), 1); rand(L); rand(N)]),
    ("BVDRenewal", bvd_renewal, () -> [G; fill(log(10.0), L); 0.05 .+ 0.05 .* randn(NL)]),
    (
        "BVDPatch", bvd_patch,
        () -> [
            G; vec(0.05 .* (ones(NS, NS) .- I(NS))); fill(log(5.0), NS * L);
            0.1 .+ 0.05 .* randn(NS * NL); 0.5
        ],
    ),
]

const SELECTED = isempty(ARGS) ? first.(CASES) : copy(ARGS)

for (case, loss, θf) in CASES
    case in SELECTED || continue
    θ = θf()
    for (arm, wrap) in (("rule", identity), ("NoAdjoint", NoAdjoint))
        f = Base.Fix1(loss, wrap)
        gfd = ForwardDiff.gradient(f, θ)
        primal = median(@benchmark($f($θ); samples = 200, evals = 1)).time / 1.0e3
        for (bname, backend) in BACKENDS
            try
                t0 = time()
                prep = prepare_gradient(f, backend, copy(θ))
                grad = similar(θ)
                gradient!(f, grad, prep, backend, θ)
                tprep = time() - t0
                err = maximum(abs.(grad .- gfd)) / max(1.0, maximum(abs.(gfd)))
                b = @benchmark(
                    gradient!($f, $grad, $prep, $backend, $θ);
                    samples = 200, evals = 1
                )
                @printf(
                    "%-10s %-9s %-8s err=%.1e primal=%7.1f µs gradient=%8.1f µs allocs=%-6d first=%5.1f s\n",
                    case, arm, bname, err, primal, median(b).time / 1.0e3,
                    b.allocs, tprep
                )
            catch e
                @printf(
                    "%-10s %-9s %-8s FAILED %s\n", case, arm, bname,
                    first(sprint(showerror, e), 160)
                )
            end
            flush(stdout)
        end
    end
end
