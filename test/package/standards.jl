# PACKAGE-OWNED: documentation standards. Every public docstring states its
# maths and carries a runnable example; prose avoids filler words and the
# word "piece"; docstrings and src comments do not name other packages; and
# Markdown prose keeps one sentence per line, at most `MAX_SENTENCE_WORDS`
# words long, with code lines at most `MAX_CODE_CHARS` characters. On
# listed pages each section that introduces a model gives its maths before
# the code, the README code is taken from the getting started page and
# prints nothing on the home page, and each concept in `ONE_HOME` is
# explained on its home page only. The README and docs pages also go through
# the shared `test_readme_prose` (banned words, sentence length). Inputs
# live in `standards_config.jl`.

@testitem "Standards: docstring maths" tags = [:quality] begin
    using ComposableRecurrences
    include(joinpath(@__DIR__, "standards_helpers.jl"))
    mod = ComposableRecurrences
    for name in public_names(mod)
        name in MATHS_ALLOW && continue
        @testset "$name" begin
            @test has_maths(authored_docs(mod, name)) broken =
                name in PENDING_MATHS
        end
    end
end

@testitem "Standards: docstring examples" tags = [:quality] begin
    using ComposableRecurrences
    include(joinpath(@__DIR__, "standards_helpers.jl"))
    mod = ComposableRecurrences
    for name in public_names(mod)
        @testset "$name" begin
            @test has_example(authored_docs(mod, name)) broken =
                name in PENDING_EXAMPLES
        end
    end
end

# The docs pages' `jldoctest` blocks run here as well as in the docs build,
# so an example moved out of a docstring keeps a unit-test check.
@testitem "Standards: docs page doctests" tags = [:quality] begin
    using ComposableRecurrences, Documenter
    root = joinpath(@__DIR__, "..", "..", "docs", "src")
    pages = String[]
    for (dir, _, files) in walkdir(root), f in files
        path = joinpath(dir, f)
        endswith(f, ".md") && occursin("```jldoctest", read(path, String)) &&
            push!(pages, path)
    end
    @test !isempty(pages)
    src = joinpath(mktempdir(), "src")
    for path in pages
        dest = joinpath(src, relpath(path, root))
        mkpath(dirname(dest))
        cp(path, dest)
    end
    doctest(src, Module[])
end

@testitem "Standards: wording" tags = [:quality] begin
    using ComposableRecurrences
    include(joinpath(@__DIR__, "standards_helpers.jl"))
    mod = ComposableRecurrences
    sources = vcat(
        prose_sources(mod), docstring_sources(mod), comment_sources()
    )
    test_pending(violations(banned_hits, sources), PENDING_WORDING)
end

@testitem "Standards: sentence length" tags = [:quality] begin
    using ComposableRecurrences
    include(joinpath(@__DIR__, "standards_helpers.jl"))
    mod = ComposableRecurrences
    sources = vcat(prose_sources(mod), docstring_sources(mod))
    found = violations(long_sentence_hits, sources)
    test_pending(found, PENDING_SENTENCE_LENGTH)
end

@testitem "Standards: code line length" tags = [:quality] begin
    using ComposableRecurrences
    include(joinpath(@__DIR__, "standards_helpers.jl"))
    found = violations(long_code_hits, code_sources(ComposableRecurrences))
    test_pending(found, PENDING_CODE_LENGTH)
end

@testitem "Standards: README and page prose" tags = [:quality] begin
    using EpiAwarePackageTools
    include(joinpath(@__DIR__, "standards_helpers.jl"))
    banned = vcat(
        filter(!in(BANNED_SHARED_SKIP), BANNED_README_WORDS),
        collect(BANNED_EXTRA)
    )
    for file in filter(endswith(".md"), standards_prose_files())
        test_readme_prose(file; banned)
    end
end

@testitem "Standards: no other package names" tags = [:quality] begin
    using ComposableRecurrences
    include(joinpath(@__DIR__, "standards_helpers.jl"))
    mod = ComposableRecurrences
    comments = filter(comment_sources()) do (label, _)
        !any(f -> startswith(label, f * ":"), PACKAGE_NAME_SKIP)
    end
    sources = vcat(docstring_sources(mod), comments)
    @test violations(package_hits, sources) == String[]
end

@testitem "Standards: one sentence per line" tags = [:quality] begin
    using ComposableRecurrences
    include(joinpath(@__DIR__, "standards_helpers.jl"))
    mod = ComposableRecurrences
    sources = vcat(prose_sources(mod), docstring_sources(mod))
    hits(line) = several_sentences(line) ? [strip(line)] : String[]
    @test violations(hits, sources) == String[]
end

