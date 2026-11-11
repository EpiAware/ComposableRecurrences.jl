# The file `benchmark/ad_latest.jl` publishes for the AD comparison page,
# in the layout the page's reader (`EpiAwarePackageTools.load_ad_benchmarks`)
# takes: nested `data` dictionaries down to entries with a `times` vector,
# whose minimum it reports, and a `memory` number. The layout is checked
# here rather than first seen on a broken page.

@testitem "AD benchmarks: the published file merges backends in the page's layout" begin
    using BenchmarkTools, ComposableRecurrences
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
    scenarios = data["data"]["AD gradients"]["data"]
    @test sort!(collect(keys(scenarios))) == ["A", "B"]
    @test sort!(collect(keys(scenarios["A"]["data"]))) == ["X", "Y"]
    leaf = scenarios["A"]["data"]["X"]
    @test leaf["times"] == [minimum(trial.times)]
    @test leaf["memory"] == trial.memory
    @test collect(keys(scenarios["B"]["data"])) == ["Y"]

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
