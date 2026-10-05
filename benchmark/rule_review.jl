#!/usr/bin/env julia
# Keep/delete evidence for each analytic adjoint: its gradient time against
# the paths that would replace it, per backend, at S = 1, 5 and 50 strata
# (T = 200 steps, L = 20 lags; S = 10 at most for a `Primary()` kernel,
# whose ForwardDiff reference grows with S L T parameters).
#
#   julia --project=benchmark benchmark/rule_review.jl [row ...]
#
# Arms:
#   rule       the analytic adjoint
#   local      a pointwise modifier's pullback replaced by the local
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
CR.uses_adjoint(::LocalFD, ::CR.Step) = true
CR.forward(w::LocalFD, ::CR.Init, s, h) = CR.forward(w.m, CR.Init(), s, h)
CR.pullback!(grads, w::LocalFD, ::CR.Init, s, h) = CR.pullback!(grads, w.m, CR.Init(), s, h)
CR.forward(w::LocalFD, ::CR.Step, v, s, t, k) = CR.forward(w.m, CR.Step(), v, s, t, k)

hide(m, ::Val{true}) = LocalFD(m)
hide(m, ::Val{false}) = m
strata(S, x) = S == 1 ? x : PerStratum(fill(x, S))
weights(S, matrix = false) = (Random.seed!(S); S == 1 && !matrix ? randn(T) : randn(S, T))
history(S, x) = S == 1 ? fill(x, L) : fill(x, S, L)
mixing(S) = S == 1 ? I : Matrix(0.8I(S) .+ 0.2 / S .* ones(S, S))
function sparse_mixing(S)
    Random.seed!(S)
    return sprand(S, S, min(1.0, 5 / S)) .* 0.04 + 0.8 * sparse(1.0I, S, S)
end

# A loss: `K` picks the model, `wrap` is identity or NoAdjoint, `LF` hides
# the pointwise pullbacks (a type parameter, so the model type is stable),
# `p` holds the fixed data.
struct Loss{K, LF, W, P}
    wrap::W
    p::P
end
Loss(kind, wrap, lf, p) = Loss{kind, lf, typeof(wrap), typeof(p)}(wrap, p)
lf(::Loss{K, LF}) where {K, LF} = Val(LF)

function (f::Loss{:core})(θ)
    (; W, K, h, dims) = f.p
    r = Recurrence(G; coupling = K)
    return sum(W .* log.(f.wrap(r)(exp.(reshape(θ, dims)); history = h)))
end
function (f::Loss{:depletion})(θ)
    (; W, K, N, h, dims) = f.p
    dep = hide(CR.Depletion(N), lf(f))
    r = Recurrence(G; coupling = K, modifiers = (dep,))
    return sum(W .* log.(f.wrap(r)(exp.(reshape(θ, dims)); history = h)))
end
function (f::Loss{:imports})(θ)
    (; W, K, h, dims) = f.p
    m = hide(CR.Add(TimeVarying(PerStratum(fill(0.5, dims)))), lf(f))
    r = Recurrence(G; coupling = K, modifiers = (m,))
    return sum(W .* log.(f.wrap(r)(exp.(reshape(θ, dims)); history = h)))
end
function (f::Loss{:clamp})(θ)
    (; W, K, h, dims) = f.p
    r = Recurrence(G; coupling = K, modifiers = (hide(CR.Clamp(0.0, 50.0), lf(f)),))
    return sum(W .* log.(f.wrap(r)(exp.(reshape(θ, dims)); history = h)))
end
# A kernel per infection time (`Primary()`), per stratum, seeded at times
# 1 to L; `θ` holds the kernel then the log gain.
function (f::Loss{:primary})(θ)
    (; W, K, h, dims) = f.p
    S = first(dims)
    kern = TimeVarying(PerStratum(reshape(θ[1:(S * L * T)], S, L, T)), CR.Primary())
    R = exp.(reshape(θ[(S * L * T + 1):end], S, T))
    r = Recurrence(kern; coupling = K)
    return sum(W[:, (L + 1):end] .* log.(f.wrap(r)(R; history = h, start = L + 1)))
end
function (f::Loss{:convolution})(θ)
    (; W, dims) = f.p
    return sum(W .* f.wrap(Convolution([0.0; G]))(reshape(θ, dims)))
end
function (f::Loss{:rw})(θ)
    return sum(f.p.W .* f.wrap(Recurrence([1.0]))(; history = [0.3], add = θ))
end
function (f::Loss{:ar})(θ)
    r = Recurrence(θ[1:2])
    return sum(f.p.W .* f.wrap(r)(; history = [0.1, 0.2], add = θ[3:end]))
end
function (f::Loss{:bvd_renewal})(θ)
    seed = exp.(θ[(L + 1):(2L)])
    dep = hide(CR.Depletion(1.0e5; pool0 = max(1.0e5 - sum(seed), 0.0)), lf(f))
    r = Recurrence(θ[1:L]; modifiers = (dep,))
    y = f.wrap(r)(exp.(θ[(2L + 1):end]); history = seed)
    return sum(f.p.W .* log.(y))
