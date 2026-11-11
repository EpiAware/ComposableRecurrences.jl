# PACKAGE-OWNED: test tags. An item in `test/unit` or `test/usecases` that
# uses `Threaded`, `EXECUTOR` or `Threads.` carries the `:threads` tag, so
# the Threads workflow runs it with four threads on the current release,
# where it runs only the tagged items (`threads_only`). Setting `EXECUTOR`
# to a `Device` runs on an array backend, not on threads, so it does not
# count.

@testitem "Test tags: items that use threads carry the threads tag" tags = [:quality] begin
    # The names of the items in `text` whose body uses threading and whose
    # header, up to its `begin`, does not name `:threads`.
    function untagged_threading(text)
        names = String[]
        chunks = split(text, r"^(?=@test(item|snippet|module) )"m)
        for chunk in chunks
            m = match(r"^@testitem \"([^\"]+)\"", chunk)
            m === nothing && continue
            # A header must end its line with `begin`; one that does not
            # is reported, so the item is not skipped unchecked.
            stop = findfirst(r"\bbegin\s*$"m, chunk)
            stop === nothing && (push!(names, m.captures[1] * " (no begin)"); continue)
            header = chunk[1:last(stop)]
            # Code only: comments may name the executors without using them,
            # and setting `EXECUTOR` to a `Device` does not use threads.
            body = replace(chunk[(last(stop) + 1):end], r"#[^\n]*" => "")
            body = replace(body, r"\bEXECUTOR\s*=>\s*(\w+\.)*Device\(" => "")
            uses = occursin(r"\bThreaded\b|\bEXECUTOR\b|\bThreads\.", body)
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
        # Threaded() is not used here.
        NonThreaded = 1
    end
    @testitem "device" begin
        with(CR.EXECUTOR => CR.Device(backend)) do
            run()
        end
    end
    @testitem "device then threads" begin
        with(CR.EXECUTOR => CR.Device(backend)) do
            run()
        end
        with(CR.EXECUTOR => CR.Threaded()) do
            run()
        end
    end
    """
    @test untagged_threading(sample) == ["untagged", "device then threads"]
    untagged = String[]
    for dir in ("unit", "usecases")
        for (root, _, files) in walkdir(joinpath(@__DIR__, "..", dir))
            for file in files
                endswith(file, ".jl") || continue
                append!(untagged, untagged_threading(read(joinpath(root, file), String)))
            end
        end
    end
    @test isempty(untagged)
end
