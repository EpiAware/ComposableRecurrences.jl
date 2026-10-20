#!/usr/bin/env julia
# Check that the AD fixtures load against older releases, as the benchmark
# history workflow loads them.
#
#   julia benchmark/history_fixtures.jl [tag ...]
#
# The history workflow copies test/ADFixtures on its own and benchmarks the
# last five tags with it, so a scenario or matrix case that uses a name an
# older release lacks needs a `_REQUIRES` (or `MatrixCases.REQUIRES`) entry.
# Without one the history run fails, and only after merge.
#
# For each tag (by default the last five, newest first, as the workflow
# picks them) this script checks the tag out in a temporary worktree,
# stages a copy of test/ADFixtures pointed at it, and in a fresh process
# evaluates every scenario and every arm of every `ci` matrix case that the
# loaded version supports. It prints each one that throws and exits
# non-zero if any does. With no tags it checks nothing.

const ROOT = dirname(@__DIR__)
const FIXTURES = joinpath(ROOT, "test", "ADFixtures")

# Run in the staged environment: the scenarios as `scenarios()` builds them,
# and the `ci` matrix arms `benchmark/benchmarks.jl` builds.
const CHECK = raw"""
using ADFixtures
using ADFixtures: MatrixCases
failed = String[]
note(what, e) = push!(failed, what * ": " * first(sprint(showerror, e), 300))
for (name, f, θ0) in ADFixtures._TWINS
    try
        f(θ0())
    catch e
        note("scenario \"$name\"", e)
    end
end
for c in MatrixCases.CASES, z in MatrixCases.sizes(c, "ci"), arm in ("rule", "NoAdjoint", "loop")
    arm == "loop" && !(arm in MatrixCases.arms(c)) && continue
    MatrixCases.available(c, arm) || continue
    try
        f, θ = MatrixCases.build(c, z, arm)
        f(θ)
    catch e
        note("matrix case $(c.name) $(z) $(arm)", e)
    end
end
println(length(ADFixtures._TWINS), " scenarios checked, ",
    length(ADFixtures.unsupported_scenarios()), " left out by `_REQUIRES`")
foreach(println, failed)
exit(isempty(failed) ? 0 : 1)
"""

function last_tags(n = 5)
    tags = readlines(`git -C $ROOT tag --sort=-v:refname`)
    return first(tags, min(n, length(tags)))
end

# Stage the fixtures for `tag` in `dir`, as the workflow does, with the
# package resolved from a worktree of the tag. Returns the staged project.
function stage(tag, dir)
    worktree = joinpath(dir, "package")
    run(`git -C $ROOT worktree add --quiet --detach $worktree $tag`)
    staged = joinpath(dir, "test", "ADFixtures")
    mkpath(dirname(staged))
    cp(FIXTURES, staged)
    rm(joinpath(staged, "Manifest.toml"); force = true)
    project = joinpath(staged, "Project.toml")
    toml = replace(read(project, String), "path = \"../..\"" => "path = $(repr(worktree))")
    write(project, toml)
    return staged
end

function check(tag)
    dir = mktempdir()
    try
        staged = stage(tag, dir)
        julia = `$(Base.julia_cmd()) --startup-file=no --project=$staged`
        run(`$julia -e 'using Pkg; Pkg.instantiate()'`)
        println("Fixtures against ", tag, ":")
        return success(pipeline(`$julia -e $CHECK`; stdout, stderr))
    finally
        run(ignorestatus(`git -C $ROOT worktree remove --force $(joinpath(dir, "package"))`))
    end
end

tags = isempty(ARGS) ? last_tags() : ARGS
isempty(tags) && (println("No tags: nothing to check."); exit(0))
bad = filter(!check, tags)
isempty(bad) || println("Fixtures fail against: ", join(bad, ", "))
exit(isempty(bad) ? 0 : 1)
