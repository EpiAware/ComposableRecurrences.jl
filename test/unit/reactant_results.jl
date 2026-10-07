# The committed Reactant support results agree with `expected.jl`.
# The matrix itself runs in its own workflow (test/reactant/); this check
# keeps the committed `results.tsv`, `RESULTS.md` and the expectations from
# drifting apart when only one of them is edited.

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
    @test !isempty(rows)
    for r in rows
        key = (r[:name], r[:mode], r[:config], r[:backend])
        @test r[:name] in names
        r[:status] == "skipped" && continue
        @test (r[:status] == "works") == get(expected, key, false)
    end
    # Every case has a row for each mode and config run on the CPU.
    configs = unique(r[:config] for r in rows)
    for n in names, m in ("forward", "reverse"), c in configs
        @test any(r -> (r[:name], r[:mode], r[:config], r[:backend]) == (n, m, c, "cpu"), rows)
    end
    # RESULTS.md is generated from the same run.
    md = read(joinpath(dir, "RESULTS.md"), String)
    nworks = count(r -> r[:status] == "works", rows)
    @test count("| works |", md) == nworks
end
