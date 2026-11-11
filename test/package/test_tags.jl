# PACKAGE-OWNED: test tags. An item in `test/unit` or `test/usecases` that
# uses `Threaded`, `EXECUTOR` or `Threads.` carries the `:threads` tag, so
# the Threads workflow runs it with four threads on the current release,
# where it runs only the tagged items (`threads_only`).

@testitem "Test tags: items that use threads carry the threads tag" tags = [:quality] begin
    # The names of the items in `text` whose body uses threading and whose
    # header, up to its `begin`, does not name `:threads`.
    function untagged_threading(text)
        names = String[]
        chunks = split(text, r"^(?=@test(item|snippet|module) )"m)
        for chunk in chunks
            m = match(r"^@testitem \"([^\"]+)\"", chunk)
            m === nothing && continue
            stop = findfirst(r"begin\s*$"m, chunk)
            header = stop === nothing ? chunk : chunk[1:last(stop)]
            body = stop === nothing ? "" : chunk[(last(stop) + 1):end]
            uses = occursin(r"Threaded|EXECUTOR|Threads\.", body)
            uses && !occursin(":threads", header) && push!(names, m.captures[1])
        end
        return names
    end
    sample = """
    @testitem "tagged" tags = [:threads] begin
        CR.Threaded()
    end
    @testitem "untagged" setup = [S] begin
        Threads.nthreads()
    end
    @testitem "serial" begin
        1 + 1
    end
    """
    @test untagged_threading(sample) == ["untagged"]
    untagged = String[]
    for dir in ("unit", "usecases")
        for file in readdir(joinpath(@__DIR__, "..", dir); join = true)
            endswith(file, ".jl") || continue
            append!(untagged, untagged_threading(read(file, String)))
        end
    end
    # Tag each item listed here `:threads`.
    @test isempty(untagged)
end
