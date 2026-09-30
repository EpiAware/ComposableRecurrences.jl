# PACKAGE-OWNED: documentation standards. Every public docstring states its
# maths and carries a runnable example; prose avoids filler words and the
# word "piece"; docstrings and src comments do not name other packages; and
# Markdown prose keeps one sentence per line. Inputs live in
# `standards_config.jl`.

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

@testitem "Standards: wording" tags = [:quality] begin
    using ComposableRecurrences
    include(joinpath(@__DIR__, "standards_helpers.jl"))
    mod = ComposableRecurrences
    sources = vcat(
        prose_sources(mod), docstring_sources(mod), comment_sources()
    )
    found = violations(banned_hits, sources)
    pending(v) = any(l -> startswith(v, l * ","), PENDING_WORDING)
    @test filter(!pending, found) == String[]
    for label in PENDING_WORDING
        @testset "$label" begin
            @test !any(startswith(label * ","), found) broken = true
        end
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

@testitem "Standards: the checks detect violations" tags = [:quality] begin
    using ComposableRecurrences
    include(joinpath(@__DIR__, "standards_helpers.jl"))
    @test has_maths(["text\n```math\nx_t = y_t\n```\n"])
    @test !has_maths(["inline ``x_t`` only"])
    @test has_example(["```jldoctest\njulia> 1\n1\n```\n"])
    @test has_example(["```julia\nusing ComposableRecurrences\nx = 1\n```\n"])
    @test !has_example(["```julia\nRecurrence(kernel)\n```\n"])
    @test banned_hits("A robust method.") == ["robust"]
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
end
