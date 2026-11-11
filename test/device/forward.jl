# The forward pass on a device backend: every case of the JLArrays tests in
# `test/unit/gpu_arrays.jl`, run on real device arrays. JLArrays run kernels
# as Julia code on the host, so they cannot catch code a device compiler
# refuses, such as an error message built inside a kernel, or a host read
# of a device array. Included by `test/cuda/runtests.jl` and
# `test/opencl/runtests.jl`; not part of `Pkg.test`.
#
# Each case runs with the default executor, an explicit Device executor and
# dual numbers, and is checked against the same call on the host.
using ForwardDiff, Test
using ComposableRecurrences: ComposableRecurrences as CR
using Base.ScopedValues: with

# The cases module of the JLArrays tests, with each `old => new` of
# `replacements` applied to its source first.
function gpu_cases(replacements::Pair...)
    path = joinpath(@__DIR__, "..", "unit", "gpu_arrays.jl")
    m = match(r"@testmodule GPUCases begin\n(.*?)\nend\n"s, read(path, String))
    m === nothing && error("no GPUCases module in test/unit/gpu_arrays.jl")
    mod = Module(:GPUCases)
    body = replace(m[1], replacements...)
    Core.eval(mod, Meta.parseall("begin\n" * body * "\nend"))
    return mod
end

# Runs every case of `cases` on the array type `A` and the KernelAbstractions
# `backend`. `skip` maps a case name to the reason it cannot run there.
function device_forward_tests(
        title, cases, A, backend; skip = Dict{String, String}()
    )
    dual(x) = A(ForwardDiff.Dual{Nothing}.(x, 1.0))
    runs = (
        "default executor" => f -> f(A),
        "explicit Device executor" => f -> with(
            () -> f(A), CR.EXECUTOR => CR.Device(backend)
        ),
        "dual numbers" => f -> f(dual),
    )
    for (name, reason) in skip
        @info "Skipping \"$name\": $reason"
    end
    return @testset "$title" begin
        for (run, call) in runs
            @testset "$run" begin
                for (name, f) in cases.CASES
                    @testset "$name" begin
                        if haskey(skip, name)
                            @test_skip false
                            continue
                        end
                        y = call(f)
                        @test y isa A
                        v = run == "dual numbers" ?
                            ForwardDiff.value.(Array(y)) : Array(y)
                        @test v ≈ f(identity)
                    end
                end
            end
        end
        @testset "a run resumed from a device state" begin
            y1, state, y2 = cases.resumed(A)
            c1, cstate, c2 = cases.resumed(identity)
            @test state.history isa A
            @test Array(y1) ≈ c1
            @test Array(y2) ≈ c2
            @test Array(state.history) ≈ cstate.history
        end
    end
end
