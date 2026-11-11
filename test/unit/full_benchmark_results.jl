# The file `benchmark/full_latest.jl` publishes from the weekly full grid:
# the per-backend runs merged into one `BenchmarkGroup` that
# `BenchmarkTools.load` reads back. The merge is checked here rather than
# first seen on a failed deploy.

@testitem "Full benchmarks: the per-backend runs merge into one loadable group" begin
    using BenchmarkTools, ComposableRecurrences
    script = joinpath(pkgdir(ComposableRecurrences), "benchmark", "full_latest.jl")
    mod = Module(:FullLatest)
    Base.include(mod, script)

    # A primal job's run and two backends' runs, as `benchmark/run.jl` saves
    # them.
    dir = mktempdir()
    function saved(file, suite)
        results = run(suite; seconds = 0.1)
        BenchmarkTools.save(joinpath(dir, file), results)
        return joinpath(dir, file), results
    end
    entry(f) = @benchmarkable($f(), evals = 1, samples = 3, seconds = 0.1)
    primal = BenchmarkGroup()
    primal["Evaluation"] = BenchmarkGroup("Matrix m" => entry(() -> 1))
    primal["Convolution methods"] = BenchmarkGroup(
        "S 1" => BenchmarkGroup("Direct forward" => entry(() -> 2))
    )
    function backend(name)
        suite = BenchmarkGroup()
        suite["AD gradients"] = BenchmarkGroup(
            "A" => BenchmarkGroup(name => entry(() -> sum(rand(3)))),
            "Matrix m" => BenchmarkGroup(name => entry(() -> 3)),
        )
        return suite
    end
    fp, rp = saved("primal.json", primal)
    fx, rx = saved("x.json", backend("X"))
    fy, _ = saved("y.json", backend("Y"))

    merged = mod.merge_results([fp, fx, fy, joinpath(dir, "none.json")])
    @test sort!(collect(keys(merged))) ==
        ["AD gradients", "Convolution methods", "Evaluation"]
    @test sort!(collect(keys(merged["AD gradients"]["A"]))) == ["X", "Y"]
    @test merged["AD gradients"]["A"]["X"].times ==
        rx["AD gradients"]["A"]["X"].times
    @test merged["Convolution methods"]["S 1"]["Direct forward"].times ==
        rp["Convolution methods"]["S 1"]["Direct forward"].times

    # Saved, it loads back as one group with the same entries.
    out = joinpath(dir, "out", "latest.json")
    mkpath(dirname(out))
    BenchmarkTools.save(out, merged)
    back = first(BenchmarkTools.load(out))
    @test back isa BenchmarkGroup
    @test sort!(collect(keys(back["AD gradients"]["Matrix m"]))) == ["X", "Y"]
    @test back["Evaluation"]["Matrix m"].times ==
        rp["Evaluation"]["Matrix m"].times

    # The same entry in two runs is an error, not a silent overwrite.
    @test_throws ErrorException mod.merge_results([fx, fx])

    # The report counts each job's entries and returns the jobs with none.
    jobs = ["primal", "X", "Y", "Z"]
    counts = mod.count_entries(merged, jobs)
    @test counts == Dict("primal" => 2, "X" => 2, "Y" => 2, "Z" => 0)
    io = IOBuffer()
    @test mod.report(io, counts, jobs) == ["Z"]
    @test occursin("X: 2 entries", String(take!(io)))
end