@testitem "Standards: maths before code" tags = [:quality] begin
    include(joinpath(@__DIR__, "standards_helpers.jl"))
    @test issubset(first.(MATHS_FIRST_REUSE), MATHS_FIRST_PAGES)
    @test issubset(first.(PENDING_MATHS_FIRST), MATHS_FIRST_PAGES)
    for page in MATHS_FIRST_PAGES
        text = maths_first_text(joinpath(STANDARDS_ROOT, page))
        found = sections_missing_maths(text, MATHS_FIRST_CALLS)
        reused = [h for (f, h) in MATHS_FIRST_REUSE if f == page]
        pending = [h for (f, h) in PENDING_MATHS_FIRST if f == page]
        @testset "$page" begin
            @test setdiff(found, reused, pending) == String[]
            for heading in reused
                @testset "$heading reused" begin
                    @test heading in found
                end
            end
            for heading in pending
                @testset "$heading" begin
                    @test !(heading in found) broken = true
                end
            end
        end
    end
end

@testitem "Standards: README code is from the three-town page" tags = [
    :quality,
] begin
    include(joinpath(@__DIR__, "standards_helpers.jl"))
    readme = read(joinpath(STANDARDS_ROOT, "README.md"), String)
    page = read(
        joinpath(
            STANDARDS_ROOT, "docs", "src", "getting-started", "three-towns.md"
        ),
        String
    )
    lines = Set(strip.(split(page, '\n')))
    # Closing lines such as `end` or `)` match anywhere, so are not checked.
    code = filter(
        l -> !occursin(r"^(end|[)\]},]+)$", l), strip.(julia_block_lines(readme))
    )
    @test !isempty(code)
    @test filter(!in(lines), code) == String[]
end

@testitem "Standards: README example prints nothing on the home page" tags = [
    :quality,
] begin
    include(joinpath(@__DIR__, "standards_helpers.jl"))
    config = read(joinpath(STANDARDS_ROOT, "docs", "docs_config.jl"), String)
    readme = read(joinpath(STANDARDS_ROOT, "README.md"), String)
    # `INDEX_REWRITES` hides the README example's output on the home page by
    # matching its last line exactly, so the two must stay in step.
    hide = match(r"\"([^\"]+)\" =>\s*\"\1\\nnothing # hide\"", config)
    @test hide !== nothing
    blocks = [only(b.captures) for b in eachmatch(r"```julia\n(.*?)```"s, readme)]
    @test strip(last(split(strip(last(blocks)), '\n'))) == hide.captures[1]
end

@testitem "Standards: one home per concept" tags = [:quality] begin
    include(joinpath(@__DIR__, "standards_helpers.jl"))
    texts = Dict(
        replace(relpath_root(f), '\\' => '/') => read(f, String)
            for f in standards_prose_files()
    )
    for (anchor, (home, phrases)) in ONE_HOME
        @testset "$anchor" begin
            @test occursin("(@id $anchor)", texts[home])
            for phrase in phrases
                @test occursin(phrase, texts[home])
                @test [f for (f, t) in texts if f != home && occursin(phrase, t)] ==
                    String[]
            end
        end
    end
end

