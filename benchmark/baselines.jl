#!/usr/bin/env julia
# Checks that every baseline arm of a tier's cases gives the package's loss
# and ForwardDiff gradient to round-off, at each of the tier's sizes, so the
# arms the docs compare compute the same model.
#
#   julia --project=benchmark benchmark/baselines.jl [--tier=docs] [--rtol=1e-10]

using ADFixtures: MatrixCases
using ForwardDiff: ForwardDiff
using Printf: @printf

function check_baselines(tier, rtol)
    failed = 0
    for c in MatrixCases.CASES, z in MatrixCases.sizes(c, tier)
        f, θ = MatrixCases.build(c, z, "rule")
        y, g = f(θ), ForwardDiff.gradient(f, θ)
        for arm in MatrixCases.arms(c)
            arm in ("rule", "NoAdjoint", "local") && continue
            fb, θb = MatrixCases.build(c, z, arm)
            θb == θ || error("$(c.name) $z $arm: the parameters differ")
            ey = abs(fb(θ) - y) / max(1.0, abs(y))
            eg = maximum(abs.(ForwardDiff.gradient(fb, θ) .- g)) /
                max(1.0, maximum(abs, g))
            ok = ey <= rtol && eg <= rtol
            failed += !ok
            @printf(
                "%-4s %-20s %-14s %-12s loss %.1e  gradient %.1e\n",
                ok ? "ok" : "FAIL", c.name, string(z), arm, ey, eg
            )
        end
    end
    failed == 0 || error("$failed baseline arms differ from the package")
    return nothing
end

if abspath(PROGRAM_FILE) == @__FILE__
    opts = Dict("tier" => "docs", "rtol" => "1e-10")
    for a in ARGS
        m = match(r"^--([a-z]+)=(.*)$", a)
        m === nothing && error("unknown argument $a")
        opts[m.captures[1]] = m.captures[2]
    end
    check_baselines(opts["tier"], parse(Float64, opts["rtol"]))
end
