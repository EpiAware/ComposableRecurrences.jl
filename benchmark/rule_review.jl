#!/usr/bin/env julia
# Keep/delete evidence for each analytic adjoint: its gradient time against
# the paths that would replace it, per backend, at S = 1, 5 and 50 strata
# (T = 200 steps, L = 20 lags).
#
#   julia --project=benchmark benchmark/rule_review.jl [row ...]
#
# Arms:
#   rule       the analytic adjoint
#   local FD   a pointwise modifier's pullback replaced by the local
#              ForwardDiff derivative (with its parameters), the rest analytic
#   plain      plain AD of the whole operator (NoAdjoint)
# Each gradient is checked against ForwardDiff before it is timed; the
# median of prepared `gradient!` calls is reported with the speed-up of the
# rule over each alternative.

using ComposableRecurrences
using ComposableRecurrences: ComposableRecurrences as CR, NoAdjoint
using ADTypes: AutoEnzyme, AutoMooncake
using BenchmarkTools: @benchmark
using DifferentiationInterface: gradient!, prepare_gradient
import Enzyme, ForwardDiff, Mooncake
using LinearAlgebra: I, normalize
using Printf: @printf, @sprintf
using Random: Random
using SparseArrays: sparse, sprand
using Statistics: median

const T, L = 200, 20
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
const G = normalize(exp.(-0.2 .* (1:L)), 1)

# A pointwise modifier with its hand-written pullback hidden, so the rule
# uses the local ForwardDiff derivative in its place.
struct LocalFD{M}
    m::M
end
CR.ispointwise(::LocalFD) = true
CR.uses_adjoint(::LocalFD) = true
CR.init_state(w::LocalFD, h) = CR.init_state(w.m, h)
CR.apply(w::LocalFD, v, s, t, k) = CR.apply(w.m, v, s, t, k)

strata(S, x) = S == 1 ? x : fill(x, S)
weights(S) = (Random.seed!(S); S == 1 ? randn(T) : randn(S, T))
history(S, x) = S == 1 ? fill(x, L) : fill(x, S, L)
mixing(S) = Matrix(0.8I(S) .+ 0.2 / S .* ones(S, S))

# Each row: (name, loss(wrap, θ), θ, arms). `wrap` is identity or NoAdjoint;
# `local` marks rows whose pointwise modifiers can be swapped for LocalFD.
function rows()
    out = []
    for S in (1, 5, 50)
        W = weights(S)
        K = S == 1 ? I : mixing(S)
        n = S * T
        θR = 0.1 .+ 0.05 .* randn(n)
        shape(θ) = S == 1 ? θ : reshape(θ, S, T)
        push!(
            out, (
                "Recurrence core S=$S",
                (w, θ) -> sum(W .* log.(w(Recurrence(G; coupling = K))(exp.(shape(θ)); history = history(S, 5.0)))),
                θR, (:rule, :plain),
            )
        )
        dep(lf) = lf ? LocalFD(CR.Depletion(strata(S, 1.0e4))) : CR.Depletion(strata(S, 1.0e4))
        push!(
            out, (
                "Depletion S=$S",
                (w, θ; lf = false) -> sum(
                    W .* log.(
                        w(Recurrence(G; coupling = K, modifiers = (dep(lf),)))(
                            exp.(shape(θ)); history = history(S, 5.0)
                        )
                    )
                ),
                θR, (:rule, :local, :plain),
            )
        )
        push!(
            out, (
                "Convolution S=$S",
                (w, θ) -> sum(W .* w(Convolution([0.0; G]))(shape(θ))),
                rand(n), (:rule, :plain),
            )
        )
    end
    S = 5
    W = weights(S)
    for (name, K) in (
            ("sparse coupling S=5", sparse_mixing(5)), ("sparse coupling S=50", sparse_mixing(50)),
        )
        S = size(K, 1)
        W = weights(S)
        push!(
            out, (
                name,
                (w, θ) -> sum(
                    W .* log.(
                        w(Recurrence(G; coupling = K))(exp.(reshape(θ, S, T)); history = history(S, 5.0))
                    )
                ),
                0.1 .+ 0.05 .* randn(S * T), (:rule, :plain),
            )
        )
    end
    S = 5
    W = weights(S)
    for (name, mk) in (
            ("Imports S=5", lf -> (lf ? LocalFD(CR.Imports(fill(0.5, S, T))) : CR.Imports(fill(0.5, S, T)))),
            ("Clamp S=5", lf -> (lf ? LocalFD(CR.Clamp(0.0, 50.0)) : CR.Clamp(0.0, 50.0))),
        )
        push!(
            out, (
                name,
                (w, θ; lf = false) -> sum(
                    W .* log.(
                        w(Recurrence(G; coupling = mixing(S), modifiers = (mk(lf),)))(
                            exp.(reshape(θ, S, T)); history = history(S, 5.0)
                        )
                    )
                ),
                0.1 .+ 0.05 .* randn(S * T), (:rule, :local, :plain),
            )
        )
    end
    push!(
        out, (
            "RW S=1", (w, θ) -> sum(W1 .* w(Recurrence([1.0]))(; history = [0.3], add = θ)),
            0.1 .* randn(T), (:rule, :plain),
        )
    )
    push!(
        out, (
            "AR(2) S=1", (w, θ) -> sum(W1 .* w(Recurrence(θ[1:2]))(; history = [0.1, 0.2], add = θ[3:end])),
            [0.5; -0.2; 0.1 .* randn(T)], (:rule, :plain),
        )
    )
    # BVD renewal: seeded hazard depletion over N + L days after an L-day seed.
    push!(
        out, (
            "BVD renewal",
            (w, θ; lf = false) -> begin
                dep = CR.Depletion(1.0e5; seeded = true)
                r = Recurrence(θ[1:L]; modifiers = (lf ? LocalFD(dep) : dep,))
                y = w(r)(exp.(view(θ, (2L + 1):length(θ))); history = exp.(θ[(L + 1):(2L)]))
                sum(W1 .* log.(y))
            end,
            [G; fill(log(10.0), L); 0.05 .+ 0.05 .* randn(T)], (:rule, :local, :plain),
        )
    )
    # BVD patch: importation redistribution and seeded hazard depletion.
    push!(
        out, (
            "BVD patch S=5",
            (w, θ; lf = false) -> begin
                o = L
                K = reshape(θ[(o + 1):(o + 25)], 5, 5)
                o += 25
                seeds = reshape(exp.(θ[(o + 1):(o + 5L)]), 5, L)
                o += 5L
                R = reshape(exp.(θ[(o + 1):(o + 5T)]), 5, T)
                dep = CR.Depletion(fill(1.0e5, 5); seeded = true)
                mods = (CR.Redistribute(K, θ[end]), lf ? LocalFD(dep) : dep)
                y = w(Recurrence(θ[1:L]; modifiers = mods))(R; history = seeds)
                sum(W5 .* log.(y))
            end,
            [G; vec(0.05 .* (ones(5, 5) .- I(5))); fill(log(5.0), 5L); 0.1 .+ 0.05 .* randn(5T); 0.5],
            (:rule, :local, :plain),
        )
    )
    return out
