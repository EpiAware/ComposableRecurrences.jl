# The file `benchmark/ad_latest.jl` publishes for the AD comparison page:
# the page reads it with `EpiAwarePackageTools.load_ad_benchmarks`, so its
# layout is checked here rather than first seen on a broken page.

@testitem "AD benchmarks: the published file merges backends in the page's layout" begin
    using BenchmarkTools, ComposableRecurrences, EpiAwarePackageTools
    script = joinpath(pkgdir(ComposableRecurrences), "benchmark", "ad_latest.jl")
    mod = Module(:ADLatest)
    Base.include(mod, script)

    # Two backends' runs, as `benchmark/run.jl` saves them, with a matrix
    # entry that is not a registry scenario.
    dir = mktempdir()
    function saved(file, entries)
        grad = BenchmarkGroup()
        for (scenario, backend, f) in entries
            haskey(grad, scenario) || (grad[scenario] = BenchmarkGroup())
            grad[scenario][backend] = @benchmarkable(
                $f(), evals = 1, samples = 5, seconds = 1
            )
        end
        suite = BenchmarkGroup()
        suite["AD gradients"] = grad
        results = run(suite)
        BenchmarkTools.save(joinpath(dir, file), results)
        return joinpath(dir, file), results
    end
    fa, ra = saved(
        "a.json", [("A", "X", () -> sum(rand(10))), ("Matrix m", "X", () -> 1)]
    )
    fb, rb = saved("b.json", [("A", "Y", () -> rand(3)), ("B", "Y", () -> 2)])
    grid = mod.merge_results([fa, fb, joinpath(dir, "none.json")], Set(["A", "B"]))
    @test sort!(collect(keys(grid))) == ["A", "B"]
    @test sort!(collect(keys(grid["A"]))) == ["X", "Y"]
    @test collect(keys(grid["B"])) == ["Y"]
    trial = ra["AD gradients"]["A"]["X"]
    @test grid["A"]["X"]["times"] == [minimum(trial.times)]
    @test grid["A"]["X"]["memory"] == trial.memory
    @test grid["A"]["Y"]["allocs"] == rb["AD gradients"]["A"]["Y"].allocs

    out = mod.write_latest(joinpath(dir, "out", "latest.json"), grid)
    data = BenchmarkTools.JSON.parsefile(out)
    @test sort!(collect(keys(data["data"]["AD gradients"]["data"]))) == ["A", "B"]
    @test haskey(data["data"]["AD gradients"]["data"]["A"]["data"]["Y"], "times")
    r = EpiAwarePackageTools.load_ad_benchmarks(out, ["X", "Y", "Z"])
    @test r.backends == ["X", "Y"]
    @test r.missing_backends == ["Z"]
    @test length(r.rows) == 3
    row = only(filter(x -> x.scenario == "A" && x.backend == "X", r.rows))
    @test row.time_us ≈ minimum(trial.times) / 1.0e3

    # The report counts each backend's scenarios, gives a reason for each
    # gap, and returns the backends with no numbers.
    io = IOBuffer()
    reason(name, backend) = name == "B" && backend == "X" ? "skipped" : nothing
    empty_backends = mod.report_gaps(io, grid, ["A", "B"], ["X", "Y", "Z"], reason)
    report = String(take!(io))
    @test empty_backends == ["Z"]
    @test occursin("X: 1 of 2 registry scenarios", report)
    @test occursin("missing: B (skipped)", report)
    @test occursin("Y: 2 of 2 registry scenarios", report)
    @test occursin("missing: A (no number in the run", report)
end
