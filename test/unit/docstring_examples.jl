# The API page does not run `@example` blocks inside docstrings, so each
# public docstring's examples run here, one fresh module per docstring.

@testitem "Docstring examples run" begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    # The Markdown module the docstrings are parsed into.
    Markdown = parentmodule(typeof(Base.Docs.doc(CR)))

    function example_blocks(md, out = String[])
        if md isa Markdown.Code
            startswith(md.language, "@example") && push!(out, md.code)
        elseif hasproperty(md, :content) && md.content isa AbstractVector
            foreach(x -> example_blocks(x, out), md.content)
        end
        return out
    end

    # Run each block; return the names whose examples threw and the count.
    function run_examples(mod)
        failed, nrun = Symbol[], 0
        for name in names(mod)
            blocks = example_blocks(Base.Docs.doc(getfield(mod, name)))
            sandbox = Module(gensym(name))
            for code in blocks
                nrun += 1
                try
                    include_string(sandbox, code, "docstring of $name")
                catch err
                    @error "docstring example of $name failed" exception = err
                    push!(failed, name)
                end
            end
        end
        return failed, nrun
    end

    failed, nrun = run_examples(CR)
    @test isempty(failed)
    @test nrun >= length(names(CR)) - 1
end