end

function sparse_mixing(S)
    Random.seed!(S)
    K = sprand(S, S, min(1.0, 5 / S)) .* 0.2 ./ 5
    return K + 0.8 * sparse(1.0I, S, S)
end
const W1 = (Random.seed!(1); randn(T))
const W5 = (Random.seed!(5); randn(5, T))

function time_arm(f, θ, backend, gfd)
    prep = prepare_gradient(f, backend, copy(θ))
    grad = similar(θ)
    gradient!(f, grad, prep, backend, θ)
    err = maximum(abs.(grad .- gfd)) / max(1.0, maximum(abs.(gfd)))
    b = @benchmark(gradient!($f, $grad, $prep, $backend, $θ); samples = 100, evals = 1)
    return median(b).time / 1.0e3, err
end

const SELECTED = copy(ARGS)
for (name, loss, θ, arms) in rows()
    isempty(SELECTED) || any(s -> occursin(s, name), SELECTED) || continue
    fs = Dict(
        :rule => θ -> loss(identity, θ),
        :local => θ -> loss(identity, θ; lf = true),
        :plain => θ -> loss(NoAdjoint, θ),
    )
    gfd = ForwardDiff.gradient(fs[:rule], θ)
    for (bname, backend) in BACKENDS
        ts = Dict{Symbol, Float64}()
        errs = Dict{Symbol, Float64}()
        for arm in arms
            try
                ts[arm], errs[arm] = time_arm(fs[arm], θ, backend, gfd)
            catch e
                @printf("%-22s %-8s %-6s FAILED %s\n", name, bname, arm, first(sprint(showerror, e), 120))
            end
        end
        cells = join(
            [
                @sprintf("%s %.1f µs (err %.0e)", arm, ts[arm], errs[arm])
                    for arm in arms if haskey(ts, arm)
            ], " | "
        )
        gains = join(
            [
                @sprintf("×%.2f vs %s", ts[arm] / ts[:rule], arm)
                    for arm in arms if arm !== :rule && haskey(ts, arm) && haskey(ts, :rule)
            ], ", "
        )
        @printf("%-22s %-8s %s || %s\n", name, bname, cells, gains)
        flush(stdout)
    end
end
