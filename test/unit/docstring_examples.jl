# Docstring examples are doctests, which only the quality run and the docs
# build check. This runs each public docstring's examples in the default unit
# run too, one fresh module per docstring, after the block's `setup` and
# ignoring the expected output.

@testitem "Docstring examples run" begin
    using ComposableRecurrences
    CR = ComposableRecurrences

    # The `setup` expression of a doctest's header, or `nothing`.
    function block_setup(header)
        kws = strip(lstrip(strip(header), ';'))
        isempty(kws) && return nothing
        call = Meta.parse("f($kws)")
        for arg in call.args[2:end]
            if Meta.isexpr(arg, :kw) && arg.args[1] === :setup
                return eval(arg.args[2])
            end
        end
        return nothing
    end

    # The setup and code of each doctest in the authored docstrings of
    # `name`, read from the raw text so the check does not need the REPL docs
    # system.
    function example_blocks(mod, name)
        multidoc = get(Base.Docs.meta(mod), Base.Docs.Binding(mod, name), nothing)
        multidoc === nothing && return Tuple{Any, String}[]
        out = Tuple{Any, String}[]
        for ds in values(multidoc.docs)
            text = join(x for x in ds.text if x isa AbstractString)
            for m in eachmatch(r"^```jldoctest([^\n]*)\n(.*?)^```"ms, text)
                code = first(split(m.captures[2], r"^# output$"m))
                push!(out, (block_setup(m.captures[1]), code))
            end
        end
        return out
    end

    # Run each block; return the names whose examples threw and the count.
    function run_examples(mod)
        failed, nrun = Symbol[], 0
        for name in names(mod)
            sandbox = Module(gensym(name))
            for (setup, code) in example_blocks(mod, name)
                nrun += 1
                try
                    setup === nothing || Core.eval(sandbox, setup)
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
