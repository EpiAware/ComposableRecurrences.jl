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
# picks them) this script checks the tag out in a temporary worktree and
# stages copies of test/ADFixtures and benchmark/Project.toml pointed at
# it. In a fresh process it evaluates every scenario and every arm of every
# `ci` matrix case that the loaded version supports. History also runs this
# branch's benchmark/benchmarks.jl against each tag, so the process then runs
# that script too, without timing anything: each `DI.prepare_gradient` call
# is replaced by `nothing`, and each `@benchmarkable` by its expression,
# evaluated once, or by `nothing` if the expression calls `DI`. Building the
# script's gradients would take hours. It prints each failure and exits
# non-zero if there is any. With no tags it checks nothing.

using TOML

const ROOT = dirname(@__DIR__)
const FIXTURES = joinpath(ROOT, "test", "ADFixtures")

# Run in the staged environment: the scenarios as `scenarios()` builds them,
# the `ci` matrix arms `benchmark/benchmarks.jl` builds, and that script.
const CHECK = raw"""
using ADFixtures, ComposableRecurrences
using ADFixtures: MatrixCases
failed = String[]
note(what, e) = push!(failed, what * ": " * first(split(sprint(showerror, e), '\n')))
for (name, f, θ0) in ADFixtures._TWINS
    try
        f(θ0())
    catch e
        note("scenario " * repr(name), e)
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

# The benchmark script, with the gradient preparation and the timing taken
# out.
uses_di(ex) = ex === :DI
uses_di(ex::Expr) = any(uses_di, ex.args)
unquote(ex) = ex
unquote(ex::Expr) = ex.head === :$ ? unquote(only(ex.args)) : Expr(ex.head, map(unquote, ex.args)...)
untimed(ex) = ex
function untimed(ex::Expr)
    if ex.head === :call && ex.args[1] == :(DI.prepare_gradient)
        return :nothing
    elseif ex.head === :macrocall && ex.args[1] === Symbol("@benchmarkable")
        body = first(a for a in ex.args[2:end] if !(a isa LineNumberNode))
        return uses_di(body) ? :nothing : unquote(body)
    end
    return Expr(ex.head, map(untimed, ex.args)...)
end
script = Module(:BenchmarkScript)
Core.eval(script, :(include(p) = Base.include($untimed, $script, p)))
try
    Base.include(untimed, script, ENV["HISTORY_SCRIPT"])
    suite = Base.invokelatest(getglobal, script, :SUITE)
    println("benchmark/benchmarks.jl built ", join(sort!(collect(keys(suite.data))), ", "))
catch e
    note("benchmark/benchmarks.jl", e)
end
foreach(println, failed)
exit(isempty(failed) ? 0 : 1)
"""

function last_tags(n = 5)
    tags = readlines(`git -C $ROOT tag --sort=-v:refname`)
    return first(tags, min(n, length(tags)))
end

# Stage the fixtures and the benchmark environment for `tag` in `dir`, as
# the workflow does, with the package resolved from a worktree of the tag.
# Returns the staged benchmark project.
function stage(tag, dir)
    worktree = joinpath(dir, "package")
    run(`git -C $ROOT worktree add --quiet --detach $worktree $tag`)
    fixtures = joinpath(dir, "test", "ADFixtures")
    mkpath(dirname(fixtures))
    cp(FIXTURES, fixtures)
    rm(joinpath(fixtures, "Manifest.toml"); force = true)
    project = joinpath(fixtures, "Project.toml")
    toml = replace(read(project, String), "path = \"../..\"" => "path = $(repr(worktree))")
    write(project, toml)
    # The benchmark harness is not needed to build the suite.
    bench = TOML.parsefile(joinpath(ROOT, "benchmark", "Project.toml"))
    delete!(bench["deps"], "EpiAwarePackageTools")
    delete!(get(bench, "compat", Dict()), "EpiAwarePackageTools")
    bench["sources"]["ComposableRecurrences"] = Dict("path" => worktree)
    staged = joinpath(dir, "benchmark")
    mkpath(staged)
    open(io -> TOML.print(io, bench), joinpath(staged, "Project.toml"), "w")
    return staged
end

function check(tag)
    dir = mktempdir()
    try
        staged = stage(tag, dir)
        julia = `$(Base.julia_cmd()) --startup-file=no --project=$staged`
        run(`$julia -e 'using Pkg; Pkg.instantiate()'`)
        println("Fixtures against ", tag, ":")
        script = joinpath(ROOT, "benchmark", "benchmarks.jl")
        cmd = addenv(`$julia -e $CHECK`, "HISTORY_SCRIPT" => script)
        return success(pipeline(cmd; stdout, stderr))
    finally
        run(ignorestatus(`git -C $ROOT worktree remove --force $(joinpath(dir, "package"))`))
    end
end

tags = isempty(ARGS) ? last_tags() : ARGS
isempty(tags) && (println("No tags: nothing to check."); exit(0))
bad = filter(!check, tags)
isempty(bad) || println("Fixtures fail against: ", join(bad, ", "))
exit(isempty(bad) ? 0 : 1)