end
function (f::Loss{:bvd_patch})(θ)
    o = L
    K = reshape(θ[(o + 1):(o + 25)], 5, 5)
    o += 25
    seeds = reshape(exp.(θ[(o + 1):(o + 5L)]), 5, L)
    o += 5L
    R = reshape(exp.(θ[(o + 1):(o + 5T)]), 5, T)
    pool0 = PerStratum(max.(1.0e5 .- vec(sum(seeds; dims = 2)), 0.0))
    dep = hide(CR.Depletion(PerStratum(fill(1.0e5, 5)); pool0), lf(f))
    r = Recurrence(θ[1:L]; modifiers = (CR.Redistribute(K, θ[end]), dep))
    return sum(f.p.W .* log.(f.wrap(r)(R; history = seeds)))
end

# Concrete, type-stable data for S strata.
function params(S, K)
    dims = S == 1 ? (T,) : (S, T)
    return (; W = weights(S), K, N = strata(S, 1.0e4), h = history(S, 5.0), dims)
end

θstrata(S) = (Random.seed!(10 + S); 0.1 .+ 0.05 .* randn(S * T))

function rows()
    out = []
    for S in (1, 5, 50)
        p = params(S, mixing(S))
        push!(out, ("Recurrence core S=$S", :core, p, θstrata(S), (:rule, :plain)))
        push!(out, ("Depletion S=$S", :depletion, p, θstrata(S), (:rule, :local, :plain)))
        push!(out, ("Convolution S=$S", :convolution, p, rand(S * T), (:rule, :plain)))
    end
    for S in (5, 50)
        p = params(S, sparse_mixing(S))
        push!(out, ("sparse coupling S=$S", :core, p, θstrata(S), (:rule, :plain)))
    end
    for S in (1, 5, 10)
        p = (; W = weights(S, true), K = mixing(S), h = fill(5.0, S, L), dims = (S, T))
        K0 = [G[i] * (1 - 0.3 * (c > T ÷ 2)) for a in 1:S, i in 1:L, c in 1:T]
        θ = [vec(K0); θstrata(S)]
        push!(out, ("Primary kernel S=$S", :primary, p, θ, (:rule, :plain)))
    end
    p = params(5, mixing(5))
    push!(out, ("Imports S=5", :imports, p, θstrata(5), (:rule, :local, :plain)))
    push!(out, ("Clamp S=5", :clamp, p, θstrata(5), (:rule, :local, :plain)))
    p1 = (; W = weights(1))
    push!(out, ("RW S=1", :rw, p1, 0.1 .* randn(T), (:rule, :plain)))
    push!(out, ("AR(2) S=1", :ar, p1, [0.5; -0.2; 0.1 .* randn(T)], (:rule, :plain)))
    push!(
        out, (
            "BVD renewal", :bvd_renewal, p1,
            [G; fill(log(10.0), L); 0.05 .+ 0.05 .* randn(T)], (:rule, :local, :plain),
        )
    )
    push!(
        out, (
            "BVD patch S=5", :bvd_patch, (; W = weights(5)),
            [
                G; vec(0.05 .* (ones(5, 5) .- I(5))); fill(log(5.0), 5L);
                0.1 .+ 0.05 .* randn(5T); 0.5
            ],
            (:rule, :local, :plain),
        )
    )
    return out
end

function time_arm(f, θ, backend, gfd)
    prep = prepare_gradient(f, backend, copy(θ))
    grad = similar(θ)
    gradient!(f, grad, prep, backend, θ)
    err = maximum(abs.(grad .- gfd)) / max(1.0, maximum(abs.(gfd)))
    b = @benchmark(gradient!($f, $grad, $prep, $backend, $θ); samples = 100, evals = 1)
    return median(b).time / 1.0e3, err
end

const SELECTED = copy(ARGS)
for (name, kind, p, θ, arms) in rows()
    isempty(SELECTED) || any(s -> occursin(s, name), SELECTED) || continue
    fs = Dict(
        :rule => Loss(kind, identity, false, p),
        :local => Loss(kind, identity, true, p),
        :plain => Loss(kind, NoAdjoint, false, p),
    )
    gfd = ForwardDiff.gradient(fs[:rule], θ)
    for (bname, backend) in BACKENDS
        ts = Dict{Symbol, Float64}()
        errs = Dict{Symbol, Float64}()
        for arm in arms
            try
                ts[arm], errs[arm] = time_arm(fs[arm], θ, backend, gfd)
            catch e
                @printf(
                    "%-22s %-8s %-6s FAILED %s\n", name, bname, arm,
                    first(replace(sprint(showerror, e), r"\s+" => " "), 300)
                )
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
