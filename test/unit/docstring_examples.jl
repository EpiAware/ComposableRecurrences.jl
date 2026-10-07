# Docstring examples are doctests, which only the quality run and the docs
# build check. This runs each public docstring's examples in the default unit
# run too, one fresh module per docstring, ignoring the expected output.

@testitem "Docstring examples run" begin
    using ComposableRecurrences
    CR = ComposableRecurrences

    # The code of each doctest in the authored docstrings of `name`, read
    # from the raw text so the check does not need the REPL docs system.
    function example_blocks(mod, name)
        multidoc = get(Base.Docs.meta(mod), Base.Docs.Binding(mod, name), nothing)
        multidoc === nothing && return String[]
        out = String[]
        for ds in values(multidoc.docs)
            text = join(x for x in ds.text if x isa AbstractString)
            for m in eachmatch(r"^```jldoctest[^\n]*\n(.*?)^```"ms, text)
                push!(out, first(split(m.captures[1], r"^# output$"m)))
            end
        end
        return out
    end

    # Run each block; return the names whose examples threw and the count.
    function run_examples(mod)
        failed, nrun = Symbol[], 0
        for name in names(mod)
            sandbox = Module(gensym(name))
            for code in example_blocks(mod, name)
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
