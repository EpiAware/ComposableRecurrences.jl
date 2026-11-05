# The committed Reactant support results agree with `expected.jl`.
# The matrix itself runs in its own workflow (test/reactant/); this check
# keeps the committed `results.tsv`, `RESULTS.md` and the expectations from
# drifting apart when only one of them is edited. The registry scenarios'
# expectations live in the AD registry, whose environment this suite does
# not load; the Reactant workflow checks those rows against it.

@testitem "Reactant: committed results match expected.jl" begin
    using ComposableRecurrences
    dir = joinpath(pkgdir(ComposableRecurrences), "test", "reactant")
    mod = Module(:ReactantExpected)
    Base.include(mod, joinpath(dir, "cases.jl"))
    Core.eval(mod, :(using .ReactantCases))
    Base.include(mod, joinpath(dir, "expected.jl"))
    expected = mod.EXPECTED
    names = Set(c.name for c in mod.ReactantCases.CASES)

    lines = readlines(joinpath(dir, "results.tsv"))
    keys = Symbol.(split(lines[2], '\t'))
    rows = map(lines[3:end]) do l
        v = split(l, '\t')
        Dict(k => (i <= length(v) ? String(v[i]) : "") for (i, k) in enumerate(keys))
    end
    cases = filter(r -> r[:suite] == "cases", rows)
    registry = filter(r -> r[:suite] == "registry", rows)
    @test !isempty(cases)
    @test !isempty(registry)
    @test all(r -> r[:suite] in ("cases", "registry"), rows)
    for r in cases
        key = (r[:name], r[:mode], r[:backend])
        @test r[:name] in names
        r[:status] == "skipped" && continue
        @test (r[:status] == "works") == get(expected, key, false)
    end
    # Every case has a row for each mode and number of steps run on the CPU,
    # and every registry scenario one for each mode.
    steps = unique(r[:steps] for r in cases)
    for n in names, m in ("forward", "reverse"), T in steps
        @test any(
            r -> (r[:name], r[:mode], r[:backend], r[:steps]) == (n, m, "cpu", T),
            cases
        )
    end
    for n in unique(r[:name] for r in registry)
        @test sort([r[:mode] for r in registry if r[:name] == n && r[:backend] == "cpu"]) ==
            ["forward", "reverse"]
    end
    # RESULTS.md is generated from the same run.
    md = read(joinpath(dir, "RESULTS.md"), String)
    nworks = count(r -> r[:status] == "works", rows)
    @test count("| works |", md) == nworks
end

@testitem "Reactant: compare.jl gates on changed cells" begin
    using ComposableRecurrences
    dir = joinpath(pkgdir(ComposableRecurrences), "test", "reactant")
    mod = Module(:ReactantCompare)
    Base.include(mod, joinpath(dir, "compare.jl"))
    head = "# elapsed_s\t1\nstatus\tname\tmode\tsuite\tbackend\tsteps\n"
    row(s, n) = "$s\t$n\tforward\tcases\tcpu\t20\n"
    function tsv(rows...)
        path = tempname()
        write(path, head * join(rows))
        return path
    end
    committed = tsv(row("works", "a"), row("works", "b"))
    gate(fresh, subset) = redirect_stdout(devnull) do
        mod.main(committed, fresh, subset)
    end
    @test gate(tsv(row("works", "a"), row("works", "b")), false) == 0
    @test gate(tsv(row("works", "a")), false) == 1
    @test gate(tsv(row("works", "a")), true) == 0
    @test gate(tsv(row("error", "a")), true) == 1
    @test gate(tsv(), true) == 1
end
