# `benchmark/full_latest.jl`: the per-backend runs merged into one loadable group.

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

    # `main` warns for each job without results and still writes; with no
    # results from any job it fails. The jobs are passed in, as the script
    # reads them from `ADFixtures`.
    out2 = joinpath(dir, "main", "latest.json")
    log = joinpath(dir, "main.log")
    open(log, "w") do io
        redirect_stdout(() -> mod.main([out2, fx]; jobs = jobs), io)
    end
    text = read(log, String)
    @test occursin("::warning::no full benchmark results for primal", text)
    @test occursin("::warning::no full benchmark results for Z", text)
    @test !occursin("results for X", text)
    @test haskey(first(BenchmarkTools.load(out2)), "AD gradients")
    @test_throws ErrorException mod.main(
        [joinpath(dir, "none", "latest.json"), joinpath(dir, "none.json")]; jobs = jobs
    )
    @test_throws ErrorException mod.main([out2]; jobs = jobs)
end