@testitem "Standards: the checks detect violations" tags = [:quality] begin
    using ComposableRecurrences
    include(joinpath(@__DIR__, "standards_helpers.jl"))
    @test has_maths(["text\n```math\nx_t = y_t\n```\n"])
    @test !has_maths(["inline ``x_t`` only"])
    @test has_example(["```jldoctest\njulia> 1\n1\n```\n"])
    @test has_example(["```julia\nusing ComposableRecurrences\nx = 1\n```\n"])
    @test !has_example(["```julia\nRecurrence(kernel)\n```\n"])
    @test banned_hits("A robust method.") == ["robust"]
    @test banned_hits("Leveraging it.") == ["Leveraging"]
    @test banned_hits("Synergies abound.") == ["Synergies"]
    @test isempty(banned_hits("A novelist and a piecewise kernel."))
    @test banned_hits("Each piece runs.") == ["piece"]
    @test isempty(banned_hits("`piece` and `PieceInterface` are names."))
    @test package_hits("As in Mooncake.") == ["Mooncake"]
    @test isempty(package_hits("Use `Mooncake` here."))
    @test several_sentences("One sentence. Two sentences.")
    @test !several_sentences("One sentence, e.g. with an aside.")
    @test !several_sentences("Want more? See the API.")
    @test [l for (_, l) in markdown_prose("a\n```julia\nx. Y\n```\nb")] ==
        ["a", "b"]
    @test [l for (_, l) in literate_prose("# Prose.\nx = 1  # code. X\n")] ==
        ["Prose."]
    @test [l for (_, l) in markdown_prose("- a\n    b. C\n")] == ["- a"]
    @test [l for (_, l) in markdown_prose("- a\n    b. C\n"; indented = true)] ==
        ["- a", "    b. C"]
    @test banned_hits("A variant of it.") == ["variant"]
    @test banned_hits("An analytic adjoint.") == ["analytic adjoint"]
    @test banned_hits("A hand-written adjoint.") == ["hand-written adjoint"]
    @test banned_hits("Exogenous cases.") == ["Exogenous"]
    @test sentence_words("- One `two three` [four](x) ``y_t`` five.") == 5
    @test isempty(long_sentence_hits(join(fill("word", 35), " ")))
    @test long_sentence_hits(join(fill("word", 36), " ")) == ["36 words"]
    @test isempty(long_code_hits("x"^80))
    @test long_code_hits("x"^81) == ["81 characters"]
    md = "a\n```julia\nx = 1\n```\n```math\ny\n```\n```@example e\nz\n```\n"
    @test markdown_code(md) == [(3, "x = 1"), (9, "z")]
    @test literate_code("# a\nx = 1\n# ```julia\n# y\n# ```\n") ==
        [(2, "x = 1"), (4, "y")]
    block = "x = 1\nmd\"\"\"\nProse. More\n```julia\ny = 2\n```\n\"\"\"\nz = 3\n"
    @test literate_code(block) == [(1, "x = 1"), (5, "y = 2"), (8, "z = 3")]
    @test [l for (_, l) in literate_prose(block)] == ["Prose. More"]
    @test is_pending("docs/a.md:3: 36 words", "docs/a.md")
    @test is_pending("docstring A, line 2: 36 words", "docstring A")
    @test !is_pending("docstring AB, line 2: 36 words", "docstring A")
    calls = ("Recurrence", "Transform")
    @test sections_missing_maths("# ## A\nr = Recurrence(k)\n", calls) ==
        ["A"]
    @test isempty(
        sections_missing_maths(
            "# ## A\n# ```math\nx\n# ```\nr = Recurrence(k)\n", calls
        )
    )
    reused = "# ## A\n# ```math\n# ```\nRecurrence(k)\n# ## B\nRecurrence(g)\n"
    @test sections_missing_maths(reused, calls) == ["B"]
    applied = "# ## A\n# ```math\n# ```\nr = Recurrence(k)\n# ## B\nr(R)\n"
    @test isempty(sections_missing_maths(applied, calls))
    md = "## A\n\n```julia\nr = Recurrence(k)\n```\n\n## B\n\n```math\nx\n```\n\n" *
        "```julia\nConvolution(w)\n```\n"
    @test sections_missing_maths(markdown_as_literate(md), calls) == ["A"]
    @test julia_block_lines("a\n```julia\nx = 1\n\ny = 2\n```\n") ==
        ["x = 1", "y = 2"]
    @test isempty(sections_missing_maths("# ## A\nx = MyAdd(1)\n", calls))
    @test sections_missing_maths("# ## A\nx = CR.Transform(+, 1)\n", calls) == ["A"]
    nested = "# ## A\n# ```math\n# ```\n# ### B\nRecurrence(k)\n"
    @test sections_missing_maths(nested, calls) == ["B"]
    @test sections_missing_maths("# ## [A](@id a)\nTransform(+, 1)\n", calls) == ["A"]
end

@testitem "Standards: the nav lists every page the docs build" tags = [
    :quality,
] begin
    include(joinpath(@__DIR__, "standards_helpers.jl"))
    docs = joinpath(STANDARDS_ROOT, "docs")
    src = joinpath(docs, "src")
    load(file) = (m = Module(); Base.include(m, joinpath(docs, file)); m)
    cfg, nav = load("docs_config.jl"), load("pages.jl")
    paths(x::AbstractString) = [x]
    paths(x::Pair) = paths(last(x))
    paths(x::AbstractVector) = reduce(vcat, map(paths, x); init = String[])
    paths(::Nothing) = String[]
    names = (
        :PACKAGE_TUTORIALS, :PACKAGE_SECTIONS,
        :DEVELOPMENT_EXTEND_PAGE, :GETTING_STARTED_FAQ,
    )
    registered = String[]
    for name in names
        isdefined(cfg, name) && append!(registered, paths(getfield(cfg, name)))
    end
    @test !isempty(registered)
    # Every authored page: Documenter builds each Markdown file under
    # docs/src, so one missing from the nav is published but unreachable.
    # Pages that make.jl writes (gitignored) are left to the rendered list.
    generated(rel) = rel in ("index.md", "release-notes.md") ||
        startswith(rel, "lib/") || startswith(rel, "benchmarks/") ||
        startswith(rel, cfg.TUTORIALS_SUBDIR)
    authored = String[]
    for (dir, _, files) in walkdir(src)
        occursin("node_modules", dir) && continue
        for file in files
            endswith(file, ".md") || continue
            rel = replace(relpath(joinpath(dir, file), src), '\\' => '/')
            generated(rel) || push!(authored, rel)
        end
    end
    # Every Literate page the build renders.
    md(dir, file) = string(dir, "/", splitext(file)[1], ".md")
    rendered = [
        [md(cfg.TUTORIALS_SUBDIR, f) for f in cfg.LIGHT_TUTORIALS];
        [md(cfg.TUTORIALS_SUBDIR, f) for f in cfg.HEAVY_TUTORIALS];
        [md("benchmarks", f) for f in cfg.HEAVY_BENCHMARKS]
    ]
    @test "extensions/distributions.md" in authored
    @test !isempty(rendered)
    # Regenerate `docs/pages.jl` with the kit's `update` when this fails.
    built = unique([registered; authored; rendered])
    @test setdiff(built, paths(nav.pages)) == String[]
end
