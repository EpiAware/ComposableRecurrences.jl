#!/usr/bin/env julia
# Plain-AD gradient timings of the operators at the scale of the design
# prototypes (N = 200 steps, L = 20 lags, NS = 5 strata), for comparison
# with the hand-written loop arms those prototypes measured.
#
#   julia --project=benchmark benchmark/gradients.jl
#
# Each case differentiates the same scalar loss of a flat parameter vector
# as the prototype harness, with kernels lag first: Renewal1 (single renewal, log loss), RenewalS
# (five strata, dense mixing, floored depletion, log loss) and LD (a delay
# convolution with history). Every gradient is checked against ForwardDiff
# before it is timed; the median of prepared `gradient!` calls is reported.

using ComposableRecurrences
using ADFixtures: FlooredDepletion
using ADTypes: AutoEnzyme, AutoMooncake
using BenchmarkTools: @benchmark
using DifferentiationInterface: gradient!, prepare_gradient
import Enzyme, ForwardDiff, Mooncake
using LinearAlgebra: I, normalize
using Printf: @printf
using Random: Random
using Statistics: median

const N, L, NS = 200, 20, 5
const BACKENDS = [
    ("Mooncake", AutoMooncake(; config = nothing)),
    ("Enzyme", AutoEnzyme(; mode = Enzyme.set_runtime_activity(Enzyme.Reverse))),
]

Random.seed!(1)
const W_N = randn(N)
const W_SN = randn(NS, N)
const POP = fill(1.0e5, NS)
const G = normalize(exp.(-0.2 .* (1:L)), 1)  # lag first

function renewal1(θ)
    g, logw, logR = view(θ, 1:L), view(θ, (L + 1):(2L)), view(θ, (2L + 1):length(θ))
    y = Recurrence(g)(exp.(logR); history = exp.(logw))
    return sum(W_N .* log.(y))
end

function renewals(θ)
    o = L + NS^2
    g = view(θ, 1:L)
    K = reshape(view(θ, (L + 1):o), NS, NS)
    w0 = exp.(reshape(view(θ, (o + 1):(o + NS * L)), NS, L))
    R = exp.(reshape(view(θ, (o + NS * L + 1):length(θ)), NS, N))
    r = Recurrence(g; coupling = K, modifiers = (FlooredDepletion(POP),))
    return sum(W_SN .* log.(r(R; history = w0)))
end

function ld(θ)
    g, w0, ϵ = view(θ, 1:L), view(θ, (L + 1):(2L)), view(θ, (2L + 1):length(θ))
    kernel = [zero(eltype(θ)); g]
    return sum(W_N .* Convolution(kernel)(ϵ; history = w0))
end

const CASES = [
    ("Renewal1", renewal1, [G; log.(fill(10.0, L)); 0.05 .* randn(N)]),
    (
        "RenewalS", renewals,
        [
            G; vec(Matrix(0.8I(NS) .+ 0.2 / NS .* ones(NS, NS)));
            fill(log(5.0), NS * L); 0.1 .+ 0.05 .* randn(NS * N)
        ],
    ),
    ("LD", ld, [normalize(rand(L), 1); rand(L); rand(N)]),
]

for (case, f, θ) in CASES
    gfd = ForwardDiff.gradient(f, θ)
    primal = median(@benchmark($f($θ); samples = 200, evals = 1)).time / 1.0e3
    for (bname, backend) in BACKENDS
        prep = prepare_gradient(f, backend, copy(θ))
        grad = similar(θ)
        gradient!(f, grad, prep, backend, θ)
        err = maximum(abs.(grad .- gfd)) / max(1.0, maximum(abs.(gfd)))
        b = @benchmark(
            gradient!($f, $grad, $prep, $backend, $θ); samples = 200, evals = 1
        )
        @printf(
            "%-9s %-9s err=%.1e primal=%7.1f µs gradient=%8.1f µs allocs=%d\n",
            case, bname, err, primal, median(b).time / 1.0e3, b.allocs
        )
    end
end
