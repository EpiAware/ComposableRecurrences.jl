# The forward pass on an NVIDIA GPU: every case of the JLArrays tests in
# `test/unit/gpu_arrays.jl`, run on CuArrays. JLArrays run kernels as Julia
# code on the host, so they cannot catch code a GPU compiler refuses, such
# as an error message built inside a kernel, or a host read of a device
# array. Not part of `Pkg.test`, and needs a CUDA GPU. From the repository
# root:
#
#   julia --project=test/cuda -e 'using Pkg; Pkg.instantiate()'
#   julia --project=test/cuda --startup-file=no test/cuda/runtests.jl
#
# Each case runs with the default executor, an explicit Device executor
# and dual numbers, and is checked against the same call on the host.
using CUDA, ForwardDiff, Test
using ComposableRecurrences: ComposableRecurrences as CR
using Base.ScopedValues: with

CUDA.functional() || error("no functional CUDA GPU")
CUDA.allowscalar(false)

# The cases module of the JLArrays tests, with CUDA's sparse matrix.
const GPUCases = let
    src = read(joinpath(@__DIR__, "..", "unit", "gpu_arrays.jl"), String)
    m = match(r"@testmodule GPUCases begin\n(.*?)\nend\n"s, src)
    m === nothing && error("no GPUCases module in test/unit/gpu_arrays.jl")
    body = replace(
        m[1],
        "using JLArrays: JLSparseMatrixCSR" =>
            "using CUDA.CUSPARSE: CuSparseMatrixCSR",
        "JLSparseMatrixCSR(" => "CuSparseMatrixCSR("
    )
    mod = Module(:GPUCases)
    Core.eval(mod, Meta.parseall("begin\n" * body * "\nend"))
    mod
end

dual(x) = CuArray(ForwardDiff.Dual{Nothing}.(x, 1.0))
const RUNS = (
    "default executor" => f -> f(CuArray),
    "explicit Device executor" => f -> with(
        () -> f(CuArray), CR.EXECUTOR => CR.Device(CUDABackend())
    ),
    "dual numbers" => f -> f(dual),
)

@testset "CUDA forward pass" begin
    for (run, call) in RUNS
        @testset "$run" begin
            for (name, f) in GPUCases.CASES
                @testset "$name" begin
                    y = call(f)
                    @test y isa CuArray
                    v = run == "dual numbers" ?
                        ForwardDiff.value.(Array(y)) : Array(y)
                    @test v ≈ f(identity)
                end
            end
        end
    end
    @testset "a run resumed from a device state" begin
        y1, state, y2 = GPUCases.resumed(CuArray)
        c1, cstate, c2 = GPUCases.resumed(identity)
        @test state.history isa CuArray
        @test Array(y1) ≈ c1
        @test Array(y2) ≈ c2
        @test Array(state.history) ≈ cstate.history
    end
end
